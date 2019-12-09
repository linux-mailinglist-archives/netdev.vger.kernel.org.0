Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89DD6116E8C
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 15:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbfLIOHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 09:07:18 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34274 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727720AbfLIOHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 09:07:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gHDDCO4pR2psGyN6LkoA/FVbIJza3uq12Dy+w5GLUjo=; b=vsbvo24Awv2f6Ouarf90LiSo0I
        KOam4YhQZa/AidKSz9MFf8A/VXcfnOMqlqE4GFUSMlj31fZ6AFCKHa9J36A9rfj2X5xlPhBiN8GsS
        vGl/8QPW5bdlib3b7kUYNJGrpI1o37vnHZVAuYzyOa+88v0saID/WcuBUon6pINvRdLEdV3Y9TMjk
        l4Z425Yq+CFuM0dNMRY+PaSUwDvHwg3AVuWyoR5TVXrRuTbzncvMjNyJvuSl/UdiGEmhr6m6PTEcB
        5l5MF3M+Vzb+R+z4Fkn/AEHoVUrv3ZYEjDM4/Qjlg+MzIilSFd48IpMm62/XgPwqxksdUJXQDuJ8K
        I0FeJxtA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54410 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieJgl-0003Pq-Pf; Mon, 09 Dec 2019 14:07:03 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieJgj-0004OY-Eu; Mon, 09 Dec 2019 14:07:01 +0000
In-Reply-To: <20191209140258.GI25745@shell.armlinux.org.uk>
References: <20191209140258.GI25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 04/14] net: sfp: add module start/stop upstream
 notifications
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ieJgj-0004OY-Eu@rmk-PC.armlinux.org.uk>
Date:   Mon, 09 Dec 2019 14:07:01 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When dealing with some copper modules, we can't positively know the
module capabilities are until we have probed the PHY. Without the full
capabilities, we may end up failing a module that we could otherwise
drive with a restricted set of capabilities.

An example of this would be a module with a NBASE-T PHY plugged into
a host that supports phy interface modes 2500BASE-X and SGMII. The
PHY supports 10GBASE-R, 5000BASE-X, 2500BASE-X, SGMII interface modes,
which means a subset of the capabilities are compatible with the host.

However, reading the module EEPROM leads us to believe that the module
only supports ethtool link mode 10GBASE-T, which is incompatible with
the host - and thus results in the module being rejected.

This patch adds an extra notification which are triggered after the
SFP module's PHY probe, and a corresponding notification just before
the PHY is removed.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp-bus.c | 21 +++++++++++++++++++++
 drivers/net/phy/sfp.c     |  8 ++++++++
 drivers/net/phy/sfp.h     |  2 ++
 include/linux/sfp.h       |  4 ++++
 4 files changed, 35 insertions(+)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index c6627f1e5d68..eabc9e3f0a9e 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -712,6 +712,27 @@ void sfp_module_remove(struct sfp_bus *bus)
 }
 EXPORT_SYMBOL_GPL(sfp_module_remove);
 
+int sfp_module_start(struct sfp_bus *bus)
+{
+	const struct sfp_upstream_ops *ops = sfp_get_upstream_ops(bus);
+	int ret = 0;
+
+	if (ops && ops->module_start)
+		ret = ops->module_start(bus->upstream);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sfp_module_start);
+
+void sfp_module_stop(struct sfp_bus *bus)
+{
+	const struct sfp_upstream_ops *ops = sfp_get_upstream_ops(bus);
+
+	if (ops && ops->module_stop)
+		ops->module_stop(bus->upstream);
+}
+EXPORT_SYMBOL_GPL(sfp_module_stop);
+
 static void sfp_socket_clear(struct sfp_bus *bus)
 {
 	bus->sfp_dev = NULL;
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index ad3808307dba..23f30dac0f17 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -59,6 +59,7 @@ enum {
 	SFP_DEV_UP,
 
 	SFP_S_DOWN = 0,
+	SFP_S_FAIL,
 	SFP_S_WAIT,
 	SFP_S_INIT,
 	SFP_S_INIT_TX_FAULT,
@@ -122,6 +123,7 @@ static const char *event_to_str(unsigned short event)
 
 static const char * const sm_state_strings[] = {
 	[SFP_S_DOWN] = "down",
+	[SFP_S_FAIL] = "fail",
 	[SFP_S_WAIT] = "wait",
 	[SFP_S_INIT] = "init",
 	[SFP_S_INIT_TX_FAULT] = "init_tx_fault",
@@ -1826,6 +1828,8 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 		if (sfp->sm_state == SFP_S_LINK_UP &&
 		    sfp->sm_dev_state == SFP_DEV_UP)
 			sfp_sm_link_down(sfp);
+		if (sfp->sm_state > SFP_S_INIT)
+			sfp_module_stop(sfp->sfp_bus);
 		if (sfp->mod_phy)
 			sfp_sm_phy_detach(sfp);
 		sfp_module_tx_disable(sfp);
@@ -1893,6 +1897,10 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 			 * clear.  Probe for the PHY and check the LOS state.
 			 */
 			sfp_sm_probe_for_phy(sfp);
+			if (sfp_module_start(sfp->sfp_bus)) {
+				sfp_sm_next(sfp, SFP_S_FAIL, 0);
+				break;
+			}
 			sfp_sm_link_check_los(sfp);
 
 			/* Reset the fault retry count */
diff --git a/drivers/net/phy/sfp.h b/drivers/net/phy/sfp.h
index 64f54b0bbd8c..b83f70526270 100644
--- a/drivers/net/phy/sfp.h
+++ b/drivers/net/phy/sfp.h
@@ -22,6 +22,8 @@ void sfp_link_up(struct sfp_bus *bus);
 void sfp_link_down(struct sfp_bus *bus);
 int sfp_module_insert(struct sfp_bus *bus, const struct sfp_eeprom_id *id);
 void sfp_module_remove(struct sfp_bus *bus);
+int sfp_module_start(struct sfp_bus *bus);
+void sfp_module_stop(struct sfp_bus *bus);
 int sfp_link_configure(struct sfp_bus *bus, const struct sfp_eeprom_id *id);
 struct sfp_bus *sfp_register_socket(struct device *dev, struct sfp *sfp,
 				    const struct sfp_socket_ops *ops);
diff --git a/include/linux/sfp.h b/include/linux/sfp.h
index 373d8b67ea86..66a56396e8e3 100644
--- a/include/linux/sfp.h
+++ b/include/linux/sfp.h
@@ -507,6 +507,8 @@ struct sfp_bus;
  * @module_insert: called after a module has been detected to determine
  *   whether the module is supported for the upstream device.
  * @module_remove: called after the module has been removed.
+ * @module_start: called after the PHY probe step
+ * @module_stop: called before the PHY is removed
  * @link_down: called when the link is non-operational for whatever
  *   reason.
  * @link_up: called when the link is operational.
@@ -520,6 +522,8 @@ struct sfp_upstream_ops {
 	void (*detach)(void *priv, struct sfp_bus *bus);
 	int (*module_insert)(void *priv, const struct sfp_eeprom_id *id);
 	void (*module_remove)(void *priv);
+	int (*module_start)(void *priv);
+	void (*module_stop)(void *priv);
 	void (*link_down)(void *priv);
 	void (*link_up)(void *priv);
 	int (*connect_phy)(void *priv, struct phy_device *);
-- 
2.20.1

