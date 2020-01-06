Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C93AB130B8B
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 02:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgAFBef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 20:34:35 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38390 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbgAFBee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 20:34:34 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so48026493wrh.5
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 17:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iX8K9px86srtZmBfoPBz4w06gqN+iqnuOtG/sIYsq/E=;
        b=KffqfB1akbtMqpXt/0rtmq2CGesyWeNRunn4XRkAyZCIcTYqd6PPzronS2wamoA+Ow
         n4jJ2elG0WRRdGPYR+9mdzTWNBt+5tL6yitLqEiyaeOLIYaWrX0MXDFtb44aclraj/9p
         8yWoiXUHR8q8d/VssHjd+debZSEKubUm05RgT2eRw0eZiBTOi848aL9OgDoitDAEPKbK
         PyHBFIYaj8KrcKozNQ6ETkbDFQ6/JLwO2D1NS97YUnmt273Axj3o3qAo+BOAiSOAxxPf
         cQSbCg5+ZUun1i+l0ZAo8HoeOU1NjE6YbfrMAgQPWW7opLlRM8az+JuzODDmBZ5G5I7b
         GYuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iX8K9px86srtZmBfoPBz4w06gqN+iqnuOtG/sIYsq/E=;
        b=B7YCN97IVNoWMbe1QCd2tCMxrwuslafjVK/iIv9ua03NFeNk4xjzrAFxdgLyVA1ZU5
         bzB7MRpJ/wgmIz+8ga0V9jo6cSrJEC1XE7c8iXq+8cZwdX5ii3xiYAL3as7GUQhe0kag
         GaSikAKEdjpik6hYSTX/yG3I/UoRj4MUo8v14InsknUg1QSpzw2Af0v3xmnQuMbegptW
         AkgyAZPj85sOZsQFiB011NhFK9gUqM9bsAhx0h8d22XA4KyO3UltO4bzPpfEeNCJNUdf
         Q63BACTW3d9AzrJhfGJEM82wVGRt+ZGt/XQ8RtoTIV8oR5IKBKYMO2nDbIsCm5ijPM3b
         RFGQ==
X-Gm-Message-State: APjAAAV8X6g3/0R5g60DPlzjcRQmoXa7yShJf7nnjshwOTFueunkvSeC
        x3rvopPwZHCitQafO13UrxQ=
X-Google-Smtp-Source: APXvYqzEqXNDshv8bs26EW2cfXl4Bv4xJy3jnCPfJw20MvP7SvRZkgG8SFYz6zJNK+DjKXyJ1EliKw==
X-Received: by 2002:a5d:6ac2:: with SMTP id u2mr102710983wrw.233.1578274472754;
        Sun, 05 Jan 2020 17:34:32 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id l6sm1412756wmf.21.2020.01.05.17.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2020 17:34:32 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v5 net-next 1/9] mii: Add helpers for parsing SGMII auto-negotiation
Date:   Mon,  6 Jan 2020 03:34:09 +0200
Message-Id: <20200106013417.12154-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200106013417.12154-1-olteanv@gmail.com>
References: <20200106013417.12154-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Typically a MAC PCS auto-configures itself after it receives the
negotiated copper-side link settings from the PHY, but some MAC devices
are more special and need manual interpretation of the SGMII AN result.

In other cases, the PCS exposes the entire tx_config_reg base page as it
is transmitted on the wire during auto-negotiation, so it makes sense to
be able to decode the equivalent lp_advertised bit mask from the raw u16
(of course, "lp" considering the PCS to be the local PHY).

Therefore, add the bit definitions for the SGMII registers 4 and 5
(local device ability, link partner ability), as well as a link_mode
conversion helper that can be used to feed the AN results into
phy_resolve_aneg_linkmode.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v5:
- None.

Changes in v4:
- None.

Changes in v3:
- Moved the LPA_* and ADVERTISE_* bits for SGMII to a separate group of
  defines.

 include/linux/mii.h      | 50 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/mii.h | 12 ++++++++++
 2 files changed, 62 insertions(+)

