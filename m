Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803651AE5CF
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 21:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730526AbgDQT3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 15:29:31 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:41913 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730283AbgDQT3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 15:29:20 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D792523058;
        Fri, 17 Apr 2020 21:29:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1587151754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xQGI6RECM8CGglVwJZboptE0gLfAM+KqsH6P6ueOYAo=;
        b=eBU2pk7Gs9pOnv+ZlU65YAeyDFbR31HWcnUaZgfyaOlRmRRFEDEhkYZy5/FDSWUi26hycf
        hQvo/iR3KcY/YjyHtCYgB3P1IFqq2NzSx/1ebBVisSWxtBhs2V/2cbYP4kS9LHwBSzYKTZ
        yOKrvVUY2UmFz3OhL/uxhsdeiqu9ZNo=
From:   Michael Walle <michael@walle.cc>
To:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 1/3] net: phy: broadcom: add helper to write/read RDB registers
Date:   Fri, 17 Apr 2020 21:28:56 +0200
Message-Id: <20200417192858.6997-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: D792523058
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_SPAM(0.00)[0.942];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[11];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c:8000::/33, country:DE];
         FREEMAIL_CC(0.00)[suse.com,roeck-us.net,lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RDB regsiters are used on newer Broadcom PHYs. Add helper to read, write
and modify these registers.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/bcm-phy-lib.c | 80 +++++++++++++++++++++++++++++++++++
 drivers/net/phy/bcm-phy-lib.h |  9 ++++
 include/linux/brcmphy.h       |  3 ++
 3 files changed, 92 insertions(+)

diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index e77b274a09fd..d5f9a2701989 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -155,6 +155,86 @@ int bcm_phy_write_shadow(struct phy_device *phydev, u16 shadow,
 }
 EXPORT_SYMBOL_GPL(bcm_phy_write_shadow);
 
+int __bcm_phy_read_rdb(struct phy_device *phydev, u16 rdb)
+{
+	int val;
+
+	val = __phy_write(phydev, MII_BCM54XX_RDB_ADDR, rdb);
+	if (val < 0)
+		return val;
+
+	return __phy_read(phydev, MII_BCM54XX_RDB_DATA);
+}
+EXPORT_SYMBOL_GPL(__bcm_phy_read_rdb);
+
+int bcm_phy_read_rdb(struct phy_device *phydev, u16 rdb)
+{
+	int ret;
+
+	phy_lock_mdio_bus(phydev);
+	ret = __bcm_phy_read_rdb(phydev, rdb);
+	phy_unlock_mdio_bus(phydev);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bcm_phy_read_rdb);
+
+int __bcm_phy_write_rdb(struct phy_device *phydev, u16 rdb, u16 val)
+{
+	int ret;
+
+	ret = __phy_write(phydev, MII_BCM54XX_RDB_ADDR, rdb);
+	if (ret < 0)
+		return ret;
+
+	return __phy_write(phydev, MII_BCM54XX_RDB_DATA, val);
+}
+EXPORT_SYMBOL_GPL(__bcm_phy_write_rdb);
+
+int bcm_phy_write_rdb(struct phy_device *phydev, u16 rdb, u16 val)
+{
+	int ret;
+
+	phy_lock_mdio_bus(phydev);
+	ret = __bcm_phy_write_rdb(phydev, rdb, val);
+	phy_unlock_mdio_bus(phydev);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bcm_phy_write_rdb);
+
+int __bcm_phy_modify_rdb(struct phy_device *phydev, u16 rdb, u16 mask, u16 set)
+{
+	int new, ret;
+
+	ret = __phy_write(phydev, MII_BCM54XX_RDB_ADDR, rdb);
+	if (ret < 0)
+		return ret;
+
+	ret = __phy_read(phydev, MII_BCM54XX_RDB_DATA);
+	if (ret < 0)
+		return ret;
+
+	new = (ret & ~mask) | set;
+	if (new == ret)
+		return 0;
+
+	return __phy_write(phydev, MII_BCM54XX_RDB_DATA, new);
+}
+EXPORT_SYMBOL_GPL(__bcm_phy_modify_rdb);
+
+int bcm_phy_modify_rdb(struct phy_device *phydev, u16 rdb, u16 mask, u16 set)
+{
+	int ret;
+
+	phy_lock_mdio_bus(phydev);
+	ret = __bcm_phy_modify_rdb(phydev, rdb, mask, set);
+	phy_unlock_mdio_bus(phydev);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bcm_phy_modify_rdb);
+
 int bcm_phy_enable_apd(struct phy_device *phydev, bool dll_pwr_down)
 {
 	int val;
diff --git a/drivers/net/phy/bcm-phy-lib.h b/drivers/net/phy/bcm-phy-lib.h
index 129df819be8c..4d3de91cda6c 100644
--- a/drivers/net/phy/bcm-phy-lib.h
+++ b/drivers/net/phy/bcm-phy-lib.h
@@ -48,6 +48,15 @@ int bcm_phy_write_shadow(struct phy_device *phydev, u16 shadow,
 			 u16 val);
 int bcm_phy_read_shadow(struct phy_device *phydev, u16 shadow);
 
+int __bcm_phy_write_rdb(struct phy_device *phydev, u16 rdb, u16 val);
+int bcm_phy_write_rdb(struct phy_device *phydev, u16 rdb, u16 val);
+int __bcm_phy_read_rdb(struct phy_device *phydev, u16 rdb);
+int bcm_phy_read_rdb(struct phy_device *phydev, u16 rdb);
+int __bcm_phy_modify_rdb(struct phy_device *phydev, u16 rdb, u16 mask,
+			 u16 set);
+int bcm_phy_modify_rdb(struct phy_device *phydev, u16 rdb, u16 mask,
+		       u16 set);
+
 int bcm_phy_ack_intr(struct phy_device *phydev);
 int bcm_phy_config_intr(struct phy_device *phydev);
 
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index 6462c5447872..e14f78b3c8a4 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -114,6 +114,9 @@
 #define MII_BCM54XX_SHD_VAL(x)	((x & 0x1f) << 10)
 #define MII_BCM54XX_SHD_DATA(x)	((x & 0x3ff) << 0)
 
+#define MII_BCM54XX_RDB_ADDR	0x1e
+#define MII_BCM54XX_RDB_DATA	0x1f
+
 /*
  * AUXILIARY CONTROL SHADOW ACCESS REGISTERS.  (PHY REG 0x18)
  */
-- 
2.20.1

