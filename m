Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E810668EF88
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 14:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjBHNLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 08:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjBHNLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 08:11:00 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4473D4617A;
        Wed,  8 Feb 2023 05:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675861858; x=1707397858;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/CkzejY3AiGi2ChAGPQxOuEcdv0774TIJZZA086KWiM=;
  b=jDLh0Xjtbp6H6CbKY4SRNHIkgUFGr+n8HRt3JfHstGndctgbvr710phJ
   56QuXNxfR4xE/D2QDNSduh0c0If2H5hFCawIr45BUXKbvkhDxU4Pgrf34
   bgLBrDx77S7FRIPI7gRQqus356wBXuaWgDC0KIDrVoSDqYXObu326/ZFg
   P1qnXiEbaaQtZES4SNcYYpD4VZSf9OyHF3EygoV4qocKO+D1AB0SH2Mfh
   yxcEQGTK4AqX+MskgpSrnLdvW0ReD3s3SA95Sw3fUHDWkpgxOX81QiCwL
   KDOidU5MoKaCffTAmngsJIqhir3lD9AKZ4Q/LYIGGeyPv6pQjsApXgCeh
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,280,1669100400"; 
   d="scan'208";a="200078106"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Feb 2023 06:10:50 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 06:10:44 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 8 Feb 2023 06:10:41 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: microchip: vcap: Add tc flower keys for lan966x
Date:   Wed, 8 Feb 2023 14:08:39 +0100
Message-ID: <20230208130839.1696860-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the following TC flower filter keys to lan966x for IS2:
- ipv4_addr (sip and dip)
- ipv6_addr (sip and dip)
- control (IPv4 fragments)
- portnum (tcp and udp port numbers)
- basic (L3 and L4 protocol)
- vlan (outer vlan tag info)
- tcp (tcp flags)
- ip (tos field)

As the parsing of these keys is similar between lan966x and sparx5, move
the code in a separate file to be shared by these 2 chips. And put the
specific parsing outside of the common functions.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../microchip/lan966x/lan966x_tc_flower.c     | 138 ++++-
 .../microchip/sparx5/sparx5_tc_flower.c       | 503 ++----------------
 drivers/net/ethernet/microchip/vcap/Makefile  |   2 +-
 drivers/net/ethernet/microchip/vcap/vcap_tc.c | 409 ++++++++++++++
 drivers/net/ethernet/microchip/vcap/vcap_tc.h |  31 ++
 5 files changed, 607 insertions(+), 476 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_tc.c
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_tc.h

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
index 1e464bb804ae0..bd10a71897418 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
@@ -3,53 +3,135 @@
 #include "lan966x_main.h"
 #include "vcap_api.h"
 #include "vcap_api_client.h"
+#include "vcap_tc.h"
 
-struct lan966x_tc_flower_parse_usage {
-	struct flow_cls_offload *f;
-	struct flow_rule *frule;
-	struct vcap_rule *vrule;
-	unsigned int used_keys;
-	u16 l3_proto;
-};
+static bool lan966x_tc_is_known_etype(u16 etype)
+{
+	switch (etype) {
+	case ETH_P_ALL:
+	case ETH_P_ARP:
+	case ETH_P_IP:
+	case ETH_P_IPV6:
+		return true;
+	}
 
-static int lan966x_tc_flower_handler_ethaddr_usage(struct lan966x_tc_flower_parse_usage *st)
+	return false;
+}
+
+static int
+lan966x_tc_flower_handler_control_usage(struct vcap_tc_flower_parse_usage *st)
 {
-	enum vcap_key_field smac_key = VCAP_KF_L2_SMAC;
-	enum vcap_key_field dmac_key = VCAP_KF_L2_DMAC;
-	struct flow_match_eth_addrs match;
-	struct vcap_u48_key smac, dmac;
+	struct flow_match_control match;
 	int err = 0;
 
-	flow_rule_match_eth_addrs(st->frule, &match);
-
-	if (!is_zero_ether_addr(match.mask->src)) {
-		vcap_netbytes_copy(smac.value, match.key->src, ETH_ALEN);
-		vcap_netbytes_copy(smac.mask, match.mask->src, ETH_ALEN);
-		err = vcap_rule_add_key_u48(st->vrule, smac_key, &smac);
+	flow_rule_match_control(st->frule, &match);
+	if (match.mask->flags & FLOW_DIS_IS_FRAGMENT) {
+		if (match.key->flags & FLOW_DIS_IS_FRAGMENT)
+			err = vcap_rule_add_key_bit(st->vrule,
+						    VCAP_KF_L3_FRAGMENT,
+						    VCAP_BIT_1);
+		else
+			err = vcap_rule_add_key_bit(st->vrule,
+						    VCAP_KF_L3_FRAGMENT,
+						    VCAP_BIT_0);
 		if (err)
 			goto out;
 	}
 
-	if (!is_zero_ether_addr(match.mask->dst)) {
-		vcap_netbytes_copy(dmac.value, match.key->dst, ETH_ALEN);
-		vcap_netbytes_copy(dmac.mask, match.mask->dst, ETH_ALEN);
-		err = vcap_rule_add_key_u48(st->vrule, dmac_key, &dmac);
+	if (match.mask->flags & FLOW_DIS_FIRST_FRAG) {
+		if (match.key->flags & FLOW_DIS_FIRST_FRAG)
+			err = vcap_rule_add_key_bit(st->vrule,
+						    VCAP_KF_L3_FRAG_OFS_GT0,
+						    VCAP_BIT_0);
+		else
+			err = vcap_rule_add_key_bit(st->vrule,
+						    VCAP_KF_L3_FRAG_OFS_GT0,
+						    VCAP_BIT_1);
 		if (err)
 			goto out;
 	}
 
-	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS);
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_CONTROL);
 
 	return err;
 
 out:
-	NL_SET_ERR_MSG_MOD(st->f->common.extack, "eth_addr parse error");
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "ip_frag parse error");
+	return err;
+}
+
+static int
+lan966x_tc_flower_handler_basic_usage(struct vcap_tc_flower_parse_usage *st)
+{
+	struct flow_match_basic match;
+	int err = 0;
+
+	flow_rule_match_basic(st->frule, &match);
+	if (match.mask->n_proto) {
+		st->l3_proto = be16_to_cpu(match.key->n_proto);
+		if (!lan966x_tc_is_known_etype(st->l3_proto)) {
+			err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_ETYPE,
+						    st->l3_proto, ~0);
+			if (err)
+				goto out;
+		} else if (st->l3_proto == ETH_P_IP) {
+			err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_IP4_IS,
+						    VCAP_BIT_1);
+			if (err)
+				goto out;
+		}
+	}
+	if (match.mask->ip_proto) {
+		st->l4_proto = match.key->ip_proto;
+
+		if (st->l4_proto == IPPROTO_TCP) {
+			err = vcap_rule_add_key_bit(st->vrule,
+						    VCAP_KF_TCP_IS,
+						    VCAP_BIT_1);
+			if (err)
+				goto out;
+		} else if (st->l4_proto == IPPROTO_UDP) {
+			err = vcap_rule_add_key_bit(st->vrule,
+						    VCAP_KF_TCP_IS,
+						    VCAP_BIT_0);
+			if (err)
+				goto out;
+		} else {
+			err = vcap_rule_add_key_u32(st->vrule,
+						    VCAP_KF_L3_IP_PROTO,
+						    st->l4_proto, ~0);
+			if (err)
+				goto out;
+		}
+	}
+
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_BASIC);
+	return err;
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "ip_proto parse error");
 	return err;
 }
 
 static int
