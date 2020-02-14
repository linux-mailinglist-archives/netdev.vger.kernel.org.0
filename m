Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA88315F715
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 20:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388260AbgBNTtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 14:49:06 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36262 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387508AbgBNTtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 14:49:05 -0500
Received: by mail-pg1-f196.google.com with SMTP id d9so5466211pgu.3
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 11:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ZWng66Hoj7xQzhbUhm9kO2M9MQGzsOmKGEij3AJEDXU=;
        b=ONX9OTdBNa/5a5mLeDhmt5afoWTqsbefXAjxdh/WIid2nembeEayJx0HLEs8vp++ya
         qNSBA5/39f/Uiub0eo9h4mFy2IyRKrvLNU62KsbY2C+JbPxgLzOLkU2rAk4X2B4CzKQG
         7vZQJzLhiUc00YnSzHTqzKKTWkjPZ/hxr9A0Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZWng66Hoj7xQzhbUhm9kO2M9MQGzsOmKGEij3AJEDXU=;
        b=Ysg3miF550xtD3tVx6d54564TLRfLRELq6+yzEPoH3Bnz3Ur4FG87ap1NwpLvgo8dp
         /qE59Ar1BPsL4qW1hh51B3VCrSXo4qd+9jAinNxXussWPiVkbQbD+qJCs3emGSEfSlMQ
         9gyWJTbZe550Ra2mVlVFbSDx59rexnkdQV8yExPN2WJnf9+GBObPyI90rI2ZyRELtq63
         FaI0/PGRz7HJ21j2Qk3X/ytW5FqcF9g0TNDE9UxqJtiogsZUMCs8zpZLQmPwIAt5XPxQ
         DDvanEpfXrO5q5sPWcKnRbx4NcYQnKE9SOz+oZqUSd4Wwob0v5pwn8VQ0dAgJ6stmH5C
         q4Tw==
X-Gm-Message-State: APjAAAUKqvyNS9xjOPPcyyRB32tS4y5hMLHH5Ri9XAwhLqUKJAxmM8eX
        jDRcylAqgH+dP2IYGSimxflg/A==
X-Google-Smtp-Source: APXvYqwODEoeN+gxHepqNLozmja+mZtjocOV32D//1Zb1ppvJzZVslchQzuA62bl70OctqgEcPFbtg==
X-Received: by 2002:aa7:9808:: with SMTP id e8mr5202704pfl.32.1581709745136;
        Fri, 14 Feb 2020 11:49:05 -0800 (PST)
Received: from lbrmn-lnxub113.broadcom.net ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id u3sm7349815pjv.32.2020.02.14.11.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 11:49:04 -0800 (PST)
From:   Scott Branden <scott.branden@broadcom.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Ray Jui <rjui@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Scott Branden <scott.branden@broadcom.com>
Subject: [PATCH] net: phy: restore mdio regs in the iproc mdio driver
Date:   Fri, 14 Feb 2020 11:48:58 -0800
Message-Id: <20200214194858.8528-1-scott.branden@broadcom.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arun Parameswaran <arun.parameswaran@broadcom.com>

The mii management register in iproc mdio block
does not have a reention register so it is lost on suspend.
Save and restore value of register while resuming from suspend.

Fixes: bb1a619735b4 ("net: phy: Initialize mdio clock at probe function")

Signed-off-by: Arun Parameswaran <arun.parameswaran@broadcom.com>
Signed-off-by: Scott Branden <scott.branden@broadcom.com>
---
 drivers/net/phy/mdio-bcm-iproc.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/phy/mdio-bcm-iproc.c b/drivers/net/phy/mdio-bcm-iproc.c
index 7e9975d25066..f1ded03f0229 100644
--- a/drivers/net/phy/mdio-bcm-iproc.c
+++ b/drivers/net/phy/mdio-bcm-iproc.c
@@ -178,6 +178,23 @@ static int iproc_mdio_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+int iproc_mdio_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct iproc_mdio_priv *priv = platform_get_drvdata(pdev);
+
+	/* restore the mii clock configuration */
+	iproc_mdio_config_clk(priv->base);
+
+	return 0;
+}
+
+static const struct dev_pm_ops iproc_mdio_pm_ops = {
+	.resume = iproc_mdio_resume
+};
+#endif /* CONFIG_PM_SLEEP */
+
 static const struct of_device_id iproc_mdio_of_match[] = {
 	{ .compatible = "brcm,iproc-mdio", },
 	{ /* sentinel */ },
@@ -188,6 +205,9 @@ static struct platform_driver iproc_mdio_driver = {
 	.driver = {
 		.name = "iproc-mdio",
 		.of_match_table = iproc_mdio_of_match,
+#ifdef CONFIG_PM_SLEEP
+		.pm = &iproc_mdio_pm_ops,
+#endif
 	},
 	.probe = iproc_mdio_probe,
 	.remove = iproc_mdio_remove,
-- 
2.17.1

