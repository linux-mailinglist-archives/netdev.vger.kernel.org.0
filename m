Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 839271239A8
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfLQWTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:19:43 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:34449 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfLQWTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 17:19:42 -0500
Received: by mail-wr1-f50.google.com with SMTP id t2so166369wrr.1
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 14:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zIIyIkko4h1DI+aDyN7xPGMghof8YCHi0gxIxBowmZc=;
        b=aXH2uvbl3YXFCWVmmUEgXQZyWeYUwg15uGgk5xt0glQR9EjcuYYdaeAvDSEijvN9Vw
         /C/OB/JBAYCJ7ZYmnJ6glY+cJZ+T6iwcGpDQVcT+PFE1E/n+b7rT843KDr+PyFb0otZp
         K9o9N8GbLN2qis93BgmNzxa6mTAo9usXW9s8Phuys6aGbwUIU8p16JUp9muLRdhhjZa9
         GPylpEna640/joZ9aRatElq4FyMw+/NKfAKS63Cxa/9EH6eEB+vBqZYyJcb9ab+WfPal
         YGF3oSME8LdWq5lk4Ah3ryWknAaFFzeTCs8ljxXkCB7OOLcNftqm9ARPBP+MpvOTfBG4
         PinQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zIIyIkko4h1DI+aDyN7xPGMghof8YCHi0gxIxBowmZc=;
        b=pQMEl91KFIxH8l29+ijFA5j4jIcZxucr7PIkDVNyhRLWuUUZXnZDdCUQ+eT2QXpwaD
         kE0r/A2ntkxqLG/W7gPTTpf2eyhd0F6pYG4SKtk88o7z2QCwQuXi5SYx9rIUenTE0jnO
         SgrGKBdojc2zudeeuWy3dFz8Y0R+HJu3/dtR+UmtqSWTJk2yd22xh7JoD4pBXBPCxy8G
         gxTwmOPsRwFdHhtoRFJNzinzfUtborYoxwqjupVQmDoqHYIh3B9jqSaMk+ZkUgZ83g88
         Zu9/tAK0jcZ2NjLnKQ80/91D/3wabZQhNIS5+9Qo3IBeQ5vcSb0Jmho1ka0RCWEkzDiq
         Y8vg==
X-Gm-Message-State: APjAAAW9klb5TvGwaHrkGFnMY5nFb0auBGbRsE23/9QSKpa5N8yAluzz
        r+TWpM1zPd6h6wRTgYQW9xo=
X-Google-Smtp-Source: APXvYqwwUkjUalYjNYhTF97eTxlGBk+h2OKOhilSmpX4rOh6MkvAKvaHmdUg8Fzy8exvN/zkH+Td7Q==
X-Received: by 2002:a5d:52c4:: with SMTP id r4mr37343975wrv.368.1576621180273;
        Tue, 17 Dec 2019 14:19:40 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id e6sm196808wru.44.2019.12.17.14.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:19:39 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 1/8] mii: Add helpers for parsing SGMII auto-negotiation
Date:   Wed, 18 Dec 2019 00:18:24 +0200
Message-Id: <20191217221831.10923-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191217221831.10923-1-olteanv@gmail.com>
References: <20191217221831.10923-1-olteanv@gmail.com>
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
 include/linux/mii.h      | 50 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/mii.h | 10 ++++++++++
 2 files changed, 60 insertions(+)

diff --git a/include/linux/mii.h b/include/linux/mii.h
index 4ce8901a1af6..18c6208f56fc 100644
--- a/include/linux/mii.h
+++ b/include/linux/mii.h
@@ -373,6 +373,56 @@ static inline u32 mii_lpa_to_ethtool_lpa_x(u32 lpa)
 }
 
 /**
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
+/**
  * mii_adv_mod_linkmode_adv_t
  * @advertising:pointer to destination link mode.
  * @adv: value of the MII_ADVERTISE register
diff --git a/include/uapi/linux/mii.h b/include/uapi/linux/mii.h
index 51b48e4be1f2..dc3b5d635beb 100644
--- a/include/uapi/linux/mii.h
+++ b/include/uapi/linux/mii.h
@@ -71,6 +71,7 @@
 /* Advertisement control register. */
 #define ADVERTISE_SLCT		0x001f	/* Selector bits               */
 #define ADVERTISE_CSMA		0x0001	/* Only selector supported     */
+#define ADVERTISE_SGMII		0x0001	/* Can do SGMII                */
 #define ADVERTISE_10HALF	0x0020	/* Try for 10mbps half-duplex  */
 #define ADVERTISE_1000XFULL	0x0020	/* Try for 1000BASE-X full-duplex */
 #define ADVERTISE_10FULL	0x0040	/* Try for 10mbps full-duplex  */
@@ -94,6 +95,7 @@
 
 /* Link partner ability register. */
 #define LPA_SLCT		0x001f	/* Same as advertise selector  */
+#define LPA_SGMII		0x0001	/* Can do SGMII                */
 #define LPA_10HALF		0x0020	/* Can do 10mbps half-duplex   */
 #define LPA_1000XFULL		0x0020	/* Can do 1000BASE-X full-duplex */
 #define LPA_10FULL		0x0040	/* Can do 10mbps full-duplex   */
@@ -104,11 +106,19 @@
 #define LPA_1000XPAUSE_ASYM	0x0100	/* Can do 1000BASE-X pause asym*/
 #define LPA_100BASE4		0x0200	/* Can do 100mbps 4k packets   */
 #define LPA_PAUSE_CAP		0x0400	/* Can pause                   */
+#define LPA_SGMII_DPX_SPD_MASK	0x1C00	/* SGMII duplex and speed bits */
+#define LPA_SGMII_10HALF	0x0000	/* Can do SGMII 10mbps half-duplex */
+#define LPA_SGMII_10FULL	0x1000	/* Can do SGMII 10mbps full-duplex */
+#define LPA_SGMII_100HALF	0x0400	/* Can do SGMII 100mbps half-duplex */
+#define LPA_SGMII_100FULL	0x1400	/* Can do SGMII 100mbps full-duplex */
 #define LPA_PAUSE_ASYM		0x0800	/* Can pause asymetrically     */
+#define LPA_SGMII_1000HALF	0x0800	/* Can do SGMII 1000mbps half-duplex */
+#define LPA_SGMII_1000FULL	0x1800	/* Can do SGMII 1000mbps full-duplex */
 #define LPA_RESV		0x1000	/* Unused...                   */
 #define LPA_RFAULT		0x2000	/* Link partner faulted        */
 #define LPA_LPACK		0x4000	/* Link partner acked us       */
 #define LPA_NPAGE		0x8000	/* Next page bit               */
+#define LPA_SGMII_LINK		0x8000	/* Link partner has link       */
 
 #define LPA_DUPLEX		(LPA_10FULL | LPA_100FULL)
 #define LPA_100			(LPA_100FULL | LPA_100HALF | LPA_100BASE4)
-- 
2.7.4

