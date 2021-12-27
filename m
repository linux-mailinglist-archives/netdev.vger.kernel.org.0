Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579FA4803A1
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 20:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhL0TEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 14:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbhL0TEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 14:04:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0151EC061759;
        Mon, 27 Dec 2021 11:04:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D5EC61166;
        Mon, 27 Dec 2021 19:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C40C36AEA;
        Mon, 27 Dec 2021 19:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631863;
        bh=1S1pXxl8X8fzXObz19Z4j1I/DpxR1980B1Nvvn/jqeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dGKNImSsmkgFWCdsXzammpWKKgfirae92whktp17vwlZRwy3thdHFrpC0BuEhCeds
         vNvYn/VygeZ4qQ9IUhLzBtoESSHZbSsFayMHXRpLyN22kTnzgbL4AbgIgkFfwh2H3J
         z/y7T6zXD9y646zv0fim0WfGTntRCsAx0xP2GJbkNw/7IaRX7CVKeIRCUaYmfEsqC7
         wLo0eetgrtg1988M4PEtOWVFZecQA9It673MiSZHQuj7wikjOnCwrvz+/6xj8+rQsu
         WB4p8yhtdeWboz2md5l9K/pa2hQH9gMizVhzWM701Dc7KVI1qlY6XR1fnf9geZeyji
         XT2JLeJ6WnMzw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Blakey <paulb@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        edumazet@google.com, atenart@kernel.org,
        alexandr.lobakin@intel.com, weiwan@google.com, arnd@arndb.de,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/26] net/sched: Extend qdisc control block with tc control block
Date:   Mon, 27 Dec 2021 14:03:16 -0500
Message-Id: <20211227190327.1042326-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190327.1042326-1-sashal@kernel.org>
References: <20211227190327.1042326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

[ Upstream commit ec624fe740b416fb68d536b37fb8eef46f90b5c2 ]

BPF layer extends the qdisc control block via struct bpf_skb_data_end
and because of that there is no more room to add variables to the
qdisc layer control block without going over the skb->cb size.

Extend the qdisc control block with a tc control block,
and move all tc related variables to there as a pre-step for
extending the tc control block with additional members.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/pkt_sched.h   | 15 +++++++++++++++
 include/net/sch_generic.h |  2 --
 net/core/dev.c            |  8 ++++----
 net/sched/act_ct.c        | 14 +++++++-------
 net/sched/cls_api.c       |  6 ++++--
 net/sched/cls_flower.c    |  3 ++-
 net/sched/sch_frag.c      |  3 ++-
 7 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index bf79f3a890af2..05f18e81f3e87 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -193,4 +193,19 @@ static inline void skb_txtime_consumed(struct sk_buff *skb)
 	skb->tstamp = ktime_set(0, 0);
 }
 
+struct tc_skb_cb {
+	struct qdisc_skb_cb qdisc_cb;
+
+	u16 mru;
+	bool post_ct;
+};
+
+static inline struct tc_skb_cb *tc_skb_cb(const struct sk_buff *skb)
+{
+	struct tc_skb_cb *cb = (struct tc_skb_cb *)skb->cb;
+
+	BUILD_BUG_ON(sizeof(*cb) > sizeof_field(struct sk_buff, cb));
+	return cb;
+}
+
 #endif
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 8c2d611639fca..6e7cd00333577 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -440,8 +440,6 @@ struct qdisc_skb_cb {
 	};
 #define QDISC_CB_PRIV_LEN 20
 	unsigned char		data[QDISC_CB_PRIV_LEN];
-	u16			mru;
-	bool			post_ct;
 };
 
 typedef void tcf_chain_head_change_t(struct tcf_proto *tp_head, void *priv);
diff --git a/net/core/dev.c b/net/core/dev.c
index 91f53eeb0e79f..e0878a500aa92 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3934,8 +3934,8 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 		return skb;
 
 	/* qdisc_skb_cb(skb)->pkt_len was already set by the caller. */
-	qdisc_skb_cb(skb)->mru = 0;
-	qdisc_skb_cb(skb)->post_ct = false;
+	tc_skb_cb(skb)->mru = 0;
+	tc_skb_cb(skb)->post_ct = false;
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
 	switch (tcf_classify(skb, miniq->block, miniq->filter_list, &cl_res, false)) {
@@ -5088,8 +5088,8 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 	}
 
 	qdisc_skb_cb(skb)->pkt_len = skb->len;
