Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBF6581B26
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 22:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239942AbiGZUfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 16:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239935AbiGZUfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 16:35:14 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCC910CB
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 13:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658867712; x=1690403712;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IhB0Bs2tIWREzUAFeRPJT84JZHraJMzYEEfvBrHm/u0=;
  b=ORPEZUzhZsYMdNx94I+QV9NPQFxwqmgBlehTjlDYOw64ie90eaxa1Ojk
   xqwO0iLalCWMpQxnqY01V34kaA8SZl9KVR3f6hEKG9oUBqw1OVHaxulpS
   Ds8GdY7xCJhbUCYU7fROYLkznKQF8EhcU0rls964QM07TD5pKml2+Lwcm
   seTTyuWm4h4cO6s2Ol4B/3x9w+GwvYbVCD0hBegbqPC5HwQioIZUiqYks
   OV6TFNtwVVtVQz+MvKbLhi+63o353eNdLCV5USUToj08nmrIbptsPnfAl
   I4iO120Vsb0/wwvNVsi4LZDWubX/VL5kVRLSk+5nLDgXoKlLPk0ZZ4iKV
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="274923303"
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="274923303"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 13:35:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="658854169"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 26 Jul 2022 13:35:11 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        xiyou.wangcong@gmail.com, jesse.brandeburg@intel.com,
        gustavoars@kernel.org, baowen.zheng@corigine.com,
        boris.sukholitko@broadcom.com, kurt@linutronix.de,
        pablo@netfilter.org, paulb@nvidia.com, simon.horman@corigine.com,
        komachi.yoshiki@gmail.com, zhangkaiheb@126.com,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        alexandr.lobakin@intel.com, gnault@redhat.com,
        mostrows@speakeasy.net, paulus@samba.org
Subject: [PATCH net-next 4/4] ice: Add support for PPPoE hardware offload
Date:   Tue, 26 Jul 2022 13:31:33 -0700
Message-Id: <20220726203133.2171332-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220726203133.2171332-1-anthony.l.nguyen@intel.com>
References: <20220726203133.2171332-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcin Szycik <marcin.szycik@linux.intel.com>

Add support for creating PPPoE filters in switchdev mode. Add support
for parsing PPPoE and PPP-specific tc options: pppoe_sid and ppp_proto.

Example filter:
tc filter add dev $PF1 ingress protocol ppp_ses prio 1 flower pppoe_sid \
    1234 ppp_proto ip skip_sw action mirred egress redirect dev $VF1_PR

Changes in iproute2 are required to use the new fields.

ICE COMMS DDP package is required to create a filter as it contains PPPoE
profiles. Added a warning message when loaded DDP package does not contain
required profiles.

Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |   5 +-
 .../ethernet/intel/ice/ice_protocol_type.h    |  11 ++
 drivers/net/ethernet/intel/ice/ice_switch.c   | 165 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  71 +++++++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   8 +
 6 files changed, 259 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 1a2e54dbc5a1..36b440b1aaff 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -52,6 +52,7 @@
 #include <net/udp_tunnel.h>
 #include <net/vxlan.h>
 #include <net/gtp.h>
+#include <linux/ppp_defs.h>
 #include "ice_devids.h"
 #include "ice_type.h"
 #include "ice_txrx.h"
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index ada5198b5b16..4b3bb19e1d06 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -1964,8 +1964,11 @@ ice_get_sw_fv_list(struct ice_hw *hw, struct ice_prot_lkup_ext *lkups,
 			}
 		}
 	} while (fv);
-	if (list_empty(fv_list))
+	if (list_empty(fv_list)) {
+		dev_warn(ice_hw_to_dev(hw), "Required profiles not found in currently loaded DDP package");
 		return -EIO;
+	}
+
 	return 0;
 
 err:
