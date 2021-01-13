Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389942F50D9
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 18:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbhAMRQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 12:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727988AbhAMRQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 12:16:53 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B0BC0617A3
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 09:15:39 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id z5so5569997iob.11
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 09:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GXvZPSGq6x3yeoMxoYd+JlpMOpfBxN00Vmli9SdjOe4=;
        b=xXal6/FBYvLJt9S3Aum1Mf3YrBTGnLOJkLzQ1bFhtl6Jgg7XxrBNvHLTkSGE5IcYzT
         S7EstxEHuf6Tk+5ZD16TsO7bbyBuU7bpzUUUmXsXgq98YFPCEkw9RTCIUP1VNaI4fykw
         W7/wup2Kk4Ksdtq+Q5E140LGW2bdqsc8CJRJWMUCAWZkTHLXNYjitx+5rIWMzARgJXwV
         LoIOcquX6A0K+f6uid+H7G1Nn5xpQt+3jXa3JX4taT0eEeZ+PVXp/Dhv0zwkBx71890F
         MvvaxHoRY1r+tA0nm5B5krkv84Hhr5ErtUvsseHRxKHEfPl2lGQGJ0r/G1lehygSYZnd
         2vhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GXvZPSGq6x3yeoMxoYd+JlpMOpfBxN00Vmli9SdjOe4=;
        b=XXO/2mGFHfkFr9HCNSG6mrjQ/Lz4D3EbXGiW7v/dMqtkq1P7x57aJfHM+iQnSgybqm
         7j3CLKW24K/mk4CUBxwM92q/s8EG+D4WOEzqve0NADzxVwXSBx3rX4iiKpH9ZvHA56h2
         n07h5RZyr6kyIxfNSqZORqOSaDhC1R+7EGs3Jhc/emi1805pj3xKHF9VTyebqvDhJta8
         IVP+k1x9JY7zGHiHEzlU9qyV4/3AP9lkHVJQgzXpwBz8Yo2nMw+bPYvZaepd7Wxoyqrv
         FfkZsf2BBNnRgVCRbQjlA4CH5u3LalyAGZL2hBy5z3cAdrTNsYewq3/9QUqzHbZi10ed
         4Frw==
X-Gm-Message-State: AOAM533RFSY2bP9Gfk753cHjL24XNk9J2XJG8SWeHzuHBE1DJyC6r0HV
        C11oiL9XKyCVJvylXKFx8mJbIQ==
X-Google-Smtp-Source: ABdhPJy6/3uTg/SGPGO8lmIATCEf7rvP3WZKgI+71wO7E0jKmQJ1Lq1E94TnUSM51Xm2bv/nxjDZ5w==
X-Received: by 2002:a92:db52:: with SMTP id w18mr2517597ilq.56.1610558138911;
        Wed, 13 Jan 2021 09:15:38 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h9sm1120579ili.43.2021.01.13.09.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 09:15:38 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/6] net: ipa: introduce some interrupt helpers
Date:   Wed, 13 Jan 2021 11:15:28 -0600
Message-Id: <20210113171532.19248-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210113171532.19248-1-elder@linaro.org>
References: <20210113171532.19248-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new function gsi_irq_ev_ctrl_enable() that encapsulates
enabling the event ring control GSI interrupt type, and enables a
single event ring to signal that interrupt.  When an event ring
changes state as a result of an event ring command, it triggers this
interrupt.

Create an inverse function gsi_irq_ev_ctrl_disable() as well.
Because only one event ring at a time is enabled for this interrupt,
we can simply disable the interrupt for *all* channels.

Create a pair of helpers that serve the same purpose for channel
commands.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 94 ++++++++++++++++++++++++++-----------------
 1 file changed, 58 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index b5913ce0bc943..e5681a39b5fc6 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -220,6 +220,58 @@ static void gsi_irq_teardown(struct gsi *gsi)
 	/* Nothing to do */
 }
 
