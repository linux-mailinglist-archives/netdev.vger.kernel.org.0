Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB5D230638
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgG1JLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:11:30 -0400
Received: from smtprelay0015.hostedemail.com ([216.40.44.15]:40664 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728467AbgG1JL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 05:11:29 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id ACEFC180A7FD6;
        Tue, 28 Jul 2020 09:11:28 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:152:355:379:599:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2692:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:3874:4321:5007:6119:7903:8603:9010:9108:10004:10400:10848:11026:11232:11657:11658:11783:11914:12043:12048:12296:12297:12438:12740:12895:13069:13311:13357:13894:13972:14659:14721:21080:21451:21627:21990:30012:30025:30041:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: coat93_1c0ebe426f68
X-Filterd-Recvd-Size: 2656
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Tue, 28 Jul 2020 09:11:27 +0000 (UTC)
Message-ID: <bffcc7d513e186734d224bda6afdd55033b451de.camel@perches.com>
Subject: Re: [PATCH net-next] liquidio: Remove unneeded cast from memory
 allocation
From:   Joe Perches <joe@perches.com>
To:     "wanghai (M)" <wanghai38@huawei.com>, dchickles@marvell.com,
        sburla@marvell.com, fmanlunas@marvell.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 28 Jul 2020 02:11:26 -0700
In-Reply-To: <ac99bed4-dabc-a003-374f-206753f937cb@huawei.com>
References: <20200724130001.71528-1-wanghai38@huawei.com>
         <2cdef8d442bb5da39aed17bf994a800e768942f7.camel@perches.com>
         <ac99bed4-dabc-a003-374f-206753f937cb@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-07-28 at 16:42 +0800, wanghai (M) wrote:
> 在 2020/7/25 5:29, Joe Perches 写道:
> > On Fri, 2020-07-24 at 21:00 +0800, Wang Hai wrote:
> > > Remove casting the values returned by memory allocation function.
> > > 
> > > Coccinelle emits WARNING:
> > > 
> > > ./drivers/net/ethernet/cavium/liquidio/octeon_device.c:1155:14-36: WARNING:
> > >   casting value returned by memory allocation function to (struct octeon_dispatch *) is useless.
> > []
> > > diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_device.c b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
> > []
> > > @@ -1152,8 +1152,7 @@ octeon_register_dispatch_fn(struct octeon_device *oct,
> > >   
> > >   		dev_dbg(&oct->pci_dev->dev,
> > >   			"Adding opcode to dispatch list linked list\n");
> > > -		dispatch = (struct octeon_dispatch *)
> > > -			   vmalloc(sizeof(struct octeon_dispatch));
> > > +		dispatch = vmalloc(sizeof(struct octeon_dispatch));
> > More the question is why this is vmalloc at all
> > as the structure size is very small.
> > 
> > Likely this should just be kmalloc.
> > 
> > 
> Thanks for your advice.  It is indeed best to use kmalloc here.
> > >   		if (!dispatch) {
> > >   			dev_err(&oct->pci_dev->dev,
> > >   				"No memory to add dispatch function\n");
> > And this dev_err is unnecessary.
> > 
> > 
> I don't understand why dev_err is not needed here. We can easily know 
> that an error has occurred here through dev_err

Memory allocation failures without __GFP_NOWARN. already
do a dump_stack to show the location of the code that
could not successfully allocate memory.


