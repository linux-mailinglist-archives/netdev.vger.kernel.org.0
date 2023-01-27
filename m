Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0252067E62E
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 14:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbjA0NKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 08:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234627AbjA0NJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 08:09:45 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176C713D64;
        Fri, 27 Jan 2023 05:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674824962; x=1706360962;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jB16IXy/XC9nIWoTnx3Y5k5c2C8oy35c+l0uBZipiCw=;
  b=aU+r18Z9x5ej2wjEXtbPoUT7Nujs3B2LZdLk0XCMRM+OzSho+D89Nk/L
   gu8D4M07aWZpDXq1bKNq7tSfFUxJGDkdvuGh6hN5+vGd/nFXrIK2R2xeB
   TmpNJ+EfXebyJYfjeVMwbf3bQObSLYkxlgYYutjjf0l2dwV+cpKuq9OMl
   cnZvLnNp2dmyqfSraca46K8DyiovXZeA/z03J+DcrLdmFXcvy7bG+rl64
   AUQEhLEu1pTMAMn6I06eZ7KmOoicvrnMH91JMt6Hu0azo2pOaQ2jyxd3u
   bCZPRa57U8MW4fbaNl1dG5Pbq2P2nv/OXKFd8jZfEYU6F+zVo3grea0ky
   w==;
X-IronPort-AV: E=Sophos;i="5.97,251,1669100400"; 
   d="scan'208";a="209513248"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2023 06:09:08 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 27 Jan 2023 06:09:08 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 27 Jan 2023 06:09:02 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Steen Hegelund" <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Dan Carpenter <error27@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 5/8] net: microchip: sparx5: Add ES2 VCAP keyset configuration for Sparx5
Date:   Fri, 27 Jan 2023 14:08:27 +0100
Message-ID: <20230127130830.1481526-6-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230127130830.1481526-1-steen.hegelund@microchip.com>
References: <20230127130830.1481526-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the ES2 VCAP port keyset configuration for Sparx5 and also
updates the debugFS support to show the keyset configuration and the egress
port mask.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_vcap_debugfs.c    | 117 +++
 .../microchip/sparx5/sparx5_vcap_impl.c       | 766 +++++++++++++++---
 .../microchip/sparx5/sparx5_vcap_impl.h       |  34 +
 .../microchip/vcap/vcap_api_debugfs.c         |   5 +-
 4 files changed, 803 insertions(+), 119 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
index 58f86dfa54bb..f3b2e58af212 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
@@ -284,6 +284,119 @@ static void sparx5_vcap_is2_port_stickies(struct sparx5 *sparx5,
 	out->prf(out->dst, "\n");
 }
 
+static void sparx5_vcap_es2_port_keys(struct sparx5 *sparx5,
+				      struct vcap_admin *admin,
+				      struct sparx5_port *port,
+				      struct vcap_output_print *out)
+{
+	int lookup;
+	u32 value;
+
+	out->prf(out->dst, "  port[%02d] (%s): ", port->portno,
+	   netdev_name(port->ndev));
+	for (lookup = 0; lookup < admin->lookups; ++lookup) {
+		out->prf(out->dst, "\n    Lookup %d: ", lookup);
+
+		/* Get lookup state */
+		value = spx5_rd(sparx5, EACL_VCAP_ES2_KEY_SEL(port->portno,
+							      lookup));
+		out->prf(out->dst, "\n      state: ");
+		if (EACL_VCAP_ES2_KEY_SEL_KEY_ENA_GET(value))
+			out->prf(out->dst, "on");
+		else
+			out->prf(out->dst, "off");
+
+		out->prf(out->dst, "\n      arp: ");
+		switch (EACL_VCAP_ES2_KEY_SEL_ARP_KEY_SEL_GET(value)) {
+		case VCAP_ES2_PS_ARP_MAC_ETYPE:
+			out->prf(out->dst, "mac_etype");
+			break;
+		case VCAP_ES2_PS_ARP_ARP:
+			out->prf(out->dst, "arp");
+			break;
+		}
+		out->prf(out->dst, "\n      ipv4: ");
+		switch (EACL_VCAP_ES2_KEY_SEL_IP4_KEY_SEL_GET(value)) {
+		case VCAP_ES2_PS_IPV4_MAC_ETYPE:
+			out->prf(out->dst, "mac_etype");
+			break;
+		case VCAP_ES2_PS_IPV4_IP_7TUPLE:
+			out->prf(out->dst, "ip_7tuple");
+			break;
+		case VCAP_ES2_PS_IPV4_IP4_TCP_UDP_VID:
+			out->prf(out->dst, "ip4_tcp_udp ip4_vid");
+			break;
+		case VCAP_ES2_PS_IPV4_IP4_TCP_UDP_OTHER:
+			out->prf(out->dst, "ip4_tcp_udp ip4_other");
+			break;
+		case VCAP_ES2_PS_IPV4_IP4_VID:
+			out->prf(out->dst, "ip4_vid");
+			break;
+		case VCAP_ES2_PS_IPV4_IP4_OTHER:
+			out->prf(out->dst, "ip4_other");
+			break;
+		}
+		out->prf(out->dst, "\n      ipv6: ");
+		switch (EACL_VCAP_ES2_KEY_SEL_IP6_KEY_SEL_GET(value)) {
+		case VCAP_ES2_PS_IPV6_MAC_ETYPE:
+			out->prf(out->dst, "mac_etype");
+			break;
+		case VCAP_ES2_PS_IPV6_IP_7TUPLE:
+			out->prf(out->dst, "ip_7tuple");
+			break;
+		case VCAP_ES2_PS_IPV6_IP_7TUPLE_VID:
+			out->prf(out->dst, "ip_7tuple ip6_vid");
+			break;
+		case VCAP_ES2_PS_IPV6_IP_7TUPLE_STD:
+			out->prf(out->dst, "ip_7tuple ip6_std");
+			break;
+		case VCAP_ES2_PS_IPV6_IP6_VID:
+			out->prf(out->dst, "ip6_vid");
+			break;
+		case VCAP_ES2_PS_IPV6_IP6_STD:
+			out->prf(out->dst, "ip6_std");
+			break;
+		case VCAP_ES2_PS_IPV6_IP4_DOWNGRADE:
+			out->prf(out->dst, "ip4_downgrade");
+			break;
+		}
+	}
+	out->prf(out->dst, "\n");
+}
+
+static void sparx5_vcap_es2_port_stickies(struct sparx5 *sparx5,
+					  struct vcap_admin *admin,
+					  struct vcap_output_print *out)
+{
+	int lookup;
+	u32 value;
+
+	out->prf(out->dst, "  Sticky bits: ");
+	for (lookup = 0; lookup < admin->lookups; ++lookup) {
+		value = spx5_rd(sparx5, EACL_SEC_LOOKUP_STICKY(lookup));
+		out->prf(out->dst, "\n    Lookup %d: ", lookup);
+		if (EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP_7TUPLE_STICKY_GET(value))
+			out->prf(out->dst, " ip_7tuple");
+		if (EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP6_VID_STICKY_GET(value))
+			out->prf(out->dst, " ip6_vid");
+		if (EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP6_STD_STICKY_GET(value))
+			out->prf(out->dst, " ip6_std");
+		if (EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_TCPUDP_STICKY_GET(value))
+			out->prf(out->dst, " ip4_tcp_udp");
+		if (EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_VID_STICKY_GET(value))
+			out->prf(out->dst, " ip4_vid");
+		if (EACL_SEC_LOOKUP_STICKY_SEC_TYPE_IP4_OTHER_STICKY_GET(value))
+			out->prf(out->dst, " ip4_other");
+		if (EACL_SEC_LOOKUP_STICKY_SEC_TYPE_ARP_STICKY_GET(value))
+			out->prf(out->dst, " arp");
+		if (EACL_SEC_LOOKUP_STICKY_SEC_TYPE_MAC_ETYPE_STICKY_GET(value))
+			out->prf(out->dst, " mac_etype");
+		/* Clear stickies */
+		spx5_wr(value, sparx5, EACL_SEC_LOOKUP_STICKY(lookup));
+	}
+	out->prf(out->dst, "\n");
+}
+
 /* Provide port information via a callback interface */
 int sparx5_port_info(struct net_device *ndev,
 		     struct vcap_admin *admin,
@@ -305,6 +418,10 @@ int sparx5_port_info(struct net_device *ndev,
 		sparx5_vcap_is2_port_keys(sparx5, admin, port, out);
 		sparx5_vcap_is2_port_stickies(sparx5, admin, out);
 		break;
+	case VCAP_TYPE_ES2:
+		sparx5_vcap_es2_port_keys(sparx5, admin, port, out);
+		sparx5_vcap_es2_port_stickies(sparx5, admin, out);
+		break;
 	default:
 		out->prf(out->dst, "  no info\n");
 		break;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index 92073bfddc99..05e365d67e5a 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -37,6 +37,13 @@
 	ANA_CL_ADV_CL_CFG_MPLS_MC_CLM_KEY_SEL_SET(_mpls_mc) | \
 	ANA_CL_ADV_CL_CFG_MLBS_CLM_KEY_SEL_SET(_mlbs))
 
+#define SPARX5_ES2_LOOKUPS 2
+#define VCAP_ES2_KEYSEL(_ena, _arp, _ipv4, _ipv6) \
+	(EACL_VCAP_ES2_KEY_SEL_KEY_ENA_SET(_ena) | \
+	EACL_VCAP_ES2_KEY_SEL_ARP_KEY_SEL_SET(_arp) | \
+	EACL_VCAP_ES2_KEY_SEL_IP4_KEY_SEL_SET(_ipv4) | \
+	EACL_VCAP_ES2_KEY_SEL_IP6_KEY_SEL_SET(_ipv6))
+
 static struct sparx5_vcap_inst {
 	enum vcap_type vtype; /* type of vcap */
 	int vinst; /* instance number within the same type */
@@ -104,6 +111,14 @@ static struct sparx5_vcap_inst {
 		.blockno = 2, /* Maps block 2-3 */
 		.blocks = 2,
 	},
+	{
+		.vtype = VCAP_TYPE_ES2,
+		.lookups = SPARX5_ES2_LOOKUPS,
+		.lookups_per_instance = SPARX5_ES2_LOOKUPS,
+		.first_cid = SPARX5_VCAP_CID_ES2_L0,
+		.last_cid = SPARX5_VCAP_CID_ES2_MAX,
+		.count = 12288, /* Addresses according to datasheet */
+	},
 };
 
 /* These protocols have dedicated keysets in IS0 and a TC dissector */
@@ -139,25 +154,57 @@ static void sparx5_vcap_wait_super_update(struct sparx5 *sparx5)
 			  false, sparx5, VCAP_SUPER_CTRL);
 }
 
