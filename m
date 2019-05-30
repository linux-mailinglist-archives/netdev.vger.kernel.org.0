Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C667E2F715
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 07:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfE3F3C convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 30 May 2019 01:29:02 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:51826 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3F3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 01:29:02 -0400
Received: from [172.20.12.219] (unknown [94.75.125.194])
        by mail.holtmann.org (Postfix) with ESMTPSA id 90F26CEE94;
        Thu, 30 May 2019 07:37:20 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: cellular modem APIs - take 2
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <acf18b398fd63f2dfece5981ebd5057141529e6a.camel@sipsolutions.net>
Date:   Thu, 30 May 2019 07:28:58 +0200
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Daniele Palmas <dnlplm@gmail.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Content-Transfer-Encoding: 8BIT
Message-Id: <EDC081A9-573B-4F2C-BCE7-C9FD424DB2DE@holtmann.org>
References: <b59be15f1d0caa4eaa4476bbd8457afc44d57089.camel@sipsolutions.net>
 <662BBC5C-D0C7-4B2C-A001-D6F490D0F36F@holtmann.org>
 <acf18b398fd63f2dfece5981ebd5057141529e6a.camel@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

>> Have you actually looked at Phonet or CAIF.
> 
> Phonet is just a specific protocol spoken by a specific modem (family)
> for their control plane. Not all modems are going to be speaking this.
> Same for CAIF, really. I don't really see all that much that's generic
> (enough) here. It's unfortunate that in all this time nobody ever
> bothered to even try though, and just invented all their own mechanisms
> to precisely mirror the hardware and firmware they were working with.
> 
> Theoretically now, you could build a driver that still speaks CAIF or
> phonet and then translates to a specific modem, but what would the point
> be?
> 
> Now, I'm looking more at the data plan than the control plane, so I
> guess you could argue I should've not just mentioned MBIM and AT
> commands, but also something like Phonet/CAIF.

actually Phonet and CAIF are the transports and endpoint connections in the devices. The modem control protocol of Phonet was ISI and for CAIF it was actually AT commands (but I think there was a plan for ISI over CAIF).

>> And netdev by default seems like repeating the same mistake we have
>> done with WiFi. Your default context in LTE cases is only available
>> when actually registered to the LTE bearer. It is pretty much
>> pointless to have a netdev if you are not registered to the network.
> 
> I partially agree with this.
> 
> Of course, for WiFi, that's just wrong since the control path is on the
> netdev. Without a netdev, nothing works, and so not having one by
> default just adds something pointless to the setup necessary to bring up
> anything at all. It can be argued whether not allowing to remove it is
> right, but that just detracts from the discussion at hand and there's
> also a lot of history here.

Actually we need to have that history discussion on how it was also wrong for WiFi from my point of view. I do understand how things have made sense back in the days, but these days clinging to a netdev for control point even in WiFi makes no sense. Anyway, that is a different discussion.

My point is really that a lot of other things are ongoing before a modem even gets a data plane that would be mapped to a netdev.

> I do understand (and mostly agree) that having a netdev by default
> that's not connected to anything and has no functionality until you've
> done some out-of-band (as far as the netdev is concerned) setup is
> fairly much pointless, but OTOH having a netdev is something that people
> seem to want for various reasons (discovery, ethtool, …).

That worries me even more. Discovery via RTNL is pointless and totally racy. Usage of ethtool is pointless as well since we are dealing with IP only interfaces.

I have a felling that these points are from people that don’t really understand 3GPP and want to use command line tools to handle cellular modem. Back in the days iwconfig worked as well and so did pppd, but by now we all learned that this is not going to work. Especially in the world of 3GPP it is not going to work. I do not care a bit if ethtool or any other command line tool that wants to talk directly to kernel. Unless you have a way for a telephony daemon like oFono to get its work done, any of this above is just a distraction.

>> You have to do a lot of initial modem setup before you ever get to the
>> having your default context connected. Have a look at oFono and what
>> it does to bring up the modem.
> 
> Sure.
> 
>>> 2) Clearly, one needs to be able to create PDN netdevs, with the PDN
>>>  given to the command. Here's another advantage: If these are created
>>>  on top of another abstraction, not another netdev, they can have
>>>  their own queues, multiqueue RX etc. much more easily.
> [...]
>> I think you need to provide actually a lot more details on how queue
>> control inside Linux would be helpful and actually work in the first
>> place. I don’t see how Linux will be ever in charge and not the modem
>> do this all for you.
> 
> I think you misunderstand. I wasn't really talking about *queue control*
> (packet dequeue etc.) although this is *also* something that could be
> interesting, since the modem can only control packets that ever made it
> to the hardware.
> 
> I was more thinking of what I actually wrote - "have their own queues,
> multiqueue RX etc." - i.e. control the software layer of the queues in
> the driver, rather than having all of that managed in some stacked
> netdev like VLAN.
> 
> For example, with stacked netdevs like VLANs it gets difficult (and
> awkward from a network stack perspective) to put frames for different
> connections (stacked netdevs) into different hardware queues and manage
> flow control correctly.
> 
> Similarly, if one connection has maybe multiple hardware queues (say for
> a specific video stream) disentangling that when you have stacked
> netdevs is much harder than when they're all separate.
> 
> (And, of course, there's little point in having the underlying netdev to
> start with since it speaks a device-specific protocol the network stack
> will never understand.)

