Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48579632EE9
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 22:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbiKUVfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 16:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbiKUVfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 16:35:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0615B17A91;
        Mon, 21 Nov 2022 13:35:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8B50B81665;
        Mon, 21 Nov 2022 21:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D821C433C1;
        Mon, 21 Nov 2022 21:35:24 +0000 (UTC)
Date:   Mon, 21 Nov 2022 16:35:22 -0500
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
Subject: Re: [patch 10/15] timers: Silently ignore timers with a NULL
 function
Message-ID: <20221121163522.5eedbfe9@gandalf.local.home>
In-Reply-To: <20221115202117.560506554@linutronix.de>
References: <20221115195802.415956561@linutronix.de>
        <20221115202117.560506554@linutronix.de>
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

On Tue, 15 Nov 2022 21:28:49 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> @@ -1128,6 +1144,9 @@ static inline int
>   * mod_timer_pending() is the same for pending timers as mod_timer(), but
>   * will not activate inactive timers.
>   *
> + * If @timer->function == NULL then the start operation is silently
> + * discarded.
> + *
>   * Return:
>   * * %0 - The timer was inactive and not modified
>   * * %1 - The timer was active and requeued to expire at @expires
> @@ -1154,6 +1173,9 @@ EXPORT_SYMBOL(mod_timer_pending);
>   * same timer, then mod_timer() is the only safe way to modify the timeout,
>   * since add_timer() cannot modify an already running timer.
>   *
> + * If @timer->function == NULL then the start operation is silently
> + * discarded, the return value is 0 and meaningless.
> + *
>   * Return:
>   * * %0 - The timer was inactive and started

For those that only read the "Return" portion of kernel-doc, perhaps add
here:
             "or the timer is in the shutdown state and was not started".


>   * * %1 - The timer was active and requeued to expire at @expires or
> @@ -1175,6 +1197,9 @@ EXPORT_SYMBOL(mod_timer);
>   * modify an enqueued timer if that would reduce the expiration time. If
>   * @timer is not enqueued it starts the timer.
>   *
> + * If @timer->function == NULL then the start operation is silently
> + * discarded.
> + *
>   * Return:
>   * * %0 - The timer was inactive and started
>   * * %1 - The timer was active and requeued to expire at @expires or
> @@ -1201,6 +1226,9 @@ EXPORT_SYMBOL(timer_reduce);
>   *
>   * If @timer->expires is already in the past @timer will be queued to
>   * expire at the next timer tick.
> + *
> + * If @timer->function == NULL then the start operation is silently
> + * discarded.
>   */
>  void add_timer(struct timer_list *timer)
>  {
> @@ -1217,13 +1245,18 @@ EXPORT_SYMBOL(add_timer);
>   *
>   * This can only operate on an inactive timer. Attempts to invoke this on
>   * an active timer are rejected with a warning.
> + *
> + * If @timer->function == NULL then the start operation is silently
> + * discarded.
>   */
>  void add_timer_on(struct timer_list *timer, int cpu)
>  {
>  	struct timer_base *new_base, *base;
>  	unsigned long flags;
>  
> -	if (WARN_ON_ONCE(timer_pending(timer) || !timer->function))
> +	debug_assert_init(timer);
> +
> +	if (WARN_ON_ONCE(timer_pending(timer)))
>  		return;
>  
>  	new_base = get_timer_cpu_base(timer->flags, cpu);
> @@ -1234,6 +1267,13 @@ void add_timer_on(struct timer_list *tim
>  	 * wrong base locked.  See lock_timer_base().
>  	 */
>  	base = lock_timer_base(timer, &flags);
> +	/*
> +	 * Has @timer been shutdown? This needs to be evaluated while
> +	 * holding base lock to prevent a race against the shutdown code.
> +	 */
> +	if (!timer->function)
> +		goto out_unlock;
> +
>  	if (base != new_base) {
>  		timer->flags |= TIMER_MIGRATING;
>  
> @@ -1247,6 +1287,7 @@ void add_timer_on(struct timer_list *tim
>  
>  	debug_timer_activate(timer);
>  	internal_add_timer(base, timer);
> +out_unlock:
>  	raw_spin_unlock_irqrestore(&base->lock, flags);
>  }
>  EXPORT_SYMBOL_GPL(add_timer_on);
> @@ -1532,6 +1573,12 @@ static void expire_timers(struct timer_b
>  
>  		fn = timer->function;
>  
> +		if (WARN_ON_ONCE(!fn)) {
> +			/* Should never happen. Emphasis on should! */
> +			base->running_timer = NULL;
> +			return;

Why return and not continue?

Wont this drop the other timers in the queue?

-- Steve


> +		}
> +
>  		if (timer->flags & TIMER_IRQSAFE) {
>  			raw_spin_unlock(&base->lock);
>  			call_timer_fn(timer, fn, baseclk);

