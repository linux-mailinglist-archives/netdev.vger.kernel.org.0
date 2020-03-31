Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7924B1997BF
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 15:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730857AbgCaNp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 09:45:28 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55719 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730366AbgCaNp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 09:45:28 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jJHCm-0004G3-Vy; Tue, 31 Mar 2020 15:45:24 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jJHCi-00012N-Fv; Tue, 31 Mar 2020 15:45:20 +0200
Date:   Tue, 31 Mar 2020 15:45:20 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        linux-imx@nxp.com, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        mkl@pengutronix.de
Subject: Re: [PATCH v2] ARM: imx: allow to disable board specific PHY fixups
Message-ID: <20200331134520.GA5756@pengutronix.de>
References: <20200329110457.4113-1-o.rempel@pengutronix.de>
 <20200329150854.GA31812@lunn.ch>
 <20200330052611.2bgu7x4nmimf7pru@pengutronix.de>
 <40209d08-4acb-75c5-1766-6d39bb826ff9@gmail.com>
 <20200330174114.GG25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200330174114.GG25745@shell.armlinux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:16:10 up 201 days, 19:04, 452 users,  load average: 1.89, 2.71,
 2.76
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Mon, Mar 30, 2020 at 06:41:14PM +0100, Russell King - ARM Linux admin wrote:
> On Mon, Mar 30, 2020 at 10:33:03AM -0700, Florian Fainelli wrote:
> > 
> > 
> > On 3/29/2020 10:26 PM, Oleksij Rempel wrote:
> > > Hi Andrew,
> > > 
> > > On Sun, Mar 29, 2020 at 05:08:54PM +0200, Andrew Lunn wrote:
> > >> On Sun, Mar 29, 2020 at 01:04:57PM +0200, Oleksij Rempel wrote:
> > >>
> > >> Hi Oleksij
> > >>
> > >>> +config DEPRECATED_PHY_FIXUPS
> > >>> +	bool "Enable deprecated PHY fixups"
> > >>> +	default y
> > >>> +	---help---
> > >>> +	  In the early days it was common practice to configure PHYs by adding a
> > >>> +	  phy_register_fixup*() in the machine code. This practice turned out to
> > >>> +	  be potentially dangerous, because:
> > >>> +	  - it affects all PHYs in the system
> > >>> +	  - these register changes are usually not preserved during PHY reset
> > >>> +	    or suspend/resume cycle.
> > >>> +	  - it complicates debugging, since these configuration changes were not
> > >>> +	    done by the actual PHY driver.
> > >>> +	  This option allows to disable all fixups which are identified as
> > >>> +	  potentially harmful and give the developers a chance to implement the
> > >>> +	  proper configuration via the device tree (e.g.: phy-mode) and/or the
> > >>> +	  related PHY drivers.
> > >>
> > >> This appears to be an IMX only problem. Everybody else seems to of got
> > >> this right. There is no need to bother everybody with this new
> > >> option. Please put this in arch/arm/mach-mxs/Kconfig and have IMX in
> > >> the name.
> > > 
> > > Actually, all fixups seems to do wring thing:
> > > arch/arm/mach-davinci/board-dm644x-evm.c:915:		phy_register_fixup_for_uid(LXT971_PHY_ID, LXT971_PHY_MASK,
> > > 
> > > Increased MII drive strength. Should be probably enabled by the PHY
> > > driver.
> > > 
> > > arch/arm/mach-imx/mach-imx6q.c:167:		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
> > > arch/arm/mach-imx/mach-imx6q.c:169:		phy_register_fixup_for_uid(PHY_ID_KSZ9031, MICREL_PHY_ID_MASK,
> > > arch/arm/mach-imx/mach-imx6q.c:171:		phy_register_fixup_for_uid(PHY_ID_AR8031, 0xffffffef,
> > > arch/arm/mach-imx/mach-imx6q.c:173:		phy_register_fixup_for_uid(PHY_ID_AR8035, 0xffffffef,
> 
> As far as I'm concerned, the AR8035 fixup is there with good reason.
> It's not just "random" but is required to make the AR8035 usable with
> the iMX6 SoCs.  Not because of a board level thing, but because it's
> required for the AR8035 to be usable with an iMX6 SoC.
> 
> So, having it registered by the iMX6 SoC code is entirely logical and
> correct.
> 
> That's likely true of the AR8031 situation as well.
> 
> I can't speak for any of the others.

OK, let's analyze it step by step:
--------------------------------------------------------------------------------
arch/arm/mach-imx/mach-imx6q.c

The AR8035 fixup is doing following configurations:
- disable SmartEEE with following description:
  /* Ar803x phy SmartEEE feature cause link status generates glitch,
   * which cause ethernet link down/up issue, so disable SmartEEE

- enable clock output from PHY, configures it to 125Mhz and configures
  clock skew. See the comment provided in the source code:
  * Enable 125MHz clock from CLK_25M on the AR8031.  This
  * is fed in to the IMX6 on the ENET_REF_CLK (V22) pad.
  * Also, introduce a tx clock delay.
  *
  * This is the same as is the AR8031 fixup.

- powers on the PHY. Probably to make sure the clock output will run
  before FEC is probed to avoid clock glitches.

The AR8031 fixup only enables clock output of PHY, configures it to
125Mhz, and configures clock skew. The PHY not powered and although it
supports SmartEEE, it's not disabled. Let's assume the fixup author did
the correct configuration and SmartEEE is working without problems.

The KSZ9031rn fixup is configuring only the clock skew. Never the less,
this PHY is not able to provide a stable 125Mhz clock for the FEC, it's not
recommended to use. See:
| http://ww1.microchip.com/downloads/en/DeviceDoc/80000692D.pdf
| Module 2: Duty cycle variation for optional 125MHz reference output clock

The KSZ9021rn fixup is configuring clock skews.

Summary:
- SmartEEE is a PHY errata or bad configuration. It is present in both
  PHYs AR8035 and AR8031, and should be disabled via DT in the PHY driver.

- Clock skew configuration is board specific and this fixup will apply
  it even if the PHY is not connected to the FEC. For example boards
  with additional NIC connected to the PCIe or a switch connected to the
  FEC.
  For the clock skew configuration we already have RGMII_ID*, which
  can be configured by devicetree and/or by ethernet driver directly,
  if no devicetree can be used. For example by USB Ethernet adapter.
  All affected PHYs in this fixup series already support clock skew
  configuration by PHY drivers. See latest versions of at803x.c and
  micrel.c. It means, configurations relying on these fixups (and not
  providing correct devicetree with proper phy-mode) will break sooner or
  later, or already did and are already fixed.

- 125Mhz is a bigger issue:
  - It is board specific. Not all boards use PHYs as a clock source for the
    FEC. The following function is proof of my claim. It is responsible to
    configure iMX6Q to use own clock provider:
    arch/arm/mach-imx/mach-imx6q.c
|    static void __init imx6q_1588_init(void)
|	np = of_find_compatible_node(NULL, NULL, "fsl,imx6q-fec");
|	if (!np) {
|		pr_warn("%s: failed to find fec node\n", __func__);
|		return;
|	}
|
|	ptp_clk = of_clk_get(np, 2);
|	if (IS_ERR(ptp_clk)) {
|		pr_warn("%s: failed to get ptp clock\n", __func__);
|		goto put_node;
|	}
|
|	enet_ref = clk_get_sys(NULL, "enet_ref");
|	if (IS_ERR(enet_ref)) {
|		pr_warn("%s: failed to get enet clock\n", __func__);
|		goto put_ptp_clk;
|	}
|
|	/*
|	 * If enet_ref from ANATOP/CCM is the PTP clock source, we need to
|	 * set bit IOMUXC_GPR1[21].  Or the PTP clock must be from pad
|	 * (external OSC), and we need to clear the bit.
|	 */
|	clksel = clk_is_match(ptp_clk, enet_ref) ?
|				IMX6Q_GPR1_ENET_CLK_SEL_ANATOP :
|				IMX6Q_GPR1_ENET_CLK_SEL_PAD;
|	gpr = syscon_regmap_lookup_by_compatible("fsl,imx6q-iomuxc-gpr");
|	if (!IS_ERR(gpr))
|		regmap_update_bits(gpr, IOMUXC_GPR1,
|				IMX6Q_GPR1_ENET_CLK_SEL_MASK,
|				clksel);

  - The at803x PHY driver already provides following devicetree bindings to
    to configure it as clock provider:
    qca,clk-out-frequency
    qca,keep-pll-enabled
    It is kind of replacement of the clock framework.
  - the micrel PHY is configured, in most cases, by bootstrap pins, but does
    not guarantee a glitch free clock, since the PHY can be suspended no
    matter if other devices are using the clock provided by this PHY or
    not.
  - In current case we have the FEC driver which is using clock framework,
    properly, requesting clock source and even trying to disable it for
    power management. But the clock providers are _NOT_ implementing clock
    framework and do not care about proper glitch free clock initialization
    and power management. Implementing proper clock support in the PHY drivers
    will most probably break all boards relying on these fixups.

--------------------------------------------------------------------------------
arch/arm/mach-imx/mach-imx6sx.c
- this fixup is configuring RGMII signal voltage to 1V8 and clock skews.
  Both configurations are supported by the at803x driver:
  vddio-regulator
  RGMII-ID*

- This fixup is missing SmartEEE workaround.

--------------------------------------------------------------------------------
arch/arm/mach-imx/mach-imx6ul.c
static int ksz8081_phy_fixup(struct phy_device *dev)
{
	if (dev && dev->interface == PHY_INTERFACE_MODE_MII) {
		phy_write(dev, 0x1f, 0x8110);
		phy_write(dev, 0x16, 0x201);
	} else if (dev && dev->interface == PHY_INTERFACE_MODE_RMII) {
		phy_write(dev, 0x1f, 0x8190);
		phy_write(dev, 0x16, 0x202);
	}

This fixup gives me headaches:
http://ww1.microchip.com/downloads/en/DeviceDoc/KSZ8081RNA_RND.pdf

- 0x1f is PHY Control 2 register and it is changing mainly only one
  BIT(7) against default/reset values. This bit is configuring the
  clock frequency of XTAL attached to the PHY.
  Looking into the documentation shows that the meaning of this bit
  depends on the exact PHY variant (1 means 50MHz on the RNA and 25MHz
  on the RND variant). This fixup doesn't take this into account. :(

- 0x16 is Operation Mode Strap Override
  this fixup is changing two 3 bits:
  - BIT(9) If bit is ‘1’, PHY Address 0 is non-broadcast.
    This bit is overwritten by the micrel driver, see
    kszphy_config_init()
 - BIT(1) are overwriting boot strap configuration for RMII mode.
 - BIT(0) is reserved. Since this PHY support only RMII mode and has not
   enough pins for MII mode, the benefit of this configuration is
   questionable.

The patch introduced this fixup is trying to fix the imx6ul evk board.
According to this devicetree:

|arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
|&fec1 {
|	pinctrl-names = "default";
|	pinctrl-0 = <&pinctrl_enet1>;
|	phy-mode = "rmii";
|	phy-handle = <&ethphy0>;
|	phy-supply = <&reg_peri_3v3>;
|	status = "okay";
|};
|
|&fec2 {
|	pinctrl-names = "default";
|	pinctrl-0 = <&pinctrl_enet2>;
|	phy-mode = "rmii";
|	phy-handle = <&ethphy1>;
|	phy-supply = <&reg_peri_3v3>;
|	status = "okay";
|
|	mdio {
|		#address-cells = <1>;
|		#size-cells = <0>;
|
|		ethphy0: ethernet-phy@2 {
|			reg = <2>;
|			micrel,led-mode = <1>;
|			clocks = <&clks IMX6UL_CLK_ENET_REF>;
|			clock-names = "rmii-ref";
|		};
|
|		ethphy1: ethernet-phy@1 {
|			reg = <1>;
|			micrel,led-mode = <1>;
|			clocks = <&clks IMX6UL_CLK_ENET2_REF>;
|			clock-names = "rmii-ref";
|		};
|	};
|};

This PHYs have proper clock configuration and can be used only in RGMII
mode. So, this fixup should be removed any way.

--------------------------------------------------------------------------------
arch/arm/mach-imx/mach-imx7d.c
Both fixups added by following commit:
|commit 69f9c5047d04945693ecc1bdfdb8a3dc2a1f48cf
|Author: Fugang Duan <b38611@freescale.com>
|Date:   Mon Sep 7 10:55:00 2015 +0800
|
|    ARM: imx: add enet init for i.MX7D platform
|
|    Add enet phy fixup, clock source init for i.MX7D platform.
|
|    Signed-off-by: Fugang Duan <B38611@freescale.com>
|    Signed-off-by: Shawn Guo <shawnguo@kernel.org>

- the ar8031 fixup is configuring RGMII signal voltage to 1V8 and clock skews.
  Both configurations are supported by the at803x driver:
  vddio-regulator
  RGMII-ID*
- this time SmartEEE workaround is included
- the bcm54220 fixup is configuring clock skews. No driver is available
  for the bcm54220 PHY. This values are probably not overwritten by any
  other driver.

--------------------------------------------------------------------------------
arch/arm/mach-mxs/mach-mxs.c
This fixup was added by following commit:
|commit 3143bbb42b3d27a5f799c97c84fb7a4a1de88f91
|Author: Shawn Guo <shawn.guo@linaro.org>
|Date:   Sat Jul 7 23:12:03 2012 +0800
|
|    ARM: mxs: convert apx4devkit board to device tree
|
|    Tested-by: Lauri Hintsala <lauri.hintsala@bluegiga.com>
|    Signed-off-by: Shawn Guo <shawn.guo@linaro.org>

This is the first fixup and this series which is not modifying the PHY
registers directly, but set the legacy board file specific flags for the
phy. The board specific XTAL frequency is reported to the PHY by
setting MICREL_PHY_50MHZ_CLK flag and used by micrel driver.

--------------------------------------------------------------------------------
arch/arm/mach-orion5x/dns323-setup.c
This fixup was added by following commit:
|commit 6e2daa49420777190c133d7097dd8d5c05b475ac
|Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
|Date:   Mon Jun 21 13:21:53 2010 +1000
|
|    [ARM] orion5x: Base support for DNS-323 rev C1
|
|    This patch adds the base support for this new HW revision to the existing
|    dns323-setup.c file. The SoC seems to be the same as rev B1, the GPIOs
|    are all wired differently though and the fan control isn't i2c based
|    anymore.
|
|    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
|    Signed-off-by: Nicolas Pitre <nico@fluxnic.net>


This is related to a single board and do not modifies PHY registers. The
LED configuration is requested per MARVELL_PHY_M1118_DNS323_LEDS flag by
the marvell PHY driver.

--------------------------------------------------------------------------------
arch/powerpc/platforms/85xx/mpc85xx_mds.c
This fixup was added by following commit:
|commit 94833a42765509a7aa95ed1ba7b227ead3c29c08
|Author: Andy Fleming <afleming@freescale.com>
|Date:   Fri May 2 18:56:41 2008 -0500
|
|    [POWERPC] 85xx: Add 8568 PHY workarounds to board code
|
|    The 8568 MDS needs some configuration changes to the PHY in order to
|    work properly.  These are done in the firmware, normally, but Linux
|    shouldn't need to rely on the firmware running such things (someone
|    could disable the PHY support in the firmware to save space, for instance).
|
|    Signed-off-by: Andy Fleming <afleming@freescale.com>
|    Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

This fixup is hard to analyze. I was not able to find a documentation or
related driver for the Marvell 88E1111 PHY. It seems to enable 125Mhz clock as
previous fixups did.

--------------------------------------------------------------------------------
drivers/net/ethernet/dnet.c
This fixup was added by following commit:
|commit 4796417417a62e2ae83d92cb92e1ecf9ec67b5f5
|Author: Ilya Yanok <yanok@emcraft.com>
|Date:   Wed Mar 11 23:26:02 2009 -0700
|
|    dnet: Dave DNET ethernet controller driver (updated)
|
|    Driver for Dave DNET ethernet controller found on Dave/DENX QongEVB-LITE
|    FPGA. Heavily based on Dave sources, I've just adopted it to current
|    kernel version and done some code cleanup.
|
|    Signed-off-by: Ilya Yanok <yanok@emcraft.com>
|    Signed-off-by: David S. Miller <davem@davemloft.net>

Same PHY as in previous case (Marvell 88E1111). The comment statement is:
/* For Neptune board: LINK1000 as Link LED and TX as activity LED */

--------------------------------------------------------------------------------
drivers/net/usb/lan78xx.c
This driver provides two fixups, added by following commit:
|commit 02dc1f3d613d5a859513d7416c9aca370425a7e0
|Author: Woojung Huh <woojung.huh@microchip.com>
|Date:   Wed Dec 7 20:26:25 2016 +0000
|
|    lan78xx: add LAN7801 MAC only support
|
|    Add LAN7801 MAC only support with phy fixup functions.
|
|    Signed-off-by: Woojung Huh <woojung.huh@microchip.com>
|    Signed-off-by: David S. Miller <davem@davemloft.net>


These fixups are related to KSZ9031rnx and LAN8835 PHYs, are configuring clock
skews.

Please note: The KSZ9031 fixup is used on imx6q boards. What will happen
if we attach this adapter to a imx6q based system? Or what will happen
with all this usb ethernet adapters with atheros or micrel PHYs attached
to imx6 based system?

Regards,
Oleksij & Marc
-- 
Pengutronix e.K.
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
