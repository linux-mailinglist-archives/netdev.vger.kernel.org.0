Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC40E26D0FF
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 04:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgIQCNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 22:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgIQCNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 22:13:00 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058A8C06178A;
        Wed, 16 Sep 2020 19:07:02 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d9so234744pfd.3;
        Wed, 16 Sep 2020 19:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yNI3ayBSErH9ngje/k7Sy+18TDFnxYArZPNbdUTIJOk=;
        b=FsX6DT57g7I+hXAfzCe9huqDMe1fWNbooBB5T1kx8wZ6vnBwCNpxwngBxhP9TI9sAS
         I+ACHmu3hilq1NSS95gNSeu8vIysyPWSRg2Yy0l58BlS1S+7V9qOWfkB6+WgtZHH9oAQ
         tgAvflUDEV9KPtif+FYBTYS3fCHiZ7nUPVZH4tapWCB19LvlTBR4f2gs88NvjYqkWyyj
         8ql5Zy4wARRsOMTHlyIsLyPARh+SkxqMxo4itnSnMnMb+5P2vDMfgRwy6PlqJBSAHaVZ
         bZZk+zwFrOkPVfMPFBQ7Q/rFKtN+jUYBEldKD+BLHGQN4BiMWCUbWljYdndenblhiq51
         jqWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yNI3ayBSErH9ngje/k7Sy+18TDFnxYArZPNbdUTIJOk=;
        b=t0FZ+PtQi+AX5i6VNvsegS7THWcpsPdukni+Tk0BgOP2Oo7gmT7bRFDriIDDtZW1Q8
         BHsiAWikbMa9u7/9LnsPU0dJJreAP1AGl15pDyoxZSGbnasINMjxN4Js/l4y/s94y/ED
         TIYOot2b81bV02PBVyXqaT7fOwbGkO4+oYttADxooM4TUwz3wdSZy4eX1sgpPm/Ro9Z/
         3muO3SsfSDDV2i8Lh5nZhrLE03TGoaAZbmAOGQNMuQAMw6BgfpAojL8RWrmAn6r2kBKT
         2TgYeeO/AImqQx7h3M6ArNJrdwK0PMhh7kSpUDhfWZyz1kZAEmIHFkqEpTebDJGWBo9C
         HEDg==
X-Gm-Message-State: AOAM530B0Rhxs/CtBuTqDcdFJTuG9N/tv00JIDu6k+tyJNf0o96LYV4c
        Y7Rv8HhRjUpxN/eAKmMgKTWEkw6YD7rZvQ==
X-Google-Smtp-Source: ABdhPJxy+UPhTkmPJunXbuI+3voBAHstyhHq6nLyiqJWtisHZpvpTN6M2Iydb1YJBbYxY/M9ilb/8g==
X-Received: by 2002:aa7:9ab0:0:b029:13c:1611:66bb with SMTP id x16-20020aa79ab00000b029013c161166bbmr24966939pfi.6.1600308421256;
        Wed, 16 Sep 2020 19:07:01 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m13sm17181370pfk.103.2020.09.16.19.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 19:07:00 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     opendmb@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2] net: phy: bcm7xxx: request and manage GPHY clock
Date:   Wed, 16 Sep 2020 19:04:13 -0700
Message-Id: <20200917020413.2313461-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The internal Gigabit PHY on Broadcom STB chips has a digital clock which
drives its MDIO interface among other things, the driver now requests
and manage that clock during .probe() and .remove() accordingly.

Because the PHY driver can be probed with the clocks turned off we need
to apply the dummy BMSR workaround during the driver probe function to
ensure subsequent MDIO read or write towards the PHY will succeed.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:

- localize the changes exclusively within the PHY driver and do not
  involve the MDIO driver at all. Using the ethernet-phyidAAAA.BBBB
  compatible string we can get straight to the desired driver without
  requiring clocks to be assumed on.

 drivers/net/phy/bcm7xxx.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index 692048d86ab1..744c24491d63 100644
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
@@ -521,6 +523,7 @@ static void bcm7xxx_28nm_get_phy_stats(struct phy_device *phydev,
 static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 {
 	struct bcm7xxx_phy_priv *priv;
+	int ret = 0;
 
 	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -534,7 +537,30 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	if (!priv->stats)
 		return -ENOMEM;
 
-	return 0;
+	priv->clk = devm_clk_get_optional(&phydev->mdio.dev, NULL);
+	if (IS_ERR(priv->clk))
+		return PTR_ERR(priv->clk);
+
+	ret = clk_prepare_enable(priv->clk);
+	if (ret)
+		return ret;
+
+	/* Dummy read to a register to workaround an issue upon reset where the
+	 * internal inverter may not allow the first MDIO transaction to pass
+	 * the MDIO management controller and make us return 0xffff for such
+	 * reads. This is needed to ensure that any subsequent reads to the
+	 * PHY will succeed.
+	 */
+	phy_read(phydev, MII_BMSR);
+
+	return ret;
+}
+
+static void bcm7xxx_28nm_remove(struct phy_device *phydev)
+{
+	struct bcm7xxx_phy_priv *priv = phydev->priv;
+
+	clk_disable_unprepare(priv->clk);
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

