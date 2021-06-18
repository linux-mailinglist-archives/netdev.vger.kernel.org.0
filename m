Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF923AD05E
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 18:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235909AbhFRQ3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 12:29:17 -0400
Received: from mga18.intel.com ([134.134.136.126]:5462 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231898AbhFRQ3G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 12:29:06 -0400
IronPort-SDR: VtS65tXjzRYibp4iSUZddQxbOBmsxKKkoizyfiTRrzC8sSIJdFcgLyfGRZ1ONM2tGIP4JWrHLb
 bElYWcyelzRQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10019"; a="193895224"
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="193895224"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 09:26:53 -0700
IronPort-SDR: MmZ45g9Gw66tuHFnlTQ5eSz/sb+7RGg8ZSH9W5Kd0MokldyYzDCr1zoexq24iKSSVLd9FXx4wH
 OMPHUGVrl3xA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="554781630"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 18 Jun 2021 09:26:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 1/3] ice: report hash type such as L2/L3/L4
Date:   Fri, 18 Jun 2021 09:29:30 -0700
Message-Id: <20210618162932.859071-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210618162932.859071-1-anthony.l.nguyen@intel.com>
References: <20210618162932.859071-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The hardware is reporting the type of the hash used for RSS
as a PTYPE field in the receive descriptor. Use this value to set
the skb packet hash type by extending the hash type table to
cover all 10-bits of possible values (requiring some variables
to be changed from u8 to u16), and then use that table to convert
to one of the possible values in enum pkt_hash_types.

While we're here, remove the unused ptype struct value, which
makes table init easier for the zero entries, and use ranged
initializer to remove a bunch of code (works with gcc and clang).

Without this change, the kernel will recalculate the hash in software,
which can consume extra CPU cycles.

