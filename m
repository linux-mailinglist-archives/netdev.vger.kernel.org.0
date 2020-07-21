Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFA1227E0D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 13:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbgGULEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 07:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgGULEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 07:04:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5235AC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 04:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vOZkzUcCTRKiHZNE0EW9LP9E59nQ11d9h689wF1ZCnw=; b=isBioV942/fD6/UPl5b1dB+DW6
        3e88KNiCL6ZI4JMYozQGsMsL0PxNsF9mecp9uOnzT97TrOvKxGqUbSHnGISYoQljMNchG9uPz+tkG
        shojSvLJvd4rihdMLii5AB4ZTFoxoctxBZURdOFo4dOKejhAPhYqkU9bW0U+VHzA2fUkVAosQU3WI
        R4MHjtYRCN4P02zoAlKkNXLQmAa11mWYSUat8M1ARAIWY+fTsrbAtoQA0v8mnOIhuj0HUXqbNQnmZ
        ZFxdNz85p/77XYo9WWBIwb2ukjCkx/ZKrpAb82tQ8+1ozjdUsEnKR/+Vb/iAsLELhXdeHDpuYOt6K
        xOtDcquA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41782 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq4k-0004H7-V4; Tue, 21 Jul 2020 12:04:46 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq4k-0004TQ-Nr; Tue, 21 Jul 2020 12:04:46 +0100
In-Reply-To: <20200721110152.GY1551@shell.armlinux.org.uk>
References: <20200721110152.GY1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 13/14] net: phylink: add struct phylink_pcs
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jxq4k-0004TQ-Nr@rmk-PC.armlinux.org.uk>
Date:   Tue, 21 Jul 2020 12:04:46 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a way for MAC PCS to have private data while keeping independence
from struct phylink_config, which is used for the MAC itself. We need
this independence as we will have stand-alone code for PCS that is
independent of the MAC.  Introduce struct phylink_pcs, which is
designed to be embedded in a driver private data structure.

This structure does not include a mdio_device as there are PCS
implementations such as the Marvell DSA and network drivers where this
is not necessary.

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 34 ++++++++++++++++++++++-------
 include/linux/phylink.h   | 45 ++++++++++++++++++++++++++-------------
 2 files changed, 56 insertions(+), 23 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index d554a0fbb4f3..b57cd2142786 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -43,6 +43,7 @@ struct phylink {
 	const struct phylink_mac_ops *mac_ops;
 	const struct phylink_pcs_ops *pcs_ops;
 	struct phylink_config *config;
+	struct phylink_pcs *pcs;
 	struct device *dev;
 	unsigned int old_link_state:1;
 
@@ -427,7 +428,7 @@ static void phylink_mac_pcs_an_restart(struct phylink *pl)
 	    phy_interface_mode_is_8023z(pl->link_config.interface) &&
 	    phylink_autoneg_inband(pl->cur_link_an_mode)) {
 		if (pl->pcs_ops)
-			pl->pcs_ops->pcs_an_restart(pl->config);
+			pl->pcs_ops->pcs_an_restart(pl->pcs);
 		else
 			pl->mac_ops->mac_an_restart(pl->config);
 	}