I am not convinced that any of this will help us since it is all network specific and the Linux job is just to feed the packets into the hardware.

>>> 3) Separately, we need to have an ability to create "generalized control
>>>  channels". I'm thinking there would be a general command "create
>>>  control channel" with a given type (e.g. ATCMD, RPC, MBIM, GNSS) plus
>>>  a list of vendor-specific channels (e.g. for tracing).
> [...]
>>>  I guess such a channel should also be created by default, if it's
>>>  not already created by the driver in some out-of-band way anyway (and
>>>  most likely it shouldn't be, but I guess drivers might have some
>>>  entirely different communication channels for AT CMDs?)
>> 
>> I would just use sockets like Phonet and CAIF.
> 
> It was in fact one of the options I considered, but it seems to have
> very little traction with any other userspace, and having a separate
> socket family yet again also seems a bit pointless. I guess for devices
> that do already speak Phonet or CAIF that would make sense. Possible to
> some extent, but not really useful, would be to terminate the Phonet or
> CAIF protocol inside the driver or stack, but then you end up having to
> emulate some specific firmware behaviour ...
> 
> So ultimately it boils down to what protocols you want to support and
> what kind of API they typically use. I guess I don't have enough hubris
> to propose unifying the whole command set and how you talk to your
> device ;-)
> 
> I suppose you could have a socket type for AT commands, but is that
> really all that useful? Or a socket type that muxes the different
> control channels you might have, which gets close to phonet/caif.

As I stated above, Phonet and CAIF where just there to connect endpoints inside the hardware / platform. The protocol running inside these pipes could have been anything. I think what is more important is to figure out on how you access the pipes.

I think that Dan already stated this, the difference is just that we have protocols that underneath accept a transport that is serialized and stream based and others where the transport has packet boundaries and is packetized. These would obviously match to SOCK_STREAM and SOCK_SEQPACKET if you had to classify them.

Now that said, it is nice to just get a file descriptor from the kernel and then drive your protocol from userspace. We have used AT commands over TCP to connect to Phonesim for example. The AT commands don’t care if it is a real serial port, an emulated one by the modem driver or even a SOCK_STREAM socket. Same applies to all the other protocols and implementation that have been written over the years.

Dan also stated the major problems that the control and data path endpoints have been served by different drivers and figuring out what character device belongs to what network interface has been a mess. Creating a character device or a TTY is far too simple and because everybody wants to run pppd on a TTY that is what led us into this mess.

So what is really needed is a way to discovery the cellular modem and its capabilities towards the Linux host. Not all modems are equal and the number of control paths might be limited in the same way as the number of contexts it can expose or its voice to the host streams.

>> Frankly I have a problem if this is designed from the hardware point
>> of view. Unless you are familiar with how 3GPP works and what a
>> telephony stack like oFono has to do, there is really no point in
>> trying to create a WWAN subsystem.
>> 
>> Anything defined needs to be defined in terms of 3GPP and not what
>> current drivers have hacked together.
> 
> That objection makes no sense to me. 3GPP doesn't define how the data
> plane is implemented in your device/OS. There's a data plane, it carries
> IP packets, but how you get those to your applications?
> 
> After all, I'm not really proposing that we put oFono or something like
> it into the kernel - far from it! I'm only proposing that we kill the
> many various ways of creating and managing the necessary netdevs (VLANs,
> sysfs, rmnet, ...) from a piece of software like oFono (or libmbim or
> whatever else).
> 
> Apart from CAIF and phonet, oFono doesn't even try to do this though,
> afaict, so I guess it relies on the default netdev created, or some out-
> of-band configuration is still needed?

As stated above, that is the problem of default netdev by drivers. Phonet and CAIF (and also our own support with 207.07 and RawIP) are superior in these regards. That is also why phones used these. The rest was then cellular data cards where the thinking was ATD+PPP.

Regards

Marcel

