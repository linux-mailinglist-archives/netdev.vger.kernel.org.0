Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E87E394BE6
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 13:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhE2LHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 07:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhE2LHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 07:07:43 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965A3C06174A;
        Sat, 29 May 2021 04:06:05 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id j189so6698592qkf.2;
        Sat, 29 May 2021 04:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qK+54IGHwuQkuGGrspkW6kXX3D+Ib9Q7t9lsF0kQMyQ=;
        b=N5ZoH3ULZijvt18nW7ax/7Ymz5v/qI0st36qfH12OkhQO8znRG6J44m9CwaA7PK5Oz
         bTDkvEWYCbqGoNu6PTqwBGdad7eD/nt+/dYew5SGsiqD3K5vLdUlpqzbQdlpTJNGJ9zO
         p7XnkPkCPygxM7egcSM9vOE2a3SR5CGA8M8uu0/Gq1UaW7xEDOEYa35QU1gVrpZEFInC
         ieI8RqCf2/V9pvJ4dYW4cEMmfQTl769hBePBj+ST22vOTjLMe+uQiet05gPRRXLccm/4
         QVfCxl72mhE8Ilpl7hZAkhWc+6MbdvWg9yrUoF6KoaVD6oYk23OLicod848RxmbjUedz
         ZUEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qK+54IGHwuQkuGGrspkW6kXX3D+Ib9Q7t9lsF0kQMyQ=;
        b=cMWhthKI6UJ1h2nkJ1W9wPJgiQhGyGhpjvq7ZEkHzRJhauZVqtXWkBWKHrDRqWhH7a
         MTQQljEDUERqTZj4MqREoTxjVGnnty2zMvO8W8pPxenyJbO9Svt6pFgK+1CFuFx77ibd
         7dzGC6TU5wHeak7cj0hL5sd3irtAplXBgcaAMJkvsjRXFJRLHQMABiwbCyM94Z73tJSd
         qVxbaYh4JLvEIxEqx/0ehAMAF/FDm5yPdAMb1oV2WCtW0LT0VDzJfG+3p17aVyfMVnNj
         AzCdY51hUixKfBpprTV632LAhfzLFzpf2JiaSe4hEYzDEOifZbRE9z3sD8qNH+bL4zkY
         t+hA==
X-Gm-Message-State: AOAM530HfIa2oLssocg1pLgWftrhUJ3ky5YJv3TpmrziV1nO3X1kdEjo
        BGBjrJ9Ek3ZMvvM/2JV/m0s=
X-Google-Smtp-Source: ABdhPJxgYZDIbmcWTRHBDPQ7pKykzh9RKix8mwhJ6k8mPoqMlxKt5zEJNy8Rlti04jgVT/kC0HAi6Q==
X-Received: by 2002:a37:5d46:: with SMTP id r67mr7738243qkb.72.1622286364728;
        Sat, 29 May 2021 04:06:04 -0700 (PDT)
Received: from master-laptop.sparksnet ([2601:153:980:85b1:5af:2aab:d2d5:7c9a])
        by smtp.gmail.com with ESMTPSA id t137sm5328991qke.50.2021.05.29.04.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 04:06:04 -0700 (PDT)
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
Subject: [PATCH v3 2/2] net: phy: abort loading yt8511 driver in unsupported modes
Date:   Sat, 29 May 2021 07:05:56 -0400
Message-Id: <20210529110556.202531-3-pgwipeout@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210529110556.202531-1-pgwipeout@gmail.com>
References: <20210529110556.202531-1-pgwipeout@gmail.com>
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

Fixes: 48e8c6f1612b ("net: phy: add driver for Motorcomm yt8511 phy")
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

