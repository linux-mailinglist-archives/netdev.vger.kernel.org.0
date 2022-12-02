Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38E66401AC
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbiLBIMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbiLBIMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:12:39 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4450FF12
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:12:36 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1p119p-0005AT-Ti; Fri, 02 Dec 2022 09:12:29 +0100
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1p119o-001lGv-ES; Fri, 02 Dec 2022 09:12:29 +0100
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1p119m-00BfDm-Rg; Fri, 02 Dec 2022 09:12:26 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v5 05/11] wifi: rtw88: Drop coex mutex
Date:   Fri,  2 Dec 2022 09:12:18 +0100
Message-Id: <20221202081224.2779981-6-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221202081224.2779981-1-s.hauer@pengutronix.de>
References: <20221202081224.2779981-1-s.hauer@pengutronix.de>
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

coex->mutex is used in rtw_coex_info_request() only. Most callers of this
function hold rtwdev->mutex already, except for one callsite in the
debugfs code. The debugfs code alone doesn't justify the extra lock, so
acquire rtwdev->mutex there as well and drop the now unnecessary
spinlock.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/net/wireless/realtek/rtw88/coex.c  | 3 +--
 drivers/net/wireless/realtek/rtw88/debug.c | 2 ++
 drivers/net/wireless/realtek/rtw88/main.c  | 2 --
 drivers/net/wireless/realtek/rtw88/main.h  | 2 --
 4 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/coex.c b/drivers/net/wireless/realtek/rtw88/coex.c
index 6276ad6242991..38697237ee5f0 100644
--- a/drivers/net/wireless/realtek/rtw88/coex.c
+++ b/drivers/net/wireless/realtek/rtw88/coex.c
@@ -633,7 +633,7 @@ static struct sk_buff *rtw_coex_info_request(struct rtw_dev *rtwdev,
 	struct rtw_coex *coex = &rtwdev->coex;
 	struct sk_buff *skb_resp = NULL;
 
-	mutex_lock(&coex->mutex);
+	lockdep_assert_held(&rtwdev->mutex);
 
 	rtw_fw_query_bt_mp_info(rtwdev, req);
 
@@ -650,7 +650,6 @@ static struct sk_buff *rtw_coex_info_request(struct rtw_dev *rtwdev,
 	}
 
 out:
-	mutex_unlock(&coex->mutex);
 	return skb_resp;
 }
 
diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index f5b8a77ebc67b..fa3d73b333ba0 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -841,7 +841,9 @@ static int rtw_debugfs_get_coex_info(struct seq_file *m, void *v)
 	struct rtw_debugfs_priv *debugfs_priv = m->private;
 	struct rtw_dev *rtwdev = debugfs_priv->rtwdev;
 
+	mutex_lock(&rtwdev->mutex);
 	rtw_coex_display_coex_info(rtwdev, m);
+	mutex_unlock(&rtwdev->mutex);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index c98e56890401c..0a2ce7f50f412 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -2071,7 +2071,6 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 	spin_lock_init(&rtwdev->tx_report.q_lock);
 
 	mutex_init(&rtwdev->mutex);
-	mutex_init(&rtwdev->coex.mutex);
 	mutex_init(&rtwdev->hal.tx_power_mutex);
 
 	init_waitqueue_head(&rtwdev->coex.wait);
@@ -2143,7 +2142,6 @@ void rtw_core_deinit(struct rtw_dev *rtwdev)
 	}
 
 	mutex_destroy(&rtwdev->mutex);
-	mutex_destroy(&rtwdev->coex.mutex);
 	mutex_destroy(&rtwdev->hal.tx_power_mutex);
 }
 EXPORT_SYMBOL(rtw_core_deinit);
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index 4b57542bef1e9..77fd48b6cc453 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -1501,8 +1501,6 @@ struct rtw_coex_stat {
 };
 
 struct rtw_coex {
-	/* protects coex info request section */
-	struct mutex mutex;
 	struct sk_buff_head queue;
 	wait_queue_head_t wait;
 
-- 
2.30.2

