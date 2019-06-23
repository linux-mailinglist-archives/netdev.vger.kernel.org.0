Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE204F99E
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 05:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfFWDOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 23:14:54 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35230 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbfFWDOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 23:14:54 -0400
Received: by mail-qt1-f195.google.com with SMTP id d23so11088690qto.2;
        Sat, 22 Jun 2019 20:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yt/Wn2k1Bs2ZNvwnGQBOScs+RF3isMwjxUfPlb4LBKg=;
        b=X1gfy35mNI+e94xiZ939SZN6GbHePbNBZZkziEt5W4an4xwwXAhGVgu5QW1b9Lf1h+
         rqCzYVSWO0wsb4CYwJf0GER4adKeIyUEICkxgwXclfzDuY0HxO7PCJv0RKE/GD1VX67d
         bE+IEC2AQ4Nh8TBK4KWPvkLgm4mrvJYKcpfeIWEwLVi11N5fugcPslwL0qcBe92xn4kd
         RLrblb3V02DOhKqHmXN5ciG2nID2jGwdmV2szsVsckW9IuTGW0lgT8b3rV2n64/mcTXB
         pm8gq2CwMCjTjQkSpt2zTIe3VGAgkIVnO9W45vEV+Xeahbs3esxjJg/I26yayg4oCW9V
         XQ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yt/Wn2k1Bs2ZNvwnGQBOScs+RF3isMwjxUfPlb4LBKg=;
        b=Q4PiAiyJu1xdsLeZzw7+sPXTK2n1We8+ipAJjkQsKwYYAYot/6ORxwbRmIgf7z/Y+O
         z7x8GDZI36Pcv1RPET+C5hla4/x5cpsMFhiKgA/aTaprKsfL0qo4IcYf5oc0DEQ0jxnx
         Nyi/b6BdyEOwl3xcF4etv3uMoqpYYBz928oVFcG6A5qfkoNIuSSSp79xnEkkBcybc6B9
         FrnHMuVzfGC3KgVlwqIYGVBH/qUi6gZyKMUcDQr/8Tm52io9cNYU2uz67EneTCr19SYF
         LCx47+HgH/L3JwrbWetGYxUILTAf6C4/9yE91J06KpSi9T9no98FSJEpOadqZVz6NE69
         8xRA==
X-Gm-Message-State: APjAAAWeglbqsKn0Zx7HLPh/V6FWVMprnTjrbHTV9ste8BytPNeEW/a4
        rH/oPkKlyLGlHXdHVrS7ZxqS3td+wIrvfA==
X-Google-Smtp-Source: APXvYqxCGNBcuKFQ4RXBDWQ1dl4eZSToIxxEtg7OoyyTqUXYgDq0sORS7PsHXgaihXySepxDAzW0Yg==
X-Received: by 2002:aed:21c6:: with SMTP id m6mr61980185qtc.173.1561259693181;
        Sat, 22 Jun 2019 20:14:53 -0700 (PDT)
Received: from localhost.localdomain (mtrlpq02hsy-lp140-01-174-93-144-21.dsl.bell.ca. [174.93.144.21])
        by smtp.gmail.com with ESMTPSA id j6sm3721176qkf.119.2019.06.22.20.14.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 22 Jun 2019 20:14:51 -0700 (PDT)
From:   Detlev Casanova <detlev.casanova@gmail.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Detlev Casanova <detlev.casanova@gmail.com>
Subject: [PATCH v3] e1000e: Make watchdog use delayed work
Date:   Sat, 22 Jun 2019 23:14:37 -0400
Message-Id: <20190623031437.19716-1-detlev.casanova@gmail.com>
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
 drivers/net/ethernet/intel/e1000e/e1000.h  |  5 +-
 drivers/net/ethernet/intel/e1000e/netdev.c | 54 ++++++++++++----------
 2 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
index be13227f1697..34cd67951aec 100644
--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -186,12 +186,13 @@ struct e1000_phy_regs {
 
 /* board specific private data structure */
 struct e1000_adapter {
-	struct timer_list watchdog_timer;
 	struct timer_list phy_info_timer;
 	struct timer_list blink_timer;
 
 	struct work_struct reset_task;
-	struct work_struct watchdog_task;
+	struct delayed_work watchdog_task;
+
+	struct workqueue_struct *e1000_workqueue;
 
 	const struct e1000_info *ei;
 
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 0e09bede42a2..6fb6918bc136 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -1780,7 +1780,8 @@ static irqreturn_t e1000_intr_msi(int __always_unused irq, void *data)
 		}
 		/* guard against interrupt when we're going down */
 		if (!test_bit(__E1000_DOWN, &adapter->state))
-			mod_timer(&adapter->watchdog_timer, jiffies + 1);
+			queue_delayed_work(adapter->e1000_workqueue,
+					   &adapter->watchdog_task, 1);
 	}
 
 	/* Reset on uncorrectable ECC error */
