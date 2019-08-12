Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B33BB8A9EF
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbfHLVwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:52:37 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40670 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727916AbfHLVwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:52:36 -0400
Received: by mail-wr1-f66.google.com with SMTP id r1so6811836wrl.7
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K1tnXXy1vYggd9uHqyuZoECeKVB+15CHSfnLYhmyfg4=;
        b=R9x837KO+8NovVoBgIIt48z1/BcB/WD+p9pXQiatU6gkNoqezrfhcFbRr4FqLRz00d
         5dGyxiEzLtsDcjwyg/VIvA+spgGjViCEX5vKLSaxUujbZ/U+cVUgwY3gzAdekWUFp2oS
         Wrif4MxAW0NuD/KHF2PwIRf7vgXFfJjNUBJjLw6FJ5GUu0PNULkXuDC6IXtmi9v4z6WB
         +OLzExwzq0noMvkQ/iF/j+2hN7fqyFtQiViwqzUfP7S2yAz44LhzueF2xp8wBZIzNMSq
         Y3TLvctajhEgUjaM8uU9iregtQPwVcyULWZvXnAX4U73Haoey/8PVG4fkoGLiK8hKRKi
         bSNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K1tnXXy1vYggd9uHqyuZoECeKVB+15CHSfnLYhmyfg4=;
        b=Kbi9IV6RpdMJqttqSgOxAibzWR5oGYpdXlXFcyVKOyeQzp1oEkGM7ALdSpYwdJ1Qot
         ptIPL3GZkW6UItQeA/tB+LMZg5O7AHvnfDuC7iTFuFgHhEj6HwtqDxU2HY2v0ALy+3ie
         FEg3JwuD7YgEW9DzADaJ3TU7waej3R902ZivEi8pS/sHJ/cdbP9nO2+T3VVODpuutC2r
         rswzUzt8bEMmEDOMpM/iKSkbF0Th0xZPML3Jssuhv2GIes2yNe96Sw33YlcTy5bt43e1
         eadvo6N8U2UUUsfySR5n7KNPcxDyrZq0EsjMZYMf/i44bQQQVfM8ZmXsHDFh203ufJQJ
         dzew==
X-Gm-Message-State: APjAAAXS2C0JqzFx6sEqYIaKVz7NUW/PXY0oJMnVcI1BjeTTn5MdHAVK
        fixrvKmF3AnQWjgXRRDCDFhsbaKY
X-Google-Smtp-Source: APXvYqxmhQExEpfXjy3HHSnLT4atq1Xv20jhVmcK5ah96OKPXn0B3KmVt5sE8SSDFxSG8ddP22MBHg==
X-Received: by 2002:adf:da4d:: with SMTP id r13mr44352952wrl.281.1565646753276;
        Mon, 12 Aug 2019 14:52:33 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6? (p200300EA8F2F3200E9C14D4C1CCF09D6.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6])
        by smtp.googlemail.com with ESMTPSA id c15sm55113931wrb.80.2019.08.12.14.52.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 14:52:32 -0700 (PDT)
Subject: [PATCH net-next v2 3/3] net: phy: let phy_speed_down/up support
 speeds >1Gbps
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <dca82a0e-e936-b60a-3a1c-9fdb1714d1d3@gmail.com>
Message-ID: <664bb37b-7227-7502-834f-75d55097a704@gmail.com>
Date:   Mon, 12 Aug 2019 23:52:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <dca82a0e-e936-b60a-3a1c-9fdb1714d1d3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far phy_speed_down/up can be used up to 1Gbps only. Remove this
restriction by using new helper __phy_speed_down. New member adv_old
in struct phy_device is used by phy_speed_up to restore the advertised
modes before calling phy_speed_down. Don't simply advertise what is
supported because a user may have intentionally removed modes from
advertisement.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy.c | 60 ++++++++++++-------------------------------
 include/linux/phy.h   |  2 ++
 2 files changed, 18 insertions(+), 44 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index ef7aa738e..f3adea9ef 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -608,38 +608,21 @@ static int phy_poll_aneg_done(struct phy_device *phydev)
  */
 int phy_speed_down(struct phy_device *phydev, bool sync)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_old);
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_tmp);
 	int ret;
 
 	if (phydev->autoneg != AUTONEG_ENABLE)
 		return 0;
 
-	linkmode_copy(adv_old, phydev->advertising);
-	linkmode_copy(adv, phydev->lp_advertising);
-	linkmode_and(adv, adv, phydev->supported);
-
-	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, adv) ||
-	    linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, adv)) {
-		linkmode_clear_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT,
-				   phydev->advertising);
-		linkmode_clear_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
-				   phydev->advertising);
-		linkmode_clear_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
-				   phydev->advertising);
-		linkmode_clear_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
-				   phydev->advertising);
-	} else if (linkmode_test_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT,
-				     adv) ||
-		   linkmode_test_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
-				     adv)) {
-		linkmode_clear_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
-				   phydev->advertising);
-		linkmode_clear_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
-				   phydev->advertising);
-	}
+	linkmode_copy(adv_tmp, phydev->advertising);
+
+	ret = phy_speed_down_core(phydev);
+	if (ret)
+		return ret;
 
-	if (linkmode_equal(phydev->advertising, adv_old))
+	linkmode_copy(phydev->adv_old, adv_tmp);
+
+	if (linkmode_equal(phydev->advertising, adv_tmp))
 		return 0;
 
 	ret = phy_config_aneg(phydev);
@@ -658,30 +641,19 @@ EXPORT_SYMBOL_GPL(phy_speed_down);
  */
 int phy_speed_up(struct phy_device *phydev)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(all_speeds) = { 0, };
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(not_speeds);
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_old);
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(speeds);
-
-	linkmode_copy(adv_old, phydev->advertising);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_tmp);
 
 	if (phydev->autoneg != AUTONEG_ENABLE)
 		return 0;
 
-	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, all_speeds);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, all_speeds);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT, all_speeds);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, all_speeds);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT, all_speeds);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, all_speeds);
+	if (linkmode_empty(phydev->adv_old))
+		return 0;
 
-	linkmode_andnot(not_speeds, adv_old, all_speeds);
-	linkmode_copy(supported, phydev->supported);
-	linkmode_and(speeds, supported, all_speeds);
-	linkmode_or(phydev->advertising, not_speeds, speeds);
+	linkmode_copy(adv_tmp, phydev->advertising);
+	linkmode_copy(phydev->advertising, phydev->adv_old);
+	linkmode_zero(phydev->adv_old);
 
-	if (linkmode_equal(phydev->advertising, adv_old))
+	if (linkmode_equal(phydev->advertising, adv_tmp))
 		return 0;
 
 	return phy_config_aneg(phydev);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 62fdc7ff2..5ac7d2137 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -403,6 +403,8 @@ struct phy_device {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
+	/* used with phy_speed_down */
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_old);
 
 	/* Energy efficient ethernet modes which should be prohibited */
 	u32 eee_broken_modes;
-- 
2.22.0


