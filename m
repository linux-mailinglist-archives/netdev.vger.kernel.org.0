Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9A0AD736B
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 12:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730844AbfJOKir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 06:38:47 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38292 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfJOKir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 06:38:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AgGmF9l4QmCbUuWeFVTlLo51qtJnCSnmba7+DnEtgoc=; b=c+YIRV+ugQaJ/5GQziM7/8tfyt
        rRoKp0qqfczwSCgu0sRlaTGBtF/gz80ee++nXcXlF+QlmT8KqrOscnVv6TcUysDusyjLkw8AL26lX
        aWh5Q0K0jZH5wdk9WW15v/paYlw3DyHHkLiGWcd3GnmfvB1r/EZpV12k8hpeuaejiNc20pbdjB8kL
        W9VkUnjPgOZbFKPH1pNcm6lbG6hvgkAHno7goBMq7CqPb0x3Y0zfZoduVFT7DWQP7U1BOm4EZiHNp
        Q0C+MUWZAtNdEq15MoskHLtoyGVRP5gBwMOKkQXWYOvclq1cKqfGmcnpolvnocj+/RgbrfvOYqnw9
        DK4Y2Znw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:60512 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iKKDw-0003ut-Kx; Tue, 15 Oct 2019 11:38:40 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iKKDv-0000fA-Um; Tue, 15 Oct 2019 11:38:40 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] net: sfp: move fwnode parsing into sfp-bus layer
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iKKDv-0000fA-Um@rmk-PC.armlinux.org.uk>
Date:   Tue, 15 Oct 2019 11:38:39 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than parsing the sfp firmware node in phylink, parse it in the
sfp-bus code, so we can re-use this code for PHYs without having to
duplicate the parsing.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 21 ++++---------
 drivers/net/phy/sfp-bus.c | 65 +++++++++++++++++++++++++--------------
 include/linux/sfp.h       | 10 +++---
 3 files changed, 53 insertions(+), 43 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 8e53ed90da3c..4c5e8b4f8d80 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -548,26 +548,17 @@ static const struct sfp_upstream_ops sfp_phylink_ops;
 static int phylink_register_sfp(struct phylink *pl,
 				struct fwnode_handle *fwnode)
 {
-	struct fwnode_reference_args ref;
+	struct sfp_bus *bus;
 	int ret;
 
-	if (!fwnode)
-		return 0;
-
-	ret = fwnode_property_get_reference_args(fwnode, "sfp", NULL,
-						 0, 0, &ref);
-	if (ret < 0) {
-		if (ret == -ENOENT)
-			return 0;
-
-		phylink_err(pl, "unable to parse \"sfp\" node: %d\n",
-			    ret);
+	bus = sfp_register_upstream_node(fwnode, pl, &sfp_phylink_ops);
+	if (IS_ERR(bus)) {
+		ret = PTR_ERR(bus);
+		phylink_err(pl, "unable to attach SFP bus: %d\n", ret);
 		return ret;
 	}
 
-	pl->sfp_bus = sfp_register_upstream(ref.fwnode, pl, &sfp_phylink_ops);
-	if (!pl->sfp_bus)
-		return -ENOMEM;
+	pl->sfp_bus = bus;
 
 	return 0;
 }
diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index b23fc41896ef..d037aab6a71d 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -4,6 +4,7 @@
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/phylink.h>
+#include <linux/property.h>
 #include <linux/rtnetlink.h>
 #include <linux/slab.h>
 
@@ -445,45 +446,63 @@ static void sfp_upstream_clear(struct sfp_bus *bus)
 }
 
 /**
- * sfp_register_upstream() - Register the neighbouring device
- * @fwnode: firmware node for the SFP bus
+ * sfp_register_upstream_node() - parse and register the neighbouring device
+ * @fwnode: firmware node for the parent device (MAC or PHY)
  * @upstream: the upstream private data
  * @ops: the upstream's &struct sfp_upstream_ops
  *
- * Register the upstream device (eg, PHY) with the SFP bus. MAC drivers
- * should use phylink, which will call this function for them. Returns
- * a pointer to the allocated &struct sfp_bus.
+ * Parse the parent device's firmware node for a SFP bus, and register the
+ * SFP bus using sfp_register_upstream().
  *
- * On error, returns %NULL.
+ * Returns: on success, a pointer to the sfp_bus structure,
+ *	    %NULL if no SFP is specified,
+ * 	    on failure, an error pointer value:
+ * 		corresponding to the errors detailed for
+ * 		fwnode_property_get_reference_args().
+ * 	        %-ENOMEM if we failed to allocate the bus.
+ *		an error from the upstream's connect_phy() method.
  */
