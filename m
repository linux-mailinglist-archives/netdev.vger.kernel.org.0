Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78CB1478DB4
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 15:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237280AbhLQOXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 09:23:08 -0500
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com ([104.47.59.171]:28401
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234597AbhLQOXC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 09:23:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fvmQCT1wOULeD3w4mTnPvrD978W92VPqHZe9Chkkfczo9te8fMpe631/Aa2K0NYsc2UHjlIUv6AU0xHWj7WdUdHB9PNxSlGQI4mY+WP/ixW9/XIPugUcsWI0thdTmaKz7xn34E+pN9cti5jhFsbEfNo8/yPP/8YLgd9XBAu94JPIEYNuQSxBa6MH75rSetBOJyh80OgAwHE+cTwlUOreR/2r86IbklLRsgbI4BgqvcfEW8h4XukzlRyq8qma1nrIfpKgD2QHNl6J3jx+5bwYDznSEtYQ8u2ZqT+75hQn7V6IVuPJxTeRiDUYvJDg9XJEK9c9YeG8CqENyW2AjCmT1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NsZmCq/HKqyStIIUm6M+BPEeFAHsIGK1ekUALHueZOU=;
 b=NAK+XZc1wHqMfcHJi72Il+1NOuen0Hob1vJXPaCQq63EECnnjZzBKnmtww1/IOlDe+Plm7M8ECzoMqpircidOow1VV2lhodCj32J/jSi64a0ZDUIabRdIRutd8mHXS20Hyz/w/lL3cHwAKrS7FUuGBg6raovdqhNCSXXM7goMzKXErU31U+T8uLuE/6WmAsl7E9oZXiSLC7oW+nWKmL/k+jR7ZqgG+Eh5SVfcPxEYpdpcVl35CVyKbJri0M/Jejw5iXL/mC7ECzdOw2s/i8jq90K9beNd+JmqYhHJEn+oCcp5SxLcRPjS6twRuL1Xx//1PCo0bO00wUWNprl/yZ/kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NsZmCq/HKqyStIIUm6M+BPEeFAHsIGK1ekUALHueZOU=;
 b=fSSyzfkEf9gXKu/zWtxS0iNM5Sp/LbbzCV+3Hy9yT8wnx79ue6i1cpFGJWwUVJ1n6P68tm4Lk4jua+LXUZtnHcT5uSut3rIOEnFJa4J8wuXWotKqOdPd6JswChcxzTZPUfEXPkSbxMK+yk8e6daochqU5uewPVVFUqRusgKRNck=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5595.namprd13.prod.outlook.com (2603:10b6:510:139::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.8; Fri, 17 Dec
 2021 14:22:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 14:22:57 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Oz Shlomo <ozsh@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v7 net-next 11/12] flow_offload: validate flags of filter and actions
Date:   Fri, 17 Dec 2021 15:21:49 +0100
Message-Id: <20211217142150.17838-12-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211217142150.17838-1-simon.horman@corigine.com>
References: <20211217142150.17838-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0079.eurprd07.prod.outlook.com
 (2603:10a6:207:6::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 398672ad-d237-4caa-8600-08d9c168b8a2
X-MS-TrafficTypeDiagnostic: PH7PR13MB5595:EE_
X-Microsoft-Antispam-PRVS: <PH7PR13MB559533F9C1304E8C6272A2CCE8789@PH7PR13MB5595.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:16;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BQbtGZJ5IH3/+BteaVYvPwyWMGOPf7W+OhHOgup148A5UfGvP8E+bapJPaI8dyR/XCh060T8vmuGBWJq0wJyW+Vp0yURoiQVre1Rag1vi09e0beg+3yX/fyPHj9BKkoVeaXmWGA4Dx5L/5FFefjJALVA1IqZKDir4SYczxQrtEgmksWfhi8oftllXtc4sQTY5ZKyEXumsAcA+d6JsAsL0j3iKTET5Gm1Iwx+O5swpgHHfq8pHDKr+040gUU6t9/OXjz56l39jPMSrTqehLhOVoYb/umaaY9A8RIAU9Pw9tqfQLrcJjra7UAhXXrW91z5gYlVreTlgwz0oDYQ2e7OYi2r6nN1NlH6pBZwjyJqfShnV6aBV2hZaBiwac78bBcOBSD+Xx9PorbUSnZGuSNgC68KPhJfDIFEBFDwrRrJzBP2NrmewQvrMqyH6x8YCkGzYtGGilFBgJdZYKORQ19th7a68hxZWqooWENhYMioWHTKWnZIwrhndEC7mN4pIISMAOdrOClbGvI7eqtCY/VOJdjA2y8lgo/lknmsunt3AmUlkZJkv5/9YMCz1Dh9qXZm8T+GACekkiwwyzV4oRh2MHNn7wtoExcZOUiiqMb8fWvhcWOrmBgx45F+TV8cHthBBLZZKcJrli3W/sKe85TJLLWAGZxSzbK7v3R3k1JVjRzD2L+r9iEOIx9s3TABrktE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(39840400004)(346002)(376002)(136003)(110136005)(8936002)(54906003)(8676002)(316002)(66946007)(66476007)(7416002)(2906002)(66556008)(4326008)(86362001)(38100700002)(107886003)(83380400001)(508600001)(1076003)(6486002)(36756003)(6506007)(2616005)(6666004)(52116002)(5660300002)(15650500001)(44832011)(186003)(6512007)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DIamQdy1K4ozw1g25MU61URD9hu5PqIexYkdq/IayzNpFaIlnpHXA5qQ3r2d?=
 =?us-ascii?Q?lXcrvq86gZ8DdztlzwAe5e9XdCZSWVoHgLRSlL3j3X0fXJphFNTu1kaX5+AY?=
 =?us-ascii?Q?El0D0Ee5BNHt4NTII7P+6w8oRWJljH0Uhs581F1JajzvGceTgKQmVzlGF6B5?=
 =?us-ascii?Q?x/DGLmq0RZXp2ZWg5A5LqNTH07E95fQHnz5lyV8WRlaJ2HHiWV1pSIJe1XBt?=
 =?us-ascii?Q?WDZ5znOXul9KrZhT+w7i/wWMjBHjbb9iCduoj6xE6ziRqWHlaQ/VIsGK3TpU?=
 =?us-ascii?Q?bbXFzmpREWTGUSDkU95PfzvFVOwWlc019wlXX3boRCjMaA460JMPQ/yyOm7+?=
 =?us-ascii?Q?T96NMugpxKgVnq5cVb2g9gX6rcndmeYRI9mK7KO3zUFt9SgKDbX3EWzgccRn?=
 =?us-ascii?Q?MDe8CIcgF7IfpK3t/4CgQBFtq5dBv000LNhBNDspItGr+2aoUlOlrQQxI9MY?=
 =?us-ascii?Q?WI1ndUMAcYSPuq6T9SW6bBdKMPJLN6lkH2uVjf7zEs7qAPQbCq+9tEFUw6hC?=
 =?us-ascii?Q?t6BnZX3Hl/aEYrsnAP8x6PZq6AhVuwGLc4575i8VHtk/3UuOPRpqVzoz71+k?=
 =?us-ascii?Q?adgcFJn5FHCN6Gk2/c0u4GNDO3LsNrveZkGvp6qElIfelrwmSNqCtW8R+1VP?=
 =?us-ascii?Q?RYuvKgXFqPgp2lMT2NBscn4+DDJbBlQrI80qXOd5FM5kKATSUneVn2xGbB9N?=
 =?us-ascii?Q?bQWG1AQ3DZivW84nHiqjwKY9VD678uKd1RrSKJc2lIzGcXvQ2t1v015AedMp?=
 =?us-ascii?Q?jfNNA0hcQtHDdmlfa5xxGHzXpTCDY/dtgCpAy0n0g2TtqJvRwJEs5gy6UFj4?=
 =?us-ascii?Q?D7MKHUwhF8j5Fq45QonQJnLSKQee9SqVO3pJ+VpwA5IrqcNvPgGTDO98yJz2?=
 =?us-ascii?Q?l5nUlMXQvGe2PE0tT0zLKhemaIS9KRAztubCPhqheXg6kGuevJJXD89ztVkj?=
 =?us-ascii?Q?A18NxDLsLpAnCzqKdbL058JWilvm0Mg3oLhr5qvnHwtMj9mDkZk+L1Sqc/75?=
 =?us-ascii?Q?CaP5/gNbSIdHBWs/vQCCa5FzpdCsjKNEWUJp12VppMFFYDJNBiVnRQ10ovjW?=
 =?us-ascii?Q?71QEbW4++LplgLuWpzMFuKp5o0svpZl4y/TkZgIsOxgsN9nzKtnpzGy3UX5m?=
 =?us-ascii?Q?Q2ojKsUsZgoY8EzGuB2zOU34kbsXy/MqaZWpv1V+ihCQ+C6S8TUgXq944LNc?=
 =?us-ascii?Q?qKQfQ1mPZOBYhe/3vr2Cfqxl2412oWQYGcbvkZLy45oA9kJYoPU2dGYfmZ6l?=
 =?us-ascii?Q?No8qLwkhZ5O/7h22Wy2NLLmGAaHm0UnV2AuWve+1IFlin4ZZgrUD+15WbJ4T?=
 =?us-ascii?Q?xi9evMPBb+zQdW/WIecVvnDJ0F9RRlbxsvg0VuYhIVRnoFFRzvbLrTIII02J?=
 =?us-ascii?Q?MyImk99tEN1yYMB5+2IDek3qSXWCQyZwySbSDIRzMe5qhkp/pTGBBfupUKSs?=
 =?us-ascii?Q?xqGG22tcjBZ40jmvSMUxYMq2U1m3FcvtlJBgzcz6NV7NuiANQxe8zWgCRFMH?=
 =?us-ascii?Q?akqicO7R3X/ocyF2L/1TpyPTIxY7JdDqtQ+NX50/lhPHNGEm/2zbja1RRqgX?=
 =?us-ascii?Q?ZdWnuY+z8hEtdbCVzh966h1V04EsUKb89QnTb4KapSq6WwkcL233UnK0J1QY?=
 =?us-ascii?Q?VrG+C2SudNCTRGKqFREGPcAJJG8vuBo/piNMh7e7aJSWqGgmxIDuOemK1Gpi?=
 =?us-ascii?Q?qpAGkQia8iOq633IKqlJF9YQjyFiZUkT1CHEDUuiq3VNrXdWAJgTs1YdibFv?=
 =?us-ascii?Q?hB5n/dRtrg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 398672ad-d237-4caa-8600-08d9c168b8a2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 14:22:57.0155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GMVe+Z7Csx91nAWwjPwy1uNPidV9lS9bRvVapPTTXmqYiMkC3wnSM6djtb/+ZwQxidlvGx08+eQoTPQv0gEQcVwTe8rRnNuNbu5FAfZwNo4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5595
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add process to validate flags of filter and actions when adding
a tc filter.

We need to prevent adding filter with flags conflicts with its actions.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/act_api.h    |  2 +-
 include/net/pkt_cls.h    |  3 +++
 net/sched/act_api.c      | 18 +++++++++++++++---
 net/sched/cls_api.c      | 18 ++++++++++++++----
 net/sched/cls_flower.c   |  9 ++++++---
 net/sched/cls_matchall.c |  9 +++++----
 net/sched/cls_u32.c      | 12 +++++++-----
 7 files changed, 51 insertions(+), 20 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 0f5f69deb3ce..3049cb69c025 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -203,7 +203,7 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est,
 		    struct tc_action *actions[], int init_res[], size_t *attr_size,
-		    u32 flags, struct netlink_ext_ack *extack);
+		    u32 flags, u32 fl_flags, struct netlink_ext_ack *extack);
 struct tc_action_ops *tc_action_load_ops(struct nlattr *nla, bool police,
 					 bool rtnl_held,
 					 struct netlink_ext_ack *extack);
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 9021e29694c9..8a2f4579081c 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -330,6 +330,9 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp,
 		      struct nlattr **tb, struct nlattr *rate_tlv,
 		      struct tcf_exts *exts, u32 flags,
 		      struct netlink_ext_ack *extack);
