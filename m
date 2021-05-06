Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3839F3754AC
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 15:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbhEFN0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 09:26:15 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:53521 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbhEFN0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 09:26:14 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 1FAF32224B;
        Thu,  6 May 2021 15:25:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1620307513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ox1l0bZBintSTFXtUR3WQLIBXFNME5ovSnRa3uKaLDY=;
        b=iOKb3WU/U+e6uu8+iQspVNpuuqOFNz5c9O6OES/XEeoptpCcrqLgSgw3RpzvrOcPKV0idY
        ZfbIaJUQ7tpMcxqQPaNiNJ6kxSjB3WuZyainaoq6GkjU2Pyv6GmGduTAdIpYLnj1vwdHbm
        rbvHei7pXYKVvvtWI3YpiB+2/R7STNY=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 06 May 2021 15:25:07 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>, davem@davemloft.net,
        idosch@mellanox.com, joergen.andreasen@microchip.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>, vinicius.gomes@intel.com
Subject: Re: [net-next] net: dsa: felix: disable always guard band bit for TAS
 config
In-Reply-To: <20210504213259.l5rbnyhxrrbkykyg@skbuf>
References: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
 <20210504170514.10729-1-michael@walle.cc>
 <20210504181833.w2pecbp2qpuiactv@skbuf>
 <c7618025da6723418c56a54fe4683bd7@walle.cc>
 <20210504185040.ftkub3ropuacmyel@skbuf>
 <ccb40b7fd18b51ecfc3f849a47378c54@walle.cc>
 <20210504191739.73oejybqb6z7dlxr@skbuf>
 <d933eef300cb1e1db7d36ca2cb876ef6@walle.cc>
 <20210504213259.l5rbnyhxrrbkykyg@skbuf>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <efe5ac03ceddc8ff472144b5fe9fd046@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-05-04 23:33, schrieb Vladimir Oltean:
> [ trimmed the CC list, as this is most likely spam for most people ]
> 
> On Tue, May 04, 2021 at 10:23:11PM +0200, Michael Walle wrote:
>> Am 2021-05-04 21:17, schrieb Vladimir Oltean:
>> > On Tue, May 04, 2021 at 09:08:00PM +0200, Michael Walle wrote:
>> > > > > > > As explained in another mail in this thread, all queues are marked as
>> > > > > > > scheduled. So this is actually a no-op, correct? It doesn't matter if
>> > > > > > > it set or not set for now. Dunno why we even care for this bit then.
>> > > > > >
>> > > > > > It matters because ALWAYS_GUARD_BAND_SCH_Q reduces the available
>> > > > > > throughput when set.
>> > > > >
>> > > > > Ahh, I see now. All queues are "scheduled" but the guard band only
>> > > > > applies
>> > > > > for "non-scheduled" -> "scheduled" transitions. So the guard band is
>> > > > > never
>> > > > > applied, right? Is that really what we want?
>> > > >
>> > > > Xiaoliang explained that yes, this is what we want. If the end user
>> > > > wants a guard band they can explicitly add a "sched-entry 00" in the
>> > > > tc-taprio config.
>> > >
>> > > You're disabling the guard band, then. I figured, but isn't that
>> > > suprising for the user? Who else implements taprio? Do they do it in
>> > > the
>> > > same way? I mean this behavior is passed right to the userspace and
>> > > have
>> > > a direct impact on how it is configured. Of course a user can add it
>> > > manually, but I'm not sure that is what we want here. At least it
>> > > needs
>> > > to be documented somewhere. Or maybe it should be a switchable option.
>> > >
>> > > Consider the following:
>> > > sched-entry S 01 25000
>> > > sched-entry S fe 175000
>> > > basetime 0
>> > >
>> > > Doesn't guarantee, that queue 0 is available at the beginning of
>> > > the cycle, in the worst case it takes up to
>> > > <begin of cycle> + ~12.5us until the frame makes it through (given
>> > > gigabit and 1518b frames).
>> > >
>> > > Btw. there are also other implementations which don't need a guard
>> > > band (because they are store-and-forward and cound the remaining
>> > > bytes). So yes, using a guard band and scheduling is degrading the
>> > > performance.
>> >
>> > What is surprising for the user, and I mentioned this already in another
>> > thread on this patch, is that the Felix switch overruns the time gate (a
>> > packet taking 2 us to transmit will start transmission even if there is
>> > only 1 us left of its time slot, delaying the packets from the next time
>> > slot by 1 us). I guess that this is why the ALWAYS_GUARD_BAND_SCH_Q bit
>> > exists, as a way to avoid these overruns, but it is a bit of a poor tool
>> > for that job. Anyway, right now we disable it and live with the
>> > overruns.
>> 
>> We are talking about the same thing here. Why is that a poor tool?
> 
> It is a poor tool because it revolves around the idea of "scheduled
> queues" and "non-scheduled queues".
> 
> Consider the following tc-taprio schedule:
> 
> 	sched-entry S 81 2000 # TC 7 and 0 open, all others closed
> 	sched-entry S 82 2000 # TC 7 and 1 open, all others closed
> 	sched-entry S 84 2000 # TC 7 and 2 open, all others closed
> 	sched-entry S 88 2000 # TC 7 and 3 open, all others closed
> 	sched-entry S 90 2000 # TC 7 and 4 open, all others closed
> 	sched-entry S a0 2000 # TC 7 and 5 open, all others closed
> 	sched-entry S c0 2000 # TC 7 and 6 open, all others closed
> 
> Otherwise said, traffic class 7 should be able to send any time it
> wishes.

