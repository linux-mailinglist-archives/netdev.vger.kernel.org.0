Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E673DDA59
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbhHBONg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:13:36 -0400
Received: from mail-am6eur05on2124.outbound.protection.outlook.com ([40.107.22.124]:50528
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238262AbhHBOLJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:11:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZhZttsULKVFSJ9i9IHif+VZ41fcbkaYElFhh48LzwuKntptoYhfb/0IGHE0Tt4gYqfCzMU1P9uvyLxJokBA1WB0MEGmbERd9R7swzi7msxdkUZq0T5QNpgxZi3V8WhUhOS9r2HGNl+J6/k6aTRctjSxrAV1I8h0kBaA5MvesVHLQuGEOOxAL1qyafyFtzASdXNg/0PEqIxosjbw5o/b1X5qIe8oN9FuH8YR2F7vYn89Uqok7sJWhTAw0RpXhxdM9FMy0anU2TCMbi99Jzl54yr+y7Rec52MLsBHH3VZsBz7U6/wdDFX0WR+w3f9EDgNTiJfH4EaGZ3kDiNhphjKzuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KV5DRV5V3TTeeEivlfB5FBEJPttplsRUpd3OxrOMTPY=;
 b=iegCLe5rCZQVyJmhzC8wVk7I03sFkG+qP6LyY7dwcnnWzJv9CtM5283l1FRiyQg4g9Xsw6LVrDu/oIsJWPmZjLbIjFoLJZTsqUeQNQPtLnkL0jO7KxyR7H7ohVXSbnn8PiZvIhMyhJRmgnyMSPbyZb731JDj6rq5pLRr54//XeTivoSVGWW0GI3LLq6xcKpPeelazu/OuWRHTh1imQojXlAuF0kxk2/9OUT2/VR0AywxSbZV+xtta64BC355jY/3rtl6d7hmj5CC7/TisfMqJxSm5lqHatSdrX+GOIpNdxteKL+dXZ0KL+yU9D/6biaVQCqorCDpXKCt8ObK2j/HAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KV5DRV5V3TTeeEivlfB5FBEJPttplsRUpd3OxrOMTPY=;
 b=m6E+w8jl69WsGPUIvj6PM9yh4Ii8kff3AY7jxtCvhyI+1Gby7UuC4MLwWHNfzsqZ6p99GC1/KdyBTChA0VbTKn6I5SZGnUitNVydOkn/VhewMNkw3KwwunJAz05MujiiV0dUMlhE8YLiA/syZCNoUx84V6O2kSKQaD704AnZsu0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e4::5)
 by AM5P190MB0306.EURP190.PROD.OUTLOOK.COM (2603:10a6:206:20::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Mon, 2 Aug
 2021 14:09:26 +0000
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::380c:126f:278d:b230]) by AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::380c:126f:278d:b230%9]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 14:09:26 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next v2 4/4] net: marvell: prestera: Offload FLOW_ACTION_POLICE
Date:   Mon,  2 Aug 2021 17:08:49 +0300
Message-Id: <20210802140849.2050-5-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210802140849.2050-1-vadym.kochan@plvision.eu>
References: <20210802140849.2050-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0066.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:8e::43) To AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:2e4::5)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P193CA0066.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:8e::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Mon, 2 Aug 2021 14:09:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc30d9e2-bff5-4e27-d565-08d955bf22c6
X-MS-TrafficTypeDiagnostic: AM5P190MB0306:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM5P190MB0306C074BABB32A3B5B8420895EF9@AM5P190MB0306.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 49scudn3JOTUFo9zMbvi1dcKMb2UBVKuVCox9vf3Tgyo1c1vXCNEQ68b4RsW2v03rUI+WkcOxGO2tPen8VWsHU10rGEFTGDfmti9mxuSGfJY3IBdKY2cRkK6X/DXk2d01q1gnY1qdviW6Gvkf6o/ryYXWyByE3SUSBVx+4/JDR4xJofP/+HIcaE/Ld+qfPumMep4yuWy3dwkXBkJm7I+R7kApGyZX5qC9B7SeLeSOmbUMSSXU0LNlXj40Qu/iTuqv/oycgalWfMyp7WBa1eQbmNGGlMYpYppoN3hf+w5j5ZWRO/PdwaHDvcRmnosrzRyMV+L+XVj/9VT6+GJxt/LH6CsCka+W0/yxS8TMzUh+izH2PjzsyKVmOXt/PSVM8VUjtqMpTuVfxpDzFKh/vyzNGU4w3gNbrmy1nqiF1YpYAVL+QgxmeoA+VeK85jBZTOQ7nQGJElZdq2ZjGV/iDgYOz3xSH92A4e4Yf5dH7bwkyRaDiYyE4fE+hc8iW8V7aQdY4BE3+AxhYrsNC57Y+eLiAUUoAKuysac427XXoUrCqOw4nEL4chShhaoLamF4QeFBiIIil4LD+Zc35l6yAonxajVWFMMQAGhL38OfrLq7xjaT/4OGkkYf2bQeHdQwA4ObyqiiIPr0a5KGVdCTn09b4r2OWJrcX8JAaLfQytDwMr1m/Xcvk4UNf+b6EvqiYPLtztMJG1GtFYDfFR4CPyQqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P190MB1063.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(39830400003)(136003)(4326008)(44832011)(2616005)(478600001)(8936002)(956004)(186003)(6486002)(5660300002)(86362001)(66476007)(8676002)(6636002)(66556008)(52116002)(66946007)(1076003)(2906002)(36756003)(6512007)(6506007)(7416002)(83380400001)(26005)(110136005)(54906003)(38350700002)(316002)(38100700002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L1INxm7P69N1A5mzPx91OP5WOZh6bpKfwvA5ACfbE9Wr8KPLSirsL0D6IQO/?=
 =?us-ascii?Q?LqLMLw6GC7gC9T9sv1Dql4GhjV378kGBT43VOXiwQytlGuIdunPcHwCWeEZd?=
 =?us-ascii?Q?P7Z/paOQHy235drVfmq1ONzKii5unRKqfAIGIsadLIysFRblciGq3ef4MdnB?=
 =?us-ascii?Q?4ZMqn9QuxOkgUaOkN+SB1SJEOiXsZKAvSPZ3Oe1QAZFtmw97GcPZfOeDMgWx?=
 =?us-ascii?Q?B8qhxLm/XzdRN359rtXP2oFIl5B9H2DOMPeH1BcQ0qxy3uiqqz77/ZpE8/3M?=
 =?us-ascii?Q?eHGQnSHOt257IL0Da9H8fpAkcnMcKS42yiUFJ5NVOek0TW7mIsIK5SbRHoG9?=
 =?us-ascii?Q?FdWkCuRLWKyR0vnt3o3xSbReZJe6YGJT3IckOQTFrtcNvF0U15xQZEwH0yGq?=
 =?us-ascii?Q?McS6wuPgsWjGlKwLYLmNY4p+yy/XSOk2i19PdfprojWlPs0DaeSNQhA/4dhm?=
 =?us-ascii?Q?Kr5/aMKpcUw39fqwt5jzibRHJ6wiWheY0ZplkfWmdo4w18sZVDFARllwUlLM?=
 =?us-ascii?Q?AiB3WI2+x/7VOPT+ZDMRDjIQ5g/OUkP8ZpZY8c5xCUOy5s45zLQZXIQOPFzp?=
 =?us-ascii?Q?bGgSwrNFvi0qa875GzDSfye/bJ/g8gE1gwXZZcohf7sNrHcy0bHl5+TsNX8V?=
 =?us-ascii?Q?VwXPXZ64H84aMxSDQeESNh+mL9MwlF9wZA3vyX8AwZHTULGVACwkixtNbyqO?=
 =?us-ascii?Q?4KmhqWgG233WhaD3KigBikcmg/oegP5Ld1EHyxg4qInujGhLv0ALWtSHKR/O?=
 =?us-ascii?Q?CHaEH3c5PMtsSEybs5v5esQJ3KeQ9UNEsnfEJHFvyr5ulnBoE4hFrgykgYJX?=
 =?us-ascii?Q?IJ6xpp0jBDo9iipYgCViNG/il9k6YN1caQJ1ubLCkgM9hrY3muV3jNGsvOJe?=
 =?us-ascii?Q?AttaymxDFlEm/kVtEDQsLdARH7h4XtVAf09i0Mdntw+aI3aTwhmashUbUwvG?=
 =?us-ascii?Q?L4Ss7rceEvp+c6c1ZptnZt237U4Dh6D/JRrZeSFhk3Xh6AT31Lz5P9tUYKGi?=
 =?us-ascii?Q?R6nfubLtUXQn06Z5ODZlGMTOlSkLapvvEvLfws3SPp+oxoZMJIv0byMMKzQ8?=
 =?us-ascii?Q?int/h3L9JUmAxS6cnD/v8FOKYVzCUfeFQBoNxJV5OLRruTafhoWSNSeBqxxo?=
 =?us-ascii?Q?4HVwx/Wd6TcT13qIsYuk4oHW5hSpUBNw7anFWAPkVxW1ERbiuBNARgtu7JS0?=
 =?us-ascii?Q?ieGt7IDOlQCwpriXOX6ebb4SBqm/7tu4LiqkXRI+GgEsD9TQToJnHNp/DUJn?=
 =?us-ascii?Q?HRjPWk/M02h1ow9sEFqxXEcj4WibVNR6Lq/nV1DmFxwX6mmHqTchEMQ++1CC?=
 =?us-ascii?Q?Qhmg7ztoBXQIN35kKTIlw8+8?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: bc30d9e2-bff5-4e27-d565-08d955bf22c6
X-MS-Exchange-CrossTenant-AuthSource: AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 14:09:26.1729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EugPfl0VT0G0jx1fex0peMbElppOIEV2ivrLpl3jytV1sJoHccJ/fzFzosLkX35ayRZpckT2/usoERKjIC+u6gbJyL3ZIj+owQkcEgKDnIs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5P190MB0306
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
v2:
    1) Added missing "static" in prestera_hw.c:

        - __prestera_hw_acl_rule_ext_add

        - __prestera_hw_acl_rule_add

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
index c1297859e471..918cdfbfed37 100644
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
+static int __prestera_hw_acl_rule_add(struct prestera_switch *sw,
+				      struct prestera_acl_rule *rule,
+				      u32 *rule_id)
 {
 	struct prestera_msg_acl_action *actions;
 	struct prestera_msg_acl_match *matches;
@@ -1017,6 +1071,71 @@ int prestera_hw_acl_rule_add(struct prestera_switch *sw,
 	return err;
 }
 
+static int __prestera_hw_acl_rule_ext_add(struct prestera_switch *sw,
+					  struct prestera_acl_rule *rule,
+					  u32 *rule_id)
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

