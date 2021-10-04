Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573A54209B3
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 13:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbhJDLFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 07:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbhJDLFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 07:05:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87962C061745
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 04:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xguEgHuFY6y3s57+EbqlUxB6YTGzD6RmLvl/ZTSUxeE=; b=MX4NjjQXecCsWo+3QiLtQ0+h/D
        Tx4KsydbkNka1DzfZzNbMoSN+vJHc1BfyPSslkoz/t/6FWCv9q05lepI4GCkB22LwHV+YIlINUYTT
        LTlYw+M6v72RRdz1FJdyaYc47dfNXgrKem0G9F99Zql7UHKrwM2rw1R2SgF6tCjTYZiqG1J+bfkw2
        7HSpuJJsiuUJ9x5Yy8Mns8YTeTz6psVFaZkF073cmklg9Jj+hLa1MLJ0spptC2y68AYo+CHPDi07R
        bYKM4I1Hv5LtXhZ3MYsdWlJR4t3ebHbeZ+GUvhFmxdYsJ5xRUj1ON42MWOLl6kymCoylFgNcnXX40
        8HisrC0A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:42616 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mXLkm-0007VI-UZ; Mon, 04 Oct 2021 12:03:28 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mXLkm-000pd5-Hm; Mon, 04 Oct 2021 12:03:28 +0100
In-Reply-To: <YVrfTBYg7cHLzNXM@shell.armlinux.org.uk>
References: <YVrfTBYg7cHLzNXM@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/2] net: phylink: add phylink_set_10g_modes() helper
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mXLkm-000pd5-Hm@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 04 Oct 2021 12:03:28 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper for setting 10Gigabit modes, so we have one central
place that sets all appropriate 10G modes for a driver.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 11 +++++++++++
 include/linux/phylink.h   |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 5a58c77d0002..b32774fd65f8 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -132,6 +132,17 @@ void phylink_set_port_modes(unsigned long *mask)
 }
 EXPORT_SYMBOL_GPL(phylink_set_port_modes);
 
+void phylink_set_10g_modes(unsigned long *mask)
+{
+	phylink_set(mask, 10000baseT_Full);
+	phylink_set(mask, 10000baseCR_Full);
+	phylink_set(mask, 10000baseSR_Full);
+	phylink_set(mask, 10000baseLR_Full);
+	phylink_set(mask, 10000baseLRM_Full);
+	phylink_set(mask, 10000baseER_Full);
+}
+EXPORT_SYMBOL_GPL(phylink_set_10g_modes);
+
 static int phylink_is_empty_linkmode(const unsigned long *linkmode)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(tmp) = { 0, };
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 237291196ce2..f7b5ed06a815 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -484,6 +484,7 @@ int phylink_speed_up(struct phylink *pl);
 #define phylink_test(bm, mode)	__phylink_do_bit(test_bit, bm, mode)
 
 void phylink_set_port_modes(unsigned long *bits);
+void phylink_set_10g_modes(unsigned long *mask);
 void phylink_helper_basex_speed(struct phylink_link_state *state);
 
 void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
-- 
2.30.2

