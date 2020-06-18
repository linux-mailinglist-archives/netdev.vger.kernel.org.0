Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E64D1FEAC0
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 07:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgFRFOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 01:14:16 -0400
Received: from mga03.intel.com ([134.134.136.65]:25338 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727017AbgFRFOD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 01:14:03 -0400
IronPort-SDR: FKMfIR4T7q5QlZgFsxj1vCXscBi72debP/tz1AFgfB3MHLVOgEinqjV/PKtU+QD+apOAcJCDhN
 eQltrMOaofLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9655"; a="142378062"
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="142378062"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 22:13:53 -0700
IronPort-SDR: yUZo0emABunMHDiCOW1eHGa9zo/PheuwYSYVY/1hvCOhvtUiYO+TVxk++2e6fCeT4umZeWOhXj
 gBhRgoDhZmQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="263495619"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jun 2020 22:13:52 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/15] iecm: Add singleq TX/RX
Date:   Wed, 17 Jun 2020 22:13:41 -0700
Message-Id: <20200618051344.516587-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
References: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Michael <alice.michael@intel.com>

Implement legacy single queue model for TX/RX flows.

Signed-off-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: Alan Brady <alan.brady@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Donald Skidmore <donald.c.skidmore@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../ethernet/intel/iecm/iecm_singleq_txrx.c   | 670 +++++++++++++++++-
 1 file changed, 652 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/iecm/iecm_singleq_txrx.c b/drivers/net/ethernet/intel/iecm/iecm_singleq_txrx.c
