Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0787B43C001
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 04:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238445AbhJ0ChT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 22:37:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238437AbhJ0ChL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 22:37:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4946610F8;
        Wed, 27 Oct 2021 02:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635302085;
        bh=JpFYLfAJZrWyM2kYKidKhuhJYwvNlf0b8OpcUR/GQ18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YGfacD3prUMO5MR2zRSYjcshBSmfByd1JX2qYxMYqBUAgI1ZbPDH4YUOvjDfnyoWg
         cMyKGuxLE5/wvhNXglBoyOxwu0lWAhzmAXs01ICiU7HPwl6BZKF6KFwmeTfs5ki81S
         c1PWsaIcItbjPhiMU+zfGWvLVyS7YKyTEjxYrKyGMj2RGkf0sRSJed2sXD+NNvbA6h
         zfbOG7hPL5RCSdh2bp8JmG1N+4fuo4iDEcKPfNz3FvfXe0TZIDGiEq7OvohGZVhr/e
         5qBQ+VDXDTQNXbBI4boJ0BzJ/onQwmbi5nM9OMqAUgTi6yHIStiWB8mww5tOsPw42c
         rPgi6IOvN57wg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Khalid Manaa <khalidm@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/14] net/mlx5e: Add handle SHAMPO cqe support
Date:   Tue, 26 Oct 2021 19:33:41 -0700
Message-Id: <20211027023347.699076-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027023347.699076-1-saeed@kernel.org>
References: <20211027023347.699076-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Khalid Manaa <khalidm@nvidia.com>

This patch adds the new CQE SHAMPO fields:
- flush: indicates that we must close the current session and pass the SKB
         to the network stack.

- match: indicates that the current packet matches the oppened session,
         the packet will be merge into the current SKB.

- header_size: the size of the packet headers that written into the headers
               buffer.

- header_entry_index: the entry index in the headers buffer.

- data_offset: packets data offset in the WQE.

Also new cqe handler is added to handle SHAMPO packets:
- The new handler uses CQE SHAMPO fields to build the SKB.
  CQE's Flush and match fields are not used in this patch, packets are not
  merged in this patch.

Signed-off-by: Khalid Manaa <khalidm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 205 +++++++++++++++---
 include/linux/mlx5/device.h                   |  23 +-
 3 files changed, 194 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 8431cdd8006c..c95b6b65c4de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -943,6 +943,7 @@ struct mlx5e_priv {
 struct mlx5e_rx_handlers {
 	mlx5e_fp_handle_rx_cqe handle_rx_cqe;
 	mlx5e_fp_handle_rx_cqe handle_rx_cqe_mpwqe;
+	mlx5e_fp_handle_rx_cqe handle_rx_cqe_mpwqe_shampo;
 };
 
 extern const struct mlx5e_rx_handlers mlx5e_rx_handlers_nic;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 397a4e769076..68759c8fd31e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -62,10 +62,12 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 				   u16 cqe_bcnt, u32 head_offset, u32 page_idx);
 static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
+static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 
 const struct mlx5e_rx_handlers mlx5e_rx_handlers_nic = {
 	.handle_rx_cqe       = mlx5e_handle_rx_cqe,
 	.handle_rx_cqe_mpwqe = mlx5e_handle_rx_cqe_mpwrq,
+	.handle_rx_cqe_mpwqe_shampo = mlx5e_handle_rx_cqe_mpwrq_shampo,
 };
 
 static inline bool mlx5e_rx_hw_stamp(struct hwtstamp_config *config)
@@ -185,8 +187,9 @@ static inline u32 mlx5e_decompress_cqes_cont(struct mlx5e_rq *rq,
 			mlx5e_read_mini_arr_slot(wq, cqd, cqcc);
 
 		mlx5e_decompress_cqe_no_hash(rq, wq, cqcc);
-		INDIRECT_CALL_2(rq->handle_rx_cqe, mlx5e_handle_rx_cqe_mpwrq,
-				mlx5e_handle_rx_cqe, rq, &cqd->title);
+		INDIRECT_CALL_3(rq->handle_rx_cqe, mlx5e_handle_rx_cqe_mpwrq,
+				mlx5e_handle_rx_cqe_mpwrq_shampo, mlx5e_handle_rx_cqe,
+				rq, &cqd->title);
 	}
 	mlx5e_cqes_update_owner(wq, cqcc - wq->cc);
 	wq->cc = cqcc;
