Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AE21FF7EF
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 17:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731518AbgFRPrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 11:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbgFRPry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 11:47:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19126C06174E;
        Thu, 18 Jun 2020 08:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CFrmhTuApvYa+8hc6V4WzzRWOAFPgE4XtBC85Y3EoQc=; b=QZ2IBFmH9+BRB8p3aBqGat06f
        RUeg/ANwy7liXFMMZBP5hMJ4JFhzkgqTu+fs4cdL/w1Pxs4pr4LrGG005I6WFh+j/5svX62XSRlNK
        /vtc8ymd8Py5Ui6ga0aS8PffaCPY+OnsGBHmKrZxHftNFOHzmF0y7yzOG6ZMU7z/ZnTJgtK9xYlfT
        UxOSiSS2J2gqIaIRWfDx2GYoR6fENWhjIZ9iGdyd3NYDFS0XV3BWul8OoJxkC2wc7K59VAE0gP1jJ
        l2ABObysUSNiKyrzhn81VGJ3oOwk6NC9DzFBHbr3Mhto9iKgSqLP8r/deV9EWSObq44JD/qqmFBaB
        IocKCuOsQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58790)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jlwlZ-0005Ko-5L; Thu, 18 Jun 2020 16:47:49 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jlwlY-0004pU-Jx; Thu, 18 Jun 2020 16:47:48 +0100
Date:   Thu, 18 Jun 2020 16:47:48 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        christoph.muellner@theobroma-systems.com
Subject: Re: [PATCH v5 3/3] net: phy: mscc: handle the clkout control on some
 phy variants
Message-ID: <20200618154748.GE1551@shell.armlinux.org.uk>
References: <20200618121139.1703762-1-heiko@sntech.de>
 <20200618132822.GN249144@lunn.ch>
 <20200618134102.GA1551@shell.armlinux.org.uk>
 <2277698.LFZWc9m3Y3@diego>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2277698.LFZWc9m3Y3@diego>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 05:41:54PM +0200, Heiko Stübner wrote:
