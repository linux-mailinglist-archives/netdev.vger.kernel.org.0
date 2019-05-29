Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFD82E5EB
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 22:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfE2UQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 16:16:10 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:32854 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfE2UQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 16:16:09 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hW4zW-0005uo-H0; Wed, 29 May 2019 22:16:06 +0200
Message-ID: <58bc88b7eda912133ad0fc4718ac917adc8fa63b.camel@sipsolutions.net>
Subject: Re: cellular modem APIs - take 2
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Dan Williams <dcbw@redhat.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Daniele Palmas <dnlplm@gmail.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Date:   Wed, 29 May 2019 22:16:05 +0200
In-Reply-To: <cb2ef612be9e347a7cbceb26831f8d5ebea4eacf.camel@redhat.com>
References: <b59be15f1d0caa4eaa4476bbd8457afc44d57089.camel@sipsolutions.net>
         <cb2ef612be9e347a7cbceb26831f8d5ebea4eacf.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

> >    Quite possibly there might be some additional (vendor-dependent?)
> >    configuration for when such netdevs are created, but we need to
> >    figure out if that really needs to be at creation time, or just
> >    ethtool later or something like that. I guess it depends on how
> >    generic it needs to be.
> 
> I'm pretty sure it would have to be async via netlink or ethtool or
> whatever later, because the control plane (ModemManager,
> libmbim/libqmi, oFono, etc) is what sets up the PDP/EPS context and
> thus the data channel. A netdev (or a queue on that netdev) would be a
> representation of that data channel, but that's not something the
> kernel knows beforehand.

Right.

It just seemed that people do want to have a netdev (if only to see that
their driver loaded and use ethtool to dump the firmware version), and
then you can reassign it to some actual context later?

It doesn't really matter much. If you have a control channel and higher-
level abstraction (wwan device) then having the netdev is probably more
of a nuisance and mostly irrelevant, just might be useful for legacy
reasons.

> > 3) Separately, we need to have an ability to create "generalized control
> >    channels". I'm thinking there would be a general command "create
> >    control channel" with a given type (e.g. ATCMD, RPC, MBIM, GNSS) plus
> >    a list of vendor-specific channels (e.g. for tracing).
> > 
> >    I'm unsure where this channel should really go - somehow it seems to
> >    me that for many (most?) of these registering them as a serial line
> >    would be most appropriate, but some, especially vendor-defined
> >    channels like tracing, would probably better use a transport that's
> >    higher bandwidth than, e.g. netdevs.
> 
> There's only a couple protocols that are run over serial transport,
> namely AT, DM/DIAG, and Sierra's CnS.

Right.

> Most of the rest like QMI and MBIM are packet-based protocols that can
> use different transports. QMI for example can use CDC-WDM for USB
> devices but on SoCs will use Qualcomm's SMD I believe.

Right, though transport and protocol are sort of different issues.

> Should you really need to account for these specially, or would some
> kind of sysfs linkage like SET_NETDEV_DEV() be more appropriate?
> 
> Really all you want to do is (a) identify which WWAN device a given
> control/data channel is for and (b) perhaps tag different control/data
> channels with attributes like primary/secondary/gps/sim/etc often
> through USB attributes or hardcoded data on SoCs.

Ah, that brings up something I completely forgot.

I was thinking only of the case that the control channel(s) to the
device is/are all managed by the *kernel* driver, i.e. you'd have some
device-specific driver that has an interface into userspace to talk to
the modem's control channel (and that we could abstract).

However, yes, that's not true - many will be like USB where the control
channel is driven by a generic kernel driver (e.g. maybe usb-serial) or
no kernel driver at all, and then this linkage is probably the right
approach. Need to think about it.

OTOH, there will be device-specific ways to add more control channels
(say for debug/trace purposes etc.) and those would not have a "natural"
interface to userspace like control channels with generic/no drivers.

> >    One way I thought of doing this was to create an abstraction in the
> >    wwan framework that lets the driver use SKBs anyway (i.e. TX and RX
> >    on these channels using SKBs) and then translate them to some channel
> >    in the framework - that way, we can even select at runtime if we want
> >    a netdev (not really plugged into the network stack, ARPHDR_VOID?) or
> >    some other kind of transport. Building that would allow us to add
> >    transport types in the future too.
> 
> I'm not quite sure what you mean here, can you explain?

I was just thinking of the mechanics of doing this in the driver (while,
like I said above, completely forgetting about the non-monolithic driver
case). It's not really that important.

> >    I guess such a channel should also be created by default, if it's
> >    not already created by the driver in some out-of-band way anyway (and
> >    most likely it shouldn't be, but I guess drivers might have some
> >    entirely different communication channels for AT CMDs?)
> 
> For existing devices we're not talking about monolithic drivers here
> (excepting 'hso') which I guess is part of the issue. 

Right, and doesn't help I forgot about this ;-)

> A given device
> might be driven by 2 or 3 different kernel drivers (usb-serial derived,
> netdev, cdc-wdm) and they all expose different channels and none of
> them coordinate. You have to do sysfs matching up the family tree to
> find out they are associated with each other. If the kernel can take
> over some of that responsibility great.

Right. I guess it's hard for the kernel to take responsibility unless we
teach all the components (usb-serial, ...) that certain devices are
modems and should get some (additional?) registration?

> But the diversity is large. Any given TTY representing an AT channel
> could be from USB drivers (usb-serial, cdc-wdm, vendor-specific driver
> like sierra/hso, option) or PCI (nozomi) or platform stuff (Qualcomm
> SoC ones). You can also do AT-over-QMI if you want.

Right. The linkage here is the interesting part - for platform stuff
that might be easier (devicetree?) but not sure how we could teach that
to e.g. usb-serial, and nozomi is interesting because ... where is the
data plane even?

> I think it's worth discussing how this could be better unified but
> maybe small steps to get there are more feasible.

Fair point.

> > 4) There was a question about something like pure IP channels that
> >    belong to another PDN and apparently now separate netdevs might be
> >    used, but it seems to me that could just be a queue reserved on the
> >    regular netdevs and then when you say ("enable video streaming on
> >    wwan1 interface") that can do some magic to classify the video
> >    packets (DSCP?) to another hardware queue for better QoS.
> 
> Most stuff is pure IP these days (both for QMI/rmnet and MBIM at least)
> and having ethernet encapsulation is kinda pointless. 

Yeah, true, not really sure why I was distinguishing this in these
terms. I think the use case really was just giving some packets higher
priority, putting them into a different *hardware* queue so the device
can see them even if the "normal" hardware queue is completely
backlogged.

Kinda a typical multi-queue TX use case.

> But anyway you'd
> need some mechanism to map that particular queue to a given channel/PDN
> created by the control channel.

Well, I was thinking that mechanism was creating the netdev, but then
*within* that some QoS seems to be desired.

> But classification is mostly done in the hardware/network because
> setting different QoS for a given PDP/EPS context is basically saying
> how much airtime the queue gets. No amount of kernel involvement is
> going to change what the network lets you transmit. 

Right.

> And I honestly
> don't know how the firmware responds when its internal queues for a
> given context are full that would tell a kernel queue to stop sending
> more.

Well, at the very least it'll stop pulling packets from DMA/whatever, so
the kernel has to back off, right?

johannes

