Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F48628A81C
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 17:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387553AbgJKP4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 11:56:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730174AbgJKP42 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 11:56:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 693C72223C;
        Sun, 11 Oct 2020 15:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602431787;
        bh=pqoA6wkSIxse6OFFBq+N4TiZpT55U12SAaPD59TIWIs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AIE3Sg6Ey+hhdmnuXTo7IVTvffCxtk0GV5yAXPUYzjJDxLHHhr2C1XDeLKa/rsuiv
         hKMJXkil72xrDpSNF6jHRzpTwwWONo7wd1r4eavuvMOKowlrdyBXDqYyTYZYJH/UnX
         J8/H4gEoaybf2hqarkomcmesA38JqRQU7AP6U4Wo=
Date:   Sun, 11 Oct 2020 08:56:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     John Keeping <john@metanate.com>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] net: stmmac: Don't call _irqoff() with hardirqs enabled
Message-ID: <20201011085626.6bec051f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <04d10b06-ca1c-3bfa-0a5f-730a9c8a2744@gmail.com>
References: <20201008162749.860521-1-john@metanate.com>
        <8036d473-68bd-7ee7-e2e9-677ff4060bd3@gmail.com>
        <20201009085805.65f9877a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <725ba7ca-0818-074b-c380-15abaa5d037b@gmail.com>
        <070b2b87-f38c-088d-4aaf-12045dbd92f7@gmail.com>
        <20201010082248.22cc7656@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <04d10b06-ca1c-3bfa-0a5f-730a9c8a2744@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 15:42:24 +0200 Heiner Kallweit wrote:
> On 10.10.2020 17:22, Jakub Kicinski wrote:
> > On Sat, 10 Oct 2020 15:08:15 +0200 Heiner Kallweit wrote:  
> >> On 09.10.2020 18:06, Heiner Kallweit wrote:  
> >>> On 09.10.2020 17:58, Jakub Kicinski wrote:    
> >>>> On Fri, 9 Oct 2020 16:54:06 +0200 Heiner Kallweit wrote:    
> >>>>> I'm thinking about a __napi_schedule version that disables hard irq's
> >>>>> conditionally, based on variable force_irqthreads, exported by the irq
> >>>>> subsystem. This would allow to behave correctly with threadirqs set,
> >>>>> whilst not loosing the _irqoff benefit with threadirqs unset.
> >>>>> Let me come up with a proposal.    
> >>>>
> >>>> I think you'd need to make napi_schedule_irqoff() behave like that,
> >>>> right?  Are there any uses of napi_schedule_irqoff() that are disabling
> >>>> irqs and not just running from an irq handler?
> >>>>    
> >>> Right, the best approach depends on the answer to the latter question.
> >>> I didn't check this yet, therefore I described the least intrusive approach.
> >>>     
> >>
> >> With some help from coccinelle I identified the following functions that
> >> call napi_schedule_irqoff() or __napi_schedule_irqoff() and do not run
> >> from an irq handler (at least not at the first glance).
> >>
> >> dpaa2_caam_fqdan_cb
> >> qede_simd_fp_handler
> >> mlx4_en_rx_irq
> >> mlx4_en_tx_irq  
> > 
> > Don't know the others but FWIW the mlx4 ones run from an IRQ handler,
> > AFAICT:
> > 
> > static irqreturn_t mlx4_interrupt(int irq, void *dev_ptr)
> > static irqreturn_t mlx4_msi_x_interrupt(int irq, void *eq_ptr)
> >   mlx4_eq_int()
> >     mlx4_cq_completion
> >       cq->comp()
> >   
> >> qeth_qdio_poll
> >> netvsc_channel_cb
> >> napi_watchdog  
> > 
> > This one runs from a hrtimer, which I believe will be a hard irq
> > context on anything but RT. I could be wrong.
> >   
> 
> Typically forced irq threading will not be enabled, therefore going
> back to use napi_schedule() in drivers in most cases will cause
> losing the benefit of the irqoff version. Something like the following
> should be better. Only small drawback I see is that in case of forced
> irq threading hrtimers will still run in hardirq context and we lose
> the benefit of the irqoff version in napi_watchdog().
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index a146bac84..7d18560b2 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6393,7 +6393,11 @@ EXPORT_SYMBOL(napi_schedule_prep);
>   */
>  void __napi_schedule_irqoff(struct napi_struct *n)
>  {
> -	____napi_schedule(this_cpu_ptr(&softnet_data), n);
> +	/* hard irqs may not be masked in case of forced irq threading */
> +	if (force_irqthreads)
> +		__napi_schedule(n);
> +	else
> +		____napi_schedule(this_cpu_ptr(&softnet_data), n);
>  }
>  EXPORT_SYMBOL(__napi_schedule_irqoff);

Does

	if (force_irqthreads)
		local_irq_save(flags);
	____napi_schedule(this_cpu_ptr(&softnet_data), n);
	if (force_irqthreads)
		local_irq_restore(flags);

not produce more concise assembly?
