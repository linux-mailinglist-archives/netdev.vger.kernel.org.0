Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562576355CD
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 10:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237616AbiKWJX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 04:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237425AbiKWJW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 04:22:59 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECE410CEB1;
        Wed, 23 Nov 2022 01:22:11 -0800 (PST)
Date:   Wed, 23 Nov 2022 10:22:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669195329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7RMwYBxd/qD5IH2N5zIliB0q90C6LaQNXHFoiPeMVds=;
        b=iBHF1UIYWIlQvLJc+DNDRoM9dbBI4oe+b/iIBptIhLCGgf222ipuJ2ESrIvypVgL7H96je
        YhJZtUK40AVWOiGBVNn15PAfR9MDBFjPbqzuLui/ZC/g6HtGXSEW2g0C5mYZUrvMdNUK4m
        OTRTFiFF9JygI9nhYYQVi0+IEOS2/HvUeUNhGPZvYoIlZ9r9SL8+aPsMTwjxLM/9HQ3Axl
        iuk+pmrGSEqSva/NfDA/vOJvOQnVT29f6y7cZ8cDcjC/+v7CLg0mLUlvDzMFy8T+rcTsWI
        4iTBLY5S7BEL77gu/IiGvjf/nm05bIM44nNjIlFpJYMJ5OVok5GdOmoBOcrmZQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669195329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7RMwYBxd/qD5IH2N5zIliB0q90C6LaQNXHFoiPeMVds=;
        b=5Xst4rypB6KjAJo0CRCzi9BjtfZn3S0LF4qAP2RGSLl0LTYmob0DBo4LgG9T44wiBHCdLR
        EArVEYKQYHKq9eBA==
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
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [patch V2 12/17] timers: Silently ignore timers with a NULL
 function
In-Reply-To: <20221122173648.793640919@linutronix.de>
Message-ID: <ce3f4736-33de-a6bd-6e86-567bec097bf@linutronix.de>
References: <20221122171312.191765396@linutronix.de> <20221122173648.793640919@linutronix.de>
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

On Tue, 22 Nov 2022, Thomas Gleixner wrote:

> Tearing down timers which have circular dependencies to other
> functionality, e.g. workqueues, where the timer can schedule work and work
> can arm timers is not trivial.

NIT (comma is missing): can arm timer, is not trivial.

> In those cases it is desired to shutdown the timer in a way which prevents
> rearming of the timer. The mechanism to do so it to set timer->function to

s/to do so it/to do so is/

> NULL and use this as an indicator for the timer arming functions to ignore
> the (re)arm request.
> 
> In preparation for that replace the warnings in the relevant code pathes
> with checks for timer->function == NULL and discard the rearm request
> silently.

Here is a verb missing that this is a grammatically correct (and
understandable) sentence.

> Add debug_assert_init() instead of the WARN_ON_ONCE(!timer->function)
> checks so that debug objects can warn about non-initialized timers.
> 
> If developers fail to enable debug objects and then waste lots of time to
> figure out why their non-initialized timer is not firing, they deserve it.
> 
> Co-developed-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> Link: https://lore.kernel.org/all/20220407161745.7d6754b3@gandalf.local.home
> Link: https://lore.kernel.org/all/20221110064101.429013735@goodmis.org
> ---
> V2: Use continue instead of return and amend the return value docs (Steven)
> ---
>  kernel/time/timer.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 55 insertions(+), 5 deletions(-)
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

Do you mean "was" or "is"? Please have also a look at the places where you
use the same phrase.

>   * * %1 - The timer was active and requeued to expire at @expires
>   */
>  int mod_timer_pending(struct timer_list *timer, unsigned long expires)
> @@ -1155,8 +1175,12 @@ EXPORT_SYMBOL(mod_timer_pending);
>   * same timer, then mod_timer() is the only safe way to modify the timeout,
>   * since add_timer() cannot modify an already running timer.
>   *
> + * If @timer->function == NULL then the start operation is silently
> + * discarded, the return value is 0 and meaningless.

It's easier to read, if you make a dot instead of comma.


Thanks,

	Anna-Maria
