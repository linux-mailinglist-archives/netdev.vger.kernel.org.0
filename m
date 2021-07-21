Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB64C3D0EB5
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 14:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236960AbhGULgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 07:36:48 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:15463 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbhGULgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 07:36:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626869837;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=4CcqRIyqsFHa+Wrw0Xd8JK00I+Bxru7P9shO2wlwNwU=;
    b=dGicpEYuymH5XiHV1X2jtV6vho0U2eObya9dVNRiN3pM/HV7FpgxOSa5u543RpQDMh
    hGyTM8ZdlvCiR3veJMxQEyjlZz1XPnXx7H+MikPjsuoSxX+gnH1dGPOf93LixychWWTW
    ApdUqIJHJJ6CReda6RR+SgboBJX6ctHa3KotJ6JVtf12AcPy+LnVq1k1Zt8PrXOm4hdS
    n3UupM8cgyapWQyEzMI3hKsJJ2Eu/HoNd+1AVE+Yrs01SohlCCM/veva6y5H2/h/szC0
    4MsLnlzVre/kSFtBOxMZ6tCUCfs6NP8Rb0xYESNo7p1K4FCgOEuUd8KFltsRvNH6uuEf
    Gy1A==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u261EJF5OxJD4peA9Z7h"
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.28.1 DYNA|AUTH)
    with ESMTPSA id g02a44x6LCHFHg9
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 21 Jul 2021 14:17:15 +0200 (CEST)
Date:   Wed, 21 Jul 2021 14:17:11 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Subject: Re: [RFC PATCH net-next 4/4] net: wwan: Add Qualcomm BAM-DMUX WWAN
 network driver
Message-ID: <YPgQR/VbNVyxERnb@gerhold.net>
References: <20210719145317.79692-1-stephan@gerhold.net>
 <20210719145317.79692-5-stephan@gerhold.net>
 <CAHNKnsTVSg5T_ZK3PQ50wuJydHbANFfpJd5NZ-71b1m3B_4dQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHNKnsTVSg5T_ZK3PQ50wuJydHbANFfpJd5NZ-71b1m3B_4dQg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

On Tue, Jul 20, 2021 at 12:10:42PM +0300, Sergey Ryazanov wrote:
> On Mon, Jul 19, 2021 at 6:01 PM Stephan Gerhold <stephan@gerhold.net> wrote:
> > The BAM Data Multiplexer provides access to the network data channels of
> > modems integrated into many older Qualcomm SoCs, e.g. Qualcomm MSM8916 or
> > MSM8974. It is built using a simple protocol layer on top of a DMA engine
> > (Qualcomm BAM) and bidirectional interrupts to coordinate power control.
> >
> > The modem announces a fixed set of channels by sending an OPEN command.
> > The driver exports each channel as separate network interface so that
> > a connection can be established via QMI from userspace. The network
> > interface can work either in Ethernet or Raw-IP mode (configurable via
> > QMI). However, Ethernet mode seems to be broken with most firmwares
> > (network packets are actually received as Raw-IP), therefore the driver
> > only supports Raw-IP mode.
> >
> > The driver uses runtime PM to coordinate power control with the modem.
> > TX/RX buffers are put in a kind of "ring queue" and submitted via
> > the bam_dma driver of the DMAEngine subsystem.
> >
> > The basic architecture looks roughly like this:
> >
> >                    +------------+                +-------+
> >          [IPv4/6]  |  BAM-DMUX  |                |       |
> >          [Data...] |            |                |       |
> >         ---------->|rmnet0      | [DMUX chan: x] |       |
> >          [IPv4/6]  | (chan: 0)  | [IPv4/6]       |       |
> >          [Data...] |            | [Data...]      |       |
> >         ---------->|rmnet1      |--------------->| Modem |
> >                    | (chan: 1)  |      BAM       |       |
> >          [IPv4/6]  | ...        |  (DMA Engine)  |       |
> >          [Data...] |            |                |       |
> >         ---------->|rmnet7      |                |       |
> >                    | (chan: 7)  |                |       |
> >                    +------------+                +-------+
> >
> > However, on newer SoCs/firmware versions Qualcomm began gradually moving
> > to QMAP (rmnet driver) as backend-independent protocol for multiplexing
> > and data aggegration. Some firmware versions allow using QMAP on top of
> > BAM-DMUX (effectively resulting in a second multiplexing layer plus data
> > aggregation). The architecture with QMAP would look roughly like this:
> >
> >            +-------------+           +------------+                  +-------+
> >  [IPv4/6]  |    RMNET    |           |  BAM-DMUX  |                  |       |
> >  [Data...] |             |           |            | [DMUX chan: 0]   |       |
> > ---------->|rmnet_data1  |     ----->|rmnet0      | [QMAP mux-id: x] |       |
> >            | (mux-id: 1) |     |     | (chan: 0)  | [IPv4/6]         |       |
> >            |             |     |     |            | [Data...]        |       |
> >  [IPv4/6]  | ...         |------     |            |----------------->| Modem |
> >  [Data...] |             |           |            |       BAM        |       |
> > ---------->|rmnet_data42 | [QMAP: x] |[rmnet1]    |   (DMA Engine)   |       |
> >            | (mux-id: 42)| [IPv4/6]  |... unused! |                  |       |
> >            |             | [Data...] |[rmnet7]    |                  |       |
> >            |             |           |            |                  |       |
> >            +-------------+           +------------+                  +-------+
> >
> > In this case, rmnet1-7 would remain unused. The firmware used on the most
> > recent SoCs with BAM-DMUX even seems to announce only a single BAM-DMUX
> > channel (rmnet0), which makes QMAP the only option for multiplexing there.
> >
> > So far the driver is mainly tested on various smartphones/tablets based on
> > Qualcomm MSM8916/MSM8974 without QMAP. It looks like QMAP depends on a MTU
> > negotiation feature in BAM-DMUX which is not yet supported by the driver.
> >
> > Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
> > ---
> > Note that this is my first network driver, so I apologize in advance
> > if I made some obvious mistakes. :)
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
> 
> I am not very familiar with the Qualcomm protocols and am just curious
> whether BAM-DMUX has any control (management) channels or only IPv4/v6
> data channels?
> 
> The WWAN subsystem began as a framework for exporting management
> interfaces (MBIM, AT, etc.) to user space. And then the network
> interfaces (data channels) management interface was added to
> facilitate management of devices with multiple data channels. That is
> why I am curious about the BAM-DMUX device management interface or in
> other words, how a user space application could control the modem
> work?
> 

Sorry for the confusion! It's briefly mentioned in the Kconfig option
but I should have made this more clear in the commit message. It was so
long already that I wasn't sure where to put it. :)

BAM-DMUX does not have any control channels. Instead I use it together
with the rpmsg_wwan_ctrl driver [1] that I already submitted for 5.14.
The control/data channels are pretty much separate in this setup and
don't have much to do with each other.

I also had a short overview of some of the many different modem
protocols Qualcomm has come up with in a related RFC for that driver,
see [2] if you are curious.

I hope that clarifies some things, please let me know if I should
explain something better! :)

Thanks!
Stephan

[1]: https://lore.kernel.org/netdev/20210618173611.134685-3-stephan@gerhold.net/
[2]: https://lore.kernel.org/netdev/YLfL9Q+4860uqS8f@gerhold.net/
