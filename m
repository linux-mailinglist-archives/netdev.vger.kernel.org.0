Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FCB3BCDA6
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbhGFLWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:22:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232840AbhGFLT4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2D8E61CBC;
        Tue,  6 Jul 2021 11:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570225;
        bh=mZKFMY0ytWBWAZHjLhQRjClxhAk1RJo5gdFgA0TuVRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YaNXh+R0AsyTn+OpshxzyWyVrHoue4wSKMFrfTshEGo5Tv00V+IufzADp+H20Jq02
         ntUV+mzkcDNVj+aAzpLhNhE9Spyl2b/9Y/IUqtzktpzwVSOcTEiCJM0zq8PWQQH8De
         rn/Wr7BP5ZU9ksTWfCVXiFAU9ZejpBai0kfHJdwaMQdNKpHn4GbDjYzkYUIpbKhZeT
         xGKJN8F6M8H3inc43VpYNcFwGu+QM5y61jhbTlsx/hqZJOLWv0gd2q5XynKZcesbEU
         Hb/YYhpKmT4q/RRWn+bH/K7xoEOA99h66/UyES78+0csGcWyOMsYuyg1FXeyvvZJBU
         T9aSN6o6Bagzw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 131/189] mt76: mt7921: fix reset under the deep sleep is enabled
Date:   Tue,  6 Jul 2021 07:13:11 -0400
Message-Id: <20210706111409.2058071-131-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 7bf0a71e839822bb6ba04a6e163ad334314e2659 ]

To fix possibly the race to access register between the WiFi reset
and the other context that is caused by explicitly cancelling ps_work
and wake_work to break PM_STATE consistency.

Deep sleep would cause the hardware into the inactive state,
so we forcely put device drv_own state before we start to reset.

The patch also ignore the reset request when the procedure is in
progress to avoid the consecutive WiFi resets.

localhost ~ # [ 2932.073966] SError Interrupt on CPU7, code 0xbe000011
[ 2932.073967] CPU: 7 PID: 8761 Comm: kworker/u16:2 Not tainted 5.4.112 #30
[ 2932.073968] Hardware name: MediaTek Asurada rev1 board (DT)
[ 2932.073968] Workqueue: phy0 ieee80211_reconfig_filter [mac80211]
[ 2932.073969] pstate: 80400089 (Nzcv daIf +PAN -UAO)
[ 2932.073969] pc : el1_irq+0x78/0x180
[ 2932.073970] lr : mt76_mmio_rmw+0x30/0x5c [mt76]
[ 2932.073970] sp : ffffffc01142bad0
[ 2932.073970] x29: ffffffc01142bc00 x28: ffffff8f96fb1e00
[ 2932.073971] x27: ffffffd2cdc12138 x26: ffffffd2cdaeb018
[ 2932.073972] x25: 0000000000000000 x24: ffffff8fa8e14c08
[ 2932.073973] x23: 0000000080c00009 x22: ffffffd2a5603918
[ 2932.073974] x21: ffffffc01142bc10 x20: 0000007fffffffff
[ 2932.073975] x19: 0000000000000000 x18: 0000000000000400
[ 2932.073975] x17: 0000000000000400 x16: ffffffd2cd2b87dc
[ 2932.073976] x15: 0000000000000000 x14: 0000000000000000
[ 2932.073977] x13: 0000000000000001 x12: 0000000000000001
[ 2932.073978] x11: 0000000000000001 x10: 000000000010e000
[ 2932.073978] x9 : 0000000000000000 x8 : ffffffc013921404
[ 2932.073979] x7 : 000000b2b5593519 x6 : 0000000000300000
[ 2932.073980] x5 : 0000000000000000 x4 : ffffffc01142bbc8
[ 2932.073980] x3 : 00000000000001f0 x2 : 0000000000000000
[ 2932.073981] x1 : 0000000000021404 x0 : ffffff8fa8e12300
[ 2932.073982] Kernel panic - not syncing: Asynchronous SError Interrupt
[ 2932.073983] CPU: 7 PID: 8761 Comm: kworker/u16:2 Not tainted 5.4.112 #30
[ 2932.073983] Hardware name: MediaTek Asurada rev1 board (DT)
[ 2932.073984] Workqueue: phy0 ieee80211_reconfig_filter [mac80211]
[ 2932.073984] Call trace:
[ 2932.073985]  dump_backtrace+0x0/0x14c
[ 2932.073985]  show_stack+0x20/0x2c
[ 2932.073985]  dump_stack+0xa0/0xf8
[ 2932.073986]  panic+0x154/0x360
[ 2932.073986]  test_taint+0x0/0x44
[ 2932.073986]  arm64_serror_panic+0x78/0x84
[ 2932.073987]  do_serror+0x0/0x118
[ 2932.073987]  do_serror+0xa4/0x118
[ 2932.073987]  el1_error+0x84/0xf8
[ 2932.073988]  el1_irq+0x78/0x180
[ 2932.073988]  mt76_mmio_rr+0x30/0xf0 [mt76]
[ 2932.073988]  mt76_mmio_rmw+0x30/0x5c [mt76]
[ 2932.073989]  mt7921_rmw+0x4c/0x5c [mt7921e]
[ 2932.073989]  mt7921_configure_filter+0x138/0x160 [mt7921e]
[ 2932.073990]  ieee80211_configure_filter+0x2f0/0x3e0 [mac80211]
[ 2932.073990]  ieee80211_reconfig_filter+0x1c/0x28 [mac80211]
[ 2932.073990]  process_one_work+0x208/0x3c8
[ 2932.073991]  worker_thread+0x23c/0x3e8
[ 2932.073991]  kthread+0x140/0x17c
[ 2932.073992]  ret_from_fork+0x10/0x18
[ 2932.074071] SMP: stopping secondary CPUs
[ 2932.074071] Kernel Offset: 0x12bc800000 from 0xffffffc010000000
[ 2932.074072] PHYS_OFFSET: 0xfffffff180000000
[ 2932.074072] CPU features: 0x080026,2a80aa18
[ 2932.074072] Memory Limit: none

Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/mac.c   | 21 +++++++++--------
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   | 23 ++++++++++++++-----
 .../wireless/mediatek/mt76/mt7921/mt7921.h    |  1 +
 3 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index decf2d5f0ce3..66a12eba32b6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1241,9 +1241,10 @@ mt7921_mac_reset(struct mt7921_dev *dev)
 	mt76_worker_enable(&dev->mt76.tx_worker);
 
 	clear_bit(MT76_MCU_RESET, &dev->mphy.state);
