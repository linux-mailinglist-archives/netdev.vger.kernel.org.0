Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA73E18A718
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgCRVc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:32:27 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43868 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbgCRVc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 17:32:27 -0400
Received: by mail-wr1-f68.google.com with SMTP id b2so257110wrj.10
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 14:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FYYwgn5zja27gxHB30Dof3wp4fAiP/Mr8LvA96t2nLw=;
        b=G3zqk9xwUJ3Yg2zqpIyGZUhvVQDMyuLfDQFZzBnaIuS4DXgOa/qgoRCY2XFIBUhTnK
         eIpNtnuq2a/QqszPT4AujVtWj9X9Q6XWAVP1clG79pTbMzPV+3duWPMkOnntOKxAiGPu
         VIh0//AYUe3LsIiDGmyabAPIjv4Vk/S+qDFrE53Z4REC9/uAPZMzkrD9e/smrXkED0+n
         pWf0ltq/WMZ+zZ1ooNEhsmXQIKO2j+1bAmuZT8kWQSBxAJV6VkLOgiTzAECkQB4KLzwK
         FvW54LqgwjBKxBQwIeoyW2pb6QBD9xT7GNfzVpegmGWzNk5wUVBx2CbWKUjQWmgMv0mF
         3T0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FYYwgn5zja27gxHB30Dof3wp4fAiP/Mr8LvA96t2nLw=;
        b=S+MsVjWT+QkdZ6cO5Hp0uCPeQmO69ZDY3VK390rcmwTfpGjuvBlBVuAUgZrLxXF9Do
         Op0SNXSs+0KBMj/9ml7XQ0bRpobeLG2//y5HzsJ/TNET3cI8i9AsAU2vWVSWQqolCI4d
         krU3IemSFlVVmL4JzH7OfGASNd1+47IFk/63aXZb+8fSYUh6hN5PkO7qq+oDxpBWfRZS
         WIeay5yd7kE2TI92BSCipU4s6PMikt3/q8WGo+vTa5lWTwN6+tIhuUbjTUFSXOPw59Hc
         jZcreTOKyVx4kYaXIRossXN2q5kdI9+GsN7aGkRMxBWTxuTMgLNXFjIHsPBG7R/HIEqT
         332w==
X-Gm-Message-State: ANhLgQ1a/2WV4oBEmhfFHV8lDviZvdqIkTqjL+FewW2HWhAleUP8wtLr
        +tpX9g+uEamnaxWISByQAIiMfMu+
X-Google-Smtp-Source: ADFU+vutm1tTkoLodcBVIjxmcXbhsTAqLtzaO7u72OzRvORROmGf/RKI0BR1++2kfvYeAarriSAodQ==
X-Received: by 2002:adf:a313:: with SMTP id c19mr7592085wrb.411.1584567144823;
        Wed, 18 Mar 2020 14:32:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:c8fb:eee:cf86:ecdf? (p200300EA8F296000C8FB0EEECF86ECDF.dip0.t-ipconnect.de. [2003:ea:8f29:6000:c8fb:eee:cf86:ecdf])
        by smtp.googlemail.com with ESMTPSA id g2sm186083wrs.42.2020.03.18.14.32.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 14:32:24 -0700 (PDT)
Subject: [PATCH net-next 1/3] net: phy: add and use phy_check_downshift
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <6e4ea372-3d05-3446-2928-2c1e76a66faf@gmail.com>
Message-ID: <d2822357-4c1e-a072-632e-a902b04eba7c@gmail.com>
Date:   Wed, 18 Mar 2020 22:29:01 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <6e4ea372-3d05-3446-2928-2c1e76a66faf@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far PHY drivers have to check whether a downshift occurred to be
able to notify the user. To make life of drivers authors a little bit
easier move the downshift notification to phylib. phy_check_downshift()
compares the highest mutually advertised speed with the actual value
of phydev->speed (typically read by the PHY driver from a
vendor-specific register) to detect a downshift.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy-core.c | 33 +++++++++++++++++++++++++++++++++
 drivers/net/phy/phy.c      |  1 +
 include/linux/phy.h        |  1 +
 3 files changed, 35 insertions(+)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index e083e7a76..8e861be73 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -329,6 +329,39 @@ void phy_resolve_aneg_linkmode(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(phy_resolve_aneg_linkmode);
 
+/**
+ * phy_check_downshift - check whether downshift occurred
+ * @phydev: The phy_device struct
+ *
+ * Check whether a downshift to a lower speed occurred. If this should be the
+ * case warn the user.
+ */
+bool phy_check_downshift(struct phy_device *phydev)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(common);
+	int i, speed = SPEED_UNKNOWN;
+
+	if (phydev->autoneg == AUTONEG_DISABLE)
+		return false;
+
+	linkmode_and(common, phydev->lp_advertising, phydev->advertising);
+
+	for (i = 0; i < ARRAY_SIZE(settings); i++)
+		if (test_bit(settings[i].bit, common)) {
+			speed = settings[i].speed;
+			break;
+		}
+
+	if (phydev->speed == speed)
+		return false;
+
+	phydev_warn(phydev, "Downshift occurred from negotiated speed %s to actual speed %s, check cabling!\n",
+		    phy_speed_to_str(speed), phy_speed_to_str(phydev->speed));
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(phy_check_downshift);
+
 static int phy_resolve_min_speed(struct phy_device *phydev, bool fdx_only)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(common);
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index d71212a41..067ff5fec 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -507,6 +507,7 @@ static int phy_check_link_status(struct phy_device *phydev)
 		return err;
 
 	if (phydev->link && phydev->state != PHY_RUNNING) {
+		phy_check_downshift(phydev);
 		phydev->state = PHY_RUNNING;
 		phy_link_up(phydev);
 	} else if (!phydev->link && phydev->state != PHY_NOLINK) {
diff --git a/include/linux/phy.h b/include/linux/phy.h
index cb5a2182b..4962766b2 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -698,6 +698,7 @@ static inline bool phy_is_started(struct phy_device *phydev)
 
 void phy_resolve_aneg_pause(struct phy_device *phydev);
 void phy_resolve_aneg_linkmode(struct phy_device *phydev);
+bool phy_check_downshift(struct phy_device *phydev);
 
 /**
  * phy_read - Convenience function for reading a given PHY register
-- 
2.25.1


