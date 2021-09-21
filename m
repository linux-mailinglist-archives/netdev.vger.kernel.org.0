Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84014133BC
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 15:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbhIUNIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 09:08:10 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64959 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbhIUNIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 09:08:07 -0400
Received: from fsav415.sakura.ne.jp (fsav415.sakura.ne.jp [133.242.250.114])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 18LD6Rk8084339;
        Tue, 21 Sep 2021 22:06:27 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav415.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav415.sakura.ne.jp);
 Tue, 21 Sep 2021 22:06:27 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav415.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 18LD6Qoo084332
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 21 Sep 2021 22:06:27 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: [PATCH 1/2 (RESEND)] ath9k_htc: fix NULL pointer dereference at
 ath9k_htc_rxep()
Message-ID: <2b88f416-b2cb-7a18-d688-951e6dc3fe92@i-love.sakura.ne.jp>
Date:   Tue, 21 Sep 2021 22:06:23 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot is reporting lockdep warning followed by kernel panic at
ath9k_htc_rxep() [1], for ath9k_htc_rxep() depends on ath9k_rx_init()
being already completed.

Since ath9k_htc_rxep() is set by ath9k_htc_connect_svc(WMI_BEACON_SVC)
 from ath9k_init_htc_services(), it is possible that ath9k_htc_rxep() is
called via timer interrupt before ath9k_rx_init() from ath9k_init_device()
is called.

Since we can't call ath9k_init_device() before ath9k_init_htc_services(),
let's hold ath9k_htc_rxep() no-op until ath9k_rx_init() completes.

Link: https://syzkaller.appspot.com/bug?extid=4d2d56175b934b9a7bf9 [1]
Reported-by: syzbot <syzbot+4d2d56175b934b9a7bf9@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+4d2d56175b934b9a7bf9@syzkaller.appspotmail.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          | 1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 0a1634238e67..4f71e962279a 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -281,6 +281,7 @@ struct ath9k_htc_rxbuf {
 struct ath9k_htc_rx {
 	struct list_head rxbuf;
 	spinlock_t rxbuflock;
+	bool initialized;
 };
 
 #define ATH9K_HTC_TX_CLEANUP_INTERVAL 50 /* ms */
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 8e69e8989f6d..0d4595ee51ba 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1130,6 +1130,9 @@ void ath9k_htc_rxep(void *drv_priv, struct sk_buff *skb,
 	struct ath9k_htc_rxbuf *rxbuf = NULL, *tmp_buf = NULL;
 	unsigned long flags;
 
+	/* Check if ath9k_rx_init() completed. */
+	if (!data_race(priv->rx.initialized))
+		goto err;
 	spin_lock_irqsave(&priv->rx.rxbuflock, flags);
 	list_for_each_entry(tmp_buf, &priv->rx.rxbuf, list) {
 		if (!tmp_buf->in_process) {
@@ -1185,6 +1188,9 @@ int ath9k_rx_init(struct ath9k_htc_priv *priv)
 		list_add_tail(&rxbuf->list, &priv->rx.rxbuf);
 	}
 
+	/* Allow ath9k_htc_rxep() to operate. */
+	smp_wmb();
+	priv->rx.initialized = true;
 	return 0;
 
 err:
-- 
2.18.4
