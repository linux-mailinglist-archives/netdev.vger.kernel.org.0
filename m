Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5828A55EE57
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbiF1Txy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232578AbiF1TvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:51:05 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4C72E680;
        Tue, 28 Jun 2022 12:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445800; x=1687981800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0nbuFAJnH5Qg7FZsjjoFUa+z8pMZ1fWuCJ5sB2mHG5A=;
  b=DI94SPraJQB1FhLKbqBurr2T74D6FJ+tEay4BJR9P/uLexM4dkazqrQB
   AJm030C/gk5QYl5VV/8DZoRBsMCIS/tYfRARAL5orulXmlNnh6x6BSpcK
   m2DIIsUpSFX+oHqArcNURIahvx34lRdjR6EfOZR53C7FeSOd5/Bx7srDc
   gK7/7ZHTYrZq9M9DmmS6u7O2iq9JWwqHJfoeN8ya8p7G8eveubtNmDs9T
   RxT4f2aSTV4ZxaJIFi7P+1hTH8cg/sRiVU4ujLdrNQS6s6V8MroNSwRHe
   LrGtZZePXwaPnAFyKFf/Qm0beqjn/hO2E0GROX+xqCk7WywBMChUqEmLu
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="282568323"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="282568323"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:50:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="836809549"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 28 Jun 2022 12:49:55 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9j022013;
        Tue, 28 Jun 2022 20:49:53 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 45/52] net, ice: consolidate all skb fields processing
Date:   Tue, 28 Jun 2022 21:48:05 +0200
Message-Id: <20220628194812.1453059-46-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For now, skb fields filling is scattered across RQ / XSK RQ polling
function. Make it consistent and do everything in
ice_process_skb_fields().
Obtaining @vlan_tag and @rx_ptype can be moved in there too, there
is no reason to do it outside. ice_receive_skb() now becomes just
a standard pair of eth_type_trans() + napi_gro_receive(), make it
static inline to save a couple redundant jumps.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 19 +----
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 81 +++++++++----------
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h | 25 +++++-
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 11 +--
 4 files changed, 65 insertions(+), 71 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 25383bbf8245..ffea5138a7e8 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -949,11 +949,6 @@ ice_build_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 	if (unlikely(!skb))
 		return NULL;
 
-	/* must to record Rx queue, otherwise OS features such as
-	 * symmetric queue won't work
-	 */
-	skb_record_rx_queue(skb, rx_ring->q_index);
-
 	/* update pointers within the skb to store the data */
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	__skb_put(skb, xdp->data_end - xdp->data);
@@ -995,7 +990,6 @@ ice_construct_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 	if (unlikely(!skb))
 		return NULL;
 
-	skb_record_rx_queue(skb, rx_ring->q_index);
 	/* Determine available headroom for copy */
 	headlen = size;
 	if (headlen > ICE_RX_HDR_SIZE)
@@ -1134,8 +1128,6 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		unsigned int size;
 		u16 stat_err_bits;
 		int rx_buf_pgcnt;
-		u16 vlan_tag = 0;
-		u16 rx_ptype;
 
 		/* get the Rx desc from Rx ring based on 'next_to_clean' */
 		rx_desc = ICE_RX_DESC(rx_ring, rx_ring->next_to_clean);
@@ -1238,8 +1230,6 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 			continue;
 		}
 
