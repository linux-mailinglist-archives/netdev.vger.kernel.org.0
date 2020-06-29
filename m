Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC0620E548
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbgF2VfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:35:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728567AbgF2Skz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 14:40:55 -0400
Received: from localhost.localdomain.com (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CBA623E54;
        Mon, 29 Jun 2020 15:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443556;
        bh=A/kvMUhrL6RuTWQ+ET6YoN9FYDWOgBZKs3ZF69A4sLA=;
        h=From:To:Cc:Subject:Date:From;
        b=rKclHibuMMjEjOtritPsoR3Uo2kRffhaBIOJRo2tUW+7deyywSC8sbI6y05m2Gh0O
         3TLq7B6llT5Cud2PLQGyvFyB2iBOm5OGdjemgUcm+523uXRMkh1eYQoJ+OqqGyynQS
         8XcbI6Ho0xmXd+WPOU1o29LV8u86ZoET/kkRBDZ4=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, oleksandr@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH] mt76: mt76x2: fix pci suspend/resume on mt7612e
Date:   Mon, 29 Jun 2020 17:12:16 +0200
Message-Id: <b2c75a93cbffa1a8e1b9ae22e98c5097f82eefa7.1593443052.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following mt7612e hw hangs during suspend/resume reported on
Dell Vostro 3360

mt76x2e 0000:01:00.0: MCU message 2 (seq 11) timed out
mt76x2e 0000:01:00.0: MCU message 30 (seq 12) timed out
mt76x2e 0000:01:00.0: MCU message 30 (seq 13) timed out
mt76x2e 0000:01:00.0: Firmware Version: 0.0.00
mt76x2e 0000:01:00.0: Build: 1
mt76x2e 0000:01:00.0: Build Time: 201507311614____
mt76x2e 0000:01:00.0: Firmware running!
ieee80211 phy0: Hardware restart was requested
mt76x2e 0000:01:00.0: MCU message 2 (seq 1) timed out
mt76x2e 0000:01:00.0: MCU message 30 (seq 2) timed out
mt76x2e 0000:01:00.0: MCU message 30 (seq 3) timed out
mt76x2e 0000:01:00.0: Firmware Version: 0.0.00
mt76x2e 0000:01:00.0: Build: 1
mt76x2e 0000:01:00.0: Build Time: 201507311614____
mt76x2e 0000:01:00.0: Firmware running!
ieee80211 phy0: Hardware restart was requested
mt76x2e 0000:01:00.0: MCU message 31 (seq 5) timed out
mt76x2e 0000:01:00.0: MCU message 31 (seq 6) timed out
mt76x2e 0000:01:00.0: MCU message 31 (seq 7) timed out
mt76x2e 0000:01:00.0: MCU message 31 (seq 8) timed out
mt76x2e 0000:01:00.0: MCU message 31 (seq 9) timed out
mt76x2e 0000:01:00.0: MCU message 31 (seq 10) timed out
mt76x2e 0000:01:00.0: MCU message 31 (seq 11) timed out
mt76x2e 0000:01:00.0: Firmware Version: 0.0.00
mt76x2e 0000:01:00.0: Build: 1
mt76x2e 0000:01:00.0: Build Time: 201507311614____
mt76x2e 0000:01:00.0: Firmware running!
ieee80211 phy0: Hardware restart was requested
------------[ cut here ]-----------
CPU: 3 PID: 11956 Comm: kworker/3:1 Not tainted 5.7.0-pf2 #1
Hardware name: Dell Inc.          Vostro 3360/0F5DWF, BIOS A18 09/25/2013
Workqueue: events_freezable ieee80211_restart_work [mac80211]
RIP: 0010:ieee80211_reconfig+0x234/0x1700 [mac80211]
RSP: 0018:ffffb803c23ffdf0 EFLAGS: 00010286
RAX: 00000000fffffff0 RBX: ffff9595a7564900 RCX: 0000000000000008
RDX: 0000000000000000 RSI: 0000000000000100 RDI: 0000000000000100
RBP: ffff9595a7ec07e0 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000000 R12: ffff9595a7ec18d0
R13: 00000000ffffffff R14: 0000000000000000 R15: 00000000fffffff0
FS:  0000000000000000(0000) GS:ffff9595af2c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055e56d7de000 CR3: 000000042200a001 CR4: 00000000001706e0
Call Trace:
 ieee80211_restart_work+0xb7/0xe0 [mac80211]
 process_one_work+0x1d4/0x3c0
 worker_thread+0x228/0x470
 ? process_one_work+0x3c0/0x3c0
 kthread+0x19c/0x1c0
 ? __kthread_init_worker+0x30/0x30
 ret_from_fork+0x35/0x40