-/* Initializing a VCAP address range: IS0 and IS2 for now */
+/* Await the ES2 VCAP completion of the current operation */
+static void sparx5_vcap_wait_es2_update(struct sparx5 *sparx5)
+{
+	u32 value;
+
+	read_poll_timeout(spx5_rd, value,
+			  !VCAP_ES2_CTRL_UPDATE_SHOT_GET(value), 500, 10000,
+			  false, sparx5, VCAP_ES2_CTRL);
+}
+
+/* Initializing a VCAP address range */
 static void _sparx5_vcap_range_init(struct sparx5 *sparx5,
 				    struct vcap_admin *admin,
 				    u32 addr, u32 count)
 {
 	u32 size = count - 1;
 
-	spx5_wr(VCAP_SUPER_CFG_MV_NUM_POS_SET(0) |
-		VCAP_SUPER_CFG_MV_SIZE_SET(size),
-		sparx5, VCAP_SUPER_CFG);
-	spx5_wr(VCAP_SUPER_CTRL_UPDATE_CMD_SET(VCAP_CMD_INITIALIZE) |
-		VCAP_SUPER_CTRL_UPDATE_ENTRY_DIS_SET(0) |
-		VCAP_SUPER_CTRL_UPDATE_ACTION_DIS_SET(0) |
-		VCAP_SUPER_CTRL_UPDATE_CNT_DIS_SET(0) |
-		VCAP_SUPER_CTRL_UPDATE_ADDR_SET(addr) |
-		VCAP_SUPER_CTRL_CLEAR_CACHE_SET(true) |
-		VCAP_SUPER_CTRL_UPDATE_SHOT_SET(true),
-		sparx5, VCAP_SUPER_CTRL);
-	sparx5_vcap_wait_super_update(sparx5);
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS0:
+	case VCAP_TYPE_IS2:
+		spx5_wr(VCAP_SUPER_CFG_MV_NUM_POS_SET(0) |
+			VCAP_SUPER_CFG_MV_SIZE_SET(size),
+			sparx5, VCAP_SUPER_CFG);
+		spx5_wr(VCAP_SUPER_CTRL_UPDATE_CMD_SET(VCAP_CMD_INITIALIZE) |
+			VCAP_SUPER_CTRL_UPDATE_ENTRY_DIS_SET(0) |
+			VCAP_SUPER_CTRL_UPDATE_ACTION_DIS_SET(0) |
+			VCAP_SUPER_CTRL_UPDATE_CNT_DIS_SET(0) |
+			VCAP_SUPER_CTRL_UPDATE_ADDR_SET(addr) |
+			VCAP_SUPER_CTRL_CLEAR_CACHE_SET(true) |
+			VCAP_SUPER_CTRL_UPDATE_SHOT_SET(true),
+			sparx5, VCAP_SUPER_CTRL);
+		sparx5_vcap_wait_super_update(sparx5);
+		break;
+	case VCAP_TYPE_ES2:
+		spx5_wr(VCAP_ES2_CFG_MV_NUM_POS_SET(0) |
+			VCAP_ES2_CFG_MV_SIZE_SET(size),
+			sparx5, VCAP_ES2_CFG);
+		spx5_wr(VCAP_ES2_CTRL_UPDATE_CMD_SET(VCAP_CMD_INITIALIZE) |
+			VCAP_ES2_CTRL_UPDATE_ENTRY_DIS_SET(0) |
+			VCAP_ES2_CTRL_UPDATE_ACTION_DIS_SET(0) |
+			VCAP_ES2_CTRL_UPDATE_CNT_DIS_SET(0) |
+			VCAP_ES2_CTRL_UPDATE_ADDR_SET(addr) |
+			VCAP_ES2_CTRL_CLEAR_CACHE_SET(true) |
+			VCAP_ES2_CTRL_UPDATE_SHOT_SET(true),
+			sparx5, VCAP_ES2_CTRL);
+		sparx5_vcap_wait_es2_update(sparx5);
+		break;
+	default:
+		sparx5_vcap_type_err(sparx5, admin, __func__);
+		break;
+	}
 }
 
 /* Initializing VCAP rule data area */
