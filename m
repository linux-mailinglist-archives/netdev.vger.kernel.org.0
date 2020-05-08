Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF441CBB35
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 01:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgEHXVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 19:21:50 -0400
Received: from smtprelay0143.hostedemail.com ([216.40.44.143]:55446 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727110AbgEHXVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 19:21:50 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id D341B181D3025;
        Fri,  8 May 2020 23:21:48 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:4321:5007:7576:7903:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12048:12297:12438:12555:12740:12760:12895:13069:13160:13229:13311:13357:13439:14096:14097:14181:14659:14721:21080:21627:21990:30012:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: coil31_fa79d30e4a30
X-Filterd-Recvd-Size: 2587
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Fri,  8 May 2020 23:21:47 +0000 (UTC)
Message-ID: <1890306fc8c9306abe11186d419d84f784ee6144.camel@perches.com>
Subject: Re: [PATCH] net: tg3: tidy up loop, remove need to compute off with
 a multiply
From:   Joe Perches <joe@perches.com>
To:     Colin King <colin.king@canonical.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 08 May 2020 16:21:46 -0700
In-Reply-To: <20200508225301.484094-1-colin.king@canonical.com>
References: <20200508225301.484094-1-colin.king@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-05-08 at 23:53 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the value for 'off' is computed using a multiplication and
> a couple of statements later off is being incremented by len and
> this value is never read.  Clean up the code by removing the
> multiplication and just increment off by len on each iteration. Also
> use len instead of TG3_OCIR_LEN.

I think this is a lot harder to read.

> diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
[]
> @@ -10798,16 +10798,14 @@ static int tg3_init_hw(struct tg3 *tp, bool reset_phy)
>  static void tg3_sd_scan_scratchpad(struct tg3 *tp, struct tg3_ocir *ocir)
>  {
>  	int i;
> +	u32 off, len = TG3_OCIR_LEN;
>  
> -	for (i = 0; i < TG3_SD_NUM_RECS; i++, ocir++) {
> -		u32 off = i * TG3_OCIR_LEN, len = TG3_OCIR_LEN;
> -
> +	for (i = 0, off = 0; i < TG3_SD_NUM_RECS; i++, ocir++, off += len) {
>  		tg3_ape_scratchpad_read(tp, (u32 *) ocir, off, len);
> -		off += len;
>  
>  		if (ocir->signature != TG3_OCIR_SIG_MAGIC ||
>  		    !(ocir->version_flags & TG3_OCIR_FLAG_ACTIVE))
> -			memset(ocir, 0, TG3_OCIR_LEN);
> +			memset(ocir, 0, len);
>  	}
>  }

My preference would be for

{
	int i;
	u32 off = 0;

	for (i = 0; i < TG3_SD_NUM_RECS; i++) {
		tg3_ape_scratchpad_read(tp, (u32 *)ocir, off, TC3_OCIR_LEN);

		if (ocir->signature != TG3_OCIR_SIG_MAGIC ||
		    !(ocir->version_flags & TG3_OCIR_FLAG_ACTIVE))
			memset(ocir, 0, TG3_OCIR_LEN);

		off += TG3_OCIR_LEN;
		ocir++;
	}