-struct sfp_bus *sfp_register_upstream(struct fwnode_handle *fwnode,
-				      void *upstream,
-				      const struct sfp_upstream_ops *ops)
+struct sfp_bus *sfp_register_upstream_node(struct fwnode_handle *fwnode,
+					   void *upstream,
+					   const struct sfp_upstream_ops *ops)
 {
-	struct sfp_bus *bus = sfp_bus_get(fwnode);
-	int ret = 0;
+	struct fwnode_reference_args ref;
+	struct sfp_bus *bus;
+	int ret;
 
-	if (bus) {
-		rtnl_lock();
-		bus->upstream_ops = ops;
-		bus->upstream = upstream;
+	ret = fwnode_property_get_reference_args(fwnode, "sfp", NULL,
+						 0, 0, &ref);
+	if (ret == -ENOENT)
+		return NULL;
+	else if (ret < 0)
+		return ERR_PTR(ret);
 
-		if (bus->sfp) {
-			ret = sfp_register_bus(bus);
-			if (ret)
-				sfp_upstream_clear(bus);
-		}
-		rtnl_unlock();
+	bus = sfp_bus_get(ref.fwnode);
+	fwnode_handle_put(ref.fwnode);
+	if (!bus)
+		return ERR_PTR(-ENOMEM);
+
+	rtnl_lock();
+	bus->upstream_ops = ops;
+	bus->upstream = upstream;
+
+	if (bus->sfp) {
+		ret = sfp_register_bus(bus);
+		if (ret)
+			sfp_upstream_clear(bus);
+	} else {
+		ret = 0;
 	}
+	rtnl_unlock();
 
 	if (ret) {
 		sfp_bus_put(bus);
-		bus = NULL;
+		bus = ERR_PTR(ret);
 	}
 
 	return bus;
 }
-EXPORT_SYMBOL_GPL(sfp_register_upstream);
+EXPORT_SYMBOL_GPL(sfp_register_upstream_node);
 
 /**
  * sfp_unregister_upstream() - Unregister sfp bus
diff --git a/include/linux/sfp.h b/include/linux/sfp.h
index 1c35428e98bc..355a08a76fd4 100644
--- a/include/linux/sfp.h
+++ b/include/linux/sfp.h
@@ -508,9 +508,9 @@ int sfp_get_module_eeprom(struct sfp_bus *bus, struct ethtool_eeprom *ee,
 			  u8 *data);
 void sfp_upstream_start(struct sfp_bus *bus);
 void sfp_upstream_stop(struct sfp_bus *bus);
-struct sfp_bus *sfp_register_upstream(struct fwnode_handle *fwnode,
-				      void *upstream,
-				      const struct sfp_upstream_ops *ops);
+struct sfp_bus *sfp_register_upstream_node(struct fwnode_handle *fwnode,
+					   void *upstream,
+					   const struct sfp_upstream_ops *ops);
 void sfp_unregister_upstream(struct sfp_bus *bus);
 #else
 static inline int sfp_parse_port(struct sfp_bus *bus,
@@ -553,11 +553,11 @@ static inline void sfp_upstream_stop(struct sfp_bus *bus)
 {
 }
 
-static inline struct sfp_bus *sfp_register_upstream(
+static inline struct sfp_bus *sfp_register_upstream_node(
 	struct fwnode_handle *fwnode, void *upstream,
 	const struct sfp_upstream_ops *ops)
 {
-	return (struct sfp_bus *)-1;
+	return NULL;
 }
 
 static inline void sfp_unregister_upstream(struct sfp_bus *bus)
-- 
2.20.1

