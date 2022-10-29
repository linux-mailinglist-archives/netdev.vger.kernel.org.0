Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A23961244B
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 17:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiJ2Ppp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 11:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiJ2Ppg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 11:45:36 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A0E631F5
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 08:45:33 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-368994f4bc0so68307017b3.14
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 08:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g0AHcgeJMgNZ4n3AdqfRTyyatB/vb8dq3xY6apxYZtw=;
        b=Moume5WSxPCoXDv6vMh84saZJFh9im6u3KfhBuwrFJvRNP/9xEFjccDQg9+hVqPXWh
         dmRyogCz9djvB7X002POcX8E/Nkcx371iwsuQlV7+khuOr15Yk3LQZP/9kj9sF5hsPFZ
         lUMsz6PVPeT9B2wdcHN/jqK5QvJ/GssLxpv0UJPCx4OzJqPnDSkkrXe22NoiygzYg/E0
         3vy7gNkGnpl+d1AOzU+Nn/eGFpXw5qB7rfHsbPRYnXeLb7906BNSB1dWK6xkg7uaFeMk
         eQV7D5tl3pJrnNkptkBmjNzIIFaxsbsrPOBO2VzzWQwkk9HhnIitGaufxBL1/KRQDlSc
         +X+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g0AHcgeJMgNZ4n3AdqfRTyyatB/vb8dq3xY6apxYZtw=;
        b=TT/+WUsnoRNxFxciDdhGyrjAI/4SZ0wny/OO6jamPaoWdqL6lGsfkU5nf/YQIpMMKq
         aHLrRQJ0hm/ytOsEo5WZTvzmzMaKNbCrdG62IMMK7JbVqdZXaS27vnOk9c3XeUIsTeKM
         Qnfr/OGXfD8JsNKWplzGEuioQfNSochWMsXU9pSxxDRnwMowMe06bPVTT6zOzVc25Kwx
         ZzEPfcXSh3XboiVMzeEDT6hBWaujBJ/W2m0fEmk1sbKy7qNq1NoY87wkzYRzyqUUu3M6
         TQrMbirXgSzBV7pR+gqXmUxFy1oZjwfZ0h8cYBkWfT695IbrPSivOs7yDevsAd3mTWbo
         TXiQ==
X-Gm-Message-State: ACrzQf1IT8klaydQiCo8Zx9ALNJHe7c1MVvcnkdqhogPIhDjen+2NWH2
        cRGws1ny/NACKt6Qje+5FUHuslJEz3TQbQ==
X-Google-Smtp-Source: AMsMyM6CHbbpPRWjgfxARGXZ1UPn433IMVq/TRo0ITnyhGEb+GHG1LqM0TnejmGX0gDHY2gVNOq24KE/lhHKXQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:d93:0:b0:6c3:b9a9:c9c1 with SMTP id
 141-20020a250d93000000b006c3b9a9c9c1mr2ybn.103.1667058332262; Sat, 29 Oct
 2022 08:45:32 -0700 (PDT)
Date:   Sat, 29 Oct 2022 15:45:19 +0000
In-Reply-To: <20221029154520.2747444-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221029154520.2747444-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221029154520.2747444-5-edumazet@google.com>
Subject: [PATCH v2 net-next 4/5] net: dropreason: add SKB_DROP_REASON_FRAG_REASM_TIMEOUT
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Used to track skbs freed after a timeout happened
in a reassmbly unit.

Passing a @reason argument to inet_frag_rbtree_purge()
allows to use correct consumed status for frags
that have been successfully re-assembled.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/dropreason.h |  3 +++
 include/net/inet_frag.h  |  6 +++++-
 include/net/ipv6_frag.h  |  3 ++-
 net/ipv4/inet_fragment.c | 14 ++++++++++----
 net/ipv4/ip_fragment.c   |  6 ++++--
 5 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index 602d555a5f8392715ec03f85418ecb98926d0481..1d45a74148c305c6dd60408b98d3bf896dfcd599 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -69,6 +69,7 @@
 	FN(IP_INNOROUTES)		\
 	FN(PKT_TOO_BIG)			\
 	FN(DUP_FRAG)			\
