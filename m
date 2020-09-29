Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47EC927C218
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgI2KLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:11:48 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:54849
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728295AbgI2KLi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:11:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3Ij5DV/85H98bzWyZoP06zoGSyJdWorr/zn6rtYxsaHhY7UD/HW8pkOG5vZ7wmjwLbBeryo0nkKULbhD/bU/tVJIrxki1PNwv30/fLZ36+nbg71bHPUOGz50PoXJS+3zo/zdXzUVk3utl53R+oAOI33yKQyW0qxaNJsp2f7ACgsk6UAZ3krltb3nj6QaA3UWmcNTetFDlMFwj0mh7dxk9BQNQQGxx3fllysFZQmOyY6n0YVZhek0+9T3Jp7AHRDpizQg+3AIPNt/Z8Oh6q1sD4ATjsG6mLHATrAO4K8IOmUUs6gq1EVtvdb51BMKi7rqDjzw5VpTQRr/kLoSd+68w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=01huwDC0AN0PsnYV57lKNut2gS30+uKjrEYqvz092Qg=;
 b=lkw8m2jcXZ6ca9TRqfC0SdN0pJUoaKL4OwOM4AbkeHpBARfkOUr5i3bTs9vEW201e8YcvMhZOdbu+0at9sJuv6WT/FYy06nsasY5M/to0m9TcPlognupkieIax1E4/x3Z5q5fF6vun/z9/qhSzreeAlb/TQDGmyvSGFCpGTToT++h5ba4pJq1NRY0HIQiJu4qhtFhFUNsc/t+GCxRoYBKv24l1qUcDCbsAKGeERzZbYB5mrfMe4ZwRuE6qmcMWCG428zUhUw2IbJH46N4/xMTioVw+IxDWC7AjVlFi3xKoQCdwG9R2YiGPu79LPlPipYj+Bia6RQllSNBlTax6XCGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=01huwDC0AN0PsnYV57lKNut2gS30+uKjrEYqvz092Qg=;
 b=qbpgBB3QXHl72nkNE4AlazsiJ5CtRq3YgMiAQd4e+n1evvLAsj2QAckaS8Vb20vpwZfNky7NYRHRRjMLAhzVoEfGLknIUL5SS3d/krIC7+X5wLINujCUnQN5o2eyXbmnkFzkJhKwXFelJW21jOK5Q3O1yiZ36wewMorsIGCxYsY=
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
Subject: [RFC PATCH v2 net-next 15/21] net: mscc: ocelot: create TCAM skeleton from tc filter chains
Date:   Tue, 29 Sep 2020 13:10:10 +0300
Message-Id: <20200929101016.3743530-16-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6bf144f0-19ef-4199-a605-08d8645feeea
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB52958F7F360F2C065F305312E0320@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lPkhstuf83R/WgnbXQ3esClIm8n2Kk2UmyxCLF09QcZUj55atxhqGrcVne+6Op7LnjSpzqDscNNqnRceU0eMXe8dPi4hMW9REEDfCIQ13NcQufBCeHy5091IE1uExaYLRlm/hYg60cGyW6VPrOWVXhQrPx3nH/Hvs6agU8bjJoqnr19GQW1KI/fYhhvMpHqYsHeypzAutj9g0eb04XAz0AddBdAdioDWmnNFa6GbZIGwQRvE+9SNDoeb6yr3PHycJgT29NBUbYCbNJq5DQ24reAbktAEtzNLVxVV/yf09bbsziwfkUJqG1PpO6O58rLvls7XoeKZ3cmHzCfPmRus3mN8XNoPwJE+zO2aD0ujIZMLBnLXdIkGENBd+dU1AXXZNFqwjjt9pFcSNTSJLDu4FsTtLFDGR1AUMoH4FyQIctFYpq12d9fPqI4T2vUg2aVD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(30864003)(83380400001)(69590400008)(66946007)(4326008)(8936002)(86362001)(36756003)(1076003)(5660300002)(316002)(6666004)(7416002)(52116002)(2616005)(44832011)(956004)(66556008)(8676002)(6486002)(66476007)(6506007)(478600001)(16526019)(6916009)(186003)(26005)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 703ihJxIvmo/JZq0rWTpWO6y0pcQq3dRFcQ0plKh7WPc56fsQahM+IUNnvnCqfR32gMkR9BL8ot0Nw5xPG9iGeMzEXQRIhNHeP1ujLqr7hDWm49174olGEDNVidn/jv+bfsn9gPN4SJ8a9FsKMG17tMY9Zuk4LWffvTTHePhRqqC/10Ktf5pMcGpQUmvzepfap4Ni7oJx7m3+ynG7nohGmDCdfcy3VpKQEzAEqHmFTZUwiHpYo8yvlwyMljRGsHPhk2tx5Z+UBezWN2XmXB6DicJdmkqy2FyzKe28ARnvGQhiuIaIadoY4ufsaAWTsTWXF3JcQ+8fc42RZVjOeu9Unq3YDr+c+dfUdou4Qzt+xMIUCMMxFoCP39aWAU6cLBu7DKJ+n+s1YgCBgph3JRlJGOjJ9OZ1DP4rGjWBGUQuI3M5whIX9RFdFvTW98hOKV9mwkdKAa7VQTL/Hx9DUxbC2glkCfRiPYsdqxv1MWilIwttbsgW32sTtGPGKfAxIysE8j73GTGaMA8pDI6xk6dJEr87cr8xikLDJSmeDvJcmvJgBx0z9Ji01K716Jeioo2hojkTjuBNDKfVtd+YZ59GRw62zl0G1BvPy7w7cij5+/yuwsUgg++IVv2NetA3L82QvThdihIXftwrgVgRVoysg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bf144f0-19ef-4199-a605-08d8645feeea
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 10:10:46.8080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /68fvapC9EC/vSK5GgoE8SaJ+8bW8Ath6wFiVxQiY+0tx2WSwAAsqhBJSv+IvSD5tCjfdoTXtKz3p4ar1w42Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
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
Changes in v2:
Guard checks for "filter->action.police_ena" with "if (filter->block_id
== VCAP_IS2)", since filters may not be offloaded to VCAP IS2.

 drivers/net/ethernet/mscc/ocelot_flower.c | 260 +++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_vcap.c   |  52 +++--
 drivers/net/ethernet/mscc/ocelot_vcap.h   |  10 +
 include/soc/mscc/ocelot.h                 |   3 +-
 include/soc/mscc/ocelot_vcap.h            |   1 +
 5 files changed, 294 insertions(+), 32 deletions(-)

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
index 8bb03aa57811..79ac3a5ba986 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -623,10 +623,10 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
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
@@ -643,6 +643,13 @@ vcap_entry_get(struct ocelot *ocelot, struct ocelot_vcap_filter *filter, int ix)
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
@@ -671,7 +678,8 @@ static void ocelot_vcap_policer_del(struct ocelot *ocelot,
 
 	list_for_each_entry(filter, &block->rules, list) {
 		index++;
-		if (filter->action.police_ena &&
+		if (filter->block_id == VCAP_IS2 &&
+		    filter->action.police_ena &&
 		    filter->action.pol_ix < pol_ix) {
 			filter->action.pol_ix += 1;
 			ocelot_vcap_policer_add(ocelot, filter->action.pol_ix,
@@ -693,7 +701,7 @@ static void ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
 	struct ocelot_vcap_filter *tmp;
 	struct list_head *pos, *n;
 
-	if (filter->action.police_ena) {
+	if (filter->block_id == VCAP_IS2 && filter->action.police_ena) {
 		block->pol_lpr--;
 		filter->action.pol_ix = block->pol_lpr;
 		ocelot_vcap_policer_add(ocelot, filter->action.pol_ix,
@@ -831,7 +839,7 @@ static bool
 ocelot_exclusive_mac_etype_filter_rules(struct ocelot *ocelot,
 					struct ocelot_vcap_filter *filter)
 {
-	struct ocelot_vcap_block *block = &ocelot->block;
+	struct ocelot_vcap_block *block = &ocelot->block[filter->block_id];
 	struct ocelot_vcap_filter *tmp;
 	unsigned long port;
 	int i;
@@ -869,7 +877,7 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 			   struct ocelot_vcap_filter *filter,
 			   struct netlink_ext_ack *extack)
 {
-	struct ocelot_vcap_block *block = &ocelot->block;
+	struct ocelot_vcap_block *block = &ocelot->block[filter->block_id];
 	int i, index;
 
 	if (!ocelot_exclusive_mac_etype_filter_rules(ocelot, filter)) {
@@ -891,11 +899,11 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
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
 
@@ -909,7 +917,8 @@ static void ocelot_vcap_block_remove_filter(struct ocelot *ocelot,
 	list_for_each_safe(pos, q, &block->rules) {
 		tmp = list_entry(pos, struct ocelot_vcap_filter, list);
 		if (tmp->id == filter->id) {
-			if (tmp->action.police_ena)
+			if (tmp->block_id == VCAP_IS2 &&
+			    tmp->action.police_ena)
 				ocelot_vcap_policer_del(ocelot, block,
 							tmp->action.pol_ix);
 
@@ -924,7 +933,7 @@ static void ocelot_vcap_block_remove_filter(struct ocelot *ocelot,
 int ocelot_vcap_filter_del(struct ocelot *ocelot,
 			   struct ocelot_vcap_filter *filter)
 {
-	struct ocelot_vcap_block *block = &ocelot->block;
+	struct ocelot_vcap_block *block = &ocelot->block[filter->block_id];
 	struct ocelot_vcap_filter del_filter;
 	int i, index;
 
@@ -943,11 +952,11 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
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
@@ -955,7 +964,7 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 				    struct ocelot_vcap_filter *filter)
 {
-	struct ocelot_vcap_block *block = &ocelot->block;
+	struct ocelot_vcap_block *block = &ocelot->block[filter->block_id];
 	struct ocelot_vcap_filter tmp;
 	int index;
 
@@ -963,12 +972,12 @@ int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
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
@@ -994,7 +1003,7 @@ static void ocelot_vcap_init_one(struct ocelot *ocelot,
 
 int ocelot_vcap_init(struct ocelot *ocelot)
 {
-	struct ocelot_vcap_block *block = &ocelot->block;
+	int i;
 
 	ocelot_vcap_init_one(ocelot, &ocelot->vcap[VCAP_IS2]);
 
@@ -1013,9 +1022,14 @@ int ocelot_vcap_init(struct ocelot *ocelot)
 	ocelot_write_gix(ocelot, 0x3fffff, ANA_POL_CIR_STATE,
 			 OCELOT_POLICER_DISCARD);
 
-	block->pol_lpr = OCELOT_POLICER_DISCARD - 1;
+	for (i = 0; i < VCAP_COUNT; i++) {
+		struct ocelot_vcap_block *block = &ocelot->block[i];
+
+		INIT_LIST_HEAD(&block->rules);
+		block->pol_lpr = OCELOT_POLICER_DISCARD - 1;
+	}
 
-	INIT_LIST_HEAD(&block->rules);
+	INIT_LIST_HEAD(&ocelot->dummy_rules);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
index 9e301ebb5c4f..bd876b49f0fa 100644
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
index 2c636d361021..4516fb2b96c4 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -634,7 +634,8 @@ struct ocelot {
 
 	struct list_head		multicast;
 
-	struct ocelot_vcap_block	block;
+	struct list_head		dummy_rules;
+	struct ocelot_vcap_block	block[3];
 	struct vcap_props		*vcap;
 
 	/* Workqueue to check statistics for overflow with its lock */
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 9139a9894e90..40556c8a1922 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -17,6 +17,7 @@ enum {
 	VCAP_IS1,
 	VCAP_IS2,
 	VCAP_ES0,
+	VCAP_COUNT,
 };
 
 struct vcap_props {
-- 
2.25.1

