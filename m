Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71756099A7
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 07:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiJXFKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 01:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiJXFKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 01:10:47 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA59363360;
        Sun, 23 Oct 2022 22:10:46 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ompin-005Tir-QH; Mon, 24 Oct 2022 13:10:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 24 Oct 2022 13:10:34 +0800
Date:   Mon, 24 Oct 2022 13:10:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     syzbot <syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com
Subject: [PATCH] af_key: Fix send_acquire race with pfkey_register
Message-ID: <Y1YeSj2vwPvRAW61@gondor.apana.org.au>
References: <000000000000fd9a4005ebbeac67@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000fd9a4005ebbeac67@google.com>
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With name space support, it is possible for a pfkey_register to
occur in the middle of a send_acquire, thus changing the number
of supported algorithms.

This can be fixed by taking a mutex to make it single-threaded
again.

Reported-by: syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com
Fixes: 283bc9f35bbb ("xfrm: Namespacify xfrm state/policy locks")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/net/key/af_key.c b/net/key/af_key.c
index c85df5b958d2..4ceef96fef57 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3160,6 +3160,7 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
 		(sockaddr_size * 2) +
 		sizeof(struct sadb_x_policy);
 
+	mutex_lock(&pfkey_mutex);
 	if (x->id.proto == IPPROTO_AH)
 		size += count_ah_combs(t);
 	else if (x->id.proto == IPPROTO_ESP)
@@ -3171,8 +3172,10 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
 	}
 
 	skb =  alloc_skb(size + 16, GFP_ATOMIC);
-	if (skb == NULL)
+	if (skb == NULL) {
+		mutex_unlock(&pfkey_mutex);
 		return -ENOMEM;
+	}
 
 	hdr = skb_put(skb, sizeof(struct sadb_msg));
 	hdr->sadb_msg_version = PF_KEY_V2;
@@ -3228,6 +3231,7 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
 		dump_ah_combs(skb, t);
 	else if (x->id.proto == IPPROTO_ESP)
 		dump_esp_combs(skb, t);
+	mutex_unlock(&pfkey_mutex);
 
 	/* security context */
 	if (xfrm_ctx) {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
