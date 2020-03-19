Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C25318BB8A
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 16:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgCSPtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 11:49:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45358 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727265AbgCSPtk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 11:49:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ngGLP5VsHgOAZj2xsI3iVmJ7Sv6YY6nkD8TS4CSsoqo=; b=q4p06dSfddXyx1GEzsNirbMtmw
        r7psM1gzD6dYBYipdcISLJgnHSZjHZngP7egNM5nXkTSDhaC7Aps13ps8yt0OCihs+9DKXvQ8Ri9Y
        3uXwyfIeBHPJlC3+1xowvnVw5gwByTQ/OUOr/8Un/lzd8HynaU+sLxgbKQy0xzZTWi48=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jExQP-0007Ul-3d; Thu, 19 Mar 2020 16:49:37 +0100
Date:   Thu, 19 Mar 2020 16:49:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH v2 2/2] net: phy: marvell smi2usb mdio controller
Message-ID: <20200319154937.GB27807@lunn.ch>
References: <20200319135952.16258-1-tobias@waldekranz.com>
 <20200319135952.16258-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319135952.16258-2-tobias@waldekranz.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 02:59:52PM +0100, Tobias Waldekranz wrote:
> An MDIO controller present on development boards for Marvell switches
> from the Link Street (88E6xxx) family.
> 
> Using this module, you can use the following setup as a development
> platform for switchdev and DSA related work.
> 
>    .-------.      .-----------------.
>    |      USB----USB                |
>    |  SoC  |      |  88E6390X-DB  ETH1-10
>    |      ETH----ETH0               |
>    '-------'      '-----------------'
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
> 
> v1->v2:
> - Reverse christmas tree ordering of local variables.
> 
> ---
>  MAINTAINERS                    |   1 +
>  drivers/net/phy/Kconfig        |   7 ++
>  drivers/net/phy/Makefile       |   1 +
>  drivers/net/phy/mdio-smi2usb.c | 137 +++++++++++++++++++++++++++++++++
>  4 files changed, 146 insertions(+)
>  create mode 100644 drivers/net/phy/mdio-smi2usb.c

Hi Tobias

Where does the name mii2usb come from? To me, it seems to be the wrong
way around, it is USB to MII. I suppose the Marvell Switch team could
of given it this name, for them the switch is the centre of their
world, and things connect to it?

I'm just wondering if we should actually ignore Marvell and call it
usb2mii?

I also think there should be a marvell prefix in the name, since were
could be other implementations of USB/MII. mvusb2mii?

Do you know how this is implemented? Is it a product you can purchase?
Or a microcontroller on the board which implements this? It would be
an interesting product, especially on x86 machines which generally end
up doing bit-banging because of the lack of drivers using kernel MDIO.

> +static int smi2usb_probe(struct usb_interface *interface,
> +			 const struct usb_device_id *id)
> +{
> +	struct device *dev = &interface->dev;
> +	struct mii_bus *mdio;
> +	struct smi2usb *smi;
> +	int err = -ENOMEM;
> +
> +	mdio = devm_mdiobus_alloc_size(dev, sizeof(*smi));
> +	if (!mdio)
> +		goto err;
> +

...


> +static void smi2usb_disconnect(struct usb_interface *interface)
> +{
> +	struct smi2usb *smi;
> +
> +	smi = usb_get_intfdata(interface);
> +	mdiobus_unregister(smi->mdio);
> +	usb_set_intfdata(interface, NULL);
> +
> +	usb_put_intf(interface);
> +	usb_put_dev(interface_to_usbdev(interface));
> +}

I don't know enough about USB. Does disconnect have the same semantics
remove()? You used devm_mdiobus_alloc_size() to allocate the bus
structure. Will it get freed after disconnect? I've had USB devices
connected via flaky USB hubs and they have repeatedly disappeared and
reappeared. I wonder if in that case you are leaking memory if
disconnect does not release the memory?

> +	usb_put_intf(interface);
> +	usb_put_dev(interface_to_usbdev(interface));
> +}

Another USB novice question. Is this safe? Could the put of interface
cause it to be destroyed? Then interface_to_usbdev() is called on
invalid memory?

Maybe this should be cross posted to a USB mailing list, so we can get
the USB aspects reviewed. The MDIO bits seem good to me.

	   Andrew
