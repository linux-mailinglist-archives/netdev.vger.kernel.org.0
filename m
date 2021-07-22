Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2593D26E1
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 17:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbhGVPAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 11:00:08 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:21935 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232688AbhGVPAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 11:00:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626968437;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=Ry5DhG356ANv2igJZhQ+pgw95Y/FGgirnHdl1TlEnpE=;
    b=N7LBRXLwjxN2fygdz7IxsyrvPAofyTjsb3lUdoNqrWDdet45Rsgnlf58SBHTqrOjpe
    XHg4bfCMPMYpXmGRstZFaXLi6EYQSPCNp9drm+BF6qkl6ESZ8XE8Qbyhw76llswIedTh
    nM/WZt55yHlD44LNUfGFAwBGNjlnkWFkn20tFP8B2CftxGQQphw2VvKn1qQ1buaHT1Dv
    9UbGUu//UnjTSz5hAAwQ8gV47hius9oTqWqhCEz+2+qcHbflucZWbbyvQrniNWWTrjxa
    s1CcNUIRQuMe5MuHBsmFSQIVXbl8bBQLQiLTgLZNIgGLXPzG38V7h3TguLLo7nATFDXE
    s0Cw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u261EJF5OxJD4paA8ZuO1A=="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.28.1 DYNA|AUTH)
    with ESMTPSA id g02a44x6MFeaQsv
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 22 Jul 2021 17:40:36 +0200 (CEST)
Date:   Thu, 22 Jul 2021 17:40:32 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        dmaengine@vger.kernel.org, devicetree <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Subject: Re: [RFC PATCH net-next 4/4] net: wwan: Add Qualcomm BAM-DMUX WWAN
 network driver
Message-ID: <YPmRcBXpRtKKSDl8@gerhold.net>
References: <20210719145317.79692-1-stephan@gerhold.net>
 <20210719145317.79692-5-stephan@gerhold.net>
 <CAMZdPi8oxRMo0erfd0wrUPzD2UsbexoR=86u2N75Fd9RpXHoKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZdPi8oxRMo0erfd0wrUPzD2UsbexoR=86u2N75Fd9RpXHoKg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Loic,

On Mon, Jul 19, 2021 at 06:01:33PM +0200, Loic Poulain wrote:
> On Mon, 19 Jul 2021 at 17:01, Stephan Gerhold <stephan@gerhold.net> wrote:
> >
> > I'm not sure how to integrate the driver with the WWAN subsystem yet.
> > At the moment the driver creates network interfaces for all channels
> > announced by the modem, it does not make use of the WWAN link management
> > yet. Unfortunately, this is a bit complicated:
> >
> > Both QMAP and the built-in multiplexing layer might be needed at some point.
> > There are firmware versions that do not support QMAP and the other way around
> > (the built-in multiplexing was disabled on very recent firmware versions).
> > Only userspace can check if QMAP is supported in the firmware (via QMI).
> >
> > I could ignore QMAP completely for now but I think someone will show up
> > who will need this eventually. And if there is going to be common code for
> > QMAP/rmnet link management it would be nice if BAM-DMUX could also make
> > use of it.
> 
> I have this on my TODO list for mhi-net QMAP.
> 

Great, thanks!

> > But the question is, how could this look like? How do we know if we should
> > create a link for QMAP or a BAM-DMUX channel? Does it even make sense
> > to manage the 1-8 channels via the WWAN link management?
> 
> Couldn't it be specified via dts (property or different compatible
> string)?

It would probably work in most cases, but I have to admit that I would
prefer to avoid this for the following reason: This driver is used on
some smartphones that have different variants for different parts of the
world. As far as Linux is concerned the hardware is pretty much
identical, but the modem firmware is often somewhat device-specific.

This means that the same device tree is often used with different
firmware versions. Perhaps we are lucky enough that the firmware
versions have the same capabilities, but I'm not fully sure about that.

I think at the end the situation is fairly similar to qmi_wwan/USB.
There the kernel also does not know if the modem supports QMAP or not.
The way it's solved there at the moment is that ModemManager tries to
enable it from user space and then the mode of the network interface
can be switched through a sysfs file ("qmi/pass_through").

Something like this should probably also work in my case. This should
also allow me to ignore QMAP for now and deal with it if someone really
needs it at some point since it's quite complicated for BAM-DMUX.
(I tried QMAP again today and listed the problems in [1] for reference,
 but it's all BAM-DMUX specific...)

[1] https://lore.kernel.org/netdev/YPmF8bzevuabO2K9@gerhold.net/

>
> would it make sense to have two drivers (with common core) to
> manage either the multi-bam channel or newer QMAP based single
> bam-channel modems.
> 

There should be fairly little difference between those two usage modes,
so I don't think it's worth splitting the driver for this. Actually
right now (ignoring the link management of the WWAN subsystem),
it's already possible to use both.

I can use the network interfaces as-is in Raw-IP mode or I do
"sudo ip link add link rmnet0 name rmnet0_qmap type rmnet mux_id 1"
on top and use QMAP. The BAM-DMUX driver does not care, because it
just hands over sent/received packets as-is and the modem data format
must be always configured via QMI from user space.

> >
> > Another problem is that the WWAN subsystem currently creates all network
> > interfaces below the common WWAN device. This means that userspace like
> > ModemManager has no way to check which driver provides them. This is
> > necessary though to decide how to set it up via QMI (ModemManager uses it).
> 
> Well, I have quite a similar concern since I'm currently porting
> mhi-net mbim to wwan framework, and I was thinking about not making
> wwan device parent of the network link/netdev (in the same way as
> wlan0 is not child of ieee80211 device), but not sure if it's a good
> idea or not since we can not really consider driver name part of the
> uapi.
> 

Hm, I think the main disadvantage of that would be that the network
interface is no longer directly related to the WWAN device, right?
Userspace would then need some special matching to find the network
interfaces that belong to a certain control port.

With the current setup, e.g. ModemManager can simply match the WWAN
device and then look at its children and find the control port and
network interfaces. How would it find the network interfaces if they are
no longer below the WWAN device?

> The way links are created is normally abstracted, so if you know which
> bam variant you have from wwan network driver side (e.g. via dts), you
> should have nothing to check on the user side, except the session id.

In a perfect world it would probably be like this, but I'm afraid the
Qualcomm firmware situation isn't as simple. User space needs to know
which setup it is dealing with because all the setup happens via QMI.

Let's take the BAM-DMUX channels vs QMAP mux-IDs for example:

First, user space needs to configure the data format. This happens with
the QMI WDA (Wireless Data Administrative Service) "Set Data Format"
message. Parameter would be link layer format (Raw-IP in both cases)
but also the uplink/downlink data aggregation protocol. This is either
one of many QMAP versions (qmap|qmapv2|qmapv3|qmapv4|qmapv5), or simply
"none" when using BAM-DMUX without QMAP.

Then, the "session ID" (= BAM-DMUX channel or QMAP mux-ID) must be bound
to a WDS (Wireless Data Service) session. The QMI message for that is
different for BAM-DMUX and QMAP:

  - BAM-DMUX: WDS "Bind Data Port"
      (Parameter: SIO port number, can be derived from channel ID)

  - QMAP: WDS "Bind MUX Data Port" (note the "MUX", different message!)
      (Parameter: MUX ID, port type (USB/embedded/...), port number)

My point here: Since userspace is responsible for QMI at the moment
we will definitely need to make it aware of the setup that it needs to
apply. Just having an abstract "session ID" won't be enough to set up
the connection properly. :/

Thanks!
Stephan
