Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8252E7214
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 17:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgL2QDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 11:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgL2QDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 11:03:07 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F4DC06179F
        for <netdev@vger.kernel.org>; Tue, 29 Dec 2020 08:01:46 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kuHR9-00012o-0y; Tue, 29 Dec 2020 17:01:27 +0100
Date:   Tue, 29 Dec 2020 17:01:27 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Visa Hankala <visa@hankala.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] xfrm: Fix wraparound in xfrm_policy_addr_delta()
Message-ID: <20201229160127.GA30823@breakpoint.cc>
References: <20201229145009.cGOUak0JdKIIgGAv@hankala.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201229145009.cGOUak0JdKIIgGAv@hankala.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Visa Hankala <visa@hankala.org> wrote:
> Use three-way comparison for address elements to avoid integer
> wraparound in the result of xfrm_policy_addr_delta().
> 
> This ensures that the search trees are built and traversed correctly
> when the difference between compared address elements is larger
> than INT_MAX.

Please provide an update to tools/testing/selftests/net/xfrm_policy.sh
that shows that this is a problem.

>  	switch (family) {
>  	case AF_INET:
> -		if (sizeof(long) == 4 && prefixlen == 0)
> -			return ntohl(a->a4) - ntohl(b->a4);
> -		return (ntohl(a->a4) & ((~0UL << (32 - prefixlen)))) -
> -		       (ntohl(b->a4) & ((~0UL << (32 - prefixlen))));
> +		mask = ~0U << (32 - prefixlen);
> +		ma = ntohl(a->a4) & mask;
> +		mb = ntohl(b->a4) & mask;

This is suspicious.  Is prefixlen == 0 impossible?

If not, then after patch
mask = ~0U << 32;

... and function returns 0.