@@ -198,9 +245,15 @@ static bool sparx5_vcap_is2_is_first_chain(struct vcap_rule *rule)
 		  rule->vcap_chain_id < SPARX5_VCAP_CID_IS2_L3));
 }
 
+static bool sparx5_vcap_es2_is_first_chain(struct vcap_rule *rule)
+{
+	return (rule->vcap_chain_id >= SPARX5_VCAP_CID_ES2_L0 &&
+		rule->vcap_chain_id < SPARX5_VCAP_CID_ES2_L1);
+}
+
 /* Set the narrow range ingress port mask on a rule */
-static void sparx5_vcap_add_range_port_mask(struct vcap_rule *rule,
-					    struct net_device *ndev)
+static void sparx5_vcap_add_ingress_range_port_mask(struct vcap_rule *rule,
+						    struct net_device *ndev)
 {
 	struct sparx5_port *port = netdev_priv(ndev);
 	u32 port_mask;
@@ -230,6 +283,27 @@ static void sparx5_vcap_add_wide_port_mask(struct vcap_rule *rule,
 	vcap_rule_add_key_u72(rule, VCAP_KF_IF_IGR_PORT_MASK, &port_mask);
 }
 
+static void sparx5_vcap_add_egress_range_port_mask(struct vcap_rule *rule,
+						   struct net_device *ndev)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	u32 port_mask;
+	u32 range;
+
+	/* Mask range selects:
+	 * 0-2: Physical/Logical egress port number 0-31, 32–63, 64.
+	 * 3-5: Virtual Interface Number 0-31, 32-63, 64.
+	 * 6: CPU queue Number 0-7.
+	 *
+	 * Use physical/logical port ranges (0-2)
+	 */
+	range = port->portno / BITS_PER_TYPE(u32);
+	/* Port bit set to match-any */
+	port_mask = ~BIT(port->portno % BITS_PER_TYPE(u32));
+	vcap_rule_add_key_u32(rule, VCAP_KF_IF_EGR_PORT_MASK_RNG, range, 0xf);
+	vcap_rule_add_key_u32(rule, VCAP_KF_IF_EGR_PORT_MASK, 0, port_mask);
+}
+
 /* Convert IS0 chain id to vcap lookup id */
 static int sparx5_vcap_is0_cid_to_lookup(int cid)
 {
@@ -264,6 +338,17 @@ static int sparx5_vcap_is2_cid_to_lookup(int cid)
 	return lookup;
 }
 
