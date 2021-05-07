Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E033376565
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 14:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbhEGMoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 08:44:46 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:44379 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbhEGMoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 08:44:44 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 9A2812224D;
        Fri,  7 May 2021 14:43:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1620391423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uT0RuTKvzHOAe4V80zynebT/XtjkDrMnkIsyyR2Nt2Y=;
        b=agj/DMbYdpQVdTYblwOECJkssFj3fmO91Yff8cX9xzKliaDdMliedrrLC8rqldVQZLMMO/
        qkxQYrwTFDs5G+o7YuM/4tVKMJdxgYwEsZXNmyNlzFtpfBgFGdCuYTTNZkaJaBAaAF1bNp
        tQIpRi1nAMgMye8YlqT/Amf/a/0BSkY=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 07 May 2021 14:43:42 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>, davem@davemloft.net,
        idosch@mellanox.com, joergen.andreasen@microchip.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>, vinicius.gomes@intel.com
Subject: Re: [net-next] net: dsa: felix: disable always guard band bit for TAS
 config
In-Reply-To: <20210507121909.ojzlsiexficjjjun@skbuf>
References: <c7618025da6723418c56a54fe4683bd7@walle.cc>
 <20210504185040.ftkub3ropuacmyel@skbuf>
 <ccb40b7fd18b51ecfc3f849a47378c54@walle.cc>
 <20210504191739.73oejybqb6z7dlxr@skbuf>
 <d933eef300cb1e1db7d36ca2cb876ef6@walle.cc>
 <20210504213259.l5rbnyhxrrbkykyg@skbuf>
 <efe5ac03ceddc8ff472144b5fe9fd046@walle.cc>
 <DB8PR04MB5785A6A773FEA4F3E0E77698F0579@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <2898c3ae1319756e13b95da2b74ccacc@walle.cc>
 <DB8PR04MB5785D01D2F9091FB9267D515F0579@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210507121909.ojzlsiexficjjjun@skbuf>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <d2241bed63e3b36d6a46f517f697d4bd@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-05-07 14:19, schrieb Vladimir Oltean:
