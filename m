Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB598203575
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbgFVLP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728215AbgFVLPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:15:38 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B80BC061794;
        Mon, 22 Jun 2020 04:15:38 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id 35so7461755ple.0;
        Mon, 22 Jun 2020 04:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sxPv/Iyoimpx50ZrGLI4f7gnz66vb/eKDQ1bVrimQeA=;
        b=NbGBlQt5sHYNuNvrqaq0Ld4jjjxR4/TAI8CKJdvl3WkAzuV8B4LnvIUzuc5rT+uUpQ
         UGWoNydliKXJYPZSPPSUnxAqM5Jwx8h2mx6d4kMxDdwM1O979WVh/tWOalnpufh6An1M
         IAabhnHFmp28TsIsonT9hBNdXp9ZWY139a8Jp6zD5tiC1nIukE6EioSxjZTHPy162NYm
         a6l1O13/4b63mf3CfTRLf27B8Z2BxzvuoQAedIVXf3UuhlfwYu8se2rvHhpUXYGl8X73
         yYeGuh0C7nKZLlyVieEkJt0zut1eO/MVCCrsUHy427IsWLOM8QCPhkBSPxVaCkAeGE3j
         f2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sxPv/Iyoimpx50ZrGLI4f7gnz66vb/eKDQ1bVrimQeA=;
        b=luOUC+OPuTAbm74ZjhFKG7uI8WuDg3GwJxUzK88vWU4iGdihiuQVcKXxBns09Tc6/P
         65ln62Q0a4CMEKu9D9+W8pAE6XMFN7oMn5fmxZoWKCdyVTG5jwuG9IjUA5n7iy87ybdv
         wKnI/f2vLT7IzbffWXTc/DJWDoguS9pDZoTj4KlzuvX8wB0YqQqEd9yBa0YnI64o/2Q2
         RzYkA8+x9EZPuAYFc28/NQVW/TfDBnOMut39pZzYfwr/it4fnrV/wm/nVlN2VLTX5rnl
         LC5/djwUu6UgtwFKrBYjBO1sE+/WqGluA5QPBttLStuM/fW0KkDJdFku69aHoa0dv/Gp
         nJGQ==
X-Gm-Message-State: AOAM533E3OvRguJ5CRS680EaaQmC5litQOL82/IepQeTZ0rz8jcXKV69
        01d16o0CpDx6J7bn+yHHCqg=
X-Google-Smtp-Source: ABdhPJzZO5xLP2AwlmraI94flE9YliyRPA8lEdwVhoqOd0C80a6IiTL2RDKR/0y/elsqHYMyfM5Clw==
X-Received: by 2002:a17:902:7404:: with SMTP id g4mr18941802pll.134.1592824537633;
        Mon, 22 Jun 2020 04:15:37 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id n189sm13950150pfn.108.2020.06.22.04.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 04:15:37 -0700 (PDT)
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
Subject: [PATCH v2 2/3] amd8111e: Convert to generic power management
Date:   Mon, 22 Jun 2020 16:43:59 +0530
Message-Id: <20200622111400.55956-3-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200622111400.55956-1-vaibhavgupta40@gmail.com>
References: <20200622111400.55956-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers should not save device registers and/or change the power state of
the device. As per the generic PM approach, these are handled by PCI core.

The driver should support dev_pm_ops callbacks and bind them to pci_driver.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/amd/amd8111e.c | 30 +++++++++++------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 7a1286f8e983..c6591b33abcc 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -1580,9 +1580,10 @@ static void amd8111e_tx_timeout(struct net_device *dev, unsigned int txqueue)
 	if(!err)
 		netif_wake_queue(dev);
 }
-static int amd8111e_suspend(struct pci_dev *pci_dev, pm_message_t state)
+
+static int amd8111e_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pci_dev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct amd8111e_priv *lp = netdev_priv(dev);
 
 	if (!netif_running(dev))
@@ -1609,34 +1610,24 @@ static int amd8111e_suspend(struct pci_dev *pci_dev, pm_message_t state)
 		if(lp->options & OPTION_WAKE_PHY_ENABLE)
 			amd8111e_enable_link_change(lp);
 
-		pci_enable_wake(pci_dev, PCI_D3hot, 1);
-		pci_enable_wake(pci_dev, PCI_D3cold, 1);
+		device_set_wakeup_enable(dev_d, 1);
 
 	}
 	else{
-		pci_enable_wake(pci_dev, PCI_D3hot, 0);
-		pci_enable_wake(pci_dev, PCI_D3cold, 0);
+		device_set_wakeup_enable(dev_d, 0);
 	}
 
-	pci_save_state(pci_dev);
-	pci_set_power_state(pci_dev, PCI_D3hot);
-
 	return 0;
 }
-static int amd8111e_resume(struct pci_dev *pci_dev)
+
+static int amd8111e_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pci_dev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct amd8111e_priv *lp = netdev_priv(dev);
 
 	if (!netif_running(dev))
 		return 0;
 
-	pci_set_power_state(pci_dev, PCI_D0);
-	pci_restore_state(pci_dev);
-
-	pci_enable_wake(pci_dev, PCI_D3hot, 0);
-	pci_enable_wake(pci_dev, PCI_D3cold, 0); /* D3 cold */
-
 	netif_device_attach(dev);
 
 	spin_lock_irq(&lp->lock);
@@ -1918,13 +1909,14 @@ static const struct pci_device_id amd8111e_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, amd8111e_pci_tbl);
 
+static SIMPLE_DEV_PM_OPS(amd8111e_pm_ops, amd8111e_suspend, amd8111e_resume);
+
 static struct pci_driver amd8111e_driver = {
 	.name   	= MODULE_NAME,
 	.id_table	= amd8111e_pci_tbl,
 	.probe		= amd8111e_probe_one,
 	.remove		= amd8111e_remove_one,
-	.suspend	= amd8111e_suspend,
-	.resume		= amd8111e_resume
+	.driver.pm	= &amd8111e_pm_ops
 };
 
 module_pci_driver(amd8111e_driver);
-- 
2.27.0

