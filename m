Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7CCE107FF1
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 19:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfKWSa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 13:30:26 -0500
Received: from smtprelay0158.hostedemail.com ([216.40.44.158]:40553 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726494AbfKWSa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 13:30:26 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id A7669181D3025;
        Sat, 23 Nov 2019 18:30:24 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3873:3874:4250:4321:5007:6119:7514:7903:9108:10004:10400:10848:11026:11232:11658:11914:12043:12048:12296:12297:12555:12740:12760:12895:13069:13138:13146:13230:13231:13311:13357:13439:13523:13524:14096:14097:14181:14659:14721:14915:21080:21451:21627:30054:30070:30071:30080:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: color55_77d9b74f7dc5d
X-Filterd-Recvd-Size: 2351
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Sat, 23 Nov 2019 18:30:23 +0000 (UTC)
Message-ID: <491b61d7be054a2200639e4acb6a00f8e39409c4.camel@perches.com>
Subject: Re: [PATCH] net: ip/tnl: Set iph->id only when don't fragment is
 not set
From:   Joe Perches <joe@perches.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Oliver Herms <oliver.peter.herms@gmail.com>,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org
Date:   Sat, 23 Nov 2019 10:29:58 -0800
In-Reply-To: <fa37491f-3604-bd3b-7518-dab654b641b6@gmail.com>
References: <20191123145817.GA22321@fuckup>
         <fa37491f-3604-bd3b-7518-dab654b641b6@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2019-11-23 at 09:53 -0800, Eric Dumazet wrote:
> 
> On 11/23/19 6:58 AM, Oliver Herms wrote:
> > In IPv4 the identification field ensures that fragments of different datagrams
> > are not mixed by the receiver. Packets with Don't Fragment (DF) flag set are not
> > to be fragmented in transit and thus don't need an identification.
> 
> Official sources for this assertion please, so that we can double check if you
> implemented the proper avoidance ?
> 
> > Calculating the identification takes significant CPU time.
> > This patch will increase IP tunneling performance by ~10% unless DF is not set.
> > However, DF is set by default which is best practice.
> > 
> > Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
> > ---
> >  net/ipv4/ip_tunnel_core.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
> > index 1452a97914a0..8636c1e0e7b7 100644
> > --- a/net/ipv4/ip_tunnel_core.c
> > +++ b/net/ipv4/ip_tunnel_core.c
> > @@ -73,7 +73,9 @@ void iptunnel_xmit(struct sock *sk, struct rtable *rt, struct sk_buff *skb,
> >  	iph->daddr	=	dst;
> >  	iph->saddr	=	src;
> >  	iph->ttl	=	ttl;
> > -	__ip_select_ident(net, iph, skb_shinfo(skb)->gso_segs ?: 1);
> > +
> > +	if (unlikely((iph->frag_off & htons(IP_DF)) == false))
> 
> This unlikely() seems wrong to me.

as does the comparison to false.


