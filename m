Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43AF04986E8
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244691AbiAXRdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:33:21 -0500
Received: from mga17.intel.com ([192.55.52.151]:16093 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244667AbiAXRdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 12:33:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643045597; x=1674581597;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gCeImJKbrgw9VI8s/j6tZwCq2OiZ54ak/rjb6IbQbG0=;
  b=iGV3s8ko1R4A2ZG9grCIcUp55KjgcuO0fhnrsOqTSaWOSYA0jLm7qRBB
   VbJ+zST7Y1wTt+AQAYqPbT0JjfT+IXwOaeq+u9Oho2U5XA18GXS8CaAgO
   wwi8mRMdZjmQZFwEoVvDLccmVXCRcQrPujH+DA3DAbpa5N7/rIFGK6hJR
   hr2sCdFueeISOstT88uYjh7wqgiiksFsnWSTLeqkgFcRa6DO4oi+3ZjjF
   tfJ//ujwJZ475x5fIvWbdZp0z1S8RVjrpTVTGHGcC5QhMwyp/de/6LHgz
   ng7r0R6Cu/cmzbC+r/dSCv6hFeSqp5bJOsw8awDh9bcGHMFakv6eaKR00
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="226773823"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="226773823"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 09:33:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="520030865"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 24 Jan 2022 09:33:00 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20OHWuIs010465;
        Mon, 24 Jan 2022 17:32:59 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/4] ice: switch: use convenience macros to declare dummy pkt templates
Date:   Mon, 24 Jan 2022 18:31:15 +0100
Message-Id: <20220124173116.739083-5-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124173116.739083-1-alexandr.lobakin@intel.com>
References: <20220124173116.739083-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Declarations of dummy/template packet headers and offsets can be
minified to improve readability and simplify adding new templates.
Move all the repetitive constructions into two macros and let them
do the name and type expansions.
Linewrap removal is yet another positive side effect.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 83 +++++++++++----------
 1 file changed, 42 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 557b45f660ea..a892298bb243 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -41,15 +41,22 @@ struct ice_dummy_pkt_profile {
 	u16 pkt_len;
 };
 
+#define ICE_PKT_OFFSETS(type)						\
+	static const struct ice_dummy_pkt_offsets			\
+	ice_dummy_##type##_packet_offsets[]
+
+#define ICE_PKT_TEMPLATE(type)						\
+	static const u8 ice_dummy_##type##_packet[]
+
 #define ICE_PKT_PROFILE(type) ({					\
 	(struct ice_dummy_pkt_profile){					\
-		.pkt		= dummy_##type##_packet,		\
-		.pkt_len	= sizeof(dummy_##type##_packet),	\
-		.offsets	= dummy_##type##_packet_offsets,	\
+		.pkt		= ice_dummy_##type##_packet,		\
+		.pkt_len	= sizeof(ice_dummy_##type##_packet),	\
+		.offsets	= ice_dummy_##type##_packet_offsets,	\
 	};								\
 })
 
