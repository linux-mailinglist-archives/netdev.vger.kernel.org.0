Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 808F62C3AA
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfE1J5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:57:49 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35926 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfE1J5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 05:57:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LaS5oxN6DAtk04RG2PtICgGlAwzTAp3nymeCTNOc/Jw=; b=X10EOjvwFdDCeSDZaBmYk/boQZ
        4z0ZQi6IQWLzpTe+3mNDqwdBrBLdzwPgGwU3jFRxtgWACWE/Mw3lut6qRQYvLX7jGjDHJUYjaNpmz
        WQmvwNUYCOUbfnrniUzXVJK+MncgxbG5LovuH/m53ZsXM8hjExLhdBei2r96o0G1kJanlFX59+0Wu
        TCZnQTLC98ZIqMUaSYFzZuicaOf2OJcaY+cA8iLhsVIA/jEialsGxJOZJ30chcW5B8LMsD+97C1jg
        Iq2/Qnk6graYDD/6LFvJQfNnGH+vGbgcFIRlaYh75AbUMp994mObcF2Aklp9lX01YXk4cNexb/+gT
        eSeTv/QQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:39918 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hVYrV-0004zB-5r; Tue, 28 May 2019 10:57:41 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hVYrT-0005ZO-Nz; Tue, 28 May 2019 10:57:40 +0100
In-Reply-To: <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk>
References: <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 5/5] net: sfp: remove sfp-bus use of netdevs
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1hVYrT-0005ZO-Nz@rmk-PC.armlinux.org.uk>
Date:   Tue, 28 May 2019 10:57:39 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sfp-bus code now no longer has any use for the network device
structure, so remove its use.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c |  3 +--
 drivers/net/phy/sfp-bus.c | 10 +++-------
 include/linux/sfp.h       |  6 ++----
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index af02da9e9c1e..70045c5e116e 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -522,8 +522,7 @@ static int phylink_register_sfp(struct phylink *pl,
 		return ret;
 	}
 
-	pl->sfp_bus = sfp_register_upstream(ref.fwnode, pl->netdev, pl,
-					    &sfp_phylink_ops);
+	pl->sfp_bus = sfp_register_upstream(ref.fwnode, pl, &sfp_phylink_ops);
 	if (!pl->sfp_bus)
 		return -ENOMEM;
 
diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index c664c905830a..5bc8099eaaf1 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -23,7 +23,6 @@ struct sfp_bus {
 
 	const struct sfp_upstream_ops *upstream_ops;
 	void *upstream;
-	struct net_device *netdev;
 	struct phy_device *phydev;
 
 	bool registered;
@@ -442,13 +441,11 @@ static void sfp_upstream_clear(struct sfp_bus *bus)
 {
 	bus->upstream_ops = NULL;
 	bus->upstream = NULL;
-	bus->netdev = NULL;
 }
 
 /**
  * sfp_register_upstream() - Register the neighbouring device
  * @fwnode: firmware node for the SFP bus
- * @ndev: network device associated with the interface
  * @upstream: the upstream private data
  * @ops: the upstream's &struct sfp_upstream_ops
  *
@@ -459,7 +456,7 @@ static void sfp_upstream_clear(struct sfp_bus *bus)
  * On error, returns %NULL.
  */
 struct sfp_bus *sfp_register_upstream(struct fwnode_handle *fwnode,
-				      struct net_device *ndev, void *upstream,
+				      void *upstream,
 				      const struct sfp_upstream_ops *ops)
 {
 	struct sfp_bus *bus = sfp_bus_get(fwnode);
@@ -469,7 +466,6 @@ struct sfp_bus *sfp_register_upstream(struct fwnode_handle *fwnode,
 		rtnl_lock();
 		bus->upstream_ops = ops;
 		bus->upstream = upstream;
-		bus->netdev = ndev;
 
 		if (bus->sfp) {
 			ret = sfp_register_bus(bus);
@@ -591,7 +587,7 @@ struct sfp_bus *sfp_register_socket(struct device *dev, struct sfp *sfp,
 		bus->sfp = sfp;
 		bus->socket_ops = ops;
 
-		if (bus->netdev) {
+		if (bus->upstream_ops) {
 			ret = sfp_register_bus(bus);
 			if (ret)
 				sfp_socket_clear(bus);
@@ -611,7 +607,7 @@ EXPORT_SYMBOL_GPL(sfp_register_socket);
 void sfp_unregister_socket(struct sfp_bus *bus)
 {
 	rtnl_lock();
-	if (bus->netdev)
+	if (bus->upstream_ops)
 		sfp_unregister_bus(bus);
 	sfp_socket_clear(bus);
 	rtnl_unlock();
diff --git a/include/linux/sfp.h b/include/linux/sfp.h
index a3f0336dd703..1c35428e98bc 100644
--- a/include/linux/sfp.h
+++ b/include/linux/sfp.h
@@ -464,7 +464,6 @@ enum {
 struct fwnode_handle;
 struct ethtool_eeprom;
 struct ethtool_modinfo;
-struct net_device;
 struct sfp_bus;
 
 /**
@@ -510,7 +509,7 @@ int sfp_get_module_eeprom(struct sfp_bus *bus, struct ethtool_eeprom *ee,
 void sfp_upstream_start(struct sfp_bus *bus);
 void sfp_upstream_stop(struct sfp_bus *bus);
 struct sfp_bus *sfp_register_upstream(struct fwnode_handle *fwnode,
-				      struct net_device *ndev, void *upstream,
+				      void *upstream,
 				      const struct sfp_upstream_ops *ops);
 void sfp_unregister_upstream(struct sfp_bus *bus);
 #else
@@ -555,8 +554,7 @@ static inline void sfp_upstream_stop(struct sfp_bus *bus)
 }
 
 static inline struct sfp_bus *sfp_register_upstream(
-	struct fwnode_handle *fwnode,
-	struct net_device *ndev, void *upstream,
+	struct fwnode_handle *fwnode, void *upstream,
 	const struct sfp_upstream_ops *ops)
 {
 	return (struct sfp_bus *)-1;
-- 
2.7.4

