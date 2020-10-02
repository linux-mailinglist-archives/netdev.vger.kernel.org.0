Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B562811EC
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 14:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387767AbgJBMDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 08:03:07 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:10595
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726017AbgJBMDG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 08:03:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PihDuOs5ir3ZIzXmUgovyowhoVWYdqfcGCt8kdS99nzlNuhKDCt/H/McqziWBl4mocX764/LiAMpE0y8yLm/1pjX8KDlo40sMaVmPWokWGaol506y4IAaM3SBHGgn0NRzxuem6vVJg8biI2nh2H3HQls99mqYwlcqUDt3tVy/Jcv8c4dJXFEZsE7R84NJWTkohvQvtWLrzcmecCtUDYgHrDKTPj179iZkp6cJ4jv0uO+8y3ByPtEfZkR5M3bFS4khHZlr2y3p211hReH2/J1L7tNOJXUjXpZJax7tRRlpMbaax5ZF/ICcTkqbr/hxQoLwyEps+0T1uTfkVPldU11nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O4KvpjYvJaSGTRCALDvuS4QVCxiQixK1nZZMrC6lo1o=;
 b=efJqGZXaSnsk6479Jw6zimo+asMrKbNFWZrX2E5Efy8ieAlhL0V5fjLBSGSqZC3lIBIJtQ+u2KTElrIWDDulNs25f0EJ5JTRKAuEqQGOUbpAMfzqrNbd69mWs89Qr3P+waIPNleb6DCBxFONJHvS0Su5JlwSXzLwiyBN+ILiLCm9nXsoSLobYZIkYzjzKesPcp8lXrmMalSeU9c6Q8vTBavgZbj8inPz5XXDIs+n3bKqnrbtBltHbFboQo80hRTyP05hr515F5NXClbwOmQgv98F6X0fvBugb5pMQsKLapww7ha4KjLSs2S+jM0XUMrHgZ2LlAva6Vf81rfQQ2A4tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O4KvpjYvJaSGTRCALDvuS4QVCxiQixK1nZZMrC6lo1o=;
 b=gdnrI+SrpDIKjXy7VRjuT3+QoN784fJOoEvGLO4W48UQb+0gNcJX00Rrl0DG9z9iRjCl2415iRfSKvXw3X6cplAzM5w0mnWdPk0FP4osOofSWxFj/OKLBT0uxEn9aNLXJ9IdDH6c4qjJ++6vR+qzRJaUvUOkdAdtTGzxhyTBx9g=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.28; Fri, 2 Oct
 2020 12:02:57 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.038; Fri, 2 Oct 2020
 12:02:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 1/9] net: mscc: ocelot: offload multiple tc-flower actions in same rule
