Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2A75F0455
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 07:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiI3Fy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 01:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiI3Fyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 01:54:51 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1091D307;
        Thu, 29 Sep 2022 22:54:48 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oe8yh-00A4n8-9z; Fri, 30 Sep 2022 15:54:28 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Sep 2022 13:54:27 +0800
Date:   Fri, 30 Sep 2022 13:54:27 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christian Langrock <christian.langrock@secunet.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH ipsec v5] xfrm: replay: Fix ESN wrap around for GSO
Message-ID: <YzaEk6Wu5FwT5X18@gondor.apana.org.au>
References: <17ee747b-7b68-02f3-fd5c-92ecb36b4d27@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17ee747b-7b68-02f3-fd5c-92ecb36b4d27@secunet.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 07:40:24AM +0200, Christian Langrock wrote:
.
> diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
> index 9a5e79a38c67..c470a68d9c88 100644
> --- a/net/xfrm/xfrm_output.c
> +++ b/net/xfrm/xfrm_output.c
> @@ -738,7 +738,7 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
>  		skb->encapsulation = 1;
>  
>  		if (skb_is_gso(skb)) {
> -			if (skb->inner_protocol)
> +			if (skb->inner_protocol || xfrm_replay_overflow_check(x, skb))
>  				return xfrm_output_gso(net, sk, skb);

The xfrm_state is unlocked at this point.  So how can you safely
check against a shared state from xfrm_state?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
