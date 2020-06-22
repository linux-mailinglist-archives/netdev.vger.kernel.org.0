Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6B32035FC
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgFVLoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbgFVLoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:44:11 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36436C061794;
        Mon, 22 Jun 2020 04:44:10 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bh7so7457932plb.11;
        Mon, 22 Jun 2020 04:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s/zCuTBKH1kgRei9/PLc6fkyfxFbJ6O9JTgH9Zw9bLI=;
        b=L1Y6qRPpiJ7wjkUPPYV+yWXDZYyq7d1winYfIuveKQ+vr3B8aGhSLSrRRj0LIjVUmw
         i3m3lxunxggGfl9Jjol9gCHS7KluCkBJxbOS+WE6xXJ7X9EchL07q8gdsuT5tt0fYP6k
         JSbckvTGhhyPQulLeTvuWPkVR60h6FI3Twmoo2ZBdItMsD/R2sqm1vZneGXpuT1VJSml
         nXm75JK3QbkteUqKna+WDGOzHoTOYnBNIU8u6kfTlglLbivQoesbLsQmyVPKXB9LYIKy
         sqWclMDiJFpyj6uUAiK+BWc1E6+G20z545amyhaZqWVc+6EYaJT2WeQ1EOjLLRNYc2E+
         5MBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s/zCuTBKH1kgRei9/PLc6fkyfxFbJ6O9JTgH9Zw9bLI=;
        b=Xfggtm4BxYoWSyaBCljFMfj/3TkqeagUQU8T8JPp9jRZP2VWYelb1RUiLRA8WGyOV7
         P3VA4EJ9D+NFxpPFItTIwccSaYJzsK+5ee/+TfK+KBKNYHZxHze56XoIH5giwUir7rmH
         e1ihMfHOQBzGL544/3mnO6EoLb5CDxiTvdzfyjMLXKOMP6IgivTwoRF0lf7JM/ykNEkV
         MijOZHQMfkUyeR9mH5ElrzGsaiIhuqdasI4Ngs9HqS93dG/sW3qpu17z/NcpBgHiBFNA
         By2l7F5ZX6pw42N5+T3AkRkSg8GwxJkb6a/IFfgloK8sqx5fdMAySrzUpDS8XVoQNxbi
         IoDg==
X-Gm-Message-State: AOAM531QVW1rDRTt+t7FiD4xxhO8rfBIXXe+vP+OcldyBMfZ3/acaj2t
        4cUNd+Ux6Qg4MtpYidu72d4=
X-Google-Smtp-Source: ABdhPJyRXxliXX4cjV/vHWpiMmYDUvL3wizT4QWytIUjPst/tH0F9/f1PMuaccwBGyizSQEW9ZJjGw==
X-Received: by 2002:a17:90a:260b:: with SMTP id l11mr18778684pje.210.1592826249756;
        Mon, 22 Jun 2020 04:44:09 -0700 (PDT)
Received: from varodek.localdomain ([2401:4900:b8b:123e:d7ae:5602:b3d:9c0])
        by smtp.gmail.com with ESMTPSA id j17sm14081032pjy.22.2020.06.22.04.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 04:44:09 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/5] tulip: dmfe: use generic power management
Date:   Mon, 22 Jun 2020 17:12:24 +0530
Message-Id: <20200622114228.60027-2-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200622114228.60027-1-vaibhavgupta40@gmail.com>
References: <20200622114228.60027-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With legacy PM hooks, it was the responsibility of a driver to manage PCI
states and also the device's power state. The generic approach is to let the
PCI core handle the work.

The legacy suspend() and resume() were making use of
pci_read/write_config_dword() to enable/disable wol. Driver editing
configuration registers of a device is not recommended. Thus replace them
all with device_wakeup_enable/disable().

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/dec/tulip/dmfe.c | 49 +++++----------------------
 1 file changed, 9 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/dmfe.c b/drivers/net/ethernet/dec/tulip/dmfe.c
index c1884fc9ad32..c3b4abff48b5 100644
--- a/drivers/net/ethernet/dec/tulip/dmfe.c
+++ b/drivers/net/ethernet/dec/tulip/dmfe.c
@@ -2081,14 +2081,11 @@ static const struct pci_device_id dmfe_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, dmfe_pci_tbl);
 
-
-#ifdef CONFIG_PM
-static int dmfe_suspend(struct pci_dev *pci_dev, pm_message_t state)
+static int __maybe_unused dmfe_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pci_dev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct dmfe_board_info *db = netdev_priv(dev);
 	void __iomem *ioaddr = db->ioaddr;
-	u32 tmp;
 
 	/* Disable upper layer interface */
 	netif_device_detach(dev);
@@ -2105,63 +2102,35 @@ static int dmfe_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	dmfe_free_rxbuffer(db);
 
 	/* Enable WOL */
-	pci_read_config_dword(pci_dev, 0x40, &tmp);
-	tmp &= ~(DMFE_WOL_LINKCHANGE|DMFE_WOL_MAGICPACKET);
-
-	if (db->wol_mode & WAKE_PHY)
-		tmp |= DMFE_WOL_LINKCHANGE;
-	if (db->wol_mode & WAKE_MAGIC)
-		tmp |= DMFE_WOL_MAGICPACKET;
-
-	pci_write_config_dword(pci_dev, 0x40, tmp);
-
-	pci_enable_wake(pci_dev, PCI_D3hot, 1);
-	pci_enable_wake(pci_dev, PCI_D3cold, 1);
-
-	/* Power down device*/
-	pci_save_state(pci_dev);
-	pci_set_power_state(pci_dev, pci_choose_state (pci_dev, state));
+	device_wakeup_enable(dev_d);
 
 	return 0;
 }
 
-static int dmfe_resume(struct pci_dev *pci_dev)
+static int __maybe_unused dmfe_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pci_dev);
-	u32 tmp;
-
-	pci_set_power_state(pci_dev, PCI_D0);
-	pci_restore_state(pci_dev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 
 	/* Re-initialize DM910X board */
 	dmfe_init_dm910x(dev);
 
 	/* Disable WOL */
-	pci_read_config_dword(pci_dev, 0x40, &tmp);
-
-	tmp &= ~(DMFE_WOL_LINKCHANGE | DMFE_WOL_MAGICPACKET);
-	pci_write_config_dword(pci_dev, 0x40, tmp);
-
-	pci_enable_wake(pci_dev, PCI_D3hot, 0);
-	pci_enable_wake(pci_dev, PCI_D3cold, 0);
+	device_wakeup_disable(dev_d);
 
 	/* Restart upper layer interface */
 	netif_device_attach(dev);
 
 	return 0;
 }
-#else
-#define dmfe_suspend NULL
-#define dmfe_resume NULL
-#endif
+
+static SIMPLE_DEV_PM_OPS(dmfe_pm_ops, dmfe_suspend, dmfe_resume);
 
 static struct pci_driver dmfe_driver = {
 	.name		= "dmfe",
 	.id_table	= dmfe_pci_tbl,
 	.probe		= dmfe_init_one,
 	.remove		= dmfe_remove_one,
-	.suspend        = dmfe_suspend,
-	.resume         = dmfe_resume
+	.driver.pm	= &dmfe_pm_ops,
 };
 
 MODULE_AUTHOR("Sten Wang, sten_wang@davicom.com.tw");
-- 
2.27.0

