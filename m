Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86702F1D50
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390094AbhAKSAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389642AbhAKSAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 13:00:50 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B581CC0617A2
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 10:00:09 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id d26so658512wrb.12
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 10:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=o6VGoAvdQqK2Elm/WglYXBR1TIROqoxTQR1mS7lNbWE=;
        b=aLk7IIrYOoT9OrCVSPE3z2FFJ1Xk5rl6flPGwWw+SVoHZR9jZCqnS3nY2Bez/LTD7n
         AJDxaBpmCuGzCaat+TV9ATjpIOyHfTNHXTMHCmeFJofwk3QqOcV9eTrMoSLp9cwggKIa
         2Nts+5CNIgS+frKqiYBujR7DzUK7KjOJaF50LJFXzI//pb8eoFpPiT9fUD9C+ddjJ4nU
         /GWSqCicpYzywN1vYI+WgIw9L7WReZNmCgAIx94xjpZ29wmmww0PS+4l7hbLVAbbLnSP
         bxPEDhECF7QsbC8pmjCu4Ai7jwkV5ih5m8C4hQpVaBZzl8hEW1O/NyFB+lclPuiAhHMe
         LX0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=o6VGoAvdQqK2Elm/WglYXBR1TIROqoxTQR1mS7lNbWE=;
        b=a8gDBaFGqHgX+PDgZ0TSgTHkavExWieC7F8B78bJ++1qT59EC3cDlLoJ8rPcjM3r5q
         d6VMAgmbz317U9XAEUHv4zAZn/p3zm/hG4XnAjEWP3QCrj0Z0BT7IktkNCR+Fr8fBrOT
         F7+F9Jtj2pqFvtChdoMRALjfYNHcGrXwaX/qoS+CBxHYVG2LcWbOpQu3HkL7+nIyTfUy
         b4uWogf9qbqZBMFft2II7V5415hyQSyniZg9NE80cZcLf+wzQH5feIfSGehJFrExh/zZ
         7Ao2i8kjhrswByks8SJxJTU5HoUuQU5aAuM6mW1CnE+q8blNtgP0N/J0/s9vtbsZjv0Y
         2kJg==
X-Gm-Message-State: AOAM530MvTpNUG9WiM9mnww2rvAhnLcocl6oUyNTo0psuQerCEwFEX3U
        isDRhV8TIcZJy/pISS5QpJxzkA==
X-Google-Smtp-Source: ABdhPJzi2t0QSDqbMVVERhCWyviasFN3RzwpxZkNJ+UuNvy2xJa8gUxSK0qYABBBdRmrPdor0PMZ1w==
X-Received: by 2002:adf:e406:: with SMTP id g6mr291971wrm.255.1610388008461;
        Mon, 11 Jan 2021 10:00:08 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id s12sm77662wmh.29.2021.01.11.10.00.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 10:00:08 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        manivannan.sadhasivam@linaro.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next 3/3] net: mhi: Get rid of local rx queue count
Date:   Mon, 11 Jan 2021 19:07:42 +0100
Message-Id: <1610388462-16322-3-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1610388462-16322-1-git-send-email-loic.poulain@linaro.org>
References: <1610388462-16322-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new mhi_get_free_desc_count helper to track queue usage
instead of relying on the locally maintained rx_queued count.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/mhi_net.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index 3da820b..f83562d 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -25,7 +25,6 @@ struct mhi_net_stats {
 	u64_stats_t tx_bytes;
 	u64_stats_t tx_errors;
 	u64_stats_t tx_dropped;
-	atomic_t rx_queued;
 	struct u64_stats_sync tx_syncp;
 	struct u64_stats_sync rx_syncp;
 };
@@ -138,9 +137,9 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 {
 	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
 	struct sk_buff *skb = mhi_res->buf_addr;
-	int remaining;
+	int free_desc_count;
 
-	remaining = atomic_dec_return(&mhi_netdev->stats.rx_queued);
+	free_desc_count = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
 
 	if (unlikely(mhi_res->transaction_status)) {
 		dev_kfree_skb_any(skb);
@@ -164,7 +163,7 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 	}
 
 	/* Refill if RX buffers queue becomes low */
-	if (remaining <= mhi_netdev->rx_queue_sz / 2)
+	if (free_desc_count >= mhi_netdev->rx_queue_sz / 2)
 		schedule_delayed_work(&mhi_netdev->rx_refill, 0);
 }
 
@@ -211,7 +210,7 @@ static void mhi_net_rx_refill_work(struct work_struct *work)
 	struct sk_buff *skb;
 	int err;
 
-	while (atomic_read(&mhi_netdev->stats.rx_queued) < mhi_netdev->rx_queue_sz) {
+	while (!mhi_queue_is_full(mdev, DMA_FROM_DEVICE)) {
 		skb = netdev_alloc_skb(ndev, size);
 		if (unlikely(!skb))
 			break;
@@ -224,8 +223,6 @@ static void mhi_net_rx_refill_work(struct work_struct *work)
 			break;
 		}
 
-		atomic_inc(&mhi_netdev->stats.rx_queued);
-
 		/* Do not hog the CPU if rx buffers are consumed faster than
 		 * queued (unlikely).
 		 */
@@ -233,7 +230,7 @@ static void mhi_net_rx_refill_work(struct work_struct *work)
 	}
 
 	/* If we're still starved of rx buffers, reschedule later */
-	if (unlikely(!atomic_read(&mhi_netdev->stats.rx_queued)))
+	if (mhi_get_free_desc_count(mdev, DMA_FROM_DEVICE) == mhi_netdev->rx_queue_sz)
 		schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);
 }
 
-- 
2.7.4

