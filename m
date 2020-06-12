Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4621F77A4
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 14:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgFLMGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 08:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgFLMGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 08:06:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C31BC03E96F
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 05:06:07 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jjiRg-00030F-U9; Fri, 12 Jun 2020 14:06:04 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jjiRg-00022U-ES; Fri, 12 Jun 2020 14:06:04 +0200
Date:   Fri, 12 Jun 2020 14:06:04 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH v2] net: mvneta: Fix Serdes configuration for 2.5Gbps
 modes
Message-ID: <20200612120604.GT11869@pengutronix.de>
References: <20200612083847.29942-1-s.hauer@pengutronix.de>
 <20200612084710.GC1551@shell.armlinux.org.uk>
 <20200612100114.GE1551@shell.armlinux.org.uk>
 <20200612101820.GF1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200612101820.GF1551@shell.armlinux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:00:55 up 113 days, 19:31, 128 users,  load average: 0.95, 0.35,
 0.21
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 11:18:20AM +0100, Russell King - ARM Linux admin wrote:
> On Fri, Jun 12, 2020 at 11:01:15AM +0100, Russell King - ARM Linux admin wrote:
> > On Fri, Jun 12, 2020 at 09:47:10AM +0100, Russell King - ARM Linux admin wrote:
> > > On Fri, Jun 12, 2020 at 10:38:47AM +0200, Sascha Hauer wrote:
> > > > The Marvell MVNETA Ethernet controller supports a 2.5Gbps SGMII mode
> > > > called DRSGMII. Depending on the Port MAC Control Register0 PortType
> > > > setting this seems to be either an overclocked SGMII mode or 2500BaseX.
> > > > 
> > > > This patch adds the necessary Serdes Configuration setting for the
> > > > 2.5Gbps modes. There is no phy interface mode define for overclocked
> > > > SGMII, so only 2500BaseX is handled for now.
> > > > 
> > > > As phy_interface_mode_is_8023z() returns true for both
> > > > PHY_INTERFACE_MODE_1000BASEX and PHY_INTERFACE_MODE_2500BASEX we
> > > > explicitly test for 1000BaseX instead of using
> > > > phy_interface_mode_is_8023z() to differentiate the different
> > > > possibilities.
> > > > 
> > > > Fixes: da58a931f248f ("net: mvneta: Add support for 2500Mbps SGMII")
> > > > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > > 
> > > 2500base-X is used today on Armada 388 and Armada 3720 platforms and
> > > works - it is known to interoperate with Marvell PP2.2 hardware, as
> > > well was various SFPs such as the Huawei MA5671A at 2.5Gbps.  The way
> > > it is handled on these platforms is via the COMPHY, requesting that
> > > the serdes is upclocked from 1.25Gbps to 3.125Gbps.
> > > 
> > > This "DRSGMII" mode is not mentioned in the functional specs for either
> > > the Armada 388 or Armada 3720, the value you poke into the register is
> > > not mentioned either.  As I've already requested, some information on
> > > exactly what this "DRSGMII" is would be very useful, it can't be
> > > "double-rate SGMII" because that would give you 2Gbps instead of 1Gbps.
> > > 
> > > So, I suspect this breaks the platforms that are known to work.
> > > 
> > > We need a proper description of what DRSGMII is before we can consider
> > > taking any patches for it.
> > 
> > Okay, having dug through the Armada XP, 370, 388, 3720 specs, I think
> > this is fine after all - but something that will help for the future
> > would be to document that this register does not exist on the 388 and
> > 3720 devices (which brings up the question whether we should be writing
> > it there.)  The field was moved into the comphy on those devices.
> > 
> > So, it looks like if we have a comphy, we should not be writing this
> > register.
> > 
> > What's more, the write to MVNETA_SERDES_CFG should not be in
> > mvneta_port_power_up(); it's likely that XP and 370 will not work
> > properly with phylink.  It needs to be done in a similar location to
> > mvneta_comphy_init(), so that phylink can switch between 1G and 2.5G
> > speeds.
> > 
> > As you have an Armada XP system, you are best placed to test moving
> > that write.
> 
> Here's my suggestion - it won't apply to mainline or net* trees, but
> gives you the idea I'm proposing:
> 

And here is the same patch which applies on master and the net tree.
It works as expected on my Armada XP in 2.5Gbps mode. Provided you are
happy with the patch I can send it as a formal patch on monday if by
then you haven't done that already.

Thanks for your help on that

Sascha

---------------------------------8<------------------------------

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 946925bbcb2de..a1c48efd91b17 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -106,9 +106,11 @@
 #define      MVNETA_TX_IN_PRGRS                  BIT(1)
 #define      MVNETA_TX_FIFO_EMPTY                BIT(8)
 #define MVNETA_RX_MIN_FRAME_SIZE                 0x247c
+/* Only exists on Armada XP and Armada 370 */
 #define MVNETA_SERDES_CFG			 0x24A0
 #define      MVNETA_SGMII_SERDES_PROTO		 0x0cc7
 #define      MVNETA_QSGMII_SERDES_PROTO		 0x0667
+#define      MVNETA_HSGMII_SERDES_PROTO		 0x1107
 #define MVNETA_TYPE_PRIO                         0x24bc
 #define      MVNETA_FORCE_UNI                    BIT(21)
 #define MVNETA_TXQ_CMD_1                         0x24e4
