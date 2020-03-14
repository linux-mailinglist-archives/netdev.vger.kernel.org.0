Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7031856DC
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbgCOBaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:30:21 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55780 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbgCOBaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:30:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oD4RdXMjENC2iaiU1dWg4bSv1ayAAhXvLaAZ52LSrxA=; b=te7mNVaBSp3Lokx4MltctrWXpI
        uQ6EOWfYjLvMwPJtbV2pNzjdOxZ4QNQkzMP+kqIvS+bHQCBl1JQ/2ncrixDEQElZ6X1uemjmLaRFo
        NOzYTY41G2lQUCY9/DOq+4r5WbIppo/3elEiWlEqLA22LLBy7HnAMtUfs7N+jEoX6suIXIzu/vwsO
        nQKQOC7Fa/aZIdfSfuzzK1874RgB7SMEXagtEjyv+aioWlzy46SwFLD1ObkRkfXkMP3x5OCHql6Eg
        I9OUabQaul6YmH0hzKy7pzXO/tjJYkEtQBWVdNfcU+zOs7aIeI6V3d5AFVPHaB6xb7XKS+/9NjB0F
        YAzlLxmQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57462 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jD3ju-00069D-Jw; Sat, 14 Mar 2020 10:09:54 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jD3jt-000664-PK; Sat, 14 Mar 2020 10:09:53 +0000
In-Reply-To: <20200314100916.GE25745@shell.armlinux.org.uk>
References: <20200314100916.GE25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: mii: convert mii_lpa_to_ethtool_lpa_x() to
 linkmode variant
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jD3jt-000664-PK@rmk-PC.armlinux.org.uk>
Date:   Sat, 14 Mar 2020 10:09:53 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a LPA to linkmode decoder for 1000BASE-X protocols; this decoder
only provides the modify semantics similar to other such decoders.
This replaces the unused mii_lpa_to_ethtool_lpa_x() helper.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 include/linux/mii.h | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/include/linux/mii.h b/include/linux/mii.h
index 18c6208f56fc..309de4a3e6e7 100644
--- a/include/linux/mii.h
+++ b/include/linux/mii.h
@@ -354,24 +354,6 @@ static inline u32 mii_adv_to_ethtool_adv_x(u32 adv)
 	return result;
 }
 
-/**
- * mii_lpa_to_ethtool_lpa_x
- * @adv: value of the MII_LPA register
- *
- * A small helper function that translates MII_LPA
- * bits, when in 1000Base-X mode, to ethtool
- * LP advertisement settings.
- */
-static inline u32 mii_lpa_to_ethtool_lpa_x(u32 lpa)
-{
-	u32 result = 0;
-
-	if (lpa & LPA_LPACK)
-		result |= ADVERTISED_Autoneg;
-
-	return result | mii_adv_to_ethtool_adv_x(lpa);
-}
-
 /**
  * mii_lpa_mod_linkmode_adv_sgmii
  * @lp_advertising: pointer to destination link mode.
@@ -535,6 +517,25 @@ static inline u32 linkmode_adv_to_lcl_adv_t(unsigned long *advertising)
 	return lcl_adv;
 }
 
+/**
+ * mii_lpa_mod_linkmode_x - decode the link partner's config_reg to linkmodes
+ * @linkmodes: link modes array
+ * @lpa: config_reg word from link partner
+ * @fd_bit: link mode for 1000XFULL bit
+ */
+static inline void mii_lpa_mod_linkmode_x(unsigned long *linkmodes, u16 lpa,
+					 int fd_bit)
+{
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, linkmodes,
+			 lpa & LPA_LPACK);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT, linkmodes,
+			 lpa & LPA_1000XPAUSE);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, linkmodes,
+			 lpa & LPA_1000XPAUSE_ASYM);
+	linkmode_mod_bit(fd_bit, linkmodes,
+			 lpa & LPA_1000XFULL);
+}
+
 /**
  * mii_advertise_flowctrl - get flow control advertisement flags
  * @cap: Flow control capabilities (FLOW_CTRL_RX, FLOW_CTRL_TX or both)
-- 
2.20.1