+	FN(FRAG_REASM_TIMEOUT)		\
 	FNe(MAX)
 
 /**
@@ -303,6 +304,8 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_PKT_TOO_BIG,
 	/** @SKB_DROP_REASON_DUP_FRAG: duplicate fragment */
 	SKB_DROP_REASON_DUP_FRAG,
+	/** @SKB_DROP_REASON_FRAG_REASM_TIMEOUT: fragment reassembly timeout */
+	SKB_DROP_REASON_FRAG_REASM_TIMEOUT,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 0b0876610553fca80ca1ce8d53026265b316d052..b23ddec3cd5cd8303bd7dc38714c274df8a63993 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -7,6 +7,7 @@
 #include <linux/in6.h>
 #include <linux/rbtree_types.h>
 #include <linux/refcount.h>
+#include <net/dropreason.h>
 
 /* Per netns frag queues directory */
 struct fqdir {
@@ -34,12 +35,14 @@ struct fqdir {
  * @INET_FRAG_LAST_IN: final fragment has arrived
  * @INET_FRAG_COMPLETE: frag queue has been processed and is due for destruction
  * @INET_FRAG_HASH_DEAD: inet_frag_kill() has not removed fq from rhashtable
+ * @INET_FRAG_DROP: if skbs must be dropped (instead of being consumed)
  */
 enum {
 	INET_FRAG_FIRST_IN	= BIT(0),
 	INET_FRAG_LAST_IN	= BIT(1),
 	INET_FRAG_COMPLETE	= BIT(2),
 	INET_FRAG_HASH_DEAD	= BIT(3),
+	INET_FRAG_DROP		= BIT(4),
 };
 
 struct frag_v4_compare_key {
@@ -139,7 +142,8 @@ void inet_frag_destroy(struct inet_frag_queue *q);
 struct inet_frag_queue *inet_frag_find(struct fqdir *fqdir, void *key);
 
 /* Free all skbs in the queue; return the sum of their truesizes. */
-unsigned int inet_frag_rbtree_purge(struct rb_root *root);
+unsigned int inet_frag_rbtree_purge(struct rb_root *root,
+				    enum skb_drop_reason reason);
 
 static inline void inet_frag_put(struct inet_frag_queue *q)
 {
diff --git a/include/net/ipv6_frag.h b/include/net/ipv6_frag.h
index 5052c66e22d23604e698f93cf6328ca5863e4d07..7321ffe3a108c159490ae358b8c2cfca958055a4 100644
--- a/include/net/ipv6_frag.h
+++ b/include/net/ipv6_frag.h
@@ -76,6 +76,7 @@ ip6frag_expire_frag_queue(struct net *net, struct frag_queue *fq)
 	if (fq->q.flags & INET_FRAG_COMPLETE)
 		goto out;
 
+	fq->q.flags |= INET_FRAG_DROP;
 	inet_frag_kill(&fq->q);
 
 	dev = dev_get_by_index_rcu(net, fq->iif);
@@ -101,7 +102,7 @@ ip6frag_expire_frag_queue(struct net *net, struct frag_queue *fq)
 	spin_unlock(&fq->q.lock);
 
 	icmpv6_send(head, ICMPV6_TIME_EXCEED, ICMPV6_EXC_FRAGTIME, 0);
-	kfree_skb(head);
+	kfree_skb_reason(head, SKB_DROP_REASON_FRAG_REASM_TIMEOUT);
 	goto out_rcu_unlock;
 
 out:
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index c9f9ac5013a717ddbc403c7317aaa228b09f6a0c..7072fc0783ef56e59c886a2f2516e7db7d10c942 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -133,6 +133,7 @@ static void inet_frags_free_cb(void *ptr, void *arg)
 	count = del_timer_sync(&fq->timer) ? 1 : 0;
 
 	spin_lock_bh(&fq->lock);
+	fq->flags |= INET_FRAG_DROP;
 	if (!(fq->flags & INET_FRAG_COMPLETE)) {
 		fq->flags |= INET_FRAG_COMPLETE;
 		count++;
@@ -260,7 +261,8 @@ static void inet_frag_destroy_rcu(struct rcu_head *head)
 	kmem_cache_free(f->frags_cachep, q);
 }
 
-unsigned int inet_frag_rbtree_purge(struct rb_root *root)
+unsigned int inet_frag_rbtree_purge(struct rb_root *root,
+				    enum skb_drop_reason reason)
 {
 	struct rb_node *p = rb_first(root);
 	unsigned int sum = 0;
@@ -274,7 +276,7 @@ unsigned int inet_frag_rbtree_purge(struct rb_root *root)
 			struct sk_buff *next = FRAG_CB(skb)->next_frag;
 
 			sum += skb->truesize;
-			kfree_skb(skb);
+			kfree_skb_reason(skb, reason);
 			skb = next;
 		}
 	}
@@ -284,17 +286,21 @@ EXPORT_SYMBOL(inet_frag_rbtree_purge);
 
 void inet_frag_destroy(struct inet_frag_queue *q)
 {
-	struct fqdir *fqdir;
 	unsigned int sum, sum_truesize = 0;
+	enum skb_drop_reason reason;
 	struct inet_frags *f;
+	struct fqdir *fqdir;
 
 	WARN_ON(!(q->flags & INET_FRAG_COMPLETE));
+	reason = (q->flags & INET_FRAG_DROP) ?
+			SKB_DROP_REASON_FRAG_REASM_TIMEOUT :
+			SKB_CONSUMED;
 	WARN_ON(del_timer(&q->timer) != 0);
 
 	/* Release all fragment data. */
 	fqdir = q->fqdir;
 	f = fqdir->f;
-	sum_truesize = inet_frag_rbtree_purge(&q->rb_fragments);
+	sum_truesize = inet_frag_rbtree_purge(&q->rb_fragments, reason);
 	sum = sum_truesize + f->qsize;
 
 	call_rcu(&q->rcu, inet_frag_destroy_rcu);
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 676bd8d259555448457dfd98ce4316c4b549a30a..85e8113259c36881dd0153d9d68c818ebabccc0c 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -153,6 +153,7 @@ static void ip_expire(struct timer_list *t)
 	if (qp->q.flags & INET_FRAG_COMPLETE)
 		goto out;
 
+	qp->q.flags |= INET_FRAG_DROP;
 	ipq_kill(qp);
 	__IP_INC_STATS(net, IPSTATS_MIB_REASMFAILS);
 	__IP_INC_STATS(net, IPSTATS_MIB_REASMTIMEOUT);
@@ -194,7 +195,7 @@ static void ip_expire(struct timer_list *t)
 	spin_unlock(&qp->q.lock);
 out_rcu_unlock:
 	rcu_read_unlock();
-	kfree_skb(head);
+	kfree_skb_reason(head, SKB_DROP_REASON_FRAG_REASM_TIMEOUT);
 	ipq_put(qp);
 }
 
@@ -254,7 +255,8 @@ static int ip_frag_reinit(struct ipq *qp)
 		return -ETIMEDOUT;
 	}
 
-	sum_truesize = inet_frag_rbtree_purge(&qp->q.rb_fragments);
+	sum_truesize = inet_frag_rbtree_purge(&qp->q.rb_fragments,
+					      SKB_DROP_REASON_NOT_SPECIFIED);
 	sub_frag_mem_limit(qp->q.fqdir, sum_truesize);
 
 	qp->q.flags = 0;
-- 
2.38.1.273.g43a17bfeac-goog

