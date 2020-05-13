Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4341D1B31
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389733AbgEMQfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389597AbgEMQfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:35:34 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86610C061A0C;
        Wed, 13 May 2020 09:35:34 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id CD97622FEC;
        Wed, 13 May 2020 18:35:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1589387733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s2wIlU8Pd3HBd/cUetc0yeQdhnrL+6aSlOHX3DcvhZo=;
        b=SylhckRmho8eyk1BwZQTLS5ZOFZe75OM6hr2R1KaDOfZCBu2STZ1rDdPaiqujaZ2w4MiIM
        VoeShM2QfcA2vPdABYfn8y8gaLCaRbg6BQF3zrCt43NsI1XlpQcAC2M6m35ErqEDpIpHz/
        wu0vfL3RA8aPUgtyehL4bDschp3f3Og=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 2/4] net: phy: broadcom: add bcm_phy_modify_exp()
Date:   Wed, 13 May 2020 18:35:22 +0200
Message-Id: <20200513163524.31256-3-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200513163524.31256-1-michael@walle.cc>
References: <20200513163524.31256-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the convenience function to do a read-modify-write. This has the
additional benefit of saving one write to the selection register.

Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/bcm-phy-lib.c | 32 ++++++++++++++++++++++++++++++++
 drivers/net/phy/bcm-phy-lib.h |  2 ++
 2 files changed, 34 insertions(+)

diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index a390812714ed..41c728fbcfb2 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -67,6 +67,38 @@ int bcm_phy_read_exp(struct phy_device *phydev, u16 reg)
 }
 EXPORT_SYMBOL_GPL(bcm_phy_read_exp);
 
+int __bcm_phy_modify_exp(struct phy_device *phydev, u16 reg, u16 mask, u16 set)
+{
+	int new, ret;
+
+	ret = __phy_write(phydev, MII_BCM54XX_EXP_SEL, reg);
+	if (ret < 0)
+		return ret;
+
+	ret = __phy_read(phydev, MII_BCM54XX_EXP_DATA);
+	if (ret < 0)
+		return ret;
+
+	new = (ret & ~mask) | set;
+	if (new == ret)
+		return 0;
+
+	return __phy_write(phydev, MII_BCM54XX_EXP_DATA, new);
+}
+EXPORT_SYMBOL_GPL(__bcm_phy_modify_exp);
+
+int bcm_phy_modify_exp(struct phy_device *phydev, u16 reg, u16 mask, u16 set)
+{
+	int ret;
+
+	phy_lock_mdio_bus(phydev);
+	ret = __bcm_phy_modify_exp(phydev, reg, mask, set);
+	phy_unlock_mdio_bus(phydev);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bcm_phy_modify_exp);
+
 int bcm54xx_auxctl_read(struct phy_device *phydev, u16 regnum)
 {
 	/* The register must be written to both the Shadow Register Select and
diff --git a/drivers/net/phy/bcm-phy-lib.h b/drivers/net/phy/bcm-phy-lib.h
index 0eb5333cda39..b35d880220b9 100644
--- a/drivers/net/phy/bcm-phy-lib.h
+++ b/drivers/net/phy/bcm-phy-lib.h
@@ -29,8 +29,10 @@
 
 int __bcm_phy_write_exp(struct phy_device *phydev, u16 reg, u16 val);
 int __bcm_phy_read_exp(struct phy_device *phydev, u16 reg);
+int __bcm_phy_modify_exp(struct phy_device *phydev, u16 reg, u16 mask, u16 set);
 int bcm_phy_write_exp(struct phy_device *phydev, u16 reg, u16 val);
 int bcm_phy_read_exp(struct phy_device *phydev, u16 reg);
+int bcm_phy_modify_exp(struct phy_device *phydev, u16 reg, u16 mask, u16 set);
 
 static inline int bcm_phy_write_exp_sel(struct phy_device *phydev,
 					u16 reg, u16 val)
-- 
2.20.1

