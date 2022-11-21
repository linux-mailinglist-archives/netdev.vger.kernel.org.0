Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440B5632FBC
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 23:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbiKUWWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 17:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiKUWWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 17:22:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038AE18B0E;
        Mon, 21 Nov 2022 14:22:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 933A8614D7;
        Mon, 21 Nov 2022 22:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DD2C43147;
        Mon, 21 Nov 2022 22:21:59 +0000 (UTC)
Date:   Mon, 21 Nov 2022 17:21:57 -0500
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
Subject: Re: [patch 13/15] timers: Provide timer_shutdown[_sync]()
Message-ID: <20221121172157.2457df06@gandalf.local.home>
In-Reply-To: <20221115202117.734852797@linutronix.de>
References: <20221115195802.415956561@linutronix.de>
        <20221115202117.734852797@linutronix.de>
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

On Tue, 15 Nov 2022 21:28:54 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> +/**
> + * timer_shutdown_sync - Shutdown a timer and prevent rearming
> + * @timer: The timer to be shutdown
> + *
> + * When the function returns it is guaranteed that:
> + *   - @timer is not queued
> + *   - The callback function of @timer is not running
> + *   - @timer cannot be enqueued again. Any attempt to rearm
> + *     @timer is silently ignored.
> + *
> + * See timer_delete_sync() for synchronization rules.

 "See timer_delete_sync() for synchronization and context rules."

As where it can be executed is as important as the synchronization that is
needed.

-- Steve


> + *
> + * This function is useful for final teardown of an infrastructure where
> + * the timer is subject to a circular dependency problem.
> + *
> + * A common pattern for this is a timer and a workqueue where the timer can
> + * schedule work and work can arm the timer. On shutdown the workqueue must
> + * be destroyed and the timer must be prevented from rearming. Unless the
> + * code has conditionals like 'if (mything->in_shutdown)' to prevent that
> + * there is no way to get this correct with timer_delete_sync().
> + *
> + * timer_shutdown_sync() is solving the problem. The correct ordering of
> + * calls in this case is:
> + *
> + *	timer_shutdown_sync(&mything->timer);
> + *	workqueue_destroy(&mything->workqueue);
> + *
> + * After this 'mything' can be safely freed.
> + *
> + * This obviously requires that the timer is not required to be functional
> + * for the rest of the shutdown operation.
> + *
> + * Return:
> + * * %0 - The timer was not pending
> + * * %1 - The timer was pending
> + */
> +int timer_shutdown_sync(struct timer_list *timer)
> +{
> +	return __timer_delete_sync(timer, true);
> +}
> +EXPORT_SYMBOL_GPL(timer_shutdown_sync);
> +
