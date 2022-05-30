Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44CE5383E1
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 17:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241184AbiE3Oo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242814AbiE3Omv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:42:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5B714AC86
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 06:55:20 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nvfrO-0007Ui-PS; Mon, 30 May 2022 15:55:06 +0200
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1nvfrO-005SmL-P9; Mon, 30 May 2022 15:55:05 +0200
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1nvfrL-004dIT-GN; Mon, 30 May 2022 15:55:03 +0200
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
Subject: [PATCH v2 03/10] rtw88: Drop h2c.lock
Date:   Mon, 30 May 2022 15:54:50 +0200
Message-Id: <20220530135457.1104091-4-s.hauer@pengutronix.de>
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

The h2c.lock spinlock is used in rtw_fw_send_h2c_command() and
rtw_fw_send_h2c_packet().  Most callers call this with rtwdev->mutex
held, except from one callsite in the debugfs code. The debugfs code
alone doesn't justify the extra lock, so acquire rtwdev->mutex in
debugfs and drop the now unnecessary spinlock.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/net/wireless/realtek/rtw88/debug.c |  2 ++
 drivers/net/wireless/realtek/rtw88/fw.c    | 13 ++++---------
 drivers/net/wireless/realtek/rtw88/main.c  |  1 -
 drivers/net/wireless/realtek/rtw88/main.h  |  2 --
 4 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index ba5ba852efb8c..79939aa6b752c 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -396,7 +396,9 @@ static ssize_t rtw_debugfs_set_h2c(struct file *filp,
 		return -EINVAL;
 	}
 
+	mutex_lock(&rtwdev->mutex);
 	rtw_fw_h2c_cmd_dbg(rtwdev, param);
+	mutex_unlock(&rtwdev->mutex);
 
 	return count;
 }
diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index aa2aeb5fb2ccd..c3ad2a1b47212 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -320,7 +320,7 @@ static void rtw_fw_send_h2c_command(struct rtw_dev *rtwdev,
 		h2c[3], h2c[2], h2c[1], h2c[0],
 		h2c[7], h2c[6], h2c[5], h2c[4]);
 
-	spin_lock(&rtwdev->h2c.lock);
+	lockdep_assert_held(&rtwdev->mutex);
 
 	box = rtwdev->h2c.last_box_num;
 	switch (box) {
@@ -342,7 +342,7 @@ static void rtw_fw_send_h2c_command(struct rtw_dev *rtwdev,
 		break;
 	default:
 		WARN(1, "invalid h2c mail box number\n");
-		goto out;
+		return;
 	}
 
 	ret = read_poll_timeout_atomic(rtw_read8, box_state,
@@ -351,7 +351,7 @@ static void rtw_fw_send_h2c_command(struct rtw_dev *rtwdev,
 
 	if (ret) {
 		rtw_err(rtwdev, "failed to send h2c command\n");
-		goto out;
+		return;
 	}
 
 	for (idx = 0; idx < 4; idx++)
@@ -361,9 +361,6 @@ static void rtw_fw_send_h2c_command(struct rtw_dev *rtwdev,
 
 	if (++rtwdev->h2c.last_box_num >= 4)
 		rtwdev->h2c.last_box_num = 0;
-
-out:
-	spin_unlock(&rtwdev->h2c.lock);
 }
 
 void rtw_fw_h2c_cmd_dbg(struct rtw_dev *rtwdev, u8 *h2c)
@@ -375,15 +372,13 @@ static void rtw_fw_send_h2c_packet(struct rtw_dev *rtwdev, u8 *h2c_pkt)
 {
 	int ret;
 
-	spin_lock(&rtwdev->h2c.lock);
+	lockdep_assert_held(&rtwdev->mutex);
 
 	FW_OFFLOAD_H2C_SET_SEQ_NUM(h2c_pkt, rtwdev->h2c.seq);
 	ret = rtw_hci_write_data_h2c(rtwdev, h2c_pkt, H2C_PKT_SIZE);
 	if (ret)
 		rtw_err(rtwdev, "failed to send h2c packet\n");
 	rtwdev->h2c.seq++;
-
-	spin_unlock(&rtwdev->h2c.lock);
 }
 
 void
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index f9864840ffd9c..baf4d29fde678 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1994,7 +1994,6 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 	skb_queue_head_init(&rtwdev->coex.queue);
 	skb_queue_head_init(&rtwdev->tx_report.queue);
 
-	spin_lock_init(&rtwdev->h2c.lock);
 	spin_lock_init(&rtwdev->txq_lock);
 	spin_lock_init(&rtwdev->tx_report.q_lock);
 
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index df6c6032bbd3b..619ee6e8d2807 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -2018,8 +2018,6 @@ struct rtw_dev {
 	struct {
 		/* incicate the mail box to use with fw */
 		u8 last_box_num;
-		/* protect to send h2c to fw */
-		spinlock_t lock;
 		u32 seq;
 	} h2c;
 
-- 
2.30.2