@@ -3533,9 +3535,6 @@ static int mvneta_comphy_init(struct mvneta_port *pp)
 {
 	int ret;
 
-	if (!pp->comphy)
-		return 0;
-
 	ret = phy_set_mode_ext(pp->comphy, PHY_MODE_ETHERNET,
 			       pp->phy_interface);
 	if (ret)
@@ -3544,11 +3543,49 @@ static int mvneta_comphy_init(struct mvneta_port *pp)
 	return phy_power_on(pp->comphy);
 }
 
+static int mvneta_config_interface(struct mvneta_port *pp,
+				   phy_interface_t interface)
+{
+	int ret = 0;
+
+	if (pp->comphy) {
+		if (interface == PHY_INTERFACE_MODE_SGMII ||
+		    interface == PHY_INTERFACE_MODE_1000BASEX ||
+		    interface == PHY_INTERFACE_MODE_2500BASEX) {
+			ret = mvneta_comphy_init(pp);
+		}
+	} else {
+		switch (interface) {
+		case PHY_INTERFACE_MODE_QSGMII:
+			mvreg_write(pp, MVNETA_SERDES_CFG,
+				    MVNETA_QSGMII_SERDES_PROTO);
+			break;
+
+		case PHY_INTERFACE_MODE_SGMII:
+		case PHY_INTERFACE_MODE_1000BASEX:
+			mvreg_write(pp, MVNETA_SERDES_CFG,
+				    MVNETA_SGMII_SERDES_PROTO);
+			break;
+
+		case PHY_INTERFACE_MODE_2500BASEX:
+			mvreg_write(pp, MVNETA_SERDES_CFG,
+				    MVNETA_HSGMII_SERDES_PROTO);
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	pp->phy_interface = interface;
+
+	return ret;
+}
+
 static void mvneta_start_dev(struct mvneta_port *pp)
 {
 	int cpu;
 
-	WARN_ON(mvneta_comphy_init(pp));
+	WARN_ON(mvneta_config_interface(pp, pp->phy_interface));
 
 	mvneta_max_rx_size_set(pp, pp->pkt_size);
 	mvneta_txq_max_tx_size_set(pp, pp->pkt_size);
@@ -3753,7 +3790,7 @@ static void mvneta_validate(struct phylink_config *config,
 	struct mvneta_port *pp = netdev_priv(ndev);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
-	/* We only support QSGMII, SGMII, 802.3z and RGMII modes */
+	/* We only support QSGMII, SGMII, DRSGMII, 802.3z and RGMII modes */
 	if (state->interface != PHY_INTERFACE_MODE_NA &&
 	    state->interface != PHY_INTERFACE_MODE_QSGMII &&
 	    state->interface != PHY_INTERFACE_MODE_SGMII &&
@@ -3926,15 +3963,8 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 	if (state->speed == SPEED_2500)
 		new_ctrl4 |= MVNETA_GMAC4_SHORT_PREAMBLE_ENABLE;
 
-	if (pp->comphy && pp->phy_interface != state->interface &&
-	    (state->interface == PHY_INTERFACE_MODE_SGMII ||
-	     state->interface == PHY_INTERFACE_MODE_1000BASEX ||
-	     state->interface == PHY_INTERFACE_MODE_2500BASEX)) {
-		pp->phy_interface = state->interface;
-
-		WARN_ON(phy_power_off(pp->comphy));
-		WARN_ON(mvneta_comphy_init(pp));
-	}
+	if (pp->phy_interface != state->interface)
+		WARN_ON(mvneta_config_interface(pp, state->interface));
 
 	if (new_ctrl0 != gmac_ctrl0)
 		mvreg_write(pp, MVNETA_GMAC_CTRL_0, new_ctrl0);
@@ -4977,20 +5007,10 @@ static void mvneta_conf_mbus_windows(struct mvneta_port *pp,
 }
 
 /* Power up the port */
-static int mvneta_port_power_up(struct mvneta_port *pp, int phy_mode)
+static void mvneta_port_power_up(struct mvneta_port *pp, int phy_mode)
 {
 	/* MAC Cause register should be cleared */
 	mvreg_write(pp, MVNETA_UNIT_INTR_CAUSE, 0);
-
-	if (phy_mode == PHY_INTERFACE_MODE_QSGMII)
-		mvreg_write(pp, MVNETA_SERDES_CFG, MVNETA_QSGMII_SERDES_PROTO);
-	else if (phy_mode == PHY_INTERFACE_MODE_SGMII ||
-		 phy_interface_mode_is_8023z(phy_mode))
-		mvreg_write(pp, MVNETA_SERDES_CFG, MVNETA_SGMII_SERDES_PROTO);
-	else if (!phy_interface_mode_is_rgmii(phy_mode))
-		return -EINVAL;
-
-	return 0;
 }
 
 /* Device initialization routine */
@@ -5176,11 +5196,7 @@ static int mvneta_probe(struct platform_device *pdev)
 	if (err < 0)
 		goto err_netdev;
 
-	err = mvneta_port_power_up(pp, phy_mode);
-	if (err < 0) {
-		dev_err(&pdev->dev, "can't power up port\n");
-		goto err_netdev;
-	}
+	mvneta_port_power_up(pp, phy_mode);
 
 	/* Armada3700 network controller does not support per-cpu
 	 * operation, so only single NAPI should be initialized.
@@ -5334,11 +5350,7 @@ static int mvneta_resume(struct device *device)
 		}
 	}
 	mvneta_defaults_set(pp);
-	err = mvneta_port_power_up(pp, pp->phy_interface);
-	if (err < 0) {
-		dev_err(device, "can't power up port\n");
-		return err;
-	}
+	mvneta_port_power_up(pp, pp->phy_interface);
 
 	netif_device_attach(dev);
 
-- 
2.27.0

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
