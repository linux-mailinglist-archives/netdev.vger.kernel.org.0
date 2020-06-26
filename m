Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABAA20BCE4
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgFZWqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:46:25 -0400
Received: from mail-am6eur05on2082.outbound.protection.outlook.com ([40.107.22.82]:6168
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725836AbgFZWqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 18:46:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aaXK+Z0Fh64jdax6cu8DpB4PcOjxZLJYNVBp4wFDA69cc8G627yIpRCux86Q7w5DYO+W3yFDhCy+axuEC0BdBmnsFqc3jrvMpyIxVbM4uEVr9Kzxsmta9TUQ/nlDaOxGApYzRPN8Z7PJ7N81/ZMFb1xtcGSq3Wp8KCV84+1WBLGBa2ay8pMgNa7BI4Pw2g4EGxgrWY0DJvjxxBnW8EoGRr7e9Z/AsuJ2yqxq+gA1wXkDPlxnvpVK71PADAyY3BztEiXqrsJpOhJ+eYf9YSldPw8Ol8rw8RMzkLXJnwn1OMfMurEPDVmL6RLz7oBHgsUA4bFiYFisWljDtH6zbQEK9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZBHGqB4EtyfXUiapTOPzcA6NIKiS+7pRfM+jHW9WdA=;
 b=S9RDvW+Mh7yO+bqmakXhH6JGbRJd0clL+tlPdBQQ0zIGbuE+EpFlm7o71ScTmV9nfyDHXYbGFtdRRvTnFSpTEeLheGSNBWYo/iCC/I8ZSkbN6L55J/N7m5sbkTqIDddhNVnByXwXyMH1lLob/4XraQA8kAMJoyiIcojnPY3AQwJ6oVHXlMtmDXb6DA58t9YLxx/xAC56LjUcul2VNOyrzsqUS0Tf5TViUwvw/PyL+ljlITOmsXyqAy8YcS1JP9liXqQ5prwrw618Al9VLzxJavwXNQWMQWStvldBMBJQASBKGIMVzPxXdGDyjbDehZrc9gSoLeD31n5aBKH+KNqY9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZBHGqB4EtyfXUiapTOPzcA6NIKiS+7pRfM+jHW9WdA=;
 b=fgnpFIeu/m5hRnM5WY9SSq6hnfJkrUv7yA4UeFxSFnNChU6n3gInViySPspt0ovxR2l55FuFJDaB6+fJtbaQG/mLr0ObCktIdcjUN0f0YnmRd+isAbO/rSZngFVy0+yhg6kEvAgWrpOMwVO5wYahuQpKcOopgwtoL65Z0MPOt+s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3196.eurprd05.prod.outlook.com (2603:10a6:7:33::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.21; Fri, 26 Jun 2020 22:46:12 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3131.024; Fri, 26 Jun 2020
 22:46:12 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jiri@mellanox.com,
        idosch@mellanox.com, Petr Machata <petrm@mellanox.com>
Subject: [PATCH net-next v1 2/5] net: sched: Introduce helpers for qevent blocks
Date:   Sat, 27 Jun 2020 01:45:26 +0300
Message-Id: <79417f27b7c57da5c0eb54bb6d074d3a472d9ebf.1593209494.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1593209494.git.petrm@mellanox.com>
References: <cover.1593209494.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0139.eurprd05.prod.outlook.com
 (2603:10a6:207:3::17) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR05CA0139.eurprd05.prod.outlook.com (2603:10a6:207:3::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Fri, 26 Jun 2020 22:46:10 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 76120541-816b-4358-eb45-08d81a22b96b
X-MS-TrafficTypeDiagnostic: HE1PR05MB3196:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB319635A168F41A5555E91D00DB930@HE1PR05MB3196.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SmeNzq1b4Pb9+lUAjuZaOGcQfoxFh5sp4dWwcNrAXVA3eHaQdiuWB3tYvDlBiNNVPnELN/ssnYuIt7ggzipUVHKeP8hNAi6IG1YTxwli5zcw29LxcnFacT13ZRTEb0Md2olh61N+a6i4C3ru0piHiJQ66GbZOWeSbe5XLxcbAS66+dQudnhhTsewoKnndclzspUgHgBSNZtTVfjQdJOxZuoeppmIyKPPdd+sMwQY/bwmDtvj6pzndGBkF5KRYoKgKnXCS1nKfPS+wVaYoSfYUopcAR7pv1oMmu6flR0kJOKH+NjfC28nNWvmIjXcz+giUgzloV0hH/GZh1BJPD4TEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(5660300002)(66476007)(8676002)(956004)(54906003)(52116002)(2616005)(6666004)(83380400001)(4326008)(6512007)(2906002)(26005)(8936002)(6916009)(107886003)(66556008)(36756003)(478600001)(86362001)(66946007)(186003)(316002)(6486002)(6506007)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fmgT+xsj2J8J4VrwPIL82EBEEkkPjScm0h/bnP+Aj7s1bUwZ7fp2icQctV/0lz9C4EP7YsHuodXVY+0niiocRQDhqIl/kBB+Wm5i79Ek6IuxrEzzYOIuPhkU6n+vd7WM5tSKHt+ywWeoxjo2mDtW4pX3DO7aZJr/CDDTb20xO+sXAODtILOSC/PuFTBunhlP1ruo1F3i8YPcDtvs7ctRQTwUQ9hzXrI/P6JmLFS9iKGhNwWCuzK1CpIRRhNZ0cBn/gA4HXFt+5zmqkh+p0IALWz8iC9DtzDNp7IxFr/tSnNzTy1kn2Qwz9jM5IdcdlS47QzCIzxZjq5XdSepcQETKnSk+Dg0OivTPuAzpEmTbW+U0sN5q9tpKOjYRLoweAsnf97ZwRjBtAxgNGYBdsF+ilr7N2UP/Vzz4cFWK5JlmyqChKiFinUEWh7VZPpXti3bfJWD3Hd85hYj0e3nZokjjdScQka1nLP3XryfgYkwR9A=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76120541-816b-4358-eb45-08d81a22b96b
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 22:46:12.0399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JxOAjbBUl8nQ9c+hwFj6WsB1h+OCwJZaZ7ZDccHNlrr9g6Jf+EavUwsk3+XXx0zF+xmi6iNv8MOHnL0zxn4dHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3196
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qevents are attach points for TC blocks, where filters can be put that are
executed when "interesting events" take place in a qdisc. The data to keep
and the functions to invoke to maintain a qevent will be largely the same
between qevents. Therefore introduce sched-wide helpers for qevent
management.

Currently, similarly to ingress and egress blocks of clsact pseudo-qdisc,
blocks attachment cannot be changed after the qdisc is created. To that
end, add a helper tcf_qevent_validate_change(), which verifies whether
block index attribute is not attached, or if it is, whether its value
matches the current one (i.e. there is no material change).

The function tcf_qevent_handle() should be invoked when qdisc hits the
"interesting event" corresponding to a block. This function releases root
lock for the duration of executing the attached filters, to allow packets
generated through user actions (notably mirred) to be reinserted to the
same qdisc tree.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 include/net/pkt_cls.h |  49 +++++++++++++++++
 net/sched/cls_api.c   | 119 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 168 insertions(+)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index ed65619cbc47..b0e11bbb6d7a 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -32,6 +32,12 @@ struct tcf_block_ext_info {
 	u32 block_index;
 };
 
+struct tcf_qevent {
+	struct tcf_block	*block;
+	struct tcf_block_ext_info info;
+	struct tcf_proto __rcu *filter_chain;
+};
+
 struct tcf_block_cb;
 bool tcf_queue_work(struct rcu_work *rwork, work_func_t func);
 
@@ -552,6 +558,49 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
 			  void *cb_priv, u32 *flags, unsigned int *in_hw_count);
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
 
+#ifdef CONFIG_NET_CLS_ACT
+int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
+		    enum flow_block_binder_type binder_type,
+		    struct nlattr *block_index_attr,
+		    struct netlink_ext_ack *extack);
+void tcf_qevent_destroy(struct tcf_qevent *qe, struct Qdisc *sch);
+int tcf_qevent_validate_change(struct tcf_qevent *qe, struct nlattr *block_index_attr,
+			       struct netlink_ext_ack *extack);
+struct sk_buff *tcf_qevent_handle(struct tcf_qevent *qe, struct Qdisc *sch, struct sk_buff *skb,
+				  spinlock_t *root_lock, struct sk_buff **to_free, int *ret);
+int tcf_qevent_dump(struct sk_buff *skb, int attr_name, struct tcf_qevent *qe);
+#else
+static inline int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
+				  enum flow_block_binder_type binder_type,
+				  struct nlattr *block_index_attr,
+				  struct netlink_ext_ack *extack)
+{
+	return 0;
+}
+
+static inline void tcf_qevent_destroy(struct tcf_qevent *qe, struct Qdisc *sch)
+{
+}
+
+static inline int tcf_qevent_validate_change(struct tcf_qevent *qe, struct nlattr *block_index_attr,
+					     struct netlink_ext_ack *extack)
+{
+	return 0;
+}
+
+static inline struct sk_buff *
+tcf_qevent_handle(struct tcf_qevent *qe, struct Qdisc *sch, struct sk_buff *skb,
+		  spinlock_t *root_lock, struct sk_buff **to_free, int *ret)
+{
+	return skb;
+}
+
+static inline int tcf_qevent_dump(struct sk_buff *skb, int attr_name, struct tcf_qevent *qe)
+{
+	return 0;
+}
+#endif
+
 struct tc_cls_u32_knode {
 	struct tcf_exts *exts;
 	struct tcf_result *res;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index a00a203b2ef5..c594a6343be1 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3741,6 +3741,125 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
 }
 EXPORT_SYMBOL(tcf_exts_num_actions);
 
