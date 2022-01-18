Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BB249161B
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245237AbiARCcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345167AbiARCbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:31:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F188C0698C2;
        Mon, 17 Jan 2022 18:28:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1FFE611A1;
        Tue, 18 Jan 2022 02:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A379C36AF2;
        Tue, 18 Jan 2022 02:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472904;
        bh=0NPR2GEkXmlKshR2DCdw5F1yXLjr3XEZ5JAnE8LMcEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELiUtDHw6ybHgJ3le1sY7fiqiaZQKBgIW5D4y8MmB1esc1y1K9etTQJElEdBEVbqb
         bPQFZ4g5aT66iU2o3/pZnJOE3ubyXNPA1O2/HA9O4Mubvp6SPQERsQk/2F7dGw0GHT
         G7nlpwobTz8hsKjuSaUctBHTGIsLJSn5vV6Lb1rsOnhULPjt4s6rfg1DpVk9epvsVY
         /5ppbGj4wOHjb0lcu1RlCTWprrBL2JHusIdjblJRuKTaFQnou58eMkWbkcVgpEN+Hk
         23c2tX/+Ggc3IaVS5h/JBJ9cKEFIug7GLjO6ekj7KkgbmBoqse7IUOiZzGzXAJwVHu
         ACe1fpHdaeHMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot <syzbot+4d2d56175b934b9a7bf9@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, ath9k-devel@qca.qualcomm.com,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 158/217] ath9k_htc: fix NULL pointer dereference at ath9k_htc_rxep()
Date:   Mon, 17 Jan 2022 21:18:41 -0500
Message-Id: <20220118021940.1942199-158-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

[ Upstream commit b0ec7e55fce65f125bd1d7f02e2dc4de62abee34 ]

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
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/2b88f416-b2cb-7a18-d688-951e6dc3fe92@i-love.sakura.ne.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc.h          | 1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 0a1634238e673..4f71e962279af 100644
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
index 8e69e8989f6d3..e7a21eaf3a68d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1130,6 +1130,10 @@ void ath9k_htc_rxep(void *drv_priv, struct sk_buff *skb,
 	struct ath9k_htc_rxbuf *rxbuf = NULL, *tmp_buf = NULL;
 	unsigned long flags;
 
+	/* Check if ath9k_rx_init() completed. */
+	if (!data_race(priv->rx.initialized))
+		goto err;
+
 	spin_lock_irqsave(&priv->rx.rxbuflock, flags);
 	list_for_each_entry(tmp_buf, &priv->rx.rxbuf, list) {
 		if (!tmp_buf->in_process) {
@@ -1185,6 +1189,10 @@ int ath9k_rx_init(struct ath9k_htc_priv *priv)
 		list_add_tail(&rxbuf->list, &priv->rx.rxbuf);
 	}
 
+	/* Allow ath9k_htc_rxep() to operate. */
+	smp_wmb();
+	priv->rx.initialized = true;
+
 	return 0;
 
 err:
-- 
2.34.1

