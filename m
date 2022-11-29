Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C24263BD86
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 11:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbiK2KIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 05:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiK2KIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 05:08:09 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A859F140C8
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 02:08:08 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1ozxX1-0006y7-NI; Tue, 29 Nov 2022 11:08:03 +0100
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1ozxWy-0012hr-8Z; Tue, 29 Nov 2022 11:08:01 +0100
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1ozxWx-00BYGu-DQ; Tue, 29 Nov 2022 11:07:59 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v4 03/11] wifi: rtw88: Drop rf_lock
Date:   Tue, 29 Nov 2022 11:07:46 +0100
Message-Id: <20221129100754.2753237-4-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221129100754.2753237-1-s.hauer@pengutronix.de>
References: <20221129100754.2753237-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rtwdev->rf_lock spinlock protects the rf register accesses in
rtw_read_rf() and rtw_write_rf(). Most callers of these functions hold
rtwdev->mutex already with the exception of the callsites in the debugfs
code. The debugfs code doesn't justify an extra lock, so acquire the mutex
there as well before calling rf register accessors and drop the now
unnecessary spinlock.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 11 +++++++++++
 drivers/net/wireless/realtek/rtw88/hci.h   |  9 +++------
 drivers/net/wireless/realtek/rtw88/main.c  |  1 -
 drivers/net/wireless/realtek/rtw88/main.h  |  3 ---
 4 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index 9ebe544e51d0d..70e19f2a1a355 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -144,7 +144,9 @@ static int rtw_debugfs_get_rf_read(struct seq_file *m, void *v)
 	addr = debugfs_priv->rf_addr;
 	mask = debugfs_priv->rf_mask;
 
+	mutex_lock(&rtwdev->mutex);
 	val = rtw_read_rf(rtwdev, path, addr, mask);
+	mutex_unlock(&rtwdev->mutex);
 
 	seq_printf(m, "rf_read path:%d addr:0x%08x mask:0x%08x val=0x%08x\n",
 		   path, addr, mask, val);
@@ -414,7 +416,9 @@ static ssize_t rtw_debugfs_set_rf_write(struct file *filp,
 		return count;
 	}
 
+	mutex_lock(&rtwdev->mutex);
 	rtw_write_rf(rtwdev, path, addr, mask, val);
+	mutex_unlock(&rtwdev->mutex);
 	rtw_dbg(rtwdev, RTW_DBG_DEBUGFS,
 		"write_rf path:%d addr:0x%08x mask:0x%08x, val:0x%08x\n",
 		path, addr, mask, val);
@@ -519,6 +523,8 @@ static int rtw_debug_get_rf_dump(struct seq_file *m, void *v)
 	u32 addr, offset, data;
 	u8 path;
 
+	mutex_lock(&rtwdev->mutex);
+
 	for (path = 0; path < rtwdev->hal.rf_path_num; path++) {
 		seq_printf(m, "RF path:%d\n", path);
 		for (addr = 0; addr < 0x100; addr += 4) {
@@ -533,6 +539,8 @@ static int rtw_debug_get_rf_dump(struct seq_file *m, void *v)
 		seq_puts(m, "\n");
 	}
 
+	mutex_unlock(&rtwdev->mutex);
+
 	return 0;
 }
 
@@ -1026,6 +1034,8 @@ static void dump_gapk_status(struct rtw_dev *rtwdev, struct seq_file *m)
 		   dm_info->dm_flags & BIT(RTW_DM_CAP_TXGAPK) ? '-' : '+',
 		   rtw_dm_cap_strs[RTW_DM_CAP_TXGAPK]);
 
+	mutex_lock(&rtwdev->mutex);
+
 	for (path = 0; path < rtwdev->hal.rf_path_num; path++) {
 		val = rtw_read_rf(rtwdev, path, RF_GAINTX, RFREG_MASK);
 		seq_printf(m, "path %d:\n0x%x = 0x%x\n", path, RF_GAINTX, val);
@@ -1035,6 +1045,7 @@ static void dump_gapk_status(struct rtw_dev *rtwdev, struct seq_file *m)
 				   txgapk->rf3f_fs[path][i], i);
 		seq_puts(m, "\n");
 	}
+	mutex_unlock(&rtwdev->mutex);
 }
 
 static int rtw_debugfs_get_dm_cap(struct seq_file *m, void *v)
diff --git a/drivers/net/wireless/realtek/rtw88/hci.h b/drivers/net/wireless/realtek/rtw88/hci.h
index 4c6fc6fb3f83b..830d7532f2a35 100644
--- a/drivers/net/wireless/realtek/rtw88/hci.h
+++ b/drivers/net/wireless/realtek/rtw88/hci.h
@@ -166,12 +166,11 @@ static inline u32
 rtw_read_rf(struct rtw_dev *rtwdev, enum rtw_rf_path rf_path,
 	    u32 addr, u32 mask)
 {
-	unsigned long flags;
 	u32 val;
 
-	spin_lock_irqsave(&rtwdev->rf_lock, flags);
+	lockdep_assert_held(&rtwdev->mutex);
+
 	val = rtwdev->chip->ops->read_rf(rtwdev, rf_path, addr, mask);
-	spin_unlock_irqrestore(&rtwdev->rf_lock, flags);
 
 	return val;
 }
@@ -180,11 +179,9 @@ static inline void
 rtw_write_rf(struct rtw_dev *rtwdev, enum rtw_rf_path rf_path,
 	     u32 addr, u32 mask, u32 data)
 {
-	unsigned long flags;
+	lockdep_assert_held(&rtwdev->mutex);
 
-	spin_lock_irqsave(&rtwdev->rf_lock, flags);
 	rtwdev->chip->ops->write_rf(rtwdev, rf_path, addr, mask, data);
-	spin_unlock_irqrestore(&rtwdev->rf_lock, flags);
 }
 
 static inline u32
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index a7331872e8530..710ddb0283c82 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -2067,7 +2067,6 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 	skb_queue_head_init(&rtwdev->coex.queue);
 	skb_queue_head_init(&rtwdev->tx_report.queue);
 
-	spin_lock_init(&rtwdev->rf_lock);
 	spin_lock_init(&rtwdev->h2c.lock);
 	spin_lock_init(&rtwdev->txq_lock);
 	spin_lock_init(&rtwdev->tx_report.q_lock);
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index 6e5875f6d07f4..f24d17f482aaa 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -1995,9 +1995,6 @@ struct rtw_dev {
 	/* ensures exclusive access from mac80211 callbacks */
 	struct mutex mutex;
 
-	/* read/write rf register */
-	spinlock_t rf_lock;
-
 	/* watch dog every 2 sec */
 	struct delayed_work watch_dog_work;
 	u32 watch_dog_cnt;
-- 
2.30.2

