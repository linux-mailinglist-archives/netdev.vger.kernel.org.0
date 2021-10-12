Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD1442A20B
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 12:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbhJLK3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 06:29:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235994AbhJLK25 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 06:28:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0342F610E8;
        Tue, 12 Oct 2021 10:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634034416;
        bh=vVnbOqI+Czb6aD+FbRs5Ck/TEGPkIZiTx72d5stTmtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+GRU3XVtwMHNM6G2VqnkOkTB2SyZ0eruBrUs8bR+SCtAbG8FZoh1Y2ylsR3OsDX3
         yTD5IkUocJ7I7nuAaREdlFLVy8akVXpXxduODxpc5yn59siEYBKSFvGu2k9akkeFCt
         /mm7StQmjCr+9EBnZglaL9per3RieiABzy3gOoWci2BpqpALhrCvlRBrt0ZSYRCoG3
         2DL/rDBG6cgkENutGE0sfMsmQUvaD++NEwvTVBK9I8kK7LPr/unCBkIlRYz/ofEsnb
         16hY5uJy67rDhVoNo6ncZhYiZEk83hUJyaaaZmG98fbWQYwmW5yaq3HlufWUpSuqWt
         3yZyyPZXT2BQg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH mlx5-next 5/7] RDMA/mlx5: Replace struct mlx5_core_mkey by u32 key
Date:   Tue, 12 Oct 2021 13:26:33 +0300
Message-Id: <29f7323cc73d489e61ce44bdc5c8fc946fb6eb53.1634033956.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634033956.git.leonro@nvidia.com>
References: <cover.1634033956.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

In mlx5_core and vdpa there is no use of mlx5_core_mkey members except
for the key itself.

As preparation for moving mlx5_core_mkey to mlx5_ib, the occurrences of
struct mlx5_core_mkey in all modules except for mlx5_ib are replaced by
a u32 key.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mr.c               | 21 ++++++++++++------
 drivers/infiniband/hw/mlx5/odp.c              |  2 +-
 .../mellanox/mlx5/core/diag/fw_tracer.c       |  6 ++---
 .../mellanox/mlx5/core/diag/fw_tracer.h       |  2 +-
 .../mellanox/mlx5/core/diag/rsc_dump.c        | 10 ++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/trap.c |  2 +-
 .../ethernet/mellanox/mlx5/core/en_common.c   |  6 ++---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 13 +++++------
 .../ethernet/mellanox/mlx5/core/fpga/conn.c   | 10 ++++-----
 .../ethernet/mellanox/mlx5/core/fpga/core.h   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c  | 22 +++++++++----------
 .../mellanox/mlx5/core/steering/dr_icm_pool.c | 10 ++++-----
 .../mellanox/mlx5/core/steering/dr_send.c     | 11 +++++-----
 .../mellanox/mlx5/core/steering/dr_types.h    |  2 +-
 drivers/vdpa/mlx5/core/mlx5_vdpa.h            |  8 +++----
 drivers/vdpa/mlx5/core/mr.c                   |  8 +++----
 drivers/vdpa/mlx5/core/resources.c            |  8 +++----
 drivers/vdpa/mlx5/net/mlx5_vnet.c             |  2 +-
 include/linux/mlx5/driver.h                   | 14 +++++-------
 21 files changed, 82 insertions(+), 81 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 1450c2f0da00..2260b0298965 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -105,8 +105,14 @@ static int
 mlx5_ib_create_mkey(struct mlx5_ib_dev *dev, struct mlx5_core_mkey *mkey,
 		    u32 *in, int inlen)
 {
+	int ret;
+
 	assign_mkey_variant(dev, mkey, in);
-	return mlx5_core_create_mkey(dev->mdev, mkey, in, inlen);
+	ret = mlx5_core_create_mkey(dev->mdev, &mkey->key, in, inlen);
+	if (!ret)
+		init_waitqueue_head(&mkey->wait);
+
+	return ret;
 }
 
 static int
@@ -134,7 +140,7 @@ static int destroy_mkey(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 {
 	WARN_ON(xa_load(&dev->odp_mkeys, mlx5_base_mkey(mr->mmkey.key)));
 
-	return mlx5_core_destroy_mkey(dev->mdev, &mr->mmkey);
+	return mlx5_core_destroy_mkey(dev->mdev, mr->mmkey.key);
 }
 
 static void create_mkey_callback(int status, struct mlx5_async_work *context)
@@ -261,10 +267,11 @@ static struct mlx5_ib_mr *create_cache_mr(struct mlx5_cache_ent *ent)
 		goto free_in;
 	}
 
