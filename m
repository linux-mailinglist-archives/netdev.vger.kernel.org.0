Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD91381B03
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 22:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234918AbhEOUkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 16:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231463AbhEOUj6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 16:39:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2648061370;
        Sat, 15 May 2021 20:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621111125;
        bh=FQbc6ClsB85LyOT0Vkw30qDCJ5Ajv2IDqsQ9FfNK+2Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CnFj34UsFO3aDFbawxm5eeB/bLqQ0SozitxIMXHGCWGH50Tj7r+BEYvvxyth95Svo
         6pZQnTyoeRl2UEEdKpKti/fInrKo90ZBX1rkvgY1TSnBublxoWh48ioO4iM7wK0SZ5
         36mOqfHYzLyALIM2eA0tPUL2bzGJG1DxxBDP2g3Xe74DQPGFAi746k86nIBVSZm9UZ
         kVwn7V/N0WQqA6m4YJNKl9CPzMqIAnJ9DanNNhAv1LMOwhXDAW1298i3chfzFMkXlY
         LAHuyT3sChTiVCOFaVmbqqKbZmD2AMoXSMP7D4cGGauc/U8p4ZGGyEqrAf1EzZziNv
         2ZzZ3k6ODq4Yg==
Date:   Sat, 15 May 2021 13:38:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, simon.horman@netronome.com,
        oss-drivers@netronome.com, bigeasy@linutronix.de
Subject: Re: [PATCH net-next 1/2] net: add a napi variant for
 RT-well-behaved drivers
Message-ID: <20210515133844.21f08a5e@kicinski-fedora-PC1C0HJN>
In-Reply-To: <87pmxs1g4x.ffs@nanos.tec.linutronix.de>
References: <20210514222402.295157-1-kuba@kernel.org>
        <87pmxs1g4x.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 15 May 2021 11:49:02 +0200 Thomas Gleixner wrote:
> On Fri, May 14 2021 at 15:24, Jakub Kicinski wrote:
> >  /**
> > - *	napi_schedule_irqoff - schedule NAPI poll
> > - *	@n: NAPI context
> > + * napi_schedule_irq() - schedule NAPI poll from hardware IRQ
> > + * @n: NAPI context
> >   *
> >   * Variant of napi_schedule(), assuming hard irqs are masked.
> > + * Hardware interrupt handler must be marked with IRQF_NO_THREAD
> > + * to safely invoke this function on CONFIG_RT=y kernels (unless
> > + * it manually masks the interrupts already).
> >   */
> > -static inline void napi_schedule_irqoff(struct napi_struct *n)
> > +static inline void napi_schedule_irq(struct napi_struct *n)
> >  {
> >  	if (napi_schedule_prep(n))
> > -		__napi_schedule_irqoff(n);
> > +		__napi_schedule_irq(n);  
> 
> As this is intended for the trivial
> 
>    irqhandler()
>         napi_schedule_irq(n);
>         return IRQ_HANDLED;
> 
> case, wouldn't it make sense to bring napi_schedule_irq() out of line
> and have the prep invocation right there?
> 
> void napi_schedule_irq(struct napi_struct *n)
> {
>  	if (napi_schedule_prep(n))
> 		____napi_schedule(this_cpu_ptr(&softnet_data), n);
> }
> EXPORT_SYMBOL(napi_schedule_irq);
> 
> As that spares a function call and lets the compiler be smarter about
> it. I might be missing something though, but at least brain is more
> awake now :)

I'm just copying the existing two handlers (reviewer's favorite
response, I know) :)

My guess is .._prep() used to be a static inline itself, I can look 
at modifying all helpers if the assembly really looks better, but based
on Sebastian's email I'm not sure we're gonna go ahead with the new 
helper at all?
