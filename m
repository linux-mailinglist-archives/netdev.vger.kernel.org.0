Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760072811EE
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 14:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387806AbgJBMDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 08:03:15 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:10595
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726017AbgJBMDP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 08:03:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSSq92ia4qO3ouY3NK+WgCzwZF87VWOsRMsLKA7pqkgYtcob/oAFhoOTs2ed4SW1CISs2Qb+A+PiDDffPe0V5XeEOlgzGwJ/9zE9kqzhTgd50EPGaKXJXgPGMHVNymh0yuDEnsFFmd/3xQ56STktpWkcW0Szd+rzfifZLn/JsPzxdRV09JZ7HNJo80d9CD8DduQByXDF0jwDe5JFoD6U4yiKnQXEIwWImo30ZvxEu0ZO6MwS78hQ681O/A3QN+FrPcNERM2YGZllPnJsu2QxJ8ixfd7FWWAJvhG2rBhrNDJIfDJvCtDsQiLJkmbQDe2rXc59rO59Iio9kX1vYY2F2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5EzjQkLM58Tbgrng8to8zKHONsXDjFVjJfIffjd+So=;
 b=hxASEACe+CEkqyepUOXEg7yCZ3qD3hh8dnmiWCwK2VHvBQQCn/2LE8Plcm35e3SOypCE/97qCV2S+U84e6HVo3C2tuRx2ABJPuZEsNkqYFkqIs/Rxo/Fb5NmUUb+oJKxp0pf69XlGLpbgbr2Flimnf9uubOJXCqmb6gwCZofIuUR7Ml5R78nWiteVbnTYzMLfmdEAxN2t9Aw9h/4CzvlHyoPDkZQZTQrFDu2WGX5RS/Czu9dKUbA8LvZPOdhxxSwXmHUoPRX37p/u5UExNc9219Jz68DNEGuneRALZjpiwQKDS1cQG2j0esV2GOPDZqI/HJofwtOKtvERuG+8bXKKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5EzjQkLM58Tbgrng8to8zKHONsXDjFVjJfIffjd+So=;
 b=q0GLqRbBjPqL7xEmtBQ2/xQ4bkOY+VBO/JE1317c+ytFef0fRFmP/+raYntD4wYjTTsa1BmElRK3oT9vegkYmHGE5vYvwcQ8s4PmhDlULASJxDhsEtKLO8MyBilaZsFC0AOSbttXIcsqdKo2NIDlUc7FofavdmiTeoTziNykoU0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.28; Fri, 2 Oct
 2020 12:03:02 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.038; Fri, 2 Oct 2020
 12:03:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 3/9] net: mscc: ocelot: create TCAM skeleton from tc filter chains
