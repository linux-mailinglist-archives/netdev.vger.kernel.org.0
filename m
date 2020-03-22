Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98D0318E735
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 07:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgCVG4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 02:56:30 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39300 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbgCVG42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 02:56:28 -0400
Received: by mail-pj1-f65.google.com with SMTP id ck23so4483598pjb.4;
        Sat, 21 Mar 2020 23:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tPO4pLxbeKsS7djmA7oXTYCzKtZ3E1WZ+5DefgKALio=;
        b=pj87yIqiE6WHyGND4mE621sSuYLHdTudZZ6eYuJeC7HCpJ1SS6KV47ENP6s733DsUI
         MwsMAKtfKw8LpjJ9wGoth6VqCSzjcxfUMtTKBfEu6BYoNgnXmkHZVYnaMsBVJUx1I0Xo
         C5E011Infd50bVUcVbtYSQx3wTx0iOiG0S19zYTyX+W4ST0HoJzXSKYotB3Pj7vMCwB1
         pzUmqfoN2bsxKhpDohS0WvJ4i11QjeoaOr2huH7sUzrey+X8ONcDAB9bu4ortB1gsmWd
         MgCUN38B7ATIFDaDLY0j7Kf9tsAZxiDmsgu4n/gshim7/Ku29NRZE1Tt4PnpzKBV3etU
         ysvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tPO4pLxbeKsS7djmA7oXTYCzKtZ3E1WZ+5DefgKALio=;
        b=suZKo8cOEz+tGUm35OxrplbZvTnlVPon40zZn5Bmwz6JJ7uyFPp5WClLgwpKR1Mmb0
         iXAMOcR4Oh5yfVaD0EwmY7xP/ktVdkXPM47OgEhQ0t3k98ZwV5lCwWpiHAcCgmw1+0s9
         fcCX2kXhTvssLHqOLzGVJXQ0nH+SBYyRxYILrStK9tVSGNVbXd7KPmxrxifvEtXhV9Cu
         Y/jq6DKLeObDls8UP8DNq2rBd/wvjfljJqzaWMc7DjjXRX+kLNEjYr+pQFDh/GYTsAGw
         C7/BcPqOgHpXLWrXbGerq/hUJcZufr36dul7O3sdkx9RmynvArFRiGtA+aTDIeNoz4F0
         lqOA==
X-Gm-Message-State: ANhLgQ3h8WqGfweApHSpaIzJFb0T8wA7TquUJWFvoR7BYLKlLgX10XOc
        oqwcCktnTjeuJ1ZNpJkmjkU=
X-Google-Smtp-Source: ADFU+vskLMEC7J0dIF6angxpxUsECVgxvebuxQlf418hlYPy+b6P1MTg5YpByfwvpLSqYwgym87L2w==
X-Received: by 2002:a17:90b:3007:: with SMTP id hg7mr18499008pjb.70.1584860187433;
        Sat, 21 Mar 2020 23:56:27 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id h4sm10056245pfg.177.2020.03.21.23.56.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Mar 2020 23:56:27 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        gregkh@linuxfoundation.org, broonie@kernel.org,
        alexios.zavras@intel.com, tglx@linutronix.de,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v4 6/9] net: phy: marvell10g: use phy_read_mmd_poll_timeout() to simplify the code
Date:   Sun, 22 Mar 2020 14:55:52 +0800
Message-Id: <20200322065555.17742-7-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322065555.17742-1-zhengdejin5@gmail.com>
References: <20200322065555.17742-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use phy_read_mmd_poll_timeout() to replace the poll codes for
simplify mv3310_reset() function.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v3 -> v4:
	- add this patch by Andrew's suggestion. Thanks Andrew!

 drivers/net/phy/marvell10g.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 7e05b92504f0..90772a22286c 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -241,22 +241,17 @@ static int mv3310_power_up(struct phy_device *phydev)
 
 static int mv3310_reset(struct phy_device *phydev, u32 unit)
 {
-	int retries, val, err;
+	int val, err;
 
 	err = phy_modify_mmd(phydev, MDIO_MMD_PCS, unit + MDIO_CTRL1,
 			     MDIO_CTRL1_RESET, MDIO_CTRL1_RESET);
 	if (err < 0)
 		return err;
 
-	retries = 20;
-	do {
-		msleep(5);
-		val = phy_read_mmd(phydev, MDIO_MMD_PCS, unit + MDIO_CTRL1);
-		if (val < 0)
-			return val;
-	} while (val & MDIO_CTRL1_RESET && --retries);
-
-	return val & MDIO_CTRL1_RESET ? -ETIMEDOUT : 0;
+	return phy_read_mmd_poll_timeout(phydev, MDIO_MMD_PCS,
+					 unit + MDIO_CTRL1, val,
+					 !(val & MDIO_CTRL1_RESET),
+					 5000, 100000);
 }
 
 static int mv3310_get_edpd(struct phy_device *phydev, u16 *edpd)
-- 
2.25.0