-(*lan966x_tc_flower_handlers_usage[])(struct lan966x_tc_flower_parse_usage *st) = {
-	[FLOW_DISSECTOR_KEY_ETH_ADDRS] = lan966x_tc_flower_handler_ethaddr_usage,
+lan966x_tc_flower_handler_vlan_usage(struct vcap_tc_flower_parse_usage *st)
+{
+	return vcap_tc_flower_handler_vlan_usage(st,
+						 VCAP_KF_8021Q_VID_CLS,
+						 VCAP_KF_8021Q_PCP_CLS);
+}
+
+static int
+(*lan966x_tc_flower_handlers_usage[])(struct vcap_tc_flower_parse_usage *st) = {
+	[FLOW_DISSECTOR_KEY_ETH_ADDRS] = vcap_tc_flower_handler_ethaddr_usage,
+	[FLOW_DISSECTOR_KEY_IPV4_ADDRS] = vcap_tc_flower_handler_ipv4_usage,
+	[FLOW_DISSECTOR_KEY_IPV6_ADDRS] = vcap_tc_flower_handler_ipv6_usage,
+	[FLOW_DISSECTOR_KEY_CONTROL] = lan966x_tc_flower_handler_control_usage,
+	[FLOW_DISSECTOR_KEY_PORTS] = vcap_tc_flower_handler_portnum_usage,
+	[FLOW_DISSECTOR_KEY_BASIC] = lan966x_tc_flower_handler_basic_usage,
+	[FLOW_DISSECTOR_KEY_VLAN] = lan966x_tc_flower_handler_vlan_usage,
+	[FLOW_DISSECTOR_KEY_TCP] = vcap_tc_flower_handler_tcp_usage,
+	[FLOW_DISSECTOR_KEY_ARP] = vcap_tc_flower_handler_arp_usage,
+	[FLOW_DISSECTOR_KEY_IP] = vcap_tc_flower_handler_ip_usage,
 };
 
 static int lan966x_tc_flower_use_dissectors(struct flow_cls_offload *f,
@@ -57,8 +139,8 @@ static int lan966x_tc_flower_use_dissectors(struct flow_cls_offload *f,
 					    struct vcap_rule *vrule,
 					    u16 *l3_proto)
 {
-	struct lan966x_tc_flower_parse_usage state = {
-		.f = f,
+	struct vcap_tc_flower_parse_usage state = {
+		.fco = f,
 		.vrule = vrule,
 		.l3_proto = ETH_P_ALL,
 	};
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index f962304272c28..d73668dcc6b6d 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -10,6 +10,7 @@
 #include "sparx5_tc.h"
 #include "vcap_api.h"
 #include "vcap_api_client.h"
+#include "vcap_tc.h"
 #include "sparx5_main.h"
 #include "sparx5_vcap_impl.h"
 
@@ -27,223 +28,8 @@ struct sparx5_multiple_rules {
 	struct sparx5_wildcard_rule rule[SPX5_MAX_RULE_SIZE];
 };
 
-struct sparx5_tc_flower_parse_usage {
-	struct flow_cls_offload *fco;
-	struct flow_rule *frule;
-	struct vcap_rule *vrule;
-	struct vcap_admin *admin;
-	u16 l3_proto;
-	u8 l4_proto;
-	unsigned int used_keys;
-};
-
-enum sparx5_is2_arp_opcode {
-	SPX5_IS2_ARP_REQUEST,
-	SPX5_IS2_ARP_REPLY,
-	SPX5_IS2_RARP_REQUEST,
-	SPX5_IS2_RARP_REPLY,
-};
-
-enum tc_arp_opcode {
-	TC_ARP_OP_RESERVED,
-	TC_ARP_OP_REQUEST,
-	TC_ARP_OP_REPLY,
-};
-
-static int sparx5_tc_flower_handler_ethaddr_usage(struct sparx5_tc_flower_parse_usage *st)
-{
-	enum vcap_key_field smac_key = VCAP_KF_L2_SMAC;
-	enum vcap_key_field dmac_key = VCAP_KF_L2_DMAC;
-	struct flow_match_eth_addrs match;
-	struct vcap_u48_key smac, dmac;
-	int err = 0;
-
-	flow_rule_match_eth_addrs(st->frule, &match);
-
-	if (!is_zero_ether_addr(match.mask->src)) {
-		vcap_netbytes_copy(smac.value, match.key->src, ETH_ALEN);
-		vcap_netbytes_copy(smac.mask, match.mask->src, ETH_ALEN);
-		err = vcap_rule_add_key_u48(st->vrule, smac_key, &smac);
-		if (err)
-			goto out;
-	}
-
-	if (!is_zero_ether_addr(match.mask->dst)) {
-		vcap_netbytes_copy(dmac.value, match.key->dst, ETH_ALEN);
-		vcap_netbytes_copy(dmac.mask, match.mask->dst, ETH_ALEN);
-		err = vcap_rule_add_key_u48(st->vrule, dmac_key, &dmac);
-		if (err)
-			goto out;
-	}
-
-	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS);
-
-	return err;
-
-out:
-	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "eth_addr parse error");
-	return err;
-}
-
 static int
-sparx5_tc_flower_handler_ipv4_usage(struct sparx5_tc_flower_parse_usage *st)
-{
-	int err = 0;
-
-	if (st->l3_proto == ETH_P_IP) {
-		struct flow_match_ipv4_addrs mt;
-
-		flow_rule_match_ipv4_addrs(st->frule, &mt);
-		if (mt.mask->src) {
-			err = vcap_rule_add_key_u32(st->vrule,
-						    VCAP_KF_L3_IP4_SIP,
-						    be32_to_cpu(mt.key->src),
-						    be32_to_cpu(mt.mask->src));
-			if (err)
-				goto out;
-		}
-		if (mt.mask->dst) {
-			err = vcap_rule_add_key_u32(st->vrule,
-						    VCAP_KF_L3_IP4_DIP,
-						    be32_to_cpu(mt.key->dst),
-						    be32_to_cpu(mt.mask->dst));
-			if (err)
-				goto out;
-		}
-	}
-
-	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS);
-
-	return err;
-
-out:
-	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "ipv4_addr parse error");
-	return err;
-}
-
-static int
-sparx5_tc_flower_handler_ipv6_usage(struct sparx5_tc_flower_parse_usage *st)
-{
-	int err = 0;
-
-	if (st->l3_proto == ETH_P_IPV6) {
-		struct flow_match_ipv6_addrs mt;
-		struct vcap_u128_key sip;
-		struct vcap_u128_key dip;
-
-		flow_rule_match_ipv6_addrs(st->frule, &mt);
-		/* Check if address masks are non-zero */
-		if (!ipv6_addr_any(&mt.mask->src)) {
-			vcap_netbytes_copy(sip.value, mt.key->src.s6_addr, 16);
-			vcap_netbytes_copy(sip.mask, mt.mask->src.s6_addr, 16);
-			err = vcap_rule_add_key_u128(st->vrule,
-						     VCAP_KF_L3_IP6_SIP, &sip);
-			if (err)
-				goto out;
-		}
-		if (!ipv6_addr_any(&mt.mask->dst)) {
-			vcap_netbytes_copy(dip.value, mt.key->dst.s6_addr, 16);
-			vcap_netbytes_copy(dip.mask, mt.mask->dst.s6_addr, 16);
-			err = vcap_rule_add_key_u128(st->vrule,
-						     VCAP_KF_L3_IP6_DIP, &dip);
-			if (err)
-				goto out;
-		}
-	}
-	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS);
-	return err;
-out:
-	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "ipv6_addr parse error");
-	return err;
-}
-
-static int
-sparx5_tc_flower_handler_control_usage(struct sparx5_tc_flower_parse_usage *st)
-{
-	struct flow_match_control mt;
-	u32 value, mask;
-	int err = 0;
-
-	flow_rule_match_control(st->frule, &mt);
-
-	if (mt.mask->flags) {
-		if (mt.mask->flags & FLOW_DIS_FIRST_FRAG) {
-			if (mt.key->flags & FLOW_DIS_FIRST_FRAG) {
-				value = 1; /* initial fragment */
-				mask = 0x3;
-			} else {
-				if (mt.mask->flags & FLOW_DIS_IS_FRAGMENT) {
-					value = 3; /* follow up fragment */
-					mask = 0x3;
-				} else {
-					value = 0; /* no fragment */
-					mask = 0x3;
-				}
-			}
-		} else {
-			if (mt.mask->flags & FLOW_DIS_IS_FRAGMENT) {
-				value = 3; /* follow up fragment */
-				mask = 0x3;
-			} else {
-				value = 0; /* no fragment */
-				mask = 0x3;
-			}
-		}
-
-		err = vcap_rule_add_key_u32(st->vrule,
-					    VCAP_KF_L3_FRAGMENT_TYPE,
-					    value, mask);
-		if (err)
-			goto out;
-	}
-
-	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_CONTROL);
-
-	return err;
-
-out:
-	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "ip_frag parse error");
-	return err;
-}
-
-static int
-sparx5_tc_flower_handler_portnum_usage(struct sparx5_tc_flower_parse_usage *st)
-{
-	struct flow_match_ports mt;
-	u16 value, mask;
-	int err = 0;
-
-	flow_rule_match_ports(st->frule, &mt);
-
-	if (mt.mask->src) {
-		value = be16_to_cpu(mt.key->src);
-		mask = be16_to_cpu(mt.mask->src);
-		err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_L4_SPORT, value,
-					    mask);
-		if (err)
-			goto out;
-	}
-
-	if (mt.mask->dst) {
-		value = be16_to_cpu(mt.key->dst);
-		mask = be16_to_cpu(mt.mask->dst);
-		err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_L4_DPORT, value,
-					    mask);
-		if (err)
-			goto out;
-	}
-
-	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_PORTS);
-
-	return err;
-
-out:
-	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "port parse error");
-	return err;
-}
-
-static int
-sparx5_tc_flower_handler_basic_usage(struct sparx5_tc_flower_parse_usage *st)
+sparx5_tc_flower_handler_basic_usage(struct vcap_tc_flower_parse_usage *st)
 {
 	struct flow_match_basic mt;
 	int err = 0;
@@ -274,7 +60,6 @@ sparx5_tc_flower_handler_basic_usage(struct sparx5_tc_flower_parse_usage *st)
 				if (err)
 					goto out;
 			}
