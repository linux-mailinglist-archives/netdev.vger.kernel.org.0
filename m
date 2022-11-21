Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128D4632DC8
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbiKUUTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiKUUTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:19:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B81BF5AA;
        Mon, 21 Nov 2022 12:18:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98D51B81233;
        Mon, 21 Nov 2022 20:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448C6C433C1;
        Mon, 21 Nov 2022 20:18:55 +0000 (UTC)
Date:   Mon, 21 Nov 2022 15:18:50 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [patch 05/15] timers: Replace BUG_ON()s
Message-ID: <20221121151850.635d3883@gandalf.local.home>
In-Reply-To: <20221115202117.267934419@linutronix.de>
References: <20221115195802.415956561@linutronix.de>
        <20221115202117.267934419@linutronix.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Nov 2022 21:28:41 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> The timer code still has a few BUG_ON()s left which are crashing the kernel
> in situations where it still can recover or simply refuse to take an
> action.
> 
> Remove the one in the hotplug callback which checks for the CPU being
> offline. If that happens then the whole hotplug machinery will explode in
> colourful ways.
> 
> Replace the rest with WARN_ON_ONCE() and conditional returns where
> appropriate.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/time/timer.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> --- a/kernel/time/timer.c
> +++ b/kernel/time/timer.c
> @@ -1193,7 +1193,8 @@ EXPORT_SYMBOL(timer_reduce);
>   */
>  void add_timer(struct timer_list *timer)
>  {
> -	BUG_ON(timer_pending(timer));
> +	if (WARN_ON_ONCE(timer_pending(timer)))
> +		return;
>  	__mod_timer(timer, timer->expires, MOD_TIMER_NOTPENDING);
>  }
>  EXPORT_SYMBOL(add_timer);
> @@ -1210,7 +1211,8 @@ void add_timer_on(struct timer_list *tim
>  	struct timer_base *new_base, *base;
>  	unsigned long flags;
>  
> -	BUG_ON(timer_pending(timer) || !timer->function);
> +	if (WARN_ON_ONCE(timer_pending(timer) || !timer->function))
> +		return;
>  
>  	new_base = get_timer_cpu_base(timer->flags, cpu);
>  

I wonder if this patch should be split up into two patches, as the above is
trivial and the below is a bit more "complex". Although it's probably moot
as none of these should ever trigger.

> @@ -2017,8 +2019,6 @@ int timers_dead_cpu(unsigned int cpu)
>  	struct timer_base *new_base;
>  	int b, i;
>  
> -	BUG_ON(cpu_online(cpu));
> -
>  	for (b = 0; b < NR_BASES; b++) {
>  		old_base = per_cpu_ptr(&timer_bases[b], cpu);
>  		new_base = get_cpu_ptr(&timer_bases[b]);
> @@ -2035,7 +2035,8 @@ int timers_dead_cpu(unsigned int cpu)
>  		 */
>  		forward_timer_base(new_base);
>  
> -		BUG_ON(old_base->running_timer);
> +		WARN_ON_ONCE(old_base->running_timer);
> +		old_base->running_timer = NULL;

I guess interesting things could happen if running_timer was not NULL, but
again, WARN_ON_ONCE() should never be triggered in a correctly running
kernel.

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve

>  
>  		for (i = 0; i < WHEEL_SIZE; i++)
>  			migrate_timer_list(new_base, old_base->vectors + i);

