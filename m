Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF3543756B
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 12:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbhJVKbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 06:31:22 -0400
Received: from relay.sw.ru ([185.231.240.75]:57254 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232483AbhJVKbU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 06:31:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=XQ6Ahg85i45HJD/1pzC326y13kc7dgKywmzoKnkSAn8=; b=ZYlerleCmMyBLkC/HsF
        T+OpLAUDsBywovDRHJd6fHPdsNHfrGJk1ZqvJO5kTyAzqSrLl8kPC0cog00oK2lnccYVeUth+Sx2w
        mwxXREGc1fWsjwuyiQIpD5YTQQJ5h1L8lxPLnLS721GMO1R3qkjOzo2SkGb2Owv7sWbRiKJXo8Y=;
Received: from [172.29.1.17]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mdrnH-006pEx-4a; Fri, 22 Oct 2021 13:28:59 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH net v10] skb_expand_head() adjust skb->truesize incorrectly
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Christoph Paasch <christoph.paasch@gmail.com>,
        linux-kernel@vger.kernel.org, kernel@openvz.org
References: <2721362c-462b-878f-9e09-9f6c4353c73d@gmail.com>
Message-ID: <644330dd-477e-0462-83bf-9f514c41edd1@virtuozzo.com>
Date:   Fri, 22 Oct 2021 13:28:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <2721362c-462b-878f-9e09-9f6c4353c73d@gmail.com>
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
v10: is_skb_wmem() was moved into separate header (it depends on net/tcp.h)
     use it after pskb_expand_head() insted of strange sock_edemux check
v9: restored sock_edemux check
v8: clone non-wmem skb
v7 (from kuba@):
    shift more magic into helpers,
    follow Eric's advice and don't inherit non-wmem skbs for now
v6: fixed delta,
    improved comments
v5: fixed else condition, thanks to Eric
    reworked update of expanded skb,
    added corresponding comments
v4: decided to use is_skb_wmem() after pskb_expand_head() call
    fixed 'return (EXPRESSION);' in os_skb_wmem according to Eric
Dumazet
v3: removed __pskb_expand_head(),
    added is_skb_wmem() helper for skb with wmem-compatible destructors
    there are 2 ways to use it:
     - before pskb_expand_head(), to create skb clones
     - after successfull pskb_expand_head() to change owner on extended
       skb.
v2: based on patch version from Eric Dumazet,
    added __pskb_expand_head() function, which can be forced
    to adjust skb->truesize and sk->sk_wmem_alloc.

 net/core/skbuff.c          | 36 +++++++++++++++++++++++-------------
 net/core/sock_destructor.h | 12 ++++++++++++
 2 files changed, 35 insertions(+), 13 deletions(-)
 create mode 100644 net/core/sock_destructor.h

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2170bea2c7de..fe9358437380 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -80,6 +80,7 @@
 #include <linux/indirect_call_wrapper.h>
 
 #include "datagram.h"
+#include "sock_destructor.h"
 
 struct kmem_cache *skbuff_head_cache __ro_after_init;
 static struct kmem_cache *skbuff_fclone_cache __ro_after_init;
@@ -1804,30 +1805,39 @@ EXPORT_SYMBOL(skb_realloc_headroom);
 struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
 {
 	int delta = headroom - skb_headroom(skb);
+	int osize = skb_end_offset(skb);
+	struct sock *sk = skb->sk;
 
 	if (WARN_ONCE(delta <= 0,
 		      "%s is expecting an increase in the headroom", __func__))
 		return skb;
 
-	/* pskb_expand_head() might crash, if skb is shared */
-	if (skb_shared(skb)) {
+	delta = SKB_DATA_ALIGN(delta);
+	/* pskb_expand_head() might crash, if skb is shared. */
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
+	if (sk && is_skb_wmem(skb)) {
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
 
diff --git a/net/core/sock_destructor.h b/net/core/sock_destructor.h
new file mode 100644
index 000000000000..2f396e6bfba5
--- /dev/null
+++ b/net/core/sock_destructor.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _NET_CORE_SOCK_DESTRUCTOR_H
+#define _NET_CORE_SOCK_DESTRUCTOR_H
+#include <net/tcp.h>
+
+static inline bool is_skb_wmem(const struct sk_buff *skb)
+{
+	return skb->destructor == sock_wfree ||
+	       skb->destructor == __sock_wfree ||
+	       (IS_ENABLED(CONFIG_INET) && skb->destructor == tcp_wfree);
+}
+#endif
-- 
2.32.0

