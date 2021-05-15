Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84ACF3818EF
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 15:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhEONL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 09:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhEONL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 09:11:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D68C061573;
        Sat, 15 May 2021 06:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fAzgbMupEdZq7k4jnscABWVAr393MLUY7L0uJlUvVmw=; b=YcA0XrBrPKFJIu86gydG4WM/84
        a1SfDCPKJbbPzY6Chb2Ew+AgSuXbrRYgzToN5WedvKFcQZWG3u0sVCxBVViDzvSBmiP6ZUN1fDExI
        iDwCKIolW7fE4A+/R+nkbUxB7TC0lOmaDgTTioaXE6U/oYyKcsMVwDg9BErhTcziuA3F0virDxxJq
        qPh0gOrchq4D6z9KlKrtWHtC+uQyLqefvHTUsRt6Bky025Q5N0e0W/gBXYif7NXQWJw2YFfnvhUVV
        dJh6JHN4FXElaREn+W+X3upjMDbk6+q7iyqvOhtlJcWv+U/XDKn4G655DjoTmZtIS12jVK+YCqiTn
        Xriad/ZA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lhu2q-00BF4C-IO; Sat, 15 May 2021 13:09:31 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id B526E986476; Sat, 15 May 2021 15:09:26 +0200 (CEST)
Date:   Sat, 15 May 2021 15:09:26 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Michal Svec <msvec@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hayes Wang <hayeswang@realtek.com>,
        Thierry Reding <treding@nvidia.com>,
        Lee Jones <lee.jones@linaro.org>,
        Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH RFC] r8152: Ensure that napi_schedule() is handled
Message-ID: <20210515130926.GC21560@worktop.programming.kicks-ass.net>
References: <877dk162mo.ffs@nanos.tec.linutronix.de>
 <20210514123838.10d78c35@kicinski-fedora-PC1C0HJN>
 <87sg2p2hbl.ffs@nanos.tec.linutronix.de>
 <20210514134655.73d972cb@kicinski-fedora-PC1C0HJN>
 <87fsyp2f8s.ffs@nanos.tec.linutronix.de>
 <20210514144130.7287af8e@kicinski-fedora-PC1C0HJN>
 <871ra83nop.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871ra83nop.ffs@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 15, 2021 at 01:23:02AM +0200, Thomas Gleixner wrote:
> We can make that work but sure I'm not going to argue when you decide to
> just go for raise_softirq_irqsoff().
> 
> I just hacked that check up which is actually useful beyond NAPI. It's
> straight forward except for that flush_smp_call_function_from_idle()
> oddball, which immeditately triggered that assert because block mq uses
> __raise_softirq_irqsoff() in a smp function call...
> 
> See below. Peter might have opinions though :)

Yeah, lovely stuff :-)


> +#define lockdep_assert_softirq_raise_ok()				\
> +do {									\
> +	WARN_ON_ONCE(__lockdep_enabled &&				\
> +		     !current->softirq_raise_safe &&			\
> +		     !(softirq_count() | hardirq_count()));		\
> +} while (0)

> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -691,7 +691,9 @@ void flush_smp_call_function_from_idle(v
>  	cfd_seq_store(this_cpu_ptr(&cfd_seq_local)->idle, CFD_SEQ_NOCPU,
>  		      smp_processor_id(), CFD_SEQ_IDLE);
>  	local_irq_save(flags);
> +	lockdep_set_softirq_raise_safe();
>  	flush_smp_call_function_queue(true);
> +	lockdep_clear_softirq_raise_safe();
>  	if (local_softirq_pending())
>  		do_softirq();

I think it might make more sense to raise hardirq_count() in/for
flush_smp_call_function_queue() callers that aren't already from hardirq
context. That's this site and smpcfd_dying_cpu().

Then we can do away with this new special case.
