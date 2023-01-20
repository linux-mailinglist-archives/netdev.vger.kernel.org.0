Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE89676047
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 23:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjATWk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 17:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjATWk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 17:40:26 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607E47AF34;
        Fri, 20 Jan 2023 14:40:24 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 5F7ED1A00;
        Fri, 20 Jan 2023 23:40:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1674254422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u/J5oeU7SA9v0gVYvk5Iqa+YJEe2Ko+M47R4seZEilw=;
        b=I+ckk16cFwlFldrGtcH5cJnLgInmJYDyqU4UJVJy8x9nozXAez+Fd6OKGzE47l/CCIiV8X
        fq3IlOI5yEP8AMTz2+fACO0ptcUu2DXD6RHbn/1Z0HQe7m5j1+tzAHG2RuggHQcRN55KqO
        s17tPrpD3Yp1Ds6fsJIKgEH1ErfOpD+q5hIzkCmj/XOuzH7oZOzMPeQwbFQBz0jtwq/ibC
        OmLHnKBS9tPMr142yt8LW3lguF8JY8m41To01CNjMV5TnPWkheRr1Uw8amtcXgiu4kLsjZ
        THNn4x1TFBrYWztuO0ovpkcygHPZ6l+QNe7mcJsW1lhCFKRD/QqJoasTBTSAMw==
From:   Michael Walle <michael@walle.cc>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 4/5] phy: net: introduce phy_promote_to_c45()
Date:   Fri, 20 Jan 2023 23:40:10 +0100
Message-Id: <20230120224011.796097-5-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230120224011.796097-1-michael@walle.cc>
References: <20230120224011.796097-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
           ret = phy_get_c45_ids(phydev);
           if (ret < 0)
                   return ret;
   }

Move that code into the core by creating a new function
phy_promote_to_c45(). If a PHY is promoted, C45-over-C22 access is used,
regardless if the bus supports C45 or not. That is because there might
be C22 PHYs on the bus which gets confused by C45 accesses.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/mxl-gpy.c    |  9 ++++-----
 drivers/net/phy/phy_device.c | 23 +++++++++++++++++++----
 include/linux/phy.h          |  2 +-
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index e86aea4381c2..4dc1093dbdc1 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -281,11 +281,10 @@ static int gpy_probe(struct phy_device *phydev)
 	int fw_version;
 	int ret;
 
-	if (!phydev->has_c45) {
-		ret = phy_get_c45_ids(phydev);
-		if (ret < 0)
-			return ret;
-	}
+	/* This might have been probed as a C22 PHY, but this is a C45 PHY */
+	ret = phy_promote_to_c45(phydev);
+	if (ret)
+		return ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index d5ea034cde98..ae24b62abfac 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1058,18 +1058,33 @@ void phy_device_remove(struct phy_device *phydev)
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
+ * Can also be called if a PHY is already a C45 one. In that case it does
+ * nothing.
+ *
+ * Promoted PHYs will always use C45-over-C22 accesses to prevent any C45
+ * transactions on the bus, which might confuse C22-only PHYs.
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
+	phydev->c45_over_c22 = true;
 	return get_phy_c45_ids(phydev->mdio.bus, phydev->mdio.addr,
 			       &phydev->c45_ids);
 }
-EXPORT_SYMBOL(phy_get_c45_ids);
+EXPORT_SYMBOL(phy_promote_to_c45);
 
 /**
  * phy_find_first - finds the first PHY device on the bus
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 4c02c468a24b..9473e2ed8496 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1588,7 +1588,7 @@ static inline int phy_device_register(struct phy_device *phy)
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