+int tcf_exts_validate_ex(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
+			 struct nlattr *rate_tlv, struct tcf_exts *exts,
+			 u32 flags, u32 fl_flags, struct netlink_ext_ack *extack);
 void tcf_exts_destroy(struct tcf_exts *exts);
 void tcf_exts_change(struct tcf_exts *dst, struct tcf_exts *src);
 int tcf_exts_dump(struct sk_buff *skb, struct tcf_exts *exts);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 0103e44e241f..91967f6a6c03 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1385,7 +1385,8 @@ static bool tc_act_bind(u32 flags)
 
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est, struct tc_action *actions[],
-		    int init_res[], size_t *attr_size, u32 flags,
+		    int init_res[], size_t *attr_size,
+		    u32 flags, u32 fl_flags,
 		    struct netlink_ext_ack *extack)
 {
 	struct tc_action_ops *ops[TCA_ACT_MAX_PRIO] = {};
@@ -1423,7 +1424,18 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		sz += tcf_action_fill_size(act);
 		/* Start from index 0 */
 		actions[i - 1] = act;
-		if (!tc_act_bind(flags)) {
+		if (tc_act_bind(flags)) {
+			bool skip_sw = tc_skip_sw(fl_flags);
+			bool skip_hw = tc_skip_hw(fl_flags);
+
+			if (tc_act_bind(act->tcfa_flags))
+				continue;
+			if (skip_sw != tc_act_skip_sw(act->tcfa_flags) ||
+			    skip_hw != tc_act_skip_hw(act->tcfa_flags)) {
+				err = -EINVAL;
+				goto err;
+			}
+		} else {
 			err = tcf_action_offload_add(act, extack);
 			if (tc_act_skip_sw(act->tcfa_flags) && err)
 				goto err;
@@ -1926,7 +1938,7 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
 
 	for (loop = 0; loop < 10; loop++) {
 		ret = tcf_action_init(net, NULL, nla, NULL, actions, init_res,
-				      &attr_size, flags, extack);
+				      &attr_size, flags, 0, extack);
 		if (ret != -EAGAIN)
 			break;
 	}
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 353e1eed48be..e3e26d358c7f 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3025,9 +3025,9 @@ void tcf_exts_destroy(struct tcf_exts *exts)
 }
 EXPORT_SYMBOL(tcf_exts_destroy);
 
-int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
-		      struct nlattr *rate_tlv, struct tcf_exts *exts,
-		      u32 flags, struct netlink_ext_ack *extack)
+int tcf_exts_validate_ex(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
+			 struct nlattr *rate_tlv, struct tcf_exts *exts,
+			 u32 flags, u32 fl_flags, struct netlink_ext_ack *extack)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	{
@@ -3061,7 +3061,8 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 			flags |= TCA_ACT_FLAGS_BIND;
 			err = tcf_action_init(net, tp, tb[exts->action],
 					      rate_tlv, exts->actions, init_res,
-					      &attr_size, flags, extack);
+					      &attr_size, flags, fl_flags,
+					      extack);
 			if (err < 0)
 				return err;
 			exts->nr_actions = err;