Date:   Fri,  2 Oct 2020 15:02:20 +0300
Message-Id: <20201002120228.3451337-2-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.229.171) by AM3PR07CA0130.eurprd07.prod.outlook.com (2603:10a6:207:8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.14 via Frontend Transport; Fri, 2 Oct 2020 12:02:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4274822a-0a26-4692-6f6c-08d866cb1937
X-MS-TrafficTypeDiagnostic: VI1PR04MB4222:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB42229144C6E8D02F68F8C90AE0310@VI1PR04MB4222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +dvxWhB9ojJEb8Sa++scfwYDhuNKsc+wFF5bjwjoHiLy/yoeEA3SLpFd2QdrNjQv7FnobcRstM9y61piEjekI7BLgDPVOp8eMlMuuK+bDL2M6MlC8k3ZlY+hJkh6Edg4bOaY/w+pJYmeLiKkr25ozCwWy0KqVimHSeXvSR+9DQiJd5QkRdSixXvwy/YpBt06w+cpBX8wYIEcO0TpubWduy9sCB1nSjizBOU0yyiTmU30hth5WOnjKfPQOpbhZjgJwyi14Ca/MIgkPQc1wvFLP3ECZc9KlM/VypLqPzD44tT2A5yCYtO7Ena1UTJaNPBbrQFv7pLPAWomI+hy9YvjaZHYyMm/tEVkkx1O8UaMEEm4sReJTURHBpqR9sDo9BJm4THW4JcFYPWDMWJvF3xikBSsud4Gfxr0uAD47e28cC48WHNv6nYoSp7Q96PSfUuk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(86362001)(186003)(26005)(2616005)(16526019)(7416002)(52116002)(478600001)(5660300002)(6916009)(2906002)(6506007)(6486002)(66946007)(36756003)(69590400008)(66476007)(66556008)(956004)(6512007)(6666004)(44832011)(4326008)(83380400001)(8676002)(8936002)(1076003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /rXWCgVTf8mDko+ediXMRw7gkCrVjx/Dszh6ObTLfbtHyyJWt4IYECoezMZwNVkUqLDdKIJHYGTGHFyCA9PCuxsWgFU+C/FKIXACPMlwRJUBveMWqQGALj4xuY7HI3OHVKiyBEn62G+2hksU9UazGuo/jJHdXfdIZdtbKqv7ZUZDl+Ym7DNTbKoDQpPr5K09IBbxFGJz5/AmDTI6bPlf/FgYuaX6qtoMYG7hKTg+e9LHKug2a/y3GwyTzaROvRC4Vy0Boqsny23UFr9BGUzDk70dwFN8GM5bZgzklxqo/NP1b3WHwU7xYam4WxnBsboqOGMxT+99J8RhIFyC6QPlEWmNGgKz8JcMqEL/yyssLvxdKK0vzyL9sbDM9L+z/66W4q+fzppp6HRpciK2TpuHouLjlVet1jGuAbss36Htnj9a2mssVhuHpUVkVCzgNgwFAg/ummQz2Fj32pUEbg2LlOAKMW4HYZY1l/Z7OAgbH1H+aY8Kh2evp1z3qvTxFmZVT3lS2qOHjXtZOb/GY7ChVBjoC1n7aH8sR2pVykNNNb1XawJHRJuUPGecrpaqorhDxRgBc9kcJq5jMIYftJ9IZTTp4MmpxsIYsUP5+z9MpGbBd8xA8vPpcnGPRCqYPUlHpttgAMYgRJppCdnbBfDnow==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4274822a-0a26-4692-6f6c-08d866cb1937
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 12:02:56.5829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QLOj4t0vzxLFBlUeA+cqmzt4VHGTB8jHcfwzWqEYqtTonrBZaN4KPlkeU+QyGWRl0BFKuE4SY2F5xsi+XipeyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
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
Changes since RFC:
None.

 drivers/net/ethernet/mscc/ocelot_flower.c | 19 +++++---
 drivers/net/ethernet/mscc/ocelot_vcap.c   | 59 ++++++++---------------
 drivers/net/ethernet/mscc/ocelot_vcap.h   | 30 +++++++++---
 3 files changed, 53 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 0988bc9aaac5..00b02b76164e 100644
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
@@ -25,16 +22,22 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
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
+			filter->action.mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;
+			filter->action.port_mask = 0;
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
index 75eca3457e6e..1d880045786c 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -10,7 +10,6 @@
 #include "ocelot_police.h"
 #include "ocelot_vcap.h"
 
-#define OCELOT_POLICER_DISCARD 0x17f
 #define ENTRY_WIDTH 32
 
 enum vcap_sel {
@@ -332,35 +331,14 @@ static void is2_action_set(struct ocelot *ocelot, struct vcap_data *data,
 			   struct ocelot_vcap_filter *filter)
 {
 	const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS2];
-
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
+	struct ocelot_vcap_action *a = &filter->action;
+
+	vcap_action_set(vcap, data, VCAP_IS2_ACT_MASK_MODE, a->mask_mode);
+	vcap_action_set(vcap, data, VCAP_IS2_ACT_PORT_MASK, a->port_mask);
+	vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_ENA, a->police_ena);
+	vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_IDX, a->pol_ix);
+	vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_QU_NUM, a->cpu_qu_num);
+	vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_COPY_ENA, a->cpu_copy_ena);
 }
 
 static void is2_entry_set(struct ocelot *ocelot, int ix,
@@ -710,11 +688,11 @@ static void ocelot_vcap_policer_del(struct ocelot *ocelot,
 
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
@@ -732,10 +710,11 @@ static void ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
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
@@ -947,9 +926,9 @@ static void ocelot_vcap_block_remove_filter(struct ocelot *ocelot,
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
index 7db6da6e35b9..70d4f7131fde 100644
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

