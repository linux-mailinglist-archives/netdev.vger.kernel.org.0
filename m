Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30B927EEF3
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731362AbgI3QUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:20:53 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:50547 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731310AbgI3QUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:20:36 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 30 Sep 2020 19:20:28 +0300
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08UGKR2L032498;
        Wed, 30 Sep 2020 19:20:28 +0300
From:   Boris Pismenny <borisp@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH net-next RFC v1 10/10] net/mlx5e: NVMEoTCP, data-path for DDP offload
Date:   Wed, 30 Sep 2020 19:20:10 +0300
Message-Id: <20200930162010.21610-11-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200930162010.21610-1-borisp@mellanox.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NVMEoTCP direct data placement constructs an SKB from each CQE, while
pointing at NVME buffers.

This enables the offload, as the NVMe-TCP layer will skip the copy when
src == dst.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |   1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |   1 +
 .../mlx5/core/en_accel/nvmeotcp_rxtx.c        | 256 ++++++++++++++++++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.h        |  25 ++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  51 +++-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  12 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   8 +
 include/linux/mlx5/device.h                   |  30 +-
 10 files changed, 379 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 9dd6b41c2486..89ffb1dae75c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -85,4 +85,4 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o
 					steering/dr_cmd.o steering/dr_fw.o \
 					steering/dr_action.o steering/fs_dr.o
 