Date:   Fri,  2 Oct 2020 15:02:22 +0300
Message-Id: <20201002120228.3451337-4-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.229.171) by AM3PR07CA0130.eurprd07.prod.outlook.com (2603:10a6:207:8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.14 via Frontend Transport; Fri, 2 Oct 2020 12:03:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fdb6e7df-df7b-4b86-d7b1-08d866cb1cae
X-MS-TrafficTypeDiagnostic: VI1PR04MB4222:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4222BED196321A8411109096E0310@VI1PR04MB4222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /qX6sbhJAG1MGyD2+oEnz1jAmRwfJskZFIutgBhMnAu9+GlfFv/lgbFv8guj5Lg/X0l6HqDIY8cYEL0k6zZIY+yfEIvwuLWtBjVGQBrpj1xWCRxfr9fja9DUeT+RlIJgdaYJ8huQtL+sjbC/3cscnU90cCUlNnShf8bd2N5pUDY/4s7ekQfZcB1VwcAWQOzAAavo7LcrMDf/qBW2z/GcShMbI8jrTw4S+3OyNefczSFOpKuCtbKhaWSnXZIgZ+EvKM4hOyK3CpsyClj/68VlGd8KOFHWdRhYZAyC2hx4lgcxGwUYuHtRLHVvPkE0wz5n27yCyH/wM9O/7pAa5uhdQ2Af9yjaSGYMIx596lq8aecysoaqDWqeKaKUR0j8tT2U1rx7xKGlJ9ExUy7dI7Yvt2NV1ZDcL8lnXKG3k+iLHN9r7NoxBKYjd6eXypLbnXfs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(86362001)(186003)(26005)(2616005)(16526019)(7416002)(52116002)(478600001)(5660300002)(6916009)(2906002)(6506007)(30864003)(6486002)(66946007)(36756003)(69590400008)(66476007)(66556008)(956004)(6512007)(6666004)(44832011)(4326008)(83380400001)(8676002)(8936002)(1076003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: J6ln5xBdAxZDouH8JAsSmAejIRhc4J9KFnfj2ekIlac6+cejQyBH9eumq0+ddrz4YcPPuLZEuswk+ncE0lv90WZEE5hVljADyz7fwoRD2gd/tycdDzsWCt0Xk2RePV74iZp09Iu3e3mLKyXDXYZye2+YG21ZYeSLea4ZHZsqCTXY9YPcAbOiGR/szhsbGvjubCsupin43dtKq77Q3vo8acmtHAGhV9AFKOkUjZPiTtaOibZjyI0+2sZdfWuGHnU0q3Pcus+IGpN2AXVk3kIepBlvAafBEwTwhlB3bZIZj4loieT0Dfym9Vz1Kj2v6jgSv6JK5FYdKxMfocu2KFWZQ3q+TYL758dEUu7BiXWq58h810DHhX6gg4S253gXWW4wfBvzOraGeEh5roefdKoSX+E4Dc5GtSCgmcexmGguDSm35G5jPXp/CRllVIwMMJ6yUGhI+s+6uR5dFlli7WNUY7iDLKIOWtNPG0bqTZ4qb1rtjhff1naa9451iv1JJX5wSAR54fgSk81yhYEsRtHUYNX/bWa7l5hr02hKAtc6enzVLyDYTpUf8sefb/lYeDnTs2eQf/Yx0lsaz0OLk8n8GkIRrxS30JE79tDb2h1PrEEUXb5+4Tt2WN///WY1Q3PtsnUZac0+XECodGPz9L2iJw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdb6e7df-df7b-4b86-d7b1-08d866cb1cae
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 12:03:02.5555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MYGoWHLVkAf6UvSWffYr25sfV4CKAkGHpOM4hgU3Bnv5oKfQv41LVIOtteREIJgda4KLWYsOfwSTOpTrUMsaGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For Ocelot switches, there are 2 ingress pipelines for flow offload
rules: VCAP IS1 (Ingress Classification) and IS2 (Security Enforcement).
IS1 and IS2 support different sets of actions. The pipeline order for a
packet on ingress is:

Basic classification -> VCAP IS1 -> VCAP IS2

Furthermore, IS1 is looked up 3 times, and IS2 is looked up twice (each
TCAM entry can be configured to match only on the first lookup, or only
on the second, or on both etc).

Because the TCAMs are completely independent in hardware, and because of
the fixed pipeline, we actually have very limited options when it comes
to offloading complex rules to them while still maintaining the same
semantics with the software data path.

This patch maps flow offload rules to ingress TCAMs according to a
predefined chain index number. There is going to be a script in
selftests that clarifies the usage model.

There is also an egress TCAM (VCAP ES0, the Egress Rewriter), which is
modeled on top of the default chain 0 of the egress qdisc, because it
doesn't have multiple lookups.

Suggested-by: Allan W. Nielsen <allan.nielsen@microchip.com>
Co-developed-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes since RFC:
None.

 drivers/net/ethernet/mscc/ocelot_flower.c | 260 +++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_vcap.c   |  50 +++--
 drivers/net/ethernet/mscc/ocelot_vcap.h   |  10 +
 include/soc/mscc/ocelot.h                 |   3 +-
 4 files changed, 290 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 00b02b76164e..c0cb89c1967d 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -5,49 +5,239 @@
 
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_gact.h>
-
+#include <soc/mscc/ocelot_vcap.h>
 #include "ocelot_vcap.h"
 
-static int ocelot_flower_parse_action(struct flow_cls_offload *f,
+/* Arbitrarily chosen constants for encoding the VCAP block and lookup number
+ * into the chain number. This is UAPI.
+ */
+#define VCAP_BLOCK			10000
+#define VCAP_LOOKUP			1000
+#define VCAP_IS1_NUM_LOOKUPS		3
+#define VCAP_IS2_NUM_LOOKUPS		2
+#define VCAP_IS2_NUM_PAG		256
+#define VCAP_IS1_CHAIN(lookup)		\
+	(1 * VCAP_BLOCK + (lookup) * VCAP_LOOKUP)
+#define VCAP_IS2_CHAIN(lookup, pag)	\
+	(2 * VCAP_BLOCK + (lookup) * VCAP_LOOKUP + (pag))
+
+static int ocelot_chain_to_block(int chain, bool ingress)
+{
+	int lookup, pag;
+
+	if (!ingress) {
+		if (chain == 0)
+			return VCAP_ES0;
+		return -EOPNOTSUPP;
+	}
+
+	/* Backwards compatibility with older, single-chain tc-flower
+	 * offload support in Ocelot
+	 */
+	if (chain == 0)
+		return VCAP_IS2;
+
+	for (lookup = 0; lookup < VCAP_IS1_NUM_LOOKUPS; lookup++)
+		if (chain == VCAP_IS1_CHAIN(lookup))
+			return VCAP_IS1;
+
+	for (lookup = 0; lookup < VCAP_IS2_NUM_LOOKUPS; lookup++)
+		for (pag = 0; pag < VCAP_IS2_NUM_PAG; pag++)
+			if (chain == VCAP_IS2_CHAIN(lookup, pag))
+				return VCAP_IS2;
+
+	return -EOPNOTSUPP;
+}
+
+/* Caller must ensure this is a valid IS1 or IS2 chain first,
+ * by calling ocelot_chain_to_block.
+ */
+static int ocelot_chain_to_lookup(int chain)
+{
+	return (chain / VCAP_LOOKUP) % 10;
+}
+
+static bool ocelot_is_goto_target_valid(int goto_target, int chain,
+					bool ingress)
+{
+	int pag;
+
+	/* Can't offload GOTO in VCAP ES0 */
+	if (!ingress)
+		return (goto_target < 0);
+
+	/* Non-optional GOTOs */
+	if (chain == 0)
+		/* VCAP IS1 can be skipped, either partially or completely */
+		return (goto_target == VCAP_IS1_CHAIN(0) ||
+			goto_target == VCAP_IS1_CHAIN(1) ||
+			goto_target == VCAP_IS1_CHAIN(2) ||
+			goto_target == VCAP_IS2_CHAIN(0, 0) ||
+			goto_target == VCAP_IS2_CHAIN(1, 0));
+
+	if (chain == VCAP_IS1_CHAIN(0))
+		return (goto_target == VCAP_IS1_CHAIN(1));
+
+	if (chain == VCAP_IS1_CHAIN(1))
+		return (goto_target == VCAP_IS1_CHAIN(2));
+
+	/* Lookup 2 of VCAP IS1 can really support non-optional GOTOs,
+	 * using a Policy Association Group (PAG) value, which is an 8-bit
+	 * value encoding a VCAP IS2 target chain.
+	 */
+	if (chain == VCAP_IS1_CHAIN(2)) {
+		for (pag = 0; pag < VCAP_IS2_NUM_PAG; pag++)
+			if (goto_target == VCAP_IS2_CHAIN(0, pag))
+				return true;
+
+		return false;
+	}
+
+	/* Non-optional GOTO from VCAP IS2 lookup 0 to lookup 1.
+	 * We cannot change the PAG at this point.
+	 */
+	for (pag = 0; pag < VCAP_IS2_NUM_PAG; pag++)
+		if (chain == VCAP_IS2_CHAIN(0, pag))
+			return (goto_target == VCAP_IS2_CHAIN(1, pag));
+
+	/* VCAP IS2 lookup 1 cannot jump anywhere */
+	return false;
+}
+
+static struct ocelot_vcap_filter *
+ocelot_find_vcap_filter_that_points_at(struct ocelot *ocelot, int chain)
+{
+	struct ocelot_vcap_filter *filter;
+	struct ocelot_vcap_block *block;
+	int block_id;
+
+	block_id = ocelot_chain_to_block(chain, true);
+	if (block_id < 0)
+		return NULL;
+
+	if (block_id == VCAP_IS2) {
+		block = &ocelot->block[VCAP_IS1];
+
+		list_for_each_entry(filter, &block->rules, list)
+			if (filter->type == OCELOT_VCAP_FILTER_PAG &&
+			    filter->goto_target == chain)
+				return filter;
+	}
+
+	list_for_each_entry(filter, &ocelot->dummy_rules, list)
+		if (filter->goto_target == chain)
+			return filter;
+
+	return NULL;
+}
+
+static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
 				      struct ocelot_vcap_filter *filter)
 {
+	struct netlink_ext_ack *extack = f->common.extack;
+	bool allow_missing_goto_target = false;
 	const struct flow_action_entry *a;
+	int i, chain;
 	u64 rate;
-	int i;
 
 	if (!flow_action_basic_hw_stats_check(&f->rule->action,
 					      f->common.extack))
 		return -EOPNOTSUPP;
 
+	chain = f->common.chain_index;
+	filter->block_id = ocelot_chain_to_block(chain, ingress);
+	if (filter->block_id < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload to this chain");
+		return -EOPNOTSUPP;
+	}
+	if (filter->block_id == VCAP_IS1 || filter->block_id == VCAP_IS2)
+		filter->lookup = ocelot_chain_to_lookup(chain);
+
+	filter->goto_target = -1;
+	filter->type = OCELOT_VCAP_FILTER_DUMMY;
+
 	flow_action_for_each(i, a, &f->rule->action) {
 		switch (a->id) {
 		case FLOW_ACTION_DROP:
+			if (filter->block_id != VCAP_IS2) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Drop action can only be offloaded to VCAP IS2");
+				return -EOPNOTSUPP;
+			}
+			if (filter->goto_target != -1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Last action must be GOTO");
+				return -EOPNOTSUPP;
+			}
 			filter->action.mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;
 			filter->action.port_mask = 0;
 			filter->action.police_ena = true;
 			filter->action.pol_ix = OCELOT_POLICER_DISCARD;
+			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
 			break;
 		case FLOW_ACTION_TRAP:
+			if (filter->block_id != VCAP_IS2) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Trap action can only be offloaded to VCAP IS2");
+				return -EOPNOTSUPP;
+			}
+			if (filter->goto_target != -1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Last action must be GOTO");
+				return -EOPNOTSUPP;
+			}
 			filter->action.mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;
 			filter->action.port_mask = 0;
 			filter->action.cpu_copy_ena = true;
 			filter->action.cpu_qu_num = 0;
+			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
 			break;
 		case FLOW_ACTION_POLICE:
+			if (filter->block_id != VCAP_IS2) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Police action can only be offloaded to VCAP IS2");
+				return -EOPNOTSUPP;
+			}
+			if (filter->goto_target != -1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Last action must be GOTO");
+				return -EOPNOTSUPP;
+			}
 			filter->action.police_ena = true;
 			rate = a->police.rate_bytes_ps;
 			filter->action.pol.rate = div_u64(rate, 1000) * 8;
 			filter->action.pol.burst = a->police.burst;
+			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
+			break;
+		case FLOW_ACTION_GOTO:
+			filter->goto_target = a->chain_index;
 			break;
 		default:
+			NL_SET_ERR_MSG_MOD(extack, "Cannot offload action");
 			return -EOPNOTSUPP;
 		}
 	}
 