index a85471e72d66..acb3e56063f5 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_singleq_txrx.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_singleq_txrx.c
@@ -17,7 +17,11 @@ static __le64
 iecm_tx_singleq_build_ctob(u64 td_cmd, u64 td_offset, unsigned int size,
 			   u64 td_tag)
 {
-	/* stub */
+	return cpu_to_le64(IECM_TX_DESC_DTYPE_DATA |
+			   (td_cmd    << IECM_TXD_QW1_CMD_S) |
+			   (td_offset << IECM_TXD_QW1_OFFSET_S) |
+			   ((u64)size << IECM_TXD_QW1_TX_BUF_SZ_S) |
+			   (td_tag    << IECM_TXD_QW1_L2TAG1_S));
 }
 
 /**
@@ -31,7 +35,93 @@ static
 int iecm_tx_singleq_csum(struct iecm_tx_buf *first,
 			 struct iecm_tx_offload_params *off)
 {
-	/* stub */
+	u32 l4_len = 0, l3_len = 0, l2_len = 0;
+	struct sk_buff *skb = first->skb;
+	union {
+		struct iphdr *v4;
+		struct ipv6hdr *v6;
+		unsigned char *hdr;
+	} ip;
+	union {
+		struct tcphdr *tcp;
+		unsigned char *hdr;
+	} l4;
+	__be16 frag_off, protocol;
+	unsigned char *exthdr;
+	u32 offset, cmd = 0;
+	u8 l4_proto = 0;
+
+	if (skb->ip_summed != CHECKSUM_PARTIAL)
+		return 0;
+
+	if (skb->encapsulation)
+		return -1;
+
+	ip.hdr = skb_network_header(skb);
+	l4.hdr = skb_transport_header(skb);
+
+	/* compute outer L2 header size */
+	l2_len = ip.hdr - skb->data;
+	offset = (l2_len / 2) << IECM_TX_DESC_LEN_MACLEN_S;
+
+	/* Enable IP checksum offloads */
+	protocol = vlan_get_protocol(skb);
+	if (protocol == htons(ETH_P_IP)) {
+		l4_proto = ip.v4->protocol;
+		/* the stack computes the IP header already, the only time we
+		 * need the hardware to recompute it is in the case of TSO.
+		 */
+		if (first->tx_flags & IECM_TX_FLAGS_TSO)
+			cmd |= IECM_TX_DESC_CMD_IIPT_IPV4_CSUM;
+		else
+			cmd |= IECM_TX_DESC_CMD_IIPT_IPV4;
+
+	} else if (protocol == htons(ETH_P_IPV6)) {
+		cmd |= IECM_TX_DESC_CMD_IIPT_IPV6;
+		exthdr = ip.hdr + sizeof(*ip.v6);
+		l4_proto = ip.v6->nexthdr;
+		if (l4.hdr != exthdr)
+			ipv6_skip_exthdr(skb, exthdr - skb->data, &l4_proto,
+					 &frag_off);
+	} else {
+		return -1;
+	}
+
+	/* compute inner L3 header size */
+	l3_len = l4.hdr - ip.hdr;
+	offset |= (l3_len / 4) << IECM_TX_DESC_LEN_IPLEN_S;
+
+	/* Enable L4 checksum offloads */
+	switch (l4_proto) {
+	case IPPROTO_TCP:
+		/* enable checksum offloads */
+		cmd |= IECM_TX_DESC_CMD_L4T_EOFT_TCP;
+		l4_len = l4.tcp->doff;
+		offset |= l4_len << IECM_TX_DESC_LEN_L4_LEN_S;
+		break;
+	case IPPROTO_UDP:
+		/* enable UDP checksum offload */
+		cmd |= IECM_TX_DESC_CMD_L4T_EOFT_UDP;
+		l4_len = (sizeof(struct udphdr) >> 2);
+		offset |= l4_len << IECM_TX_DESC_LEN_L4_LEN_S;
+		break;
+	case IPPROTO_SCTP:
+		/* enable SCTP checksum offload */
+		cmd |= IECM_TX_DESC_CMD_L4T_EOFT_SCTP;
+		l4_len = sizeof(struct sctphdr) >> 2;
+		offset |= l4_len << IECM_TX_DESC_LEN_L4_LEN_S;
+		break;
+
+	default:
+		if (first->tx_flags & IECM_TX_FLAGS_TSO)
+			return -1;
+		skb_checksum_help(skb);
+		return 0;
+	}
+
+	off->td_cmd |= cmd;
+	off->hdr_offsets |= offset;
+	return 1;
 }
 
 /**
@@ -48,7 +138,125 @@ static void
 iecm_tx_singleq_map(struct iecm_queue *tx_q, struct iecm_tx_buf *first,
 		    struct iecm_tx_offload_params *offloads)
 {
-	/* stub */
+	u32 offsets = offloads->hdr_offsets;
+	struct iecm_base_tx_desc *tx_desc;
+	u64  td_cmd = offloads->td_cmd;
+	unsigned int data_len, size;
+	struct iecm_tx_buf *tx_buf;
+	u16 i = tx_q->next_to_use;
+	struct netdev_queue *nq;
+	struct sk_buff *skb;
+	skb_frag_t *frag;
+	dma_addr_t dma;
+
+	skb = first->skb;
+
+	data_len = skb->data_len;
+	size = skb_headlen(skb);
+
+	tx_desc = IECM_BASE_TX_DESC(tx_q, i);
+
+	dma = dma_map_single(tx_q->dev, skb->data, size, DMA_TO_DEVICE);
+
+	tx_buf = first;
+
+	/* write each descriptor with CRC bit */
+	if (tx_q->vport->adapter->dev_ops.crc_enable)
+		tx_q->vport->adapter->dev_ops.crc_enable(&td_cmd);
+
+	for (frag = &skb_shinfo(skb)->frags[0];; frag++) {
+		unsigned int max_data = IECM_TX_MAX_DESC_DATA_ALIGNED;
+
+		if (dma_mapping_error(tx_q->dev, dma))
+			goto dma_error;
+
+		/* record length, and DMA address */
+		dma_unmap_len_set(tx_buf, len, size);
+		dma_unmap_addr_set(tx_buf, dma, dma);
+
+		/* align size to end of page */
+		max_data += -dma & (IECM_TX_MAX_READ_REQ_SIZE - 1);
+		tx_desc->buf_addr = cpu_to_le64(dma);
+
+		/* account for data chunks larger than the hardware
+		 * can handle
+		 */
+		while (unlikely(size > IECM_TX_MAX_DESC_DATA)) {
+			tx_desc->qw1 = iecm_tx_singleq_build_ctob(td_cmd,
+								  offsets,
+								  size, 0);
+			tx_desc++;
+			i++;
+
+			if (i == tx_q->desc_count) {
+				tx_desc = IECM_BASE_TX_DESC(tx_q, 0);
+				i = 0;
+			}
+
+			dma += max_data;
+			size -= max_data;
+
+			max_data = IECM_TX_MAX_DESC_DATA_ALIGNED;
+			tx_desc->buf_addr = cpu_to_le64(dma);
+		}
+
+		if (likely(!data_len))
+			break;
+		tx_desc->qw1 = iecm_tx_singleq_build_ctob(td_cmd, offsets,
+							  size, 0);
+		tx_desc++;
+		i++;
+
+		if (i == tx_q->desc_count) {
+			tx_desc = IECM_BASE_TX_DESC(tx_q, 0);
+			i = 0;
+		}
+
+		size = skb_frag_size(frag);
+		data_len -= size;
+
+		dma = skb_frag_dma_map(tx_q->dev, frag, 0, size,
+				       DMA_TO_DEVICE);
+
+		tx_buf = &tx_q->tx_buf[i];
+	}
+
+	/* record bytecount for BQL */
+	nq = netdev_get_tx_queue(tx_q->vport->netdev, tx_q->idx);
+	netdev_tx_sent_queue(nq, first->bytecount);
+
+	/* record SW timestamp if HW timestamp is not available */
+	skb_tx_timestamp(first->skb);
+
+	/* write last descriptor with RS and EOP bits */
+	td_cmd |= (u64)(IECM_TX_DESC_CMD_EOP | IECM_TX_DESC_CMD_RS);
+
+	tx_desc->qw1 = iecm_tx_singleq_build_ctob(td_cmd, offsets, size, 0);
+
+	i++;
+	if (i == tx_q->desc_count)
+		i = 0;
+
+	/* set next_to_watch value indicating a packet is present */
+	first->next_to_watch = tx_desc;
+
+	iecm_tx_buf_hw_update(tx_q, i, skb);
+
+	return;
+
+dma_error:
+	/* clear DMA mappings for failed tx_buf map */
+	for (;;) {
+		tx_buf = &tx_q->tx_buf[i];
+		iecm_tx_buf_rel(tx_q, tx_buf);
+		if (tx_buf == first)
+			break;
+		if (i == 0)
+			i = tx_q->desc_count;
+		i--;
+	}
+
+	tx_q->next_to_use = i;
 }
 
 /**
@@ -61,7 +269,42 @@ iecm_tx_singleq_map(struct iecm_queue *tx_q, struct iecm_tx_buf *first,
 static netdev_tx_t
 iecm_tx_singleq_frame(struct sk_buff *skb, struct iecm_queue *tx_q)
 {
-	/* stub */
+	struct iecm_tx_offload_params offload = {0};
+	struct iecm_tx_buf *first;
+	unsigned int count;
+	int csum;
+
+	count = iecm_tx_desc_count_required(skb);
+
+	/* need: 1 descriptor per page * PAGE_SIZE/IECM_MAX_DATA_PER_TXD,
+	 *       + 1 desc for skb_head_len/IECM_MAX_DATA_PER_TXD,
+	 *       + 4 desc gap to avoid the cache line where head is,
+	 *       + 1 desc for context descriptor,
+	 * otherwise try next time
+	 */
+	if (iecm_tx_maybe_stop(tx_q, count + IECM_TX_DESCS_PER_CACHE_LINE +
+			       IECM_TX_DESCS_FOR_CTX)) {
+		return NETDEV_TX_BUSY;
+	}
+
+	/* record the location of the first descriptor for this packet */
+	first = &tx_q->tx_buf[tx_q->next_to_use];
+	first->skb = skb;
+	first->bytecount = max_t(unsigned int, skb->len, ETH_ZLEN);
+	first->gso_segs = 1;
+	first->tx_flags = 0;
+
+	csum = iecm_tx_singleq_csum(first, &offload);
+	if (csum < 0)
+		goto out_drop;
+
+	iecm_tx_singleq_map(tx_q, first, &offload);
+
+	return NETDEV_TX_OK;
+
+out_drop:
+	dev_kfree_skb_any(skb);
+	return NETDEV_TX_OK;
 }
 
 /**
@@ -74,7 +317,18 @@ iecm_tx_singleq_frame(struct sk_buff *skb, struct iecm_queue *tx_q)
 netdev_tx_t iecm_tx_singleq_start(struct sk_buff *skb,
 				  struct net_device *netdev)
 {
-	/* stub */
+	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
+	struct iecm_queue *tx_q;
+
+	tx_q = vport->txqs[skb->queue_mapping];
+
+	/* hardware can't handle really short frames, hardware padding works
+	 * beyond this point
+	 */
+	if (skb_put_padto(skb, IECM_TX_MIN_LEN))
+		return NETDEV_TX_OK;
+
+	return iecm_tx_singleq_frame(skb, tx_q);
 }
 
 /**
@@ -85,7 +339,98 @@ netdev_tx_t iecm_tx_singleq_start(struct sk_buff *skb,
  */
 static bool iecm_tx_singleq_clean(struct iecm_queue *tx_q, int napi_budget)
 {
-	/* stub */
+	unsigned int budget = tx_q->vport->compln_clean_budget;
+	unsigned int total_bytes = 0, total_pkts = 0;
+	struct iecm_base_tx_desc *tx_desc;
+	s16 ntc = tx_q->next_to_clean;
+	struct iecm_tx_buf *tx_buf;
+	struct netdev_queue *nq;
+
+	tx_desc = IECM_BASE_TX_DESC(tx_q, ntc);
+	tx_buf = &tx_q->tx_buf[ntc];
+	ntc -= tx_q->desc_count;
+
+	do {
+		struct iecm_base_tx_desc *eop_desc = tx_buf->next_to_watch;
+
+		/* if next_to_watch is not set then no work pending */
+		if (!eop_desc)
+			break;
+
+		/* prevent any other reads prior to eop_desc */
+		smp_rmb();
+
+		/* if the descriptor isn't done, no work yet to do */
+		if (!(eop_desc->qw1 &
+		      cpu_to_le64(IECM_TX_DESC_DTYPE_DESC_DONE)))
+			break;
+
+		/* clear next_to_watch to prevent false hangs */
+		tx_buf->next_to_watch = NULL;
+
+		/* update the statistics for this packet */
+		total_bytes += tx_buf->bytecount;
+		total_pkts += tx_buf->gso_segs;
+
+		/* free the skb */
+		napi_consume_skb(tx_buf->skb, napi_budget);
+
+		/* unmap skb header data */
+		dma_unmap_single(tx_q->dev,
+				 dma_unmap_addr(tx_buf, dma),
+				 dma_unmap_len(tx_buf, len),
+				 DMA_TO_DEVICE);
+
+		/* clear tx_buf data */
+		tx_buf->skb = NULL;
+		dma_unmap_len_set(tx_buf, len, 0);
+
+		/* unmap remaining buffers */
+		while (tx_desc != eop_desc) {
+			tx_buf++;
+			tx_desc++;
+			ntc++;
+			if (unlikely(!ntc)) {
+				ntc -= tx_q->desc_count;
+				tx_buf = tx_q->tx_buf;
+				tx_desc = IECM_BASE_TX_DESC(tx_q, 0);
+			}
+
+			/* unmap any remaining paged data */
+			if (dma_unmap_len(tx_buf, len)) {
+				dma_unmap_page(tx_q->dev,
+					       dma_unmap_addr(tx_buf, dma),
+					       dma_unmap_len(tx_buf, len),
+					       DMA_TO_DEVICE);
+				dma_unmap_len_set(tx_buf, len, 0);
+			}
+		}
+
+		tx_buf++;
+		tx_desc++;
+		ntc++;
+		if (unlikely(!ntc)) {
+			ntc -= tx_q->desc_count;
+			tx_buf = tx_q->tx_buf;
+			tx_desc = IECM_BASE_TX_DESC(tx_q, 0);
+		}
+		/* update budget */
+		budget--;
+	} while (likely(budget));
+
+	ntc += tx_q->desc_count;
+	tx_q->next_to_clean = ntc;
+	nq = netdev_get_tx_queue(tx_q->vport->netdev, tx_q->idx);
+	netdev_tx_completed_queue(nq, total_pkts, total_bytes);
+	tx_q->itr.stats.tx.packets += total_pkts;
+	tx_q->itr.stats.tx.bytes += total_bytes;
+
+	u64_stats_update_begin(&tx_q->stats_sync);
+	tx_q->q_stats.tx.packets += total_pkts;
+	tx_q->q_stats.tx.bytes += total_bytes;
+	u64_stats_update_end(&tx_q->stats_sync);
+
+	return !!budget;
 }
 
 /**
@@ -98,7 +443,16 @@ static bool iecm_tx_singleq_clean(struct iecm_queue *tx_q, int napi_budget)
 static inline bool
 iecm_tx_singleq_clean_all(struct iecm_q_vector *q_vec, int budget)
 {
-	/* stub */
+	bool clean_complete = true;
+	int i, budget_per_q;
+
+	budget_per_q = max(budget / q_vec->num_txq, 1);
+	for (i = 0; i < q_vec->num_txq; i++) {
+		if (!iecm_tx_singleq_clean(q_vec->tx[i], budget_per_q))
+			clean_complete = false;
+	}
+
+	return clean_complete;
 }
 
 /**
@@ -116,7 +470,8 @@ static bool
 iecm_rx_singleq_test_staterr(struct iecm_singleq_base_rx_desc *rx_desc,
 			     const u64 stat_err_bits)
 {
-	/* stub */
+	return !!(rx_desc->qword1.status_error_ptype_len &
+		  cpu_to_le64(stat_err_bits));
 }
 
 /**
@@ -129,7 +484,15 @@ static bool iecm_rx_singleq_is_non_eop(struct iecm_queue *rxq,
 				       struct iecm_singleq_base_rx_desc
 				       *rx_desc, struct sk_buff *skb)
 {
-	/* stub */
+	/* if we are the last buffer then there is nothing else to do */
+ #define IECM_RXD_EOF BIT(IECM_RX_BASE_DESC_STATUS_EOF_S)
+	if (likely(iecm_rx_singleq_test_staterr(rx_desc, IECM_RXD_EOF)))
+		return false;
+
+	/* place skb in next buffer to be received */
+	rxq->rx_buf.buf[rxq->next_to_clean].skb = skb;
+
+	return true;
 }
 
 /**
@@ -145,7 +508,63 @@ static void iecm_rx_singleq_csum(struct iecm_queue *rxq, struct sk_buff *skb,
 				 struct iecm_singleq_base_rx_desc *rx_desc,
 				 u8 ptype)
 {
-	/* stub */
+	u64 qw1 = le64_to_cpu(rx_desc->qword1.status_error_ptype_len);
+	struct iecm_rx_ptype_decoded decoded;
+	bool ipv4, ipv6;
+	u32 rx_status;
+	u8 rx_error;
+
+	/* Start with CHECKSUM_NONE and by default csum_level = 0 */
+	skb->ip_summed = CHECKSUM_NONE;
+	skb_checksum_none_assert(skb);
+
+	/* check if Rx checksum is enabled */
+	if (!(rxq->vport->netdev->features & NETIF_F_RXCSUM))
+		return;
+
+	rx_status = ((qw1 & IECM_RXD_QW1_STATUS_M) >> IECM_RXD_QW1_STATUS_S);
+	rx_error = ((qw1 & IECM_RXD_QW1_ERROR_M) >> IECM_RXD_QW1_ERROR_S);
+
+	/* check if HW has decoded the packet and checksum */
+	if (!(rx_status & BIT(IECM_RX_BASE_DESC_STATUS_L3L4P_S)))
+		return;
+
+	decoded = rxq->vport->rx_ptype_lkup[ptype];
+	if (!(decoded.known && decoded.outer_ip))
+		return;
+
+	ipv4 = (decoded.outer_ip == IECM_RX_PTYPE_OUTER_IP) &&
+	       (decoded.outer_ip_ver == IECM_RX_PTYPE_OUTER_IPV4);
+	ipv6 = (decoded.outer_ip == IECM_RX_PTYPE_OUTER_IP) &&
+	       (decoded.outer_ip_ver == IECM_RX_PTYPE_OUTER_IPV6);
+
+	if (ipv4 && (rx_error & (BIT(IECM_RX_BASE_DESC_ERROR_IPE_S) |
+				 BIT(IECM_RX_BASE_DESC_ERROR_EIPE_S))))
+		goto checksum_fail;
+	else if (ipv6 && (rx_status &
+		 (BIT(IECM_RX_BASE_DESC_STATUS_IPV6EXADD_S))))
+		goto checksum_fail;
+
+	/* check for L4 errors and handle packets that were not able to be
+	 * checksummed due to arrival speed
+	 */
+	if (rx_error & BIT(IECM_RX_BASE_DESC_ERROR_L3L4E_S))
+		goto checksum_fail;
+
+	/* Only report checksum unnecessary for ICMP, TCP, UDP, or SCTP */
+	switch (decoded.inner_prot) {
+	case IECM_RX_PTYPE_INNER_PROT_ICMP:
+	case IECM_RX_PTYPE_INNER_PROT_TCP:
+	case IECM_RX_PTYPE_INNER_PROT_UDP:
+	case IECM_RX_PTYPE_INNER_PROT_SCTP:
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+	default:
+		break;
+	}
+	return;
+
+checksum_fail:
+	dev_dbg(rxq->dev, "RX Checksum not available\n");
 }
 
 /**
@@ -163,7 +582,10 @@ iecm_rx_singleq_process_skb_fields(struct iecm_queue *rxq, struct sk_buff *skb,
 				   struct iecm_singleq_base_rx_desc *rx_desc,
 				   u8 ptype)
 {
-	/* stub */
+	/* modifies the skb - consumes the enet header */
+	skb->protocol = eth_type_trans(skb, rxq->vport->netdev);
+
+	iecm_rx_singleq_csum(rxq, skb, rx_desc, ptype);
 }
 
 /**
@@ -176,7 +598,44 @@ iecm_rx_singleq_process_skb_fields(struct iecm_queue *rxq, struct sk_buff *skb,
 bool iecm_rx_singleq_buf_hw_alloc_all(struct iecm_queue *rx_q,
 				      u16 cleaned_count)
 {
-	/* stub */
+	struct iecm_singleq_rx_buf_desc *singleq_rx_desc = NULL;
+	u16 nta = rx_q->next_to_alloc;
+	struct iecm_rx_buf *buf;
+
+	/* do nothing if no valid netdev defined */
+	if (!rx_q->vport->netdev || !cleaned_count)
+		return false;
+
+	singleq_rx_desc = IECM_SINGLEQ_RX_BUF_DESC(rx_q, nta);
+	buf = &rx_q->rx_buf.buf[nta];
+
+	do {
+		if (!iecm_rx_buf_hw_alloc(rx_q, buf))
+			break;
+
+		/* Refresh the desc even if buffer_addrs didn't change
+		 * because each write-back erases this info.
+		 */
+		singleq_rx_desc->pkt_addr =
+			cpu_to_le64(buf->dma + buf->page_offset);
+		singleq_rx_desc->hdr_addr = 0;
+		singleq_rx_desc++;
+
+		buf++;
+		nta++;
+		if (unlikely(nta == rx_q->desc_count)) {
+			singleq_rx_desc = IECM_SINGLEQ_RX_BUF_DESC(rx_q, 0);
+			buf = rx_q->rx_buf.buf;
+			nta = 0;
+		}
+
+		cleaned_count--;
+	} while (cleaned_count);
+
+	if (rx_q->next_to_alloc != nta)
+		iecm_rx_buf_hw_update(rx_q, nta);
+
+	return !!cleaned_count;
 }
 
 /**
@@ -190,7 +649,16 @@ bool iecm_rx_singleq_buf_hw_alloc_all(struct iecm_queue *rx_q,
 static void iecm_singleq_rx_put_buf(struct iecm_queue *rx_bufq,
 				    struct iecm_rx_buf *rx_buf)
 {
-	/* stub */
+	u16 ntu = rx_bufq->next_to_use;
+	bool recycled = false;
+
+	recycled = iecm_rx_recycle_buf(rx_bufq, false, rx_buf);
+
+	/* update, and store next to alloc if the buffer was recycled */
+	if (recycled) {
+		ntu++;
+		rx_bufq->next_to_use = (ntu < rx_bufq->desc_count) ? ntu : 0;
+	}
 }
 
 /**
@@ -199,7 +667,12 @@ static void iecm_singleq_rx_put_buf(struct iecm_queue *rx_bufq,
  */
 static void iecm_singleq_rx_bump_ntc(struct iecm_queue *q)
 {
-	/* stub */
+	u16 ntc = q->next_to_clean + 1;
+	/* fetch, update, and store next to clean */
+	if (ntc < q->desc_count)
+		q->next_to_clean = ntc;
+	else
+		q->next_to_clean = 0;
 }
 
 /**
@@ -214,7 +687,17 @@ static struct sk_buff *
 iecm_singleq_rx_get_buf_page(struct device *dev, struct iecm_rx_buf *rx_buf,
 			     const unsigned int size)
 {
-	/* stub */
+	prefetch(rx_buf->page);
+
+	/* we are reusing so sync this buffer for CPU use */
+	dma_sync_single_range_for_cpu(dev, rx_buf->dma,
+				      rx_buf->page_offset, size,
+				      DMA_FROM_DEVICE);
+
+	/* We have pulled a buffer for use, so decrement pagecnt_bias */
+	rx_buf->pagecnt_bias--;
+
+	return rx_buf->skb;
 }
 
 /**
@@ -226,7 +709,116 @@ iecm_singleq_rx_get_buf_page(struct device *dev, struct iecm_rx_buf *rx_buf,
  */
 static int iecm_rx_singleq_clean(struct iecm_queue *rx_q, int budget)
 {
-	/* stub */
+	struct iecm_singleq_base_rx_desc *singleq_base_rx_desc;
+	unsigned int total_rx_bytes = 0, total_rx_pkts = 0;
+	u16 cleaned_count = 0;
+	bool failure = false;
+
+	/* Process Rx packets bounded by budget */
+	while (likely(total_rx_pkts < (unsigned int)budget)) {
+		union iecm_rx_desc *rx_desc;
+		struct sk_buff *skb = NULL;
+		struct iecm_rx_buf *rx_buf;
+		unsigned int size;
+		u8 rx_ptype;
+		u64 qword;
+
+		/* get the Rx desc from Rx queue based on 'next_to_clean' */
+		rx_desc = IECM_RX_DESC(rx_q, rx_q->next_to_clean);
+		singleq_base_rx_desc = (struct iecm_singleq_base_rx_desc *)
+					rx_desc;
+		/* status_error_ptype_len will always be zero for unused
+		 * descriptors because it's cleared in cleanup, and overlaps
+		 * with hdr_addr which is always zero because packet split
+		 * isn't used, if the hardware wrote DD then the length will be
+		 * non-zero
+		 */
+		qword =
+		le64_to_cpu(rx_desc->base_wb.qword1.status_error_ptype_len);
+
+		/* This memory barrier is needed to keep us from reading
+		 * any other fields out of the rx_desc
+		 */
+		dma_rmb();
+#define IECM_RXD_DD BIT(IECM_RX_BASE_DESC_STATUS_DD_S)
+		if (!iecm_rx_singleq_test_staterr(singleq_base_rx_desc,
+						  IECM_RXD_DD))
+			break;
+
+		size = (qword & IECM_RXD_QW1_LEN_PBUF_M) >>
+		       IECM_RXD_QW1_LEN_PBUF_S;
+		if (!size)
+			break;
+
+		rx_buf = &rx_q->rx_buf.buf[rx_q->next_to_clean];
+		skb = iecm_singleq_rx_get_buf_page(rx_q->dev, rx_buf, size);
+
+		if (skb)
+			iecm_rx_add_frag(rx_buf, skb, size);
+		else
+			skb = iecm_rx_construct_skb(rx_q, rx_buf, size);
+
+		/* exit if we failed to retrieve a buffer */
+		if (!skb) {
+			rx_buf->pagecnt_bias++;
+			break;
+		}
+
+		iecm_singleq_rx_put_buf(rx_q, rx_buf);
+		iecm_singleq_rx_bump_ntc(rx_q);
+
+		cleaned_count++;
+
+		/* skip if it is non EOP desc */
+		if (iecm_rx_singleq_is_non_eop(rx_q, singleq_base_rx_desc,
+					       skb))
+			continue;
+
+#define IECM_RXD_ERR_S BIT(IECM_RXD_QW1_ERROR_S)
+		if (unlikely(iecm_rx_singleq_test_staterr(singleq_base_rx_desc,
+							  IECM_RXD_ERR_S))) {
+			dev_kfree_skb_any(skb);
+			skb = NULL;
+			continue;
+		}
+
+		/* correct empty headers and pad skb if needed (to make valid
+		 * ethernet frame
+		 */
+		if (iecm_rx_cleanup_headers(skb)) {
+			skb = NULL;
+			continue;
+		}
+
+		/* probably a little skewed due to removing CRC */
+		total_rx_bytes += skb->len;
+
+		rx_ptype = (qword & IECM_RXD_QW1_PTYPE_M) >>
+				IECM_RXD_QW1_PTYPE_S;
+
+		/* protocol */
+		iecm_rx_singleq_process_skb_fields(rx_q, skb,
+						   singleq_base_rx_desc,
+						   rx_ptype);
+
+		/* send completed skb up the stack */
+		iecm_rx_skb(rx_q, skb);
+
+		/* update budget accounting */
+		total_rx_pkts++;
+	}
+	if (cleaned_count)
+		failure = iecm_rx_singleq_buf_hw_alloc_all(rx_q, cleaned_count);
+
+	rx_q->itr.stats.rx.packets += total_rx_pkts;
+	rx_q->itr.stats.rx.bytes += total_rx_bytes;
+	u64_stats_update_begin(&rx_q->stats_sync);
+	rx_q->q_stats.rx.packets += total_rx_pkts;
+	rx_q->q_stats.rx.bytes += total_rx_bytes;
+	u64_stats_update_end(&rx_q->stats_sync);
+
+	/* guarantee a trip back through this routine if there was a failure */
+	return failure ? budget : (int)total_rx_pkts;
 }
 
 /**
@@ -241,7 +833,22 @@ static inline bool
 iecm_rx_singleq_clean_all(struct iecm_q_vector *q_vec, int budget,
 			  int *cleaned)
 {
-	/* stub */
+	bool clean_complete = true;
+	int pkts_cleaned_per_q;
+	int budget_per_q, i;
+
+	budget_per_q = max(budget / q_vec->num_rxq, 1);
+	for (i = 0; i < q_vec->num_rxq; i++) {
+		pkts_cleaned_per_q = iecm_rx_singleq_clean(q_vec->rx[0],
+							   budget_per_q);
+
+		/* if we clean as many as budgeted, we must not be done */
+		if (pkts_cleaned_per_q >= budget_per_q)
+			clean_complete = false;
+		*cleaned += pkts_cleaned_per_q;
+	}
+
+	return clean_complete;
 }
 
 /**
@@ -251,5 +858,32 @@ iecm_rx_singleq_clean_all(struct iecm_q_vector *q_vec, int budget,
  */
 int iecm_vport_singleq_napi_poll(struct napi_struct *napi, int budget)
 {
-	/* stub */
+	struct iecm_q_vector *q_vector =
+				container_of(napi, struct iecm_q_vector, napi);
+	bool clean_complete;
+	int work_done = 0;
+
+	clean_complete = iecm_tx_singleq_clean_all(q_vector, budget);
+
+	/* Handle case where we are called by netpoll with a budget of 0 */
+	if (budget <= 0)
+		return budget;
+
+	/* We attempt to distribute budget to each Rx queue fairly, but don't
+	 * allow the budget to go below 1 because that would exit polling early.
+	 */
+	clean_complete |= iecm_rx_singleq_clean_all(q_vector, budget,
+						    &work_done);
+
+	/* If work not completed, return budget and polling will return */
+	if (!clean_complete)
+		return budget;
+
+	/* Exit the polling mode, but don't re-enable interrupts if stack might
+	 * poll us due to busy-polling
+	 */
+	if (likely(napi_complete_done(napi, work_done)))
+		iecm_vport_intr_update_itr_ena_irq(q_vector);
+
+	return min_t(int, work_done, budget - 1);
 }
-- 
2.26.2

