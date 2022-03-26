Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C794E8451
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 22:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiCZVPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 17:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiCZVPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 17:15:34 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC982111;
        Sat, 26 Mar 2022 14:13:55 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1648329233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mbQY8BdXJSy15or2VA0tthqhZce+ka6Ne142NTDmrFU=;
        b=4aNofIJ68CTv6Fd4K2Nl6TSsQKoNzeMdxmM2m3PYRmewpGKcv2kT1L7Hog7bBoXEgMr2Fk
        mXyCQFLjsq1n9SmidzOETuKlZOx5tLMpgLoD1iRRTLSELh4gHcvtROAEP2toaTgMXo0rIX
        5Z4eLVscxWRxga2P/atYD8MtLS7AtNKW6rCR5KX8YIq1SUCeyUvjTS1OCHVk+ityZwKufR
        T5DlmJQhIa/jEErMD0+lZKXFXtyig3MWNHm7zsUMIkpG/D7+r1ZMxw857n/EPD6We4axTW
        3yii6RCQJzlMs9MbwQLlxvQrr1/hjCrOsHu7qSmAJEBLUiGEurleY9/lutjvFA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1648329233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mbQY8BdXJSy15or2VA0tthqhZce+ka6Ne142NTDmrFU=;
        b=+Ie63okd/iD/11vBwRhZQXmJI5KcIkd/7JvhH8IluJISuYdX4+L/CiTb/8u+dM26la1z7i
        B7KKrwbQgPzJ7TDw==
To:     Artem Savkov <asavkov@redhat.com>, jpoimboe@redhat.com,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, Artem Savkov <asavkov@redhat.com>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>
Subject: Re: [PATCH 1/2] timer: introduce upper bound timers
In-Reply-To: <87tubn8rgk.ffs@tglx>
References: <20220323111642.2517885-1-asavkov@redhat.com>
 <20220323111642.2517885-2-asavkov@redhat.com> <87tubn8rgk.ffs@tglx>
Date:   Sat, 26 Mar 2022 22:13:52 +0100
Message-ID: <87zglcfmcv.ffs@tglx>
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

Artem,

On Thu, Mar 24 2022 at 13:28, Thomas Gleixner wrote:
> On Wed, Mar 23 2022 at 12:16, Artem Savkov wrote:
>>  	 * Round up with level granularity to prevent this.
>> +	 * Do not perform round up in case of upper bound timer.
>>  	 */
>> -	expires = (expires + LVL_GRAN(lvl)) >> LVL_SHIFT(lvl);
>> +	if (upper_bound)
>> +		expires = expires >> LVL_SHIFT(lvl);
>> +	else
>> +		expires = (expires + LVL_GRAN(lvl)) >> LVL_SHIFT(lvl);
>
> While this "works", I fundamentally hate this because it adds an extra

actually it cannot not work. At least not in a realiable and predictable
way.

The timer wheel is fundamentaly relying on moving the timer one bucket
out. Let's look how this all works.

The wheel has N levels of bucket arrays. Each level has 64 buckets and
the granularity increases by a factor of 8 per level, i.e. the worst
case deviation is 12.5% per level.

The original timer wheel was able to fire the timer at expiry time + one
tick for the price of cascading timers every so often from one level to
the next lower level. Here are a few pointers:

    https://lwn.net/Articles/152436/
    https://lwn.net/Articles/646950/

The accuracy of the original wheel implementation was weakened already
in course of the NOHZ development where the concept of slack
(algorithmic batching at enqueue time for the price of overhead) was
introduced. It had the same 12.5% worst case deviation of the resulting
granularity level, though the batching was not enforced and only worked
most of the time. So in theory the same issue could have been seen back
then already.

The enqueue placement and the expiry is driven by base::clock, which
is nothing else than jiffies. When a timer is queued then base::clock is
the time on which the next tick and expiry check happens.

Now let's look how the expiry mechanism works. The first level (0) is
obviously expired every tick. On every eigth tick the second level (1) is
expired, on every 64th tick the third level (2)...

IOW, the expiry events of a level happen at 8^index(level) intervals.

Let's assume that base::clk is 0. That means at the next tick (which
could be imminent) in _all_ levels bucket[0] is due for expiry.

Now let's enqueue a timer with expiry value of 64:

    delta = 64 - 0 = 64

That means the timer ends up in the second level in bucket[0], which
makes it eligible for expiry at the next tick. The same is true for any
expiry value of 8^N.

Not what you are trying to achieve, right? You try to enforce an upper
bound, but you expect that the timer does not fire earlier than 12.5% of
the granularity level of that upper bound, right?

IOW, you created a expiry lottery and there is no way to prevent that
except with more conditionals and heuristics which are hardely welcomed.

You've also seen the outcome of a timer firing unexpectedly due to the
bit abuse, right?

Now let's take a step back and look at the problem at hand.

TCP alive timer, which is affected by the batching and the resulting
inaccuracy, is (re)armed with a relative timeout, which is known
upfront, right?

The important part is *relative* timeout. Why?

Because the timeout is relative it's trivial to calculate a relative
timeout value from the given accurate relative timeout value, which is
guaranteed to not expire late and within the timerwheel's error margin,
and use that for the actual rearming.

I'm pretty sure that you can come up with a conversion function for that
and use this function in the TCP code at the point where the TCP
keepalive timer is configured.

Hint 1: The output of calc_wheel_index() should be good enough to figure
        that out.

Hint 2: If you get frustrated, try

        git grep johnstul arch/x86/ | awk '{ $1=$2=$3=""; print $0 }'

Hint 3: Feel free to ask questions anytime

Thanks,

        tglx
