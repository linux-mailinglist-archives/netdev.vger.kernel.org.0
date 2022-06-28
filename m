Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8BC55CD35
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344058AbiF1LaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 07:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345541AbiF1LaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 07:30:06 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0607B24BF2
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 04:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656415805; x=1687951805;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qk14Dhs3ao9u3+d5/yRYh6eMfLGm453HNv5+tkIcnao=;
  b=bvTmAAMkUZEoq0ZMeDOuOJmvNg/1YulpxHfesnIpvTW2VbM5JP2GwJfc
   SS+EJ60FTFQa4HUmEzYsJgYqOK3aXc/ejcO8RweHfxPW4gKm6gqPlvx+q
   rwXhLVQ1vPH+qaCNdpquYkjWMlAoMWz83QNC7EhjPJk9TAVWvKG08TjnB
   KQCBIzTlvliSUtkldVw5RgVXz6CjYB89dYEPai/gYMOUumsYcLxAK0oPD
   Cz2FnTPxAAoGXdKKFxFGK0MMFJLjKB892Sk/MJuMm1QPLb5giLFkb8WUX
   GEhhaK0oLkAFCvMeFhtnwwSMwjlVdmdchcdqiisq5LhWhyof65ovaf5iT
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="282806792"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="282806792"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 04:29:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="646875851"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 28 Jun 2022 04:29:44 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SBTb6b005664;
        Tue, 28 Jun 2022 12:29:42 +0100
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        xiyou.wangcong@gmail.com, jesse.brandeburg@intel.com,
        gustavoars@kernel.org, baowen.zheng@corigine.com,
        boris.sukholitko@broadcom.com, edumazet@google.com,
        kuba@kernel.org, jhs@mojatatu.com, jiri@resnulli.us,
        kurt@linutronix.de, pablo@netfilter.org, pabeni@redhat.com,
        paulb@nvidia.com, simon.horman@corigine.com,
        komachi.yoshiki@gmail.com, zhangkaiheb@126.com,
        intel-wired-lan@lists.osuosl.org,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        alexandr.lobakin@intel.com,
        Marcin Szycik <marcin.szycik@linux.intel.com>
Subject: [RFC PATCH net-next v2 4/4] ice: Add support for PPPoE hardware offload
Date:   Tue, 28 Jun 2022 13:29:18 +0200
Message-Id: <20220628112918.11296-5-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628112918.11296-1-marcin.szycik@linux.intel.com>
References: <20220628112918.11296-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for creating PPPoE filters in switchdev mode. Add support
for parsing PPPoE and PPP-specific tc options: pppoe_sid and ppp_proto.

Example filter:
tc filter add dev $PF1 ingress protocol ppp_ses prio 1 flower pppoe_sid \
    1234 ppp_proto ip skip_sw action mirred egress redirect dev $VF1_PR

Changes in iproute2 are required to use the new fields.

ICE COMMS DDP package is required to create a filter as it contains PPPoE
profiles. Added a warning message when loaded DDP package does not contain
required profiles.

Note: currently matching on vlan + PPPoE fields is not supported. Patch [0]
will add this feature.