-mlx5_core-$(CONFIG_MLX5_EN_NVMEOTCP) += en_accel/fs_tcp.o en_accel/nvmeotcp.o
+mlx5_core-$(CONFIG_MLX5_EN_NVMEOTCP) += en_accel/fs_tcp.o en_accel/nvmeotcp.o en_accel/nvmeotcp_rxtx.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a8c0fc98b394..47611401a55d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -536,6 +536,7 @@ struct mlx5e_rq;
 typedef void (*mlx5e_fp_handle_rx_cqe)(struct mlx5e_rq*, struct mlx5_cqe64*);
 typedef struct sk_buff *
 (*mlx5e_fp_skb_from_cqe_mpwrq)(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
+			       struct mlx5_cqe64 *cqe,
 			       u16 cqe_bcnt, u32 head_offset, u32 page_idx);
 typedef struct sk_buff *
 (*mlx5e_fp_skb_from_cqe)(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 8e7b877d8a12..9a6fbd1b1c34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -25,6 +25,7 @@ static struct sk_buff *mlx5e_xsk_construct_skb(struct mlx5e_rq *rq, void *data,
 
 struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 						    struct mlx5e_mpw_info *wi,
+						    struct mlx5_cqe64 *cqe,
 						    u16 cqe_bcnt,
 						    u32 head_offset,
 						    u32 page_idx)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index 7f88ccf67fdd..112c5b3ec165 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -11,6 +11,7 @@
 
 struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 						    struct mlx5e_mpw_info *wi,
+						    struct mlx5_cqe64 *cqe,
 						    u16 cqe_bcnt,
 						    u32 head_offset,
 						    u32 page_idx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
new file mode 100644
index 000000000000..93b8ab497460
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
@@ -0,0 +1,256 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2020 Mellanox Technologies.
+
+#include "en_accel/nvmeotcp_rxtx.h"
+#include "en_accel/nvmeotcp.h"
+#include <linux/mlx5/mlx5_ifc.h>
+
+#define	MLX5E_TC_FLOW_ID_MASK  0x00ffffff
+static void nvmeotcp_update_resync(struct mlx5e_nvmeotcp_queue *queue,
+				   struct mlx5e_cqe128 *cqe128)
+{
+	const struct tcp_ddp_ulp_ops *ulp_ops;
+	struct mlx5e_rq_stats *stats;
+	u32 seq;
+
+	seq = be32_to_cpu(cqe128->resync_tcp_sn);
+	ulp_ops = inet_csk(queue->sk)->icsk_ulp_ddp_ops;
+	if (ulp_ops && ulp_ops->resync_request)
+		ulp_ops->resync_request(queue->sk, seq, TCP_DDP_RESYNC_REQ);
+
+	stats = queue->priv->channels.c[queue->channel_ix]->rq.stats;
+	stats->nvmeotcp_resync++;
+}
+
+static void mlx5e_nvmeotcp_advance_sgl_iter(struct mlx5e_nvmeotcp_queue *queue)
+{
+	struct nvmeotcp_queue_entry *nqe = &queue->ccid_table[queue->ccid];
+
+	queue->ccoff += nqe->sgl[queue->ccsglidx].length;
+	queue->ccoff_inner = 0;
+	queue->ccsglidx++;
+}
+
+static inline void
+mlx5e_nvmeotcp_add_skb_frag(struct net_device *netdev, struct sk_buff *skb,
+			    struct mlx5e_nvmeotcp_queue *queue,
+			    struct nvmeotcp_queue_entry *nqe, u32 fragsz)
+{
+	dma_sync_single_for_cpu(&netdev->dev,
+				nqe->sgl[queue->ccsglidx].offset + queue->ccoff_inner,
+				fragsz, DMA_FROM_DEVICE);
+	page_ref_inc(compound_head(sg_page(&(nqe->sgl[queue->ccsglidx]))));
+	// XXX: consider reducing the truesize, as no new memory is consumed
+	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+			sg_page(&(nqe->sgl[queue->ccsglidx])),
+			nqe->sgl[queue->ccsglidx].offset + queue->ccoff_inner,
+			fragsz,
+			fragsz);
+}
+
+int mlx5_nvmeotcp_get_headlen(struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
+{
+	struct mlx5e_cqe128 *cqe128;
+
+	if (!cqe_is_nvmeotcp_zc(cqe) || cqe_is_nvmeotcp_resync(cqe))
+		return cqe_bcnt;
+
+	cqe128 = (struct mlx5e_cqe128 *)((char *)cqe - 64);
+	return be16_to_cpu(cqe128->hlen);
+}
+
+static struct sk_buff*
+mlx5_nvmeotcp_add_tail_nonlinear(struct mlx5e_nvmeotcp_queue *queue,
+				 struct sk_buff *skb, skb_frag_t *org_frags,
+				 int org_nr_frags, int frag_index)
+{
+	struct mlx5e_priv *priv = queue->priv;
+	struct mlx5e_rq_stats *stats;
+
+	while (org_nr_frags != frag_index) {
+		if (skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS) {
+			dev_kfree_skb_any(skb);
+			stats = priv->channels.c[queue->channel_ix]->rq.stats;
+			stats->nvmeotcp_drop++;
+			return NULL;
+		}
+		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+				skb_frag_page(&org_frags[frag_index]),
+				skb_frag_off(&org_frags[frag_index]),
+				skb_frag_size(&org_frags[frag_index]),
+				skb_frag_size(&org_frags[frag_index]));
+		page_ref_inc(skb_frag_page(&org_frags[frag_index]));
+		frag_index++;
+	}
+	return skb;
+}
+
+static struct sk_buff*
+mlx5_nvmeotcp_add_tail(struct mlx5e_nvmeotcp_queue *queue, struct sk_buff *skb,
+		       int offset, int len)
+{
+	struct mlx5e_priv *priv = queue->priv;
+	struct mlx5e_rq_stats *stats;
+
+	if (skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS) {
+		dev_kfree_skb_any(skb);
+		stats = priv->channels.c[queue->channel_ix]->rq.stats;
+		stats->nvmeotcp_drop++;
+		return NULL;
+	}
+	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+			virt_to_page(skb->data),
+			offset,
+			len,
+			len);
+	page_ref_inc(virt_to_page(skb->data));
+	return skb;
+}
+
+static void mlx5_nvmeotcp_trim_nonlinear(struct sk_buff *skb,
+					 skb_frag_t *org_frags,
+					 int *frag_index,
+					 int remaining)
+{
+	unsigned int frag_size;
+	int nr_frags;
+
+	/* skip @remaining bytes in frags */
+	*frag_index = 0;
+	while (remaining) {
+		frag_size = skb_frag_size(&skb_shinfo(skb)->frags[*frag_index]);
+		if (frag_size > remaining) {
+			skb_frag_off_add(&skb_shinfo(skb)->frags[*frag_index],
+					 remaining);
+			skb_frag_size_sub(&skb_shinfo(skb)->frags[*frag_index],
+					  remaining);
+			remaining = 0;
+		} else {
+			remaining -= frag_size;
+			skb_frag_unref(skb, *frag_index);
+			*frag_index += 1;
+		}
+	}
+
+	/* save original frags for the tail and unref */
+	nr_frags = skb_shinfo(skb)->nr_frags;
+	memcpy(&org_frags[*frag_index], &skb_shinfo(skb)->frags[*frag_index],
+	       (nr_frags - *frag_index) * sizeof(skb_frag_t));
+	while (--nr_frags >= *frag_index)
+		skb_frag_unref(skb, nr_frags);
+
+	/* remove frags from skb */
+	skb_shinfo(skb)->nr_frags = 0;
+	skb->len -= skb->data_len;
+	skb->truesize -= skb->data_len;
+	skb->data_len = 0;
+}
+
+struct sk_buff*
+mlx5e_nvmeotcp_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
+			     struct mlx5_cqe64 *cqe, u32 cqe_bcnt,
+			     bool linear)
+{
+	int ccoff, cclen, hlen, ccid, remaining, fragsz, to_copy = 0;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	skb_frag_t org_frags[MAX_SKB_FRAGS];
+	struct mlx5e_nvmeotcp_queue *queue;
+	struct nvmeotcp_queue_entry *nqe;
+	struct mlx5e_rq_stats *stats;
+	int org_nr_frags, frag_index;
+	struct mlx5e_cqe128 *cqe128;
+	u32 queue_id;
+
+	queue_id = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
+	queue = mlx5e_nvmeotcp_get_queue(priv->nvmeotcp, queue_id);
+	if (unlikely(!queue)) {
+		dev_kfree_skb_any(skb);
+		return NULL;
+	}
+
+	cqe128 = (struct mlx5e_cqe128 *)((char *)cqe - 64);
+	if (cqe_is_nvmeotcp_resync(cqe)) {
+		nvmeotcp_update_resync(queue, cqe128);
+		mlx5e_nvmeotcp_put_queue(queue);
+		return skb;
+	}
+
+	stats = priv->channels.c[queue->channel_ix]->rq.stats;
+
+	/* cc ddp from cqe */
+	ccid = be16_to_cpu(cqe128->ccid);
+	ccoff = be32_to_cpu(cqe128->ccoff);
+	cclen = be16_to_cpu(cqe128->cclen);
+	hlen  = be16_to_cpu(cqe128->hlen);
+
+	/* carve a hole in the skb for DDP data */
+	if (linear) {
+		skb_trim(skb, hlen);
+	} else {
+		org_nr_frags = skb_shinfo(skb)->nr_frags;
+		mlx5_nvmeotcp_trim_nonlinear(skb, org_frags, &frag_index,
+					     cclen);
+	}
+
+	nqe = &queue->ccid_table[ccid];
+
+	/* packet starts new ccid? */
+	if (queue->ccid != ccid || queue->ccid_gen != nqe->ccid_gen) {
+		queue->ccid = ccid;
+		queue->ccoff = 0;
+		queue->ccoff_inner = 0;
+		queue->ccsglidx = 0;
+		queue->ccid_gen = nqe->ccid_gen;
+	}
+
+	/* skip inside cc until the ccoff in the cqe */
+	while (queue->ccoff + queue->ccoff_inner < ccoff) {
+		remaining = nqe->sgl[queue->ccsglidx].length - queue->ccoff_inner;
+		fragsz = min_t(off_t, remaining,
+			       ccoff - (queue->ccoff + queue->ccoff_inner));
+
+		if (fragsz == remaining)
+			mlx5e_nvmeotcp_advance_sgl_iter(queue);
+		else
+			queue->ccoff_inner += fragsz;
+	}
+
+	/* adjust the skb according to the cqe cc */
+	while (to_copy < cclen) {
+		if (skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS) {
+			dev_kfree_skb_any(skb);
+			stats->nvmeotcp_drop++;
+			mlx5e_nvmeotcp_put_queue(queue);
+			return NULL;
+		}
+
+		remaining = nqe->sgl[queue->ccsglidx].length - queue->ccoff_inner;
+		fragsz = min_t(int, remaining, cclen - to_copy);
+
+		mlx5e_nvmeotcp_add_skb_frag(netdev, skb, queue, nqe, fragsz);
+		to_copy += fragsz;
+		if (fragsz == remaining)
+			mlx5e_nvmeotcp_advance_sgl_iter(queue);
+		else
+			queue->ccoff_inner += fragsz;
+	}
+
+	if (cqe_bcnt > hlen + cclen) {
+		remaining = cqe_bcnt - hlen - cclen;
+		if (linear)
+			skb = mlx5_nvmeotcp_add_tail(queue, skb,
+						     offset_in_page(skb->data) +
+								hlen + cclen,
+						     remaining);
+		else
+			skb = mlx5_nvmeotcp_add_tail_nonlinear(queue, skb,
+							       org_frags,
+							       org_nr_frags,
+							       frag_index);
+	}
+
+	stats->nvmeotcp_offload_packets++;
+	stats->nvmeotcp_offload_bytes += cclen;
+	mlx5e_nvmeotcp_put_queue(queue);
+	return skb;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h
new file mode 100644
index 000000000000..85af1650633c
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2020 Mellanox Technologies.
+
+#ifndef __MLX5E_NVMEOTCP_RXTX_H__
+#define __MLX5E_NVMEOTCP_RXTX_H__
+
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+
+#include <linux/skbuff.h>
+#include "en.h"
+
+struct sk_buff*
+mlx5e_nvmeotcp_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
+			     struct mlx5_cqe64 *cqe, u32 cqe_bcnt, bool linear);
+
+int mlx5_nvmeotcp_get_headlen(struct mlx5_cqe64 *cqe, u32 cqe_bcnt);
+#else
+int mlx5_nvmeotcp_get_headlen(struct mlx5_cqe64 *cqe, u32 cqe_bcnt) { return cqe_bcnt; }
+struct sk_buff*
+mlx5e_nvmeotcp_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
+			     struct mlx5_cqe64 *cqe, u32 cqe_bcnt, bool linear) { return skb; }
+
+#endif /* CONFIG_MLX5_EN_NVMEOTCP */
+
+#endif /* __MLX5E_NVMEOTCP_RXTX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index ac99dbb3573a..b60b4be152e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -48,6 +48,7 @@
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/tls_rxtx.h"
 #include "en_accel/nvmeotcp.h"
