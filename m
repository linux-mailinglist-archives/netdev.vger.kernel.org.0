Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9702529A0
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 10:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgHZI67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 04:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgHZI67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 04:58:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30373C061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 01:58:59 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1kArGj-0008Mr-L7; Wed, 26 Aug 2020 10:58:57 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1kArGj-0003GD-5y; Wed, 26 Aug 2020 10:58:57 +0200
Date:   Wed, 26 Aug 2020 10:58:57 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de
Subject: Re: ethernet-phy-ieee802.3-c22 binding and reset-gpios
Message-ID: <20200826085857.GO13023@pengutronix.de>
References: <20200825090933.GN13023@pengutronix.de>
 <20200825131400.GO2588906@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825131400.GO2588906@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:50:13 up 188 days, 16:20, 148 users,  load average: 0.51, 0.32,
 0.28
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Tue, Aug 25, 2020 at 03:14:00PM +0200, Andrew Lunn wrote:
> On Tue, Aug 25, 2020 at 11:09:33AM +0200, Sascha Hauer wrote:
> > Hi All,
> > 
> > I am using the ethernet phy binding here that looks like:
> > 
> > ethphy1: ethernet-phy@1 {
> > 	compatible = "ethernet-phy-ieee802.3-c22";
> > 	reg = <1>;
> > 	eee-broken-1000t;
> > 	reset-gpios = <&gpio4 2 GPIO_ACTIVE_LOW>;
> > };
> > 
> > It seems the "reset-gpios" is inherently broken in Linux.
> 
> Hi Sascha
> 
> I think it would be better to say, it does not do what people expect,
> rather than broken.
> 
> This code was developed for a PHY which needed to be reset after
> enumeration. That PHY did enumerate, either because it was not held in
> reset, or would still answer ID requests while held in reset.
> 
> It does however not work for PHYs which are held in reset during probe
> and won't enumerate. This is a known issues, but could be better
> documented.

I think the behaviour should rather be improved than documented.

> 
> > Is this the path to go or are there any other ideas how to solve
> > this issue?
> 
> There is two different reset gpios in DT. There is a per PHY reset,
> which you are trying to use. And a per MDIO bus reset, which should
> apply to all PHYs on the bus. This per bus reset works more as
> expected. If this works for you, you could use that.

Well there is only one phy connected to the bus, so it makes no
difference if I say the reset GPIO is for the whole bus or for a single
phy only. The per bus reset should work, but currently it doesn't. First
reason I found out that mdiobus_register() doesn't handle -EPROBE_DEFER
returned by the devm_gpiod_get_optional() properly, patch follows.
Second reason is that the phy is not detected (id read returns 0xffff)
when the reset is attached to the bus. So far I haven't found the reason
for that.

> 
> Otherwise, you need to modify of_mdiobus_register() to look in device
> tree while it is performing the scan and see if there is a reset
> property for each address on the bus. If so, take the device out of
> reset before reading the ID registers.

Ok.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
