Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372002CB065
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgLAWno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:43:44 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15993 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbgLAWno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 17:43:44 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc6c6d50000>; Tue, 01 Dec 2020 14:42:29 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Dec
 2020 22:42:28 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Shay Drory" <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/15] net/mlx5: Arm only EQs with EQEs
Date:   Tue, 1 Dec 2020 14:42:05 -0800
Message-ID: <20201201224208.73295-13-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201201224208.73295-1-saeedm@nvidia.com>
References: <20201201224208.73295-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606862549; bh=VGQxibwb/GiiQnNeGnHjDdCYmTPa645dn4gV3BEblM8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=h4H6h/j07c3vpu6lHalgmsRJrsLY2CjDxcUc4QR/XAd8EZ/hfLg63d3AqTBjuMoz/
         qnwcUr5PNh/C0nu2jeUzWZtXvI8WIbFBC+x9pGD+FNWEUctQAKhQGakmRwrxv1wfoK
         a1eD6Wu39GtBnwkChI1Kpbhq0br2mha/htQbwNlydWhm8LyFF292vDy8Kjm713ykkz
         y9o8gwVejAddUDuGUwXONxSWWKrW3YH5NOd+KzZM8s+/IqOwsb8SaZU5n61dtjEzmi
         qhY22g4BFpsPUHKe3sHm17g96Vw+8T1mKRrIysWOZh4kjpmbc6W/dCj+/ETmmXwcap
         fzn7gw2uDWAAA==
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

