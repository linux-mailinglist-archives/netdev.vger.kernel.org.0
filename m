Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3FF375582
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 16:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbhEFOV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 10:21:59 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:57553 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234002AbhEFOV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 10:21:59 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 1B3ED2224B;
        Thu,  6 May 2021 16:20:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1620310859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y/yU/utlCxeBkgHRjpQvGfxDuh18wji/GyOpNJch9Tg=;
        b=TbEmmQZ51d09fE7MyhMV8SuWNjLHN1yK49qhMzXFYsFBcM7TwLOMOqAukbyapWA1mmVQ/p
        qcIFeEzEKIZjP/hf8Gpc3ECSQtFT7st2LYz45W07aegs2xZOOGyZlKYEl1iZcGtQ4aD1Dj
        rYwFc2xBp22QY6JM1B9j/xLwP2FYHxI=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 06 May 2021 16:20:59 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>, davem@davemloft.net,
        idosch@mellanox.com, joergen.andreasen@microchip.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>, vinicius.gomes@intel.com
Subject: Re: [net-next] net: dsa: felix: disable always guard band bit for TAS
 config
In-Reply-To: <20210506135007.ul3gpdecq427tvgr@skbuf>
References: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
 <20210504170514.10729-1-michael@walle.cc>
 <20210504181833.w2pecbp2qpuiactv@skbuf>
 <c7618025da6723418c56a54fe4683bd7@walle.cc>
 <20210504185040.ftkub3ropuacmyel@skbuf>
 <ccb40b7fd18b51ecfc3f849a47378c54@walle.cc>
 <20210504191739.73oejybqb6z7dlxr@skbuf>
 <d933eef300cb1e1db7d36ca2cb876ef6@walle.cc>
 <20210504213259.l5rbnyhxrrbkykyg@skbuf>
 <efe5ac03ceddc8ff472144b5fe9fd046@walle.cc>
 <20210506135007.ul3gpdecq427tvgr@skbuf>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <0e909d9f9cc245d433ee7b02df5bafe0@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-05-06 15:50, schrieb Vladimir Oltean:
> On Thu, May 06, 2021 at 03:25:07PM +0200, Michael Walle wrote:
>> Am 2021-05-04 23:33, schrieb Vladimir Oltean:
>> > [ trimmed the CC list, as this is most likely spam for most people ]
>> >
>> > On Tue, May 04, 2021 at 10:23:11PM +0200, Michael Walle wrote:
[..]

>> > With the ALWAYS_GUARD_BAND_SCH_Q bit, there will be hiccups in packet
>> > transmission for TC 7. For example, at the end of every time slot,
>> > the hardware will insert a guard band for TC 7 because there is a
>> > scheduled-queue-to-scheduled-queue transition, and it has been told to
>> > do that. But a packet with TC 7 should be transmitted at any time,
>> > because that's what we told the port to do!
>> >
>> > Alternatively, we could tell the switch that TC 7 is "scheduled", and
>> > the others are "not scheduled". Then it would implement the guard band
>> > at the end of TCs 0-6, but it wouldn't for packets sent in TC 7. But
>> > when you look at the overall schedule I described above, it kinds looks
>> > like TCs 0-6 are the ones that are "scheduled" and TC 7 looks like the
>> > one which isn't "scheduled" but can send at any time it pleases.
>> >
>> > Odd, just odd. It's clear that someone had something in mind, it's just
>> > not clear what. I would actually appreciate if somebody from Microchip
>> > could chime in and say "no, you're wrong", and then explain.
>> 
>> If I had to make a bet, the distinction between "scheduled" and
>> "non-scheduled" is there to have more control for some traffic classes
>> you trust and where you can engineer the traffic, so you don't really
>> need the guard band and between arbitrary traffic where you can't 
>> really
>> say anything about and thus need the guard band.
> 
> I still don't know if I understand properly. You mean that "scheduled"
> traffic is traffic sent synchronized with the switch's schedule, and
> which does not need guard banding at the end of its time slot because
> the sender is playing nice?

Yes exactly. If you have a low level application that might be a
reasonable optimization.

> Yes, but then, do you gain anything at all by disabling that guard band
> and allowing the sender to overrun if they want to? I still don't see
> why overruns are permitted by the switch in certain configurations.

First, I suspect that this shouldn't happen, because as in you words,
the sender is playing nice and won't send outside its allocated time
frame.
Second, you don't waste the (possible) deadtime for the guard band
which might make sense esp. for smaller windows.

Consider the following gate timings:

(1) gate open event
(2)-(3) guard band
(3) gate close event

       (1)                 (2)      (3)
        _________ ... ______________
______|                    |_______|________


And the following timings for a frame:

(A)           ___... ___
_____________|          |___________________

(B)                   ___... ___
_____________________|          |___________

(C)                          ____
____________________________|    |__________


(A) and (B) can be send if there is a guard band, (C) can only
be send if there is no guard band. But in the case of (C) you
have to trust the sender to stop sending before reaching (3).
For (B) you don't have to trust the sender because the end of the
frame cannot be later than (3).

-michael
