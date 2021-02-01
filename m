Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A361B30A4F1
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 11:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbhBAKGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 05:06:32 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60049 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233023AbhBAKGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 05:06:19 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 1 Feb 2021 12:05:14 +0200
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 111A5C0C029353;
        Mon, 1 Feb 2021 12:05:14 +0200
From:   Boris Pismenny <borisp@mellanox.com>
To:     dsahern@gmail.com, kuba@kernel.org, davem@davemloft.net,
        saeedm@nvidia.com, hch@lst.de, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com,
        smalin@marvell.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v3 net-next  19/21] net/mlx5e: NVMEoTCP, data-path for DDP+CRC offload
Date:   Mon,  1 Feb 2021 12:05:07 +0200
Message-Id: <20210201100509.27351-20-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210201100509.27351-1-borisp@mellanox.com>
References: <20210201100509.27351-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

This patch implements the data-path for direct data placement (DDP)
and CRC offloads. NVMEoTCP DDP constructs an SKB from each CQE, while
pointing at NVME destination buffers. In turn, this enables the offload,
as the NVMe-TCP layer will skip the copy when src == dst.

Additionally, this patch adds support for CRC offload.
HW will report CRC offload only if it has not encountered an error
in the received packet. We pass this indication in skb->ddp_crc
up the stack to NVMe-TCP to skip computing the CRC if all
corresponding SKBs were verified by HW.

This patch also handles context resynchronization requests made by
NIC HW. The resync request is passed to the NVMe-TCP layer
to be handled at a later point in time.

Finally, we also use the skb->ddp_crc bit to avoid skb_condense.
This is critical as every SKB that uses DDP has a hole that fits
perfectly with skb_condense's policy, but filling this hole is
counter-productive as the data there already resides in its
destination buffer.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |   1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |   1 +
 .../mlx5/core/en_accel/nvmeotcp_rxtx.c        | 248 ++++++++++++++++++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.h        |  43 +++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  41 ++-
 7 files changed, 330 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 020fe2478fd3..deff6b691619 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -98,4 +98,4 @@ mlx5_core-$(CONFIG_MLX5_SF) += sf/vhca_event.o sf/dev/dev.o sf/dev/driver.o
 #
 mlx5_core-$(CONFIG_MLX5_SF_MANAGER) += sf/cmd.o sf/hw_table.o sf/devlink.o
 
