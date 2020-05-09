Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102FF1CC500
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 00:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgEIWmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 18:42:40 -0400
Received: from smtprelay0083.hostedemail.com ([216.40.44.83]:48244 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726771AbgEIWmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 18:42:40 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 0436318029123;
        Sat,  9 May 2020 22:42:39 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:966:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2692:2828:2895:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3874:4250:4321:4385:4605:5007:7903:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12296:12297:12438:12740:12895:13069:13311:13357:13439:13618:13894:13972:14096:14097:14659:14721:21080:21627:21740:21990:30054:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: force24_16f61c6693f2a
X-Filterd-Recvd-Size: 2622
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Sat,  9 May 2020 22:42:37 +0000 (UTC)
Message-ID: <fc5cf8da8e70ebb981a9fc3aec6834c74197f0ed.camel@perches.com>
Subject: Re: [PATCH] net/sonic: Fix some resource leaks in error handling
 paths
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, fthain@telegraphics.com.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date:   Sat, 09 May 2020 15:42:36 -0700
In-Reply-To: <20200509111321.51419b19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200508172557.218132-1-christophe.jaillet@wanadoo.fr>
         <20200508185402.41d9d068@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <50ef36cd-d095-9abe-26ea-d363d11ce521@wanadoo.fr>
         <20200509111321.51419b19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-05-09 at 11:13 -0700, Jakub Kicinski wrote:
> On Sat, 9 May 2020 18:47:08 +0200 Christophe JAILLET wrote:
> > Le 09/05/2020 à 03:54, Jakub Kicinski a écrit :
> > > On Fri,  8 May 2020 19:25:57 +0200 Christophe JAILLET wrote:  
> > > > @@ -527,8 +531,9 @@ static int mac_sonic_platform_remove(struct platform_device *pdev)
> > > >   	struct sonic_local* lp = netdev_priv(dev);
> > > >   
> > > >   	unregister_netdev(dev);
> > > > -	dma_free_coherent(lp->device, SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
> > > > -	                  lp->descriptors, lp->descriptors_laddr);
> > > > +	dma_free_coherent(lp->device,
> > > > +			  SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
> > > > +			  lp->descriptors, lp->descriptors_laddr);
> > > >   	free_netdev(dev);
> > > >   
> > > >   	return 0;  
> > > This is a white-space only change, right? Since this is a fix we should
> > > avoid making cleanups which are not strictly necessary.
> > 
> > Right.
> > 
> > The reason of this clean-up is that I wanted to avoid a checkpatch 
> > warning with the proposed patch and I felt that having the same layout 
> > in the error handling path of the probe function and in the remove 
> > function was clearer.
> > So I updated also the remove function.
> 
> I understand the motivation is good.

David, maybe I missed some notification about Jakub's role.

What is Jakub's role in relation to the networking tree?