+#include "en_accel/nvmeotcp_rxtx.h"
 #include "lib/clock.h"
 #include "en/xdp.h"
 #include "en/xsk/rx.h"
@@ -57,9 +58,11 @@
 
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
+				struct mlx5_cqe64 *cqe,
 				u16 cqe_bcnt, u32 head_offset, u32 page_idx);
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
+				   struct mlx5_cqe64 *cqe,
 				   u16 cqe_bcnt, u32 head_offset, u32 page_idx);
 static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
@@ -1076,6 +1079,10 @@ static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 	if (unlikely(mlx5_ipsec_is_rx_flow(cqe)))
 		mlx5e_ipsec_offload_handle_rx_skb(netdev, skb, cqe);
 
+#if defined(CONFIG_TCP_DDP_CRC) && defined(CONFIG_MLX5_EN_NVMEOTCP)
+	skb->ddp_crc = cqe_is_nvmeotcp_crcvalid(cqe);
+#endif
+
 	if (lro_num_seg > 1) {
 		mlx5e_lro_update_hdr(skb, cqe, cqe_bcnt);
 		skb_shinfo(skb)->gso_size = DIV_ROUND_UP(cqe_bcnt, lro_num_seg);
@@ -1189,16 +1196,28 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	/* queue up for recycling/reuse */
 	page_ref_inc(di->page);
 
+#if defined(CONFIG_TCP_DDP) && defined(CONFIG_MLX5_EN_NVMEOTCP)
+	if (cqe_is_nvmeotcp_zc(cqe))
+		skb = mlx5e_nvmeotcp_handle_rx_skb(rq->netdev, skb, cqe,
+						   cqe_bcnt, true);
+#endif
+
 	return skb;
 }
 
