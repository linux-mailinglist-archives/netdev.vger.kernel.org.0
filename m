Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C232768FAEB
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 00:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjBHXJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 18:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjBHXJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 18:09:29 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4555C28D13
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 15:09:27 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pPtYf-0094Zs-Cq; Thu, 09 Feb 2023 07:08:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 09 Feb 2023 07:08:57 +0800
Date:   Thu, 9 Feb 2023 07:08:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Hyunwoo Kim <v4bel@theori.io>, steffen.klassert@secunet.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, imv4bel@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] xfrm: Zero padding when dumping algos and encap
Message-ID: <Y+QriSfj3OYBj6J6@gondor.apana.org.au>
References: <20230204175018.GA7246@ubuntu>
 <Y+Hp+0LzvScaUJV0@gondor.apana.org.au>
 <20230208085434.GA2933@ubuntu>
 <Y+N4Q2B01iRfXlQu@gondor.apana.org.au>
 <Y+Oggx0YBA3kLLcw@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+Oggx0YBA3kLLcw@hog>
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_RDNS_DYNAMIC_FP,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 02:15:47PM +0100, Sabrina Dubroca wrote:
>
> Do you mean as a replacement for Hyunwoo's patch, or that both are
> needed? pfkey_msg2xfrm_state doesn't always initialize encap_sport and
> encap_dport (and calg->alg_key_len, but you're not using that in
> copy_to_user_calg), so I guess you mean both patches.

It's meant to be a replacement but yes we should still zero x->encap
because that will leak out in other ways, e.g., on the wire.

Hyunwoo, could you please repost your patch just for x->encap?

> > +static int copy_to_user_encap(struct xfrm_encap_tmpl *ep, struct sk_buff *skb)
> > +{
> > +	struct nlattr *nla = nla_reserve(skb, XFRMA_ALG_COMP, sizeof(*ep));
> 
> XFRMA_ENCAP

Good catch.  I will repost the patch.

> > +	uep->encap_oa = ep->encap_oa;
> 
> Should that be a memcpy? At least that's how xfrm_user.c usually does
> copies of xfrm_address_t.

It doesn't really matter.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
