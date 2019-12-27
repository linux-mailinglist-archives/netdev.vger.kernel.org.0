Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDFB12BB4F
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 22:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfL0Vg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 16:36:56 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37002 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbfL0Vgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 16:36:53 -0500
Received: by mail-wr1-f66.google.com with SMTP id w15so14650613wru.4
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 13:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QP/2Bmqa2OlptzTt4Bt0tS4N2p0i9VyZ3bTfTiXn7q8=;
        b=sVIv1jKIsgU/T4p7UpB1ifp+qeMzo1AC54IkTW3fdMcbxWhSfOjUiqYOfO1UIA/HHv
         LyuTjc/YXiLssdOoox1hpVELPAS1vxGVu7l7rZR31OBsQ4HGbA5b1nM5m/GOCQi7nW2O
         QPgT0vwDwOZBTogvas2O7/WADIgbneQThGOg5o3/SW0nksLz42RcQ0tgs5j7SLSb+qZU
         10RwJswUcMudQhdYAB0fPqndK5hm0KbamyhJvh9+aNu8Gw/R/8MJsDz0195dkjm8fHtb
         D8uUC/4OtMa53/zIMlBCuBdAdWnxcegH1jxAILh/Xt1v+hRLMEzoxeQ9cZi3XSCD7NE9
         Vs0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QP/2Bmqa2OlptzTt4Bt0tS4N2p0i9VyZ3bTfTiXn7q8=;
        b=nfEvZI8N06KlHIhE93J6WUQ0wt0UJ8+l+HPVBnMoBZMRaYLMaHeR0bHji1vETfEoAW
         xMlkqL0je/YiPt2akpMUMAqt3h/Debku9hg5Z0CbqbeF2chDhWHp7zELj7Q0cTWOy0uG
         YU1FTHo2Y80/b9lRZXMkS5imtoi2TMeVonRGPfCItO40kcyVgwlji73KU4ouIuulL9l1
         DL2bx1RzMOSU3R1JWLfb2JsFf07NdrYdvdulF9WvgNx2l0yjlX4NnB+LzheuxedFZgDt
         bVWcwZXBgVxiSWrfFjOvc4z/KEFjxwnIqfEdPs8kQOkA5GPY7HUgRbHCnDGKUwxKFhqx
         KKAw==
X-Gm-Message-State: APjAAAXW/jsEAtb7PjXDLCetim7u255AGjUMRvm6lwEz+33q7j8mz204
        J9b3nr+lit3EdzKXvDVNuFgAgcm6ynacaQ==
X-Google-Smtp-Source: APXvYqyE00+RAxBfKjKAPuKxlfhRMKVCwKbXHjwe0h880jdmTvUNyJPLNa9a2acKW2i0J+9NKMpEZg==
X-Received: by 2002:adf:cf0a:: with SMTP id o10mr42515046wrj.325.1577482610648;
        Fri, 27 Dec 2019 13:36:50 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id v3sm36330504wru.32.2019.12.27.13.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 13:36:50 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 01/11] mii: Add helpers for parsing SGMII auto-negotiation
Date:   Fri, 27 Dec 2019 23:36:16 +0200
Message-Id: <20191227213626.4404-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191227213626.4404-1-olteanv@gmail.com>
References: <20191227213626.4404-1-olteanv@gmail.com>
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

