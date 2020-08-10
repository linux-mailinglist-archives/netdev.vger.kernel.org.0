Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13E9240141
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 05:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgHJDy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 23:54:29 -0400
Received: from smtprelay0087.hostedemail.com ([216.40.44.87]:46542 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726481AbgHJDy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 23:54:28 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 3E759182CED2A;
        Mon, 10 Aug 2020 03:54:27 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:196:355:379:599:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2899:3138:3139:3140:3141:3142:3150:3353:3622:3865:3866:3867:3868:3870:3871:3873:3874:4250:4321:5007:8603:10004:10400:10848:11026:11232:11657:11658:11914:12043:12048:12296:12297:12740:12760:12895:13069:13095:13311:13357:13439:14181:14659:14721:21080:21212:21220:21324:21433:21611:21627:30054:30070:30075:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: alley78_2c011d126fd7
X-Filterd-Recvd-Size: 2562
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Mon, 10 Aug 2020 03:54:25 +0000 (UTC)
Message-ID: <8cc2925b53845876475ccc4f098fbc88471d77bb.camel@perches.com>
Subject: Re: [PATCH] ionic_lif: Use devm_kcalloc() in ionic_qcq_alloc()
From:   Joe Perches <joe@perches.com>
To:     Shannon Nelson <snelson@pensando.io>, Xu Wang <vulab@iscas.ac.cn>,
        drivers@pensando.io, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Sun, 09 Aug 2020 20:54:24 -0700
In-Reply-To: <2623670b-09f0-2ab4-d618-e478d98c186a@pensando.io>
References: <20200810023807.9260-1-vulab@iscas.ac.cn>
         <4265227298e8d0a943ca4468a4f32222317df197.camel@perches.com>
         <2623670b-09f0-2ab4-d618-e478d98c186a@pensando.io>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-08-09 at 20:50 -0700, Shannon Nelson wrote:
> On 8/9/20 8:20 PM, Joe Perches wrote:
> > On Mon, 2020-08-10 at 02:38 +0000, Xu Wang wrote:
> > > A multiplication for the size determination of a memory allocation
> > > indicated that an array data structure should be processed.
> > > Thus use the corresponding function "devm_kcalloc".
> > []
> > > diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> > []
> > > @@ -412,7 +412,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
> > >   
> > >   	new->flags = flags;
> > >   
> > > -	new->q.info = devm_kzalloc(dev, sizeof(*new->q.info) * num_descs,
> > > +	new->q.info = devm_kcalloc(dev, num_descs, sizeof(*new->q.info),
> > >   				   GFP_KERNEL);
> > >   	if (!new->q.info) {
> > >   		netdev_err(lif->netdev, "Cannot allocate queue info\n");
> > You could also remove these unnecessary allocation error messages.
> > There is an existing dump_stack() on allocation failure.
> > 
> Yes, the dump_stack() tells you which function had the allocation 
> failure, but since there are multiple allocation operations in this same 
> function, I find these helpful in knowing quickly which one of the 
> allocations failed, without having to track down the symbols and source 
> for whatever distro's kernel this might have happened in.

If you do chose the message, might as well add __GFP_NOWARN
to the allocation to avoid the dump_stack().

But honestly, if any allocation fails, you're OOM anyway.

