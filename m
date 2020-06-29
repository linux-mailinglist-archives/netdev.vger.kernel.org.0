Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BD820E17A
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389774AbgF2U4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731283AbgF2TNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:09 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CDBC03E979;
        Sun, 28 Jun 2020 20:52:58 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b16so7293971pfi.13;
        Sun, 28 Jun 2020 20:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mMGxHvmMYl6KmBYcQsFExMxRkPUqi7/TV9d4rzWRr7k=;
        b=u2R2A9TNTrjVPaCWT+EtNeCfx976UM0/uvyxC3814IxJ3BmtNIBpFQ0ICCey/EcQGc
         C2eS5fpQk4UcCXH1AL8vjaVjN962La5SVUBbXE9DUXpkS2EulFeP7MKv0QrS30LgmQyA
         cQ2YIx5Dt2G8V0SVUKirabbIOS+ctzsLxrqbXTTe6FbjXEnT9K169K/WjAZx+6ZX270m
         k++SJlX43a5xXxXOD4YsBZgNqOf3YZSfrFwcvunodSnyOzYfknDpa3lYOFOoZY8PdBi8
         RgNZnFHUk+mC3uA38MgCHbsb3oJAcFv/T6tdXFqj0DgTQqEKKIGlhuti9b9huZHg99il
         aDTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mMGxHvmMYl6KmBYcQsFExMxRkPUqi7/TV9d4rzWRr7k=;
        b=Oj00TvbRgLoUUi5gmJh70uj/58twygrgn7n5JHCKtXPhCE+aDBEFZDjqLrvUpb7jeu
         yzy4IHuGYvOZg/KblKHYtsSUQK7mSI7oD42jYNKOAVv63bIV/Zc8lohqCxSaJOF1g/se
         o9l1RvR4mq76eswFlzv4jxaId3C29Y0wLV081BwpT2H/MZAYS1B2/7G7kYKN2IIrp7A7
         Zd1B1mbQ6cMv6TT/c2bRjmqScUTbTvueeMh4Xnt0+3DF4tSz0LYV5M12GqxzFn+zgd/B
         6OAagL9esXnOJfoWa5GwS7lqjV21ZISDUJl8uOHqp8kPLxNLpZFncGwPCbX1RZ7UAXEu
         jGCA==
X-Gm-Message-State: AOAM5328Pso4MS3TVeS5DW09NaDy0WZ5/GD3dukJB2xTzXc+LK2x83Ti
        9FDFX8OseeBRuAPMAMrbvZg=
X-Google-Smtp-Source: ABdhPJydbdI8co0v0o/sBZ2cRFoABhFdoGlHqU5hKHlqf4wT6H8b7R/olOtLPlXq7tzCb6hpIsCqjw==
X-Received: by 2002:a62:1716:: with SMTP id 22mr12030455pfx.99.1593402777406;
        Sun, 28 Jun 2020 20:52:57 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id b191sm28757684pga.13.2020.06.28.20.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 20:52:56 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, linux-wireless@vger.kernel.org
Subject: [PATCH v1] adm8211: use generic power management
Date:   Mon, 29 Jun 2020 09:20:32 +0530
Message-Id: <20200629035031.169670-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With legacy PM, drivers themselves were responsible for managing the
device's power states and takes care of register states.

After upgrading to the generic structure, PCI core will take care of
required tasks and drivers should do only device-specific operations.

In the case of adm8211, after removing PCI helper functions, .suspend()
and .resume() became empty-body functions. Hence, define them NULL and
use dev_pm_ops.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/wireless/admtek/adm8211.c | 25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/admtek/adm8211.c b/drivers/net/wireless/admtek/adm8211.c
index ba326f6c1214..22f9f2f8af10 100644
--- a/drivers/net/wireless/admtek/adm8211.c
+++ b/drivers/net/wireless/admtek/adm8211.c
@@ -1976,35 +1976,20 @@ static void adm8211_remove(struct pci_dev *pdev)
 }
 
 
-#ifdef CONFIG_PM
-static int adm8211_suspend(struct pci_dev *pdev, pm_message_t state)
-{
-	pci_save_state(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-	return 0;
-}
-
-static int adm8211_resume(struct pci_dev *pdev)
-{
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	return 0;
-}
-#endif /* CONFIG_PM */
-
+#define adm8211_suspend NULL
+#define adm8211_resume NULL
 
 MODULE_DEVICE_TABLE(pci, adm8211_pci_id_table);
 
+static SIMPLE_DEV_PM_OPS(adm8211_pm_ops, adm8211_suspend, adm8211_resume);
+
 /* TODO: implement enable_wake */
 static struct pci_driver adm8211_driver = {
 	.name		= "adm8211",
 	.id_table	= adm8211_pci_id_table,
 	.probe		= adm8211_probe,
 	.remove		= adm8211_remove,
-#ifdef CONFIG_PM
-	.suspend	= adm8211_suspend,
-	.resume		= adm8211_resume,
-#endif /* CONFIG_PM */
+	.driver.pm	= &adm8211_pm_ops,
 };
 
 module_pci_driver(adm8211_driver);
-- 
2.27.0