@@ -206,8 +209,9 @@ static inline u32 mlx5e_decompress_cqes_start(struct mlx5e_rq *rq,
 	mlx5e_read_title_slot(rq, wq, cc);
 	mlx5e_read_mini_arr_slot(wq, cqd, cc + 1);
 	mlx5e_decompress_cqe(rq, wq, cc);
-	INDIRECT_CALL_2(rq->handle_rx_cqe, mlx5e_handle_rx_cqe_mpwrq,
-			mlx5e_handle_rx_cqe, rq, &cqd->title);
+	INDIRECT_CALL_3(rq->handle_rx_cqe, mlx5e_handle_rx_cqe_mpwrq,
+			mlx5e_handle_rx_cqe_mpwrq_shampo, mlx5e_handle_rx_cqe,
+			rq, &cqd->title);
 	cqd->mini_arr_idx++;
 
 	return mlx5e_decompress_cqes_cont(rq, wq, 1, budget_rem) - 1;
@@ -448,13 +452,13 @@ mlx5e_add_skb_frag(struct mlx5e_rq *rq, struct sk_buff *skb,
 static inline void
 mlx5e_copy_skb_header(struct device *pdev, struct sk_buff *skb,
 		      struct mlx5e_dma_info *dma_info,
-		      int offset_from, u32 headlen)
+		      int offset_from, int dma_offset, u32 headlen)
 {
 	const void *from = page_address(dma_info->page) + offset_from;
 	/* Aligning len to sizeof(long) optimizes memcpy performance */
 	unsigned int len = ALIGN(headlen, sizeof(long));
 
-	dma_sync_single_for_cpu(pdev, dma_info->addr + offset_from, len,
+	dma_sync_single_for_cpu(pdev, dma_info->addr + dma_offset, len,
 				DMA_FROM_DEVICE);
 	skb_copy_to_linear_data(skb, from, len);
 }
@@ -820,8 +824,8 @@ static void mlx5e_lro_update_tcp_hdr(struct mlx5_cqe64 *cqe, struct tcphdr *tcp)
 
 	if (tcp_ack) {
 		tcp->ack                = 1;
-		tcp->ack_seq            = cqe->lro_ack_seq_num;
-		tcp->window             = cqe->lro_tcp_win;
+		tcp->ack_seq            = cqe->lro.ack_seq_num;
+		tcp->window             = cqe->lro.tcp_win;
 	}
 }
 
@@ -847,7 +851,7 @@ static void mlx5e_lro_update_hdr(struct sk_buff *skb, struct mlx5_cqe64 *cqe,
 		tcp = ip_p + sizeof(struct iphdr);
 		skb_shinfo(skb)->gso_type = SKB_GSO_TCPV4;
 
-		ipv4->ttl               = cqe->lro_min_ttl;
+		ipv4->ttl               = cqe->lro.min_ttl;
 		ipv4->tot_len           = cpu_to_be16(tot_len);
 		ipv4->check             = 0;
 		ipv4->check             = ip_fast_csum((unsigned char *)ipv4,
@@ -867,7 +871,7 @@ static void mlx5e_lro_update_hdr(struct sk_buff *skb, struct mlx5_cqe64 *cqe,
 		tcp = ip_p + sizeof(struct ipv6hdr);
 		skb_shinfo(skb)->gso_type = SKB_GSO_TCPV6;
 
-		ipv6->hop_limit         = cqe->lro_min_ttl;
+		ipv6->hop_limit         = cqe->lro.min_ttl;
 		ipv6->payload_len       = cpu_to_be16(payload_len);
 
 		mlx5e_lro_update_tcp_hdr(cqe, tcp);
@@ -1237,7 +1241,8 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	}
 
 	/* copy header */
-	mlx5e_copy_skb_header(rq->pdev, skb, head_wi->di, head_wi->offset, headlen);
+	mlx5e_copy_skb_header(rq->pdev, skb, head_wi->di, head_wi->offset, head_wi->offset,
+			      headlen);
 	/* skb linear part was allocated with headlen and aligned to long */
 	skb->tail += headlen;
 	skb->len  += headlen;
@@ -1433,6 +1438,30 @@ const struct mlx5e_rx_handlers mlx5e_rx_handlers_rep = {
 };
 #endif
 
+static void
+mlx5e_fill_skb_data(struct sk_buff *skb, struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
+		    u32 data_bcnt, u32 data_offset)
+{
+	net_prefetchw(skb->data);
+
+	while (data_bcnt) {
+		u32 pg_consumed_bytes = min_t(u32, PAGE_SIZE - data_offset, data_bcnt);
+		unsigned int truesize;
+
+		if (test_bit(MLX5E_RQ_STATE_SHAMPO, &rq->state))
+			truesize = pg_consumed_bytes;
+		else
+			truesize = ALIGN(pg_consumed_bytes, BIT(rq->mpwqe.log_stride_sz));
+
+		mlx5e_add_skb_frag(rq, skb, di, data_offset,
+				   pg_consumed_bytes, truesize);
+
+		data_bcnt -= pg_consumed_bytes;
+		data_offset = 0;
+		di++;
+	}
+}
+
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 				   u16 cqe_bcnt, u32 head_offset, u32 page_idx)
@@ -1458,20 +1487,9 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 		frag_offset -= PAGE_SIZE;
 	}
 
-	while (byte_cnt) {
-		u32 pg_consumed_bytes =
-			min_t(u32, PAGE_SIZE - frag_offset, byte_cnt);
-		unsigned int truesize =
-			ALIGN(pg_consumed_bytes, BIT(rq->mpwqe.log_stride_sz));
-
-		mlx5e_add_skb_frag(rq, skb, di, frag_offset,
-				   pg_consumed_bytes, truesize);
-		byte_cnt -= pg_consumed_bytes;
-		frag_offset = 0;
-		di++;
-	}
+	mlx5e_fill_skb_data(skb, rq, di, byte_cnt, frag_offset);
 	/* copy header */
-	mlx5e_copy_skb_header(rq->pdev, skb, head_di, head_offset, headlen);
+	mlx5e_copy_skb_header(rq->pdev, skb, head_di, head_offset, head_offset, headlen);
 	/* skb linear part was allocated with headlen and aligned to long */
 	skb->tail += headlen;
 	skb->len  += headlen;
@@ -1525,6 +1543,123 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	return skb;
 }
 
