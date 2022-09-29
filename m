Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D326E5EFA56
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 18:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbiI2QYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 12:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236196AbiI2QX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 12:23:58 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355C912FF0B;
        Thu, 29 Sep 2022 09:21:41 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1odwHx-0004Jv-Ly; Thu, 29 Sep 2022 18:21:29 +0200
Date:   Thu, 29 Sep 2022 18:21:29 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH 1/1] netfilter: nft_fib: Fix for rpath check with VRF
 devices
Message-ID: <20220929162129.GA10152@breakpoint.cc>
References: <20220928113908.4525-1-fw@strlen.de>
 <20220928113908.4525-2-fw@strlen.de>
 <20220929161035.GE6761@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929161035.GE6761@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guillaume Nault <gnault@redhat.com> wrote:

[ CC David Ahern ]

> On Wed, Sep 28, 2022 at 01:39:08PM +0200, Florian Westphal wrote:
> > From: Phil Sutter <phil@nwl.cc>
> > 
> > Analogous to commit b575b24b8eee3 ("netfilter: Fix rpfilter
> > dropping vrf packets by mistake") but for nftables fib expression:
> > Add special treatment of VRF devices so that typical reverse path
> > filtering via 'fib saddr . iif oif' expression works as expected.
> > 
> > Fixes: f6d0cbcf09c50 ("netfilter: nf_tables: add fib expression")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  net/ipv4/netfilter/nft_fib_ipv4.c | 3 +++
> >  net/ipv6/netfilter/nft_fib_ipv6.c | 6 +++++-
> >  2 files changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
> > index b75cac69bd7e..7ade04ff972d 100644
> > --- a/net/ipv4/netfilter/nft_fib_ipv4.c
> > +++ b/net/ipv4/netfilter/nft_fib_ipv4.c
> > @@ -83,6 +83,9 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
> >  	else
> >  		oif = NULL;
> >  
> > +	if (priv->flags & NFTA_FIB_F_IIF)
> > +		fl4.flowi4_oif = l3mdev_master_ifindex_rcu(oif);
> > +
> 
> Shouldn't we set .flowi4_l3mdev instead of .flowi4_oif?

No idea.
db53cd3d88dc328dea2e968c9c8d3b4294a8a674 sets both.
rp_filter modules in iptables only set flowi(6)_oif.

David, can you give advice on what the correct fix is?

Then we could change all users in netfilter at once rather than the
current collection of random-looking guesses...
