Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46B3205617
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 17:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733046AbgFWPgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 11:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733009AbgFWPgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 11:36:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F54C061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 08:36:49 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jnkyd-0001RE-Rv; Tue, 23 Jun 2020 17:36:47 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jnkyd-000675-7i; Tue, 23 Jun 2020 17:36:47 +0200
Date:   Tue, 23 Jun 2020 17:36:47 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel@pengutronix.de
Subject: Re: [PATCH 1/2] net: ethernet: mvneta: Fix Serdes configuration for
 SoCs without comphy
Message-ID: <20200623153647.GF11869@pengutronix.de>
References: <20200616083140.8498-1-s.hauer@pengutronix.de>
 <20200622235340.GQ1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622235340.GQ1551@shell.armlinux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:36:02 up 124 days, 23:06, 121 users,  load average: 0.22, 0.26,
 0.27
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 12:53:40AM +0100, Russell King - ARM Linux admin wrote:
> On Tue, Jun 16, 2020 at 10:31:39AM +0200, Sascha Hauer wrote:
> > The MVNETA_SERDES_CFG register is only available on older SoCs like the
> > Armada XP. On newer SoCs like the Armada 38x the fields are moved to
> > comphy. This patch moves the writes to this register next to the comphy
> > initialization, so that depending on the SoC either comphy or
> > MVNETA_SERDES_CFG is configured.
> > With this we no longer write to the MVNETA_SERDES_CFG on SoCs where it
> > doesn't exist.
> > 
> > Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 80 +++++++++++++++------------
> >  1 file changed, 44 insertions(+), 36 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> > index 51889770958d8..9933eb4577d43 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -106,6 +106,7 @@
> >  #define      MVNETA_TX_IN_PRGRS                  BIT(1)
> >  #define      MVNETA_TX_FIFO_EMPTY                BIT(8)
> >  #define MVNETA_RX_MIN_FRAME_SIZE                 0x247c
> > +/* Only exists on Armada XP and Armada 370 */
> >  #define MVNETA_SERDES_CFG			 0x24A0
> >  #define      MVNETA_SGMII_SERDES_PROTO		 0x0cc7
> >  #define      MVNETA_QSGMII_SERDES_PROTO		 0x0667
> > @@ -3514,26 +3515,55 @@ static int mvneta_setup_txqs(struct mvneta_port *pp)
> >  	return 0;
> >  }
> >  
> > -static int mvneta_comphy_init(struct mvneta_port *pp)
> > +static int mvneta_comphy_init(struct mvneta_port *pp, phy_interface_t interface)
> >  {
> >  	int ret;
> >  
> > -	if (!pp->comphy)
> > -		return 0;
> > -
> > -	ret = phy_set_mode_ext(pp->comphy, PHY_MODE_ETHERNET,
> > -			       pp->phy_interface);
> > +	ret = phy_set_mode_ext(pp->comphy, PHY_MODE_ETHERNET, interface);
> >  	if (ret)
> >  		return ret;
> >  
> >  	return phy_power_on(pp->comphy);
> >  }
> >  
> > +static int mvneta_config_interface(struct mvneta_port *pp,
> > +				   phy_interface_t interface)
> > +{
> > +	int ret = 0;
> > +
> > +	if (pp->comphy) {
> > +		if (interface == PHY_INTERFACE_MODE_SGMII ||
> > +		    interface == PHY_INTERFACE_MODE_1000BASEX ||
> > +		    interface == PHY_INTERFACE_MODE_2500BASEX) {
> > +			ret = mvneta_comphy_init(pp, interface);
> > +		}
> > +	} else {
> > +		switch (interface) {
> > +		case PHY_INTERFACE_MODE_QSGMII:
> > +			mvreg_write(pp, MVNETA_SERDES_CFG,
> > +				    MVNETA_QSGMII_SERDES_PROTO);
> > +			break;
> > +
> > +		case PHY_INTERFACE_MODE_SGMII:
> > +		case PHY_INTERFACE_MODE_1000BASEX:
> > +			mvreg_write(pp, MVNETA_SERDES_CFG,
> > +				    MVNETA_SGMII_SERDES_PROTO);
> > +			break;
> > +		default:
> > +			return -EINVAL;
> 
> I've just noticed that you made changes to the patch I sent, such as
> adding this default case that errors out, and by doing so, you have
> caused a regression by causing a WARN_ON() splat.
> 
> It was not accidental that my patch had "break;" here instead of an
> error return, and I left the interface mode checking in
> mvneta_port_power_up() that you also removed.
> 
> mvneta supports RGMII, and since RGMII doesn't use the serdes, there
> is no need to write to MVNETA_SGMII_SERDES_PROTO, and so we want to
> ignore those, not return -EINVAL.
> 
> Since the interface type was already validated both by phylink when
> the interface is brought up, and also by the driver at probe time
> through mvneta_port_power_up(), which performs early validation of
> the mode given in DT this was not a problem... there is no need to
> consider anything but the RGMII case in the "default" case here.
> 
> So, please fix this... at minimum fixing this switch() statement not
> to error out in the RGMII cases.  However, I think actually following
> what was in my patch (which was there for good reason) rather than
> randomly changing it would have been better.
> 
> This will have made the kernel on the SolidRun Clearfog platform
> trigger the WARN_ON()s for the dedicated gigabit port, which uses
> RGMII, and doesn't have a comphy specified in DT... and having
> waited for the compile to finish and the resulting kernel to boot...

I'll send a fixup shortly

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
