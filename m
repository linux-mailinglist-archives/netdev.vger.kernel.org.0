Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E0343DFBE
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 13:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhJ1LJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 07:09:41 -0400
Received: from mail-bn8nam11on2096.outbound.protection.outlook.com ([40.107.236.96]:56801
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230122AbhJ1LJk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 07:09:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIUj2YHSXnz93vAfjGPqBo3752PqZEMRPKeQ9lFuDqzFDc1mZqzAbr2d9nYrX8DDqbE3jC9HiQRBWHxx7/Oo9kpMWgHQC/RPgmsIM1w4SUPnZB4kXH4/MKEmG2n+7mVfX6lXEW9zzy2cbp/OBKZqv5S66QnxHH9cmf8xGC2s2eu8O3MIVuyvADAe3cwGhdozKSWJUZSrGLHVNp0OvkMGCj/8zQUvak+b069EUgrNWmMwu7dOJTgQe74jPkY+fRWaNUD3QjvRl6a9M83Ha8yALFYfB3tfcNOpSWuaOv2yzAj0RhsXbm336Ko+yzor4X/Xb8V6RSLbblNSZ4uZ8sq/qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b/4HxzwRVriw1LmBVCsT+NzQaHyqFiwP6yC3Vje4ia8=;
 b=hP04tIlpOxJYkr4RQ1RBEHlHRt2oKrqMRD/v4jQj9x7Rea4fM3p4QhqlLbBfC340LZGO9Sat4vzOWX0g5XVnZae/99OrKSNdZGjm8BU5rcW09obp8AqcnIh6LNnePX/Kj0mXqIZsIRTMnpBUeinB7ZPlZKsu7eic+ODyIIfv2IhtP4vMX/yeDw83MIxz2qbA9sb5rmSkcgRa2Xw6p9HUC4NTBx0sXleqWdClJkhs7Y6xEQAt1Vx1N9AZvjw5K2hmliRtHFHJv18tV4orRgpOM6Jns1gsWjXp1RPm6uY1qhNPB34D9k68zFSf5+ZHx1A0/lDdhA/ZG9DQeD4TU6T7DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/4HxzwRVriw1LmBVCsT+NzQaHyqFiwP6yC3Vje4ia8=;
 b=tJe2YpCd+vq9siKe5BMvQqNqiRumg/VAo+CyibaDtJ2QS1MqalKHbpU0sPSNbmftCLHJm54eEIcxwpcucMQ5CEkkRyOkuit4dAMW4T/JMMjK2aSBzaeH9Qkdb3Vmivx76XrQ2/1bUIwu7beeW/XPVnjJwdhN9yo2IDteuVZdnVw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4956.namprd13.prod.outlook.com (2603:10b6:510:98::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11; Thu, 28 Oct
 2021 11:07:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4669.005; Thu, 28 Oct 2021
 11:07:11 +0000
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
Subject: [RFC/PATCH net-next v3 3/8] flow_offload: allow user to offload tc action to net device
Date:   Thu, 28 Oct 2021 13:06:41 +0200
Message-Id: <20211028110646.13791-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211028110646.13791-1-simon.horman@corigine.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0040.eurprd03.prod.outlook.com (2603:10a6:208::17)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR03CA0040.eurprd03.prod.outlook.com (2603:10a6:208::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Thu, 28 Oct 2021 11:07:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 760a5e69-6197-44b2-f016-08d99a0316dc
X-MS-TrafficTypeDiagnostic: PH0PR13MB4956:
X-Microsoft-Antispam-PRVS: <PH0PR13MB495696D49E6ED30A098FF0A0E8869@PH0PR13MB4956.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:565;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rmHY4syD3H2+8UduqGBuJc+A/dpsN/1azJ6nhaLPllvj8DrOWFB/OIE6YSrOXkfJzYaocd7CB6I3OnlHDZVSbEvWSNpTtZ3Oy/I7PXeZiX1gl85C50Vh3/sq3RF7ErsFC/i2aYEsiNcZGvaSn4UgaEZf2Mb5we1BlSp8jYwX10HFFgi1fQziYG5IgU6otz1u3o/JBFwwseT2RVsD1hP5Sn5Ap6YGoh1gb8akW+WRJbUut2m8goFk5DJH17xHBVSTlOsf5oBxGqs0fK8LZzQxHejqIqquffRPBVr/VwN+hFpuhfhiWMXu3oZoA0GRp0EDLvHfimEvWUym1afonM53pl0LFZZL89QpVJhrnGH1LcaPoHyeIjNfUYrJX6MhYTr9/f1tw1Fpg/kvv04A+93w9PtjsYgDqwgp9SHUydhmLnX4gprFcJ+Zxa4N5ji6cXfw2VPd95I3q6Z/Qn+Q3nG1/+hCRJp+daIJ4dA4eBTnzVLNWPTGqxDh5RCqihFUFDMQ2SAbTJhiX30P8BMCghT6jc5uMewxdoUGyLKO8ZaSXCMyWJ8PqeFLHDFLL32dC35X9sW427FMy69safmfRUvX3XscWl8tS4u/4cBAZYh/ZKdRPbZRGoXYA2Ou4gQ5A7gIzeZn3KLmqeam0gcSMNJoyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(39840400004)(396003)(4326008)(83380400001)(316002)(36756003)(54906003)(44832011)(6512007)(8676002)(2616005)(2906002)(5660300002)(8936002)(6666004)(52116002)(186003)(66476007)(107886003)(66556008)(6916009)(508600001)(6486002)(1076003)(66946007)(6506007)(86362001)(38100700002)(30864003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FQK6vsfSqWqDEWeHTgXKwC1u7JQ+vC41Sla8vSr12MBb+h3TaMiXod1U+rUP?=
 =?us-ascii?Q?XRrhgakbcvwdWLl6jkDRPBy6YtPUm1vKAcM4se/mK6TJbfYACdcaCl7yqMRf?=
 =?us-ascii?Q?i79TiroGk9d1N2UD8JtO1tjWhuOd20WvgS3Rcs08K0RU0qiCkbfCfONx8onQ?=
 =?us-ascii?Q?g6OK9rzoEeK7JmsQX5icNVDTAKXzMrSqcm3kkBlg2wm/zl9PFWSu8rMwds4U?=
 =?us-ascii?Q?obxdt5QQB+b+PfsYrBVks+AcWeGwfd/iNz0JB3wk3M9UeTkN/ec21bv7nmX6?=
 =?us-ascii?Q?18jIzbiN0rGIybgSiuE+1E5zTpaEw9lGc6B+1gUaqSgCwqZyUSHqWGDWNUh+?=
 =?us-ascii?Q?mzyzqCw0ldhktFmiUOZT5kPxRWr1SaRPrSa4VKXbI9nCDdBKVNhCGBIH5Exf?=
 =?us-ascii?Q?+XjC7Cl4iKvuHjIb9n3JX90C2dCfC0MRUhwLNz/RrDEzL8lZ+GZuxtOrHZ1C?=
 =?us-ascii?Q?BQVQiuIUzdwnueYkcNMP7sDWkZVqVpge25xkomy5V6nBizFWbSNBRapIiEJl?=
 =?us-ascii?Q?Q5gCnidA9VxTp9NJKZZBawTKmcZNzqOn+7igcYGOgkg7B6UoBfEM0InUfX4q?=
 =?us-ascii?Q?7qrsNU91Rx8FfOR3nHtzsCeXHZPocfCmM7K/MMbGaewbKjSOXKf+XJJyzWVE?=
 =?us-ascii?Q?V+becFig2+gEIJzhry+DkMKGhu5UiC//kXILWzbGSZZcKdJQ5CDTCKKTDlqx?=
 =?us-ascii?Q?Edpy/BaGKuHkhP8wmNZjoiI8HvahzpzwiOz/JCa4tAJ0Rtesw2oqrHykdKY1?=
 =?us-ascii?Q?KQL7IrBW/Tol9aVZiuPBYMTrPgNf2NAH4Qdri9mlZDZiuXRwuW+uFuNDcEY+?=
 =?us-ascii?Q?37v2d7I4ABLra44xZWRZHkPvISB9dVTjLXT74VD11gAhQWYRHzccyOUB0+5O?=
 =?us-ascii?Q?5mTg6BeN3lkD5tovEOofLkXNNhUW3SKCmjkLSPd7cN4f22ei/mlvCOOzpR0w?=
 =?us-ascii?Q?jsArGT+C9y462KAIVQCxJxpXE/7hSKEqTzsBDO4qL43Wdv7CsirrrhJqyeyn?=
 =?us-ascii?Q?aM/4144lSp/NwgnGsjj+wRbZf8wM65FIpcigClsEPSl/7bHIAHP8Dl0vXkBE?=
 =?us-ascii?Q?KQQmzEcyDL5UpgxN/NvfCdyFeW2F8zq8fjWYg7Sv087POeFUu2PyHKHuWLjZ?=
 =?us-ascii?Q?jl3FjpRJ9Us9Hj5zxoBJuta6qAyy8y7TA6PCodC570EVyJHIUPtHcuAu53g/?=
 =?us-ascii?Q?hC47YNvfNnaK3f557hxbKo232gWxlxLVqLNtsNLzu75hc+0pIsLqROPzFLgt?=
 =?us-ascii?Q?fpRU4P5yaelAlNuzbBODLuXKnckdQHKwld+c24mCErJocM1G0qF8Kf7oabgI?=
 =?us-ascii?Q?wZ3B2bEqEuryAHCBmWbjG0tlbgt6sawyZZA4aEKJ0UgaS03kN6hlkduWMLrQ?=
 =?us-ascii?Q?vF53NhzDcZRohMYPQhTORMwrU1KcskaXJgRzZ8PkhfeGxtCb5UVzGbuOXz98?=
 =?us-ascii?Q?MnDMOQwDCquDR7qznAXdAlRynFt0yS46PnGRF1QBuBgSrlv2BgA+H0x8dqxJ?=
 =?us-ascii?Q?8lJhcwICsDerM85tr4/irOpKzTnYBCauUnJOpVZa0maAVxxYVOwT7RTYdsTY?=
 =?us-ascii?Q?c+lntSfcR4zXw+MERhmvlCyb3zXx0ROvl/h7EG7xjS+HzyhUnrRz0JuPmXLc?=
 =?us-ascii?Q?I+nbX4FmPMuJFwH4m4okCAa3E8WmwKxrpbjwgxrPQ65NlOGkNEn59fyw6jb9?=
 =?us-ascii?Q?4CRcFIy9qSCKOlakSpWOYD9nQg9mCtJsWmWcW/kAu7WQbxs8PApkESQyRebZ?=
 =?us-ascii?Q?7btQ5m3Zfj3qkRH04oH0MzvnuQcE0SQ=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 760a5e69-6197-44b2-f016-08d99a0316dc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 11:07:11.0037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EiAU/83ffxQ9kP0W13tG1xX64OvXej7oEkCXMAws4tJdfyxc2lWbayTlbzvLGsW25vOwrdxqr2DIcfJEe8J0kkuOPNLR5NWeM28cvyMT7Z8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4956
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Use flow_indr_dev_register/flow_indr_dev_setup_offload to
offload tc action.

We need to call tc_cleanup_flow_action to clean up tc action entry since
in tc_setup_action, some actions may hold dev refcnt, especially the mirror
action.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/linux/netdevice.h  |   1 +
 include/net/act_api.h      |   2 +-
 include/net/flow_offload.h |  17 ++++
 include/net/pkt_cls.h      |  15 ++++
 net/core/flow_offload.c    |  43 ++++++++--
 net/sched/act_api.c        | 166 +++++++++++++++++++++++++++++++++++++
 net/sched/cls_api.c        |  29 ++++++-
 7 files changed, 260 insertions(+), 13 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3ec42495a43a..9815c3a058e9 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -916,6 +916,7 @@ enum tc_setup_type {
 	TC_SETUP_QDISC_TBF,
 	TC_SETUP_QDISC_FIFO,
 	TC_SETUP_QDISC_HTB,
+	TC_SETUP_ACT,
 };
 
 /* These structures hold the attributes of bpf state that are being passed
diff --git a/include/net/act_api.h b/include/net/act_api.h
index b5b624c7e488..9eb19188603c 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -239,7 +239,7 @@ static inline void tcf_action_inc_overlimit_qstats(struct tc_action *a)
 void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
 			     u64 drops, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
-
+int tcf_action_offload_del(struct tc_action *action);
 int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
 			     struct tcf_chain **handle,
 			     struct netlink_ext_ack *newchain);
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 3961461d9c8b..aa28592fccc0 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -552,6 +552,23 @@ struct flow_cls_offload {
 	u32 classid;
 };
 
+enum flow_act_command {
+	FLOW_ACT_REPLACE,
+	FLOW_ACT_DESTROY,
+	FLOW_ACT_STATS,
+};
+
+struct flow_offload_action {
+	struct netlink_ext_ack *extack; /* NULL in FLOW_ACT_STATS process*/
+	enum flow_act_command command;
+	enum flow_action_id id;
+	u32 index;
+	struct flow_stats stats;
+	struct flow_action action;
+};
+
+struct flow_offload_action *flow_action_alloc(unsigned int num_actions);
+
 static inline struct flow_rule *
 flow_cls_offload_flow_rule(struct flow_cls_offload *flow_cmd)
 {
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 193f88ebf629..922775407257 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -258,6 +258,9 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 	for (; 0; (void)(i), (void)(a), (void)(exts))
 #endif
 
+#define tcf_act_for_each_action(i, a, actions) \
+	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
+
 static inline void
 tcf_exts_stats_update(const struct tcf_exts *exts,
 		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
@@ -532,8 +535,19 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
 	return ifindex == skb->skb_iif;
 }
 
+#ifdef CONFIG_NET_CLS_ACT
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts);
+#else
+static inline int tc_setup_flow_action(struct flow_action *flow_action,
+				       const struct tcf_exts *exts)
+{
+	return 0;
+}
+#endif
+
+int tc_setup_action(struct flow_action *flow_action,
+		    struct tc_action *actions[]);
 void tc_cleanup_flow_action(struct flow_action *flow_action);
 
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
@@ -554,6 +568,7 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
 			  enum tc_setup_type type, void *type_data,
 			  void *cb_priv, u32 *flags, unsigned int *in_hw_count);
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
+unsigned int tcf_act_num_actions_single(struct tc_action *act);
 
 #ifdef CONFIG_NET_CLS_ACT
 int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 6beaea13564a..6676431733ef 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -27,6 +27,27 @@ struct flow_rule *flow_rule_alloc(unsigned int num_actions)
 }
 EXPORT_SYMBOL(flow_rule_alloc);
 
+struct flow_offload_action *flow_action_alloc(unsigned int num_actions)
+{
+	struct flow_offload_action *fl_action;
+	int i;
+
+	fl_action = kzalloc(struct_size(fl_action, action.entries, num_actions),
+			    GFP_KERNEL);
+	if (!fl_action)
+		return NULL;
+
+	fl_action->action.num_entries = num_actions;
+	/* Pre-fill each action hw_stats with DONT_CARE.
+	 * Caller can override this if it wants stats for a given action.
+	 */
+	for (i = 0; i < num_actions; i++)
+		fl_action->action.entries[i].hw_stats = FLOW_ACTION_HW_STATS_DONT_CARE;
+
+	return fl_action;
+}
+EXPORT_SYMBOL(flow_action_alloc);
+
 #define FLOW_DISSECTOR_MATCH(__rule, __type, __out)				\
 	const struct flow_match *__m = &(__rule)->match;			\
 	struct flow_dissector *__d = (__m)->dissector;				\
@@ -549,19 +570,25 @@ int flow_indr_dev_setup_offload(struct net_device *dev,	struct Qdisc *sch,
 				void (*cleanup)(struct flow_block_cb *block_cb))
 {
 	struct flow_indr_dev *this;
+	u32 count = 0;
+	int err;
 
 	mutex_lock(&flow_indr_block_lock);
+	if (bo) {
+		if (bo->command == FLOW_BLOCK_BIND)
+			indir_dev_add(data, dev, sch, type, cleanup, bo);
+		else if (bo->command == FLOW_BLOCK_UNBIND)
+			indir_dev_remove(data);
+	}
 
-	if (bo->command == FLOW_BLOCK_BIND)
-		indir_dev_add(data, dev, sch, type, cleanup, bo);
-	else if (bo->command == FLOW_BLOCK_UNBIND)
-		indir_dev_remove(data);
-
-	list_for_each_entry(this, &flow_block_indr_dev_list, list)
-		this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
+	list_for_each_entry(this, &flow_block_indr_dev_list, list) {
+		err = this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
+		if (!err)
+			count++;
+	}
 
 	mutex_unlock(&flow_indr_block_lock);
 
-	return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
+	return (bo && list_empty(&bo->cb_list)) ? -EOPNOTSUPP : count;
 }
 EXPORT_SYMBOL(flow_indr_dev_setup_offload);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 3258da3d5bed..33f2ff885b4b 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -21,6 +21,19 @@
 #include <net/pkt_cls.h>
 #include <net/act_api.h>
 #include <net/netlink.h>
+#include <net/tc_act/tc_pedit.h>
+#include <net/tc_act/tc_mirred.h>
+#include <net/tc_act/tc_vlan.h>
+#include <net/tc_act/tc_tunnel_key.h>
+#include <net/tc_act/tc_csum.h>
+#include <net/tc_act/tc_gact.h>
+#include <net/tc_act/tc_police.h>
+#include <net/tc_act/tc_sample.h>
+#include <net/tc_act/tc_skbedit.h>
+#include <net/tc_act/tc_ct.h>
+#include <net/tc_act/tc_mpls.h>
+#include <net/tc_act/tc_gate.h>
+#include <net/flow_offload.h>
 
 #ifdef CONFIG_INET
 DEFINE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
@@ -148,6 +161,7 @@ static int __tcf_action_put(struct tc_action *p, bool bind)
 		idr_remove(&idrinfo->action_idr, p->tcfa_index);
 		mutex_unlock(&idrinfo->lock);
 
+		tcf_action_offload_del(p);
 		tcf_action_cleanup(p);
 		return 1;
 	}