+static u16 mlx5e_get_headlen_hint(struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
+{
+	return  min_t(u32, MLX5E_RX_MAX_HEAD,
+		      mlx5_nvmeotcp_get_headlen(cqe, cqe_bcnt));
+}
+
 static struct sk_buff *
 mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 			     struct mlx5e_wqe_frag_info *wi, u32 cqe_bcnt)
 {
 	struct mlx5e_rq_frag_info *frag_info = &rq->wqe.info.arr[0];
+	u16 headlen = mlx5e_get_headlen_hint(cqe, cqe_bcnt);
 	struct mlx5e_wqe_frag_info *head_wi = wi;
-	u16 headlen      = min_t(u32, MLX5E_RX_MAX_HEAD, cqe_bcnt);
 	u16 frag_headlen = headlen;
 	u16 byte_cnt     = cqe_bcnt - headlen;
 	struct sk_buff *skb;
@@ -1207,7 +1226,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	 * might spread among multiple pages.
 	 */
 	skb = napi_alloc_skb(rq->cq.napi,
-			     ALIGN(MLX5E_RX_MAX_HEAD, sizeof(long)));
+			     ALIGN(headlen, sizeof(long)));
 	if (unlikely(!skb)) {
 		rq->stats->buff_alloc_err++;
 		return NULL;
@@ -1233,6 +1252,12 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	skb->tail += headlen;
 	skb->len  += headlen;
 
+#if defined(CONFIG_TCP_DDP) && defined(CONFIG_MLX5_EN_NVMEOTCP)
+	if (cqe_is_nvmeotcp_zc(cqe))
+		skb = mlx5e_nvmeotcp_handle_rx_skb(rq->netdev, skb, cqe,
+						   cqe_bcnt, false);
+#endif
+
 	return skb;
 }
 
