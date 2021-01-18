Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D5E2F994B
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 06:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731691AbhARFbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 00:31:04 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:13911 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731475AbhARFaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 00:30:55 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 2D75B5C15FF;
        Mon, 18 Jan 2021 13:18:48 +0800 (CST)
From:   wenxu@ucloud.cn
To:     marcelo.leitner@gmail.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] net/sched: cls_flower add CT_FLAGS_INVALID flag support
Date:   Mon, 18 Jan 2021 13:18:47 +0800
Message-Id: <1610947127-4412-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZQxhMGkgaGBlIThoaVkpNSktCT0xKSUNJQkhVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PzI6Ggw5Tj0wURU8SAo2MAkJ
        FB8aCTpVSlVKTUpLQk9MSklDT0xNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU5CQkg3Bg++
X-HM-Tid: 0a7713ee6b932087kuqy2d75b5c15ff
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch add the TCA_FLOWER_KEY_CT_FLAGS_INVALID flag to
match the ct_state with invalid for conntrack.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/linux/skbuff.h       |  4 ++--
 include/net/sch_generic.h    |  1 +
 include/uapi/linux/pkt_cls.h |  1 +
 net/core/dev.c               |  2 ++
 net/core/flow_dissector.c    | 13 +++++++++----
 net/sched/act_ct.c           |  1 +
 net/sched/cls_flower.c       |  6 +++++-
 7 files changed, 21 insertions(+), 7 deletions(-)

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
index 1319986..e8653d9 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -305,6 +305,9 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 	struct fl_flow_key skb_key;
 	struct fl_flow_mask *mask;
 	struct cls_fl_filter *f;
+	bool post_ct;
+
+	post_ct = qdisc_skb_cb(skb)->post_ct;
 
 	list_for_each_entry_rcu(mask, &head->masks, list) {
 		flow_dissector_init_keys(&skb_key.control, &skb_key.basic);
@@ -318,7 +321,8 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
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

