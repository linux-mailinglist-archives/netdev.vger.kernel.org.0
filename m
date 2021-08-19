Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885593F21EB
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 22:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235688AbhHSUwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 16:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbhHSUwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 16:52:40 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EA8C061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 13:52:03 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id n24so9431277ion.10
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 13:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1ziHY4EvXx+0bJZ0Qy1XP9FfuZgCSYZ/yaAXfLPrPV0=;
        b=Wbx6sSO9YjAWq/7mcoDMYfdP12/GYCo3RehiEDHvgnRf4uHaCj8oCnqBf2tDVjorSB
         Ll+KSuiPS8eb0WgLRB1dgSI2AMvOQKgH+BjdGatNPboVK0/IMP/2HPf5wRlBvQ6mpUOt
         9fFxdkz6kMf5R8BiWngk+xHtoofl/KQ+Cq/Ak9XExupABfzb4iBonl7N3bnaL3DTyv2w
         kDq40Z18SqytbDsZz+zzI8QH+kVt5YAFtsLpvkvJLHz2T3DCxZr/H+iNWNGOpPuruXH5
         Z0DTNAURpFX5fDR1zcJ/iGKaPreVFliG2Ks5nWjvOUsqcrn+wA2qDa6wqrZcSa2/IF62
         L0lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1ziHY4EvXx+0bJZ0Qy1XP9FfuZgCSYZ/yaAXfLPrPV0=;
        b=XC1XRibMjdCO15CSwjrqpGNSqjfKh8v42rfobv+jtl67Y1t24Evoba8FN52Va941k0
         CJjKq55LKjg5SSqmkSfq5WKpXHi2pyb8JETDTnPV/Iwj2Uq8HZ9Vyoa9wO/CdkmSPias
         9Es3cfjV2MkTEMYDRwsuIa/mUCoNQiKUrvK0vLHNbDEYv66foxqeitZ9OqhZE3WVLBcC
         t6vkgeiwQMUkVJMdXEawKBKizSZ3EZIgABH+C6wbP1DcE/gucDmixP7RX/pfMBdok5sO
         y6K5GuhOetqpR8G7Yr1SjlROaMy7V4WJafxAjNXd5XZpf8P2T358luZVdjTyf7r5RlTI
         yxXg==
X-Gm-Message-State: AOAM531HiskbK0ML+DSj/jMQoAstjvusCqouBpicuhpY3IxoLMhyeI+T
        0h3AXdKwqkZlI0ib5Hsxq8qExvDiYQvBN8l7
X-Google-Smtp-Source: ABdhPJy1vmQ0ztCHIH+v7BsWnn2o/qZIW/3rV5kNnRpAJFxXM6BbqFROes4qbCa+/5eQ6Xn/2aR4jQ==
X-Received: by 2002:a05:6638:3b0:: with SMTP id z16mr14313306jap.139.1629406323214;
        Thu, 19 Aug 2021 13:52:03 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n7sm2164152ioz.18.2021.08.19.13.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 13:52:02 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: ipa: fix TX queue race
Date:   Thu, 19 Aug 2021 15:51:59 -0500
Message-Id: <20210819205159.3148951-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski pointed out a race condition in ipa_start_xmit() in a
recently-accepted series of patches:
  https://lore.kernel.org/netdev/20210812195035.2816276-1-elder@linaro.org/
We are stopping the modem TX queue in that function if the power
state is not active.  We restart the TX queue again once hardware
resume is complete.

  TX path                       Power Management
  -------                       ----------------
  pm_runtime_get(); no power    Start resume
  Stop TX queue                      ...
  pm_runtime_put()              Resume complete
  return NETDEV_TX_BUSY         Start TX queue

  pm_runtime_get()
  Power present, transmit
  pm_runtime_put()              (auto-suspend)

The issue is that the power management (resume) activity and the
network transmit activity can occur concurrently, and there's a
chance the queue will be stopped *after* it has been started again.

  TX path                       Power Management
  -------                       ----------------
                                Resume underway
  pm_runtime_get(); no power         ...
                                Resume complete
                                Start TX queue
  Stop TX queue       <-- No more transmits after this
  pm_runtime_put()
  return NETDEV_TX_BUSY

We address this using a STARTED flag to indicate when the TX queue
has been started from the resume path, and a spinlock to make the
flag and queue updates happen atomically.

  TX path                       Power Management
  -------                       ----------------
                                Resume underway
  pm_runtime_get(); no power    Resume complete
                                start TX queue     \
  If STARTED flag is *not* set:                     > atomic
      Stop TX queue             set STARTED flag   /
  pm_runtime_put()
  return NETDEV_TX_BUSY

