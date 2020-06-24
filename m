Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D442070C5
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 12:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390252AbgFXKGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 06:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390133AbgFXKGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 06:06:55 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B0EC061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 03:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CStELbkh86G8AgHdyDC7Xkx9hhRI6fnTcbFBsZUkuCc=; b=KMBPVqm5gBFohINMZAjAMV1Uk1
        5tLnT8sNYfASJyrdnD06HZN5yecbcdD284cpa9jQgraWSIYkF+AmZH9j9XtR1ehtR9/Y8vYiP1Trh
        4fHzgyAhWzSWIcHlPBslGVDDMaDgCncCCb8Ud2LR5fsl3q3iWR3DLNNcr/ts1f0s9QR/J8zPA2Nmm
        nsPVHb93QOIFIAygGJVevtMTtVWvJvMttDJksaQDcnwfWO9G0l/TDAGtYLrrO6vefxWlLopaMoiPj
        vbaqjsL7cK5wTDl4JiEh8CqFTpwRnDz8KaOB7/qMxxtfFmZeRklzBpqed+dOdJwcrfyjuzs6Em+e1
        N/8hgbZA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57874 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jo2Iw-0002rV-9t; Wed, 24 Jun 2020 11:06:54 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jo2Iw-0005N1-3b; Wed, 24 Jun 2020 11:06:54 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?Q?Daniel_Gonz=C3=A1lez_Cabanelas?= <dgcbueu@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: phylink: add phylink_speed_(up|down) interface
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jo2Iw-0005N1-3b@rmk-PC.armlinux.org.uk>
Date:   Wed, 24 Jun 2020 11:06:54 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an interface for the phy_speed_(up|down) functions when a driver
makes use of phylink. These pass the call through to phylib when we
have a normal PHY attached (i.o.w., not a PHY on a SFP module.)

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
This is to support the work by Daniel González Cabanelas for mvneta WoL,
but at the present time, this has no users (hence no patch 2). I hope
mvneta WoL support can be revived soon with the aid of this patch.
(Resent with Daniel's name fixed.)

 drivers/net/phy/phylink.c | 48 +++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  2 ++
 2 files changed, 50 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 7ce787c227b3..7cda1646bbf7 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1826,6 +1826,54 @@ int phylink_mii_ioctl(struct phylink *pl, struct ifreq *ifr, int cmd)
 }
 EXPORT_SYMBOL_GPL(phylink_mii_ioctl);
 
+/**
+ * phylink_speed_down() - set the non-SFP PHY to lowest speed supported by both
+ *   link partners
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ * @sync: perform action synchronously
+ *
+ * If we have a PHY that is not part of a SFP module, then set the speed
+ * as described in the phy_speed_down() function. Please see this function
+ * for a description of the @sync parameter.
+ *
+ * Returns zero if there is no PHY, otherwise as per phy_speed_down().
+ */
+int phylink_speed_down(struct phylink *pl, bool sync)
+{
+	int ret = 0;
+
+	ASSERT_RTNL();
+
+	if (!pl->sfp_bus && pl->phydev)
+		ret = phy_speed_down(pl->phydev, sync);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phylink_speed_down);
+
+/**
+ * phylink_speed_up() - restore the advertised speeds prior to the call to
+ *   phylink_speed_down()
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ *
+ * If we have a PHY that is not part of a SFP module, then restore the
+ * PHY speeds as per phy_speed_up().
+ *
+ * Returns zero if there is no PHY, otherwise as per phy_speed_up().
+ */
+int phylink_speed_up(struct phylink *pl)
+{
+	int ret = 0;
+
+	ASSERT_RTNL();
+
+	if (!pl->sfp_bus && pl->phydev)
+		ret = phy_speed_up(pl->phydev);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phylink_speed_up);
+
 static void phylink_sfp_attach(void *upstream, struct sfp_bus *bus)
 {
 	struct phylink *pl = upstream;
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index cc5b452a184e..b32b8b45421b 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -392,6 +392,8 @@ int phylink_init_eee(struct phylink *, bool);
 int phylink_ethtool_get_eee(struct phylink *, struct ethtool_eee *);
 int phylink_ethtool_set_eee(struct phylink *, struct ethtool_eee *);
 int phylink_mii_ioctl(struct phylink *, struct ifreq *, int);
+int phylink_speed_down(struct phylink *pl, bool sync);
+int phylink_speed_up(struct phylink *pl);
 
 #define phylink_zero(bm) \
 	bitmap_zero(bm, __ETHTOOL_LINK_MODE_MASK_NBITS)
-- 
2.20.1

