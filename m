Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E91538451
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 17:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241207AbiE3Ooa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233303AbiE3Omy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:42:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A10714ACB7
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 06:55:20 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nvfrO-0007UV-PT; Mon, 30 May 2022 15:55:07 +0200
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1nvfrO-005SmC-GO; Mon, 30 May 2022 15:55:05 +0200
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1nvfrL-004dIQ-Fc; Mon, 30 May 2022 15:55:03 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v2 02/10] rtw88: Drop rf_lock
Date:   Mon, 30 May 2022 15:54:49 +0200
Message-Id: <20220530135457.1104091-3-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220530135457.1104091-1-s.hauer@pengutronix.de>
References: <20220530135457.1104091-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
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
---
 drivers/net/wireless/realtek/rtw88/debug.c | 11 +++++++++++
 drivers/net/wireless/realtek/rtw88/hci.h   |  9 +++------
 drivers/net/wireless/realtek/rtw88/main.c  |  1 -
 drivers/net/wireless/realtek/rtw88/main.h  |  3 ---
 4 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index 1a52ff585fbc7..ba5ba852efb8c 100644
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
@@ -418,7 +420,9 @@ static ssize_t rtw_debugfs_set_rf_write(struct file *filp,
 		return count;
 	}
 
+	mutex_lock(&rtwdev->mutex);
 	rtw_write_rf(rtwdev, path, addr, mask, val);
+	mutex_unlock(&rtwdev->mutex);
 	rtw_dbg(rtwdev, RTW_DBG_DEBUGFS,
 		"write_rf path:%d addr:0x%08x mask:0x%08x, val:0x%08x\n",
 		path, addr, mask, val);
@@ -523,6 +527,8 @@ static int rtw_debug_get_rf_dump(struct seq_file *m, void *v)
 	u32 addr, offset, data;
 	u8 path;
 
+	mutex_lock(&rtwdev->mutex);
+
 	for (path = 0; path < rtwdev->hal.rf_path_num; path++) {
 		seq_printf(m, "RF path:%d\n", path);
 		for (addr = 0; addr < 0x100; addr += 4) {
@@ -537,6 +543,8 @@ static int rtw_debug_get_rf_dump(struct seq_file *m, void *v)
 		seq_puts(m, "\n");
 	}
 
+	mutex_unlock(&rtwdev->mutex);
+
 	return 0;
 }
 
@@ -1027,6 +1035,8 @@ static void dump_gapk_status(struct rtw_dev *rtwdev, struct seq_file *m)
 		   dm_info->dm_flags & BIT(RTW_DM_CAP_TXGAPK) ? '-' : '+',
 		   rtw_dm_cap_strs[RTW_DM_CAP_TXGAPK]);
 
+	mutex_lock(&rtwdev->mutex);
+
 	for (path = 0; path < rtwdev->hal.rf_path_num; path++) {
 		val = rtw_read_rf(rtwdev, path, RF_GAINTX, RFREG_MASK);
 		seq_printf(m, "path %d:\n0x%x = 0x%x\n", path, RF_GAINTX, val);
@@ -1036,6 +1046,7 @@ static void dump_gapk_status(struct rtw_dev *rtwdev, struct seq_file *m)
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
index 8b9899e41b0bb..f9864840ffd9c 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1994,7 +1994,6 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 	skb_queue_head_init(&rtwdev->coex.queue);
 	skb_queue_head_init(&rtwdev->tx_report.queue);
 
-	spin_lock_init(&rtwdev->rf_lock);
 	spin_lock_init(&rtwdev->h2c.lock);
 	spin_lock_init(&rtwdev->txq_lock);
 	spin_lock_init(&rtwdev->tx_report.q_lock);
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index 17815af9dd4ea..df6c6032bbd3b 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -1994,9 +1994,6 @@ struct rtw_dev {
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

