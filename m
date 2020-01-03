Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C599A12FD5D
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgACUBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:01:50 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41714 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbgACUBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:01:49 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so43475684wrw.8
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 12:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0NuFrsJsJe1ZD2gjej39RnA7WNRUq88hu4Umo0kelpg=;
        b=uM6Y4uLo2XVDWPL1dmP9WaJtixPkJnT/5MjVh0nKjlsJOsSIkR+9XDo7im4N6QQW+j
         L1UCz5RU8k5ewOGhFD8whikhic0q/iAwRBP+otinoriYpnO2yWW7Es0w6EjxQ9jpGSRP
         9rmlaoDsouaRbV4zp6bXVTU6oFvkQhfOWGbQhL1yyz/ckCMgJa1JCaw7FPUXCXKgOQ09
         HvAcDqaMcc0AEvHaWB4K8WO4RJYVsgQHnfKKkJr83bAxOADrdxLDODRsCfZUxowr0aKV
         gPskR1TfFZCYQw/EIU6aR55qvjY3NnINMLA+Dkevynr68snQZWLGspZlaBGshZUCt2/x
         9/hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0NuFrsJsJe1ZD2gjej39RnA7WNRUq88hu4Umo0kelpg=;
        b=HFa74q7n3FwgQRcoPjpmIvQrfj+R9zqttr7X3rYttZxYyuopd6sgdmpai7gFTBJS9f
         FjJ92yzRZdHfW2Htsq4KZeIwktz31iK2lsE44lvh/bJ8nnhy3KwpbIIjKV6vEo+P/fnn
         /U51GQQbAtRgssXWVeYk3n2HFXN3WlfCSb5lNfUQRQJ57iQJroCcGy+3ZuiVVsILg0BO
         0qDrpm18Fm38/UlQ8EehSj7FydB8q+tVHv00zAo+MJ1YC3e7WAcXuH8pStdz9907aCvW
         3+aurfuRIDPGEtM5gTqkKsHjmmATBgl1BoYdTF4Aw4lQD4660CWgsdrXCRDgUyQqc2gY
         g64g==
X-Gm-Message-State: APjAAAVz0oXzo3rICcAKr3uwn5URHuQJWQcQ6f+04PuCImqexUh+0oVi
        upJubjlZnCPTgyZJZK6ejjY=
X-Google-Smtp-Source: APXvYqxQndrgUkenY7kGV8MH/BKePURHVrMDi8nRkXD0D9sz4ER8rTiMfNQM/3Xefz8UWDIoFORL4g==
X-Received: by 2002:a5d:540f:: with SMTP id g15mr86351917wrv.86.1578081706316;
        Fri, 03 Jan 2020 12:01:46 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id e12sm60998154wrn.56.2020.01.03.12.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 12:01:45 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 1/9] mii: Add helpers for parsing SGMII auto-negotiation
Date:   Fri,  3 Jan 2020 22:01:19 +0200
Message-Id: <20200103200127.6331-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200103200127.6331-1-olteanv@gmail.com>
References: <20200103200127.6331-1-olteanv@gmail.com>
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

