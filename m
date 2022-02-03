Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B104A8259
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 11:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238109AbiBCKd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 05:33:56 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55611 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236018AbiBCKd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 05:33:56 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nFZKe-0003rg-Qk; Thu, 03 Feb 2022 11:27:16 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nFZKX-00DAH6-3F; Thu, 03 Feb 2022 11:27:09 +0100
Date:   Thu, 3 Feb 2022 11:27:09 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 0/4] usbnet: add "label" support
Message-ID: <Yfut/RbMAoaIhx41@pengutronix.de>
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
 <YfJ6tZ3hJLbTeaDr@kroah.com>
 <41599e9d-20c0-d1ed-d793-cd7037013718@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <41599e9d-20c0-d1ed-d793-cd7037013718@suse.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:08:31 up 98 days, 16:35, 87 users,  load average: 2.02, 3.35,
 2.95
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 10:34:25AM +0100, Oliver Neukum wrote:
> 
> On 27.01.22 11:57, Greg KH wrote:
> > On Thu, Jan 27, 2022 at 11:49:01AM +0100, Oleksij Rempel wrote:
> >> Add devicetree label property for usbnet devices and related yaml
> >> schema.
> > That says _what_ you are doing, but not _why_ you would want to do such
> > a crazy thing, nor what problem you are attempting to solve here.
> 
> could you at least describe what kind of systems we are talking
> about? Is this for a limited set of embedded devices?
> Are we talking about devices embedded on a motherboard,
> which happen to be connected by USB?

In this particular use case there is a PCB with a imx6 SoC with hard
wired USB attached USB-Ethernet-MAC adapters. One of these adapters is
connected in the same PCB to an Ethernet switch chip. There is a DSA
driver for the switch, so we want to describe the whole boards in a DT.
Putting a label in the DT that renames the network interface is "nice to
have" but not so important.

As the DT DSA bindings rely on linking a MAC phandle to the switch we
need to describe the USB Ethernet adapter in the DT, this is more
important. See this discussion:

https://lore.kernel.org/all/20220127120039.GE9150@pengutronix.de/

> That is, are we talking about another kind of firmware
> we are to take information about devices from?

There is no other firmware involved. The switch chip is attached via
RGMII to the USB/MAC and with SPI to the CPU for the configuration
interface. (I2C to the CPU or MDIO to the USB/MAC would be another
option for the configuration interface.)

> And if so, why are you proposing to solve this on the
> USB driver level?
> It looks to me like those devices are addressed by
> their USB path. But still there is no reason that a USB
> driver should actively interpret firmware stuff that
> comes from a source that tells us nothing about USB
> properties.
> In other words it looks to me like you are trying to put
> a generic facility for getting device properties into
> a specific driver. The question whether device names
> should be read out of firmware is not a USB question.
> 
> I would suggest you implement a generic facility
> in the network layer and if everybody is happy with that
> obviously usbnet can pass through a pointer for that
> to operate on. Frankly, it looks to me like you are
> implementing only a subset of what device tree
> could contain for your specific use case.

Sounds good, but we'll focus on the DSA use case, as this is more
important. So patches 1 and 2 of this patches set have highest prio for
us.

Regards,
Oleksij & Marc
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