-	qdisc_skb_cb(skb)->mru = 0;
-	qdisc_skb_cb(skb)->post_ct = false;
+	tc_skb_cb(skb)->mru = 0;
+	tc_skb_cb(skb)->post_ct = false;
 	skb->tc_at_ingress = 1;
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 90866ae45573a..98e248b9c0b17 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -690,10 +690,10 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 				   u8 family, u16 zone, bool *defrag)
 {
 	enum ip_conntrack_info ctinfo;
-	struct qdisc_skb_cb cb;
 	struct nf_conn *ct;
 	int err = 0;
 	bool frag;
+	u16 mru;
 
 	/* Previously seen (loopback)? Ignore. */
 	ct = nf_ct_get(skb, &ctinfo);
@@ -708,7 +708,7 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 		return err;
 
 	skb_get(skb);
-	cb = *qdisc_skb_cb(skb);
+	mru = tc_skb_cb(skb)->mru;
 
 	if (family == NFPROTO_IPV4) {
 		enum ip_defrag_users user = IP_DEFRAG_CONNTRACK_IN + zone;
@@ -722,7 +722,7 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 
 		if (!err) {
 			*defrag = true;
-			cb.mru = IPCB(skb)->frag_max_size;
+			mru = IPCB(skb)->frag_max_size;
 		}
 	} else { /* NFPROTO_IPV6 */
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
@@ -735,7 +735,7 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 
 		if (!err) {
 			*defrag = true;
-			cb.mru = IP6CB(skb)->frag_max_size;
+			mru = IP6CB(skb)->frag_max_size;
 		}
 #else
 		err = -EOPNOTSUPP;
@@ -744,7 +744,7 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 	}
 
 	if (err != -EINPROGRESS)
-		*qdisc_skb_cb(skb) = cb;
+		tc_skb_cb(skb)->mru = mru;
 	skb_clear_hash(skb);
 	skb->ignore_df = 1;
 	return err;
@@ -963,7 +963,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	tcf_action_update_bstats(&c->common, skb);
 
 	if (clear) {
-		qdisc_skb_cb(skb)->post_ct = false;
+		tc_skb_cb(skb)->post_ct = false;
 		ct = nf_ct_get(skb, &ctinfo);
 		if (ct) {
 			nf_conntrack_put(&ct->ct_general);
@@ -1048,7 +1048,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 out_push:
 	skb_push_rcsum(skb, nh_ofs);
 
-	qdisc_skb_cb(skb)->post_ct = true;
+	tc_skb_cb(skb)->post_ct = true;
 out_clear:
 	if (defrag)
 		qdisc_skb_cb(skb)->pkt_len = skb->len;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index e54f0a42270c1..ff8a9383bf1c4 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1617,12 +1617,14 @@ int tcf_classify(struct sk_buff *skb,
 
 	/* If we missed on some chain */
 	if (ret == TC_ACT_UNSPEC && last_executed_chain) {
+		struct tc_skb_cb *cb = tc_skb_cb(skb);
+
 		ext = tc_skb_ext_alloc(skb);
 		if (WARN_ON_ONCE(!ext))
 			return TC_ACT_SHOT;
 		ext->chain = last_executed_chain;
-		ext->mru = qdisc_skb_cb(skb)->mru;
-		ext->post_ct = qdisc_skb_cb(skb)->post_ct;
+		ext->mru = cb->mru;
+		ext->post_ct = cb->post_ct;
 	}
 
 	return ret;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index eb6345a027e13..161bd91c8c6b0 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -19,6 +19,7 @@
 
 #include <net/sch_generic.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 #include <net/ip.h>
 #include <net/flow_dissector.h>
 #include <net/geneve.h>
@@ -309,7 +310,7 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		       struct tcf_result *res)
 {
 	struct cls_fl_head *head = rcu_dereference_bh(tp->root);
-	bool post_ct = qdisc_skb_cb(skb)->post_ct;
+	bool post_ct = tc_skb_cb(skb)->post_ct;
 	struct fl_flow_key skb_key;
 	struct fl_flow_mask *mask;
 	struct cls_fl_filter *f;
diff --git a/net/sched/sch_frag.c b/net/sched/sch_frag.c
index 8c06381391d6f..5ded4c8672a64 100644
--- a/net/sched/sch_frag.c
+++ b/net/sched/sch_frag.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 #include <net/netlink.h>
 #include <net/sch_generic.h>
+#include <net/pkt_sched.h>
 #include <net/dst.h>
 #include <net/ip.h>
 #include <net/ip6_fib.h>
@@ -137,7 +138,7 @@ static int sch_fragment(struct net *net, struct sk_buff *skb,
 
 int sch_frag_xmit_hook(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb))
 {
-	u16 mru = qdisc_skb_cb(skb)->mru;
+	u16 mru = tc_skb_cb(skb)->mru;
 	int err;
 
 	if (mru && skb->len > mru + skb->dev->hard_header_len)
-- 
2.34.1

