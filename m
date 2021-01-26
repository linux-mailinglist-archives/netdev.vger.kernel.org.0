Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E646305526
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhA0H7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:59:50 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2465 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S317154AbhAZX1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 18:27:00 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a4c00000>; Tue, 26 Jan 2021 15:24:48 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:24:47 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/14] net/mlx5e: Add trap entity to ETH driver
Date:   Tue, 26 Jan 2021 15:24:16 -0800
Message-ID: <20210126232419.175836-12-saeedm@nvidia.com>
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
        t=1611703488; bh=p9w242CeRLgMiVQIDwAnQsihNGd22leNKWUx/SUi4vA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=QViN8a7fEy+VmUvT4u0xaOUt1Oo+ChaKRR16mvD95PXt6M4wbHh+r7AgiCSNPS8yJ
         joKzMx4mgjsZ/NEqV6VlxpYf8LdyikC4cJp7BYqZAjRMh78h7aaPLEKC8LyQYgOuoG
         EUmLJQbmGjof2+HFe6k5bngKjh9C3tErnmLmEDa2Ff6fEpWd5wETjPP/wEtL7Tdxyb
         Z6fzPGfJ8tD07H6xzwgl4NpTz6ZEsWRCxX7JR6M2mSI5kJMPBaV0wWdHVXPEhaS4yd
         P+rXx2v27pk1yKMDMoXVtHbdx+1J2S4IxPjfXF4woy6ydn0wLZ0ftPsnqMyyRqKMki
         eRbd+FdxbaEEQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Introduce mlx5e_trap which includes a dedicated RQ and NAPI for trapped
packets. Trap-RQ processes packets that were destined to be dropped,
but for debug and visibility sake these packets are trapped and reported
to devlink.
Trap-RQ connects between the HW and the driver and is not a part of a
channel. Open mlx5e_create_rq() and mlx5_core_destroy_rq() as API and
add dedicate RQ handlers which report to devlink of trapped packets.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   7 +
 .../net/ethernet/mellanox/mlx5/core/en/trap.c | 409 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/trap.h |  35 ++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  46 ++
 include/linux/mlx5/device.h                   |   5 +
 7 files changed, 505 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/trap.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index fcfc0b114985..d44f5f6ee449 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -27,7 +27,7 @@ mlx5_core-$(CONFIG_MLX5_CORE_EN) +=3D en_main.o en_common=
.o en_fs.o en_ethtool.o \
 		en_selftest.o en/port.o en/monitor_stats.o en/health.o \
 		en/reporter_tx.o en/reporter_rx.o en/params.o en/xsk/pool.o \
 		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o en/ptp.o \
-		en/qos.o
+		en/qos.o en/trap.o
=20
 #
 # Netdev extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index dc4895a1fa9b..f439a977ad61 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -564,6 +564,7 @@ typedef bool (*mlx5e_fp_post_rx_wqes)(struct mlx5e_rq *=
rq);
 typedef void (*mlx5e_fp_dealloc_wqe)(struct mlx5e_rq*, u16);
