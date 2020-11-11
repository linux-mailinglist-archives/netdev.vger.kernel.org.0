Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A832AFD20
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgKLBcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:32:07 -0500
Received: from correo.us.es ([193.147.175.20]:57312 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727960AbgKKXnG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 18:43:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 73F241C41C6
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 00:43:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 63DFEDA78F
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 00:43:04 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5975ADA78B; Thu, 12 Nov 2020 00:43:04 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 031F6DA704;
        Thu, 12 Nov 2020 00:43:02 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 12 Nov 2020 00:43:02 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D71A64301DE0;
        Thu, 12 Nov 2020 00:43:01 +0100 (CET)
Date:   Thu, 12 Nov 2020 00:43:01 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Martin Willi <martin@strongswan.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] vrf: Fix fast path output packet handling with async
 Netfilter rules
Message-ID: <20201111234301.GA3058@salvia>
References: <20201106073030.3974927-1-martin@strongswan.org>
 <20201110133506.GA1777@salvia>
 <2df88651a28cf77daf09e3d1282261d518794629.camel@strongswan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2df88651a28cf77daf09e3d1282261d518794629.camel@strongswan.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

On Tue, Nov 10, 2020 at 04:02:13PM +0100, Martin Willi wrote:
> Hi Pablo,
>  
> > > +static int vrf_output6_direct_finish(struct net *net, struct sock *sk,
> > > +				     struct sk_buff *skb)
> > > +{
> > > +	vrf_finish_direct(skb);
> > > +
> > > +	return vrf_ip6_local_out(net, sk, skb);
> > > +}
> > > +
> > >  static int vrf_output6_direct(struct net *net, struct sock *sk,
> > >  			      struct sk_buff *skb)
> > >  {
> > > +	int err = 1;
> > > +
> > >  	skb->protocol = htons(ETH_P_IPV6);
> > >  
> > > -	return NF_HOOK_COND(NFPROTO_IPV6, NF_INET_POST_ROUTING,
> > > -			    net, sk, skb, NULL, skb->dev,
> > > -			    vrf_finish_direct,
> > > -			    !(IPCB(skb)->flags & IPSKB_REROUTED));
> > > +	if (!(IPCB(skb)->flags & IPSKB_REROUTED))
> > > +		err = nf_hook(NFPROTO_IPV6, NF_INET_POST_ROUTING, net, sk, skb,
> > > +			      NULL, skb->dev, vrf_output6_direct_finish);
> > 
> > I might missing something... this looks very similar to NF_HOOK_COND
> > but it's open-coded.
> > 
> > My question, could you still use NF_HOOK_COND?
> > 
> >         ret = NF_HOOK_COND(NFPROTO_IPV6, ..., vrf_output6_direct_finish);
> > 
> > just update the okfn.
> 
> I don't think this will work. The point of the patch is to have
> different paths for sync and async Netfilter rules: In the async case
> we call vrf_output6_direct_finish() to additionally do dst_output(). In
> the (existing) synchronous path we just do vrf_finish_direct() and let
> the caller do the dst_output().
> 
> If we prefer a common okfn(), we could return 0 to omit dst_output() in
> ip/ip6_local_out(). This changes/extends the call stack for the common
> case, though, and this is what I've tried to avoid.

thanks for explaining.

> > > +	if (likely(err == 1))
> > 
> > I'd suggest you remove likely() here and elsewhere in this patch.
> > Just let the branch predictor make its work instead of assuming that
> > the ruleset accepts traffic.
> 
> The likely() may be questionable, but I seems that is done in most
> places when checking for synchronous Netfilter completion. But I'm fine
> with changing these hunks, if you prefer.

I see, this likely() assumes that IPCB(skb)->flags & IPSKB_REROUTED is
actually unlikely to happen.

no objections from my side to this patch, thanks.