+/* Convert ES2 chain id to vcap lookup id */
+static int sparx5_vcap_es2_cid_to_lookup(int cid)
+{
+	int lookup = 0;
+
+	if (cid >= SPARX5_VCAP_CID_ES2_L1)
+		lookup = 1;
+
+	return lookup;
+}
+
 /* Add ethernet type IS0 keyset to a list */
 static void
 sparx5_vcap_is0_get_port_etype_keysets(struct vcap_keyset_list *keysetlist,
@@ -435,6 +520,97 @@ static int sparx5_vcap_is2_get_port_keysets(struct net_device *ndev,
 	return 0;
 }
 
+/* Return the keysets for the vcap port IP4 traffic class configuration */
+static void
+sparx5_vcap_es2_get_port_ipv4_keysets(struct vcap_keyset_list *keysetlist,
+				      u32 value)
+{
+	switch (EACL_VCAP_ES2_KEY_SEL_IP4_KEY_SEL_GET(value)) {
+	case VCAP_ES2_PS_IPV4_MAC_ETYPE:
+		vcap_keyset_list_add(keysetlist, VCAP_KFS_MAC_ETYPE);
+		break;
+	case VCAP_ES2_PS_IPV4_IP_7TUPLE:
+		vcap_keyset_list_add(keysetlist, VCAP_KFS_IP_7TUPLE);
+		break;
+	case VCAP_ES2_PS_IPV4_IP4_TCP_UDP_VID:
+		vcap_keyset_list_add(keysetlist, VCAP_KFS_IP4_TCP_UDP);
+		break;
+	case VCAP_ES2_PS_IPV4_IP4_TCP_UDP_OTHER:
+		vcap_keyset_list_add(keysetlist, VCAP_KFS_IP4_TCP_UDP);
+		vcap_keyset_list_add(keysetlist, VCAP_KFS_IP4_OTHER);
+		break;
+	case VCAP_ES2_PS_IPV4_IP4_VID:
+		/* Not used */
+		break;
+	case VCAP_ES2_PS_IPV4_IP4_OTHER:
+		vcap_keyset_list_add(keysetlist, VCAP_KFS_IP4_OTHER);
+		break;
+	}
+}
+
+/* Return the list of keysets for the vcap port configuration */
+static int sparx5_vcap_es2_get_port_keysets(struct net_device *ndev,
+					    int lookup,
+					    struct vcap_keyset_list *keysetlist,
+					    u16 l3_proto)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	int portno = port->portno;
+	u32 value;
+
+	value = spx5_rd(sparx5, EACL_VCAP_ES2_KEY_SEL(portno, lookup));
+
+	/* Collect all keysets for the port in a list */
+	if (l3_proto == ETH_P_ALL || l3_proto == ETH_P_ARP) {
+		switch (EACL_VCAP_ES2_KEY_SEL_ARP_KEY_SEL_GET(value)) {
+		case VCAP_ES2_PS_ARP_MAC_ETYPE:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_MAC_ETYPE);
+			break;
+		case VCAP_ES2_PS_ARP_ARP:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_ARP);
+			break;
+		}
+	}
+
+	if (l3_proto == ETH_P_ALL || l3_proto == ETH_P_IP)
+		sparx5_vcap_es2_get_port_ipv4_keysets(keysetlist, value);
+
+	if (l3_proto == ETH_P_ALL || l3_proto == ETH_P_IPV6) {
+		switch (EACL_VCAP_ES2_KEY_SEL_IP6_KEY_SEL_GET(value)) {
+		case VCAP_ES2_PS_IPV6_MAC_ETYPE:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_MAC_ETYPE);
+			break;
+		case VCAP_ES2_PS_IPV6_IP_7TUPLE:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP_7TUPLE);
+			break;
+		case VCAP_ES2_PS_IPV6_IP_7TUPLE_VID:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP_7TUPLE);
+			break;
+		case VCAP_ES2_PS_IPV6_IP_7TUPLE_STD:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP_7TUPLE);
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP6_STD);
+			break;
+		case VCAP_ES2_PS_IPV6_IP6_VID:
+			/* Not used */
+			break;
+		case VCAP_ES2_PS_IPV6_IP6_STD:
+			vcap_keyset_list_add(keysetlist, VCAP_KFS_IP6_STD);
+			break;
+		case VCAP_ES2_PS_IPV6_IP4_DOWNGRADE:
+			sparx5_vcap_es2_get_port_ipv4_keysets(keysetlist,
+							      value);
+			break;
+		}
+	}
+
+	if (l3_proto != ETH_P_ARP && l3_proto != ETH_P_IP &&
+	    l3_proto != ETH_P_IPV6) {
+		vcap_keyset_list_add(keysetlist, VCAP_KFS_MAC_ETYPE);
+	}
+	return 0;
+}
+
 /* Get the port keyset for the vcap lookup */
 int sparx5_vcap_get_port_keyset(struct net_device *ndev,
 				struct vcap_admin *admin,
@@ -456,6 +632,11 @@ int sparx5_vcap_get_port_keyset(struct net_device *ndev,
 		err = sparx5_vcap_is2_get_port_keysets(ndev, lookup, kslist,
 						       l3_proto);
 		break;
+	case VCAP_TYPE_ES2:
+		lookup = sparx5_vcap_es2_cid_to_lookup(cid);
+		err = sparx5_vcap_es2_get_port_keysets(ndev, lookup, kslist,
+						       l3_proto);
+		break;
 	default:
 		port = netdev_priv(ndev);
 		sparx5_vcap_type_err(port->sparx5, admin, __func__);
@@ -519,6 +700,11 @@ sparx5_vcap_validate_keyset(struct net_device *ndev,
 		sparx5_vcap_is2_get_port_keysets(ndev, lookup, &keysetlist,
 						 l3_proto);
 		break;
+	case VCAP_TYPE_ES2:
+		lookup = sparx5_vcap_es2_cid_to_lookup(rule->vcap_chain_id);
+		sparx5_vcap_es2_get_port_keysets(ndev, lookup, &keysetlist,
+						 l3_proto);
+		break;
 	default:
 		port = netdev_priv(ndev);
 		sparx5_vcap_type_err(port->sparx5, admin, __func__);
@@ -538,43 +724,82 @@ sparx5_vcap_validate_keyset(struct net_device *ndev,
 	return -ENOENT;
 }
 
-/* API callback used for adding default fields to a rule */
-static void sparx5_vcap_add_default_fields(struct net_device *ndev,
-					   struct vcap_admin *admin,
-					   struct vcap_rule *rule)
+static void sparx5_vcap_ingress_add_default_fields(struct net_device *ndev,
+						   struct vcap_admin *admin,
+						   struct vcap_rule *rule)
 {
 	const struct vcap_field *field;
-	struct sparx5_port *port;
-	bool is_first = true;
+	bool is_first;
 
+	/* Add ingress port mask matching the net device */
 	field = vcap_lookup_keyfield(rule, VCAP_KF_IF_IGR_PORT_MASK);
 	if (field && field->width == SPX5_PORTS)
 		sparx5_vcap_add_wide_port_mask(rule, ndev);
 	else if (field && field->width == BITS_PER_TYPE(u32))
-		sparx5_vcap_add_range_port_mask(rule, ndev);
+		sparx5_vcap_add_ingress_range_port_mask(rule, ndev);
 	else
 		pr_err("%s:%d: %s: could not add an ingress port mask for: %s\n",
 		       __func__, __LINE__, netdev_name(ndev),
 		       sparx5_vcap_keyset_name(ndev, rule->keyset));
 
+	if (admin->vtype == VCAP_TYPE_IS0)
+		is_first = sparx5_vcap_is0_is_first_chain(rule);
+	else
+		is_first = sparx5_vcap_is2_is_first_chain(rule);
+
+	/* Add key that selects the first/second lookup */
+	if (is_first)
+		vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS,
+				      VCAP_BIT_1);
+	else
+		vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS,
+				      VCAP_BIT_0);
+}
+
+static void sparx5_vcap_es2_add_default_fields(struct net_device *ndev,
+					       struct vcap_admin *admin,
+					       struct vcap_rule *rule)
+{
+	const struct vcap_field *field;
+	bool is_first;
+
+	/* Add egress port mask matching the net device */
+	field = vcap_lookup_keyfield(rule, VCAP_KF_IF_EGR_PORT_MASK);
+	if (field)
+		sparx5_vcap_add_egress_range_port_mask(rule, ndev);
+
+	/* Add key that selects the first/second lookup */
+	is_first = sparx5_vcap_es2_is_first_chain(rule);
+
+	if (is_first)
+		vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS,
+				      VCAP_BIT_1);
+	else
+		vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS,
+				      VCAP_BIT_0);
+}
+
+/* API callback used for adding default fields to a rule */
+static void sparx5_vcap_add_default_fields(struct net_device *ndev,
+					   struct vcap_admin *admin,
+					   struct vcap_rule *rule)
+{
+	struct sparx5_port *port;
+
 	/* add the lookup bit */
 	switch (admin->vtype) {
 	case VCAP_TYPE_IS0:
-		is_first = sparx5_vcap_is0_is_first_chain(rule);
-		break;
 	case VCAP_TYPE_IS2:
-		is_first = sparx5_vcap_is2_is_first_chain(rule);
+		sparx5_vcap_ingress_add_default_fields(ndev, admin, rule);
+		break;
+	case VCAP_TYPE_ES2:
+		sparx5_vcap_es2_add_default_fields(ndev, admin, rule);
 		break;
 	default:
 		port = netdev_priv(ndev);
 		sparx5_vcap_type_err(port->sparx5, admin, __func__);
 		break;
 	}
-
-	if (is_first)
-		vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS, VCAP_BIT_1);
-	else
-		vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS, VCAP_BIT_0);
 }
 
 /* API callback used for erasing the vcap cache area (not the register area) */
@@ -586,21 +811,60 @@ static void sparx5_vcap_cache_erase(struct vcap_admin *admin)
 	memset(&admin->cache.counter, 0, sizeof(admin->cache.counter));
 }
 
