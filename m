Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC5043DFC1
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 13:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhJ1LJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 07:09:49 -0400
Received: from mail-bn8nam11on2113.outbound.protection.outlook.com ([40.107.236.113]:43800
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230170AbhJ1LJs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 07:09:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cS1GnAHVaFnyYGBHTRVzxr+4S4WlVv/5WZAv6WsWyIBZpRDcAHUR5vfw0NelToscKZj75ypMWet3Ad4kX9H7mSjNRXUQwoq9TT0+xBtZ2FM458PZIFZd0XH3CXiKcKgowjUqW1MOgyJ7cmlqLj8xt/SrhPJ1QjgajxJaCVZSzpNpRkAJCPnnII8XxfZFQXTx3herIda6Yv0vx7TdJMSX6kAe3IquVjYc1ZnyZo7uoiOCywKJXAtyofwnr8T88SXLe+hrMfD5rQOjcodBY2VhCUpWNWOPnCxd/fF5WV9TlfYie+PFeSLe1nCfX/DEBq+2QKoC7eE+K/Pkv/VkbSNalg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I0Wegr03kFezN66/FhJQz+sJWo3B8gRcHvYDGPJ0Ji8=;
 b=fac1HMLUj3CSVK3OMgXc4OGdZPcmFP/+ZbJ0It5S/NU/NVTdH8O4LkXfnsYWt/fYcBM4eSxPrTxUj9+2Nco//QTqoxWMliMNdg2uTMfUEc/YXxVf+l/v1ZDm7ACo45hny0BIiyLpUVDDGGXqYDFTgNYJI9gH+WcnbYtBWoix8cmqtZsSU8oMKZQMFACS9kXE0N39ANzs1AT1qkHHMyNXmsKswjtACC9ENe4GrB7GItOtuCRk0W58OZWFlzMQrHNZGJcuzSIcCvbJZYS75etFL6czpHTUzpJRFyzr10OMvDGWoMqYlhBJa6wJ+oRz9CiO87tLVUK0XBXTFvgTQcYsLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I0Wegr03kFezN66/FhJQz+sJWo3B8gRcHvYDGPJ0Ji8=;
 b=jy3UGgvC9ES4yfji0ukCy6unxQtMYg1B0ZbN7M87C8qyHy+a1RTPb9GzeddvQXwWB9UybaUbzuMvrnA9saH3rcjl/Jv1dgk22EOXnU6VskNuC5b4flueiV93Hike0Ds6uySFfbLlIncHlY25tFuiKfKXI0RScBGCHQjgRb4Wgsk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4956.namprd13.prod.outlook.com (2603:10b6:510:98::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11; Thu, 28 Oct
 2021 11:07:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4669.005; Thu, 28 Oct 2021
 11:07:20 +0000
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
Subject: [RFC/PATCH net-next v3 7/8] flow_offload: add reoffload process to update hw_count
Date:   Thu, 28 Oct 2021 13:06:45 +0200
Message-Id: <20211028110646.13791-8-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211028110646.13791-1-simon.horman@corigine.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0040.eurprd03.prod.outlook.com (2603:10a6:208::17)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR03CA0040.eurprd03.prod.outlook.com (2603:10a6:208::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Thu, 28 Oct 2021 11:07:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 140d454a-1ead-4b39-ca6a-08d99a031c57
X-MS-TrafficTypeDiagnostic: PH0PR13MB4956:
X-Microsoft-Antispam-PRVS: <PH0PR13MB4956144E1BE027EAA758AE5AE8869@PH0PR13MB4956.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y0QLkUS05UxJlD8Aixdu9cDPuDxLSA5F0klY0/64JfIO/da/ru9kmQ7yV0FsvjMCJQoa/DG2RZugVc9CglySZapJXPdwkkUaXa/poJQrwJzJB+5wfjfE/6MZE7Zvrk3k0YRbTOgk/TExtYWGg2k8Ffr0RsTXjSjHB3F+qFe/x1tR6Kg8ZLi3/n2FGFNCRyYlk+Hkn2909W65dJX8clyUexJNQC9omvfqq67Qc6CbnUtSZl1QQm/paScvpFEYwotFrT+V/5ZhSLVSlIzEcoVC5z57phuuA8QoxMsKXc93WFcNnFttCkcmiyqZfn747xJy1qFxydD08nQRRRRtXrCL2EwUNcB/IV1gZ4kfZuSe8+rKj3pji1fB/ke3WtyfBTKgJMao7PxZYx1ZUdUDe/WtEC5YsSCwDxdYuZqpFGdI+c0i8sjZ09D7rkhakaNtQkppLiZRc6x2fsQiAPPRhve5YeKMRJ6qgMWnknHqDkKHQQJ82pFnW48LP0m5NVtO4Tc/wFFHdHIwa3VoeVHIqLmgg5FXKC919K/gHh5+Woo/a2HZ+W3h7/ZsVrp+HLwQcO1wJLOWmlwM5xOnYuEgt44HGVW2G1iYdmnZE+yoIRTiqLhi3DYTvBT0NY/Is+Sv0+n3k0PCBqgtfoIAXoaFzjjcOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(39840400004)(396003)(4326008)(83380400001)(316002)(36756003)(54906003)(44832011)(6512007)(8676002)(2616005)(2906002)(5660300002)(8936002)(6666004)(52116002)(186003)(66476007)(107886003)(66556008)(15650500001)(6916009)(508600001)(6486002)(1076003)(66946007)(6506007)(86362001)(38100700002)(30864003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WWZbDKPCdfzAoh2lLkUAqpvVQ0omlYbEyoBSp9OSzUo645cHP/A/F1QTKqku?=
 =?us-ascii?Q?o2dW/rwKS3QzaRe1TxiEcKLB3LDUl6xBYx7tmlWnEMvAllw19FqcckTA6iKj?=
 =?us-ascii?Q?0NpChm3c1G2ODpOMO7n5LDeSUWKu39AgFJHozjamTMGY9Q6jkNlRYCtNpcaJ?=
 =?us-ascii?Q?mO6zh4sZwpG/4+lLiKPWtZKR9dFKrOGAvxwcFCWtdZgI+TNfsxEq4T+DnG+F?=
 =?us-ascii?Q?8X5mGzw5PLl8FjYkG7yHDi3eX/Y5e0E+pfeKLsQOVLJjcuwQoxv5ndnzCbY+?=
 =?us-ascii?Q?REDTerslSWqrZKTGmYYxYvhm1doyhwg3FZfl6MveIFUU4cPJq3pHz0mvCr64?=
 =?us-ascii?Q?nE7Ojkzq7HkIGrM7crBmetpTdk+f34lMkH33KLuZTn12SI2zE7XG5jtbxjtc?=
 =?us-ascii?Q?Oce3+CRWIHVwWrWoVsjDSPxguT13EmVHNsimURywtpps3wmR+q+SXJlzew18?=
 =?us-ascii?Q?22ZLHmuNX6ANBMnf8pPYEIt5hPGwVFXb2iMKUP8Zrmkm3aoEzIuuvoeNYy//?=
 =?us-ascii?Q?rufpQF5cDJJCUWsdpc5WikVbzn2q5Mxctgx5MexmdF4j6NY3MzXvFw+KiYL+?=
 =?us-ascii?Q?ltbp6MBxJPCfJAZmGwBl6JxhKVSmLqd0JOndWbs+n2cZU2neZP7RzJ46/MLi?=
 =?us-ascii?Q?Ip9L/C30FALJyzBYEaXHPeE61jEdbbRErCu+Wi6DyxbkApNl7WYM+sfdX4un?=
 =?us-ascii?Q?5Po+u+efGNcSWKZ7WHM9MAbYlNXfjMv4qB9gzZqTlbaNz6ulkB3wcytM5NLW?=
 =?us-ascii?Q?CZ5VPQLQnTfJL4bVRTDeanT8b3/XN11IP739Hq5/CldzBqJjDxcyP6MrjxdK?=
 =?us-ascii?Q?ZNlwqvtmkVLiX0vxfw0l2WV92NxrLl/1FCuBysiAgRyH/Tq6k87lhz79Ls4n?=
 =?us-ascii?Q?m2VuXli3giIkw3FY5fvujWMdYWShfLcGmf06S07JEApQUQ31GArJoFMf57mB?=
 =?us-ascii?Q?4pgmsnCWRYH85DUaTg9Ti/CWh5uGoXZ18TKwSjvKT2la3P0s4o6lyNPgdzPh?=
 =?us-ascii?Q?NqItun5rLU09fjpPK676jOTfefutu8Kox9gx2p2TtFjRH+pgjTa8AsAEpoE+?=
 =?us-ascii?Q?S+5TKN2cTQKoa7VVTKHXZ2eVJ9ZRbfgn4pyVzad/9dHEeIX55O29+GB9FXtC?=
 =?us-ascii?Q?s3pJ8h9lI340TeExTtMIZqK2rO3tfDWUOCvY7psLE9fVh7Xk1j5ll58jGD97?=
 =?us-ascii?Q?pq9uW0hVAFWlF1cqhuAxd133G8ow6SZxIDoYA/iWGM3wlRcc+oq239hUN1oz?=
 =?us-ascii?Q?PcSB/IcCSSZjGoggrG+fu8/Uc8emMm9ySx0bR6q30SyMgc3rzmGSyo0vyH49?=
 =?us-ascii?Q?wV/G59d1RujWouvxVeHeX1qxDchZin7yaibeecyX8mo9lIW3Ox4rnjWQEx+0?=
 =?us-ascii?Q?wQu8meohPVcM0uZHfR8qfxHzFq4fJlkfiMB2jsiDY4yEb448ZlGnS6qGtXGh?=
 =?us-ascii?Q?LFaFdS7HwwJiWhOw5gCPLvlQS0WtPyvkNpkkNhwDEg6/ugY9u0VhgOjpS6S5?=
 =?us-ascii?Q?3M5yMMkU8kNgQq36CrBCnCoUO3j81ccopGNjSY1qIQPu8RZbtH/K3gSSsMd4?=
 =?us-ascii?Q?n9PehvVn+se5i9doOsLINs932ZPbglEQaO8DSeZgMRxVFAH0RKhkQBidCbgc?=
 =?us-ascii?Q?Y8mHSjgKpTuS9bapIrvGfiUttF+RPIX9maxhlCMR0xO9uTsFoDH903Utx2Eu?=
 =?us-ascii?Q?i0kF8ex3ETWSksGWv+hCkNZqC8MdvsXOn9yyibWjPQ5jt3gZcR5yhqywYkI+?=
 =?us-ascii?Q?Vpn/cUSnFC2ds8K+cTBGuhti4n/ajF0=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 140d454a-1ead-4b39-ca6a-08d99a031c57
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 11:07:20.1835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YwrIk0+HvvxSlBWf7IpFJeseYrIdTmaEPr0Bnr9lKjbfBZXMpCr7fJ70E30ysKIwylqUTTLMPv3+AeOomNOirS5VIuvLC6x8Vf2Bcl6NO1Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4956
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add reoffload process to update hw_count when driver
is inserted or removed.

When reoffloading actions, we still offload the actions
that are added independent of filters.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/act_api.h   |  24 +++++
 include/net/pkt_cls.h   |   5 +
 net/core/flow_offload.c |   5 +
 net/sched/act_api.c     | 213 ++++++++++++++++++++++++++++++++++++----
 4 files changed, 228 insertions(+), 19 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 80a9d1e7d805..03ff39e347c3 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -7,6 +7,7 @@
 */
 
 #include <linux/refcount.h>
+#include <net/flow_offload.h>
 #include <net/sch_generic.h>
 #include <net/pkt_sched.h>
 #include <net/net_namespace.h>
@@ -243,11 +244,26 @@ static inline void flow_action_hw_count_set(struct tc_action *act,
 	act->in_hw_count = hw_count;
 }
 
+static inline void flow_action_hw_count_inc(struct tc_action *act,
+					    u32 hw_count)
+{
+	act->in_hw_count += hw_count;
+}
+
+static inline void flow_action_hw_count_dec(struct tc_action *act,
+					    u32 hw_count)
+{
+	act->in_hw_count = act->in_hw_count > hw_count ?
+			   act->in_hw_count - hw_count : 0;
+}
+
 void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
 			     u64 drops, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
 int tcf_action_offload_del(struct tc_action *action);
 int tcf_action_update_hw_stats(struct tc_action *action);
+int tcf_action_reoffload_cb(flow_indr_block_bind_cb_t *cb,
+			    void *cb_priv, bool add);
 int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
 			     struct tcf_chain **handle,
 			     struct netlink_ext_ack *newchain);
@@ -259,6 +275,14 @@ DECLARE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
 #endif
 
 int tcf_dev_queue_xmit(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb));
+
+#else /* !CONFIG_NET_CLS_ACT */
+
+static inline int tcf_action_reoffload_cb(flow_indr_block_bind_cb_t *cb,
+					  void *cb_priv, bool add) {
+	return 0;
+}
+
 #endif /* CONFIG_NET_CLS_ACT */
 
 static inline void tcf_action_stats_update(struct tc_action *a, u64 bytes,
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 88788b821f76..82ac631c50bc 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -284,6 +284,11 @@ static inline bool tc_act_flags_valid(u32 flags)
 	return flags ^ (TCA_ACT_FLAGS_SKIP_HW | TCA_ACT_FLAGS_SKIP_SW);
 }
 
+static inline bool tc_act_bind(u32 flags)
+{
+	return !!(flags & TCA_ACT_FLAGS_BIND);
+}
+
 static inline void
 tcf_exts_stats_update(const struct tcf_exts *exts,
 		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 6676431733ef..d591204af6e0 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <net/act_api.h>
 #include <net/flow_offload.h>
 #include <linux/rtnetlink.h>
 #include <linux/mutex.h>
@@ -418,6 +419,8 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
 	existing_qdiscs_register(cb, cb_priv);
 	mutex_unlock(&flow_indr_block_lock);
 
+	tcf_action_reoffload_cb(cb, cb_priv, true);
+
 	return 0;
 }
 EXPORT_SYMBOL(flow_indr_dev_register);
@@ -472,6 +475,8 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
 
 	flow_block_indr_notify(&cleanup_list);
 	kfree(indr_dev);
+
+	tcf_action_reoffload_cb(cb, cb_priv, false);
 }
 EXPORT_SYMBOL(flow_indr_dev_unregister);
 
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 3893ffd91192..dce25d8f147b 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -638,6 +638,59 @@ EXPORT_SYMBOL(tcf_idrinfo_destroy);
 
 static LIST_HEAD(act_base);
 static DEFINE_RWLOCK(act_mod_lock);
+/* since act ops id is stored in pernet subsystem list,
+ * then there is no way to walk through only all the action
+ * subsystem, so we keep tc action pernet ops id for
+ * reoffload to walk through.
+ */
+static LIST_HEAD(act_pernet_id_list);
+static DEFINE_MUTEX(act_id_mutex);
+struct tc_act_pernet_id {
+	struct list_head list;
+	unsigned int id;
+};
+
+static int tcf_pernet_add_id_list(unsigned int id)
+{
+	struct tc_act_pernet_id *id_ptr;
+	int ret = 0;
+
+	mutex_lock(&act_id_mutex);
+	list_for_each_entry(id_ptr, &act_pernet_id_list, list) {
+		if (id_ptr->id == id) {
+			ret = -EEXIST;
+			goto err_out;
+		}
+	}
+
+	id_ptr = kzalloc(sizeof(*id_ptr), GFP_KERNEL);
+	if (!id_ptr) {
+		ret = -ENOMEM;
+		goto err_out;
+	}
+	id_ptr->id = id;
+
+	list_add_tail(&id_ptr->list, &act_pernet_id_list);
+
+err_out:
+	mutex_unlock(&act_id_mutex);
+	return ret;
+}
+
+static void tcf_pernet_del_id_list(unsigned int id)
+{
+	struct tc_act_pernet_id *id_ptr;
+
+	mutex_lock(&act_id_mutex);
+	list_for_each_entry(id_ptr, &act_pernet_id_list, list) {
+		if (id_ptr->id == id) {
+			list_del(&id_ptr->list);
+			kfree(id_ptr);
+			break;
+		}
+	}
+	mutex_unlock(&act_id_mutex);
+}
 
 int tcf_register_action(struct tc_action_ops *act,
 			struct pernet_operations *ops)
@@ -656,18 +709,30 @@ int tcf_register_action(struct tc_action_ops *act,
 	if (ret)
 		return ret;
 
+	if (ops->id) {
+		ret = tcf_pernet_add_id_list(*ops->id);
+		if (ret)
+			goto id_err;
+	}
+
 	write_lock(&act_mod_lock);
 	list_for_each_entry(a, &act_base, head) {
 		if (act->id == a->id || (strcmp(act->kind, a->kind) == 0)) {
-			write_unlock(&act_mod_lock);
-			unregister_pernet_subsys(ops);
-			return -EEXIST;
+			ret = -EEXIST;
+			goto err_out;
 		}
 	}
 	list_add_tail(&act->head, &act_base);
 	write_unlock(&act_mod_lock);
 
 	return 0;
+
+err_out:
+	write_unlock(&act_mod_lock);
+	tcf_pernet_del_id_list(*ops->id);
+id_err:
+	unregister_pernet_subsys(ops);
+	return ret;
 }
 EXPORT_SYMBOL(tcf_register_action);
 
@@ -686,8 +751,11 @@ int tcf_unregister_action(struct tc_action_ops *act,
 		}
 	}
 	write_unlock(&act_mod_lock);
