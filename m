Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075F6609A33
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 08:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiJXGGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 02:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiJXGG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 02:06:28 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68F24E846;
        Sun, 23 Oct 2022 23:06:26 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1omqae-005UFA-Ab; Mon, 24 Oct 2022 14:06:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 24 Oct 2022 14:06:12 +0800
Date:   Mon, 24 Oct 2022 14:06:12 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <edumazet@google.com>
Cc:     syzbot <syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Subject: [v2 PATCH] af_key: Fix send_acquire race with pfkey_register
Message-ID: <Y1YrVGP+5TP7V1/R@gondor.apana.org.au>
References: <000000000000fd9a4005ebbeac67@google.com>
 <Y1YeSj2vwPvRAW61@gondor.apana.org.au>
 <CANn89i+41Whp=ACQo393s_wPx_MtWAZgL9DqG9aoLomN4ddwTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+41Whp=ACQo393s_wPx_MtWAZgL9DqG9aoLomN4ddwTg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 23, 2022 at 10:21:05PM -0700, Eric Dumazet wrote:
>
> Are you sure we can sleep in mutex_lock() ?
> 
> Use of GFP_ATOMIC would suggest otherwise :/

Good point.  Acquires are triggered from the network stack so
it may be in BH context.

---8<---
With name space support, it is possible for a pfkey_register to
occur in the middle of a send_acquire, thus changing the number
of supported algorithms.

This can be fixed by taking a lock to make it single-threaded
again.  As this lock can be taken from both thread and softirq
contexts, we need to take the necessary precausions with disabling
BH and make it a spin lock.

Reported-by: syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com
Fixes: 283bc9f35bbb ("xfrm: Namespacify xfrm state/policy locks")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/net/key/af_key.c b/net/key/af_key.c
index c85df5b958d2..4e0d21e2045e 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -23,6 +23,7 @@
 #include <linux/proc_fs.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/spinlock.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 #include <net/xfrm.h>
@@ -39,6 +40,7 @@ struct netns_pfkey {
 	atomic_t socks_nr;
 };
 static DEFINE_MUTEX(pfkey_mutex);
+static DEFINE_SPINLOCK(pfkey_alg_lock);
 
 #define DUMMY_MARK 0
 static const struct xfrm_mark dummy_mark = {0, 0};
@@ -1697,11 +1699,11 @@ static int pfkey_register(struct sock *sk, struct sk_buff *skb, const struct sad
 		pfk->registered |= (1<<hdr->sadb_msg_satype);
 	}
 
-	mutex_lock(&pfkey_mutex);
+	spin_lock_bh(&pfkey_alg_lock);
 	xfrm_probe_algs();
 
 	supp_skb = compose_sadb_supported(hdr, GFP_KERNEL | __GFP_ZERO);
-	mutex_unlock(&pfkey_mutex);
+	spin_unlock_bh(&pfkey_alg_lock);
 
 	if (!supp_skb) {
 		if (hdr->sadb_msg_satype != SADB_SATYPE_UNSPEC)
@@ -3160,6 +3162,7 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
 		(sockaddr_size * 2) +
 		sizeof(struct sadb_x_policy);
 
+	spin_lock_bh(&pfkey_alg_lock);
 	if (x->id.proto == IPPROTO_AH)
 		size += count_ah_combs(t);
 	else if (x->id.proto == IPPROTO_ESP)
@@ -3171,8 +3174,10 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
 	}
 
 	skb =  alloc_skb(size + 16, GFP_ATOMIC);
-	if (skb == NULL)
+	if (skb == NULL) {
+		spin_unlock_bh(&pfkey_alg_lock);
 		return -ENOMEM;
+	}
 
 	hdr = skb_put(skb, sizeof(struct sadb_msg));
 	hdr->sadb_msg_version = PF_KEY_V2;
@@ -3228,6 +3233,7 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
 		dump_ah_combs(skb, t);
 	else if (x->id.proto == IPPROTO_ESP)
 		dump_esp_combs(skb, t);
+	spin_unlock_bh(&pfkey_alg_lock);
 
 	/* security context */
 	if (xfrm_ctx) {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