@@ -453,7 +454,7 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 	phylink_mac_config(pl, state);
 
 	if (pl->pcs_ops) {
-		err = pl->pcs_ops->pcs_config(pl->config, pl->cur_link_an_mode,
+		err = pl->pcs_ops->pcs_config(pl->pcs, pl->cur_link_an_mode,
 					      state->interface,
 					      state->advertising,
 					      !!(pl->link_config.pause &
@@ -506,7 +507,7 @@ static int phylink_change_inband_advert(struct phylink *pl)
 	 * restart negotiation if the pcs_config() helper indicates that
 	 * the programmed advertisement has changed.
 	 */
-	ret = pl->pcs_ops->pcs_config(pl->config, pl->cur_link_an_mode,
+	ret = pl->pcs_ops->pcs_config(pl->pcs, pl->cur_link_an_mode,
 				      pl->link_config.interface,
 				      pl->link_config.advertising,
 				      !!(pl->link_config.pause & MLO_PAUSE_AN));
@@ -533,7 +534,7 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 	state->link = 1;
 
 	if (pl->pcs_ops)
-		pl->pcs_ops->pcs_get_state(pl->config, state);
+		pl->pcs_ops->pcs_get_state(pl->pcs, state);
 	else
 		pl->mac_ops->mac_pcs_get_state(pl->config, state);
 }
@@ -604,7 +605,7 @@ static void phylink_link_up(struct phylink *pl,
 	pl->cur_interface = link_state.interface;
 
 	if (pl->pcs_ops && pl->pcs_ops->pcs_link_up)
-		pl->pcs_ops->pcs_link_up(pl->config, pl->cur_link_an_mode,
+		pl->pcs_ops->pcs_link_up(pl->pcs, pl->cur_link_an_mode,
 					 pl->cur_interface,
 					 link_state.speed, link_state.duplex);
 
@@ -863,11 +864,26 @@ struct phylink *phylink_create(struct phylink_config *config,
 }
 EXPORT_SYMBOL_GPL(phylink_create);
 
-void phylink_add_pcs(struct phylink *pl, const struct phylink_pcs_ops *ops)
+/**
+ * phylink_set_pcs() - set the current PCS for phylink to use
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ * @pcs: a pointer to the &struct phylink_pcs
+ *
+ * Bind the MAC PCS to phylink.  This may be called after phylink_create(),
+ * in mac_prepare() or mac_config() methods if it is desired to dynamically
+ * change the PCS.
+ *
+ * Please note that there are behavioural changes with the mac_config()
+ * callback if a PCS is present (denoting a newer setup) so removing a PCS
+ * is not supported, and if a PCS is going to be used, it must be registered
+ * by calling phylink_set_pcs() at the latest in the first mac_config() call.
+ */
+void phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs)
 {
-	pl->pcs_ops = ops;
+	pl->pcs = pcs;
+	pl->pcs_ops = pcs->ops;
 }
-EXPORT_SYMBOL_GPL(phylink_add_pcs);
+EXPORT_SYMBOL_GPL(phylink_set_pcs);
 
 /**
  * phylink_destroy() - cleanup and destroy the phylink instance
@@ -1212,6 +1228,8 @@ void phylink_start(struct phylink *pl)
 		break;
 	case MLO_AN_INBAND:
 		poll |= pl->config->pcs_poll;
+		if (pl->pcs)
+			poll |= pl->pcs->poll;
 		break;
 	}
 	if (poll)
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 2f1315f32113..057f78263a46 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -321,6 +321,21 @@ void mac_link_up(struct phylink_config *config, struct phy_device *phy,
 		 int speed, int duplex, bool tx_pause, bool rx_pause);
 #endif
 
+struct phylink_pcs_ops;
+
+/**
+ * struct phylink_pcs - PHYLINK PCS instance
+ * @ops: a pointer to the &struct phylink_pcs_ops structure
+ * @poll: poll the PCS for link changes
+ *
+ * This structure is designed to be embedded within the PCS private data,
+ * and will be passed between phylink and the PCS.
+ */
+struct phylink_pcs {
+	const struct phylink_pcs_ops *ops;
+	bool poll;
+};
+
 /**
  * struct phylink_pcs_ops - MAC PCS operations structure.
  * @pcs_get_state: read the current MAC PCS link state from the hardware.
@@ -330,21 +345,21 @@ void mac_link_up(struct phylink_config *config, struct phy_device *phy,
  *               (where necessary).
  */
 struct phylink_pcs_ops {
-	void (*pcs_get_state)(struct phylink_config *config,
+	void (*pcs_get_state)(struct phylink_pcs *pcs,
 			      struct phylink_link_state *state);
-	int (*pcs_config)(struct phylink_config *config, unsigned int mode,
+	int (*pcs_config)(struct phylink_pcs *pcs, unsigned int mode,
 			  phy_interface_t interface,
 			  const unsigned long *advertising,
 			  bool permit_pause_to_mac);
-	void (*pcs_an_restart)(struct phylink_config *config);
-	void (*pcs_link_up)(struct phylink_config *config, unsigned int mode,
+	void (*pcs_an_restart)(struct phylink_pcs *pcs);
+	void (*pcs_link_up)(struct phylink_pcs *pcs, unsigned int mode,
 			    phy_interface_t interface, int speed, int duplex);
 };
 
 #if 0 /* For kernel-doc purposes only. */
 /**
  * pcs_get_state() - Read the current inband link state from the hardware
- * @config: a pointer to a &struct phylink_config.
+ * @pcs: a pointer to a &struct phylink_pcs.
  * @state: a pointer to a &struct phylink_link_state.
  *
  * Read the current inband link state from the MAC PCS, reporting the
@@ -357,12 +372,12 @@ struct phylink_pcs_ops {
  * When present, this overrides mac_pcs_get_state() in &struct
  * phylink_mac_ops.
  */
-void pcs_get_state(struct phylink_config *config,
+void pcs_get_state(struct phylink_pcs *pcs,
 		   struct phylink_link_state *state);
 
 /**
  * pcs_config() - Configure the PCS mode and advertisement
- * @config: a pointer to a &struct phylink_config.
+ * @pcs: a pointer to a &struct phylink_pcs.
  * @mode: one of %MLO_AN_FIXED, %MLO_AN_PHY, %MLO_AN_INBAND.
  * @interface: interface mode to be used
  * @advertising: adertisement ethtool link mode mask
@@ -382,21 +397,21 @@ void pcs_get_state(struct phylink_config *config,
  *
  * For most 10GBASE-R, there is no advertisement.
  */
-int (*pcs_config)(struct phylink_config *config, unsigned int mode,
-		  phy_interface_t interface, const unsigned long *advertising);
+int pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+	       phy_interface_t interface, const unsigned long *advertising);
 
 /**
  * pcs_an_restart() - restart 802.3z BaseX autonegotiation
- * @config: a pointer to a &struct phylink_config.
+ * @pcs: a pointer to a &struct phylink_pcs.
  *
  * When PCS ops are present, this overrides mac_an_restart() in &struct
  * phylink_mac_ops.
  */
-void (*pcs_an_restart)(struct phylink_config *config);
+void pcs_an_restart(struct phylink_pcs *pcs);
 
 /**
  * pcs_link_up() - program the PCS for the resolved link configuration
- * @config: a pointer to a &struct phylink_config.
+ * @pcs: a pointer to a &struct phylink_pcs.
  * @mode: link autonegotiation mode
  * @interface: link &typedef phy_interface_t mode
  * @speed: link speed
@@ -407,14 +422,14 @@ void (*pcs_an_restart)(struct phylink_config *config);
  * mode without in-band AN needs to be manually configured for the link
  * and duplex setting. Otherwise, this should be a no-op.
  */
-void (*pcs_link_up)(struct phylink_config *config, unsigned int mode,
-		    phy_interface_t interface, int speed, int duplex);
+void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
+		 phy_interface_t interface, int speed, int duplex);
 #endif
 
 struct phylink *phylink_create(struct phylink_config *, struct fwnode_handle *,
 			       phy_interface_t iface,
 			       const struct phylink_mac_ops *mac_ops);
-void phylink_add_pcs(struct phylink *, const struct phylink_pcs_ops *ops);
+void phylink_set_pcs(struct phylink *, struct phylink_pcs *pcs);
 void phylink_destroy(struct phylink *);
 
 int phylink_connect_phy(struct phylink *, struct phy_device *);
-- 
2.20.1

