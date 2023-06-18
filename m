Return-Path: <netdev+bounces-11793-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D10587347A5
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 20:41:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04D2D1C2085A
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 18:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1DB3748C;
	Sun, 18 Jun 2023 18:41:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67C11865
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 18:41:45 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F46612B
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 11:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
	Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=Y5pr+LkV594IoRYSJcMPgtrKd5/GjFWZLX1RiZE0mvU=; b=0JmB3om3ViclPDYrpTLNfhP6a7
	BV+qlLiyZWqdDzJZHVkeA5QIiAJ4GMrLTZ5FvYMHL7K7FS+HsgUVe+tMiWuDgOFfjkCDRDdHTeJHI
	L/UKjKoHDSfgExzIzwmTt2YDEOQ5m9K6eo9ubs0WMlPBHkHb9slICd8LxRlJMMuxCLfU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qAxLC-00Gr3M-M9; Sun, 18 Jun 2023 20:41:34 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: netdev <netdev@vger.kernel.org>
Cc: Russell King <rmk+kernel@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v4 net-next 7/9] net: phy: Add phy_support_eee() indicating MAC support EEE
Date: Sun, 18 Jun 2023 20:41:17 +0200
Message-Id: <20230618184119.4017149-8-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230618184119.4017149-1-andrew@lunn.ch>
References: <20230618184119.4017149-1-andrew@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In order for EEE to operate, both the MAC and the PHY need to support
it, similar to how pause works. Copy the pause concept and add the
call phy_support_eee() which the MAC makes after connecting the PHY to
indicate it supports EEE. phylib will then advertise EEE when auto-neg
is performed.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy_device.c | 18 ++++++++++++++++++
 include/linux/phy.h          |  3 ++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 2cad9cc3f6b8..ae2ebe1df15c 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2762,6 +2762,24 @@ void phy_advertise_supported(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(phy_advertise_supported);
 
+/**
+ * phy_support_eee - Enable support of EEE
+ * @phydev: target phy_device struct
+ *
+ * Description: Called by the MAC to indicate is supports Energy
+ * Efficient Ethernet. This should be called before phy_start() in
+ * order that EEE is negotiated when the link comes up as part of
+ * phy_start(). EEE is enabled by default when the hardware supports
+ * it.
+ */
+void phy_support_eee(struct phy_device *phydev)
+{
+	linkmode_copy(phydev->advertising_eee, phydev->supported_eee);
+	phydev->eee_cfg.tx_lpi_enabled = true;
+	phydev->eee_cfg.eee_enabled = true;
+}
+EXPORT_SYMBOL(phy_support_eee);
+
 /**
  * phy_support_sym_pause - Enable support of symmetrical pause
  * @phydev: target phy_device struct
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 473ddf62bee9..29ae45d37011 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -693,7 +693,7 @@ struct phy_device {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
 	/* used with phy_speed_down */
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_old);
-	/* used for eee validation */
+	/* used for eee validation and configuration*/
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported_eee);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising_eee);
 	bool eee_enabled;
@@ -1903,6 +1903,7 @@ void phy_remove_link_mode(struct phy_device *phydev, u32 link_mode);
 void phy_advertise_supported(struct phy_device *phydev);
 void phy_support_sym_pause(struct phy_device *phydev);
 void phy_support_asym_pause(struct phy_device *phydev);
+void phy_support_eee(struct phy_device *phydev);
 void phy_set_sym_pause(struct phy_device *phydev, bool rx, bool tx,
 		       bool autoneg);
 void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx);
-- 
2.40.1


