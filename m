Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBA120E0CB
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387776AbgF2Utu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731482AbgF2TNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:40 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DD0C0086DE;
        Mon, 29 Jun 2020 02:31:46 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id z5so8039614pgb.6;
        Mon, 29 Jun 2020 02:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U8LfJvZ8Suv0UU3L8Vq/myysU79XrKbzAI5mVt1upHA=;
        b=UMnRMoplidwqa2axc+13CTf6GjvG/QKjq19NX5mr89r2PyhZPX2MmNwdhqGn5qo/AE
         M/IV5z4/XD05V3cPZvLn0BS3/ArPV/QS+ZEH9j7MePFM4pBR9FEAf7VN6gytNgMOuzwd
         LpJdF3e/tF391hQub1QawVUYlZHIIYXfYfAVpsYvXVu9lab+VFzIx3/ydCnJKYCUXEmR
         VdWO4gpulSb43KzGvbLkwnqUkfIXscpggHyFGR/ixKo889mdkn9g1akJKYcwTJTY+HIS
         VYxamiq6E56/6ub1rzvsawOCbz6kYBvFRVeo28EdhIndpB5xhclS+Eh+UmAAuX0JpzPp
         egYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U8LfJvZ8Suv0UU3L8Vq/myysU79XrKbzAI5mVt1upHA=;
        b=mkQHfdvKLx3SYlrbGo5wZqvZQscv0ZW16Uyr2vuEJpbElvO84wlYkjcWTrZVPdHJlY
         eWbPwPyNcsL7gD6JhrjrqxsCHxfDbr4DwSz4/deZVmfVspAp3IivN212DDPcH3i5Zyae
         UpBI7o/QFV9plfNaQM+hDosjaWZdp2wxODRwFbgCck4caz+NQICDX/JCeClMO0glycwm
         EddpX1RDM6r9GJLdrv6UZYOrvdeiYbIjBan3yy/NQF5l9GQ00NURJL2+42xioF+TluDb
         uCl4hb5dQbDCMyJdc3kJ8QIMxCkAYcf2YSFHIZiGGEUGm6KgTwDUIG4dgiXIcn1/5k05
         OB3g==
X-Gm-Message-State: AOAM532G9bzmjJWiHy0DRt+vYNAIfsIiLFxm/DQLhMuQwS58eJXZdSbG
        gh69ovekFAzttowPaQdynXE=
X-Google-Smtp-Source: ABdhPJxCrwzkJMp9WcEN5z/vEr5Xrtqg4Z1I1sF8VTyeVMLmhzbwmlekF7t0Va8jyim44rh9w5wtUA==
X-Received: by 2002:a63:b915:: with SMTP id z21mr9981906pge.145.1593423105725;
        Mon, 29 Jun 2020 02:31:45 -0700 (PDT)
Received: from varodek.localdomain ([106.210.40.90])
        by smtp.gmail.com with ESMTPSA id q20sm2921286pfn.111.2020.06.29.02.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 02:31:45 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 5/5] e100: use generic power management
Date:   Mon, 29 Jun 2020 14:59:43 +0530
Message-Id: <20200629092943.227910-6-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629092943.227910-1-vaibhavgupta40@gmail.com>
References: <20200629092943.227910-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With legacy PM hooks, it was the responsibility of a driver to manage PCI
states and also the device's power state. The generic approach is to let
PCI core handle the work.

e100_suspend() calls __e100_shutdown() to perform intermediate tasks.
__e100_shutdown() calls pci_save_state() which is not recommended.

e100_suspend() also calls __e100_power_off() which is calling PCI helper
functions, pci_prepare_to_sleep(), pci_set_power_state(), along with
pci_wake_from_d3(...,false). Hence, the functin call is removed and wol is
disabled as earlier using device_wakeup_disable().

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/intel/e100.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 1b8d015ebfb0..7506fb5eca8f 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2997,8 +2997,6 @@ static void __e100_shutdown(struct pci_dev *pdev, bool *enable_wake)
 		e100_down(nic);
 	netif_device_detach(netdev);
 
-	pci_save_state(pdev);
-
 	if ((nic->flags & wol_magic) | e100_asf(nic)) {
 		/* enable reverse auto-negotiation */
 		if (nic->phy == phy_82552_v) {
@@ -3028,24 +3026,21 @@ static int __e100_power_off(struct pci_dev *pdev, bool wake)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int e100_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused e100_suspend(struct device *dev_d)
 {
 	bool wake;
-	__e100_shutdown(pdev, &wake);
-	return __e100_power_off(pdev, wake);
+	__e100_shutdown(to_pci_dev(dev_d), &wake);
+
+	device_wakeup_disable(dev_d);
+
+	return 0;
 }
 
-static int e100_resume(struct pci_dev *pdev)
+static int __maybe_unused e100_resume(struct device *dev_d)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev_d);
 	struct nic *nic = netdev_priv(netdev);
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	/* ack any pending wake events, disable PME */
-	pci_enable_wake(pdev, PCI_D0, 0);
-
 	/* disable reverse auto-negotiation */
 	if (nic->phy == phy_82552_v) {
 		u16 smartspeed = mdio_read(netdev, nic->mii.phy_id,
@@ -3062,7 +3057,6 @@ static int e100_resume(struct pci_dev *pdev)
 
 	return 0;
 }
-#endif /* CONFIG_PM */
 
 static void e100_shutdown(struct pci_dev *pdev)
 {
@@ -3150,16 +3144,17 @@ static const struct pci_error_handlers e100_err_handler = {
 	.resume = e100_io_resume,
 };
 
+static SIMPLE_DEV_PM_OPS(e100_pm_ops, e100_suspend, e100_resume);
+
 static struct pci_driver e100_driver = {
 	.name =         DRV_NAME,
 	.id_table =     e100_id_table,
 	.probe =        e100_probe,
 	.remove =       e100_remove,
-#ifdef CONFIG_PM
+
 	/* Power Management hooks */
-	.suspend =      e100_suspend,
-	.resume =       e100_resume,
-#endif
+	.driver.pm =	&e100_pm_ops,
+
 	.shutdown =     e100_shutdown,
 	.err_handler = &e100_err_handler,
 };
-- 
2.27.0

