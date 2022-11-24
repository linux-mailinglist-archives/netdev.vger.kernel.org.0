Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106F4637B00
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbiKXODn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiKXOD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:03:26 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C8DECCD3;
        Thu, 24 Nov 2022 06:00:39 -0800 (PST)
Date:   Thu, 24 Nov 2022 15:00:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669298438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gF/hDDUQQuamiBo9tk/P8dm4oq4tbevNf7bzKapxWj8=;
        b=h1Z0Yqw7yojuggrrs4UWtoOM1khJlf0X5HRDxmwTw/NE1xtaRRCIcVIPpL6cyNeenjvxfI
        Ya+C8rYblKXQUHnzBxchKEeBgcetJmS88su1r8ahNWwh+I43Q2fj4bddVfiaQuEWtrc0xH
        81KQlZIYxyfZTTI2e5QqgwxuGh1IdMAB+LxJLeX9QX2Gd8ewmh2kvbX774cPD9P6oSPvxz
        Wp/NxV9Q2g11hVJHZATEw+HDRrJJskNyQsqbKn+83r3Nqs2NCtGuOPe1RFuiayenZdiqPy
        Z8ZUYsDAPupORpOfEEwo9LyW4BcaQtqCbcwtcPWDlWtazLIzMabdG0oq5N9Ksg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669298438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gF/hDDUQQuamiBo9tk/P8dm4oq4tbevNf7bzKapxWj8=;
        b=LflPRjIlnkBisnfq9cmgMoN6Iw97sP/+aV3YrbrIjBehaC55j/DPrrXubo/35pb9NizcWi
        BsdFgArw6psC1GBQ==
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
Subject: Re: [patch V3 00/17] timers: Provide timer_shutdown[_sync]()
In-Reply-To: <20221123201306.823305113@linutronix.de>
Message-ID: <55c7744b-8a2c-e2b2-6c3-c2fa7ab978cc@linutronix.de>
References: <20221123201306.823305113@linutronix.de>
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

> This is the third version of the timer shutdown work. The second version
> can be found here:
> 
>   https://lore.kernel.org/all/20221122171312.191765396@linutronix.de
> 
> Tearing down timers can be tedious when there are circular dependencies to
> other things which need to be torn down. A prime example is timer and
> workqueue where the timer schedules work and the work arms the timer.
> 
> Steven and the Google Chromebook team ran into such an issue in the
> Bluetooth HCI code.
> 
> Steven suggested to create a new function del_timer_free() which marks the
> timer as shutdown. Rearm attempts of shutdown timers are discarded and he
> wanted to emit a warning for that case:
> 
>    https://lore.kernel.org/all/20220407161745.7d6754b3@gandalf.local.home
> 
> This resulted in a lengthy discussion and suggestions how this should be
> implemented. The patch series went through several iterations and during
> the review of the last version it turned out that this approach is
> suboptimal:
> 
>    https://lore.kernel.org/all/20221110064101.429013735@goodmis.org
> 
> The warning is not really helpful because it's entirely unclear how it
> should be acted upon. The only way to address such a case is to add 'if
> (in_shutdown)' conditionals all over the place. This is error prone and in
> most cases of teardown like the HCI one which started this discussion not
> required all.
> 
> What needs to prevented is that pending work which is drained via
> destroy_workqueue() does not rearm the previously shutdown timer. Nothing
> in that shutdown sequence relies on the timer being functional.
> 
> The conclusion was that the semantics of timer_shutdown_sync() should be:
> 
>     - timer is not enqueued
>     - timer callback is not running
>     - timer cannot be rearmed
> 
> Preventing the rearming of shutdown timers is done by discarding rearm
> attempts silently.
> 
> As Steven is short of cycles, I made some spare cycles available and
> reworked the patch series to follow the new semantics and plugged the races
> which were discovered during review.
> 
> The patches have been split up into small pieces to make review easier and
> I took the liberty to throw a bunch of overdue cleanups into the picture
> instead of proliferating the existing state further.
> 
> The last patch in the series addresses the HCI teardown issue for real.
> 
> The series is also available from git:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git timers
> 

With fix of the last NITs:

Reviewed-by: Anna-Maria Behnsen <anna-maria@linutronix.de>

Thanks,
	Anna-Maria

