Return-Path: <netdev+bounces-4456-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90E9370CF4B
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:33:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 470AA1C20C21
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 00:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB9811FAC;
	Tue, 23 May 2023 00:30:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4244C122
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 00:30:08 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AC4423B
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 17:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684801803; x=1716337803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jXwFNmy37k4+dZtC6mkM3U8XgEnA32T1zRufjpHZmB8=;
  b=hk/Kn/OkfpGZFjj6tSlka9hlPdPrJr4bsX0rPHDy8m7a7plDBiLjHb+n
   MLzsM4ucv3yu+9CfNpxCBZ2XtNSk7+JguQRIJB4IYNwrABznwY0CXze/W
   MdbGK8gHtxQgV8uAk2Pl4EqvWuBe0LjUvEyAn+AnrJkDNMiRJryEVCe9R
   QNUdLtlNl5l6+BGrJ05ypbBbJEcJuDJnMgMyFS0JHVcOmSLpL3fmlKkkF
   +2ecvZ41Ed67XSp4SKbu51bROUy0j00G1uYEnQSWwcWgMB0wv3N21LKac
   iHypG/HzG3W0mbiqQ1U8ksWVHV28WFfjJ6MOWADjuftvepbYWXQenpUkX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="337670781"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="337670781"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 17:26:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="827885522"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="827885522"
Received: from unknown (HELO AMR-CMP1.ger.corp.intel.com) ([10.166.80.24])
  by orsmga004.jf.intel.com with ESMTP; 22 May 2023 17:26:04 -0700
From: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: shannon.nelson@amd.com,
	simon.horman@corigine.com,
	leon@kernel.org,
	decot@google.com,
	willemb@google.com,
	stephen@networkplumber.org,
	mst@redhat.com,
	Alan Brady <alan.brady@intel.com>,
	jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	Joshua Hay <joshua.a.hay@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Phani Burra <phani.r.burra@intel.com>,
	Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
	Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: [PATCH iwl-next v6 12/15] idpf: add RX splitq napi poll support
Date: Mon, 22 May 2023 17:22:49 -0700
Message-Id: <20230523002252.26124-13-pavan.kumar.linga@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230523002252.26124-1-pavan.kumar.linga@intel.com>
References: <20230523002252.26124-1-pavan.kumar.linga@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alan Brady <alan.brady@intel.com>

Add support to handle interrupts for the RX completion queue and
RX buffer queue. When the interrupt fires on RX completion queue,
process the RX descriptors that are received. Allocate and prepare
the SKB with the RX packet info, for both data and header buffer.

IDPF uses software maintained refill queues to manage buffers between
RX queue producer and the buffer queue consumer. They are required in
order to maintain a lockless buffer management system and are strictly
software only constructs. Instead of updating the RX buffer queue tail
with available buffers right after the clean routine, it posts the
buffer ids to the refill queues, only to post them to the HW later.

If the generic receive offload (GRO) is enabled in the capabilities
and turned on by default or via ethtool, then HW performs the
packet coalescing if certain criteria are met by the incoming
packets and updates the RX descriptor. Similar to GRO, if generic
checksum is enabled, HW computes the checksum and updates the
respective fields in the descriptor. Add support to update the
SKB fields with the GRO and the generic checksum received.

Signed-off-by: Alan Brady <alan.brady@intel.com>
Co-developed-by: Joshua Hay <joshua.a.hay@intel.com>
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
Co-developed-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
---
 drivers/net/ethernet/intel/idpf/idpf.h        |   2 +
 drivers/net/ethernet/intel/idpf/idpf_txrx.c   | 992 +++++++++++++++++-
 drivers/net/ethernet/intel/idpf/idpf_txrx.h   |  56 +-
 .../net/ethernet/intel/idpf/idpf_virtchnl.c   |   4 +-
 4 files changed, 1045 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf.h b/drivers/net/ethernet/intel/idpf/idpf.h
index 3dc97dd45012..ddb52cd16a47 100644
--- a/drivers/net/ethernet/intel/idpf/idpf.h
+++ b/drivers/net/ethernet/intel/idpf/idpf.h
@@ -14,6 +14,7 @@ struct idpf_vport_max_q;
 #include <linux/etherdevice.h>
 #include <linux/pci.h>
 #include <linux/bitfield.h>
+#include <net/gro.h>
 #include <linux/dim.h>
 
 #include "virtchnl2.h"
