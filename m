Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E472CCDE4
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgLCEWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:22:48 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17030 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727175AbgLCEWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 23:22:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc867ca0000>; Wed, 02 Dec 2020 20:21:30 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 04:21:30 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Shay Drory" <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 12/15] net/mlx5: Arm only EQs with EQEs
Date:   Wed, 2 Dec 2020 20:21:05 -0800
Message-ID: <20201203042108.232706-13-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201203042108.232706-1-saeedm@nvidia.com>
References: <20201203042108.232706-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606969290; bh=VGQxibwb/GiiQnNeGnHjDdCYmTPa645dn4gV3BEblM8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=lKZ6g3j94w5iSPlwXGxEpmI9D2MIY4BDgMXlKJym7G4N1yj5oZhMgd1RJpROtfVnJ
         0SiWMbWlkYMf4Nmfy0TqdZlmr7LHZO3VQYKB5WfNgSl0rLf8WWhY/fYAxQ5h0BPq9w
         CoyKT3gOT2sYO2m1PzW6KOWPgn53Pc+Ai48OFe3Ly6OZvIYNw6a1GqFEm2rHSbHPYM
         2LCNA71B8oUqu45WHidMh5RHW5FgkyWPqADVzewGeJQjIKzOeBZDXjFSPdwJJGUaiD
         5AoHjCNZQgSxDNUJySY5qJCU05+jAc/hH/7mUpMXNCCXSKhjYE/qTBkD1nTD+YRPyV
         TFQ0g/EzW/ngg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Currently, when more than one EQ is sharing an IRQ, and this IRQ is
being interrupted, all the EQs sharing the IRQ will be armed. This is
done regardless of whether an EQ has EQE.
When multiple EQs are sharing an IRQ, one or more EQs can have valid
EQEs.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/eth=
ernet/mellanox/mlx5/core/eq.c
index 4ea5d6ddf56a..fc0afa03d407 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -136,7 +136,7 @@ static int mlx5_eq_comp_int(struct notifier_block *nb,
=20
 	eqe =3D next_eqe_sw(eq);
 	if (!eqe)
-		goto out;
+		return 0;
=20
 	do {
 		struct mlx5_core_cq *cq;
@@ -161,8 +161,6 @@ static int mlx5_eq_comp_int(struct notifier_block *nb,
 		++eq->cons_index;
=20
 	} while ((++num_eqes < MLX5_EQ_POLLING_BUDGET) && (eqe =3D next_eqe_sw(eq=
)));
-
-out:
 	eq_update_ci(eq, 1);
=20
 	if (cqn !=3D -1)
@@ -250,9 +248,9 @@ static int mlx5_eq_async_int(struct notifier_block *nb,
 		++eq->cons_index;
=20
 	} while ((++num_eqes < MLX5_EQ_POLLING_BUDGET) && (eqe =3D next_eqe_sw(eq=
)));
+	eq_update_ci(eq, 1);
=20
 out:
-	eq_update_ci(eq, 1);
 	mlx5_eq_async_int_unlock(eq_async, recovery, &flags);
=20
 	return unlikely(recovery) ? num_eqes : 0;
--=20
2.26.2