-/* API callback used for writing to the VCAP cache */
-static void sparx5_vcap_cache_write(struct net_device *ndev,
-				    struct vcap_admin *admin,
-				    enum vcap_selection sel,
-				    u32 start,
-				    u32 count)
+static void sparx5_vcap_is0_cache_write(struct sparx5 *sparx5,
+					struct vcap_admin *admin,
+					enum vcap_selection sel,
+					u32 start,
+					u32 count)
 {
-	struct sparx5_port *port = netdev_priv(ndev);
-	struct sparx5 *sparx5 = port->sparx5;
 	u32 *keystr, *mskstr, *actstr;
 	int idx;
 
 	keystr = &admin->cache.keystream[start];
 	mskstr = &admin->cache.maskstream[start];
 	actstr = &admin->cache.actionstream[start];
+
+	switch (sel) {
+	case VCAP_SEL_ENTRY:
+		for (idx = 0; idx < count; ++idx) {
+			/* Avoid 'match-off' by setting value & mask */
+			spx5_wr(keystr[idx] & mskstr[idx], sparx5,
+				VCAP_SUPER_VCAP_ENTRY_DAT(idx));
+			spx5_wr(~mskstr[idx], sparx5,
+				VCAP_SUPER_VCAP_MASK_DAT(idx));
+		}
+		break;
+	case VCAP_SEL_ACTION:
+		for (idx = 0; idx < count; ++idx)
+			spx5_wr(actstr[idx], sparx5,
+				VCAP_SUPER_VCAP_ACTION_DAT(idx));
+		break;
+	case VCAP_SEL_ALL:
+		pr_err("%s:%d: cannot write all streams at once\n",
+		       __func__, __LINE__);
+		break;
+	default:
+		break;
+	}
+
+	if (sel & VCAP_SEL_COUNTER)
+		spx5_wr(admin->cache.counter, sparx5,
+			VCAP_SUPER_VCAP_CNT_DAT(0));
+}
+
+static void sparx5_vcap_is2_cache_write(struct sparx5 *sparx5,
+					struct vcap_admin *admin,
+					enum vcap_selection sel,
+					u32 start,
+					u32 count)
+{
+	u32 *keystr, *mskstr, *actstr;
+	int idx;
+
+	keystr = &admin->cache.keystream[start];
+	mskstr = &admin->cache.maskstream[start];
+	actstr = &admin->cache.actionstream[start];
+
 	switch (sel) {
 	case VCAP_SEL_ENTRY:
 		for (idx = 0; idx < count; ++idx) {
@@ -624,44 +888,99 @@ static void sparx5_vcap_cache_write(struct net_device *ndev,
 		break;
 	}
 	if (sel & VCAP_SEL_COUNTER) {
-		switch (admin->vtype) {
-		case VCAP_TYPE_IS0:
+		start = start & 0xfff; /* counter limit */
+		if (admin->vinst == 0)
 			spx5_wr(admin->cache.counter, sparx5,
-				VCAP_SUPER_VCAP_CNT_DAT(0));
-			break;
-		case VCAP_TYPE_IS2:
-			start = start & 0xfff; /* counter limit */
-			if (admin->vinst == 0)
-				spx5_wr(admin->cache.counter, sparx5,
-					ANA_ACL_CNT_A(start));
-			else
-				spx5_wr(admin->cache.counter, sparx5,
-					ANA_ACL_CNT_B(start));
-			spx5_wr(admin->cache.sticky, sparx5,
-				VCAP_SUPER_VCAP_CNT_DAT(0));
-			break;
-		default:
-			sparx5_vcap_type_err(sparx5, admin, __func__);
-			break;
+				ANA_ACL_CNT_A(start));
+		else
+			spx5_wr(admin->cache.counter, sparx5,
+				ANA_ACL_CNT_B(start));
+		spx5_wr(admin->cache.sticky, sparx5,
+			VCAP_SUPER_VCAP_CNT_DAT(0));
+	}
+}
+
+static void sparx5_vcap_es2_cache_write(struct sparx5 *sparx5,
+					struct vcap_admin *admin,
+					enum vcap_selection sel,
+					u32 start,
+					u32 count)
+{
+	u32 *keystr, *mskstr, *actstr;
+	int idx;
+
+	keystr = &admin->cache.keystream[start];
+	mskstr = &admin->cache.maskstream[start];
+	actstr = &admin->cache.actionstream[start];
+
+	switch (sel) {
+	case VCAP_SEL_ENTRY:
+		for (idx = 0; idx < count; ++idx) {
+			/* Avoid 'match-off' by setting value & mask */
+			spx5_wr(keystr[idx] & mskstr[idx], sparx5,
+				VCAP_ES2_VCAP_ENTRY_DAT(idx));
+			spx5_wr(~mskstr[idx], sparx5,
+				VCAP_ES2_VCAP_MASK_DAT(idx));
 		}
+		break;
+	case VCAP_SEL_ACTION:
+		for (idx = 0; idx < count; ++idx)
+			spx5_wr(actstr[idx], sparx5,
+				VCAP_ES2_VCAP_ACTION_DAT(idx));
+		break;
+	case VCAP_SEL_ALL:
+		pr_err("%s:%d: cannot write all streams at once\n",
+		       __func__, __LINE__);
+		break;
+	default:
+		break;
+	}
+	if (sel & VCAP_SEL_COUNTER) {
+		start = start & 0x7ff; /* counter limit */
+		spx5_wr(admin->cache.counter, sparx5, EACL_ES2_CNT(start));
+		spx5_wr(admin->cache.sticky, sparx5, VCAP_ES2_VCAP_CNT_DAT(0));
 	}
 }
 
-/* API callback used for reading from the VCAP into the VCAP cache */
-static void sparx5_vcap_cache_read(struct net_device *ndev,
-				   struct vcap_admin *admin,
-				   enum vcap_selection sel,
-				   u32 start,
-				   u32 count)
+/* API callback used for writing to the VCAP cache */
+static void sparx5_vcap_cache_write(struct net_device *ndev,
+				    struct vcap_admin *admin,
+				    enum vcap_selection sel,
+				    u32 start,
+				    u32 count)
 {
 	struct sparx5_port *port = netdev_priv(ndev);
 	struct sparx5 *sparx5 = port->sparx5;
+
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS0:
+		sparx5_vcap_is0_cache_write(sparx5, admin, sel, start, count);
+		break;
+	case VCAP_TYPE_IS2:
+		sparx5_vcap_is2_cache_write(sparx5, admin, sel, start, count);
+		break;
+	case VCAP_TYPE_ES2:
+		sparx5_vcap_es2_cache_write(sparx5, admin, sel, start, count);
+		break;
+	default:
+		sparx5_vcap_type_err(sparx5, admin, __func__);
+		break;
+	}
+}
+
+static void sparx5_vcap_is0_cache_read(struct sparx5 *sparx5,
+				       struct vcap_admin *admin,
+				       enum vcap_selection sel,
+				       u32 start,
+				       u32 count)
+{
 	u32 *keystr, *mskstr, *actstr;
 	int idx;
 
 	keystr = &admin->cache.keystream[start];
 	mskstr = &admin->cache.maskstream[start];
 	actstr = &admin->cache.actionstream[start];
+
 	if (sel & VCAP_SEL_ENTRY) {
 		for (idx = 0; idx < count; ++idx) {
 			keystr[idx] = spx5_rd(sparx5,
@@ -670,35 +989,120 @@ static void sparx5_vcap_cache_read(struct net_device *ndev,
 					       VCAP_SUPER_VCAP_MASK_DAT(idx));
 		}
 	}
-	if (sel & VCAP_SEL_ACTION) {
+
+	if (sel & VCAP_SEL_ACTION)
 		for (idx = 0; idx < count; ++idx)
 			actstr[idx] = spx5_rd(sparx5,
 					      VCAP_SUPER_VCAP_ACTION_DAT(idx));
+
+	if (sel & VCAP_SEL_COUNTER) {
+		admin->cache.counter =
+			spx5_rd(sparx5, VCAP_SUPER_VCAP_CNT_DAT(0));
+		admin->cache.sticky =
+			spx5_rd(sparx5, VCAP_SUPER_VCAP_CNT_DAT(0));
+	}
+}
+
+static void sparx5_vcap_is2_cache_read(struct sparx5 *sparx5,
+				       struct vcap_admin *admin,
+				       enum vcap_selection sel,
+				       u32 start,
+				       u32 count)
+{
+	u32 *keystr, *mskstr, *actstr;
+	int idx;
+
+	keystr = &admin->cache.keystream[start];
+	mskstr = &admin->cache.maskstream[start];
+	actstr = &admin->cache.actionstream[start];
+
+	if (sel & VCAP_SEL_ENTRY) {
+		for (idx = 0; idx < count; ++idx) {
+			keystr[idx] = spx5_rd(sparx5,
+					      VCAP_SUPER_VCAP_ENTRY_DAT(idx));
+			mskstr[idx] = ~spx5_rd(sparx5,
+					       VCAP_SUPER_VCAP_MASK_DAT(idx));
+		}
 	}
+
+	if (sel & VCAP_SEL_ACTION)
+		for (idx = 0; idx < count; ++idx)
+			actstr[idx] = spx5_rd(sparx5,
+					      VCAP_SUPER_VCAP_ACTION_DAT(idx));
+
 	if (sel & VCAP_SEL_COUNTER) {
-		switch (admin->vtype) {
-		case VCAP_TYPE_IS0:
+		start = start & 0xfff; /* counter limit */
+		if (admin->vinst == 0)
 			admin->cache.counter =
-				spx5_rd(sparx5, VCAP_SUPER_VCAP_CNT_DAT(0));
-			admin->cache.sticky =
-				spx5_rd(sparx5, VCAP_SUPER_VCAP_CNT_DAT(0));
-			break;
-		case VCAP_TYPE_IS2:
-			start = start & 0xfff; /* counter limit */
-			if (admin->vinst == 0)
-				admin->cache.counter =
-					spx5_rd(sparx5, ANA_ACL_CNT_A(start));
-			else
-				admin->cache.counter =
-					spx5_rd(sparx5, ANA_ACL_CNT_B(start));
-			admin->cache.sticky =
-				spx5_rd(sparx5, VCAP_SUPER_VCAP_CNT_DAT(0));
-			break;
-		default:
-			sparx5_vcap_type_err(sparx5, admin, __func__);
-			break;
+				spx5_rd(sparx5, ANA_ACL_CNT_A(start));
+		else
+			admin->cache.counter =
+				spx5_rd(sparx5, ANA_ACL_CNT_B(start));
+		admin->cache.sticky =
+			spx5_rd(sparx5, VCAP_SUPER_VCAP_CNT_DAT(0));
+	}
+}
+
+static void sparx5_vcap_es2_cache_read(struct sparx5 *sparx5,
+				       struct vcap_admin *admin,
+				       enum vcap_selection sel,
+				       u32 start,
+				       u32 count)
+{
+	u32 *keystr, *mskstr, *actstr;
+	int idx;
+
+	keystr = &admin->cache.keystream[start];
+	mskstr = &admin->cache.maskstream[start];
+	actstr = &admin->cache.actionstream[start];
+
+	if (sel & VCAP_SEL_ENTRY) {
+		for (idx = 0; idx < count; ++idx) {
+			keystr[idx] =
+				spx5_rd(sparx5, VCAP_ES2_VCAP_ENTRY_DAT(idx));
+			mskstr[idx] =
+				~spx5_rd(sparx5, VCAP_ES2_VCAP_MASK_DAT(idx));
 		}
 	}
+
+	if (sel & VCAP_SEL_ACTION)
+		for (idx = 0; idx < count; ++idx)
+			actstr[idx] =
+				spx5_rd(sparx5, VCAP_ES2_VCAP_ACTION_DAT(idx));
+
+	if (sel & VCAP_SEL_COUNTER) {
+		start = start & 0x7ff; /* counter limit */
+		admin->cache.counter =
+			spx5_rd(sparx5, EACL_ES2_CNT(start));
+		admin->cache.sticky =
+			spx5_rd(sparx5, VCAP_ES2_VCAP_CNT_DAT(0));
+	}
+}
+
+/* API callback used for reading from the VCAP into the VCAP cache */
+static void sparx5_vcap_cache_read(struct net_device *ndev,
+				   struct vcap_admin *admin,
+				   enum vcap_selection sel,
+				   u32 start,
+				   u32 count)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS0:
+		sparx5_vcap_is0_cache_read(sparx5, admin, sel, start, count);
+		break;
+	case VCAP_TYPE_IS2:
+		sparx5_vcap_is2_cache_read(sparx5, admin, sel, start, count);
+		break;
+	case VCAP_TYPE_ES2:
+		sparx5_vcap_es2_cache_read(sparx5, admin, sel, start, count);
+		break;
+	default:
+		sparx5_vcap_type_err(sparx5, admin, __func__);
+		break;
+	}
 }
 
 /* API callback used for initializing a VCAP address range */
@@ -712,16 +1116,12 @@ static void sparx5_vcap_range_init(struct net_device *ndev,
 	_sparx5_vcap_range_init(sparx5, admin, addr, count);
 }
 
-/* API callback used for updating the VCAP cache, IS0 and IS2 for now */
-static void sparx5_vcap_update(struct net_device *ndev,
-			       struct vcap_admin *admin, enum vcap_command cmd,
-			       enum vcap_selection sel, u32 addr)
+static void sparx5_vcap_super_update(struct sparx5 *sparx5,
+				     enum vcap_command cmd,
+				     enum vcap_selection sel, u32 addr)
 {
-	struct sparx5_port *port = netdev_priv(ndev);
-	struct sparx5 *sparx5 = port->sparx5;
-	bool clear;
+	bool clear = (cmd == VCAP_CMD_INITIALIZE);
 
-	clear = (cmd == VCAP_CMD_INITIALIZE);
 	spx5_wr(VCAP_SUPER_CFG_MV_NUM_POS_SET(0) |
 		VCAP_SUPER_CFG_MV_SIZE_SET(0), sparx5, VCAP_SUPER_CFG);
 	spx5_wr(VCAP_SUPER_CTRL_UPDATE_CMD_SET(cmd) |
@@ -735,6 +1135,87 @@ static void sparx5_vcap_update(struct net_device *ndev,
 	sparx5_vcap_wait_super_update(sparx5);
 }
 
+static void sparx5_vcap_es2_update(struct sparx5 *sparx5,
+				   enum vcap_command cmd,
+				   enum vcap_selection sel, u32 addr)
+{
+	bool clear = (cmd == VCAP_CMD_INITIALIZE);
+
+	spx5_wr(VCAP_ES2_CFG_MV_NUM_POS_SET(0) |
+		VCAP_ES2_CFG_MV_SIZE_SET(0), sparx5, VCAP_ES2_CFG);
+	spx5_wr(VCAP_ES2_CTRL_UPDATE_CMD_SET(cmd) |
+		VCAP_ES2_CTRL_UPDATE_ENTRY_DIS_SET((VCAP_SEL_ENTRY & sel) == 0) |
+		VCAP_ES2_CTRL_UPDATE_ACTION_DIS_SET((VCAP_SEL_ACTION & sel) == 0) |
+		VCAP_ES2_CTRL_UPDATE_CNT_DIS_SET((VCAP_SEL_COUNTER & sel) == 0) |
+		VCAP_ES2_CTRL_UPDATE_ADDR_SET(addr) |
+		VCAP_ES2_CTRL_CLEAR_CACHE_SET(clear) |
+		VCAP_ES2_CTRL_UPDATE_SHOT_SET(true),
+		sparx5, VCAP_ES2_CTRL);
+	sparx5_vcap_wait_es2_update(sparx5);
+}
+
+/* API callback used for updating the VCAP cache */
+static void sparx5_vcap_update(struct net_device *ndev,
+			       struct vcap_admin *admin, enum vcap_command cmd,
+			       enum vcap_selection sel, u32 addr)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS0:
+	case VCAP_TYPE_IS2:
+		sparx5_vcap_super_update(sparx5, cmd, sel, addr);
+		break;
+	case VCAP_TYPE_ES2:
+		sparx5_vcap_es2_update(sparx5, cmd, sel, addr);
+		break;
+	default:
+		sparx5_vcap_type_err(sparx5, admin, __func__);
+		break;
+	}
+}
+
+static void sparx5_vcap_super_move(struct sparx5 *sparx5,
+				   u32 addr,
+				   enum vcap_command cmd,
+				   u16 mv_num_pos,
+				   u16 mv_size)
+{
+	spx5_wr(VCAP_SUPER_CFG_MV_NUM_POS_SET(mv_num_pos) |
+		VCAP_SUPER_CFG_MV_SIZE_SET(mv_size),
+		sparx5, VCAP_SUPER_CFG);
+	spx5_wr(VCAP_SUPER_CTRL_UPDATE_CMD_SET(cmd) |
+		VCAP_SUPER_CTRL_UPDATE_ENTRY_DIS_SET(0) |
+		VCAP_SUPER_CTRL_UPDATE_ACTION_DIS_SET(0) |
+		VCAP_SUPER_CTRL_UPDATE_CNT_DIS_SET(0) |
+		VCAP_SUPER_CTRL_UPDATE_ADDR_SET(addr) |
+		VCAP_SUPER_CTRL_CLEAR_CACHE_SET(false) |
+		VCAP_SUPER_CTRL_UPDATE_SHOT_SET(true),
+		sparx5, VCAP_SUPER_CTRL);
+	sparx5_vcap_wait_super_update(sparx5);
+}
+
+static void sparx5_vcap_es2_move(struct sparx5 *sparx5,
+				 u32 addr,
+				 enum vcap_command cmd,
+				 u16 mv_num_pos,
+				 u16 mv_size)
+{
+	spx5_wr(VCAP_ES2_CFG_MV_NUM_POS_SET(mv_num_pos) |
+		VCAP_ES2_CFG_MV_SIZE_SET(mv_size),
+		sparx5, VCAP_ES2_CFG);
+	spx5_wr(VCAP_ES2_CTRL_UPDATE_CMD_SET(cmd) |
+		VCAP_ES2_CTRL_UPDATE_ENTRY_DIS_SET(0) |
+		VCAP_ES2_CTRL_UPDATE_ACTION_DIS_SET(0) |
+		VCAP_ES2_CTRL_UPDATE_CNT_DIS_SET(0) |
+		VCAP_ES2_CTRL_UPDATE_ADDR_SET(addr) |
+		VCAP_ES2_CTRL_CLEAR_CACHE_SET(false) |
+		VCAP_ES2_CTRL_UPDATE_SHOT_SET(true),
+		sparx5, VCAP_ES2_CTRL);
+	sparx5_vcap_wait_es2_update(sparx5);
+}
+
 /* API callback used for moving a block of rules in the VCAP */
 static void sparx5_vcap_move(struct net_device *ndev, struct vcap_admin *admin,
 			     u32 addr, int offset, int count)
@@ -753,18 +1234,19 @@ static void sparx5_vcap_move(struct net_device *ndev, struct vcap_admin *admin,
 		mv_num_pos = -offset - 1;
 		cmd = VCAP_CMD_MOVE_UP;
 	}
-	spx5_wr(VCAP_SUPER_CFG_MV_NUM_POS_SET(mv_num_pos) |
-		VCAP_SUPER_CFG_MV_SIZE_SET(mv_size),
-		sparx5, VCAP_SUPER_CFG);
-	spx5_wr(VCAP_SUPER_CTRL_UPDATE_CMD_SET(cmd) |
-		VCAP_SUPER_CTRL_UPDATE_ENTRY_DIS_SET(0) |
-		VCAP_SUPER_CTRL_UPDATE_ACTION_DIS_SET(0) |
-		VCAP_SUPER_CTRL_UPDATE_CNT_DIS_SET(0) |
-		VCAP_SUPER_CTRL_UPDATE_ADDR_SET(addr) |
-		VCAP_SUPER_CTRL_CLEAR_CACHE_SET(false) |
-		VCAP_SUPER_CTRL_UPDATE_SHOT_SET(true),
-		sparx5, VCAP_SUPER_CTRL);
-	sparx5_vcap_wait_super_update(sparx5);
+
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS0:
+	case VCAP_TYPE_IS2:
+		sparx5_vcap_super_move(sparx5, addr, cmd, mv_num_pos, mv_size);
+		break;
+	case VCAP_TYPE_ES2:
+		sparx5_vcap_es2_move(sparx5, addr, cmd, mv_num_pos, mv_size);
+		break;
+	default:
+		sparx5_vcap_type_err(sparx5, admin, __func__);
+		break;
+	}
 }
 
 static struct vcap_operations sparx5_vcap_ops = {
@@ -832,6 +1314,22 @@ static void sparx5_vcap_is2_port_key_selection(struct sparx5 *sparx5,
 			 ANA_ACL_VCAP_S2_CFG(portno));
 }
 
