Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B792C3DEF8D
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbhHCOBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236436AbhHCOBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:01:22 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CEDC061798
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 07:01:11 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id a14so19587464ila.1
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 07:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jTGvfFyrFctJIWi/cCKby6tPrdVdtZKue9ulwhsCP2w=;
        b=H5/W9PO44intcwnyeGgl/bJL25N3vDbYZSSweM7vIW9mVsNmi9JwcZ/PRsBLsRjCOH
         N3C3/GrK/SY/qgWjtnig6HjSHPU2ZA5f2Q5DHzPkZZP/47ljq2DEOBm06vWu3iwgufsE
         mAH6AehWcXX8aQQ6xQosMSTkCw1H3tnme1XtqCs9ablEtqn0JFVI1ZEKigvLhlMeN1MO
         I1m6mK4WY+z3kTf29KCsszdQYcKMszPjK/DmqyzP/SfN2OxBKBKHWUTnZTuydYFUg4N/
         897L9rsMtRJrjbhg7NleGS9Nwe7arcsYExqFRtamM0P0vvr9SYqjpdBa3Z8tn+SgiJOx
         8pEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jTGvfFyrFctJIWi/cCKby6tPrdVdtZKue9ulwhsCP2w=;
        b=hmrEZvYpbwWiW275Yi9Su7aoszFIXnjnaCXN5Nuxscv6Igh5BBFuLkzu7lnOirdj7A
         X8jU8YMTGAmGuKUh35OkrfsaFlgjkHTyGfC9jZcpQkGb9SCbKKELugPe3WM2H2lpeKl5
         iEFnbXS3bT5nBrwY2ZM2HY22x3r6fq5OG2nSu/DTBduXeZDNpC4Rm5DKi66MNRY0PyHk
         hPtx0qrRFbqQ0RFcOUfeapXh4iN2Si/celfWWehhqInjYDoiYGMjLT7NDsajYVXxc7mK
         UcGhyKE216037sTTvhCF5lB46vhXBoLoJYYtn1FBlJbif3dn2AiSFTrCOUDtTF0AvkUy
         dZ4w==
X-Gm-Message-State: AOAM533DIZbCdIgnZQTvWYfQ0dxkuEbQHTttta6zTbsstP841Y+CDO0x
        I2FObqUIsCEUEL9lds6GogNS7w==
X-Google-Smtp-Source: ABdhPJzXaDHcrYwSFGAtXzT456Uq7qmbhya9QdfSmEyPKRd1a5Hka0nqZVdqAQ5xLVIywI6hyGA86w==
X-Received: by 2002:a92:cd50:: with SMTP id v16mr736836ilq.141.1627999271035;
        Tue, 03 Aug 2021 07:01:11 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w7sm9456798iox.1.2021.08.03.07.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 07:01:10 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] net: ipa: move some GSI setup functions
Date:   Tue,  3 Aug 2021 09:01:00 -0500
Message-Id: <20210803140103.1012697-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210803140103.1012697-1-elder@linaro.org>
References: <20210803140103.1012697-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move gsi_irq_setup() and gsi_ring_setup() so they're defined right
above gsi_setup() where they're called.  This is a trivial movement
of code to prepare for upcoming patches.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 142 +++++++++++++++++++++---------------------
 1 file changed, 71 insertions(+), 71 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 5c5a2571d2faf..a5d23a2837cb6 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -198,77 +198,6 @@ static void gsi_irq_type_disable(struct gsi *gsi, enum gsi_irq_type_id type_id)
 	gsi_irq_type_update(gsi, gsi->type_enabled_bitmap & ~BIT(type_id));
 }
 
