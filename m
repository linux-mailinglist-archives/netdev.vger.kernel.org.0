Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27832FB429
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 09:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbhASIdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 03:33:09 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:27415 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730122AbhASIco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 03:32:44 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id DAEA45C15EE;
        Tue, 19 Jan 2021 16:31:50 +0800 (CST)
From:   wenxu@ucloud.cn
To:     marcelo.leitner@gmail.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2 net-next ] net/sched: cls_flower add CT_FLAGS_INVALID flag support
Date:   Tue, 19 Jan 2021 16:31:50 +0800
Message-Id: <1611045110-682-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZS01PQktDGE5NTEoZVkpNSkpLT05KSkpLS0lVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PzI6Hxw6Qj0wNhQyVhoSExwS
        FzxPCglVSlVKTUpKS09OSkpKSUpIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU1LSko3Bg++
X-HM-Tid: 0a7719c584872087kuqydaea45c15ee
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch add the TCA_FLOWER_KEY_CT_FLAGS_INVALID flag to
match the ct_state with invalid for conntrack.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v2:  initialize post_ct right on the declaration

 include/linux/skbuff.h       |  4 ++--
 include/net/sch_generic.h    |  1 +
 include/uapi/linux/pkt_cls.h |  1 +
 net/core/dev.c               |  2 ++
 net/core/flow_dissector.c    | 13 +++++++++----
 net/sched/act_ct.c           |  1 +
 net/sched/cls_flower.c       |  4 +++-
 7 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c9568cf..e22ccf0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1353,8 +1353,8 @@ void skb_flow_dissect_meta(const struct sk_buff *skb,
 skb_flow_dissect_ct(const struct sk_buff *skb,
 		    struct flow_dissector *flow_dissector,
 		    void *target_container,
-		    u16 *ctinfo_map,
-		    size_t mapsize);
+		    u16 *ctinfo_map, size_t mapsize,
+		    bool post_ct);
 void
 skb_flow_dissect_tunnel_info(const struct sk_buff *skb,
 			     struct flow_dissector *flow_dissector,
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 639e465..e7bee99 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -388,6 +388,7 @@ struct qdisc_skb_cb {
 #define QDISC_CB_PRIV_LEN 20
 	unsigned char		data[QDISC_CB_PRIV_LEN];
 	u16			mru;
+	bool			post_ct;
 };
 
 typedef void tcf_chain_head_change_t(struct tcf_proto *tp_head, void *priv);
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index ee95f42..709668e 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -591,6 +591,7 @@ enum {
 	TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED = 1 << 1, /* Part of an existing connection. */
 	TCA_FLOWER_KEY_CT_FLAGS_RELATED = 1 << 2, /* Related to an established connection. */
 	TCA_FLOWER_KEY_CT_FLAGS_TRACKED = 1 << 3, /* Conntrack has occurred. */
+	TCA_FLOWER_KEY_CT_FLAGS_INVALID = 1 << 4, /* Conntrack is invalid. */
 };
 
 enum {
diff --git a/net/core/dev.c b/net/core/dev.c
index bae35c1..9dce3f7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3878,6 +3878,7 @@ int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
 
 	/* qdisc_skb_cb(skb)->pkt_len was already set by the caller. */
 	qdisc_skb_cb(skb)->mru = 0;
+	qdisc_skb_cb(skb)->post_ct = false;
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
 	switch (tcf_classify(skb, miniq->filter_list, &cl_res, false)) {
@@ -4960,6 +4961,7 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
 
 	qdisc_skb_cb(skb)->pkt_len = skb->len;
 	qdisc_skb_cb(skb)->mru = 0;
+	qdisc_skb_cb(skb)->post_ct = false;
 	skb->tc_at_ingress = 1;
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 2d70ded..c565c7a 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -237,9 +237,8 @@ void skb_flow_dissect_meta(const struct sk_buff *skb,
 void
 skb_flow_dissect_ct(const struct sk_buff *skb,
 		    struct flow_dissector *flow_dissector,
-		    void *target_container,
-		    u16 *ctinfo_map,
-		    size_t mapsize)
+		    void *target_container, u16 *ctinfo_map,
+		    size_t mapsize, bool post_ct)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	struct flow_dissector_key_ct *key;
@@ -251,13 +250,19 @@ void skb_flow_dissect_meta(const struct sk_buff *skb,
 		return;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct)
+	if (!ct && !post_ct)
 		return;
 
 	key = skb_flow_dissector_target(flow_dissector,
 					FLOW_DISSECTOR_KEY_CT,
 					target_container);
 
+	if (!ct) {
+		key->ct_state = TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
+				TCA_FLOWER_KEY_CT_FLAGS_INVALID;
+		return;
+	}
+
 	if (ctinfo < mapsize)
 		key->ct_state = ctinfo_map[ctinfo];
 #if IS_ENABLED(CONFIG_NF_CONNTRACK_ZONES)
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 83a5c67..b344207 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1030,6 +1030,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 
 out:
 	tcf_action_update_bstats(&c->common, skb);
+	qdisc_skb_cb(skb)->post_ct = true;
 	if (defrag)
 		qdisc_skb_cb(skb)->pkt_len = skb->len;
 	return retval;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 1319986..0dcb5a0 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -302,6 +302,7 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		       struct tcf_result *res)
 {
 	struct cls_fl_head *head = rcu_dereference_bh(tp->root);
+	bool post_ct = qdisc_skb_cb(skb)->post_ct;
 	struct fl_flow_key skb_key;
 	struct fl_flow_mask *mask;
 	struct cls_fl_filter *f;
@@ -318,7 +319,8 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		skb_flow_dissect_tunnel_info(skb, &mask->dissector, &skb_key);
 		skb_flow_dissect_ct(skb, &mask->dissector, &skb_key,
 				    fl_ct_info_to_flower_map,
-				    ARRAY_SIZE(fl_ct_info_to_flower_map));
+				    ARRAY_SIZE(fl_ct_info_to_flower_map),
+				    post_ct);
 		skb_flow_dissect_hash(skb, &mask->dissector, &skb_key);
 		skb_flow_dissect(skb, &mask->dissector, &skb_key, 0);
 
-- 
1.8.3.1

