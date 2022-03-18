Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D9D4DDEBE
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239053AbiCRQX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239105AbiCRQXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:23:30 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC539F6CB;
        Fri, 18 Mar 2022 09:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647620390; x=1679156390;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qMjhIkLt6W0+6Lbt3Yyz+N3duk23vmNc2+yCEC07C3U=;
  b=hhFPwJJBQ8fDxsz3gR27ZQzZE0AOUOqHPLswUW4/PQa/Q3JocAUjObr9
   rfcGaEmXiqNOA7n++l/z5DOLlhl/9iDtMK/zR55GI8ydt79TuPfZefL4l
   leo2O4SYJI6lgEEJ8o9VUKvleO0sbAJh/IkpyUTcNplv4VKOIQ6gENHJ4
   HEtrsInqijBT38OtBeDaxuKwyjZIMWz4F7W/FeYIHWiicqwJn6xOLhwyM
   2xawrvmKzOzv0cYGZBqnSXlaV5HiQdwZZVg+qojebi2AH8N9S03+N/P8U
   6/ESIMKl1pLDVzdvPXxSL45R9g8QR0s4jy9njsRaNGvp4+XdwihWvtvzx
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="237111694"
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="237111694"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 09:18:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="599551816"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 18 Mar 2022 09:18:28 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22IGIOmG024113;
        Fri, 18 Mar 2022 16:18:27 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 4/5] ice: switch: use convenience macros to declare dummy pkt templates
Date:   Fri, 18 Mar 2022 17:17:12 +0100
Message-Id: <20220318161713.680436-5-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220318161713.680436-1-alexandr.lobakin@intel.com>
References: <20220318161713.680436-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Declarations of dummy/template packet headers and offsets can be
minified to improve readability and simplify adding new templates.
Move all the repetitive constructions into two macros and let them
do the name and type expansions.
Linewrap removal is yet another positive side effect.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Marcin Szycik <marcin.szycik@linux.intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 133 +++++++++-----------
 1 file changed, 62 insertions(+), 71 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 12fb0f6aa350..8d4e49173dd1 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -41,15 +41,22 @@ struct ice_dummy_pkt_profile {
 	u64 pkt_len:16;
 };
 
