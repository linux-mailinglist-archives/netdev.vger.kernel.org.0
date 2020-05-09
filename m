Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1017D1CBC8E
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 04:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgEICbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 22:31:52 -0400
Received: from smtprelay0160.hostedemail.com ([216.40.44.160]:58544 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728353AbgEICbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 22:31:52 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 105B4180A733F;
        Sat,  9 May 2020 02:31:51 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3866:3867:3868:3872:3873:4321:5007:7809:9010:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12297:12438:12740:12760:12895:13069:13311:13357:13439:13891:14096:14097:14181:14659:14721:21080:21324:21451:21627:21740:30054:30064:30083:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: pan63_4a25c479b7e55
X-Filterd-Recvd-Size: 2571
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Sat,  9 May 2020 02:31:49 +0000 (UTC)
Message-ID: <fbd61323358554b00460c97ec303572189f99544.camel@perches.com>
Subject: Re: [PATCH] net: tg3: tidy up loop, remove need to compute off with
 a multiply
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>
Cc:     Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 08 May 2020 19:31:48 -0700
In-Reply-To: <20200508184814.45e10c12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200508225301.484094-1-colin.king@canonical.com>
         <1890306fc8c9306abe11186d419d84f784ee6144.camel@perches.com>
         <160ce1ee-3bb5-3357-64f3-e5dea8c0538d@canonical.com>
         <20200508184814.45e10c12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-05-08 at 18:48 -0700, Jakub Kicinski wrote:
> On Sat, 9 May 2020 00:31:03 +0100 Colin Ian King wrote:
> > > My preference would be for
> > > 
> > > {
> > > 	int i;
> > > 	u32 off = 0;
> > > 
> > > 	for (i = 0; i < TG3_SD_NUM_RECS; i++) {
> > > 		tg3_ape_scratchpad_read(tp, (u32 *)ocir, off, TC3_OCIR_LEN);
> > > 
> > > 		if (ocir->signature != TG3_OCIR_SIG_MAGIC ||
> > > 		    !(ocir->version_flags & TG3_OCIR_FLAG_ACTIVE))
> > > 			memset(ocir, 0, TG3_OCIR_LEN);
> > > 
> > > 		off += TG3_OCIR_LEN;
> > > 		ocir++;
> > > 	}
> > >   
> > OK, I'll send a V3 tomorrow.
> 
> I already reviewed and applied v2, just waiting for builds to finish,
> let's leave it.


I think clarity should be preferred.
Are you a maintainer of this file?

$ ./scripts/get_maintainer.pl -f drivers/net/ethernet/broadcom/tg3.c
Siva Reddy Kallam <siva.kallam@broadcom.com> (supporter:BROADCOM TG3 GIGABIT ETHERNET DRIVER)
Prashant Sreedharan <prashant@broadcom.com> (supporter:BROADCOM TG3 GIGABIT ETHERNET DRIVER)
Michael Chan <mchan@broadcom.com> (supporter:BROADCOM TG3 GIGABIT ETHERNET DRIVER)
"David S. Miller" <davem@davemloft.net> (odd fixer:NETWORKING DRIVERS)
netdev@vger.kernel.org (open list:BROADCOM TG3 GIGABIT ETHERNET DRIVER)
linux-kernel@vger.kernel.org (open list)


