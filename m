Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CB53BA3F6
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 20:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbhGBSc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 14:32:29 -0400
Received: from mail-vi1eur05on2124.outbound.protection.outlook.com ([40.107.21.124]:46816
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230225AbhGBScY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 14:32:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOWv5q8Ba3y8knxrZxBIQfTNj9sJj49qMza9eKS87WFP6oKZCyJVH6MnB9KlVHIPs5LWcuE7GQGRG/42sfy5Y10G/3dCs2UESu2WSMIREJJGHKtGDhEIlC6QiooTuljV0hdVu+2OtZcWdFQBHN0PUDxRV5uinAIITTPkEUExBEeHWF2octfg2ZvsFFYmBRcTxDYPdNCURJ08hiaUQchCT24Kc5UnZIn/srVIcu/C9ur0+G1VwlTZzr5Akeiu113eJpCr3ujghpYWHiDD5E/JCYOQvZ3amst4EBi1wnk6MaHT8RuNnL7vtsZY/mW64jaO3RPHOzBG7wEjYBtJjSAWTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vddhFZWo8GTPMKr7Gb4+5GIgWUP3/r0dzf8NPUO8yZ8=;
 b=Ty9ar5LrmdiN3HFCWem01wIFltNebEPbCQUreUsqe32kSMn9JurbDMYPd1OSzciFWAih7M2LPNM0bh5oGAMFxfbokZn4mAxcB7xFnkKYopeHaKbVwabrNJaYKtQkhdBQVU/8R4tEKU/tux1bU0tPmABTwc3IvS6rcnJJ/87K2fkztBh63S8NNiwDlTbaTT0GPfL51bhAFr9YwVWal6C2ZmpYt034WR1UkyA4dEUQRI4QGk13o3NI87OVOMAoE8awkgFwAQS30JkIF2k+MuGSaEdeQfe2z/n8dJ0puwzqVF1Kx1diybQrGCR2MHoOeX0nMtmJL8WduQ4N8C6/loQonA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vddhFZWo8GTPMKr7Gb4+5GIgWUP3/r0dzf8NPUO8yZ8=;
 b=iHinzJt4W7JPGhPcIzXp+LlEk5NeJCvgBOttjktkiszweb8MUvsJQ2x+RsL3On9YWVNwf6QDxdn2QBy4WO7/26CgQ8Cdmvij0U5ySQZFb2PrllwqQWSOtCfiqIktwa+D8Qj9009K6lpXqPbeQzYqPi96SLNoBMe9UhMPQgDq0qQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0394.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.23; Fri, 2 Jul 2021 18:29:48 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::40d:b065:3aa7:ac38]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::40d:b065:3aa7:ac38%5]) with mapi id 15.20.4264.032; Fri, 2 Jul 2021
 18:29:48 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@mellanox.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [RFC net-next 4/4] net: marvell: prestera: Offload FLOW_ACTION_POLICE