+/* Enable ES2 lookups per port and set the keyset generation */
+static void sparx5_vcap_es2_port_key_selection(struct sparx5 *sparx5,
+					       struct vcap_admin *admin)
+{
+	int portno, lookup;
+	u32 keysel;
+
+	keysel = VCAP_ES2_KEYSEL(true, VCAP_ES2_PS_ARP_MAC_ETYPE,
+				 VCAP_ES2_PS_IPV4_IP4_TCP_UDP_OTHER,
+				 VCAP_ES2_PS_IPV6_IP_7TUPLE);
+	for (lookup = 0; lookup < admin->lookups; ++lookup)
+		for (portno = 0; portno < SPX5_PORTS; ++portno)
+			spx5_wr(keysel, sparx5,
+				EACL_VCAP_ES2_KEY_SEL(portno, lookup));
+}
+
 /* Enable lookups per port and set the keyset generation */
 static void sparx5_vcap_port_key_selection(struct sparx5 *sparx5,
 					   struct vcap_admin *admin)
@@ -843,6 +1341,9 @@ static void sparx5_vcap_port_key_selection(struct sparx5 *sparx5,
 	case VCAP_TYPE_IS2:
 		sparx5_vcap_is2_port_key_selection(sparx5, admin);
 		break;
+	case VCAP_TYPE_ES2:
+		sparx5_vcap_es2_port_key_selection(sparx5, admin);
+		break;
 	default:
 		sparx5_vcap_type_err(sparx5, admin, __func__);
 		break;
@@ -871,6 +1372,14 @@ static void sparx5_vcap_port_key_deselection(struct sparx5 *sparx5,
 				 sparx5,
 				 ANA_ACL_VCAP_S2_CFG(portno));
 		break;
+	case VCAP_TYPE_ES2:
+		for (lookup = 0; lookup < admin->lookups; ++lookup)
+			for (portno = 0; portno < SPX5_PORTS; ++portno)
+				spx5_rmw(EACL_VCAP_ES2_KEY_SEL_KEY_ENA_SET(0),
+					 EACL_VCAP_ES2_KEY_SEL_KEY_ENA,
+					 sparx5,
+					 EACL_VCAP_ES2_KEY_SEL(portno, lookup));
+		break;
 	default:
 		sparx5_vcap_type_err(sparx5, admin, __func__);
 		break;
@@ -927,22 +1436,43 @@ static void sparx5_vcap_block_alloc(struct sparx5 *sparx5,
 				    struct vcap_admin *admin,
 				    const struct sparx5_vcap_inst *cfg)
 {
-	int idx;
+	int idx, cores;
 
-	/* Super VCAP block mapping and address configuration. Block 0
-	 * is assigned addresses 0 through 3071, block 1 is assigned
-	 * addresses 3072 though 6143, and so on.
-	 */
-	for (idx = cfg->blockno; idx < cfg->blockno + cfg->blocks; ++idx) {
-		spx5_wr(VCAP_SUPER_IDX_CORE_IDX_SET(idx), sparx5,
-			VCAP_SUPER_IDX);
-		spx5_wr(VCAP_SUPER_MAP_CORE_MAP_SET(cfg->map_id), sparx5,
-			VCAP_SUPER_MAP);
-	}
-	admin->first_valid_addr = cfg->blockno * SUPER_VCAP_BLK_SIZE;
-	admin->last_used_addr = admin->first_valid_addr +
-		cfg->blocks * SUPER_VCAP_BLK_SIZE;
-	admin->last_valid_addr = admin->last_used_addr - 1;
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS0:
+	case VCAP_TYPE_IS2:
+		/* Super VCAP block mapping and address configuration. Block 0
+		 * is assigned addresses 0 through 3071, block 1 is assigned
+		 * addresses 3072 though 6143, and so on.
+		 */
+		for (idx = cfg->blockno; idx < cfg->blockno + cfg->blocks;
+		     ++idx) {
+			spx5_wr(VCAP_SUPER_IDX_CORE_IDX_SET(idx), sparx5,
+				VCAP_SUPER_IDX);
+			spx5_wr(VCAP_SUPER_MAP_CORE_MAP_SET(cfg->map_id),
+				sparx5, VCAP_SUPER_MAP);
+		}
+		admin->first_valid_addr = cfg->blockno * SUPER_VCAP_BLK_SIZE;
+		admin->last_used_addr = admin->first_valid_addr +
+			cfg->blocks * SUPER_VCAP_BLK_SIZE;
+		admin->last_valid_addr = admin->last_used_addr - 1;
+		break;
+	case VCAP_TYPE_ES2:
+		admin->first_valid_addr = 0;
+		admin->last_used_addr = cfg->count;
+		admin->last_valid_addr = cfg->count - 1;
+		cores = spx5_rd(sparx5, VCAP_ES2_CORE_CNT);
+		for (idx = 0; idx < cores; ++idx) {
+			spx5_wr(VCAP_ES2_IDX_CORE_IDX_SET(idx), sparx5,
+				VCAP_ES2_IDX);
+			spx5_wr(VCAP_ES2_MAP_CORE_MAP_SET(1), sparx5,
+				VCAP_ES2_MAP);
+		}
+		break;
+	default:
+		sparx5_vcap_type_err(sparx5, admin, __func__);
+		break;
+	}
 }
 
 /* Allocate a vcap control and vcap instances and configure the system */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