-	if (!err)
+	if (!err) {
 		unregister_pernet_subsys(ops);
+		if (ops->id)
+			tcf_pernet_del_id_list(*ops->id);
+	}
 	return err;
 }
 EXPORT_SYMBOL(tcf_unregister_action);
@@ -1175,15 +1243,11 @@ static int flow_action_init(struct flow_offload_action *fl_action,
 	return 0;
 }
 
-static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
-				  u32 *hw_count,
-				  struct netlink_ext_ack *extack)
+static int tcf_action_offload_cmd_ex(struct flow_offload_action *fl_act,
+				     u32 *hw_count)
 {
 	int err;
 
-	if (IS_ERR(fl_act))
-		return PTR_ERR(fl_act);
-
 	err = flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT,
 					  fl_act, NULL, NULL);
 	if (err < 0)
@@ -1195,9 +1259,41 @@ static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
 	return 0;
 }
 
+static int tcf_action_offload_cmd_cb_ex(struct flow_offload_action *fl_act,
+					u32 *hw_count,
+					flow_indr_block_bind_cb_t *cb,
+					void *cb_priv)
+{
+	int err;
+
+	err = cb(NULL, NULL, cb_priv, TC_SETUP_ACT, NULL, fl_act, NULL);
+	if (err < 0)
+		return err;
+
+	if (hw_count)
+		*hw_count = 1;
+
+	return 0;
+}
+
+static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
+				  u32 *hw_count,
+				  flow_indr_block_bind_cb_t *cb,
+				  void *cb_priv)
+{
+	if (IS_ERR(fl_act))
+		return PTR_ERR(fl_act);
+
+	return cb ? tcf_action_offload_cmd_cb_ex(fl_act, hw_count,
+						 cb, cb_priv) :
+		    tcf_action_offload_cmd_ex(fl_act, hw_count);
+}
+
 /* offload the tc command after inserted */
