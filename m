Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B12822D950
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 20:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgGYSXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 14:23:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55430 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726727AbgGYSXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 14:23:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jzOpb-006pw9-R7; Sat, 25 Jul 2020 20:23:35 +0200
Date:   Sat, 25 Jul 2020 20:23:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, jacek.anaszewski@gmail.com,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v3 2/2] net: phy: marvell: add
 support for PHY LEDs via LED class
Message-ID: <20200725182335.GN1472201@lunn.ch>
References: <20200724164603.29148-1-marek.behun@nic.cz>
 <20200724164603.29148-3-marek.behun@nic.cz>
 <20200725172318.GK1472201@lunn.ch>
 <20200725200224.3f03c041@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200725200224.3f03c041@nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 25, 2020 at 08:02:24PM +0200, Marek Behun wrote:
> On Sat, 25 Jul 2020 19:23:18 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > On Fri, Jul 24, 2020 at 06:46:03PM +0200, Marek Behún wrote:
> > > This patch adds support for controlling the LEDs connected to several
> > > families of Marvell PHYs via the PHY HW LED trigger API. These families
> > > are: 88E1112, 88E1121R, 88E1240, 88E1340S, 88E1510 and 88E1545. More can
> > > be added.
> > > 
> > > The code reads LEDs definitions from the device-tree node of the PHY.
> > > 
> > > This patch does not yet add support for compound LED modes. This could
> > > be achieved via the LED multicolor framework (which is not yet in
> > > upstream).
> > > 
> > > Settings such as HW blink rate or pulse stretch duration are not yet
> > > supported, nor are LED polarity settings.
> > > 
> > > Signed-off-by: Marek Behún <marek.behun@nic.cz>
> > > ---
> > >  drivers/net/phy/Kconfig   |   1 +
> > >  drivers/net/phy/marvell.c | 364 ++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 365 insertions(+)
> > > 
> > > diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> > > index ffea11f73acd..5428a8af26d2 100644
> > > --- a/drivers/net/phy/Kconfig
> > > +++ b/drivers/net/phy/Kconfig
> > > @@ -462,6 +462,7 @@ config LXT_PHY
> > >  
> > >  config MARVELL_PHY
> > >  	tristate "Marvell PHYs"
> > > +	depends on LED_TRIGGER_PHY_HW  
> > 
> > Does it really depend on it? I think the driver will work fine without
> > it, just the LED control will be missing.
> > 
> > It is really a policy question. Cable test is always available, there
> > is no Kconfig'ury to stop it getting built. Is LED support really big
> > so that somebody might want to disable it? I think not. So lets just
> > enable it all the time.
> 
> OK
> 
> > >  	help
> > >  	  Currently has a driver for the 88E1011S
> > >    
> > 
> > > +enum {
> > > +	L1V0_RECV		= BIT(0),
> > > +	L1V0_COPPER		= BIT(1),
> > > +	L1V5_100_FIBER		= BIT(2),
> > > +	L1V5_100_10		= BIT(3),
> > > +	L2V2_INIT		= BIT(4),
> > > +	L2V2_PTP		= BIT(5),
> > > +	L2V2_DUPLEX		= BIT(6),
> > > +	L3V0_FIBER		= BIT(7),
> > > +	L3V0_LOS		= BIT(8),
> > > +	L3V5_TRANS		= BIT(9),
> > > +	L3V7_FIBER		= BIT(10),
> > > +	L3V7_DUPLEX		= BIT(11),  

        COMMON			= BIT(32),

> > > +static const struct marvell_led_mode_info marvell_led_mode_info[] = {
> > > +	{ "link/act",			{ 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, }, COMMON },
> > > +	{ "1Gbps/100Mbps/10Mbps",	{ 0x2,  -1,  -1,  -1,  -1,  -1, }, COMMON },
> > > +	{ "act",			{ 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, }, COMMON },
> > > +	{ "blink-act",			{ 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, }, COMMON },
> > > +	{ "tx",				{ 0x5,  -1, 0x5,  -1, 0x5, 0x5, }, COMMON },
> > > +	{ "tx",				{  -1,  -1,  -1, 0x5,  -1,  -1, }, L3V5_TRANS },
> > > +	{ "rx",				{  -1,  -1,  -1,  -1, 0x0, 0x0, }, COMMON },
> > > +	{ "rx",				{  -1, 0x0,  -1,  -1,  -1,  -1, }, L1V0_RECV },
> > > +	{ "copper",			{ 0x6,  -1,  -1,  -1,  -1,  -1, }, COMMON },
> > > +	{ "copper",			{  -1, 0x0,  -1,  -1,  -1,  -1, }, L1V0_COPPER },
> > > +	{ "1Gbps",			{ 0x7,  -1,  -1,  -1,  -1,  -1, }, COMMON },
> > > +	{ "link/rx",			{  -1, 0x2,  -1, 0x2, 0x2, 0x2, }, COMMON },
> > > +	{ "100Mbps-fiber",		{  -1, 0x5,  -1,  -1,  -1,  -1, }, L1V5_100_FIBER },
> > > +	{ "100Mbps-10Mbps",		{  -1, 0x5,  -1,  -1,  -1,  -1, }, L1V5_100_10 },
> > > +	{ "1Gbps-100Mbps",		{  -1, 0x6,  -1,  -1,  -1,  -1, }, COMMON },
> > > +	{ "1Gbps-10Mbps",		{  -1,  -1, 0x6, 0x6,  -1,  -1, }, COMMON },
> > > +	{ "100Mbps",			{  -1, 0x7,  -1,  -1,  -1,  -1, }, COMMON },
> > > +	{ "10Mbps",			{  -1,  -1, 0x7,  -1,  -1,  -1, }, COMMON },
> > > +	{ "fiber",			{  -1,  -1,  -1, 0x0,  -1,  -1, }, L3V0_FIBER },
> > > +	{ "fiber",			{  -1,  -1,  -1, 0x7,  -1,  -1, }, L3V7_FIBER },
> > > +	{ "FullDuplex",			{  -1,  -1,  -1, 0x7,  -1,  -1, }, L3V7_DUPLEX },
> > > +	{ "FullDuplex",			{  -1,  -1,  -1,  -1, 0x6, 0x6, }, COMMON },
> > > +	{ "FullDuplex/collision",	{  -1,  -1,  -1,  -1, 0x7, 0x7, }, COMMON },
> > > +	{ "FullDuplex/collision",	{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_DUPLEX },
> > > +	{ "ptp",			{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_PTP },
> > > +	{ "init",			{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_INIT },
> > > +	{ "los",			{  -1,  -1,  -1, 0x0,  -1,  -1, }, L3V0_LOS },
> > > +	{ "hi-z",			{ 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, }, COMMON },
> > > +	{ "blink",			{ 0xb, 0xb, 0xb, 0xb, 0xb, 0xb, }, COMMON },
> > > +};
> > > +

> > > +static const struct marvell_leds_info marvell_leds_info[] = {
> > > +	LED(1112,  4, COMMON | L1V0_COPPER | L1V5_100_FIBER | L2V2_INIT | L3V0_LOS | L3V5_TRANS | L3V7_FIBER),
> > > +	LED(1121R, 3, COMMON | L1V5_100_10),
> > > +	LED(1240,  6, COMMON | L3V5_TRANS),
> > > +	LED(1340S, 6, COMMON | L1V0_COPPER | L1V5_100_FIBER | L2V2_PTP | L3V0_FIBER | L3V7_DUPLEX),
> > > +	LED(1510,  3, COMMON | L1V0_RECV | L1V5_100_FIBER | L2V2_DUPLEX),
> > > +	LED(1545,  6, COMMON | L1V5_100_FIBER | L3V0_FIBER | L3V7_DUPLEX),
> > > +};
> > > +

> > > +{
> > > +	return mode->regval[led->idx] != -1 && (!mode->flags || (priv->led_flags & mode->flags));  

This then becomes

return mode->regval[led->idx] != -1 && (priv->led_flags & mode->flags));  

       Andrew
