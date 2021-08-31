Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C283FC9DF
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 16:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238332AbhHaOf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 10:35:26 -0400
Received: from relay.sw.ru ([185.231.240.75]:45648 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234845AbhHaOfZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 10:35:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=3y3a0G9JOqOLl1XXFRKNLkkT/vIWt1LlgMq53mTUC6U=; b=brfqHMCWyeI/RD7xYkr
        xGsXMqL2DGVgLzdz2FU3T7mFop2/m3hjmnbijJkNizAt+K588YQWRpZzm4hqGw+HIFyeIZJOB0v9o
        ly199lwEOKmgyg/PlQsJmexvrAOX+uynpqzvbnapaLfDBFolsv9EgFQJQU5QoT881/uvRrbjLWY=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mL4qB-000N5z-W4; Tue, 31 Aug 2021 17:34:19 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH net-next v3 RFC] skb_expand_head() adjust skb->truesize
 incorrectly
To:     Christoph Paasch <christoph.paasch@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
References: <8fd56805-2ac8-dcbe-1337-b20f91f759d6@gmail.com>
Message-ID: <b66d9db6-f0ac-48a9-8062-49d6a5249d4b@virtuozzo.com>
Date:   Tue, 31 Aug 2021 17:34:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <8fd56805-2ac8-dcbe-1337-b20f91f759d6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC because it have an extra changes:
new is_skb_wmem() helper can be called
 - either before pskb_expand_head(), to create skb clones 
    for skb with destructors that does not change sk->sk_wmem_alloc
 - or after pskb_expand_head(), to change owner in skb_set_owner_w()

In current patch I've added both these ways,
we need to keep one of them.
---
Christoph Paasch reports [1] about incorrect skb->truesize
after skb_expand_head() call in ip6_xmit.
This may happen because of two reasons:
- skb_set_owner_w() for newly cloned skb is called too early,
before pskb_expand_head() where truesize is adjusted for (!skb-sk) case.
- pskb_expand_head() does not adjust truesize in (skb->sk) case.
In this case sk->sk_wmem_alloc should be adjusted too.

[1] https://lkml.org/lkml/2021/8/20/1082

Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
v3: removed __pskb_expand_head(),
    added is_skb_wmem() helper for skb with wmem-compatible destructors
    there are 2 ways to use it:
     - before pskb_expand_head(), to create skb clones
     - after pskb_expand_head(), to change owner on extended skb.
v2: based on patch version from Eric Dumazet,
    added __pskb_expand_head() function, which can be forced
    to adjust skb->truesize and sk->sk_wmem_alloc.
---
 include/net/sock.h |  1 +
 net/core/skbuff.c  | 39 ++++++++++++++++++++++++++++-----------
 net/core/sock.c    |  8 ++++++++
 3 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 95b2577..173d58c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1695,6 +1695,7 @@ struct sk_buff *sock_wmalloc(struct sock *sk, unsigned long size, int force,
 			     gfp_t priority);
 void __sock_wfree(struct sk_buff *skb);
 void sock_wfree(struct sk_buff *skb);
+bool is_skb_wmem(const struct sk_buff *skb);
 struct sk_buff *sock_omalloc(struct sock *sk, unsigned long size,
 			     gfp_t priority);
 void skb_orphan_partial(struct sk_buff *skb);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f931176..3ce33f2 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1804,30 +1804,47 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
 struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
 {
 	int delta = headroom - skb_headroom(skb);
+	int osize = skb_end_offset(skb);
+	struct sk_buff *oskb = NULL;
+	struct sock *sk = skb->sk;
 
 	if (WARN_ONCE(delta <= 0,
 		      "%s is expecting an increase in the headroom", __func__))
 		return skb;
 
-	/* pskb_expand_head() might crash, if skb is shared */
-	if (skb_shared(skb)) {
+	delta = SKB_DATA_ALIGN(delta);
+	/* pskb_expand_head() might crash, if skb is shared.
+	 * Also we should clone skb if its destructor does
+	 * not adjust skb->truesize and sk->sk_wmem_alloc
+ 	 */
+	if (skb_shared(skb) ||
+	    (sk && (!sk_fullsock(sk) || !is_skb_wmem(skb)))) {
 		struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
 
-		if (likely(nskb)) {
-			if (skb->sk)
-				skb_set_owner_w(nskb, skb->sk);
-			consume_skb(skb);
-		} else {
+		if (unlikely(!nskb)) {
 			kfree_skb(skb);
+			return NULL;
 		}
+		oskb = skb;
 		skb = nskb;
 	}
-	if (skb &&
-	    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
+	if (pskb_expand_head(skb, delta, 0, GFP_ATOMIC)) {
 		kfree_skb(skb);
-		skb = NULL;
+		kfree_skb(oskb);
+		return NULL;
 	}
-	return skb;
+	if (oskb) {
+		if (sk)
+			skb_set_owner_w(skb, sk);
+		consume_skb(oskb);
+	} else if (sk) {
+		delta = osize - skb_end_offset(skb);
+		if (!is_skb_wmem(skb))
+			skb_set_owner_w(skb, sk);
+		skb->truesize += delta;
+		if (sk_fullsock(sk))
+			refcount_add(delta, &sk->sk_wmem_alloc);
+	}	return skb;
 }
 EXPORT_SYMBOL(skb_expand_head);
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 950f1e7..0315dcb 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2227,6 +2227,14 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
 }
 EXPORT_SYMBOL(skb_set_owner_w);
 
+bool is_skb_wmem(const struct sk_buff *skb)
+{
+	return (skb->destructor == sock_wfree ||
+		skb->destructor == __sock_wfree ||
+		(IS_ENABLED(CONFIG_INET) && skb->destructor == tcp_wfree));
+}
+EXPORT_SYMBOL(is_skb_wmem);
+
 static bool can_skb_orphan_partial(const struct sk_buff *skb)
 {
 #ifdef CONFIG_TLS_DEVICE
-- 
1.8.3.1

