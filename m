Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3093647556
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 16:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfFPOy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 10:54:57 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38014 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfFPOy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 10:54:56 -0400
Received: by mail-qt1-f196.google.com with SMTP id n11so7981311qtl.5;
        Sun, 16 Jun 2019 07:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a0e8a6kjw3Ld7aXlSsYEgWWio9r9Ou3iyyWaG+o4QfU=;
        b=FHAkksUfoBaCYpa/aL7oHlQ5GOpVEn3+NugfpQKWcxi34Wq0vgTvXb75JsfnZdfArn
         UY0Iu2ARgpvztEBbLNooDhbuJKlVbSUrTu8ZJ/eCcE2YLU5bER04EkDOxIIccJ2eBmpU
         r/rwCq8wVTXCgPCa1tRe/+Z9lylmp1qfATbN9AjtYzD30kTLxzMfvz/tRYgD2ACz7Hz/
         us2wJWiYdO7+zu9GOG0JJJSLlZQ+I8qdO9m+w4LY20hCIlju9/XO24Tr2D604OiaGbF4
         EbXASi3XzRwOKVOcxeleBbUbzYnPSo3UqhUtydfbotdjIYKm7MikCsf1/hdFMBq0OmWN
         e6jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a0e8a6kjw3Ld7aXlSsYEgWWio9r9Ou3iyyWaG+o4QfU=;
        b=VNvpFa5fPKioKhROZP55KCT/mmfSnJVvVcWP7TG4maZuatpyoyap+bemQ7H8kj4OkN
         AKrjeGqDQbHHK/wFWlVVFLAQekFTdRiltGjBkOqW9YtJFJvSapqCG8gVH5eEYN2pBjF6
         D7NOR4NRQzDJicERkJz52uZogNA4VUQ3ZIgo6jLB9p9DHhOyI+xTxzHZ49VKst2IC247
         LWPW6Jd+9tia6pu/+8PSE2RSm/QYKkY9iLz60yvj9q0UTnmTquagFEUqHvUVeZbyJQjL
         veCc3yWB/CkCtajbI8sWcE04ys6xE2EJfrSV6rMmFFLyM/uU3jR4oJq5qmhjG9mp3/4I
         U11A==
X-Gm-Message-State: APjAAAUY+RazaT7Om5bqQ38+FTLJKMyauIEKhCD+LgSDNNYcLfxhf3gi
        1ssT23fTIMPNvXYechuNKf0=
X-Google-Smtp-Source: APXvYqwJrBMj7BcFgAs1dJ8RVIMje2XA6B1DOm/NsRpRoOn+3BaTme4iQB1kcDSa35fyZ6JEAOkO4w==
X-Received: by 2002:ac8:6958:: with SMTP id n24mr50908481qtr.360.1560696895363;
        Sun, 16 Jun 2019 07:54:55 -0700 (PDT)
Received: from localhost.localdomain (mtrlpq02hsy-lp140-01-174-93-144-21.dsl.bell.ca. [174.93.144.21])
        by smtp.gmail.com with ESMTPSA id f26sm7146109qtf.44.2019.06.16.07.54.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 16 Jun 2019 07:54:54 -0700 (PDT)
From:   Detlev Casanova <detlev.casanova@gmail.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Detlev Casanova <detlev.casanova@gmail.com>
Subject: [PATCH] e1000e: Make watchdog use delayed work
Date:   Sun, 16 Jun 2019 10:54:45 -0400
Message-Id: <20190616145445.9637-1-detlev.casanova@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use delayed work instead of timers to run the watchdog of the e1000e
driver.

Simplify the code with one less middle function.

Signed-off-by: Detlev Casanova <detlev.casanova@gmail.com>
---
 drivers/net/ethernet/intel/e1000e/e1000.h  |  3 +-
 drivers/net/ethernet/intel/e1000e/netdev.c | 52 +++++++++++-----------
 2 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
index be13227f1697..942ab74030ca 100644
--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -186,12 +186,11 @@ struct e1000_phy_regs {
 
 /* board specific private data structure */
 struct e1000_adapter {
-	struct timer_list watchdog_timer;
 	struct timer_list phy_info_timer;
 	struct timer_list blink_timer;
 
 	struct work_struct reset_task;
-	struct work_struct watchdog_task;
+	struct delayed_work watchdog_task;
 
 	const struct e1000_info *ei;
 
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 0e09bede42a2..d101671cdb9b 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -39,6 +39,8 @@ static int debug = -1;
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
 
+struct workqueue_struct *e1000_workqueue;
+
 static const struct e1000_info *e1000_info_tbl[] = {
 	[board_82571]		= &e1000_82571_info,
 	[board_82572]		= &e1000_82572_info,
@@ -1780,7 +1782,7 @@ static irqreturn_t e1000_intr_msi(int __always_unused irq, void *data)
 		}
 		/* guard against interrupt when we're going down */
 		if (!test_bit(__E1000_DOWN, &adapter->state))
-			mod_timer(&adapter->watchdog_timer, jiffies + 1);
+			queue_delayed_work(e1000_workqueue, &adapter->watchdog_task, 1);
 	}
 
 	/* Reset on uncorrectable ECC error */
@@ -1860,7 +1862,7 @@ static irqreturn_t e1000_intr(int __always_unused irq, void *data)
 		}
 		/* guard against interrupt when we're going down */
 		if (!test_bit(__E1000_DOWN, &adapter->state))
