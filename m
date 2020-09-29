Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4C627C21B
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgI2KL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:11:59 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:54849
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726064AbgI2KLu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:11:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YmX8Skrkch/EsRK9TDkB3aGMqfOx9l1gCWrrgEyf3EKatDtANGru4NaPPmxNfUuR3BgasCvabCW3+qx+J6q5FotEbKFun/ixOi6cSbbj7ORt9syMl1oCdD0nN/nhKlH5J8dPcK5bjIDXIMOL5yyKd686y4ZkcKM1iEB9x1q7Hhnm2epmo7oODbyWDNhM84NNlF9p9CjnLnmBRQ1x3UCT/UCyo6DkBeEKPTSmZjt+XuHoNBqx0pm6oFIR7LZAV6/agzlKfCtz4Ek90iTKiv/hBcW2+b+DKzBnLmMmPNWPmkwLNDU2Y5L1wv7gKlI1yGjPt1QuLU4Bi3vp6TryA6IMyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r/inJetJEwmX5+lJ4ld0RTS4Ok1rmrG/vzUDLs7YubE=;
 b=LK/hTAKqJHl7W+SEEsANDnBt1L5ze2W0whqkLQLV7fgj0ZFAec/jbFPEFW/Q0IqZasXDYsNS0q7XHMWXBwbEN9pXrtY+oIk/rHGOoKfww7h+EcPFcFvRx7euk6sbgA7mkgaMT7GxbSKXaeAc+iUMHY3g5k/2e8k08mvlePPRd/L500YAn3Gsu/+QYmErNBQN6CObDqwWw8N4kf/L9BRQ/hmyRj5FLpaPthv1pCdcMsJDCBnmAwVDBx7WktvpqZPhLY4ifaKp7GfeqzbZN4OBY6C4rfXoUUv2L5n8gFPXal0zyR+8Pn0QHEN+EcD0HNZa4WHUMU6gDlx/XyBpOTzeCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r/inJetJEwmX5+lJ4ld0RTS4Ok1rmrG/vzUDLs7YubE=;
 b=WkRUABqukxsZLrkpD2z8mx7pFJzY0y29ohF/UjPDB7JINnQI1MwWfh57B8/VXk/Yb9UbUU8h6PAoZzbGEvvkmRjq7vkTRmh6YJA36GVaA9geRsa0pxht89aUNnwLRAsfBiUwtEKAhEMzF48UwkdFRGi/NRKtBlRcvqaPHabQnWs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Tue, 29 Sep
 2020 10:10:47 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 10:10:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 16/21] net: mscc: ocelot: offload ingress skbedit and vlan actions to VCAP IS1
