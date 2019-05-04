Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A98FF13C47
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 01:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfEDXtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 19:49:04 -0400
Received: from mail-yw1-f74.google.com ([209.85.161.74]:39505 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbfEDXtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 19:49:04 -0400
Received: by mail-yw1-f74.google.com with SMTP id w191so9251074ywa.6
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 16:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=h0Pt/9lEwrh3d5QSnSYV/ZhPhdQkpSWEqHqfwmBDnHQ=;
        b=I4SPw9StK76EF43NRm2dF60q2x6KfGH5enIThnNHerwov0ZcPaMBvB6F94JRMVkNy2
         /qL3TnCAV2xIkkm24Y1HWduX35Xy4luDKK9GFYBoRRmWWmfO9/fHR6FdV6Ii4oB5773Z
         d8J6xaY/N9ltGiE2QpPvonvNpMphYhJI798Cx3gAgvpAec1gX7MNyuxignj0TCqAPb8H
         5eAZRbyTirNeZ8EfSsRLcaWw0EfTHgWFBIstxO/fOI9dAW3qzR7aPXJJzYbs0sEIFyMm
         zorTOVp7gt/23m2VbhtADlVDoNNFyvHRz2MyFwvr/qZfxdIXc9fIR95XcTUE1am2kgSQ
         14TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=h0Pt/9lEwrh3d5QSnSYV/ZhPhdQkpSWEqHqfwmBDnHQ=;
        b=Pl43Bj3WiVcOitYPrUVb8Z+KEcQGuBfPI2YFkjqfT5I6H0BQ8ePZP6Usg3UVzswSEr
         LCez3R4EvU75if4BHZ5oMFjQzb4Gfqq9o7BDQa16CQ6QnIHOBJimgm9hJshdLZkuzLOl
         HQwLd7P7lOJ6lIlR7mzWjVdQ+Z6vzbXeQy6MtRpVX/tK/1cSzmp1K2HkNFW+a+S2dJY9
         rlauP2NYxNdWzPTiYprqQahGm44dbl35YXxvcmD9tU90wBI+z5nk5O8NxGc1GzyRNtJS
         y8qa4WTAVA+4+wvLqz3kb8eHa4hR3Q3LUj5TiLDbLoc+HvyPHIe5thF4IcOefLKF2mUZ
         5SKA==
X-Gm-Message-State: APjAAAVMEFUfwdC25HPxVeNm1NOM58W8ZL5rIEev78MOLclpqPeqCoNz
        4YBe40zDFUQxaGdFde9JVHlsSvVLmzYmpQ==
X-Google-Smtp-Source: APXvYqwxe3lyqkLznRddlDf9hDthS9tT4sVu/pVZUPtSIjByMNPP9pALuYimKUyEptF3RlpZD775jp1AqUbi4A==
X-Received: by 2002:a0d:c703:: with SMTP id j3mr12278274ywd.469.1557013742590;
 Sat, 04 May 2019 16:49:02 -0700 (PDT)
Date:   Sat,  4 May 2019 16:48:53 -0700
In-Reply-To: <20190504234854.57812-1-edumazet@google.com>
Message-Id: <20190504234854.57812-2-edumazet@google.com>
Mime-Version: 1.0
References: <20190504234854.57812-1-edumazet@google.com>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH net-next 1/2] net_sched: sch_fq: do not assume EDT packets are ordered
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCP stack makes sure packets for a given flow are monotically
increasing, but we want to allow UDP packets to use EDT as
well, so that QUIC servers can use in-kernel pacing.

This patch adds a per-flow rb-tree on which packets might
be stored. We still try to use the linear list for the
typical cases where packets are queued with monotically
increasing skb->tstamp, since queue/dequeue packets on
a standard list is O(1).

Note that the ability to store packets in arbitrary EDT
order will allow us to implement later a per TCP socket
mechanism adding delays (with jitter eventually) and reorders,
to implement convenient network emulators.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/sch_fq.c | 95 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 83 insertions(+), 12 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index d107c74767cd1d3258b7f038c0c3176db589a51f..ee138365ec45ee01cb10f149ae5b1d7635fa1185 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -54,10 +54,23 @@
 #include <net/tcp_states.h>
 #include <net/tcp.h>
 
