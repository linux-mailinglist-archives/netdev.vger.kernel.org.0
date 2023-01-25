Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63B267BB2D
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 20:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236168AbjAYTwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 14:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236034AbjAYTwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 14:52:02 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75811589BD
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:51:17 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id mg12so50607884ejc.5
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fZXSe+W5cVBmHn39qBn1fgW+vdfoWT/J0aoyP8tJEY0=;
        b=lR6BNV1OIuwBB1OtVeSeyzQKeOVrwLmnMiMZpVQY1YkgGIVhhkirqCRuM3G6cfvudo
         fOVFqz11nViGbdyUbD2nJPk9c7sTwO4CyM/OVFH7l8pbpXq8HXwPMomVU9RzlT7MuClU
         RLCn8KIif77ABBpVD8z/Bpix/sMvEqVoIGSA6tt11xDjHng7UQ/jz48TIKpoG71VAS7l
         RC4CW3nBNewPMG3kDaM41lHzWgwSa97A4SZc4O53feXtFxG9a0jAW2MZFWopXC3EKWrT
         1MJv1LtHOVE4ddVzs5tKsekVmarAhcSTqbMbQ7Bj13CoCLPgTxh8eDhr5Knl+ddw0Ky2
         vzxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fZXSe+W5cVBmHn39qBn1fgW+vdfoWT/J0aoyP8tJEY0=;
        b=xOjkBJtVwABDyXxGqcBufTqvp4L0boZEy/nLm0y23ZMq9JGS43au0Hxt8fzajF5neD
         5GumC6PI9DViv7GZ6k7MdN/Js9C/NPpuxTg+Ga8Vv9dS/AdpYfG9KBzmsG5W++XojGSb
         fYiwJ9lPoR+opdFh+ip5PgCGlIq6Qbay7aAw8fMQViopGs0f05ii/e6HcvqNozbnam5t
         u1NMwBGBZBFjvbIyerDqP+tx8h0lLYZKfBFNVNWdUGRpB97OtBuvd75CoYe11J3B5Z2c
         qR1+g2ERA0FkTzwiOqleJ66Uv8nFzAlHQrk0sxuO2AyqC5rNNH/opbOWJ3l2v0m6FPsC
         0NBg==
X-Gm-Message-State: AFqh2krZwj+7mRAXqS/SIAmyw7T+3LVZbgZcOvAke8xpyQeVuZxpijNH
        JEaix5jJ+jycVaEEEPcaijIFCQ==
X-Google-Smtp-Source: AMrXdXvQU8kRuX62Kury4EqdPsjsiINq1jQByURwaB4uoLrVdOiLv4fp8cVaHR1rQDyP5MJDoa/rTw==
X-Received: by 2002:a17:907:1042:b0:7c1:5863:f8c4 with SMTP id oy2-20020a170907104200b007c15863f8c4mr33072684ejb.21.1674676276901;
        Wed, 25 Jan 2023 11:51:16 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a247:815f:ef74:e427:628a:752c])
        by smtp.gmail.com with ESMTPSA id s15-20020a170906454f00b00872c0bccab2sm2778830ejq.35.2023.01.25.11.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 11:51:16 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v2 14/18] can: m_can: Use the workqueue as queue
Date:   Wed, 25 Jan 2023 20:50:55 +0100
Message-Id: <20230125195059.630377-15-msp@baylibre.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230125195059.630377-1-msp@baylibre.com>
References: <20230125195059.630377-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current implementation uses the workqueue for peripheral chips to
submit work. Only a single work item is queued and used at any time.

To be able to keep more than one transmit in flight at a time, prepare
the workqueue to support multiple transmits at the same time.

Each work item now has a separate storage for a skb and a pointer to
cdev. This assures that each workitem can be processed individually.

The workqueue is replaced by an ordered workqueue which makes sure that
only a single worker processes the items queued on the workqueue. Also
items are ordered by the order they were enqueued. This removes most of
the concurrency the workqueue normally offers. It is not necessary for
this driver.

