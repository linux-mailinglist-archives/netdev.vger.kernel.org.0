Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0FA589A41
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 12:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239184AbiHDKEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 06:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiHDKEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 06:04:06 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4F96435;
        Thu,  4 Aug 2022 03:04:04 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oJXhi-007m61-LH; Thu, 04 Aug 2022 20:03:47 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 04 Aug 2022 18:03:46 +0800
Date:   Thu, 4 Aug 2022 18:03:46 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Abhishek Shah <abhishek.shah@columbia.edu>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, linux-kernel@vger.kernel.org,
        Gabriel Ryan <gabe@cs.columbia.edu>,
        Fan Du <fan.du@windriver.com>,
        Steffen Klassert <klassert@kernel.org>
Subject: [PATCH] af_key: Do not call xfrm_probe_algs in parallel
Message-ID: <YuuZgsdmJK8roKLD@gondor.apana.org.au>
References: <CAEHB24-9hXY+TgQKxJB4bE9a9dFD9C+Lan+ShBwpvwaHVAGMFg@mail.gmail.com>
 <YtoWqEkKzvimzWS5@gondor.apana.org.au>
 <CAEHB249ygptvp9wpynMF7zZ2Kcet0+bwLVuVg5UReZHOU1+8HA@mail.gmail.com>
 <YuNGR/5U5pSo6YM3@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuNGR/5U5pSo6YM3@gondor.apana.org.au>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When namespace support was added to xfrm/afkey, it caused the
previously single-threaded call to xfrm_probe_algs to become
multi-threaded.  This is buggy and needs to be fixed with a mutex.

Reported-by: Abhishek Shah <abhishek.shah@columbia.edu>
Fixes: 283bc9f35bbb ("xfrm: Namespacify xfrm state/policy locks")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/net/key/af_key.c b/net/key/af_key.c
index fb16d7c4e1b8..20e73643b9c8 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1697,9 +1697,12 @@ static int pfkey_register(struct sock *sk, struct sk_buff *skb, const struct sad
 		pfk->registered |= (1<<hdr->sadb_msg_satype);
 	}
 
+	mutex_lock(&pfkey_mutex);
 	xfrm_probe_algs();
 
 	supp_skb = compose_sadb_supported(hdr, GFP_KERNEL | __GFP_ZERO);
+	mutex_unlock(&pfkey_mutex);
+
 	if (!supp_skb) {
 		if (hdr->sadb_msg_satype != SADB_SATYPE_UNSPEC)
 			pfk->registered &= ~(1<<hdr->sadb_msg_satype);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