-/* Turn off all GSI interrupts initially; there is no gsi_irq_teardown() */
-static void gsi_irq_setup(struct gsi *gsi)
-{
-	/* Disable all interrupt types */
-	gsi_irq_type_update(gsi, 0);
-
-	/* Clear all type-specific interrupt masks */
-	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
-	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
-	iowrite32(0, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
-	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
-
-	/* The inter-EE interrupts are not supported for IPA v3.0-v3.1 */
-	if (gsi->version > IPA_VERSION_3_1) {
-		u32 offset;
-
-		/* These registers are in the non-adjusted address range */
-		offset = GSI_INTER_EE_SRC_CH_IRQ_MSK_OFFSET;
-		iowrite32(0, gsi->virt_raw + offset);
-		offset = GSI_INTER_EE_SRC_EV_CH_IRQ_MSK_OFFSET;
-		iowrite32(0, gsi->virt_raw + offset);
-	}
-
-	iowrite32(0, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
-}
-
-/* Get # supported channel and event rings; there is no gsi_ring_teardown() */
-static int gsi_ring_setup(struct gsi *gsi)
-{
-	struct device *dev = gsi->dev;
-	u32 count;
-	u32 val;
-
-	if (gsi->version < IPA_VERSION_3_5_1) {
-		/* No HW_PARAM_2 register prior to IPA v3.5.1, assume the max */
-		gsi->channel_count = GSI_CHANNEL_COUNT_MAX;
-		gsi->evt_ring_count = GSI_EVT_RING_COUNT_MAX;
-
-		return 0;
-	}
-
-	val = ioread32(gsi->virt + GSI_GSI_HW_PARAM_2_OFFSET);
-
-	count = u32_get_bits(val, NUM_CH_PER_EE_FMASK);
-	if (!count) {
-		dev_err(dev, "GSI reports zero channels supported\n");
-		return -EINVAL;
-	}
-	if (count > GSI_CHANNEL_COUNT_MAX) {
-		dev_warn(dev, "limiting to %u channels; hardware supports %u\n",
-			 GSI_CHANNEL_COUNT_MAX, count);
-		count = GSI_CHANNEL_COUNT_MAX;
-	}
-	gsi->channel_count = count;
-
-	count = u32_get_bits(val, NUM_EV_PER_EE_FMASK);
-	if (!count) {
-		dev_err(dev, "GSI reports zero event rings supported\n");
-		return -EINVAL;
-	}
-	if (count > GSI_EVT_RING_COUNT_MAX) {
-		dev_warn(dev,
-			 "limiting to %u event rings; hardware supports %u\n",
-			 GSI_EVT_RING_COUNT_MAX, count);
-		count = GSI_EVT_RING_COUNT_MAX;
-	}
-	gsi->evt_ring_count = count;
-
-	return 0;
-}
-
 /* Event ring commands are performed one at a time.  Their completion
  * is signaled by the event ring control GSI interrupt type, which is
  * only enabled when we issue an event ring command.  Only the event
@@ -1878,6 +1807,77 @@ static void gsi_channel_teardown(struct gsi *gsi)
 	gsi_irq_disable(gsi);
 }
 
+/* Turn off all GSI interrupts initially; there is no gsi_irq_teardown() */
+static void gsi_irq_setup(struct gsi *gsi)
+{
+	/* Disable all interrupt types */
+	gsi_irq_type_update(gsi, 0);
+
+	/* Clear all type-specific interrupt masks */
+	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
+	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
+	iowrite32(0, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
+	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
+
+	/* The inter-EE interrupts are not supported for IPA v3.0-v3.1 */
+	if (gsi->version > IPA_VERSION_3_1) {
+		u32 offset;
+
+		/* These registers are in the non-adjusted address range */
+		offset = GSI_INTER_EE_SRC_CH_IRQ_MSK_OFFSET;
+		iowrite32(0, gsi->virt_raw + offset);
+		offset = GSI_INTER_EE_SRC_EV_CH_IRQ_MSK_OFFSET;
+		iowrite32(0, gsi->virt_raw + offset);
+	}
+
+	iowrite32(0, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
+}
+
+/* Get # supported channel and event rings; there is no gsi_ring_teardown() */
+static int gsi_ring_setup(struct gsi *gsi)
+{
+	struct device *dev = gsi->dev;
+	u32 count;
+	u32 val;
+
+	if (gsi->version < IPA_VERSION_3_5_1) {
+		/* No HW_PARAM_2 register prior to IPA v3.5.1, assume the max */
+		gsi->channel_count = GSI_CHANNEL_COUNT_MAX;
+		gsi->evt_ring_count = GSI_EVT_RING_COUNT_MAX;
+
+		return 0;
+	}
+
+	val = ioread32(gsi->virt + GSI_GSI_HW_PARAM_2_OFFSET);
+
+	count = u32_get_bits(val, NUM_CH_PER_EE_FMASK);
+	if (!count) {
+		dev_err(dev, "GSI reports zero channels supported\n");
+		return -EINVAL;
+	}
+	if (count > GSI_CHANNEL_COUNT_MAX) {
+		dev_warn(dev, "limiting to %u channels; hardware supports %u\n",
+			 GSI_CHANNEL_COUNT_MAX, count);
+		count = GSI_CHANNEL_COUNT_MAX;
+	}
+	gsi->channel_count = count;
+
+	count = u32_get_bits(val, NUM_EV_PER_EE_FMASK);
+	if (!count) {
+		dev_err(dev, "GSI reports zero event rings supported\n");
+		return -EINVAL;
+	}
+	if (count > GSI_EVT_RING_COUNT_MAX) {
+		dev_warn(dev,
+			 "limiting to %u event rings; hardware supports %u\n",
+			 GSI_EVT_RING_COUNT_MAX, count);
+		count = GSI_EVT_RING_COUNT_MAX;
+	}
+	gsi->evt_ring_count = count;
+
+	return 0;
+}
+
 /* Setup function for GSI.  GSI firmware must be loaded and initialized */
 int gsi_setup(struct gsi *gsi)
 {
-- 
2.27.0

