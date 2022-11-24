Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4012A637A3E
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 14:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiKXNsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 08:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiKXNsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 08:48:04 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9BA1B791;
        Thu, 24 Nov 2022 05:48:03 -0800 (PST)
Date:   Thu, 24 Nov 2022 14:48:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669297682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1dPUZbRDq+w3xgCnVHaPIQvAFpBAuWURnnoA1oTqYfw=;
        b=hoChWmaBUSRzsmSnJk1bQPYhGXlreqbe6wbECUZNgL5vJAHwK6bOKal930Wr0dOfikygao
        u2Y6+rIOUxHwfxP/tqVqocJpYSl5qFDBl0hMDAO2IgFjyneCf4N7chM1I3uizBRSSqzeZJ
        KtC/7GdRCs1L5gYOv2Je35011iw608/24FP+Rebtf6PpxXxydoev4BkyI5LtjpRdTxZdWQ
        QMJCuRGN7MRGWueKt/i3dZkRMiwfUCgsgXOA7rLTJCQcjMv5eJK+WgxfQOOZarm6eXj3py
        N31e7K5qlDkpf54JunJyXgiVqJqfOJxuCPBZDa9PQQLrq/FsbMO9+G2VzOMDwA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669297682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1dPUZbRDq+w3xgCnVHaPIQvAFpBAuWURnnoA1oTqYfw=;
        b=Z8wXuvr0mnNlK6lDvqG955a3Y2RoB45dCmmYZN4ZXsPsQrCcOgjlOwegYq1sKObXC/YdHw
        fLm8uZJqtVxo9ZCA==
From:   Anna-Maria Behnsen <anna-maria@linutronix.de>
To:     Thomas Gleixner <tglx@linutronix.de>
cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [patch V3 14/17] timers: Add shutdown mechanism to the internal
 functions
In-Reply-To: <20221123201625.253883224@linutronix.de>
Message-ID: <d68c67a2-6488-89e9-4e56-e6efdb1260f@linutronix.de>
References: <20221123201306.823305113@linutronix.de> <20221123201625.253883224@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Nov 2022, Thomas Gleixner wrote:

> Tearing down timers which have circular dependencies to other
> functionality, e.g. workqueues, where the timer can schedule work and work
> can arm timers, is not trivial.
> 
> In those cases it is desired to shutdown the timer in a way which prevents
> rearming of the timer. The mechanism to do so is to set timer->function to
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
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Link: https://lore.kernel.org/all/20220407161745.7d6754b3@gandalf.local.home
> Link: https://lore.kernel.org/all/20221110064101.429013735@goodmis.org
> ---
> V2: Add missing commata (Steven)
> V3: Changelog updates (Anna-Maria)
> ---
>  kernel/time/timer.c |   64 ++++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 55 insertions(+), 9 deletions(-)
> 
> --- a/kernel/time/timer.c
> +++ b/kernel/time/timer.c
> @@ -1297,14 +1297,21 @@ void add_timer_on(struct timer_list *tim
>  EXPORT_SYMBOL_GPL(add_timer_on);
>  
>  /**
> - * __timer_delete - Internal function: Deactivate a timer.
> + * __timer_delete - Internal function: Deactivate a timer

Some more NIT: You already updated the line a patch before. Maybe remove
the dot in the patch before and you get rid of this unneccessary
delete/insert of the above line in this hunk.

>   * @timer:	The timer to be deactivated
> + * @shutdown:	If true, this indicates that the timer is about to be
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

Thanks,

	Anna-Maria

