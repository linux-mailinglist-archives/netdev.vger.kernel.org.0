Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C247F43DFBF
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 13:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhJ1LJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 07:09:41 -0400
Received: from mail-bn8nam11on2096.outbound.protection.outlook.com ([40.107.236.96]:56801
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230213AbhJ1LJk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 07:09:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZhCDU0FQLroQS0VPfcTmDt+ato78iu/fnYWbtpzwt2RnbCqYBYJ1GDgwKSeh8XJz0OCZ5cqRkYGaJHS/hh6FTNad1p3KbXyP4W0phUdCv65s4cnHeLrlkU8/1uylIMXT/5Z0ECngP9rh6KVOr+lb84xmtNOJUfUx4bbgMWaoktfrNBEfZjTq+cmdIyroIP43Cy9aEuRCNzzW8k8xTChgXOAcjgRmRDMwGkjYW7vmtolyadNPl4n6P/eSagibsZL3aFLXupxhngg/lhFaaYvqOYuTJX/UsfhRDcfcTrwsCrwi2oOiXtk+/zp1e0ACrWThPRmoB5FHPO38JMAiRG5V7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IAmGYRk+bQ1u7Cy7fkTkxpxX5HUn47plXJDBHKw78rc=;
 b=kjA6huA8SrpJUr4SJ3lCrF5EyQMI3fbDfzyecxm/+ahauw6DiQF2uLaFpPb2nZdJUj5mFoLQ3DIdFdq2+F2f/FgpCQBaOFp78aWJJXGnjO5lXf+c2xVcH9U2tAQprn/2uoh8pymHrmWc5cND3PN1KlUd6JRAQCBRqLPdsDa2ZZmj39c/8inzN6GE3APjYf9/iP4V01mjSrhIzgkFR70PT6kJRX8x1zx1H92bPLBxvIRxuRYtorH5HZCp09zzfZmSrV8YvofZVzca/lbGEiDlPBUQt2oJk9oSwYb73HcMvv+mPnON5GneWqeau/SdZMZutr/uzVKC8ya7UJopkkJyAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IAmGYRk+bQ1u7Cy7fkTkxpxX5HUn47plXJDBHKw78rc=;
 b=KfwVl8+CCmrVSGLDIkgJ1HxfR/FGjgkerA+sVBmH8mqWwoOGiC3m6wadzsiK7vhZpRliJQQo13kw4Npb2Nf5Aen5gm8JdKT/mn5niuUOSBLDfM6SbfD9qjylVku1RRpGLi0a07+Ve8Kprc5mdM1C5vTNk5AcejGHSaVag+ntDxM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4956.namprd13.prod.outlook.com (2603:10b6:510:98::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11; Thu, 28 Oct
 2021 11:07:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4669.005; Thu, 28 Oct 2021
 11:07:13 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [RFC/PATCH net-next v3 4/8] flow_offload: add skip_hw and skip_sw to control if offload the action
Date:   Thu, 28 Oct 2021 13:06:42 +0200
Message-Id: <20211028110646.13791-5-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211028110646.13791-1-simon.horman@corigine.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0040.eurprd03.prod.outlook.com (2603:10a6:208::17)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR03CA0040.eurprd03.prod.outlook.com (2603:10a6:208::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Thu, 28 Oct 2021 11:07:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d075dca-c695-45ef-b33c-08d99a031831
X-MS-TrafficTypeDiagnostic: PH0PR13MB4956:
X-Microsoft-Antispam-PRVS: <PH0PR13MB495683683F4060F41B0FF90FE8869@PH0PR13MB4956.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:619;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D8ldJ94QcowWhjJ3u4uppjININOitKihaAK/HNQ1IAhRytM9oamS7cz7PGckZE5uG+2UAUEcEJ19yicXiBBoV0r6Q1dSQZx5sorRVSGGHIdOVE9+HTcKywJmuA0Lx+efhsQrOkfjYh/I0gbhX+81B2FZOMBPAkA3ayIY2WJQlB0j5Zw5Je/0vsu+/AHv0KRiNkTAabXGK2w/R88o5EZanf1elWczZnFJxY3H0phlqXBN+bA9atfGseGWyQKPfvg8d8rCmqo/T/5AUuNgvbAnw+sJW48jtm2WWA8ctmDRXFTQk81Dl0so6pxZ/0vbgELq9NPIAOZ6h1h2ff9H9NoI8G6Lv0TXVVr6+sCJSLXMimTNKHOf1j2pMJxspDMdZqABnHQP+pVUAidpDPvw/ZRkWERYzEXH/L9k6EHdprfvPEmE8avU1TVBNBU9NmL095l+N0pPnc5UCwNhk7kcKSl+ilfCxbQCepUfnSzWaIyju4NL8nUCaggHpZrhHIfIagMS5JTBTWGp5AftefLBxO8bCtdSQiuyHJfqpHbWb03tDOSuO52xEp7gCRZSghSL0FyuTRQVcEL4o08V+uX0FA+ZEgvkma8ayn04ez1rmrmeGmRAJAUnh1ZVvZhZcOzRt7Tmg/N58k72EqflNk0N3QurhlmOrPBF9dr+oAcYrD68yuX3/+L9qMoZhIH+F9uf+A9n18hMDoEqwDYVGmTBYAO4ig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(39840400004)(396003)(4326008)(83380400001)(316002)(36756003)(54906003)(44832011)(6512007)(8676002)(2616005)(2906002)(5660300002)(8936002)(6666004)(52116002)(186003)(66476007)(107886003)(66556008)(6916009)(508600001)(6486002)(1076003)(66946007)(6506007)(86362001)(38100700002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Up/57fWrQRbVyTtPeMw2GIjdMppRUhIEIjz3/5aRU3DAKfb/o6sVKZyHUJjz?=
 =?us-ascii?Q?WFnFAdyiHvrJIzRiOLPos6ypytk2IS1Kn6pQC2ZWBmmJF01oe/cF9isgadoV?=
 =?us-ascii?Q?SS8crcMjIZ4Qy78PWcAhS6g3wk/6ohTM0qpIpYSDwMoAE4JLIIUBnsW/DpqY?=
 =?us-ascii?Q?+3qQB9rEZ/i9sTvZXJ29zwvRjwuDfnyE5yUfBmKW49NeLh2zunCHbGGdvvMI?=
 =?us-ascii?Q?Tjts7zTg16899wuOSwlr8GmJXoQKXGFbHmhqLyV752HQe8RmLQtnljT8Q5eG?=
 =?us-ascii?Q?MkNCcDxBgBZCgJOqzE42UrRIwD3tVGjzRJNCO3zAKQ/AJXF3RtMDYAUvjLVn?=
 =?us-ascii?Q?4NJZDGpxxWtuWfmDsua9sD0exV6O5PbxJvHACNFABSxLSjG6XrBBodqW6TGG?=
 =?us-ascii?Q?NqZGzgtrRyKfZlXr5dA7d3z3LzW90bJ7Qudh99FbytsYoJkvizMR/bPH03aM?=
 =?us-ascii?Q?P1cRa9DVj+tSn4vdT3r4KAjd7dWG3F/24mP1X0Fqu5KDFmxfytmg81m9dILz?=
 =?us-ascii?Q?dEydbhXbI6CotOTc9w+KHFnO6AgKBexyhgnZ2VIrr82lh0Rarqw7aIRMVBve?=
 =?us-ascii?Q?+9kJo0COGPVfMyppXaXTHhB1Ug3kWVf8gux2zKpiAinScIHOmYPtTeV0lgQe?=
 =?us-ascii?Q?3D5dQ2m+H4XKzm3/RsXhSnIND3r+jhdsiAdQ0cVNVRu7nri+YDAk2TcgRL6V?=
 =?us-ascii?Q?AixKvrKJDJS10ahZrBP3R/JGypG9/H34xuonjeH75ySbQh0IpziOtP5QZCyK?=
 =?us-ascii?Q?O8R10QtcYtf5ay2zR02gZjFAcQs1MDPXeq78wM6583wg0sdrcGhLyUpHF8mO?=
 =?us-ascii?Q?rPtNirqaCEarwHKdQL1RBfFSejEoHnKgCRv+MV0rPUSVUwRBi4rRWMU7XZTX?=
 =?us-ascii?Q?hsb8EgANdIk9e3gB/9SwJKkLHA6x5tJv2ibWW6TRWw1WXw/ctEF5Gie62bXW?=
 =?us-ascii?Q?X6Y31EVKwhOHMTlDCobDJl4XuGP0SyhKj9Q7qoI4xWbN276S7/5Z+9KlyhoG?=
 =?us-ascii?Q?KHuTjNz2CEZWrwVAye5SaQis41+Id8R37InG2blfrqiMc9oicTrwCEHMP/qd?=
 =?us-ascii?Q?2DpC+fOCBnu03ovVWCVLPOgATxLNF8yneFV6nLmDweiYxo7WZkzCXKpYL5ac?=
 =?us-ascii?Q?svDPRyudMO85AiFmW/WiYJm/4UwhCfuhZuYD+c+DcjDBamLOVPOyfGGMIFma?=
 =?us-ascii?Q?cqRQ0YpPDbhWWHZQY3IgI9HL+ThKjkZZbAyblHuUOOYDZ4xuaEufGvSK1PRW?=
 =?us-ascii?Q?NpFj5BqgR7QWys0yw48Gc7XLgkumo19j6MYpr3AyQhkEpSJf8N7b9oLlD2dR?=
 =?us-ascii?Q?QLfzOewX0VxjU2N9beEimjwsPlMtgq7rGLeguiw1Fe2kquuW7WnibWGVVLSH?=
 =?us-ascii?Q?fWoIjcXihgOyrUR9wvJbB3S8z6qOd83jj0dv8daHhzRn+sR1OI8egkW+FInx?=
 =?us-ascii?Q?6KIwPuCx2uH7ou5/MLyy3QHr0ps8tl1FSy7HyPdtj3Q3SOSbhcHzFUfFVEMw?=
 =?us-ascii?Q?YwpbVszSdW1Py54vPOrrG2wkndxR9NmN9dycJGtJnnQx9P1PGNGPqOY8PB4H?=
 =?us-ascii?Q?WHDGJ4QXFkBJHwXv23z3zwqOcPPhw5NrdANi2X5aENiRENA0sNLTFV7DASmP?=
 =?us-ascii?Q?pwm7ceEVLDoW7C1k6SH3+GIJS9TqrOgNUAoFW+gMDpVw/EemKDltFrOsoWPO?=
 =?us-ascii?Q?nF5x6pnVVTiyiSbDu4eQvRbnlzrNJJRB3pFPNLPZMtYlEhQeKd6fCWwjHJnF?=
 =?us-ascii?Q?LupVL8BOvKInEY9N4Fmfnl34EI7QXaU=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d075dca-c695-45ef-b33c-08d99a031831
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 11:07:13.2300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7mPtgb1+3/tqGU2ETukneyFOuCMWJg3ial9CeXbxMOhTF7ErOgBM3fUt1udWkKa9JBkAxC2oLzLA6VT9eb2AN4qM3fz4qKrxdGyws7xFG50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4956
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

We add skip_hw and skip_sw for user to control if offload the action
to hardware.

We also add in_hw_count for user to indicate if the action is offloaded
to any hardware.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/act_api.h        |  7 +++++
 include/net/pkt_cls.h        | 23 +++++++++++++++
 include/uapi/linux/pkt_cls.h |  9 ++++--
 net/sched/act_api.c          | 54 ++++++++++++++++++++++++++++++++----
 4 files changed, 84 insertions(+), 9 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 9eb19188603c..671208bd27ef 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -44,6 +44,7 @@ struct tc_action {
 	u8			hw_stats;
 	u8			used_hw_stats;
 	bool			used_hw_stats_valid;
+	u32			in_hw_count;
 };
 #define tcf_index	common.tcfa_index
 #define tcf_refcnt	common.tcfa_refcnt
@@ -236,6 +237,12 @@ static inline void tcf_action_inc_overlimit_qstats(struct tc_action *a)
 	spin_unlock(&a->tcfa_lock);
 }
 
+static inline void flow_action_hw_count_set(struct tc_action *act,
+					    u32 hw_count)
+{
+	act->in_hw_count = hw_count;
+}
+
 void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
 			     u64 drops, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 922775407257..44ae5182a965 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -261,6 +261,29 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 #define tcf_act_for_each_action(i, a, actions) \
 	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
 
+static inline bool tc_act_skip_hw(u32 flags)
+{
+	return (flags & TCA_ACT_FLAGS_SKIP_HW) ? true : false;
+}
+
+static inline bool tc_act_skip_sw(u32 flags)
+{
+	return (flags & TCA_ACT_FLAGS_SKIP_SW) ? true : false;
+}
+
+static inline bool tc_act_in_hw(struct tc_action *act)
+{
+	return !!act->in_hw_count;
+}
+
+/* SKIP_HW and SKIP_SW are mutually exclusive flags. */
+static inline bool tc_act_flags_valid(u32 flags)
+{
+	flags &= TCA_ACT_FLAGS_SKIP_HW | TCA_ACT_FLAGS_SKIP_SW;
+
+	return flags ^ (TCA_ACT_FLAGS_SKIP_HW | TCA_ACT_FLAGS_SKIP_SW);
+}
+
 static inline void
 tcf_exts_stats_update(const struct tcf_exts *exts,
 		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 6836ccb9c45d..ee38b35c3f57 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -19,13 +19,16 @@ enum {
 	TCA_ACT_FLAGS,
 	TCA_ACT_HW_STATS,
 	TCA_ACT_USED_HW_STATS,
+	TCA_ACT_IN_HW_COUNT,
 	__TCA_ACT_MAX
 };
 
 /* See other TCA_ACT_FLAGS_ * flags in include/net/act_api.h. */
-#define TCA_ACT_FLAGS_NO_PERCPU_STATS 1 /* Don't use percpu allocator for
-					 * actions stats.
-					 */
+#define TCA_ACT_FLAGS_NO_PERCPU_STATS (1 << 0) /* Don't use percpu allocator for
+						* actions stats.
+						*/
+#define TCA_ACT_FLAGS_SKIP_HW	(1 << 1) /* don't offload action to HW */
+#define TCA_ACT_FLAGS_SKIP_SW	(1 << 2) /* don't use action in SW */
 
 /* tca HW stats type
  * When user does not pass the attribute, he does not care.
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 33f2ff885b4b..604bf1923bcc 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -751,6 +751,9 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 			jmp_prgcnt -= 1;
 			continue;
 		}
+
+		if (tc_act_skip_sw(a->tcfa_flags))
+			continue;
 repeat:
 		ret = a->ops->act(skb, a, res);
 		if (ret == TC_ACT_REPEAT)
@@ -856,6 +859,9 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 			       a->tcfa_flags, a->tcfa_flags))
 		goto nla_put_failure;
 
+	if (nla_put_u32(skb, TCA_ACT_IN_HW_COUNT, a->in_hw_count))
+		goto nla_put_failure;
+
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
@@ -935,7 +941,9 @@ static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
 	[TCA_ACT_COOKIE]	= { .type = NLA_BINARY,
 				    .len = TC_COOKIE_MAX_SIZE },
 	[TCA_ACT_OPTIONS]	= { .type = NLA_NESTED },
-	[TCA_ACT_FLAGS]		= NLA_POLICY_BITFIELD32(TCA_ACT_FLAGS_NO_PERCPU_STATS),
+	[TCA_ACT_FLAGS]		= NLA_POLICY_BITFIELD32(TCA_ACT_FLAGS_NO_PERCPU_STATS |
+							TCA_ACT_FLAGS_SKIP_HW |
+							TCA_ACT_FLAGS_SKIP_SW),
 	[TCA_ACT_HW_STATS]	= NLA_POLICY_BITFIELD32(TCA_ACT_HW_STATS_ANY),
 };
 
@@ -1048,8 +1056,13 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 			}
 		}
 		hw_stats = tcf_action_hw_stats_get(tb[TCA_ACT_HW_STATS]);
-		if (tb[TCA_ACT_FLAGS])
+		if (tb[TCA_ACT_FLAGS]) {
 			userflags = nla_get_bitfield32(tb[TCA_ACT_FLAGS]);
+			if (!tc_act_flags_valid(userflags.value)) {
+				err = -EINVAL;
+				goto err_out;
+			}
+		}
 
 		err = a_o->init(net, tb[TCA_ACT_OPTIONS], est, &a, tp,
 				userflags.value | flags, extack);
@@ -1161,6 +1174,7 @@ static int flow_action_init(struct flow_offload_action *fl_action,
 }
 
 static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
+				  u32 *hw_count,
 				  struct netlink_ext_ack *extack)
 {
 	int err;
@@ -1173,6 +1187,9 @@ static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
 	if (err < 0)
 		return err;
 
+	if (hw_count)
+		*hw_count = err;
+
 	return 0;
 }
 
@@ -1180,12 +1197,17 @@ static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
 static int tcf_action_offload_add(struct tc_action *action,
 				  struct netlink_ext_ack *extack)
 {
+	bool skip_sw = tc_act_skip_sw(action->tcfa_flags);
 	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
 		[0] = action,
 	};
 	struct flow_offload_action *fl_action;
+	u32 in_hw_count = 0;
 	int err = 0;
 
+	if (tc_act_skip_hw(action->tcfa_flags))
+		return 0;
+
 	fl_action = flow_action_alloc(tcf_act_num_actions_single(action));
 	if (!fl_action)
 		return -EINVAL;
@@ -1201,7 +1223,13 @@ static int tcf_action_offload_add(struct tc_action *action,
 		goto fl_err;
 	}
 
-	err = tcf_action_offload_cmd(fl_action, extack);
+	err = tcf_action_offload_cmd(fl_action, &in_hw_count, extack);
+	if (!err)
+		flow_action_hw_count_set(action, in_hw_count);
+
+	if (skip_sw && !tc_act_in_hw(action))
+		err = -EINVAL;
+
 	tc_cleanup_flow_action(&fl_action->action);
 
 fl_err:
@@ -1213,16 +1241,27 @@ static int tcf_action_offload_add(struct tc_action *action,
 int tcf_action_offload_del(struct tc_action *action)
 {
 	struct flow_offload_action fl_act;
+	u32 in_hw_count = 0;
 	int err = 0;
 
 	if (!action)
 		return -EINVAL;
 
+	if (!tc_act_in_hw(action))
+		return 0;
+
 	err = flow_action_init(&fl_act, action, FLOW_ACT_DESTROY, NULL);
 	if (err)
 		return err;
 
-	return tcf_action_offload_cmd(&fl_act, NULL);
+	err = tcf_action_offload_cmd(&fl_act, &in_hw_count, NULL);
+	if (err)
+		return err;
+
+	if (action->in_hw_count != in_hw_count)
+		return -EINVAL;
+
+	return 0;
 }
 
 /* Returns numbers of initialized actions or negative error. */
@@ -1267,8 +1306,11 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		sz += tcf_action_fill_size(act);
 		/* Start from index 0 */
 		actions[i - 1] = act;
-		if (!(flags & TCA_ACT_FLAGS_BIND))
-			tcf_action_offload_add(act, extack);
+		if (!(flags & TCA_ACT_FLAGS_BIND)) {
+			err = tcf_action_offload_add(act, extack);
+			if (tc_act_skip_sw(act->tcfa_flags) && err)
+				goto err;
+		}
 	}
 
 	/* We have to commit them all together, because if any error happened in
-- 
2.20.1

