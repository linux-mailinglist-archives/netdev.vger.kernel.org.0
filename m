Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3844F40D9
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353058AbiDEUDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457212AbiDEQC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:02:56 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1959113DDB;
        Tue,  5 Apr 2022 08:33:26 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649172804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=8ASus4u1QA/a9x22WdWo4eEieH828jzjqRFL7kX886U=;
        b=1P3Kii0NW65OFDEM/zPZ5aPmRWKA0lKLtlpv2OCU6WknI8uc7bvQaWizdVpiSwIlp5I32r
        /S7nbNZDO8gm2tVDicfBIv2L+hLSB35PWCHXkMyXOzPEhjUOlqVbpOwQYiG3+yhAJ+VsGZ
        Sjq3/GuPGCwsqZmODE/UT8So2DtVpnRjFv4y9/dtRUNKq087t5REIGgi3GMDEoCwBkMWzb
        2qjjyhVmL5t5VVfzA33TAqfJaJFjKlpoYecWrKchSmmLbnXnFJ9fWlT6Qfdmqkp71nwqrz
        iAgyx3L/UDvIWbteLNhcpipHk6yhMMsLX4gYb1EXVOhwPvsdf+LLRVUXh5QvTg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649172804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=8ASus4u1QA/a9x22WdWo4eEieH828jzjqRFL7kX886U=;
        b=GRILXDRwQcq59ReN7aYNgY2qJGEheQZksZtafXl6IP3Hki4hdyF6kWoy8OF/g4UwqTNUjI
        I+WX2ZcMbdpg3SBg==
To:     Artem Savkov <asavkov@redhat.com>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc:     netdev@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] timer: add a function to adjust timeouts to be
 upper bound
In-Reply-To: <YkfzZWs+Nj3hCvnE@sparkplug.usersys.redhat.com>
Date:   Tue, 05 Apr 2022 17:33:23 +0200
Message-ID: <871qyb35q4.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 02 2022 at 08:55, Artem Savkov wrote:
> On Wed, Mar 30, 2022 at 03:40:55PM +0200, Anna-Maria Behnsen wrote:
>> When calculating the level/index with a relative timeout, there is no
>> guarantee that the result is the same when actual enqueueing the timer with
>> expiry = jiffies + timeout .
>
> Yes, you are correct. This especially is a problem for timeouts placed
> just before LVL_START(x), which is a good chunk of cases. I don't
> think it is possible to get to timer_base clock without meddling with
> the hot-path.

Especially not when the timer might end up being migrated to a different
base, which would in the worst case require to do the calculation twice
if the base clocks differ.

The problem especially with network timers is that in the traffic case
the timers are often rearmed at high frequency. See the optimizations in
mod_timer() which try to avoid dequeue/enqueue sequences.

One of the main reasons for giving up on accuracy for the timer wheel
back then was to avoid two issues for networking:

    - Full rearming of a timer which ended up in the same expiry bucket
      due to software batching (incomplete, but with the same goal and
      the same 12.5% error margin).

    - Cascading bursts.

      We gathered statistics from various workloads which showed that
      99+% of all timers were canceled or rearmed before expiry, but
      under certain load scenarios a large portion of those timers where
      cascaded into a lower wheel level with smaller granularity before
      cancelation or rearming.

      As the wheel level granularity was strictly exponential the event
      of cascading a large amount (hint: thousands) of timers in one go
      was not uncommon. Cascading happened with interrupts disabled and
      it touched a usualy cold cache line per cascaded timer...

> Is it possible to determine the upper limit of error margin here? My
> assumption is it shouldn't be very big, so maybe it would be enough to
> account for this when adjusting timeout at the edge of a level.
> I know this doesn't sound good but I am running out of ideas here.

Let's just take a step back.

So we know, that the maximal error margin in the wheel is 12.5%, right?
That means, if you take your relative timeout and subtract 12.5% then
you are in the right ballpark and the earliest expiry will not be before
that point obviously, but it's also guaranteed not to expire later than
the original timeout. Obviously this will converge towards the early
expiry the longer the timeouts are, but it's bound.

Also due to the properties of the wheel, the lag of base::clk will
obviously only affect those levels where lag >= LVL_GRAN(level).

That's not perfect, but perfect is the enemy of good.

Thanks,

        tglx
