Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19BEA40FDD3
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 18:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242835AbhIQQZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 12:25:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229925AbhIQQZt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 12:25:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABF2361100;
        Fri, 17 Sep 2021 16:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631895866;
        bh=5KWQndG4p0DXH6K47zytg8Avj1HbjadJQvfWZGBdZVg=;
        h=From:To:Cc:Subject:Date:From;
        b=iAhm69a18nW/O93EkGbpJAPWt6O9onBYTl1KWZq7YpRruXBg6ovVfh/kPt/2oxRjr
         SOfZhX/ekJaVDcpcfQKRsqCzkOez4dwSdBKWUPQrrCypN+Vk/jL+fUzIE8S2Wkt0yt
         tdWE/fnqZZ0doNIe6Ph3op9/50x7SI8dYO8NAlnKKEF2NEG6VgRTbLv3ZRZzrGPakV
         Jmq+yQuMPYQDfqGhOoS6VqJ5vusEItHauPLOScGy0O75d5sPrD1JjLrouJjutzqa6U
         fcKQx9F6sFj+O0XoFcpjJKuebTCTUKQUiMZxVdJThx9AMBE0LLbcnDWu6s8vCFf+G8
         zvLBjIxPYPUvA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Christoph Paasch <christoph.paasch@gmail.com>,
        Hao Sun <sunhao.th@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net v7] net: skb_expand_head() adjust skb->truesize incorrectly
Date:   Fri, 17 Sep 2021 09:24:18 -0700
Message-Id: <20210917162418.1437772-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

Christoph Paasch reports [1] about incorrect skb->truesize
after skb_expand_head() call in ip6_xmit.
This may happen because of two reasons:
 - skb_set_owner_w() for newly cloned skb is called too early,
   before pskb_expand_head() where truesize is adjusted for (!skb-sk) case.
 - pskb_expand_head() does not adjust truesize in (skb->sk) case.
   In this case sk->sk_wmem_alloc should be adjusted too.

Eric cautions us against increasing sk_wmem_alloc if the old
skb did not hold any wmem references.

[1] https://lkml.org/lkml/2021/8/20/1082

Fixes: f1260ff15a71 ("skbuff: introduce skb_expand_head()")
Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
Reported-by: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v7: - shift more magic into helpers
    - follow Eric's advice and don't inherit non-wmem sks for now

Looks like we stalled here, let me try to push this forward.
This builds, is it possible to repro without syzcaller?
Anyone willing to test?
---
 include/net/sock.h |  2 ++
 net/core/skbuff.c  | 50 +++++++++++++++++++++++++++++++++++-----------
 net/core/sock.c    | 10 ++++++++++
 3 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 66a9a90f9558..102e3e1009d1 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1707,6 +1707,8 @@ void sock_pfree(struct sk_buff *skb);
 #define sock_edemux sock_efree
 #endif
 
+bool is_skb_wmem(const struct sk_buff *skb);
+
 int sock_setsockopt(struct socket *sock, int level, int op,
 		    sockptr_t optval, unsigned int optlen);
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7c2ab27fcbf9..5093321c2b65 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1786,6 +1786,24 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
 }
 EXPORT_SYMBOL(skb_realloc_headroom);
 
+static void skb_owner_inherit(struct sk_buff *nskb, struct sk_buff *oskb)
+{
+	if (is_skb_wmem(oskb))
+		skb_set_owner_w(nskb, oskb->sk);
+
+	/* handle rmem sock etc. as needed .. */
+}
+
+static void skb_increase_truesize(struct sk_buff *skb, unsigned int add)
+{
+	if (is_skb_wmem(skb))
+		refcount_add(add, &skb->sk->sk_wmem_alloc);
+	/* handle rmem sock etc. as needed .. */
+	WARN_ON(skb->destructor == sock_rfree);
+
+	skb->truesize += add;
+}
+
 /**
  *	skb_expand_head - reallocate header of &sk_buff
  *	@skb: buffer to reallocate
@@ -1801,6 +1819,7 @@ EXPORT_SYMBOL(skb_realloc_headroom);
 struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
 {
 	int delta = headroom - skb_headroom(skb);
+	int osize = skb_end_offset(skb);
 
 	if (WARN_ONCE(delta <= 0,
 		      "%s is expecting an increase in the headroom", __func__))
@@ -1810,21 +1829,28 @@ struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
 	if (skb_shared(skb)) {
 		struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
 
-		if (likely(nskb)) {
-			if (skb->sk)
-				skb_set_owner_w(nskb, skb->sk);
-			consume_skb(skb);
-		} else {
-			kfree_skb(skb);
-		}
+		if (unlikely(!nskb))
+			goto err_free;
+
+		skb_owner_inherit(nskb, skb);
+		consume_skb(skb);
 		skb = nskb;
 	}
-	if (skb &&
-	    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
-		kfree_skb(skb);
-		skb = NULL;
-	}
+
+	if (pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC))
+		goto err_free;
+	delta = skb_end_offset(skb) - osize;
+
+	/* pskb_expand_head() will adjust truesize itself for non-sk cases
+	 * todo: move the adjustment there at some point?
+	 */
+	if (skb->sk && skb->destructor != sock_edemux)
+		skb_increase_truesize(skb, delta);
+
 	return skb;
+err_free:
+	kfree_skb(skb);
+	return NULL;
 }
 EXPORT_SYMBOL(skb_expand_head);
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 62627e868e03..1483b4f755ef 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2227,6 +2227,16 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
 }
 EXPORT_SYMBOL(skb_set_owner_w);
 
+/* Should clones of this skb count towards skb->sk->sk_wmem_alloc
+ * and use sock_wfree() as their destructor?
+ */
+bool is_skb_wmem(const struct sk_buff *skb)
+{
+	return skb->destructor == sock_wfree ||
+		skb->destructor == __sock_wfree ||
+		(IS_ENABLED(CONFIG_INET) && skb->destructor == tcp_wfree);
+}
+
 static bool can_skb_orphan_partial(const struct sk_buff *skb)
 {
 #ifdef CONFIG_TLS_DEVICE
-- 
2.31.1

