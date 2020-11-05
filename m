Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4E52A85EF
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731972AbgKESOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731746AbgKESOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 13:14:21 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008EEC061A4A
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 10:14:20 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id n12so2757194ioc.2
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 10:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CLD0TDN5U5ictzlX9lH1ciOecwDXrfrRRemjaW/v3i0=;
        b=u64jzCqqaixWJC6t2lJeqLSd4xcl89rF3YPmKTn029bJMELQ54uErsCnqkm2Qylhyn
         286akHNZx9iuUmMfQVuPKL8f5lC9tDZ2IFq7UA6j/g4vkI2U29CF2/bV++e9qZyCPTh5
         IS+VgeUSZcwqlwMcwtzEOhYIunox+utAWDmFIKM3HtdQrlgu8+ZgCFvG0cl4rUtMkQkW
         HPowKtfbJ1nlh9Q5/iS9GdiSlPaTTaSKkqhcqgNEPgO1v9oPD1+32fdeKcpBT2ifWBe1
         JQfoKjT/JqTKBoPTbttCJCpgI//6WFaHhT6TED8y0na8mH3kKLkrgcflil2ClOzi5Z/f
         8rBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CLD0TDN5U5ictzlX9lH1ciOecwDXrfrRRemjaW/v3i0=;
        b=hNu5b1ZTojpuScLMU0G2Zgvt4YUaVrJ9qifyuR0gw3PzehvINQEWUbsyC+OhM+XPSO
         jXpCD4INgRjU56wNHPAZSjebe0GQOQo7q+qdhX0Zq7548ncB/Ajf/AcxIRFEkl7opos2
         LFnhjXuGj/gQN1lTHootTRIn5tiUt/dqJF0/XCU2+HwWc+rCfH+//1tjYMjMsN7NVm76
         4ZSMfsle+kM38UKJFOhul3tX/M+FRS4rhvbXICq/iU7rzWvs/VefLeHw3Mx+c8NaJmju
         K4LHw2fb0bajHRTMmp9hbCclv9bjVhYXJGowwh9hX/aphyzFKkIgakURx9Yo/Gf7rpRu
         8hWw==
X-Gm-Message-State: AOAM530lKnI9e6JNTuy2t5cmyHQ520shLqLXQ7qD393Aq4Jymw7KgKce
        bFK9ZMVFSOJ1FeLpSOPtxA1Nug==
X-Google-Smtp-Source: ABdhPJxYbXQevkKnd9BXD7h+eFEQzWjKsAPxYX5dRURy5deiR3tpkMgkQu0cGsjxPNXTMZjPx3ZEIw==
X-Received: by 2002:a02:2e45:: with SMTP id u5mr3019150jae.81.1604600060386;
        Thu, 05 Nov 2020 10:14:20 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o19sm1554136ilt.24.2020.11.05.10.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 10:14:19 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 06/13] net: ipa: cache last-saved GSI IRQ enabled type
Date:   Thu,  5 Nov 2020 12:14:00 -0600
Message-Id: <20201105181407.8006-7-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201105181407.8006-1-elder@linaro.org>
References: <20201105181407.8006-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Keep track of the set of GSI interrupt types that are currently
enabled by recording the mask value to write (or last written) to
the TYPE_IRQ_MSK register.

Create a new helper function gsi_irq_type_update() to handle
actually writing the register.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 35 +++++++++++++++++++++++------------
 drivers/net/ipa/gsi.h |  1 +
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 669d7496f8bdb..f76b5a1e1f8d5 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -230,16 +230,25 @@ static u32 gsi_channel_id(struct gsi_channel *channel)
 	return channel - &channel->gsi->channel[0];
 }
 
+/* Update the GSI IRQ type register with the cached value */
+static void gsi_irq_type_update(struct gsi *gsi)
+{
+	iowrite32(gsi->type_enabled_bitmap,
+		  gsi->virt + GSI_CNTXT_TYPE_IRQ_MSK_OFFSET);
+}
+
 /* Turn off all GSI interrupts initially */
 static void gsi_irq_setup(struct gsi *gsi)
 {
-	iowrite32(0, gsi->virt + GSI_CNTXT_TYPE_IRQ_MSK_OFFSET);
+	gsi->type_enabled_bitmap = 0;
+	gsi_irq_type_update(gsi);
 }
 
 /* Turn off all GSI interrupts when we're all done */
 static void gsi_irq_teardown(struct gsi *gsi)
 {
-	iowrite32(0, gsi->virt + GSI_CNTXT_TYPE_IRQ_MSK_OFFSET);
+	gsi->type_enabled_bitmap = 0;
+	gsi_irq_type_update(gsi);
 }
 
 static void gsi_irq_ieob_enable(struct gsi *gsi, u32 evt_ring_id)
@@ -267,34 +276,36 @@ static void gsi_irq_enable(struct gsi *gsi)
 
 	val = GENMASK(gsi->channel_count - 1, 0);
 	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
+	gsi->type_enabled_bitmap |= BIT(GSI_CH_CTRL);
 
 	val = GENMASK(gsi->evt_ring_count - 1, 0);
 	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET);
+	gsi->type_enabled_bitmap |= BIT(GSI_EV_CTRL);
 
 	/* Each IEOB interrupt is enabled (later) as needed by channels */
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
+	gsi->type_enabled_bitmap |= BIT(GSI_IEOB);
 
 	val = GSI_CNTXT_GLOB_IRQ_ALL;
 	iowrite32(val, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
+	gsi->type_enabled_bitmap |= BIT(GSI_GLOB_EE);
+
+	/* We don't use inter-EE channel or event interrupts */
 
 	/* Never enable GSI_BREAK_POINT */
 	val = GSI_CNTXT_GSI_IRQ_ALL & ~BREAK_POINT_FMASK;
 	iowrite32(val, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
+	gsi->type_enabled_bitmap |= BIT(GSI_GENERAL);
 
-	/* Finally enable the interrupt types we use */
-	val = BIT(GSI_CH_CTRL);
-	val |= BIT(GSI_EV_CTRL);
-	val |= BIT(GSI_GLOB_EE);
-	val |= BIT(GSI_IEOB);
-	/* We don't use inter-EE channel or event interrupts */
-	val |= BIT(GSI_GENERAL);
-	iowrite32(val, gsi->virt + GSI_CNTXT_TYPE_IRQ_MSK_OFFSET);
+	/* Finally update the interrupt types we want enabled */
+	gsi_irq_type_update(gsi);
 }
 
-/* Disable all GSI_interrupt types */
+/* Disable all GSI interrupt types */
 static void gsi_irq_disable(struct gsi *gsi)
 {
-	iowrite32(0, gsi->virt + GSI_CNTXT_TYPE_IRQ_MSK_OFFSET);
+	gsi->type_enabled_bitmap = 0;
+	gsi_irq_type_update(gsi);
 
 	iowrite32(0, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
 	iowrite32(0, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index fa7e2d35c19cb..758125737c8e9 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -158,6 +158,7 @@ struct gsi {
 	struct gsi_evt_ring evt_ring[GSI_EVT_RING_COUNT_MAX];
 	u32 event_bitmap;		/* allocated event rings */
 	u32 modem_channel_bitmap;	/* modem channels to allocate */
+	u32 type_enabled_bitmap;	/* GSI IRQ types enabled */
 	u32 ieob_enabled_bitmap;	/* IEOB IRQ enabled (event rings) */
 	struct completion completion;	/* for global EE commands */
 	struct mutex mutex;		/* protects commands, programming */
-- 
2.20.1

