Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCF7635A93
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237006AbiKWKwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237682AbiKWKwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:52:02 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CDDA471;
        Wed, 23 Nov 2022 02:39:03 -0800 (PST)
Date:   Wed, 23 Nov 2022 11:39:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669199942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bWx+syrVkp3Bs5TQK0zJVwfz+f2QVugtV7Vnnswr1DY=;
        b=KUZzCzQheoKwx9UCNhqqaf0xx6QqkOGpsWdU0nxl2HNAmA9rDPZfgWpo13JlhWHFIZKU1o
        pxqYLnkC1PWOiRr8zbn0v7fWO+JkspD+ogXX6JE1waI8vy5hKkszeapiQyqw0IRAV8HBpA
        muGFRmCS/htW9dvZjntjFOsWA0XQFHVvJCPPFcJMjb5DJLVqJ7gdwnYFiuTWezRB7qU6rk
        hfI60jE3YWZ79eR+QmXw8Rjy6ANnzEbycSsj0BM3rHVRjw95lqkmbPIaozpHAlHP1Fk9H9
        M+CSZxkD8y2Kvw++fVAnf7jXyRFNiDRSA/rsKmLMAbOPSqcf8a0NC0oTsxdYQw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669199942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bWx+syrVkp3Bs5TQK0zJVwfz+f2QVugtV7Vnnswr1DY=;
        b=t4BSrZeM86Ma19HnfSro2jQz0o+kyPq6OWYx9UbNR58mdx5CpR0IaxKKZZZiwJp69uznkV
        Sewrmksh9/wqZ1CQ==
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
Message-ID: <1f8f4b0-f9fe-c9c6-7620-862deff6b9d8@linutronix.de>
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
> 
> In those cases it is desired to shutdown the timer in a way which prevents
> rearming of the timer. The mechanism to do so it to set timer->function to
> NULL and use this as an indicator for the timer arming functions to ignore
> the (re)arm request.
> 
> In preparation for that replace the warnings in the relevant code pathes
> with checks for timer->function == NULL and discard the rearm request
> silently.
> 
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
> @@ -1202,6 +1230,9 @@ EXPORT_SYMBOL(timer_reduce);
>   *
>   * If @timer->expires is already in the past @timer will be queued to
>   * expire at the next timer tick.
> + *
> + * If @timer->function == NULL then the start operation is silently
> + * discarded.
>   */
>  void add_timer(struct timer_list *timer)
>  {

Could you move the new paragraph after the paragraph where is is mentioned,
that timer->function has to be set prior calling add_timer()?

Thanks,

       	Anna-Maria
