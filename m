Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E73018C225
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 22:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgCSVRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 17:17:08 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38674 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbgCSVRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 17:17:06 -0400
Received: by mail-wm1-f66.google.com with SMTP id l20so4108120wmi.3
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 14:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KSN3pOGKPieqyBDSxSMkxyLC5PdEUbEo+31iQHJ/aYY=;
        b=B3/AGyAdbX0XQVOO/ykgB36DH8hAvIi6u+XyEfJepV7Lj8fzGj5i4NCpILak6tXVVJ
         fV1gxUhoy8OjxrImj2ZvGoGXRWRGn6xhhWukWZtS82G+Ywzu5m84WDp6AnhpuBgxYRpM
         9YR3xSSY5uywn/Zufugfp6CQKugvC8qIV9e7ouQf+BJXgW9jBBUngY7k2kcZ9MWJV/WG
         oipGDya4MbcRkdhLzKPee4UHDNBn/cfTbMjKnbzYIXTV4E75UTbzIs8eVuWlEf8QUHFE
         EPIZdVZK1tW/iyF5FaUE3ha+9Rq3W7egWtWoGjNSDumvJHq7o4osR5k6jKL0XMr7z5mA
         4eXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KSN3pOGKPieqyBDSxSMkxyLC5PdEUbEo+31iQHJ/aYY=;
        b=WkYJOQiZ8AEYugfhgp/XekCtlXQrKz9xLJBev+Evz1fOEBLwKkUjTiQx9ppJxCEYdP
         g4BT+UKMzgl1dNNw9SnHvVF8cNK1XX5+W4EbgX63uIMoGOU7ZEVqNsT4tscseJm/WkBF
         JkqyAIe3PQ4pf+XdAp2EfF53WIOxC0xbidNagTvR2HpzidPL7V1G5ZHOW16VfM1DzRsO
         63aRrooUKr4KOWh0MgpHinGtUWojOnIZuXN7kZA8t2y6ogz6sRYvF4U2VEGKxLbDJ4cG
         GVuCD3dC4NmRlbXxwirYu7wIqzGk8jYwwYVeqOLVYxxOTJ4FhSDSf4yUPyFLgVCAn+7T
         90yw==
X-Gm-Message-State: ANhLgQ1R734nB9VvtXOeaT3FU8Yd5x7+NO8QF/wgl3OOaf8roxFPs+zB
        MbmBZ22YDqK11pY4Mr7Ey/0=
X-Google-Smtp-Source: ADFU+vtchH6/zu/9tUaMzRmgxm5bez14TiIV8TGLtdRoeoHio0CQo0+TjG9wdtlXHFjLllvcgPKegQ==
X-Received: by 2002:a7b:ce95:: with SMTP id q21mr1698021wmj.65.1584652625331;
        Thu, 19 Mar 2020 14:17:05 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id l13sm5117655wrm.57.2020.03.19.14.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 14:17:04 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, antoine.tenart@bootlin.com
Subject: [PATCH net-next 3/4] net: phy: mscc: configure both RX and TX internal delays for RGMII
Date:   Thu, 19 Mar 2020 23:16:48 +0200
Message-Id: <20200319211649.10136-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319211649.10136-1-olteanv@gmail.com>
References: <20200319211649.10136-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The driver appears to be secretly enabling the RX clock skew
irrespective of PHY interface type, which is generally considered a big
no-no.

Make them configurable instead, and add TX internal delays when
necessary too.

While at it, configure a more canonical clock skew of 2.0 nanoseconds
than the current default of 1.1 ns.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/mscc/mscc.h      |  2 ++
 drivers/net/phy/mscc/mscc_main.c | 16 +++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index 56feb14838f3..d4349a327329 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -164,6 +164,8 @@ enum rgmii_clock_delay {
 #define MSCC_PHY_RGMII_CNTL		  20
 #define RGMII_RX_CLK_DELAY_MASK		  0x0070
 #define RGMII_RX_CLK_DELAY_POS		  4
+#define RGMII_TX_CLK_DELAY_MASK		  0x0007
+#define RGMII_TX_CLK_DELAY_POS		  0
 
 #define MSCC_PHY_WOL_LOWER_MAC_ADDR	  21
 #define MSCC_PHY_WOL_MID_MAC_ADDR	  22
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 67d96a3e0fad..dd99e0cb9588 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -522,16 +522,26 @@ static int vsc85xx_mac_if_set(struct phy_device *phydev,
 
 static int vsc85xx_default_config(struct phy_device *phydev)
 {
+	u16 reg_val = 0;
 	int rc;
-	u16 reg_val;
 
 	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+
+	if (!phy_interface_mode_is_rgmii(phydev->interface))
+		return 0;
+
 	mutex_lock(&phydev->lock);
 
-	reg_val = RGMII_CLK_DELAY_1_1_NS << RGMII_RX_CLK_DELAY_POS;
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
+		reg_val |= RGMII_CLK_DELAY_2_0_NS << RGMII_RX_CLK_DELAY_POS;
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
+		reg_val |= RGMII_CLK_DELAY_2_0_NS << RGMII_TX_CLK_DELAY_POS;
 
 	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_2,
-			      MSCC_PHY_RGMII_CNTL, RGMII_RX_CLK_DELAY_MASK,
+			      MSCC_PHY_RGMII_CNTL,
+			      RGMII_RX_CLK_DELAY_MASK | RGMII_TX_CLK_DELAY_MASK,
 			      reg_val);
 
 	mutex_unlock(&phydev->lock);
-- 
2.17.1

