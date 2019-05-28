Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8963D2C3A9
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfE1J5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:57:43 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35916 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfE1J5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 05:57:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9nKaGhe+xuoEqt7IqX3UShtrrZPWNKYR4qZFj9Xz5E0=; b=fgEoOWOlYSXCzfax01id8drYt6
        AHZRvmb1tYtul1CqQr1mO3rnSsV5smMe7kF+ZdAf6EJQ6y7Zt2WHYYtOV0CQjGWRuJkVoHJu0jJaA
        rC17nADxCpjv2D6xyVhTvUC/3a6nAYPPdU4OEs2Kjs4Joa3ykXFdDPjvpc1ifumerQtCiycDBKnNv
        t/KiD/hbh19PC2jntgS33h+KCOVAtfPDYDnrcqG71XxdVTLC5rpPGPdFoVJIE4lboPGs4mrzLuO3R
        gk7lsFSUI/b/6PGaYRIhRDPnzOuC23tgIJLCFS6BKpPuaw3TrmD09ElBYr1AlxcLHC+5l7P3tHBJg
        bR44EZcg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:40430 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hVYrQ-0004z3-2T; Tue, 28 May 2019 10:57:36 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hVYrO-0005ZH-C8; Tue, 28 May 2019 10:57:34 +0100
In-Reply-To: <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk>
References: <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 4/5] net: sfp: add mandatory attach/detach methods
 for sfp buses
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1hVYrO-0005ZH-C8@rmk-PC.armlinux.org.uk>
Date:   Tue, 28 May 2019 10:57:34 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add attach and detach methods for SFP buses, which will allow us to get
rid of the netdev storage in sfp-bus.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 16 ++++++++++++++++
 drivers/net/phy/sfp-bus.c |  4 ++--
 include/linux/sfp.h       |  6 ++++++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 00cd0ed7ff3d..af02da9e9c1e 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1595,6 +1595,20 @@ int phylink_mii_ioctl(struct phylink *pl, struct ifreq *ifr, int cmd)
 }
 EXPORT_SYMBOL_GPL(phylink_mii_ioctl);
 
+static void phylink_sfp_attach(void *upstream, struct sfp_bus *bus)
+{
+	struct phylink *pl = upstream;
+
+	pl->netdev->sfp_bus = bus;
+}
+
+static void phylink_sfp_detach(void *upstream, struct sfp_bus *bus)
+{
+	struct phylink *pl = upstream;
+
+	pl->netdev->sfp_bus = NULL;
+}
+
 static int phylink_sfp_module_insert(void *upstream,
 				     const struct sfp_eeprom_id *id)
 {
@@ -1713,6 +1727,8 @@ static void phylink_sfp_disconnect_phy(void *upstream)
 }
 
 static const struct sfp_upstream_ops sfp_phylink_ops = {
+	.attach = phylink_sfp_attach,
+	.detach = phylink_sfp_detach,
 	.module_insert = phylink_sfp_module_insert,
 	.link_up = phylink_sfp_link_up,
 	.link_down = phylink_sfp_link_down,
diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index fef701bfad62..c664c905830a 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -350,7 +350,7 @@ static int sfp_register_bus(struct sfp_bus *bus)
 	bus->socket_ops->attach(bus->sfp);
 	if (bus->started)
 		bus->socket_ops->start(bus->sfp);
-	bus->netdev->sfp_bus = bus;
+	bus->upstream_ops->attach(bus->upstream, bus);
 	bus->registered = true;
 	return 0;
 }
@@ -359,8 +359,8 @@ static void sfp_unregister_bus(struct sfp_bus *bus)
 {
 	const struct sfp_upstream_ops *ops = bus->upstream_ops;
 
-	bus->netdev->sfp_bus = NULL;
 	if (bus->registered) {
+		bus->upstream_ops->detach(bus->upstream, bus);
 		if (bus->started)
 			bus->socket_ops->stop(bus->sfp);
 		bus->socket_ops->detach(bus->sfp);
diff --git a/include/linux/sfp.h b/include/linux/sfp.h
index d9d9de3fcf8e..a3f0336dd703 100644
--- a/include/linux/sfp.h
+++ b/include/linux/sfp.h
@@ -469,6 +469,10 @@ struct sfp_bus;
 
 /**
  * struct sfp_upstream_ops - upstream operations structure
+ * @attach: called when the sfp socket driver is bound to the upstream
+ *   (mandatory).
+ * @detach: called when the sfp socket driver is unbound from the upstream
+ *   (mandatory).
  * @module_insert: called after a module has been detected to determine
  *   whether the module is supported for the upstream device.
  * @module_remove: called after the module has been removed.
@@ -481,6 +485,8 @@ struct sfp_bus;
  *   been removed.
  */
 struct sfp_upstream_ops {
+	void (*attach)(void *priv, struct sfp_bus *bus);
+	void (*detach)(void *priv, struct sfp_bus *bus);
 	int (*module_insert)(void *priv, const struct sfp_eeprom_id *id);
 	void (*module_remove)(void *priv);
 	void (*link_down)(void *priv);
-- 
2.7.4

