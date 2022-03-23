Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF0F4E587A
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 19:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343822AbiCWSgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 14:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240140AbiCWSgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 14:36:03 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA50D71EC9;
        Wed, 23 Mar 2022 11:34:32 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 79C12223F6;
        Wed, 23 Mar 2022 19:34:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648060470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DhcMgIaTy6FRI8JLWQ7wMPHYxcmUnSolW4s0k7u/vp0=;
        b=ai1n4+g0tBDGnAqSzsNwyLDFmhInG7N8+fj+RBbLfLw8wWBGRN0e+myKHUnTDLkjkGuBCC
        wxFpztQK7zUG44ueibAf7P5EpUpewlvK+TVK4cA6H7MlwXS8EDIvzh5GD+gcftkIGbgQA5
        t9IZB7hD5t2P2P/uknPqVR4AP/ColZs=
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
Subject: [PATCH RFC net-next 4/5] net: phy: introduce is_c45_over_c22 flag
Date:   Wed, 23 Mar 2022 19:34:18 +0100
Message-Id: <20220323183419.2278676-5-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220323183419.2278676-1-michael@walle.cc>
References: <20220323183419.2278676-1-michael@walle.cc>
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

The GPY215 driver supports indirect accesses to c45 over the c22
registers. In its probe function phy_get_c45_ids() is called and the
author descibed their use case as follows:

  The problem comes from condition "phydev->c45_ids.mmds_present &
  MDIO_DEVS_AN".

  Our product supports both C22 and C45.

  In the real system, we found C22 was used by customers (with indirect
  access to C45 registers when necessary).

So it is pretty clear that the intention was to have a method to use the
c45 features over a c22-only MDIO bus. The purpose of calling
phy_get_c45_ids() is to populate the .c45_ids for a PHY which wasn't
probed as a c45 one. Thus, first rename the phy_get_c45_ids() function
to reflect its actual meaning and second, add a new flag which indicates
that this is actually a c45 PHY but behind a c22 bus. The latter is
important for phylink because phylink will treat c45 in a special way by
checking the .is_c45 property. But in our case this isn't set.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/mxl-gpy.c    |  2 +-
 drivers/net/phy/phy_device.c | 20 +++++++++++++++-----
 include/linux/phy.h          |  4 +++-
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 5ce1bf03bbd7..0c825ec20eaa 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -99,7 +99,7 @@ static int gpy_probe(struct phy_device *phydev)
 	int ret;
 
 	if (!phydev->is_c45) {
-		ret = phy_get_c45_ids(phydev);
+		ret = phy_get_c45_ids_by_c22(phydev);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index c766f5bb421a..43354b261bd5 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1005,18 +1005,28 @@ void phy_device_remove(struct phy_device *phydev)
 EXPORT_SYMBOL(phy_device_remove);
 
 /**
- * phy_get_c45_ids - Read 802.3-c45 IDs for phy device.
+ * phy_get_c45_ids - Read 802.3-c45 IDs for phy device by using indirect
+ *                   c22 accesses.
  * @phydev: phy_device structure to read 802.3-c45 IDs
  *
  * Returns zero on success, %-EIO on bus access error, or %-ENODEV if
  * the "devices in package" is invalid.
  */
-int phy_get_c45_ids(struct phy_device *phydev)
+int phy_get_c45_ids_by_c22(struct phy_device *phydev)
 {
-	return get_phy_c45_ids(phydev->mdio.bus, phydev->mdio.addr,
-			       &phydev->c45_ids);
+	int ret;
+
+	if (WARN(phydev->is_c45, "PHY is already clause 45\n"))
+		return -EINVAL;
+
+	ret = get_phy_c45_ids(phydev->mdio.bus, phydev->mdio.addr,
+			      &phydev->c45_ids);
+	if (!ret)
+		phydev->is_c45_over_c22 = true;
+
+	return ret;
 }
-EXPORT_SYMBOL(phy_get_c45_ids);
+EXPORT_SYMBOL(phy_get_c45_ids_by_c22);
 
 /**
  * phy_find_first - finds the first PHY device on the bus
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 36ca2b5c2253..eb436d603feb 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -525,6 +525,7 @@ struct macsec_ops;
  * @phy_id: UID for this device found during discovery
  * @c45_ids: 802.3-c45 Device Identifiers if is_c45.
  * @is_c45:  Set to true if this PHY uses clause 45 addressing.
+ * @is_c45_over_c22:  Set to true if this PHY uses c45-over-c22 addressing.
  * @is_internal: Set to true if this PHY is internal to a MAC.
  * @is_pseudo_fixed_link: Set to true if this PHY is an Ethernet switch, etc.
  * @is_gigabit_capable: Set to true if PHY supports 1000Mbps
@@ -606,6 +607,7 @@ struct phy_device {
 
 	struct phy_c45_device_ids c45_ids;
 	unsigned is_c45:1;
+	unsigned is_c45_over_c22:1;
 	unsigned is_internal:1;
 	unsigned is_pseudo_fixed_link:1;
 	unsigned is_gigabit_capable:1;
@@ -1466,7 +1468,7 @@ static inline int phy_device_register(struct phy_device *phy)
 static inline void phy_device_free(struct phy_device *phydev) { }
 #endif /* CONFIG_PHYLIB */
 void phy_device_remove(struct phy_device *phydev);
-int phy_get_c45_ids(struct phy_device *phydev);
+int phy_get_c45_ids_by_c22(struct phy_device *phydev);
 int phy_init_hw(struct phy_device *phydev);
 int phy_suspend(struct phy_device *phydev);
 int phy_resume(struct phy_device *phydev);
-- 
2.30.2

