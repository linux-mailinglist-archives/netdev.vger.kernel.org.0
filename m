Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3424C5514D
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 16:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbfFYOOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 10:14:19 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:36434 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbfFYOOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 10:14:19 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hfmCx-0005G4-66; Tue, 25 Jun 2019 16:14:03 +0200
Message-ID: <868e949b1fc8cf22307f579ab1f14543064bec20.camel@sipsolutions.net>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alex Elder <elder@linaro.org>, Dan Williams <dcbw@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        abhishek.esse@gmail.com, Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        syadagir@codeaurora.org
Date:   Tue, 25 Jun 2019 16:14:00 +0200
In-Reply-To: <7de004be-27b6-ac63-389d-8ea9d23d0361@linaro.org> (sfid-20190624_182121_787713_CF57399E)
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
         <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
         <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
         <fc0d08912bc10ad089eb74034726308375279130.camel@redhat.com>
         <36bca57c999f611353fd9741c55bb2a7@codeaurora.org>
         <153fafb91267147cf22e2bf102dd822933ec823a.camel@redhat.com>
         <CAK8P3a2Y+tcL1-V57dtypWHndNT3eDJdcKj29c_v+k8o1HHQig@mail.gmail.com>
         <f4249aa5f5acdd90275eda35aa16f3cfb29d29be.camel@redhat.com>
         <CAK8P3a2nzZKtshYfomOOSYkqx5HdU15Wr9b+3va0B1euNhFOAg@mail.gmail.com>
         <dbb32f185d2c3a654083ee0a7188379e1f88d899.camel@sipsolutions.net>
         <e6ba8a9063e63506c0b88a70418d74ca4efe85cd.camel@sipsolutions.net>
         <850eed1d-0fec-c396-6e91-b5f1f8440ded@linaro.org>
         <84153d9e7c903084b492ceccc0dd98cbb32c12ac.camel@redhat.com>
         <7de004be-27b6-ac63-389d-8ea9d23d0361@linaro.org>
         (sfid-20190624_182121_787713_CF57399E)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

I'll just pick a few or your messages and reply there - some other
subthreads seem to have pretty much completed.

> Sorry for the delay.  There's a lot here to go through, and with
> each message the picture is (slowly) getting a bit clearer for me.
> Still, there are some broad tradeoffs to consider and I think we
> need to get a little more specific again.  I'm going to start a
> new thread (or rather re-subject a response to the very first one)
> that tries to do a fresh start that takes into account the
> discussion so far.
> 
> I will also be talking with some people inside Qualcomm (including
> Subash) soon to make sure we don't miss any requirements or insights
> they know of that I don't realize are important.

That's much appreciated.

> > Linux usually tries to keep drivers generic and focused; each driver is
> > written for a specific function. For example, a USB device usually
> > provides multiple USB interfaces which will be bound to different Linux
> > drivers like a TTY, cdc-ether, QMI (via qmi_wwan), cdc-acm, etc.
> 
> So USB has some attributes similar to what we're talking about
> here.  But if I'm not mistaken we want some sort of an overall
> management scheme as well.

Yes. For the record, I think the part about "keep drivers generic and
focused" really only works for USB devices that expose different pieces
that look like any other network device or a TTY device on the USB
level, just the combination of these things (and knowing about that)
really makes them a modem.

For things like IPA or the (hypothetical) Intel driver we're talking
about, it's still all managed by a single (PCIe) driver. For the Intel
device in particular, even all the control channels are over exactly the
same transport mechanism as the data channels.

