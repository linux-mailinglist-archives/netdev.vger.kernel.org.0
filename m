Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832F1373157
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 22:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbhEDUYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 16:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbhEDUYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 16:24:09 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498B5C06174A;
        Tue,  4 May 2021 13:23:14 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 17B2B2224F;
        Tue,  4 May 2021 22:23:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1620159792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FVpW2LqtcLWR77k08ecf7OzOcx+9jtCPSlRIJuCXys8=;
        b=XL2QiTH9b30sZ/jO69OWDrOVONQiLE7vPqhNzK24rc6W/1ZT5JNxzNJwZZSYUPoO18+xMO
        9WFFWdOXoLQKJqSQCW0B0X8l30zJ2xrc/G2c9yLtd/s5QmvEJSQ0+swElTnThOwG+ZrSA3
        6qNwp5V1hvtsTDDoueTTfSFgIzk1Cco=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 04 May 2021 22:23:11 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     xiaoliang.yang_1@nxp.com, Arvid.Brodin@xdin.com,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, andre.guedes@linux.intel.com,
        claudiu.manoil@nxp.com, colin.king@canonical.com,
        davem@davemloft.net, idosch@mellanox.com,
        ivan.khoronzhuk@linaro.org, jiri@mellanox.com,
        joergen.andreasen@microchip.com, leoyang.li@nxp.com,
        linux-kernel@vger.kernel.org, m-karicheri2@ti.com,
        michael.chan@broadcom.com, mingkai.hu@nxp.com,
        netdev@vger.kernel.org, po.liu@nxp.com, saeedm@mellanox.com,
        vinicius.gomes@intel.com, vladimir.oltean@nxp.com,
        yuehaibing@huawei.com
Subject: Re: [net-next] net: dsa: felix: disable always guard band bit for TAS
 config
In-Reply-To: <20210504191739.73oejybqb6z7dlxr@skbuf>
References: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
 <20210504170514.10729-1-michael@walle.cc>
 <20210504181833.w2pecbp2qpuiactv@skbuf>
 <c7618025da6723418c56a54fe4683bd7@walle.cc>
 <20210504185040.ftkub3ropuacmyel@skbuf>
 <ccb40b7fd18b51ecfc3f849a47378c54@walle.cc>
 <20210504191739.73oejybqb6z7dlxr@skbuf>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <d933eef300cb1e1db7d36ca2cb876ef6@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-05-04 21:17, schrieb Vladimir Oltean:
> On Tue, May 04, 2021 at 09:08:00PM +0200, Michael Walle wrote:
>> > > > > As explained in another mail in this thread, all queues are marked as
>> > > > > scheduled. So this is actually a no-op, correct? It doesn't matter if
>> > > > > it set or not set for now. Dunno why we even care for this bit then.
>> > > >
>> > > > It matters because ALWAYS_GUARD_BAND_SCH_Q reduces the available
>> > > > throughput when set.
>> > >
>> > > Ahh, I see now. All queues are "scheduled" but the guard band only
>> > > applies
>> > > for "non-scheduled" -> "scheduled" transitions. So the guard band is
>> > > never
>> > > applied, right? Is that really what we want?
>> >
>> > Xiaoliang explained that yes, this is what we want. If the end user
>> > wants a guard band they can explicitly add a "sched-entry 00" in the
>> > tc-taprio config.
>> 
>> You're disabling the guard band, then. I figured, but isn't that
>> suprising for the user? Who else implements taprio? Do they do it in 
>> the
>> same way? I mean this behavior is passed right to the userspace and 
>> have
>> a direct impact on how it is configured. Of course a user can add it
>> manually, but I'm not sure that is what we want here. At least it 
>> needs
>> to be documented somewhere. Or maybe it should be a switchable option.
>> 
>> Consider the following:
>> sched-entry S 01 25000
>> sched-entry S fe 175000
>> basetime 0
>> 
>> Doesn't guarantee, that queue 0 is available at the beginning of
>> the cycle, in the worst case it takes up to
>> <begin of cycle> + ~12.5us until the frame makes it through (given
>> gigabit and 1518b frames).
>> 
>> Btw. there are also other implementations which don't need a guard
>> band (because they are store-and-forward and cound the remaining
>> bytes). So yes, using a guard band and scheduling is degrading the
>> performance.
> 
> What is surprising for the user, and I mentioned this already in 
> another
> thread on this patch, is that the Felix switch overruns the time gate 
> (a
> packet taking 2 us to transmit will start transmission even if there is
> only 1 us left of its time slot, delaying the packets from the next 
> time
> slot by 1 us). I guess that this is why the ALWAYS_GUARD_BAND_SCH_Q bit
> exists, as a way to avoid these overruns, but it is a bit of a poor 
> tool
> for that job. Anyway, right now we disable it and live with the 
> overruns.

We are talking about the same thing here. Why is that a poor tool?

> FWIW, the ENETC does not overrun the time gate, the SJA1105 does. You
> can't really tell just by looking at the driver code, just by testing.
> It's a bit of a crapshoot.

I was speaking of other switches, I see there is also a hirschmann
switch (hellcreek) supported in linux, for example.

Shouldn't the goal to make the configuration of the taprio qdisc
independent of the switch. If on one you'll have to manually define the
guard band by inserting dead-time scheduler entries and on another this
is already handled by the hardware (like it would be with
ALWAYS_GUARD_BAND_SCH_Q or if it doesn't need it at all), this goal
isn't met.

Also what do you expect if you use the following configuration:
sched-entry S 01 5000
sched-entry S fe <some large number>

Will queue 0 be able to send traffic? To me, with this patch, it seems
to me that this isn't always the case anymore. If there is a large 
packet
just sent at the end of the second cycle, the first might even be 
skipped
completely.
Will a user of the taprio (without knowledge of the underlying switch)
assume that it can send traffic up to ~600 bytes? I'd say yes.

-michael
