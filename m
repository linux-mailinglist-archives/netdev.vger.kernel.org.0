Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9383620B561
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 17:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbgFZPyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 11:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730082AbgFZPxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 11:53:50 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABAFC03E97B
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 08:53:50 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id l17so9296707wmj.0
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 08:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TbnIQG0QHISwW/i84YvrCuX1R8Xn9pu9QKVIxgPnwPw=;
        b=EVUJjBN8sxl7dynrrBDu7PHBrUi+wFFMq5tb0hZV31YnJQU6ZSB5VsT0F59sh1HNs2
         uPjTKB8yALRduXU4eLgOTIq8K7bbdrWeq0F8rIqX5k5oO2VUI73fCjvfcTmRMHocyCl7
         7Nit5Fnhmb3wzUbXCwXzrc4ZjhD7u1WSeZhmYVherSgfwcRgUFl/tHqI2NDlce7liHeA
         legSrznURkRtbfaHBHhzNy73fHl7FfsdYAhzPrYLTUzmTsJP8e0it5tBdbFW3cn/wjXA
         yfjLEATMugtYRbOGoLMMvrUls3uUExk1B3lqSv6L2jFnZatq+UIv1WpsqbGtGPzMnIpt
         Ghew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TbnIQG0QHISwW/i84YvrCuX1R8Xn9pu9QKVIxgPnwPw=;
        b=PLLxdJgeE3IIsEiEM7ZZ76840bc9IyuNGFLVj4uUsdI0oUW7OqnnrrymnK8e78HAJo
         A8vmHaJ8QhrKzj8snDRB8OS6H58ZcFu8UdtWUwdt3MMvRxqG5ZZvESh4kxzy0/0r3aTD
         EPXMxuhA0J1ecJ3uCfV/GgVqv3GoUoaMPZ+p5JP5RETUOScqhYPpUt5A+sqr48Ab/pBB
         240WrWBq/AFFv7v92Wg4nKQBSSn8BHvGL4Cd3UUDbuu5tMeKQhiE4h/k/juitlmBLr9P
         oJkWGeJ6tq8QP0T1egElN6EaI6c8qtbC1MJ6G3CqBoXatYheVSQ007I2RCv/e2Sgi9UV
         EaOQ==
X-Gm-Message-State: AOAM530ETHZ8xJA36sdvRvY8c4gzBfXohPiHnc6Jq+L85y7wDke4uTaX
        mHGUgfa5qCjdpd07hLYubZJeyA==
X-Google-Smtp-Source: ABdhPJwZ/GZzuZzZ5R/O//GZ8s1TehBYsWqMkVPkM1A+iw4VakcREenLIdIEwMKrTHeTj5M/lp9Qdw==
X-Received: by 2002:a7b:cf21:: with SMTP id m1mr4252746wmg.71.1593186829554;
        Fri, 26 Jun 2020 08:53:49 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id h142sm8242791wme.3.2020.06.26.08.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 08:53:49 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5/6] net: phy: reset the PHY even if probe() is not implemented
Date:   Fri, 26 Jun 2020 17:53:24 +0200
Message-Id: <20200626155325.7021-6-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200626155325.7021-1-brgl@bgdev.pl>
References: <20200626155325.7021-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Currently we only call phy_device_reset() if the PHY driver implements
the probe() callback. This is not mandatory and many drivers (e.g.
realtek) don't need probe() for most devices but still can have reset
GPIOs defined. There's no reason to depend on the presence of probe()
here so pull the reset code out of the if clause.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy_device.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1b4df12c70ad..f6985db08340 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2690,16 +2690,13 @@ static int phy_probe(struct device *dev)
 
 	mutex_lock(&phydev->lock);
 
-	if (phydev->drv->probe) {
-		/* Deassert the reset signal */
-		phy_device_reset(phydev, 0);
+	/* Deassert the reset signal */
+	phy_device_reset(phydev, 0);
 
+	if (phydev->drv->probe) {
 		err = phydev->drv->probe(phydev);
-		if (err) {
-			/* Assert the reset signal */
-			phy_device_reset(phydev, 1);
+		if (err)
 			goto out;
-		}
 	}
 
 	/* Start out supporting everything. Eventually,
@@ -2761,6 +2758,10 @@ static int phy_probe(struct device *dev)
 	phydev->state = PHY_READY;
 
 out:
+	/* Assert the reset signal */
+	if (err)
+		phy_device_reset(phydev, 1);
+
 	mutex_unlock(&phydev->lock);
 
 	return err;
@@ -2779,12 +2780,12 @@ static int phy_remove(struct device *dev)
 	sfp_bus_del_upstream(phydev->sfp_bus);
 	phydev->sfp_bus = NULL;
 
-	if (phydev->drv && phydev->drv->remove) {
+	if (phydev->drv && phydev->drv->remove)
 		phydev->drv->remove(phydev);
 
-		/* Assert the reset signal */
-		phy_device_reset(phydev, 1);
-	}
+	/* Assert the reset signal */
+	phy_device_reset(phydev, 1);
+
 	phydev->drv = NULL;
 
 	return 0;
-- 
2.26.1

