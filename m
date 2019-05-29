Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92D3C2E5A8
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 21:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfE2T7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 15:59:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50660 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbfE2T7S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 15:59:18 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E12C0B2DDE;
        Wed, 29 May 2019 19:59:07 +0000 (UTC)
Received: from ovpn-112-20.rdu2.redhat.com (ovpn-112-20.rdu2.redhat.com [10.10.112.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E93061491;
        Wed, 29 May 2019 19:59:03 +0000 (UTC)
Message-ID: <cb2ef612be9e347a7cbceb26831f8d5ebea4eacf.camel@redhat.com>
Subject: Re: cellular modem APIs - take 2
From:   Dan Williams <dcbw@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Daniele Palmas <dnlplm@gmail.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Date:   Wed, 29 May 2019 14:59:02 -0500
In-Reply-To: <b59be15f1d0caa4eaa4476bbd8457afc44d57089.camel@sipsolutions.net>
References: <b59be15f1d0caa4eaa4476bbd8457afc44d57089.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 29 May 2019 19:59:18 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-05-27 at 15:20 +0200, Johannes Berg wrote:
> Hi all,
> 
> Sorry for the long delay in getting back to this. I'm meaning to write
> some code soon also for this, to illustrate better, but I figured I'd
> still get some thoughts out before I do that.
> 
> After more discussion (@Intel) and the previous thread(s), I've pretty
> much come to the conclusion that we should have a small subsystem for
> WWAN, rather than fudging everything like we previously did.
> 
> We can debate whether or not that should use 'real' netlink or generic
> netlink - personally I know the latter better and I think it has some
> real advantages like easier message parsing (it's automatic more or
> less) including strict checking and automatic policy introspection (I
> recently wrote the code for this and it's plugged into generic netlink
> family, for other netlink families it needs more hand-written code). But
> I could possibly be convinced of doing something else, and/or perhaps
> building more infrastructure for 'real' netlink to realize those
> benefits there as well.
> 
> 
> In terms of what I APIs are needed, the kernel-driver side and userspace
> side go pretty much hand in hand (the wwan subsystem just providing the
> glue), so what I say below is pretty much both a method/function call
> (kernel internal API) or a netlink message (userspace API).
> 
> 1) I think a generic abstraction of WWAN device that is not a netdev
>    is needed. Yes, on the one hand it's quite nice to be able to work on
>    top of a given netdev, but it's also limiting because it requires the
>    data flow to go through there, and packets that are tagged in some
>    way be exchanged there.
>    For VLANs this can be out-of-band (in a sense) with hw-accel, but for
>    rmnet-style it's in-band, and that limits what we can do.
> 
>    Now, of course this doesn't mean there shouldn't be a netdev created
>    by default in most cases, but it gives us a way to do additional
>    things that we cannot do with *just* a netdev.
> 
>    From a driver POV though, it would register a new "wwan_device", and
>    then get some generic callback to create a netdev on top, maybe by
>    default from the subsystem or from the user.
> 
> 2) Clearly, one needs to be able to create PDN netdevs, with the PDN
>    given to the command. Here's another advantage: If these are created
>    on top of another abstraction, not another netdev, they can have
>    their own queues, multiqueue RX etc. much more easily.
> 
>    Also, things like the "if I have just a single channel, drop the mux
>    headers" can then be entirely done in the driver, and the default
>    netdev no longer has the possibility of muxed and IP frames on the
>    same datapath.
> 
>    This also enables more things like handling checksum offload directly
>    in the driver, which doesn't behave so well with VLANs I think.
> 
>    All of that will just be easier for 5G too, I believe, with
>    acceleration being handled per PDN, multi-queue working without
>    ndo_select_queue, etc.
> 
>    Quite possibly there might be some additional (vendor-dependent?)
>    configuration for when such netdevs are created, but we need to
>    figure out if that really needs to be at creation time, or just
>    ethtool later or something like that. I guess it depends on how
>    generic it needs to be.

