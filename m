Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E9630517B
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238755AbhA0E2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:28:46 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8252 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388795AbhAZX0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 18:26:22 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a4bf0000>; Tue, 26 Jan 2021 15:24:47 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:24:46 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/14] net/mlx5e: Expose RX dma info helpers
Date:   Tue, 26 Jan 2021 15:24:15 -0800
Message-ID: <20210126232419.175836-11-saeedm@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126232419.175836-1-saeedm@nvidia.com>
References: <20210126232419.175836-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611703487; bh=5xjmju8tJ3JUUAdcZb0s6li7yY7fJKQAX5ZSF/XDar0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=RgAzMZAoeUvveI0IwozBISx+pGsFqArMTbgi7DKQxZyCG9B4uh1+FJW9j8OVp+FqU
         loe/+77G4cPy2w91yGdExTum0gyFXTNHvCZEhtbSWLHHyDDtdF4mqwyj6GCDUkfbq8
         rNSjda6m6vYWga8vSUL3ZoECaLJXGkeKh62GYT6nohcqgkiuUr5sSuTvSVE1v3+UYM
         rFgUYTcEwlN50QvSrZp8iXlfWgg7VvHpBsabL2LJXtaYgr9rtQkXdAPw+QcpO8Dbmo
         lJp9QZVRCeE6AGjgH6v6kHLpB9duSP+Q4WNi3vkDE2zXuW1vaZiOU4ySsSMX710S07
         NXWS/FPthMDNg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

In order to support RQs outside of channel context, change
mlx5e_init_di_list() signature to accept NUMA node instead of cpu.
In addition, expose dma info helpers as API. This API will be used for
RQ's creation in other files in downstream patches.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 10 ++++------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 26e578a973e5..dc4895a1fa9b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1072,6 +1072,8 @@ void mlx5e_destroy_q_counters(struct mlx5e_priv *priv=
);
 int mlx5e_open_drop_rq(struct mlx5e_priv *priv,
 		       struct mlx5e_rq *drop_rq);
 void mlx5e_close_drop_rq(struct mlx5e_rq *drop_rq);
+int mlx5e_init_di_list(struct mlx5e_rq *rq, int wq_sz, int node);
+void mlx5e_free_di_list(struct mlx5e_rq *rq);
=20
 int mlx5e_create_indirect_rqt(struct mlx5e_priv *priv);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index b9a175982801..bed2f1a6d730 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -343,13 +343,11 @@ static void mlx5e_init_frags_partition(struct mlx5e_r=
q *rq)
 		prev->last_in_page =3D true;
 }
=20
-static int mlx5e_init_di_list(struct mlx5e_rq *rq,
-			      int wq_sz, int cpu)
+int mlx5e_init_di_list(struct mlx5e_rq *rq, int wq_sz, int node)
 {
 	int len =3D wq_sz << rq->wqe.info.log_num_frags;
=20
-	rq->wqe.di =3D kvzalloc_node(array_size(len, sizeof(*rq->wqe.di)),
-				   GFP_KERNEL, cpu_to_node(cpu));
+	rq->wqe.di =3D kvzalloc_node(array_size(len, sizeof(*rq->wqe.di)), GFP_KE=
RNEL, node);
 	if (!rq->wqe.di)
 		return -ENOMEM;
=20
@@ -358,7 +356,7 @@ static int mlx5e_init_di_list(struct mlx5e_rq *rq,
 	return 0;
 }
=20
-static void mlx5e_free_di_list(struct mlx5e_rq *rq)
+void mlx5e_free_di_list(struct mlx5e_rq *rq)
 {
 	kvfree(rq->wqe.di);
 }
@@ -500,7 +498,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 			goto err_rq_wq_destroy;
 		}
=20
-		err =3D mlx5e_init_di_list(rq, wq_sz, c->cpu);
+		err =3D mlx5e_init_di_list(rq, wq_sz, cpu_to_node(c->cpu));
 		if (err)
 			goto err_rq_frags;
=20
--=20
2.29.2