-static const struct ice_dummy_pkt_offsets dummy_gre_tcp_packet_offsets[] = {
+ICE_PKT_OFFSETS(gre_tcp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV4_OFOS,	14 },
@@ -61,7 +68,7 @@ static const struct ice_dummy_pkt_offsets dummy_gre_tcp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_gre_tcp_packet[] = {
+ICE_PKT_TEMPLATE(gre_tcp) = {
 	0x00, 0x00, 0x00, 0x00,	/* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -96,7 +103,7 @@ static const u8 dummy_gre_tcp_packet[] = {
 	0x00, 0x00, 0x00, 0x00
 };
 
-static const struct ice_dummy_pkt_offsets dummy_gre_udp_packet_offsets[] = {
+ICE_PKT_OFFSETS(gre_udp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV4_OFOS,	14 },
@@ -108,7 +115,7 @@ static const struct ice_dummy_pkt_offsets dummy_gre_udp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_gre_udp_packet[] = {
+ICE_PKT_TEMPLATE(gre_udp) = {
 	0x00, 0x00, 0x00, 0x00,	/* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -140,7 +147,7 @@ static const u8 dummy_gre_udp_packet[] = {
 	0x00, 0x08, 0x00, 0x00,
 };
 
-static const struct ice_dummy_pkt_offsets dummy_udp_tun_tcp_packet_offsets[] = {
+ICE_PKT_OFFSETS(udp_tun_tcp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV4_OFOS,	14 },
@@ -155,7 +162,7 @@ static const struct ice_dummy_pkt_offsets dummy_udp_tun_tcp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_udp_tun_tcp_packet[] = {
+ICE_PKT_TEMPLATE(udp_tun_tcp) = {
 	0x00, 0x00, 0x00, 0x00,  /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -193,7 +200,7 @@ static const u8 dummy_udp_tun_tcp_packet[] = {
 	0x00, 0x00, 0x00, 0x00
 };
 
-static const struct ice_dummy_pkt_offsets dummy_udp_tun_udp_packet_offsets[] = {
+ICE_PKT_OFFSETS(udp_tun_udp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV4_OFOS,	14 },
@@ -208,7 +215,7 @@ static const struct ice_dummy_pkt_offsets dummy_udp_tun_udp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_udp_tun_udp_packet[] = {
+ICE_PKT_TEMPLATE(udp_tun_udp) = {
 	0x00, 0x00, 0x00, 0x00,  /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -243,8 +250,7 @@ static const u8 dummy_udp_tun_udp_packet[] = {
 	0x00, 0x08, 0x00, 0x00,
 };
 
-static const struct ice_dummy_pkt_offsets
-dummy_gre_ipv6_tcp_packet_offsets[] = {
+ICE_PKT_OFFSETS(gre_ipv6_tcp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV4_OFOS,	14 },
@@ -256,7 +262,7 @@ dummy_gre_ipv6_tcp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_gre_ipv6_tcp_packet[] = {
+ICE_PKT_TEMPLATE(gre_ipv6_tcp) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -296,8 +302,7 @@ static const u8 dummy_gre_ipv6_tcp_packet[] = {
 	0x00, 0x00, 0x00, 0x00
 };
 
-static const struct ice_dummy_pkt_offsets
-dummy_gre_ipv6_udp_packet_offsets[] = {
+ICE_PKT_OFFSETS(gre_ipv6_udp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV4_OFOS,	14 },
@@ -309,7 +314,7 @@ dummy_gre_ipv6_udp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_gre_ipv6_udp_packet[] = {
+ICE_PKT_TEMPLATE(gre_ipv6_udp) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -346,8 +351,7 @@ static const u8 dummy_gre_ipv6_udp_packet[] = {
 	0x00, 0x08, 0x00, 0x00,
 };
 
-static const struct ice_dummy_pkt_offsets
-dummy_udp_tun_ipv6_tcp_packet_offsets[] = {
+ICE_PKT_OFFSETS(udp_tun_ipv6_tcp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV4_OFOS,	14 },
@@ -362,7 +366,7 @@ dummy_udp_tun_ipv6_tcp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_udp_tun_ipv6_tcp_packet[] = {
+ICE_PKT_TEMPLATE(udp_tun_ipv6_tcp) = {
 	0x00, 0x00, 0x00, 0x00,  /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -405,8 +409,7 @@ static const u8 dummy_udp_tun_ipv6_tcp_packet[] = {
 	0x00, 0x00, 0x00, 0x00
 };
 
-static const struct ice_dummy_pkt_offsets
-dummy_udp_tun_ipv6_udp_packet_offsets[] = {
+ICE_PKT_OFFSETS(udp_tun_ipv6_udp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV4_OFOS,	14 },
@@ -421,7 +424,7 @@ dummy_udp_tun_ipv6_udp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_udp_tun_ipv6_udp_packet[] = {
+ICE_PKT_TEMPLATE(udp_tun_ipv6_udp) = {
 	0x00, 0x00, 0x00, 0x00,  /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -462,7 +465,7 @@ static const u8 dummy_udp_tun_ipv6_udp_packet[] = {
 };
 
 /* offset info for MAC + IPv4 + UDP dummy packet */
-static const struct ice_dummy_pkt_offsets dummy_udp_packet_offsets[] = {
+ICE_PKT_OFFSETS(udp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV4_OFOS,	14 },
@@ -471,7 +474,7 @@ static const struct ice_dummy_pkt_offsets dummy_udp_packet_offsets[] = {
 };
 
 /* Dummy packet for MAC + IPv4 + UDP */
-static const u8 dummy_udp_packet[] = {
+ICE_PKT_TEMPLATE(udp) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -491,7 +494,7 @@ static const u8 dummy_udp_packet[] = {
 };
 
 /* offset info for MAC + VLAN + IPv4 + UDP dummy packet */
-static const struct ice_dummy_pkt_offsets dummy_vlan_udp_packet_offsets[] = {
+ICE_PKT_OFFSETS(vlan_udp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_VLAN_OFOS,	12 },
 	{ ICE_ETYPE_OL,		16 },
@@ -501,7 +504,7 @@ static const struct ice_dummy_pkt_offsets dummy_vlan_udp_packet_offsets[] = {
 };
 
 /* C-tag (801.1Q), IPv4:UDP dummy packet */
-static const u8 dummy_vlan_udp_packet[] = {
+ICE_PKT_TEMPLATE(vlan_udp) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -523,7 +526,7 @@ static const u8 dummy_vlan_udp_packet[] = {
 };
 
 /* offset info for MAC + IPv4 + TCP dummy packet */
-static const struct ice_dummy_pkt_offsets dummy_tcp_packet_offsets[] = {
+ICE_PKT_OFFSETS(tcp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV4_OFOS,	14 },
@@ -532,7 +535,7 @@ static const struct ice_dummy_pkt_offsets dummy_tcp_packet_offsets[] = {
 };
 
 /* Dummy packet for MAC + IPv4 + TCP */
-static const u8 dummy_tcp_packet[] = {
+ICE_PKT_TEMPLATE(tcp) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -555,7 +558,7 @@ static const u8 dummy_tcp_packet[] = {
 };
 
 /* offset info for MAC + VLAN (C-tag, 802.1Q) + IPv4 + TCP dummy packet */
-static const struct ice_dummy_pkt_offsets dummy_vlan_tcp_packet_offsets[] = {
+ICE_PKT_OFFSETS(vlan_tcp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_VLAN_OFOS,	12 },
 	{ ICE_ETYPE_OL,		16 },
@@ -565,7 +568,7 @@ static const struct ice_dummy_pkt_offsets dummy_vlan_tcp_packet_offsets[] = {
 };
 
 /* C-tag (801.1Q), IPv4:TCP dummy packet */
-static const u8 dummy_vlan_tcp_packet[] = {
+ICE_PKT_TEMPLATE(vlan_tcp) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -589,7 +592,7 @@ static const u8 dummy_vlan_tcp_packet[] = {
 	0x00, 0x00,	/* 2 bytes for 4 byte alignment */
 };
 
-static const struct ice_dummy_pkt_offsets dummy_tcp_ipv6_packet_offsets[] = {
+ICE_PKT_OFFSETS(tcp_ipv6) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV6_OFOS,	14 },
@@ -597,7 +600,7 @@ static const struct ice_dummy_pkt_offsets dummy_tcp_ipv6_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_tcp_ipv6_packet[] = {
+ICE_PKT_TEMPLATE(tcp_ipv6) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -625,8 +628,7 @@ static const u8 dummy_tcp_ipv6_packet[] = {
 };
 
 /* C-tag (802.1Q): IPv6 + TCP */
-static const struct ice_dummy_pkt_offsets
-dummy_vlan_tcp_ipv6_packet_offsets[] = {
+ICE_PKT_OFFSETS(vlan_tcp_ipv6) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_VLAN_OFOS,	12 },
 	{ ICE_ETYPE_OL,		16 },
@@ -636,7 +638,7 @@ dummy_vlan_tcp_ipv6_packet_offsets[] = {
 };
 
 /* C-tag (802.1Q), IPv6 + TCP dummy packet */
-static const u8 dummy_vlan_tcp_ipv6_packet[] = {
+ICE_PKT_TEMPLATE(vlan_tcp_ipv6) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -666,7 +668,7 @@ static const u8 dummy_vlan_tcp_ipv6_packet[] = {
 };
 
 /* IPv6 + UDP */
-static const struct ice_dummy_pkt_offsets dummy_udp_ipv6_packet_offsets[] = {
+ICE_PKT_OFFSETS(udp_ipv6) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV6_OFOS,	14 },
@@ -675,7 +677,7 @@ static const struct ice_dummy_pkt_offsets dummy_udp_ipv6_packet_offsets[] = {
 };
 
 /* IPv6 + UDP dummy packet */
-static const u8 dummy_udp_ipv6_packet[] = {
+ICE_PKT_TEMPLATE(udp_ipv6) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -703,8 +705,7 @@ static const u8 dummy_udp_ipv6_packet[] = {
 };
 
 /* C-tag (802.1Q): IPv6 + UDP */
-static const struct ice_dummy_pkt_offsets
-dummy_vlan_udp_ipv6_packet_offsets[] = {
+ICE_PKT_OFFSETS(vlan_udp_ipv6) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_VLAN_OFOS,	12 },
 	{ ICE_ETYPE_OL,		16 },
@@ -714,7 +715,7 @@ dummy_vlan_udp_ipv6_packet_offsets[] = {
 };
 
 /* C-tag (802.1Q), IPv6 + UDP dummy packet */
-static const u8 dummy_vlan_udp_ipv6_packet[] = {
+ICE_PKT_TEMPLATE(vlan_udp_ipv6) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
-- 
2.34.1