I'm pretty sure it would have to be async via netlink or ethtool or
whatever later, because the control plane (ModemManager,
libmbim/libqmi, oFono, etc) is what sets up the PDP/EPS context and
thus the data channel. A netdev (or a queue on that netdev) would be a
representation of that data channel, but that's not something the
kernel knows beforehand.

> 3) Separately, we need to have an ability to create "generalized control
>    channels". I'm thinking there would be a general command "create
>    control channel" with a given type (e.g. ATCMD, RPC, MBIM, GNSS) plus
>    a list of vendor-specific channels (e.g. for tracing).
> 
>    I'm unsure where this channel should really go - somehow it seems to
>    me that for many (most?) of these registering them as a serial line
>    would be most appropriate, but some, especially vendor-defined
>    channels like tracing, would probably better use a transport that's
>    higher bandwidth than, e.g. netdevs.

There's only a couple protocols that are run over serial transport,
namely AT, DM/DIAG, and Sierra's CnS.

Most of the rest like QMI and MBIM are packet-based protocols that can
use different transports. QMI for example can use CDC-WDM for USB
devices but on SoCs will use Qualcomm's SMD I believe.

Should you really need to account for these specially, or would some
kind of sysfs linkage like SET_NETDEV_DEV() be more appropriate?

Really all you want to do is (a) identify which WWAN device a given
control/data channel is for and (b) perhaps tag different control/data
channels with attributes like primary/secondary/gps/sim/etc often
through USB attributes or hardcoded data on SoCs.

>    One way I thought of doing this was to create an abstraction in the
>    wwan framework that lets the driver use SKBs anyway (i.e. TX and RX
>    on these channels using SKBs) and then translate them to some channel
>    in the framework - that way, we can even select at runtime if we want
>    a netdev (not really plugged into the network stack, ARPHDR_VOID?) or
>    some other kind of transport. Building that would allow us to add
>    transport types in the future too.

I'm not quite sure what you mean here, can you explain?

>    I guess such a channel should also be created by default, if it's
>    not already created by the driver in some out-of-band way anyway (and
>    most likely it shouldn't be, but I guess drivers might have some
>    entirely different communication channels for AT CMDs?)

For existing devices we're not talking about monolithic drivers here
(excepting 'hso') which I guess is part of the issue. A given device
might be driven by 2 or 3 different kernel drivers (usb-serial derived,
netdev, cdc-wdm) and they all expose different channels and none of
them coordinate. You have to do sysfs matching up the family tree to
find out they are associated with each other. If the kernel can take
over some of that responsibility great.

But the diversity is large. Any given TTY representing an AT channel
could be from USB drivers (usb-serial, cdc-wdm, vendor-specific driver
like sierra/hso, option) or PCI (nozomi) or platform stuff (Qualcomm
SoC ones). You can also do AT-over-QMI if you want.

I think it's worth discussing how this could be better unified but
maybe small steps to get there are more feasible.

> 4) There was a question about something like pure IP channels that
>    belong to another PDN and apparently now separate netdevs might be
>    used, but it seems to me that could just be a queue reserved on the
>    regular netdevs and then when you say ("enable video streaming on
>    wwan1 interface") that can do some magic to classify the video
>    packets (DSCP?) to another hardware queue for better QoS.

Most stuff is pure IP these days (both for QMI/rmnet and MBIM at least)
and having ethernet encapsulation is kinda pointless. But anyway you'd
need some mechanism to map that particular queue to a given channel/PDN
created by the control channel.

But classification is mostly done in the hardware/network because
setting different QoS for a given PDP/EPS context is basically saying
how much airtime the queue gets. No amount of kernel involvement is
going to change what the network lets you transmit. And I honestly
don't know how the firmware responds when its internal queues for a
given context are full that would tell a kernel queue to stop sending
more.

Dan

> 
> 
> Anyway, if all of this doesn't seem completely outlandish I'll try to
> write some code to illustrate it (sooner, rather than later).
> 
> Thanks,
> johannes
> 

