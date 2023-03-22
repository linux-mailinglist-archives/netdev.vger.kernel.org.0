Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D66E6C49C8
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 13:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbjCVMAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 08:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbjCVMAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 08:00:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D497F58B70;
        Wed, 22 Mar 2023 05:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZpAtKl/RV4mqUVq/4aXiz/Cd3G2od94mTwE3ws+jErE=; b=xWAZS+Epu9VEE+Q1zJyJkkG5P0
        RCe1jX/Ke7K54z2sAcwM/RRGjbwfjn642BDtIRudf7IyrQUIU2Hv0QZ+CuX/zyOIjva31JJTlKPrX
        Zrob4y4ZzWktR31ueqz0Kz/XfGOyvLQi9F4aeGZb3UvfcvaI58jT481OAvfNmSuDETMTlWBq1ywvU
        t0Sl7vDq47VS9F/6G4BaXk5IA5i6Hix2s3Sm3nhgGCmET4T+lr8fLNH+zDx44uW+aUzr1tGm2sZSL
        RJFF9mnrU4Ydx+dubFMrchiBu3Pq/gj7+LtaIJioFotxGiguJYKCYgXOYhjxhVHfVm5nR7qNBl5A9
        bc12tJ2Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:37350 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pex8L-00035Q-QF; Wed, 22 Mar 2023 12:00:01 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pex8L-00Dvnl-1F; Wed, 22 Mar 2023 12:00:01 +0000
In-Reply-To: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH RFC net-next 2/7] net: phylink: provide
 phylink_find_max_speed()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pex8L-00Dvnl-1F@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 22 Mar 2023 12:00:01 +0000
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 32 ++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  1 +
 2 files changed, 33 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index f7da96f0c75b..5cd29cceaf93 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -426,6 +426,38 @@ static unsigned long phylink_cap_from_speed_duplex(int speed,
 	return 0;
 }
 
+/**
+ * phylink_find_max_speed
+ * @caps: bitmask of MAC capabilities
+ * @speed: pointer to int for speed
+ * @duplex: pointer to int for duplex
+ */
+int phylink_find_max_speed(unsigned long caps, int *speed, int *duplex)
+{
+	static const int duplex_order[] = {
+		DUPLEX_FULL,
+		DUPLEX_HALF,
+	};
+	int i, j;
+
+	*speed = SPEED_UNKNOWN;
+	*duplex = DUPLEX_UNKNOWN;
+
+	for (j = 0; j < ARRAY_SIZE(duplex_order); j++) {
+		for (i = 0; i < ARRAY_SIZE(phylink_caps_params); i++) {
+			if (phylink_caps_params[i].duplex == duplex_order[j] &&
+			    caps & phylink_caps_params[i].mask) {
+				*speed = phylink_caps_params[i].speed;
+				*duplex = phylink_caps_params[i].duplex;
+				return 0;
+			}
+		}
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(phylink_find_max_speed);
+
 /**
  * phylink_get_capabilities() - get capabilities for a given MAC
  * @interface: phy interface mode defined by &typedef phy_interface_t
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 9ff56b050584..f8e20ff1e70e 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -557,6 +557,7 @@ void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 		 phy_interface_t interface, int speed, int duplex);
 #endif
 
+int phylink_find_max_speed(unsigned long caps, int *speed, int *duplex);
 void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps);
 unsigned long phylink_get_capabilities(phy_interface_t interface,
 				       unsigned long mac_capabilities,
-- 
2.30.2

