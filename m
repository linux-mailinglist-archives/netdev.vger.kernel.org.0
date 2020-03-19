Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3FF18C36B
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 00:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbgCSXAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 19:00:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46192 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727442AbgCSXAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 19:00:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nJ3RQq5k4oQrLoKYkTfeXSLHosWOJBMgbqxYfwIzYec=; b=TpZCIGDxBIMC2xx9b7D7m9Iqhx
        VXWESjDV5RcelMAVkmrtiuT5N/aCNquXDvvwpPbV/Jmb3RSH3TEqmBHT4arPw7YYG72Gn/AaYrSRf
        saoIwjHabga0ORaJ5fA+wJZyaY+h4Ibyp3fvcGLZ62xdik0de1Yj7uI0eQI1RvXB8GxA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jF48w-0001gT-G2; Fri, 20 Mar 2020 00:00:02 +0100
Date:   Fri, 20 Mar 2020 00:00:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH v2 2/2] net: phy: marvell smi2usb mdio controller
Message-ID: <20200319230002.GO27807@lunn.ch>
References: <20200319135952.16258-1-tobias@waldekranz.com>
 <20200319135952.16258-2-tobias@waldekranz.com>
 <20200319154937.GB27807@lunn.ch>
 <20200319223544.GA14699@wkz-x280>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319223544.GA14699@wkz-x280>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias

> How about just mdio-mvusb?

Yes, i like that.

> On the 88E6390X-DB, I know that there is a chip by the USB port that
> is probably either an MCU or a small FPGA. I can have a closer look at
> it when I'm at the office tomorrow if you'd like. I also remember
> seeing some docs from Marvell which seemed to indicate that they have
> a standalone product providing only the USB-to-MDIO functionality.

I would be interested in knowing more.

> The x86 use-case is interesting. It would be even more so if there was
> some way of loading a DSA DT fragment so that you could hook it up to
> your machine's Ethernet port.

We don't have that at the moment. But so long as you only need
internal copper PHYs, it is possible to use a platform device and it
all just works.

> > > +static int smi2usb_probe(struct usb_interface *interface,
> > > +			 const struct usb_device_id *id)
> > > +{
> > > +	struct device *dev = &interface->dev;
> > > +	struct mii_bus *mdio;
> > > +	struct smi2usb *smi;
> > > +	int err = -ENOMEM;
> > > +
> > > +	mdio = devm_mdiobus_alloc_size(dev, sizeof(*smi));
> > > +	if (!mdio)
> > > +		goto err;
> > > +
> > 
> > ...
> > 
> > 
> > > +static void smi2usb_disconnect(struct usb_interface *interface)
> > > +{
> > > +	struct smi2usb *smi;
> > > +
> > > +	smi = usb_get_intfdata(interface);
> > > +	mdiobus_unregister(smi->mdio);
> > > +	usb_set_intfdata(interface, NULL);
> > > +
> > > +	usb_put_intf(interface);
> > > +	usb_put_dev(interface_to_usbdev(interface));
> > > +}
> > 
> > I don't know enough about USB. Does disconnect have the same semantics
> > remove()? You used devm_mdiobus_alloc_size() to allocate the bus
> > structure. Will it get freed after disconnect? I've had USB devices
> > connected via flaky USB hubs and they have repeatedly disappeared and
> > reappeared. I wonder if in that case you are leaking memory if
> > disconnect does not release the memory?
> 
> Disclaimer: This is my first ever USB driver.

And i've only ever written one which has been merged.

> I assumed that since we're removing 'interface', 'interface->dev' will
> be removed as well and thus calling all devm hooks.
> 
> > > +	usb_put_intf(interface);
> > > +	usb_put_dev(interface_to_usbdev(interface));
> > > +}
> > 
> > Another USB novice question. Is this safe? Could the put of interface
> > cause it to be destroyed? Then interface_to_usbdev() is called on
> > invalid memory?
> 
> That does indeed look scary. I inverted the order of the calls to the
> _get_ functions, which I got from the USB skeleton driver. I'll try to
> review some other drivers to see if I can figure this out.
> 
> > Maybe this should be cross posted to a USB mailing list, so we can get
> > the USB aspects reviewed. The MDIO bits seem good to me.
> 
> Good idea. Any chance you can help an LKML rookie out? How does one go
> about that? Do I simply reply to this thread and add the USB list, or
> do I post the patches again as a new series? Any special tags? Is
> there any documentation available?

I would fixup the naming and repost. You can put whatever comments you
want under the --- marker. So say this driver should be merged via
netdev, but you would appreciate reviews of the USB parts from USB
maintainers. linux-usb@vger.kernel.org would be the correct list to
add.

     Andrew
