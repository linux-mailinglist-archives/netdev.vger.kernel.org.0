Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4DEC6BAE97
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 12:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbjCOLHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 07:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbjCOLGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 07:06:41 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0EF856AB
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:06:33 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id j19-20020a05600c191300b003eb3e1eb0caso828593wmq.1
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112; t=1678878392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OHW+8pE2A5c2VoqM9vU7QUWbsPA/ggSN3rae/Dk0G5A=;
        b=H5FZwJ1JMuEvd7SN/LBWH2Q/LxGpSvzyVzzGIrLSQlkQzv2tWUjyq+ZdLNVLuFCMm6
         f7acADBRMLfEwb1nfb1QgC151ryK74lxPxvBkGvzMJZGCKu3THq1CubBj50iQX5PiScX
         UlyLGiLeXu7fcI8xjgCI5REMl9FIA9ItG+NBjDDtBjV/3lZxYR5DbvJHa8dqjSwXurlL
         O/mINTSadJtNso10aO/FVntmwgS/AX6szF5HpPpzUdJQ3xwv3H6VsjC4e14c8lsfBfqp
         mdo/836BKqVGQF7MecURrwQn5KkkoYzGaPikslaZgSrzcYpz/6EiWdQpNFkE1ypkt4GP
         /xPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678878392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OHW+8pE2A5c2VoqM9vU7QUWbsPA/ggSN3rae/Dk0G5A=;
        b=BmDQP20QGk9CMBkbttRDcdihngjfSZ2dyuLG99lnKobp7qfugZuvLV2h2s403tv+ow
         hap964KZ4EawmDjNT3z/pReos/TmlupgnlaKnY4yWfxZN+qLKhcv+gLZGm9EsigKZk1M
         aMLx0iceJXk5CqXJe8xmMnFjQfp42seaEL2GMDPXm7oni9MiVYwkIk3yOmuYXqHH9H9q
         mCsoXUBcyGBrXRVJaKCNRh/hj0qTPRttK+WCOE8m3JE5ZjZREEz0ej/JtdHIANhEHbL3
         reyYjzJo8uiFEClNMe/m0D5h0zPCWphxP9DtocwPNgF6q2PSjAwTQGjSUP8bAGJkjHLE
         7sMg==
X-Gm-Message-State: AO0yUKX64Xi3dtmZwDE7E5NWxLjJ73gnZLHeu3TzwkG0Qmm2Oe/qHQei
        qfsmywRui1nmEhRgDNpFUB2U9Q==
X-Google-Smtp-Source: AK7set9nF5WJdWoQ0s02TAT6+CaCGirsEd/QUUX5bhdQEjj3zBsRQTwGyXKy+SLWLXAxFoyywgVdXQ==
X-Received: by 2002:a05:600c:4f42:b0:3eb:98aa:54cd with SMTP id m2-20020a05600c4f4200b003eb98aa54cdmr16940364wmq.17.1678878391927;
        Wed, 15 Mar 2023 04:06:31 -0700 (PDT)
Received: from blmsp.fritz.box ([2001:4090:a247:8056:be7d:83e:a6a5:4659])
        by smtp.gmail.com with ESMTPSA id l4-20020a7bc444000000b003eafc47eb09sm1460563wmi.43.2023.03.15.04.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 04:06:31 -0700 (PDT)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v3 08/16] can: m_can: Implement transmit coalescing
Date:   Wed, 15 Mar 2023 12:05:38 +0100
Message-Id: <20230315110546.2518305-9-msp@baylibre.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315110546.2518305-1-msp@baylibre.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the coalescing implementation for transmits.

In normal mode the chip raises an interrupt for every finished transmit.
This implementation switches to coalescing mode as soon as an interrupt
handled a transmit. For coalescing the watermark level interrupt is used
to interrupt exactly after x frames were sent. It switches back into
normal mode once there was an interrupt with no finished transmit and
the timer being inactive.