+/* Event ring commands are performed one at a time.  Their completion
+ * is signaled by the event ring control GSI interrupt type, which is
+ * only enabled when we issue an event ring command.  Only the event
+ * ring being operated on has this interrupt enabled.
+ */
+static void gsi_irq_ev_ctrl_enable(struct gsi *gsi, u32 evt_ring_id)
+{
+	u32 val = BIT(evt_ring_id);
+
+	/* There's a small chance that a previous command completed
+	 * after the interrupt was disabled, so make sure we have no
+	 * pending interrupts before we enable them.
+	 */
+	iowrite32(~0, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_CLR_OFFSET);
+
+	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
+	gsi_irq_type_enable(gsi, GSI_EV_CTRL);
+}
+
+/* Disable event ring control interrupts */
+static void gsi_irq_ev_ctrl_disable(struct gsi *gsi)
+{
+	gsi_irq_type_disable(gsi, GSI_EV_CTRL);
+	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
+}
+
+/* Channel commands are performed one at a time.  Their completion is
+ * signaled by the channel control GSI interrupt type, which is only
+ * enabled when we issue a channel command.  Only the channel being
+ * operated on has this interrupt enabled.
+ */
+static void gsi_irq_ch_ctrl_enable(struct gsi *gsi, u32 channel_id)
+{
+	u32 val = BIT(channel_id);
+
+	/* There's a small chance that a previous command completed
+	 * after the interrupt was disabled, so make sure we have no
+	 * pending interrupts before we enable them.
+	 */
+	iowrite32(~0, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_CLR_OFFSET);
+
+	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
+	gsi_irq_type_enable(gsi, GSI_CH_CTRL);
+}
+
+/* Disable channel control interrupts */
+static void gsi_irq_ch_ctrl_disable(struct gsi *gsi)
+{
+	gsi_irq_type_disable(gsi, GSI_CH_CTRL);
+	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
+}
+
 static void gsi_irq_ieob_enable(struct gsi *gsi, u32 evt_ring_id)
 {
 	bool enable_ieob = !gsi->ieob_enabled_bitmap;
@@ -335,30 +387,15 @@ static void gsi_evt_ring_command(struct gsi *gsi, u32 evt_ring_id,
 	bool timeout;
 	u32 val;
 
-	/* We only perform one event ring command at a time, and event
-	 * control interrupts should only occur when such a command
-	 * is issued here.  Only permit *this* event ring to trigger
-	 * an interrupt, and only enable the event control IRQ type
-	 * when we expect it to occur.
-	 *
-	 * There's a small chance that a previous command completed
-	 * after the interrupt was disabled, so make sure we have no
-	 * pending interrupts before we enable them.
-	 */
-	iowrite32(~0, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_CLR_OFFSET);
-
-	val = BIT(evt_ring_id);
-	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
-	gsi_irq_type_enable(gsi, GSI_EV_CTRL);
+	/* Enable the completion interrupt for the command */
+	gsi_irq_ev_ctrl_enable(gsi, evt_ring_id);
 
 	val = u32_encode_bits(evt_ring_id, EV_CHID_FMASK);
 	val |= u32_encode_bits(opcode, EV_OPCODE_FMASK);
 
 	timeout = !gsi_command(gsi, GSI_EV_CH_CMD_OFFSET, val, completion);
 
-	/* Disable the interrupt again */
-	gsi_irq_type_disable(gsi, GSI_EV_CTRL);
-	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
+	gsi_irq_ev_ctrl_disable(gsi);
 
 	if (!timeout)
 		return;
@@ -459,29 +496,14 @@ gsi_channel_command(struct gsi_channel *channel, enum gsi_ch_cmd_opcode opcode)
 	bool timeout;
 	u32 val;
 
-	/* We only perform one channel command at a time, and channel
-	 * control interrupts should only occur when such a command is
-	 * issued here.  So we only permit *this* channel to trigger
-	 * an interrupt and only enable the channel control IRQ type
-	 * when we expect it to occur.
-	 *
-	 * There's a small chance that a previous command completed
-	 * after the interrupt was disabled, so make sure we have no
-	 * pending interrupts before we enable them.
-	 */
-	iowrite32(~0, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_CLR_OFFSET);
-
-	val = BIT(channel_id);
-	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
-	gsi_irq_type_enable(gsi, GSI_CH_CTRL);
+	/* Enable the completion interrupt for the command */
+	gsi_irq_ch_ctrl_enable(gsi, channel_id);
 
 	val = u32_encode_bits(channel_id, CH_CHID_FMASK);
 	val |= u32_encode_bits(opcode, CH_OPCODE_FMASK);
 	timeout = !gsi_command(gsi, GSI_CH_CMD_OFFSET, val, completion);
 
-	/* Disable the interrupt again */
-	gsi_irq_type_disable(gsi, GSI_CH_CTRL);
-	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
+	gsi_irq_ch_ctrl_disable(gsi);
 
 	if (!timeout)
 		return;
-- 
2.20.1

