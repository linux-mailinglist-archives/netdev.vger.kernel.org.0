Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD44E291C3D
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731547AbgJRTgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:36:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731583AbgJRT0K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:26:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A1C3222E9;
        Sun, 18 Oct 2020 19:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049170;
        bh=J1/LT1/AKi8I1u0pP++kL0Kx/j8NXcq4ktyZEqhNL98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RppdkjJyEUQGPkc72VQhSRcvHpoV3XcywmxDmfyZM0VnQsEUZ8be5td5krZRw1lAZ
         8nqQUaTo2743q9cTzBMzfzfutSUdDrVfr6OS+ru4eWsh2PwQwXvmTeftl6NuqqHhjN
         QKO0W9+DA4/EAy4/bqHG2zgdeOxqpdrMQuevauik=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brooke Basile <brookebasile@gmail.com>,
        syzbot+89bd486af9427a9fc605@syzkaller.appspotmail.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 33/52] ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill_anchored_urbs()
Date:   Sun, 18 Oct 2020 15:25:10 -0400
Message-Id: <20201018192530.4055730-33-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192530.4055730-1-sashal@kernel.org>
References: <20201018192530.4055730-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brooke Basile <brookebasile@gmail.com>

[ Upstream commit 03fb92a432ea5abe5909bca1455b7e44a9380480 ]

Calls to usb_kill_anchored_urbs() after usb_kill_urb() on multiprocessor
systems create a race condition in which usb_kill_anchored_urbs() deallocates
the URB before the completer callback is called in usb_kill_urb(), resulting
in a use-after-free.
To fix this, add proper lock protection to usb_kill_urb() calls that can
possibly run concurrently with usb_kill_anchored_urbs().

Reported-by: syzbot+89bd486af9427a9fc605@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=cabffad18eb74197f84871802fd2c5117b61febf
Signed-off-by: Brooke Basile <brookebasile@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200911071427.32354-1-brookebasile@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index e80d509bc5415..ce3a785212740 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -447,10 +447,19 @@ static void hif_usb_stop(void *hif_handle)
 	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 
 	/* The pending URBs have to be canceled. */
+	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 	list_for_each_entry_safe(tx_buf, tx_buf_tmp,
 				 &hif_dev->tx.tx_pending, list) {
+		usb_get_urb(tx_buf->urb);
+		spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 		usb_kill_urb(tx_buf->urb);
+		list_del(&tx_buf->list);
+		usb_free_urb(tx_buf->urb);
+		kfree(tx_buf->buf);
+		kfree(tx_buf);
+		spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 	}
+	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 
 	usb_kill_anchored_urbs(&hif_dev->mgmt_submitted);
 }
@@ -760,27 +769,37 @@ static void ath9k_hif_usb_dealloc_tx_urbs(struct hif_device_usb *hif_dev)
 	struct tx_buf *tx_buf = NULL, *tx_buf_tmp = NULL;
 	unsigned long flags;
 
+	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 	list_for_each_entry_safe(tx_buf, tx_buf_tmp,
 				 &hif_dev->tx.tx_buf, list) {
+		usb_get_urb(tx_buf->urb);
+		spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 		usb_kill_urb(tx_buf->urb);
 		list_del(&tx_buf->list);
 		usb_free_urb(tx_buf->urb);
 		kfree(tx_buf->buf);
 		kfree(tx_buf);
+		spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 	}
+	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 
 	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 	hif_dev->tx.flags |= HIF_USB_TX_FLUSH;
 	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 
+	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 	list_for_each_entry_safe(tx_buf, tx_buf_tmp,
 				 &hif_dev->tx.tx_pending, list) {
+		usb_get_urb(tx_buf->urb);
+		spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 		usb_kill_urb(tx_buf->urb);
 		list_del(&tx_buf->list);
 		usb_free_urb(tx_buf->urb);
 		kfree(tx_buf->buf);
 		kfree(tx_buf);
+		spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 	}
+	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 
 	usb_kill_anchored_urbs(&hif_dev->mgmt_submitted);
 }
-- 
2.25.1

