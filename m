Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96C5269DAB
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 07:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgIOFDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 01:03:08 -0400
Received: from smtprelay0055.hostedemail.com ([216.40.44.55]:35882 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726061AbgIOFDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 01:03:07 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 2B8A61800BCF6;
        Tue, 15 Sep 2020 05:03:06 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:69:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3868:3871:4321:5007:6117:7903:10004:10400:11026:11232:11473:11657:11658:11914:12043:12109:12296:12297:12555:12740:12760:12895:13439:14181:14659:14721:21080:21433:21627:21809:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: fall88_11112c42710e
X-Filterd-Recvd-Size: 2856
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Tue, 15 Sep 2020 05:03:05 +0000 (UTC)
Message-ID: <44bf7e95e8326e02ca564bb9c7c0c75d22c78936.camel@perches.com>
Subject: Re: [PATCH net-next v5 2/6] lib8390: Replace pr_cont() with
 SMP-safe construct
From:   Joe Perches <joe@perches.com>
To:     Armin Wolf <W_Armin@gmx.de>, davem@davemloft.net
Cc:     netdev@vger.kernel.org
Date:   Mon, 14 Sep 2020 22:03:04 -0700
In-Reply-To: <20200914210128.7741-3-W_Armin@gmx.de>
References: <20200914210128.7741-1-W_Armin@gmx.de>
         <20200914210128.7741-3-W_Armin@gmx.de>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-09-14 at 23:01 +0200, Armin Wolf wrote:
> Replace pr_cont() with SMP-safe construct.
> 
> Signed-off-by: Armin Wolf <W_Armin@gmx.de>
> ---
>  drivers/net/ethernet/8390/lib8390.c | 31 +++++++++++------------------
>  1 file changed, 12 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/8390/lib8390.c
> index 3a2b1e33a47a..e8a323352c40 100644
> --- a/drivers/net/ethernet/8390/lib8390.c
> +++ b/drivers/net/ethernet/8390/lib8390.c
> @@ -518,25 +518,18 @@ static void ei_tx_err(struct net_device *dev)
>  {
>  	unsigned long e8390_base = dev->base_addr;
>  	/* ei_local is used on some platforms via the EI_SHIFT macro */
> -	struct ei_device *ei_local __maybe_unused = netdev_priv(dev);
> -	unsigned char txsr = ei_inb_p(e8390_base+EN0_TSR);
> -	unsigned char tx_was_aborted = txsr & (ENTSR_ABT+ENTSR_FU);
> -
> -#ifdef VERBOSE_ERROR_DUMP
> -	netdev_dbg(dev, "transmitter error (%#2x):", txsr);
> -	if (txsr & ENTSR_ABT)
> -		pr_cont(" excess-collisions ");
> -	if (txsr & ENTSR_ND)
> -		pr_cont(" non-deferral ");
> -	if (txsr & ENTSR_CRS)
> -		pr_cont(" lost-carrier ");
> -	if (txsr & ENTSR_FU)
> -		pr_cont(" FIFO-underrun ");
> -	if (txsr & ENTSR_CDH)
> -		pr_cont(" lost-heartbeat ");
> -	pr_cont("\n");
> -#endif
> -
> +	struct ei_device *ei_local = netdev_priv(dev);
> +	unsigned char txsr = ei_inb_p(e8390_base + EN0_TSR);
> +	unsigned char tx_was_aborted = txsr & (ENTSR_ABT + ENTSR_FU);
> +
> +	if (netif_msg_tx_err(ei_local)) {
> +		netdev_err(dev, "Transmitter error %#2x ( %s%s%s%s%s)", txsr,
> +			   (txsr & ENTSR_ABT) ? "excess-collisions " : "",
> +			   (txsr & ENTSR_ND) ? "non-deferral " : "",
> +			   (txsr & ENTSR_CRS) ? "lost-carrier " : "",
> +			   (txsr & ENTSR_FU) ? "FIFO-underrun " : "",
> +			   (txsr & ENTSR_CDH) ? "lost-heartbeat " : "");
> +	}

Still should use a terminating '\n' and likely
this might be better as:

	netif_dbg(ei_local, tx_err, dev, "Transmitter error ...\n",
		  etc...);


