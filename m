Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463342811F1
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 14:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387827AbgJBMDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 08:03:21 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:10595
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726010AbgJBMDU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 08:03:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HVRAoSXjS6RUB2Xy3acjlHIUiHckUSlcPBK3e+semcN2I055leWcghrDVu0vYLArGQiKV0SXqljF5nktakoIR+rkZjmUoB4VUCYqaZsGCWYwwMZCVy4xir3M0SxyN3uY4j5fbSCR6F6J0+gwHsePFdHQpLWL0bT7tQ3noBhPLSFMPnGlIqv51XExET2SrobuIMZeLxatTA+cQQWvRzjlLlwO2NElWKgwnSQuCGRHRnoD+XVWY30TEcG1YJ5M2BJNZrXE4plQ0An04/2MDAjtTBrlU7cv6Ur2Rx2KB6gmwoJM4VwLUUHjQgyjop9acownQg+/TumM1gKmZjJd62EEbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nJioyImGX2B/6g+1Ov9wTKJax4MgjcZC0kVb89IPugw=;
 b=Q/CdE+/n6MLbAoN825Kkwkvm+vKkOcV1QboZnCYYSDlpLOlCK4FQPcNFa7AQPEVM4MjZ5/ttAiKfgy5h7N+C836dHDDDncop0cCu2CphCSIOu7obPd/rZqKI2hE69r8PZuzJsUVx1ZGBrGhpVKra1zRUQP6sg06BTtXlmbmSvoo8C/RKrkvntdqlydfkGlAVG5GgKjZY5CjeCbZyoNQavkP2CCwSAPKy4AKVaQamNx0yNjxMT6GGyHbDlDTk+oyLZ/ZnvEz11/j6rWryumM603qgiuWbXIx+uI0LDpnopoOvhyyTQwAeGjibMsNw/Epfxq8f89tWtbLs/lpdPoDK2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nJioyImGX2B/6g+1Ov9wTKJax4MgjcZC0kVb89IPugw=;
 b=U/4jgXclSJeNMA740pEPs4i5XMEPhu/WVZYt3a54EgOmT2EqkKow18gkal/p7k6WY9g4DEGJJT+vOOlKNGDNDtgzUt2ceiQNlaGjPNHGpJddolHjGqdhvPllM4HdjImkZl4W22jLzH9nVyjsH/KT+YpR9/mWvWSv9bd72g4mBrk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.28; Fri, 2 Oct
 2020 12:03:04 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.038; Fri, 2 Oct 2020
 12:03:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 4/9] net: mscc: ocelot: offload ingress skbedit and vlan actions to VCAP IS1