-		vlan_tag = ice_get_vlan_tag_from_rx_desc(rx_desc);
-
 		/* pad the skb if needed, to make a valid ethernet frame */
 		if (eth_skb_pad(skb)) {
 			skb = NULL;
@@ -1249,15 +1239,10 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		/* probably a little skewed due to removing CRC */
 		total_rx_bytes += skb->len;
 
-		/* populate checksum, VLAN, and protocol */
-		rx_ptype = le16_to_cpu(rx_desc->wb.ptype_flex_flags0) &
-			ICE_RX_FLEX_DESC_PTYPE_M;
-
-		ice_process_skb_fields(rx_ring, rx_desc, skb, rx_ptype);
+		ice_process_skb_fields(rx_ring, rx_desc, skb);
 
 		ice_trace(clean_rx_irq_indicate, rx_ring, rx_desc, skb);
-		/* send completed skb up the stack */
-		ice_receive_skb(rx_ring, skb, vlan_tag);
+		ice_receive_skb(rx_ring, skb);
 		skb = NULL;
 
 		/* update budget accounting */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 7ee38d02d1e5..92c001baa2cc 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -40,16 +40,15 @@ void ice_release_rx_desc(struct ice_rx_ring *rx_ring, u16 val)
 
 /**
  * ice_ptype_to_htype - get a hash type
- * @ptype: the ptype value from the descriptor
+ * @decoded: the decoded ptype value from the descriptor
  *
  * Returns appropriate hash type (such as PKT_HASH_TYPE_L2/L3/L4) to be used by
  * skb_set_hash based on PTYPE as parsed by HW Rx pipeline and is part of
  * Rx desc.
  */
-static enum pkt_hash_types ice_ptype_to_htype(u16 ptype)
+static enum pkt_hash_types
+ice_ptype_to_htype(struct ice_rx_ptype_decoded decoded)
 {
-	struct ice_rx_ptype_decoded decoded = ice_decode_rx_desc_ptype(ptype);
-
 	if (!decoded.known)
 		return PKT_HASH_TYPE_NONE;
 	if (decoded.payload_layer == ICE_RX_PTYPE_PAYLOAD_LAYER_PAY4)
@@ -67,11 +66,11 @@ static enum pkt_hash_types ice_ptype_to_htype(u16 ptype)
  * @rx_ring: descriptor ring
  * @rx_desc: specific descriptor
  * @skb: pointer to current skb
- * @rx_ptype: the ptype value from the descriptor
+ * @decoded: the decoded ptype value from the descriptor
  */
 static void
 ice_rx_hash(struct ice_rx_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
-	    struct sk_buff *skb, u16 rx_ptype)
+	    struct sk_buff *skb, struct ice_rx_ptype_decoded decoded)
 {
 	struct ice_32b_rx_flex_desc_nic *nic_mdid;
 	u32 hash;
@@ -84,7 +83,7 @@ ice_rx_hash(struct ice_rx_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
 
 	nic_mdid = (struct ice_32b_rx_flex_desc_nic *)rx_desc;
 	hash = le32_to_cpu(nic_mdid->rss_hash);
-	skb_set_hash(skb, hash, ice_ptype_to_htype(rx_ptype));
+	skb_set_hash(skb, hash, ice_ptype_to_htype(decoded));
 }
 
 /**
@@ -92,23 +91,21 @@ ice_rx_hash(struct ice_rx_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
  * @ring: the ring we care about
  * @skb: skb currently being received and modified
  * @rx_desc: the receive descriptor
- * @ptype: the packet type decoded by hardware
+ * @decoded: the decoded packet type parsed by hardware
  *
  * skb->protocol must be set before this function is called
  */
 static void
 ice_rx_csum(struct ice_rx_ring *ring, struct sk_buff *skb,
-	    union ice_32b_rx_flex_desc *rx_desc, u16 ptype)
+	    union ice_32b_rx_flex_desc *rx_desc,
+	    struct ice_rx_ptype_decoded decoded)
 {
-	struct ice_rx_ptype_decoded decoded;
 	u16 rx_status0, rx_status1;
 	bool ipv4, ipv6;
 
 	rx_status0 = le16_to_cpu(rx_desc->wb.status_error0);
 	rx_status1 = le16_to_cpu(rx_desc->wb.status_error1);
 
-	decoded = ice_decode_rx_desc_ptype(ptype);
-
 	/* Start with CHECKSUM_NONE and by default csum_level = 0 */
 	skb->ip_summed = CHECKSUM_NONE;
 	skb_checksum_none_assert(skb);
@@ -170,12 +167,31 @@ ice_rx_csum(struct ice_rx_ring *ring, struct sk_buff *skb,
 	ring->vsi->back->hw_csum_rx_error++;
 }
 
+static void ice_rx_vlan(struct sk_buff *skb,
+			const struct ice_rx_ring *rx_ring,
+			const union ice_32b_rx_flex_desc *rx_desc)
+{
+	netdev_features_t features = rx_ring->netdev->features;
+	bool non_zero_vlan;
+	u16 vlan_tag;
+
+	vlan_tag = ice_get_vlan_tag_from_rx_desc(rx_desc);
+	non_zero_vlan = !!(vlan_tag & VLAN_VID_MASK);
+
+	if (!non_zero_vlan)
+		return;
+
+	if ((features & NETIF_F_HW_VLAN_CTAG_RX))
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tag);
+	else if ((features & NETIF_F_HW_VLAN_STAG_RX))
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021AD), vlan_tag);
+}
+
 /**
  * ice_process_skb_fields - Populate skb header fields from Rx descriptor
  * @rx_ring: Rx descriptor ring packet is being transacted on
  * @rx_desc: pointer to the EOP Rx descriptor
  * @skb: pointer to current skb being populated
- * @ptype: the packet type decoded by hardware
  *
  * This function checks the ring, descriptor, and packet information in
  * order to populate the hash, checksum, VLAN, protocol, and
@@ -184,42 +200,25 @@ ice_rx_csum(struct ice_rx_ring *ring, struct sk_buff *skb,
 void
 ice_process_skb_fields(struct ice_rx_ring *rx_ring,
 		       union ice_32b_rx_flex_desc *rx_desc,
-		       struct sk_buff *skb, u16 ptype)
+		       struct sk_buff *skb)
 {
-	ice_rx_hash(rx_ring, rx_desc, skb, ptype);
+	struct ice_rx_ptype_decoded decoded;
+	u16 ptype;
 
-	/* modifies the skb - consumes the enet header */
-	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
+	skb_record_rx_queue(skb, rx_ring->q_index);
 