-static int tcf_action_offload_add(struct tc_action *action,
-				  struct netlink_ext_ack *extack)
+static int tcf_action_offload_add_ex(struct tc_action *action,
+				     struct netlink_ext_ack *extack,
+				     flow_indr_block_bind_cb_t *cb,
+				     void *cb_priv)
 {
 	bool skip_sw = tc_act_skip_sw(action->tcfa_flags);
 	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
@@ -1225,9 +1321,10 @@ static int tcf_action_offload_add(struct tc_action *action,
 		goto fl_err;
 	}
 
-	err = tcf_action_offload_cmd(fl_action, &in_hw_count, extack);
+	err = tcf_action_offload_cmd(fl_action, &in_hw_count, cb, cb_priv);
 	if (!err)
-		flow_action_hw_count_set(action, in_hw_count);
+		cb ? flow_action_hw_count_inc(action, in_hw_count) :
+		     flow_action_hw_count_set(action, in_hw_count);
 
 	if (skip_sw && !tc_act_in_hw(action))
 		err = -EINVAL;
@@ -1240,6 +1337,12 @@ static int tcf_action_offload_add(struct tc_action *action,
 	return err;
 }
 
+static int tcf_action_offload_add(struct tc_action *action,
+				  struct netlink_ext_ack *extack)
+{
+	return tcf_action_offload_add_ex(action, extack, NULL, NULL);
+}
+
 int tcf_action_update_hw_stats(struct tc_action *action)
 {
 	struct flow_offload_action fl_act = {};
@@ -1252,7 +1355,7 @@ int tcf_action_update_hw_stats(struct tc_action *action)
 	if (err)
 		goto err_out;
 
-	err = tcf_action_offload_cmd(&fl_act, NULL, NULL);
+	err = tcf_action_offload_cmd(&fl_act, NULL, NULL, NULL);
 
 	if (!err && fl_act.stats.lastused) {
 		preempt_disable();
@@ -1274,7 +1377,9 @@ int tcf_action_update_hw_stats(struct tc_action *action)
 }
 EXPORT_SYMBOL(tcf_action_update_hw_stats);
 
-int tcf_action_offload_del(struct tc_action *action)
+static int tcf_action_offload_del_ex(struct tc_action *action,
+				     flow_indr_block_bind_cb_t *cb,
+				     void *cb_priv)
 {
 	struct flow_offload_action fl_act;
 	u32 in_hw_count = 0;
@@ -1290,13 +1395,83 @@ int tcf_action_offload_del(struct tc_action *action)
 	if (err)
 		return err;
 
-	err = tcf_action_offload_cmd(&fl_act, &in_hw_count, NULL);
-	if (err)
+	err = tcf_action_offload_cmd(&fl_act, &in_hw_count, cb, cb_priv);
+	if (err < 0)
 		return err;
 
-	if (action->in_hw_count != in_hw_count)
+	if (!cb && action->in_hw_count != in_hw_count)
 		return -EINVAL;
 
+	/* do not need to update hw state when deleting action */
+	if (cb && in_hw_count)
+		flow_action_hw_count_dec(action, in_hw_count);
+
+	return 0;
+}
+
+int tcf_action_offload_del(struct tc_action *action)
+{
+	return tcf_action_offload_del_ex(action, NULL, NULL);
+}
+
+int tcf_action_reoffload_cb(flow_indr_block_bind_cb_t *cb,
+			    void *cb_priv, bool add)
+{
+	struct tc_act_pernet_id *id_ptr;
+	struct tcf_idrinfo *idrinfo;
+	struct tc_action_net *tn;
+	struct tc_action *p;
+	unsigned int act_id;
+	unsigned long tmp;
+	unsigned long id;
+	struct idr *idr;
+	struct net *net;
+	int ret;
+
+	if (!cb)
+		return -EINVAL;
+
+	down_read(&net_rwsem);
+	mutex_lock(&act_id_mutex);
+
+	for_each_net(net) {
+		list_for_each_entry(id_ptr, &act_pernet_id_list, list) {
+			act_id = id_ptr->id;
+			tn = net_generic(net, act_id);
+			if (!tn)
+				continue;
+			idrinfo = tn->idrinfo;
+			if (!idrinfo)
+				continue;
+
+			mutex_lock(&idrinfo->lock);
+			idr = &idrinfo->action_idr;
+			idr_for_each_entry_ul(idr, p, tmp, id) {
+				if (IS_ERR(p) || tc_act_bind(p->tcfa_flags))
+					continue;
+				if (add) {
+					tcf_action_offload_add_ex(p, NULL, cb,
+								  cb_priv);
+					continue;
+				}
+
+				/* cb unregister to update hw count */
+				ret = tcf_action_offload_del_ex(p, cb, cb_priv);
+				if (ret < 0)
+					continue;
+				if (tc_act_skip_sw(p->tcfa_flags) &&
+				    !tc_act_in_hw(p)) {
+					ret = tcf_idr_release_unsafe(p);
+					if (ret == ACT_P_DELETED)
+						module_put(p->ops->owner);
+				}
+			}
+			mutex_unlock(&idrinfo->lock);
+		}
+	}
+	mutex_unlock(&act_id_mutex);
+	up_read(&net_rwsem);
+
 	return 0;
 }
 
-- 
2.20.1

