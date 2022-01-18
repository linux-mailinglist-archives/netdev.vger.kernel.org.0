Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9207149162F
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345924AbiARCcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345172AbiARCbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:31:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B3FC07E5FA;
        Mon, 17 Jan 2022 18:28:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA83860AB1;
        Tue, 18 Jan 2022 02:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE72C36AF3;
        Tue, 18 Jan 2022 02:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472906;
        bh=XOsj6tMeo3byH1VXmZp4CqHcytz5W+S7VP6NCTNikdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BOXlXepRtnNGK0wOg0U3O5oLDzHiNuVzpW6LzuHVK/ovoH1W0Pk27CXs2Y/0EmuGD
         kz3LHv7zGfnJ/w2veMIpxJSA7JgNFGkT2kNzXT1fA2POLiIafdPvQLcLDf+rTCrwZS
         3wDAWqfWkJ6CAAw8fAvnfXGfOp6wTWhVqI/9Insy7d5ZCwnoclMUJPujE4DPw2lK3M
         6HhNWl7qVOjBMEaX3AIcFGb7YRpMSdZhOHLMY3YBkmJXUMUeaYlY4seQBsAdQRv/cK
         JzWwoDBk0A6cNo+Q7jMb/pfJNG4uZOFZYnzRfNZo6oWozoyRxSn8sVbz/QS17rzFjw
         diUww688x1Ltw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot <syzbot+31d54c60c5b254d6f75b@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, ath9k-devel@qca.qualcomm.com,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 159/217] ath9k_htc: fix NULL pointer dereference at ath9k_htc_tx_get_packet()
Date:   Mon, 17 Jan 2022 21:18:42 -0500
Message-Id: <20220118021940.1942199-159-sashal@kernel.org>
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

[ Upstream commit 8b3046abc99eefe11438090bcc4ec3a3994b55d0 ]

syzbot is reporting lockdep warning at ath9k_wmi_event_tasklet() followed
by kernel panic at get_htc_epid_queue() from ath9k_htc_tx_get_packet() from
ath9k_htc_txstatus() [1], for ath9k_wmi_event_tasklet(WMI_TXSTATUS_EVENTID)
depends on spin_lock_init() from ath9k_init_priv() being already completed.

Since ath9k_wmi_event_tasklet() is set by ath9k_init_wmi() from
ath9k_htc_probe_device(), it is possible that ath9k_wmi_event_tasklet() is
called via tasklet interrupt before spin_lock_init() from ath9k_init_priv()
 from ath9k_init_device() from ath9k_htc_probe_device() is called.

Let's hold ath9k_wmi_event_tasklet(WMI_TXSTATUS_EVENTID) no-op until
ath9k_tx_init() completes.

Link: https://syzkaller.appspot.com/bug?extid=31d54c60c5b254d6f75b [1]
Reported-by: syzbot <syzbot+31d54c60c5b254d6f75b@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+31d54c60c5b254d6f75b@syzkaller.appspotmail.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/77b76ac8-2bee-6444-d26c-8c30858b8daa@i-love.sakura.ne.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc.h          | 1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 5 +++++
 drivers/net/wireless/ath/ath9k/wmi.c          | 4 ++++
 3 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 4f71e962279af..6b45e63fae4ba 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -306,6 +306,7 @@ struct ath9k_htc_tx {
 	DECLARE_BITMAP(tx_slot, MAX_TX_BUF_NUM);
 	struct timer_list cleanup_timer;
 	spinlock_t tx_lock;
+	bool initialized;
 };
 
 struct ath9k_htc_tx_ctl {
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index e7a21eaf3a68d..6a850a0bfa8ad 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -813,6 +813,11 @@ int ath9k_tx_init(struct ath9k_htc_priv *priv)
 	skb_queue_head_init(&priv->tx.data_vi_queue);
 	skb_queue_head_init(&priv->tx.data_vo_queue);
 	skb_queue_head_init(&priv->tx.tx_failed);
+
+	/* Allow ath9k_wmi_event_tasklet(WMI_TXSTATUS_EVENTID) to operate. */
+	smp_wmb();
+	priv->tx.initialized = true;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index fe29ad4b9023c..f315c54bd3ac0 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -169,6 +169,10 @@ void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
 					     &wmi->drv_priv->fatal_work);
 			break;
 		case WMI_TXSTATUS_EVENTID:
+			/* Check if ath9k_tx_init() completed. */
+			if (!data_race(priv->tx.initialized))
+				break;
+
 			spin_lock_bh(&priv->tx.tx_lock);
 			if (priv->tx.flags & ATH9K_HTC_OP_TX_DRAIN) {
 				spin_unlock_bh(&priv->tx.tx_lock);
-- 
2.34.1

