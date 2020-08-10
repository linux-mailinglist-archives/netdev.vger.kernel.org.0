Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1921F240129
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 05:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgHJDU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 23:20:27 -0400
Received: from smtprelay0113.hostedemail.com ([216.40.44.113]:59298 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726338AbgHJDU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 23:20:26 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 58A8D182244EC;
        Mon, 10 Aug 2020 03:20:25 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:196:355:379:599:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2899:3138:3139:3140:3141:3142:3150:3352:3622:3865:3866:3871:3873:3874:4321:5007:8603:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12048:12296:12297:12438:12740:12760:12895:13069:13161:13229:13311:13357:13439:14181:14659:14721:21080:21212:21433:21611:21627:30054:30075:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: dogs95_06140a126fd6
X-Filterd-Recvd-Size: 2141
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Mon, 10 Aug 2020 03:20:24 +0000 (UTC)
Message-ID: <4265227298e8d0a943ca4468a4f32222317df197.camel@perches.com>
Subject: Re: [PATCH] ionic_lif: Use devm_kcalloc() in ionic_qcq_alloc()
From:   Joe Perches <joe@perches.com>
To:     Xu Wang <vulab@iscas.ac.cn>, snelson@pensando.io,
        drivers@pensando.io, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Sun, 09 Aug 2020 20:20:22 -0700
In-Reply-To: <20200810023807.9260-1-vulab@iscas.ac.cn>
References: <20200810023807.9260-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-08-10 at 02:38 +0000, Xu Wang wrote:
> A multiplication for the size determination of a memory allocation
> indicated that an array data structure should be processed.
> Thus use the corresponding function "devm_kcalloc".
[]
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
[]
> @@ -412,7 +412,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
>  
>  	new->flags = flags;
>  
> -	new->q.info = devm_kzalloc(dev, sizeof(*new->q.info) * num_descs,
> +	new->q.info = devm_kcalloc(dev, num_descs, sizeof(*new->q.info),
>  				   GFP_KERNEL);
>  	if (!new->q.info) {
>  		netdev_err(lif->netdev, "Cannot allocate queue info\n");

You could also remove these unnecessary allocation error messages.
There is an existing dump_stack() on allocation failure.

> @@ -462,7 +462,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
>  		new->intr.index = IONIC_INTR_INDEX_NOT_ASSIGNED;
>  	}
>  
> -	new->cq.info = devm_kzalloc(dev, sizeof(*new->cq.info) * num_descs,
> +	new->cq.info = devm_kcalloc(dev, num_descs, sizeof(*new->cq.info),
>  				    GFP_KERNEL);
>  	if (!new->cq.info) {
>  		netdev_err(lif->netdev, "Cannot allocate completion queue info\n");