+static struct sk_buff *
+mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
+			  struct mlx5_cqe64 *cqe, u16 header_index)
+{
+	struct mlx5e_dma_info *head = &rq->mpwqe.shampo->info[header_index];
+	u16 head_offset = head->addr & (PAGE_SIZE - 1);
+	u16 head_size = cqe->shampo.header_size;
+	u16 rx_headroom = rq->buff.headroom;
+	struct sk_buff *skb = NULL;
+	void *hdr, *data;
+	u32 frag_size;
+
+	hdr		= page_address(head->page) + head_offset;
+	data		= hdr + rx_headroom;
+	frag_size	= MLX5_SKB_FRAG_SZ(rx_headroom + head_size);
+
+	if (likely(frag_size <= BIT(MLX5E_SHAMPO_LOG_MAX_HEADER_ENTRY_SIZE))) {
+		/* build SKB around header */
+		dma_sync_single_range_for_cpu(rq->pdev, head->addr, 0, frag_size, DMA_FROM_DEVICE);
+		prefetchw(hdr);
+		prefetch(data);
+		skb = mlx5e_build_linear_skb(rq, hdr, frag_size, rx_headroom, head_size);
+
+		if (unlikely(!skb))
+			return NULL;
+
+		/* queue up for recycling/reuse */
+		page_ref_inc(head->page);
+
+	} else {
+		/* allocate SKB and copy header for large header */
+		skb = napi_alloc_skb(rq->cq.napi,
+				     ALIGN(head_size, sizeof(long)));
+		if (unlikely(!skb)) {
+			rq->stats->buff_alloc_err++;
+			return NULL;
+		}
+
+		prefetchw(skb->data);
+		mlx5e_copy_skb_header(rq->pdev, skb, head,
+				      head_offset + rx_headroom,
+				      rx_headroom, head_size);
+		/* skb linear part was allocated with headlen and aligned to long */
+		skb->tail += head_size;
+		skb->len  += head_size;
+	}
+	return skb;
+}
+
+static void
+mlx5e_free_rx_shampo_hd_entry(struct mlx5e_rq *rq, u16 header_index)
+{
+	struct mlx5e_shampo_hd *shampo = rq->mpwqe.shampo;
+	u64 addr = shampo->info[header_index].addr;
+
+	if (((header_index + 1) & (MLX5E_SHAMPO_WQ_HEADER_PER_PAGE - 1)) == 0) {
+		shampo->info[header_index].addr = ALIGN_DOWN(addr, PAGE_SIZE);
+		mlx5e_page_release(rq, &shampo->info[header_index], true);
+	}
+	bitmap_clear(shampo->bitmap, header_index, 1);
+}
+
+static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
+{
+	u16 data_bcnt		= mpwrq_get_cqe_byte_cnt(cqe) - cqe->shampo.header_size;
+	u16 header_index	= be16_to_cpu(cqe->shampo.header_entry_index);
+	u32 wqe_offset		= be32_to_cpu(cqe->shampo.data_offset);
+	u16 cstrides		= mpwrq_get_cqe_consumed_strides(cqe);
+	u32 data_offset		= wqe_offset & (PAGE_SIZE - 1);
+	u32 cqe_bcnt		= mpwrq_get_cqe_byte_cnt(cqe);
+	u16 wqe_id		= be16_to_cpu(cqe->wqe_id);
+	u32 page_idx		= wqe_offset >> PAGE_SHIFT;
+	struct mlx5e_rx_wqe_ll *wqe;
+	struct sk_buff *skb = NULL;
+	struct mlx5e_dma_info *di;
+	struct mlx5e_mpw_info *wi;
+	struct mlx5_wq_ll *wq;
+
+	wi = &rq->mpwqe.info[wqe_id];
+	wi->consumed_strides += cstrides;
+
+	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
+		trigger_report(rq, cqe);
+		rq->stats->wqe_err++;
+		goto mpwrq_cqe_out;
+	}
+
+	if (unlikely(mpwrq_is_filler_cqe(cqe))) {
+		struct mlx5e_rq_stats *stats = rq->stats;
+
+		stats->mpwqe_filler_cqes++;
+		stats->mpwqe_filler_strides += cstrides;
+		goto mpwrq_cqe_out;
+	}
+
+	skb = mlx5e_skb_from_cqe_shampo(rq, wi, cqe, header_index);
+
+	if (unlikely(!skb))
+		goto free_hd_entry;
+
+	di = &wi->umr.dma_info[page_idx];
+	mlx5e_fill_skb_data(skb, rq, di, data_bcnt, data_offset);
+
+	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
+	napi_gro_receive(rq->cq.napi, skb);
+free_hd_entry:
+	mlx5e_free_rx_shampo_hd_entry(rq, header_index);
+mpwrq_cqe_out:
+	if (likely(wi->consumed_strides < rq->mpwqe.num_strides))
+		return;
+
+	wq  = &rq->mpwqe.wq;
+	wqe = mlx5_wq_ll_get_wqe(wq, wqe_id);
+	mlx5e_free_rx_mpwqe(rq, wi, true);
+	mlx5_wq_ll_pop(wq, cqe->wqe_id, &wqe->next.next_wqe_index);
+}
+
 static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 {
 	u16 cstrides       = mpwrq_get_cqe_consumed_strides(cqe);
@@ -1617,8 +1752,9 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget)
 
 		mlx5_cqwq_pop(cqwq);
 
