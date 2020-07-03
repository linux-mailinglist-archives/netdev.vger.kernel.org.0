Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20552131FD
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 05:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgGCDDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 23:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgGCDDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 23:03:10 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855B7C08C5C1;
        Thu,  2 Jul 2020 20:03:10 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id cm21so3943013pjb.3;
        Thu, 02 Jul 2020 20:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qQztFWTnvvCC65swoXT94iI6JJUvW0UB4XPTfh/WW2w=;
        b=AbeOyO3AB9clkR6h04uVOavwnqvrYCoZtcBo+RCO6rYpywWxZCGiCC7VQCXmcEy08s
         K7BjOwxfQVNgJThs4LMXWVk+tol+EJtQad8cSNgiqQr9NGkkG5mAvSlRSgGQFNNOH6Zs
         5C4Nh5KgmunmWPzI4G1/q/pRNuTV3V9APLQGxbhPEIc4CPz7GdRuB5W8tyUbz4KxA2wn
         THQsh2gA18I6TTRiGHb0pw7el9xnMgfb9Gpy+yBDoCaa/L9GbDkfWpryTbuhNW4FtymH
         cbd0D9lnTmmnv5o4/G4iahsRB2WNXeEyVkZ6AOH06a8pZdS7u6QseoxI6S18+uod9KW8
         ZAgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qQztFWTnvvCC65swoXT94iI6JJUvW0UB4XPTfh/WW2w=;
        b=FhCbUUPwuu3UTo0eehKbCX3duEVFwSKK2VTs2cks8+VgyUw2g9uoObHtS/8SVO86jL
         d8wde4CEWqN0Ij5jlJzbctWYuNU1BbjYvzGtAwRoZCNi3XlxHZCV49OHM4tAneXtsTOe
         ds+ihPx03ov3+9aaAcop+NjAdC2oCU6UtREoceE94Aw+mm5YzS+iQWoX4+z+RgmHHkSU
         n2dFG7zatJ8+fE9hbGGGLbKpWQYWLbWTVbNNKk6O2VzBfmHXKaEn8D0+jcFBiTRLXl5T
         vxifDAj8KzU/8GDPXBQdNlNAAO/Q/zOlXEmyTnTzwmame25tmuljsqEr74pT6SmZQkXY
         agmQ==
X-Gm-Message-State: AOAM532FlOu7zaaXEH8R4KQjcsk2wCqNYgrN27YvdMv6ySpyNcpwHQms
        m6dz2rAJpolAeOlgj3TfLz0=
X-Google-Smtp-Source: ABdhPJzyUxIZmx9Fap9uAXWsv4XhEJ/scd+jwPILtyrju0Liv5NQs6RsVcYgi38l4wMv64k21APvoQ==
X-Received: by 2002:a17:902:a511:: with SMTP id s17mr28552218plq.37.1593745389988;
        Thu, 02 Jul 2020 20:03:09 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id h194sm9903223pfe.201.2020.07.02.20.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 20:03:09 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steve Glendinning <steve.glendinning@shawell.net>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v2 1/2] epic100: use generic power management
Date:   Fri,  3 Jul 2020 08:31:37 +0530
Message-Id: <20200703030138.25724-2-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200703030138.25724-1-vaibhavgupta40@gmail.com>
References: <20200703030138.25724-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers should not use legacy power management as they have to manage power
states and related operations, for the device, themselves.

With generic PM, all essentials will be handled by the PCI core. Driver
needs to do only device-specific operations.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/smsc/epic100.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/smsc/epic100.c b/drivers/net/ethernet/smsc/epic100.c
index 61ddee0c2a2e..d950b312c418 100644
--- a/drivers/net/ethernet/smsc/epic100.c
+++ b/drivers/net/ethernet/smsc/epic100.c
@@ -1512,12 +1512,9 @@ static void epic_remove_one(struct pci_dev *pdev)
 	/* pci_power_off(pdev, -1); */
 }
 
-
-#ifdef CONFIG_PM
-
-static int epic_suspend (struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused epic_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct epic_private *ep = netdev_priv(dev);
 	void __iomem *ioaddr = ep->ioaddr;
 
@@ -1531,9 +1528,9 @@ static int epic_suspend (struct pci_dev *pdev, pm_message_t state)
 }
 
 
-static int epic_resume (struct pci_dev *pdev)
+static int __maybe_unused epic_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 
 	if (!netif_running(dev))
 		return 0;
@@ -1542,18 +1539,14 @@ static int epic_resume (struct pci_dev *pdev)
 	return 0;
 }
 
-#endif /* CONFIG_PM */
-
+static SIMPLE_DEV_PM_OPS(epic_pm_ops, epic_suspend, epic_resume);
 
 static struct pci_driver epic_driver = {
 	.name		= DRV_NAME,
 	.id_table	= epic_pci_tbl,
 	.probe		= epic_init_one,
 	.remove		= epic_remove_one,
-#ifdef CONFIG_PM
-	.suspend	= epic_suspend,
-	.resume		= epic_resume,
-#endif /* CONFIG_PM */
+	.driver.pm	= &epic_pm_ops,
 };
 
 
-- 
2.27.0