The cleanup functions have to be adopted a bit to handle this new
mechanism.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 109 ++++++++++++++++++++--------------
 drivers/net/can/m_can/m_can.h |  12 +++-
 2 files changed, 74 insertions(+), 47 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 83ffb4c0eb4c..03e6466f9b32 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -443,17 +443,16 @@ static void m_can_clean(struct net_device *net)
 {
 	struct m_can_classdev *cdev = netdev_priv(net);
 
-	if (cdev->tx_skb) {
-		int putidx = 0;
+	for (int i = 0; i != cdev->tx_fifo_size; ++i) {
+		if (!cdev->tx_ops[i].skb)
+			continue;
 
 		net->stats.tx_errors++;
-		if (cdev->version > 30)
-			putidx = FIELD_GET(TXFQS_TFQPI_MASK,
-					   m_can_read(cdev, M_CAN_TXFQS));
-
-		can_free_echo_skb(cdev->net, putidx, NULL);
-		cdev->tx_skb = NULL;
+		cdev->tx_ops[i].skb = NULL;
 	}
+
+	for (int i = 0; i != cdev->can.echo_skb_max; ++i)
+		can_free_echo_skb(cdev->net, i, NULL);
 }
 
 /* For peripherals, pass skb to rx-offload, which will push skb from
@@ -1656,8 +1655,9 @@ static int m_can_close(struct net_device *dev)
 	m_can_clk_stop(cdev);
 	free_irq(dev->irq, dev);
 
+	m_can_clean(dev);
+
 	if (cdev->is_peripheral) {
-		cdev->tx_skb = NULL;
 		destroy_workqueue(cdev->tx_wq);
 		cdev->tx_wq = NULL;
 		can_rx_offload_disable(&cdev->offload);
@@ -1684,19 +1684,17 @@ static int m_can_next_echo_skb_occupied(struct net_device *dev, int putidx)
 	return !!cdev->can.echo_skb[next_idx];
 }
 
-static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
+static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev,
+				    struct sk_buff *skb)
 {
-	struct canfd_frame *cf = (struct canfd_frame *)cdev->tx_skb->data;
+	struct canfd_frame *cf = (struct canfd_frame *)skb->data;
 	struct net_device *dev = cdev->net;
-	struct sk_buff *skb = cdev->tx_skb;
 	struct id_and_dlc fifo_header;
 	u32 cccr, fdflags;
 	u32 txfqs;
 	int err;
 	int putidx;
 
-	cdev->tx_skb = NULL;
-
 	/* Generate ID field for TX buffer Element */
 	/* Common to all supported M_CAN versions */
 	if (cf->can_id & CAN_EFF_FLAG) {
@@ -1820,10 +1818,36 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 
 static void m_can_tx_work_queue(struct work_struct *ws)
 {
-	struct m_can_classdev *cdev = container_of(ws, struct m_can_classdev,
-						   tx_work);
+	struct m_can_tx_op *op = container_of(ws, struct m_can_tx_op, work);
+	struct m_can_classdev *cdev = op->cdev;
+	struct sk_buff *skb = op->skb;
 
-	m_can_tx_handler(cdev);
+	op->skb = NULL;
+	m_can_tx_handler(cdev, skb);
+}
+
+static void m_can_tx_queue_skb(struct m_can_classdev *cdev, struct sk_buff *skb)
+{
+	cdev->tx_ops[cdev->next_tx_op].skb = skb;
+	queue_work(cdev->tx_wq, &cdev->tx_ops[cdev->next_tx_op].work);
+
+	++cdev->next_tx_op;
+	if (cdev->next_tx_op >= cdev->tx_fifo_size)
+		cdev->next_tx_op = 0;
+}
+
+static netdev_tx_t m_can_start_peripheral_xmit(struct m_can_classdev *cdev,
+					       struct sk_buff *skb)
+{
+	if (cdev->can.state == CAN_STATE_BUS_OFF) {
+		m_can_clean(cdev->net);
+		return NETDEV_TX_OK;
+	}
+
+	netif_stop_queue(cdev->net);
+	m_can_tx_queue_skb(cdev, skb);
+
+	return NETDEV_TX_OK;
 }
 
 static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
@@ -1834,30 +1858,10 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
-	if (cdev->is_peripheral) {
-		if (cdev->tx_skb) {
-			netdev_err(dev, "hard_xmit called while tx busy\n");
-			return NETDEV_TX_BUSY;
-		}
-
-		if (cdev->can.state == CAN_STATE_BUS_OFF) {
-			m_can_clean(dev);
-		} else {
-			/* Need to stop the queue to avoid numerous requests
-			 * from being sent.  Suggested improvement is to create
-			 * a queueing mechanism that will queue the skbs and
-			 * process them in order.
-			 */
-			cdev->tx_skb = skb;
-			netif_stop_queue(cdev->net);
-			queue_work(cdev->tx_wq, &cdev->tx_work);
-		}
-	} else {
-		cdev->tx_skb = skb;
-		return m_can_tx_handler(cdev);
-	}
-
-	return NETDEV_TX_OK;
+	if (cdev->is_peripheral)
+		return m_can_start_peripheral_xmit(cdev, skb);
+	else
+		return m_can_tx_handler(cdev, skb);
 }
 
 static int m_can_open(struct net_device *dev)
@@ -1885,15 +1889,17 @@ static int m_can_open(struct net_device *dev)
 
 	/* register interrupt handler */
 	if (cdev->is_peripheral) {
-		cdev->tx_skb = NULL;
-		cdev->tx_wq = alloc_workqueue("mcan_wq",
-					      WQ_FREEZABLE | WQ_MEM_RECLAIM, 0);
+		cdev->tx_wq = alloc_ordered_workqueue("mcan_wq",
+						      WQ_FREEZABLE | WQ_MEM_RECLAIM);
 		if (!cdev->tx_wq) {
 			err = -ENOMEM;
 			goto out_wq_fail;
 		}
 
-		INIT_WORK(&cdev->tx_work, m_can_tx_work_queue);
+		for (int i = 0; i != cdev->tx_fifo_size; ++i) {
+			cdev->tx_ops[i].cdev = cdev;
+			INIT_WORK(&cdev->tx_ops[i].work, m_can_tx_work_queue);
+		}
 
 		err = request_threaded_irq(dev->irq, NULL, m_can_isr,
 					   IRQF_ONESHOT,
@@ -2179,6 +2185,19 @@ int m_can_class_register(struct m_can_classdev *cdev)
 {
 	int ret;
 
+	cdev->tx_fifo_size = max(1, min(cdev->mcfg[MRAM_TXB].num,
+					cdev->mcfg[MRAM_TXE].num));
+	if (cdev->is_peripheral) {
+		cdev->tx_ops =
+			devm_kzalloc(cdev->dev,
+				     cdev->tx_fifo_size * sizeof(*cdev->tx_ops),
+				     GFP_KERNEL);
+		if (!cdev->tx_ops) {
+			dev_err(cdev->dev, "Failed to allocate tx_ops for workqueue\n");
+			return -ENOMEM;
+		}
+	}
+
 	if (cdev->pm_clock_support) {
 		ret = m_can_clk_start(cdev);
 		if (ret)
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index 4437085f63b8..774672fe7d2e 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -70,6 +70,12 @@ struct m_can_ops {
 	int (*init)(struct m_can_classdev *cdev);
 };
 
+struct m_can_tx_op {
+	struct m_can_classdev *cdev;
+	struct work_struct work;
+	struct sk_buff *skb;
+};
+
 struct m_can_classdev {
 	struct can_priv can;
 	struct can_rx_offload offload;
@@ -80,8 +86,6 @@ struct m_can_classdev {
 	struct clk *cclk;
 
 	struct workqueue_struct *tx_wq;
-	struct work_struct tx_work;
-	struct sk_buff *tx_skb;
 	struct phy *transceiver;
 
 	struct hrtimer irq_timer;
@@ -105,6 +109,10 @@ struct m_can_classdev {
 	// Store this internally to avoid fetch delays on peripheral chips
 	int tx_fifo_putidx;
 
+	struct m_can_tx_op *tx_ops;
+	int tx_fifo_size;
+	int next_tx_op;
+
 	struct mram_cfg mcfg[MRAM_CFG_NUM];
 };
 
-- 
2.39.0