The timer is shared with receive coalescing. The time for receive and
transmit coalescing timers have to be the same for that to work. The
benefit is to have only a single running timer.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 33 ++++++++++++++++++++-------------
 drivers/net/can/m_can/m_can.h |  3 +++
 2 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index e7dc083e32e4..94c962ac6992 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -255,6 +255,7 @@ enum m_can_reg {
 #define TXESC_TBDS_64B		0x7
 
 /* Tx Event FIFO Configuration (TXEFC) */
+#define TXEFC_EFWM_MASK		GENMASK(29, 24)
 #define TXEFC_EFS_MASK		GENMASK(21, 16)
 
 /* Tx Event FIFO Status (TXEFS) */
@@ -1080,7 +1081,7 @@ static void m_can_interrupt_enable(struct m_can_classdev *cdev, u32 interrupts)
 
 static void m_can_coalescing_disable(struct m_can_classdev *cdev)
 {
-	u32 new_interrupts = cdev->active_interrupts | IR_RF0N;
+	u32 new_interrupts = cdev->active_interrupts | IR_RF0N | IR_TEFN;
 
 	hrtimer_cancel(&cdev->irq_timer);
 	m_can_interrupt_enable(cdev, new_interrupts);
@@ -1089,21 +1090,26 @@ static void m_can_coalescing_disable(struct m_can_classdev *cdev)
 static void m_can_coalescing_update(struct m_can_classdev *cdev, u32 ir)
 {
 	u32 new_interrupts = cdev->active_interrupts;
-	bool enable_timer = false;
+	bool enable_rx_timer = false;
+	bool enable_tx_timer = false;
 
 	if (cdev->rx_coalesce_usecs_irq > 0 && (ir & (IR_RF0N | IR_RF0W))) {
-		enable_timer = true;
+		enable_rx_timer = true;
 		new_interrupts &= ~IR_RF0N;
-	} else if (!hrtimer_active(&cdev->irq_timer)) {
-		new_interrupts |= IR_RF0N;
 	}
+	if (cdev->tx_coalesce_usecs_irq > 0 && (ir & (IR_TEFN | IR_TEFW))) {
+		enable_tx_timer = true;
+		new_interrupts &= ~IR_TEFN;
+	}
+	if (!enable_rx_timer && !hrtimer_active(&cdev->irq_timer))
+		new_interrupts |= IR_RF0N;
+	if (!enable_tx_timer && !hrtimer_active(&cdev->irq_timer))
+		new_interrupts |= IR_TEFN;
 
 	m_can_interrupt_enable(cdev, new_interrupts);
-	if (enable_timer) {
-		hrtimer_start(&cdev->irq_timer,
-			      ns_to_ktime(cdev->rx_coalesce_usecs_irq * NSEC_PER_USEC),
+	if (enable_rx_timer | enable_tx_timer)
+		hrtimer_start(&cdev->irq_timer, cdev->irq_timer_wait,
 			      HRTIMER_MODE_REL);
-	}
 }
 
 static irqreturn_t m_can_isr(int irq, void *dev_id)
@@ -1158,7 +1164,7 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 			netif_wake_queue(dev);
 		}
 	} else  {
-		if (ir & IR_TEFN) {
+		if (ir & (IR_TEFN | IR_TEFW)) {
 			/* New TX FIFO Element arrived */
 			if (m_can_echo_tx_event(dev) != 0)
 				goto out_fail;
@@ -1326,9 +1332,8 @@ static int m_can_chip_config(struct net_device *dev)
 	}
 
 	/* Disable unused interrupts */
-	interrupts &= ~(IR_ARA | IR_ELO | IR_DRX | IR_TEFF | IR_TEFW | IR_TFE |
-			IR_TCF | IR_HPM | IR_RF1F | IR_RF1W | IR_RF1N |
-			IR_RF0F);
+	interrupts &= ~(IR_ARA | IR_ELO | IR_DRX | IR_TEFF | IR_TFE | IR_TCF |
+			IR_HPM | IR_RF1F | IR_RF1W | IR_RF1N | IR_RF0F);
 
 	m_can_config_endisable(cdev, true);
 
@@ -1365,6 +1370,8 @@ static int m_can_chip_config(struct net_device *dev)
 	} else {
 		/* Full TX Event FIFO is used */
 		m_can_write(cdev, M_CAN_TXEFC,
+			    FIELD_PREP(TXEFC_EFWM_MASK,
+				       cdev->tx_max_coalesced_frames_irq) |
 			    FIELD_PREP(TXEFC_EFS_MASK,
 				       cdev->mcfg[MRAM_TXE].num) |
 			    cdev->mcfg[MRAM_TXE].off);
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index c59099d3f5b9..d0c21eddb6ec 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -85,6 +85,7 @@ struct m_can_classdev {
 	struct phy *transceiver;
 
 	struct hrtimer irq_timer;
+	ktime_t irq_timer_wait;
 
 	struct m_can_ops *ops;
 
@@ -98,6 +99,8 @@ struct m_can_classdev {
 	u32 active_interrupts;
 	u32 rx_max_coalesced_frames_irq;
 	u32 rx_coalesce_usecs_irq;
+	u32 tx_max_coalesced_frames_irq;
+	u32 tx_coalesce_usecs_irq;
 
 	struct mram_cfg mcfg[MRAM_CFG_NUM];
 };
-- 
2.39.2

