Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666BA34F3E3
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 00:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbhC3WAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 18:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbhC3WA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 18:00:29 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508C0C061574;
        Tue, 30 Mar 2021 15:00:29 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id v186so12691277pgv.7;
        Tue, 30 Mar 2021 15:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XtO4pVCtzVBgR7IqwEYI9V7XGb7phFtCoEr67g27Cik=;
        b=uo86C2/TKA/bEjzQXrVuXAI6BUaWD5dnableFS9fGDPrcZ8J1RJUSHrvXMaq+f89eP
         LETm5cLNKvXb7dzfhXjuokOW4YxthD3KLCc/z0jFnmke+fPmn9yeKcLwZq00/nhEtX40
         NQytlXvLe+FkXrtodQmm6TuO1R+aSF2P8RKkLDfIkH4LmM65qI1WDekgNUKPWQIIFc9a
         OIZ4S8Mq6Khf5Om5Z/QWV9lu12+zI1ezK5cygWvekSIJLVrQaE2jGk5l55QsJ5USFh5j
         T/WSkIYRX2Pqqychlve2+UlH7U4Fq6nX/vYVUi5/O23G/6keMcPmu9yj/rHioXzJ2BLk
         qF2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XtO4pVCtzVBgR7IqwEYI9V7XGb7phFtCoEr67g27Cik=;
        b=MIyxfONkKcZ5SvaTUT1FPbtMD5htGTY6WQGMOT8K+o3NnhqV3tZp4APFBNkAh5HTXb
         STEXQxBR7nsoqRYeLfRNIurANEPElKk2ynlYtp2+p/G/zPrEzneWd8AWoYGGxczr8eFx
         fJnUww3uTPGlYwCK5nZRqFXPp00eBi1dwnoFQ2UCVuu67OF99dkTmU/lsgzyzbZIwKCh
         nXjyneM2hjgjAaag57QFqrDuQyW3zT8NVaFNfgzJSa3TB1oAj3NbP5WHEUm9CoV4prbE
         +EzprNxhSR6POmWe/v6S5VVPiMECLtQB0c9STB03RzUVnm373az9/UmbrGjBYmdqd3G+
         nCDw==
X-Gm-Message-State: AOAM531zIeu5cP0z6QSMKbydeQsZuXwy1MwwfCFsMb5tVeoMoc/TEzEJ
        VuFJzeSLbWBS4xMW7Ur9UPm23EMsnP0=
X-Google-Smtp-Source: ABdhPJySev1UyCL7ZUbiEejQWJVpL2cCId2EtN20PbzAjuk+sBs5VP7/8V4d1OCCN9SuAga/mv+d1A==
X-Received: by 2002:a05:6a00:2163:b029:216:deaa:e386 with SMTP id r3-20020a056a002163b0290216deaae386mr56607pff.72.1617141628442;
        Tue, 30 Mar 2021 15:00:28 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y4sm27389pfn.67.2021.03.30.15.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 15:00:27 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: phy: broadcom: Only advertise EEE for supported modes
Date:   Tue, 30 Mar 2021 15:00:24 -0700
Message-Id: <20210330220024.1459286-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should not be advertising EEE for modes that we do not support,
correct that oversight by looking at the PHY device supported linkmodes.

Fixes: 99cec8a4dda2 ("net: phy: broadcom: Allow enabling or disabling of EEE")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/bcm-phy-lib.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index 53282a6d5928..287cccf8f7f4 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -369,7 +369,7 @@ EXPORT_SYMBOL_GPL(bcm_phy_enable_apd);
 
 int bcm_phy_set_eee(struct phy_device *phydev, bool enable)
 {
-	int val;
+	int val, mask = 0;
 
 	/* Enable EEE at PHY level */
 	val = phy_read_mmd(phydev, MDIO_MMD_AN, BRCM_CL45VEN_EEE_CONTROL);
@@ -388,10 +388,17 @@ int bcm_phy_set_eee(struct phy_device *phydev, bool enable)
 	if (val < 0)
 		return val;
 
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+			      phydev->supported))
+		mask |= MDIO_EEE_1000T;
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+			      phydev->supported))
+		mask |= MDIO_EEE_100TX;
+
 	if (enable)
-		val |= (MDIO_EEE_100TX | MDIO_EEE_1000T);
+		val |= mask;
 	else
-		val &= ~(MDIO_EEE_100TX | MDIO_EEE_1000T);
+		val &= ~mask;
 
 	phy_write_mmd(phydev, MDIO_MMD_AN, BCM_CL45VEN_EEE_ADV, (u32)val);
 
-- 
2.25.1

