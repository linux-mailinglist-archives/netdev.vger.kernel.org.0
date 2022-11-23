Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45053635B06
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 12:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236840AbiKWLHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 06:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237133AbiKWLGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 06:06:40 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FEFD7A;
        Wed, 23 Nov 2022 03:06:15 -0800 (PST)
Date:   Wed, 23 Nov 2022 12:06:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669201574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0+upg52BtLT9oHrczBXFvaIQMySCLIal3hm8l0NDLnQ=;
        b=l6P32vFF870ypZx6vCoBcNNgylnWvrBUmEtcYRcXy0kC4LhfNZoPFwgNttx+vj4z5wSKMs
        vn0R0rCHUKYgVmCz92vdsSe961Z3VtAs7dzNEsbFtTOO8XqYz4W8PAMnYdRRVSJ4AFv1Wa
        ft7/SCUlKy2Jmg2zEGahbi/Vxb9wOE1B1ouYh1jYSbFG/bIN3M24g8kmbQXEIxFzWZA8I9
        AUncV4boGStW+ocIgtThmc2wweNnOlhxDOGwTfw6KkdaXTbMt0pQfqBCyBuvSaou/mE4Pe
        JP34yBeyRtHZe8ual+wzjM9X206u7+vlPqIllWbycEFVneffF9kaG4Bi9JrbzQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669201574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0+upg52BtLT9oHrczBXFvaIQMySCLIal3hm8l0NDLnQ=;
        b=SxPe9D9BGzUbhvSxqQS4b3uIXz2O6cBpEgHoPX1lNKZsBn8VsZihEBpiNn1TJIoH4DHOj/
        3ujtJx8+O88t8zAQ==
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
Message-ID: <165dcea1-2713-218b-fecf-5bf80452229@linutronix.de>
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

Could you expand this paragraph, so that is is not missleading when a
reader is not aware of the details of debug objects? Otherwise it seems to
the reader that debug objects will warn when timer->function == NULL.

  The warning of debug objects does not cover the original
  WARN_ON_ONCE(!timer->function). It warns when timer was not initialized
  using timer_setup[_on_stack]() or via DEFINE_TIMER().


> If developers fail to enable debug objects and then waste lots of time to
> figure out why their non-initialized timer is not firing, they deserve it.


Thanks,

	Anna-Maria

