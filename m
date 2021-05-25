Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB58390A88
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 22:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbhEYUez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 16:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233303AbhEYUew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 16:34:52 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D492C061574;
        Tue, 25 May 2021 13:33:21 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id h20so16297955qko.11;
        Tue, 25 May 2021 13:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KOeO+6nuknyeJ2HhH+Yp/Jtu6IHeWxm1QSBaTbCP4J0=;
        b=uaVNsC4elfWMZ7P7Akjg8dMD52Gg6JntWFcubp2CrYJNFKizVIOO/Ss/KShEdwcl1/
         1kzDa1n2+A0LzxJvI4sCv5e1xle8UUn/ZEY/l5Gui6EwtnELRr8v4A22gdeUoMzK60Ut
         K1M/tPUg8Xi2NNgfK5WXRnJhroR7jBHzFihOLFUDNiHbYb8+blQdXA+oKOUW2ihSSA4+
         eVU+UIpMMhYO3vasbexwTuVQ83jP1POFtRXoxz6O9B+M7JjWH1lcNsIaMMz2nb+fuYbi
         +engr9WbvtuZYZsk2SJQeFUBwFFirMDs+5OPs7Nr5Rh/sAGZ62uyW5bhxq3gzBDNGWez
         CgOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KOeO+6nuknyeJ2HhH+Yp/Jtu6IHeWxm1QSBaTbCP4J0=;
        b=OM/009jqs2Td3RaZLvcvrB7oXCf3yUSf/CN4L86rDe2IBQ1UUS3ILbdmM9OxpsF40U
         GjYX6wL9WSytnFwcxULTnY4Y+FxYcILRczfgEfgEdr2VHyADh4DSRG/y8GCr2uMYbYRj
         DVyUeFbh2OcWOq9qyWhl4xYKnwu2/64BfwXKGUowizCRSL8h/Qi6XyNe12aMFTmBaiEa
         P9xGSoQbPVKNuTHEPcX94FbxqQXR1KPzi1vO8ktuH7czs8qIxzQ7d86pG7iPr0GcaeeN
         0yEFiTy+8gGfaCG4uwprDyOEMYZN0d7FopSFe/rxotzSHIiwiKQCUlzZpFfgVzp+toHY
         qg+w==
X-Gm-Message-State: AOAM532ICt/HysY4UAQ5jIBWQO6MAXwVkNXVoDhrjA0W+LyxajkxRpF7
        HiLJOfzFJLpXzbCURNTbWrE=
X-Google-Smtp-Source: ABdhPJzvfGCG5cxpW2qQuyZJ1aI3VCdZGSzp5YY6sKvAuintrWHfMeqwq/HJaITfHNgzg5bZSq86jA==
X-Received: by 2002:a05:620a:c9a:: with SMTP id q26mr36241166qki.371.1621974800349;
        Tue, 25 May 2021 13:33:20 -0700 (PDT)
Received: from master-laptop.sparksnet ([2601:153:980:85b1:a465:c799:7794:b233])
        by smtp.gmail.com with ESMTPSA id g4sm159312qtg.86.2021.05.25.13.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 13:33:19 -0700 (PDT)
From:   Peter Geis <pgwipeout@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Peter Geis <pgwipeout@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2 2/2] net: phy: abort loading yt8511 driver in unsupported modes
Date:   Tue, 25 May 2021 16:33:14 -0400
Message-Id: <20210525203314.14681-3-pgwipeout@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525203314.14681-1-pgwipeout@gmail.com>
References: <20210525203314.14681-1-pgwipeout@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While investigating the clang `ge` uninitialized variable report, it was
discovered the default switch would have unintended consequences. Due to
the switch to __phy_modify, the driver would modify the ID values in the
default scenario.

Fix this by promoting the interface mode switch and aborting when the
mode is not a supported RGMII mode.

This prevents the `ge` and `fe` variables from ever being used
uninitialized.

Fixes: b1b41c047f73 ("net: phy: add driver for Motorcomm yt8511 phy")
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Peter Geis <pgwipeout@gmail.com>
---
 drivers/net/phy/motorcomm.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index 68cd19540c67..7e6ac2c5e27e 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -53,15 +53,10 @@ static int yt8511_config_init(struct phy_device *phydev)
 	int oldpage, ret = 0;
 	unsigned int ge, fe;
 
-	/* set clock mode to 125mhz */
 	oldpage = phy_select_page(phydev, YT8511_EXT_CLK_GATE);
 	if (oldpage < 0)
 		goto err_restore_page;
 
-	ret = __phy_modify(phydev, YT8511_PAGE, 0, YT8511_CLK_125M);
-	if (ret < 0)
-		goto err_restore_page;
-
 	/* set rgmii delay mode */
 	switch (phydev->interface) {
 	case PHY_INTERFACE_MODE_RGMII:
@@ -80,14 +75,20 @@ static int yt8511_config_init(struct phy_device *phydev)
 		ge = YT8511_DELAY_RX | YT8511_DELAY_GE_TX_EN;
 		fe = YT8511_DELAY_FE_TX_EN;
 		break;
-	default: /* leave everything alone in other modes */
-		break;
+	default: /* do not support other modes */
+		ret = -EOPNOTSUPP;
+		goto err_restore_page;
 	}
 
 	ret = __phy_modify(phydev, YT8511_PAGE, (YT8511_DELAY_RX | YT8511_DELAY_GE_TX_EN), ge);
 	if (ret < 0)
 		goto err_restore_page;
 
+	/* set clock mode to 125mhz */
+	ret = __phy_modify(phydev, YT8511_PAGE, 0, YT8511_CLK_125M);
+	if (ret < 0)
+		goto err_restore_page;
+
 	/* fast ethernet delay is in a separate page */
 	ret = __phy_write(phydev, YT8511_PAGE_SELECT, YT8511_EXT_DELAY_DRIVE);
 	if (ret < 0)
-- 
2.25.1

