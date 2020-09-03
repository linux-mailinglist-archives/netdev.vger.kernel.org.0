Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741CB25B9D6
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 06:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgICEkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 00:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgICEkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 00:40:00 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2979C061246;
        Wed,  2 Sep 2020 21:39:58 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id w7so1234781pfi.4;
        Wed, 02 Sep 2020 21:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OCoYfCHA4fbX8keiyJAOi27WsH3JkGUyWwn39WFi8cs=;
        b=paS1VAwdpuoy9XgQKKu05cXDI0GtUR+4bEIQS12wUqzYNRCPGqNPAJOz02SCxMZ63I
         oyuw4P3YzWW3OBUeQawiXU5Gvj+I+IF0+c9sfdYwvX01NEGS9SeFjdNoWF0WAjxNrJfT
         6JF2jpJNEdzUMGh/GDP5Afb73prB6cFFYm9QSfVFQMNJ0JmmOM4gCpJ6OVZTkoLQl/il
         dMmsOlZgX2L+8qInlw9AG/uE7CpNsO9EcquKdjirvGwi048rcky8w+bYZbxbBAusipLn
         8uux/JoYv0AtWAtgqOHIb+olTWB4MWoQ7xQtdGm+mviJuA2wxpBcyrqgngApNgT1eGAz
         9HXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OCoYfCHA4fbX8keiyJAOi27WsH3JkGUyWwn39WFi8cs=;
        b=Izx5XStM/Ga3JDEv2XCYsJFUFTt2YuV73tzbC611KBtEUA0NXvOtafFoDUS7HrfPB8
         dScJjoVWbjOb4pkdNC5Uv4RMHRg3dpCgh84QHR+xagf6NDJ8mYZ5o/8b1U7aWEqK4Rtl
         fkOxT8gq/R9zlnKSHEfW5WJQ+2VtV9KhCX4aAECaWOUmV9S4hgapnqiqCR3JavtdQOJD
         86yip0CtvJzJqgz6bNn4C65fzxwz30h4kl4piWcp72P3TG9iMVx32CfY8IWOjp/nnWkW
         X3Rpwf9P0g6Cb3Az8FJjeNA+2el+75hGWnWfwag8iuHs0wsI+3cjK29bWUdyEoRuyfns
         L90g==
X-Gm-Message-State: AOAM531hAkbW2uKp3Rjtn4mTr/biHhaXX8/JuKl8nOnScQVyrX/koM12
        KE7EQKKNuTpwtBDBop1oGewPhn6f5g4=
X-Google-Smtp-Source: ABdhPJwV5NxZ7QzGLBEyelXlNs/6EJvQwXLMWXLMZ+8iL8XbcV5B1GKuKiZ85hvkoaXG8oPA3/Ttfw==
X-Received: by 2002:a63:ba18:: with SMTP id k24mr1334327pgf.335.1599107998009;
        Wed, 02 Sep 2020 21:39:58 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u63sm1251805pfu.34.2020.09.02.21.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 21:39:57 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        adam.rudzinski@arf.net.pl, m.felsch@pengutronix.de,
        hkallweit1@gmail.com, richard.leitner@skidata.com,
        zhengdejin5@gmail.com, devicetree@vger.kernel.org,
        kernel@pengutronix.de, kuba@kernel.org, robh+dt@kernel.org
Subject: [PATCH net-next 3/3] net: phy: bcm7xxx: request and manage GPHY clock
Date:   Wed,  2 Sep 2020 21:39:47 -0700
Message-Id: <20200903043947.3272453-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200903043947.3272453-1-f.fainelli@gmail.com>
References: <20200903043947.3272453-1-f.fainelli@gmail.com>
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
 drivers/net/phy/bcm7xxx.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index 692048d86ab1..f0ffcdcaef03 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -11,6 +11,7 @@
 #include "bcm-phy-lib.h"
 #include <linux/bitops.h>
 #include <linux/brcmphy.h>
+#include <linux/clk.h>
 #include <linux/mdio.h>
 
 /* Broadcom BCM7xxx internal PHY registers */
@@ -39,6 +40,7 @@
 
 struct bcm7xxx_phy_priv {
 	u64	*stats;
+	struct clk *clk;
 };
 
 static int bcm7xxx_28nm_d0_afe_config_init(struct phy_device *phydev)
@@ -534,7 +536,19 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	if (!priv->stats)
 		return -ENOMEM;
 
-	return 0;
+	priv->clk = devm_clk_get_optional(&phydev->mdio.dev, NULL);
+	if (IS_ERR(priv->clk))
+		return PTR_ERR(priv->clk);
+
+	return clk_prepare_enable(priv->clk);
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
@@ -552,6 +566,7 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	.get_strings	= bcm_phy_get_strings,				\
 	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
+	.remove		= bcm7xxx_28nm_remove,				\
 }
 
 #define BCM7XXX_28NM_EPHY(_oui, _name)					\
@@ -567,6 +582,7 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	.get_strings	= bcm_phy_get_strings,				\
 	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
+	.remove		= bcm7xxx_28nm_remove,				\
 }
 
 #define BCM7XXX_40NM_EPHY(_oui, _name)					\
-- 
2.25.1

