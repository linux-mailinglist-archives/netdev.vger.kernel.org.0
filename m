Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6636A4D3969
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237118AbiCITEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237110AbiCITEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:04:01 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD68F9A980
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646852578; x=1678388578;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AZCVxkih86B7IXaYHqu5zqG8ifuzeC5jJc50BYvQZUs=;
  b=j+2gxYa4LHfaja1tm/nC5HOhZ2gnZMc21UV5CEVPxu6INQVcPM2TNgE7
   XKoa6heYZKxTVjecF5Pp84hCECq43N9dPjA3mQx4fzrBIovLyEkq1LvqR
   LMwlUQ/2f9yogdWkA2coQDidV6pbdhwrf47x2mLLsSgBNbmXO6uY+RrGQ
   lxYQXoYy/9qtkrWK3+nyTyDF3CoL1u2X/NDJ37oNFFTxTizT0iAoVEnDX
   3fT4ciaYQCK9jxLPjeFPuVXdIfTKbqK8SRjmqEPfdCdTXmbhZBuP/0Z3H
   QJeOPTMb7MXt0vBuOcb7UcaZD05LBY2Z7WkYU10/HQ8rCybMZHd0fiu25
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="341494151"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="341494151"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:02:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="781188749"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 09 Mar 2022 11:02:57 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 1/5] ice: Add support for inner etype in switchdev
Date:   Wed,  9 Mar 2022 11:03:11 -0800
Message-Id: <20220309190315.1380414-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220309190315.1380414-1-anthony.l.nguyen@intel.com>
References: <20220309190315.1380414-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>

Enable support for adding TC rules that filter on the inner
EtherType field of tunneled packet headers.

Signed-off-by: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../ethernet/intel/ice/ice_protocol_type.h    |   2 +
 drivers/net/ethernet/intel/ice/ice_switch.c   | 272 +++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  15 +-
 3 files changed, 277 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_protocol_type.h b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
