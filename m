Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBAB2CB064
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgLAWnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:43:43 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5389 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgLAWnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 17:43:42 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc6c6d40000>; Tue, 01 Dec 2020 14:42:28 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Dec
 2020 22:42:20 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Tariq Toukan" <tariqt@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/15] net/mlx5e: Free drop RQ in a dedicated function
Date:   Tue, 1 Dec 2020 14:41:54 -0800
Message-ID: <20201201224208.73295-2-saeedm@nvidia.com>
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
        t=1606862548; bh=t/ISaRgk/RfYL3J+R1ONQOC+NlhvGIJJQBFByDe96D8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=a3o2BwcmkKuHZ/8wv4pakvPrvemet1qUXCC2oc7bUOkpH1iLF86a8teDGAxEMwEgD
         9Me+5Dzfi2k4dsWX7gCZ3ZVcjJvl61EIYYnyASN19JkWsUo8JU//CD4SXzRDV7FmEI
         gaPaOtBdtm361pWL+CMe2KXJ/9xOH9ogNyC5WDo3rEh28a/o12dTcvsYCY65M0LI9U
         TDm+xVh+yiikDZO6kPdaYpCqrVTAAJWAcDsO+kg49fyeozPQ1D5AJA6bPgI4XeNg45
         MxrNmfu08Ghv6fOMp5f4mnpcQ8xvqXpPT2+nllEfeBxX0gOcVriRRf/W4VJMamCT3a
         b60l1ucAl82cA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

The drop RQ has very limited objects to be freed, and differs
from regular RQs in the context that it is freed from.
Add a dedicated function for it, use it where needed, and remove
the drop_rq-specific checks in the generic function.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c  | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 527c5f12c5af..aab6b5d7de0a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -613,14 +613,11 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
=20
 static void mlx5e_free_rq(struct mlx5e_rq *rq)
 {
-	struct mlx5e_channel *c =3D rq->channel;
-	struct bpf_prog *old_prog =3D NULL;
+	struct bpf_prog *old_prog;
 	int i;
=20
-	/* drop_rq has neither channel nor xdp_prog. */
-	if (c)
-		old_prog =3D rcu_dereference_protected(rq->xdp_prog,
-						     lockdep_is_held(&c->priv->state_lock));
+	old_prog =3D rcu_dereference_protected(rq->xdp_prog,
+					     lockdep_is_held(&rq->channel->priv->state_lock));
 	if (old_prog)
 		bpf_prog_put(old_prog);
=20
@@ -3196,6 +3193,11 @@ int mlx5e_close(struct net_device *netdev)
 	return err;
 }
=20
+static void mlx5e_free_drop_rq(struct mlx5e_rq *rq)
+{
+	mlx5_wq_destroy(&rq->wq_ctrl);
+}
+
 static int mlx5e_alloc_drop_rq(struct mlx5_core_dev *mdev,
 			       struct mlx5e_rq *rq,
 			       struct mlx5e_rq_param *param)
@@ -3263,7 +3265,7 @@ int mlx5e_open_drop_rq(struct mlx5e_priv *priv,
 	return 0;
=20
 err_free_rq:
-	mlx5e_free_rq(drop_rq);
+	mlx5e_free_drop_rq(drop_rq);
=20
 err_destroy_cq:
 	mlx5e_destroy_cq(cq);
@@ -3277,7 +3279,7 @@ int mlx5e_open_drop_rq(struct mlx5e_priv *priv,
 void mlx5e_close_drop_rq(struct mlx5e_rq *drop_rq)
 {
 	mlx5e_destroy_rq(drop_rq);
-	mlx5e_free_rq(drop_rq);
+	mlx5e_free_drop_rq(drop_rq);
 	mlx5e_destroy_cq(&drop_rq->cq);
 	mlx5e_free_cq(&drop_rq->cq);
 }
--=20
2.26.2

