Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB43849E0E9
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240337AbiA0LaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:30:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35266 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiA0LaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:30:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69B956181D;
        Thu, 27 Jan 2022 11:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FF6C340E4;
        Thu, 27 Jan 2022 11:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643283022;
        bh=nuVIdVfY68a6mnwbLdAZuHokHgEveE8vKcaTX6XBEGw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q1dqbeynuM669sRodIlHVeHhf9+T2UDVfXQKK5PueOJd3P1hJvpy9m5/GkV8/dCcr
         vsDnZGrQp1isq6/AMI9doqL5AtyWRweSycxOMBGj/74Wh4ZcPcZRY/dEGSFrAOle8Q
         dqwJynsIhwNNC/FvOsMr9P/gjAuCLNCU5+Adb0zc=
Date:   Thu, 27 Jan 2022 12:30:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 4/4] usbnet: add support for label from
 device tree
Message-ID: <YfKCTG7N86yy74q+@kroah.com>
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
 <20220127104905.899341-5-o.rempel@pengutronix.de>
 <YfJ6lhZMAEmetdad@kroah.com>
 <20220127112305.GC9150@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127112305.GC9150@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 12:23:05PM +0100, Oleksij Rempel wrote:
> On Thu, Jan 27, 2022 at 11:57:26AM +0100, Greg KH wrote:
> > On Thu, Jan 27, 2022 at 11:49:05AM +0100, Oleksij Rempel wrote:
> > > Similar to the option to set a netdev name in device tree for switch
> > > ports by using the property "label" in the DSA framework, this patch
> > > adds this functionality to the usbnet infrastructure.
> > > 
> > > This will help to name the interfaces properly throughout supported
> > > devices. This provides stable interface names which are useful
> > > especially in embedded use cases.
> > 
> > Stable interface names are for userspace to set, not the kernel.
> > 
> > Why would USB care about this?  If you need something like this, get it
> > from the USB device itself, not DT, which should have nothing to do with
> > USB as USB is a dynamic, self-describing, bus.  Unlike DT.
> > 
> > So I do not think this is a good idea.
> 
> This is needed for embedded devices with integrated USB Ethernet
> controller. Currently I have following use cases to solve:
> - Board with one or multiple USB Ethernet controllers with external PHY.
>   The PHY need devicetree to describe IRQ, clock sources, label on board, etc.

The phy is for the USB controller, not the Ethernet controller, right?
If for the ethernet controller, ugh, that's a crazy design and I would
argue a broken one.  But whatever, DT should not be used to describe a
USB device itself.

> - Board with USB Ethernet controller with DSA switch. The USB ethernet
>   controller is attached to the CPU port of DSA switch. In this case,
>   DSA switch is the sub-node of the USB device.

What do you mean exactly by "sub node"?  USB does not have such a term.

>  The CPU port should have
>   stable name for all device related to this product.

name for who to use?  Userspace?  Or within the kernel?

Naming is done by userspace, as USB is NOT determinisitic in numbering /
naming the devices attached to it, by design.  If you need to have a
stable name, do so in userspace please, we have loads of tools that
already do this there today.  Let's not reinvent the wheel.

> Using user space tools to name interfaces would double the maintenance
> of similar information: DT - describing the HW + udev scripts describing
> same HW again.

Not for the network name of the device, that belongs in userspace.

Do not be listing USB device ids in a DT file, that way lies madness.

thanks,

greg k-h
