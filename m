Return-Path: <netdev+bounces-9463-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EA7072946E
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:13:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0AC71C2111B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:13:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CD7DDDA6;
	Fri,  9 Jun 2023 09:13:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C78AD2F6
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:13:09 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5A749D0
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=LLQKmy4bmksb7Y7NWOCvDE2tfQhfMuSULlMomvJiH2Y=; b=pJ6awy9NrZen2p5vHjfiVY97Pf
	i8S5PJq6rSJh2QtrDcXkXZXu1D2OOu55iKR75u9NP9ErnrGVTfXkNGSfNGtL1GhqUN+3uoTpvW0IH
	kAGP9unFBwgxhoQAjIKrmVARZogYwFqXJqWRz33ZC+3VfnXpLTwlQxc50xAW340gAOFoYV2Chhlc1
	JPUdIGP12rbJCsIFHt156hKY4R/+7Robn2ssIstmQJP6kd9lh+aXYkfDMRyYWjv0F31sFP2mQj1uP
	iGSI9Lz0GXWDtQwGVQZIaDA8EL6hEm6fitG9nPeyYW9UNFbfOXom99lBRYgsdEz/j9v0FudDnerXr
	YTpD4pAA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:48142 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q7Y9S-0001ja-35; Fri, 09 Jun 2023 10:11:22 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q7Y9R-00DI8g-GF; Fri, 09 Jun 2023 10:11:21 +0100
In-Reply-To: <ZILsqV0gkSMMdinU@shell.armlinux.org.uk>
References: <ZILsqV0gkSMMdinU@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Marcin Wojtas <mw@semihalf.com>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH RFC net-next 2/4] net: phylink: add EEE management
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q7Y9R-00DI8g-GF@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 09 Jun 2023 10:11:21 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add EEE management to phylink.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 82 ++++++++++++++++++++++++++++++++++++---
 include/linux/phylink.h   | 32 +++++++++++++++
 2 files changed, 109 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 1ae7868d2137..d0abae91ceb5 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -80,6 +80,9 @@ struct phylink {
 	DECLARE_PHY_INTERFACE_MASK(sfp_interfaces);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(sfp_support);
 	u8 sfp_port;
+
+	struct eee_config eee_cfg;
+	bool eee_active;
 };
 
 #define phylink_printk(level, pl, fmt, ...) \
@@ -1253,6 +1256,24 @@ static const char *phylink_pause_to_str(int pause)
 	}
 }
 
+static void phylink_disable_tx_lpi(struct phylink *pl)
+{
+	if (pl->mac_ops->mac_disable_tx_lpi)
+		pl->mac_ops->mac_disable_tx_lpi(pl->config);
+}
+
+static void phylink_enable_tx_lpi(struct phylink *pl)
+{
+	if (pl->mac_ops->mac_enable_tx_lpi)
+		pl->mac_ops->mac_enable_tx_lpi(pl->config,
+					       pl->eee_cfg.tx_lpi_timer);
+}
+
+static bool phylink_eee_is_active(struct phylink *pl)
+{
+	return phylink_init_eee(pl, pl->config->eee_clk_stop_enable) >= 0;
+}
+
 static void phylink_link_up(struct phylink *pl,
 			    struct phylink_link_state link_state)
 {
@@ -1294,6 +1315,12 @@ static void phylink_link_up(struct phylink *pl,
 				 pl->cur_interface, speed, duplex,
 				 !!(link_state.pause & MLO_PAUSE_TX), rx_pause);
 
+	if (eeecfg_mac_can_tx_lpi(&pl->eee_cfg)) {
+		pl->eee_active = phylink_eee_is_active(pl);
+		if (pl->eee_active)
+			phylink_enable_tx_lpi(pl);
+	}
+
 	if (ndev)
 		netif_carrier_on(ndev);
 
@@ -1310,25 +1337,32 @@ static void phylink_link_down(struct phylink *pl)
 
 	if (ndev)
 		netif_carrier_off(ndev);
+
+	if (eeecfg_mac_can_tx_lpi(&pl->eee_cfg) && pl->eee_active) {
+		pl->eee_active = false;
+		phylink_disable_tx_lpi(pl);
+	}
+
 	pl->mac_ops->mac_link_down(pl->config, pl->cur_link_an_mode,
 				   pl->cur_interface);
 	phylink_info(pl, "Link is Down\n");
 }
 
