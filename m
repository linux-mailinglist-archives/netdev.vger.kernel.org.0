Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F74B632FAD
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 23:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbiKUWTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 17:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbiKUWSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 17:18:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113FF657F6;
        Mon, 21 Nov 2022 14:18:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8FEDB816A1;
        Mon, 21 Nov 2022 22:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC7FC43152;
        Mon, 21 Nov 2022 22:18:06 +0000 (UTC)
Date:   Mon, 21 Nov 2022 17:18:03 -0500
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
Subject: Re: [patch 12/15] timers: Add shutdown mechanism to the internal
 functions
Message-ID: <20221121171803.35a1811e@gandalf.local.home>
In-Reply-To: <20221115202117.677534558@linutronix.de>
References: <20221115195802.415956561@linutronix.de>
        <20221115202117.677534558@linutronix.de>
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

On Tue, 15 Nov 2022 21:28:52 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> Tearing down timers which have circular dependencies to other
> functionality, e.g. workqueues, where the timer can schedule work and work
> can arm timers is not trivial.
> 
> In those cases it is desired to shutdown the timer in a way which prevents
> rearming of the timer. The mechanism to do so it to set timer->function to
> NULL and use this as an indicator for the timer arming functions to ignore
> the (re)arm request.
> 
> Add a shutdown argument to the relevant internal functions which makes the
> actual deactivation code set timer->function to NULL which in turn prevents
> rearming of the timer.
> 
> Co-developed-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Link: https://lore.kernel.org/all/20220407161745.7d6754b3@gandalf.local.home
> Link: https://lore.kernel.org/all/20221110064101.429013735@goodmis.org
> ---
>  kernel/time/timer.c |   64 ++++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 55 insertions(+), 9 deletions(-)
> 
> --- a/kernel/time/timer.c
> +++ b/kernel/time/timer.c
> @@ -1293,14 +1293,21 @@ void add_timer_on(struct timer_list *tim
>  EXPORT_SYMBOL_GPL(add_timer_on);
>  
>  /**
> - * __timer_delete - Internal function: Deactivate a timer.
> + * __timer_delete - Internal function: Deactivate a timer
>   * @timer:	The timer to be deactivated
> + * @shutdown:	If true this indicates that the timer is about to be

Nit, needs a common (or "then") after true.


> + *		shutdown permanently.
> + *
> + * If @shutdown is true then @timer->function is set to NULL under the
> + * timer base lock which prevents further rearming of the time. In that
> + * case any attempt to rearm @timer after this function returns will be
> + * silently ignored.
>   *
>   * Return:
>   * * %0 - The timer was not pending
>   * * %1 - The timer was pending and deactivated
>   */
> -static int __timer_delete(struct timer_list *timer)
> +static int __timer_delete(struct timer_list *timer, bool shutdown)
>  {
>  	struct timer_base *base;
>  	unsigned long flags;
> @@ -1308,9 +1315,22 @@ static int __timer_delete(struct timer_l
>  
>  	debug_assert_init(timer);
>  
> -	if (timer_pending(timer)) {
> +	/*
> +	 * If @shutdown is set then the lock has to be taken whether the
> +	 * timer is pending or not to protect against a concurrent rearm
> +	 * which might hit between the lockless pending check and the lock
> +	 * aquisition. By taking the lock it is ensured that such a newly
> +	 * enqueued timer is dequeued and cannot end up with
> +	 * timer->function == NULL in the expiry code.
> +	 *
> +	 * If timer->function is currently executed, then this makes sure
> +	 * that the callback cannot requeue the timer.
> +	 */
> +	if (timer_pending(timer) || shutdown) {
>  		base = lock_timer_base(timer, &flags);
>  		ret = detach_if_pending(timer, base, true);
> +		if (shutdown)
> +			timer->function = NULL;
>  		raw_spin_unlock_irqrestore(&base->lock, flags);
>  	}
>  
> @@ -1332,20 +1352,31 @@ static int __timer_delete(struct timer_l
>   */
>  int timer_delete(struct timer_list *timer)
>  {
> -	return __timer_delete(timer);
> +	return __timer_delete(timer, false);
>  }
>  EXPORT_SYMBOL(timer_delete);
>  
>  /**
>   * __try_to_del_timer_sync - Internal function: Try to deactivate a timer
>   * @timer:	Timer to deactivate
> + * @shutdown:	If true this indicates that the timer is about to be

Same here.

> + *		shutdown permanently.
> + *
> + * If @shutdown is true then @timer->function is set to NULL under the
> + * timer base lock which prevents further rearming of the timer. Any
> + * attempt to rearm @timer after this function returns will be silently
> + * ignored.
> + *
> + * This function cannot guarantee that the timer cannot be rearmed
> + * right after dropping the base lock if @shutdown is false. That
> + * needs to be prevented by the calling code if necessary.
>   *
>   * Return:
>   * * %0  - The timer was not pending
>   * * %1  - The timer was pending and deactivated
>   * * %-1 - The timer callback function is running on a different CPU
>   */
> -static int __try_to_del_timer_sync(struct timer_list *timer)
> +static int __try_to_del_timer_sync(struct timer_list *timer, bool shutdown)
>  {
>  	struct timer_base *base;
>  	unsigned long flags;
> @@ -1357,6 +1388,8 @@ static int __try_to_del_timer_sync(struc
>  
>  	if (base->running_timer != timer)
>  		ret = detach_if_pending(timer, base, true);
> +	if (shutdown)
> +		timer->function = NULL;
>  
>  	raw_spin_unlock_irqrestore(&base->lock, flags);
>  
> @@ -1379,7 +1412,7 @@ static int __try_to_del_timer_sync(struc
>   */
>  int try_to_del_timer_sync(struct timer_list *timer)
>  {
> -	return __try_to_del_timer_sync(timer);
> +	return __try_to_del_timer_sync(timer, false);
>  }
>  EXPORT_SYMBOL(try_to_del_timer_sync);
>  
> @@ -1460,12 +1493,25 @@ static inline void del_timer_wait_runnin
>   * __timer_delete_sync - Internal function: Deactivate a timer and wait
>   *			 for the handler to finish.
>   * @timer:	The timer to be deactivated
> + * @shutdown:	If true @timer->function will be set to NULL under the

Here too.

-- Steve

> + *		timer base lock which prevents rearming of @timer
> + *
> + * If @shutdown is not set the timer can be rearmed later. If the timer can
> + * be rearmed concurrently, i.e. after dropping the base lock then the
> + * return value is meaningless.
> + *
> + * If @shutdown is set then @timer->function is set to NULL under timer
> + * base lock which prevents rearming of the timer. Any attempt to rearm
> + * a shutdown timer is silently ignored.
> + *
> + * If the timer should be reused after shutdown it has to be initialized
> + * again.
>   *
>   * Return:
>   * * %0	- The timer was not pending
>   * * %1	- The timer was pending and deactivated
>   */
> -static int __timer_delete_sync(struct timer_list *timer)
> +static int __timer_delete_sync(struct timer_list *timer, bool shutdown)
>  {
>  	int ret;
>  
> @@ -1495,7 +1541,7 @@ static int __timer_delete_sync(struct ti
>  		lockdep_assert_preemption_enabled();
>  
>  	do {
> -		ret = __try_to_del_timer_sync(timer);
> +		ret = __try_to_del_timer_sync(timer, shutdown);
>  
>  		if (unlikely(ret < 0)) {
>  			del_timer_wait_running(timer);
> @@ -1547,7 +1593,7 @@ static int __timer_delete_sync(struct ti
>   */
>  int timer_delete_sync(struct timer_list *timer)
>  {
> -	return __timer_delete_sync(timer);
> +	return __timer_delete_sync(timer, false);
>  }
>  EXPORT_SYMBOL(timer_delete_sync);
>  