=20
 int mlx5e_rq_set_handlers(struct mlx5e_rq *rq, struct mlx5e_params *params=
, bool xsk);
+void mlx5e_rq_set_trap_handlers(struct mlx5e_rq *rq, struct mlx5e_params *=
params);
=20
 enum mlx5e_rq_flag {
 	MLX5E_RQ_FLAG_XDP_XMIT,
@@ -805,6 +806,8 @@ struct mlx5e_htb {
 	u16 defcls;
 };
=20
+struct mlx5e_trap;
+
 struct mlx5e_priv {
 	/* priv data path fields - start */
 	/* +1 for port ptp ts */
@@ -844,8 +847,10 @@ struct mlx5e_priv {
=20
 	struct mlx5_core_dev      *mdev;
 	struct net_device         *netdev;
+	struct mlx5e_trap         *en_trap;
 	struct mlx5e_stats         stats;
 	struct mlx5e_channel_stats channel_stats[MLX5E_MAX_NUM_CHANNELS];
+	struct mlx5e_channel_stats trap_stats;
 	struct mlx5e_port_ptp_stats port_ptp_stats;
 	u16                        max_nch;
 	u8                         max_opened_tc;
@@ -961,6 +966,8 @@ int mlx5e_open_rq(struct mlx5e_channel *c, struct mlx5e=
_params *params,
 int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int wait_time);
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
 void mlx5e_close_rq(struct mlx5e_rq *rq);
+int mlx5e_create_rq(struct mlx5e_rq *rq, struct mlx5e_rq_param *param);
+void mlx5e_destroy_rq(struct mlx5e_rq *rq);
=20
 struct mlx5e_sq_param;
 int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/trap.c
new file mode 100644
index 000000000000..5507efacb9dc
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
@@ -0,0 +1,409 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies */
+
+#include <net/page_pool.h>
+#include "en/txrx.h"
+#include "en/params.h"
+#include "en/trap.h"
+
+static int mlx5e_trap_napi_poll(struct napi_struct *napi, int budget)
+{
+	struct mlx5e_trap *trap_ctx =3D container_of(napi, struct mlx5e_trap, nap=
i);
+	struct mlx5e_ch_stats *ch_stats =3D trap_ctx->stats;
+	struct mlx5e_rq *rq =3D &trap_ctx->rq;
+	bool busy =3D false;
+	int work_done =3D 0;
+
+	ch_stats->poll++;
+
+	work_done =3D mlx5e_poll_rx_cq(&rq->cq, budget);
+	busy |=3D work_done =3D=3D budget;
+	busy |=3D rq->post_wqes(rq);
+
+	if (busy)
+		return budget;
+
+	if (unlikely(!napi_complete_done(napi, work_done)))
+		return work_done;
+
+	mlx5e_cq_arm(&rq->cq);
+	return work_done;
+}
+
+static int mlx5e_alloc_trap_rq(struct mlx5e_priv *priv, struct mlx5e_rq_pa=
ram *rqp,
+			       struct mlx5e_rq_stats *stats, struct mlx5e_params *params,
+			       struct mlx5e_ch_stats *ch_stats,
+			       struct mlx5e_rq *rq)
+{
+	void *rqc_wq =3D MLX5_ADDR_OF(rqc, rqp->rqc, wq);
+	struct mlx5_core_dev *mdev =3D priv->mdev;
+	struct page_pool_params pp_params =3D {};
+	int node =3D dev_to_node(mdev->device);
+	u32 pool_size;
+	int wq_sz;
+	int err;
+	int i;
+
+	rqp->wq.db_numa_node =3D node;
+
+	rq->wq_type  =3D params->rq_wq_type;
+	rq->pdev     =3D mdev->device;
+	rq->netdev   =3D priv->netdev;
+	rq->mdev     =3D mdev;
+	rq->priv     =3D priv;
+	rq->stats    =3D stats;
+	rq->clock    =3D &mdev->clock;
+	rq->tstamp   =3D &priv->tstamp;
+	rq->hw_mtu   =3D MLX5E_SW2HW_MTU(params, params->sw_mtu);
+
+	xdp_rxq_info_unused(&rq->xdp_rxq);
+
+	rq->buff.map_dir =3D DMA_FROM_DEVICE;
+	rq->buff.headroom =3D mlx5e_get_rq_headroom(mdev, params, NULL);
+	pool_size =3D 1 << params->log_rq_mtu_frames;
+
+	err =3D mlx5_wq_cyc_create(mdev, &rqp->wq, rqc_wq, &rq->wqe.wq, &rq->wq_c=
trl);
+	if (err)
+		return err;
+
+	rq->wqe.wq.db =3D &rq->wqe.wq.db[MLX5_RCV_DBR];
+
+	wq_sz =3D mlx5_wq_cyc_get_size(&rq->wqe.wq);
+
+	rq->wqe.info =3D rqp->frags_info;
+	rq->buff.frame0_sz =3D rq->wqe.info.arr[0].frag_stride;
+	rq->wqe.frags =3D	kvzalloc_node(array_size(sizeof(*rq->wqe.frags),
+						 (wq_sz << rq->wqe.info.log_num_frags)),
+				      GFP_KERNEL, node);
+	if (!rq->wqe.frags) {
+		err =3D -ENOMEM;
+		goto err_wq_cyc_destroy;
+	}
+
+	err =3D mlx5e_init_di_list(rq, wq_sz, node);
+	if (err)
+		goto err_free_frags;
+
+	rq->mkey_be =3D cpu_to_be32(priv->mdev->mlx5e_res.mkey.key);
+
+	mlx5e_rq_set_trap_handlers(rq, params);
+
+	/* Create a page_pool and register it with rxq */
+	pp_params.order     =3D 0;
+	pp_params.flags     =3D 0; /* No-internal DMA mapping in page_pool */
+	pp_params.pool_size =3D pool_size;
+	pp_params.nid       =3D node;
+	pp_params.dev       =3D mdev->device;
+	pp_params.dma_dir   =3D rq->buff.map_dir;
+
+	/* page_pool can be used even when there is no rq->xdp_prog,
+	 * given page_pool does not handle DMA mapping there is no
+	 * required state to clear. And page_pool gracefully handle
+	 * elevated refcnt.
+	 */
+	rq->page_pool =3D page_pool_create(&pp_params);
+	if (IS_ERR(rq->page_pool)) {
+		err =3D PTR_ERR(rq->page_pool);
+		rq->page_pool =3D NULL;
+		goto err_free_di_list;
+	}
+	for (i =3D 0; i < wq_sz; i++) {
+		struct mlx5e_rx_wqe_cyc *wqe =3D
+			mlx5_wq_cyc_get_wqe(&rq->wqe.wq, i);
+		int f;
+
+		for (f =3D 0; f < rq->wqe.info.num_frags; f++) {
+			u32 frag_size =3D rq->wqe.info.arr[f].frag_size |
+				MLX5_HW_START_PADDING;
+
+			wqe->data[f].byte_count =3D cpu_to_be32(frag_size);
+			wqe->data[f].lkey =3D rq->mkey_be;
+		}
+		/* check if num_frags is not a pow of two */
+		if (rq->wqe.info.num_frags < (1 << rq->wqe.info.log_num_frags)) {
+			wqe->data[f].byte_count =3D 0;
+			wqe->data[f].lkey =3D cpu_to_be32(MLX5_INVALID_LKEY);
+			wqe->data[f].addr =3D 0;
+		}
+	}
+	return 0;
+
+err_free_di_list:
+	mlx5e_free_di_list(rq);
+err_free_frags:
+	kvfree(rq->wqe.frags);
+err_wq_cyc_destroy:
+	mlx5_wq_destroy(&rq->wq_ctrl);
+
+	return err;
+}
+
+static void mlx5e_free_trap_rq(struct mlx5e_rq *rq)
+{
+	page_pool_destroy(rq->page_pool);
+	mlx5e_free_di_list(rq);
+	kvfree(rq->wqe.frags);
+	mlx5_wq_destroy(&rq->wq_ctrl);
+}
+
+static int mlx5e_open_trap_rq(struct mlx5e_priv *priv, struct napi_struct =
*napi,
+			      struct mlx5e_rq_stats *stats, struct mlx5e_params *params,
+			      struct mlx5e_rq_param *rq_param,
+			      struct mlx5e_ch_stats *ch_stats,
+			      struct mlx5e_rq *rq)
+{
+	struct mlx5_core_dev *mdev =3D priv->mdev;
+	struct mlx5e_create_cq_param ccp =3D {};
+	struct dim_cq_moder trap_moder =3D {};
+	struct mlx5e_cq *cq =3D &rq->cq;
+	int err;
+
+	ccp.node     =3D dev_to_node(mdev->device);
+	ccp.ch_stats =3D ch_stats;
+	ccp.napi     =3D napi;
+	ccp.ix       =3D 0;
+	err =3D mlx5e_open_cq(priv, trap_moder, &rq_param->cqp, &ccp, cq);
+	if (err)
+		return err;
+
+	err =3D mlx5e_alloc_trap_rq(priv, rq_param, stats, params, ch_stats, rq);
+	if (err)
+		goto err_destroy_cq;
+
+	err =3D mlx5e_create_rq(rq, rq_param);
+	if (err)
+		goto err_free_rq;
+
+	err =3D mlx5e_modify_rq_state(rq, MLX5_RQC_STATE_RST, MLX5_RQC_STATE_RDY)=
;
+	if (err)
+		goto err_destroy_rq;
+
+	return 0;
+
+err_destroy_rq:
+	mlx5e_destroy_rq(rq);
+	mlx5e_free_rx_descs(rq);
+err_free_rq:
+	mlx5e_free_trap_rq(rq);
+err_destroy_cq:
+	mlx5e_close_cq(cq);
+
+	return err;
+}
+
+static void mlx5e_close_trap_rq(struct mlx5e_rq *rq)
+{
+	mlx5e_destroy_rq(rq);
+	mlx5e_free_rx_descs(rq);
+	mlx5e_free_trap_rq(rq);
+	mlx5e_close_cq(&rq->cq);
+}
+
+static int mlx5e_create_trap_direct_rq_tir(struct mlx5_core_dev *mdev, str=
uct mlx5e_tir *tir,
+					   u32 rqn)
+{
+	void *tirc;
+	int inlen;
+	u32 *in;
+	int err;
+
+	inlen =3D MLX5_ST_SZ_BYTES(create_tir_in);
+	in =3D kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	tirc =3D MLX5_ADDR_OF(create_tir_in, in, ctx);
+	MLX5_SET(tirc, tirc, transport_domain, mdev->mlx5e_res.td.tdn);
+	MLX5_SET(tirc, tirc, rx_hash_fn, MLX5_RX_HASH_FN_NONE);
+	MLX5_SET(tirc, tirc, disp_type, MLX5_TIRC_DISP_TYPE_DIRECT);
+	MLX5_SET(tirc, tirc, inline_rqn, rqn);
+	err =3D mlx5e_create_tir(mdev, tir, in);
+	kvfree(in);
+
+	return err;
+}
+
+static void mlx5e_destroy_trap_direct_rq_tir(struct mlx5_core_dev *mdev, s=
truct mlx5e_tir *tir)
+{
+	mlx5e_destroy_tir(mdev, tir);
+}
+
+static void mlx5e_activate_trap_rq(struct mlx5e_rq *rq)
+{
+	set_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
+}
+
+static void mlx5e_deactivate_trap_rq(struct mlx5e_rq *rq)
+{
+	clear_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
+}
+
+static void mlx5e_build_trap_params(struct mlx5e_priv *priv, struct mlx5e_=
trap *t)
+{
+	struct mlx5e_params *params =3D &t->params;
+
+	params->rq_wq_type =3D MLX5_WQ_TYPE_CYCLIC;
+	mlx5e_init_rq_type_params(priv->mdev, params);
+	params->sw_mtu =3D priv->netdev->max_mtu;
+	mlx5e_build_rq_param(priv, params, NULL, &t->rq_param);
+}
+
+static struct mlx5e_trap *mlx5e_open_trap(struct mlx5e_priv *priv)
+{
+	int cpu =3D cpumask_first(mlx5_comp_irq_get_affinity_mask(priv->mdev, 0))=
;
+	struct net_device *netdev =3D priv->netdev;
+	struct mlx5e_trap *t;
+	int err;
+
+	t =3D kvzalloc_node(sizeof(*t), GFP_KERNEL, cpu_to_node(cpu));
+	if (!t)
+		return ERR_PTR(-ENOMEM);
+
+	mlx5e_build_trap_params(priv, t);
+
+	t->priv     =3D priv;
+	t->mdev     =3D priv->mdev;
+	t->tstamp   =3D &priv->tstamp;
+	t->pdev     =3D mlx5_core_dma_dev(priv->mdev);
+	t->netdev   =3D priv->netdev;
+	t->mkey_be  =3D cpu_to_be32(priv->mdev->mlx5e_res.mkey.key);
+	t->stats    =3D &priv->trap_stats.ch;
+
+	netif_napi_add(netdev, &t->napi, mlx5e_trap_napi_poll, 64);
+
+	err =3D mlx5e_open_trap_rq(priv, &t->napi,
+				 &priv->trap_stats.rq,
+				 &t->params, &t->rq_param,
+				 &priv->trap_stats.ch,
+				 &t->rq);
+	if (unlikely(err))
+		goto err_napi_del;
+
+	err =3D mlx5e_create_trap_direct_rq_tir(t->mdev, &t->tir, t->rq.rqn);
+	if (err)
+		goto err_close_trap_rq;
+
+	return t;
+
+err_close_trap_rq:
+	mlx5e_close_trap_rq(&t->rq);
+err_napi_del:
+	netif_napi_del(&t->napi);
+	kvfree(t);
+	return ERR_PTR(err);
+}
+
+void mlx5e_close_trap(struct mlx5e_trap *trap)
+{
+	mlx5e_destroy_trap_direct_rq_tir(trap->mdev, &trap->tir);
+	mlx5e_close_trap_rq(&trap->rq);
+	netif_napi_del(&trap->napi);
+	kvfree(trap);
+}
+
+static void mlx5e_activate_trap(struct mlx5e_trap *trap)
+{
+	napi_enable(&trap->napi);
+	mlx5e_activate_trap_rq(&trap->rq);
+	napi_schedule(&trap->napi);
+}
+
+void mlx5e_deactivate_trap(struct mlx5e_priv *priv)
+{
+	struct mlx5e_trap *trap =3D priv->en_trap;
+
+	mlx5e_deactivate_trap_rq(&trap->rq);
+	napi_disable(&trap->napi);
+}
+
+static struct mlx5e_trap *mlx5e_add_trap_queue(struct mlx5e_priv *priv)
+{
+	struct mlx5e_trap *trap;
+
+	trap =3D mlx5e_open_trap(priv);
+	if (IS_ERR(trap))
+		goto out;
+
+	mlx5e_activate_trap(trap);
+out:
+	return trap;
+}
+
+static void mlx5e_del_trap_queue(struct mlx5e_priv *priv)
+{
+	mlx5e_deactivate_trap(priv);
+	mlx5e_close_trap(priv->en_trap);
+	priv->en_trap =3D NULL;
+}
+
+static int mlx5e_trap_get_tirn(struct mlx5e_trap *en_trap)
+{
+	return en_trap->tir.tirn;
+}
+
+static int mlx5e_handle_action_trap(struct mlx5e_priv *priv, int trap_id)
+{
+	bool open_queue =3D !priv->en_trap;
+	struct mlx5e_trap *trap;
+	int err;
+
+	if (open_queue) {
+		trap =3D mlx5e_add_trap_queue(priv);
+		if (IS_ERR(trap))
+			return PTR_ERR(trap);
+		priv->en_trap =3D trap;
+	}
+
+	switch (trap_id) {
+	case DEVLINK_TRAP_GENERIC_ID_INGRESS_VLAN_FILTER:
+		err =3D mlx5e_add_vlan_trap(priv, trap_id, mlx5e_trap_get_tirn(priv->en_=
trap));
+		if (err)
+			goto err_out;
+		break;
+	default:
+		netdev_warn(priv->netdev, "%s: Unknown trap id %d\n", __func__, trap_id)=
;
+		err =3D -EINVAL;
+		goto err_out;
+	}
+	return 0;
+
+err_out:
+	if (open_queue)
+		mlx5e_del_trap_queue(priv);
+	return err;
+}
+
+static int mlx5e_handle_action_drop(struct mlx5e_priv *priv, int trap_id)
+{
+	switch (trap_id) {
+	case DEVLINK_TRAP_GENERIC_ID_INGRESS_VLAN_FILTER:
+		mlx5e_remove_vlan_trap(priv);
+		break;
+	default:
+		netdev_warn(priv->netdev, "%s: Unknown trap id %d\n", __func__, trap_id)=
;
+		return -EINVAL;
+	}
+	if (priv->en_trap && !mlx5_devlink_trap_get_num_active(priv->mdev))
+		mlx5e_del_trap_queue(priv);
+
+	return 0;
+}
+
+int mlx5e_handle_trap_event(struct mlx5e_priv *priv, struct mlx5_trap_ctx =
*trap_ctx)
+{
+	int err =3D 0;
+
+	switch (trap_ctx->action) {
+	case DEVLINK_TRAP_ACTION_TRAP:
+		err =3D mlx5e_handle_action_trap(priv, trap_ctx->id);
+		break;
+	case DEVLINK_TRAP_ACTION_DROP:
+		err =3D mlx5e_handle_action_drop(priv, trap_ctx->id);
+		break;
+	default:
+		netdev_warn(priv->netdev, "%s: Unsupported action %d\n", __func__,
+			    trap_ctx->action);
+		err =3D -EINVAL;
+	}
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/trap.h
new file mode 100644
index 000000000000..cc1fa9f12c45
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020, Mellanox Technologies */
+
+#ifndef __MLX5E_TRAP_H__
+#define __MLX5E_TRAP_H__
+
+#include "../en.h"
+#include "../devlink.h"
+
+struct mlx5e_trap {
+	/* data path */
+	struct mlx5e_rq            rq;
+	struct mlx5e_tir           tir;
+	struct napi_struct         napi;
+	struct device             *pdev;
+	struct net_device         *netdev;
+	__be32                     mkey_be;
+
+	/* data path - accessed per napi poll */
+	struct mlx5e_ch_stats     *stats;
+
+	/* control */
+	struct mlx5e_priv         *priv;
+	struct mlx5_core_dev      *mdev;
+	struct hwtstamp_config    *tstamp;
+	DECLARE_BITMAP(state, MLX5E_CHANNEL_NUM_STATES);
+
+	struct mlx5e_params        params;
+	struct mlx5e_rq_param      rq_param;
+};
+
+void mlx5e_close_trap(struct mlx5e_trap *trap);
+void mlx5e_deactivate_trap(struct mlx5e_priv *priv);
+int mlx5e_handle_trap_event(struct mlx5e_priv *priv, struct mlx5_trap_ctx =
*trap_ctx);
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index bed2f1a6d730..ec5bb48cb54a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -649,8 +649,7 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
 	mlx5_wq_destroy(&rq->wq_ctrl);
 }
=20
-static int mlx5e_create_rq(struct mlx5e_rq *rq,
-			   struct mlx5e_rq_param *param)
+int mlx5e_create_rq(struct mlx5e_rq *rq, struct mlx5e_rq_param *param)
 {
 	struct mlx5_core_dev *mdev =3D rq->mdev;
=20
@@ -773,7 +772,7 @@ static int mlx5e_modify_rq_vsd(struct mlx5e_rq *rq, boo=
l vsd)
 	return err;
 }
=20
-static void mlx5e_destroy_rq(struct mlx5e_rq *rq)
+void mlx5e_destroy_rq(struct mlx5e_rq *rq)
 {
 	mlx5_core_destroy_rq(rq->mdev, rq->rqn);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index dec93d57542f..98b56f495b32 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -52,6 +52,7 @@
 #include "en/xsk/rx.h"
 #include "en/health.h"
 #include "en/params.h"
+#include "devlink.h"
=20
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info=
 *wi,
@@ -1815,3 +1816,48 @@ int mlx5e_rq_set_handlers(struct mlx5e_rq *rq, struc=
t mlx5e_params *params, bool
=20
 	return 0;
 }
+
+static void mlx5e_trap_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe6=
4 *cqe)
+{
+	struct mlx5e_priv *priv =3D netdev_priv(rq->netdev);
+	struct mlx5_wq_cyc *wq =3D &rq->wqe.wq;
+	struct mlx5e_wqe_frag_info *wi;
+	struct sk_buff *skb;
+	u32 cqe_bcnt;
+	u16 trap_id;
+	u16 ci;
+
+	trap_id  =3D get_cqe_flow_tag(cqe);
+	ci       =3D mlx5_wq_cyc_ctr2ix(wq, be16_to_cpu(cqe->wqe_counter));
+	wi       =3D get_frag(rq, ci);
+	cqe_bcnt =3D be32_to_cpu(cqe->byte_cnt);
+
+	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
+		rq->stats->wqe_err++;
+		goto free_wqe;
+	}
+
+	skb =3D mlx5e_skb_from_cqe_nonlinear(rq, cqe, wi, cqe_bcnt);
+	if (!skb)
+		goto free_wqe;
+
+	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
+	skb_push(skb, ETH_HLEN);
+
+	mlx5_devlink_trap_report(rq->mdev, trap_id, skb, &priv->dl_port);
+	dev_kfree_skb_any(skb);
+
+free_wqe:
+	mlx5e_free_rx_wqe(rq, wi, false);
+	mlx5_wq_cyc_pop(wq);
+}
+
+void mlx5e_rq_set_trap_handlers(struct mlx5e_rq *rq, struct mlx5e_params *=
params)
+{
+	rq->wqe.skb_from_cqe =3D mlx5e_rx_is_linear_skb(params, NULL) ?
+			       mlx5e_skb_from_cqe_linear :
+			       mlx5e_skb_from_cqe_nonlinear;
+	rq->post_wqes =3D mlx5e_post_rx_wqes;
+	rq->dealloc_wqe =3D mlx5e_dealloc_rx_wqe;
+	rq->handle_rx_cqe =3D mlx5e_trap_handle_rx_cqe;
+}
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 77ba54d38772..00057eae89ab 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -903,6 +903,11 @@ static inline u64 get_cqe_ts(struct mlx5_cqe64 *cqe)
 	return (u64)lo | ((u64)hi << 32);
 }
=20
+static inline u16 get_cqe_flow_tag(struct mlx5_cqe64 *cqe)
+{
+	return be32_to_cpu(cqe->sop_drop_qpn) & 0xFFF;
+}
+
 #define MLX5_MPWQE_LOG_NUM_STRIDES_BASE	(9)
 #define MLX5_MPWQE_LOG_STRIDE_SZ_BASE	(6)
=20
--=20
2.29.2