diff --git a/include/linux/mii.h b/include/linux/mii.h
index 4ce8901a1af6..18c6208f56fc 100644
--- a/include/linux/mii.h
+++ b/include/linux/mii.h
@@ -372,6 +372,56 @@ static inline u32 mii_lpa_to_ethtool_lpa_x(u32 lpa)
 	return result | mii_adv_to_ethtool_adv_x(lpa);
 }
 
+/**
+ * mii_lpa_mod_linkmode_adv_sgmii
+ * @lp_advertising: pointer to destination link mode.
+ * @lpa: value of the MII_LPA register
+ *
+ * A small helper function that translates MII_LPA bits to
+ * linkmode advertisement settings for SGMII.
+ * Leaves other bits unchanged.
+ */
+static inline void
+mii_lpa_mod_linkmode_lpa_sgmii(unsigned long *lp_advertising, u32 lpa)
+{
+	u32 speed_duplex = lpa & LPA_SGMII_DPX_SPD_MASK;
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT, lp_advertising,
+			 speed_duplex == LPA_SGMII_1000HALF);
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, lp_advertising,
+			 speed_duplex == LPA_SGMII_1000FULL);
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT, lp_advertising,
+			 speed_duplex == LPA_SGMII_100HALF);
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, lp_advertising,
+			 speed_duplex == LPA_SGMII_100FULL);
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, lp_advertising,
+			 speed_duplex == LPA_SGMII_10HALF);
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, lp_advertising,
+			 speed_duplex == LPA_SGMII_10FULL);
+}
+
+/**
+ * mii_lpa_to_linkmode_adv_sgmii
+ * @advertising: pointer to destination link mode.
+ * @lpa: value of the MII_LPA register
+ *
+ * A small helper function that translates MII_ADVERTISE bits
+ * to linkmode advertisement settings when in SGMII mode.
+ * Clears the old value of advertising.
+ */
+static inline void mii_lpa_to_linkmode_lpa_sgmii(unsigned long *lp_advertising,
+						 u32 lpa)
+{
+	linkmode_zero(lp_advertising);
+
+	mii_lpa_mod_linkmode_lpa_sgmii(lp_advertising, lpa);
+}
+
 /**
  * mii_adv_mod_linkmode_adv_t
  * @advertising:pointer to destination link mode.
diff --git a/include/uapi/linux/mii.h b/include/uapi/linux/mii.h
index 51b48e4be1f2..0b9c3beda345 100644
--- a/include/uapi/linux/mii.h
+++ b/include/uapi/linux/mii.h
@@ -131,6 +131,18 @@
 #define NWAYTEST_LOOPBACK	0x0100	/* Enable loopback for N-way   */
 #define NWAYTEST_RESV2		0xfe00	/* Unused...                   */
 
+/* MAC and PHY tx_config_Reg[15:0] for SGMII in-band auto-negotiation.*/
+#define ADVERTISE_SGMII		0x0001	/* MAC can do SGMII            */
+#define LPA_SGMII		0x0001	/* PHY can do SGMII            */
+#define LPA_SGMII_DPX_SPD_MASK	0x1C00	/* SGMII duplex and speed bits */
+#define LPA_SGMII_10HALF	0x0000	/* Can do 10mbps half-duplex   */
+#define LPA_SGMII_10FULL	0x1000	/* Can do 10mbps full-duplex   */
+#define LPA_SGMII_100HALF	0x0400	/* Can do 100mbps half-duplex  */
+#define LPA_SGMII_100FULL	0x1400	/* Can do 100mbps full-duplex  */
+#define LPA_SGMII_1000HALF	0x0800	/* Can do 1000mbps half-duplex */
+#define LPA_SGMII_1000FULL	0x1800	/* Can do 1000mbps full-duplex */
+#define LPA_SGMII_LINK		0x8000	/* PHY link with copper-side partner */
+
 /* 1000BASE-T Control register */
 #define ADVERTISE_1000FULL	0x0200  /* Advertise 1000BASE-T full duplex */
 #define ADVERTISE_1000HALF	0x0100  /* Advertise 1000BASE-T half duplex */
-- 
2.17.1

