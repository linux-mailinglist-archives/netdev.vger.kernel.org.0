Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FABD2D58F5
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 12:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733284AbgLJLKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 06:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733031AbgLJLJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 06:09:38 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F7EC0617A6
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 03:08:53 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id a3so4858201wmb.5
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 03:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ItgTeuucSKI7xOPb/cgLQD69gw3sQiixlB2VotUPk5g=;
        b=TEvsdZohROnaAdJ5/jhdwYd8eOhBsKhXm/k1RudoZ6tCL7rTmhURAa6S/9xJTKlS2E
         r1ef6LiJiH6th7SwvGo04yV1gkoAjezvYSu7Ntog80GInGG4owGdAjJ28686ROWIpJd1
         9YGmuUSZ4y23ykFLhj2pwW5aDkPyT99DSkwC/WxKyB+4T1ESOcJVgK0iaYTyT/Jw5rXT
         MYdFWE09TWdmI+pxjTGNlZC5hRbMbXI7IBA0A/PO8LEAN2f0gX6gSEUU02zq0nqy/tpu
         Ut/zZujKEOFizrynGx73NOqQ+hMI7i/yTtkxNqiWEMbV8S0DR1R1cbnjTdxJe4g2CtWD
         2/HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ItgTeuucSKI7xOPb/cgLQD69gw3sQiixlB2VotUPk5g=;
        b=hAZmvYZDB+K2VhPJaD2dVm0BpchDcK0KOQimcDvGHOkzq8dVSWjhymYNQQM6oAjqTN
         am9GCA0XrXuY6UGHyvfgWZDXUp3WQ96OPzRtogYo+FGDihmEREaxs2O8V8LmqnY0sKsS
         tSz++xwRv2BATYMBkmBfLCDWHhI0srCWz2x02amTqVEWwTwxxSNqPJQ9JNHqzy9/qjXF
         1Vx6ZM6416OMBxlldrfa88tBnzY1w63clYtdZIUoawnmyniCRlEKO9q7tTniEsJIJ6QI
         ciIG4nSnUWremVxT5johFwSS5K6+D5cN9yCv9LBXwiqRAZ7L4DFHsoHF+0sU6Zwm+BHw
         ET8w==
X-Gm-Message-State: AOAM530NXMZH6LtVVPw1khLohyKitOcyvua7W6QJpbM1I0WrppeYgU3C
        pH6kzL06ubBD8BqMMu6oCf/dSA==
X-Google-Smtp-Source: ABdhPJw8WjOOZgBLd6ZkveFOdwvNfNdsaML37vwAHz296xZNibxN1eti8URNh3s2lZNYttHsaDDbKw==
X-Received: by 2002:a1c:6856:: with SMTP id d83mr7855877wmc.119.1607598531933;
        Thu, 10 Dec 2020 03:08:51 -0800 (PST)
Received: from localhost.localdomain ([2a01:e0a:490:8730:4468:1cc2:be0c:233f])
        by smtp.gmail.com with ESMTPSA id n123sm8961809wmn.7.2020.12.10.03.08.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Dec 2020 03:08:51 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     manivannan.sadhasivam@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, jhugo@codeaurora.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH v2 3/3] net: mhi: Add dedicated alloc thread
Date:   Thu, 10 Dec 2020 12:15:51 +0100
Message-Id: <1607598951-2340-3-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607598951-2340-1-git-send-email-loic.poulain@linaro.org>
References: <1607598951-2340-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The buffer allocation for RX path is currently done by a work executed
in the system workqueue. The work to do is quite simple and consists
mostly in allocating and queueing as much as possible buffers to the MHI
RX channel.

It appears that using a dedicated kthread would be more appropriate to
prevent
1. RX allocation latency introduced by the system queue
2. Unbounded work execution, the work only returning when queue is
full, it can possibly monopolise the workqueue thread on slower systems.

This patch replaces the system work with a simple kthread that loops on
buffer allocation and sleeps when queue is full. Moreover it gets rid
of the local rx_queued variable (to track buffer count), and instead,
relies on the new mhi_get_free_desc_count helper.

