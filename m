Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F36C4A96C
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730253AbfFRSGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:06:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53184 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729715AbfFRSGb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 14:06:31 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0918DC0586C4;
        Tue, 18 Jun 2019 18:06:27 +0000 (UTC)
Received: from ovpn-112-37.rdu2.redhat.com (ovpn-112-37.rdu2.redhat.com [10.10.112.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CDDB176BD;
        Tue, 18 Jun 2019 18:06:14 +0000 (UTC)
Message-ID: <84153d9e7c903084b492ceccc0dd98cbb32c12ac.camel@redhat.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
From:   Dan Williams <dcbw@redhat.com>
To:     Alex Elder <elder@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
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
Date:   Tue, 18 Jun 2019 13:06:13 -0500
In-Reply-To: <850eed1d-0fec-c396-6e91-b5f1f8440ded@linaro.org>
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
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 18 Jun 2019 18:06:30 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-06-18 at 10:20 -0500, Alex Elder wrote:
> On 6/17/19 7:25 AM, Johannes Berg wrote:
> > On Mon, 2019-06-17 at 13:42 +0200, Johannes Berg wrote:
> > 
> > > But anyway, as I alluded to above, I had something like this in
> > > mind:
> > 
> > I forgot to state this here, but this was *heavily* influenced by
> > discussions with Dan - many thanks to him.
> 
> Thanks for getting even more concrete with this.  Code is the
> most concise way of describing things, once the general ideas
> seem to be coming together.
> 
> I'm not going to comment on the specific code bits, but I have
> some more general questions and comments on the design.  Some
> of these are simply due to my lack of knowledge of how WWAN/modem
> interactions normally work.
> 
> First, a few terms (correct or improve as you like):
> - WWAN device is a hardware device (like IPA) that presents a
>   connection between AP and modem, and presents an interface
>   that allows the use of that connection to be managed.
> - WWAN netdevice represents a Linux network interface, with its
>   operations and queues, etc., but implements a standardized
>   set of WWAN-specific operations.  It represents a logical
> ' channel whose data is multiplexed over the WWAN device.
> - WWAN channel is a user space abstraction that corresponds
>   with a WWAN netdevice (but I'm not clear on all the ways
>   they differ or interact).

When Johannes and I have talked about "WWAN channel" we mean a control
or data or other channel. That could be QMI, AT, MBIM control, GPS,
PCSC, QMAP, MBIM data, PPP TTY, DM/DIAG, CDC-ETHER, CDC-NCM, Sierra
HIP, etc. Or even voice-call audio :)

A netdev is a Linux abstraction of a WWAN *data* channel, be that QMI
or CDC-ETHER or whatever.

> - The WWAN core is kernel code that presents abstractions
>   for WWAN devices and netdevices, so they can be managed
>   in a generic way.  It is for configuration and communication
>   and is not at all involved in the data path.
> 
> You're saying that the WWAN driver space calls wwan_add()
> to register itself as a new WWAN device.
> 
> You're also saying that a WWAN device "attaches" a WWAN
> netdevice, which is basically notifying the WWAN core
> that the new netdev/channel is available for use.
> - I trust that a "tentative" attachement is necessary.  But
>   I'm not sure what makes it transition into becoming a
>   "real" one, or how that event gets communicated.

Linux usually tries to keep drivers generic and focused; each driver is
written for a specific function. For example, a USB device usually
provides multiple USB interfaces which will be bound to different Linux
drivers like a TTY, cdc-ether, QMI (via qmi_wwan), cdc-acm, etc.

These drivers are often generic and we may not have enough information
in one driver to know that the parent of this interface is a WWAN
device. But another driver might. Since probing is asynchronous we may
have cdc-acm bind to a device and provide a TTY before cdc-ether (which
does know it's a WWAN) binds and provides the netdevice.

> Some questions:
> - What causes a new channel to be created?  Is it initiated
>   by the WWAN device driver?  Does the modem request that
>   it get created?  User space?  Both?

Either created at driver bind time in the kernel (usually control
channels) or initiated by userspace when the WWAN management process
has coordinated with the firmware for another channel. Honestly
userspace should probably always create the netdevices (since they are
always useless until userspace coordinates with the firmware about
them) but that's not how things are yet.

[ A concrete example...

Assume a QMI device has an existing packet data connection which is
abstracted by a netdevice on the Linux side. Now the WWAN management
daemon wants to create a second packet data connection with a different
APN (maybe an MMS connection, maybe a VOIP one, maybe an IPv6). It
sends a WDS Start Network request to the modem firmware and receives a
new QMI Packet Data Handle.

The management daemon must somehow get a netdevice associated with this
new Packet Data Handle. It would ask the WWAN kernel device to create a
new data channel with the PDH, and would get back the ifindex of that
netdevice which it would configure with the IP that it gets from the
firmware via the WDS Get Current Settings QMI request.

The WWAN device would forward the request down to IPA (or rmnet) which
would then create the netdevice using the PDH as the QMAP MUX ID for
that netdevice's traffic.]


> - What causes a created channel to be removed?

Driver removal, userspace WWAN daemon terminating the packet data
connection which the channel represents, the modem terminating the
packet data connection (eg network initiated disconnect), etc.

> - You distinguish between attaching a netdevice and (what
>   I'll call) activating it.  What causes activation?

Can you describe what you mean by "activating"? Do you mean
successfully TX/RX packets via the netdev and the outside world?

I read "attach" here as simply associating an existing netdev with the
"parent" WWAN device. A purely Linux operation that is only book-
keeping and may not have any interaction with the modem. 

> - How are the attributes of a WWAN device or channel set,
>   or communicated?

Via netlink attributes when userspace asks the WWAN device to create a
new channel. In the control methods I've seen, only userspace really
knows the channel identifier that it and the modem have agreed on (eg
what the MUX ID in the QMAP header would be, or the MBIM Session ID).

> - Are there any attributes that are only optionally supported,
>   and if so, how are the supported ones communicated?

Yeah, capabilities would be important here and I don't think Johannes
accounted for that yet.

> - Which WWAN channel attributes must be set *before* the
>   channel is activated, and can't be changed?  Are there any
>   that can be changed dynamically?

I would assume userspace must pass the agreed identifier (QMUX ID, MBIM
session ID, etc) when creating the channel and that wouldn't change. I
think a world where you can dynamically change the MUX ID/SessionID/etc
is a more complicated one.

Things like QoS could change but I don't recall if modems allow that;
eg does a +CGEQOS (or equivalent QMI WDS LTE QoS Parameters request)
take effect while the bearer is active, or is it only respected on
bearer creation?

> And while the whole point of this is to make things generic,
> it might be nice to have a way to implement a new feature
> before it can be "standardized".

That would be nice, but I'd rather have the conversation about if/how
to standardize things before they make it into the kernel and have
their API set in stone... which is how we ended up with 5 ways of doing
the same thing already.

Dan

> Thanks.
> 
> 					-Alex
> 
> PS  I don't want to exclude anybody but we could probably start
>     a different mail chain on this topic...
> 
> > > driver_dev
> > >   struct device *dev (USB, PCI, ...)
> > >   net_device NA
> > >   net_device NB
> > >   tty TA
> > >  ...
> > > 
> 
> . . .