[0] https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20220420210048.5809-1-martyna.szapar-mudlaw@intel.com

Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
---
v2: wrap one long line

 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |   5 +-
 .../ethernet/intel/ice/ice_protocol_type.h    |  11 ++
 drivers/net/ethernet/intel/ice/ice_switch.c   | 165 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  95 ++++++++--
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   8 +
 6 files changed, 274 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 60453b3b8d23..0e48a930f004 100644
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
index c73cdab44f70..14fdd73a83be 100644
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
index 3f64300b0e14..4b7471a25551 100644
--- a/drivers/net/ethernet/intel/ice/ice_protocol_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
@@ -43,6 +43,7 @@ enum ice_protocol_type {
 	ICE_NVGRE,
 	ICE_GTP,
 	ICE_GTP_NO_PAY,
+	ICE_PPPOE,
 	ICE_VXLAN_GPE,
 	ICE_SCTP_IL,
 	ICE_PROTOCOL_LAST
@@ -107,6 +108,7 @@ enum ice_prot_id {
 #define ICE_TCP_IL_HW		49
 #define ICE_UDP_ILOS_HW		53
 #define ICE_GRE_OF_HW		64
+#define ICE_PPPOE_HW		103
 
 #define ICE_UDP_OF_HW	52 /* UDP Tunnels */
 #define ICE_META_DATA_ID_HW 255 /* this is used for tunnel type */
@@ -200,6 +202,14 @@ struct ice_udp_gtp_hdr {
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
@@ -217,6 +227,7 @@ union ice_prot_hdr {
 	struct ice_udp_tnl_hdr tnl_hdr;
 	struct ice_nvgre_hdr nvgre_hdr;
 	struct ice_udp_gtp_hdr gtp_hdr;
+	struct ice_pppoe_hdr pppoe_hdr;
 };
 
 /* This is mapping table entry that maps every word within a given protocol
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 8d8f3eec79ee..99af56264f8a 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -41,6 +41,7 @@ enum {
 	ICE_PKT_INNER_TCP	= BIT(7),
 	ICE_PKT_INNER_UDP	= BIT(8),
 	ICE_PKT_GTP_NOPAY	= BIT(9),
+	ICE_PKT_PPPOE		= BIT(10),
 };
 
 struct ice_dummy_pkt_offsets {
@@ -1233,6 +1234,154 @@ ICE_DECLARE_PKT_TEMPLATE(ipv6_gtp) = {
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
@@ -1259,6 +1408,11 @@ static const struct ice_dummy_pkt_profile ice_dummy_pkt_profiles[] = {
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
@@ -4609,6 +4763,7 @@ static const struct ice_prot_ext_tbl_entry ice_prot_ext[ICE_PROTOCOL_LAST] = {
 	{ ICE_NVGRE,		{ 0, 2, 4, 6 } },
 	{ ICE_GTP,		{ 8, 10, 12, 14, 16, 18, 20, 22 } },
 	{ ICE_GTP_NO_PAY,	{ 8, 10, 12, 14 } },
+	{ ICE_PPPOE,		{ 0, 2, 4, 6 } },
 };
 
 static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {
@@ -4629,6 +4784,7 @@ static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {
 	{ ICE_NVGRE,		ICE_GRE_OF_HW },
 	{ ICE_GTP,		ICE_UDP_OF_HW },
 	{ ICE_GTP_NO_PAY,	ICE_UDP_ILOS_HW },
+	{ ICE_PPPOE,		ICE_PPPOE_HW },
 };
 
 /**
@@ -5615,6 +5771,12 @@ ice_find_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
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
@@ -5707,6 +5869,9 @@ ice_fill_adv_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
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
index b803f2ab3cc7..c14483248b73 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -50,6 +50,11 @@ ice_tc_count_lkups(u32 flags, struct ice_tc_flower_lyr_2_4_hdrs *headers,
 	if (flags & ICE_TC_FLWR_FIELD_VLAN)
 		lkups_cnt++;
 
+	/* are PPPoE options specified? */
+	if (flags & (ICE_TC_FLWR_FIELD_PPPOE_SESSID |
+		     ICE_TC_FLWR_FIELD_PPP_PROTO))
+		lkups_cnt++;
+
 	/* are IPv[4|6] fields specified? */
 	if (flags & (ICE_TC_FLWR_FIELD_DEST_IPV4 | ICE_TC_FLWR_FIELD_SRC_IPV4 |
 		     ICE_TC_FLWR_FIELD_DEST_IPV6 | ICE_TC_FLWR_FIELD_SRC_IPV6))
@@ -317,6 +322,28 @@ ice_tc_fill_rules(struct ice_hw *hw, u32 flags,
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
@@ -660,6 +687,33 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
 	return ret;
 }
 
+/**
+ * ice_tc_set_pppoe - Parse PPPoE fields from TC flower filter
+ * @match: Pointer to flow match structure
+ * @fltr: Pointer to filter structure
+ * @headers: Pointer to outer header fields
+ * @returns Whether ppp_proto field was used
+ */
+static bool
+ice_tc_set_pppoe(struct flow_match_pppoe *match,
+		 struct ice_tc_flower_fltr *fltr,
+		 struct ice_tc_flower_lyr_2_4_hdrs *headers)
+{
+	if (match->mask->session_id) {
+		fltr->flags |= ICE_TC_FLWR_FIELD_PPPOE_SESSID;
+		headers->pppoe_hdr.session_id =
+			cpu_to_be16(match->key->session_id);
+	}
+
+	if (match->mask->ppp_proto) {
+		fltr->flags |= ICE_TC_FLWR_FIELD_PPP_PROTO;
+		headers->pppoe_hdr.ppp_proto = match->key->ppp_proto;
+		return true;
+	}
+
+	return false;
+}
+
 /**
  * ice_tc_set_ipv4 - Parse IPv4 addresses from TC flower filter
  * @match: Pointer to flow match structure
@@ -937,6 +991,7 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 	u16 n_proto_mask = 0, n_proto_key = 0, addr_type = 0;
 	struct flow_dissector *dissector;
 	struct net_device *tunnel_dev;
+	bool ppp_proto_present = false;
 
 	dissector = rule->match.dissector;
 
@@ -954,7 +1009,8 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 	      BIT(FLOW_DISSECTOR_KEY_ENC_PORTS) |
 	      BIT(FLOW_DISSECTOR_KEY_ENC_OPTS) |
 	      BIT(FLOW_DISSECTOR_KEY_ENC_IP) |
-	      BIT(FLOW_DISSECTOR_KEY_PORTS))) {
+	      BIT(FLOW_DISSECTOR_KEY_PORTS) |
+	      BIT(FLOW_DISSECTOR_KEY_PPPOE))) {
 		NL_SET_ERR_MSG_MOD(fltr->extack, "Unsupported key used");
 		return -EOPNOTSUPP;
 	}
@@ -986,21 +1042,40 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 		fltr->tunnel_type = TNL_LAST;
 	}
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PPPOE)) {
+		struct flow_match_pppoe match;
+
+		flow_rule_match_pppoe(rule, &match);
+		ppp_proto_present = ice_tc_set_pppoe(&match, fltr, headers);
+	}
+
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
 		struct flow_match_basic match;
 
 		flow_rule_match_basic(rule, &match);
 
-		n_proto_key = ntohs(match.key->n_proto);
-		n_proto_mask = ntohs(match.mask->n_proto);
-
-		if (n_proto_key == ETH_P_ALL || n_proto_key == 0 ||
-		    fltr->tunnel_type == TNL_GTPU ||
-		    fltr->tunnel_type == TNL_GTPC) {
-			n_proto_key = 0;
-			n_proto_mask = 0;
+		if (ppp_proto_present) {
+			/* When ppp_proto field is specified, it also overwrites
+			 * ethertype field with its value. E.g. if tc command is
+			 * ... protocol ppp_ses ... ppp_proto ip ...
+			 * it will result in ppp_proto=ip and n_proto_key=ip.
+			 * n_proto_key needs to be set to the proper value,
+			 * i.e. ppp_ses.
+			 */
+			n_proto_key = ETH_P_PPP_SES;
+			n_proto_mask = 0xFFFF;
 		} else {
-			fltr->flags |= ICE_TC_FLWR_FIELD_ETH_TYPE_ID;
+			n_proto_key = ntohs(match.key->n_proto);
+			n_proto_mask = ntohs(match.mask->n_proto);
+
+			if (n_proto_key == ETH_P_ALL || n_proto_key == 0 ||
+			    fltr->tunnel_type == TNL_GTPU ||
+			    fltr->tunnel_type == TNL_GTPC) {
+				n_proto_key = 0;
+				n_proto_mask = 0;
+			} else {
+				fltr->flags |= ICE_TC_FLWR_FIELD_ETH_TYPE_ID;
+			}
 		}
 
 		headers->l2_key.n_proto = cpu_to_be16(n_proto_key);
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.h b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
index e25e958f4396..efbd9c0a54ec 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
@@ -23,6 +23,8 @@
 #define ICE_TC_FLWR_FIELD_ENC_DST_MAC		BIT(16)
 #define ICE_TC_FLWR_FIELD_ETH_TYPE_ID		BIT(17)
 #define ICE_TC_FLWR_FIELD_ENC_OPTS		BIT(18)
+#define ICE_TC_FLWR_FIELD_PPPOE_SESSID		BIT(19)
+#define ICE_TC_FLWR_FIELD_PPP_PROTO		BIT(20)
 
 #define ICE_TC_FLOWER_MASK_32   0xFFFFFFFF
 
@@ -42,6 +44,11 @@ struct ice_tc_vlan_hdr {
 	u16 vlan_prio; /* Only last 3 bits valid (valid values: 0..7) */
 };
 
+struct ice_tc_pppoe_hdr {
+	__be16 session_id;
+	__be16 ppp_proto;
+};
+
 struct ice_tc_l2_hdr {
 	u8 dst_mac[ETH_ALEN];
 	u8 src_mac[ETH_ALEN];
@@ -81,6 +88,7 @@ struct ice_tc_flower_lyr_2_4_hdrs {
 	struct ice_tc_l2_hdr l2_key;
 	struct ice_tc_l2_hdr l2_mask;
 	struct ice_tc_vlan_hdr vlan_hdr;
+	struct ice_tc_pppoe_hdr pppoe_hdr;
 	/* L3 (IPv4[6]) layer fields with their mask */
 	struct ice_tc_l3_hdr l3_key;
 	struct ice_tc_l3_hdr l3_mask;
-- 
2.35.1

