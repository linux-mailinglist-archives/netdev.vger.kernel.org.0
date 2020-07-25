Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1E222D8E8
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 19:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgGYRXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 13:23:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55350 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726904AbgGYRXd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 13:23:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jzNtG-006pYV-U0; Sat, 25 Jul 2020 19:23:18 +0200
Date:   Sat, 25 Jul 2020 19:23:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
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
Message-ID: <20200725172318.GK1472201@lunn.ch>
References: <20200724164603.29148-1-marek.behun@nic.cz>
 <20200724164603.29148-3-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200724164603.29148-3-marek.behun@nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 06:46:03PM +0200, Marek Behún wrote:
> This patch adds support for controlling the LEDs connected to several
> families of Marvell PHYs via the PHY HW LED trigger API. These families
> are: 88E1112, 88E1121R, 88E1240, 88E1340S, 88E1510 and 88E1545. More can
> be added.
> 
> The code reads LEDs definitions from the device-tree node of the PHY.
> 
> This patch does not yet add support for compound LED modes. This could
> be achieved via the LED multicolor framework (which is not yet in
> upstream).
> 
> Settings such as HW blink rate or pulse stretch duration are not yet
> supported, nor are LED polarity settings.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>
> ---
>  drivers/net/phy/Kconfig   |   1 +
>  drivers/net/phy/marvell.c | 364 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 365 insertions(+)
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index ffea11f73acd..5428a8af26d2 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -462,6 +462,7 @@ config LXT_PHY
>  
>  config MARVELL_PHY
>  	tristate "Marvell PHYs"
> +	depends on LED_TRIGGER_PHY_HW

Does it really depend on it? I think the driver will work fine without
it, just the LED control will be missing.

It is really a policy question. Cable test is always available, there
is no Kconfig'ury to stop it getting built. Is LED support really big
so that somebody might want to disable it? I think not. So lets just
enable it all the time.

>  	help
>  	  Currently has a driver for the 88E1011S
>  

