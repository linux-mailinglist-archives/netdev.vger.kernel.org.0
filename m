Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3CB55EEAC
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbiF1Txx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbiF1TvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:51:04 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3F32C66A;
        Tue, 28 Jun 2022 12:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445801; x=1687981801;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RMjkP7N3C2aO9AK8761DdIt9FB/kHYV8pUPcGpDSf7k=;
  b=asWFRFcFARiYjK9mBun5GPp/WU1aL9x0NAjxChHdkWpYS8tnMzH2I1Ja
   MCts2qnENZPjl/RRd2iFFxTW2ZNi5Xkpm/heSqn0pRHmOVZdtcIR4d3N/
   C8/yP+vH/y4Nmi9VagoZIG8Hs6lsvYSThpOkwFLmQ7cnpGow9V6tzPOAz
   Qz2fRSPhd15GVNveVkgp12Mv8qs5ZdK5y4NqSTMpYax6hrCZDNBxLANIg
   MIr1dzOovf7XQhEH77gRG8iP9wpEM4B8HJgtaooWJc2RTu96xx38MERCi
   Afv1cswgGJMYJn7Qh6lex3Jbw41MYSOaUcToor/6GHyBUstu0i6lKcp71
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="280596055"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="280596055"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:50:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="594927668"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 28 Jun 2022 12:49:57 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9k022013;
        Tue, 28 Jun 2022 20:49:55 +0100
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
Subject: [PATCH RFC bpf-next 46/52] net, ice: use an onstack &xdp_meta_generic_rx to store HW frame info
Date:   Tue, 28 Jun 2022 21:48:06 +0200
Message-Id: <20220628194812.1453059-47-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To be able to pass HW-provided frame metadata, such as hash,
checksum status etc., to BPF and XSK programs, unify the container
which is used to store it regardless of an XDP program presence or
a verdict returned by it. Use an intermediate onstack
&xdp_meta_generic_rx before filling skb fields and switch descriptor
parsing functions to use it instead of an &sk_buff.
This works the same way how &xdp_buff is being filled before forming
an skb. If metadata generation is enabled, the actual space in front
of a frame will be used in the upcoming changes.
Using &xdp_meta_generic_rx instead of full-blown &xdp_meta_generic
reduces text size by 32 bytes per function.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c      |  19 ++--
 drivers/net/ethernet/intel/ice/ice_ptp.h      |  17 ++-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   4 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   1 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 105 ++++++++++--------
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  12 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |   4 +-
 7 files changed, 91 insertions(+), 71 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index ef9344ef0d8e..d4d955152682 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1795,24 +1795,22 @@ int ice_ptp_set_ts_config(struct ice_pf *pf, struct ifreq *ifr)
 
 /**
  * ice_ptp_rx_hwtstamp - Check for an Rx timestamp
- * @rx_ring: Ring to get the VSI info
  * @rx_desc: Receive descriptor
- * @skb: Particular skb to send timestamp with
+ * @rx_ring: Ring to get the VSI info
+ * @md: Metadata to set timestamp in
  *
  * The driver receives a notification in the receive descriptor with timestamp.
  * The timestamp is in ns, so we must convert the result first.
  */
