Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2EF85F0DE7
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbiI3OsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiI3OsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:48:05 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FF9129FC2;
        Fri, 30 Sep 2022 07:47:59 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oeHIu-000305-IO; Fri, 30 Sep 2022 16:47:52 +0200
Date:   Fri, 30 Sep 2022 16:47:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH 1/1] netfilter: nft_fib: Fix for rpath check with VRF
 devices
Message-ID: <20220930144752.GA8349@breakpoint.cc>
References: <20220928113908.4525-1-fw@strlen.de>
 <20220928113908.4525-2-fw@strlen.de>
 <20220930141048.GA10057@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930141048.GA10057@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guillaume Nault <gnault@redhat.com> wrote:
> On Wed, Sep 28, 2022 at 01:39:08PM +0200, Florian Westphal wrote:
> > diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
> > index 8970d0b4faeb..1d7e520d9966 100644
> > --- a/net/ipv6/netfilter/nft_fib_ipv6.c
> > +++ b/net/ipv6/netfilter/nft_fib_ipv6.c
> > @@ -41,6 +41,9 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
> >  	if (ipv6_addr_type(&fl6->daddr) & IPV6_ADDR_LINKLOCAL) {
> >  		lookup_flags |= RT6_LOOKUP_F_IFACE;
> >  		fl6->flowi6_oif = get_ifindex(dev ? dev : pkt->skb->dev);
> > +	} else if ((priv->flags & NFTA_FIB_F_IIF) &&
> > +		   (netif_is_l3_master(dev) || netif_is_l3_slave(dev))) {
> > +		fl6->flowi6_oif = dev->ifindex;
> >  	}
> 
> I'm not very familiar with nft code, but it seems dev can be NULL here,
> so netif_is_l3_master() can dereference a NULL pointer.

No, this should never be NULL, NFTA_FIB_F_IIF is restricted to
input/prerouting chains.

> Shouldn't we test dev in the 'else if' condition?

We could do that in case it makes review easier.
