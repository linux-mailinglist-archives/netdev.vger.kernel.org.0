Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C249526CCA6
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgIPUri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbgIPUrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 16:47:16 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1844BC061756
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 13:47:16 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id bd2so3838680plb.7
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 13:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5aWZzX82c0nLX/s70yWwltAKwH5AU5Pve+rjX5edcUk=;
        b=jGVr0g2MMkQDdDdwCnhF63dbAYRELIOS4jmYhvTnjVBNZrvoQY+NmSwMGerFyzo6Zt
         7XET+IIju49A4f68IQeMZg779o0gQ9SE1gktTLYZnGE5VZkMDLGR3LyaaBWS5+bJxOA2
         cRAM67Cdoi2Wcq2jEjwI6BEPG1HZzTptg2vdhZKgQ0aEYzhhLn9TP0J827cbnD/FBzze
         2OuTczVQza1UmCt0pkDuHkUaTsdXRqwFobWa5GMdESwfzj9u2tbsNLDPmV0vAt75DFkv
         O5p62dpaE8lPFtCI93587bMoFS5DlihBlg/G2sBc8mIGWHf0p6B4HsJtNJdF/FXa0aNN
         Q8IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5aWZzX82c0nLX/s70yWwltAKwH5AU5Pve+rjX5edcUk=;
        b=rJIeBgPI6RGZk1Uz/ZrAl4FpfkiGteRZZBaIMY6XuElsLM0BFVQPxHyXe7pEbhws5b
         gGRhs4d1gECEL65cDL3UoGGE9qtRbyCr8fqo+dsU4aiZENRPyknvl1uGjDeQ3cHCCs/Y
         lR4nF59k9icYbg5CWhHKUCQ5Ay6suPoglAi/2zZLK/X3apFvBLgRVo6KG5CusZOnY61c
         8cAOa+2nyTS7KwqnJJSLP/jWL7mubBAzOrlkqn7+o/Y68hHS9kzaubBX3O3PnpQd5GAM
         jfjJIJ2M5hG6LbkT3NkjcrIh7tkjG64wFPMgXgFu3TySccGOnDrQiZGuf0e6wwjjI5Gq
         J48g==
X-Gm-Message-State: AOAM5332OkYWvqRUu0O0vSXQCOeNLj6EyqkMYQPPx6+0tVxV+wNbi3mc
        JQShyu2jtBOAsrGm2dEin7acws3Qsomoyw==
X-Google-Smtp-Source: ABdhPJxdMgTQYEXTrx9daHhY03ulwHDyHwJKW//fKKQL4LPMtatbQkcZP5jrHS6IspW22Vx6028rVw==
X-Received: by 2002:a17:90b:209:: with SMTP id fy9mr5444272pjb.189.1600289235276;
        Wed, 16 Sep 2020 13:47:15 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p11sm17684138pfq.130.2020.09.16.13.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 13:47:14 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, kuba@kernel.org, davem@davemloft.net
Subject: [PATCH net-next 2/2] net: phy: bcm7xxx: request and manage GPHY clock
Date:   Wed, 16 Sep 2020 13:44:15 -0700
Message-Id: <20200916204415.1831417-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200916204415.1831417-1-f.fainelli@gmail.com>
References: <20200916204415.1831417-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The internal Gigabit PHY on Broadcom STB chips has a digital clock which
drives its MDIO interface among other things, the driver now requests
and manage that clock during .probe() and .remove() accordingly.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/bcm7xxx.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index 692048d86ab1..aa70b322b119 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -11,6 +11,8 @@
 #include "bcm-phy-lib.h"
 #include <linux/bitops.h>
 #include <linux/brcmphy.h>
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
 #include <linux/mdio.h>
 
 /* Broadcom BCM7xxx internal PHY registers */
@@ -39,6 +41,7 @@
 
 struct bcm7xxx_phy_priv {
 	u64	*stats;
+	struct clk *clk;
 };
 
 static int bcm7xxx_28nm_d0_afe_config_init(struct phy_device *phydev)
@@ -521,6 +524,7 @@ static void bcm7xxx_28nm_get_phy_stats(struct phy_device *phydev,
 static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 {
 	struct bcm7xxx_phy_priv *priv;
+	int ret = 0;
 
 	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -534,7 +538,29 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	if (!priv->stats)
 		return -ENOMEM;
 
-	return 0;
+	priv->clk = devm_clk_get_optional(&phydev->mdio.dev, NULL);
+	if (IS_ERR(priv->clk))
+		return PTR_ERR(priv->clk);
+
+	/* Do not increment the clock reference count here, the MDIO driver has
+	 * already done that in order to successfully enable the PHY during its
+	 * bus->reset() callback and get us past get_phy_device() which reads
+	 * the PHY ID and later matches against a given PHY driver. If we
+	 * incremented the reference count, a driver unbind would not be able
+	 * to turn off the clock.
+	 */
+	if (!__clk_is_enabled(priv->clk))
+		ret = clk_prepare_enable(priv->clk);
+
+	return ret;
+}
+
+static void bcm7xxx_28nm_remove(struct phy_device *phydev)
+{
+	struct bcm7xxx_phy_priv *priv = phydev->priv;
+
+	clk_disable_unprepare(priv->clk);
+	devm_clk_put(&phydev->mdio.dev, priv->clk);
 }
 
 #define BCM7XXX_28NM_GPHY(_oui, _name)					\
@@ -552,6 +578,7 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	.get_strings	= bcm_phy_get_strings,				\
 	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
+	.remove		= bcm7xxx_28nm_remove,				\
 }
 
 #define BCM7XXX_28NM_EPHY(_oui, _name)					\
@@ -567,6 +594,7 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	.get_strings	= bcm_phy_get_strings,				\
 	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
+	.remove		= bcm7xxx_28nm_remove,				\
 }
 
 #define BCM7XXX_40NM_EPHY(_oui, _name)					\
-- 
2.25.1