@@ -272,6 +273,7 @@ struct idpf_vport {
 	u8 default_mac_addr[ETH_ALEN];
 	/* ITR profiles for the DIM algorithm */
 #define IDPF_DIM_PROFILE_SLOTS  5
+	u16 rx_itr_profile[IDPF_DIM_PROFILE_SLOTS];
 	u16 tx_itr_profile[IDPF_DIM_PROFILE_SLOTS];
 
 	bool link_up;
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index 7d070b7dcffb..528a870e9705 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -335,6 +335,11 @@ static void idpf_rx_buf_rel(struct idpf_queue *rxq,
 	idpf_rx_page_rel(rxq, &rx_buf->page_info[0]);
 	if (PAGE_SIZE < 8192 && rx_buf->buf_size > IDPF_RX_BUF_2048)
 		idpf_rx_page_rel(rxq, &rx_buf->page_info[1]);
+
+	if (rx_buf->skb) {
+		dev_kfree_skb(rx_buf->skb);
+		rx_buf->skb = NULL;
+	}
 }
 
 /**
@@ -650,6 +655,28 @@ static bool idpf_rx_buf_hw_alloc_all(struct idpf_queue *rxbufq, u16 alloc_count)
 	return !!alloc_count;
 }
 
+/**
+ * idpf_rx_post_buf_refill - Post buffer id to refill queue
+ * @refillq: refill queue to post to
+ * @buf_id: buffer id to post
+ */
+static void idpf_rx_post_buf_refill(struct idpf_sw_queue *refillq, u16 buf_id)
+{
+	u16 nta = refillq->next_to_alloc;
+
+	/* store the buffer ID and the SW maintained GEN bit to the refillq */
+	refillq->ring[nta] =
+		((buf_id << IDPF_RX_BI_BUFID_S) & IDPF_RX_BI_BUFID_M) |
+		(!!(test_bit(__IDPF_Q_GEN_CHK, refillq->flags)) <<
+		 IDPF_RX_BI_GEN_S);
+
+	if (unlikely(++nta == refillq->desc_count)) {
+		nta = 0;
+		change_bit(__IDPF_Q_GEN_CHK, refillq->flags);
+	}
+	refillq->next_to_alloc = nta;
+}
+
 /**
  * idpf_rx_post_buf_desc - Post buffer to bufq descriptor ring
  * @bufq: buffer queue to post to
@@ -2776,6 +2803,868 @@ netdev_tx_t idpf_tx_splitq_start(struct sk_buff *skb,
 	return idpf_tx_splitq_frame(skb, tx_q);
 }
 
+/**
+ * idpf_ptype_to_htype - get a hash type
+ * @decoded: Decoded Rx packet type related fields
+ *
+ * Returns appropriate hash type (such as PKT_HASH_TYPE_L2/L3/L4) to be used by
+ * skb_set_hash based on PTYPE as parsed by HW Rx pipeline and is part of
+ * Rx desc.
+ */
+static enum pkt_hash_types
+idpf_ptype_to_htype(const struct idpf_rx_ptype_decoded *decoded)
+{
+	if (!decoded->known)
+		return PKT_HASH_TYPE_NONE;
+	if (decoded->payload_layer == IDPF_RX_PTYPE_PAYLOAD_LAYER_PAY2 &&
+	    decoded->inner_prot)
+		return PKT_HASH_TYPE_L4;
+	if (decoded->payload_layer == IDPF_RX_PTYPE_PAYLOAD_LAYER_PAY2 &&
+	    decoded->outer_ip)
+		return PKT_HASH_TYPE_L3;
+	if (decoded->outer_ip == IDPF_RX_PTYPE_OUTER_L2)
+		return PKT_HASH_TYPE_L2;
+
+	return PKT_HASH_TYPE_NONE;
+}
+
+/**
+ * idpf_rx_hash - set the hash value in the skb
+ * @rxq: Rx descriptor ring packet is being transacted on
+ * @skb: pointer to current skb being populated
+ * @rx_desc: Receive descriptor
+ * @decoded: Decoded Rx packet type related fields
+ */
+static void idpf_rx_hash(struct idpf_queue *rxq, struct sk_buff *skb,
+			 struct virtchnl2_rx_flex_desc_adv_nic_3 *rx_desc,
+			 struct idpf_rx_ptype_decoded *decoded)
+{
+	u32 hash;
+
+	if (unlikely(!idpf_is_feature_ena(rxq->vport, NETIF_F_RXHASH)))
+		return;
+
+	hash = le16_to_cpu(rx_desc->hash1) |
+	       (rx_desc->ff2_mirrid_hash2.hash2 << 16) |
+	       (rx_desc->hash3 << 24);
+
+	skb_set_hash(skb, hash, idpf_ptype_to_htype(decoded));
+}
+
+/**
+ * idpf_rx_csum - Indicate in skb if checksum is good
+ * @rxq: Rx descriptor ring packet is being transacted on
+ * @skb: pointer to current skb being populated
+ * @csum_bits: checksum fields extracted from the descriptor
+ * @decoded: Decoded Rx packet type related fields
+ *
+ * skb->protocol must be set before this function is called
+ */
+static void idpf_rx_csum(struct idpf_queue *rxq, struct sk_buff *skb,
+			 struct idpf_rx_csum_decoded *csum_bits,
+			 struct idpf_rx_ptype_decoded *decoded)
+{
+	bool ipv4, ipv6;
+
+	/* check if Rx checksum is enabled */
+	if (unlikely(!idpf_is_feature_ena(rxq->vport, NETIF_F_RXCSUM)))
+		return;
+
+	/* check if HW has decoded the packet and checksum */
+	if (!(csum_bits->l3l4p))
+		return;
+
+	ipv4 = IDPF_RX_PTYPE_TO_IPV(decoded, IDPF_RX_PTYPE_OUTER_IPV4);
+	ipv6 = IDPF_RX_PTYPE_TO_IPV(decoded, IDPF_RX_PTYPE_OUTER_IPV6);
+
+	if (ipv4 && (csum_bits->ipe || csum_bits->eipe))
+		goto checksum_fail;
+
+	if (ipv6 && csum_bits->ipv6exadd)
+		return;
+
+	/* check for L4 errors and handle packets that were not able to be
+	 * checksummed
+	 */
+	if (csum_bits->l4e)
+		goto checksum_fail;
+
+	/* Only report checksum unnecessary for ICMP, TCP, UDP, or SCTP */
+	switch (decoded->inner_prot) {
+	case IDPF_RX_PTYPE_INNER_PROT_ICMP:
+	case IDPF_RX_PTYPE_INNER_PROT_TCP:
+	case IDPF_RX_PTYPE_INNER_PROT_UDP:
+		if (!csum_bits->raw_csum_inv) {
+			u16 csum = csum_bits->raw_csum;
+
+			skb->csum = csum_unfold((__force __sum16)~swab16(csum));
+			skb->ip_summed = CHECKSUM_COMPLETE;
+		} else {
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+		}
+		break;
+	case IDPF_RX_PTYPE_INNER_PROT_SCTP:
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+		break;
+	default:
+		break;
+	}
+
+	return;
+
+checksum_fail:
+	u64_stats_update_begin(&rxq->stats_sync);
+	u64_stats_inc(&rxq->q_stats.rx.hw_csum_err);
+	u64_stats_update_end(&rxq->stats_sync);
+}
+
+/**
+ * idpf_rx_splitq_extract_csum_bits - Extract checksum bits from descriptor
+ * @rx_desc: receive descriptor
+ * @csum: structure to extract checksum fields
+ *
+ **/
+static void idpf_rx_splitq_extract_csum_bits(struct virtchnl2_rx_flex_desc_adv_nic_3 *rx_desc,
+					     struct idpf_rx_csum_decoded *csum)
+{
+	u8 qword0, qword1;
+
+	qword0 = rx_desc->status_err0_qw0;
+	qword1 = rx_desc->status_err0_qw1;
+
+	csum->ipe = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_STATUS0_XSUM_IPE_M,
+			      qword1);
+	csum->eipe = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_STATUS0_XSUM_EIPE_M,
+			       qword1);
+	csum->l4e = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_STATUS0_XSUM_L4E_M,
+			      qword1);
+	csum->l3l4p = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_STATUS0_L3L4P_M,
+				qword1);
+	csum->ipv6exadd = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_STATUS0_IPV6EXADD_M,
+				    qword0);
+	csum->raw_csum_inv = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_RAW_CSUM_INV_M,
+				       le16_to_cpu(rx_desc->ptype_err_fflags0));
+	csum->raw_csum = le16_to_cpu(rx_desc->misc.raw_cs);
+}
+
+/**
+ * idpf_rx_rsc - Set the RSC fields in the skb
+ * @rxq : Rx descriptor ring packet is being transacted on
+ * @skb : pointer to current skb being populated
+ * @rx_desc: Receive descriptor
+ * @decoded: Decoded Rx packet type related fields
+ *
+ * Return 0 on success and error code on failure
+ *
+ * Populate the skb fields with the total number of RSC segments, RSC payload
+ * length and packet type.
+ */
+static int idpf_rx_rsc(struct idpf_queue *rxq, struct sk_buff *skb,
+		       struct virtchnl2_rx_flex_desc_adv_nic_3 *rx_desc,
+		       struct idpf_rx_ptype_decoded *decoded)
+{
+	u16 rsc_segments, rsc_seg_len;
+	bool ipv4, ipv6;
+	int len;
+
+	if (unlikely(!decoded->outer_ip))
+		return -EINVAL;
+
+	rsc_seg_len = le16_to_cpu(rx_desc->misc.rscseglen);
+	if (unlikely(!rsc_seg_len))
+		return -EINVAL;
+
+	ipv4 = IDPF_RX_PTYPE_TO_IPV(decoded, IDPF_RX_PTYPE_OUTER_IPV4);
+	ipv6 = IDPF_RX_PTYPE_TO_IPV(decoded, IDPF_RX_PTYPE_OUTER_IPV6);
+
+	if (unlikely(!(ipv4 ^ ipv6)))
+		return -EINVAL;
+
+	rsc_segments = DIV_ROUND_UP(skb->data_len, rsc_seg_len);
+	if (unlikely(rsc_segments == 1))
+		return 0;
+
+	NAPI_GRO_CB(skb)->count = rsc_segments;
+	skb_shinfo(skb)->gso_size = rsc_seg_len;
+
+	skb_reset_network_header(skb);
+	len = skb->len - skb_transport_offset(skb);
+
+	if (ipv4) {
+		struct iphdr *ipv4h = ip_hdr(skb);
+
+		skb_shinfo(skb)->gso_type = SKB_GSO_TCPV4;
+
+		/* Reset and set transport header offset in skb */
+		skb_set_transport_header(skb, sizeof(struct iphdr));
+
+		/* Compute the TCP pseudo header checksum*/
+		tcp_hdr(skb)->check =
+			~tcp_v4_check(len, ipv4h->saddr, ipv4h->daddr, 0);
+	} else {
+		struct ipv6hdr *ipv6h = ipv6_hdr(skb);
+
+		skb_shinfo(skb)->gso_type = SKB_GSO_TCPV6;
+		skb_set_transport_header(skb, sizeof(struct ipv6hdr));
+		tcp_hdr(skb)->check =
+			~tcp_v6_check(len, &ipv6h->saddr, &ipv6h->daddr, 0);
+	}
+
+	tcp_gro_complete(skb);
+
+	u64_stats_update_begin(&rxq->stats_sync);
+	u64_stats_inc(&rxq->q_stats.rx.rsc_pkts);
+	u64_stats_update_end(&rxq->stats_sync);
+
+	return 0;
+}
+
+/**
+ * idpf_rx_process_skb_fields - Populate skb header fields from Rx descriptor
+ * @rxq: Rx descriptor ring packet is being transacted on
+ * @skb: pointer to current skb being populated
+ * @rx_desc: Receive descriptor
+ *
+ * This function checks the ring, descriptor, and packet information in
+ * order to populate the hash, checksum, protocol, and
+ * other fields within the skb.
+ */
+static int idpf_rx_process_skb_fields(struct idpf_queue *rxq,
+				      struct sk_buff *skb,
+				      struct virtchnl2_rx_flex_desc_adv_nic_3 *rx_desc)
+{
+	struct idpf_rx_csum_decoded csum_bits = { };
+	struct idpf_rx_ptype_decoded decoded;
+	u16 rx_ptype;
+
+	rx_ptype = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_PTYPE_M,
+			     le16_to_cpu(rx_desc->ptype_err_fflags0));
+
+	decoded = rxq->vport->rx_ptype_lkup[rx_ptype];
+	/* If we don't know the ptype we can't do anything else with it. Just
+	 * pass it up the stack as-is.
+	 */
+	if (!decoded.known)
+		return 0;
+
+	/* process RSS/hash */
+	idpf_rx_hash(rxq, skb, rx_desc, &decoded);
+
+	skb->protocol = eth_type_trans(skb, rxq->vport->netdev);
+
+	if (FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_RSC_M,
+		      le16_to_cpu(rx_desc->hdrlen_flags)))
+		return idpf_rx_rsc(rxq, skb, rx_desc, &decoded);
+
+	idpf_rx_splitq_extract_csum_bits(rx_desc, &csum_bits);
+	idpf_rx_csum(rxq, skb, &csum_bits, &decoded);
+
+	return 0;
+}
+
+/**
+ * idpf_rx_buf_adjust_pg - Prepare rx buffer for reuse
+ * @rx_buf: Rx buffer to adjust
+ * @size: Size of adjustment
+ *
+ * Update the offset within page so that rx buf will be ready to be reused.
+ * For systems with PAGE_SIZE < 8192 this function will flip the page offset
+ * so the second half of page assigned to rx buffer will be used, otherwise
+ * the offset is moved by the @size bytes
+ */
+static void idpf_rx_buf_adjust_pg(struct idpf_rx_buf *rx_buf, unsigned int size)
+{
+	struct idpf_page_info *pinfo;
+
+	pinfo = &rx_buf->page_info[rx_buf->page_indx];
+
+	if (PAGE_SIZE < 8192)
+		if (rx_buf->buf_size > IDPF_RX_BUF_2048)
+			/* flip to second page */
+			rx_buf->page_indx = !rx_buf->page_indx;
+		else
+			/* flip page offset to other buffer */
+			pinfo->page_offset ^= size;
+	else
+		pinfo->page_offset += size;
+}
+
+/**
+ * idpf_rx_can_reuse_page - Determine if page can be reused for another rx
+ * @rx_buf: buffer containing the page
+ *
+ * If page is reusable, we have a green light for calling idpf_reuse_rx_page,
+ * which will assign the current buffer to the buffer that next_to_alloc is
+ * pointing to; otherwise, the dma mapping needs to be destroyed and
+ * page freed
+ */
+static bool idpf_rx_can_reuse_page(struct idpf_rx_buf *rx_buf)
+{
+	unsigned int last_offset = PAGE_SIZE - rx_buf->buf_size;
+	struct idpf_page_info *pinfo;
+	unsigned int pagecnt_bias;
+	struct page *page;
+
+	pinfo = &rx_buf->page_info[rx_buf->page_indx];
+	pagecnt_bias = pinfo->pagecnt_bias;
+	page = pinfo->page;
+
+	if (unlikely(!dev_page_is_reusable(page)))
+		return false;
+
+	if (PAGE_SIZE < 8192) {
+		/* For 2K buffers, we can reuse the page if we are the
+		 * owner. For 4K buffers, we can reuse the page if there are
+		 * no other others.
+		 */
+		if (unlikely((page_count(page) - pagecnt_bias) >
+			     pinfo->reuse_bias))
+			return false;
+	} else if (pinfo->page_offset > last_offset) {
+		return false;
+	}
+
+	/* If we have drained the page fragment pool we need to update
+	 * the pagecnt_bias and page count so that we fully restock the
+	 * number of references the driver holds.
+	 */
+	if (unlikely(pagecnt_bias == 1)) {
+		page_ref_add(page, USHRT_MAX - 1);
+		pinfo->pagecnt_bias = USHRT_MAX;
+	}
+
+	return true;
+}
+
+/**
+ * idpf_rx_frame_truesize - Returns an actual size of Rx frame in memory
+ * @buf: pointer to buffer metadata struct
+ * @size: Packet length from rx_desc
+ *
+ * Returns an actual size of Rx frame in memory, considering page size
+ * and SKB data alignment.
+ */
+static unsigned int idpf_rx_frame_truesize(struct idpf_rx_buf *buf,
+					   unsigned int size)
+{
+	return PAGE_SIZE >= 8192 ? SKB_DATA_ALIGN(size) : buf->buf_size;
+}
+
+/**
+ * idpf_rx_add_frag - Add contents of Rx buffer to sk_buff as a frag
+ * @rx_buf: buffer containing page to add
+ * @skb: sk_buff to place the data into
+ * @size: packet length from rx_desc
+ *
+ * This function will add the data contained in rx_buf->page to the skb.
+ * It will just attach the page as a frag to the skb.
+ * The function will then update the page offset.
+ */
+static void idpf_rx_add_frag(struct idpf_rx_buf *rx_buf, struct sk_buff *skb,
+			     unsigned int size)
+{
+	unsigned int truesize = idpf_rx_frame_truesize(rx_buf, size);
+	struct idpf_page_info *pinfo;
+
+	pinfo = &rx_buf->page_info[rx_buf->page_indx];
+	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, pinfo->page,
+			pinfo->page_offset, size, truesize);
+
+	idpf_rx_buf_adjust_pg(rx_buf, truesize);
+}
+
+/**
+ * idpf_rx_get_buf_page - Fetch Rx buffer page and synchronize data for use
+ * @dev: device struct
+ * @rx_buf: Rx buf to fetch page for
+ * @size: size of buffer to add to skb
+ *
+ * This function will pull an Rx buffer page from the ring and synchronize it
+ * for use by the CPU.
+ */
+static void idpf_rx_get_buf_page(struct device *dev, struct idpf_rx_buf *rx_buf,
+				 const unsigned int size)
+{
+	struct idpf_page_info *pinfo;
+
+	pinfo = &rx_buf->page_info[rx_buf->page_indx];
+
+	/* we are reusing so sync this buffer for CPU use */
+	dma_sync_single_range_for_cpu(dev, pinfo->dma,
+				      pinfo->page_offset, size,
+				      DMA_FROM_DEVICE);
+
+	/* We have pulled a buffer for use, so decrement pagecnt_bias */
+	pinfo->pagecnt_bias--;
+}
+
+/**
+ * idpf_rx_construct_skb - Allocate skb and populate it
+ * @rxq: Rx descriptor queue
+ * @rx_buf: Rx buffer to pull data from
+ * @size: the length of the packet
+ *
+ * This function allocates an skb. It then populates it with the page
+ * data from the current receive descriptor, taking care to set up the
+ * skb correctly.
+ */
+static struct sk_buff *idpf_rx_construct_skb(struct idpf_queue *rxq,
+					     struct idpf_rx_buf *rx_buf,
+					     unsigned int size)
+{
+	unsigned int headlen, truesize;
+	struct idpf_page_info *pinfo;
+	struct sk_buff *skb;
+	void *va;
+
+	pinfo = &rx_buf->page_info[rx_buf->page_indx];
+	va = page_address(pinfo->page) + pinfo->page_offset;
+
+	/* prefetch first cache line of first page */
+	net_prefetch(va);
+	/* allocate a skb to store the frags */
+	skb = __napi_alloc_skb(&rxq->q_vector->napi, IDPF_RX_HDR_SIZE,
+			       GFP_ATOMIC | __GFP_NOWARN);
+	if (unlikely(!skb))
+		return NULL;
+
+	skb_record_rx_queue(skb, rxq->idx);
+
+	/* Determine available headroom for copy */
+	headlen = size;
+	if (headlen > IDPF_RX_HDR_SIZE)
+		headlen = eth_get_headlen(skb->dev, va, IDPF_RX_HDR_SIZE);
+
+	/* align pull length to size of long to optimize memcpy performance */
+	memcpy(__skb_put(skb, headlen), va, ALIGN(headlen, sizeof(long)));
+
+	/* if we exhaust the linear part then add what is left as a frag */
+	size -= headlen;
+	if (!size) {
+		/* buffer is unused, reset bias back to rx_buf; data was copied
+		 * onto skb's linear part so there's no need for adjusting
+		 * page offset and we can reuse this buffer as-is
+		 */
+		pinfo->pagecnt_bias++;
+
+		return skb;
+	}
+
+	truesize = idpf_rx_frame_truesize(rx_buf, size);
+	skb_add_rx_frag(skb, 0, pinfo->page,
+			pinfo->page_offset + headlen, size,
+			truesize);
+	/* buffer is used by skb, update page_offset */
+	idpf_rx_buf_adjust_pg(rx_buf, truesize);
+
+	return skb;
+}
+
+/**
+ * idpf_rx_hdr_construct_skb - Allocate skb and populate it from header buffer
+ * @rxq: Rx descriptor queue
+ * @hdr_buf: Rx buffer to pull data from
+ * @size: the length of the packet
+ *
+ * This function allocates an skb. It then populates it with the page data from
+ * the current receive descriptor, taking care to set up the skb correctly.
+ * This specifically uses a header buffer to start building the skb.
+ */
+static struct sk_buff *idpf_rx_hdr_construct_skb(struct idpf_queue *rxq,
+						 struct idpf_dma_mem *hdr_buf,
+						 unsigned int size)
+{
+	struct sk_buff *skb;
+
+	/* allocate a skb to store the frags */
+	skb = __napi_alloc_skb(&rxq->q_vector->napi, size,
+			       GFP_ATOMIC | __GFP_NOWARN);
+	if (unlikely(!skb))
+		return NULL;
+
+	skb_record_rx_queue(skb, rxq->idx);
+
+	memcpy(__skb_put(skb, size), hdr_buf->va, ALIGN(size, sizeof(long)));
+
+	return skb;
+}
+
+/**
+ * idpf_rx_splitq_test_staterr - tests bits in Rx descriptor
+ * status and error fields
+ * @stat_err_field: field from descriptor to test bits in
+ * @stat_err_bits: value to mask
+ *
+ */
+static bool idpf_rx_splitq_test_staterr(const u8 stat_err_field,
+					const u8 stat_err_bits)
+{
+	return !!(stat_err_field & stat_err_bits);
+}
+
+/**
+ * idpf_rx_splitq_is_eop - process handling of EOP buffers
+ * @rx_desc: Rx descriptor for current buffer
+ *
+ * If the buffer is an EOP buffer, this function exits returning true,
+ * otherwise return false indicating that this is in fact a non-EOP buffer.
+ */
+static bool idpf_rx_splitq_is_eop(struct virtchnl2_rx_flex_desc_adv_nic_3 *rx_desc)
+{
+	/* if we are the last buffer then there is nothing else to do */
+	return likely(idpf_rx_splitq_test_staterr(rx_desc->status_err0_qw1,
+						  IDPF_RXD_EOF_SPLITQ));
+}
+
+/**
+ * idpf_rx_splitq_recycle_buf - Attempt to recycle or realloc buffer
+ * @rxbufq: receive queue
+ * @rx_buf: Rx buffer to pull data from
+ *
+ * This function will clean up the contents of the rx_buf. It will either
+ * recycle the buffer or unmap it and free the associated resources. The buffer
+ * will then be placed on a refillq where it will later be reclaimed by the
+ * corresponding bufq.
+ *
+ * This works based on page flipping. If we assume e.g., a 4k page, it will be
+ * divided into two 2k buffers. We post the first half to hardware and, after
+ * using it, flip to second half of the page with idpf_adjust_pg_offset and
+ * post that to hardware. The third time through we'll flip back to first half
+ * of page and check if stack is still using it, if not we can reuse the buffer
+ * as is, otherwise we'll drain it and get a new page.
+ */
+static void idpf_rx_splitq_recycle_buf(struct idpf_queue *rxbufq,
+				       struct idpf_rx_buf *rx_buf)
+{
+	struct idpf_page_info *pinfo = &rx_buf->page_info[rx_buf->page_indx];
+
+	if (idpf_rx_can_reuse_page(rx_buf))
+		return;
+
+	/* we are not reusing the buffer so unmap it */
+	dma_unmap_page_attrs(rxbufq->dev, pinfo->dma, PAGE_SIZE,
+			     DMA_FROM_DEVICE, IDPF_RX_DMA_ATTR);
+	__page_frag_cache_drain(pinfo->page, pinfo->pagecnt_bias);
+
+	/* clear contents of buffer_info */
+	pinfo->page = NULL;
+
+	/* It's possible the alloc can fail here but there's not much
+	 * we can do, bufq will have to try and realloc to fill the
+	 * hole.
+	 */
+	idpf_alloc_page(rxbufq, pinfo);
+}
+
+/**
+ * idpf_rx_splitq_clean - Clean completed descriptors from Rx queue
+ * @rxq: Rx descriptor queue to retrieve receive buffer queue
+ * @budget: Total limit on number of packets to process
+ *
+ * This function provides a "bounce buffer" approach to Rx interrupt
+ * processing. The advantage to this is that on systems that have
+ * expensive overhead for IOMMU access this provides a means of avoiding
+ * it by maintaining the mapping of the page to the system.
+ *
+ * Returns amount of work completed
+ */
+static int idpf_rx_splitq_clean(struct idpf_queue *rxq, int budget)
+{
+	int total_rx_bytes = 0, total_rx_pkts = 0;
+	struct idpf_queue *rx_bufq = NULL;
+	struct sk_buff *skb = rxq->skb;
+	u16 ntc = rxq->next_to_clean;
+
+	/* Process Rx packets bounded by budget */
+	while (likely(total_rx_pkts < budget)) {
+		struct virtchnl2_rx_flex_desc_adv_nic_3 *rx_desc;
+		struct idpf_sw_queue *refillq = NULL;
+		struct idpf_dma_mem *hdr_buf = NULL;
+		struct idpf_rxq_set *rxq_set = NULL;
+		struct idpf_rx_buf *rx_buf = NULL;
+		union virtchnl2_rx_desc *desc;
+		unsigned int pkt_len = 0;
+		unsigned int hdr_len = 0;
+		u16 gen_id, buf_id = 0;
+		 /* Header buffer overflow only valid for header split */
+		bool hbo = false;
+		int bufq_id;
+		u8 rxdid;
+
+		/* get the Rx desc from Rx queue based on 'next_to_clean' */
+		desc = IDPF_RX_DESC(rxq, ntc);
+		rx_desc = (struct virtchnl2_rx_flex_desc_adv_nic_3 *)desc;
+
+		/* This memory barrier is needed to keep us from reading
+		 * any other fields out of the rx_desc
+		 */
+		dma_rmb();
+
+		/* if the descriptor isn't done, no work yet to do */
+		gen_id = le16_to_cpu(rx_desc->pktlen_gen_bufq_id);
+		gen_id = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_GEN_M, gen_id);
+
+		if (test_bit(__IDPF_Q_GEN_CHK, rxq->flags) != gen_id)
+			break;
+
+		rxdid = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_RXDID_M,
+				  rx_desc->rxdid_ucast);
+		if (rxdid != VIRTCHNL2_RXDID_2_FLEX_SPLITQ) {
+			IDPF_RX_BUMP_NTC(rxq, ntc);
+			u64_stats_update_begin(&rxq->stats_sync);
+			u64_stats_inc(&rxq->q_stats.rx.bad_descs);
+			u64_stats_update_end(&rxq->stats_sync);
+			continue;
+		}
+
+		pkt_len = le16_to_cpu(rx_desc->pktlen_gen_bufq_id);
+		pkt_len = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_LEN_PBUF_M,
+				    pkt_len);
+
+		hbo = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_STATUS0_HBO_M,
+				rx_desc->status_err0_qw1);
+
+		if (unlikely(hbo)) {
+			/* If a header buffer overflow, occurs, i.e. header is
+			 * too large to fit in the header split buffer, HW will
+			 * put the entire packet, including headers, in the
+			 * data/payload buffer.
+			 */
+			u64_stats_update_begin(&rxq->stats_sync);
+			u64_stats_inc(&rxq->q_stats.rx.hsplit_buf_ovf);
+			u64_stats_update_end(&rxq->stats_sync);
+			goto bypass_hsplit;
+		}
+
+		hdr_len = le16_to_cpu(rx_desc->hdrlen_flags);
+		hdr_len = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_LEN_HDR_M,
+				    hdr_len);
+
+bypass_hsplit:
+		bufq_id = le16_to_cpu(rx_desc->pktlen_gen_bufq_id);
+		bufq_id = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_BUFQ_ID_M,
+				    bufq_id);
+
+		rxq_set = container_of(rxq, struct idpf_rxq_set, rxq);
+		if (!bufq_id)
+			refillq = rxq_set->refillq0;
+		else
+			refillq = rxq_set->refillq1;
+
+		/* retrieve buffer from the rxq */
+		rx_bufq = &rxq->rxq_grp->splitq.bufq_sets[bufq_id].bufq;
+
+		buf_id = le16_to_cpu(rx_desc->buf_id);
+
+		if (pkt_len) {
+			rx_buf = &rx_bufq->rx_buf.buf[buf_id];
+			idpf_rx_get_buf_page(rx_bufq->dev, rx_buf, pkt_len);
+		}
+
+		if (hdr_len) {
+			hdr_buf = rx_bufq->rx_buf.hdr_buf[buf_id];
+
+			dma_sync_single_for_cpu(rxq->dev, hdr_buf->pa, hdr_buf->size,
+						DMA_FROM_DEVICE);
+
+			skb = idpf_rx_hdr_construct_skb(rxq, hdr_buf, hdr_len);
+			u64_stats_update_begin(&rxq->stats_sync);
+			u64_stats_inc(&rxq->q_stats.rx.hsplit_pkts);
+			u64_stats_update_end(&rxq->stats_sync);
+		}
+
+		if (pkt_len) {
+			if (skb)
+				idpf_rx_add_frag(rx_buf, skb, pkt_len);
+			else
+				skb = idpf_rx_construct_skb(rxq, rx_buf,
+							    pkt_len);
+		}
+
+		/* exit if we failed to retrieve a buffer */
+		if (!skb) {
+			/* If we fetched a buffer, but didn't use it
+			 * undo pagecnt_bias decrement
+			 */
+			if (rx_buf)
+				rx_buf->page_info[rx_buf->page_indx].pagecnt_bias++;
+			break;
+		}
+
+		if (rx_buf)
+			idpf_rx_splitq_recycle_buf(rx_bufq, rx_buf);
+		idpf_rx_post_buf_refill(refillq, buf_id);
+
+		IDPF_RX_BUMP_NTC(rxq, ntc);
+		/* skip if it is non EOP desc */
+		if (!idpf_rx_splitq_is_eop(rx_desc))
+			continue;
+
+		/* pad skb if needed (to make valid ethernet frame) */
+		if (eth_skb_pad(skb)) {
+			skb = NULL;
+			continue;
+		}
+
+		/* probably a little skewed due to removing CRC */
+		total_rx_bytes += skb->len;
+
+		/* protocol */
+		if (unlikely(idpf_rx_process_skb_fields(rxq, skb, rx_desc))) {
+			dev_kfree_skb_any(skb);
+			skb = NULL;
+			continue;
+		}
+
+		/* send completed skb up the stack */
+		napi_gro_receive(&rxq->q_vector->napi, skb);
+		skb = NULL;
+
+		/* update budget accounting */
+		total_rx_pkts++;
+	}
+
+	rxq->next_to_clean = ntc;
+
+	rxq->skb = skb;
+	u64_stats_update_begin(&rxq->stats_sync);
+	u64_stats_add(&rxq->q_stats.rx.packets, total_rx_pkts);
+	u64_stats_add(&rxq->q_stats.rx.bytes, total_rx_bytes);
+	u64_stats_update_end(&rxq->stats_sync);
+
+	/* guarantee a trip back through this routine if there was a failure */
+	return total_rx_pkts;
+}
+
+/**
+ * idpf_rx_update_bufq_desc - Update buffer queue descriptor
+ * @bufq: Pointer to the buffer queue
+ * @refill_desc: SW Refill queue descriptor containing buffer ID
+ * @buf_desc: Buffer queue descriptor
+ *
+ * Return 0 on success and negative on failure.
+ */
+static int idpf_rx_update_bufq_desc(struct idpf_queue *bufq, u16 refill_desc,
+				    struct virtchnl2_splitq_rx_buf_desc *buf_desc)
+{
+	struct idpf_page_info *pinfo;
+	struct idpf_dma_mem *hdr_buf;
+	struct idpf_rx_buf *buf;
+	u16 buf_id;
+
+	buf_id = FIELD_GET(IDPF_RX_BI_BUFID_M, refill_desc);
+
+	buf = &bufq->rx_buf.buf[buf_id];
+	pinfo = &buf->page_info[buf->page_indx];
+
+	/* It's possible page alloc failed during rxq clean, try to
+	 * recover here.
+	 */
+	if (unlikely(!pinfo->page && idpf_alloc_page(bufq, pinfo)))
+		return -ENOMEM;
+
+	dma_sync_single_range_for_device(bufq->dev, pinfo->dma,
+					 pinfo->page_offset,
+					 bufq->rx_buf_size,
+					 DMA_FROM_DEVICE);
+	buf_desc->pkt_addr =
+		cpu_to_le64(pinfo->dma + pinfo->page_offset);
+	buf_desc->qword0.buf_id = cpu_to_le16(buf_id);
+
+	if (!bufq->rx_hsplit_en)
+		return 0;
+
+	hdr_buf = bufq->rx_buf.hdr_buf[buf_id];
+	buf_desc->hdr_addr = cpu_to_le64(hdr_buf->pa);
+
+	dma_sync_single_for_device(bufq->dev, hdr_buf->pa,
+				   hdr_buf->size, DMA_FROM_DEVICE);
+
+	return 0;
+}
+
+/**
+ * idpf_rx_clean_refillq - Clean refill queue buffers
+ * @bufq: buffer queue to post buffers back to
+ * @refillq: refill queue to clean
+ *
+ * This function takes care of the buffer refill management
+ */
+static void idpf_rx_clean_refillq(struct idpf_queue *bufq,
+				  struct idpf_sw_queue *refillq)
+{
+	struct virtchnl2_splitq_rx_buf_desc *buf_desc;
+	u16 bufq_nta = bufq->next_to_alloc;
+	u16 ntc = refillq->next_to_clean;
+	int cleaned = 0;
+	u16 gen;
+
+	buf_desc = IDPF_SPLITQ_RX_BUF_DESC(bufq, bufq_nta);
+
+	/* make sure we stop at ring wrap in the unlikely case ring is full */
+	while (likely(cleaned < refillq->desc_count)) {
+		u16 refill_desc = IDPF_SPLITQ_RX_BI_DESC(refillq, ntc);
+		bool failure;
+
+		gen = FIELD_GET(IDPF_RX_BI_GEN_M, refill_desc);
+		if (test_bit(__IDPF_RFLQ_GEN_CHK, refillq->flags) != gen)
+			break;
+
+		failure = idpf_rx_update_bufq_desc(bufq, refill_desc,
+						   buf_desc);
+		if (failure)
+			break;
+
+		if (unlikely(++ntc == refillq->desc_count)) {
+			change_bit(__IDPF_RFLQ_GEN_CHK, refillq->flags);
+			ntc = 0;
+		}
+
+		if (unlikely(++bufq_nta == bufq->desc_count)) {
+			buf_desc = IDPF_SPLITQ_RX_BUF_DESC(bufq, 0);
+			bufq_nta = 0;
+		} else {
+			buf_desc++;
+		}
+
+		cleaned++;
+	}
+
+	if (!cleaned)
+		return;
+
+	/* We want to limit how many transactions on the bus we trigger with
+	 * tail writes so we only do it in strides. It's also important we
+	 * align the write to a multiple of 8 as required by HW.
+	 */
+	if (((bufq->next_to_use <= bufq_nta ? 0 : bufq->desc_count) +
+	    bufq_nta - bufq->next_to_use) >= IDPF_RX_BUF_POST_STRIDE)
+		idpf_rx_buf_hw_update(bufq, ALIGN_DOWN(bufq_nta,
+						       IDPF_RX_BUF_POST_STRIDE));
+
+	/* update next to alloc since we have filled the ring */
+	refillq->next_to_clean = ntc;
+	bufq->next_to_alloc = bufq_nta;
+}
+
+/**
+ * idpf_rx_clean_refillq_all - Clean all refill queues
+ * @bufq: buffer queue with refill queues
+ *
+ * Iterates through all refill queues assigned to the buffer queue assigned to
+ * this vector.  Returns true if clean is complete within budget, false
+ * otherwise.
+ */
+static void idpf_rx_clean_refillq_all(struct idpf_queue *bufq)
+{
+	struct idpf_bufq_set *bufq_set;
+	int i;
+
+	bufq_set = container_of(bufq, struct idpf_bufq_set, bufq);
+	for (i = 0; i < bufq_set->num_refillqs; i++)
+		idpf_rx_clean_refillq(bufq, &bufq_set->refillqs[i]);
+}
+
 /**
  * idpf_vport_intr_clean_queues - MSIX mode Interrupt Handler
  * @irq: interrupt number
@@ -2972,7 +3861,7 @@ static void idpf_net_dim(struct idpf_q_vector *q_vector)
 	u32 i;
 
 	if (!IDPF_ITR_IS_DYNAMIC(q_vector->tx_intr_mode))
-		return;
+		goto check_rx_itr;
 
 	for (i = 0, packets = 0, bytes = 0; i < q_vector->num_txq; i++) {
 		struct idpf_queue *txq = q_vector->tx[i];
@@ -2988,6 +3877,25 @@ static void idpf_net_dim(struct idpf_q_vector *q_vector)
 	idpf_update_dim_sample(q_vector, &dim_sample, &q_vector->tx_dim,
 			       packets, bytes);
 	net_dim(&q_vector->tx_dim, dim_sample);
+
+check_rx_itr:
+	if (!IDPF_ITR_IS_DYNAMIC(q_vector->rx_intr_mode))
+		return;
+
+	for (i = 0, packets = 0, bytes = 0; i < q_vector->num_rxq; i++) {
+		struct idpf_queue *rxq = q_vector->rx[i];
+		unsigned int start;
+
+		do {
+			start = u64_stats_fetch_begin(&rxq->stats_sync);
+			packets += u64_stats_read(&rxq->q_stats.rx.packets);
+			bytes += u64_stats_read(&rxq->q_stats.rx.bytes);
+		} while (u64_stats_fetch_retry(&rxq->stats_sync, start));
+	}
+
+	idpf_update_dim_sample(q_vector, &dim_sample, &q_vector->rx_dim,
+			       packets, bytes);
+	net_dim(&q_vector->rx_dim, dim_sample);
 }
 
 /**
@@ -3105,7 +4013,15 @@ static void idpf_vport_intr_ena_irq_all(struct idpf_vport *vport)
 						  true);
 		}
 
-		if (qv->num_txq)
+		if (qv->num_rxq) {
+			dynamic = IDPF_ITR_IS_DYNAMIC(qv->rx_intr_mode);
+			itr = vport->rx_itr_profile[qv->rx_dim.profile_ix];
+			idpf_vport_intr_write_itr(qv, dynamic ?
+						  itr : qv->rx_itr_value,
+						  false);
+		}
+
+		if (qv->num_txq || qv->num_rxq)
 			idpf_vport_intr_update_itr_ena_irq(qv);
 	}
 }
@@ -3148,6 +4064,32 @@ static void idpf_tx_dim_work(struct work_struct *work)
 	dim->state = DIM_START_MEASURE;
 }
 
+/**
+ * idpf_rx_dim_work - Call back from the stack
+ * @work: work queue structure
+ */
+static void idpf_rx_dim_work(struct work_struct *work)
+{
+	struct idpf_q_vector *q_vector;
+	struct idpf_vport *vport;
+	struct dim *dim;
+	u16 itr;
+
+	dim = container_of(work, struct dim, work);
+	q_vector = container_of(dim, struct idpf_q_vector, rx_dim);
+	vport = q_vector->vport;
+
+	if (dim->profile_ix >= ARRAY_SIZE(vport->rx_itr_profile))
+		dim->profile_ix = ARRAY_SIZE(vport->rx_itr_profile) - 1;
+
+	/* look up the values in our local table */
+	itr = vport->rx_itr_profile[dim->profile_ix];
+
+	idpf_vport_intr_write_itr(q_vector, itr, false);
+
+	dim->state = DIM_START_MEASURE;
+}
+
 /**
  * idpf_init_dim - Set up dynamic interrupt moderation
  * @qv: q_vector structure
@@ -3157,6 +4099,10 @@ static void idpf_init_dim(struct idpf_q_vector *qv)
 	INIT_WORK(&qv->tx_dim.work, idpf_tx_dim_work);
 	qv->tx_dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
 	qv->tx_dim.profile_ix = IDPF_DIM_DEFAULT_PROFILE_IX;
+
+	INIT_WORK(&qv->rx_dim.work, idpf_rx_dim_work);
+	qv->rx_dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+	qv->rx_dim.profile_ix = IDPF_DIM_DEFAULT_PROFILE_IX;
 }
 
 /**
@@ -3204,6 +4150,44 @@ static bool idpf_tx_splitq_clean_all(struct idpf_q_vector *q_vec,
 	return clean_complete;
 }
 
+/**
+ * idpf_rx_splitq_clean_all- Clean completion queues
+ * @q_vec: queue vector
+ * @budget: Used to determine if we are in netpoll
+ * @cleaned: returns number of packets cleaned
+ *
+ * Returns false if clean is not complete else returns true
+ */
+static bool idpf_rx_splitq_clean_all(struct idpf_q_vector *q_vec, int budget,
+				     int *cleaned)
+{
+	int num_rxq = q_vec->num_rxq;
+	bool clean_complete = true;
+	int pkts_cleaned = 0;
+	int i, budget_per_q;
+
+	/* We attempt to distribute budget to each Rx queue fairly, but don't
+	 * allow the budget to go below 1 because that would exit polling early.
+	 */
+	budget_per_q = num_rxq ? max(budget / num_rxq, 1) : 0;
+	for (i = 0; i < num_rxq; i++) {
+		struct idpf_queue *rxq = q_vec->rx[i];
+		int pkts_cleaned_per_q;
+
+		pkts_cleaned_per_q = idpf_rx_splitq_clean(rxq, budget_per_q);
+		/* if we clean as many as budgeted, we must not be done */
+		if (pkts_cleaned_per_q >= budget_per_q)
+			clean_complete = false;
+		pkts_cleaned += pkts_cleaned_per_q;
+	}
+	*cleaned = pkts_cleaned;
+
+	for (i = 0; i < q_vec->num_bufq; i++)
+		idpf_rx_clean_refillq_all(q_vec->bufq[i]);
+
+	return clean_complete;
+}
+
 /**
  * idpf_vport_splitq_napi_poll - NAPI handler
  * @napi: struct from which you get q_vector
@@ -3223,7 +4207,8 @@ static int idpf_vport_splitq_napi_poll(struct napi_struct *napi, int budget)
 		return 0;
 	}
 
-	clean_complete = idpf_tx_splitq_clean_all(q_vector, budget, &work_done);
+	clean_complete = idpf_rx_splitq_clean_all(q_vector, budget, &work_done);
+	clean_complete &= idpf_tx_splitq_clean_all(q_vector, budget, &work_done);
 
 	/* If work not completed, return budget and polling will return */
 	if (!clean_complete)