wlp1s0:  Failed check-sdata-in-driver check, flags: 0x0
CPU: 3 PID: 11956 Comm: kworker/3:1 Tainted: G        W         5.7.0-pf2 #1
Hardware name: Dell Inc.          Vostro 3360/0F5DWF, BIOS A18 09/25/2013
Workqueue: events_freezable ieee80211_restart_work [mac80211]
RIP: 0010:drv_remove_interface+0x11f/0x130 [mac80211]
RSP: 0018:ffffb803c23ffc80 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff9595a7564900 RCX: 0000000000000000
RDX: 0000000000000001 RSI: 0000000000000082 RDI: 00000000ffffffff
RBP: ffff9595a7ec1930 R08: 00000000000004b6 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000006f08 R12: ffff9595a7ec1000
R13: ffff9595a75654b8 R14: ffff9595a7ec0ca0 R15: ffff9595a7ec07e0
FS:  0000000000000000(0000) GS:ffff9595af2c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055e56d7de000 CR3: 000000042200a001 CR4: 00000000001706e0
Call Trace:
 ieee80211_do_stop+0x5af/0x8c0 [mac80211]
 ieee80211_stop+0x16/0x20 [mac80211]
 __dev_close_many+0xaa/0x120
 dev_close_many+0xa1/0x2b0
 dev_close+0x6d/0x90
 cfg80211_shutdown_all_interfaces+0x71/0xd0 [cfg80211]
 ieee80211_reconfig+0xa2/0x1700 [mac80211]
 ieee80211_restart_work+0xb7/0xe0 [mac80211]
 process_one_work+0x1d4/0x3c0
 worker_thread+0x228/0x470
 ? process_one_work+0x3c0/0x3c0
 kthread+0x19c/0x1c0
 ? __kthread_init_worker+0x30/0x30
 ret_from_fork+0x35/0x40

Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
Tested-by: Oleksandr Natalenko <oleksandr@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  1 +
 .../net/wireless/mediatek/mt76/mt76x2/pci.c   | 56 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  | 17 ++++++
 3 files changed, 74 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index eca95b7f64d2..d01f47c83eb1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -39,6 +39,7 @@ static inline bool mt76x2_channel_silent(struct mt76x02_dev *dev)
 extern const struct ieee80211_ops mt76x2_ops;
 
 int mt76x2_register_device(struct mt76x02_dev *dev);
+int mt76x2_resume_device(struct mt76x02_dev *dev);
 
 void mt76x2_phy_power_on(struct mt76x02_dev *dev);
 void mt76x2_stop_hardware(struct mt76x02_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
index f36c71c1bc58..6dfb0df8ec8a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
@@ -103,6 +103,58 @@ mt76x2e_remove(struct pci_dev *pdev)
 	mt76_free_device(mdev);
 }
 
+static int __maybe_unused
+mt76x2e_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct mt76_dev *mdev = pci_get_drvdata(pdev);
+	int i, err;
+
+	napi_disable(&mdev->tx_napi);
+	tasklet_kill(&mdev->pre_tbtt_tasklet);
+	tasklet_kill(&mdev->tx_tasklet);
+
+	mt76_for_each_q_rx(mdev, i)
+		napi_disable(&mdev->napi[i]);
+
+	pci_enable_wake(pdev, pci_choose_state(pdev, state), true);
+	pci_save_state(pdev);
+	err = pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	if (err)
+		goto restore;
+
+	return 0;
+
+restore:
+	mt76_for_each_q_rx(mdev, i)
+		napi_enable(&mdev->napi[i]);
+	napi_enable(&mdev->tx_napi);
+
+	return err;
+}
+
+static int __maybe_unused
+mt76x2e_resume(struct pci_dev *pdev)
+{
+	struct mt76_dev *mdev = pci_get_drvdata(pdev);
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
+	int i, err;
+
+	err = pci_set_power_state(pdev, PCI_D0);
+	if (err)
+		return err;
+
+	pci_restore_state(pdev);
+
+	mt76_for_each_q_rx(mdev, i) {
+		napi_enable(&mdev->napi[i]);
+		napi_schedule(&mdev->napi[i]);
+	}
+	napi_enable(&mdev->tx_napi);
+	napi_schedule(&mdev->tx_napi);
+
+	return mt76x2_resume_device(dev);
+}
+
 MODULE_DEVICE_TABLE(pci, mt76x2e_device_table);
 MODULE_FIRMWARE(MT7662_FIRMWARE);
 MODULE_FIRMWARE(MT7662_ROM_PATCH);
@@ -113,6 +165,10 @@ static struct pci_driver mt76pci_driver = {
 	.id_table	= mt76x2e_device_table,
 	.probe		= mt76x2e_probe,
 	.remove		= mt76x2e_remove,
+#ifdef CONFIG_PM
+	.suspend	= mt76x2e_suspend,
+	.resume		= mt76x2e_resume,
+#endif /* CONFIG_PM */
 };
 
 module_pci_driver(mt76pci_driver);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index f27774f57438..101a0fe00ef3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -217,6 +217,23 @@ mt76x2_power_on(struct mt76x02_dev *dev)
 	mt76x2_power_on_rf(dev, 1);
 }
 
+int mt76x2_resume_device(struct mt76x02_dev *dev)
+{
+	int err;
+
+	mt76x02_dma_disable(dev);
+	mt76x2_reset_wlan(dev, true);
+	mt76x2_power_on(dev);
+
+	err = mt76x2_mac_reset(dev, true);
+	if (err)
+		return err;
+
+	mt76x02_mac_start(dev);
+
+	return mt76x2_mcu_init(dev);
+}
+
 static int mt76x2_init_hardware(struct mt76x02_dev *dev)
 {
 	int ret;
-- 
2.26.2