-
 		}
 	}
 
@@ -318,268 +103,92 @@ sparx5_tc_flower_handler_basic_usage(struct sparx5_tc_flower_parse_usage *st)
 }
 
 static int
-sparx5_tc_flower_handler_cvlan_usage(struct sparx5_tc_flower_parse_usage *st)
-{
-	enum vcap_key_field vid_key = VCAP_KF_8021Q_VID0;
-	enum vcap_key_field pcp_key = VCAP_KF_8021Q_PCP0;
-	struct flow_match_vlan mt;
-	u16 tpid;
-	int err;
-
-	if (st->admin->vtype != VCAP_TYPE_IS0) {
-		NL_SET_ERR_MSG_MOD(st->fco->common.extack,
-				   "cvlan not supported in this VCAP");
-		return -EINVAL;
-	}
-
-	flow_rule_match_cvlan(st->frule, &mt);
-
-	tpid = be16_to_cpu(mt.key->vlan_tpid);
-
-	if (tpid == ETH_P_8021Q) {
-		vid_key = VCAP_KF_8021Q_VID1;
-		pcp_key = VCAP_KF_8021Q_PCP1;
-	}
-
-	if (mt.mask->vlan_id) {
-		err = vcap_rule_add_key_u32(st->vrule, vid_key,
-					    mt.key->vlan_id,
-					    mt.mask->vlan_id);
-		if (err)
-			goto out;
-	}
-
-	if (mt.mask->vlan_priority) {
-		err = vcap_rule_add_key_u32(st->vrule, pcp_key,
-					    mt.key->vlan_priority,
-					    mt.mask->vlan_priority);
-		if (err)
-			goto out;
-	}
-
-	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_CVLAN);
-
-	return 0;
-out:
-	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "cvlan parse error");
-	return err;
-}
-
-static int
-sparx5_tc_flower_handler_vlan_usage(struct sparx5_tc_flower_parse_usage *st)
+sparx5_tc_flower_handler_control_usage(struct vcap_tc_flower_parse_usage *st)
 {
-	enum vcap_key_field vid_key = VCAP_KF_8021Q_VID_CLS;
-	enum vcap_key_field pcp_key = VCAP_KF_8021Q_PCP_CLS;
-	struct flow_match_vlan mt;
-	int err;
-
-	flow_rule_match_vlan(st->frule, &mt);
-
-	if (st->admin->vtype == VCAP_TYPE_IS0) {
-		vid_key = VCAP_KF_8021Q_VID0;
-		pcp_key = VCAP_KF_8021Q_PCP0;
-	}
-
-	if (mt.mask->vlan_id) {
-		err = vcap_rule_add_key_u32(st->vrule, vid_key,
-					    mt.key->vlan_id,
-					    mt.mask->vlan_id);
-		if (err)
-			goto out;
-	}
-
-	if (mt.mask->vlan_priority) {
-		err = vcap_rule_add_key_u32(st->vrule, pcp_key,
-					    mt.key->vlan_priority,
-					    mt.mask->vlan_priority);
-		if (err)
-			goto out;
-	}
-
-	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_VLAN);
-
-	return 0;
-out:
-	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "vlan parse error");
-	return err;
-}
-
-static int
-sparx5_tc_flower_handler_tcp_usage(struct sparx5_tc_flower_parse_usage *st)
-{
-	struct flow_match_tcp mt;
-	u16 tcp_flags_mask;
-	u16 tcp_flags_key;
-	enum vcap_bit val;
+	struct flow_match_control mt;
+	u32 value, mask;
 	int err = 0;
 
-	flow_rule_match_tcp(st->frule, &mt);
-	tcp_flags_key = be16_to_cpu(mt.key->flags);
-	tcp_flags_mask = be16_to_cpu(mt.mask->flags);
-
-	if (tcp_flags_mask & TCPHDR_FIN) {
-		val = VCAP_BIT_0;
-		if (tcp_flags_key & TCPHDR_FIN)
-			val = VCAP_BIT_1;
-		err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_L4_FIN, val);
-		if (err)
-			goto out;
-	}
-
-	if (tcp_flags_mask & TCPHDR_SYN) {
-		val = VCAP_BIT_0;
-		if (tcp_flags_key & TCPHDR_SYN)
-			val = VCAP_BIT_1;
-		err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_L4_SYN, val);
-		if (err)
-			goto out;
-	}
-
-	if (tcp_flags_mask & TCPHDR_RST) {
-		val = VCAP_BIT_0;
-		if (tcp_flags_key & TCPHDR_RST)
-			val = VCAP_BIT_1;
-		err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_L4_RST, val);
-		if (err)
-			goto out;
-	}
-
-	if (tcp_flags_mask & TCPHDR_PSH) {
-		val = VCAP_BIT_0;
-		if (tcp_flags_key & TCPHDR_PSH)
-			val = VCAP_BIT_1;
-		err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_L4_PSH, val);
-		if (err)
-			goto out;
-	}
+	flow_rule_match_control(st->frule, &mt);
 
