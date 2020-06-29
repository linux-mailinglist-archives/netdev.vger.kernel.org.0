Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D6620E1AB
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390010AbgF2U62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731255AbgF2TNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:04 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A4CC0086DD;
        Mon, 29 Jun 2020 02:31:40 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id z5so8039474pgb.6;
        Mon, 29 Jun 2020 02:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ayAl0LoNSdRH5ysQrzi9ZVtfNrMXxNYN9qeSjnl571U=;
        b=GV0KvGGX4dJpz/Wcl9nBaTIGm6slYAAJClid5ntya+hSHoQshp9o8aro6FvFHtt3QY
         D9DNF1s9O9XiHhwhAk1gjjifrTGvawv6ZbQnHsxHHkOIrK/rt38r+iaZuYejiSFv8f0H
         vXzVPrjXgzjvl0Bp0LmYH9HKRbWmihJ5KuF1g6LUH/03IsCMryUbichVVlfjSFPpRPw5
         x3fnnUnUovLSp/DqQgHTAMju1MG1BQ2HLkpTYlydRrgeYoPA8ijwr/94gfGkUgRH5N2N
         I7gdEp+00LPtV+avLCRnOgYhiR4Ieg3y5ys2aUj3PM2SGrSB8vccHGahSoNMSpfSa8/Q
         /ctw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ayAl0LoNSdRH5ysQrzi9ZVtfNrMXxNYN9qeSjnl571U=;
        b=MsNT4uTYh2vU5aoEmOwFCpI0PIXML4H7xYovOQtCkiwg7UX/5kND1U8O/jIeDcZM+G
         OOOq2v2ygGUow58UTSRo6w5kA2T+1wXMYcF4TFP9p6uT4Gey2nIOsrQX6bG3d2PifDsr
         DNV3fYaLP793vnHLfRQCdOx7FVZGcTcod7CnmAb8Rdlb5HbSx27Nn1C9/RR4symzvc5o
         eyADLfk4GjucOO+aH0l0r3++V27S7cqtBvH8rYry/a8PK6slNYtAzWXV6g26B15sbP7Z
         iIR23T48wJ/2t7NlxiO/2msmjum3DSCQnnnSwvQYxakVJLfuevSWqf0Euy+2K1qDuaHq
         AG/w==
X-Gm-Message-State: AOAM5300omtjR31ClpjJJjcUx3O2TvYbammPwWscDCviOJg6WndIG+gR
        leY5da+JmyXlBYWwNNhlrII=
X-Google-Smtp-Source: ABdhPJwRDli2Y2bH5K3wrG95jVuSEXZnknlpezTd2aULIFClM3Bmo5xukNXS6A/E8xgqSTqHNHa17A==
X-Received: by 2002:a63:5623:: with SMTP id k35mr10075750pgb.325.1593423099692;
        Mon, 29 Jun 2020 02:31:39 -0700 (PDT)
Received: from varodek.localdomain ([106.210.40.90])
        by smtp.gmail.com with ESMTPSA id q20sm2921286pfn.111.2020.06.29.02.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 02:31:39 -0700 (PDT)
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
Subject: [PATCH v1 4/5] ixgbevf: use generic power management
Date:   Mon, 29 Jun 2020 14:59:42 +0530
Message-Id: <20200629092943.227910-5-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629092943.227910-1-vaibhavgupta40@gmail.com>
References: <20200629092943.227910-1-vaibhavgupta40@gmail.com>
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

The driver was invoking PCI helper functions like pci_save/restore_state(),
and pci_enable/disable_device(), which is not recommended.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 44 +++++--------------
 1 file changed, 10 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index a39e2cb384dd..988345aeae4a 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4300,13 +4300,10 @@ static int ixgbevf_change_mtu(struct net_device *netdev, int new_mtu)
 	return 0;
 }
 
-static int ixgbevf_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused ixgbevf_suspend(struct device *dev_d)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev_d);
 	struct ixgbevf_adapter *adapter = netdev_priv(netdev);
-#ifdef CONFIG_PM
-	int retval = 0;
-#endif
 
 	rtnl_lock();
 	netif_device_detach(netdev);
@@ -4317,37 +4314,16 @@ static int ixgbevf_suspend(struct pci_dev *pdev, pm_message_t state)
 	ixgbevf_clear_interrupt_scheme(adapter);
 	rtnl_unlock();
 
-#ifdef CONFIG_PM
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-
-#endif
-	if (!test_and_set_bit(__IXGBEVF_DISABLED, &adapter->state))
-		pci_disable_device(pdev);
-
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int ixgbevf_resume(struct pci_dev *pdev)
+static int __maybe_unused ixgbevf_resume(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct ixgbevf_adapter *adapter = netdev_priv(netdev);
 	u32 err;
 
-	pci_restore_state(pdev);
-	/* pci_restore_state clears dev->state_saved so call
-	 * pci_save_state to restore it.
-	 */
-	pci_save_state(pdev);
-
-	err = pci_enable_device_mem(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "Cannot enable PCI device from suspend\n");
-		return err;
-	}
-
 	adapter->hw.hw_addr = adapter->io_addr;
 	smp_mb__before_atomic();
 	clear_bit(__IXGBEVF_DISABLED, &adapter->state);
@@ -4368,10 +4344,9 @@ static int ixgbevf_resume(struct pci_dev *pdev)
 	return err;
 }
 
-#endif /* CONFIG_PM */
 static void ixgbevf_shutdown(struct pci_dev *pdev)
 {
-	ixgbevf_suspend(pdev, PMSG_SUSPEND);
+	ixgbevf_suspend(&pdev->dev);
 }
 
 static void ixgbevf_get_tx_ring_stats(struct rtnl_link_stats64 *stats,
@@ -4891,16 +4866,17 @@ static const struct pci_error_handlers ixgbevf_err_handler = {
 	.resume = ixgbevf_io_resume,
 };
 
+static SIMPLE_DEV_PM_OPS(ixgbevf_pm_ops, ixgbevf_suspend, ixgbevf_resume);
+
 static struct pci_driver ixgbevf_driver = {
 	.name		= ixgbevf_driver_name,
 	.id_table	= ixgbevf_pci_tbl,
 	.probe		= ixgbevf_probe,
 	.remove		= ixgbevf_remove,
-#ifdef CONFIG_PM
+
 	/* Power Management Hooks */
-	.suspend	= ixgbevf_suspend,
-	.resume		= ixgbevf_resume,
-#endif
+	.driver.pm	= &ixgbevf_pm_ops,
+
 	.shutdown	= ixgbevf_shutdown,
 	.err_handler	= &ixgbevf_err_handler
 };
-- 
2.27.0