@@ -1386,7 +1411,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq, struct mlx5_cqe64
 	skb = INDIRECT_CALL_2(rq->mpwqe.skb_from_cqe_mpwrq,
 			      mlx5e_skb_from_cqe_mpwrq_linear,
 			      mlx5e_skb_from_cqe_mpwrq_nonlinear,
-			      rq, wi, cqe_bcnt, head_offset, page_idx);
+			      rq, wi, cqe, cqe_bcnt, head_offset, page_idx);
 	if (!skb)
 		goto mpwrq_cqe_out;
 
@@ -1417,17 +1442,18 @@ const struct mlx5e_rx_handlers mlx5e_rx_handlers_rep = {
 
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
+				   struct mlx5_cqe64 *cqe,
 				   u16 cqe_bcnt, u32 head_offset, u32 page_idx)
 {
-	u16 headlen = min_t(u16, MLX5E_RX_MAX_HEAD, cqe_bcnt);
 	struct mlx5e_dma_info *di = &wi->umr.dma_info[page_idx];
+	u16 headlen = mlx5e_get_headlen_hint(cqe, cqe_bcnt);
 	u32 frag_offset    = head_offset + headlen;
 	u32 byte_cnt       = cqe_bcnt - headlen;
 	struct mlx5e_dma_info *head_di = di;
 	struct sk_buff *skb;
 
 	skb = napi_alloc_skb(rq->cq.napi,
-			     ALIGN(MLX5E_RX_MAX_HEAD, sizeof(long)));
+			     ALIGN(headlen, sizeof(long)));
 	if (unlikely(!skb)) {
 		rq->stats->buff_alloc_err++;
 		return NULL;
@@ -1458,11 +1484,18 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 	skb->tail += headlen;
 	skb->len  += headlen;
 
+#if defined(CONFIG_TCP_DDP) && defined(CONFIG_MLX5_EN_NVMEOTCP)
+	if (cqe_is_nvmeotcp_zc(cqe))
+		skb = mlx5e_nvmeotcp_handle_rx_skb(rq->netdev, skb, cqe,
+						   cqe_bcnt, false);
+#endif
+
 	return skb;
 }
 
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
+				struct mlx5_cqe64 *cqe,
 				u16 cqe_bcnt, u32 head_offset, u32 page_idx)
 {
 	struct mlx5e_dma_info *di = &wi->umr.dma_info[page_idx];
@@ -1504,6 +1537,12 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	/* queue up for recycling/reuse */
 	page_ref_inc(di->page);
 
+#if defined(CONFIG_TCP_DDP) && defined(CONFIG_MLX5_EN_NVMEOTCP)
+	if (cqe_is_nvmeotcp_zc(cqe))
+		skb = mlx5e_nvmeotcp_handle_rx_skb(rq->netdev, skb, cqe,
+						   cqe_bcnt, true);
+#endif
+
 	return skb;
 }
 
