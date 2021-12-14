Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31E6474581
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbhLNOsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbhLNOsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 09:48:09 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8002AC061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 06:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dknd3D5Z+mwljsg7PsDvhyICALIQjYgxwdx6nR1QZaM=; b=uqxGTUKboG8wIwaSDaAPfnMLAX
        hmo3Dwrmx7tWR0S5NExgOMOow0wo61De/Fn2vmd8rSCQ3zzyc04mUkyhPfpPPGbMuRRTF6D18g/e2
        F7GFvQil3W5xiHT+3KDw4XeA//2Ks+QVFROF0Jy804qf4SyBhuBZIpREYmt4a7kZ7038IOWZ3uiKd
        6Wd3YMxf47V9/kXtLRcafLLm0LazGwHDaEggw/Mp0Fc5h3GUmue/f/k74w0MWvzAS8sU3Sti77Ues
        8tcdKZk/hi/MbWuQpRf3dXE4yNjbfqyTcrw+yOAd58mJ0IE/6MHaQsiZTDmwSCQ0TbSxVrUoeDcqO
        QS2Hq7Dw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60478 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mx965-000548-OS; Tue, 14 Dec 2021 14:48:05 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mx965-00GCd9-Ao; Tue, 14 Dec 2021 14:48:05 +0000
In-Reply-To: <Ybiue1TPCwsdHmV4@shell.armlinux.org.uk>
References: <Ybiue1TPCwsdHmV4@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH net-next 1/7] net: phylink: add mac_select_pcs() method to
 phylink_mac_ops
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mx965-00GCd9-Ao@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 14 Dec 2021 14:48:05 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mac_select_pcs() allows us to have an explicit point to query which
PCS the MAC wishes to use for a particular PHY interface mode, thereby
allowing us to add support to validate the link settings with the PCS.

Phylink will also use this to select the PCS to be used during a major
configuration event without the MAC driver needing to call
phylink_set_pcs().

Note that if mac_select_pcs() is present, the supported_interfaces
bitmap must be filled in; this avoids mac_select_pcs() being called
with PHY_INTERFACE_MODE_NA when we want to get support for all
interface types. Phylink will return an error in phylink_create()
unless this condition is satisfied.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 68 +++++++++++++++++++++++++++++++++------
 include/linux/phylink.h   | 18 +++++++++++
 2 files changed, 77 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 20df8af3e201..c7035d65e159 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -419,6 +419,23 @@ void phylink_generic_validate(struct phylink_config *config,
 }
 EXPORT_SYMBOL_GPL(phylink_generic_validate);
 
+static int phylink_validate_mac_and_pcs(struct phylink *pl,
+					unsigned long *supported,
+					struct phylink_link_state *state)
+{
+	struct phylink_pcs *pcs;
+
+	if (pl->mac_ops->mac_select_pcs) {
+		pcs = pl->mac_ops->mac_select_pcs(pl->config, state->interface);
+		if (IS_ERR(pcs))
+			return PTR_ERR(pcs);
+	}
+
+	pl->mac_ops->validate(pl->config, supported, state);
+
+	return phylink_is_empty_linkmode(supported) ? -EINVAL : 0;
+}
+
 static int phylink_validate_any(struct phylink *pl, unsigned long *supported,
 				struct phylink_link_state *state)
 {
@@ -434,9 +451,10 @@ static int phylink_validate_any(struct phylink *pl, unsigned long *supported,
 
 			t = *state;
 			t.interface = intf;
-			pl->mac_ops->validate(pl->config, s, &t);
-			linkmode_or(all_s, all_s, s);
-			linkmode_or(all_adv, all_adv, t.advertising);
+			if (!phylink_validate_mac_and_pcs(pl, s, &t)) {
+				linkmode_or(all_s, all_s, s);
+				linkmode_or(all_adv, all_adv, t.advertising);
+			}
 		}
 	}
 
@@ -458,9 +476,7 @@ static int phylink_validate(struct phylink *pl, unsigned long *supported,
 			return -EINVAL;
 	}
 