-	err = mlx5_core_create_mkey(ent->dev->mdev, &mr->mmkey, in, inlen);
+	err = mlx5_core_create_mkey(ent->dev->mdev, &mr->mmkey.key, in, inlen);
 	if (err)
 		goto free_mr;
 
+	init_waitqueue_head(&mr->mmkey.wait);
 	mr->mmkey.type = MLX5_MKEY_MR;
 	WRITE_ONCE(ent->dev->cache.last_add, jiffies);
 	spin_lock_irq(&ent->lock);
@@ -291,7 +298,7 @@ static void remove_cache_mr_locked(struct mlx5_cache_ent *ent)
 	ent->available_mrs--;
 	ent->total_mrs--;
 	spin_unlock_irq(&ent->lock);
-	mlx5_core_destroy_mkey(ent->dev->mdev, &mr->mmkey);
+	mlx5_core_destroy_mkey(ent->dev->mdev, mr->mmkey.key);
 	kfree(mr);
 	spin_lock_irq(&ent->lock);
 }
@@ -651,7 +658,7 @@ static void clean_keys(struct mlx5_ib_dev *dev, int c)
 		ent->available_mrs--;
 		ent->total_mrs--;
 		spin_unlock_irq(&ent->lock);
-		mlx5_core_destroy_mkey(dev->mdev, &mr->mmkey);
+		mlx5_core_destroy_mkey(dev->mdev, mr->mmkey.key);
 	}
 
 	list_for_each_entry_safe(mr, tmp_mr, &del_list, list) {
@@ -2350,7 +2357,7 @@ int mlx5_ib_alloc_mw(struct ib_mw *ibmw, struct ib_udata *udata)
 	return 0;
 
 free_mkey:
-	mlx5_core_destroy_mkey(dev->mdev, &mw->mmkey);
+	mlx5_core_destroy_mkey(dev->mdev, mw->mmkey.key);
 free:
 	kfree(in);
 	return err;
@@ -2369,7 +2376,7 @@ int mlx5_ib_dealloc_mw(struct ib_mw *mw)
 		 */
 		mlx5r_deref_wait_odp_mkey(&mmw->mmkey);
 
-	return mlx5_core_destroy_mkey(dev->mdev, &mmw->mmkey);
+	return mlx5_core_destroy_mkey(dev->mdev, mmw->mmkey.key);
 }
 
 int mlx5_ib_check_mr_status(struct ib_mr *ibmr, u32 check_mask,
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 3b24cfc96d36..8ffd3ea8db7c 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -909,7 +909,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 		pklm = (struct mlx5_klm *)MLX5_ADDR_OF(query_mkey_out, out,
 						       bsf0_klm0_pas_mtt0_1);
 
-		ret = mlx5_core_query_mkey(dev->mdev, mmkey, out, outlen);
+		ret = mlx5_core_query_mkey(dev->mdev, mmkey->key, out, outlen);
 		if (ret)
 			goto end;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index f9cf9fb31547..02db3148240a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -745,7 +745,7 @@ static int mlx5_fw_tracer_set_mtrc_conf(struct mlx5_fw_tracer *tracer)
 	MLX5_SET(mtrc_conf, in, trace_mode, TRACE_TO_MEMORY);
 	MLX5_SET(mtrc_conf, in, log_trace_buffer_size,
 		 ilog2(TRACER_BUFFER_PAGE_NUM));
-	MLX5_SET(mtrc_conf, in, trace_mkey, tracer->buff.mkey.key);
+	MLX5_SET(mtrc_conf, in, trace_mkey, tracer->buff.mkey);
 
 	err = mlx5_core_access_reg(dev, in, sizeof(in), out, sizeof(out),
 				   MLX5_REG_MTRC_CONF, 0, 1);
@@ -1028,7 +1028,7 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tracer)
 
 err_notifier_unregister:
 	mlx5_eq_notifier_unregister(dev, &tracer->nb);
-	mlx5_core_destroy_mkey(dev, &tracer->buff.mkey);
+	mlx5_core_destroy_mkey(dev, tracer->buff.mkey);
 err_dealloc_pd:
 	mlx5_core_dealloc_pd(dev, tracer->buff.pdn);
 err_cancel_work:
@@ -1051,7 +1051,7 @@ void mlx5_fw_tracer_cleanup(struct mlx5_fw_tracer *tracer)
 	if (tracer->owner)
 		mlx5_fw_tracer_ownership_release(tracer);
 
-	mlx5_core_destroy_mkey(tracer->dev, &tracer->buff.mkey);
+	mlx5_core_destroy_mkey(tracer->dev, tracer->buff.mkey);
 	mlx5_core_dealloc_pd(tracer->dev, tracer->buff.pdn);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
