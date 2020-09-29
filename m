Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB8627C212
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbgI2KLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:11:35 -0400
Received: from mail-eopbgr70085.outbound.protection.outlook.com ([40.107.7.85]:58854
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725776AbgI2KL1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:11:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qf4qPhK6zZ14waSVKV8QN5OaB72+4NqP2lRmBG0wBWDpY5ua/ct0qQiQnERQJr8FL0EgQizNNAZ/zvCrTB9zvhg5ks8B9YgzNGZnJboH1ED6pjdajZdwjHjBv1J5O5bUDhViJwZwA/cZyYgeQIxpDmxQX2GzGqrKb12f/P65yAjwhKcT55ErHsqnhpWlHjOkNOUWUPzwFkkufWy2kkWucG2/siu4neL1cAH0Zdhqv7vC2FsXBDnLvPdKQvxGFw3ilRCXp1myBZsLYgbvzUYRiyG43QVV0o8bd9lmijtk+fuuqTZjI24yItWS9rC3t0la3UKoomo7fHfQZBWFqhtiIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOPGWK3dzsT26vb/gltkfJJpYLsQ0KSX0DWVMJH9dfk=;
 b=RcgFHqLDwm5xXw1TgKosmeCvJJyr4CJNZ329sEf78QXmb0HtQI0SC2FsrIY6JY0bVEsktqNHgpP8FMC9wL/xLQmt6FTq1a/saJQ3DqmeQATSZMZc4ZwbCVosOVLXnQQC6UvMRZbq/xZ5Hk0/i8tIPXdYfdT401z8DIbXz+aLn9y9xWcRdDfFZRXmDzjABmKk/RQRtQjVAvS16jEpGMSyW7RatWY20SQaXcDq+A7NNEXGxZPJaIsT1T8iJ68qwMEP/Yx4LHFnh25KfLtD+k+k/RK8iNZc2qMW7zePTiIKMCPI9sfERCGhp4yqsgBl5fckDUPYZn5EoTkdIK/5MR20cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOPGWK3dzsT26vb/gltkfJJpYLsQ0KSX0DWVMJH9dfk=;
 b=bMz/7AjOPz0Piz1pcpZWF5potALyWWzKCdm1z1LZr1lT6TdwPE8jelTWQ+DBLLaK/p8alvJE7776k+N6Rw8fW1pjkPhiFlZ5FwabyM/JVfDhO82HCDkz/9hiT3BeI9+GArN/4oisbtb35xBkwih//tH/87OMAdjS0b9Iz0BocOw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Tue, 29 Sep
 2020 10:10:42 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 10:10:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 10/21] net: mscc: ocelot: offload multiple tc-flower actions in same rule
Date:   Tue, 29 Sep 2020 13:10:05 +0300
Message-Id: <20200929101016.3743530-11-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.229.171) by VI1PR08CA0112.eurprd08.prod.outlook.com (2603:10a6:800:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 10:10:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5ef8710d-ee36-499c-c169-08d8645fec61
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5295A748D31118FAEA55D405E0320@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DX2SRE25FDE2x+Z+xNeNEPpRXgw9BreDdr1AyYFPN1GXqysy2fyU7LHLTYuGoCW574oxAFrA2Eqg80Fhgcu27MHFfGxrvoqJZ5w2hg+LYyUIbeK6huGCjE/RBLNQVyuCgjTaPqQLErjK4Xb1NWHIOzD7bWufRgKLUhRuzUS1G9BnkV0fq1kmkstkZZ+6sXLwNR5Dn7Q72mwfRRwMkRlX2Qu5Dqw0iONIBsfJa7uiGqinxM944TMpvmy7Jrdr4CAqFLDcZqDJdHyqGXjeYEF9IyQ1pHdVHFZCiG91M+nwy2t/hdUFIuhJlhNEHvEWMDzr0A8vCROEEQlL5JX288p5SqT67Gel2rjpw85QRmkPKwHncsJR8VLLOMqzoB0v1qGkOymz9BAMRKM8gyZaPwTXUiF0gVNqhc3Tv9fCkB3yB+nHnhjyHYNYNvCJ47jS5v6K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(83380400001)(69590400008)(66946007)(4326008)(8936002)(86362001)(36756003)(1076003)(5660300002)(316002)(6666004)(7416002)(52116002)(2616005)(44832011)(956004)(66556008)(8676002)(6486002)(66476007)(6506007)(478600001)(16526019)(6916009)(186003)(26005)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EN/BN2yr4hKy3Ff1FnJ8a6JDpFBaqyC3jCS19+zu03OHtWONfTxBlvtSoikTDjUBko8McoWxvd4hADiEoMPxJ1aPeAPA4Y9Ls35VqTQRyUU1Re0ogDvP1H1IzWvel91b4tW0V22UuET5fV9A9tVGvBHLHgt/89toBDEwwcVyDFJwInHp+5ZMwkjMSYL5RQOmS1VeLCewxQOjhe8LSq0hvaGoDkBDCxXS+DzXtepW7vQVB6ahLi3Rg4FubGLNQygh8kmjVa698Ya+sd0HeyyFkceZ4LpaXvfnBCmBuLwIG4qCVtlTLgh0I6GetHciRxfxMV/0dJMcjSYYqXCIEkx/Mvjj4IG9qSyhFcblsCSwVmPeuSxPEY0tbxuUbjWL//chRD2W3oAilWryWUywnAdG5CTIpaIUUqdSrr6UnKYVEdUJ9ypjlv3Z1y5utQzwkN29HOILEHGkbx/MDGDitC89R2Y02bnqnBHJezJlrLAsFGh+h52eRRcqk1LbWOx9k+W46vTfAk4qiSAYuogGlm5Z32vhdyks7u1pedakyoSoTfbs7ypTaurPuwdcBqSL4HR7YKfgwLfD2IOdU12RSnFqUJ4pWQFb4N6sZWoRHyZFuYfdYs4JB1soKATkKHGUQf144hhDwAFzKEy9EdJ8mSx9Ww==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ef8710d-ee36-499c-c169-08d8645fec61
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 10:10:42.5314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BMj38S+EKWGEoEz0TVQAgHSdtPN/J+1+Tkpn0Ny9rvfvH5Asr8gtDMEnFVmddVsQ9QeqeonRhVAoP8EOtN1Y9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
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
Changes in v2:
Made sure that 'trap' action still drops frame from forwarding path.

 drivers/net/ethernet/mscc/ocelot_flower.c | 19 ++++----
 drivers/net/ethernet/mscc/ocelot_vcap.c   | 57 +++++++----------------
 drivers/net/ethernet/mscc/ocelot_vcap.h   | 30 +++++++++---
 3 files changed, 52 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index ae51ec76b9b1..542c2f3172f6 100644
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