index aabdf4355103..46a08d5aff3d 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
@@ -32,6 +32,11 @@
 #define SPARX5_VCAP_CID_IS2_MAX \
 	(VCAP_CID_INGRESS_STAGE2_L3 + VCAP_CID_LOOKUP_SIZE - 1) /* IS2 Max */
 
+#define SPARX5_VCAP_CID_ES2_L0 VCAP_CID_EGRESS_STAGE2_L0 /* ES2 lookup 0 */
+#define SPARX5_VCAP_CID_ES2_L1 VCAP_CID_EGRESS_STAGE2_L1 /* ES2 lookup 1 */
+#define SPARX5_VCAP_CID_ES2_MAX \
+	(VCAP_CID_EGRESS_STAGE2_L1 + VCAP_CID_LOOKUP_SIZE - 1) /* ES2 Max */
+
 /* IS0 port keyset selection control */
 
 /* IS0 ethernet, IPv4, IPv6 traffic type keyset generation */
@@ -129,6 +134,35 @@ enum vcap_is2_port_sel_arp {
 	VCAP_IS2_PS_ARP_ARP,
 };
 
+/* ES2 port keyset selection control */
+
+/* ES2 IPv4 traffic type keyset generation */
+enum vcap_es2_port_sel_ipv4 {
+	VCAP_ES2_PS_IPV4_MAC_ETYPE,
+	VCAP_ES2_PS_IPV4_IP_7TUPLE,
+	VCAP_ES2_PS_IPV4_IP4_TCP_UDP_VID,
+	VCAP_ES2_PS_IPV4_IP4_TCP_UDP_OTHER,
+	VCAP_ES2_PS_IPV4_IP4_VID,
+	VCAP_ES2_PS_IPV4_IP4_OTHER,
+};
+
+/* ES2 IPv6 traffic type keyset generation */
+enum vcap_es2_port_sel_ipv6 {
+	VCAP_ES2_PS_IPV6_MAC_ETYPE,
+	VCAP_ES2_PS_IPV6_IP_7TUPLE,
+	VCAP_ES2_PS_IPV6_IP_7TUPLE_VID,
+	VCAP_ES2_PS_IPV6_IP_7TUPLE_STD,
+	VCAP_ES2_PS_IPV6_IP6_VID,
+	VCAP_ES2_PS_IPV6_IP6_STD,
+	VCAP_ES2_PS_IPV6_IP4_DOWNGRADE,
+};
+
+/* ES2 ARP traffic type keyset generation */
+enum vcap_es2_port_sel_arp {
+	VCAP_ES2_PS_ARP_MAC_ETYPE,
+	VCAP_ES2_PS_ARP_ARP,
+};
+
 /* Get the port keyset for the vcap lookup */
 int sparx5_vcap_get_port_keyset(struct net_device *ndev,
 				struct vcap_admin *admin,
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
index d49b1cf7712f..08b18c9360f2 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
@@ -44,11 +44,14 @@ static void vcap_debugfs_show_rule_keyfield(struct vcap_control *vctrl,
 			out->prf(out->dst, "%pI4h/%pI4h", &data->u32.value,
 				 &data->u32.mask);
 		} else if (key == VCAP_KF_ETYPE ||
-			   key == VCAP_KF_IF_IGR_PORT_MASK) {
+			   key == VCAP_KF_IF_IGR_PORT_MASK ||
+			   key == VCAP_KF_IF_EGR_PORT_MASK) {
 			hex = true;
 		} else {
 			u32 fmsk = (1 << keyfield[key].width) - 1;
 
+			if (keyfield[key].width == 32)
+				fmsk = ~0;
 			out->prf(out->dst, "%u/%u", data->u32.value & fmsk,
 				 data->u32.mask & fmsk);
 		}
-- 
2.39.1