Date:   Fri,  2 Oct 2020 15:02:23 +0300
Message-Id: <20201002120228.3451337-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201002120228.3451337-1-vladimir.oltean@nxp.com>
References: <20201002120228.3451337-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM3PR07CA0130.eurprd07.prod.outlook.com
 (2603:10a6:207:8::16) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM3PR07CA0130.eurprd07.prod.outlook.com (2603:10a6:207:8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.14 via Frontend Transport; Fri, 2 Oct 2020 12:03:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 71a4f479-cb50-4e88-5fb7-08d866cb1e15
X-MS-TrafficTypeDiagnostic: VI1PR04MB4222:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4222488D3315078F85D391DBE0310@VI1PR04MB4222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3uVsVoK0mBmoLF/8RRLY+3ijACwXprFQh4GhXcNaFggFUZgG0nQo6CDETYpmyGzN/2w7E4QhOGaiWIGoSy9qCNurN07L54b2Zgq2DKvu7hbBHv6A2gXOJ+r+/GavAPawYwCW7FIhChWy9OOUNyOawU+8TflD6AIHh3W3OL09xAS8NasaOuyl3wjjK0PthmXpDJWlRDTerKRLKtOcvk2ZcOxpDrHZQigygrsfC++9jrD2EC9KTE7prgvuS5K6E0CIKLTEXnhmjGGbX61GQYxiVnuh95GjYA3FjffdvQjBL/JG3bOoVDFu7Vr8Ajw9WYYso7RdqG01hAmj8BhBmjRDgmDFWOaoXeCWf306d4NmsZ7wUto2Qx+8ZtpJPT1O/6pxBDZtPGor7wnzDV7L3q7wBhT2+tupMPiSqO5ghgS/d2V2t6VgadmEKCPITn6cIRW8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(86362001)(186003)(26005)(2616005)(16526019)(7416002)(52116002)(478600001)(5660300002)(6916009)(2906002)(6506007)(30864003)(6486002)(66946007)(36756003)(69590400008)(66476007)(66556008)(956004)(6512007)(6666004)(44832011)(4326008)(83380400001)(8676002)(8936002)(1076003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OAe+48N8qi01sVn4+hId2s+XICYZdAScXWT7Yy2OzxPcNt1l1+yAWgqs3ASIy/8IgGyzrzFUlu/cZz0Jq7FjBS0g2geZgzr+uIC5wgd0XjWYwVxlP4l/8BP4v+Y7PACtgCqiS4jKGRlqIUdkdZr8ytnDKFG7oP/FHZPHY1wWUxeO6Y6WxMDs2UCWKMv7Of+HjpozPtepKi01ThXTSuDRiAmQ3MQChpVtdZXNi8WwV8Cb9YtWGV2HwqhGh2Dudl1tZQHCz/5QsK7EzKe+LqAzfY9Y1VjX6OB7+xCRgNYCk9a4Pdrm6MS8JfTzeBvFknNKxKccD0NXzSXIoLndFk3mVin7mYy1c6eBz7Ye7wuX61dB8KPPPKzjV3FjiphvZQ5Baw99szvQbTfrmOiNgezz5KzLaGGTP0kU8RcNqDEYFyBQFeO190dXaYe5UHhWy+ntFdbJzvLUu8nTk62qWdex2bd+tNB77o5yS1LQOWW3sS0YTjj05AQRhtcLC0ZPVrQQReACRfEPrq28eqKneNUOK4F+wtmY0lEnbDaSOhFh1S1G3kmZ8DMiik7uKsVXIUmPQ9u+zfZpTTZERut+9B1jPZ96ntYuxcYgsnc11zP0VBm8HzAk+fsS0FAiblT23SxsI2ub4fJE9/c21NWixMye8w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71a4f479-cb50-4e88-5fb7-08d866cb1e15
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 12:03:04.7843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h2fNYieg6GUS/Sgz2Lh4i1l7AVlqmMerEAeP9Du6+/T16YEcy5igNP1Hx1USi5hUqqMU9n36l6lz4hRQ7L/tbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

VCAP IS1 is a VCAP module which can filter on the most common L2/L3/L4
Ethernet keys, and modify the results of the basic QoS classification
and VLAN classification based on those flow keys.

There are 3 VCAP IS1 lookups, mapped over chains 10000, 11000 and 12000.
Currently the driver is hardcoded to use IS1_ACTION_TYPE_NORMAL half
keys.

Note that the VLAN_MANGLE has been omitted for now. In hardware, the
VCAP_IS1_ACT_VID_REPLACE_ENA field replaces the classified VLAN
(metadata associated with the frame) and not the VLAN from the header
itself. There are currently some issues which need to be addressed when
operating in standalone, or in bridge with vlan_filtering=0 modes,
because in those cases the switch ports have VLAN awareness disabled,
and changing the classified VLAN to anything other than the pvid causes
the packets to be dropped. Another issue is that on egress, we expect
port tagging to push the classified VLAN, but port tagging is disabled
in the modes mentioned above, so although the classified VLAN is
replaced, it is not visible in the packet transmitted by the switch.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes since RFC:
- Modified IPv4 key packing in is1_action_set()
- Removed FLOW_ACTION_VLAN_MANGLE

 drivers/net/dsa/ocelot/felix_vsc9959.c    |   1 +
 drivers/net/ethernet/mscc/ocelot.c        |   3 +
 drivers/net/ethernet/mscc/ocelot_flower.c |  69 +++++++++++
 drivers/net/ethernet/mscc/ocelot_vcap.c   | 136 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vcap.h   |  17 +++
 5 files changed, 226 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index c98ba7c529c5..4fc67ff212de 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -711,6 +711,7 @@ static const struct vcap_field vsc9959_vcap_is1_actions[] = {
 	[VCAP_IS1_ACT_PAG_OVERRIDE_MASK]	= { 13,  8},
 	[VCAP_IS1_ACT_PAG_VAL]			= { 21,  8},
 	[VCAP_IS1_ACT_RSV]			= { 29,  9},
+	/* The fields below are incorrectly shifted by 2 in the manual */
 	[VCAP_IS1_ACT_VID_REPLACE_ENA]		= { 38,  1},
 	[VCAP_IS1_ACT_VID_ADD_VAL]		= { 39, 12},
 	[VCAP_IS1_ACT_FID_SEL]			= { 51,  2},
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 974821b9cdc4..ba47359c26c7 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -108,6 +108,9 @@ static void ocelot_vcap_enable(struct ocelot *ocelot, int port)
 	ocelot_write_gix(ocelot, ANA_PORT_VCAP_S2_CFG_S2_ENA |
 			 ANA_PORT_VCAP_S2_CFG_S2_IP6_CFG(0xa),
 			 ANA_PORT_VCAP_S2_CFG, port);
+
+	ocelot_write_gix(ocelot, ANA_PORT_VCAP_CFG_S1_ENA,
+			 ANA_PORT_VCAP_CFG, port);
 }
 
 static inline u32 ocelot_vlant_read_vlanaccess(struct ocelot *ocelot)
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index c0cb89c1967d..b8a588e65929 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -57,6 +57,17 @@ static int ocelot_chain_to_lookup(int chain)
 	return (chain / VCAP_LOOKUP) % 10;
 }
 
+/* Caller must ensure this is a valid IS2 chain first,
+ * by calling ocelot_chain_to_block.
+ */
+static int ocelot_chain_to_pag(int chain)
+{
+	int lookup = ocelot_chain_to_lookup(chain);
+
+	/* calculate PAG value as chain index relative to the first PAG */
+	return chain - VCAP_IS2_CHAIN(lookup, 0);
+}
+
 static bool ocelot_is_goto_target_valid(int goto_target, int chain,
 					bool ingress)
 {
@@ -209,8 +220,52 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
 			filter->action.pol.burst = a->police.burst;
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
 			break;
+		case FLOW_ACTION_VLAN_POP:
+			if (filter->block_id != VCAP_IS1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "VLAN pop action can only be offloaded to VCAP IS1");
+				return -EOPNOTSUPP;
+			}
+			if (filter->goto_target != -1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Last action must be GOTO");
+				return -EOPNOTSUPP;
+			}
+			filter->action.vlan_pop_cnt_ena = true;
+			filter->action.vlan_pop_cnt++;
+			if (filter->action.vlan_pop_cnt > 2) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Cannot pop more than 2 VLAN headers");
+				return -EOPNOTSUPP;
+			}
+			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
+			break;
+		case FLOW_ACTION_PRIORITY:
+			if (filter->block_id != VCAP_IS1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Priority action can only be offloaded to VCAP IS1");
+				return -EOPNOTSUPP;
+			}
+			if (filter->goto_target != -1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Last action must be GOTO");
+				return -EOPNOTSUPP;
+			}
+			filter->action.qos_ena = true;
+			filter->action.qos_val = a->priority;
+			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
+			break;
 		case FLOW_ACTION_GOTO:
 			filter->goto_target = a->chain_index;