-mlx5_core-$(CONFIG_MLX5_EN_NVMEOTCP) += en_accel/fs_tcp.o en_accel/nvmeotcp.o
+mlx5_core-$(CONFIG_MLX5_EN_NVMEOTCP) += en_accel/fs_tcp.o en_accel/nvmeotcp.o en_accel/nvmeotcp_rxtx.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index f282c0f6cdab..6853ffafbf7d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -577,6 +577,7 @@ struct mlx5e_rq;
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
index 000000000000..b16fcf051665
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
@@ -0,0 +1,248 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021 Mellanox Technologies. */
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
+	u32 seq;
+
+	seq = be32_to_cpu(cqe128->resync_tcp_sn);
+	ulp_ops = inet_csk(queue->sk)->icsk_ulp_ddp_ops;
+	if (ulp_ops && ulp_ops->resync_request)
+		ulp_ops->resync_request(queue->sk, seq, TCP_DDP_RESYNC_REQ);
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
+	page_ref_inc(compound_head(sg_page(&nqe->sgl[queue->ccsglidx])));
+	// XXX: consider reducing the truesize, as no new memory is consumed
+	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+			sg_page(&nqe->sgl[queue->ccsglidx]),
+			nqe->sgl[queue->ccsglidx].offset + queue->ccoff_inner,
+			fragsz,
+			fragsz);
+}
+
+static struct sk_buff*
+mlx5_nvmeotcp_add_tail_nonlinear(struct mlx5e_nvmeotcp_queue *queue,
+				 struct sk_buff *skb, skb_frag_t *org_frags,
+				 int org_nr_frags, int frag_index)
+{
+	struct mlx5e_priv *priv = queue->priv;
+
+	while (org_nr_frags != frag_index) {
+		if (skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS) {
+			dev_kfree_skb_any(skb);
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
+
+	if (skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS) {
+		dev_kfree_skb_any(skb);
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
+	cqe128 = container_of(cqe, struct mlx5e_cqe128, cqe64);
+	if (cqe_is_nvmeotcp_resync(cqe)) {
+		nvmeotcp_update_resync(queue, cqe128);
+		mlx5e_nvmeotcp_put_queue(queue);
+		return skb;
+	}
+
+	/* If a resync occurred in the previous cqe,
+	 * the current cqe.crcvalid bit may not be valid,
+	 * so we will treat it as 0
+	 */
+	if (unlikely(queue->after_resync_cqe)) {
+		skb->ddp_crc = 0;
+		queue->after_resync_cqe = 0;
+	} else {
+		if (queue->crc_rx)
+			skb->ddp_crc = cqe_is_nvmeotcp_crcvalid(cqe);
+		else
+			skb->ddp_crc = cqe_is_nvmeotcp_zc(cqe);
+	}
+
+	if (!cqe_is_nvmeotcp_zc(cqe)) {
+		mlx5e_nvmeotcp_put_queue(queue);
+		return skb;
+	}
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
+	mlx5e_nvmeotcp_put_queue(queue);
+	return skb;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h
new file mode 100644
index 000000000000..65456b46c33f
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021 Mellanox Technologies. */
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
+static inline int mlx5_nvmeotcp_get_headlen(struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
+{
+	struct mlx5e_cqe128 *cqe128;
+
+	if (!cqe_is_nvmeotcp_zc(cqe) || cqe_is_nvmeotcp_resync(cqe))
+		return cqe_bcnt;
+
+	cqe128 = container_of(cqe, struct mlx5e_cqe128, cqe64);
+	return be16_to_cpu(cqe128->hlen);
+}
+
+#else
+static inline struct sk_buff*
+mlx5e_nvmeotcp_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
+			     struct mlx5_cqe64 *cqe, u32 cqe_bcnt, bool linear)
+{ return skb; }
+
+static inline int mlx5_nvmeotcp_get_headlen(struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
+{ return cqe_bcnt; }
+
+#endif /* CONFIG_MLX5_EN_NVMEOTCP */
+
+static inline u16 mlx5e_get_headlen_hint(struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
+{
+	return min_t(u32, MLX5E_RX_MAX_HEAD, mlx5_nvmeotcp_get_headlen(cqe, cqe_bcnt));
+}
+
+
+#endif /* __MLX5E_NVMEOTCP_RXTX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 7e044a211aa1..b4a3b94e894d 100644
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
@@ -1185,6 +1188,12 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	/* queue up for recycling/reuse */
 	page_ref_inc(di->page);
 
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	if (cqe_is_nvmeotcp(cqe))
+		skb = mlx5e_nvmeotcp_handle_rx_skb(rq->netdev, skb, cqe,
+						   cqe_bcnt, true);
+#endif
+
 	return skb;
 }
 
@@ -1193,8 +1202,8 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 			     struct mlx5e_wqe_frag_info *wi, u32 cqe_bcnt)
 {
 	struct mlx5e_rq_frag_info *frag_info = &rq->wqe.info.arr[0];
+	u16 headlen = mlx5e_get_headlen_hint(cqe, cqe_bcnt);
 	struct mlx5e_wqe_frag_info *head_wi = wi;
-	u16 headlen      = min_t(u32, MLX5E_RX_MAX_HEAD, cqe_bcnt);
 	u16 frag_headlen = headlen;
 	u16 byte_cnt     = cqe_bcnt - headlen;
 	struct sk_buff *skb;
@@ -1203,7 +1212,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	 * might spread among multiple pages.
 	 */
 	skb = napi_alloc_skb(rq->cq.napi,
-			     ALIGN(MLX5E_RX_MAX_HEAD, sizeof(long)));
+			     ALIGN(headlen, sizeof(long)));
 	if (unlikely(!skb)) {
 		rq->stats->buff_alloc_err++;
 		return NULL;
@@ -1229,6 +1238,12 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	skb->tail += headlen;
 	skb->len  += headlen;
 
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	if (cqe_is_nvmeotcp(cqe))
+		skb = mlx5e_nvmeotcp_handle_rx_skb(rq->netdev, skb, cqe,
+						   cqe_bcnt, false);
+#endif
+
 	return skb;
 }
 
@@ -1383,7 +1398,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq, struct mlx5_cqe64
 	skb = INDIRECT_CALL_2(rq->mpwqe.skb_from_cqe_mpwrq,
 			      mlx5e_skb_from_cqe_mpwrq_linear,
 			      mlx5e_skb_from_cqe_mpwrq_nonlinear,
-			      rq, wi, cqe_bcnt, head_offset, page_idx);
+			      rq, wi, cqe, cqe_bcnt, head_offset, page_idx);
 	if (!skb)
 		goto mpwrq_cqe_out;
 
@@ -1414,17 +1429,18 @@ const struct mlx5e_rx_handlers mlx5e_rx_handlers_rep = {
 
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
@@ -1455,11 +1471,18 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 	skb->tail += headlen;
 	skb->len  += headlen;
 
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	if (cqe_is_nvmeotcp(cqe))
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
@@ -1501,6 +1524,12 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	/* queue up for recycling/reuse */
 	page_ref_inc(di->page);
 
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	if (cqe_is_nvmeotcp(cqe))
+		skb = mlx5e_nvmeotcp_handle_rx_skb(rq->netdev, skb, cqe,
+						   cqe_bcnt, true);
+#endif
+
 	return skb;
 }
 
@@ -1539,7 +1568,7 @@ static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cq
 	skb = INDIRECT_CALL_2(rq->mpwqe.skb_from_cqe_mpwrq,
 			      mlx5e_skb_from_cqe_mpwrq_linear,
 			      mlx5e_skb_from_cqe_mpwrq_nonlinear,
-			      rq, wi, cqe_bcnt, head_offset, page_idx);
+			      rq, wi, cqe, cqe_bcnt, head_offset, page_idx);
 	if (!skb)
 		goto mpwrq_cqe_out;
 
-- 
2.24.1