A second flag is used to address a different race that involves
another path requesting power.

  TX path            Other path              Power Management
  -------            ----------              ----------------
                     pm_runtime_get_sync()   Resume
                                             Start TX queue   \ atomic
                                             Set STARTED flag /
                     (do its thing)
                     pm_runtime_put()
                                             (auto-suspend)
  pm_runtime_get()                           Mark delayed resume
  STARTED *is* set, so
    do *not* stop TX queue  <-- Queue should be stopped here
  pm_runtime_put()
  return NETDEV_TX_BUSY                      Suspend done, resume
                                             Resume complete
  pm_runtime_get()
  Stop TX queue
    (STARTED is *not* set)                   Start TX queue   \ atomic
  pm_runtime_put()                           Set STARTED flag /
  return NETDEV_TX_BUSY

So a STOPPED flag is set in the transmit path when it has stopped
the TX queue, and this pair of operations is also protected by the
spinlock.  The resume path only restarts the TX queue if the STOPPED
flag is set.  This case isn't a major problem, but it avoids the
"non-trivial amount of useless work" done by the networking stack
when NETDEV_TX_BUSY is returned.

Fixes: 6b51f802d652b ("net: ipa: ensure hardware has power in ipa_start_xmit()")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c | 70 +++++++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_clock.h | 18 ++++++++++
 drivers/net/ipa/ipa_modem.c |  7 ++--
 3 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index 8f25107c1f1e7..ed7ef72fbb78a 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -48,11 +48,15 @@ struct ipa_interconnect {
  * enum ipa_power_flag - IPA power flags
  * @IPA_POWER_FLAG_RESUMED:	Whether resume from suspend has been signaled
  * @IPA_POWER_FLAG_SYSTEM:	Hardware is system (not runtime) suspended
+ * @IPA_POWER_FLAG_STOPPED:	Modem TX is disabled by ipa_start_xmit()
+ * @IPA_POWER_FLAG_STARTED:	Modem TX was enabled by ipa_runtime_resume()
  * @IPA_POWER_FLAG_COUNT:	Number of defined power flags
  */
 enum ipa_power_flag {
 	IPA_POWER_FLAG_RESUMED,
 	IPA_POWER_FLAG_SYSTEM,
+	IPA_POWER_FLAG_STOPPED,
+	IPA_POWER_FLAG_STARTED,
 	IPA_POWER_FLAG_COUNT,		/* Last; not a flag */
 };
 
@@ -60,6 +64,7 @@ enum ipa_power_flag {
  * struct ipa_clock - IPA clocking information
  * @dev:		IPA device pointer
  * @core:		IPA core clock
+ * @spinlock:		Protects modem TX queue enable/disable
  * @flags:		Boolean state flags
  * @interconnect_count:	Number of elements in interconnect[]
  * @interconnect:	Interconnect array
@@ -67,6 +72,7 @@ enum ipa_power_flag {
 struct ipa_clock {
 	struct device *dev;
 	struct clk *core;
+	spinlock_t spinlock;	/* used with STOPPED/STARTED power flags */
 	DECLARE_BITMAP(flags, IPA_POWER_FLAG_COUNT);
 	u32 interconnect_count;
 	struct ipa_interconnect *interconnect;
@@ -334,6 +340,69 @@ static void ipa_suspend_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
 	ipa_interrupt_suspend_clear_all(ipa->interrupt);
 }
 
+/* The next few functions coordinate stopping and starting the modem
+ * network device transmit queue.
+ *
+ * Transmit can be running concurrent with power resume, and there's a
+ * chance the resume completes before the transmit path stops the queue,
+ * leaving the queue in a stopped state.  The next two functions are used
+ * to avoid this: ipa_power_modem_queue_stop() is used by ipa_start_xmit()
+ * to conditionally stop the TX queue; and ipa_power_modem_queue_start()
+ * is used by ipa_runtime_resume() to conditionally restart it.
+ *
+ * Two flags and a spinlock are used.  If the queue is stopped, the STOPPED
+ * power flag is set.  And if the queue is started, the STARTED flag is set.
+ * The queue is only started on resume if the STOPPED flag is set.  And the
+ * queue is only started in ipa_start_xmit() if the STARTED flag is *not*
+ * set.  As a result, the queue remains operational if the two activites
+ * happen concurrently regardless of the order they complete.  The spinlock
+ * ensures the flag and TX queue operations are done atomically.
+ *
+ * The first function stops the modem netdev transmit queue, but only if
+ * the STARTED flag is *not* set.  That flag is cleared if it was set.
+ * If the queue is stopped, the STOPPED flag is set.  This is called only
+ * from the power ->runtime_resume operation.
+ */
+void ipa_power_modem_queue_stop(struct ipa *ipa)
+{
+	struct ipa_clock *clock = ipa->clock;
+	unsigned long flags;
+
+	spin_lock_irqsave(&clock->spinlock, flags);
+
+	if (!__test_and_clear_bit(IPA_POWER_FLAG_STARTED, clock->flags)) {
+		netif_stop_queue(ipa->modem_netdev);
+		__set_bit(IPA_POWER_FLAG_STOPPED, clock->flags);
+	}
+
+	spin_unlock_irqrestore(&clock->spinlock, flags);
+}
+
+/* This function starts the modem netdev transmit queue, but only if the
+ * STOPPED flag is set.  That flag is cleared if it was set.  If the queue
+ * was restarted, the STARTED flag is set; this allows ipa_start_xmit()
+ * to skip stopping the queue in the event of a race.
+ */
+void ipa_power_modem_queue_wake(struct ipa *ipa)
+{
+	struct ipa_clock *clock = ipa->clock;
+	unsigned long flags;
+
+	spin_lock_irqsave(&clock->spinlock, flags);
+
+	if (__test_and_clear_bit(IPA_POWER_FLAG_STOPPED, clock->flags)) {
+		__set_bit(IPA_POWER_FLAG_STARTED, clock->flags);
+		netif_wake_queue(ipa->modem_netdev);
+	}
+
+	spin_unlock_irqrestore(&clock->spinlock, flags);
+}
+
+/* This function clears the STARTED flag once the TX queue is operating */
+{
+	clear_bit(IPA_POWER_FLAG_STARTED, ipa->clock->flags);
+}
+
 int ipa_power_setup(struct ipa *ipa)
 {
 	int ret;
@@ -383,6 +452,7 @@ ipa_clock_init(struct device *dev, const struct ipa_clock_data *data)
 	}
 	clock->dev = dev;
 	clock->core = clk;
+	spin_lock_init(&clock->spinlock);
 	clock->interconnect_count = data->interconnect_count;
 
 	ret = ipa_interconnect_init(clock, dev, data->interconnect_data);
diff --git a/drivers/net/ipa/ipa_clock.h b/drivers/net/ipa/ipa_clock.h
index 5c53241336a1a..64cd15981b1da 100644
--- a/drivers/net/ipa/ipa_clock.h
+++ b/drivers/net/ipa/ipa_clock.h
@@ -22,6 +22,24 @@ extern const struct dev_pm_ops ipa_pm_ops;
  */
 u32 ipa_clock_rate(struct ipa *ipa);
 
+/**
+ * ipa_power_modem_queue_stop() - Possibly stop the modem netdev TX queue
+ * @ipa:	IPA pointer
+ */
+void ipa_power_modem_queue_stop(struct ipa *ipa);
+
+/**
+ * ipa_power_modem_queue_wake() - Possibly wake the modem netdev TX queue
+ * @ipa:	IPA pointer
+ */
+void ipa_power_modem_queue_wake(struct ipa *ipa);
+
+/**
+ * ipa_power_modem_queue_active() - Report modem netdev TX queue active
+ * @ipa:	IPA pointer
+ */
+void ipa_power_modem_queue_active(struct ipa *ipa);
+
 /**
  * ipa_power_setup() - Set up IPA power management
  * @ipa:	IPA pointer
diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index c8724af935b85..16d87910305e1 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -130,6 +130,7 @@ ipa_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 	if (ret < 1) {
 		/* If a resume won't happen, just drop the packet */
 		if (ret < 0 && ret != -EINPROGRESS) {
+			ipa_power_modem_queue_active(ipa);
 			pm_runtime_put_noidle(dev);
 			goto err_drop_skb;
 		}
@@ -138,13 +139,15 @@ ipa_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 		 * until we're resumed; ipa_modem_resume() arranges for the
 		 * TX queue to be started again.
 		 */
-		netif_stop_queue(netdev);
+		ipa_power_modem_queue_stop(ipa);
 
 		(void)pm_runtime_put(dev);
 
 		return NETDEV_TX_BUSY;
 	}
 
+	ipa_power_modem_queue_active(ipa);
+
 	ret = ipa_endpoint_skb_tx(endpoint, skb);
 
 	(void)pm_runtime_put(dev);
@@ -241,7 +244,7 @@ static void ipa_modem_wake_queue_work(struct work_struct *work)
 {
 	struct ipa_priv *priv = container_of(work, struct ipa_priv, work);
 
-	netif_wake_queue(priv->ipa->modem_netdev);
+	ipa_power_modem_queue_wake(priv->ipa);
 }
 
 /** ipa_modem_resume() - resume callback for runtime_pm
-- 
2.27.0

