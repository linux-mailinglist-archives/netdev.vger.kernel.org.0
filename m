Return-Path: <netdev+bounces-3962-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7A1C709D72
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:06:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51642281DBA
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B590125CA;
	Fri, 19 May 2023 17:05:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDFA12B6E
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:05:11 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A160110E6
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 10:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684515884; x=1716051884;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tx4dNzgue35j9G3NNE/LhMBtqHeK4KlzWz31pmExk/8=;
  b=G7WVUZ5fhqDrVziKkkaQDlXYEMI9g+pAfYTY2Zi1Ls4voFJpc05J4wdG
   CdYYoX/vthnkilU7Mz4OkQ7MK7tWhoSp4irVL9y/SoPwZANj0xCMDxxcI
   zxqjqxv6scqGFibaONFKdAJaJNtvmwgCqSd0zpND2wsRVJOSGtDTuChPQ
   F0+zEzMvG0dXWBZkrIj13i/MHOfGxyfZWfSOfjtZjrYPpIjIiz4j2JOIx
   4+O9NQp6c+ZOZae/CHt1ZSb3jEGyevWciFD/4sC7n6b/0WhqJMqdsgSL1
   4QtO5ughSBS9PnxrLvLZ+7/J2VDIfIWVyq2RA2Wu92V91qOXy1AJTAbHh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="337017689"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="337017689"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 10:04:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="846950275"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="846950275"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga001.fm.intel.com with ESMTP; 19 May 2023 10:04:13 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	anthony.l.nguyen@intel.com,
	Piotr Raczynski <piotr.raczynski@intel.com>,
	Simon Horman <simon.horman@corigine.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Subject: [PATCH net-next 1/5] ice: define meta data to match in switch
Date: Fri, 19 May 2023 10:00:14 -0700
Message-Id: <20230519170018.2820322-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230519170018.2820322-1-anthony.l.nguyen@intel.com>
References: <20230519170018.2820322-1-anthony.l.nguyen@intel.com>
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

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Add description for each meta data. Redefine tunnel mask to match only
tunneled MAC and tunneled VLAN. It shouldn't try to match other flags
(previously it was 0xff, it is redundant).

VLAN mask was 0xd000, change it to 0xf000. 4 last bits are flags
depending on the same field in packets (VLAN tag). Because of that,
It isn't harmful to match also on ITAG.

Group all MDID and MDID offsets into enums to keep things organized.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../ethernet/intel/ice/ice_protocol_type.h    | 186 +++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_switch.c   |  11 +-
 .../net/ethernet/intel/ice/ice_vlan_mode.c    |   2 +-
 3 files changed, 183 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_protocol_type.h b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