@@ -341,6 +355,7 @@ static int tcf_idr_release_unsafe(struct tc_action *p)
 		return -EPERM;
 
 	if (refcount_dec_and_test(&p->tcfa_refcnt)) {
+		tcf_action_offload_del(p);
 		idr_remove(&p->idrinfo->action_idr, p->tcfa_index);
 		tcf_action_cleanup(p);
 		return ACT_P_DELETED;
@@ -452,6 +467,7 @@ static int tcf_idr_delete_index(struct tcf_idrinfo *idrinfo, u32 index)
 						p->tcfa_index));
 			mutex_unlock(&idrinfo->lock);
 
+			tcf_action_offload_del(p);
 			tcf_action_cleanup(p);
 			module_put(owner);
 			return 0;
@@ -1061,6 +1077,154 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	return ERR_PTR(err);
 }
 
+static int flow_action_init(struct flow_offload_action *fl_action,
+			    struct tc_action *act,
+			    enum flow_act_command cmd,
+			    struct netlink_ext_ack *extack)
+{
+	if (!fl_action)
+		return -EINVAL;
+
+	fl_action->extack = extack;
+	fl_action->command = cmd;
+	fl_action->index = act->tcfa_index;
+
+	if (is_tcf_gact_ok(act)) {
+		fl_action->id = FLOW_ACTION_ACCEPT;
+	} else if (is_tcf_gact_shot(act)) {
+		fl_action->id = FLOW_ACTION_DROP;
+	} else if (is_tcf_gact_trap(act)) {
+		fl_action->id = FLOW_ACTION_TRAP;
+	} else if (is_tcf_gact_goto_chain(act)) {
+		fl_action->id = FLOW_ACTION_GOTO;
+	} else if (is_tcf_mirred_egress_redirect(act)) {
+		fl_action->id = FLOW_ACTION_REDIRECT;
+	} else if (is_tcf_mirred_egress_mirror(act)) {
+		fl_action->id = FLOW_ACTION_MIRRED;
+	} else if (is_tcf_mirred_ingress_redirect(act)) {
+		fl_action->id = FLOW_ACTION_REDIRECT_INGRESS;
+	} else if (is_tcf_mirred_ingress_mirror(act)) {
+		fl_action->id = FLOW_ACTION_MIRRED_INGRESS;
+	} else if (is_tcf_vlan(act)) {
+		switch (tcf_vlan_action(act)) {
+		case TCA_VLAN_ACT_PUSH:
+			fl_action->id = FLOW_ACTION_VLAN_PUSH;
+			break;
+		case TCA_VLAN_ACT_POP:
+			fl_action->id = FLOW_ACTION_VLAN_POP;
+			break;
+		case TCA_VLAN_ACT_MODIFY:
+			fl_action->id = FLOW_ACTION_VLAN_MANGLE;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+	} else if (is_tcf_tunnel_set(act)) {
+		fl_action->id = FLOW_ACTION_TUNNEL_ENCAP;
+	} else if (is_tcf_tunnel_release(act)) {
+		fl_action->id = FLOW_ACTION_TUNNEL_DECAP;
+	} else if (is_tcf_csum(act)) {
+		fl_action->id = FLOW_ACTION_CSUM;
+	} else if (is_tcf_skbedit_mark(act)) {
+		fl_action->id = FLOW_ACTION_MARK;
+	} else if (is_tcf_sample(act)) {
+		fl_action->id = FLOW_ACTION_SAMPLE;
+	} else if (is_tcf_police(act)) {
+		fl_action->id = FLOW_ACTION_POLICE;
+	} else if (is_tcf_ct(act)) {
+		fl_action->id = FLOW_ACTION_CT;
+	} else if (is_tcf_mpls(act)) {
+		switch (tcf_mpls_action(act)) {
+		case TCA_MPLS_ACT_PUSH:
+			fl_action->id = FLOW_ACTION_MPLS_PUSH;
+			break;
+		case TCA_MPLS_ACT_POP:
+			fl_action->id = FLOW_ACTION_MPLS_POP;
+			break;
+		case TCA_MPLS_ACT_MODIFY:
+			fl_action->id = FLOW_ACTION_MPLS_MANGLE;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+	} else if (is_tcf_skbedit_ptype(act)) {
+		fl_action->id = FLOW_ACTION_PTYPE;
+	} else if (is_tcf_skbedit_priority(act)) {
+		fl_action->id = FLOW_ACTION_PRIORITY;
+	} else if (is_tcf_gate(act)) {
+		fl_action->id = FLOW_ACTION_GATE;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
+				  struct netlink_ext_ack *extack)
+{
+	int err;
+
+	if (IS_ERR(fl_act))
+		return PTR_ERR(fl_act);
+
+	err = flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT,
+					  fl_act, NULL, NULL);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+/* offload the tc command after inserted */
+static int tcf_action_offload_add(struct tc_action *action,
+				  struct netlink_ext_ack *extack)
+{
+	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
+		[0] = action,
+	};
+	struct flow_offload_action *fl_action;
+	int err = 0;
+
+	fl_action = flow_action_alloc(tcf_act_num_actions_single(action));
+	if (!fl_action)
+		return -EINVAL;
+
+	err = flow_action_init(fl_action, action, FLOW_ACT_REPLACE, extack);
+	if (err)
+		goto fl_err;
+
+	err = tc_setup_action(&fl_action->action, actions);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed to setup tc actions for offload\n");
+		goto fl_err;
+	}
+
+	err = tcf_action_offload_cmd(fl_action, extack);
+	tc_cleanup_flow_action(&fl_action->action);
+
+fl_err:
+	kfree(fl_action);
+
+	return err;
+}
+
+int tcf_action_offload_del(struct tc_action *action)
+{
+	struct flow_offload_action fl_act;
+	int err = 0;
+
+	if (!action)
+		return -EINVAL;
+
+	err = flow_action_init(&fl_act, action, FLOW_ACT_DESTROY, NULL);
+	if (err)
+		return err;
+
+	return tcf_action_offload_cmd(&fl_act, NULL);
+}
+
 /* Returns numbers of initialized actions or negative error. */
 
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
@@ -1103,6 +1267,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		sz += tcf_action_fill_size(act);
 		/* Start from index 0 */
 		actions[i - 1] = act;
+		if (!(flags & TCA_ACT_FLAGS_BIND))
+			tcf_action_offload_add(act, extack);
 	}
 
 	/* We have to commit them all together, because if any error happened in
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2ef8f5a6205a..351d93988b8b 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3544,8 +3544,8 @@ static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
 	return hw_stats;
 }
 
-int tc_setup_flow_action(struct flow_action *flow_action,
-			 const struct tcf_exts *exts)
+int tc_setup_action(struct flow_action *flow_action,
+		    struct tc_action *actions[])
 {
 	struct tc_action *act;
 	int i, j, k, err = 0;
@@ -3554,11 +3554,11 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_DELAYED != FLOW_ACTION_HW_STATS_DELAYED);
 
-	if (!exts)
+	if (!actions)
 		return 0;
 
 	j = 0;
-	tcf_exts_for_each_action(i, act, exts) {
+	tcf_act_for_each_action(i, act, actions) {
 		struct flow_action_entry *entry;
 
 		entry = &flow_action->entries[j];
@@ -3725,7 +3725,19 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 	spin_unlock_bh(&act->tcfa_lock);
 	goto err_out;
 }
+EXPORT_SYMBOL(tc_setup_action);
+
+#ifdef CONFIG_NET_CLS_ACT
+int tc_setup_flow_action(struct flow_action *flow_action,
+			 const struct tcf_exts *exts)
+{
+	if (!exts)
+		return 0;
+
+	return tc_setup_action(flow_action, exts->actions);
+}
 EXPORT_SYMBOL(tc_setup_flow_action);
+#endif
 
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
 {
@@ -3743,6 +3755,15 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
 }
 EXPORT_SYMBOL(tcf_exts_num_actions);
 
+unsigned int tcf_act_num_actions_single(struct tc_action *act)
+{
+	if (is_tcf_pedit(act))
+		return tcf_pedit_nkeys(act);
+	else
+		return 1;
+}
+EXPORT_SYMBOL(tcf_act_num_actions_single);
+
 #ifdef CONFIG_NET_CLS_ACT
 static int tcf_qevent_parse_block_index(struct nlattr *block_index_attr,
 					u32 *p_block_index,
-- 
2.20.1