-	clear_bit(MT76_STATE_PM, &dev->mphy.state);
 
-	mt76_wr(dev, MT_WFDMA0_HOST_INT_ENA, 0);
+	mt76_wr(dev, MT_WFDMA0_HOST_INT_ENA,
+		MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL |
+		MT_INT_MCU_CMD);
 	mt76_wr(dev, MT_PCIE_MAC_INT_ENABLE, 0xff);
 
 	err = mt7921_run_firmware(dev);
@@ -1261,22 +1262,23 @@ mt7921_mac_reset(struct mt7921_dev *dev)
 /* system error recovery */
 void mt7921_mac_reset_work(struct work_struct *work)
 {
-	struct ieee80211_hw *hw;
-	struct mt7921_dev *dev;
+	struct mt7921_dev *dev = container_of(work, struct mt7921_dev,
+					      reset_work);
+	struct ieee80211_hw *hw = mt76_hw(dev);
+	struct mt76_connac_pm *pm = &dev->pm;
 	int i;
 
-	dev = container_of(work, struct mt7921_dev, reset_work);
-	hw = mt76_hw(dev);
-
 	dev_err(dev->mt76.dev, "chip reset\n");
 	ieee80211_stop_queues(hw);
 
 	cancel_delayed_work_sync(&dev->mphy.mac_work);
-	cancel_delayed_work_sync(&dev->pm.ps_work);
-	cancel_work_sync(&dev->pm.wake_work);
+	cancel_delayed_work_sync(&pm->ps_work);
+	cancel_work_sync(&pm->wake_work);
 
 	mutex_lock(&dev->mt76.mutex);
 	for (i = 0; i < 10; i++) {
+		__mt7921_mcu_drv_pmctrl(dev);
+
 		if (!mt7921_mac_reset(dev))
 			break;
 	}
@@ -1297,6 +1299,7 @@ void mt7921_mac_reset_work(struct work_struct *work)
 	ieee80211_iterate_active_interfaces(hw,
 					    IEEE80211_IFACE_ITER_RESUME_ALL,
 					    mt7921_vif_connect_iter, NULL);
+	mt76_connac_power_save_sched(&dev->mt76.phy, pm);
 }
 
 void mt7921_reset(struct mt76_dev *mdev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 67dc4b4cc094..ef3e454862ad 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1288,17 +1288,12 @@ int mt7921_mcu_sta_add(struct mt7921_dev *dev, struct ieee80211_sta *sta,
 	return mt76_connac_mcu_add_sta_cmd(&dev->mphy, &info);
 }
 
-int mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev)
+int __mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev)
 {
 	struct mt76_phy *mphy = &dev->mt76.phy;
 	struct mt76_connac_pm *pm = &dev->pm;
 	int i, err = 0;
 
-	mutex_lock(&pm->mutex);
-
-	if (!test_bit(MT76_STATE_PM, &mphy->state))
-		goto out;
-
 	for (i = 0; i < MT7921_DRV_OWN_RETRY_COUNT; i++) {
 		mt76_wr(dev, MT_CONN_ON_LPCTL, PCIE_LPCR_HOST_CLR_OWN);
 		if (mt76_poll_msec(dev, MT_CONN_ON_LPCTL,
@@ -1318,6 +1313,22 @@ int mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev)
 	pm->stats.last_wake_event = jiffies;
 	pm->stats.doze_time += pm->stats.last_wake_event -
 			       pm->stats.last_doze_event;
+out:
+	return err;
+}
+
+int mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev)
+{
+	struct mt76_phy *mphy = &dev->mt76.phy;
+	struct mt76_connac_pm *pm = &dev->pm;
+	int err = 0;
+
+	mutex_lock(&pm->mutex);
+
+	if (!test_bit(MT76_STATE_PM, &mphy->state))
+		goto out;
+
+	err = __mt7921_mcu_drv_pmctrl(dev);
 out:
 	mutex_unlock(&pm->mutex);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 59862ea4951c..03bcb210c357 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -368,6 +368,7 @@ int mt7921_mcu_uni_bss_bcnft(struct mt7921_dev *dev, struct ieee80211_vif *vif,
 			     bool enable);
 int mt7921_mcu_set_bss_pm(struct mt7921_dev *dev, struct ieee80211_vif *vif,
 			  bool enable);
+int __mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev);
 int mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev);
 int mt7921_mcu_fw_pmctrl(struct mt7921_dev *dev);
 void mt7921_pm_wake_work(struct work_struct *work);
-- 
2.30.2