What is the use case behind that? TC7 (with the highest priority)
may always take precedence of the other TCs, thus what is the point
of having a dedicated window for the others.

Anyway, I've tried it and there are no hiccups. I've meassured
the delta between the start of successive packets and they are
always ~12370ns for a 1518b frame. TC7 is open all the time,
which makes sense. It only happens if you actually close the gate,
eg. you have a sched-entry where a TC7 bit is not set. In this case,
I can see a difference between ALWAYS_GUARD_BAND_SCH_Q set and not
set. If it is set, there is up to a ~12.5us delay added (of course
it depends on when the former frame was scheduled).

It seems that also needs to be 1->0 transition.

You've already mentioned that the switch violates the Qbv standard.
What makes you think so? IMHO before that patch, it wasn't violated.
Now it likely is (still have to confirm that). How can this
be reasonable?

If you have a look at the initial commit message, it is about
making it possible to have a smaller gate window, but that is not
possible because of the current guard band of ~12.5us. It seems
to be a shortcut for not having the MAXSDU (and thus the length
of the guard band) configurable. Yes (static) guard bands will
have a performance impact, also described in [1]. You are trading
the correctness of the TAS for performance. And it is the sole
purpose of Qbv to have a determisitc way (in terms of timing) of
sending the frames.

And telling the user, hey, we know we violate the Qbv standard,
please insert the guard bands yourself if you really need them is
not a real solution. As already mentioned, (1) it is not documented
anywhere, (2) can't be shared among other switches (unless they do
the same workaround) and (3) what am I supposed to do for TSN compliance
testing. Modifying the schedule that is about to be checked (and thus
given by the compliance suite)?

> With the ALWAYS_GUARD_BAND_SCH_Q bit, there will be hiccups in packet
> transmission for TC 7. For example, at the end of every time slot,
> the hardware will insert a guard band for TC 7 because there is a
> scheduled-queue-to-scheduled-queue transition, and it has been told to
> do that. But a packet with TC 7 should be transmitted at any time,
> because that's what we told the port to do!
> 
> Alternatively, we could tell the switch that TC 7 is "scheduled", and
> the others are "not scheduled". Then it would implement the guard band
> at the end of TCs 0-6, but it wouldn't for packets sent in TC 7. But
> when you look at the overall schedule I described above, it kinds looks
> like TCs 0-6 are the ones that are "scheduled" and TC 7 looks like the
> one which isn't "scheduled" but can send at any time it pleases.
> 
> Odd, just odd. It's clear that someone had something in mind, it's just
> not clear what. I would actually appreciate if somebody from Microchip
> could chime in and say "no, you're wrong", and then explain.

If I had to make a bet, the distinction between "scheduled" and
"non-scheduled" is there to have more control for some traffic classes
you trust and where you can engineer the traffic, so you don't really
need the guard band and between arbitrary traffic where you can't really
say anything about and thus need the guard band.

>> > FWIW, the ENETC does not overrun the time gate, the SJA1105 does. You
>> > can't really tell just by looking at the driver code, just by testing.
>> > It's a bit of a crapshoot.
>> 
>> I was speaking of other switches, I see there is also a hirschmann
>> switch (hellcreek) supported in linux, for example.
>> 
>> Shouldn't the goal to make the configuration of the taprio qdisc
>> independent of the switch. If on one you'll have to manually define 
>> the
>> guard band by inserting dead-time scheduler entries and on another 
>> this
>> is already handled by the hardware (like it would be with
>> ALWAYS_GUARD_BAND_SCH_Q or if it doesn't need it at all), this goal
>> isn't met.
>> 
>> Also what do you expect if you use the following configuration:
>> sched-entry S 01 5000
>> sched-entry S fe <some large number>
>> 
>> Will queue 0 be able to send traffic? To me, with this patch, it seems
>> to me that this isn't always the case anymore. If there is a large 
>> packet
>> just sent at the end of the second cycle, the first might even be 
>> skipped
>> completely.
>> Will a user of the taprio (without knowledge of the underlying switch)
>> assume that it can send traffic up to ~600 bytes? I'd say yes.
> 
> Yeah, I think that if a switch overruns a packet's reserved time gate,
> then the above tc-taprio schedule is as good as not having any. I 
> didn't
> say that overruns are not a problem, I just said that the 
> ALWAYS_blah_blah
> bit isn't as silver-bullet for a solution as you think.

See above.

-michael

[1] 
https://www.belden.com/hubfs/resources/knowledge/white-papers/tsn-time-sensitive-networking.pdf