index 02a4e1cf624e..8a84f106bd4d 100644
--- a/drivers/net/ethernet/intel/ice/ice_protocol_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
@@ -115,17 +115,7 @@ enum ice_prot_id {
 #define ICE_L2TPV3_HW		104
 
 #define ICE_UDP_OF_HW	52 /* UDP Tunnels */
-#define ICE_META_DATA_ID_HW 255 /* this is used for tunnel and VLAN type */
 
-#define ICE_MDID_SIZE 2
-
-#define ICE_TUN_FLAG_MDID 21
-#define ICE_TUN_FLAG_MDID_OFF (ICE_MDID_SIZE * ICE_TUN_FLAG_MDID)
-#define ICE_TUN_FLAG_MASK 0xFF
-
-#define ICE_VLAN_FLAG_MDID 20
-#define ICE_VLAN_FLAG_MDID_OFF (ICE_MDID_SIZE * ICE_VLAN_FLAG_MDID)
-#define ICE_PKT_FLAGS_0_TO_15_VLAN_FLAGS_MASK 0xD000
 
 #define ICE_TUN_FLAG_FV_IND 2
 
@@ -230,6 +220,181 @@ struct ice_nvgre_hdr {
 	__be32 tni_flow;
 };
 
+/* Metadata information
+ *
+ * Not all MDIDs can be used by switch block. It depends on package version.
+ *
+ * MDID 16 (Rx offset)
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |  A  |   B     |   Reserved    |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *
+ * A = Source port where the transaction came from (3b).
+ *
+ * B = Destination TC of the packet. The TC is relative to a port (5b).
+ *
+ * MDID 17
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |      PTYPE        | Reserved  |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *
+ * PTYPE = Encodes the packet type (10b).
+ *
+ * MDID 18
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * | Packet length             | R |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *
+ * Packet length = Length of the packet in bytes
+ *		   (packet always carriers CRC) (14b).
+ * R = Reserved (2b).
+ *
+ * MDID 19
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |   Source VSI      | Reserved  |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *
+ * Source VSI = Source VSI of packet loopbacked in switch (for egress) (10b).
+ *
+ * MDID 20
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |A|B|C|D|E|F|R|R|G|H|I|J|K|L|M|N|
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *
+ * A = DSI - set for DSI RX pkts.
+ * B = ipsec_decrypted - invalid on NIC.
+ * C = marker - this is a marker packet.
+ * D = from_network - for TX sets to 0
+ *		      for RX:
+ *		        * 1 - packet is from external link
+ *		        * 0 - packet source is from internal
+ * E = source_interface_is_rx - reflect the physical interface from where the
+ *				packet was received:
+ *				* 1 - Rx
+ *				* 0 - Tx
+ * F = from_mng - The bit signals that the packet's origin is the management.
+ * G = ucast - Outer L2 MAC address is unicast.
+ * H = mcast - Outer L2 MAC address is multicast.
+ * I = bcast - Outer L2 MAC address is broadcast.
+ * J = second_outer_mac_present - 2 outer MAC headers are present in the packet.
+ * K = STAG or BVLAN - Outer L2 header has STAG (ethernet type 0x88a8) or
+ *		       BVLAN (ethernet type 0x88a8).
+ * L = ITAG - Outer L2 header has ITAG *ethernet type 0x88e7)
+ * M = EVLAN (0x8100) - Outer L2 header has EVLAN (ethernet type 0x8100)
+ * N = EVLAN (0x9100) - Outer L2 header has EVLAN (ethernet type 0x9100)
+ */
+#define ICE_PKT_VLAN_STAG	BIT(12)
+#define ICE_PKT_VLAN_ITAG	BIT(13)
+#define ICE_PKT_VLAN_EVLAN	(BIT(14) | BIT(15))
+#define ICE_PKT_VLAN_MASK	(ICE_PKT_VLAN_STAG | ICE_PKT_VLAN_ITAG | \
+				ICE_PKT_VLAN_EVLAN)
+/* MDID 21
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |A|B|C|D|E|F|G|H|I|J|R|R|K|L|M|N|
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *
+ * A = VLAN (0x8100) - Outer L2 header has VLAN (ethernet type 0x8100)
+ * B = NSHoE - Outer L2 header has NSH (ethernet type 0x894f)
+ * C = MPLS (0x8847) - There is at least 1 MPLS tag in the outer header
+ *		       (ethernet type 0x8847)
+ * D = MPLS (0x8848) - There is at least 1 MPLS tag in the outer header
+ *		       (ethernet type 0x8848)
+ * E = multi MPLS - There is more than a single MPLS tag in the outer header
+ * F = inner MPLS - There is inner MPLS tag in the packet
+ * G = tunneled MAC - Set if the packet includes a tunneled MAC
+ * H = tunneled VLAN - Same as VLAN, but for a tunneled header
+ * I = pkt_is_frag - Packet is fragmented (ipv4 or ipv6)
+ * J = ipv6_ext - The packet has routing or destination ipv6 extension in inner
+ *		  or outer ipv6 headers
+ * K = RoCE - UDP packet detected as RoCEv2
+ * L = UDP_XSUM_0 - Set to 1 if L4 checksum is 0 in a UDP packet
+ * M = ESP - This is a ESP packet
+ * N = NAT_ESP - This is a ESP packet encapsulated in UDP NAT
+ */
+#define ICE_PKT_TUNNEL_MAC	BIT(6)
+#define ICE_PKT_TUNNEL_VLAN	BIT(7)
+#define ICE_PKT_TUNNEL_MASK	(ICE_PKT_TUNNEL_MAC | ICE_PKT_TUNNEL_VLAN)
+
+/* MDID 22
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |A|B|C|D|E|F|  G  |H|I|J| K |L|M|
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *
+ * A = fin - fin flag in tcp header
+ * B = sync - sync flag in tcp header
+ * C = rst - rst flag in tcp header
+ * D = psh - psh flag in tcp header
+ * E = ack - ack flag in tcp header
+ * F = urg - urg flag in tcp header
+ * G = tunnel type (3b) - Flags used to decode tunnel type:
+ *			  * b000 - not a VXLAN/Geneve/GRE tunnel
+ *			  * b001 - VXLAN-GPE
+ *			  * b010 - VXLAN (non-GPE)
+ *			  * b011 - Geneve
+ *			  * b100 - GRE (no key, no xsum)
+ *			  * b101 - GREK (key, no xsum)
+ *			  * b110 - GREC (no key, xsum)
+ *			  * b111 - GREKC (key, xsum)
+ * H = UDP_GRE - Packet is UDP (VXLAN or VLAN_GPE or Geneve or MPLSoUDP or GRE)
+ *		 tunnel
+ * I = OAM - VXLAN/Geneve/tunneled NSH packet with the OAM bit set
+ * J = tunneled NSH - Packet has NSHoGRE or NSHoUDP
+ * K = switch (2b) - Direction on switch
+ *		     * b00 - normal
+ *		     * b01 - TX force only LAN
+ *		     * b10 - TX disable LAN
+ *		     * b11 - direct to VSI
+ * L = swpe - Represents SWPE bit in TX command
+ * M = sw_cmd - Switch command
+ *
+ * MDID 23
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |A|B|C|D|        R        |E|F|R|
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *
+ * A = MAC error - Produced by MAC according to L2 error conditions
+ * B = PPRS no offload - FIFO overflow in PPRS or any problematic condition in
+ *			 PPRS ANA
+ * C = abort - Set when malicious packet is detected
+ * D = partial analysis - ANA's analysing got cut in the middle
+ *			 (header > 504B etc.)
+ * E = FLM - Flow director hit indication
+ * F = FDLONG - Flow direector long bucket indication
+ *
+ */
+#define ICE_MDID_SIZE 2
+#define ICE_META_DATA_ID_HW 255
+
+enum ice_hw_metadata_id {
+	ICE_SOURCE_PORT_MDID = 16,
+	ICE_PTYPE_MDID = 17,
+	ICE_PACKET_LENGTH_MDID = 18,
+	ICE_SOURCE_VSI_MDID = 19,
+	ICE_PKT_VLAN_MDID = 20,
+	ICE_PKT_TUNNEL_MDID = 21,
+	ICE_PKT_TCP_MDID = 22,
+	ICE_PKT_ERROR_MDID = 23,
+};
+
+enum ice_hw_metadata_offset {
+	ICE_SOURCE_PORT_MDID_OFFSET = ICE_MDID_SIZE * ICE_SOURCE_PORT_MDID,
+	ICE_PTYPE_MDID_OFFSET = ICE_MDID_SIZE * ICE_PTYPE_MDID,
+	ICE_PACKET_LENGTH_MDID_OFFSET = ICE_MDID_SIZE * ICE_PACKET_LENGTH_MDID,
+	ICE_SOURCE_VSI_MDID_OFFSET = ICE_MDID_SIZE * ICE_SOURCE_VSI_MDID,
+	ICE_PKT_VLAN_MDID_OFFSET = ICE_MDID_SIZE * ICE_PKT_VLAN_MDID,
+	ICE_PKT_TUNNEL_MDID_OFFSET = ICE_MDID_SIZE * ICE_PKT_TUNNEL_MDID,
+	ICE_PKT_TCP_MDID_OFFSET = ICE_MDID_SIZE * ICE_PKT_TCP_MDID,
+	ICE_PKT_ERROR_MDID_OFFSET = ICE_MDID_SIZE * ICE_PKT_ERROR_MDID,
+};
+
+struct ice_hw_metadata {
+	__be16 source_port;
+	__be16 ptype;
+	__be16 packet_length;
+	__be16 source_vsi;
+	__be16 flags[4];
+};
+
 union ice_prot_hdr {
 	struct ice_ether_hdr eth_hdr;
 	struct ice_ethtype_hdr ethertype;
@@ -243,6 +408,7 @@ union ice_prot_hdr {
 	struct ice_udp_gtp_hdr gtp_hdr;
 	struct ice_pppoe_hdr pppoe_hdr;
 	struct ice_l2tpv3_sess_hdr l2tpv3_sess_hdr;
+	struct ice_hw_metadata metadata;
 };
 
 /* This is mapping table entry that maps every word within a given protocol
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 46b36851af46..5c3f266fa80f 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -5268,7 +5268,7 @@ static bool ice_tun_type_match_word(enum ice_sw_tunnel_type tun_type, u16 *mask)
 	case ICE_SW_TUN_NVGRE:
 	case ICE_SW_TUN_GTPU:
 	case ICE_SW_TUN_GTPC:
-		*mask = ICE_TUN_FLAG_MASK;
+		*mask = ICE_PKT_TUNNEL_MASK;
 		return true;
 
 	default:
@@ -5297,7 +5297,8 @@ ice_add_special_words(struct ice_adv_rule_info *rinfo,
 			u8 word = lkup_exts->n_val_words++;
 
 			lkup_exts->fv_words[word].prot_id = ICE_META_DATA_ID_HW;
-			lkup_exts->fv_words[word].off = ICE_TUN_FLAG_MDID_OFF;
+			lkup_exts->fv_words[word].off =
+				ICE_PKT_TUNNEL_MDID_OFFSET;
 			lkup_exts->field_mask[word] = mask;
 		} else {
 			return -ENOSPC;
@@ -5309,9 +5310,9 @@ ice_add_special_words(struct ice_adv_rule_info *rinfo,
 			u8 word = lkup_exts->n_val_words++;
 
 			lkup_exts->fv_words[word].prot_id = ICE_META_DATA_ID_HW;
-			lkup_exts->fv_words[word].off = ICE_VLAN_FLAG_MDID_OFF;
-			lkup_exts->field_mask[word] =
-					ICE_PKT_FLAGS_0_TO_15_VLAN_FLAGS_MASK;
+			lkup_exts->fv_words[word].off =
+				ICE_PKT_VLAN_MDID_OFFSET;
+			lkup_exts->field_mask[word] = ICE_PKT_VLAN_MASK;
 		} else {
 			return -ENOSPC;
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_vlan_mode.c b/drivers/net/ethernet/intel/ice/ice_vlan_mode.c
index bcda2e004807..1279c1ffe31c 100644
--- a/drivers/net/ethernet/intel/ice/ice_vlan_mode.c
+++ b/drivers/net/ethernet/intel/ice/ice_vlan_mode.c
@@ -219,7 +219,7 @@ static struct ice_update_recipe_lkup_idx_params ice_dvm_dflt_recipes[] = {
 		.rid = ICE_SW_LKUP_VLAN,
 		.fv_idx = ICE_PKT_FLAGS_0_TO_15_FV_IDX,
 		.ignore_valid = false,
-		.mask = ICE_PKT_FLAGS_0_TO_15_VLAN_FLAGS_MASK,
+		.mask = ICE_PKT_VLAN_MASK,
 		.mask_valid = true,
 		.lkup_idx = ICE_SW_LKUP_VLAN_PKT_FLAGS_LKUP_IDX,
 	},
-- 
2.38.1