-		INDIRECT_CALL_2(rq->handle_rx_cqe, mlx5e_handle_rx_cqe_mpwrq,
-				mlx5e_handle_rx_cqe, rq, cqe);
+		INDIRECT_CALL_3(rq->handle_rx_cqe, mlx5e_handle_rx_cqe_mpwrq,
+				mlx5e_handle_rx_cqe, mlx5e_handle_rx_cqe_mpwrq_shampo,
+				rq, cqe);
 	} while ((++work_done < budget) && (cqe = mlx5_cqwq_get_cqe(cqwq)));
 
 out:
@@ -1822,15 +1958,24 @@ int mlx5e_rq_set_handlers(struct mlx5e_rq *rq, struct mlx5e_params *params, bool
 		rq->post_wqes = mlx5e_post_rx_mpwqes;
 		rq->dealloc_wqe = mlx5e_dealloc_rx_mpwqe;
 
-		rq->handle_rx_cqe = priv->profile->rx_handlers->handle_rx_cqe_mpwqe;
 		if (mlx5_fpga_is_ipsec_device(mdev)) {
 			netdev_err(netdev, "MPWQE RQ with Innova IPSec offload not supported\n");
 			return -EINVAL;
 		}
-		if (!rq->handle_rx_cqe) {
-			netdev_err(netdev, "RX handler of MPWQE RQ is not set\n");
-			return -EINVAL;
+		if (params->packet_merge.type == MLX5E_PACKET_MERGE_SHAMPO) {
+			rq->handle_rx_cqe = priv->profile->rx_handlers->handle_rx_cqe_mpwqe_shampo;
+			if (!rq->handle_rx_cqe) {
+				netdev_err(netdev, "RX handler of SHAMPO MPWQE RQ is not set\n");
+				return -EINVAL;
+			}
+		} else {
+			rq->handle_rx_cqe = priv->profile->rx_handlers->handle_rx_cqe_mpwqe;
+			if (!rq->handle_rx_cqe) {
+				netdev_err(netdev, "RX handler of MPWQE RQ is not set\n");
+				return -EINVAL;
+			}
 		}
+
 		break;
 	default: /* MLX5_WQ_TYPE_CYCLIC */
 		rq->wqe.skb_from_cqe = xsk ?
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index c920e5932368..56bcf95d4ab7 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -800,10 +800,23 @@ struct mlx5_cqe64 {
 	u8		tls_outer_l3_tunneled;
 	u8		rsvd0;
 	__be16		wqe_id;
-	u8		lro_tcppsh_abort_dupack;
-	u8		lro_min_ttl;
-	__be16		lro_tcp_win;
-	__be32		lro_ack_seq_num;
+	union {
+		struct {
+			u8	tcppsh_abort_dupack;
+			u8	min_ttl;
+			__be16	tcp_win;
+			__be32	ack_seq_num;
+		} lro;
+		struct {
+			u8	reserved0:1;
+			u8	match:1;
+			u8	flush:1;
+			u8	reserved3:5;
+			u8	header_size;
+			__be16	header_entry_index;
+			__be32	data_offset;
+		} shampo;
+	};
 	__be32		rss_hash_result;
 	u8		rss_hash_type;
 	u8		ml_path;
@@ -873,7 +886,7 @@ static inline u8 get_cqe_opcode(struct mlx5_cqe64 *cqe)
 
 static inline u8 get_cqe_lro_tcppsh(struct mlx5_cqe64 *cqe)
 {
-	return (cqe->lro_tcppsh_abort_dupack >> 6) & 1;
+	return (cqe->lro.tcppsh_abort_dupack >> 6) & 1;
 }
 
 static inline u8 get_cqe_l4_hdr_type(struct mlx5_cqe64 *cqe)
-- 
2.31.1