-void
-ice_ptp_rx_hwtstamp(struct ice_rx_ring *rx_ring,
-		    union ice_32b_rx_flex_desc *rx_desc, struct sk_buff *skb)
+void ice_ptp_rx_hwtstamp(struct xdp_meta_generic *md,
+			 const union ice_32b_rx_flex_desc *rx_desc,
+			 const struct ice_rx_ring *rx_ring)
 {
 	u32 ts_high;
 	u64 ts_ns;
 
-	/* Populate timesync data into skb */
+	/* Populate timesync data into md */
 	if (rx_desc->wb.time_stamp_low & ICE_PTP_TS_VALID) {
-		struct skb_shared_hwtstamps *hwtstamps;
-
 		/* Use ice_ptp_extend_32b_ts directly, using the ring-specific
 		 * cached PHC value, rather than accessing the PF. This also
 		 * allows us to simply pass the upper 32bits of nanoseconds
@@ -1822,9 +1820,8 @@ ice_ptp_rx_hwtstamp(struct ice_rx_ring *rx_ring,
 		ts_high = le32_to_cpu(rx_desc->wb.flex_ts.ts_high);
 		ts_ns = ice_ptp_extend_32b_ts(rx_ring->cached_phctime, ts_high);
 
-		hwtstamps = skb_hwtstamps(skb);
-		memset(hwtstamps, 0, sizeof(*hwtstamps));
-		hwtstamps->hwtstamp = ns_to_ktime(ts_ns);
+		xdp_meta_rx_tstamp_present_set(md, 1);
+		xdp_meta_rx_tstamp_set(md, ts_ns);
 	}
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 10e396abf130..488b6bb01605 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -228,8 +228,12 @@ struct ice_ptp {
 #define N_EXT_TS_E810_NO_SMA		2
 #define ETH_GLTSYN_ENA(_i)		(0x03000348 + ((_i) * 4))
 
-#if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
 struct ice_pf;
+struct ice_rx_ring;
+struct xdp_meta_generic;
+union ice_32b_rx_flex_desc;
+
+#if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
 int ice_ptp_set_ts_config(struct ice_pf *pf, struct ifreq *ifr);
 int ice_ptp_get_ts_config(struct ice_pf *pf, struct ifreq *ifr);
 void ice_ptp_cfg_timestamp(struct ice_pf *pf, bool ena);
@@ -238,9 +242,9 @@ int ice_get_ptp_clock_index(struct ice_pf *pf);
 s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb);
 void ice_ptp_process_ts(struct ice_pf *pf);
 
-void
-ice_ptp_rx_hwtstamp(struct ice_rx_ring *rx_ring,
-		    union ice_32b_rx_flex_desc *rx_desc, struct sk_buff *skb);
+void ice_ptp_rx_hwtstamp(struct xdp_meta_generic *md,
+			 const union ice_32b_rx_flex_desc *rx_desc,
+			 const struct ice_rx_ring *rx_ring);
 void ice_ptp_reset(struct ice_pf *pf);
 void ice_ptp_prepare_for_reset(struct ice_pf *pf);
 void ice_ptp_init(struct ice_pf *pf);
@@ -271,8 +275,9 @@ ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)
 
 static inline void ice_ptp_process_ts(struct ice_pf *pf) { }
 static inline void
-ice_ptp_rx_hwtstamp(struct ice_rx_ring *rx_ring,
-		    union ice_32b_rx_flex_desc *rx_desc, struct sk_buff *skb) { }
+ice_ptp_rx_hwtstamp(struct xdp_meta_generic *md,
+		    const union ice_32b_rx_flex_desc *rx_desc,
+		    const struct ice_rx_ring *rx_ring) { }
 static inline void ice_ptp_reset(struct ice_pf *pf) { }
 static inline void ice_ptp_prepare_for_reset(struct ice_pf *pf) { }
 static inline void ice_ptp_init(struct ice_pf *pf) { }
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index ffea5138a7e8..c679f7c30bdc 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1123,6 +1123,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 	/* start the loop to process Rx packets bounded by 'budget' */
 	while (likely(total_rx_pkts < (unsigned int)budget)) {
 		union ice_32b_rx_flex_desc *rx_desc;
+		struct xdp_meta_generic_rx md;
 		struct ice_rx_buf *rx_buf;
 		unsigned char *hard_start;
 		unsigned int size;
@@ -1239,7 +1240,8 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		/* probably a little skewed due to removing CRC */
 		total_rx_bytes += skb->len;
 
-		ice_process_skb_fields(rx_ring, rx_desc, skb);
+		ice_xdp_build_meta(&md, rx_desc, rx_ring, 0);
+		__xdp_populate_skb_meta_generic(skb, &md);
 
 		ice_trace(clean_rx_irq_indicate, rx_ring, rx_desc, skb);
 		ice_receive_skb(rx_ring, skb);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 1fc31ab0bf33..a814709deb50 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -4,6 +4,7 @@
 #ifndef _ICE_TXRX_H_
 #define _ICE_TXRX_H_
 
+#include <net/xdp_meta.h>
 #include "ice_type.h"
 
 #define ICE_DFLT_IRQ_WORK	256
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 92c001baa2cc..7550e2ed8936 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -43,36 +43,37 @@ void ice_release_rx_desc(struct ice_rx_ring *rx_ring, u16 val)
  * @decoded: the decoded ptype value from the descriptor
  *
  * Returns appropriate hash type (such as PKT_HASH_TYPE_L2/L3/L4) to be used by
- * skb_set_hash based on PTYPE as parsed by HW Rx pipeline and is part of
- * Rx desc.
+ * xdp_meta_rx_hash_type_set() based on PTYPE as parsed by HW Rx pipeline and
+ * is part of Rx desc.
  */
-static enum pkt_hash_types
+static u32
 ice_ptype_to_htype(struct ice_rx_ptype_decoded decoded)
 {
 	if (!decoded.known)
-		return PKT_HASH_TYPE_NONE;
+		return XDP_META_RX_HASH_NONE;
 	if (decoded.payload_layer == ICE_RX_PTYPE_PAYLOAD_LAYER_PAY4)
-		return PKT_HASH_TYPE_L4;
+		return XDP_META_RX_HASH_L4;
 	if (decoded.payload_layer == ICE_RX_PTYPE_PAYLOAD_LAYER_PAY3)
-		return PKT_HASH_TYPE_L3;
+		return XDP_META_RX_HASH_L3;
 	if (decoded.outer_ip == ICE_RX_PTYPE_OUTER_L2)
-		return PKT_HASH_TYPE_L2;
+		return XDP_META_RX_HASH_L2;
 
-	return PKT_HASH_TYPE_NONE;
+	return XDP_META_RX_HASH_NONE;
 }
 
 /**
- * ice_rx_hash - set the hash value in the skb
+ * ice_rx_hash - set the hash value in the medatadata
+ * @md: pointer to current metadata
  * @rx_ring: descriptor ring
  * @rx_desc: specific descriptor
- * @skb: pointer to current skb
  * @decoded: the decoded ptype value from the descriptor
  */
-static void
-ice_rx_hash(struct ice_rx_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
-	    struct sk_buff *skb, struct ice_rx_ptype_decoded decoded)
+static void ice_rx_hash(struct xdp_meta_generic *md,
+			const struct ice_rx_ring *rx_ring,
+			const union ice_32b_rx_flex_desc *rx_desc,
+			struct ice_rx_ptype_decoded decoded)
 {
-	struct ice_32b_rx_flex_desc_nic *nic_mdid;
+	const struct ice_32b_rx_flex_desc_nic *nic_mdid;
 	u32 hash;
 
 	if (!(rx_ring->netdev->features & NETIF_F_RXHASH))
@@ -81,24 +82,24 @@ ice_rx_hash(struct ice_rx_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
 	if (rx_desc->wb.rxdid != ICE_RXDID_FLEX_NIC)
 		return;
 
-	nic_mdid = (struct ice_32b_rx_flex_desc_nic *)rx_desc;
+	nic_mdid = (typeof(nic_mdid))rx_desc;
 	hash = le32_to_cpu(nic_mdid->rss_hash);
-	skb_set_hash(skb, hash, ice_ptype_to_htype(decoded));
+
+	xdp_meta_rx_hash_type_set(md, ice_ptype_to_htype(decoded));
+	xdp_meta_rx_hash_set(md, hash);
 }
 
 /**
- * ice_rx_csum - Indicate in skb if checksum is good
+ * ice_rx_csum - Indicate in metadata if checksum is good
+ * @md: metadata currently being filled
  * @ring: the ring we care about
- * @skb: skb currently being received and modified
  * @rx_desc: the receive descriptor
  * @decoded: the decoded packet type parsed by hardware
- *
- * skb->protocol must be set before this function is called
  */
-static void
-ice_rx_csum(struct ice_rx_ring *ring, struct sk_buff *skb,
-	    union ice_32b_rx_flex_desc *rx_desc,
-	    struct ice_rx_ptype_decoded decoded)
+static void ice_rx_csum(struct xdp_meta_generic *md,
+			const struct ice_rx_ring *ring,
+			const union ice_32b_rx_flex_desc *rx_desc,
+			struct ice_rx_ptype_decoded decoded)
 {
 	u16 rx_status0, rx_status1;
 	bool ipv4, ipv6;
@@ -106,10 +107,6 @@ ice_rx_csum(struct ice_rx_ring *ring, struct sk_buff *skb,
 	rx_status0 = le16_to_cpu(rx_desc->wb.status_error0);
 	rx_status1 = le16_to_cpu(rx_desc->wb.status_error1);
 
-	/* Start with CHECKSUM_NONE and by default csum_level = 0 */
-	skb->ip_summed = CHECKSUM_NONE;
-	skb_checksum_none_assert(skb);
-
 	/* check if Rx checksum is enabled */
 	if (!(ring->netdev->features & NETIF_F_RXCSUM))
 		return;
@@ -149,14 +146,14 @@ ice_rx_csum(struct ice_rx_ring *ring, struct sk_buff *skb,
 	 * we are indicating we validated the inner checksum.
 	 */
 	if (decoded.tunnel_type >= ICE_RX_PTYPE_TUNNEL_IP_GRENAT)
-		skb->csum_level = 1;
+		xdp_meta_rx_csum_level_set(md, 1);
 
 	/* Only report checksum unnecessary for TCP, UDP, or SCTP */
 	switch (decoded.inner_prot) {
 	case ICE_RX_PTYPE_INNER_PROT_TCP:
 	case ICE_RX_PTYPE_INNER_PROT_UDP:
 	case ICE_RX_PTYPE_INNER_PROT_SCTP:
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
+		xdp_meta_rx_csum_status_set(md, XDP_META_RX_CSUM_OK);
 		break;
 	default:
 		break;
@@ -167,7 +164,13 @@ ice_rx_csum(struct ice_rx_ring *ring, struct sk_buff *skb,
 	ring->vsi->back->hw_csum_rx_error++;
 }
 
-static void ice_rx_vlan(struct sk_buff *skb,
+#define xdp_meta_rx_vlan_from_feat(feat) ({			\
+	((feat) & NETIF_F_HW_VLAN_CTAG_RX) ? XDP_META_RX_CVID :	\
+	((feat) & NETIF_F_HW_VLAN_STAG_RX) ? XDP_META_RX_SVID :	\
+	XDP_META_RX_VLAN_NONE;					\
+})
+
+static void ice_rx_vlan(struct xdp_meta_generic *md,
 			const struct ice_rx_ring *rx_ring,
 			const union ice_32b_rx_flex_desc *rx_desc)
 {
@@ -181,42 +184,48 @@ static void ice_rx_vlan(struct sk_buff *skb,
 	if (!non_zero_vlan)
 		return;
 
-	if ((features & NETIF_F_HW_VLAN_CTAG_RX))
-		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tag);
-	else if ((features & NETIF_F_HW_VLAN_STAG_RX))
-		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021AD), vlan_tag);
+	xdp_meta_rx_vlan_type_set(md, xdp_meta_rx_vlan_from_feat(features));
+	xdp_meta_rx_vid_set(md, vlan_tag);
 }
 
 /**
- * ice_process_skb_fields - Populate skb header fields from Rx descriptor
- * @rx_ring: Rx descriptor ring packet is being transacted on
+ * __ice_xdp_build_meta - Populate XDP generic metadata fields from Rx desc
+ * @rx_md: pointer to the metadata structure to be populated
  * @rx_desc: pointer to the EOP Rx descriptor
- * @skb: pointer to current skb being populated
+ * @rx_ring: Rx descriptor ring packet is being transacted on
+ * @full_id: full ID (BTF ID + type ID) to fill in
  *
  * This function checks the ring, descriptor, and packet information in
  * order to populate the hash, checksum, VLAN, protocol, and
- * other fields within the skb.
+ * other fields within the metadata.
  */
-void
-ice_process_skb_fields(struct ice_rx_ring *rx_ring,
-		       union ice_32b_rx_flex_desc *rx_desc,
-		       struct sk_buff *skb)
+void __ice_xdp_build_meta(struct xdp_meta_generic_rx *rx_md,
+			  const union ice_32b_rx_flex_desc *rx_desc,
+			  const struct ice_rx_ring *rx_ring,
+			  __le64 full_id)
 {
+	struct xdp_meta_generic *md = to_gen_md(rx_md);
 	struct ice_rx_ptype_decoded decoded;
 	u16 ptype;
 
-	skb_record_rx_queue(skb, rx_ring->q_index);
+	xdp_meta_init(&md->id, full_id);
+	md->rx_hash = 0;
+	md->rx_csum = 0;
+	md->rx_flags = 0;
+
+	xdp_meta_rx_qid_present_set(md, 1);
+	xdp_meta_rx_qid_set(md, rx_ring->q_index);
 
 	ptype = le16_to_cpu(rx_desc->wb.ptype_flex_flags0) &
 		ICE_RX_FLEX_DESC_PTYPE_M;
 	decoded = ice_decode_rx_desc_ptype(ptype);
 
-	ice_rx_hash(rx_ring, rx_desc, skb, decoded);
-	ice_rx_csum(rx_ring, skb, rx_desc, decoded);
-	ice_rx_vlan(skb, rx_ring, rx_desc);
+	ice_rx_hash(md, rx_ring, rx_desc, decoded);
+	ice_rx_csum(md, rx_ring, rx_desc, decoded);
+	ice_rx_vlan(md, rx_ring, rx_desc);
 
 	if (rx_ring->ptp_rx)
-		ice_ptp_rx_hwtstamp(rx_ring, rx_desc, skb);
+		ice_ptp_rx_hwtstamp(md, rx_desc, rx_ring);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
index 45dc5ef79e28..b51e58b8e83d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
@@ -92,9 +92,13 @@ void ice_finalize_xdp_rx(struct ice_tx_ring *xdp_ring, unsigned int xdp_res);
 int ice_xmit_xdp_buff(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring);
 int ice_xmit_xdp_ring(void *data, u16 size, struct ice_tx_ring *xdp_ring);
 void ice_release_rx_desc(struct ice_rx_ring *rx_ring, u16 val);
-void
-ice_process_skb_fields(struct ice_rx_ring *rx_ring,
-		       union ice_32b_rx_flex_desc *rx_desc,
-		       struct sk_buff *skb);
+
+void __ice_xdp_build_meta(struct xdp_meta_generic_rx *rx_md,
+			  const union ice_32b_rx_flex_desc *rx_desc,
+			  const struct ice_rx_ring *rx_ring,
+			  __le64 full_id);
+
+#define ice_xdp_build_meta(md, ...)					\
+	__ice_xdp_build_meta(to_rx_md(md), ##__VA_ARGS__)
 
 #endif /* !_ICE_TXRX_LIB_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 0a66128964e7..eade918723eb 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -603,6 +603,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		union ice_32b_rx_flex_desc *rx_desc;
 		unsigned int size, xdp_res = 0;
+		struct xdp_meta_generic_rx md;
 		struct xdp_buff *xdp;
 		struct sk_buff *skb;
 		u16 stat_err_bits;
@@ -673,7 +674,8 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 		total_rx_bytes += skb->len;
 		total_rx_packets++;
 
-		ice_process_skb_fields(rx_ring, rx_desc, skb);
+		ice_xdp_build_meta(&md, rx_desc, rx_ring, 0);
+		__xdp_populate_skb_meta_generic(skb, &md);
 		ice_receive_skb(rx_ring, skb);
 	}
 
-- 
2.36.1