+#define ICE_DECLARE_PKT_OFFSETS(type)					\
+	static const struct ice_dummy_pkt_offsets			\
+	ice_dummy_##type##_packet_offsets[]
+
+#define ICE_DECLARE_PKT_TEMPLATE(type)					\
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
+ICE_DECLARE_PKT_OFFSETS(gre_tcp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV4_OFOS,	14 },
@@ -61,7 +68,7 @@ static const struct ice_dummy_pkt_offsets dummy_gre_tcp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_gre_tcp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(gre_tcp) = {
 	0x00, 0x00, 0x00, 0x00,	/* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -96,7 +103,7 @@ static const u8 dummy_gre_tcp_packet[] = {
 	0x00, 0x00, 0x00, 0x00
 };
 
-static const struct ice_dummy_pkt_offsets dummy_gre_udp_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(gre_udp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV4_OFOS,	14 },
@@ -108,7 +115,7 @@ static const struct ice_dummy_pkt_offsets dummy_gre_udp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_gre_udp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(gre_udp) = {
 	0x00, 0x00, 0x00, 0x00,	/* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -140,7 +147,7 @@ static const u8 dummy_gre_udp_packet[] = {
 	0x00, 0x08, 0x00, 0x00,
 };
 
-static const struct ice_dummy_pkt_offsets dummy_udp_tun_tcp_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(udp_tun_tcp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV4_OFOS,	14 },
@@ -155,7 +162,7 @@ static const struct ice_dummy_pkt_offsets dummy_udp_tun_tcp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_udp_tun_tcp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(udp_tun_tcp) = {
 	0x00, 0x00, 0x00, 0x00,  /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -193,7 +200,7 @@ static const u8 dummy_udp_tun_tcp_packet[] = {
 	0x00, 0x00, 0x00, 0x00
 };
 
-static const struct ice_dummy_pkt_offsets dummy_udp_tun_udp_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(udp_tun_udp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV4_OFOS,	14 },
@@ -208,7 +215,7 @@ static const struct ice_dummy_pkt_offsets dummy_udp_tun_udp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_udp_tun_udp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(udp_tun_udp) = {
 	0x00, 0x00, 0x00, 0x00,  /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -243,8 +250,7 @@ static const u8 dummy_udp_tun_udp_packet[] = {
 	0x00, 0x08, 0x00, 0x00,
 };
 
-static const struct ice_dummy_pkt_offsets
-dummy_gre_ipv6_tcp_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(gre_ipv6_tcp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV4_OFOS,	14 },
@@ -256,7 +262,7 @@ dummy_gre_ipv6_tcp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_gre_ipv6_tcp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(gre_ipv6_tcp) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -296,8 +302,7 @@ static const u8 dummy_gre_ipv6_tcp_packet[] = {
 	0x00, 0x00, 0x00, 0x00
 };
 
-static const struct ice_dummy_pkt_offsets
-dummy_gre_ipv6_udp_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(gre_ipv6_udp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV4_OFOS,	14 },
@@ -309,7 +314,7 @@ dummy_gre_ipv6_udp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_gre_ipv6_udp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(gre_ipv6_udp) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -346,8 +351,7 @@ static const u8 dummy_gre_ipv6_udp_packet[] = {
 	0x00, 0x08, 0x00, 0x00,
 };
 
-static const struct ice_dummy_pkt_offsets
-dummy_udp_tun_ipv6_tcp_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(udp_tun_ipv6_tcp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV4_OFOS,	14 },
@@ -362,7 +366,7 @@ dummy_udp_tun_ipv6_tcp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_udp_tun_ipv6_tcp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(udp_tun_ipv6_tcp) = {
 	0x00, 0x00, 0x00, 0x00,  /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -405,8 +409,7 @@ static const u8 dummy_udp_tun_ipv6_tcp_packet[] = {
 	0x00, 0x00, 0x00, 0x00
 };
 
-static const struct ice_dummy_pkt_offsets
-dummy_udp_tun_ipv6_udp_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(udp_tun_ipv6_udp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV4_OFOS,	14 },
@@ -421,7 +424,7 @@ dummy_udp_tun_ipv6_udp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_udp_tun_ipv6_udp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(udp_tun_ipv6_udp) = {
 	0x00, 0x00, 0x00, 0x00,  /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -462,7 +465,7 @@ static const u8 dummy_udp_tun_ipv6_udp_packet[] = {
 };
 
 /* offset info for MAC + IPv4 + UDP dummy packet */
-static const struct ice_dummy_pkt_offsets dummy_udp_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(udp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV4_OFOS,	14 },
@@ -471,7 +474,7 @@ static const struct ice_dummy_pkt_offsets dummy_udp_packet_offsets[] = {
 };
 
 /* Dummy packet for MAC + IPv4 + UDP */
-static const u8 dummy_udp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(udp) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -491,7 +494,7 @@ static const u8 dummy_udp_packet[] = {
 };
 
 /* offset info for MAC + VLAN + IPv4 + UDP dummy packet */
-static const struct ice_dummy_pkt_offsets dummy_vlan_udp_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(vlan_udp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_VLAN_OFOS,	12 },
 	{ ICE_ETYPE_OL,		16 },
@@ -501,7 +504,7 @@ static const struct ice_dummy_pkt_offsets dummy_vlan_udp_packet_offsets[] = {
 };
 
 /* C-tag (801.1Q), IPv4:UDP dummy packet */
-static const u8 dummy_vlan_udp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(vlan_udp) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -523,7 +526,7 @@ static const u8 dummy_vlan_udp_packet[] = {
 };
 
 /* offset info for MAC + IPv4 + TCP dummy packet */
-static const struct ice_dummy_pkt_offsets dummy_tcp_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(tcp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV4_OFOS,	14 },
@@ -532,7 +535,7 @@ static const struct ice_dummy_pkt_offsets dummy_tcp_packet_offsets[] = {
 };
 
 /* Dummy packet for MAC + IPv4 + TCP */
-static const u8 dummy_tcp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(tcp) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -555,7 +558,7 @@ static const u8 dummy_tcp_packet[] = {
 };
 
 /* offset info for MAC + VLAN (C-tag, 802.1Q) + IPv4 + TCP dummy packet */
-static const struct ice_dummy_pkt_offsets dummy_vlan_tcp_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(vlan_tcp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_VLAN_OFOS,	12 },
 	{ ICE_ETYPE_OL,		16 },
@@ -565,7 +568,7 @@ static const struct ice_dummy_pkt_offsets dummy_vlan_tcp_packet_offsets[] = {
 };
 
 /* C-tag (801.1Q), IPv4:TCP dummy packet */
-static const u8 dummy_vlan_tcp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(vlan_tcp) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -589,7 +592,7 @@ static const u8 dummy_vlan_tcp_packet[] = {
 	0x00, 0x00,	/* 2 bytes for 4 byte alignment */
 };
 
-static const struct ice_dummy_pkt_offsets dummy_tcp_ipv6_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(tcp_ipv6) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV6_OFOS,	14 },
@@ -597,7 +600,7 @@ static const struct ice_dummy_pkt_offsets dummy_tcp_ipv6_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_tcp_ipv6_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(tcp_ipv6) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -625,8 +628,7 @@ static const u8 dummy_tcp_ipv6_packet[] = {
 };
 
 /* C-tag (802.1Q): IPv6 + TCP */
