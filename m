Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B591949177B
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344586AbiARCl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:41:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47766 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345018AbiARCiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:38:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D07ECB811CF;
        Tue, 18 Jan 2022 02:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4805CC36AF4;
        Tue, 18 Jan 2022 02:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473490;
        bh=0NPR2GEkXmlKshR2DCdw5F1yXLjr3XEZ5JAnE8LMcEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBTl1mvLXt1gyrXFUR8uttyUpY5PZW7wNLpjjrbeFezDsNkwoiCMFiYb638Ja2FSU
         CyJfNd8ygxyfZQh76GMkfzyhgHAzYqLpIuN0ThSacDCsneo1F/ZYJOif/2ZH0VS5Ys
         5G8526zB2VJFpWot71oPGTzQM4OJeDPqclLGJcxYuwBHlFhvFGoKHEP7+4uvz5kLJg
         7KV8sLF5SK/8f0GxYBnqsx1HViENsjlZ+4fpVcn0AEogmRNLbyvQ02mrQ9m2xG343e
         rh+FPTgm8LSOTkaH69SldSqSm03mYuEinQBNNyRw+pUVxVbfboqO17rIq1MPhTdQUT
         pH3EBUV3AFHzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot <syzbot+4d2d56175b934b9a7bf9@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, ath9k-devel@qca.qualcomm.com,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 133/188] ath9k_htc: fix NULL pointer dereference at ath9k_htc_rxep()
Date:   Mon, 17 Jan 2022 21:30:57 -0500
Message-Id: <20220118023152.1948105-133-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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

