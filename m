Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB452A87F9
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732341AbgKEUWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:22:22 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19775 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732328AbgKEUWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:22:21 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa45f000002>; Thu, 05 Nov 2020 12:22:24 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Nov
 2020 20:22:14 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net v2 7/7] net/mlx5e: Fix incorrect access of RCU-protected xdp_prog
Date:   Thu, 5 Nov 2020 12:21:29 -0800
Message-ID: <20201105202129.23644-8-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201105202129.23644-1-saeedm@nvidia.com>
References: <20201105202129.23644-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604607744; bh=Me4k3oBtLi1R1bUzXFhth6SnIPa/YVgeeB1Nn0ImP/A=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=hv2URyXKuTW9hQgokHO+yhEyfWFjxjlqsWVsg4rIpqVB7u/mkezgSUjQLbDl/sBga
         4FdHGb9pWJYWAYTDKOExPPAE3DbrsGRFwyFvBeuaGlbo2UFiX3AxsnYj/bs6GL60TI
         Yuadzckc1ZZapUcwBDPVNtGxaFkXi+cB0EHVSMruy/5izAajd3vEHpQyFWT3y8up5b
         NXRcnka6TcR2affSHo1zh+HqUc/YJi4H+kYeuy+hxX2ke0eVHUZ0gMfR5EoQ6JquxS
         4Md6olo24sjhA/I4RxayeVU0QBJ/cpPlVasJCC2pU0QNhPVCzwugvzS+oLv/CFMJWm
         ykvpw3Bc/eFOQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

rq->xdp_prog is RCU-protected and should be accessed only with
rcu_access_pointer for the NULL check in mlx5e_poll_rx_cq.

rq->xdp_prog may change on the fly only from one non-NULL value to
another non-NULL value, so the checks in mlx5e_xdp_handle and
mlx5e_poll_rx_cq will have the same result during one NAPI cycle,
meaning that no additional synchronization is needed.

Fixes: fe45386a2082 ("net/mlx5e: Use RCU to protect rq->xdp_prog")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index 599f5b5ebc97..6628a0197b4e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1584,7 +1584,7 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget)
 	} while ((++work_done < budget) && (cqe =3D mlx5_cqwq_get_cqe(cqwq)));
=20
 out:
-	if (rq->xdp_prog)
+	if (rcu_access_pointer(rq->xdp_prog))
 		mlx5e_xdp_rx_poll_complete(rq);
=20
 	mlx5_cqwq_update_db_record(cqwq);
--=20
2.26.2

