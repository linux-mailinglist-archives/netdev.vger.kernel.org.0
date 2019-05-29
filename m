Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BADD2E4F5
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 21:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfE2TFQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 May 2019 15:05:16 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:60331 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfE2TFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 15:05:16 -0400
Received: from [172.20.12.219] (unknown [94.75.125.194])
        by mail.holtmann.org (Postfix) with ESMTPSA id 824B2CEE14;
        Wed, 29 May 2019 21:13:35 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: cellular modem APIs - take 2
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <b59be15f1d0caa4eaa4476bbd8457afc44d57089.camel@sipsolutions.net>
Date:   Wed, 29 May 2019 21:05:12 +0200
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Daniele Palmas <dnlplm@gmail.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Content-Transfer-Encoding: 8BIT
Message-Id: <662BBC5C-D0C7-4B2C-A001-D6F490D0F36F@holtmann.org>
References: <b59be15f1d0caa4eaa4476bbd8457afc44d57089.camel@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

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
>   is needed. Yes, on the one hand it's quite nice to be able to work on
>   top of a given netdev, but it's also limiting because it requires the
>   data flow to go through there, and packets that are tagged in some
>   way be exchanged there.
>   For VLANs this can be out-of-band (in a sense) with hw-accel, but for
>   rmnet-style it's in-band, and that limits what we can do.
> 
>   Now, of course this doesn't mean there shouldn't be a netdev created
>   by default in most cases, but it gives us a way to do additional
>   things that we cannot do with *just* a netdev.
> 
>   From a driver POV though, it would register a new "wwan_device", and
>   then get some generic callback to create a netdev on top, maybe by
>   default from the subsystem or from the user.

Have you actually looked at Phonet or CAIF.

And netdev by default seems like repeating the same mistake we have done with WiFi. Your default context in LTE cases is only available when actually registered to the LTE bearer. It is pretty much pointless to have a netdev if you are not registered to the network.

You have to do a lot of initial modem setup before you ever get to the having your default context connected. Have a look at oFono and what it does to bring up the modem.

> 2) Clearly, one needs to be able to create PDN netdevs, with the PDN
>   given to the command. Here's another advantage: If these are created
>   on top of another abstraction, not another netdev, they can have
>   their own queues, multiqueue RX etc. much more easily.
> 
>   Also, things like the "if I have just a single channel, drop the mux
>   headers" can then be entirely done in the driver, and the default
>   netdev no longer has the possibility of muxed and IP frames on the
>   same datapath.
> 
>   This also enables more things like handling checksum offload directly
>   in the driver, which doesn't behave so well with VLANs I think.
> 
>   All of that will just be easier for 5G too, I believe, with
>   acceleration being handled per PDN, multi-queue working without
>   ndo_select_queue, etc.
> 
>   Quite possibly there might be some additional (vendor-dependent?)
>   configuration for when such netdevs are created, but we need to
>   figure out if that really needs to be at creation time, or just
>   ethtool later or something like that. I guess it depends on how
>   generic it needs to be.

I think you need to provide actually a lot more details on how queue control inside Linux would be helpful and actually work in the first place. I don’t see how Linux will be ever in charge and not the modem do this all for you.

> 3) Separately, we need to have an ability to create "generalized control
>   channels". I'm thinking there would be a general command "create
>   control channel" with a given type (e.g. ATCMD, RPC, MBIM, GNSS) plus
>   a list of vendor-specific channels (e.g. for tracing).
> 
>   I'm unsure where this channel should really go - somehow it seems to
>   me that for many (most?) of these registering them as a serial line
>   would be most appropriate, but some, especially vendor-defined
>   channels like tracing, would probably better use a transport that's
>   higher bandwidth than, e.g. netdevs.
> 
>   One way I thought of doing this was to create an abstraction in the
>   wwan framework that lets the driver use SKBs anyway (i.e. TX and RX
>   on these channels using SKBs) and then translate them to some channel
>   in the framework - that way, we can even select at runtime if we want
>   a netdev (not really plugged into the network stack, ARPHDR_VOID?) or
>   some other kind of transport. Building that would allow us to add
>   transport types in the future too.
> 
>   I guess such a channel should also be created by default, if it's
>   not already created by the driver in some out-of-band way anyway (and
>   most likely it shouldn't be, but I guess drivers might have some
>   entirely different communication channels for AT CMDs?)

I would just use sockets like Phonet and CAIF.

> 4) There was a question about something like pure IP channels that
>   belong to another PDN and apparently now separate netdevs might be
>   used, but it seems to me that could just be a queue reserved on the
>   regular netdevs and then when you say ("enable video streaming on
>   wwan1 interface") that can do some magic to classify the video
>   packets (DSCP?) to another hardware queue for better QoS.
> 
> 
> 
> Anyway, if all of this doesn't seem completely outlandish I'll try to
> write some code to illustrate it (sooner, rather than later).

Frankly I have a problem if this is designed from the hardware point of view. Unless you are familiar with how 3GPP works and what a telephony stack like oFono has to do, there is really no point in trying to create a WWAN subsystem.

Anything defined needs to be defined in terms of 3GPP and not what current drivers have hacked together.

Regards

Marcel