index 695b6dd61dc2..385deaa021ac 100644
--- a/drivers/net/ethernet/intel/ice/ice_protocol_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
@@ -29,6 +29,7 @@ enum ice_protocol_type {
 	ICE_MAC_OFOS = 0,
 	ICE_MAC_IL,
 	ICE_ETYPE_OL,
+	ICE_ETYPE_IL,
 	ICE_VLAN_OFOS,
 	ICE_IPV4_OFOS,
 	ICE_IPV4_IL,
@@ -92,6 +93,7 @@ enum ice_prot_id {
 #define ICE_MAC_OFOS_HW		1
 #define ICE_MAC_IL_HW		4
 #define ICE_ETYPE_OL_HW		9
+#define ICE_ETYPE_IL_HW		10
 #define ICE_VLAN_OF_HW		16
 #define ICE_VLAN_OL_HW		17
 #define ICE_IPV4_OFOS_HW	32
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 9c40a8d58c71..d98aa35c0337 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -41,6 +41,7 @@ static const struct ice_dummy_pkt_offsets dummy_gre_tcp_packet_offsets[] = {
 	{ ICE_IPV4_OFOS,	14 },
 	{ ICE_NVGRE,		34 },
 	{ ICE_MAC_IL,		42 },
+	{ ICE_ETYPE_IL,		54 },
 	{ ICE_IPV4_IL,		56 },
 	{ ICE_TCP_IL,		76 },
 	{ ICE_PROTOCOL_LAST,	0 },
@@ -65,7 +66,8 @@ static const u8 dummy_gre_tcp_packet[] = {
 	0x00, 0x00, 0x00, 0x00,	/* ICE_MAC_IL 42 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
-	0x08, 0x00,
+
+	0x08, 0x00,		/* ICE_ETYPE_IL 54 */
 
 	0x45, 0x00, 0x00, 0x14,	/* ICE_IPV4_IL 56 */
 	0x00, 0x00, 0x00, 0x00,
@@ -86,6 +88,7 @@ static const struct ice_dummy_pkt_offsets dummy_gre_udp_packet_offsets[] = {
 	{ ICE_IPV4_OFOS,	14 },
 	{ ICE_NVGRE,		34 },
 	{ ICE_MAC_IL,		42 },
+	{ ICE_ETYPE_IL,		54 },
 	{ ICE_IPV4_IL,		56 },
 	{ ICE_UDP_ILOS,		76 },
 	{ ICE_PROTOCOL_LAST,	0 },
@@ -110,7 +113,8 @@ static const u8 dummy_gre_udp_packet[] = {
 	0x00, 0x00, 0x00, 0x00,	/* ICE_MAC_IL 42 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
-	0x08, 0x00,
+
+	0x08, 0x00,		/* ICE_ETYPE_IL 54 */
 
 	0x45, 0x00, 0x00, 0x14,	/* ICE_IPV4_IL 56 */
 	0x00, 0x00, 0x00, 0x00,
@@ -131,6 +135,7 @@ static const struct ice_dummy_pkt_offsets dummy_udp_tun_tcp_packet_offsets[] = {
 	{ ICE_GENEVE,		42 },
 	{ ICE_VXLAN_GPE,	42 },
 	{ ICE_MAC_IL,		50 },
+	{ ICE_ETYPE_IL,		62 },
 	{ ICE_IPV4_IL,		64 },
 	{ ICE_TCP_IL,		84 },
 	{ ICE_PROTOCOL_LAST,	0 },
@@ -158,7 +163,8 @@ static const u8 dummy_udp_tun_tcp_packet[] = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_IL 50 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
-	0x08, 0x00,
+
+	0x08, 0x00,		/* ICE_ETYPE_IL 62 */
 
 	0x45, 0x00, 0x00, 0x28, /* ICE_IPV4_IL 64 */
 	0x00, 0x01, 0x00, 0x00,
@@ -182,6 +188,7 @@ static const struct ice_dummy_pkt_offsets dummy_udp_tun_udp_packet_offsets[] = {
 	{ ICE_GENEVE,		42 },
 	{ ICE_VXLAN_GPE,	42 },
 	{ ICE_MAC_IL,		50 },
+	{ ICE_ETYPE_IL,		62 },
 	{ ICE_IPV4_IL,		64 },
 	{ ICE_UDP_ILOS,		84 },
 	{ ICE_PROTOCOL_LAST,	0 },
@@ -209,7 +216,8 @@ static const u8 dummy_udp_tun_udp_packet[] = {
 	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_IL 50 */
 	0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00,
-	0x08, 0x00,
+
+	0x08, 0x00,		/* ICE_ETYPE_IL 62 */
 
 	0x45, 0x00, 0x00, 0x1c, /* ICE_IPV4_IL 64 */
 	0x00, 0x01, 0x00, 0x00,
@@ -221,6 +229,224 @@ static const u8 dummy_udp_tun_udp_packet[] = {
 	0x00, 0x08, 0x00, 0x00,
 };
 
+static const struct ice_dummy_pkt_offsets
+dummy_gre_ipv6_tcp_packet_offsets[] = {
+	{ ICE_MAC_OFOS,		0 },
+	{ ICE_ETYPE_OL,		12 },
+	{ ICE_IPV4_OFOS,	14 },
+	{ ICE_NVGRE,		34 },
+	{ ICE_MAC_IL,		42 },
+	{ ICE_ETYPE_IL,		54 },
+	{ ICE_IPV6_IL,		56 },
+	{ ICE_TCP_IL,		96 },
+	{ ICE_PROTOCOL_LAST,	0 },
+};
+
+static const u8 dummy_gre_ipv6_tcp_packet[] = {
+	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x08, 0x00,		/* ICE_ETYPE_OL 12 */
+
+	0x45, 0x00, 0x00, 0x66, /* ICE_IPV4_OFOS 14 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x2F, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x80, 0x00, 0x65, 0x58, /* ICE_NVGRE 34 */
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_IL 42 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x86, 0xdd,		/* ICE_ETYPE_IL 54 */
+
+	0x60, 0x00, 0x00, 0x00, /* ICE_IPV6_IL 56 */
+	0x00, 0x08, 0x06, 0x40,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x00, 0x00, /* ICE_TCP_IL 96 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x50, 0x02, 0x20, 0x00,
+	0x00, 0x00, 0x00, 0x00
+};
+
+static const struct ice_dummy_pkt_offsets
+dummy_gre_ipv6_udp_packet_offsets[] = {
+	{ ICE_MAC_OFOS,		0 },
+	{ ICE_ETYPE_OL,		12 },
+	{ ICE_IPV4_OFOS,	14 },
+	{ ICE_NVGRE,		34 },
+	{ ICE_MAC_IL,		42 },
+	{ ICE_ETYPE_IL,		54 },
+	{ ICE_IPV6_IL,		56 },
+	{ ICE_UDP_ILOS,		96 },
+	{ ICE_PROTOCOL_LAST,	0 },
+};
+
+static const u8 dummy_gre_ipv6_udp_packet[] = {
+	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_OFOS 0 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x08, 0x00,		/* ICE_ETYPE_OL 12 */
+
+	0x45, 0x00, 0x00, 0x5a, /* ICE_IPV4_OFOS 14 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x2F, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x80, 0x00, 0x65, 0x58, /* ICE_NVGRE 34 */
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_IL 42 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x86, 0xdd,		/* ICE_ETYPE_IL 54 */
+
+	0x60, 0x00, 0x00, 0x00, /* ICE_IPV6_IL 56 */
+	0x00, 0x08, 0x11, 0x40,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x00, 0x00, /* ICE_UDP_ILOS 96 */
+	0x00, 0x08, 0x00, 0x00,
+};
+
+static const struct ice_dummy_pkt_offsets
+dummy_udp_tun_ipv6_tcp_packet_offsets[] = {
+	{ ICE_MAC_OFOS,		0 },
+	{ ICE_ETYPE_OL,		12 },
+	{ ICE_IPV4_OFOS,	14 },
+	{ ICE_UDP_OF,		34 },
+	{ ICE_VXLAN,		42 },
+	{ ICE_GENEVE,		42 },
+	{ ICE_VXLAN_GPE,	42 },
+	{ ICE_MAC_IL,		50 },
+	{ ICE_ETYPE_IL,		62 },
+	{ ICE_IPV6_IL,		64 },
+	{ ICE_TCP_IL,		104 },
+	{ ICE_PROTOCOL_LAST,	0 },
+};
+
+static const u8 dummy_udp_tun_ipv6_tcp_packet[] = {
+	0x00, 0x00, 0x00, 0x00,  /* ICE_MAC_OFOS 0 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x08, 0x00,		/* ICE_ETYPE_OL 12 */
+
+	0x45, 0x00, 0x00, 0x6e, /* ICE_IPV4_OFOS 14 */
+	0x00, 0x01, 0x00, 0x00,
+	0x40, 0x11, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x12, 0xb5, /* ICE_UDP_OF 34 */
+	0x00, 0x5a, 0x00, 0x00,
+
+	0x00, 0x00, 0x65, 0x58, /* ICE_VXLAN 42 */
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_IL 50 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x86, 0xdd,		/* ICE_ETYPE_IL 62 */
+
+	0x60, 0x00, 0x00, 0x00, /* ICE_IPV6_IL 64 */
+	0x00, 0x08, 0x06, 0x40,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x00, 0x00, /* ICE_TCP_IL 104 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x50, 0x02, 0x20, 0x00,
+	0x00, 0x00, 0x00, 0x00
+};
+
+static const struct ice_dummy_pkt_offsets
+dummy_udp_tun_ipv6_udp_packet_offsets[] = {
+	{ ICE_MAC_OFOS,		0 },
+	{ ICE_ETYPE_OL,		12 },
+	{ ICE_IPV4_OFOS,	14 },
+	{ ICE_UDP_OF,		34 },
+	{ ICE_VXLAN,		42 },
+	{ ICE_GENEVE,		42 },
+	{ ICE_VXLAN_GPE,	42 },
+	{ ICE_MAC_IL,		50 },
+	{ ICE_ETYPE_IL,		62 },
+	{ ICE_IPV6_IL,		64 },
+	{ ICE_UDP_ILOS,		104 },
+	{ ICE_PROTOCOL_LAST,	0 },
+};
+
+static const u8 dummy_udp_tun_ipv6_udp_packet[] = {
+	0x00, 0x00, 0x00, 0x00,  /* ICE_MAC_OFOS 0 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x08, 0x00,		/* ICE_ETYPE_OL 12 */
+
+	0x45, 0x00, 0x00, 0x62, /* ICE_IPV4_OFOS 14 */
+	0x00, 0x01, 0x00, 0x00,
+	0x00, 0x11, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x12, 0xb5, /* ICE_UDP_OF 34 */
+	0x00, 0x4e, 0x00, 0x00,
+
+	0x00, 0x00, 0x65, 0x58, /* ICE_VXLAN 42 */
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x00, 0x00, /* ICE_MAC_IL 50 */
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x86, 0xdd,		/* ICE_ETYPE_IL 62 */
+
+	0x60, 0x00, 0x00, 0x00, /* ICE_IPV6_IL 64 */
+	0x00, 0x08, 0x11, 0x40,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+
+	0x00, 0x00, 0x00, 0x00, /* ICE_UDP_ILOS 104 */
+	0x00, 0x08, 0x00, 0x00,
+};
+
 /* offset info for MAC + IPv4 + UDP dummy packet */
 static const struct ice_dummy_pkt_offsets dummy_udp_packet_offsets[] = {
 	{ ICE_MAC_OFOS,		0 },
@@ -3818,6 +4044,7 @@ static const struct ice_prot_ext_tbl_entry ice_prot_ext[ICE_PROTOCOL_LAST] = {
 	{ ICE_MAC_OFOS,		{ 0, 2, 4, 6, 8, 10, 12 } },
 	{ ICE_MAC_IL,		{ 0, 2, 4, 6, 8, 10, 12 } },
 	{ ICE_ETYPE_OL,		{ 0 } },
+	{ ICE_ETYPE_IL,		{ 0 } },
 	{ ICE_VLAN_OFOS,	{ 2, 0 } },
 	{ ICE_IPV4_OFOS,	{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18 } },
 	{ ICE_IPV4_IL,		{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18 } },
@@ -3837,6 +4064,7 @@ static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {
 	{ ICE_MAC_OFOS,		ICE_MAC_OFOS_HW },
 	{ ICE_MAC_IL,		ICE_MAC_IL_HW },
 	{ ICE_ETYPE_OL,		ICE_ETYPE_OL_HW },
+	{ ICE_ETYPE_IL,		ICE_ETYPE_IL_HW },
 	{ ICE_VLAN_OFOS,	ICE_VLAN_OL_HW },
 	{ ICE_IPV4_OFOS,	ICE_IPV4_OFOS_HW },
 	{ ICE_IPV4_IL,		ICE_IPV4_IL_HW },
@@ -4818,6 +5046,7 @@ ice_find_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 		      const struct ice_dummy_pkt_offsets **offsets)
 {
 	bool tcp = false, udp = false, ipv6 = false, vlan = false;
+	bool ipv6_il = false;
 	u16 i;
 
 	for (i = 0; i < lkups_cnt; i++) {
@@ -4833,18 +5062,35 @@ ice_find_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 			 lkups[i].h_u.ethertype.ethtype_id ==
 				cpu_to_be16(ICE_IPV6_ETHER_ID) &&
 			 lkups[i].m_u.ethertype.ethtype_id ==
-					cpu_to_be16(0xFFFF))
+				cpu_to_be16(0xFFFF))
 			ipv6 = true;
+		else if (lkups[i].type == ICE_ETYPE_IL &&
+			 lkups[i].h_u.ethertype.ethtype_id ==
+				cpu_to_be16(ICE_IPV6_ETHER_ID) &&
+			 lkups[i].m_u.ethertype.ethtype_id ==
+				cpu_to_be16(0xFFFF))
+			ipv6_il = true;
 	}
 
 	if (tun_type == ICE_SW_TUN_NVGRE) {
+		if (tcp && ipv6_il) {
+			*pkt = dummy_gre_ipv6_tcp_packet;
+			*pkt_len = sizeof(dummy_gre_ipv6_tcp_packet);
+			*offsets = dummy_gre_ipv6_tcp_packet_offsets;
+			return;
+		}
 		if (tcp) {
 			*pkt = dummy_gre_tcp_packet;
 			*pkt_len = sizeof(dummy_gre_tcp_packet);
 			*offsets = dummy_gre_tcp_packet_offsets;
 			return;
 		}
-
+		if (ipv6_il) {
+			*pkt = dummy_gre_ipv6_udp_packet;
+			*pkt_len = sizeof(dummy_gre_ipv6_udp_packet);
+			*offsets = dummy_gre_ipv6_udp_packet_offsets;
+			return;
+		}
 		*pkt = dummy_gre_udp_packet;
 		*pkt_len = sizeof(dummy_gre_udp_packet);
 		*offsets = dummy_gre_udp_packet_offsets;
@@ -4853,13 +5099,24 @@ ice_find_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 
 	if (tun_type == ICE_SW_TUN_VXLAN ||
 	    tun_type == ICE_SW_TUN_GENEVE) {
+		if (tcp && ipv6_il) {
+			*pkt = dummy_udp_tun_ipv6_tcp_packet;
+			*pkt_len = sizeof(dummy_udp_tun_ipv6_tcp_packet);
+			*offsets = dummy_udp_tun_ipv6_tcp_packet_offsets;
+			return;
+		}
 		if (tcp) {
 			*pkt = dummy_udp_tun_tcp_packet;
 			*pkt_len = sizeof(dummy_udp_tun_tcp_packet);
 			*offsets = dummy_udp_tun_tcp_packet_offsets;
 			return;
 		}
-
+		if (ipv6_il) {
+			*pkt = dummy_udp_tun_ipv6_udp_packet;
+			*pkt_len = sizeof(dummy_udp_tun_ipv6_udp_packet);
+			*offsets = dummy_udp_tun_ipv6_udp_packet_offsets;
+			return;
+		}
 		*pkt = dummy_udp_tun_udp_packet;
 		*pkt_len = sizeof(dummy_udp_tun_udp_packet);
 		*offsets = dummy_udp_tun_udp_packet_offsets;
@@ -4965,6 +5222,7 @@ ice_fill_adv_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 			len = sizeof(struct ice_ether_hdr);
 			break;
 		case ICE_ETYPE_OL:
+		case ICE_ETYPE_IL:
 			len = sizeof(struct ice_ethtype_hdr);
 			break;
 		case ICE_VLAN_OFOS:
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 65cf32eb4046..424c74ca7d69 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -33,9 +33,7 @@ ice_tc_count_lkups(u32 flags, struct ice_tc_flower_lyr_2_4_hdrs *headers,
 	if (flags & ICE_TC_FLWR_FIELD_ENC_DEST_L4_PORT)
 		lkups_cnt++;
 
-	/* currently inner etype filter isn't supported */
-	if ((flags & ICE_TC_FLWR_FIELD_ETH_TYPE_ID) &&
-	    fltr->tunnel_type == TNL_LAST)
+	if (flags & ICE_TC_FLWR_FIELD_ETH_TYPE_ID)
 		lkups_cnt++;
 
 	/* are MAC fields specified? */
@@ -64,6 +62,11 @@ static enum ice_protocol_type ice_proto_type_from_mac(bool inner)
 	return inner ? ICE_MAC_IL : ICE_MAC_OFOS;
 }
 
+static enum ice_protocol_type ice_proto_type_from_etype(bool inner)
+{
+	return inner ? ICE_ETYPE_IL : ICE_ETYPE_OL;
+}
+
 static enum ice_protocol_type ice_proto_type_from_ipv4(bool inner)
 {
 	return inner ? ICE_IPV4_IL : ICE_IPV4_OFOS;
@@ -224,8 +227,10 @@ ice_tc_fill_rules(struct ice_hw *hw, u32 flags,
 
 		headers = &tc_fltr->inner_headers;
 		inner = true;
-	} else if (flags & ICE_TC_FLWR_FIELD_ETH_TYPE_ID) {
-		list[i].type = ICE_ETYPE_OL;
+	}
+
+	if (flags & ICE_TC_FLWR_FIELD_ETH_TYPE_ID) {
+		list[i].type = ice_proto_type_from_etype(inner);
 		list[i].h_u.ethertype.ethtype_id = headers->l2_key.n_proto;
 		list[i].m_u.ethertype.ethtype_id = headers->l2_mask.n_proto;
 		i++;
-- 
2.31.1

