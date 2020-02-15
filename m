Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4ECB15FF11
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 16:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgBOPte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 10:49:34 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34070 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgBOPtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 10:49:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uRdh10xstUsKts8l1DdYb6YWUFYXDIBYpPF52fm9EEk=; b=fzOjOFuuOtqDfWlGb+HVojQ8Pz
        lUpEVPwckXpOHw3iT0sL1xeqN9db4SqI2qM2FwPbtEEYWjmrcwuMBvmoB4V9X/eKY3chLdp7MOxpu
        iVQxx/eR/cI75eH+UlFmJkTjFCjNs/8m/Tnb7+djluRvc428TIf7+0i8QL8OaEb8gVrXqHP7hQUFj
        Ymjo/rSNjk+hl1BsrW+YMbFcBs/R7/lFMFG4o/BoOmnWwFYRRZannHyANocbOX/ur75mRUoxM0oIx
        RNXGQClRuwuwtv9p3qDtgFL4E4CNuIdcsFrUKzn92o3XeRZC4UpKtvGmAl1//7VhCusL9r05AogKm
        FwUyFraw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:41198 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j2zh9-0005jI-RV; Sat, 15 Feb 2020 15:49:27 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j2zh9-0003X2-9y; Sat, 15 Feb 2020 15:49:27 +0000
In-Reply-To: <20200215154839.GR25745@shell.armlinux.org.uk>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 02/10] net: add helpers to resolve negotiated flow
 control
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j2zh9-0003X2-9y@rmk-PC.armlinux.org.uk>
Date:   Sat, 15 Feb 2020 15:49:27 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a couple of helpers to resolve negotiated flow control. Two helpers
are provided:

- linkmode_resolve_pause() which takes the link partner and local
  advertisements, and decodes whether we should enable TX or RX pause
  at the MAC. This is useful outside of phylib, e.g. in phylink.
- phy_get_pause(), which returns the TX/RX enablement status for the
  current negotiation results of the PHY.

This allows us to centralise the flow control resolution, rather than
spreading it around.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/Makefile     |  3 ++-
 drivers/net/phy/linkmode.c   | 44 ++++++++++++++++++++++++++++++++++++
 drivers/net/phy/phy_device.c | 26 +++++++++++++++++++++
 include/linux/linkmode.h     |  4 ++++
 include/linux/phy.h          |  3 +++
 5 files changed, 79 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/phy/linkmode.c

diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index fe5badf13b65..d523fd5670e4 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -1,7 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for Linux PHY drivers and MDIO bus drivers
 
-libphy-y			:= phy.o phy-c45.o phy-core.o phy_device.o
+libphy-y			:= phy.o phy-c45.o phy-core.o phy_device.o \
+				   linkmode.o
 mdio-bus-y			+= mdio_bus.o mdio_device.o
 
 ifdef CONFIG_MDIO_DEVICE
diff --git a/drivers/net/phy/linkmode.c b/drivers/net/phy/linkmode.c
new file mode 100644
index 000000000000..969918795228
--- /dev/null
+++ b/drivers/net/phy/linkmode.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0+
+#include <linux/linkmode.h>
+
+/**
+ * linkmode_resolve_pause - resolve the allowable pause modes
+ * @local_adv: local advertisement in ethtool format
+ * @partner_adv: partner advertisement in ethtool format
+ * @tx_pause: pointer to bool to indicate whether transmit pause should be
+ * enabled.
+ * @rx_pause: pointer to bool to indicate whether receive pause should be
+ * enabled.
+ *
+ * Flow control is resolved according to our and the link partners
+ * advertisements using the following drawn from the 802.3 specs:
+ *  Local device  Link partner
+ *  Pause AsymDir Pause AsymDir Result
+ *    0     X       0     X     Disabled
+ *    0     1       1     0     Disabled
+ *    0     1       1     1     TX
+ *    1     0       0     X     Disabled
+ *    1     X       1     X     TX+RX
+ *    1     1       0     1     RX
+ */
+void linkmode_resolve_pause(const unsigned long *local_adv,
+			    const unsigned long *partner_adv,
+			    bool *tx_pause, bool *rx_pause)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(m);
+
+	linkmode_and(m, local_adv, partner_adv);
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT, m)) {
+		*tx_pause = true;
+		*rx_pause = true;
+	} else if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, m)) {
+		*tx_pause = linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+					      partner_adv);
+		*rx_pause = linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+					      local_adv);
+	} else {
+		*tx_pause = false;
+		*rx_pause = false;
+	}
+}
+EXPORT_SYMBOL_GPL(linkmode_resolve_pause);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 6a5056e0ae77..f5a7a077ec1f 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2409,6 +2409,32 @@ bool phy_validate_pause(struct phy_device *phydev,
 }
 EXPORT_SYMBOL(phy_validate_pause);
 
+/**
+ * phy_get_pause - resolve negotiated pause modes
+ * @phydev: phy_device struct
+ * @tx_pause: pointer to bool to indicate whether transmit pause should be
+ * enabled.
+ * @rx_pause: pointer to bool to indicate whether receive pause should be
+ * enabled.
+ *
+ * Resolve and return the flow control modes according to the negotiation
+ * result. This includes checking that we are operating in full duplex mode.
+ * See linkmode_resolve_pause() for further details.
+ */
+void phy_get_pause(struct phy_device *phydev, bool *tx_pause, bool *rx_pause)
+{
+	if (phydev->duplex != DUPLEX_FULL) {
+		*tx_pause = false;
+		*rx_pause = false;
+		return;
+	}
+
+	return linkmode_resolve_pause(phydev->advertising,
+				      phydev->lp_advertising,
+				      tx_pause, rx_pause);
+}
+EXPORT_SYMBOL(phy_get_pause);
+
 static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 {
 	return phydrv->config_intr && phydrv->ack_interrupt;
diff --git a/include/linux/linkmode.h b/include/linux/linkmode.h
index 8e5b352e44f2..9ec210f31d06 100644
--- a/include/linux/linkmode.h
+++ b/include/linux/linkmode.h
@@ -88,4 +88,8 @@ static inline int linkmode_subset(const unsigned long *src1,
 	return bitmap_subset(src1, src2, __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
+void linkmode_resolve_pause(const unsigned long *local_adv,
+			    const unsigned long *partner_adv,
+			    bool *tx_pause, bool *rx_pause);
+
 #endif /* __LINKMODE_H */
diff --git a/include/linux/phy.h b/include/linux/phy.h
index c570e162e05e..80f8b2158271 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1257,6 +1257,9 @@ void phy_set_sym_pause(struct phy_device *phydev, bool rx, bool tx,
 void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx);
 bool phy_validate_pause(struct phy_device *phydev,
 			struct ethtool_pauseparam *pp);
+void phy_get_pause(struct phy_device *phydev, bool *tx_pause, bool *rx_pause);
+void phy_resolve_pause(unsigned long *local_adv, unsigned long *partner_adv,
+		       bool *tx_pause, bool *rx_pause);
 
 int phy_register_fixup(const char *bus_id, u32 phy_uid, u32 phy_uid_mask,
 		       int (*run)(struct phy_device *));
-- 
2.20.1

