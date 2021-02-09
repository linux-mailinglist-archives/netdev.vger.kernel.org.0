Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486CF314CC8
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 11:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhBIKSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 05:18:53 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:59670 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbhBIKQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 05:16:21 -0500
Date:   Tue, 9 Feb 2021 13:15:28 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/20] net: phy: realtek: Fix events detection failure in
 LPI mode
Message-ID: <20210209101528.3lf47ouaedfgq74n@mobilestation>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
 <20210208140341.9271-2-Sergey.Semin@baikalelectronics.ru>
 <8300d9ca-b877-860f-a975-731d6d3a93a5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8300d9ca-b877-860f-a975-731d6d3a93a5@gmail.com>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 09:14:02PM +0100, Heiner Kallweit wrote:
> On 08.02.2021 15:03, Serge Semin wrote:
> > It has been noticed that RTL8211E PHY stops detecting and reporting events
> > when EEE is successfully advertised and RXC stopping in LPI is enabled.
> > The freeze happens right after 3.0.10 bit (PC1R "Clock Stop Enable"
> > register) is set. At the same time LED2 stops blinking as if EEE mode has
> > been disabled. Notably the network traffic still flows through the PHY
> > with no obvious problem. Anyway if any MDIO read procedure is performed
> > after the "RXC stop in LPI" mode is enabled PHY gets to be unfrozen, LED2
> > starts blinking and PHY interrupts happens again. The problem has been
> > noticed on RTL8211E PHY working together with DW GMAC 3.73a MAC and
> > reporting its event via a dedicated IRQ signal. (Obviously the problem has
> > been unnoticed in the polling mode, since it gets naturally fixed by the
> > periodic MDIO read procedure from the PHY status register - BMSR.)
> > 
> > In order to fix that problem we suggest to locally re-implement the MMD
> > write method for RTL8211E PHY and perform a dummy read right after the
> > PC1R register is accessed to enable the RXC stopping in LPI mode.
> > 
> > Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > ---
> >  drivers/net/phy/realtek.c | 37 +++++++++++++++++++++++++++++++++++++
> >  1 file changed, 37 insertions(+)
> > 
> > diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> > index 99ecd6c4c15a..cbb86c257aae 100644
> > --- a/drivers/net/phy/realtek.c
> > +++ b/drivers/net/phy/realtek.c
> > @@ -559,6 +559,42 @@ static int rtl822x_write_mmd(struct phy_device *phydev, int devnum, u16 regnum,
> >  	return ret;
> >  }
> >  
> > +static int rtl8211e_write_mmd(struct phy_device *phydev, int devnum, u16 regnum,
> > +			      u16 val)
> > +{
> > +	int ret;
> > +
> > +	/* Write to the MMD registers by using the standard control/data pair.
> > +	 * The only difference is that we need to perform a dummy read after
> > +	 * the PC1R.CLKSTOP_EN bit is set. It's required to workaround an issue
> > +	 * of a partial core freeze so LED2 stops blinking in EEE mode, PHY
> > +	 * stops detecting the link change and raising IRQs until any read from
> > +	 * its registers performed. That happens only if and right after the PHY
> > +	 * is enabled to stop RXC in LPI mode.
> > +	 */
> > +	ret = __phy_write(phydev, MII_MMD_CTRL, devnum);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = __phy_write(phydev, MII_MMD_DATA, regnum);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = __phy_write(phydev, MII_MMD_CTRL, devnum | MII_MMD_CTRL_NOINCR);
> > +	if (ret)
> > +		return ret;
> > +
> 

> Nice analysis. Alternatively to duplicating this code piece we could
> export mmd_phy_indirect(). But up to you.

I also considered creating a generic method to access the MMD
registers of a generic PHY, something like phy_read()/phy_write(), but
for MMD (alas just exporting mmd_phy_indirect() would not be enough).
But as I see it such methods need to be created only after we get to
have at least several places with duplicating direct MMD-read/write
patterns. Doing that just for a single place seems redundant. Anyway it's
up to maintainers to decide whether they want to see a generic part
of the phy_read_mmd()/phy_write_mmd() methods being detached and
exported as something like genphy_{read,write}_mmd() methods. I can do
that in v2 if you ask me to.

-Sergey

> 
> > +	ret = __phy_write(phydev, MII_MMD_DATA, val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (devnum == MDIO_MMD_PCS && regnum == MDIO_CTRL1 &&
> > +	    val & MDIO_PCS_CTRL1_CLKSTOP_EN)
> > +		ret =  __phy_read(phydev, MII_MMD_DATA);
> > +
> > +	return ret < 0 ? ret : 0;
> > +}
> > +
> >  static int rtl822x_get_features(struct phy_device *phydev)
> >  {
> >  	int val;
> > @@ -725,6 +761,7 @@ static struct phy_driver realtek_drvs[] = {
> >  		.resume		= genphy_resume,
> >  		.read_page	= rtl821x_read_page,
> >  		.write_page	= rtl821x_write_page,
> > +		.write_mmd	= rtl8211e_write_mmd,
> >  	}, {
> >  		PHY_ID_MATCH_EXACT(0x001cc916),
> >  		.name		= "RTL8211F Gigabit Ethernet",
> > 
> 