-static const struct ice_dummy_pkt_offsets
-dummy_vlan_tcp_ipv6_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(vlan_tcp_ipv6) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_VLAN_OFOS,	12 },
 	{ ICE_ETYPE_OL,		16 },
@@ -636,7 +638,7 @@ dummy_vlan_tcp_ipv6_packet_offsets[] = {
 };
 
 /* C-tag (802.1Q), IPv6 + TCP dummy packet */
-static const u8 dummy_vlan_tcp_ipv6_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(vlan_tcp_ipv6) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -666,7 +668,7 @@ static const u8 dummy_vlan_tcp_ipv6_packet[] = {
 };
 
 /* IPv6 + UDP */
-static const struct ice_dummy_pkt_offsets dummy_udp_ipv6_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(udp_ipv6) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_ETYPE_OL,		12 },
 	{ ICE_IPV6_OFOS,	14 },
@@ -675,7 +677,7 @@ static const struct ice_dummy_pkt_offsets dummy_udp_ipv6_packet_offsets[] = {
 };
 
 /* IPv6 + UDP dummy packet */
-static const u8 dummy_udp_ipv6_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(udp_ipv6) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -703,8 +705,7 @@ static const u8 dummy_udp_ipv6_packet[] = {
 };
 
 /* C-tag (802.1Q): IPv6 + UDP */
-static const struct ice_dummy_pkt_offsets
-dummy_vlan_udp_ipv6_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(vlan_udp_ipv6) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_VLAN_OFOS,	12 },
 	{ ICE_ETYPE_OL,		16 },
@@ -714,7 +715,7 @@ dummy_vlan_udp_ipv6_packet_offsets[] = {
 };
 
 /* C-tag (802.1Q), IPv6 + UDP dummy packet */
-static const u8 dummy_vlan_udp_ipv6_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(vlan_udp_ipv6) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -741,8 +742,7 @@ static const u8 dummy_vlan_udp_ipv6_packet[] = {
 };
 
 /* Outer IPv4 + Outer UDP + GTP + Inner IPv4 + Inner TCP */
