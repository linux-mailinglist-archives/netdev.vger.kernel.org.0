Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0C81038FA
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 12:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbfKTLmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 06:42:49 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39166 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727952AbfKTLmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 06:42:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=trN7D8LqA6+pGKME8/thA18A4u2FIHFAYvwi+we/mmI=; b=DAzff7Lb3dC+9+ST1JslxrJdJY
        J8b2G5ZcV92ZeMo5wR2aybUD6XeaCFt1jal7XR8Qx2R6kN6iIvvZIuXgro6j1pEJLNfQjE5zWx8Ac
        1t7gK20SJZFtRmD4sxIFo7/L4HELB3CPtwx7Elae4vdCyBXnCDFWphHV728RXvmgZ/5YsoBPVFdC4
        BYc4Goa6Ic4RUzwC+RSpzAkcfvaWgFvS3yxPNUGa0yE6p0JldZX9fkgwx16PoJv+1kR13qP7pJAC6
        3Mh6DtR4C1ZeOdhyW8dlgr7Y2gxyzHWldaGzxVEpe/cN6//OBnHvBrEM8ZtHTf5n+EE0MOk1Kzq6n
        gq5FP45A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:39536 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iXONf-00084J-5e; Wed, 20 Nov 2019 11:42:43 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iXONe-0005el-H8; Wed, 20 Nov 2019 11:42:42 +0000
In-Reply-To: <20191120113900.GP25745@shell.armlinux.org.uk>
References: <20191120113900.GP25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: sfp: add support for module quirks
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iXONe-0005el-H8@rmk-PC.armlinux.org.uk>
Date:   Wed, 20 Nov 2019 11:42:42 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for applying module quirks to the list of supported
ethtool link modes.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp-bus.c | 54 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 2f826a303ad8..aebb6978e91a 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -10,6 +10,12 @@
 
 #include "sfp.h"
 
+struct sfp_quirk {
+	const char *vendor;
+	const char *part;
+	void (*modes)(const struct sfp_eeprom_id *id, unsigned long *modes);
+};
+
 /**
  * struct sfp_bus - internal representation of a sfp bus
  */
@@ -22,6 +28,7 @@ struct sfp_bus {
 	const struct sfp_socket_ops *socket_ops;
 	struct device *sfp_dev;
 	struct sfp *sfp;
+	const struct sfp_quirk *sfp_quirk;
 
 	const struct sfp_upstream_ops *upstream_ops;
 	void *upstream;
@@ -31,6 +38,46 @@ struct sfp_bus {
 	bool started;
 };
 
+static const struct sfp_quirk sfp_quirks[] = {
+};
+
+static size_t sfp_strlen(const char *str, size_t maxlen)
+{
+	size_t size, i;
+
+	/* Trailing characters should be filled with space chars */
+	for (i = 0, size = 0; i < maxlen; i++)
+		if (str[i] != ' ')
+			size = i + 1;
+
+	return size;
+}
+
+static bool sfp_match(const char *qs, const char *str, size_t len)
+{
+	if (!qs)
+		return true;
+	if (strlen(qs) != len)
+		return false;
+	return !strncmp(qs, str, len);
+}
+
+static const struct sfp_quirk *sfp_lookup_quirk(const struct sfp_eeprom_id *id)
+{
+	const struct sfp_quirk *q;
+	unsigned int i;
+	size_t vs, ps;
+
+	vs = sfp_strlen(id->base.vendor_name, ARRAY_SIZE(id->base.vendor_name));
+	ps = sfp_strlen(id->base.vendor_pn, ARRAY_SIZE(id->base.vendor_pn));
+
+	for (i = 0, q = sfp_quirks; i < ARRAY_SIZE(sfp_quirks); i++, q++)
+		if (sfp_match(q->vendor, id->base.vendor_name, vs) &&
+		    sfp_match(q->part, id->base.vendor_pn, ps))
+			return q;
+
+	return NULL;
+}
 /**
  * sfp_parse_port() - Parse the EEPROM base ID, setting the port type
  * @bus: a pointer to the &struct sfp_bus structure for the sfp module
@@ -245,6 +292,9 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 			phylink_set(modes, 1000baseX_Full);
 	}
 
+	if (bus->sfp_quirk)
+		bus->sfp_quirk->modes(id, modes);
+
 	bitmap_or(support, support, modes, __ETHTOOL_LINK_MODE_MASK_NBITS);
 
 	phylink_set(support, Autoneg);
@@ -622,6 +672,8 @@ int sfp_module_insert(struct sfp_bus *bus, const struct sfp_eeprom_id *id)
 	const struct sfp_upstream_ops *ops = sfp_get_upstream_ops(bus);
 	int ret = 0;
 
+	bus->sfp_quirk = sfp_lookup_quirk(id);
+
 	if (ops && ops->module_insert)
 		ret = ops->module_insert(bus->upstream, id);
 
@@ -635,6 +687,8 @@ void sfp_module_remove(struct sfp_bus *bus)
 
 	if (ops && ops->module_remove)
 		ops->module_remove(bus->upstream);
+
+	bus->sfp_quirk = NULL;
 }
 EXPORT_SYMBOL_GPL(sfp_module_remove);
 
-- 
2.20.1