-	pl->mac_ops->validate(pl->config, supported, state);
-
-	return phylink_is_empty_linkmode(supported) ? -EINVAL : 0;
+	return phylink_validate_mac_and_pcs(pl, supported, state);
 }
 
 static int phylink_parse_fixedlink(struct phylink *pl,
@@ -750,10 +766,21 @@ static void phylink_mac_pcs_an_restart(struct phylink *pl)
 static void phylink_major_config(struct phylink *pl, bool restart,
 				  const struct phylink_link_state *state)
 {
+	struct phylink_pcs *pcs = NULL;
 	int err;
 
 	phylink_dbg(pl, "major config %s\n", phy_modes(state->interface));
 
+	if (pl->mac_ops->mac_select_pcs) {
+		pcs = pl->mac_ops->mac_select_pcs(pl->config, state->interface);
+		if (IS_ERR(pcs)) {
+			phylink_err(pl,
+				    "mac_select_pcs unexpectedly failed: %pe\n",
+				    pcs);
+			return;
+		}
+	}
+
 	if (pl->mac_ops->mac_prepare) {
 		err = pl->mac_ops->mac_prepare(pl->config, pl->cur_link_an_mode,
 					       state->interface);
@@ -764,6 +791,12 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 		}
 	}
 
+	/* If we have a new PCS, switch to the new PCS after preparing the MAC
+	 * for the change.
+	 */
+	if (pcs)
+		phylink_set_pcs(pl, pcs);
+
 	phylink_mac_config(pl, state);
 
 	if (pl->pcs_ops) {
@@ -1155,6 +1188,14 @@ struct phylink *phylink_create(struct phylink_config *config,
 	struct phylink *pl;
 	int ret;
 
+	/* Validate the supplied configuration */
+	if (mac_ops->mac_select_pcs &&
+	    phy_interface_empty(config->supported_interfaces)) {
+		dev_err(config->dev,
+			"phylink: error: empty supported_interfaces but mac_select_pcs() method present\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	pl = kzalloc(sizeof(*pl), GFP_KERNEL);
 	if (!pl)
 		return ERR_PTR(-ENOMEM);
@@ -1222,9 +1263,10 @@ EXPORT_SYMBOL_GPL(phylink_create);
  * @pl: a pointer to a &struct phylink returned from phylink_create()
  * @pcs: a pointer to the &struct phylink_pcs
  *
- * Bind the MAC PCS to phylink.  This may be called after phylink_create(),
- * in mac_prepare() or mac_config() methods if it is desired to dynamically
- * change the PCS.
+ * Bind the MAC PCS to phylink.  This may be called after phylink_create().
+ * If it is desired to dynamically change the PCS, then the preferred method
+ * is to use mac_select_pcs(), but it may also be called in mac_prepare()
+ * or mac_config().
  *
  * Please note that there are behavioural changes with the mac_config()
  * callback if a PCS is present (denoting a newer setup) so removing a PCS
@@ -1235,6 +1277,14 @@ void phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs)
 {
 	pl->pcs = pcs;
 	pl->pcs_ops = pcs->ops;
+
+	if (!pl->phylink_disable_state &&
+	    pl->cfg_link_an_mode == MLO_AN_INBAND) {
+		if (pl->config->pcs_poll || pcs->poll)
+			mod_timer(&pl->link_poll, jiffies + HZ);
+		else
+			del_timer(&pl->link_poll);
+	}
 }
 EXPORT_SYMBOL_GPL(phylink_set_pcs);
 
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index a2f266cc3442..f44b33cddc4d 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -112,6 +112,7 @@ struct phylink_config {
 /**
  * struct phylink_mac_ops - MAC operations structure.
  * @validate: Validate and update the link configuration.
+ * @mac_select_pcs: Select a PCS for the interface mode.
  * @mac_pcs_get_state: Read the current link state from the hardware.
  * @mac_prepare: prepare for a major reconfiguration of the interface.
  * @mac_config: configure the MAC for the selected mode and state.
@@ -126,6 +127,8 @@ struct phylink_mac_ops {
 	void (*validate)(struct phylink_config *config,
 			 unsigned long *supported,
 			 struct phylink_link_state *state);
+	struct phylink_pcs *(*mac_select_pcs)(struct phylink_config *config,
+					      phy_interface_t interface);
 	void (*mac_pcs_get_state)(struct phylink_config *config,
 				  struct phylink_link_state *state);
 	int (*mac_prepare)(struct phylink_config *config, unsigned int mode,
@@ -178,6 +181,21 @@ struct phylink_mac_ops {
  */
 void validate(struct phylink_config *config, unsigned long *supported,
 	      struct phylink_link_state *state);
+/**
+ * @mac_select_pcs: Select a PCS for the interface mode.
+ * @config: a pointer to a &struct phylink_config.
+ * @interface: PHY interface mode for PCS
+ *
+ * Return the &struct phylink_pcs for the specified interface mode, or
+ * NULL if none is required, or an error pointer on error.
+ *
+ * This must not modify any state. It is used to query which PCS should
+ * be used. Phylink will use this during validation to ensure that the
+ * configuration is valid, and when setting a configuration to internally
+ * set the PCS that will be used.
+ */
+struct phylink_pcs *mac_select_pcs(struct phylink_config *config,
+				   phy_interface_t interface);
 
 /**
  * mac_pcs_get_state() - Read the current inband link state from the hardware
-- 
2.30.2

