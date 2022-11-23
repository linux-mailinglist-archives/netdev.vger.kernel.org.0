Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674B1635C50
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 13:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237133AbiKWMCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 07:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235568AbiKWMCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 07:02:34 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A63FE60;
        Wed, 23 Nov 2022 04:02:30 -0800 (PST)
Date:   Wed, 23 Nov 2022 13:02:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669204948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GBqote1BzkExg7MDXCmwtPPCsS+a19i+SHqr+lLca80=;
        b=y0HTq8Y1ZNK8Wtx/oprXpMyJ2N9mqtEFNwZt5LxOb1F9SRbDb3Rhf5nS6KvVLSK2yr+chq
        UAyUIMyIP5VBrhr2JJnGC3jFzBXDOjNtD8ugbm4sj8C/CFYUJFowIFBG8f9BuwC9O+oqlq
        LWhr8pvgWkG7kZsIIEKSW+d4BuIGoFCa8Qgf4jXlGE1OFJgFrPJBBtd6ww4aXRoKaoNoyo
        dl/u7FQPSCSzXHWVDTOl+c2uoYrzmGN/gfKHXj4EgtGiHmOa9gtB3YFnQpjugeSpTfRHZK
        u90AdOsj9cTnYrqs1rXagGk5UviSpZ6RHlUBx5Kb7CQSJU4MdSeyXZBmTM36nQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669204948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GBqote1BzkExg7MDXCmwtPPCsS+a19i+SHqr+lLca80=;
        b=+dQr51Q/aNU9Zi95upJOwnukC6/3AeHNq7llh46X/GY39Cd4rhXeE02hvdPBokTfSOXfey
        JuOTX+74Hbe2BNBQ==
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
Subject: Re: [patch V2 15/17] timers: Provide timer_shutdown[_sync]()
In-Reply-To: <20221122173648.962476045@linutronix.de>
Message-ID: <3779da12-6da5-8f6b-ec93-f8d52e38a40@linutronix.de>
References: <20221122171312.191765396@linutronix.de> <20221122173648.962476045@linutronix.de>
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

> @@ -1605,6 +1629,48 @@ int timer_delete_sync(struct timer_list
>  }
>  EXPORT_SYMBOL(timer_delete_sync);
>  
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

NIT... Maybe the first requires could be replaced by
assumes/expects/presupposes to prevent double use of required?

Thanks,

	Anna-Maria