@@ -3577,7 +4562,6 @@ int idpf_init_rss(struct idpf_vport *vport)
 /**
  * idpf_deinit_rss - Release RSS resources
  * @vport: virtual port
- *
  */
 void idpf_deinit_rss(struct idpf_vport *vport)
 {
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.h b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
index 83f802b06bb9..e24339da9035 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
@@ -62,10 +62,21 @@
 
 #define IDPF_RX_BUFQ_WORKING_SET(rxq)		((rxq)->desc_count - 1)
 
+#define IDPF_RX_BUMP_NTC(rxq, ntc)				\
+do {								\
+	if (unlikely(++(ntc) == (rxq)->desc_count)) {		\
+		ntc = 0;					\
+		change_bit(__IDPF_Q_GEN_CHK, (rxq)->flags);	\
+	}							\
+} while (0)
+
+#define IDPF_RX_HDR_SIZE			256
 #define IDPF_RX_BUF_2048			2048
 #define IDPF_RX_BUF_4096			4096
 #define IDPF_RX_BUF_STRIDE			32
+#define IDPF_RX_BUF_POST_STRIDE			16
 #define IDPF_LOW_WATERMARK			64
+/* Size of header buffer specifically for header split */
 #define IDPF_HDR_BUF_SIZE			256
 #define IDPF_PACKET_HDR_PAD	\
 	(ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN * 2)
@@ -75,10 +86,18 @@
  */
 #define IDPF_TX_SPLITQ_RE_MIN_GAP	64
 
+#define IDPF_RX_BI_BUFID_S		0
+#define IDPF_RX_BI_BUFID_M		GENMASK(14, 0)
+#define IDPF_RX_BI_GEN_S		15
+#define IDPF_RX_BI_GEN_M		BIT(IDPF_RX_BI_GEN_S)
+#define IDPF_RXD_EOF_SPLITQ		VIRTCHNL2_RX_FLEX_DESC_ADV_STATUS0_EOF_M
+#define IDPF_RXD_EOF_SINGLEQ		BIT(VIRTCHNL2_RX_BASE_DESC_STATUS_EOF_S)
+
 #define IDPF_SINGLEQ_RX_BUF_DESC(rxq, i)	\
 	(&(((struct virtchnl2_singleq_rx_buf_desc *)((rxq)->desc_ring))[i]))
 #define IDPF_SPLITQ_RX_BUF_DESC(rxq, i)	\
 	(&(((struct virtchnl2_splitq_rx_buf_desc *)((rxq)->desc_ring))[i]))
+#define IDPF_SPLITQ_RX_BI_DESC(rxq, i) ((((rxq)->ring))[i])
 
 #define IDPF_SPLITQ_TX_COMPLQ_DESC(txcq, i)	\
 	(&(((struct idpf_splitq_tx_compl_desc *)((txcq)->desc_ring))[i]))
@@ -184,6 +203,20 @@ struct idpf_tx_splitq_params {
 	struct idpf_tx_offload_params offload;
 };
 
+/* Checksum offload bits decoded from the receive descriptor. */
+struct idpf_rx_csum_decoded {
+	u32 l3l4p : 1;
+	u32 ipe : 1;
+	u32 eipe : 1;
+	u32 eudpe : 1;
+	u32 ipv6exadd : 1;
+	u32 l4e : 1;
+	u32 pprs : 1;
+	u32 nat : 1;
+	u32 raw_csum_inv : 1;
+	u32 raw_csum : 16;
+};
+
 #define IDPF_TX_COMPLQ_CLEAN_BUDGET	256
 #define IDPF_TX_MIN_PKT_LEN		17
 #define IDPF_TX_DESCS_FOR_SKB_DATA_PTR	1
@@ -206,6 +239,8 @@ struct idpf_tx_splitq_params {
 
 #define IDPF_RX_DMA_ATTR \
 	(DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
+#define IDPF_RX_DESC(rxq, i)	\
+	(&(((union virtchnl2_rx_desc *)((rxq)->desc_ring))[i]))
 
 struct idpf_page_info {
 	dma_addr_t dma;
@@ -225,6 +260,7 @@ struct idpf_rx_buf {
 	struct idpf_page_info page_info[IDPF_RX_BUF_MAX_PAGES];
 	u8 page_indx;
 	u16 buf_size;
+	struct sk_buff *skb;
 };
 
 #define IDPF_GET_PTYPE_SIZE(p) struct_size((p), proto_id, (p)->proto_id_count)
@@ -263,6 +299,10 @@ enum idpf_rx_ptype_outer_ip {
 	IDPF_RX_PTYPE_OUTER_IP	= 1,
 };
 
+#define IDPF_RX_PTYPE_TO_IPV(ptype, ipv)			\
+	(((ptype)->outer_ip == IDPF_RX_PTYPE_OUTER_IP) &&	\
+	 ((ptype)->outer_ip_ver == (ipv)))
+
 enum idpf_rx_ptype_outer_ip_ver {
 	IDPF_RX_PTYPE_OUTER_NONE	= 0,
 	IDPF_RX_PTYPE_OUTER_IPV4	= 1,
@@ -387,6 +427,7 @@ struct idpf_q_vector {
 
 	int num_rxq;
 	struct idpf_queue **rx;
+	struct dim rx_dim;	/* data for net_dim algorithm */
 	u16 rx_itr_value;
 	bool rx_intr_mode;
 	u32 rx_itr_idx;
@@ -399,7 +440,13 @@ struct idpf_q_vector {
 };
 
 struct idpf_rx_queue_stats {
-	/* stub */
+	u64_stats_t packets;
+	u64_stats_t bytes;
+	u64_stats_t rsc_pkts;
+	u64_stats_t hw_csum_err;
+	u64_stats_t hsplit_pkts;
+	u64_stats_t hsplit_buf_ovf;
+	u64_stats_t bad_descs;
 };
 
 struct idpf_tx_queue_stats {
@@ -569,9 +616,10 @@ struct idpf_queue {
  * lockless buffer management system and are strictly software only constructs.
  */
 struct idpf_sw_queue {
-	DECLARE_BITMAP(flags, __IDPF_Q_FLAGS_NBITS)
-		____cacheline_aligned_in_smp;
-	u16 *ring ____cacheline_aligned_in_smp;
+	u16 next_to_clean;
+	u16 next_to_alloc;
+	DECLARE_BITMAP(flags, __IDPF_Q_FLAGS_NBITS);
+	u16 *ring;
 	u16 desc_count;
 	u16 buf_size;
 	struct device *dev;
diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
index 07c7a3d30bb8..4215ec8f97a3 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -2903,6 +2903,7 @@ void idpf_vport_init(struct idpf_vport *vport, struct idpf_vport_max_q *max_q)
 	struct virtchnl2_create_vport *vport_msg;
 	struct idpf_vport_config *vport_config;
 	u16 tx_itr[] = {2, 8, 64, 128, 256};
+	u16 rx_itr[] = {2, 8, 32, 96, 128};
 	struct idpf_rss_data *rss_data;
 	u16 idx = vport->idx;
 
@@ -2928,7 +2929,8 @@ void idpf_vport_init(struct idpf_vport *vport, struct idpf_vport_max_q *max_q)
 	ether_addr_copy(vport->default_mac_addr, vport_msg->default_mac_addr);
 	vport->max_mtu = le16_to_cpu(vport_msg->max_mtu) - IDPF_PACKET_HDR_PAD;
 
-	/* Initialize Tx profiles for Dynamic Interrupt Moderation */
+	/* Initialize Tx and Rx profiles for Dynamic Interrupt Moderation */
+	memcpy(vport->rx_itr_profile, rx_itr, IDPF_DIM_PROFILE_SLOTS);
 	memcpy(vport->tx_itr_profile, tx_itr, IDPF_DIM_PROFILE_SLOTS);
 
 	idpf_vport_init_num_qs(vport, vport_msg);
-- 
2.37.3