-	if (tcp_flags_mask & TCPHDR_ACK) {
-		val = VCAP_BIT_0;
-		if (tcp_flags_key & TCPHDR_ACK)
-			val = VCAP_BIT_1;
-		err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_L4_ACK, val);
-		if (err)
-			goto out;
-	}
+	if (mt.mask->flags) {
+		if (mt.mask->flags & FLOW_DIS_FIRST_FRAG) {
+			if (mt.key->flags & FLOW_DIS_FIRST_FRAG) {
+				value = 1; /* initial fragment */
+				mask = 0x3;
+			} else {
+				if (mt.mask->flags & FLOW_DIS_IS_FRAGMENT) {
+					value = 3; /* follow up fragment */
+					mask = 0x3;
+				} else {
+					value = 0; /* no fragment */
+					mask = 0x3;
+				}
+			}
+		} else {
+			if (mt.mask->flags & FLOW_DIS_IS_FRAGMENT) {
+				value = 3; /* follow up fragment */
+				mask = 0x3;
+			} else {
+				value = 0; /* no fragment */
+				mask = 0x3;
+			}
+		}
 
-	if (tcp_flags_mask & TCPHDR_URG) {
-		val = VCAP_BIT_0;
-		if (tcp_flags_key & TCPHDR_URG)
-			val = VCAP_BIT_1;
-		err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_L4_URG, val);
+		err = vcap_rule_add_key_u32(st->vrule,
+					    VCAP_KF_L3_FRAGMENT_TYPE,
+					    value, mask);
 		if (err)
 			goto out;
 	}
 