> Am Donnerstag, 18. Juni 2020, 15:41:02 CEST schrieb Russell King - ARM Linux admin:
> > On Thu, Jun 18, 2020 at 03:28:22PM +0200, Andrew Lunn wrote:
> > > On Thu, Jun 18, 2020 at 02:11:39PM +0200, Heiko Stuebner wrote:
> > > > From: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
> > > > 
> > > > At least VSC8530/8531/8540/8541 contain a clock output that can emit
> > > > a predefined rate of 25, 50 or 125MHz.
> > > > 
> > > > This may then feed back into the network interface as source clock.
> > > > So expose a clock-provider from the phy using the common clock framework
> > > > to allow setting the rate.
> > > > 
> > > > Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
> > > > ---
> > > >  drivers/net/phy/mscc/mscc.h      |  13 +++
> > > >  drivers/net/phy/mscc/mscc_main.c | 182 +++++++++++++++++++++++++++++--
> > > >  2 files changed, 187 insertions(+), 8 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
> > > > index fbcee5fce7b2..94883dab5cc1 100644
> > > > --- a/drivers/net/phy/mscc/mscc.h
> > > > +++ b/drivers/net/phy/mscc/mscc.h
> > > > @@ -218,6 +218,13 @@ enum rgmii_clock_delay {
> > > >  #define INT_MEM_DATA_M			  0x00ff
> > > >  #define INT_MEM_DATA(x)			  (INT_MEM_DATA_M & (x))
> > > >  
> > > > +#define MSCC_CLKOUT_CNTL		  13
> > > > +#define CLKOUT_ENABLE			  BIT(15)
> > > > +#define CLKOUT_FREQ_MASK		  GENMASK(14, 13)
> > > > +#define CLKOUT_FREQ_25M			  (0x0 << 13)
> > > > +#define CLKOUT_FREQ_50M			  (0x1 << 13)
> > > > +#define CLKOUT_FREQ_125M		  (0x2 << 13)
> > > > +
> > > >  #define MSCC_PHY_PROC_CMD		  18
> > > >  #define PROC_CMD_NCOMPLETED		  0x8000
> > > >  #define PROC_CMD_FAILED			  0x4000
> > > > @@ -360,6 +367,12 @@ struct vsc8531_private {
> > > >  	 */
> > > >  	unsigned int base_addr;
> > > >  
> > > > +#ifdef CONFIG_COMMON_CLK
> > > > +	struct clk_hw clkout_hw;
> > > > +#endif
> > > > +	u32 clkout_rate;
> > > > +	int clkout_enabled;
> > > > +
> > > >  #if IS_ENABLED(CONFIG_MACSEC)
> > > >  	/* MACsec fields:
> > > >  	 * - One SecY per device (enforced at the s/w implementation level)
> > > > diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
> > > > index 5d2777522fb4..727a9dd58403 100644
> > > > --- a/drivers/net/phy/mscc/mscc_main.c
> > > > +++ b/drivers/net/phy/mscc/mscc_main.c
> > > > @@ -7,6 +7,7 @@
> > > >   * Copyright (c) 2016 Microsemi Corporation
> > > >   */
> > > >  
> > > > +#include <linux/clk-provider.h>
> > > >  #include <linux/firmware.h>
> > > >  #include <linux/jiffies.h>
> > > >  #include <linux/kernel.h>
> > > > @@ -431,7 +432,6 @@ static int vsc85xx_dt_led_mode_get(struct phy_device *phydev,
> > > >  
> > > >  	return led_mode;
> > > >  }
> > > > -
> > > >  #else
> > > >  static int vsc85xx_edge_rate_magic_get(struct phy_device *phydev)
> > > >  {
> > > > @@ -1508,6 +1508,43 @@ static int vsc85xx_config_init(struct phy_device *phydev)
> > > >  	return 0;
> > > >  }
> > > >  
> > > > +static int vsc8531_config_init(struct phy_device *phydev)
> > > > +{
> > > > +	struct vsc8531_private *vsc8531 = phydev->priv;
> > > > +	u16 val;
> > > > +	int rc;
> > > > +
> > > > +	rc = vsc85xx_config_init(phydev);
> > > > +	if (rc)
> > > > +		return rc;
> > > > +
> > > > +#ifdef CONFIG_COMMON_CLK
> > > > +	switch (vsc8531->clkout_rate) {
> > > > +	case 25000000:
> > > > +		val = CLKOUT_FREQ_25M;
> > > > +		break;
> > > > +	case 50000000:
> > > > +		val = CLKOUT_FREQ_50M;
> > > > +		break;
> > > > +	case 125000000:
> > > > +		val = CLKOUT_FREQ_125M;
> > > > +		break;
> > > > +	default:
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > > +	if (vsc8531->clkout_enabled)
> > > > +		val |= CLKOUT_ENABLE;
> > > > +
> > > > +	rc = phy_write_paged(phydev, MSCC_PHY_PAGE_EXTENDED_GPIO,
> > > > +			     MSCC_CLKOUT_CNTL, val);
> > > > +	if (rc)
> > > > +		return rc;
> > > > +#endif
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > 
> > > > +static int vsc8531_clkout_prepare(struct clk_hw *hw)
> > > > +{
> > > > +	struct vsc8531_private *vsc8531 = clkout_hw_to_vsc8531(hw);
> > > > +
> > > > +	vsc8531->clkout_enabled = true;
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static void vsc8531_clkout_unprepare(struct clk_hw *hw)
> > > > +{
> > > > +	struct vsc8531_private *vsc8531 = clkout_hw_to_vsc8531(hw);
> > > > +
> > > > +	vsc8531->clkout_enabled = false;
> > > > +}
> > > > +
> > > 
> > > > +static const struct clk_ops vsc8531_clkout_ops = {
> > > > +	.prepare = vsc8531_clkout_prepare,
> > > > +	.unprepare = vsc8531_clkout_unprepare,
> > > > +	.is_prepared = vsc8531_clkout_is_prepared,
> > > > +	.recalc_rate = vsc8531_clkout_recalc_rate,
> > > > +	.round_rate = vsc8531_clkout_round_rate,
> > > > +	.set_rate = vsc8531_clkout_set_rate,
> > > 
> > > I'm not sure this is the expected behaviour. The clk itself should
> > > only start ticking when the enable callback is called. But this code
> > > will enable the clock when config_init() is called. I think you should
> > > implement the enable and disable methods.
> > 
> > That is actually incorrect.  The whole "prepare" vs "enable" difference
> > is that prepare can schedule, enable isn't permitted.  So, if you need
> > to sleep to enable the clock, then enabling the clock in the prepare
> > callback is the right thing to do.
> > 
> > However, the above driver just sets a flag, which only gets used when
> > the PHY's config_init method is called; that really doesn't seem to be
> > sane - the clock is available from the point that the PHY has been
> > probed, and it'll be expected that once the clock is published, it can
> > be made functional.
> 
> Though I'm not sure how this fits in the whole bringup of ethernet phys.
> Like the phy is dependent on the underlying ethernet controller to
> actually turn it on.
> 
> I guess we should check the phy-state and if it's not accessible, just
> keep the values and if it's in a suitable state do the configuration.
> 
> Calling a vsc8531_config_clkout() from both the vsc8531_config_init()
> as well as the clk_(un-)prepare  and clk_set_rate functions and being
> protected by a check against phy_is_started() ?

It sounds like it doesn't actually fit the clk API paradym then.  I
see that Rob suggested it, and from the DT point of view, it makes
complete sense, but then if the hardware can't actually be used in
the way the clk API expects it to be used, then there's a semantic
problem.

What is this clock used for?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