index 97252a85d65e..4762b55b0b0e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
@@ -89,7 +89,7 @@ struct mlx5_fw_tracer {
 		void *log_buf;
 		dma_addr_t dma;
 		u32 size;
-		struct mlx5_core_mkey mkey;
+		u32 mkey;
 		u32 consumer_index;
 	} buff;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
index ed4fb79b4db7..538adab6878b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
@@ -30,7 +30,7 @@ static const char *const mlx5_rsc_sgmt_name[] = {
 
 struct mlx5_rsc_dump {
 	u32 pdn;
-	struct mlx5_core_mkey mkey;
+	u32 mkey;
 	u16 fw_segment_type[MLX5_SGMT_TYPE_NUM];
 };
 
@@ -89,7 +89,7 @@ static int mlx5_rsc_dump_trigger(struct mlx5_core_dev *dev, struct mlx5_rsc_dump
 		return -ENOMEM;
 
 	in_seq_num = MLX5_GET(resource_dump, cmd->cmd, seq_num);
-	MLX5_SET(resource_dump, cmd->cmd, mkey, rsc_dump->mkey.key);
+	MLX5_SET(resource_dump, cmd->cmd, mkey, rsc_dump->mkey);
 	MLX5_SET64(resource_dump, cmd->cmd, address, dma);
 
 	err = mlx5_core_access_reg(dev, cmd->cmd, sizeof(cmd->cmd), cmd->cmd,
@@ -202,7 +202,7 @@ static int mlx5_rsc_dump_menu(struct mlx5_core_dev *dev)
 }
 
 static int mlx5_rsc_dump_create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
-				     struct mlx5_core_mkey *mkey)
+				     u32 *mkey)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
 	void *mkc;
@@ -276,7 +276,7 @@ int mlx5_rsc_dump_init(struct mlx5_core_dev *dev)
 	return err;
 
 destroy_mkey:
-	mlx5_core_destroy_mkey(dev, &rsc_dump->mkey);
+	mlx5_core_destroy_mkey(dev, rsc_dump->mkey);
 free_pd:
 	mlx5_core_dealloc_pd(dev, rsc_dump->pdn);
 	return err;
@@ -287,6 +287,6 @@ void mlx5_rsc_dump_cleanup(struct mlx5_core_dev *dev)
 	if (IS_ERR_OR_NULL(dev->rsc_dump))
 		return;
 
-	mlx5_core_destroy_mkey(dev, &dev->rsc_dump->mkey);
+	mlx5_core_destroy_mkey(dev, dev->rsc_dump->mkey);
 	mlx5_core_dealloc_pd(dev, dev->rsc_dump->pdn);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 7b8c8187543a..21244a4ec4b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -664,7 +664,7 @@ struct mlx5e_rq {
 	u8                     wq_type;
 	u32                    rqn;
 	struct mlx5_core_dev  *mdev;
-	struct mlx5_core_mkey  umr_mkey;
+	u32  umr_mkey;
 	struct mlx5e_dma_info  wqe_overflow;
 
 	/* XDP read-mostly */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index ee688dec67a9..6ebca117e5ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -683,7 +683,7 @@ int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	c->tstamp   = &priv->tstamp;
 	c->pdev     = mlx5_core_dma_dev(priv->mdev);
 	c->netdev   = priv->netdev;
-	c->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.hw_objs.mkey.key);
+	c->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.hw_objs.mkey);
 	c->num_tc   = mlx5e_get_dcb_num_tc(params);
 	c->stats    = &priv->ptp_stats.ch;
 	c->lag_port = lag_port;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
index d54607a42740..a55b066746cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
@@ -137,7 +137,7 @@ static struct mlx5e_trap *mlx5e_open_trap(struct mlx5e_priv *priv)
 	t->tstamp   = &priv->tstamp;
 	t->pdev     = mlx5_core_dma_dev(priv->mdev);
 	t->netdev   = priv->netdev;
-	t->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.hw_objs.mkey.key);
+	t->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.hw_objs.mkey);
 	t->stats    = &priv->trap_stats.ch;
 
 	netif_napi_add(netdev, &t->napi, mlx5e_trap_napi_poll, 64);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index 84eb7201c142..c0f409c195bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -47,7 +47,7 @@ void mlx5e_mkey_set_relaxed_ordering(struct mlx5_core_dev *mdev, void *mkc)
 }
 
 static int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
-			     struct mlx5_core_mkey *mkey)
+			     u32 *mkey)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
 	void *mkc;
@@ -108,7 +108,7 @@ int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev)
 	return 0;
 
 err_destroy_mkey:
-	mlx5_core_destroy_mkey(mdev, &res->mkey);
+	mlx5_core_destroy_mkey(mdev, res->mkey);
 err_dealloc_transport_domain:
 	mlx5_core_dealloc_transport_domain(mdev, res->td.tdn);
 err_dealloc_pd:
@@ -121,7 +121,7 @@ void mlx5e_destroy_mdev_resources(struct mlx5_core_dev *mdev)
 	struct mlx5e_hw_objs *res = &mdev->mlx5e_res.hw_objs;
 
 	mlx5_free_bfreg(mdev, &res->bfreg);
-	mlx5_core_destroy_mkey(mdev, &res->mkey);
+	mlx5_core_destroy_mkey(mdev, res->mkey);
 	mlx5_core_dealloc_transport_domain(mdev, res->td.tdn);
 	mlx5_core_dealloc_pd(mdev, res->pdn);
 	memset(res, 0, sizeof(*res));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3fd515e7bf30..ea5b5b40e6cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -234,8 +234,7 @@ static int mlx5e_rq_alloc_mpwqe_info(struct mlx5e_rq *rq, int node)
 }
 
 static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
-				 u64 npages, u8 page_shift,
-				 struct mlx5_core_mkey *umr_mkey,
+				 u64 npages, u8 page_shift, u32 *umr_mkey,
 				 dma_addr_t filler_addr)
 {
 	struct mlx5_mtt *mtt;
@@ -455,7 +454,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 		err = mlx5e_create_rq_umr_mkey(mdev, rq);
 		if (err)
 			goto err_rq_drop_page;
-		rq->mkey_be = cpu_to_be32(rq->umr_mkey.key);
+		rq->mkey_be = cpu_to_be32(rq->umr_mkey);
 
 		err = mlx5e_rq_alloc_mpwqe_info(rq, node);
 		if (err)
@@ -487,7 +486,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 		if (err)
 			goto err_rq_frags;
 
-		rq->mkey_be = cpu_to_be32(mdev->mlx5e_res.hw_objs.mkey.key);
+		rq->mkey_be = cpu_to_be32(mdev->mlx5e_res.hw_objs.mkey);
 	}
 
 	if (xsk) {
@@ -574,7 +573,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
 		kvfree(rq->mpwqe.info);
 err_rq_mkey:
-		mlx5_core_destroy_mkey(mdev, &rq->umr_mkey);
+		mlx5_core_destroy_mkey(mdev, rq->umr_mkey);
 err_rq_drop_page:
 		mlx5e_free_mpwqe_rq_drop_page(rq);
 		break;
@@ -607,7 +606,7 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
 	switch (rq->wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
 		kvfree(rq->mpwqe.info);
-		mlx5_core_destroy_mkey(rq->mdev, &rq->umr_mkey);
+		mlx5_core_destroy_mkey(rq->mdev, rq->umr_mkey);
 		mlx5e_free_mpwqe_rq_drop_page(rq);
 		break;
 	default: /* MLX5_WQ_TYPE_CYCLIC */
@@ -1991,7 +1990,7 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	c->cpu      = cpu;
 	c->pdev     = mlx5_core_dma_dev(priv->mdev);
 	c->netdev   = priv->netdev;
-	c->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.hw_objs.mkey.key);
+	c->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.hw_objs.mkey);
 	c->num_tc   = mlx5e_get_dcb_num_tc(params);
 	c->xdp      = !!params->xdp_prog;
 	c->stats    = &priv->channel_stats[ix].ch;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index 306279b7f9e7..12abe991583a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -115,7 +115,7 @@ static int mlx5_fpga_conn_post_recv(struct mlx5_fpga_conn *conn,
 	ix = conn->qp.rq.pc & (conn->qp.rq.size - 1);
 	data = mlx5_wq_cyc_get_wqe(&conn->qp.wq.rq, ix);
 	data->byte_count = cpu_to_be32(buf->sg[0].size);
-	data->lkey = cpu_to_be32(conn->fdev->conn_res.mkey.key);
+	data->lkey = cpu_to_be32(conn->fdev->conn_res.mkey);
 	data->addr = cpu_to_be64(buf->sg[0].dma_addr);
 
 	conn->qp.rq.pc++;
@@ -155,7 +155,7 @@ static void mlx5_fpga_conn_post_send(struct mlx5_fpga_conn *conn,
 		if (!buf->sg[sgi].data)
 			break;
 		data->byte_count = cpu_to_be32(buf->sg[sgi].size);
-		data->lkey = cpu_to_be32(conn->fdev->conn_res.mkey.key);
+		data->lkey = cpu_to_be32(conn->fdev->conn_res.mkey);
 		data->addr = cpu_to_be64(buf->sg[sgi].dma_addr);
 		data++;
 		size++;
@@ -221,7 +221,7 @@ static int mlx5_fpga_conn_post_recv_buf(struct mlx5_fpga_conn *conn)
 }
 
 static int mlx5_fpga_conn_create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
-				      struct mlx5_core_mkey *mkey)
+				      u32 *mkey)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
 	void *mkc;
