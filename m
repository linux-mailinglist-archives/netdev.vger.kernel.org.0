Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7AB412858
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 23:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245079AbhITVpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 17:45:12 -0400
Received: from relay.sw.ru ([185.231.240.75]:36816 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231410AbhITVnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 17:43:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=iaWR+4csH3XbjqwDPZ9H83JOs8k0zel2izzxGA+L4jw=; b=m+3c9VtjwnBJLKpiMU5
        Eu6KEofV2PKAsRB9yqIj6ub8pZCOW0RoxkKggiizpvxpNSw6VWbKb3DSTL4ykdokDWvvpLtweVXDZ
        GL/4oLPYHbFo5CfzChKGqXMen5Cum9+Rnya7gyYRhWOekfWmVOhMphedM+sUy097qmkZTQKommc=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mSR2d-002eAC-5C; Tue, 21 Sep 2021 00:41:35 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH net v8] skb_expand_head() adjust skb->truesize incorrectly
To:     Christoph Paasch <christoph.paasch@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org, Julian Wiedmann <jwi@linux.ibm.com>
References: <20210920111259.18f9cc01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <be927ca4-6fd7-ce89-e472-bb1e5a0dc2a9@virtuozzo.com>
Date:   Tue, 21 Sep 2021 00:41:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210920111259.18f9cc01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Paasch reports [1] about incorrect skb->truesize
after skb_expand_head() call in ip6_xmit.
This may happen because of two reasons:
- skb_set_owner_w() for newly cloned skb is called too early,
before pskb_expand_head() where truesize is adjusted for (!skb-sk) case.
- pskb_expand_head() does not adjust truesize in (skb->sk) case.
In this case sk->sk_wmem_alloc should be adjusted too.

[1] https://lkml.org/lkml/2021/8/20/1082

Fixes: f1260ff15a71 ("skbuff: introduce skb_expand_head()")
Fixes: 2d85a1b31dde ("ipv6: ip6_finish_output2: set sk into newly allocated nskb")
Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
v8: clone non-wmem skb
V7 (from kuba@):
    shift more magic into helpers,
    follow Eric's advice and don't inherit non-wmem skbs for now
v6: fixed delta,
    improved comments
v5: fixed else condition, thanks to Eric
    reworked update of expanded skb,
    added corresponding comments
v4: decided to use is_skb_wmem() after pskb_expand_head() call
    fixed 'return (EXPRESSION);' in os_skb_wmem according to Eric Dumazet
v3: removed __pskb_expand_head(),
    added is_skb_wmem() helper for skb with wmem-compatible destructors
    there are 2 ways to use it:
     - before pskb_expand_head(), to create skb clones
     - after successfull pskb_expand_head() to change owner on extended skb.
v2: based on patch version from Eric Dumazet,
    added __pskb_expand_head() function, which can be forced
    to adjust skb->truesize and sk->sk_wmem_alloc.
---
 include/net/sock.h |  1 +
 net/core/skbuff.c  | 33 +++++++++++++++++++++------------
 net/core/sock.c    |  8 ++++++++
 3 files changed, 30 insertions(+), 12 deletions(-)

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
index f931176..4b49f63 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1804,30 +1804,39 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
 struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
 {
 	int delta = headroom - skb_headroom(skb);
+	int osize = skb_end_offset(skb);
+	struct sock *sk = skb->sk;
 
 	if (WARN_ONCE(delta <= 0,
 		      "%s is expecting an increase in the headroom", __func__))
 		return skb;
 
+	delta = SKB_DATA_ALIGN(delta);
 	/* pskb_expand_head() might crash, if skb is shared */
-	if (skb_shared(skb)) {
+	if (skb_shared(skb) || !is_skb_wmem(skb)) {
 		struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
 
-		if (likely(nskb)) {
-			if (skb->sk)
-				skb_set_owner_w(nskb, skb->sk);
-			consume_skb(skb);
-		} else {
-			kfree_skb(skb);
-		}
+		if (unlikely(!nskb))
+			goto fail;
+
+		if (sk)
+			skb_set_owner_w(nskb, sk);
+		consume_skb(skb);
 		skb = nskb;
 	}
-	if (skb &&
-	    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
-		kfree_skb(skb);
-		skb = NULL;
+	if (pskb_expand_head(skb, delta, 0, GFP_ATOMIC))
+		goto fail;
+
+	if (sk) {
+		delta = skb_end_offset(skb) - osize;
+		refcount_add(delta, &sk->sk_wmem_alloc);
+		skb->truesize += delta;
 	}
 	return skb;
+
+fail:
+	kfree_skb(skb);
+	return NULL;
 }
 EXPORT_SYMBOL(skb_expand_head);
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 950f1e7..6cbda43 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2227,6 +2227,14 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
 }
 EXPORT_SYMBOL(skb_set_owner_w);
 
+bool is_skb_wmem(const struct sk_buff *skb)
+{
+	return skb->destructor == sock_wfree ||
+	       skb->destructor == __sock_wfree ||
+	       (IS_ENABLED(CONFIG_INET) && skb->destructor == tcp_wfree);
+}
+EXPORT_SYMBOL(is_skb_wmem);
+
 static bool can_skb_orphan_partial(const struct sk_buff *skb)
 {
 #ifdef CONFIG_TLS_DEVICE
-- 
1.8.3.1

