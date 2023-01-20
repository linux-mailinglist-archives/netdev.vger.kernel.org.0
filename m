Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E6B674FBF
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 09:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjATIuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 03:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjATIuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 03:50:01 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D6B7DFBD;
        Fri, 20 Jan 2023 00:49:58 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pIn5e-00297g-Rr; Fri, 20 Jan 2023 16:49:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Jan 2023 16:49:38 +0800
Date:   Fri, 20 Jan 2023 16:49:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 1/4] crypto: Introduce crypto_pool
Message-ID: <Y8pVojWNpvdYpH03@gondor.apana.org.au>
References: <20230118214111.394416-1-dima@arista.com>
 <20230118214111.394416-2-dima@arista.com>
 <Y8kSkW4X4vQdFyOl@gondor.apana.org.au>
 <7c4138b4-e7dd-c9c5-11ac-68be90563cad@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c4138b4-e7dd-c9c5-11ac-68be90563cad@arista.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 06:03:40PM +0000, Dmitry Safonov wrote:
>
> - net/ipv4/ah4.c could benefit from it: currently it allocates
> crypto_alloc_ahash() per every connection, allocating user-specified
> hash algorithm with ahash = crypto_alloc_ahash(x->aalg->alg_name, 0, 0),
> which are not shared between each other and it doesn't provide
> pre-allocated temporary/scratch buffer to calculate hash, so it uses
> GFP_ATOMIC in ah_alloc_tmp()
> - net/ipv6/ah6.c is copy'n'paste of the above
> - net/ipv4/esp4.c and net/ipv6/esp6.c are more-or-less also copy'n'paste
> with crypto_alloc_aead() instead of crypto_alloc_ahash()

No they should definitely not switch over to the pool model.  In
fact, these provide the correct model that you should follow.

The correct model is to allocate the tfm on the control/slow path,
and allocate requests on the fast path (or reuse existing memory,
e.g., from the skb).

We have not yet explored doing the latter with IPsec but that is
certainly a possibility.

Yes I understand that this is currently impossible for hashes but
that is why I'm working on per-request keys.

> - net/xfrm/xfrm_ipcomp.c has its own manager for different compression
> algorithms that are used in quite the same fashion. The significant
> exception is scratch area: it's IPCOMP_SCRATCH_SIZE=65400. So, if it
> could be shared with other crypto users that do the same pattern
> (bh-disabled usage), it would save some memory.

IPcomp uses the legacy crypto compression interface.  We now have
a new acomp interface which was specifically designed so that we
don't need to have these memory pools.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