@@ -1860,7 +1861,8 @@ static irqreturn_t e1000_intr(int __always_unused irq, void *data)
 		}
 		/* guard against interrupt when we're going down */
 		if (!test_bit(__E1000_DOWN, &adapter->state))
-			mod_timer(&adapter->watchdog_timer, jiffies + 1);
+			queue_delayed_work(adapter->e1000_workqueue,
+					   &adapter->watchdog_task, 1);
 	}
 
 	/* Reset on uncorrectable ECC error */
@@ -1905,7 +1907,8 @@ static irqreturn_t e1000_msix_other(int __always_unused irq, void *data)
 		hw->mac.get_link_status = true;
 		/* guard against interrupt when we're going down */
 		if (!test_bit(__E1000_DOWN, &adapter->state))
-			mod_timer(&adapter->watchdog_timer, jiffies + 1);
+			queue_delayed_work(adapter->e1000_workqueue,
+					   &adapter->watchdog_task, 1);
 	}
 
 	if (!test_bit(__E1000_DOWN, &adapter->state))
@@ -4278,7 +4281,6 @@ void e1000e_down(struct e1000_adapter *adapter, bool reset)
 
 	napi_synchronize(&adapter->napi);
 
-	del_timer_sync(&adapter->watchdog_timer);
 	del_timer_sync(&adapter->phy_info_timer);
 
 	spin_lock(&adapter->stats64_lock);
@@ -5150,25 +5152,11 @@ static void e1000e_check_82574_phy_workaround(struct e1000_adapter *adapter)
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
@@ -5395,8 +5383,9 @@ static void e1000_watchdog_task(struct work_struct *work)
 
 	/* Reset the timer */
 	if (!test_bit(__E1000_DOWN, &adapter->state))
-		mod_timer(&adapter->watchdog_timer,
-			  round_jiffies(jiffies + 2 * HZ));
+		queue_delayed_work(adapter->e1000_workqueue,
+				   &adapter->watchdog_task,
+				   round_jiffies(2 * HZ));
 }
 
 #define E1000_TX_FLAGS_CSUM		0x00000001
@@ -7251,11 +7240,21 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_eeprom;
 	}
 
-	timer_setup(&adapter->watchdog_timer, e1000_watchdog, 0);
+	adapter->e1000_workqueue = alloc_workqueue("%s", WQ_MEM_RECLAIM, 0,
+						   e1000e_driver_name);
+
+	if (!adapter->e1000_workqueue) {
+		err = -ENOMEM;
+		goto err_workqueue;
+	}
+
+	INIT_DELAYED_WORK(&adapter->watchdog_task, e1000_watchdog_task);
+	queue_delayed_work(adapter->e1000_workqueue, &adapter->watchdog_task,
+			   0);
+
 	timer_setup(&adapter->phy_info_timer, e1000_update_phy_info, 0);
 
 	INIT_WORK(&adapter->reset_task, e1000_reset_task);
-	INIT_WORK(&adapter->watchdog_task, e1000_watchdog_task);
 	INIT_WORK(&adapter->downshift_task, e1000e_downshift_workaround);
 	INIT_WORK(&adapter->update_phy_task, e1000e_update_phy_task);
 	INIT_WORK(&adapter->print_hang_task, e1000_print_hw_hang);
@@ -7349,6 +7348,9 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 err_register:
+	flush_workqueue(adapter->e1000_workqueue);
+	destroy_workqueue(adapter->e1000_workqueue);
+err_workqueue:
 	if (!(adapter->flags & FLAG_HAS_AMT))
 		e1000e_release_hw_control(adapter);
 err_eeprom:
@@ -7395,15 +7397,17 @@ static void e1000_remove(struct pci_dev *pdev)
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
+	flush_workqueue(adapter->e1000_workqueue);
+	destroy_workqueue(adapter->e1000_workqueue);
+
 	if (adapter->flags & FLAG_HAS_HW_TIMESTAMP) {
 		cancel_work_sync(&adapter->tx_hwtstamp_work);
 		if (adapter->tx_hwtstamp_skb) {
-- 
2.22.0