Date:   Fri,  2 Jul 2021 21:29:15 +0300
Message-Id: <20210702182915.1035-5-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210702182915.1035-1-vadym.kochan@plvision.eu>
References: <20210702182915.1035-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0108.eurprd04.prod.outlook.com
 (2603:10a6:20b:31e::23) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AS8PR04CA0108.eurprd04.prod.outlook.com (2603:10a6:20b:31e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Fri, 2 Jul 2021 18:29:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f04c8fd-5469-470d-c6c6-08d93d875fab
X-MS-TrafficTypeDiagnostic: HE1P190MB0394:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB03944260EEE86CB41DB3FD70951F9@HE1P190MB0394.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lXbomPMS/XJE6GKy+6mtg219UhGqo1UneG8l9ujY/+KjHC3n7wy5A00OXIUV3TE+yRKdSXvCgkOpCLegHEPr7Zb2EuCRLQxo61x2MGdfzwl5WTxMvrlJH+is5ANq9IBjAK5UjdcYYCrMBWYC4exGjIpTu13oahUT5DMRqnuU6l9NT9Ixvod7gN6rCA3yUkuuSIyCCGGQLE0qTLm9Iv0onmbc4sp1hxpb1mOiREaD+oajsZNIPCATfgI0In38hXBFg5iGSZy+DQNI0o5AAPJM4lwwgBzSZ5ESF900tpR5vqUVL6UA3+gbwKhXjEMkp+B4viqvUd87AiFqml0HdHEV5IpVji5r2+P1Mt75ywDFiIb4TmJE86f7Gu2kprABKxSMXQ0emz+u8W8vpaaN5Kb9hNsjlLmjRsLw42tFi+nveQxTPZCRl1544vh+68BfuBcI1f4UpCmrFOPVwcpIBcpy/5DDxy+VMRObYV3lBQ3BHmiEyMj1kb77RkzbvDqgvWTFOdekYMZmmOQM/McDjcko1LnbgoUArel0wnGfMFS5D874TRaUZY0lNbhr2vafpMyhQ3Rfi+4EV9uf+jQfmjnK0k5AWQRI8F+rmXtY1VEClUjfTuNoX3PUc9nENGCtwXkqcfpZ4iK1Ey+yTC8UuqLC5Tb2uYyptDDfu41L/y3jVIs3l715vBB7OKyXCOCgUplh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(346002)(376002)(136003)(6636002)(7416002)(2906002)(316002)(110136005)(54906003)(44832011)(2616005)(956004)(38350700002)(83380400001)(86362001)(6666004)(36756003)(38100700002)(66476007)(4326008)(1076003)(6506007)(8676002)(8936002)(5660300002)(52116002)(16526019)(66556008)(6486002)(26005)(478600001)(66946007)(6512007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ci0hWjuvv4VEgbb8I4R/IVoXFiRkduUZKgMlA36R36X0klwYy6oEKtt0317i?=
 =?us-ascii?Q?SzznO2Cn3PM83eFx5L4D3YHdYNhtnpZ4duDrqDq+J+v5CSYckxUgGoREZQFu?=
 =?us-ascii?Q?FI9mFKO6n8yLw5bHb5tyPlLuYpQqEtE8ONl2+L8+QzFNQFfkTPaEMOp3mimR?=
 =?us-ascii?Q?k1tpIjnZ8nUPQRUOpLLcg1HHxXFITDuSRg3ObNXkKGFGZUrpUbtw7+tI1spQ?=
 =?us-ascii?Q?KTBXjcMpARr0+7eT6GRt3x6NN1FAmDUAd5nwambmvmobUHgLxdhfoa3X9TLw?=
 =?us-ascii?Q?Dnv6MUNmj7R8QY5Fw2iz1DsAfAMmcBRqGi5oCAh+d4TmOp1xcNdrsN/Xa71Y?=
 =?us-ascii?Q?yJDyGrVtBcWvE2HZUPOUbUphDVKpggdLyb2NPyY4Z4OZCSSjN+T0Q9fK6i5G?=
 =?us-ascii?Q?/VFXn/dp6iC1ZUJXgWFdIUF1P8SDR73G3dJDNsQRAe1NoHnK4miwVyex8Wrg?=
 =?us-ascii?Q?zlYPK7U296ALjpZ1go5Dg08bL9cyOzSZBUyWDQFhGl1wpmE3A98aYxHL45qq?=
 =?us-ascii?Q?zRardkl8eA61MWgFePXfiI5y/7V1p7SFARKeWqGolzx2RwmoyHVQXJCg1dOP?=
 =?us-ascii?Q?Bg65NhBR24X6Ivf2u/8ASq326CX3XvHZoUxaS+cEL2RlyJpd1PO2o6hjysCl?=
 =?us-ascii?Q?xAnXElNwfMoA7UAIO8gjYuK6HXrVQXkQ+2L1BNkTGGub83wg0hGxyCa0PXdQ?=
 =?us-ascii?Q?jxRcZxgnv7xbhJVOctlgt+8zV3Q7mMzz6J+yJATKgMuv2F29oOHz9V4lYn04?=
 =?us-ascii?Q?2aynlhWVMAWKDQbiXG/IR2kw/Z32n+pNz6+co5CL0iT9F9AHg5StPEQkT09N?=
 =?us-ascii?Q?IPUvgMQlRHyg4uhX2sSTzWeyjcjP703Z7+oDC2LOFfXLIvCYLIBk5oYJSqya?=
 =?us-ascii?Q?Zg6i32l0sQ3UB9+IcY9V0Q5BpWbYGAihZr0Dtrwl5JJs4RguuJFKbO/2jBBo?=
 =?us-ascii?Q?DYqDO6FzKZSYhS20WGUAPydijWTa8Ddeak0HEILVaqy2kBuRsbBrOO/wdbuB?=
 =?us-ascii?Q?AUIYvBEGbdEXQqtcXV2WTefXA/7mVrfz7d2PU/63mswMPtP11ThFWukmK/Xy?=
 =?us-ascii?Q?0IIS3+ucpv2+TFBmKjkwBfCF9agn+8ku7ohXF9bumlAeHH7fshbKmESnWwuM?=
 =?us-ascii?Q?+u1ZU6RZkXxQGvepe6jAfd4SSDtfvovCWV8oWuX//D5KkvivpHRubCpg5/MP?=
 =?us-ascii?Q?Q0qQKkPmPi81X8GFCv8XT9OLqlhtAew0EvFBCXwLU8YL+r6YUZxyrOyvgKNL?=
 =?us-ascii?Q?A7vdIyy96nKo/vH6nJUE652Sodotr7E5efjsnHy/3j0OWh2x4vVNAOSFxEqU?=
 =?us-ascii?Q?IHtCTvNjcQH+azNtvHS05VWg?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f04c8fd-5469-470d-c6c6-08d93d875fab
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2021 18:29:48.6227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cl6dGTPxqThgGKufbd9wLEpv2xLQYwezQ3r997M0F3Z+FH70YysggXBKXgpkNhogTVTgL1g1mju7P1S5DSnSP7/EpZhmRjvn9qZF7+jCfBw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0394
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Serhiy Boiko <serhiy.boiko@plvision.eu>

Offload action police when keyed to a flower classifier.
Only rate and burst is supported for now. The conform-exceed
drop is assumed as a default value.

Policer support requires FW 3.1 version. Still to make a backward
compatibility with ACL of FW 3.0 introduced separate FW msg structs for
ACL calls which have different field layout.

Co-developed-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Co-developed-by: Vadym Kochan <vkochan@marvell.com>
Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 .../ethernet/marvell/prestera/prestera_acl.c  |  14 ++
 .../ethernet/marvell/prestera/prestera_acl.h  |  11 +-
 .../marvell/prestera/prestera_flower.c        |  18 +++
 .../ethernet/marvell/prestera/prestera_hw.c   | 125 +++++++++++++++++-
 .../ethernet/marvell/prestera/prestera_pci.c  |   1 +
 5 files changed, 165 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
index 83c75ffb1a1c..9a473f94fab0 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
@@ -8,6 +8,8 @@
 #include "prestera_acl.h"
 #include "prestera_span.h"
 
+#define PRESTERA_ACL_DEF_HW_TC		3
+
 struct prestera_acl {
 	struct prestera_switch *sw;
 	struct list_head rules;
@@ -29,6 +31,7 @@ struct prestera_acl_rule {
 	u32 priority;
 	u8 n_actions;
 	u8 n_matches;
+	u8 hw_tc;
 	u32 id;
 };
 
@@ -203,6 +206,7 @@ prestera_acl_rule_create(struct prestera_flow_block *block,
 	INIT_LIST_HEAD(&rule->action_list);
 	rule->cookie = cookie;
 	rule->block = block;
+	rule->hw_tc = PRESTERA_ACL_DEF_HW_TC;
 
 	return rule;
 }
@@ -251,6 +255,16 @@ void prestera_acl_rule_priority_set(struct prestera_acl_rule *rule,
 	rule->priority = priority;
 }
 
+u8 prestera_acl_rule_hw_tc_get(struct prestera_acl_rule *rule)
+{
+	return rule->hw_tc;
+}
+
+void prestera_acl_rule_hw_tc_set(struct prestera_acl_rule *rule, u8 hw_tc)
+{
+	rule->hw_tc = hw_tc;
+}
+
 int prestera_acl_rule_match_add(struct prestera_acl_rule *rule,
 				struct prestera_acl_rule_match_entry *entry)
 {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.h b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
index 39b7869be659..2a2fbae1432a 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
@@ -25,7 +25,8 @@ enum prestera_acl_rule_match_entry_type {
 enum prestera_acl_rule_action {
 	PRESTERA_ACL_RULE_ACTION_ACCEPT,
 	PRESTERA_ACL_RULE_ACTION_DROP,
-	PRESTERA_ACL_RULE_ACTION_TRAP
+	PRESTERA_ACL_RULE_ACTION_TRAP,
+	PRESTERA_ACL_RULE_ACTION_POLICE,
 };
 
 struct prestera_switch;
@@ -50,6 +51,12 @@ struct prestera_flow_block {
 struct prestera_acl_rule_action_entry {
 	struct list_head list;
 	enum prestera_acl_rule_action id;
+	union {
+		struct {
+			u64 rate;
+			u64 burst;
+		} police;
+	};
 };
 
 struct prestera_acl_rule_match_entry {
@@ -120,5 +127,7 @@ void prestera_acl_rule_del(struct prestera_switch *sw,
 int prestera_acl_rule_get_stats(struct prestera_switch *sw,
 				struct prestera_acl_rule *rule,
 				u64 *packets, u64 *bytes, u64 *last_use);
+u8 prestera_acl_rule_hw_tc_get(struct prestera_acl_rule *rule);
+void prestera_acl_rule_hw_tc_set(struct prestera_acl_rule *rule, u8 hw_tc);
 
 #endif /* _PRESTERA_ACL_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
index e571ba09ec08..76f30856ac98 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -5,6 +5,8 @@
 #include "prestera_acl.h"
 #include "prestera_flower.h"
 
+#define PRESTERA_HW_TC_NUM	8
+
 static int prestera_flower_parse_actions(struct prestera_flow_block *block,
 					 struct prestera_acl_rule *rule,
 					 struct flow_action *flow_action,
@@ -30,6 +32,11 @@ static int prestera_flower_parse_actions(struct prestera_flow_block *block,
 		case FLOW_ACTION_TRAP:
 			a_entry.id = PRESTERA_ACL_RULE_ACTION_TRAP;
 			break;
+		case FLOW_ACTION_POLICE:
+			a_entry.id = PRESTERA_ACL_RULE_ACTION_POLICE;
+			a_entry.police.rate = act->police.rate_bytes_ps;
+			a_entry.police.burst = act->police.burst;
+			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
 			pr_err("Unsupported action\n");
@@ -110,6 +117,17 @@ static int prestera_flower_parse(struct prestera_flow_block *block,
 		return -EOPNOTSUPP;
 	}
 
+	if (f->classid) {
+		int hw_tc = __tc_classid_to_hwtc(PRESTERA_HW_TC_NUM, f->classid);
+
+		if (hw_tc < 0) {
+			NL_SET_ERR_MSG_MOD(f->common.extack, "Unsupported HW TC");
+			return hw_tc;
+		}
+
+		prestera_acl_rule_hw_tc_set(rule, hw_tc);
+	}
+
 	prestera_acl_rule_priority_set(rule, f->common.prio);
 
 	if (flow_rule_match_key(f_rule, FLOW_DISSECTOR_KEY_META)) {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index c1297859e471..2d1dfb52aca4 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -91,6 +91,7 @@ enum {
 enum {
 	PRESTERA_CMD_SWITCH_ATTR_MAC = 1,
 	PRESTERA_CMD_SWITCH_ATTR_AGEING = 2,
+	PRESTERA_SWITCH_ATTR_TRAP_POLICER = 3,
 };
 
 enum {
@@ -319,6 +320,19 @@ struct prestera_msg_acl_action {
 	u32 id;
 };
 
+struct prestera_msg_acl_action_ext {
+	u32 id;
+	union {
+		struct {
+			u64 rate;
+			u64 burst;
+		} police;
+		struct {
+			u64 res[3];
+		} reserv;
+	} __packed;
+};
+
 struct prestera_msg_acl_match {
 	u32 type;
 	union {
@@ -354,6 +368,16 @@ struct prestera_msg_acl_rule_req {
 	u8 n_matches;
 };
 
+struct prestera_msg_acl_rule_ext_req {
+	struct prestera_msg_cmd cmd;
+	u32 id;
+	u32 priority;
+	u16 ruleset_id;
+	u8 n_actions;
+	u8 n_matches;
+	u8 hw_tc;
+};
+
 struct prestera_msg_acl_rule_resp {
 	struct prestera_msg_ret ret;
 	u32 id;
@@ -908,6 +932,36 @@ static int prestera_hw_acl_actions_put(struct prestera_msg_acl_action *action,
 	return 0;
 }
 
+static int prestera_hw_acl_actions_ext_put(struct prestera_msg_acl_action_ext *action,
+					   struct prestera_acl_rule *rule)
+{
+	struct list_head *a_list = prestera_acl_rule_action_list_get(rule);
+	struct prestera_acl_rule_action_entry *a_entry;
+	int i = 0;
+
+	list_for_each_entry(a_entry, a_list, list) {
+		action[i].id = a_entry->id;
+
+		switch (a_entry->id) {
+		case PRESTERA_ACL_RULE_ACTION_ACCEPT:
+		case PRESTERA_ACL_RULE_ACTION_DROP:
+		case PRESTERA_ACL_RULE_ACTION_TRAP:
+			/* just rule action id, no specific data */
+			break;
+		case PRESTERA_ACL_RULE_ACTION_POLICE:
+			action[i].police.rate = a_entry->police.rate;
+			action[i].police.burst = a_entry->police.burst;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		i++;
+	}
+
+	return 0;
+}
+
 static int prestera_hw_acl_matches_put(struct prestera_msg_acl_match *match,
 				       struct prestera_acl_rule *rule)
 {
@@ -963,9 +1017,9 @@ static int prestera_hw_acl_matches_put(struct prestera_msg_acl_match *match,
 	return 0;
 }
 
-int prestera_hw_acl_rule_add(struct prestera_switch *sw,
-			     struct prestera_acl_rule *rule,
-			     u32 *rule_id)
+int __prestera_hw_acl_rule_add(struct prestera_switch *sw,
+			       struct prestera_acl_rule *rule,
+			       u32 *rule_id)
 {
 	struct prestera_msg_acl_action *actions;
 	struct prestera_msg_acl_match *matches;
@@ -1017,6 +1071,71 @@ int prestera_hw_acl_rule_add(struct prestera_switch *sw,
 	return err;
 }
 
+int __prestera_hw_acl_rule_ext_add(struct prestera_switch *sw,
+				   struct prestera_acl_rule *rule,
+				   u32 *rule_id)
+{
+	struct prestera_msg_acl_action_ext *actions;
+	struct prestera_msg_acl_rule_ext_req *req;
+	struct prestera_msg_acl_match *matches;
+	struct prestera_msg_acl_rule_resp resp;
+	u8 n_actions;
+	u8 n_matches;
+	void *buff;
+	u32 size;
+	int err;
+
+	n_actions = prestera_acl_rule_action_len(rule);
+	n_matches = prestera_acl_rule_match_len(rule);
+
+	size = sizeof(*req) + sizeof(*actions) * n_actions +
+		sizeof(*matches) * n_matches;
+
+	buff = kzalloc(size, GFP_KERNEL);
+	if (!buff)
+		return -ENOMEM;
+
+	req = buff;
+	actions = buff + sizeof(*req);
+	matches = buff + sizeof(*req) + sizeof(*actions) * n_actions;
+
+	/* put acl actions into the message */
+	err = prestera_hw_acl_actions_ext_put(actions, rule);
+	if (err)
+		goto free_buff;
+
+	/* put acl matches into the message */
+	err = prestera_hw_acl_matches_put(matches, rule);
+	if (err)
+		goto free_buff;
+
+	req->ruleset_id = prestera_acl_rule_ruleset_id_get(rule);
+	req->priority = prestera_acl_rule_priority_get(rule);
+	req->n_actions = prestera_acl_rule_action_len(rule);
+	req->n_matches = prestera_acl_rule_match_len(rule);
+	req->hw_tc = prestera_acl_rule_hw_tc_get(rule);
+
+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_ACL_RULE_ADD,
+			       &req->cmd, size, &resp.ret, sizeof(resp));
+	if (err)
+		goto free_buff;
+
+	*rule_id = resp.id;
+free_buff:
+	kfree(buff);
+	return err;
+}
+
+int prestera_hw_acl_rule_add(struct prestera_switch *sw,
+			     struct prestera_acl_rule *rule,
+			     u32 *rule_id)
+{
+	if (sw->dev->fw_rev.maj == 3 && sw->dev->fw_rev.min == 0)
+		return __prestera_hw_acl_rule_add(sw, rule, rule_id);
+
+	return __prestera_hw_acl_rule_ext_add(sw, rule, rule_id);
+};
+
 int prestera_hw_acl_rule_del(struct prestera_switch *sw, u32 rule_id)
 {
 	struct prestera_msg_acl_rule_req req = {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index ce4cf51dba5a..f988603af1b6 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -15,6 +15,7 @@
 #define PRESTERA_MSG_MAX_SIZE 1500
 
 static struct prestera_fw_rev prestera_fw_supp[] = {
+	{ 3, 1 },
 	{ 3, 0 },
 	{ 2, 0 }
 };
-- 
2.17.1