Date:   Tue, 29 Sep 2020 13:10:11 +0300
Message-Id: <20200929101016.3743530-17-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
References: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: VI1PR08CA0112.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::14) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by VI1PR08CA0112.eurprd08.prod.outlook.com (2603:10a6:800:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 10:10:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3d238a70-cf92-4444-4f40-08d8645fef68
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB52953D576074EAB22D5EF88FE0320@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yxlvS06C/go950bDzS5PNBffPt94Xjo+BA4/GewejB+4oxhf/bTxyAUliSvHoHkLNCcAxBaAEN6ytZq93QuPr3TA0ksEDYem1M5xhpEEOhU+fPhRo7llCBc81Tt3mzxc5FDb4+IQZ/yLWWIfx0DpJ/kowR3rjH7av99iJByDaTXvsHyH7ZnoGAQmKAwlM7KDcvP1SQOOLmt/N7OG42MP/OplUgZd+fZLDvPJ7ut7nZrkZwq4ORqXqqlMWQ0nDMLcLyeDZrXAOCLAsTWoyNXXhe/2Q3+PVM5Pyin9sMeIlKwIJU4v7XikNln0JsFZmjAbBdMKrr9ryg9HbzXSYlynslgneMXUROaJKOjapLSD1Jdpbb2ZPa6gJPW8wibjjuQMeZBXiAzgflDMAOQiKiObctfKtRcprm1pISRsKrVWdWfsZ24QrdRkFzTaScGp8fIi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(30864003)(83380400001)(69590400008)(66946007)(4326008)(8936002)(86362001)(36756003)(1076003)(5660300002)(316002)(6666004)(7416002)(52116002)(2616005)(44832011)(956004)(66556008)(8676002)(6486002)(66476007)(6506007)(478600001)(16526019)(6916009)(186003)(26005)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RwSw9Q7be/3R91jGYw6oDR/I1O2LdrtD2WSVoap9XZvrL9MSwqDyXvEQAyj4IPlEk6lcniwyg1KBvq2RkS2+fiiIrmK+I7rSb8a0n5Wql333fDqA8PW0beMqVAzVoZEjBIxpl5TTQ8ItAYjMUnjfTvpcKkcD3ASsfMkhjFDqcbc8Amfe7TdgHlR6Lo7R56byoFMuEodiLVHVOsGzZ7ydaW8OdA2wqHRy/hYY+H3sefGubYhhw4jVGTFmWKjC3W5854IVFlH4DCJD9gxkG5/TcT5u38nxux5MsGy5A1SLEb3ogwn3kUz6gzvrltXjh4eOBN59FYaXySpfEkoSzpq4jzytxxlOWbPHIT+HXDcPNWf/1d1P7fr62+Ci0skHbWrm9iK0gB5uf+4AL8Ufj4Aq+2eKXQNS8d+OTLV4LXcRsx+3ADHt6Cy+kJKDSFCyweibz1sbd5Yel4gMQIOkoE357CXNdNERCwfY5WClP00TUahCk9cKjPXIbMCsA1ckxY+mP3T9gvHiZQviwAJawDu+MTzqpnQik5AjBcL8EFqoPFjnPUIzPCyiIUV503xtsvv1rDlbzdYGXbGMtzRNEtwl9WpVQ769rA7PMkcPMCU2ZTMmLeTSXpmkrmznuV5u9L9le5Bgk30MOPT6I0STPWfLQw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d238a70-cf92-4444-4f40-08d8645fef68
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 10:10:47.7274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EGo6aoFQfCLPd276QeNwuj+MQj7OmrAiuPXhX92FkJ/QhGh2hFqQjdbqlEnmxZhur1zlmhXJzriBXHwz4hS9NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
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

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Stopped modifying VCAP_S1_CFG for lookup 0, which made no sense.
Checks for the key types that can be offloaded to IS1.

 drivers/net/dsa/ocelot/felix_vsc9959.c    |  1 +
 drivers/net/ethernet/mscc/ocelot.c        |  3 +
 drivers/net/ethernet/mscc/ocelot_flower.c | 86 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vcap.c   | 88 +++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vcap.h   | 17 +++++
 5 files changed, 195 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 01d0e698b77a..c02780710971 100644
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
index 2eba6b5385d1..b9cc4aaaafd7 100644
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
index c0cb89c1967d..45b44444f0a7 100644
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
@@ -209,8 +220,69 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
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
+		case FLOW_ACTION_VLAN_MANGLE:
+			if (filter->block_id != VCAP_IS1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "VLAN modify action can only be offloaded to VCAP IS1");
+				return -EOPNOTSUPP;
+			}
+			if (filter->goto_target != -1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Last action must be GOTO");
+				return -EOPNOTSUPP;
+			}
+			filter->action.vid_replace_ena = true;
+			filter->action.pcp_dei_ena = true;
+			filter->action.vid = a->vlan.vid;
+			filter->action.pcp = a->vlan.prio;
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
@@ -242,6 +314,7 @@ static int ocelot_flower_parse_key(struct flow_cls_offload *f, bool ingress,
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
+	struct netlink_ext_ack *extack = f->common.extack;
 	u16 proto = ntohs(f->common.protocol);
 	bool match_protocol = true;
 
@@ -265,6 +338,13 @@ static int ocelot_flower_parse_key(struct flow_cls_offload *f, bool ingress,
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
@@ -318,6 +398,12 @@ static int ocelot_flower_parse_key(struct flow_cls_offload *f, bool ingress,
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
index 79ac3a5ba986..be9a179364ef 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -623,6 +623,91 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
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
@@ -646,6 +731,8 @@ static void vcap_entry_get(struct ocelot *ocelot, int ix,
 static void vcap_entry_set(struct ocelot *ocelot, int ix,
 			   struct ocelot_vcap_filter *filter)
 {
+	if (filter->block_id == VCAP_IS1)
+		return is1_entry_set(ocelot, ix, filter);
 	if (filter->block_id == VCAP_IS2)
 		return is2_entry_set(ocelot, ix, filter);
 }
@@ -1005,6 +1092,7 @@ int ocelot_vcap_init(struct ocelot *ocelot)
 {
 	int i;
 
+	ocelot_vcap_init_one(ocelot, &ocelot->vcap[VCAP_IS1]);
 	ocelot_vcap_init_one(ocelot, &ocelot->vcap[VCAP_IS2]);
 
 	/* Create a policer that will drop the frames for the cpu.
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
index bd876b49f0fa..665b4c3aa200 100644
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

