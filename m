Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE39F2E5AA
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 22:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfE2UAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 16:00:02 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:60788 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfE2UAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 16:00:02 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hW4jq-0005Qg-Kd; Wed, 29 May 2019 21:59:54 +0200
Message-ID: <acf18b398fd63f2dfece5981ebd5057141529e6a.camel@sipsolutions.net>
Subject: Re: cellular modem APIs - take 2
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Daniele Palmas <dnlplm@gmail.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Date:   Wed, 29 May 2019 21:59:51 +0200
In-Reply-To: <662BBC5C-D0C7-4B2C-A001-D6F490D0F36F@holtmann.org>
References: <b59be15f1d0caa4eaa4476bbd8457afc44d57089.camel@sipsolutions.net>
         <662BBC5C-D0C7-4B2C-A001-D6F490D0F36F@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

> Have you actually looked at Phonet or CAIF.

Phonet is just a specific protocol spoken by a specific modem (family)
for their control plane. Not all modems are going to be speaking this.
Same for CAIF, really. I don't really see all that much that's generic
(enough) here. It's unfortunate that in all this time nobody ever
bothered to even try though, and just invented all their own mechanisms
to precisely mirror the hardware and firmware they were working with.

Theoretically now, you could build a driver that still speaks CAIF or
phonet and then translates to a specific modem, but what would the point
be?

Now, I'm looking more at the data plan than the control plane, so I
guess you could argue I should've not just mentioned MBIM and AT
commands, but also something like Phonet/CAIF.

> And netdev by default seems like repeating the same mistake we have
> done with WiFi. Your default context in LTE cases is only available
> when actually registered to the LTE bearer. It is pretty much
> pointless to have a netdev if you are not registered to the network.

I partially agree with this.

Of course, for WiFi, that's just wrong since the control path is on the
netdev. Without a netdev, nothing works, and so not having one by
default just adds something pointless to the setup necessary to bring up
anything at all. It can be argued whether not allowing to remove it is
right, but that just detracts from the discussion at hand and there's
also a lot of history here.

I do understand (and mostly agree) that having a netdev by default
that's not connected to anything and has no functionality until you've
done some out-of-band (as far as the netdev is concerned) setup is
fairly much pointless, but OTOH having a netdev is something that people
seem to want for various reasons (discovery, ethtool, ...).

> You have to do a lot of initial modem setup before you ever get to the
> having your default context connected. Have a look at oFono and what
> it does to bring up the modem.

Sure.

> > 2) Clearly, one needs to be able to create PDN netdevs, with the PDN
> >   given to the command. Here's another advantage: If these are created
> >   on top of another abstraction, not another netdev, they can have
> >   their own queues, multiqueue RX etc. much more easily.
[...]
> I think you need to provide actually a lot more details on how queue
> control inside Linux would be helpful and actually work in the first
> place. I don’t see how Linux will be ever in charge and not the modem
> do this all for you.

I think you misunderstand. I wasn't really talking about *queue control*
(packet dequeue etc.) although this is *also* something that could be
interesting, since the modem can only control packets that ever made it
to the hardware.

I was more thinking of what I actually wrote - "have their own queues,
multiqueue RX etc." - i.e. control the software layer of the queues in
the driver, rather than having all of that managed in some stacked
netdev like VLAN.

For example, with stacked netdevs like VLANs it gets difficult (and
awkward from a network stack perspective) to put frames for different
connections (stacked netdevs) into different hardware queues and manage
flow control correctly.

Similarly, if one connection has maybe multiple hardware queues (say for
a specific video stream) disentangling that when you have stacked
netdevs is much harder than when they're all separate.

(And, of course, there's little point in having the underlying netdev to
start with since it speaks a device-specific protocol the network stack
will never understand.)

> > 3) Separately, we need to have an ability to create "generalized control
> >   channels". I'm thinking there would be a general command "create
> >   control channel" with a given type (e.g. ATCMD, RPC, MBIM, GNSS) plus
> >   a list of vendor-specific channels (e.g. for tracing).
[...]
> >   I guess such a channel should also be created by default, if it's
> >   not already created by the driver in some out-of-band way anyway (and
> >   most likely it shouldn't be, but I guess drivers might have some
> >   entirely different communication channels for AT CMDs?)
> 
> I would just use sockets like Phonet and CAIF.

It was in fact one of the options I considered, but it seems to have
very little traction with any other userspace, and having a separate
socket family yet again also seems a bit pointless. I guess for devices
that do already speak Phonet or CAIF that would make sense. Possible to
some extent, but not really useful, would be to terminate the Phonet or
CAIF protocol inside the driver or stack, but then you end up having to
emulate some specific firmware behaviour ...

So ultimately it boils down to what protocols you want to support and
what kind of API they typically use. I guess I don't have enough hubris
to propose unifying the whole command set and how you talk to your
device ;-)

I suppose you could have a socket type for AT commands, but is that
really all that useful? Or a socket type that muxes the different
control channels you might have, which gets close to phonet/caif.

> Frankly I have a problem if this is designed from the hardware point
> of view. Unless you are familiar with how 3GPP works and what a
> telephony stack like oFono has to do, there is really no point in
> trying to create a WWAN subsystem.
> 
> Anything defined needs to be defined in terms of 3GPP and not what
> current drivers have hacked together.

That objection makes no sense to me. 3GPP doesn't define how the data
plane is implemented in your device/OS. There's a data plane, it carries
IP packets, but how you get those to your applications?

After all, I'm not really proposing that we put oFono or something like
it into the kernel - far from it! I'm only proposing that we kill the
many various ways of creating and managing the necessary netdevs (VLANs,
sysfs, rmnet, ...) from a piece of software like oFono (or libmbim or
whatever else).

Apart from CAIF and phonet, oFono doesn't even try to do this though,
afaict, so I guess it relies on the default netdev created, or some out-
of-band configuration is still needed?

johannes

