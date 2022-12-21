Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30AF965333E
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 16:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbiLUP0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 10:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234663AbiLUPZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 10:25:52 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCBCDF8B
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:50 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id s5so22402432edc.12
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vIiue0Eegphd4TqHDxcJLHie9gRriJxojR2XQBDT6w0=;
        b=P6uN06IHWaXNID+/R1r/6/a5P1HuWXlqwa5Yg7oJS5DlP068fKhkZ3SwKOIqp3F/GG
         pI3dFE8HWJICes1ljhmq3lEHlMNI+RRI/B/nfwhj7pydJ2/gI1ruJvtkFOVGsDR8IR8G
         Qu9SopBKJJeUHeAyQMuB+fiUkR+60O39luRPwP/arM8BnMGlETYM1HpqwAz8XSUeEEbh
         mXTRQzYqk3BeZSgujRIqbYrBkNMaewLo9KO2/c1HFnRhNTfaOlfbhtJAyAQSlPC+VkAe
         qzaFnRiICuWeXycPMtZKcme4Lf6MXDxNggPuHp8bzUnNk0WdtbUB7CRBr/zqT3G0HgzX
         oVBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vIiue0Eegphd4TqHDxcJLHie9gRriJxojR2XQBDT6w0=;
        b=xWy9iUsZps6LoBBRDaRjfmqkRgnwXi2N/ux13/DB05SfIoUM4TAYDFHBE1s2yqWer+
         Pmh0e8lrbo+TkQ9Z9rXHG66VUYU6IfQjHYZ4aMKo5Oa0/nQ0vNLVAzY0UswmfoLYsxN3
         XWPZdBpab+9+3X2F95PLvDlnAPJOV5Y2hz6PqC1o7txPzrRUPVz70VYeQEII/M97FlcJ
         f93gWfqAOvQwk2NILpbUItphfL+7/rNKtw1HhOQuKOhYZ5CLoRh2q9y/xgYmlQ2NbID3
         pLAV9TbqAHJ5FF8DtstAbj+qaEyWuL/IeUdTCTJkJIBf/DZ55CzYCG8mSmFsRtPEIRfF
         N2hg==
X-Gm-Message-State: AFqh2kpTCsRgBTLKthERUjZHY3Sb3i8vCCxJYZouQvbpuR+T5MRvFjMN
        xgwYhKrtH8BwpZVzKdTDtN5mrw==
X-Google-Smtp-Source: AMrXdXs8b2TseWYBCteYL66mSyLYaf6awgzq9icYhPo3wywKaFj1qqYe4U38kv3tpza48CcUHF8n6Q==
X-Received: by 2002:a05:6402:1055:b0:467:c3cb:49aa with SMTP id e21-20020a056402105500b00467c3cb49aamr1846132edu.4.1671636349931;
        Wed, 21 Dec 2022 07:25:49 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id n19-20020aa7c793000000b0045cf4f72b04sm7105428eds.94.2022.12.21.07.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 07:25:49 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 10/18] can: m_can: Implement transmit coalescing
Date:   Wed, 21 Dec 2022 16:25:29 +0100
Message-Id: <20221221152537.751564-11-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221152537.751564-1-msp@baylibre.com>
References: <20221221152537.751564-1-msp@baylibre.com>
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
index 2e664313101b..a84a17386c02 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -254,6 +254,7 @@ enum m_can_reg {
 #define TXESC_TBDS_64B		0x7
 
 /* Tx Event FIFO Configuration (TXEFC) */
+#define TXEFC_EFWM_MASK		GENMASK(29, 24)
 #define TXEFC_EFS_MASK		GENMASK(21, 16)
 
 /* Tx Event FIFO Status (TXEFS) */
@@ -1070,7 +1071,7 @@ static void m_can_interrupt_enable(struct m_can_classdev *cdev, u32 interrupts)
 
 static void m_can_coalescing_disable(struct m_can_classdev *cdev)
 {
-	u32 new_interrupts = cdev->active_interrupts | IR_RF0N;
+	u32 new_interrupts = cdev->active_interrupts | IR_RF0N | IR_TEFN;
 
 	hrtimer_cancel(&cdev->irq_timer);
 	m_can_interrupt_enable(cdev, new_interrupts);
@@ -1079,21 +1080,26 @@ static void m_can_coalescing_disable(struct m_can_classdev *cdev)
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
@@ -1148,7 +1154,7 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 			netif_wake_queue(dev);
 		}
 	} else  {
-		if (ir & IR_TEFN) {
+		if (ir & (IR_TEFN | IR_TEFW)) {
 			/* New TX FIFO Element arrived */
 			if (m_can_echo_tx_event(dev) != 0)
 				goto out_fail;
@@ -1309,9 +1315,8 @@ static void m_can_chip_config(struct net_device *dev)
 	u32 interrupts = IR_ALL_INT;
 
 	/* Disable unused interrupts */
-	interrupts &= ~(IR_ARA | IR_ELO | IR_DRX | IR_TEFF | IR_TEFW | IR_TFE |
-			IR_TCF | IR_HPM | IR_RF1F | IR_RF1W | IR_RF1N |
-			IR_RF0F);
+	interrupts &= ~(IR_ARA | IR_ELO | IR_DRX | IR_TEFF | IR_TFE | IR_TCF |
+			IR_HPM | IR_RF1F | IR_RF1W | IR_RF1N | IR_RF0F);
 
 	m_can_config_endisable(cdev, true);
 
@@ -1348,6 +1353,8 @@ static void m_can_chip_config(struct net_device *dev)
 	} else {
 		/* Full TX Event FIFO is used */
 		m_can_write(cdev, M_CAN_TXEFC,
+			    FIELD_PREP(TXEFC_EFWM_MASK,
+				       cdev->tx_max_coalesced_frames_irq) |
 			    FIELD_PREP(TXEFC_EFS_MASK,
 				       cdev->mcfg[MRAM_TXE].num) |
 			    cdev->mcfg[MRAM_TXE].off);
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index 4943e1e9aff0..62631a613076 100644
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
2.38.1