-			mod_timer(&adapter->watchdog_timer, jiffies + 1);
+			queue_delayed_work(e1000_workqueue, &adapter->watchdog_task, 1);
 	}
 
 	/* Reset on uncorrectable ECC error */
@@ -1905,7 +1907,7 @@ static irqreturn_t e1000_msix_other(int __always_unused irq, void *data)
 		hw->mac.get_link_status = true;
 		/* guard against interrupt when we're going down */
 		if (!test_bit(__E1000_DOWN, &adapter->state))
-			mod_timer(&adapter->watchdog_timer, jiffies + 1);
+			queue_delayed_work(e1000_workqueue, &adapter->watchdog_task, 0);
 	}
 
 	if (!test_bit(__E1000_DOWN, &adapter->state))
@@ -4278,7 +4280,6 @@ void e1000e_down(struct e1000_adapter *adapter, bool reset)
 
 	napi_synchronize(&adapter->napi);
 
-	del_timer_sync(&adapter->watchdog_timer);
 	del_timer_sync(&adapter->phy_info_timer);
 
 	spin_lock(&adapter->stats64_lock);
@@ -5150,25 +5151,11 @@ static void e1000e_check_82574_phy_workaround(struct e1000_adapter *adapter)
 	}
 }
 
-/**
- * e1000_watchdog - Timer Call-back
- * @data: pointer to adapter cast into an unsigned long
- **/
-static void e1000_watchdog(struct timer_list *t)
-{
-	struct e1000_adapter *adapter = from_timer(adapter, t, watchdog_timer);
-
-	/* Do the rest outside of interrupt context */
-	schedule_work(&adapter->watchdog_task);
-
-	/* TODO: make this use queue_delayed_work() */
-}
-
 static void e1000_watchdog_task(struct work_struct *work)
 {
 	struct e1000_adapter *adapter = container_of(work,
 						     struct e1000_adapter,
-						     watchdog_task);
+						     watchdog_task.work);
 	struct net_device *netdev = adapter->netdev;
 	struct e1000_mac_info *mac = &adapter->hw.mac;
 	struct e1000_phy_info *phy = &adapter->hw.phy;
@@ -5395,8 +5382,8 @@ static void e1000_watchdog_task(struct work_struct *work)
 
 	/* Reset the timer */
 	if (!test_bit(__E1000_DOWN, &adapter->state))
-		mod_timer(&adapter->watchdog_timer,
-			  round_jiffies(jiffies + 2 * HZ));
+		queue_delayed_work(e1000_workqueue, &adapter->watchdog_task,
+				   round_jiffies(2 * HZ));
 }
 
 #define E1000_TX_FLAGS_CSUM		0x00000001
@@ -7251,11 +7238,21 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_eeprom;
 	}
 
-	timer_setup(&adapter->watchdog_timer, e1000_watchdog, 0);
+	e1000_workqueue = alloc_workqueue("%s", WQ_MEM_RECLAIM, 0,
+			                  e1000e_driver_name);
+
+	if (!e1000_workqueue)
+	{
+		err = -ENOMEM;
+		goto err_workqueue;
+	}
+
+	INIT_DELAYED_WORK(&adapter->watchdog_task, e1000_watchdog_task);
+	queue_delayed_work(e1000_workqueue, &adapter->watchdog_task, 0);
+
 	timer_setup(&adapter->phy_info_timer, e1000_update_phy_info, 0);
 
 	INIT_WORK(&adapter->reset_task, e1000_reset_task);
-	INIT_WORK(&adapter->watchdog_task, e1000_watchdog_task);
 	INIT_WORK(&adapter->downshift_task, e1000e_downshift_workaround);
 	INIT_WORK(&adapter->update_phy_task, e1000e_update_phy_task);
 	INIT_WORK(&adapter->print_hang_task, e1000_print_hw_hang);
@@ -7349,6 +7346,9 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 err_register:
+	flush_workqueue(e1000_workqueue);
+	destroy_workqueue(e1000_workqueue);
+err_workqueue:
 	if (!(adapter->flags & FLAG_HAS_AMT))
 		e1000e_release_hw_control(adapter);
 err_eeprom:
@@ -7395,15 +7395,17 @@ static void e1000_remove(struct pci_dev *pdev)
 	 */
 	if (!down)
 		set_bit(__E1000_DOWN, &adapter->state);
-	del_timer_sync(&adapter->watchdog_timer);
 	del_timer_sync(&adapter->phy_info_timer);
 
 	cancel_work_sync(&adapter->reset_task);
-	cancel_work_sync(&adapter->watchdog_task);
 	cancel_work_sync(&adapter->downshift_task);
 	cancel_work_sync(&adapter->update_phy_task);
 	cancel_work_sync(&adapter->print_hang_task);
 
+	cancel_delayed_work(&adapter->watchdog_task);
+	flush_workqueue(e1000_workqueue);
+	destroy_workqueue(e1000_workqueue);
+
 	if (adapter->flags & FLAG_HAS_HW_TIMESTAMP) {
 		cancel_work_sync(&adapter->tx_hwtstamp_work);
 		if (adapter->tx_hwtstamp_skb) {
-- 
2.22.0