-	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_TCP);
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_CONTROL);
 
 	return err;
 
 out:
-	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "tcp_flags parse error");
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "ip_frag parse error");
 	return err;
 }
 
 static int
-sparx5_tc_flower_handler_arp_usage(struct sparx5_tc_flower_parse_usage *st)
+sparx5_tc_flower_handler_cvlan_usage(struct vcap_tc_flower_parse_usage *st)
 {
-	struct flow_match_arp mt;
-	u16 value, mask;
-	u32 ipval, ipmsk;
-	int err;
-
-	flow_rule_match_arp(st->frule, &mt);
-
-	if (mt.mask->op) {
-		mask = 0x3;
-		if (st->l3_proto == ETH_P_ARP) {
-			value = mt.key->op == TC_ARP_OP_REQUEST ?
-					SPX5_IS2_ARP_REQUEST :
-					SPX5_IS2_ARP_REPLY;
-		} else { /* RARP */
-			value = mt.key->op == TC_ARP_OP_REQUEST ?
-					SPX5_IS2_RARP_REQUEST :
-					SPX5_IS2_RARP_REPLY;
-		}
-		err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_ARP_OPCODE,
-					    value, mask);
-		if (err)
-			goto out;
-	}
-
-	/* The IS2 ARP keyset does not support ARP hardware addresses */
-	if (!is_zero_ether_addr(mt.mask->sha) ||
-	    !is_zero_ether_addr(mt.mask->tha)) {
-		err = -EINVAL;
-		goto out;
-	}
-
-	if (mt.mask->sip) {
-		ipval = be32_to_cpu((__force __be32)mt.key->sip);
-		ipmsk = be32_to_cpu((__force __be32)mt.mask->sip);
-
-		err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_L3_IP4_SIP,
-					    ipval, ipmsk);
-		if (err)
-			goto out;
-	}
-
-	if (mt.mask->tip) {
-		ipval = be32_to_cpu((__force __be32)mt.key->tip);
-		ipmsk = be32_to_cpu((__force __be32)mt.mask->tip);
-
-		err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_L3_IP4_DIP,
-					    ipval, ipmsk);
-		if (err)
-			goto out;
+	if (st->admin->vtype != VCAP_TYPE_IS0) {
+		NL_SET_ERR_MSG_MOD(st->fco->common.extack,
+				   "cvlan not supported in this VCAP");
+		return -EINVAL;
 	}
 
-	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_ARP);
-
-	return 0;
-
-out:
-	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "arp parse error");
-	return err;
+	return vcap_tc_flower_handler_cvlan_usage(st);
 }
 
 static int
-sparx5_tc_flower_handler_ip_usage(struct sparx5_tc_flower_parse_usage *st)
+sparx5_tc_flower_handler_vlan_usage(struct vcap_tc_flower_parse_usage *st)
 {
-	struct flow_match_ip mt;
-	int err = 0;
-
-	flow_rule_match_ip(st->frule, &mt);
+	enum vcap_key_field vid_key = VCAP_KF_8021Q_VID_CLS;
+	enum vcap_key_field pcp_key = VCAP_KF_8021Q_PCP_CLS;
 
-	if (mt.mask->tos) {
-		err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_L3_TOS,
-					    mt.key->tos,
-					    mt.mask->tos);
-		if (err)
-			goto out;
+	if (st->admin->vtype == VCAP_TYPE_IS0) {
+		vid_key = VCAP_KF_8021Q_VID0;
+		pcp_key = VCAP_KF_8021Q_PCP0;
 	}
 
-	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_IP);
-
-	return err;
-
-out:
-	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "ip_tos parse error");
-	return err;
+	return vcap_tc_flower_handler_vlan_usage(st, vid_key, pcp_key);
 }
 