-	ice_rx_csum(rx_ring, skb, rx_desc, ptype);
+	ptype = le16_to_cpu(rx_desc->wb.ptype_flex_flags0) &
+		ICE_RX_FLEX_DESC_PTYPE_M;
+	decoded = ice_decode_rx_desc_ptype(ptype);
+
+	ice_rx_hash(rx_ring, rx_desc, skb, decoded);
+	ice_rx_csum(rx_ring, skb, rx_desc, decoded);
+	ice_rx_vlan(skb, rx_ring, rx_desc);
 
 	if (rx_ring->ptp_rx)
 		ice_ptp_rx_hwtstamp(rx_ring, rx_desc, skb);
 }
 
-/**
- * ice_receive_skb - Send a completed packet up the stack
- * @rx_ring: Rx ring in play
- * @skb: packet to send up
- * @vlan_tag: VLAN tag for packet
- *
- * This function sends the completed packet (via. skb) up the stack using
- * gro receive functions (with/without VLAN tag)
- */
-void
-ice_receive_skb(struct ice_rx_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag)
-{
-	netdev_features_t features = rx_ring->netdev->features;
-	bool non_zero_vlan = !!(vlan_tag & VLAN_VID_MASK);
-
-	if ((features & NETIF_F_HW_VLAN_CTAG_RX) && non_zero_vlan)
-		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tag);
-	else if ((features & NETIF_F_HW_VLAN_STAG_RX) && non_zero_vlan)
-		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021AD), vlan_tag);
-
-	napi_gro_receive(&rx_ring->q_vector->napi, skb);
-}
-
 /**
  * ice_clean_xdp_irq - Reclaim resources after transmit completes on XDP ring
  * @xdp_ring: XDP ring to clean
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
index c7d2954dc9ea..45dc5ef79e28 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
@@ -40,7 +40,7 @@ ice_build_ctob(u64 td_cmd, u64 td_offset, unsigned int size, u64 td_tag)
  * one is found return the tag, else return 0 to mean no VLAN tag was found.
  */
 static inline u16
-ice_get_vlan_tag_from_rx_desc(union ice_32b_rx_flex_desc *rx_desc)
+ice_get_vlan_tag_from_rx_desc(const union ice_32b_rx_flex_desc *rx_desc)
 {
 	u16 stat_err_bits;
 
@@ -55,6 +55,24 @@ ice_get_vlan_tag_from_rx_desc(union ice_32b_rx_flex_desc *rx_desc)
 	return 0;
 }
 
+/**
+ * ice_receive_skb - Send a completed packet up the stack
+ * @rx_ring: Rx ring in play
+ * @skb: packet to send up
+ *
+ * This function sends the completed packet (via. skb) up the stack using
+ * gro receive functions
+ */
+static inline void ice_receive_skb(const struct ice_rx_ring *rx_ring,
+				   struct sk_buff *skb)
+{
+	/* modifies the skb - consumes the enet header */
+	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
+
+	/* send completed skb up the stack */
+	napi_gro_receive(&rx_ring->q_vector->napi, skb);
+}
+
 /**
  * ice_xdp_ring_update_tail - Updates the XDP Tx ring tail register
  * @xdp_ring: XDP Tx ring
@@ -77,7 +95,6 @@ void ice_release_rx_desc(struct ice_rx_ring *rx_ring, u16 val);
 void
 ice_process_skb_fields(struct ice_rx_ring *rx_ring,
 		       union ice_32b_rx_flex_desc *rx_desc,
-		       struct sk_buff *skb, u16 ptype);
-void
-ice_receive_skb(struct ice_rx_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag);
+		       struct sk_buff *skb);
+
 #endif /* !_ICE_TXRX_LIB_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index eb994cf68ff4..0a66128964e7 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -606,8 +606,6 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 		struct xdp_buff *xdp;
 		struct sk_buff *skb;
 		u16 stat_err_bits;
-		u16 vlan_tag = 0;
-		u16 rx_ptype;
 
 		rx_desc = ICE_RX_DESC(rx_ring, rx_ring->next_to_clean);
 
@@ -675,13 +673,8 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 		total_rx_bytes += skb->len;
 		total_rx_packets++;
 
-		vlan_tag = ice_get_vlan_tag_from_rx_desc(rx_desc);
-
-		rx_ptype = le16_to_cpu(rx_desc->wb.ptype_flex_flags0) &
-				       ICE_RX_FLEX_DESC_PTYPE_M;
-
-		ice_process_skb_fields(rx_ring, rx_desc, skb, rx_ptype);
-		ice_receive_skb(rx_ring, skb, vlan_tag);
+		ice_process_skb_fields(rx_ring, rx_desc, skb);
+		ice_receive_skb(rx_ring, skb);
 	}
 
 	entries_to_alloc = ICE_DESC_UNUSED(rx_ring);
-- 
2.36.1