> > These drivers are often generic and we may not have enough information
> > in one driver to know that the parent of this interface is a WWAN
> > device. But another driver might. Since probing is asynchronous we may
> > have cdc-acm bind to a device and provide a TTY before cdc-ether (which
> > does know it's a WWAN) binds and provides the netdevice.
> 
> Is this why Johannes wanted to have a "maybe attach" method?

Yes.

> I don't like the "maybe" API unless there's no other way to do it.
> 
> Instead I think it would be better for the probing driver to register
> with a whatever the WWAN core is, and then have the WWAN core be
> responsible for pulling things all together when it receives a
> request to do so.  I.e., something in user space should request
> that a registered data interface be brought up, and at that
> time everything "knows" it's implemented as part of a WWAN
> device.

Right, but then we just punt to userspace. Mostly we *do* (eventually!)
know that it's a WWAN device, just not every component can detect it.
Some components typically can.

So for example, you might have a USB multi-function device with a
network function (looks just like ethernet pretty much) but another TTY
control channel that actually has some specific WWAN IDs, so that part
can know it's a WWAN.

Here, the ethernet function would need "maybe" attach, and the control
channel would "definitively" attach, pulling it together as a WWAN
device without requiring any more action or information.

> So maybe:
> - Hardware probe detects a WWAN device
> - The drivers that detect the WWAN device register it with the
>   WWAN core code.
> - A control channel is instantiated at/before the time the WWAN
>   device is registered
> - Something in user space should manage the bring-up of any
>   other things on the WWAN device thereafter

But those things need to actually get connected first :-)

In IPA/Intel case this is easy since it's a single driver. But if
there's multi-function device with ethernet being a completely separate
driver, the control channel cannot even reach that to tell it to create
a new data channel.

> > userspace should probably always create the netdevices (since they are
> > always useless until userspace coordinates with the firmware about
> > them) but that's not how things are yet.
> 
> That's too bad.  How hard would that be to change?

Depends, but as I said above it's probably orthogonal to the question.
The data channel driver would still need to attach to the WWAN device
somehow so it becomes reachable by the control plane (note this isn't
the same as "control channel" since the latter talks to the modem, the
control plane talks to the kernel drivers).

> > > - What causes a created channel to be removed?
> > 
> > Driver removal, userspace WWAN daemon terminating the packet data
> > connection which the channel represents, the modem terminating the
> > packet data connection (eg network initiated disconnect), etc.
> 
> OK this is as I expected.  Driver (or device) removal is somewhat
> obvious, but you're confirming user space might request it as well.

If userspace actually had the ability to create (data) channels, then it
would have the ability to also remove them. Right now, this may or may
not be supported by the drivers that act together to form the interfaces
to a WWAN device.

> > > - You distinguish between attaching a netdevice and (what
> > >   I'll call) activating it.  What causes activation?
> > 
> > Can you describe what you mean by "activating"? Do you mean
> > successfully TX/RX packets via the netdev and the outside world?
> 
> Johannes mentioned an API to "maybe attach" a device.  That begs
> the question of what happens if this request does *not* attach.
> Does the attach request have to be made again, or is it done
> automatically with a notification, or something else?
> 
> So by "activation" I was trying to refer to the notion of this
> subsequent successful attach.

Oh. Well, what I was thinking that "maybe attach" would just be a sort
of "in-limbo" WWAN device that doesn't get visible to userspace or the
control plane until something did a "definitively attach" to it so it
was known to be a WWAN device.

The case of "maybe attach but never get to definitive attach" would be
the case where the USB driver bound a real ethernet device, for example,
not something that looks like an ethernet device but really is part of a
modem.


OTOH, "activating" a data channel is also needed somehow through the
control channel by talking to the modem, i.e. making a connection. In
the ideal case we'd not even *have* a netdev until it makes sense to
create a data channel, but in reality a lot of devices have one around
all the time (or even only support one), AFAICT.

> > I read "attach" here as simply associating an existing netdev with the
> > "parent" WWAN device. A purely Linux operation that is only book-
> > keeping and may not have any interaction with the modem.
> 
> If that's the case I would want the "activation" to be a separate
> step.  The attach would do the bookkeeping, and generally shouldn't
> fail. An attached interface would be brought up ("activated")
> separately and might fail if things aren't quite ready yet.

Right, but netdevs need to be brought up anyway, and that can fail?

> > > - How are the attributes of a WWAN device or channel set,
> > >   or communicated?
> > 
> > Via netlink attributes when userspace asks the WWAN device to create a
> > new channel. In the control methods I've seen, only userspace really
> > knows the channel identifier that it and the modem have agreed on (eg
> > what the MUX ID in the QMAP header would be, or the MBIM Session ID).
> 
> Yes, that's the way it's worked for rmnet and IPA.  Previously it
> was IOCTL requests but it's currently hard-wired.

Right. We're just trying to lift it out of the Qualcomm sphere into
something more generically useful.

johannes

