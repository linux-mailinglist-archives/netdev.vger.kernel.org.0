Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3A049E66A
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 16:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243054AbiA0Pmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 10:42:55 -0500
Received: from mga04.intel.com ([192.55.52.120]:23622 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243123AbiA0Pms (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 10:42:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643298168; x=1674834168;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pgpF1HclREDWxl4bKSRDHExPzqY2ZGLaOCIggkW8uK4=;
  b=BhIQ0OUXUBogc8awatZRkFe8pZz9MiPNMgKzwYgzpI4GMvsAgHBQNBvW
   RWC1jCF+wgDjEIske7oWNejnKqqEmoJWr6Hu2RV0P8bwlsYupSSmwDrhu
   45WCZdyU5X6aikdSf4S+gtPAp2329T7CPOuV8lQSwac0Y3iTu1DIu3G8B
   nlDBylTJ7f6AunoEVi/Fj9zV4wvI+36H+0ruW+/QZ/ygF7XnY3SGItcUz
   5S02JkeZWHakVdOYlHBwF8vGk3LtIgUYeRUYWPfjTCZU9j1so+IOsSZ9G
   IL0/Sfwqc2njYxy6+iwRDuxDvxubFhIt5nPs4YrEuq4xB/yKnyDF+rFLj
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="245730421"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="245730421"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 07:41:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="535705389"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 27 Jan 2022 07:41:49 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20RFfjOr028674;
        Thu, 27 Jan 2022 15:41:48 GMT
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
Subject: [PATCH v2 net-next 4/4] ice: switch: use convenience macros to declare dummy pkt templates
Date:   Thu, 27 Jan 2022 16:40:09 +0100
Message-Id: <20220127154009.623304-5-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127154009.623304-1-alexandr.lobakin@intel.com>
References: <20220127154009.623304-1-alexandr.lobakin@intel.com>
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
index 68202671a114..2105cae0f2f8 100644
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

