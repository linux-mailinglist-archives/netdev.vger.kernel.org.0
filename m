Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4757D20355E
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgFVLLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbgFVLLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:11:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD0BC061794
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 04:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QrRBbR/bIWz5VTmljTze1tFpkdvYvRE5aw+qlLDLMCE=; b=qjMua3+WpuzUbAhVDiM30Tizm
        u/poGRRr6pRuKSAlkeQ+jzJp2rdcPJ9IIR2D8NHtmhZh3xcUXqCd5tN30kDI3CYvKyLCs+E3MO6DQ
        jBLDbkqxlJpY0nkxIzd7EbFZOvaScO0kyMEV3aygmCzMQfPSvKZXLajmcZz28wiV0e1+zBQLkTHr6
        JpeBUJ++5VXXNEgQm52owPa54Mx5J1bX3KBvsWUUC468I66EVBvQk1KzxyHeFtlhWo5v+iRCAGG8x
        FjS9o0ecdkjWXftdKlaVnurVDOhwMkbt0V9z+fJfWNI+ctMiz5z2qbX7aXXkHPXiRVA0BqUDwJ7oD
        iKNelXNig==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58952)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jnKLq-00005H-Nx; Mon, 22 Jun 2020 12:10:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jnKLp-0008SK-Qj; Mon, 22 Jun 2020 12:10:57 +0100
Date:   Mon, 22 Jun 2020 12:10:57 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        f.fainelli@gmail.com, olteanv@gmail.com
Subject: Re: [PATCH net-next v3 5/9] net: dsa: add support for phylink_pcs_ops
Message-ID: <20200622111057.GM1605@shell.armlinux.org.uk>
References: <20200621225451.12435-1-ioana.ciornei@nxp.com>
 <20200621225451.12435-6-ioana.ciornei@nxp.com>
 <20200622102213.GD1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622102213.GD1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 11:22:13AM +0100, Russell King - ARM Linux admin wrote:
> On Mon, Jun 22, 2020 at 01:54:47AM +0300, Ioana Ciornei wrote:
> > In order to support split PCS using PHYLINK properly, we need to add a
> > phylink_pcs_ops structure.
> > 
> > Note that a DSA driver that wants to use these needs to implement all 4
> > of them: the DSA core checks the presence of these 4 function pointers
> > in dsa_switch_ops and only then does it add a PCS to PHYLINK. This is
> > done in order to preserve compatibility with drivers that have not yet
> > been converted, or don't need, a split PCS setup.
> > 
> > Also, when pcs_get_state() and pcs_an_restart() are present, their mac
> > counterparts (mac_pcs_get_state(), mac_an_restart()) will no longer get
> > called, as can be seen in phylink.c.
> 
> I don't like this at all, it means we've got all this useless layering,
> and that layering will force similar layering veneers into other parts
> of the kernel (such as the DPAA2 MAC driver, when we eventually come to
> re-use pcs-lynx there.)
> 
> I don't think we need that - I think we can get to a position where
> pcs-lynx is called requesting that it bind to phylink as the PCS, and
> it calls phylink_add_pcs() directly, which means we do not end up with
> veneers in DSA nor in the DPAA2 MAC driver - they just need to call
> the pcs-lynx initialisation function with the phylink instance for it
> to attach to.
> 
> Yes, that requires phylink_add_pcs() to change slightly, and for there
> to be a PCS private pointer, as I have previously stated.  At the
> moment, changing that is really easy - the phylink PCS backend has no
> in-tree users at the moment.  So there is no reason not to get this
> correct right now.

How about something like this?  I don't want to embed a mdio_device
inside struct phylink_pcs because that would not be appropriate for
some potential users (e.g., Marvell 88E6xxx DSA drivers, Marvell
NETA, PP2, etc.)

From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next] net: phylink: add struct phylink_pcs

