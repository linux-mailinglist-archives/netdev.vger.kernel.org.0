Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E562310D8
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 19:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731998AbgG1R1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 13:27:18 -0400
Received: from mail.nic.cz ([217.31.204.67]:58738 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731684AbgG1R1R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 13:27:17 -0400
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 7519613FCD1;
        Tue, 28 Jul 2020 19:27:14 +0200 (CEST)
Date:   Tue, 28 Jul 2020 19:27:13 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, jacek.anaszewski@gmail.com,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?B?T25kxZllag==?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v4 1/2] net: phy: add API for LEDs
 controlled by PHY HW
Message-ID: <20200728192713.01153e43@nic.cz>
In-Reply-To: <20200728162816.GK1705504@lunn.ch>
References: <20200728150530.28827-1-marek.behun@nic.cz>
        <20200728150530.28827-2-marek.behun@nic.cz>
        <20200728171128.61c7193b@dellmb.labs.office.nic.cz>
        <20200728162816.GK1705504@lunn.ch>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,URIBL_BLOCKED,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 18:28:16 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > > @@ -736,6 +777,16 @@ struct phy_driver {
> > >  	int (*set_loopback)(struct phy_device *dev, bool enable);
> > >  	int (*get_sqi)(struct phy_device *dev);
> > >  	int (*get_sqi_max)(struct phy_device *dev);
> > > +
> > > +	/* PHY LED support */
> > > +	int (*led_init)(struct phy_device *dev, struct
> > > phy_device_led *led);
> > > +	int (*led_brightness_set)(struct phy_device *dev, struct
> > > phy_device_led *led,
> > > +				  enum led_brightness brightness);
> > > +	const char *(*led_iter_hw_mode)(struct phy_device *dev,
> > > struct phy_device_led *led,
> > > +					void **	iter);
> > > +	int (*led_set_hw_mode)(struct phy_device *dev, struct
> > > phy_device_led *led,
> > > +			       const char *mode);
> > > +	const char *(*led_get_hw_mode)(struct phy_device *dev,
> > > struct phy_device_led *led); };
> > >  #define to_phy_driver(d)
> > > container_of(to_mdio_common_driver(d),		\ struct
> > > phy_driver, mdiodrv)  
> > 
> > The problem here is that the same code will have to be added to DSA
> > switch ops structure, which is not OK.  
> 
> Not necessarily. DSA drivers do have access to the phydev structure.
> 
> I think putting these members into a structure is a good idea. That
> structure can be part of phy_driver and initialised just like other
> members. But on probing the phy, it can be copied over to the
> phy_device structure. And we can provide an API which DSA drivers can
> use to register there own structure of ops to be placed into
> phy_device, which would call into the DSA driver.
> 
>       Andrew

On Marvell switches there are LEDs that do not necesarrily blink on
events on a specific port, but instead on the whole switch. Ie a LED
can be put into a mode "act on any port". Vendors may create devices
with this as intender mode for a LED, and such a LED may be on the
other side of the device from where the ports are, or something. Such a
LED should be described in the device tree not as a child of any PHY or
port, but instead as a child of the switch itself. And since all the
LEDs on Marvell switches are technically controlled by the switch, not
it's internal PHYs, I think all of them should be children of the
switch node (or a "leds" node which is a child of the switch node),
instead of being descended from the internal PHYs.

Marek
