Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E495625B5F2
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 23:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgIBVd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 17:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbgIBVd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 17:33:56 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E78CC061245;
        Wed,  2 Sep 2020 14:33:56 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id o20so420188pfp.11;
        Wed, 02 Sep 2020 14:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4kk+T1HfVLH9UnnPxrYNLNlYNhDqwqvqKumUeDWS3JQ=;
        b=OcxWYM9I1S0nYRyIiEpmze7EpUyRt5TTJVkcMdyw+moqmQGN4FGyWtzMqouaWNlon9
         XgNDvSghoyxBttYvKDr3i7AR1COPeY9SEWEWleXrKNo6kqtWYSVwKsynEzNmUS5sXq2L
         EeO+D27H8ca8ZmUpxLrYNJC5Z3hVgE81vcd74Mz3Dp3h+oh+Gh+RFVTMOV47mDwD2AEE
         o9Z/r+NC4yXJCJiNytRND90ixSxixBQe2rC0IFPVghSEdRvs+GPxqlvJU3sgLvIdKQGD
         f7aRdTD2hqAawnedbYyOzH7OgIgtCO4t6xs+oMPtL39RRUOuaox9mPUxeG+sd/xylF08
         nWgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4kk+T1HfVLH9UnnPxrYNLNlYNhDqwqvqKumUeDWS3JQ=;
        b=kfkzvUO4uqwzYvJkYgr/Yq24oi3mUPWBOGYQ1o8LeX59J9OcVQmh4xji6BJKgh8K+M
         FMKYnlth9P18OFNxIW1uiU7e2HKUx7KY92bhWy8diOGKg9PUI1M+CmnhVTcnfqXPpn2z
         egjMfleqs+AUWSgaQ5na4AmgTNxqFcKwQgPZ7CEcV4ZmEX4DE+R4acS+5Qm2rmzKQKw/
         3tdxXeBlLLU2xieo57V37vovyLpiSZszeL5gKCqHK25Q1c7NXvdZw6fwwlpLoiz2JZZG
         AI1rwriwaQX9d4w6NF1UdsAyaMoaF2ihmyElxRB53WIaDAFpTgEstthO9IOKFjJ5StBS
         JfgA==
X-Gm-Message-State: AOAM530KwlZa4SwSEnpREkCvX05hnBMVxsLAkEuG5FPRRs34Ly51R28+
        sNgmCxXokXyAIkgUD6sGhsaXxXdZb2M=
X-Google-Smtp-Source: ABdhPJwlyfccYGDlLlkHPvW/UGVj2yiW2J3a1EEJs75B4faKGdzGpci8n7B6qFo62q813JqAJXxbzg==
X-Received: by 2002:a65:5a4c:: with SMTP id z12mr1059pgs.10.1599082435076;
        Wed, 02 Sep 2020 14:33:55 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g5sm466881pfh.168.2020.09.02.14.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 14:33:54 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        adam.rudzinski@arf.net.pl, m.felsch@pengutronix.de,
        hkallweit1@gmail.com, richard.leitner@skidata.com,
        zhengdejin5@gmail.com, devicetree@vger.kernel.org,
        kernel@pengutronix.de, kuba@kernel.org, robh+dt@kernel.org
Subject: [RFC net-next 2/2] net: phy: bcm7xxx: request and manage GPHY clock
Date:   Wed,  2 Sep 2020 14:33:47 -0700
Message-Id: <20200902213347.3177881-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200902213347.3177881-1-f.fainelli@gmail.com>
References: <20200902213347.3177881-1-f.fainelli@gmail.com>
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
 drivers/net/phy/bcm7xxx.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index 692048d86ab1..2b81a11e3167 100644
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
@@ -534,7 +538,28 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	if (!priv->stats)
 		return -ENOMEM;
 
-	return 0;
+	priv->clk = devm_clk_get_optional(&phydev->mdio.dev, "sw_gphy");
+	if (IS_ERR(priv->clk))
+		return PTR_ERR(priv->clk);
+
+	/* To get there, the mdiobus registration logic already enabled our
+	 * clock otherwise we would not have probed this device since we would
+	 * not be able to read its ID. To avoid artificially bumping up the
+	 * clock reference count, only do the clock enable from a phy_remove ->
+	 * phy_probe path (driver unbind, then rebind).
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
@@ -552,6 +577,7 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	.get_strings	= bcm_phy_get_strings,				\
 	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
+	.remove		= bcm7xxx_28nm_remove,				\
 }
 
 #define BCM7XXX_28NM_EPHY(_oui, _name)					\
@@ -567,6 +593,7 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	.get_strings	= bcm_phy_get_strings,				\
 	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
+	.remove		= bcm7xxx_28nm_remove,				\
 }
 
 #define BCM7XXX_40NM_EPHY(_oui, _name)					\
-- 
2.25.1