@@ -978,7 +978,7 @@ int mlx5_fpga_conn_device_init(struct mlx5_fpga_device *fdev)
 		mlx5_fpga_err(fdev, "create mkey failed, %d\n", err);
 		goto err_dealloc_pd;
 	}
-	mlx5_fpga_dbg(fdev, "Created mkey 0x%x\n", fdev->conn_res.mkey.key);
+	mlx5_fpga_dbg(fdev, "Created mkey 0x%x\n", fdev->conn_res.mkey);
 
 	return 0;
 
@@ -994,7 +994,7 @@ int mlx5_fpga_conn_device_init(struct mlx5_fpga_device *fdev)
 
 void mlx5_fpga_conn_device_cleanup(struct mlx5_fpga_device *fdev)
 {
-	mlx5_core_destroy_mkey(fdev->mdev, &fdev->conn_res.mkey);
+	mlx5_core_destroy_mkey(fdev->mdev, fdev->conn_res.mkey);
 	mlx5_core_dealloc_pd(fdev->mdev, fdev->conn_res.pdn);
 	mlx5_put_uars_page(fdev->mdev, fdev->conn_res.uar);
 	mlx5_nic_vport_disable_roce(fdev->mdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.h b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.h
index 52c9dee91ea4..2a984e82ae16 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.h
@@ -54,7 +54,7 @@ struct mlx5_fpga_device {
 	/* QP Connection resources */
 	struct {
 		u32 pdn;
-		struct mlx5_core_mkey mkey;
+		u32 mkey;
 		struct mlx5_uars_page *uar;
 	} conn_res;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 6e99fd166f98..f099a087400e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -35,9 +35,8 @@
 #include <linux/mlx5/driver.h>
 #include "mlx5_core.h"
 
-int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
-			  struct mlx5_core_mkey *mkey,
-			  u32 *in, int inlen)
+int mlx5_core_create_mkey(struct mlx5_core_dev *dev, u32 *mkey, u32 *in,
+			  int inlen)
 {
 	u32 lout[MLX5_ST_SZ_DW(create_mkey_out)] = {};
 	u32 mkey_index;
@@ -50,33 +49,32 @@ int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
 		return err;
 
 	mkey_index = MLX5_GET(create_mkey_out, lout, mkey_index);
-	mkey->key = (u32)mlx5_mkey_variant(mkey->key) | mlx5_idx_to_mkey(mkey_index);
-	init_waitqueue_head(&mkey->wait);
+	*mkey = MLX5_GET(create_mkey_in, in, memory_key_mkey_entry.mkey_7_0) |
+		mlx5_idx_to_mkey(mkey_index);
 
-	mlx5_core_dbg(dev, "out 0x%x, mkey 0x%x\n", mkey_index, mkey->key);
+	mlx5_core_dbg(dev, "out 0x%x, mkey 0x%x\n", mkey_index, *mkey);
 	return 0;
 }
 EXPORT_SYMBOL(mlx5_core_create_mkey);
 
-int mlx5_core_destroy_mkey(struct mlx5_core_dev *dev,
-			   struct mlx5_core_mkey *mkey)
+int mlx5_core_destroy_mkey(struct mlx5_core_dev *dev, u32 mkey)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_mkey_in)] = {};
 
 	MLX5_SET(destroy_mkey_in, in, opcode, MLX5_CMD_OP_DESTROY_MKEY);
-	MLX5_SET(destroy_mkey_in, in, mkey_index, mlx5_mkey_to_idx(mkey->key));
+	MLX5_SET(destroy_mkey_in, in, mkey_index, mlx5_mkey_to_idx(mkey));
 	return mlx5_cmd_exec_in(dev, destroy_mkey, in);
 }
 EXPORT_SYMBOL(mlx5_core_destroy_mkey);
 
