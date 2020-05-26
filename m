Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCDA1E1CDE
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 10:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731608AbgEZIFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 04:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbgEZIFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 04:05:11 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AB3C03E97E;
        Tue, 26 May 2020 01:05:11 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id w20so4606147pga.6;
        Tue, 26 May 2020 01:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ctzNEK9ct3Xheefnk+QOHIxDO7kXYLYdjrWKg/OFEKg=;
        b=X3CG+oVNVMX0lnR1bi1OH2EBx9kaknDBst0b0ZXlD1lfVkqB9xV21QY6KlTOXvqitn
         0smFZVRkdfWyhtq61P49oHA0xGA6wXQ1JLgF1/G4YuiyR7NlsJEKkw158Nc37bGnGIBn
         0uAFuFDVBWHSzmJgM2SnNAEhX4pyBRHMNWuZOz9wy8n2/lQUX843A7Q/oSAjs4x22kyB
         0Ho+PzQcqCnkDcrqqboUJFsG04pfnotwisLoJSeGqAzOrk/klA/a/N6LPb8zyyz5vcaV
         tNpFvwffBFksgUI1WpGWYtkKwHoCUYfl0Yg0zdapn/RkupzOuLVN37cuQ62oKt4Fvl7k
         jd+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ctzNEK9ct3Xheefnk+QOHIxDO7kXYLYdjrWKg/OFEKg=;
        b=DTsHeU6LKEBpGCYahHGgQWMUbw9F0x+EBjxhdKX84FOuL8+97XVFgBr4OojlCyLa3K
         A591Lx/JYKjZsUJMgjQ2O6da3DmJOmVR2w3gfHMRGGUzA+XDGVifSH8PK/LT1UFbLGAD
         g4yLAswRZtovhg/oloSt+ZLN8MgnJukB870/IokCikuy/isLheciClS6mLneaelujTPE
         uZb+R7x/cQjt3cFJaP9Y/MGSsZv++asZ/mrqKVr/AkQdiDftmb8QhwUkGIyRpbkX0ub6
         JLgRRIkvqfecJFT0BrWqOQW4fdmmKn0B1t3wPlAz3Qj7Z1wWhC14zaJ8iRiiIZJMmzSF
         /HpQ==
X-Gm-Message-State: AOAM533IknjMEyvGYv3TIpd5N0SOzZezk65YprMw2Vqy2QcBk/a6wWDQ
        3bmCww8CDhRUzpqKVJNZesI=
X-Google-Smtp-Source: ABdhPJztp+CYa62M7C0UA8/be7wZZ+tfVKlbQCJ9G2m7H6/p2rSXV64EhYvePkYTV3VRwa2BU5ITWA==
X-Received: by 2002:a05:6a00:a:: with SMTP id h10mr21383389pfk.310.1590480310570;
        Tue, 26 May 2020 01:05:10 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.209])
        by smtp.gmail.com with ESMTPSA id fa19sm8614477pjb.18.2020.05.26.01.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 01:05:10 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Don Fry <pcnet32@frontier.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [RFC PATCH v1 3/3] amd-xgbe: Convert to generic power management
Date:   Tue, 26 May 2020 13:33:24 +0530
Message-Id: <20200526080324.69828-4-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526080324.69828-1-vaibhavgupta40@gmail.com>
References: <20200526080324.69828-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

compile-tested only

Use dev_pm_ops structure to call generic suspend() and resume() callbacks.

Drivers should avoid saving device register and/or change power states
using PCI helper functions. With generic approach, all these are handled by
PCI core.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
index 7b86240ecd5f..014cee31a1d4 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
@@ -421,9 +421,9 @@ static void xgbe_pci_remove(struct pci_dev *pdev)
 	xgbe_free_pdata(pdata);
 }
 
-#ifdef CONFIG_PM
-static int xgbe_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused xgbe_pci_suspend(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct xgbe_prv_data *pdata = pci_get_drvdata(pdev);
 	struct net_device *netdev = pdata->netdev;
 	int ret = 0;
@@ -438,8 +438,9 @@ static int xgbe_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	return ret;
 }
 
-static int xgbe_pci_resume(struct pci_dev *pdev)
+static int __maybe_unused xgbe_pci_resume(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct xgbe_prv_data *pdata = pci_get_drvdata(pdev);
 	struct net_device *netdev = pdata->netdev;
 	int ret = 0;
@@ -460,7 +461,6 @@ static int xgbe_pci_resume(struct pci_dev *pdev)
 
 	return ret;
 }
-#endif /* CONFIG_PM */
 
 static const struct xgbe_version_data xgbe_v2a = {
 	.init_function_ptrs_phy_impl	= xgbe_init_function_ptrs_phy_v2,
@@ -502,15 +502,16 @@ static const struct pci_device_id xgbe_pci_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, xgbe_pci_table);
 
+static SIMPLE_DEV_PM_OPS(xgbe_pci_pm_ops, xgbe_pci_suspend, xgbe_pci_resume);
+
 static struct pci_driver xgbe_driver = {
 	.name = XGBE_DRV_NAME,
 	.id_table = xgbe_pci_table,
 	.probe = xgbe_pci_probe,
 	.remove = xgbe_pci_remove,
-#ifdef CONFIG_PM
-	.suspend = xgbe_pci_suspend,
-	.resume = xgbe_pci_resume,
-#endif
+	.driver = {
+		.pm = &xgbe_pci_pm_ops,
+	}
 };
 
 int xgbe_pci_init(void)
-- 
2.26.2