After pratical testing on a x86_64 machine, this change improves
- Peek throughput (slightly, by few mbps)
- Throughput stability when concurrent loads are running (stress)
- CPU usage, less CPU cycles dedicated to the task

Below is the powertop output for RX allocation task before and after
this change, when performing UDP download at 6Gbps. Mostly to highlight
the improvement in term of CPU usage.

older (system workqueue):
Usage       Events/s    Category       Description
63,2 ms/s     134,0        kWork          mhi_net_rx_refill_work
62,8 ms/s     134,3        kWork          mhi_net_rx_refill_work
60,8 ms/s     141,4        kWork          mhi_net_rx_refill_work

newer (dedicated kthread):
Usage       Events/s    Category       Description
20,7 ms/s     155,6        Process        [PID 3360] [mhi-net-rx]
22,2 ms/s     169,6        Process        [PID 3360] [mhi-net-rx]
22,3 ms/s     150,2        Process        [PID 3360] [mhi-net-rx]

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: add module parameter for changing RX refill level

 drivers/net/mhi_net.c | 110 ++++++++++++++++++++++++++++----------------------
 1 file changed, 62 insertions(+), 48 deletions(-)

diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index 0333e07..bd66d51 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/if_arp.h>
+#include <linux/kthread.h>
 #include <linux/mhi.h>
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
@@ -16,6 +17,11 @@
 #define MHI_NET_MAX_MTU		0xffff
 #define MHI_NET_DEFAULT_MTU	0x4000
 
