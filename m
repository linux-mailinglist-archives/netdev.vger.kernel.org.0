Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE28F2E786C
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 13:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgL3MHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 07:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbgL3MHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 07:07:14 -0500
Received: from vale.hankala.org (vale.hankala.org [IPv6:2a02:2770:3:0:21a:4aff:fefb:f65c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8580EC061799
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 04:06:33 -0800 (PST)
Received: by vale.hankala.org (OpenSMTPD) with ESMTPS id 6b24027b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 30 Dec 2020 12:06:25 +0000 (UTC)
Date:   Wed, 30 Dec 2020 12:06:23 +0000
From:   Visa Hankala <visa@hankala.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] xfrm: Fix wraparound in xfrm_policy_addr_delta()
Message-ID: <20201230115517.iZlNGikD3bKtySfO@hankala.org>
References: <20201229145009.cGOUak0JdKIIgGAv@hankala.org>
 <20201229160127.GA30823@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201229160127.GA30823@breakpoint.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 29, 2020 at 05:01:27PM +0100, Florian Westphal wrote:
> Visa Hankala <visa@hankala.org> wrote:
> > Use three-way comparison for address elements to avoid integer
> > wraparound in the result of xfrm_policy_addr_delta().
> > 
> > This ensures that the search trees are built and traversed correctly
> > when the difference between compared address elements is larger
> > than INT_MAX.
> 
> Please provide an update to tools/testing/selftests/net/xfrm_policy.sh
> that shows that this is a problem.

I will do that in the next revision.

> >  	switch (family) {
> >  	case AF_INET:
> > -		if (sizeof(long) == 4 && prefixlen == 0)
> > -			return ntohl(a->a4) - ntohl(b->a4);
> > -		return (ntohl(a->a4) & ((~0UL << (32 - prefixlen)))) -
> > -		       (ntohl(b->a4) & ((~0UL << (32 - prefixlen))));
> > +		mask = ~0U << (32 - prefixlen);
> > +		ma = ntohl(a->a4) & mask;
> > +		mb = ntohl(b->a4) & mask;
> 
> This is suspicious.  Is prefixlen == 0 impossible?
> 
> If not, then after patch
> mask = ~0U << 32;
> 
> ... and function returns 0.

prefixlen == 0 is possible. However, I now realize that left shift
by 32 should be avoided with 32-bit integers.

With prefixlen == 0, there is only one equivalence class, so
returning 0 seems reasonable to me.

Is there a reason why the function has treated /0 prefix as /32
with IPv4? IPv6 does not have this treatment.