+	if (filter->goto_target == -1) {
+		if ((filter->block_id == VCAP_IS2 && filter->lookup == 1) ||
+		    chain == 0) {
+			allow_missing_goto_target = true;
+		} else {
+			NL_SET_ERR_MSG_MOD(extack, "Missing GOTO action");
+			return -EOPNOTSUPP;
+		}
+	}
+
+	if (!ocelot_is_goto_target_valid(filter->goto_target, chain, ingress) &&
+	    !allow_missing_goto_target) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload this GOTO target");
+		return -EOPNOTSUPP;
+	}
+
 	return 0;
 }
 
-static int ocelot_flower_parse_key(struct flow_cls_offload *f,
+static int ocelot_flower_parse_key(struct flow_cls_offload *f, bool ingress,
 				   struct ocelot_vcap_filter *filter)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
@@ -185,7 +375,7 @@ static int ocelot_flower_parse_key(struct flow_cls_offload *f,
 	return 0;
 }
 
-static int ocelot_flower_parse(struct flow_cls_offload *f,
+static int ocelot_flower_parse(struct flow_cls_offload *f, bool ingress,
 			       struct ocelot_vcap_filter *filter)
 {
 	int ret;
@@ -193,11 +383,11 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 	filter->prio = f->common.prio;
 	filter->id = f->cookie;
 
-	ret = ocelot_flower_parse_action(f, filter);
+	ret = ocelot_flower_parse_action(f, ingress, filter);
 	if (ret)
 		return ret;
 
-	return ocelot_flower_parse_key(f, filter);
+	return ocelot_flower_parse_key(f, ingress, filter);
 }
 
 static struct ocelot_vcap_filter
@@ -214,22 +404,52 @@ static struct ocelot_vcap_filter
 	return filter;
 }
 
+static int ocelot_vcap_dummy_filter_add(struct ocelot *ocelot,
+					struct ocelot_vcap_filter *filter)
+{
+	list_add(&filter->list, &ocelot->dummy_rules);
+
+	return 0;
+}
+
+static int ocelot_vcap_dummy_filter_del(struct ocelot *ocelot,
+					struct ocelot_vcap_filter *filter)
+{
+	list_del(&filter->list);
+	kfree(filter);
+
+	return 0;
+}
+
 int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 			      struct flow_cls_offload *f, bool ingress)
 {
+	struct netlink_ext_ack *extack = f->common.extack;
 	struct ocelot_vcap_filter *filter;
+	int chain = f->common.chain_index;
 	int ret;
 
+	if (chain && !ocelot_find_vcap_filter_that_points_at(ocelot, chain)) {
+		NL_SET_ERR_MSG_MOD(extack, "No default GOTO action points to this chain");
+		return -EOPNOTSUPP;
+	}
+
 	filter = ocelot_vcap_filter_create(ocelot, port, f);
 	if (!filter)
 		return -ENOMEM;
 
-	ret = ocelot_flower_parse(f, filter);
+	ret = ocelot_flower_parse(f, ingress, filter);
 	if (ret) {
 		kfree(filter);
 		return ret;
 	}
 
+	/* The non-optional GOTOs for the TCAM skeleton don't need
+	 * to be actually offloaded.
+	 */
+	if (filter->type == OCELOT_VCAP_FILTER_DUMMY)
+		return ocelot_vcap_dummy_filter_add(ocelot, filter);
+
 	return ocelot_vcap_filter_add(ocelot, filter, f->common.extack);
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_replace);
@@ -237,13 +457,23 @@ EXPORT_SYMBOL_GPL(ocelot_cls_flower_replace);
 int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
 			      struct flow_cls_offload *f, bool ingress)
 {
-	struct ocelot_vcap_block *block = &ocelot->block;
 	struct ocelot_vcap_filter *filter;
+	struct ocelot_vcap_block *block;
+	int block_id;
+
+	block_id = ocelot_chain_to_block(f->common.chain_index, ingress);
+	if (block_id < 0)
+		return 0;
+
+	block = &ocelot->block[block_id];
 
 	filter = ocelot_vcap_block_find_filter_by_id(block, f->cookie);
 	if (!filter)
 		return 0;
 
+	if (filter->type == OCELOT_VCAP_FILTER_DUMMY)
+		return ocelot_vcap_dummy_filter_del(ocelot, filter);
+
 	return ocelot_vcap_filter_del(ocelot, filter);
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_destroy);
@@ -251,12 +481,18 @@ EXPORT_SYMBOL_GPL(ocelot_cls_flower_destroy);
 int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
 			    struct flow_cls_offload *f, bool ingress)
 {
-	struct ocelot_vcap_block *block = &ocelot->block;
 	struct ocelot_vcap_filter *filter;
-	int ret;
+	struct ocelot_vcap_block *block;
+	int block_id, ret;
+
+	block_id = ocelot_chain_to_block(f->common.chain_index, ingress);
+	if (block_id < 0)
+		return 0;
+
+	block = &ocelot->block[block_id];
 
 	filter = ocelot_vcap_block_find_filter_by_id(block, f->cookie);
-	if (!filter)
+	if (!filter || filter->type == OCELOT_VCAP_FILTER_DUMMY)
 		return 0;
 
 	ret = ocelot_vcap_filter_stats_update(ocelot, filter);
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 1d880045786c..f6b232ab19b1 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -640,10 +640,10 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_WRITE, VCAP_SEL_ALL);
 }
 
