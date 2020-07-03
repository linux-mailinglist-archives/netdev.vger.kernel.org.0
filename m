Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425D22131FE
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 05:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgGCDDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 23:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgGCDDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 23:03:16 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EEEC08C5C1;
        Thu,  2 Jul 2020 20:03:16 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l63so14408456pge.12;
        Thu, 02 Jul 2020 20:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7/Ul8qd4qCPb+R/S6l8vvX2AsnTM3XBhH8ONOb+qXLQ=;
        b=YoC4LipQqqn/jldCWdIAwlgUZTF9gieKYuAKku9Tnv3zXhPkcnjN5Ex4YHMxCRg+Tz
         JFR3MBx0V8NkcXOW1tdInY6/PkI4mOD+mJ0y3sxH9WY8mSwoBg8xTjcb22CP7SIqnMQL
         Gnskco/ZvZAZRUlXIcGNJxaP/X2udS9Eb/usJtqYHydr9TT8ZK27jLqN09QX8P+VTIHx
         mAXZ3sP0jVw0wksFjjqFwD3AvTZdY/06V12rjtwPDYgQBvaw3dqHNAKwkF9zYc5MEIRA
         UPLVa0CtmW3dEUAjIida+NqmzndBgaGCkpkJguc0YN+1r/0yNgQvLzqlGVYhkFgIo2NL
         +uhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7/Ul8qd4qCPb+R/S6l8vvX2AsnTM3XBhH8ONOb+qXLQ=;
        b=FHmet9i9nnSv3QaEJjTzwdYxh20nqYCuBzmRbMgTS5Zyjx9sqCpGKeil0cUMLXEPgh
         f9TcqFlm8NEp7ypFoW2iENZMDZ3tz+W74I9sb+MpBvHJxNfxTDFHtTsGdiwokvtIGI52
         H59qkSXBb3knCtNCZlf5aVYMWYt8Qb0Of3bctOyh4P0+/YjlUb6yk8INM+hjoOJs4/Go
         42Yah3lY1V89tfjqVveH6Np0U70ua+BRg2LzUWaxTdtoLdAvxFc2jmicIdqBrtBeiupY
         bBkcehk7xpU0AHgajuS4f7fSEX/Re9B0GuTzAU76ciWavmepMGmnm98dILIhfnebh6zD
         t3QQ==
X-Gm-Message-State: AOAM530Ar4QuJ3FwixkJkvw2bVmef1xreuoBG4Q8EJApD3nHcEAQ1bti
        9LjkAAasfcLljEfjaB5xqfA=
X-Google-Smtp-Source: ABdhPJwzVlWrSFL5uLiWLLBMd9oA1y/5jtIF2yAs0j4cPWQ5Io1OPeP+h7Tg01cSpuYLMNCue8Xo3Q==
X-Received: by 2002:a63:ca11:: with SMTP id n17mr26926924pgi.439.1593745395573;
        Thu, 02 Jul 2020 20:03:15 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id h194sm9903223pfe.201.2020.07.02.20.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 20:03:15 -0700 (PDT)
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
Subject: [PATCH v2 2/2] smsc9420: use generic power management
Date:   Fri,  3 Jul 2020 08:31:38 +0530
Message-Id: <20200703030138.25724-3-vaibhavgupta40@gmail.com>
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
states and related operations, for the device, themselves. This driver was
handling them with the help of PCI helper functions.

With generic PM, all essentials will be handled by the PCI core. Driver
needs to do only device-specific operations.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/smsc/smsc9420.c | 40 ++++++++--------------------
 1 file changed, 11 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc9420.c b/drivers/net/ethernet/smsc/smsc9420.c
index 7312e522c022..42bef04d65ba 100644
--- a/drivers/net/ethernet/smsc/smsc9420.c
+++ b/drivers/net/ethernet/smsc/smsc9420.c
@@ -1422,11 +1422,9 @@ static int smsc9420_open(struct net_device *dev)
 	return result;
 }
 
-#ifdef CONFIG_PM
-
-static int smsc9420_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused smsc9420_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct smsc9420_pdata *pd = netdev_priv(dev);
 	u32 int_cfg;
 	ulong flags;
@@ -1451,34 +1449,21 @@ static int smsc9420_suspend(struct pci_dev *pdev, pm_message_t state)
 		netif_device_detach(dev);
 	}
 
-	pci_save_state(pdev);
-	pci_enable_wake(pdev, pci_choose_state(pdev, state), 0);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	device_wakeup_disable(dev_d);
 
 	return 0;
 }
 
-static int smsc9420_resume(struct pci_dev *pdev)
+static int __maybe_unused smsc9420_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
-	struct smsc9420_pdata *pd = netdev_priv(dev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	int err;
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-
-	err = pci_enable_device(pdev);
-	if (err)
-		return err;
+	pci_set_master(to_pci_dev(dev_d));
 
-	pci_set_master(pdev);
-
-	err = pci_enable_wake(pdev, PCI_D0, 0);
-	if (err)
-		netif_warn(pd, ifup, pd->dev, "pci_enable_wake failed: %d\n",
-			   err);
+	device_wakeup_disable(dev_d);
 
+	err = 0;
 	if (netif_running(dev)) {
 		/* FIXME: gross. It looks like ancient PM relic.*/
 		err = smsc9420_open(dev);
@@ -1487,8 +1472,6 @@ static int smsc9420_resume(struct pci_dev *pdev)
 	return err;
 }
 
-#endif /* CONFIG_PM */
-
 static const struct net_device_ops smsc9420_netdev_ops = {
 	.ndo_open		= smsc9420_open,
 	.ndo_stop		= smsc9420_stop,
@@ -1658,15 +1641,14 @@ static void smsc9420_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
+static SIMPLE_DEV_PM_OPS(smsc9420_pm_ops, smsc9420_suspend, smsc9420_resume);
+
 static struct pci_driver smsc9420_driver = {
 	.name = DRV_NAME,
 	.id_table = smsc9420_id_table,
 	.probe = smsc9420_probe,
 	.remove = smsc9420_remove,
-#ifdef CONFIG_PM
-	.suspend = smsc9420_suspend,
-	.resume = smsc9420_resume,
-#endif /* CONFIG_PM */
+	.driver.pm = &smsc9420_pm_ops,
 };
 
 static int __init smsc9420_init_module(void)
-- 
2.27.0

