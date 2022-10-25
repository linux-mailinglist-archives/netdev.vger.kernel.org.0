Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE8B60C39D
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 08:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbiJYGHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 02:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbiJYGHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 02:07:06 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A9EABD4D;
        Mon, 24 Oct 2022 23:07:05 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1onD4l-0064BC-Tl; Tue, 25 Oct 2022 14:06:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 25 Oct 2022 14:06:48 +0800
Date:   Tue, 25 Oct 2022 14:06:48 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Subject: [v3 PATCH] af_key: Fix send_acquire race with pfkey_register
Message-ID: <Y1d8+FdfgtVCaTDS@gondor.apana.org.au>
References: <000000000000fd9a4005ebbeac67@google.com>
 <Y1YeSj2vwPvRAW61@gondor.apana.org.au>
 <CANn89i+41Whp=ACQo393s_wPx_MtWAZgL9DqG9aoLomN4ddwTg@mail.gmail.com>
 <Y1YrVGP+5TP7V1/R@gondor.apana.org.au>
 <Y1Y8oN5xcIoMu+SH@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1Y8oN5xcIoMu+SH@hog>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 09:20:00AM +0200, Sabrina Dubroca wrote:
> 2022-10-24, 14:06:12 +0800, Herbert Xu wrote:
> > @@ -1697,11 +1699,11 @@ static int pfkey_register(struct sock *sk, struct sk_buff *skb, const struct sad
> >  		pfk->registered |= (1<<hdr->sadb_msg_satype);
> >  	}
> >  
> > -	mutex_lock(&pfkey_mutex);
> > +	spin_lock_bh(&pfkey_alg_lock);
> >  	xfrm_probe_algs();
> 
> I don't think we can do that:
> 
> void xfrm_probe_algs(void)
> {
> 	int i, status;
> 
> 	BUG_ON(in_softirq());

Indeed.  I was also wrong in stating that this bug was created by
namespaces.  This race has always existed since this code was first
added.

---8<---
The function pfkey_send_acquire may race with pfkey_register
(which could even be in a different name space).  This may result
in a buffer overrun.

Allocating the maximum amount of memory that could be used prevents
this.

Reported-by: syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/net/key/af_key.c b/net/key/af_key.c
index c85df5b958d2..213287814328 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2905,7 +2905,7 @@ static int count_ah_combs(const struct xfrm_tmpl *t)
 			break;
 		if (!aalg->pfkey_supported)
 			continue;
-		if (aalg_tmpl_set(t, aalg) && aalg->available)
+		if (aalg_tmpl_set(t, aalg))
 			sz += sizeof(struct sadb_comb);
 	}
 	return sz + sizeof(struct sadb_prop);
@@ -2923,7 +2923,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 		if (!ealg->pfkey_supported)
 			continue;
 
-		if (!(ealg_tmpl_set(t, ealg) && ealg->available))
+		if (!(ealg_tmpl_set(t, ealg)))
 			continue;
 
 		for (k = 1; ; k++) {
@@ -2934,16 +2934,17 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 			if (!aalg->pfkey_supported)
 				continue;
 
-			if (aalg_tmpl_set(t, aalg) && aalg->available)
+			if (aalg_tmpl_set(t, aalg))
 				sz += sizeof(struct sadb_comb);
 		}
 	}
 	return sz + sizeof(struct sadb_prop);
 }
 
-static void dump_ah_combs(struct sk_buff *skb, const struct xfrm_tmpl *t)
+static int dump_ah_combs(struct sk_buff *skb, const struct xfrm_tmpl *t)
 {
 	struct sadb_prop *p;
+	int sz = 0;
 	int i;
 
 	p = skb_put(skb, sizeof(struct sadb_prop));
@@ -2971,13 +2972,17 @@ static void dump_ah_combs(struct sk_buff *skb, const struct xfrm_tmpl *t)
 			c->sadb_comb_soft_addtime = 20*60*60;
 			c->sadb_comb_hard_usetime = 8*60*60;
 			c->sadb_comb_soft_usetime = 7*60*60;
+			sz += sizeof(*c);
 		}
 	}
+
+	return sz + sizeof(*p);
 }
 
-static void dump_esp_combs(struct sk_buff *skb, const struct xfrm_tmpl *t)
+static int dump_esp_combs(struct sk_buff *skb, const struct xfrm_tmpl *t)
 {
 	struct sadb_prop *p;
+	int sz = 0;
 	int i, k;
 
 	p = skb_put(skb, sizeof(struct sadb_prop));
@@ -3019,8 +3024,11 @@ static void dump_esp_combs(struct sk_buff *skb, const struct xfrm_tmpl *t)
 			c->sadb_comb_soft_addtime = 20*60*60;
 			c->sadb_comb_hard_usetime = 8*60*60;
 			c->sadb_comb_soft_usetime = 7*60*60;
+			sz += sizeof(*c);
 		}
 	}
+
+	return sz + sizeof(*p);
 }
 
 static int key_notify_policy_expire(struct xfrm_policy *xp, const struct km_event *c)
@@ -3150,6 +3158,7 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
 	struct sadb_x_sec_ctx *sec_ctx;
 	struct xfrm_sec_ctx *xfrm_ctx;
 	int ctx_size = 0;
+	int alg_size = 0;
 
 	sockaddr_size = pfkey_sockaddr_size(x->props.family);
 	if (!sockaddr_size)
@@ -3161,16 +3170,16 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
 		sizeof(struct sadb_x_policy);
 
 	if (x->id.proto == IPPROTO_AH)
-		size += count_ah_combs(t);
+		alg_size = count_ah_combs(t);
 	else if (x->id.proto == IPPROTO_ESP)
-		size += count_esp_combs(t);
+		alg_size = count_esp_combs(t);
 
 	if ((xfrm_ctx = x->security)) {
 		ctx_size = PFKEY_ALIGN8(xfrm_ctx->ctx_len);
 		size +=  sizeof(struct sadb_x_sec_ctx) + ctx_size;
 	}
 
-	skb =  alloc_skb(size + 16, GFP_ATOMIC);
+	skb =  alloc_skb(size + alg_size + 16, GFP_ATOMIC);
 	if (skb == NULL)
 		return -ENOMEM;
 
@@ -3224,10 +3233,13 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
 	pol->sadb_x_policy_priority = xp->priority;
 
 	/* Set sadb_comb's. */
+	alg_size = 0;
 	if (x->id.proto == IPPROTO_AH)
-		dump_ah_combs(skb, t);
+		alg_size = dump_ah_combs(skb, t);
 	else if (x->id.proto == IPPROTO_ESP)
-		dump_esp_combs(skb, t);
+		alg_size = dump_esp_combs(skb, t);
+
+	hdr->sadb_msg_len += alg_size / 8;
 
 	/* security context */
 	if (xfrm_ctx) {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
