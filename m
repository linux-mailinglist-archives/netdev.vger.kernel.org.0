Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CFA2786E6
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 14:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgIYMTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 08:19:32 -0400
Received: from mail-eopbgr10061.outbound.protection.outlook.com ([40.107.1.61]:2854
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728148AbgIYMTa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 08:19:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D59EIv/1F3ZgE7UMXuyCxwi0+5GBQTJ8uUxbvvXAyL8l8TlI4WGorxhTm0MFvm/sU5+/U1kbEekrWWLBekvqLNRJCYVi1YUwP09egK2Q6E1TB9nsa6VMnLJQ79+cU5LGHLUECLdXqKmkBa2J1xOL9eLqHf9/50VW8MoP4RfHAza6FGcrRn9GOPNHurso5EKS4b82bwj4CF/3owpAomi7P1Oq7WQ3MUVi+5N8rFXs9JAJ+bibf8l2LvyeKdhGL362l/c2s6hAyLzX3LNHPgqaQYcXuKGUCAQ8l7FzestJf1GELJnRVbqm0BMLFH0uX/NHhNNaTQwkskXAr+1YLG/I4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7wMCBKiRaaf/i4f9Lit9GAfF6rFrq2wNv038qoNaEQ=;
 b=gsE6ZrXfngmnXCSy/Lx3m+wqjIg8PSJGIriYAeHL6l2+EwHpr+a1ZbrpAegkTPiuM7Wu8QtKPCi/P3VwdYVFvx04k1CrDfLDa5tBxAZD7jhMnvCyk2+s0m1ulVwmyKbnLRQ9Celi/zd/DUY1K7ldp3zh3/F+Ryue6O9c05L+Z4HLZ+9nF5mfboxc6tncTuhxdADOfKBdR44wa5U/TmF46ihOY7Kefxgc9ehpIo1KJ3cbYQwF8BLoLIRhe4EF/cnWe45POOUdSsZ9pk4F46W15Yq2fVX4jNKHiFGWPyhvWHvcTVvqoH3fKhxfmwjwoMbi2684MDCWPdxi5WgOZX7qFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7wMCBKiRaaf/i4f9Lit9GAfF6rFrq2wNv038qoNaEQ=;
 b=BBN6XQTOmm1f2rH5cH+yi8z+YxrJHVhM3Z/LScy/554ATEFx77NOiEMeBiSloEM9tz5N0DJKyJuaoDOMCa/uyRs2/44cBbUFcqDI5Rlrks2c2Um2m6FFeGIjAyRKzqewEiZgkXOXkmV28+UdTmmmof27WJIu8UuFv6jwb6EQSpI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5856.eurprd04.prod.outlook.com (2603:10a6:803:eb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Fri, 25 Sep
 2020 12:19:24 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 12:19:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH net-next 03/14] net: mscc: ocelot: offload multiple tc-flower actions in same rule
Date:   Fri, 25 Sep 2020 15:18:44 +0300
Message-Id: <20200925121855.370863-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925121855.370863-1-vladimir.oltean@nxp.com>
References: <20200925121855.370863-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0007.eurprd08.prod.outlook.com
 (2603:10a6:803:104::20) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VE1PR08CA0007.eurprd08.prod.outlook.com (2603:10a6:803:104::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 12:19:23 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 61a63671-fb17-4268-c67d-08d8614d3d28
X-MS-TrafficTypeDiagnostic: VI1PR04MB5856:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB585634D96DBDF5C354A88F19E0360@VI1PR04MB5856.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8vwP/AO/B6owtvZgY/P7b5Gj4fnsUJpiPCYUPybP0ZqDkC4HhE7TAj7QYEZhrM32fgkNfgOFQezxAgrvvXngaXcOiTZTEUSaM+6prR9erh/VypnfhW9wOhRJSNgzjQT1NcCwFY3eNp6K+PwnRUPugxHOTkWj3VJa+mmOtf2jqJrKpA7djgKuoYVZUg+uOff3cvVz77mhBGkNsq60mgPVRPjyCOWpi7+AIzVGz+zmde3sHuYNWuDQGhaDqoojBZXefdZ35Vc7kXYHzIPWbGXbpyfYmU4J6UzgGDyLS+NmsJBx1rZ4+ND2+h/HGZ30IkQzUMQYsLs+U+8pUzpw4Tp9Lhh4EqQm8m0uKhOJ7GpY+lTE+1l5aEzGLIBy13Xc51E/DmBZBY1cs1p25M5bk7zdiM/TftOXsylh4Y8S7uaGP7ni/uARTtDmlDUfbkuB+Ah2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(26005)(16526019)(478600001)(52116002)(186003)(316002)(4326008)(86362001)(6512007)(36756003)(1076003)(2906002)(6916009)(44832011)(66946007)(8936002)(69590400008)(5660300002)(6506007)(66476007)(6666004)(6486002)(7416002)(83380400001)(66556008)(956004)(2616005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: p8/3xEYdku0+RDP0OjA7NfXb5NrkgzRPqNbwTaabaGUNveLAHJDbZanE4b5nO0HucPb23cQnyL6Bxyt+VUzWEmPfO2Kz7DJqzcDBdlAnXbUYpbYRlBu3fqrQPjh7FWq4fQfsp4YX7ySWc2lsBbbaqLaud1sCiCMxb5/SaQLfkDecDLFvYhxgtbKuSN5vpdU+quwAEXqVxqf4xacA528OER8Z/ebL7RhAHaM77NDR/e0KeVYJZySSzhEsbSIJEXuSBR0umuTjypt82YW1V+KmFUGqM6VvAYIFCfs/pKfSVR3onVTKalAs2iE1tZ2/cZtFwcEoYntys5+iqM2OW3QjgMTLLloWyhyU5aWHQyXV9ot4zDoZzc4y+wI7KfsAlTM0RGzFeF144jJnivn6Ur+CqIGCNWKgDJ/wPshpKjytseKN1RMRarrMwJyPWl7vuPqEK6nr91YGdP2vZ59nCZeeKD7cXLk9g6Rq8rk200vv/u9TOI72srpwgnQ8M8ruKJP1U5haHWJijz33mNZyYgqnfBzEoPKmI4LH+7Fubi/yqbItkvTEpJGfHZpgF4gRTOPjmbaQSkx4CJy6XbkjpM1IgH53SgMvryEumeY7OW9cvkDkYGdTLKWXBIbY9ljte+2C8of+2aZuw6JmwTG7p5yPUw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61a63671-fb17-4268-c67d-08d8614d3d28
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 12:19:24.2142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QN/CEaGgqnDP76P+tpxN1+kFiLgZ8thaq0SOaQsPfeE10dakBdOzVEeYOz30daDBIOKZBJ4ltsezV36tKV7Bbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5856
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At this stage, the tc-flower offload of mscc_ocelot can only delegate
rules to the VCAP IS2 security enforcement block. These rules have, in
hardware, separate bits for policing and for overriding the destination
port mask and/or copying to the CPU. So it makes sense that we attempt
to expose some more of that low-level complexity instead of simply
choosing between a single type of action.

Something similar happens with the VCAP IS1 block, where the same action
can contain enable bits for VLAN classification and for QoS
classification at the same time.

So model the action structure after the hardware description, and let
the high-level ocelot_flower.c construct an action vector from multiple
tc actions.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 17 +++----
 drivers/net/ethernet/mscc/ocelot_vcap.c   | 57 +++++++----------------
 drivers/net/ethernet/mscc/ocelot_vcap.h   | 30 +++++++++---
 3 files changed, 50 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index ec1b6e2572ba..ffd66966b0b7 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -15,9 +15,6 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 	u64 rate;
 	int i;
 
-	if (!flow_offload_has_one_action(&f->rule->action))
-		return -EOPNOTSUPP;
-
 	if (!flow_action_basic_hw_stats_check(&f->rule->action,
 					      f->common.extack))
 		return -EOPNOTSUPP;
@@ -25,16 +22,20 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 	flow_action_for_each(i, a, &f->rule->action) {
 		switch (a->id) {
 		case FLOW_ACTION_DROP:
-			filter->action = OCELOT_VCAP_ACTION_DROP;
+			filter->action.mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;
+			filter->action.port_mask = 0;
+			filter->action.police_ena = true;
+			filter->action.pol_ix = OCELOT_POLICER_DISCARD;
 			break;
 		case FLOW_ACTION_TRAP:
-			filter->action = OCELOT_VCAP_ACTION_TRAP;
+			filter->action.cpu_copy_ena = true;
+			filter->action.cpu_qu_num = 0;
 			break;
 		case FLOW_ACTION_POLICE:
-			filter->action = OCELOT_VCAP_ACTION_POLICE;
+			filter->action.police_ena = true;
 			rate = a->police.rate_bytes_ps;
-			filter->pol.rate = div_u64(rate, 1000) * 8;
-			filter->pol.burst = a->police.burst;
+			filter->action.pol.rate = div_u64(rate, 1000) * 8;
+			filter->action.pol.burst = a->police.burst;
 			break;
 		default:
 			return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 1755979e3f36..e9629a20971c 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -10,7 +10,6 @@
 #include "ocelot_police.h"
 #include "ocelot_vcap.h"
 
-#define OCELOT_POLICER_DISCARD 0x17f
 #define ENTRY_WIDTH 32
 
 enum vcap_sel {
@@ -315,35 +314,14 @@ static void is2_action_set(struct ocelot *ocelot, struct vcap_data *data,
 			   struct ocelot_vcap_filter *filter)
 {
 	const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS2];
+	struct ocelot_vcap_action *a = &filter->action;
 
-	switch (filter->action) {
-	case OCELOT_VCAP_ACTION_DROP:
-		vcap_action_set(vcap, data, VCAP_IS2_ACT_PORT_MASK, 0);
-		vcap_action_set(vcap, data, VCAP_IS2_ACT_MASK_MODE, 1);
-		vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_ENA, 1);
-		vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_IDX,
-				OCELOT_POLICER_DISCARD);
-		vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
-		vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_COPY_ENA, 0);
-		break;
-	case OCELOT_VCAP_ACTION_TRAP:
-		vcap_action_set(vcap, data, VCAP_IS2_ACT_PORT_MASK, 0);
-		vcap_action_set(vcap, data, VCAP_IS2_ACT_MASK_MODE, 1);
-		vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_ENA, 0);
-		vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_IDX, 0);
-		vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
-		vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_COPY_ENA, 1);
-		break;
-	case OCELOT_VCAP_ACTION_POLICE:
-		vcap_action_set(vcap, data, VCAP_IS2_ACT_PORT_MASK, 0);
-		vcap_action_set(vcap, data, VCAP_IS2_ACT_MASK_MODE, 0);
-		vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_ENA, 1);
-		vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_IDX,
-				filter->pol_ix);
-		vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
-		vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_COPY_ENA, 0);
-		break;
-	}
+	vcap_action_set(vcap, data, VCAP_IS2_ACT_MASK_MODE, a->mask_mode);
+	vcap_action_set(vcap, data, VCAP_IS2_ACT_PORT_MASK, a->port_mask);
+	vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_ENA, a->police_ena);
+	vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_IDX, a->pol_ix);
+	vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_QU_NUM, a->cpu_qu_num);
+	vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_COPY_ENA, a->cpu_copy_ena);
 }
 
 static void is2_entry_set(struct ocelot *ocelot, int ix,
@@ -693,11 +671,11 @@ static void ocelot_vcap_policer_del(struct ocelot *ocelot,
 
 	list_for_each_entry(filter, &block->rules, list) {
 		index++;
-		if (filter->action == OCELOT_VCAP_ACTION_POLICE &&
-		    filter->pol_ix < pol_ix) {
-			filter->pol_ix += 1;
-			ocelot_vcap_policer_add(ocelot, filter->pol_ix,
-						&filter->pol);
+		if (filter->action.police_ena &&
+		    filter->action.pol_ix < pol_ix) {
+			filter->action.pol_ix += 1;
+			ocelot_vcap_policer_add(ocelot, filter->action.pol_ix,
+						&filter->action.pol);
 			is2_entry_set(ocelot, index, filter);
 		}
 	}
@@ -715,10 +693,11 @@ static void ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
 	struct ocelot_vcap_filter *tmp;
 	struct list_head *pos, *n;
 
-	if (filter->action == OCELOT_VCAP_ACTION_POLICE) {
+	if (filter->action.police_ena) {
 		block->pol_lpr--;
-		filter->pol_ix = block->pol_lpr;
-		ocelot_vcap_policer_add(ocelot, filter->pol_ix, &filter->pol);
+		filter->action.pol_ix = block->pol_lpr;
+		ocelot_vcap_policer_add(ocelot, filter->action.pol_ix,
+					&filter->action.pol);
 	}
 
 	block->count++;
@@ -918,9 +897,9 @@ static void ocelot_vcap_block_remove_filter(struct ocelot *ocelot,
 	list_for_each_safe(pos, q, &block->rules) {
 		tmp = list_entry(pos, struct ocelot_vcap_filter, list);
 		if (tmp->id == filter->id) {
-			if (tmp->action == OCELOT_VCAP_ACTION_POLICE)
+			if (tmp->action.police_ena)
 				ocelot_vcap_policer_del(ocelot, block,
-							tmp->pol_ix);
+							tmp->action.pol_ix);
 
 			list_del(pos);
 			kfree(tmp);
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
index 0dfbfc011b2e..b1e77fd874b4 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.h
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.h
@@ -11,6 +11,8 @@
 #include <net/sch_generic.h>
 #include <net/pkt_cls.h>
 
+#define OCELOT_POLICER_DISCARD 0x17f
+
 struct ocelot_ipv4 {
 	u8 addr[4];
 };
@@ -174,10 +176,26 @@ struct ocelot_vcap_key_ipv6 {
 	enum ocelot_vcap_bit seq_zero;       /* TCP sequence number is zero */
 };
 
-enum ocelot_vcap_action {
-	OCELOT_VCAP_ACTION_DROP,
-	OCELOT_VCAP_ACTION_TRAP,
-	OCELOT_VCAP_ACTION_POLICE,
+enum ocelot_mask_mode {
+	OCELOT_MASK_MODE_NONE,
+	OCELOT_MASK_MODE_PERMIT_DENY,
+	OCELOT_MASK_MODE_POLICY,
+	OCELOT_MASK_MODE_REDIRECT,
+};
+
+struct ocelot_vcap_action {
+	union {
+		/* VCAP IS2 */
+		struct {
+			bool cpu_copy_ena;
+			u8 cpu_qu_num;
+			enum ocelot_mask_mode mask_mode;
+			unsigned long port_mask;
+			bool police_ena;
+			struct ocelot_policer pol;
+			u32 pol_ix;
+		};
+	};
 };
 
 struct ocelot_vcap_stats {
@@ -192,7 +210,7 @@ struct ocelot_vcap_filter {
 	u16 prio;
 	u32 id;
 
-	enum ocelot_vcap_action action;
+	struct ocelot_vcap_action action;
 	struct ocelot_vcap_stats stats;
 	unsigned long ingress_port_mask;
 
@@ -210,8 +228,6 @@ struct ocelot_vcap_filter {
 		struct ocelot_vcap_key_ipv4 ipv4;
 		struct ocelot_vcap_key_ipv6 ipv6;
 	} key;
-	struct ocelot_policer pol;
-	u32 pol_ix;
 };
 
 int ocelot_vcap_filter_add(struct ocelot *ocelot,
-- 
2.25.1