@@ -1542,7 +1581,7 @@ static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cq
 	skb = INDIRECT_CALL_2(rq->mpwqe.skb_from_cqe_mpwrq,
 			      mlx5e_skb_from_cqe_mpwrq_linear,
 			      mlx5e_skb_from_cqe_mpwrq_nonlinear,
-			      rq, wi, cqe_bcnt, head_offset, page_idx);
+			      rq, wi, cqe, cqe_bcnt, head_offset, page_idx);
 	if (!skb)
 		goto mpwrq_cqe_out;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 25d203d64bb2..8fe28694d7cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -198,6 +198,10 @@ static const struct counter_desc sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_ddp_setup) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_ddp_setup_fail) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_ddp_teardown) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_drop) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_resync) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_offload_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_offload_bytes) },
 #endif
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_events) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_poll) },
@@ -331,6 +335,10 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 		s->rx_nvmeotcp_ddp_setup       += rq_stats->nvmeotcp_ddp_setup;
 		s->rx_nvmeotcp_ddp_setup_fail  += rq_stats->nvmeotcp_ddp_setup_fail;
 		s->rx_nvmeotcp_ddp_teardown    += rq_stats->nvmeotcp_ddp_teardown;
+		s->rx_nvmeotcp_drop            += rq_stats->nvmeotcp_drop;
+		s->rx_nvmeotcp_resync          += rq_stats->nvmeotcp_resync;
+		s->rx_nvmeotcp_offload_packets += rq_stats->nvmeotcp_offload_packets;
+		s->rx_nvmeotcp_offload_bytes   += rq_stats->nvmeotcp_offload_bytes;
 #endif
 		s->ch_events      += ch_stats->events;
 		s->ch_poll        += ch_stats->poll;
@@ -1584,6 +1592,10 @@ static const struct counter_desc rq_stats_desc[] = {
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_ddp_setup) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_ddp_setup_fail) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_ddp_teardown) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_drop) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_resync) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_offload_packets) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_offload_bytes) },
 #endif
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 5c1c0ad88ff4..be1574e61945 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -182,6 +182,10 @@ struct mlx5e_sw_stats {
 	u64 rx_nvmeotcp_ddp_setup;
 	u64 rx_nvmeotcp_ddp_setup_fail;
 	u64 rx_nvmeotcp_ddp_teardown;
+	u64 rx_nvmeotcp_drop;
+	u64 rx_nvmeotcp_resync;
+	u64 rx_nvmeotcp_offload_packets;
+	u64 rx_nvmeotcp_offload_bytes;
 #endif
 	u64 ch_events;
 	u64 ch_poll;
@@ -353,6 +357,10 @@ struct mlx5e_rq_stats {
 	u64 nvmeotcp_ddp_setup;
 	u64 nvmeotcp_ddp_setup_fail;
 	u64 nvmeotcp_ddp_teardown;
+	u64 nvmeotcp_drop;
+	u64 nvmeotcp_resync;
+	u64 nvmeotcp_offload_packets;
+	u64 nvmeotcp_offload_bytes;
 #endif
 };
 
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index afadf4cf6d7a..c1a75f727ade 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -779,7 +779,7 @@ struct mlx5_err_cqe {
 
 struct mlx5_cqe64 {
 	u8		tls_outer_l3_tunneled;
-	u8		rsvd0;
+	u8		nvmetcp;
 	__be16		wqe_id;
 	u8		lro_tcppsh_abort_dupack;
 	u8		lro_min_ttl;
@@ -812,6 +812,19 @@ struct mlx5_cqe64 {
 	u8		op_own;
 };
 
+struct mlx5e_cqe128 {
+	__be16		cclen;
+	__be16		hlen;
+	union {
+		__be32		resync_tcp_sn;
+		__be32		ccoff;
+	};
+	__be16		ccid;
+	__be16		rsvd8;
+	u8		rsvd12[52];
+	struct mlx5_cqe64 cqe64;
+};
+
 struct mlx5_mini_cqe8 {
 	union {
 		__be32 rx_hash_result;
@@ -842,6 +855,21 @@ enum {
 
 #define MLX5_MINI_CQE_ARRAY_SIZE 8
 
+static inline bool cqe_is_nvmeotcp_resync(struct mlx5_cqe64 *cqe)
+{
+	return ((cqe->nvmetcp >> 6) & 0x1);
+}
+
+static inline bool cqe_is_nvmeotcp_crcvalid(struct mlx5_cqe64 *cqe)
+{
+	return ((cqe->nvmetcp >> 5) & 0x1);
+}
+
+static inline bool cqe_is_nvmeotcp_zc(struct mlx5_cqe64 *cqe)
+{
+	return ((cqe->nvmetcp >> 4) & 0x1);
+}
+
 static inline u8 mlx5_get_cqe_format(struct mlx5_cqe64 *cqe)
 {
 	return (cqe->op_own >> 2) & 0x3;
-- 
2.24.1