Co-developed-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
NOTE: this patch generates an expected checkpatch error due to the
tricky structure initializer macro.

 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    | 147 ++++--------------
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   2 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  23 ++-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |   2 +-
 5 files changed, 50 insertions(+), 126 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index 4238ab0433ee..80736e0ec0dc 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -161,7 +161,6 @@ struct ice_fltr_desc {
 #define ICE_FXD_FLTR_WB_QW1_FAIL_PROF_YES	0x1ULL
 
 struct ice_rx_ptype_decoded {
-	u32 ptype:10;
 	u32 known:1;
 	u32 outer_ip:1;
 	u32 outer_ip_ver:2;
@@ -606,9 +605,32 @@ struct ice_tlan_ctx {
 	u8 int_q_state;	/* width not needed - internal - DO NOT WRITE!!! */
 };
 
-/* macro to make the table lines short */
+/* The ice_ptype_lkup table is used to convert from the 10-bit ptype in the
+ * hardware to a bit-field that can be used by SW to more easily determine the
+ * packet type.
+ *
+ * Macros are used to shorten the table lines and make this table human
+ * readable.
+ *
+ * We store the PTYPE in the top byte of the bit field - this is just so that
+ * we can check that the table doesn't have a row missing, as the index into
+ * the table should be the PTYPE.
+ *
+ * Typical work flow:
+ *
+ * IF NOT ice_ptype_lkup[ptype].known
+ * THEN
+ *      Packet is unknown
+ * ELSE IF ice_ptype_lkup[ptype].outer_ip == ICE_RX_PTYPE_OUTER_IP
+ *      Use the rest of the fields to look at the tunnels, inner protocols, etc
+ * ELSE
+ *      Use the enum ice_rx_l2_ptype to decode the packet type
+ * ENDIF
+ */
+
+/* macro to make the table lines short, use explicit indexing with [PTYPE] */
 #define ICE_PTT(PTYPE, OUTER_IP, OUTER_IP_VER, OUTER_FRAG, T, TE, TEF, I, PL)\
-	{	PTYPE, \
+	[PTYPE] = { \
 		1, \
 		ICE_RX_PTYPE_OUTER_##OUTER_IP, \
 		ICE_RX_PTYPE_OUTER_##OUTER_IP_VER, \
@@ -619,14 +641,14 @@ struct ice_tlan_ctx {
 		ICE_RX_PTYPE_INNER_PROT_##I, \
 		ICE_RX_PTYPE_PAYLOAD_LAYER_##PL }
 
-#define ICE_PTT_UNUSED_ENTRY(PTYPE) { PTYPE, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
+#define ICE_PTT_UNUSED_ENTRY(PTYPE) [PTYPE] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
 
 /* shorter macros makes the table fit but are terse */
 #define ICE_RX_PTYPE_NOF		ICE_RX_PTYPE_NOT_FRAG
 #define ICE_RX_PTYPE_FRG		ICE_RX_PTYPE_FRAG
 
-/* Lookup table mapping the HW PTYPE to the bit field for decoding */
-static const struct ice_rx_ptype_decoded ice_ptype_lkup[] = {
+/* Lookup table mapping in the 10-bit HW PTYPE to the bit field for decoding */
+static const struct ice_rx_ptype_decoded ice_ptype_lkup[BIT(10)] = {
 	/* L2 Packet types */
 	ICE_PTT_UNUSED_ENTRY(0),
 	ICE_PTT(1, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY2),
@@ -832,118 +854,7 @@ static const struct ice_rx_ptype_decoded ice_ptype_lkup[] = {
 	ICE_PTT(153, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, ICMP, PAY4),
 
 	/* unused entries */
-	ICE_PTT_UNUSED_ENTRY(154),
-	ICE_PTT_UNUSED_ENTRY(155),
-	ICE_PTT_UNUSED_ENTRY(156),
-	ICE_PTT_UNUSED_ENTRY(157),
-	ICE_PTT_UNUSED_ENTRY(158),
-	ICE_PTT_UNUSED_ENTRY(159),
-
-	ICE_PTT_UNUSED_ENTRY(160),
-	ICE_PTT_UNUSED_ENTRY(161),
-	ICE_PTT_UNUSED_ENTRY(162),
-	ICE_PTT_UNUSED_ENTRY(163),
-	ICE_PTT_UNUSED_ENTRY(164),
-	ICE_PTT_UNUSED_ENTRY(165),
-	ICE_PTT_UNUSED_ENTRY(166),
-	ICE_PTT_UNUSED_ENTRY(167),
-	ICE_PTT_UNUSED_ENTRY(168),
-	ICE_PTT_UNUSED_ENTRY(169),
-
-	ICE_PTT_UNUSED_ENTRY(170),
-	ICE_PTT_UNUSED_ENTRY(171),
-	ICE_PTT_UNUSED_ENTRY(172),
-	ICE_PTT_UNUSED_ENTRY(173),
-	ICE_PTT_UNUSED_ENTRY(174),
-	ICE_PTT_UNUSED_ENTRY(175),
-	ICE_PTT_UNUSED_ENTRY(176),
-	ICE_PTT_UNUSED_ENTRY(177),
-	ICE_PTT_UNUSED_ENTRY(178),
-	ICE_PTT_UNUSED_ENTRY(179),
-
-	ICE_PTT_UNUSED_ENTRY(180),
-	ICE_PTT_UNUSED_ENTRY(181),
-	ICE_PTT_UNUSED_ENTRY(182),
-	ICE_PTT_UNUSED_ENTRY(183),
-	ICE_PTT_UNUSED_ENTRY(184),
-	ICE_PTT_UNUSED_ENTRY(185),
-	ICE_PTT_UNUSED_ENTRY(186),
-	ICE_PTT_UNUSED_ENTRY(187),
-	ICE_PTT_UNUSED_ENTRY(188),
-	ICE_PTT_UNUSED_ENTRY(189),
-
-	ICE_PTT_UNUSED_ENTRY(190),
-	ICE_PTT_UNUSED_ENTRY(191),
-	ICE_PTT_UNUSED_ENTRY(192),
-	ICE_PTT_UNUSED_ENTRY(193),
-	ICE_PTT_UNUSED_ENTRY(194),
-	ICE_PTT_UNUSED_ENTRY(195),
-	ICE_PTT_UNUSED_ENTRY(196),
-	ICE_PTT_UNUSED_ENTRY(197),
-	ICE_PTT_UNUSED_ENTRY(198),
-	ICE_PTT_UNUSED_ENTRY(199),
-
-	ICE_PTT_UNUSED_ENTRY(200),
-	ICE_PTT_UNUSED_ENTRY(201),
-	ICE_PTT_UNUSED_ENTRY(202),
-	ICE_PTT_UNUSED_ENTRY(203),
-	ICE_PTT_UNUSED_ENTRY(204),
-	ICE_PTT_UNUSED_ENTRY(205),
-	ICE_PTT_UNUSED_ENTRY(206),
-	ICE_PTT_UNUSED_ENTRY(207),
-	ICE_PTT_UNUSED_ENTRY(208),
-	ICE_PTT_UNUSED_ENTRY(209),
-
-	ICE_PTT_UNUSED_ENTRY(210),
-	ICE_PTT_UNUSED_ENTRY(211),
-	ICE_PTT_UNUSED_ENTRY(212),
-	ICE_PTT_UNUSED_ENTRY(213),
-	ICE_PTT_UNUSED_ENTRY(214),
-	ICE_PTT_UNUSED_ENTRY(215),
-	ICE_PTT_UNUSED_ENTRY(216),
-	ICE_PTT_UNUSED_ENTRY(217),
-	ICE_PTT_UNUSED_ENTRY(218),
-	ICE_PTT_UNUSED_ENTRY(219),
-
-	ICE_PTT_UNUSED_ENTRY(220),
-	ICE_PTT_UNUSED_ENTRY(221),
-	ICE_PTT_UNUSED_ENTRY(222),
-	ICE_PTT_UNUSED_ENTRY(223),
-	ICE_PTT_UNUSED_ENTRY(224),
-	ICE_PTT_UNUSED_ENTRY(225),
-	ICE_PTT_UNUSED_ENTRY(226),
-	ICE_PTT_UNUSED_ENTRY(227),
-	ICE_PTT_UNUSED_ENTRY(228),
-	ICE_PTT_UNUSED_ENTRY(229),
-
-	ICE_PTT_UNUSED_ENTRY(230),
-	ICE_PTT_UNUSED_ENTRY(231),
-	ICE_PTT_UNUSED_ENTRY(232),
-	ICE_PTT_UNUSED_ENTRY(233),
-	ICE_PTT_UNUSED_ENTRY(234),
-	ICE_PTT_UNUSED_ENTRY(235),
-	ICE_PTT_UNUSED_ENTRY(236),
-	ICE_PTT_UNUSED_ENTRY(237),
-	ICE_PTT_UNUSED_ENTRY(238),
-	ICE_PTT_UNUSED_ENTRY(239),
-
-	ICE_PTT_UNUSED_ENTRY(240),
-	ICE_PTT_UNUSED_ENTRY(241),
-	ICE_PTT_UNUSED_ENTRY(242),
-	ICE_PTT_UNUSED_ENTRY(243),
-	ICE_PTT_UNUSED_ENTRY(244),
-	ICE_PTT_UNUSED_ENTRY(245),
-	ICE_PTT_UNUSED_ENTRY(246),
-	ICE_PTT_UNUSED_ENTRY(247),
-	ICE_PTT_UNUSED_ENTRY(248),
-	ICE_PTT_UNUSED_ENTRY(249),
-
-	ICE_PTT_UNUSED_ENTRY(250),
-	ICE_PTT_UNUSED_ENTRY(251),
-	ICE_PTT_UNUSED_ENTRY(252),
-	ICE_PTT_UNUSED_ENTRY(253),
-	ICE_PTT_UNUSED_ENTRY(254),
-	ICE_PTT_UNUSED_ENTRY(255),
+	[154 ... 1023] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
 };
 
 static inline struct ice_rx_ptype_decoded ice_decode_rx_desc_ptype(u16 ptype)
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 917eba7fdd0c..e9e9edb32c6f 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1082,7 +1082,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		u16 stat_err_bits;
 		int rx_buf_pgcnt;
 		u16 vlan_tag = 0;
-		u8 rx_ptype;
+		u16 rx_ptype;
 
 		/* get the Rx desc from Rx ring based on 'next_to_clean' */
 		rx_desc = ICE_RX_DESC(rx_ring, rx_ring->next_to_clean);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 166cf25d1139..171397dcf00a 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -38,10 +38,23 @@ void ice_release_rx_desc(struct ice_ring *rx_ring, u16 val)
  * ice_ptype_to_htype - get a hash type
  * @ptype: the ptype value from the descriptor
  *
- * Returns a hash type to be used by skb_set_hash
+ * Returns appropriate hash type (such as PKT_HASH_TYPE_L2/L3/L4) to be used by
+ * skb_set_hash based on PTYPE as parsed by HW Rx pipeline and is part of
+ * Rx desc.
  */
-static enum pkt_hash_types ice_ptype_to_htype(u8 __always_unused ptype)
+static enum pkt_hash_types ice_ptype_to_htype(u16 ptype)
 {
+	struct ice_rx_ptype_decoded decoded = ice_decode_rx_desc_ptype(ptype);
+
+	if (!decoded.known)
+		return PKT_HASH_TYPE_NONE;
+	if (decoded.payload_layer == ICE_RX_PTYPE_PAYLOAD_LAYER_PAY4)
+		return PKT_HASH_TYPE_L4;
+	if (decoded.payload_layer == ICE_RX_PTYPE_PAYLOAD_LAYER_PAY3)
+		return PKT_HASH_TYPE_L3;
+	if (decoded.outer_ip == ICE_RX_PTYPE_OUTER_L2)
+		return PKT_HASH_TYPE_L2;
+
 	return PKT_HASH_TYPE_NONE;
 }
 
@@ -54,7 +67,7 @@ static enum pkt_hash_types ice_ptype_to_htype(u8 __always_unused ptype)
  */
 static void
 ice_rx_hash(struct ice_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
-	    struct sk_buff *skb, u8 rx_ptype)
+	    struct sk_buff *skb, u16 rx_ptype)
 {
 	struct ice_32b_rx_flex_desc_nic *nic_mdid;
 	u32 hash;
@@ -81,7 +94,7 @@ ice_rx_hash(struct ice_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
  */
 static void
 ice_rx_csum(struct ice_ring *ring, struct sk_buff *skb,
-	    union ice_32b_rx_flex_desc *rx_desc, u8 ptype)
+	    union ice_32b_rx_flex_desc *rx_desc, u16 ptype)
 {
 	struct ice_rx_ptype_decoded decoded;
 	u16 rx_status0, rx_status1;
@@ -167,7 +180,7 @@ ice_rx_csum(struct ice_ring *ring, struct sk_buff *skb,
 void
 ice_process_skb_fields(struct ice_ring *rx_ring,
 		       union ice_32b_rx_flex_desc *rx_desc,
-		       struct sk_buff *skb, u8 ptype)
+		       struct sk_buff *skb, u16 ptype)
 {
 	ice_rx_hash(rx_ring, rx_desc, skb, ptype);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
index 58ff58f0f972..05ac30752902 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
@@ -53,7 +53,7 @@ void ice_release_rx_desc(struct ice_ring *rx_ring, u16 val);
 void
 ice_process_skb_fields(struct ice_ring *rx_ring,
 		       union ice_32b_rx_flex_desc *rx_desc,
-		       struct sk_buff *skb, u8 ptype);
+		       struct sk_buff *skb, u16 ptype);
 void
 ice_receive_skb(struct ice_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag);
 #endif /* !_ICE_TXRX_LIB_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 239b9bf10794..52acbe325db3 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -528,7 +528,7 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 		struct sk_buff *skb;
 		u16 stat_err_bits;
 		u16 vlan_tag = 0;
-		u8 rx_ptype;
+		u16 rx_ptype;
 
 		rx_desc = ICE_RX_DESC(rx_ring, rx_ring->next_to_clean);
 
-- 
2.26.2

