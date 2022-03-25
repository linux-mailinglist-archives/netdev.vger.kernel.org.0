Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F324E7CA8
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbiCYVhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 17:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbiCYVhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 17:37:06 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29424C7A0;
        Fri, 25 Mar 2022 14:35:31 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 18A4922438;
        Fri, 25 Mar 2022 22:35:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648244128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H8VkAdaZqV/fF69kPMLAXYZCpovyMDnXX53kDMmonNE=;
        b=Q3jRUy9zCYFTg6krSaXovRlK0b9oAqpD2mttDgPc/ppJVURS65urJxLnYrw/PcGrrcCl+4
        WCeKmQ3KUgeyfSUsJZZtLlg7ZEbRThU3IWp4AIOwkynzNH2zf6Byg7pI6TUhLP4UfELdyh
        9A0dyeYp/Ylvvw57Yz9d1gVw9gfD5k8=
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH RFC net-next v2 7/8] phy: net: introduce phy_promote_to_c45()
Date:   Fri, 25 Mar 2022 22:35:17 +0100
Message-Id: <20220325213518.2668832-8-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220325213518.2668832-1-michael@walle.cc>
References: <20220325213518.2668832-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If not explitly asked to be probed as a C45 PHY, on a bus which is
capable of doing both C22 and C45 transfers, C45 PHYs are first tried to
be probed as C22 PHYs. To be able to promote the PHY to be a C45 one,
the driver can call phy_promote_to_c45() in its probe function.

This was already done in the mxl-gpy driver by the following snippet:

   if (!phydev->has_c45) {
	   phydev->has_c45 = true;
           ret = phy_get_c45_ids(phydev);
           if (ret < 0)
                   return ret;
   }

Move that code into the core by creating a new function
phy_promote_to_c45().

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/mxl-gpy.c    |  8 ++------
 drivers/net/phy/phy_device.c | 19 +++++++++++++++----
 include/linux/phy.h          |  2 +-
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 2a19905984fc..fe9417528444 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -98,12 +98,8 @@ static int gpy_probe(struct phy_device *phydev)
 {
 	int ret;
 
-	if (!phydev->has_c45) {
-		phydev->has_c45 = true;
-		ret = phy_get_c45_ids(phydev);
-		if (ret < 0)
-			return ret;
-	}
+	/* This might have been probed as a C22 PHY, but this is a C45 PHY */
+	phy_promote_to_c45(phydev);
 
 	/* Show GPY PHY FW version in dmesg */
 	ret = phy_read(phydev, PHY_FWV);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 920bc8859069..3dc7d012051d 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1007,18 +1007,29 @@ void phy_device_remove(struct phy_device *phydev)
 EXPORT_SYMBOL(phy_device_remove);
 
 /**
- * phy_get_c45_ids - Read 802.3-c45 IDs for phy device.
- * @phydev: phy_device structure to read 802.3-c45 IDs
+ * phy_promote_to_c45 - Promote to a C45 PHY
+ * @phydev: phy_device structure
+ *
+ * If a PHY supports both C22 and C45 and it isn't specifically asked to probe
+ * as a C45 PHY it might be probed as a C22 PHY. The driver can call this
+ * function to promote a PHY from C22 to C45.
+ *
+ * Can also be called if a PHY is already a C45 one. In this case this does
+ * nothing.
  *
  * Returns zero on success, %-EIO on bus access error, or %-ENODEV if
  * the "devices in package" is invalid.
  */
-int phy_get_c45_ids(struct phy_device *phydev)
+int phy_promote_to_c45(struct phy_device *phydev)
 {
+	if (phydev->has_c45)
+		return 0;
+
+	phydev->has_c45 = true;
 	return get_phy_c45_ids(phydev->mdio.bus, phydev->mdio.addr,
 			       &phydev->c45_ids);
 }
-EXPORT_SYMBOL(phy_get_c45_ids);
+EXPORT_SYMBOL(phy_promote_to_c45);
 
 /**
  * phy_find_first - finds the first PHY device on the bus
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 64f2dff2f125..4473e760264a 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1470,7 +1470,7 @@ static inline int phy_device_register(struct phy_device *phy)
 static inline void phy_device_free(struct phy_device *phydev) { }
 #endif /* CONFIG_PHYLIB */
 void phy_device_remove(struct phy_device *phydev);
-int phy_get_c45_ids(struct phy_device *phydev);
+int phy_promote_to_c45(struct phy_device *phydev);
 int phy_init_hw(struct phy_device *phydev);
 int phy_suspend(struct phy_device *phydev);
 int phy_resume(struct phy_device *phydev);
-- 
2.30.2