+static unsigned int rx_refill_level = 70;
+module_param(rx_refill_level, uint, 0600);
+MODULE_PARM_DESC(rx_refill_level,
+		 "The minimal RX queue level percentage (0 to 100) under which the RX queue must be refilled");
+
 struct mhi_net_stats {
 	u64_stats_t rx_packets;
 	u64_stats_t rx_bytes;
@@ -25,7 +31,6 @@ struct mhi_net_stats {
 	u64_stats_t tx_bytes;
 	u64_stats_t tx_errors;
 	u64_stats_t tx_dropped;
-	atomic_t rx_queued;
 	struct u64_stats_sync tx_syncp;
 	struct u64_stats_sync rx_syncp;
 };
@@ -33,17 +38,66 @@ struct mhi_net_stats {
 struct mhi_net_dev {
 	struct mhi_device *mdev;
 	struct net_device *ndev;
-	struct delayed_work rx_refill;
+	struct task_struct *refill_task;
+	wait_queue_head_t refill_wq;
 	struct mhi_net_stats stats;
 	u32 rx_queue_sz;
+	u32 rx_refill_level;
 };
 
+static int mhi_net_refill_thread(void *data)
+{
+	struct mhi_net_dev *mhi_netdev = data;
+	struct net_device *ndev = mhi_netdev->ndev;
+	struct mhi_device *mdev = mhi_netdev->mdev;
+	int size = READ_ONCE(ndev->mtu);
+	struct sk_buff *skb;
+	int err;
+
+	while (1) {
+		err = wait_event_interruptible(mhi_netdev->refill_wq,
+					       !mhi_queue_is_full(mdev, DMA_FROM_DEVICE)
+					       || kthread_should_stop());
+		if (err || kthread_should_stop())
+			break;
+
+		skb = netdev_alloc_skb(ndev, size);
+		if (unlikely(!skb)) {
+			/* No memory, retry later */
+			schedule_timeout_interruptible(msecs_to_jiffies(250));
+			continue;
+		}
+
+		err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb, size, MHI_EOT);
+		if (unlikely(err)) {
+			net_err_ratelimited("%s: Failed to queue RX buf (%d)\n",
+					    ndev->name, err);
+			kfree_skb(skb);
+			break;
+		}
+
+		/* Do not hog the CPU */
+		cond_resched();
+	}
+
+	return 0;
+}
+
 static int mhi_ndo_open(struct net_device *ndev)
 {
 	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+	unsigned int qsz = mhi_netdev->rx_queue_sz;
 
-	/* Feed the rx buffer pool */
-	schedule_delayed_work(&mhi_netdev->rx_refill, 0);
+	if (rx_refill_level >= 100)
+		mhi_netdev->rx_refill_level = 1;
+	else
+		mhi_netdev->rx_refill_level = qsz - qsz * rx_refill_level / 100;
+
+	mhi_netdev->refill_task = kthread_run(mhi_net_refill_thread, mhi_netdev,
+					      "mhi-net-rx");
+	if (IS_ERR(mhi_netdev->refill_task)) {
+		return PTR_ERR(mhi_netdev->refill_task);
+	}
 
 	/* Carrier is established via out-of-band channel (e.g. qmi) */
 	netif_carrier_on(ndev);
@@ -57,9 +111,9 @@ static int mhi_ndo_stop(struct net_device *ndev)
 {
 	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
 
+	kthread_stop(mhi_netdev->refill_task);
 	netif_stop_queue(ndev);
 	netif_carrier_off(ndev);
-	cancel_delayed_work_sync(&mhi_netdev->rx_refill);
 
 	return 0;
 }
@@ -138,9 +192,6 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 {
 	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
 	struct sk_buff *skb = mhi_res->buf_addr;
-	int remaining;
-
-	remaining = atomic_dec_return(&mhi_netdev->stats.rx_queued);
 
 	if (unlikely(mhi_res->transaction_status)) {
 		dev_kfree_skb_any(skb);
@@ -163,9 +214,8 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 		netif_rx(skb);
 	}
 
-	/* Refill if RX buffers queue becomes low */
-	if (remaining <= mhi_netdev->rx_queue_sz / 2)
-		schedule_delayed_work(&mhi_netdev->rx_refill, 0);
+	if (mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE) >= mhi_netdev->rx_refill_level)
+		wake_up_interruptible(&mhi_netdev->refill_wq);
 }
 
 static void mhi_net_ul_callback(struct mhi_device *mhi_dev,
@@ -200,42 +250,6 @@ static void mhi_net_ul_callback(struct mhi_device *mhi_dev,
 		netif_wake_queue(ndev);
 }
 
-static void mhi_net_rx_refill_work(struct work_struct *work)
-{
-	struct mhi_net_dev *mhi_netdev = container_of(work, struct mhi_net_dev,
-						      rx_refill.work);
-	struct net_device *ndev = mhi_netdev->ndev;
-	struct mhi_device *mdev = mhi_netdev->mdev;
-	int size = READ_ONCE(ndev->mtu);
-	struct sk_buff *skb;
-	int err;
-
-	while (atomic_read(&mhi_netdev->stats.rx_queued) < mhi_netdev->rx_queue_sz) {
-		skb = netdev_alloc_skb(ndev, size);
-		if (unlikely(!skb))
-			break;
-
-		err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb, size, MHI_EOT);
-		if (unlikely(err)) {
-			net_err_ratelimited("%s: Failed to queue RX buf (%d)\n",
-					    ndev->name, err);
-			kfree_skb(skb);
-			break;
-		}
-
-		atomic_inc(&mhi_netdev->stats.rx_queued);
-
-		/* Do not hog the CPU if rx buffers are consumed faster than
-		 * queued (unlikely).
-		 */
-		cond_resched();
-	}
-
-	/* If we're still starved of rx buffers, reschedule later */
-	if (unlikely(!atomic_read(&mhi_netdev->stats.rx_queued)))
-		schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);
-}
-
 static int mhi_net_probe(struct mhi_device *mhi_dev,
 			 const struct mhi_device_id *id)
 {
@@ -256,7 +270,7 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
 	mhi_netdev->mdev = mhi_dev;
 	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
 
-	INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
+	init_waitqueue_head(&mhi_netdev->refill_wq);
 	u64_stats_init(&mhi_netdev->stats.rx_syncp);
 	u64_stats_init(&mhi_netdev->stats.tx_syncp);
 
-- 
2.7.4