+
+			if (filter->block_id == VCAP_IS1 &&
+			    ocelot_chain_to_lookup(chain) == 2) {
+				int pag = ocelot_chain_to_pag(filter->goto_target);
+
+				filter->action.pag_override_mask = 0xff;
+				filter->action.pag_val = pag;
+				filter->type = OCELOT_VCAP_FILTER_PAG;
+			}
 			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "Cannot offload action");
@@ -242,6 +297,7 @@ static int ocelot_flower_parse_key(struct flow_cls_offload *f, bool ingress,
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
+	struct netlink_ext_ack *extack = f->common.extack;
 	u16 proto = ntohs(f->common.protocol);
 	bool match_protocol = true;
 
@@ -265,6 +321,13 @@ static int ocelot_flower_parse_key(struct flow_cls_offload *f, bool ingress,
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
 		struct flow_match_eth_addrs match;
 
+		if (filter->block_id == VCAP_IS1 &&
+		    !is_zero_ether_addr(match.mask->dst)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Key type S1_NORMAL cannot match on destination MAC");
+			return -EOPNOTSUPP;
+		}
+
 		/* The hw support mac matches only for MAC_ETYPE key,
 		 * therefore if other matches(port, tcp flags, etc) are added
 		 * then just bail out
@@ -318,6 +381,12 @@ static int ocelot_flower_parse_key(struct flow_cls_offload *f, bool ingress,
 		struct flow_match_ipv4_addrs match;
 		u8 *tmp;
 
+		if (filter->block_id == VCAP_IS1 && *(u32 *)&match.mask->dst) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Key type S1_NORMAL cannot match on destination IP");
+			return -EOPNOTSUPP;
+		}
+
 		flow_rule_match_ipv4_addrs(rule, &match);
 		tmp = &filter->key.ipv4.sip.value.addr[0];
 		memcpy(tmp, &match.key->src, 4);
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index f6b232ab19b1..be3293e7c892 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -640,6 +640,140 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_WRITE, VCAP_SEL_ALL);
 }
 
+static void is1_action_set(struct ocelot *ocelot, struct vcap_data *data,
+			   const struct ocelot_vcap_filter *filter)
+{
+	const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS1];
+	const struct ocelot_vcap_action *a = &filter->action;
+
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_VID_REPLACE_ENA,
+			a->vid_replace_ena);
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_VID_ADD_VAL, a->vid);
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_VLAN_POP_CNT_ENA,
+			a->vlan_pop_cnt_ena);
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_VLAN_POP_CNT,
+			a->vlan_pop_cnt);
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_PCP_DEI_ENA, a->pcp_dei_ena);
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_PCP_VAL, a->pcp);
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_DEI_VAL, a->dei);
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_QOS_ENA, a->qos_ena);
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_QOS_VAL, a->qos_val);
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_PAG_OVERRIDE_MASK,
+			a->pag_override_mask);
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_PAG_VAL, a->pag_val);
+}
+
+static void is1_entry_set(struct ocelot *ocelot, int ix,
+			  struct ocelot_vcap_filter *filter)
+{
+	const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS1];
+	struct ocelot_vcap_key_vlan *tag = &filter->vlan;
+	struct ocelot_vcap_u64 payload;
+	struct vcap_data data;
+	int row = ix / 2;
+	u32 type;
+
+	memset(&payload, 0, sizeof(payload));
+	memset(&data, 0, sizeof(data));
+
+	/* Read row */
+	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_READ, VCAP_SEL_ALL);
+	vcap_cache2entry(ocelot, vcap, &data);
+	vcap_cache2action(ocelot, vcap, &data);
+
+	data.tg_sw = VCAP_TG_HALF;
+	data.type = IS1_ACTION_TYPE_NORMAL;
+	vcap_data_offset_get(vcap, &data, ix);
+	data.tg = (data.tg & ~data.tg_mask);
+	if (filter->prio != 0)
+		data.tg |= data.tg_value;
+
+	vcap_key_set(vcap, &data, VCAP_IS1_HK_IGR_PORT_MASK, 0,
+		     ~filter->ingress_port_mask);
+	vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_L2_MC, filter->dmac_mc);
+	vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_L2_BC, filter->dmac_bc);
+	vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_VLAN_TAGGED, tag->tagged);
+	vcap_key_set(vcap, &data, VCAP_IS1_HK_VID,
+		     tag->vid.value, tag->vid.mask);
+	vcap_key_set(vcap, &data, VCAP_IS1_HK_PCP,
+		     tag->pcp.value[0], tag->pcp.mask[0]);
+	type = IS1_TYPE_S1_NORMAL;
+
+	switch (filter->key_type) {
+	case OCELOT_VCAP_KEY_ETYPE: {
+		struct ocelot_vcap_key_etype *etype = &filter->key.etype;
+
+		vcap_key_bytes_set(vcap, &data, VCAP_IS1_HK_L2_SMAC,
+				   etype->smac.value, etype->smac.mask);
+		vcap_key_bytes_set(vcap, &data, VCAP_IS1_HK_ETYPE,
+				   etype->etype.value, etype->etype.mask);
+		break;
+	}
+	case OCELOT_VCAP_KEY_IPV4: {
+		struct ocelot_vcap_key_ipv4 *ipv4 = &filter->key.ipv4;
+		struct ocelot_vcap_udp_tcp *sport = &ipv4->sport;
+		struct ocelot_vcap_udp_tcp *dport = &ipv4->dport;
+		enum ocelot_vcap_bit tcp_udp = OCELOT_VCAP_BIT_0;
+		struct ocelot_vcap_u8 proto = ipv4->proto;
+		struct ocelot_vcap_ipv4 sip = ipv4->sip;
+		u32 val, msk;
+
+		vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_IP_SNAP,
+				 OCELOT_VCAP_BIT_1);
+		vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_IP4,
+				 OCELOT_VCAP_BIT_1);
+		vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_ETYPE_LEN,
+				 OCELOT_VCAP_BIT_1);
+		vcap_key_bytes_set(vcap, &data, VCAP_IS1_HK_L3_IP4_SIP,
+				   sip.value.addr, sip.mask.addr);
+
+		val = proto.value[0];
+		msk = proto.mask[0];
+
+		if ((val == NEXTHDR_TCP || val == NEXTHDR_UDP) && msk == 0xff)
+			tcp_udp = OCELOT_VCAP_BIT_1;
+		vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_TCP_UDP, tcp_udp);
+
+		if (tcp_udp) {
+			enum ocelot_vcap_bit tcp = OCELOT_VCAP_BIT_0;
+
+			if (val == NEXTHDR_TCP)
+				tcp = OCELOT_VCAP_BIT_1;
+
+			vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_TCP, tcp);
+			vcap_key_l4_port_set(vcap, &data, VCAP_IS1_HK_L4_SPORT,
+					     sport);
+			/* Overloaded field */
+			vcap_key_l4_port_set(vcap, &data, VCAP_IS1_HK_ETYPE,
+					     dport);
+		} else {
+			/* IPv4 "other" frame */
+			struct ocelot_vcap_u16 etype = {0};
+
+			/* Overloaded field */
+			etype.value[0] = proto.value[0];
+			etype.mask[0] = proto.mask[0];
+
+			vcap_key_bytes_set(vcap, &data, VCAP_IS1_HK_ETYPE,
+					   etype.value, etype.mask);
+		}
+	}
+	default:
+		break;
+	}
+	vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_TYPE,
+			 type ? OCELOT_VCAP_BIT_1 : OCELOT_VCAP_BIT_0);
+
+	is1_action_set(ocelot, &data, filter);
+	vcap_data_set(data.counter, data.counter_offset,
+		      vcap->counter_width, filter->stats.pkts);
+
+	/* Write row */
+	vcap_entry2cache(ocelot, vcap, &data);
+	vcap_action2cache(ocelot, vcap, &data);
+	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_WRITE, VCAP_SEL_ALL);
+}
+
 static void vcap_entry_get(struct ocelot *ocelot, int ix,
 			   struct ocelot_vcap_filter *filter)
 {
@@ -663,6 +797,8 @@ static void vcap_entry_get(struct ocelot *ocelot, int ix,
 static void vcap_entry_set(struct ocelot *ocelot, int ix,
 			   struct ocelot_vcap_filter *filter)
 {
+	if (filter->block_id == VCAP_IS1)
+		return is1_entry_set(ocelot, ix, filter);
 	if (filter->block_id == VCAP_IS2)
 		return is2_entry_set(ocelot, ix, filter);
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
index a8e03dbf1083..a71bb4447648 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.h
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.h
@@ -160,6 +160,7 @@ struct ocelot_vcap_key_ipv4 {
 struct ocelot_vcap_key_ipv6 {
 	struct ocelot_vcap_u8 proto; /* IPv6 protocol */
 	struct ocelot_vcap_u128 sip; /* IPv6 source (byte 0-7 ignored) */
+	struct ocelot_vcap_u128 dip; /* IPv6 destination (byte 0-7 ignored) */
 	enum ocelot_vcap_bit ttl;  /* TTL zero */
 	struct ocelot_vcap_u8 ds;
 	struct ocelot_vcap_u48 data; /* Not UDP/TCP: IP data */
@@ -185,6 +186,21 @@ enum ocelot_mask_mode {
 
 struct ocelot_vcap_action {
 	union {
+		/* VCAP IS1 */
+		struct {
+			bool vid_replace_ena;
+			u16 vid;
+			bool vlan_pop_cnt_ena;
+			int vlan_pop_cnt;
+			bool pcp_dei_ena;
+			u8 pcp;
+			u8 dei;
+			bool qos_ena;
+			u8 qos_val;
+			u8 pag_override_mask;
+			u8 pag_val;
+		};
+
 		/* VCAP IS2 */
 		struct {
 			bool cpu_copy_ena;
@@ -217,6 +233,7 @@ struct ocelot_vcap_filter {
 	int block_id;
 	int goto_target;
 	int lookup;
+	u8 pag;
 	u16 prio;
 	u32 id;
 
-- 
2.25.1

