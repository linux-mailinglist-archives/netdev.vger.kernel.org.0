Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74956319533
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBKVdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 16:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhBKVdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 16:33:43 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F35EAC061574
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 13:33:02 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id 7so5640597wrz.0
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 13:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:from:to:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=1oAEI7hpWNDgPcBDT0357JI7CaiRHqJP+WGEi+0qMj8=;
        b=BHYUG8VIHsPb00SSlG92sR2kzGWm5hVeuL45QsHm2xfVl4huJq4+GHfgoBxaz6AW/f
         s7MTKI7tS20d8RLxrZ++rQEXGV2GbS3rH2r7pwDCS3ie3xJ1qjquj6vDkBsu/p3S8zTQ
         rcQJNlRIwC+FykLkStKFNH5drXS67ms1gpZm3ZhBmz67Ehuj1iVQX/oGiP6IudFnGvi3
         ycbDMxh8Jo1543G4X9H/QymC50jjT4mdrvqbZzRrBaoUHCMeIdX8hOFMDIFmMrnQejhw
         0LtSnyciE4ICa8YuBP14Rg4sP1Z09wRzzKIYcB+K18VuGBF+gQYi7ZAPC98LnP1OUSjc
         7UaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:from:to:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=1oAEI7hpWNDgPcBDT0357JI7CaiRHqJP+WGEi+0qMj8=;
        b=AVjBOQjGnEidWZsLaCAmlFG7H6BPe06uSuIM0z/O6/IcVhzHzxG/iowL/1hNrEXLaD
         X1HbOqJZaDJb8e5A9TfTZDqugZD8fznugmHCLcAc+A/VAsFNOreqqIjfEf+7G1iJq7jU
         eU7MWdfe5u+Gi8FOWK2RGm4uusxN19m+Mkg6WI6QQcR6ul6CzciVeAM4RMwkoZW44G3j
         sANOI2KRiwb06WXiu1z5sGEyxsyji2eJBUPytlsUNYQaGWBpIE5HjrOO4NBTjAdUTZsG
         CFIjimu1/sZPEsjOh9tJ9HGNDktJt8Bafq/db7vKFlV6xd9OO4Cg+0bDP1jHhC6c84Oz
         bJsQ==
X-Gm-Message-State: AOAM532O5U2fPqvAhhOdAMsVb8+C/On9yMgPBidKlPnTTVWvUy6GS1Hh
        uu1l86StL86HB0z12XE1Gra79rPQh4XJpQ==
X-Google-Smtp-Source: ABdhPJzojnxRrffPMtL5uanQJYFU1wz/Olr1aCVHuuD6vp/gIeZqpNZU/laiPcqaFq3XXgBlx3wOZw==
X-Received: by 2002:adf:9599:: with SMTP id p25mr279104wrp.107.1613079181379;
        Thu, 11 Feb 2021 13:33:01 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:1524:b28c:2a1c:169e? (p200300ea8f1fad001524b28c2a1c169e.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:1524:b28c:2a1c:169e])
        by smtp.googlemail.com with ESMTPSA id o25sm18557611wmh.1.2021.02.11.13.32.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 13:33:00 -0800 (PST)
Cc:     Claudiu Beznea <Claudiu.Beznea@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: [PATCH net] net: phy: consider that suspend2ram may cut off PHY power
Message-ID: <fcd4c005-22b0-809b-4474-0435313a5a47@gmail.com>
Date:   Thu, 11 Feb 2021 22:32:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Claudiu reported that on his system S2R cuts off power to the PHY and
after resuming certain PHY settings are lost. The PM folks confirmed
that cutting off power to selected components in S2R is a valid case.
Therefore resuming from S2R, same as from hibernation, has to assume
that the PHY has power-on defaults. As a consequence use the restore
callback also as resume callback.
In addition make sure that the interrupt configuration is restored.
Let's do this in phy_init_hw() and ensure that after this call
actual interrupt configuration is in sync with phydev->interrupts.
Currently, if interrupt was enabled before hibernation, we would
resume with interrupt disabled because that's the power-on default.

This fix applies cleanly only after the commit marked as fixed.

I don't have an affected system, therefore change is compile-tested
only.

[0] https://lore.kernel.org/netdev/1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com/

Fixes: 611d779af7ca ("net: phy: fix MDIO bus PM PHY resuming")
Reported-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy_device.c | 53 ++++++++++++------------------------
 1 file changed, 17 insertions(+), 36 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8447e56ba..d48bdcb91 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -300,50 +300,22 @@ static int mdio_bus_phy_resume(struct device *dev)
 
 	phydev->suspended_by_mdio_bus = 0;
 
-	ret = phy_resume(phydev);
+	ret = phy_init_hw(phydev);
 	if (ret < 0)
 		return ret;
 
-no_resume:
-	if (phydev->attached_dev && phydev->adjust_link)
-		phy_start_machine(phydev);
-
-	return 0;
-}
-
-static int mdio_bus_phy_restore(struct device *dev)
-{
-	struct phy_device *phydev = to_phy_device(dev);
-	struct net_device *netdev = phydev->attached_dev;
-	int ret;
-
-	if (!netdev)
-		return 0;
-
-	ret = phy_init_hw(phydev);
+	ret = phy_resume(phydev);
 	if (ret < 0)
 		return ret;
-
+no_resume:
 	if (phydev->attached_dev && phydev->adjust_link)
 		phy_start_machine(phydev);
 
 	return 0;
 }
 
-static const struct dev_pm_ops mdio_bus_phy_pm_ops = {
-	.suspend = mdio_bus_phy_suspend,
-	.resume = mdio_bus_phy_resume,
-	.freeze = mdio_bus_phy_suspend,
-	.thaw = mdio_bus_phy_resume,
-	.restore = mdio_bus_phy_restore,
-};
-
-#define MDIO_BUS_PHY_PM_OPS (&mdio_bus_phy_pm_ops)
-
-#else
-
-#define MDIO_BUS_PHY_PM_OPS NULL
-
+static SIMPLE_DEV_PM_OPS(mdio_bus_phy_pm_ops, mdio_bus_phy_suspend,
+			 mdio_bus_phy_resume);
 #endif /* CONFIG_PM */
 
 /**
@@ -554,7 +526,7 @@ static const struct device_type mdio_bus_phy_type = {
 	.name = "PHY",
 	.groups = phy_dev_groups,
 	.release = phy_device_release,
-	.pm = MDIO_BUS_PHY_PM_OPS,
+	.pm = pm_ptr(&mdio_bus_phy_pm_ops),
 };
 
 static int phy_request_driver_module(struct phy_device *dev, u32 phy_id)
@@ -1143,10 +1115,19 @@ int phy_init_hw(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
-	if (phydev->drv->config_init)
+	if (phydev->drv->config_init) {
 		ret = phydev->drv->config_init(phydev);
+		if (ret < 0)
+			return ret;
+	}
 
-	return ret;
+	if (phydev->drv->config_intr) {
+		ret = phydev->drv->config_intr(phydev);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL(phy_init_hw);
 
-- 
2.30.1

