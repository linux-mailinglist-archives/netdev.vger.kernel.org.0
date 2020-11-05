Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3A52A85E1
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732030AbgKESOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731964AbgKESOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 13:14:22 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7911FC0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 10:14:22 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id u21so2724019iol.12
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 10:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fu48RAzzMMR4ItX7OzUw943cvMlgXykDKz6gYMlK0dA=;
        b=LnPcbDfCHyemuVLs43uVIYo680gzVWSzUE1EUFgZ9XEeZ/Rl8NYQoTU/5Vc0yY9jJ0
         lDYDOxjBBiPL0FZf5QJWpr21+eT7Dir6RoFga4zqYAR9NmimYlPj9hPLXMnZgpPpwYLC
         xv8/qtoThAdIKUN5unYGnY44sOQ4gP14sgajM59mf+qLm+KHIqsXJtfHZsAFyqsyFO42
         urhFHACZfYl92lqz/8XXFvaVtuDelRMHg+3TY33r7DKzEHqy/nzVN2Pwd3AkxGVkNpHL
         ithMoIn7SYfbx1hDbQSAz5YN0M8oJw616luy081+c1kvd6uRmP24fdKLdwQ8NRrNA253
         rXTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fu48RAzzMMR4ItX7OzUw943cvMlgXykDKz6gYMlK0dA=;
        b=tQVyZ3KXXABomjtFanuKZJ5eaOGgX1rA6IV/ygiIt6FqM4KQt38KyDVEMdWK5NpiKd
         MryILNSmTm3yRTo0Vgo6pQe9ix8hKEbFlqNBq5T9ANg/CEXjCKnlX3T5AGcCVDG0lK26
         u77bNGTC7STyBR3vik35OAGOv7va8V61d02ftnrznUqfKDxKmu3DStZaf50ctoKs1B/W
         cKb1uaLxCpJSeTGntUhvKhEIvF59LKgDXpUeYDqtebolqHw+/7Lg2Wq0hMa4aPg89f1L
         7SEVWl8lmnSTItSa5ym7JLM+aJ6w+D5blo84ijGSzYzSGPxgfyprnjw+HL9zQv5Fpmt/
         s7UQ==
X-Gm-Message-State: AOAM533ptMR6YcyvBEkxvUq938S1xcmbpmCgwywR0s8LafoQiTib2rXc
        HZ8evzQ4sSMAyD3K26vJ5W3CoQ==
X-Google-Smtp-Source: ABdhPJyr825eDARpYWQA/Fu15Gk5CLSa5JWUljh75jKuxUKN4r9ZLOV/g64cPqdvPnxkfZDavV6MwA==
X-Received: by 2002:a05:6638:120d:: with SMTP id n13mr3017379jas.35.1604600061840;
        Thu, 05 Nov 2020 10:14:21 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o19sm1554136ilt.24.2020.11.05.10.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 10:14:21 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 07/13] net: ipa: only enable GSI channel control IRQs when needed
Date:   Thu,  5 Nov 2020 12:14:01 -0600
Message-Id: <20201105181407.8006-8-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201105181407.8006-1-elder@linaro.org>
References: <20201105181407.8006-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A GSI channel causes a channel control interrupt to fire whenever
its state changes (between NOT_ALLOCATED, ALLOCATED, STARTED, etc.).
We do not support inter-EE channel commands (initiated by other EEs),
so no channel should ever change state except when we request it to.

Currently, we permit *all* channels to generate channel control
interrupts--even those that are never used.  And we enable channel
control interrupts essentially at all times, from setup to teardown.

Instead, disable all channel control interrupts initially in
gsi_irq_setup(), and only enable the channel control interrupt
type for the duration of a channel command.  When doing so, only
allow the channel being operated upon to cause the interrupt to
fire.

Because a channel's interrupt is now enabled only when needed (one
channel at a time), there is no longer any need to zero the channel
mask in gsi_irq_disable().

Add new gsi_irq_type_enable() and gsi_irq_type_disable() as helper
functions to control whether a given GSI interrupt type is enabled.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index f76b5a1e1f8d5..4fc72dfe1e9b0 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -237,11 +237,25 @@ static void gsi_irq_type_update(struct gsi *gsi)
 		  gsi->virt + GSI_CNTXT_TYPE_IRQ_MSK_OFFSET);
 }
 
+static void gsi_irq_type_enable(struct gsi *gsi, enum gsi_irq_type_id type_id)
+{
+	gsi->type_enabled_bitmap |= BIT(type_id);
+	gsi_irq_type_update(gsi);
+}
+
+static void gsi_irq_type_disable(struct gsi *gsi, enum gsi_irq_type_id type_id)
+{
+	gsi->type_enabled_bitmap &= ~BIT(type_id);
+	gsi_irq_type_update(gsi);
+}
+
 /* Turn off all GSI interrupts initially */
 static void gsi_irq_setup(struct gsi *gsi)
 {
 	gsi->type_enabled_bitmap = 0;
 	gsi_irq_type_update(gsi);
+
+	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
 }
 
 /* Turn off all GSI interrupts when we're all done */
@@ -274,10 +288,6 @@ static void gsi_irq_enable(struct gsi *gsi)
 {
 	u32 val;
 
-	val = GENMASK(gsi->channel_count - 1, 0);
-	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
-	gsi->type_enabled_bitmap |= BIT(GSI_CH_CTRL);
-
 	val = GENMASK(gsi->evt_ring_count - 1, 0);
 	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
 	gsi->type_enabled_bitmap |= BIT(GSI_EV_CTRL);
@@ -311,7 +321,6 @@ static void gsi_irq_disable(struct gsi *gsi)
 	iowrite32(0, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
-	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
 }
 
 /* Return the virtual address associated with a ring index */
@@ -461,13 +470,29 @@ gsi_channel_command(struct gsi_channel *channel, enum gsi_ch_cmd_opcode opcode)
 	u32 channel_id = gsi_channel_id(channel);
 	struct gsi *gsi = channel->gsi;
 	struct device *dev = gsi->dev;
+	bool success;
 	u32 val;
 
+	/* We only perform one channel command at a time, and channel
+	 * control interrupts should only occur when such a command is
+	 * issued here.  So we only permit *this* channel to trigger
+	 * an interrupt and only enable the channel control IRQ type
+	 * when we expect it to occur.
+	 */
+	val = BIT(channel_id);
+	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
+	gsi_irq_type_enable(gsi, GSI_CH_CTRL);
+
 	val = u32_encode_bits(channel_id, CH_CHID_FMASK);
 	val |= u32_encode_bits(opcode, CH_OPCODE_FMASK);
+	success = gsi_command(gsi, GSI_CH_CMD_OFFSET, val, completion);
 
-	if (gsi_command(gsi, GSI_CH_CMD_OFFSET, val, completion))
-		return 0;	/* Success! */
+	/* Disable the interrupt again */
+	gsi_irq_type_disable(gsi, GSI_CH_CTRL);
+	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
+
+	if (success)
+		return 0;
 
 	dev_err(dev, "GSI command %u for channel %u timed out, state %u\n",
 		opcode, channel_id, gsi_channel_state(channel));
-- 
2.20.1