Add a way for MAC PCS to have private data while keeping independence
from struct phylink_config, which is used for the MAC itself. We need
this independence as we will have stand-alone code for PCS that is
independent of the MAC.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 23 +++++++++++++++-------
 include/linux/phylink.h   | 41 ++++++++++++++++++++++++++-------------
 2 files changed, 43 insertions(+), 21 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 7ce787c227b3..37ed7455652a 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -43,6 +43,7 @@ struct phylink {
 	const struct phylink_mac_ops *mac_ops;
 	const struct phylink_pcs_ops *pcs_ops;
 	struct phylink_config *config;
+	struct phylink_pcs *pcs;
 	struct device *dev;
 	unsigned int old_link_state:1;
 
@@ -431,7 +432,7 @@ static void phylink_mac_pcs_an_restart(struct phylink *pl)
 	if (pl->link_config.an_enabled &&
 	    phy_interface_mode_is_8023z(pl->link_config.interface)) {
 		if (pl->pcs_ops)
-			pl->pcs_ops->pcs_an_restart(pl->config);
+			pl->pcs_ops->pcs_an_restart(pl->pcs);
 		else
 			pl->mac_ops->mac_an_restart(pl->config);
 	}
@@ -442,7 +443,7 @@ static void phylink_pcs_config(struct phylink *pl, bool force_restart,
 {
 	bool restart = force_restart;
 
-	if (pl->pcs_ops && pl->pcs_ops->pcs_config(pl->config,
+	if (pl->pcs_ops && pl->pcs_ops->pcs_config(pl->pcs,
 						   pl->cur_link_an_mode,
 						   state->interface,
 						   state->advertising))
@@ -468,7 +469,7 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 	state->link = 1;
 
 	if (pl->pcs_ops)
-		pl->pcs_ops->pcs_get_state(pl->config, state);
+		pl->pcs_ops->pcs_get_state(pl->pcs, state);
 	else
 		pl->mac_ops->mac_pcs_get_state(pl->config, state);
 }
@@ -539,7 +540,7 @@ static void phylink_link_up(struct phylink *pl,
 	pl->cur_interface = link_state.interface;
 
 	if (pl->pcs_ops && pl->pcs_ops->pcs_link_up)
-		pl->pcs_ops->pcs_link_up(pl->config, pl->cur_link_an_mode,
+		pl->pcs_ops->pcs_link_up(pl->pcs, pl->cur_link_an_mode,
 					 pl->cur_interface,
 					 link_state.speed, link_state.duplex);
 
@@ -777,11 +778,19 @@ struct phylink *phylink_create(struct phylink_config *config,
 }
 EXPORT_SYMBOL_GPL(phylink_create);
 
-void phylink_add_pcs(struct phylink *pl, const struct phylink_pcs_ops *ops)
+/**
+ * phylink_set_pcs() - set the current PCS for phylink to use
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ * @pcs: a pointer to the &struct phylink_pcs
+ *
+ * Bind the MAC PCS to phylink.
+ */
+void phylink_set_pcs(struct phylink *pl, const struct phylink_pcs *pcs)
 {
-	pl->pcs_ops = ops;
+	pl->pcs = pcs;
+	pl->pcs_ops = pcs->ops;
 }
-EXPORT_SYMBOL_GPL(phylink_add_pcs);
+EXPORT_SYMBOL_GPL(phylink_set_pcs);
 
 /**
  * phylink_destroy() - cleanup and destroy the phylink instance
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index cc5b452a184e..77e20d48577f 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -273,6 +273,19 @@ void mac_link_up(struct phylink_config *config, struct phy_device *phy,
 		 int speed, int duplex, bool tx_pause, bool rx_pause);
 #endif
 
+struct phylink_pcs_ops;
+
+/**
+ * struct phylink_pcs - PHYLINK PCS instance
+ * @ops: a pointer to the &struct phylink_pcs_ops structure
+ *
+ * This structure is designed to be embedded within the PCS private data,
+ * and will be passed between phylink and the PCS.
+ */
+struct phylink_pcs {
+	const struct phylink_pcs_ops *ops;
+};
+
 /**
  * struct phylink_pcs_ops - MAC PCS operations structure.
  * @pcs_get_state: read the current MAC PCS link state from the hardware.
@@ -282,12 +295,12 @@ void mac_link_up(struct phylink_config *config, struct phy_device *phy,
  *               (where necessary).
  */
 struct phylink_pcs_ops {
-	void (*pcs_get_state)(struct phylink_config *config,
+	void (*pcs_get_state)(struct phylink_pcs *pcs,
 			      struct phylink_link_state *state);
-	int (*pcs_config)(struct phylink_config *config, unsigned int mode,
+	int (*pcs_config)(struct phylink_pcs *pcs, unsigned int mode,
 			  phy_interface_t interface,
 			  const unsigned long *advertising);
-	void (*pcs_an_restart)(struct phylink_config *config);
+	void (*pcs_an_restart)(struct phylink_pcs *pcs);
 	void (*pcs_link_up)(struct phylink_config *config, unsigned int mode,
 			    phy_interface_t interface, int speed, int duplex);
 };
@@ -295,7 +308,7 @@ struct phylink_pcs_ops {
 #if 0 /* For kernel-doc purposes only. */
 /**
  * pcs_get_state() - Read the current inband link state from the hardware
- * @config: a pointer to a &struct phylink_config.
+ * @pcs: a pointer to a &struct phylink_pcs.
  * @state: a pointer to a &struct phylink_link_state.
  *
  * Read the current inband link state from the MAC PCS, reporting the
@@ -308,12 +321,12 @@ struct phylink_pcs_ops {
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
@@ -331,21 +344,21 @@ void pcs_get_state(struct phylink_config *config,
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
@@ -356,14 +369,14 @@ void (*pcs_an_restart)(struct phylink_config *config);
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


-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
