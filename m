Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091326A993F
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 15:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbjCCORW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 09:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCCORV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 09:17:21 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96B83CE3A;
        Fri,  3 Mar 2023 06:17:19 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677853037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c59/pZtJ4BPMeqcHgfx7bb0sCxiifET9QkB2iiMvL70=;
        b=uYDrfbdFFxTx/MlPDo2DSer/FW9mAdABsQ6QxUlbI7KCeO4FZFtHmG/pUaoNSlcPORz/HT
        oSS0MuaiaCoF6CTIglkX8LfNjMqJB7c73ZHsW8fHCuFC3OIKZkNTkpunFsIVcVvQmMzB+C
        f0+XlffnROsQO0FVStl9BfXEzb5++xhqPUG4TWI2DlIrrO/zY4kSjvDIY+7eHxWiH0UBXi
        S7DnRp2ju8nexW0MYathrvEqyB6AnaVoyithPgvrWiSf5wx4zE/pXTdyUGFZ3er9nhn0CC
        Ff9kRLsd0S8yQUIKwQU424Of82ljE7dPURxVc6uxz13nNAsPXBtLa5gWYaRQtg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677853037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c59/pZtJ4BPMeqcHgfx7bb0sCxiifET9QkB2iiMvL70=;
        b=bE0/L8qjyqbXIK/qu1RacGNDEWO+yGBA7j2F04qNFENU6/kEgzIOUbrH+Kh6odwut7zqiL
        nCKFBbqdfLIg6/AA==
To:     Jakub Kicinski <kuba@kernel.org>, peterz@infradead.org
Cc:     jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 3/3] softirq: don't yield if only expedited handlers are
 pending
In-Reply-To: <20221222221244.1290833-4-kuba@kernel.org>
References: <20221222221244.1290833-1-kuba@kernel.org>
 <20221222221244.1290833-4-kuba@kernel.org>
Date:   Fri, 03 Mar 2023 15:17:17 +0100
Message-ID: <87mt4tkjgy.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub!

On Thu, Dec 22 2022 at 14:12, Jakub Kicinski wrote:
> This leads to a situation where we go thru the softirq loop twice.
> First round we have pending = NET (from the NIC IRQ/NAPI), and
> the second iteration has pending = TASKLET (the socket tasklet).

...

> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index ad200d386ec1..4ac59ffb0d55 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -601,7 +601,7 @@ asmlinkage __visible void __softirq_entry __do_softirq(void)
>  
>  		if (time_is_before_eq_jiffies(end) || !--max_restart)
>  			limit = SOFTIRQ_OVERLOAD_TIME;
> -		else if (need_resched())
> +		else if (need_resched() && pending & ~SOFTIRQ_NOW_MASK)
>  			limit = SOFTIRQ_DEFER_TIME;
>  		else
>  			goto restart;

While this is the least of my softirq worries on PREEMPT_RT, Peter is
right about real-time tasks being deferred on a PREEMPT_RT=n
kernel. That's a real issue for low-latency audio which John Stultz is
trying to resolve. Especially as the above check can go in circles.

I fear we need to go back to the drawing board and come up with a real
solution which takes these contradicting aspects into account. Let me
stare at Peters and Johns patches for a while.

Thanks

        tglx