-static int (*sparx5_tc_flower_usage_handlers[])(struct sparx5_tc_flower_parse_usage *st) = {
-	[FLOW_DISSECTOR_KEY_ETH_ADDRS] = sparx5_tc_flower_handler_ethaddr_usage,
-	[FLOW_DISSECTOR_KEY_IPV4_ADDRS] = sparx5_tc_flower_handler_ipv4_usage,
-	[FLOW_DISSECTOR_KEY_IPV6_ADDRS] = sparx5_tc_flower_handler_ipv6_usage,
+static int (*sparx5_tc_flower_usage_handlers[])(struct vcap_tc_flower_parse_usage *st) = {
+	[FLOW_DISSECTOR_KEY_ETH_ADDRS] = vcap_tc_flower_handler_ethaddr_usage,
+	[FLOW_DISSECTOR_KEY_IPV4_ADDRS] = vcap_tc_flower_handler_ipv4_usage,
+	[FLOW_DISSECTOR_KEY_IPV6_ADDRS] = vcap_tc_flower_handler_ipv6_usage,
 	[FLOW_DISSECTOR_KEY_CONTROL] = sparx5_tc_flower_handler_control_usage,
-	[FLOW_DISSECTOR_KEY_PORTS] = sparx5_tc_flower_handler_portnum_usage,
+	[FLOW_DISSECTOR_KEY_PORTS] = vcap_tc_flower_handler_portnum_usage,
 	[FLOW_DISSECTOR_KEY_BASIC] = sparx5_tc_flower_handler_basic_usage,
 	[FLOW_DISSECTOR_KEY_CVLAN] = sparx5_tc_flower_handler_cvlan_usage,
 	[FLOW_DISSECTOR_KEY_VLAN] = sparx5_tc_flower_handler_vlan_usage,
-	[FLOW_DISSECTOR_KEY_TCP] = sparx5_tc_flower_handler_tcp_usage,
-	[FLOW_DISSECTOR_KEY_ARP] = sparx5_tc_flower_handler_arp_usage,
-	[FLOW_DISSECTOR_KEY_IP] = sparx5_tc_flower_handler_ip_usage,
+	[FLOW_DISSECTOR_KEY_TCP] = vcap_tc_flower_handler_tcp_usage,
+	[FLOW_DISSECTOR_KEY_ARP] = vcap_tc_flower_handler_arp_usage,
+	[FLOW_DISSECTOR_KEY_IP] = vcap_tc_flower_handler_ip_usage,
 };
 
 static int sparx5_tc_use_dissectors(struct flow_cls_offload *fco,
@@ -587,7 +196,7 @@ static int sparx5_tc_use_dissectors(struct flow_cls_offload *fco,
 				    struct vcap_rule *vrule,
 				    u16 *l3_proto)
 {
-	struct sparx5_tc_flower_parse_usage state = {
+	struct vcap_tc_flower_parse_usage state = {
 		.fco = fco,
 		.vrule = vrule,
 		.l3_proto = ETH_P_ALL,
diff --git a/drivers/net/ethernet/microchip/vcap/Makefile b/drivers/net/ethernet/microchip/vcap/Makefile
index 0adb8f5a8735a..c86f20e6491f0 100644
--- a/drivers/net/ethernet/microchip/vcap/Makefile
+++ b/drivers/net/ethernet/microchip/vcap/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_VCAP) += vcap.o
 obj-$(CONFIG_VCAP_KUNIT_TEST) +=  vcap_model_kunit.o
 vcap-$(CONFIG_DEBUG_FS) += vcap_api_debugfs.o
 
-vcap-y += vcap_api.o
+vcap-y += vcap_api.o vcap_tc.o
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_tc.c b/drivers/net/ethernet/microchip/vcap/vcap_tc.c
new file mode 100644
index 0000000000000..09a994a7cec24
--- /dev/null
+++ b/drivers/net/ethernet/microchip/vcap/vcap_tc.c
@@ -0,0 +1,409 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip VCAP TC
+ *
+ * Copyright (c) 2023 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include <net/flow_offload.h>
+#include <net/ipv6.h>
+#include <net/tcp.h>
+
+#include "vcap_api_client.h"
+#include "vcap_tc.h"
+
+enum vcap_is2_arp_opcode {
+	VCAP_IS2_ARP_REQUEST,
+	VCAP_IS2_ARP_REPLY,
+	VCAP_IS2_RARP_REQUEST,
+	VCAP_IS2_RARP_REPLY,
+};
+
+enum vcap_arp_opcode {
+	VCAP_ARP_OP_RESERVED,
+	VCAP_ARP_OP_REQUEST,
+	VCAP_ARP_OP_REPLY,
+};
+
+int vcap_tc_flower_handler_ethaddr_usage(struct vcap_tc_flower_parse_usage *st)
+{
+	enum vcap_key_field smac_key = VCAP_KF_L2_SMAC;
+	enum vcap_key_field dmac_key = VCAP_KF_L2_DMAC;
+	struct flow_match_eth_addrs match;
+	struct vcap_u48_key smac, dmac;
+	int err = 0;
+
+	flow_rule_match_eth_addrs(st->frule, &match);
+
+	if (!is_zero_ether_addr(match.mask->src)) {
+		vcap_netbytes_copy(smac.value, match.key->src, ETH_ALEN);
+		vcap_netbytes_copy(smac.mask, match.mask->src, ETH_ALEN);
+		err = vcap_rule_add_key_u48(st->vrule, smac_key, &smac);
+		if (err)
+			goto out;
+	}
+
+	if (!is_zero_ether_addr(match.mask->dst)) {
+		vcap_netbytes_copy(dmac.value, match.key->dst, ETH_ALEN);
+		vcap_netbytes_copy(dmac.mask, match.mask->dst, ETH_ALEN);
+		err = vcap_rule_add_key_u48(st->vrule, dmac_key, &dmac);
+		if (err)
+			goto out;
+	}
+
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS);
+
+	return err;
+
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "eth_addr parse error");
+	return err;
+}
+EXPORT_SYMBOL_GPL(vcap_tc_flower_handler_ethaddr_usage);
+
+int vcap_tc_flower_handler_ipv4_usage(struct vcap_tc_flower_parse_usage *st)
+{
+	int err = 0;
+
+	if (st->l3_proto == ETH_P_IP) {
+		struct flow_match_ipv4_addrs mt;
+
+		flow_rule_match_ipv4_addrs(st->frule, &mt);
+		if (mt.mask->src) {
+			err = vcap_rule_add_key_u32(st->vrule,
+						    VCAP_KF_L3_IP4_SIP,
+						    be32_to_cpu(mt.key->src),
+						    be32_to_cpu(mt.mask->src));
+			if (err)
+				goto out;
+		}
+		if (mt.mask->dst) {
+			err = vcap_rule_add_key_u32(st->vrule,
+						    VCAP_KF_L3_IP4_DIP,
+						    be32_to_cpu(mt.key->dst),
+						    be32_to_cpu(mt.mask->dst));
+			if (err)
+				goto out;
+		}
+	}
+
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS);
+
+	return err;
+
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "ipv4_addr parse error");
+	return err;
+}
+EXPORT_SYMBOL_GPL(vcap_tc_flower_handler_ipv4_usage);
+
+int vcap_tc_flower_handler_ipv6_usage(struct vcap_tc_flower_parse_usage *st)
+{
+	int err = 0;
+
+	if (st->l3_proto == ETH_P_IPV6) {
+		struct flow_match_ipv6_addrs mt;
+		struct vcap_u128_key sip;
+		struct vcap_u128_key dip;
+
+		flow_rule_match_ipv6_addrs(st->frule, &mt);
+		/* Check if address masks are non-zero */
+		if (!ipv6_addr_any(&mt.mask->src)) {
+			vcap_netbytes_copy(sip.value, mt.key->src.s6_addr, 16);
+			vcap_netbytes_copy(sip.mask, mt.mask->src.s6_addr, 16);
+			err = vcap_rule_add_key_u128(st->vrule,
+						     VCAP_KF_L3_IP6_SIP, &sip);
+			if (err)
+				goto out;
+		}
+		if (!ipv6_addr_any(&mt.mask->dst)) {
+			vcap_netbytes_copy(dip.value, mt.key->dst.s6_addr, 16);
+			vcap_netbytes_copy(dip.mask, mt.mask->dst.s6_addr, 16);
+			err = vcap_rule_add_key_u128(st->vrule,
+						     VCAP_KF_L3_IP6_DIP, &dip);
+			if (err)
+				goto out;
+		}
+	}
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS);
+	return err;
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "ipv6_addr parse error");
+	return err;
+}
+EXPORT_SYMBOL_GPL(vcap_tc_flower_handler_ipv6_usage);
+
+int vcap_tc_flower_handler_portnum_usage(struct vcap_tc_flower_parse_usage *st)
+{
+	struct flow_match_ports mt;
+	u16 value, mask;
+	int err = 0;
+
+	flow_rule_match_ports(st->frule, &mt);
+
+	if (mt.mask->src) {
+		value = be16_to_cpu(mt.key->src);
+		mask = be16_to_cpu(mt.mask->src);
+		err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_L4_SPORT, value,
+					    mask);
+		if (err)
+			goto out;
+	}
+
+	if (mt.mask->dst) {
+		value = be16_to_cpu(mt.key->dst);
+		mask = be16_to_cpu(mt.mask->dst);
+		err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_L4_DPORT, value,
+					    mask);
+		if (err)
+			goto out;
+	}
+
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_PORTS);
+
+	return err;
+
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "port parse error");
+	return err;
+}
+EXPORT_SYMBOL_GPL(vcap_tc_flower_handler_portnum_usage);
+
+int vcap_tc_flower_handler_cvlan_usage(struct vcap_tc_flower_parse_usage *st)
+{
+	enum vcap_key_field vid_key = VCAP_KF_8021Q_VID0;
+	enum vcap_key_field pcp_key = VCAP_KF_8021Q_PCP0;
+	struct flow_match_vlan mt;
+	u16 tpid;
+	int err;
+
+	flow_rule_match_cvlan(st->frule, &mt);
+
+	tpid = be16_to_cpu(mt.key->vlan_tpid);
+
+	if (tpid == ETH_P_8021Q) {
+		vid_key = VCAP_KF_8021Q_VID1;
+		pcp_key = VCAP_KF_8021Q_PCP1;
+	}
+
+	if (mt.mask->vlan_id) {
+		err = vcap_rule_add_key_u32(st->vrule, vid_key,
+					    mt.key->vlan_id,
+					    mt.mask->vlan_id);
+		if (err)
+			goto out;
+	}
+
+	if (mt.mask->vlan_priority) {
+		err = vcap_rule_add_key_u32(st->vrule, pcp_key,
+					    mt.key->vlan_priority,
+					    mt.mask->vlan_priority);
+		if (err)
+			goto out;
+	}
+
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_CVLAN);
+
+	return 0;
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "cvlan parse error");
+	return err;
+}
+EXPORT_SYMBOL_GPL(vcap_tc_flower_handler_cvlan_usage);
+
+int vcap_tc_flower_handler_vlan_usage(struct vcap_tc_flower_parse_usage *st,
+				      enum vcap_key_field vid_key,
+				      enum vcap_key_field pcp_key)
+{
+	struct flow_match_vlan mt;
+	int err;
+
+	flow_rule_match_vlan(st->frule, &mt);
+
+	if (mt.mask->vlan_id) {
+		err = vcap_rule_add_key_u32(st->vrule, vid_key,
+					    mt.key->vlan_id,
+					    mt.mask->vlan_id);
+		if (err)
+			goto out;
+	}
+
+	if (mt.mask->vlan_priority) {
+		err = vcap_rule_add_key_u32(st->vrule, pcp_key,
+					    mt.key->vlan_priority,
+					    mt.mask->vlan_priority);
+		if (err)
+			goto out;
+	}
+
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_VLAN);
+
+	return 0;
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "vlan parse error");
+	return err;
+}
+EXPORT_SYMBOL_GPL(vcap_tc_flower_handler_vlan_usage);
+
+int vcap_tc_flower_handler_tcp_usage(struct vcap_tc_flower_parse_usage *st)
+{
+	struct flow_match_tcp mt;
+	u16 tcp_flags_mask;
+	u16 tcp_flags_key;
+	enum vcap_bit val;
+	int err = 0;
+
+	flow_rule_match_tcp(st->frule, &mt);
+	tcp_flags_key = be16_to_cpu(mt.key->flags);
+	tcp_flags_mask = be16_to_cpu(mt.mask->flags);
+
+	if (tcp_flags_mask & TCPHDR_FIN) {
+		val = VCAP_BIT_0;
+		if (tcp_flags_key & TCPHDR_FIN)
+			val = VCAP_BIT_1;
+		err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_L4_FIN, val);
+		if (err)
+			goto out;
+	}
+
+	if (tcp_flags_mask & TCPHDR_SYN) {
+		val = VCAP_BIT_0;
+		if (tcp_flags_key & TCPHDR_SYN)
+			val = VCAP_BIT_1;
+		err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_L4_SYN, val);
+		if (err)
+			goto out;
+	}
+
+	if (tcp_flags_mask & TCPHDR_RST) {
+		val = VCAP_BIT_0;
+		if (tcp_flags_key & TCPHDR_RST)
+			val = VCAP_BIT_1;
+		err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_L4_RST, val);
+		if (err)
+			goto out;
+	}
+
+	if (tcp_flags_mask & TCPHDR_PSH) {
+		val = VCAP_BIT_0;
+		if (tcp_flags_key & TCPHDR_PSH)
+			val = VCAP_BIT_1;
+		err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_L4_PSH, val);
+		if (err)
+			goto out;
+	}
+
+	if (tcp_flags_mask & TCPHDR_ACK) {
+		val = VCAP_BIT_0;
+		if (tcp_flags_key & TCPHDR_ACK)
+			val = VCAP_BIT_1;
+		err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_L4_ACK, val);
+		if (err)
+			goto out;
+	}
+
+	if (tcp_flags_mask & TCPHDR_URG) {
+		val = VCAP_BIT_0;
+		if (tcp_flags_key & TCPHDR_URG)
+			val = VCAP_BIT_1;
+		err = vcap_rule_add_key_bit(st->vrule, VCAP_KF_L4_URG, val);
+		if (err)
+			goto out;
+	}
+
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_TCP);
+
+	return err;
+
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "tcp_flags parse error");
+	return err;
+}
+EXPORT_SYMBOL_GPL(vcap_tc_flower_handler_tcp_usage);
+
+int vcap_tc_flower_handler_arp_usage(struct vcap_tc_flower_parse_usage *st)
+{
+	struct flow_match_arp mt;
+	u16 value, mask;
+	u32 ipval, ipmsk;
+	int err;
+
+	flow_rule_match_arp(st->frule, &mt);
+
+	if (mt.mask->op) {
+		mask = 0x3;
+		if (st->l3_proto == ETH_P_ARP) {
+			value = mt.key->op == VCAP_ARP_OP_REQUEST ?
+					VCAP_IS2_ARP_REQUEST :
+					VCAP_IS2_ARP_REPLY;
+		} else { /* RARP */
+			value = mt.key->op == VCAP_ARP_OP_REQUEST ?
+					VCAP_IS2_RARP_REQUEST :
+					VCAP_IS2_RARP_REPLY;
+		}
+		err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_ARP_OPCODE,
+					    value, mask);
+		if (err)
+			goto out;
+	}
+
+	/* The IS2 ARP keyset does not support ARP hardware addresses */
+	if (!is_zero_ether_addr(mt.mask->sha) ||
+	    !is_zero_ether_addr(mt.mask->tha)) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (mt.mask->sip) {
+		ipval = be32_to_cpu((__force __be32)mt.key->sip);
+		ipmsk = be32_to_cpu((__force __be32)mt.mask->sip);
+
+		err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_L3_IP4_SIP,
+					    ipval, ipmsk);
+		if (err)
+			goto out;
+	}
+
+	if (mt.mask->tip) {
+		ipval = be32_to_cpu((__force __be32)mt.key->tip);
+		ipmsk = be32_to_cpu((__force __be32)mt.mask->tip);
+
+		err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_L3_IP4_DIP,
+					    ipval, ipmsk);
+		if (err)
+			goto out;
+	}
+
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_ARP);
+
+	return 0;
+
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "arp parse error");
+	return err;
+}
+EXPORT_SYMBOL_GPL(vcap_tc_flower_handler_arp_usage);
+
+int vcap_tc_flower_handler_ip_usage(struct vcap_tc_flower_parse_usage *st)
+{
+	struct flow_match_ip mt;
+	int err = 0;
+
+	flow_rule_match_ip(st->frule, &mt);
+
+	if (mt.mask->tos) {
+		err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_L3_TOS,
+					    mt.key->tos,
+					    mt.mask->tos);
+		if (err)
+			goto out;
+	}
+
+	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_IP);
+
+	return err;
+
+out:
+	NL_SET_ERR_MSG_MOD(st->fco->common.extack, "ip_tos parse error");
+	return err;
+}
+EXPORT_SYMBOL_GPL(vcap_tc_flower_handler_ip_usage);
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_tc.h b/drivers/net/ethernet/microchip/vcap/vcap_tc.h
new file mode 100644
index 0000000000000..5c55ccbee175c
--- /dev/null
+++ b/drivers/net/ethernet/microchip/vcap/vcap_tc.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: BSD-3-Clause */
+/* Copyright (C) 2023 Microchip Technology Inc. and its subsidiaries.
+ * Microchip VCAP TC
+ */
+
+#ifndef __VCAP_TC__
+#define __VCAP_TC__
+
+struct vcap_tc_flower_parse_usage {
+	struct flow_cls_offload *fco;
+	struct flow_rule *frule;
+	struct vcap_rule *vrule;
+	struct vcap_admin *admin;
+	u16 l3_proto;
+	u8 l4_proto;
+	unsigned int used_keys;
+};
+
+int vcap_tc_flower_handler_ethaddr_usage(struct vcap_tc_flower_parse_usage *st);
+int vcap_tc_flower_handler_ipv4_usage(struct vcap_tc_flower_parse_usage *st);
+int vcap_tc_flower_handler_ipv6_usage(struct vcap_tc_flower_parse_usage *st);
+int vcap_tc_flower_handler_portnum_usage(struct vcap_tc_flower_parse_usage *st);
+int vcap_tc_flower_handler_cvlan_usage(struct vcap_tc_flower_parse_usage *st);
+int vcap_tc_flower_handler_vlan_usage(struct vcap_tc_flower_parse_usage *st,
+				      enum vcap_key_field vid_key,
+				      enum vcap_key_field pcp_key);
+int vcap_tc_flower_handler_tcp_usage(struct vcap_tc_flower_parse_usage *st);
+int vcap_tc_flower_handler_arp_usage(struct vcap_tc_flower_parse_usage *st);
+int vcap_tc_flower_handler_ip_usage(struct vcap_tc_flower_parse_usage *st);
+
+#endif /* __VCAP_TC__ */
-- 
2.38.0