diff --git a/drivers/net/ethernet/intel/ice/ice_protocol_type.h b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
index d4a0d089649c..560efc7654c7 100644
--- a/drivers/net/ethernet/intel/ice/ice_protocol_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
@@ -43,6 +43,7 @@ enum ice_protocol_type {
 	ICE_NVGRE,
 	ICE_GTP,
 	ICE_GTP_NO_PAY,
+	ICE_PPPOE,
 	ICE_VLAN_EX,
 	ICE_VLAN_IN,
 	ICE_VXLAN_GPE,
@@ -109,6 +110,7 @@ enum ice_prot_id {
 #define ICE_TCP_IL_HW		49
 #define ICE_UDP_ILOS_HW		53
 #define ICE_GRE_OF_HW		64
+#define ICE_PPPOE_HW		103
 
 #define ICE_UDP_OF_HW	52 /* UDP Tunnels */
 #define ICE_META_DATA_ID_HW 255 /* this is used for tunnel and VLAN type */
@@ -207,6 +209,14 @@ struct ice_udp_gtp_hdr {
 	u8 rsvrd;
 };
 
+struct ice_pppoe_hdr {
+	u8 rsrvd_ver_type;
+	u8 rsrvd_code;
+	__be16 session_id;
+	__be16 length;
+	__be16 ppp_prot_id; /* control and data only */
+};
+
 struct ice_nvgre_hdr {
 	__be16 flags;
 	__be16 protocol;
@@ -224,6 +234,7 @@ union ice_prot_hdr {
 	struct ice_udp_tnl_hdr tnl_hdr;
 	struct ice_nvgre_hdr nvgre_hdr;
 	struct ice_udp_gtp_hdr gtp_hdr;
+	struct ice_pppoe_hdr pppoe_hdr;
 };
 
 /* This is mapping table entry that maps every word within a given protocol
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 2d1274774987..4a6a8334a0e0 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -41,6 +41,7 @@ enum {
 	ICE_PKT_INNER_UDP	= BIT(7),
 	ICE_PKT_GTP_NOPAY	= BIT(8),
 	ICE_PKT_KMALLOC		= BIT(9),
+	ICE_PKT_PPPOE		= BIT(10),
 };
 
 struct ice_dummy_pkt_offsets {
@@ -1109,6 +1110,154 @@ ICE_DECLARE_PKT_TEMPLATE(ipv6_gtp) = {
 	0x00, 0x00,
 };
 
+ICE_DECLARE_PKT_OFFSETS(pppoe_ipv4_tcp) = {
+	{ ICE_MAC_OFOS,		0 },
+	{ ICE_ETYPE_OL,		12 },
+	{ ICE_PPPOE,		14 },
+	{ ICE_IPV4_OFOS,	22 },
+	{ ICE_TCP_IL,		42 },
+	{ ICE_PROTOCOL_LAST,	0 },
+};
+
+ICE_DECLARE_PKT_TEMPLATE(pppoe_ipv4_tcp) = {
+	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x88, 0x64,		/* ICE_ETYPE_OL 12 */
+
+	0x11, 0x00, 0x00, 0x00, /* ICE_PPPOE 14 */
+	0x00, 0x16,
+
+	0x00, 0x21,		/* PPP Link Layer 20 */
+
+	0x45, 0x00, 0x00, 0x28, /* ICE_IPV4_OFOS 22 */
+	0x00, 0x01, 0x00, 0x00,
+	0x00, 0x06, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x00, 0x00, /* ICE_TCP_IL 42 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x50, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00,		/* 2 bytes for 4 bytes alignment */
+};
+
+ICE_DECLARE_PKT_OFFSETS(pppoe_ipv4_udp) = {
+	{ ICE_MAC_OFOS,		0 },
+	{ ICE_ETYPE_OL,		12 },
+	{ ICE_PPPOE,		14 },
+	{ ICE_IPV4_OFOS,	22 },
+	{ ICE_UDP_ILOS,		42 },
+	{ ICE_PROTOCOL_LAST,	0 },
+};
+
+ICE_DECLARE_PKT_TEMPLATE(pppoe_ipv4_udp) = {
+	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x88, 0x64,		/* ICE_ETYPE_OL 12 */
+
+	0x11, 0x00, 0x00, 0x00, /* ICE_PPPOE 14 */
+	0x00, 0x16,
+
+	0x00, 0x21,		/* PPP Link Layer 20 */
+
+	0x45, 0x00, 0x00, 0x1c, /* ICE_IPV4_OFOS 22 */
+	0x00, 0x01, 0x00, 0x00,
+	0x00, 0x11, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x00, 0x00, /* ICE_UDP_ILOS 42 */
+	0x00, 0x08, 0x00, 0x00,
+
+	0x00, 0x00,		/* 2 bytes for 4 bytes alignment */
+};
+
+ICE_DECLARE_PKT_OFFSETS(pppoe_ipv6_tcp) = {
+	{ ICE_MAC_OFOS,		0 },
+	{ ICE_ETYPE_OL,		12 },
+	{ ICE_PPPOE,		14 },
+	{ ICE_IPV6_OFOS,	22 },
+	{ ICE_TCP_IL,		62 },
+	{ ICE_PROTOCOL_LAST,	0 },
+};
+
+ICE_DECLARE_PKT_TEMPLATE(pppoe_ipv6_tcp) = {
+	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x88, 0x64,		/* ICE_ETYPE_OL 12 */
+
+	0x11, 0x00, 0x00, 0x00, /* ICE_PPPOE 14 */
+	0x00, 0x2a,
+
+	0x00, 0x57,		/* PPP Link Layer 20 */
+
+	0x60, 0x00, 0x00, 0x00, /* ICE_IPV6_OFOS 22 */
+	0x00, 0x14, 0x06, 0x00, /* Next header is TCP */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x00, 0x00, /* ICE_TCP_IL 62 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x50, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00,		/* 2 bytes for 4 bytes alignment */
+};
+
+ICE_DECLARE_PKT_OFFSETS(pppoe_ipv6_udp) = {
+	{ ICE_MAC_OFOS,		0 },
+	{ ICE_ETYPE_OL,		12 },
+	{ ICE_PPPOE,		14 },
+	{ ICE_IPV6_OFOS,	22 },
+	{ ICE_UDP_ILOS,		62 },
+	{ ICE_PROTOCOL_LAST,	0 },
+};
+
+ICE_DECLARE_PKT_TEMPLATE(pppoe_ipv6_udp) = {
+	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x88, 0x64,		/* ICE_ETYPE_OL 12 */
+
+	0x11, 0x00, 0x00, 0x00, /* ICE_PPPOE 14 */
+	0x00, 0x2a,
+
+	0x00, 0x57,		/* PPP Link Layer 20 */
+
+	0x60, 0x00, 0x00, 0x00, /* ICE_IPV6_OFOS 22 */
+	0x00, 0x08, 0x11, 0x00, /* Next header UDP*/
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x00, 0x00, /* ICE_UDP_ILOS 62 */
+	0x00, 0x08, 0x00, 0x00,
+
+	0x00, 0x00,		/* 2 bytes for 4 bytes alignment */
+};
+
 static const struct ice_dummy_pkt_profile ice_dummy_pkt_profiles[] = {
 	ICE_PKT_PROFILE(ipv6_gtp, ICE_PKT_TUN_GTPU | ICE_PKT_OUTER_IPV6 |
 				  ICE_PKT_GTP_NOPAY),
@@ -1135,6 +1284,11 @@ static const struct ice_dummy_pkt_profile ice_dummy_pkt_profiles[] = {
 	ICE_PKT_PROFILE(ipv4_gtpu_ipv4_tcp, ICE_PKT_TUN_GTPU),
 	ICE_PKT_PROFILE(ipv6_gtp, ICE_PKT_TUN_GTPC | ICE_PKT_OUTER_IPV6),
 	ICE_PKT_PROFILE(ipv4_gtpu_ipv4, ICE_PKT_TUN_GTPC),
+	ICE_PKT_PROFILE(pppoe_ipv6_udp, ICE_PKT_PPPOE | ICE_PKT_OUTER_IPV6 |
+					ICE_PKT_INNER_UDP),
+	ICE_PKT_PROFILE(pppoe_ipv6_tcp, ICE_PKT_PPPOE | ICE_PKT_OUTER_IPV6),
+	ICE_PKT_PROFILE(pppoe_ipv4_udp, ICE_PKT_PPPOE | ICE_PKT_INNER_UDP),
+	ICE_PKT_PROFILE(pppoe_ipv4_tcp, ICE_PKT_PPPOE),
 	ICE_PKT_PROFILE(gre_ipv6_tcp, ICE_PKT_TUN_NVGRE | ICE_PKT_INNER_IPV6 |
 				      ICE_PKT_INNER_TCP),
 	ICE_PKT_PROFILE(gre_tcp, ICE_PKT_TUN_NVGRE | ICE_PKT_INNER_TCP),
@@ -4480,6 +4634,7 @@ static const struct ice_prot_ext_tbl_entry ice_prot_ext[ICE_PROTOCOL_LAST] = {
 	{ ICE_NVGRE,		{ 0, 2, 4, 6 } },
 	{ ICE_GTP,		{ 8, 10, 12, 14, 16, 18, 20, 22 } },
 	{ ICE_GTP_NO_PAY,	{ 8, 10, 12, 14 } },
+	{ ICE_PPPOE,		{ 0, 2, 4, 6 } },
 	{ ICE_VLAN_EX,          { 2, 0 } },
 	{ ICE_VLAN_IN,          { 2, 0 } },
 };
@@ -4502,6 +4657,7 @@ static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {
 	{ ICE_NVGRE,		ICE_GRE_OF_HW },
 	{ ICE_GTP,		ICE_UDP_OF_HW },
 	{ ICE_GTP_NO_PAY,	ICE_UDP_ILOS_HW },
+	{ ICE_PPPOE,		ICE_PPPOE_HW },
 	{ ICE_VLAN_EX,          ICE_VLAN_OF_HW },
 	{ ICE_VLAN_IN,          ICE_VLAN_OL_HW },
 };
@@ -5580,6 +5736,12 @@ ice_find_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 			match |= ICE_PKT_INNER_IPV6;
 		else if (lkups[i].type == ICE_GTP_NO_PAY)
 			match |= ICE_PKT_GTP_NOPAY;
+		else if (lkups[i].type == ICE_PPPOE) {
+			match |= ICE_PKT_PPPOE;
+			if (lkups[i].h_u.pppoe_hdr.ppp_prot_id ==
+			    htons(PPP_IPV6))
+				match |= ICE_PKT_OUTER_IPV6;
+		}
 	}
 
 	while (ret->match && (match & ret->match) != ret->match)
@@ -5677,6 +5839,9 @@ ice_fill_adv_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 		case ICE_GTP:
 			len = sizeof(struct ice_udp_gtp_hdr);
 			break;
+		case ICE_PPPOE:
+			len = sizeof(struct ice_pppoe_hdr);
+			break;
 		default:
 			return -EINVAL;
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 14795157846b..a298862857a8 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -54,6 +54,11 @@ ice_tc_count_lkups(u32 flags, struct ice_tc_flower_lyr_2_4_hdrs *headers,
 	if (flags & ICE_TC_FLWR_FIELD_CVLAN)
 		lkups_cnt++;
 
+	/* are PPPoE options specified? */
+	if (flags & (ICE_TC_FLWR_FIELD_PPPOE_SESSID |
+		     ICE_TC_FLWR_FIELD_PPP_PROTO))
+		lkups_cnt++;
+
 	/* are IPv[4|6] fields specified? */
 	if (flags & (ICE_TC_FLWR_FIELD_DEST_IPV4 | ICE_TC_FLWR_FIELD_SRC_IPV4 |
 		     ICE_TC_FLWR_FIELD_DEST_IPV6 | ICE_TC_FLWR_FIELD_SRC_IPV6))
@@ -350,6 +355,28 @@ ice_tc_fill_rules(struct ice_hw *hw, u32 flags,
 		i++;
 	}
 
+	if (flags & (ICE_TC_FLWR_FIELD_PPPOE_SESSID |
+		     ICE_TC_FLWR_FIELD_PPP_PROTO)) {
+		struct ice_pppoe_hdr *vals, *masks;
+
+		vals = &list[i].h_u.pppoe_hdr;
+		masks = &list[i].m_u.pppoe_hdr;
+
+		list[i].type = ICE_PPPOE;
+
+		if (flags & ICE_TC_FLWR_FIELD_PPPOE_SESSID) {
+			vals->session_id = headers->pppoe_hdr.session_id;
+			masks->session_id = cpu_to_be16(0xFFFF);
+		}
+
+		if (flags & ICE_TC_FLWR_FIELD_PPP_PROTO) {
+			vals->ppp_prot_id = headers->pppoe_hdr.ppp_proto;
+			masks->ppp_prot_id = cpu_to_be16(0xFFFF);
+		}
+
+		i++;
+	}
+
 	/* copy L3 (IPv[4|6]: src, dest) address */
 	if (flags & (ICE_TC_FLWR_FIELD_DEST_IPV4 |
 		     ICE_TC_FLWR_FIELD_SRC_IPV4)) {
@@ -693,6 +720,31 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
 	return ret;
 }
 
+/**
+ * ice_tc_set_pppoe - Parse PPPoE fields from TC flower filter
+ * @match: Pointer to flow match structure
+ * @fltr: Pointer to filter structure
+ * @headers: Pointer to outer header fields
+ * @returns PPP protocol used in filter (ppp_ses or ppp_disc)
+ */
+static u16
+ice_tc_set_pppoe(struct flow_match_pppoe *match,
+		 struct ice_tc_flower_fltr *fltr,
+		 struct ice_tc_flower_lyr_2_4_hdrs *headers)
+{
+	if (match->mask->session_id) {
+		fltr->flags |= ICE_TC_FLWR_FIELD_PPPOE_SESSID;
+		headers->pppoe_hdr.session_id = match->key->session_id;
+	}
+
+	if (match->mask->ppp_proto) {
+		fltr->flags |= ICE_TC_FLWR_FIELD_PPP_PROTO;
+		headers->pppoe_hdr.ppp_proto = match->key->ppp_proto;
+	}
+
+	return be16_to_cpu(match->key->type);
+}
+
 /**
  * ice_tc_set_ipv4 - Parse IPv4 addresses from TC flower filter
  * @match: Pointer to flow match structure
@@ -988,7 +1040,8 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 	      BIT(FLOW_DISSECTOR_KEY_ENC_PORTS) |
 	      BIT(FLOW_DISSECTOR_KEY_ENC_OPTS) |
 	      BIT(FLOW_DISSECTOR_KEY_ENC_IP) |
-	      BIT(FLOW_DISSECTOR_KEY_PORTS))) {
+	      BIT(FLOW_DISSECTOR_KEY_PORTS) |
+	      BIT(FLOW_DISSECTOR_KEY_PPPOE))) {
 		NL_SET_ERR_MSG_MOD(fltr->extack, "Unsupported key used");
 		return -EOPNOTSUPP;
 	}
@@ -1124,6 +1177,22 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 			headers->cvlan_hdr.vlan_prio = match.key->vlan_priority;
 	}
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PPPOE)) {
+		struct flow_match_pppoe match;
+
+		flow_rule_match_pppoe(rule, &match);
+		n_proto_key = ice_tc_set_pppoe(&match, fltr, headers);
+
+		/* If ethertype equals ETH_P_PPP_SES, n_proto might be
+		 * overwritten by encapsulated protocol (ppp_proto field) or set
+		 * to 0. To correct this, flow_match_pppoe provides the type
+		 * field, which contains the actual ethertype (ETH_P_PPP_SES).
+		 */
+		headers->l2_key.n_proto = cpu_to_be16(n_proto_key);
+		headers->l2_mask.n_proto = cpu_to_be16(0xFFFF);
+		fltr->flags |= ICE_TC_FLWR_FIELD_ETH_TYPE_ID;
+	}
+
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
 		struct flow_match_control match;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.h b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
index 0193874cd203..91cd3d3778c7 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
@@ -24,6 +24,8 @@
 #define ICE_TC_FLWR_FIELD_ETH_TYPE_ID		BIT(17)
 #define ICE_TC_FLWR_FIELD_ENC_OPTS		BIT(18)
 #define ICE_TC_FLWR_FIELD_CVLAN			BIT(19)
+#define ICE_TC_FLWR_FIELD_PPPOE_SESSID		BIT(20)
+#define ICE_TC_FLWR_FIELD_PPP_PROTO		BIT(21)
 
 #define ICE_TC_FLOWER_MASK_32   0xFFFFFFFF
 
@@ -44,6 +46,11 @@ struct ice_tc_vlan_hdr {
 	__be16 vlan_tpid;
 };
 
+struct ice_tc_pppoe_hdr {
+	__be16 session_id;
+	__be16 ppp_proto;
+};
+
 struct ice_tc_l2_hdr {
 	u8 dst_mac[ETH_ALEN];
 	u8 src_mac[ETH_ALEN];
@@ -84,6 +91,7 @@ struct ice_tc_flower_lyr_2_4_hdrs {
 	struct ice_tc_l2_hdr l2_mask;
 	struct ice_tc_vlan_hdr vlan_hdr;
 	struct ice_tc_vlan_hdr cvlan_hdr;
+	struct ice_tc_pppoe_hdr pppoe_hdr;
 	/* L3 (IPv4[6]) layer fields with their mask */
 	struct ice_tc_l3_hdr l3_key;
 	struct ice_tc_l3_hdr l3_mask;
-- 
2.35.1

