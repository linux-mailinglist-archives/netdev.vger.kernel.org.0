Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E38115F8F1
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 22:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbgBNVsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 16:48:07 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40561 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730459AbgBNVsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 16:48:06 -0500
Received: by mail-wm1-f65.google.com with SMTP id t14so12320203wmi.5
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 13:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=tuhpf2H8a4ZzCABJWxUowWp6EKCvGrriOjGBgmmrUqk=;
        b=hQ4SQQcTZJYMJuGZ+sQF+Ern+ux0UaPM5+ddU9VsawxMBSNRoBQ5HHGbv2iNajhR2x
         oLZ6oWB9QvA3XrP3wpvBD8d4G8nrCqZZ8RlFLQfkp0Xe4UypOaGTNap69OXifGgIfN4d
         806OAX5oL1Eht/84kwnb/N8C5O5eo3AvMGVcM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tuhpf2H8a4ZzCABJWxUowWp6EKCvGrriOjGBgmmrUqk=;
        b=CQoEIsi00c8UUT4GQTE7cH3bXAlY1E0UPoYTD3aV6Jgd+UbleE/2hOsPhGftLVfdKz
         2JwkBRKXvvPfyvuJDykVslpOjwly2+2AaQLujxTMDv/opdHAKuqZx+7C0nMLQoeoWtLq
         3bcloCO3iqAKOHeAO1MINRpzJkvDTinnZU9QTq5g921p0KJGY6Q+IZMNjwx4ti826Vvp
         Va1cRUWLNASOdwjcQ3bi2rT5eujeTK71gKfDrLRuUJqqOtSXMrCCA83jI0IOuHtIKKfj
         hdOuRTRmVp5kc44Mi5fkDpsSAZPogEiefs1rbJ5S8EsuRcrLYEO/bBSiF7wUIRDrKsRt
         bCQg==
X-Gm-Message-State: APjAAAWZLPwVSM0eVHn5UsDXCLZeSrQOrb5zDNdOPlpZcjmJQLOAQHG3
        UwBndtJl0QT7gOCprmv/laJb+g==
X-Google-Smtp-Source: APXvYqzPAS+OXaRY2OgIGYMo+NU6m1xw9xivVTbrwWXjQRsZAf0oh5rZLW12uHI+OCzLkzVtHm0Oag==
X-Received: by 2002:a1c:9ed7:: with SMTP id h206mr6546114wme.67.1581716885231;
        Fri, 14 Feb 2020 13:48:05 -0800 (PST)
Received: from lbrmn-lnxub113.broadcom.net ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id y12sm8842421wrw.88.2020.02.14.13.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 13:48:04 -0800 (PST)
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
Subject: [PATCH v2] net: phy: restore mdio regs in the iproc mdio driver
Date:   Fri, 14 Feb 2020 13:47:46 -0800
Message-Id: <20200214214746.10153-1-scott.branden@broadcom.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arun Parameswaran <arun.parameswaran@broadcom.com>

The mii management register in iproc mdio block
does not have a retention register so it is lost on suspend.
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

