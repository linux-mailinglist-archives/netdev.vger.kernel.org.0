Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E546BAE93
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 12:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbjCOLG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 07:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbjCOLGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 07:06:40 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F7E81CC9
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:06:32 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id bh21-20020a05600c3d1500b003ed1ff06fb0so904137wmb.3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112; t=1678878391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4G51EsWXQSEVtcp1NG3mD14IHUOx70eoIPFV54V3mcs=;
        b=72BvkdADVNjAa//Jme41vk/2ZmgkszfBpEMKZ60sdwjtfF6qTaHNZzJmsTkwx88AqO
         sYYYbSDb+bDMGj0ThqGzZRhJDpBwtCA41s4V5c4SO3cLj75hEGAHmLiLsS1C8ZAAOdKZ
         BnDbuRc0Xd+0ZMz2OJF5QdH/IWXb/0M6cyWg4d2BMB3+52sarKFCxFrhDm2PecL+bDwe
         debh6WkcdC5yTFublpG7Bi/i+kj6SKVAM7IHtOgNOnAanQVGyKYtqkaJm4OSDoz5lHeW
         JYBxrt22Tp9gfXeSc8zOQt5dyyuTZs35OH/3K3RMy3889Axt4i0ZFuk1KaBmcqqckUfr
         PJRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678878391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4G51EsWXQSEVtcp1NG3mD14IHUOx70eoIPFV54V3mcs=;
        b=M77TLeYmb3XDom3HXFWFD8PaqV6fRQPNbBhYZ0bcrvCaB9h27bgLJ2++O81qecmCO2
         n6lNZaUN6Kv7rzex7lwGRIrVgIfqV5Wdevqm4/x1ULayZRAiIAhDBmHLUljs8ieHsMbT
         T1bNCdE+KE2B1gRYYuLlDgvv9GyTJKc1GphwQy5gscHOXFPIPP1bSq+p7yDV1Du/pErq
         +M9V0RVIx3lqQN9fabJKPZNaUYkqlo+audFhqAa3iyboD4NrBbD/soIjHozdzso8YSDQ
         yv3HWlqY2knzBK1L6QI4FbwKp6uTw+jE6hJROml/GxjzLlVJUOJH73LLg0Urk6+Qrzry
         UgWQ==
X-Gm-Message-State: AO0yUKV/DbXc1kFINe2UPwRTUBqS4f2gG/2tzoJtfHj92REJpeNsxjmo
        eCjxpjkkydWsa6rM7BVTHjCd73Lsw4m5FjUN4tc=
X-Google-Smtp-Source: AK7set8w1hmTzg92IG0jHG+mf8hEnjjY0U67BwBBI9PGNrCoNUG1+/olZ8NThQ0LZWw0eP1kwTIRkA==
X-Received: by 2002:a05:600c:4fd1:b0:3ed:377b:19d4 with SMTP id o17-20020a05600c4fd100b003ed377b19d4mr551186wmq.0.1678878391024;
        Wed, 15 Mar 2023 04:06:31 -0700 (PDT)
Received: from blmsp.fritz.box ([2001:4090:a247:8056:be7d:83e:a6a5:4659])
        by smtp.gmail.com with ESMTPSA id l4-20020a7bc444000000b003eafc47eb09sm1460563wmi.43.2023.03.15.04.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 04:06:30 -0700 (PDT)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v3 07/16] can: m_can: Implement receive coalescing
Date:   Wed, 15 Mar 2023 12:05:37 +0100
Message-Id: <20230315110546.2518305-8-msp@baylibre.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315110546.2518305-1-msp@baylibre.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
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

m_can offers the possibility to set an interrupt on reaching a watermark
level in the receive FIFO. This can be used to implement coalescing.
Unfortunately there is no hardware timeout available to trigger an
interrupt if only a few messages were received within a given time. To
solve this I am using a hrtimer to wake up the irq thread after x
microseconds.

The timer is always started if receive coalescing is enabled and new
received frames were available during an interrupt. The timer is stopped
if during a interrupt handling no new data was available.

If the timer is started the new item interrupt is disabled and the
watermark interrupt takes over. If the timer is not started again, the
new item interrupt is enabled again, notifying the handler about every
new item received.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 69 ++++++++++++++++++++++++++++++++---
 drivers/net/can/m_can/m_can.h |  7 ++++
 2 files changed, 70 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 35a2332464e5..e7dc083e32e4 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1070,15 +1070,55 @@ static int m_can_echo_tx_event(struct net_device *dev)
 	return err;
 }
 
