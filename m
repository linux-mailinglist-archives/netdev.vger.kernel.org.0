Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30E86372F2
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 08:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiKXHhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 02:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiKXHhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 02:37:38 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B05F95AC;
        Wed, 23 Nov 2022 23:37:34 -0800 (PST)
Date:   Thu, 24 Nov 2022 08:37:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669275452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R7IPR3D+2Uj3z9wyAmJvuyCVbX35tyzgdGaPWhfMVFU=;
        b=cyK3yXtZPH/MmeCGW9/Y7sa0S8j3U4V3cbZvcG7kljTMBRfM0Y0QkdauTW+7DBjoQjZtTr
        Smv7dXzSJykzTNJSGc8sLgPdzbbDlfoTKd/C8NOokzgmUYyb8tklUcrtDDn4C15je2/t5S
        qZ1JQCGr47d8HQHaAaN8lAer6OE19hnNpyB1jgifOrlEnW6D7thcZgBd7eWn+yIeCGQbN8
        JAwvmeLK9L9DAYhNk5u69q40Gq9krI/dQFO6xIn3O7kgU2+P46t20owVpLaEAWKInjhFqR
        wlWQJvdR2QKQazhoXmXtNlH26Ho7CMc2H6AHQCb4EHtFSJuPBzjiNZwLJTi/Yg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669275452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R7IPR3D+2Uj3z9wyAmJvuyCVbX35tyzgdGaPWhfMVFU=;
        b=upalo9fPCSzAMl+wEAxT8iWIYDUFQBY6xP1a37mssQ+s+quUZB6ymRcbfF4PbBXUAt2ltk
        VvbgJt/W+r7rfFDQ==
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
Subject: Re: [patch V3 12/17] timers: Silently ignore timers with a NULL
 function
In-Reply-To: <20221123201625.135055320@linutronix.de>
Message-ID: <644695b9-f343-7fb7-ed8e-763e5fe3d158@linutronix.de>
References: <20221123201306.823305113@linutronix.de> <20221123201625.135055320@linutronix.de>
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
> In preparation for that replace the warnings in the relevant code paths
> with checks for timer->function == NULL. If the pointer is NULLL, then

s/NULLL/NULL

> discard the rearm request silently.
> 
> Add debug_assert_init() instead of the WARN_ON_ONCE(!timer->function)
> checks so that debug objects can warn about non-initialized timers.
> 
> The warning of debug objects does warn if timer->function == NULL.  It

does NOT warn

> warns when timer was not initialized using timer_setup[_on_stack]() or via
> DEFINE_TIMER(). If developers fail to enable debug objects and then waste
> lots of time to figure out why their non-initialized timer is not firing,
> they deserve it. Same for initializing a timer with a NULL function.
> 
> Co-developed-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Link: https://lore.kernel.org/all/20220407161745.7d6754b3@gandalf.local.home
> Link: https://lore.kernel.org/all/20221110064101.429013735@goodmis.org
> ---
> V2: Use continue instead of return and amend the return value docs (Steven)
> V3: Changelog and comment updates (Anna-Maria)
> ---
>  kernel/time/timer.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 52 insertions(+), 5 deletions(-)
> 
> --- a/kernel/time/timer.c
> +++ b/kernel/time/timer.c
> @@ -1128,8 +1144,12 @@ static inline int
>   * mod_timer_pending() is the same for pending timers as mod_timer(), but
>   * will not activate inactive timers.
>   *
> + * If @timer->function == NULL then the start operation is silently
> + * discarded.
> + *
>   * Return:
> - * * %0 - The timer was inactive and not modified
> + * * %0 - The timer was inactive and not modified or was is in
> + *	  shutdown state and the operation was discarded

You forgot to update this "was is" mistake. All other places are fine.

>   * * %1 - The timer was active and requeued to expire at @expires
>   */
>  int mod_timer_pending(struct timer_list *timer, unsigned long expires)

Thanks,

	Anna-Maria

