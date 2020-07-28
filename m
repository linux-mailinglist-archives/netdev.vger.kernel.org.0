Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E36A230E88
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731068AbgG1Py5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:54:57 -0400
Received: from smtprelay0075.hostedemail.com ([216.40.44.75]:33018 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730679AbgG1Py5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 11:54:57 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 18151181D396A;
        Tue, 28 Jul 2020 15:54:56 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2194:2196:2199:2200:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3872:4321:4385:4605:5007:9010:10004:10400:10848:11026:11232:11657:11658:11914:12043:12048:12296:12297:12438:12555:12740:12760:12895:13439:13972:14659:14721:21080:21451:21627:21990:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: seed58_631747d26f6b
X-Filterd-Recvd-Size: 3298
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Tue, 28 Jul 2020 15:54:51 +0000 (UTC)
Message-ID: <4299fe666c93018a9a047575e5d68a0bb4dd269f.camel@perches.com>
Subject: Re: [PATCH net-next] liquidio: Remove unneeded cast from memory
 allocation
From:   Joe Perches <joe@perches.com>
To:     "wanghai (M)" <wanghai38@huawei.com>, dchickles@marvell.com,
        sburla@marvell.com, fmanlunas@marvell.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 28 Jul 2020 08:54:48 -0700
In-Reply-To: <2996569e-5e1a-db02-2c78-0ee0d572706d@huawei.com>
References: <20200724130001.71528-1-wanghai38@huawei.com>
         <2cdef8d442bb5da39aed17bf994a800e768942f7.camel@perches.com>
         <ac99bed4-dabc-a003-374f-206753f937cb@huawei.com>
         <bffcc7d513e186734d224bda6afdd55033b451de.camel@perches.com>
         <2996569e-5e1a-db02-2c78-0ee0d572706d@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-07-28 at 21:38 +0800, wanghai (M) wrote:
> Thanks for your explanation. I got it.
> 
> Can it be modified like this?
[]
> +++ b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
> @@ -1152,11 +1152,8 @@ octeon_register_dispatch_fn(struct octeon_device 
> *oct,
> 
>                  dev_dbg(&oct->pci_dev->dev,
>                          "Adding opcode to dispatch list linked list\n");
> -               dispatch = (struct octeon_dispatch *)
> -                          vmalloc(sizeof(struct octeon_dispatch));
> +               dispatch = kmalloc(sizeof(struct octeon_dispatch), 
> GFP_KERNEL);
>                  if (!dispatch) {
> -                       dev_err(&oct->pci_dev->dev,
> -                               "No memory to add dispatch function\n");
>                          return 1;
>                  }
>                  dispatch->opcode = combined_opcode;

Yes, but the free also needs to be changed.

I think it's:
---
 drivers/net/ethernet/cavium/liquidio/octeon_device.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_device.c b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
index 934115d18488..4ee4cb946e1d 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
@@ -1056,7 +1056,7 @@ void octeon_delete_dispatch_list(struct octeon_device *oct)
 
 	list_for_each_safe(temp, tmp2, &freelist) {
 		list_del(temp);
-		vfree(temp);
+		kfree(temp);
 	}
 }
 
@@ -1152,13 +1152,10 @@ octeon_register_dispatch_fn(struct octeon_device *oct,
 
 		dev_dbg(&oct->pci_dev->dev,
 			"Adding opcode to dispatch list linked list\n");
-		dispatch = (struct octeon_dispatch *)
-			   vmalloc(sizeof(struct octeon_dispatch));
-		if (!dispatch) {
-			dev_err(&oct->pci_dev->dev,
-				"No memory to add dispatch function\n");
+		dispatch = kmalloc(sizeof(struct octeon_dispatch), GFP_KERNEL);
+		if (!dispatch)
 			return 1;
-		}
+
 		dispatch->opcode = combined_opcode;
 		dispatch->dispatch_fn = fn;
 		dispatch->arg = fn_arg;