+struct fq_skb_cb {
+	u64	        time_to_send;
+};
+
+static inline struct fq_skb_cb *fq_skb_cb(struct sk_buff *skb)
+{
+	qdisc_cb_private_validate(skb, sizeof(struct fq_skb_cb));
+	return (struct fq_skb_cb *)qdisc_skb_cb(skb)->data;
+}
+
 /*
- * Per flow structure, dynamically allocated
+ * Per flow structure, dynamically allocated.
+ * If packets have monotically increasing time_to_send, they are placed in O(1)
+ * in linear list (head,tail), otherwise are placed in a rbtree (t_root).
  */
 struct fq_flow {
+	struct rb_root	t_root;
 	struct sk_buff	*head;		/* list of skbs for this flow : first skb */
 	union {
 		struct sk_buff *tail;	/* last skb in the list */
@@ -298,6 +311,8 @@ static struct fq_flow *fq_classify(struct sk_buff *skb, struct fq_sched_data *q)
 		q->stat_allocation_errors++;
 		return &q->internal;
 	}
+	/* f->t_root is already zeroed after kmem_cache_zalloc() */
+
 	fq_flow_set_detached(f);
 	f->sk = sk;
 	if (skb->sk)
@@ -312,14 +327,40 @@ static struct fq_flow *fq_classify(struct sk_buff *skb, struct fq_sched_data *q)
 	return f;
 }
 
+static struct sk_buff *fq_peek(struct fq_flow *flow)
+{
+	struct sk_buff *skb = skb_rb_first(&flow->t_root);
+	struct sk_buff *head = flow->head;
+
+	if (!skb)
+		return head;
+
+	if (!head)
+		return skb;
+
+	if (fq_skb_cb(skb)->time_to_send < fq_skb_cb(head)->time_to_send)
+		return skb;
+	return head;
+}
+
+static void fq_erase_head(struct Qdisc *sch, struct fq_flow *flow,
+			  struct sk_buff *skb)
+{
+	if (skb == flow->head) {
+		flow->head = skb->next;
+	} else {
+		rb_erase(&skb->rbnode, &flow->t_root);
+		skb->dev = qdisc_dev(sch);
+	}
+}
 
 /* remove one skb from head of flow queue */
 static struct sk_buff *fq_dequeue_head(struct Qdisc *sch, struct fq_flow *flow)
 {
-	struct sk_buff *skb = flow->head;
+	struct sk_buff *skb = fq_peek(flow);
 
 	if (skb) {
-		flow->head = skb->next;
+		fq_erase_head(sch, flow, skb);
 		skb_mark_not_on_list(skb);
 		flow->qlen--;
 		qdisc_qstats_backlog_dec(sch, skb);
@@ -330,15 +371,36 @@ static struct sk_buff *fq_dequeue_head(struct Qdisc *sch, struct fq_flow *flow)
 
 static void flow_queue_add(struct fq_flow *flow, struct sk_buff *skb)
 {
-	struct sk_buff *head = flow->head;
+	struct rb_node **p, *parent;
+	struct sk_buff *head, *aux;
 
-	skb->next = NULL;
-	if (!head)
-		flow->head = skb;
-	else
-		flow->tail->next = skb;
+	fq_skb_cb(skb)->time_to_send = skb->tstamp ?: ktime_get_ns();
 
-	flow->tail = skb;
+	head = flow->head;
+	if (!head ||
+	    fq_skb_cb(skb)->time_to_send >= fq_skb_cb(flow->tail)->time_to_send) {
+		if (!head)
+			flow->head = skb;
+		else
+			flow->tail->next = skb;
+		flow->tail = skb;
+		skb->next = NULL;
+		return;
+	}
+
+	p = &flow->t_root.rb_node;
+	parent = NULL;
+
+	while (*p) {
+		parent = *p;
+		aux = rb_to_skb(parent);
+		if (fq_skb_cb(skb)->time_to_send >= fq_skb_cb(aux)->time_to_send)
+			p = &parent->rb_right;
+		else
+			p = &parent->rb_left;
+	}
+	rb_link_node(&skb->rbnode, parent, p);
+	rb_insert_color(&skb->rbnode, &flow->t_root);
 }
 
 static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
@@ -450,9 +512,9 @@ static struct sk_buff *fq_dequeue(struct Qdisc *sch)
 		goto begin;
 	}
 
-	skb = f->head;
+	skb = fq_peek(f);
 	if (skb) {
-		u64 time_next_packet = max_t(u64, ktime_to_ns(skb->tstamp),
+		u64 time_next_packet = max_t(u64, fq_skb_cb(skb)->time_to_send,
 					     f->time_next_packet);
 
 		if (now < time_next_packet) {
@@ -533,6 +595,15 @@ static struct sk_buff *fq_dequeue(struct Qdisc *sch)
 
 static void fq_flow_purge(struct fq_flow *flow)
 {
+	struct rb_node *p = rb_first(&flow->t_root);
+
+	while (p) {
+		struct sk_buff *skb = rb_to_skb(p);
+
+		p = rb_next(p);
+		rb_erase(&skb->rbnode, &flow->t_root);
+		rtnl_kfree_skbs(skb, skb);
+	}
 	rtnl_kfree_skbs(flow->head, flow->tail);
 	flow->head = NULL;
 	flow->qlen = 0;
-- 
2.21.0.1020.gf2820cf01a-goog