-int mlx5_core_query_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mkey *mkey,
-			 u32 *out, int outlen)
+int mlx5_core_query_mkey(struct mlx5_core_dev *dev, u32 mkey, u32 *out,
+			 int outlen)
 {
 	u32 in[MLX5_ST_SZ_DW(query_mkey_in)] = {};
 
 	memset(out, 0, outlen);
 	MLX5_SET(query_mkey_in, in, opcode, MLX5_CMD_OP_QUERY_MKEY);
-	MLX5_SET(query_mkey_in, in, mkey_index, mlx5_mkey_to_idx(mkey->key));
+	MLX5_SET(query_mkey_in, in, mkey_index, mlx5_mkey_to_idx(mkey));
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
 }
 EXPORT_SYMBOL(mlx5_core_query_mkey);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index 66c24767e3b0..7f6fd9c5e371 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -24,7 +24,7 @@ struct mlx5dr_icm_dm {
 };
 
 struct mlx5dr_icm_mr {
-	struct mlx5_core_mkey mkey;
+	u32 mkey;
 	struct mlx5dr_icm_dm dm;
 	struct mlx5dr_domain *dmn;
 	size_t length;
@@ -33,7 +33,7 @@ struct mlx5dr_icm_mr {
 
 static int dr_icm_create_dm_mkey(struct mlx5_core_dev *mdev,
 				 u32 pd, u64 length, u64 start_addr, int mode,
-				 struct mlx5_core_mkey *mkey)
+				 u32 *mkey)
 {
 	u32 inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
 	u32 in[MLX5_ST_SZ_DW(create_mkey_in)] = {};
@@ -116,7 +116,7 @@ dr_icm_pool_mr_create(struct mlx5dr_icm_pool *pool)
 	return icm_mr;
 
 free_mkey:
-	mlx5_core_destroy_mkey(mdev, &icm_mr->mkey);
+	mlx5_core_destroy_mkey(mdev, icm_mr->mkey);
 free_dm:
 	mlx5_dm_sw_icm_dealloc(mdev, icm_mr->dm.type, icm_mr->dm.length, 0,
 			       icm_mr->dm.addr, icm_mr->dm.obj_id);
@@ -130,7 +130,7 @@ static void dr_icm_pool_mr_destroy(struct mlx5dr_icm_mr *icm_mr)
 	struct mlx5_core_dev *mdev = icm_mr->dmn->mdev;
 	struct mlx5dr_icm_dm *dm = &icm_mr->dm;
 
-	mlx5_core_destroy_mkey(mdev, &icm_mr->mkey);
+	mlx5_core_destroy_mkey(mdev, icm_mr->mkey);
 	mlx5_dm_sw_icm_dealloc(mdev, dm->type, dm->length, 0,
 			       dm->addr, dm->obj_id);
 	kvfree(icm_mr);
@@ -252,7 +252,7 @@ dr_icm_chunk_create(struct mlx5dr_icm_pool *pool,
 
 	offset = mlx5dr_icm_pool_dm_type_to_entry_size(pool->icm_type) * seg;
 
-	chunk->rkey = buddy_mem_pool->icm_mr->mkey.key;
+	chunk->rkey = buddy_mem_pool->icm_mr->mkey;
 	chunk->mr_addr = offset;
 	chunk->icm_addr =
 		(uintptr_t)buddy_mem_pool->icm_mr->icm_start_addr + offset;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index bfb14b4b1906..00aef47d7682 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -350,7 +350,7 @@ static void dr_fill_data_segs(struct mlx5dr_send_ring *send_ring,
 	send_info->read.length = send_info->write.length;
 	/* Read into the same write area */
 	send_info->read.addr = (uintptr_t)send_info->write.addr;
-	send_info->read.lkey = send_ring->mr->mkey.key;
+	send_info->read.lkey = send_ring->mr->mkey;
 
 	if (send_ring->pending_wqe % send_ring->signal_th == 0)
 		send_info->read.send_flags = IB_SEND_SIGNALED;
@@ -388,7 +388,7 @@ static int dr_postsend_icm_data(struct mlx5dr_domain *dmn,
 		       (void *)(uintptr_t)send_info->write.addr,
 		       send_info->write.length);
 		send_info->write.addr = (uintptr_t)send_ring->mr->dma_addr + buff_offset;
-		send_info->write.lkey = send_ring->mr->mkey.key;
+		send_info->write.lkey = send_ring->mr->mkey;
 	}
 
 	send_ring->tx_head++;
@@ -848,8 +848,7 @@ static void dr_destroy_cq(struct mlx5_core_dev *mdev, struct mlx5dr_cq *cq)
 	kfree(cq);
 }
 
-static int
-dr_create_mkey(struct mlx5_core_dev *mdev, u32 pdn, struct mlx5_core_mkey *mkey)
+static int dr_create_mkey(struct mlx5_core_dev *mdev, u32 pdn, u32 *mkey)
 {
 	u32 in[MLX5_ST_SZ_DW(create_mkey_in)] = {};
 	void *mkc;
@@ -908,7 +907,7 @@ static struct mlx5dr_mr *dr_reg_mr(struct mlx5_core_dev *mdev,
 
 static void dr_dereg_mr(struct mlx5_core_dev *mdev, struct mlx5dr_mr *mr)
 {
-	mlx5_core_destroy_mkey(mdev, &mr->mkey);
+	mlx5_core_destroy_mkey(mdev, mr->mkey);
 	dma_unmap_single(mlx5_core_dma_dev(mdev), mr->dma_addr, mr->size,
 			 DMA_BIDIRECTIONAL);
 	kfree(mr);
@@ -1039,7 +1038,7 @@ int mlx5dr_send_ring_force_drain(struct mlx5dr_domain *dmn)
 	send_info.write.lkey = 0;
 	/* Using the sync_mr in order to write/read */
 	send_info.remote_addr = (uintptr_t)send_ring->sync_mr->addr;
-	send_info.rkey = send_ring->sync_mr->mkey.key;
+	send_info.rkey = send_ring->sync_mr->mkey;
 
 	for (i = 0; i < num_of_sends_req; i++) {
 		ret = dr_postsend_icm_data(dmn, &send_info);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index b20e8aabb861..6c67185c05c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1275,7 +1275,7 @@ struct mlx5dr_cq {
 
 struct mlx5dr_mr {
 	struct mlx5_core_dev *mdev;
-	struct mlx5_core_mkey mkey;
+	u32 mkey;
 	dma_addr_t dma_addr;
 	void *addr;
 	size_t size;
diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 01a848adf590..3163b313a470 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -15,7 +15,7 @@ struct mlx5_vdpa_direct_mr {
 	u64 start;
 	u64 end;
 	u32 perm;
-	struct mlx5_core_mkey mr;
+	u32 mr;
 	struct sg_table sg_head;
 	int log_size;
 	int nsg;
@@ -25,7 +25,7 @@ struct mlx5_vdpa_direct_mr {
 };
 
 struct mlx5_vdpa_mr {
-	struct mlx5_core_mkey mkey;
+	u32 mkey;
 
 	/* list of direct MRs descendants of this indirect mr */
 	struct list_head head;
@@ -99,9 +99,9 @@ int mlx5_vdpa_alloc_transport_domain(struct mlx5_vdpa_dev *mvdev, u32 *tdn);
 void mlx5_vdpa_dealloc_transport_domain(struct mlx5_vdpa_dev *mvdev, u32 tdn);
 int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *mvdev);
 void mlx5_vdpa_free_resources(struct mlx5_vdpa_dev *mvdev);
-int mlx5_vdpa_create_mkey(struct mlx5_vdpa_dev *mvdev, struct mlx5_core_mkey *mkey, u32 *in,
+int mlx5_vdpa_create_mkey(struct mlx5_vdpa_dev *mvdev, u32 *mkey, u32 *in,
 			  int inlen);
-int mlx5_vdpa_destroy_mkey(struct mlx5_vdpa_dev *mvdev, struct mlx5_core_mkey *mkey);
+int mlx5_vdpa_destroy_mkey(struct mlx5_vdpa_dev *mvdev, u32 mkey);
 int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 			     bool *change_map);
 int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb);
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index ff010c6d0cd3..a639b9208d41 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -88,7 +88,7 @@ static int create_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct
 
 static void destroy_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr *mr)
 {
-	mlx5_vdpa_destroy_mkey(mvdev, &mr->mr);
+	mlx5_vdpa_destroy_mkey(mvdev, mr->mr);
 }
 
 static u64 map_start(struct vhost_iotlb_map *map, struct mlx5_vdpa_direct_mr *mr)
@@ -162,7 +162,7 @@ static void fill_indir(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mkey, v
 		}
 
 		if (preve == dmr->start) {
-			klm->key = cpu_to_be32(dmr->mr.key);
+			klm->key = cpu_to_be32(dmr->mr);
 			klm->bcount = cpu_to_be32(klm_bcount(dmr->end - dmr->start));
 			preve = dmr->end;
 		} else {
@@ -217,7 +217,7 @@ static int create_indirect_key(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr
 
 static void destroy_indirect_key(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mkey)
 {
-	mlx5_vdpa_destroy_mkey(mvdev, &mkey->mkey);
+	mlx5_vdpa_destroy_mkey(mvdev, mkey->mkey);
 }
 
 static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr *mr,
@@ -449,7 +449,7 @@ static int create_dma_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
 
 static void destroy_dma_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_mr *mr)
 {
-	mlx5_vdpa_destroy_mkey(mvdev, &mr->mkey);
+	mlx5_vdpa_destroy_mkey(mvdev, mr->mkey);
 }
 
 static int dup_iotlb(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *src)
diff --git a/drivers/vdpa/mlx5/core/resources.c b/drivers/vdpa/mlx5/core/resources.c
index 72b2d80e75b0..9800f9bec225 100644
--- a/drivers/vdpa/mlx5/core/resources.c
+++ b/drivers/vdpa/mlx5/core/resources.c
@@ -198,7 +198,7 @@ void mlx5_vdpa_dealloc_transport_domain(struct mlx5_vdpa_dev *mvdev, u32 tdn)
 	mlx5_cmd_exec_in(mvdev->mdev, dealloc_transport_domain, in);
 }
 
-int mlx5_vdpa_create_mkey(struct mlx5_vdpa_dev *mvdev, struct mlx5_core_mkey *mkey, u32 *in,
+int mlx5_vdpa_create_mkey(struct mlx5_vdpa_dev *mvdev, u32 *mkey, u32 *in,
 			  int inlen)
 {
 	u32 lout[MLX5_ST_SZ_DW(create_mkey_out)] = {};
@@ -213,17 +213,17 @@ int mlx5_vdpa_create_mkey(struct mlx5_vdpa_dev *mvdev, struct mlx5_core_mkey *mk
 		return err;
 
 	mkey_index = MLX5_GET(create_mkey_out, lout, mkey_index);
-	mkey->key |= mlx5_idx_to_mkey(mkey_index);
+	*mkey |= mlx5_idx_to_mkey(mkey_index);
 	return 0;
 }
 
-int mlx5_vdpa_destroy_mkey(struct mlx5_vdpa_dev *mvdev, struct mlx5_core_mkey *mkey)
+int mlx5_vdpa_destroy_mkey(struct mlx5_vdpa_dev *mvdev, u32 mkey)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_mkey_in)] = {};
 
 	MLX5_SET(destroy_mkey_in, in, uid, mvdev->res.uid);
 	MLX5_SET(destroy_mkey_in, in, opcode, MLX5_CMD_OP_DESTROY_MKEY);
-	MLX5_SET(destroy_mkey_in, in, mkey_index, mlx5_mkey_to_idx(mkey->key));
+	MLX5_SET(destroy_mkey_in, in, mkey_index, mlx5_mkey_to_idx(mkey));
 	return mlx5_cmd_exec_in(mvdev->mdev, destroy_mkey, in);
 }
 
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index bd56de7484dc..5c7d2a953dbd 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -865,7 +865,7 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
 	MLX5_SET64(virtio_q, vq_ctx, desc_addr, mvq->desc_addr);
 	MLX5_SET64(virtio_q, vq_ctx, used_addr, mvq->device_addr);
 	MLX5_SET64(virtio_q, vq_ctx, available_addr, mvq->driver_addr);
-	MLX5_SET(virtio_q, vq_ctx, virtio_q_mkey, ndev->mvdev.mr.mkey.key);
+	MLX5_SET(virtio_q, vq_ctx, virtio_q_mkey, ndev->mvdev.mr.mkey);
 	MLX5_SET(virtio_q, vq_ctx, umem_1_id, mvq->umem1.id);
 	MLX5_SET(virtio_q, vq_ctx, umem_1_size, mvq->umem1.size);
 	MLX5_SET(virtio_q, vq_ctx, umem_2_id, mvq->umem2.id);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 31e19f06bc3a..42f653c70e8c 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -650,7 +650,7 @@ struct mlx5e_resources {
 	struct mlx5e_hw_objs {
 		u32                        pdn;
 		struct mlx5_td             td;
-		struct mlx5_core_mkey      mkey;
+		u32			   mkey;
 		struct mlx5_sq_bfreg       bfreg;
 	} hw_objs;
 	struct devlink_port dl_port;
@@ -1019,13 +1019,11 @@ struct mlx5_cmd_mailbox *mlx5_alloc_cmd_mailbox_chain(struct mlx5_core_dev *dev,
 						      gfp_t flags, int npages);
 void mlx5_free_cmd_mailbox_chain(struct mlx5_core_dev *dev,
 				 struct mlx5_cmd_mailbox *head);
-int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
-			  struct mlx5_core_mkey *mkey,
-			  u32 *in, int inlen);
-int mlx5_core_destroy_mkey(struct mlx5_core_dev *dev,
-			   struct mlx5_core_mkey *mkey);
-int mlx5_core_query_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mkey *mkey,
-			 u32 *out, int outlen);
+int mlx5_core_create_mkey(struct mlx5_core_dev *dev, u32 *mkey, u32 *in,
+			  int inlen);
+int mlx5_core_destroy_mkey(struct mlx5_core_dev *dev, u32 mkey);
+int mlx5_core_query_mkey(struct mlx5_core_dev *dev, u32 mkey, u32 *out,
+			 int outlen);
 int mlx5_core_alloc_pd(struct mlx5_core_dev *dev, u32 *pdn);
 int mlx5_core_dealloc_pd(struct mlx5_core_dev *dev, u32 pdn);
 int mlx5_pagealloc_init(struct mlx5_core_dev *dev);
-- 
2.31.1