+static void m_can_interrupt_enable(struct m_can_classdev *cdev, u32 interrupts)
+{
+	if (cdev->active_interrupts == interrupts)
+		return;
+	cdev->ops->write_reg(cdev, M_CAN_IE, interrupts);
+	cdev->active_interrupts = interrupts;
+}
+
+static void m_can_coalescing_disable(struct m_can_classdev *cdev)
+{
+	u32 new_interrupts = cdev->active_interrupts | IR_RF0N;
+
+	hrtimer_cancel(&cdev->irq_timer);
+	m_can_interrupt_enable(cdev, new_interrupts);
+}
+
+static void m_can_coalescing_update(struct m_can_classdev *cdev, u32 ir)
+{
+	u32 new_interrupts = cdev->active_interrupts;
+	bool enable_timer = false;
+
+	if (cdev->rx_coalesce_usecs_irq > 0 && (ir & (IR_RF0N | IR_RF0W))) {
+		enable_timer = true;
+		new_interrupts &= ~IR_RF0N;
+	} else if (!hrtimer_active(&cdev->irq_timer)) {
+		new_interrupts |= IR_RF0N;
+	}
+
+	m_can_interrupt_enable(cdev, new_interrupts);
+	if (enable_timer) {
+		hrtimer_start(&cdev->irq_timer,
+			      ns_to_ktime(cdev->rx_coalesce_usecs_irq * NSEC_PER_USEC),
+			      HRTIMER_MODE_REL);
+	}
+}
+
 static irqreturn_t m_can_isr(int irq, void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	u32 ir;
 
-	if (pm_runtime_suspended(cdev->dev))
+	if (pm_runtime_suspended(cdev->dev)) {
+		m_can_coalescing_disable(cdev);
 		return IRQ_NONE;
+	}
+
 	ir = m_can_read(cdev, M_CAN_IR);
+	m_can_coalescing_update(cdev, ir);
 	if (!ir)
 		return IRQ_NONE;
 
@@ -1093,13 +1133,17 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 	 * - state change IRQ
 	 * - bus error IRQ and bus error reporting
 	 */
-	if ((ir & IR_RF0N) || (ir & IR_ERR_ALL_30X)) {
+	if (ir & (IR_RF0N | IR_RF0W | IR_ERR_ALL_30X)) {
 		cdev->irqstatus = ir;
 		if (!cdev->is_peripheral) {
 			m_can_disable_all_interrupts(cdev);
 			napi_schedule(&cdev->napi);
-		} else if (m_can_rx_peripheral(dev, ir) < 0) {
-			goto out_fail;
+		} else {
+			int pkts;
+
+			pkts = m_can_rx_peripheral(dev, ir);
+			if (pkts < 0)
+				goto out_fail;
 		}
 	}
 
@@ -1135,6 +1179,15 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static enum hrtimer_restart m_can_irq_timer(struct hrtimer *timer)
+{
+	struct m_can_classdev *cdev = container_of(timer, struct m_can_classdev, irq_timer);
+
+	irq_wake_thread(cdev->net->irq, cdev->net);
+
+	return HRTIMER_NORESTART;
+}
+
 static const struct can_bittiming_const m_can_bittiming_const_30X = {
 	.name = KBUILD_MODNAME,
 	.tseg1_min = 2,		/* Time segment 1 = prop_seg + phase_seg1 */
@@ -1275,7 +1328,7 @@ static int m_can_chip_config(struct net_device *dev)
 	/* Disable unused interrupts */
 	interrupts &= ~(IR_ARA | IR_ELO | IR_DRX | IR_TEFF | IR_TEFW | IR_TFE |
 			IR_TCF | IR_HPM | IR_RF1F | IR_RF1W | IR_RF1N |
-			IR_RF0F | IR_RF0W);
+			IR_RF0F);
 
 	m_can_config_endisable(cdev, true);
 
@@ -1319,6 +1372,7 @@ static int m_can_chip_config(struct net_device *dev)
 
 	/* rx fifo configuration, blocking mode, fifo size 1 */
 	m_can_write(cdev, M_CAN_RXF0C,
+		    FIELD_PREP(RXFC_FWM_MASK, cdev->rx_max_coalesced_frames_irq) |
 		    FIELD_PREP(RXFC_FS_MASK, cdev->mcfg[MRAM_RXF0].num) |
 		    cdev->mcfg[MRAM_RXF0].off);
 
@@ -1377,7 +1431,7 @@ static int m_can_chip_config(struct net_device *dev)
 		else
 			interrupts &= ~(IR_ERR_LEC_31X);
 	}
-	m_can_write(cdev, M_CAN_IE, interrupts);
+	m_can_interrupt_enable(cdev, interrupts);
 
 	/* route all interrupts to INT0 */
 	m_can_write(cdev, M_CAN_ILS, ILS_ALL_INT0);
@@ -2041,6 +2095,9 @@ int m_can_class_register(struct m_can_classdev *cdev)
 
 	of_can_transceiver(cdev->net);
 
+	hrtimer_init(&cdev->irq_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	cdev->irq_timer.function = m_can_irq_timer;
+
 	dev_info(cdev->dev, "%s device registered (irq=%d, version=%d)\n",
 		 KBUILD_MODNAME, cdev->net->irq, cdev->version);
 
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index a839dc71dc9b..c59099d3f5b9 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -84,6 +84,8 @@ struct m_can_classdev {
 	struct sk_buff *tx_skb;
 	struct phy *transceiver;
 
+	struct hrtimer irq_timer;
+
 	struct m_can_ops *ops;
 
 	int version;
@@ -92,6 +94,11 @@ struct m_can_classdev {
 	int pm_clock_support;
 	int is_peripheral;
 
+	// Cached M_CAN_IE register content
+	u32 active_interrupts;
+	u32 rx_max_coalesced_frames_irq;
+	u32 rx_coalesce_usecs_irq;
+
 	struct mram_cfg mcfg[MRAM_CFG_NUM];
 };
 
-- 
2.39.2