-static const
-struct ice_dummy_pkt_offsets dummy_ipv4_gtpu_ipv4_tcp_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(ipv4_gtpu_ipv4_tcp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_IPV4_OFOS,	14 },
 	{ ICE_UDP_OF,		34 },
@@ -752,7 +752,7 @@ struct ice_dummy_pkt_offsets dummy_ipv4_gtpu_ipv4_tcp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_ipv4_gtpu_ipv4_tcp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(ipv4_gtpu_ipv4_tcp) = {
 	0x00, 0x00, 0x00, 0x00, /* Ethernet 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -790,8 +790,7 @@ static const u8 dummy_ipv4_gtpu_ipv4_tcp_packet[] = {
 };
 
 /* Outer IPv4 + Outer UDP + GTP + Inner IPv4 + Inner UDP */
-static const
-struct ice_dummy_pkt_offsets dummy_ipv4_gtpu_ipv4_udp_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(ipv4_gtpu_ipv4_udp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_IPV4_OFOS,	14 },
 	{ ICE_UDP_OF,		34 },
@@ -801,7 +800,7 @@ struct ice_dummy_pkt_offsets dummy_ipv4_gtpu_ipv4_udp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_ipv4_gtpu_ipv4_udp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(ipv4_gtpu_ipv4_udp) = {
 	0x00, 0x00, 0x00, 0x00, /* Ethernet 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -836,8 +835,7 @@ static const u8 dummy_ipv4_gtpu_ipv4_udp_packet[] = {
 };
 
 /* Outer IPv6 + Outer UDP + GTP + Inner IPv4 + Inner TCP */
-static const
-struct ice_dummy_pkt_offsets dummy_ipv4_gtpu_ipv6_tcp_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(ipv4_gtpu_ipv6_tcp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_IPV4_OFOS,	14 },
 	{ ICE_UDP_OF,		34 },
@@ -847,7 +845,7 @@ struct ice_dummy_pkt_offsets dummy_ipv4_gtpu_ipv6_tcp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_ipv4_gtpu_ipv6_tcp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(ipv4_gtpu_ipv6_tcp) = {
 	0x00, 0x00, 0x00, 0x00, /* Ethernet 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -889,8 +887,7 @@ static const u8 dummy_ipv4_gtpu_ipv6_tcp_packet[] = {
 	0x00, 0x00, /* 2 bytes for 4 byte alignment */
 };
 
-static const
-struct ice_dummy_pkt_offsets dummy_ipv4_gtpu_ipv6_udp_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(ipv4_gtpu_ipv6_udp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_IPV4_OFOS,	14 },
 	{ ICE_UDP_OF,		34 },
@@ -900,7 +897,7 @@ struct ice_dummy_pkt_offsets dummy_ipv4_gtpu_ipv6_udp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_ipv4_gtpu_ipv6_udp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(ipv4_gtpu_ipv6_udp) = {
 	0x00, 0x00, 0x00, 0x00, /* Ethernet 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -939,8 +936,7 @@ static const u8 dummy_ipv4_gtpu_ipv6_udp_packet[] = {
 	0x00, 0x00, /* 2 bytes for 4 byte alignment */
 };
 
-static const
-struct ice_dummy_pkt_offsets dummy_ipv6_gtpu_ipv4_tcp_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(ipv6_gtpu_ipv4_tcp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_IPV6_OFOS,	14 },
 	{ ICE_UDP_OF,		54 },
@@ -950,7 +946,7 @@ struct ice_dummy_pkt_offsets dummy_ipv6_gtpu_ipv4_tcp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_ipv6_gtpu_ipv4_tcp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(ipv6_gtpu_ipv4_tcp) = {
 	0x00, 0x00, 0x00, 0x00, /* Ethernet 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -992,8 +988,7 @@ static const u8 dummy_ipv6_gtpu_ipv4_tcp_packet[] = {
 	0x00, 0x00, /* 2 bytes for 4 byte alignment */
 };
 
-static const
-struct ice_dummy_pkt_offsets dummy_ipv6_gtpu_ipv4_udp_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(ipv6_gtpu_ipv4_udp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_IPV6_OFOS,	14 },
 	{ ICE_UDP_OF,		54 },
@@ -1003,7 +998,7 @@ struct ice_dummy_pkt_offsets dummy_ipv6_gtpu_ipv4_udp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_ipv6_gtpu_ipv4_udp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(ipv6_gtpu_ipv4_udp) = {
 	0x00, 0x00, 0x00, 0x00, /* Ethernet 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -1042,8 +1037,7 @@ static const u8 dummy_ipv6_gtpu_ipv4_udp_packet[] = {
 	0x00, 0x00, /* 2 bytes for 4 byte alignment */
 };
 
-static const
-struct ice_dummy_pkt_offsets dummy_ipv6_gtpu_ipv6_tcp_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(ipv6_gtpu_ipv6_tcp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_IPV6_OFOS,	14 },
 	{ ICE_UDP_OF,		54 },
@@ -1053,7 +1047,7 @@ struct ice_dummy_pkt_offsets dummy_ipv6_gtpu_ipv6_tcp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_ipv6_gtpu_ipv6_tcp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(ipv6_gtpu_ipv6_tcp) = {
 	0x00, 0x00, 0x00, 0x00, /* Ethernet 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -1100,8 +1094,7 @@ static const u8 dummy_ipv6_gtpu_ipv6_tcp_packet[] = {
 	0x00, 0x00, /* 2 bytes for 4 byte alignment */
 };
 
-static const
-struct ice_dummy_pkt_offsets dummy_ipv6_gtpu_ipv6_udp_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(ipv6_gtpu_ipv6_udp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_IPV6_OFOS,	14 },
 	{ ICE_UDP_OF,		54 },
@@ -1111,7 +1104,7 @@ struct ice_dummy_pkt_offsets dummy_ipv6_gtpu_ipv6_udp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_ipv6_gtpu_ipv6_udp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(ipv6_gtpu_ipv6_udp) = {
 	0x00, 0x00, 0x00, 0x00, /* Ethernet 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -1155,8 +1148,7 @@ static const u8 dummy_ipv6_gtpu_ipv6_udp_packet[] = {
 	0x00, 0x00, /* 2 bytes for 4 byte alignment */
 };
 
-static const
-struct ice_dummy_pkt_offsets dummy_ipv4_gtpu_ipv4_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(ipv4_gtpu_ipv4) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_IPV4_OFOS,	14 },
 	{ ICE_UDP_OF,		34 },
@@ -1164,7 +1156,7 @@ struct ice_dummy_pkt_offsets dummy_ipv4_gtpu_ipv4_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_ipv4_gtpu_ipv4_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(ipv4_gtpu_ipv4) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
@@ -1194,8 +1186,7 @@ static const u8 dummy_ipv4_gtpu_ipv4_packet[] = {
 	0x00, 0x00,
 };
 
-static const
-struct ice_dummy_pkt_offsets dummy_ipv6_gtp_packet_offsets[] = {
+ICE_DECLARE_PKT_OFFSETS(ipv6_gtp) = {
 	{ ICE_MAC_OFOS,		0 },
 	{ ICE_IPV6_OFOS,	14 },
 	{ ICE_UDP_OF,		54 },
@@ -1203,7 +1194,7 @@ struct ice_dummy_pkt_offsets dummy_ipv6_gtp_packet_offsets[] = {
 	{ ICE_PROTOCOL_LAST,	0 },
 };
 
-static const u8 dummy_ipv6_gtp_packet[] = {
+ICE_DECLARE_PKT_TEMPLATE(ipv6_gtp) = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
-- 
2.35.1