> +enum {
> +	L1V0_RECV		= BIT(0),
> +	L1V0_COPPER		= BIT(1),
> +	L1V5_100_FIBER		= BIT(2),
> +	L1V5_100_10		= BIT(3),
> +	L2V2_INIT		= BIT(4),
> +	L2V2_PTP		= BIT(5),
> +	L2V2_DUPLEX		= BIT(6),
> +	L3V0_FIBER		= BIT(7),
> +	L3V0_LOS		= BIT(8),
> +	L3V5_TRANS		= BIT(9),
> +	L3V7_FIBER		= BIT(10),
> +	L3V7_DUPLEX		= BIT(11),

Maybe also add COMMON?

> +};
> +
> +struct marvell_led_mode_info {
> +	const char *name;
> +	s8 regval[MARVELL_PHY_MAX_LEDS];
> +	u32 flags;

Maybe give the enum a name, and use it here? It can be quite hard
tracking the meaning of flags in this code. Here, it is an indication
of an individual feature.

> +};
> +
> +static const struct marvell_led_mode_info marvell_led_mode_info[] = {
> +	{ "link",			{ 0x0,  -1, 0x0,  -1,  -1,  -1, }, 0 },

Replace flags 0 with COMMON?

> +	{ "link/act",			{ 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, }, 0 },
> +	{ "1Gbps/100Mbps/10Mbps",	{ 0x2,  -1,  -1,  -1,  -1,  -1, }, 0 },
> +	{ "act",			{ 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, }, 0 },
> +	{ "blink-act",			{ 0x4, 0x4, 0x4, 0x4, 0x4, 0x4, }, 0 },
> +	{ "tx",				{ 0x5,  -1, 0x5,  -1, 0x5, 0x5, }, 0 },
> +	{ "tx",				{  -1,  -1,  -1, 0x5,  -1,  -1, }, L3V5_TRANS },
> +	{ "rx",				{  -1,  -1,  -1,  -1, 0x0, 0x0, }, 0 },
> +	{ "rx",				{  -1, 0x0,  -1,  -1,  -1,  -1, }, L1V0_RECV },
> +	{ "copper",			{ 0x6,  -1,  -1,  -1,  -1,  -1, }, 0 },
> +	{ "copper",			{  -1, 0x0,  -1,  -1,  -1,  -1, }, L1V0_COPPER },
> +	{ "1Gbps",			{ 0x7,  -1,  -1,  -1,  -1,  -1, }, 0 },
> +	{ "link/rx",			{  -1, 0x2,  -1, 0x2, 0x2, 0x2, }, 0 },
> +	{ "100Mbps-fiber",		{  -1, 0x5,  -1,  -1,  -1,  -1, }, L1V5_100_FIBER },
> +	{ "100Mbps-10Mbps",		{  -1, 0x5,  -1,  -1,  -1,  -1, }, L1V5_100_10 },
> +	{ "1Gbps-100Mbps",		{  -1, 0x6,  -1,  -1,  -1,  -1, }, 0 },
> +	{ "1Gbps-10Mbps",		{  -1,  -1, 0x6, 0x6,  -1,  -1, }, 0 },
> +	{ "100Mbps",			{  -1, 0x7,  -1,  -1,  -1,  -1, }, 0 },
> +	{ "10Mbps",			{  -1,  -1, 0x7,  -1,  -1,  -1, }, 0 },
> +	{ "fiber",			{  -1,  -1,  -1, 0x0,  -1,  -1, }, L3V0_FIBER },
> +	{ "fiber",			{  -1,  -1,  -1, 0x7,  -1,  -1, }, L3V7_FIBER },
> +	{ "FullDuplex",			{  -1,  -1,  -1, 0x7,  -1,  -1, }, L3V7_DUPLEX },
> +	{ "FullDuplex",			{  -1,  -1,  -1,  -1, 0x6, 0x6, }, 0 },
> +	{ "FullDuplex/collision",	{  -1,  -1,  -1,  -1, 0x7, 0x7, }, 0 },
> +	{ "FullDuplex/collision",	{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_DUPLEX },
> +	{ "ptp",			{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_PTP },
> +	{ "init",			{  -1,  -1, 0x2,  -1,  -1,  -1, }, L2V2_INIT },
> +	{ "los",			{  -1,  -1,  -1, 0x0,  -1,  -1, }, L3V0_LOS },
> +	{ "hi-z",			{ 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, }, 0 },
> +	{ "blink",			{ 0xb, 0xb, 0xb, 0xb, 0xb, 0xb, }, 0 },
> +};
> +
> +struct marvell_leds_info {
> +	u32 family;
> +	int nleds;
> +	u32 flags;

Here flags is a combination of all the features this specific PHY
supports.

> +};
> +
> +#define LED(fam,n,flg)								\
> +	{									\
> +		.family = MARVELL_PHY_FAMILY_ID(MARVELL_PHY_ID_88E##fam),	\
> +		.nleds = (n),							\
> +		.flags = (flg),							\
> +	}									\
> +
> +static const struct marvell_leds_info marvell_leds_info[] = {
> +	LED(1112,  4, L1V0_COPPER | L1V5_100_FIBER | L2V2_INIT | L3V0_LOS | L3V5_TRANS | L3V7_FIBER),
> +	LED(1121R, 3, L1V5_100_10),
> +	LED(1240,  6, L3V5_TRANS),
> +	LED(1340S, 6, L1V0_COPPER | L1V5_100_FIBER | L2V2_PTP | L3V0_FIBER | L3V7_DUPLEX),
> +	LED(1510,  3, L1V0_RECV | L1V5_100_FIBER | L2V2_DUPLEX),
> +	LED(1545,  6, L1V0_COPPER | L1V5_100_FIBER | L3V0_FIBER | L3V7_DUPLEX),
> +};
> +
> +static inline int marvell_led_reg(int led)

No inline functions in C code. Let the compiler decide.

> +{
> +	switch (led) {
> +	case 0 ... 3:
> +		return MII_PHY_LED_CTRL;
> +	case 4 ... 5:
> +		return MII_PHY_LED45_CTRL;
> +	default:
> +		return -EINVAL;
> +	}
> +}

> +static inline bool is_valid_led_mode(struct marvell_priv *priv, struct marvell_phy_led *led,
> +				     const struct marvell_led_mode_info *mode)

Same here, and anywhere else you might of used inline.

> +{
> +	return mode->regval[led->idx] != -1 && (!mode->flags || (priv->led_flags & mode->flags));

If you have COMMON, this gets simpler.

> +}
> +

> +static int marvell_register_led(struct phy_device *phydev, struct device_node *np, int nleds)
> +{
> +	struct marvell_priv *priv = phydev->priv;
> +	struct led_init_data init_data = {};
> +	struct marvell_phy_led *led;
> +	u32 reg, color;
> +	int err;
> +
> +	err = of_property_read_u32(np, "reg", &reg);
> +	if (err < 0)
> +		return err;
> +
> +	/*
> +	 * Maybe we should check here if reg >= nleds, where nleds is number of LEDs of this specific
> +	 * PHY.
> +	 */
> +	if (reg >= nleds) {
> +		phydev_err(phydev,
> +			   "LED node %pOF 'reg' property too large (%u, PHY supports max %u)\n",
> +			   np, reg, nleds - 1);
> +		return -EINVAL;
> +	}
> +
> +	led = &priv->leds[reg];
> +
> +	err = of_property_read_u32(np, "color", &color);
> +	if (err < 0) {
> +		phydev_err(phydev, "LED node %pOF does not specify color\n", np);
> +		return -EINVAL;
> +	}
> +
> +#if 0
> +	/* LED_COLOR_ID_MULTI is not yet merged in Linus' tree */
> +	/* TODO: Support DUAL MODE */
> +	if (color == LED_COLOR_ID_MULTI) {
> +		phydev_warn(phydev, "node %pOF: This driver does not yet support multicolor LEDs\n",
> +			    np);
> +		return -ENOTSUPP;
> +	}
> +#endif

Code getting committed should not be using #if 0. Is the needed code
in the LED tree? Do we want to consider a stable branch of the LED
tree which DaveM can pull into net-next? Or do you want to wait until
the next merge cycle?

> +
> +	init_data.fwnode = &np->fwnode;
> +	init_data.devname_mandatory = true;
> +	init_data.devicename = phydev->attached_dev ? netdev_name(phydev->attached_dev) : "";

This we need to think about. Are you running this on a system with
systemd? Does the interface have a name like enp2s0? Does the LED get
registered before or after systemd renames it from eth0 to enp2s0?

> +
> +	if (led->cdev.max_brightness) {
> +		phydev_err(phydev, "LED node %pOF 'reg' property collision with another LED\n", np);
> +		return -EEXIST;
> +	}
> +
> +	led->cdev.max_brightness = 1;
> +	led->cdev.brightness_set_blocking = marvell_led_brightness_set;
> +	led->cdev.trigger_type = &phy_hw_led_trig_type;
> +	led->idx = reg;
> +
> +	of_property_read_string(np, "linux,default-trigger", &led->cdev.default_trigger);
> +
> +	err = devm_led_classdev_register_ext(&phydev->mdio.dev, &led->cdev, &init_data);
> +	if (err < 0) {
> +		phydev_err(phydev, "Cannot register LED %pOF: %i\n", np, err);
> +		return err;
> +	}

I don't like having the DT binding in the driver. We want all PHY
drivers to use the same binding, and not feel free to implement
whatever they want in their own driver. These are all standard
properties which all PHY drivers should be using. So lets move it into
phylib core. That also allows us to specify the properties in DT,
maybe just pulling in the core LED yaml stuff.

> +
> +	return 0;
> +}
> +
> +static void marvell_register_leds(struct phy_device *phydev)
> +{
> +	struct marvell_priv *priv = phydev->priv;
> +	struct device_node *node = phydev->mdio.dev.of_node;
> +	struct device_node *leds, *led;
> +	const struct marvell_leds_info *info = NULL;
> +	int i;

Reverse Christmas tree.

> +
> +	/* some families don't support LED control in this driver yet */
> +	if (!phydev->drv->led_set_hw_mode)
> +		return;
> +
> +	for (i = 0; i < ARRAY_SIZE(marvell_leds_info); ++i) {
> +		if (MARVELL_PHY_FAMILY_ID(phydev->phy_id) == marvell_leds_info[i].family) {
> +			info = &marvell_leds_info[i];
> +			break;
> +		}
> +	}
> +
> +	if (!info)
> +		return;
> +
> +	priv->led_flags = info->flags;
> +
> +#if 0
> +	/*
> +	 * TODO: here priv->led_flags should be changed so that hw_control values
> +	 * for unsupported modes won't be shown. This cannot be deduced from
> +	 * family only: for example the 88E1510 family contains 88E1510 which
> +	 * does not support fiber, but also 88E1512, which supports fiber.
> +	 */
> +	switch (MARVELL_PHY_FAMILY_ID(phydev->phy_id)) {
> +	}
> +#endif
> +
> +	leds = of_get_child_by_name(node, "leds");
> +	if (!leds)
> +		return;
> +
> +	for_each_available_child_of_node(leds, led) {
> +		/* Should this check if some LED registration failed? */
> +		marvell_register_led(phydev, led, info->nleds);
> +	}
> +}
> +

  Andrew
