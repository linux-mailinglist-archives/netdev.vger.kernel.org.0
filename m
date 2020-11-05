Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74FF2A85F0
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732260AbgKESPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732002AbgKESOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 13:14:24 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF847C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 10:14:23 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id y17so2222198ilg.4
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 10:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DUVWkaJcfOkuDCAV2Fn6/P4D6HwwSj/ewkT/2xXQGog=;
        b=GY+O6d8S/P3PXdDXbSmb+5atuaULQINMGsN/7awyctX7XuxuiGE1nYtFG7hQC8Mchd
         KNXpMI9Dsluk6tpzWK7sez2WZKSAlOGK89/W0JSku6JAUVWklAbhnJOU0zq4qmOs9XqU
         4Ym2vKQxv5xmXEU31OxYrFnan5pOXH6cwsB1Qf7HEhwGwfEWc4nbkUOLf5SG/rp4Zuxg
         X3RApMsmPySr4E+ikY7r8VpfNmo3uF172GJm1ZCN/YIdsOa9rROfOQKhyyymbtQZJxxO
         zUXOrx5lePra5PPktpfA4PcRvpoOuzGYPdESdD/VLTsEvo+aKTLHFQqJRRmW17sxdJwG
         NU4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DUVWkaJcfOkuDCAV2Fn6/P4D6HwwSj/ewkT/2xXQGog=;
        b=K8n8uLhaKtDYgW/7WDPHkZNVQmuzs301oNAJ5bNBFeI48l/fkoxNm4owFUss3CoR4Z
         W2pmaGycFxwyqea1XP2GkMqD5w4GtgctstGkY+LzXusObSt4MfixlS0rdSxspDM9TX1U
         qqHg6XwJbp2X1kr+T1Obpw/Srl+iKwBuUqh2iDz5OlrO5mjYNhZPwHZdyYKxrYPsmkbH
         Xf2nrS2HDI2LWMMoWSGRW/isZeRAgPtYWnNYMGeE0wTw3+so7rg95AGcFC8hazpX4vK0
         Tu1bB1bTNqhie+WvyjSm44Apm4Togwz6DrmQYIFrGOgVHGcVwcxsQ6rtRqWBIawFECnP
         MRrg==
X-Gm-Message-State: AOAM531wxbXlYIC96g0JRarq9jMT1rR3L+CgR2iPgYJJ/K2D7GYQO/mW
        6+VU6vni+UG+eJFdkh5qcs4KaQ==
X-Google-Smtp-Source: ABdhPJwBH2MnUlQgldexo2R1LYzUIcKeJcOlvKhlqX9lEsqi5tSvBEc9FgIi4wkIzXfPKwfCK3P17g==
X-Received: by 2002:a92:d6cd:: with SMTP id z13mr2886937ilp.38.1604600063334;
        Thu, 05 Nov 2020 10:14:23 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o19sm1554136ilt.24.2020.11.05.10.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 10:14:22 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 08/13] net: ipa: only enable GSI event control IRQs when needed
Date:   Thu,  5 Nov 2020 12:14:02 -0600
Message-Id: <20201105181407.8006-9-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201105181407.8006-1-elder@linaro.org>
References: <20201105181407.8006-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A GSI event ring causes an event control interrupt to fire whenever
its state changes (between NOT_ALLOCATED and ALLOCATED).  No event
ring should ever change state except when we request it to.

Currently, we permit *all* events rings to generate event control
interrupts--even those that are never used.  And we enable event
control interrupts essentially at all times, from setup to teardown.

Instead, only enable the event control interrupt type for the
duration of an event ring command, and when doing so, only allow
the event ring being operated upon to cause the interrupt to fire.
Disallow all event rings from issuing the event control interrupt
in gsi_irq_setup().

Because an event ring's interrupt is only enabled when needed,
there is no longer any need to zero the event channel mask in
gsi_irq_disable().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 4fc72dfe1e9b0..2c01a04e07b70 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -256,6 +256,7 @@ static void gsi_irq_setup(struct gsi *gsi)
 	gsi_irq_type_update(gsi);
 
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
+	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
 }
 
 /* Turn off all GSI interrupts when we're all done */
@@ -288,10 +289,6 @@ static void gsi_irq_enable(struct gsi *gsi)
 {
 	u32 val;
 
-	val = GENMASK(gsi->evt_ring_count - 1, 0);
-	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
-	gsi->type_enabled_bitmap |= BIT(GSI_EV_CTRL);
-
 	/* Each IEOB interrupt is enabled (later) as needed by channels */
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
 	gsi->type_enabled_bitmap |= BIT(GSI_IEOB);
@@ -320,7 +317,6 @@ static void gsi_irq_disable(struct gsi *gsi)
 	iowrite32(0, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
 	iowrite32(0, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
-	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
 }
 
 /* Return the virtual address associated with a ring index */
@@ -374,13 +370,30 @@ static int evt_ring_command(struct gsi *gsi, u32 evt_ring_id,
 	struct gsi_evt_ring *evt_ring = &gsi->evt_ring[evt_ring_id];
 	struct completion *completion = &evt_ring->completion;
 	struct device *dev = gsi->dev;
+	bool success;
 	u32 val;
 
+	/* We only perform one event ring command at a time, and event
+	 * control interrupts should only occur when such a command
+	 * is issued here.  Only permit *this* event ring to trigger
+	 * an interrupt, and only enable the event control IRQ type
+	 * when we expect it to occur.
+	 */
+	val = BIT(evt_ring_id);
+	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
+	gsi_irq_type_enable(gsi, GSI_EV_CTRL);
+
 	val = u32_encode_bits(evt_ring_id, EV_CHID_FMASK);
 	val |= u32_encode_bits(opcode, EV_OPCODE_FMASK);
 
-	if (gsi_command(gsi, GSI_EV_CH_CMD_OFFSET, val, completion))
-		return 0;	/* Success! */
+	success = gsi_command(gsi, GSI_EV_CH_CMD_OFFSET, val, completion);
+
+	/* Disable the interrupt again */
+	gsi_irq_type_disable(gsi, GSI_EV_CTRL);
+	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
+
+	if (success)
+		return 0;
 
 	dev_err(dev, "GSI command %u for event ring %u timed out, state %u\n",
 		opcode, evt_ring_id, evt_ring->state);
-- 
2.20.1