@@ -3077,6 +3078,15 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 
 	return 0;
 }
+EXPORT_SYMBOL(tcf_exts_validate_ex);
+
+int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
+		      struct nlattr *rate_tlv, struct tcf_exts *exts,
+		      u32 flags, struct netlink_ext_ack *extack)
+{
+	return tcf_exts_validate_ex(net, tp, tb, rate_tlv, exts,
+				    flags, 0, extack);
+}
 EXPORT_SYMBOL(tcf_exts_validate);
 
 void tcf_exts_change(struct tcf_exts *dst, struct tcf_exts *src)
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index f4dad3be31c9..1e5caad4f7c8 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1917,12 +1917,14 @@ static int fl_set_parms(struct net *net, struct tcf_proto *tp,
 			struct cls_fl_filter *f, struct fl_flow_mask *mask,
 			unsigned long base, struct nlattr **tb,
 			struct nlattr *est,
-			struct fl_flow_tmplt *tmplt, u32 flags,
+			struct fl_flow_tmplt *tmplt,
+			u32 flags, u32 fl_flags,
 			struct netlink_ext_ack *extack)
 {
 	int err;
 
-	err = tcf_exts_validate(net, tp, tb, est, &f->exts, flags, extack);
+	err = tcf_exts_validate_ex(net, tp, tb, est, &f->exts, flags,
+				   fl_flags, extack);
 	if (err < 0)
 		return err;
 
@@ -2036,7 +2038,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	}
 
 	err = fl_set_parms(net, tp, fnew, mask, base, tb, tca[TCA_RATE],
-			   tp->chain->tmplt_priv, flags, extack);
+			   tp->chain->tmplt_priv, flags, fnew->flags,
+			   extack);
 	if (err)
 		goto errout;
 
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 2d2702915cfa..13f7a9ecd89a 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -163,12 +163,13 @@ static const struct nla_policy mall_policy[TCA_MATCHALL_MAX + 1] = {
 static int mall_set_parms(struct net *net, struct tcf_proto *tp,
 			  struct cls_mall_head *head,
 			  unsigned long base, struct nlattr **tb,
-			  struct nlattr *est, u32 flags,
+			  struct nlattr *est, u32 flags, u32 fl_flags,
 			  struct netlink_ext_ack *extack)
 {
 	int err;
 
-	err = tcf_exts_validate(net, tp, tb, est, &head->exts, flags, extack);
+	err = tcf_exts_validate_ex(net, tp, tb, est, &head->exts, flags,
+				   fl_flags, extack);
 	if (err < 0)
 		return err;
 
@@ -226,8 +227,8 @@ static int mall_change(struct net *net, struct sk_buff *in_skb,
 		goto err_alloc_percpu;
 	}
 
-	err = mall_set_parms(net, tp, new, base, tb, tca[TCA_RATE], flags,
-			     extack);
+	err = mall_set_parms(net, tp, new, base, tb, tca[TCA_RATE],
+			     flags, new->flags, extack);
 	if (err)
 		goto err_set_parms;
 
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 4272814487f0..cf5649292ee0 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -709,12 +709,13 @@ static const struct nla_policy u32_policy[TCA_U32_MAX + 1] = {
 static int u32_set_parms(struct net *net, struct tcf_proto *tp,
 			 unsigned long base,
 			 struct tc_u_knode *n, struct nlattr **tb,
-			 struct nlattr *est, u32 flags,
+			 struct nlattr *est, u32 flags, u32 fl_flags,
 			 struct netlink_ext_ack *extack)
 {
 	int err;
 
-	err = tcf_exts_validate(net, tp, tb, est, &n->exts, flags, extack);
+	err = tcf_exts_validate_ex(net, tp, tb, est, &n->exts, flags,
+				   fl_flags, extack);
 	if (err < 0)
 		return err;
 
@@ -895,7 +896,8 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 			return -ENOMEM;
 
 		err = u32_set_parms(net, tp, base, new, tb,
-				    tca[TCA_RATE], flags, extack);
+				    tca[TCA_RATE], flags, new->flags,
+				    extack);
 
 		if (err) {
 			u32_destroy_key(new, false);
@@ -1060,8 +1062,8 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 	}
 #endif
 
-	err = u32_set_parms(net, tp, base, n, tb, tca[TCA_RATE], flags,
-			    extack);
+	err = u32_set_parms(net, tp, base, n, tb, tca[TCA_RATE],
+			    flags, n->flags, extack);
 	if (err == 0) {
 		struct tc_u_knode __rcu **ins;
 		struct tc_u_knode *pins;
-- 
2.20.1