+static bool phylink_link_is_up(struct phylink *pl)
+{
+	return pl->netdev ? netif_carrier_ok(pl->netdev) : pl->old_link_state;
+}
+
 static void phylink_resolve(struct work_struct *w)
 {
 	struct phylink *pl = container_of(w, struct phylink, resolve);
 	struct phylink_link_state link_state;
-	struct net_device *ndev = pl->netdev;
 	bool mac_config = false;
 	bool retrigger = false;
 	bool cur_link_state;
 
 	mutex_lock(&pl->state_mutex);
-	if (pl->netdev)
-		cur_link_state = netif_carrier_ok(ndev);
-	else
-		cur_link_state = pl->old_link_state;
+	cur_link_state = phylink_link_is_up(pl);
 
 	if (pl->phylink_disable_state) {
 		pl->mac_link_dropped = false;
@@ -1571,6 +1605,9 @@ struct phylink *phylink_create(struct phylink_config *config,
 	linkmode_copy(pl->link_config.advertising, pl->supported);
 	phylink_validate(pl, pl->supported, &pl->link_config);
 
+	/* Set the default EEE configuration */
+	pl->eee_cfg = pl->config->eee;
+
 	ret = phylink_parse_mode(pl, fwnode);
 	if (ret < 0) {
 		kfree(pl);
@@ -2589,6 +2626,12 @@ int phylink_ethtool_get_eee(struct phylink *pl, struct ethtool_eee *eee)
 	if (pl->phydev)
 		ret = phy_ethtool_get_eee(pl->phydev, eee);
 
+	if (!ret) {
+		/* Overwrite phylib's interpretation of configuration */
+		eeecfg_to_eee(&pl->eee_cfg, eee);
+		eee->eee_active = pl->eee_active;
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(phylink_ethtool_get_eee);
@@ -2607,6 +2650,35 @@ int phylink_ethtool_set_eee(struct phylink *pl, struct ethtool_eee *eee)
 	if (pl->phydev)
 		ret = phy_ethtool_set_eee(pl->phydev, eee);
 
+	if (!ret) {
+		bool can_lpi, old_can_lpi;
+
+		mutex_lock(&pl->state_mutex);
+		old_can_lpi = eeecfg_mac_can_tx_lpi(&pl->eee_cfg);
+		eee_to_eeecfg(eee, &pl->eee_cfg);
+		can_lpi = eeecfg_mac_can_tx_lpi(&pl->eee_cfg);
+
+		/* IF the link is up, and the configuration changes the
+		 * LPI permissive state, deal with the change at the MAC.
+		 */
+		if (phylink_link_is_up(pl) && old_can_lpi != can_lpi) {
+			if (can_lpi) {
+				/* If LPI wasn't enabled, eee_active (result
+				 * of any AN) will be false. Update it here.
+				 * If the advertisement has been changed, the
+				 * link will cycle which will update this.
+				 */
+				pl->eee_active = phylink_eee_is_active(pl);
+				if (pl->eee_active)
+					phylink_enable_tx_lpi(pl);
+			} else {
+				phylink_disable_tx_lpi(pl);
+			}
+		}
+
+		mutex_unlock(&pl->state_mutex);
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(phylink_ethtool_set_eee);
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 0cf07d7d11b8..6328a9f481ee 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -5,6 +5,8 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 
+#include <net/eee.h>
+
 struct device_node;
 struct ethtool_cmd;
 struct fwnode_handle;
@@ -122,11 +124,13 @@ enum phylink_op_type {
  *		      if MAC link is at %MLO_AN_FIXED mode.
  * @mac_managed_pm: if true, indicate the MAC driver is responsible for PHY PM.
  * @ovr_an_inband: if true, override PCS to MLO_AN_INBAND
+ * @eee_clk_stop_enable: if true, PHY can stop the receive clock during LPI
  * @get_fixed_state: callback to execute to determine the fixed link state,
  *		     if MAC link is at %MLO_AN_FIXED mode.
  * @supported_interfaces: bitmap describing which PHY_INTERFACE_MODE_xxx
  *                        are supported by the MAC/PCS.
  * @mac_capabilities: MAC pause/speed/duplex capabilities.
+ * @eee: default EEE configuration.
  */
 struct phylink_config {
 	struct device *dev;
@@ -135,10 +139,12 @@ struct phylink_config {
 	bool poll_fixed_state;
 	bool mac_managed_pm;
 	bool ovr_an_inband;
+	bool eee_clk_stop_enable;
 	void (*get_fixed_state)(struct phylink_config *config,
 				struct phylink_link_state *state);
 	DECLARE_PHY_INTERFACE_MASK(supported_interfaces);
 	unsigned long mac_capabilities;
+	struct eee_config eee;
 };
 
 /**
@@ -152,6 +158,8 @@ struct phylink_config {
  * @mac_an_restart: restart 802.3z BaseX autonegotiation.
  * @mac_link_down: take the link down.
  * @mac_link_up: allow the link to come up.
+ * @mac_disable_tx_lpi: disable LPI.
+ * @mac_enable_tx_lpi: enable and configure LPI.
  *
  * The individual methods are described more fully below.
  */
@@ -176,6 +184,8 @@ struct phylink_mac_ops {
 			    struct phy_device *phy, unsigned int mode,
 			    phy_interface_t interface, int speed, int duplex,
 			    bool tx_pause, bool rx_pause);
+	void (*mac_disable_tx_lpi)(struct phylink_config *config);
+	void (*mac_enable_tx_lpi)(struct phylink_config *config, u32 timer);
 };
 
 #if 0 /* For kernel-doc purposes only. */
@@ -429,6 +439,28 @@ void mac_link_down(struct phylink_config *config, unsigned int mode,
 void mac_link_up(struct phylink_config *config, struct phy_device *phy,
 		 unsigned int mode, phy_interface_t interface,
 		 int speed, int duplex, bool tx_pause, bool rx_pause);
+
+/**
+ * mac_disable_tx_lpi() - disable LPI generation at the MAC
+ * @config: a pointer to a &struct phylink_config.
+ *
+ * Disable generation of LPI at the MAC, effectively preventing the MAC
+ * from indicating that it is idle.
+ */
+void mac_disable_tx_lpi(struct phylink_config *config);
+
+/**
+ * mac_enable_tx_lpi() - configure and enable LPI generation at the MAC
+ * @config: a pointer to a &struct phylink_config.
+ * @timer: LPI timeout in microseconds.
+ *
+ * Configure the LPI timeout accordingly. This will only be called when
+ * the link is already up, to cater for situations where the hardware
+ * needs to be programmed according to the link speed.
+ *
+ * Enable LPI generation at the MAC.
+ */
+void mac_enable_tx_lpi(struct phylink_config *config, u32 timer);
 #endif
 
 struct phylink_pcs_ops;
-- 
2.30.2