-static void
-vcap_entry_get(struct ocelot *ocelot, struct ocelot_vcap_filter *filter, int ix)
+static void vcap_entry_get(struct ocelot *ocelot, int ix,
+			   struct ocelot_vcap_filter *filter)
 {
-	const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS2];
+	const struct vcap_props *vcap = &ocelot->vcap[filter->block_id];
 	struct vcap_data data;
 	int row, count;
 	u32 cnt;
@@ -660,6 +660,13 @@ vcap_entry_get(struct ocelot *ocelot, struct ocelot_vcap_filter *filter, int ix)
 	filter->stats.pkts = cnt;
 }
 
+static void vcap_entry_set(struct ocelot *ocelot, int ix,
+			   struct ocelot_vcap_filter *filter)
+{
+	if (filter->block_id == VCAP_IS2)
+		return is2_entry_set(ocelot, ix, filter);
+}
+
 static int ocelot_vcap_policer_add(struct ocelot *ocelot, u32 pol_ix,
 				   struct ocelot_policer *pol)
 {
@@ -688,7 +695,8 @@ static void ocelot_vcap_policer_del(struct ocelot *ocelot,
 
 	list_for_each_entry(filter, &block->rules, list) {
 		index++;
-		if (filter->action.police_ena &&
+		if (filter->block_id == VCAP_IS2 &&
+		    filter->action.police_ena &&
 		    filter->action.pol_ix < pol_ix) {
 			filter->action.pol_ix += 1;
 			ocelot_vcap_policer_add(ocelot, filter->action.pol_ix,
@@ -710,7 +718,7 @@ static void ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
 	struct ocelot_vcap_filter *tmp;
 	struct list_head *pos, *n;
 
-	if (filter->action.police_ena) {
+	if (filter->block_id == VCAP_IS2 && filter->action.police_ena) {
 		block->pol_lpr--;
 		filter->action.pol_ix = block->pol_lpr;
 		ocelot_vcap_policer_add(ocelot, filter->action.pol_ix,
@@ -848,7 +856,7 @@ static bool
 ocelot_exclusive_mac_etype_filter_rules(struct ocelot *ocelot,
 					struct ocelot_vcap_filter *filter)
 {
-	struct ocelot_vcap_block *block = &ocelot->block;
+	struct ocelot_vcap_block *block = &ocelot->block[filter->block_id];
 	struct ocelot_vcap_filter *tmp;
 	unsigned long port;
 	int i;
@@ -886,7 +894,7 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 			   struct ocelot_vcap_filter *filter,
 			   struct netlink_ext_ack *extack)
 {
-	struct ocelot_vcap_block *block = &ocelot->block;
+	struct ocelot_vcap_block *block = &ocelot->block[filter->block_id];
 	int i, index;
 
 	if (!ocelot_exclusive_mac_etype_filter_rules(ocelot, filter)) {
@@ -908,11 +916,11 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 		struct ocelot_vcap_filter *tmp;
 
 		tmp = ocelot_vcap_block_find_filter_by_index(block, i);
-		is2_entry_set(ocelot, i, tmp);
+		vcap_entry_set(ocelot, i, tmp);
 	}
 
 	/* Now insert the new filter */
-	is2_entry_set(ocelot, index, filter);
+	vcap_entry_set(ocelot, index, filter);
 	return 0;
 }
 
@@ -926,7 +934,8 @@ static void ocelot_vcap_block_remove_filter(struct ocelot *ocelot,
 	list_for_each_safe(pos, q, &block->rules) {
 		tmp = list_entry(pos, struct ocelot_vcap_filter, list);
 		if (tmp->id == filter->id) {
-			if (tmp->action.police_ena)
+			if (tmp->block_id == VCAP_IS2 &&
+			    tmp->action.police_ena)
 				ocelot_vcap_policer_del(ocelot, block,
 							tmp->action.pol_ix);
 
@@ -941,7 +950,7 @@ static void ocelot_vcap_block_remove_filter(struct ocelot *ocelot,
 int ocelot_vcap_filter_del(struct ocelot *ocelot,
 			   struct ocelot_vcap_filter *filter)
 {
-	struct ocelot_vcap_block *block = &ocelot->block;
+	struct ocelot_vcap_block *block = &ocelot->block[filter->block_id];
 	struct ocelot_vcap_filter del_filter;
 	int i, index;
 
@@ -960,11 +969,11 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 		struct ocelot_vcap_filter *tmp;
 
 		tmp = ocelot_vcap_block_find_filter_by_index(block, i);
-		is2_entry_set(ocelot, i, tmp);
+		vcap_entry_set(ocelot, i, tmp);
 	}
 
 	/* Now delete the last filter, because it is duplicated */
-	is2_entry_set(ocelot, block->count, &del_filter);
+	vcap_entry_set(ocelot, block->count, &del_filter);
 
 	return 0;
 }
@@ -972,7 +981,7 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 				    struct ocelot_vcap_filter *filter)
 {
-	struct ocelot_vcap_block *block = &ocelot->block;
+	struct ocelot_vcap_block *block = &ocelot->block[filter->block_id];
 	struct ocelot_vcap_filter tmp;
 	int index;
 
@@ -980,12 +989,12 @@ int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 	if (index < 0)
 		return index;
 
-	vcap_entry_get(ocelot, filter, index);
+	vcap_entry_get(ocelot, index, filter);
 
 	/* After we get the result we need to clear the counters */
 	tmp = *filter;
 	tmp.stats.pkts = 0;
-	is2_entry_set(ocelot, index, &tmp);
+	vcap_entry_set(ocelot, index, &tmp);
 
 	return 0;
 }
@@ -1080,7 +1089,6 @@ static void ocelot_vcap_detect_constants(struct ocelot *ocelot,
 
 int ocelot_vcap_init(struct ocelot *ocelot)
 {
-	struct ocelot_vcap_block *block = &ocelot->block;
 	int i;
 
 	/* Create a policer that will drop the frames for the cpu.
@@ -1099,15 +1107,17 @@ int ocelot_vcap_init(struct ocelot *ocelot)
 			 OCELOT_POLICER_DISCARD);
 
 	for (i = 0; i < OCELOT_NUM_VCAP_BLOCKS; i++) {
+		struct ocelot_vcap_block *block = &ocelot->block[i];
 		struct vcap_props *vcap = &ocelot->vcap[i];
 
+		INIT_LIST_HEAD(&block->rules);
+		block->pol_lpr = OCELOT_POLICER_DISCARD - 1;
+
 		ocelot_vcap_detect_constants(ocelot, vcap);
 		ocelot_vcap_init_one(ocelot, vcap);
 	}
 
-	block->pol_lpr = OCELOT_POLICER_DISCARD - 1;
-
-	INIT_LIST_HEAD(&block->rules);
+	INIT_LIST_HEAD(&ocelot->dummy_rules);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
index 70d4f7131fde..a8e03dbf1083 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.h
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.h
@@ -204,9 +204,19 @@ struct ocelot_vcap_stats {
 	u64 used;
 };
 
+enum ocelot_vcap_filter_type {
+	OCELOT_VCAP_FILTER_DUMMY,
+	OCELOT_VCAP_FILTER_PAG,
+	OCELOT_VCAP_FILTER_OFFLOAD,
+};
+
 struct ocelot_vcap_filter {
 	struct list_head list;
 
+	enum ocelot_vcap_filter_type type;
+	int block_id;
+	int goto_target;
+	int lookup;
 	u16 prio;
 	u32 id;
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 424256fa531b..46608494616f 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -633,7 +633,8 @@ struct ocelot {
 
 	struct list_head		multicast;
 
-	struct ocelot_vcap_block	block;
+	struct list_head		dummy_rules;
+	struct ocelot_vcap_block	block[3];
 	struct vcap_props		*vcap;
 
 	/* Workqueue to check statistics for overflow with its lock */
-- 
2.25.1

