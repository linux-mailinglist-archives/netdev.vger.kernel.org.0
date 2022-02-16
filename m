Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C684B906A
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 19:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237709AbiBPSkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 13:40:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237700AbiBPSkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 13:40:08 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CBC2ABD0C
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 10:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GZr/frDJc1d9rHxqpPe5bieNM3guiX4t5cG5d3s2P4U=; b=0zOnpA0BRZHcm78NsRMR+dL1AF
        8MH51SLprKbTubxDdTGUu3L8KWEmp3DOaPkwfQcMHd9QaHSk4evEohlF9K3Y+MQh9eWg8p3Uppdmj
        6VwO07dGEZIrwWFDBrVa0oGlcM/Takgc9Yaj69w/EHc59ZFVS9eRrV6ukR1aS1Jj8QKY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nKPDR-006FWh-9H; Wed, 16 Feb 2022 19:39:49 +0100
Date:   Wed, 16 Feb 2022 19:39:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Moltmann, Tobias" <Tobias.Moltmann@siemens.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: DSA and Marvell Switch Drivers
Message-ID: <Yg1E9dxdzZDrqmtN@lunn.ch>
References: <PA4PR10MB46060AD14E4D15C2F50CA3AAE5359@PA4PR10MB4606.EURPRD10.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PA4PR10MB46060AD14E4D15C2F50CA3AAE5359@PA4PR10MB4606.EURPRD10.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 08:55:17AM +0000, Moltmann, Tobias wrote:
> Hello,
> 
> I would first rewrite my questions and provide some information's and add some of Andrews answer to it as well.
> As I learned it would be helpful to address the "netdev list" to get (hopefully) even more help. 
> So please feel free to provide some feedback, thank you!
> 
> The issue we face comes along with an Kernel upgrade from 4.4.xxx to now 5.10.xx. It is all industrial-based hardware, so 
> no classical PC or something. On the hardware we have an x86 CPU, an IGB -> Marvell Switch (Marvell 88E6176) ->
> and two PHY's connected there.
> 
> Very roughly the way it worked/run with the 4.4 Kernel:
> 
> - mv88e6xxx_init() called - registered the driver
> - IGB driver loaded, started probing
> - within the probing we set up an MDIO bus (name: igb MDIO, id: 0000:01:00.0_mii)

So you have some out of tree patches for this? As far as i remember,
IGB does not make use of the MDIO framework.

> - the libphy does a first scan with no result due to some other missing stuff - at this point it is ok
> - also within the igb probing we set up an dsa_platform_data struct and run a platform_device_register()
> - this triggers the DSA driver
> - mv88e6352_probe() is called our Marvell switch is detected
> - a new DSA slave MDIO bus is been brought up automatically
> - mdiobus_scan() there register our two PHY devices 
> - everything is working :)

You can find a full example here, for a slights out of date kernel,

https://github.com/lunn/linux/blob/v5.15.5-zii-rap/drivers/platform/x86/zii-rap.c

This board also uses the igb, since the Ethernet is an i210. However,
it does not hack the driver to export the MDIO bus, it makes use of a
couple of GPIOs, and the bit banging MDIO bus driver. But that should
not make too big a difference.

The basic flow is, that once this platform driver loads, it calls
zii_rap_marvell_switch(). That tries to get the 'eth0' device. There
are some not so nice assumptions here, that this platform driver loads
after the igb.

It then adds a GPIO lookup table so you can find the GPIO being used
for the switch interrupt. The IRQ GPIO is then got, and converted into
an interrupt number. The switch actually uses level interrupts, but on
this platform only edge interrupts are supported. So we setup falling
edge and hope for the best.

The IRQ number is then added to the switch platform data.

The switch platform data is then registered to the MDIO core, via
bdinfo, against a bus name we know the MDIO bus will be given,
"gpio-0".

The bit banging MDIO bus is then setup and added.

When the MDIO bus is registered with the MDIO core, it will look at
the name, find the bdinfo structure uses the same name, and use that
to instantiate a device on the MDIO bus. That device will cause the
mv88e6xxx driver to probe, and setup a switch on the bus.

You should be able to follow the same basic scheme. Just don't add the
big banging MDIO bus, use the name you know your hacked igb driver
will use when it registers its MDIO bus. This board uses a 6390, which
needs a different compatible string to what you need. You need
"marvell,mv88e6085" for your switch.

	  Andrew
