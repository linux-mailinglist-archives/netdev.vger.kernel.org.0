Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C2E2E76AB
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 07:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgL3GuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 01:50:15 -0500
Received: from smtprelay0131.hostedemail.com ([216.40.44.131]:48084 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726203AbgL3GuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 01:50:15 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id C3A88180A7FCD;
        Wed, 30 Dec 2020 06:49:33 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3874:4321:5007:7652:10004:10400:10471:10848:11026:11232:11473:11657:11658:11914:12043:12296:12297:12438:12740:12895:13069:13161:13229:13255:13311:13357:13439:13894:14659:14721:21080:21627:21660:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: angle06_3e022d3274a3
X-Filterd-Recvd-Size: 2065
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Wed, 30 Dec 2020 06:49:32 +0000 (UTC)
Message-ID: <42f953220e40a2e32540f729f03b762610b35a42.camel@perches.com>
Subject: Re: [PATCH] liquidio: fix: warning: %u in format string (no. 3)
 requires 'unsigned int' but the argument type is 'signed int'.
From:   Joe Perches <joe@perches.com>
To:     YANG LI <abaci-bugfix@linux.alibaba.com>, davem@davemloft.net
Cc:     kuba@kernel.org, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 29 Dec 2020 22:49:31 -0800
In-Reply-To: <1609310480-80777-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1609310480-80777-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-12-30 at 14:41 +0800, YANG LI wrote:
> For safety, modify '%u' to '%d' to keep the type consistent.

There is no additional safety here.

The for loop ensures that i is positive as num_ioq_vector is also
int and so i can not be negative as it's incremented from 0.

> diff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/net/ethernet/cavium/liquidio/lio_core.c
[]
> @@ -1109,12 +1109,12 @@ int octeon_setup_interrupt(struct octeon_device *oct, u32 num_ioqs)
>  		for (i = 0 ; i < num_ioq_vectors ; i++) {
>  			if (OCTEON_CN23XX_PF(oct))
>  				snprintf(&queue_irq_names[IRQ_NAME_OFF(i)],
> -					 INTRNAMSIZ, "LiquidIO%u-pf%u-rxtx-%u",
> +					 INTRNAMSIZ, "LiquidIO%u-pf%u-rxtx-%d",
>  					 oct->octeon_id, oct->pf_num, i);
>  
> 
>  			if (OCTEON_CN23XX_VF(oct))
>  				snprintf(&queue_irq_names[IRQ_NAME_OFF(i)],
> -					 INTRNAMSIZ, "LiquidIO%u-vf%u-rxtx-%u",
> +					 INTRNAMSIZ, "LiquidIO%u-vf%u-rxtx-%d",
>  					 oct->octeon_id, oct->vf_num, i);
>  
> 
>  			irqret = request_irq(msix_entries[i].vector,