+#ifdef CONFIG_NET_CLS_ACT
+static int tcf_qevent_parse_block_index(struct nlattr *block_index_attr,
+					u32 *p_block_index,
+					struct netlink_ext_ack *extack)
+{
+	*p_block_index = nla_get_u32(block_index_attr);
+	if (!*p_block_index) {
+		NL_SET_ERR_MSG(extack, "Block number may not be zero");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
+		    enum flow_block_binder_type binder_type,
+		    struct nlattr *block_index_attr,
+		    struct netlink_ext_ack *extack)
+{
+	u32 block_index;
+	int err;
+
+	if (!block_index_attr)
+		return 0;
+
+	err = tcf_qevent_parse_block_index(block_index_attr, &block_index, extack);
+	if (err)
+		return err;
+
+	if (!block_index)
+		return 0;
+
+	qe->info.binder_type = binder_type;
+	qe->info.chain_head_change = tcf_chain_head_change_dflt;
+	qe->info.chain_head_change_priv = &qe->filter_chain;
+	qe->info.block_index = block_index;
+
+	return tcf_block_get_ext(&qe->block, sch, &qe->info, extack);
+}
+EXPORT_SYMBOL(tcf_qevent_init);
+
+void tcf_qevent_destroy(struct tcf_qevent *qe, struct Qdisc *sch)
+{
+	if (qe->info.block_index)
+		tcf_block_put_ext(qe->block, sch, &qe->info);
+}
+EXPORT_SYMBOL(tcf_qevent_destroy);
+
+int tcf_qevent_validate_change(struct tcf_qevent *qe, struct nlattr *block_index_attr,
+			       struct netlink_ext_ack *extack)
+{
+	u32 block_index;
+	int err;
+
+	if (!block_index_attr)
+		return 0;
+
+	err = tcf_qevent_parse_block_index(block_index_attr, &block_index, extack);
+	if (err)
+		return err;
+
+	/* Bounce newly-configured block or change in block. */
+	if (block_index != qe->info.block_index) {
+		NL_SET_ERR_MSG(extack, "Change of blocks is not supported");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(tcf_qevent_validate_change);
+
+struct sk_buff *tcf_qevent_handle(struct tcf_qevent *qe, struct Qdisc *sch, struct sk_buff *skb,
+				  spinlock_t *root_lock, struct sk_buff **to_free, int *ret)
+{
+	struct tcf_result cl_res;
+	struct tcf_proto *fl;
+
+	if (!qe->info.block_index)
+		return skb;
+
+	fl = rcu_dereference_bh(qe->filter_chain);
+
+	if (root_lock)
+		spin_unlock(root_lock);
+
+	switch (tcf_classify(skb, fl, &cl_res, false)) {
+	case TC_ACT_SHOT:
+		qdisc_qstats_drop(sch);
+		__qdisc_drop(skb, to_free);
+		*ret = __NET_XMIT_BYPASS;
+		return NULL;
+	case TC_ACT_STOLEN:
+	case TC_ACT_QUEUED:
+	case TC_ACT_TRAP:
+		__qdisc_drop(skb, to_free);
+		*ret = __NET_XMIT_STOLEN;
+		return NULL;
+	case TC_ACT_REDIRECT:
+		skb_do_redirect(skb);
+		*ret = __NET_XMIT_STOLEN;
+		return NULL;
+	}
+
+	if (root_lock)
+		spin_lock(root_lock);
+
+	return skb;
+}
+EXPORT_SYMBOL(tcf_qevent_handle);
+
+int tcf_qevent_dump(struct sk_buff *skb, int attr_name, struct tcf_qevent *qe)
+{
+	if (!qe->info.block_index)
+		return 0;
+	return nla_put_u32(skb, attr_name, qe->info.block_index);
+}
+EXPORT_SYMBOL(tcf_qevent_dump);
+#endif
+
 static __net_init int tcf_net_init(struct net *net)
 {
 	struct tcf_net *tn = net_generic(net, tcf_net_id);
-- 
2.20.1