> On Fri, May 07, 2021 at 11:09:24AM +0000, Xiaoliang Yang wrote:
>> Hi Michael,
>> 
>> On 2021-05-07 15:35, Michael Walle <michael@walle.cc> wrote:
>> > Am 2021-05-07 09:16, schrieb Xiaoliang Yang:
>> > > On 2021-05-06 21:25, Michael Walle <michael@walle.cc> wrote:
>> > >> Am 2021-05-04 23:33, schrieb Vladimir Oltean:
>> > >> > [ trimmed the CC list, as this is most likely spam for most people ]
>> > >> >
>> > >> > On Tue, May 04, 2021 at 10:23:11PM +0200, Michael Walle wrote:
>> > >> >> Am 2021-05-04 21:17, schrieb Vladimir Oltean:
>> > >> >> > On Tue, May 04, 2021 at 09:08:00PM +0200, Michael Walle wrote:
>> > >> >> > > > > > > As explained in another mail in this thread, all
>> > >> >> > > > > > > queues are marked as scheduled. So this is actually a
>> > >> >> > > > > > > no-op, correct? It doesn't matter if it set or not set
>> > >> >> > > > > > > for now. Dunno why we even care for this bit then.
>> > >> >> > > > > >
>> > >> >> > > > > > It matters because ALWAYS_GUARD_BAND_SCH_Q reduces the
>> > >> >> > > > > > available throughput when set.
>> > >> >> > > > >
>> > >> >> > > > > Ahh, I see now. All queues are "scheduled" but the guard
>> > >> >> > > > > band only applies for "non-scheduled" -> "scheduled" transitions.
>> > >> >> > > > > So the guard band is never applied, right? Is that really
>> > >> >> > > > > what we want?
>> > >> >> > > >
>> > >> >> > > > Xiaoliang explained that yes, this is what we want. If the
>> > >> >> > > > end user wants a guard band they can explicitly add a
>> > >> >> > > > "sched-entry 00" in the tc-taprio config.
>> > >> >> > >
>> > >> >> > > You're disabling the guard band, then. I figured, but isn't
>> > >> >> > > that suprising for the user? Who else implements taprio? Do
>> > >> >> > > they do it in the same way? I mean this behavior is passed
>> > >> >> > > right to the userspace and have a direct impact on how it is
>> > >> >> > > configured. Of course a user can add it manually, but I'm not
>> > >> >> > > sure that is what we want here. At least it needs to be
>> > >> >> > > documented somewhere. Or maybe it should be a switchable option.
>> > >> >> > >
>> > >> >> > > Consider the following:
>> > >> >> > > sched-entry S 01 25000
>> > >> >> > > sched-entry S fe 175000
>> > >> >> > > basetime 0
>> > >> >> > >
>> > >> >> > > Doesn't guarantee, that queue 0 is available at the beginning
>> > >> >> > > of the cycle, in the worst case it takes up to <begin of
>> > >> >> > > cycle> + ~12.5us until the frame makes it through (given
>> > >> >> > > gigabit and 1518b frames).
>> > >> >> > >
>> > >> >> > > Btw. there are also other implementations which don't need a
>> > >> >> > > guard band (because they are store-and-forward and cound the
>> > >> >> > > remaining bytes). So yes, using a guard band and scheduling is
>> > >> >> > > degrading the performance.
>> > >> >> >
>> > >> >> > What is surprising for the user, and I mentioned this already in
>> > >> >> > another thread on this patch, is that the Felix switch overruns
>> > >> >> > the time gate (a packet taking 2 us to transmit will start
>> > >> >> > transmission even if there is only 1 us left of its time slot,
>> > >> >> > delaying the packets from the next time slot by 1 us). I guess
>> > >> >> > that this is why the ALWAYS_GUARD_BAND_SCH_Q bit exists, as a
>> > >> >> > way to avoid these overruns, but it is a bit of a poor tool for
>> > >> >> > that job. Anyway, right now we disable it and live with the overruns.
>> > >> >>
>> > >> >> We are talking about the same thing here. Why is that a poor tool?
>> > >> >
>> > >> > It is a poor tool because it revolves around the idea of "scheduled
>> > >> > queues" and "non-scheduled queues".
>> > >> >
>> > >> > Consider the following tc-taprio schedule:
>> > >> >
>> > >> >       sched-entry S 81 2000 # TC 7 and 0 open, all others closed
>> > >> >       sched-entry S 82 2000 # TC 7 and 1 open, all others closed
>> > >> >       sched-entry S 84 2000 # TC 7 and 2 open, all others closed
>> > >> >       sched-entry S 88 2000 # TC 7 and 3 open, all others closed
>> > >> >       sched-entry S 90 2000 # TC 7 and 4 open, all others closed
>> > >> >       sched-entry S a0 2000 # TC 7 and 5 open, all others closed
>> > >> >       sched-entry S c0 2000 # TC 7 and 6 open, all others closed
>> > >> >
>> > >> > Otherwise said, traffic class 7 should be able to send any time it
>> > >> > wishes.
>> > >>
>> > >> What is the use case behind that? TC7 (with the highest priority) may
>> > >> always take precedence of the other TCs, thus what is the point of
>> > >> having a dedicated window for the others.
>> > >>
>> > >> Anyway, I've tried it and there are no hiccups. I've meassured the
>> > >> delta between the start of successive packets and they are always
>> > >> ~12370ns for a 1518b frame. TC7 is open all the time, which makes
>> > >> sense. It only happens if you actually close the gate, eg. you have a
>> > >> sched-entry where a TC7 bit is not set. In this case, I can see a
>> > >> difference between ALWAYS_GUARD_BAND_SCH_Q set and not set. If it is
>> > >> set, there is up to a ~12.5us delay added (of course it depends on
>> > >> when the former frame was scheduled).
>> > >>
>> > >> It seems that also needs to be 1->0 transition.
>> > >>
>> > >> You've already mentioned that the switch violates the Qbv standard.
>> > >> What makes you think so? IMHO before that patch, it wasn't violated.
>> > >> Now it likely is (still have to confirm that). How can this be
>> > >> reasonable?
>> > >>
>> > >> If you have a look at the initial commit message, it is about making
>> > >> it possible to have a smaller gate window, but that is not possible
>> > >> because of the current guard band of ~12.5us. It seems to be a
>> > >> shortcut for not having the MAXSDU (and thus the length of the guard
>> > >> band) configurable. Yes (static) guard bands will have a performance
>> > >> impact, also described in [1]. You are trading the correctness of the
>> > >> TAS for performance. And it is the sole purpose of Qbv to have a
>> > >> determisitc way (in terms of timing) of sending the frames.
>> > >>
>> > >> And telling the user, hey, we know we violate the Qbv standard,
>> > >> please insert the guard bands yourself if you really need them is not
>> > >> a real solution. As already mentioned, (1) it is not documented
>> > >> anywhere, (2) can't be shared among other switches (unless they do
>> > >> the same workaround) and (3) what am I supposed to do for TSN
>> > >> compliance testing. Modifying the schedule that is about to be
>> > >> checked (and thus given by the compliance suite)?
>> > >>
>> > > I disable the always guard band bit because each gate control list
>> > > needs to reserve a guard band slot, which affects performance. The
>> > > user does not need to set a guard band for each queue transmission.
>> > > For example, "sched-entry S 01 2000 sched-entry S fe 98000". Queue 0
>> > > is protected traffic and has smaller frames, so there is no need to
>> > > reserve a guard band during the open time of queue 0. The user can add
>> > > the following guard band before protected traffic: "sched-entry S 00
>> > > 25000 sched-entry S 01 2000 sched-entry S fe 73000"
>> >
>> > Again, you're passing the handling of the guard band to the user, which is an
>> > implementation detail for this switch (unless there is a new switch for it on the
>> > qdisc IMHO). And (1), (2) and (3) from above is still valid.
>> >
>> > Consider the entry
>> >   sched-entry S 01 2000
>> >   sched-entry S 02 20000
>> >
>> > A user assumes that TC0 is open for 2us. But with your change it is bascially
>> > open for 2us + 12.5us. And even worse, it is not deterministic. A frame in the
>> > subsequent queue (ie TC1) can be scheduled anywhere beteeen 0us and
>> > 12.5us after opening the gate, depending on wether there is still a frame
>> > transmitting on TC0.
>> >
>> After my change, user need to add a GCL at first: "sched-entry S 00 
>> 12500".
>> Before the change, your example need to be set as " sched-entry S 01
>> 14500 sched-entry S 02 20000", TC0 is open for 2us, and TC1 is only
>> open for 20us-12.5us. This also need to add guard band time for user.
>> So if we do not have this patch, GCL entry will also have a different
>> set with other devices.
>> 
>> > > I checked other devices such as ENETC and it can calculate how long
>> > > the frame transmission will take and determine whether to transmit
>> > > before the gate is closed. The VSC9959 device does not have this
>> > > hardware function. If we implement guard bands on each queue, we need
>> > > to reserve a 12.5us guard band for each GCL, even if it only needs to
>> > > send a small packet. This confuses customers.
>> >
>> > How about getting it right and working on how we can set the MAXSDU per
>> > queue and thus making the guard band smaller?
>> >
>> Of course, if we can set maxSDU for each queue, then users can set the
>> guard band of each queue. I added this patch to set the guard band by
>> adding GCL, which is another way to make the guard band configurable
>> for users. But there is no way to set per queue maxSDU now. Do you
>> have any ideas on how to set the MAXSDU per queue?
>> 
>> > > actually, I'm not sure if this will violate the Qbv standard. I looked
>> > > up the Qbv standard spec, and found it only introduce the guard band
>> > > before protected window (Annex Q (informative)Traffic scheduling). It
>> > > allows to design the schedule to accommodate the intended pattern of
>> > > transmission without overrunning the next gate-close event for the
>> > > traffic classes concerned.
>> >
>> > Vladimir already quoted "IEEE 802.1Q-2018 clause 8.6.8.4". I didn't check it,
>> > though.
>> >
> 
> That clause says:
> 
> In addition to the other checks carried out by the transmission
> selection algorithm, a frame on a traffic class queue is not available
> for transmission [as required for tests (a) and (b) in 8.6.8] if the
> transmission gate is in the closed state or if there is insufficient
> time available to transmit the entirety of that frame before the next
> gate-close event (3.97) associated with that queue. A per-traffic class
> counter, TransmissionOverrun (12.29.1.1.2), is incremented if the
> implementation detects that a frame from a given queue is still being
> transmitted by the MAC when the gate-close event for that queue occurs.
> 
> NOTE 1—It is assumed that the implementation has knowledge of the
> transmission overheads that are involved in transmitting a frame on a
> given Port and can therefore determine how long the transmission of a
> frame will take. However, there can be reasons why the frame size, and
> therefore the length of time needed for its transmission, is unknown;
> for example, where cut-through is supported, or where frame preemption
> is supported and there is no way of telling in advance how many times a
> given frame will be preempted before its transmission is complete. It 
> is
> desirable that the schedule for such traffic is designed to accommodate
> the intended pattern of transmission without overrunning the next
> gate-close event for the traffic classes concerned.
> 
> NOTE 2— It is assumed that the implementation can determine the time at
> which the next gate-close event will occur from the sequence of gate
> events. In the normal case, this can be achieved by inspecting the
> sequence of gate operations in OperControlList (8.6.9.4.19) and
> associated variables. However, when a new configuration is about to be
> installed, it would be necessary to inspect the contents of both the
> OperControlList and the AdminControlList (8.6.9.4.2) and associated
> variables in order to determine the time of the next gate-close event,
> as the gating cycle for the new configuration may differ in size and
> phasing from the old cycle.
> A per-traffic class queue queueMaxSDU parameter defines the maximum
> service data unit size for each queue; frames that exceed queueMaxSDU
> are discarded [item b8) in 6.5.2]. The value of queueMaxSDU for each
> queue is configurable by management (12.29); its default value is the
> maximum SDU size supported by the MAC procedures employed on the LAN to
> which the frame is to be relayed [item b3) in 6.5.2].
> 
> NOTE 3—The use of PFC is likely to interfere with a traffic schedule,
> because PFC is transmitted by a higher layer entity (see Clause 36).
> 
>> > A static guard band is one of the options you have to fulfill that.
>> > Granted, it is not that efficient, but it is how the switch handles it.
>> >
>> I'm still not sure if guard band is required for each queue. Maybe
>> this patch need revert if it's required. Then there will be a fixed
>> non-configurable guard band for each queue, and the user needs to
>> calculate the guard band into gate opening time every time when
>> designing a schedule. Maybe it's better to revert it and add MAXSDU
>> per queue set.
> 
> I think we can universally agree on the fact that overruns at the end 
> of
> the time slot should be avoided: if there isn't enough time to send it
> within your time slot, don't send it (unless you can count it, but none
> of the devices I know count the overruns). Devices like the ENETC 
> handle
> this on a per-packet basis and shouldn't require any further
> configuration. Devices like Felix need the per-queue max SDU from the
> user - if that isn's specified in the netlink message they'll have to
> default to the interface's MTU.
> Devices like the SJA1105 are more interesting, they have no knob
> whatsoever to avoid overruns. Additionally, there is a user-visible
> restriction there that two gate events on different ports can never 
> fire
> at the same time. So, the option of automatically having the driver
> shorten the GCL entries and add MTU-sized guard bands by itself kind of
> falls flat on its face - it will make for a pretty unusable device,
> considering that the user already has to calculate the lengths and
> base-time offsets properly in order to avoid gates opening/closing at
> the same time.
> On the other hand, I do understand the need for uniform behavior (or at
> least predictable, if we can't have uniformity), I'm just not sure what
> is, realistically speaking, our best option. As outrageous as it sounds
> to Michael, I think we shouldn't completely exclude the option that the
> TSN compliance suite adapts itself to real-life hardware, that is by 
> far
> the options with the least amount of limitations, all things 
> considered.

Haha, I kinda hate compliance suites anyway, so no offence taken ;)

IMHO for the devices that supports it, we should have that uniform
behavior. If the SJA1105 is inherently broken in this regard, then I
agree there is no need to make it behave the same in all circumstances.
Also the SJA1105 was one of the first devices which supported Qbv, no?
I'd presume newer devices will get better at the scheduling.

Btw. because the entries in the CGL are likely constrained (and some
customers always for how much they can use) it should be taken into
consideration when the driver will automatically add some entries.

-michael
