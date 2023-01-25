Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F8167BB2E
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 20:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbjAYTw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 14:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235895AbjAYTwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 14:52:03 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1FD5A36E
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:51:18 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id nd31so36328ejc.8
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ted8XAaZ1TnoxK7fH6iDTkjZZNEKPE9wfSG8VYeUjqk=;
        b=qe2mIr2nd4mX783B0kBepfkS72z7m+aFy+ZkMHSBbNPMAT0CEtJDL82svj1DWS8cHx
         VxZamFivlH1O3qCdQtp/LPPJw+0opMQEoSMyVW8ZeJOAZYKrx4nCBCw/q+yXNwdHlikY
         AZ6u2iK9G/PSgfT6vb4S7Pdgz27xjBP4SoMnarT+qOkG8dzsUckBubXlpt5t/YczZVNv
         pLgl26D2b5oKEncBqUXlNDLIe+u5Q3mGsoi2Fk+Mo0q2inFZjatCS1XIcGFiu/fhxUQq
         Z5OMmkbxQo7q/jZVVwOui4CEUf9ZLyibCbKQjvxbUc+e2n8mO8/wE5iYHnGDnIYE0s3+
         hZ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ted8XAaZ1TnoxK7fH6iDTkjZZNEKPE9wfSG8VYeUjqk=;
        b=MQSLO3zdZ/3vIdWrbr45FAeGMVKRrWYBscp4z2f72bbdKI7Fp/gXPBdfGCbLkfqu1F
         Ny/RTWgPHvJGZETHrnWNTz//B/B0emiWr9CrteweXRyIol3AAH9T/LfzN3C/4LgfKLDE
         c8Hpd1Al08uip9H3nMlVgK7XUNkKWHTlNHm3uGpnoaQ5Ifj0RHORREBv5ZSmgU3PP31B
         3LzH7p6NZAJUVVOGySgWguMskZbj78+fA+MU8kDLkL1iEh7t4PLdD72qgrCpmv3KZQCB
         fAPNV7rHleRw8O6MZ02v/wyZ0vli2pONPdoQ0ILDCMpow2iAX6Ql9TEMnnBy3XA2EEcx
         NRrw==
X-Gm-Message-State: AFqh2krfL/mYTTx84OQ/R2c5qJx3xFeiXz/dMUAHs25p9FpNTSjVa++V
        UYq21yt+HnoAcXQHEMoRinkHEw==
X-Google-Smtp-Source: AMrXdXumAJiNDbe7QnHfLTqLmOC4GZeJLhrB2Cuzr2//f3j2Ym+89W/WpAvX676vgoFeOTahqAj41Q==
X-Received: by 2002:a17:907:3f20:b0:7c0:f7b0:9aed with SMTP id hq32-20020a1709073f2000b007c0f7b09aedmr45200898ejc.55.1674676277826;
        Wed, 25 Jan 2023 11:51:17 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a247:815f:ef74:e427:628a:752c])
        by smtp.gmail.com with ESMTPSA id s15-20020a170906454f00b00872c0bccab2sm2778830ejq.35.2023.01.25.11.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 11:51:17 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v2 15/18] can: m_can: Introduce a tx_fifo_in_flight counter
Date:   Wed, 25 Jan 2023 20:50:56 +0100
Message-Id: <20230125195059.630377-16-msp@baylibre.com>
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

Keep track of the number of transmits in flight.

This patch prepares the driver to control the network interface queue
based on this counter. By itself this counter be
implemented with an atomic, but as we need to do other things in the
critical sections later I am using a spinlock instead.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 36 ++++++++++++++++++++++++++++++++++-
 drivers/net/can/m_can/m_can.h |  4 ++++
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 03e6466f9b32..f46d411bc796 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -453,6 +453,10 @@ static void m_can_clean(struct net_device *net)
 
 	for (int i = 0; i != cdev->can.echo_skb_max; ++i)
 		can_free_echo_skb(cdev->net, i, NULL);
+
+	spin_lock(&cdev->tx_handling_spinlock);
+	cdev->tx_fifo_in_flight = 0;
+	spin_unlock(&cdev->tx_handling_spinlock);
 }
 
 /* For peripherals, pass skb to rx-offload, which will push skb from
@@ -1023,6 +1027,20 @@ static void m_can_tx_update_stats(struct m_can_classdev *cdev,
 	stats->tx_packets++;
 }
 
+static void m_can_finish_tx(struct m_can_classdev *cdev, int transmitted)
+{
+	spin_lock(&cdev->tx_handling_spinlock);
+	cdev->tx_fifo_in_flight -= transmitted;
+	spin_unlock(&cdev->tx_handling_spinlock);
+}
+
+static void m_can_start_tx(struct m_can_classdev *cdev)
+{
+	spin_lock(&cdev->tx_handling_spinlock);
+	++cdev->tx_fifo_in_flight;
+	spin_unlock(&cdev->tx_handling_spinlock);
+}
+
 static int m_can_echo_tx_event(struct net_device *dev)
 {
 	u32 txe_count = 0;
@@ -1032,6 +1050,7 @@ static int m_can_echo_tx_event(struct net_device *dev)
 	int i = 0;
 	int err = 0;
 	unsigned int msg_mark;
+	int processed = 0;
 
 	struct m_can_classdev *cdev = netdev_priv(dev);
 
@@ -1061,12 +1080,15 @@ static int m_can_echo_tx_event(struct net_device *dev)
 
 		/* update stats */
 		m_can_tx_update_stats(cdev, msg_mark, timestamp);
+		++processed;
 	}
 
 	if (ack_fgi != -1)
 		m_can_write(cdev, M_CAN_TXEFA, FIELD_PREP(TXEFA_EFAI_MASK,
 							  ack_fgi));
 
+	m_can_finish_tx(cdev, processed);
+
 	return err;
 }
 
@@ -1161,6 +1183,7 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 				timestamp = m_can_get_timestamp(cdev);
 			m_can_tx_update_stats(cdev, 0, timestamp);
 			netif_wake_queue(dev);
+			m_can_finish_tx(cdev, 1);
 		}
 	} else  {
 		if (ir & (IR_TEFN | IR_TEFW)) {
@@ -1845,11 +1868,22 @@ static netdev_tx_t m_can_start_peripheral_xmit(struct m_can_classdev *cdev,
 	}
 
 	netif_stop_queue(cdev->net);
+
+	m_can_start_tx(cdev);
+
 	m_can_tx_queue_skb(cdev, skb);
 
 	return NETDEV_TX_OK;
 }
 
+static netdev_tx_t m_can_start_fast_xmit(struct m_can_classdev *cdev,
+					 struct sk_buff *skb)
+{
+	m_can_start_tx(cdev);
+
+	return m_can_tx_handler(cdev, skb);
+}
+
 static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
@@ -1861,7 +1895,7 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 	if (cdev->is_peripheral)
 		return m_can_start_peripheral_xmit(cdev, skb);
 	else
-		return m_can_tx_handler(cdev, skb);
+		return m_can_start_fast_xmit(cdev, skb);
 }
 
 static int m_can_open(struct net_device *dev)
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index 774672fe7d2e..bfef2c89e239 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -109,6 +109,10 @@ struct m_can_classdev {
 	// Store this internally to avoid fetch delays on peripheral chips
 	int tx_fifo_putidx;
 
+	/* Protects shared state between start_xmit and m_can_isr */
+	spinlock_t tx_handling_spinlock;
+	int tx_fifo_in_flight;
+
 	struct m_can_tx_op *tx_ops;
 	int tx_fifo_size;
 	int next_tx_op;
-- 
2.39.0

