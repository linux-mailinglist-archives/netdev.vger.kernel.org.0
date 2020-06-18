Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D2B1FF876
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731712AbgFRQBi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:01:38 -0400
Received: from gloria.sntech.de ([185.11.138.130]:55568 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731467AbgFRQBf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 12:01:35 -0400
Received: from ip5f5aa64a.dynamic.kabel-deutschland.de ([95.90.166.74] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1jlwyo-0001nB-55; Thu, 18 Jun 2020 18:01:30 +0200
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        christoph.muellner@theobroma-systems.com
Subject: Re: [PATCH v5 3/3] net: phy: mscc: handle the clkout control on some phy variants
Date:   Thu, 18 Jun 2020 18:01:29 +0200
Message-ID: <1723854.ZAnHLLU950@diego>
In-Reply-To: <20200618154748.GE1551@shell.armlinux.org.uk>
References: <20200618121139.1703762-1-heiko@sntech.de> <2277698.LFZWc9m3Y3@diego> <20200618154748.GE1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Donnerstag, 18. Juni 2020, 17:47:48 CEST schrieb Russell King - ARM Linux admin:
> On Thu, Jun 18, 2020 at 05:41:54PM +0200, Heiko Stübner wrote:
> > Am Donnerstag, 18. Juni 2020, 15:41:02 CEST schrieb Russell King - ARM Linux admin:
> > > On Thu, Jun 18, 2020 at 03:28:22PM +0200, Andrew Lunn wrote:
> > > > On Thu, Jun 18, 2020 at 02:11:39PM +0200, Heiko Stuebner wrote:
> > > > > From: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
> > > > > 
> > > > > At least VSC8530/8531/8540/8541 contain a clock output that can emit
> > > > > a predefined rate of 25, 50 or 125MHz.
> > > > > 
> > > > > This may then feed back into the network interface as source clock.
> > > > > So expose a clock-provider from the phy using the common clock framework
> > > > > to allow setting the rate.
> > > > > 
> > > > > Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
> > > > > ---
> > > > >  drivers/net/phy/mscc/mscc.h      |  13 +++
> > > > >  drivers/net/phy/mscc/mscc_main.c | 182 +++++++++++++++++++++++++++++--
> > > > >  2 files changed, 187 insertions(+), 8 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
> > > > > index fbcee5fce7b2..94883dab5cc1 100644
> > > > > --- a/drivers/net/phy/mscc/mscc.h
> > > > > +++ b/drivers/net/phy/mscc/mscc.h
> > > > > @@ -218,6 +218,13 @@ enum rgmii_clock_delay {
> > > > >  #define INT_MEM_DATA_M			  0x00ff
> > > > >  #define INT_MEM_DATA(x)			  (INT_MEM_DATA_M & (x))
> > > > >  
> > > > > +#define MSCC_CLKOUT_CNTL		  13
> > > > > +#define CLKOUT_ENABLE			  BIT(15)
> > > > > +#define CLKOUT_FREQ_MASK		  GENMASK(14, 13)
> > > > > +#define CLKOUT_FREQ_25M			  (0x0 << 13)
> > > > > +#define CLKOUT_FREQ_50M			  (0x1 << 13)
> > > > > +#define CLKOUT_FREQ_125M		  (0x2 << 13)
> > > > > +
> > > > >  #define MSCC_PHY_PROC_CMD		  18
> > > > >  #define PROC_CMD_NCOMPLETED		  0x8000
> > > > >  #define PROC_CMD_FAILED			  0x4000
> > > > > @@ -360,6 +367,12 @@ struct vsc8531_private {
> > > > >  	 */
> > > > >  	unsigned int base_addr;
> > > > >  
> > > > > +#ifdef CONFIG_COMMON_CLK
> > > > > +	struct clk_hw clkout_hw;
> > > > > +#endif
> > > > > +	u32 clkout_rate;
> > > > > +	int clkout_enabled;
> > > > > +
> > > > >  #if IS_ENABLED(CONFIG_MACSEC)
> > > > >  	/* MACsec fields:
> > > > >  	 * - One SecY per device (enforced at the s/w implementation level)
> > > > > diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
> > > > > index 5d2777522fb4..727a9dd58403 100644
> > > > > --- a/drivers/net/phy/mscc/mscc_main.c
> > > > > +++ b/drivers/net/phy/mscc/mscc_main.c
> > > > > @@ -7,6 +7,7 @@
> > > > >   * Copyright (c) 2016 Microsemi Corporation
> > > > >   */
> > > > >  
> > > > > +#include <linux/clk-provider.h>
> > > > >  #include <linux/firmware.h>
> > > > >  #include <linux/jiffies.h>
> > > > >  #include <linux/kernel.h>
> > > > > @@ -431,7 +432,6 @@ static int vsc85xx_dt_led_mode_get(struct phy_device *phydev,
> > > > >  
> > > > >  	return led_mode;
> > > > >  }
> > > > > -
> > > > >  #else
> > > > >  static int vsc85xx_edge_rate_magic_get(struct phy_device *phydev)
> > > > >  {
> > > > > @@ -1508,6 +1508,43 @@ static int vsc85xx_config_init(struct phy_device *phydev)
> > > > >  	return 0;
> > > > >  }
> > > > >  
> > > > > +static int vsc8531_config_init(struct phy_device *phydev)
> > > > > +{
> > > > > +	struct vsc8531_private *vsc8531 = phydev->priv;
> > > > > +	u16 val;
> > > > > +	int rc;
> > > > > +
> > > > > +	rc = vsc85xx_config_init(phydev);
> > > > > +	if (rc)
> > > > > +		return rc;
> > > > > +
> > > > > +#ifdef CONFIG_COMMON_CLK
> > > > > +	switch (vsc8531->clkout_rate) {
> > > > > +	case 25000000:
> > > > > +		val = CLKOUT_FREQ_25M;
> > > > > +		break;
> > > > > +	case 50000000:
> > > > > +		val = CLKOUT_FREQ_50M;
> > > > > +		break;
> > > > > +	case 125000000:
> > > > > +		val = CLKOUT_FREQ_125M;
> > > > > +		break;
> > > > > +	default:
> > > > > +		return -EINVAL;
> > > > > +	}
> > > > > +
> > > > > +	if (vsc8531->clkout_enabled)
> > > > > +		val |= CLKOUT_ENABLE;
> > > > > +
> > > > > +	rc = phy_write_paged(phydev, MSCC_PHY_PAGE_EXTENDED_GPIO,
> > > > > +			     MSCC_CLKOUT_CNTL, val);
> > > > > +	if (rc)
> > > > > +		return rc;
> > > > > +#endif
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > 
> > > > > +static int vsc8531_clkout_prepare(struct clk_hw *hw)
> > > > > +{
> > > > > +	struct vsc8531_private *vsc8531 = clkout_hw_to_vsc8531(hw);
> > > > > +
> > > > > +	vsc8531->clkout_enabled = true;
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > > +static void vsc8531_clkout_unprepare(struct clk_hw *hw)
> > > > > +{
> > > > > +	struct vsc8531_private *vsc8531 = clkout_hw_to_vsc8531(hw);
> > > > > +
> > > > > +	vsc8531->clkout_enabled = false;
> > > > > +}
> > > > > +
> > > > 
> > > > > +static const struct clk_ops vsc8531_clkout_ops = {
> > > > > +	.prepare = vsc8531_clkout_prepare,
> > > > > +	.unprepare = vsc8531_clkout_unprepare,
> > > > > +	.is_prepared = vsc8531_clkout_is_prepared,
> > > > > +	.recalc_rate = vsc8531_clkout_recalc_rate,
> > > > > +	.round_rate = vsc8531_clkout_round_rate,
> > > > > +	.set_rate = vsc8531_clkout_set_rate,
> > > > 
> > > > I'm not sure this is the expected behaviour. The clk itself should
> > > > only start ticking when the enable callback is called. But this code
> > > > will enable the clock when config_init() is called. I think you should
> > > > implement the enable and disable methods.
> > > 
> > > That is actually incorrect.  The whole "prepare" vs "enable" difference
> > > is that prepare can schedule, enable isn't permitted.  So, if you need
> > > to sleep to enable the clock, then enabling the clock in the prepare
> > > callback is the right thing to do.
> > > 
> > > However, the above driver just sets a flag, which only gets used when
> > > the PHY's config_init method is called; that really doesn't seem to be
> > > sane - the clock is available from the point that the PHY has been
> > > probed, and it'll be expected that once the clock is published, it can
> > > be made functional.
> > 
> > Though I'm not sure how this fits in the whole bringup of ethernet phys.
> > Like the phy is dependent on the underlying ethernet controller to
> > actually turn it on.
> > 
> > I guess we should check the phy-state and if it's not accessible, just
> > keep the values and if it's in a suitable state do the configuration.
> > 
> > Calling a vsc8531_config_clkout() from both the vsc8531_config_init()
> > as well as the clk_(un-)prepare  and clk_set_rate functions and being
> > protected by a check against phy_is_started() ?
> 
> It sounds like it doesn't actually fit the clk API paradym then.  I
> see that Rob suggested it, and from the DT point of view, it makes
> complete sense, but then if the hardware can't actually be used in
> the way the clk API expects it to be used, then there's a semantic
> problem.
> 
> What is this clock used for?

It provides a source for the mac-clk for the actual transfers, here to
provide the 125MHz clock needed for the RGMII interface .

So right now the old rk3368-lion devicetree just declares a stub
fixed-clock and instructs the soc's clock controller to use it [0] .
And in the cover-letter here, I show the update variant with using
the clock defined here.


I've added the idea from my previous mail like shown below [1].
which would take into account the phy-state.

But I guess I'll wait for more input before spamming people with v6.

Thanks
Heiko


[0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi#n150
[1]
@@ -1508,6 +1508,157 @@ static int vsc85xx_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+#ifdef CONFIG_COMMON_CLK
+#define clkout_hw_to_vsc8531(_hw) container_of(_hw, struct vsc8531_private, clkout_hw)
+
+static int clkout_rates[] = {
+	125000000,
+	50000000,
+	25000000,
+};
+
+static int vsc8531_config_clkout(struct phy_device *phydev)
+{
+	struct vsc8531_private *vsc8531 = phydev->priv;
+	u16 val;
+
+	/* when called from clk functions, make sure phy is running */
+	if (phy_is_started(phydev))
+		return 0;
+
+	switch (vsc8531->clkout_rate) {
+	case 25000000:
+		val = CLKOUT_FREQ_25M;
+		break;
+	case 50000000:
+		val = CLKOUT_FREQ_50M;
+		break;
+	case 125000000:
+		val = CLKOUT_FREQ_125M;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (vsc8531->clkout_enabled)
+		val |= CLKOUT_ENABLE;
+
+	return phy_write_paged(phydev, MSCC_PHY_PAGE_EXTENDED_GPIO,
+			       MSCC_CLKOUT_CNTL, val);
+}
+
+static unsigned long vsc8531_clkout_recalc_rate(struct clk_hw *hw,
+						unsigned long parent_rate)
+{
+	struct vsc8531_private *vsc8531 = clkout_hw_to_vsc8531(hw);
+
+	return vsc8531->clkout_rate;
+}
+
+static long vsc8531_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
+				      unsigned long *prate)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(clkout_rates); i++)
+		if (clkout_rates[i] <= rate)
+			return clkout_rates[i];
+	return 0;
+}
+
+static int vsc8531_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
+				   unsigned long parent_rate)
+{
+	struct vsc8531_private *vsc8531 = clkout_hw_to_vsc8531(hw);
+	struct phy_device *phydev = vsc8531->phydev;
+
+	vsc8531->clkout_rate = rate;
+	return vsc8531_config_clkout(phydev);
+}
+
+static int vsc8531_clkout_prepare(struct clk_hw *hw)
+{
+	struct vsc8531_private *vsc8531 = clkout_hw_to_vsc8531(hw);
+	struct phy_device *phydev = vsc8531->phydev;
+
+	vsc8531->clkout_enabled = true;
+	return vsc8531_config_clkout(phydev);
+}
+
+static void vsc8531_clkout_unprepare(struct clk_hw *hw)
+{
+	struct vsc8531_private *vsc8531 = clkout_hw_to_vsc8531(hw);
+	struct phy_device *phydev = vsc8531->phydev;
+
+	vsc8531->clkout_enabled = false;
+	vsc8531_config_clkout(phydev);
+}
+
+static int vsc8531_clkout_is_prepared(struct clk_hw *hw)
+{
+	struct vsc8531_private *vsc8531 = clkout_hw_to_vsc8531(hw);
+
+	return vsc8531->clkout_enabled;
+}
+
+static const struct clk_ops vsc8531_clkout_ops = {
+	.prepare = vsc8531_clkout_prepare,
+	.unprepare = vsc8531_clkout_unprepare,
+	.is_prepared = vsc8531_clkout_is_prepared,
+	.recalc_rate = vsc8531_clkout_recalc_rate,
+	.round_rate = vsc8531_clkout_round_rate,
+	.set_rate = vsc8531_clkout_set_rate,
+};
+
+static int vsc8531_register_clkout(struct phy_device *phydev)
+{
+	struct vsc8531_private *vsc8531 = phydev->priv;
+	struct device *dev = &phydev->mdio.dev;
+	struct device_node *of_node = dev->of_node;
+	struct clk_init_data init;
+	int ret;
+
+	init.name = "vsc8531-clkout";
+	init.ops = &vsc8531_clkout_ops;
+	init.flags = 0;
+	init.parent_names = NULL;
+	init.num_parents = 0;
+	vsc8531->clkout_hw.init = &init;
+
+	/* optional override of the clockname */
+	of_property_read_string(of_node, "clock-output-names", &init.name);
+
+	/* register the clock */
+	ret = devm_clk_hw_register(dev, &vsc8531->clkout_hw);
+	if (!ret)
+		ret = devm_of_clk_add_hw_provider(dev, of_clk_hw_simple_get,
+						  &vsc8531->clkout_hw);
+
+	return ret;
+}
+#else
+static int vsc8531_register_clkout(struct phy_device *phydev)
+{
+	return 0;
+}
+
+static int vsc8531_config_clkout(struct phy_device *phydev)
+{
+	return 0;
+}
+#endif
+
+static int vsc8531_config_init(struct phy_device *phydev)
+{
+	int rc;
+
+	rc = vsc85xx_config_init(phydev);
+	if (rc)
+		return rc;
+
+	return vsc8531_config_clkout(phydev);
+}
+




