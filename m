Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCC4212237
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 13:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbgGBL0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 07:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbgGBLZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 07:25:44 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F0DC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 04:25:44 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id k23so28412891iom.10
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 04:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YLxlyC8xC2oohqQ3SQ/sJ9I/B5ThQ+eLGnUYm9WmZtk=;
        b=TYz0Jvutqptt2OJP3sa1jjDjKiNUvQZ7mxjNSqSwKzJG+Jxedzq1Xa652kPmD4t8Z+
         7mGzyY9KHnT/c4udkOl6SYTpASBxb+OtMG9CUf1bb8Z1leaRPGxwj5XnS3Dz0E3mXX1n
         U0U/7CnTyaaAxtohmq/XVwNuvJ8lDszu/kV5JGe4gK9OKTkzPtrpwXpkdhq+6URq60Ce
         8TyjK1IQT4RornDjJu+2uPttWRudqccVmQRS2J37rFmjPYArXdt6s6GhFApJR/2R8OTh
         rhWpsJknpKWMP4yQ00+DpLDmoIJUkDe0mVMrQkyDJwUO3Hn1dJBOEnexF5IjJgoWYjD9
         LUOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YLxlyC8xC2oohqQ3SQ/sJ9I/B5ThQ+eLGnUYm9WmZtk=;
        b=DKWHjQmWERAO5WIfMBQksL3h51+R9nLbUFpETMCypVdP4sqzlOE+8ZRO8R0fQCCYrK
         o8uG8TiSasiU0eh01Vv4BBaXiEcPK9Uiyt+eiadcpYSyIIeIP/3jgS+GUW5EEkHhYnim
         +zvxxv/3HftCNRZlrwF/ajyHk/WEK1qVgnN/bR3yM19iD+JOqkg2cm3Zk3FHDsVxr7Hj
         NB3YfMtvER8PrcFNRodRL38z83tJ3Y+TdLP7mfrl1XXDzaf/ch2bY/FzhvgyGFFDelkc
         RbpRELKZsAePR0gfYkJAZyq4hTWuYieBvo4HQiE8WxKjIMg9inXmtVcXR6NjLX2lrv8z
         ib4A==
X-Gm-Message-State: AOAM530lqqjA84j98JP9mOptxQRlwjNNwM6Zg0MNoq86S5rZRI7NuiOv
        CqvPK5f+9Y9D+2bQQ8UXP3wqCQ==
X-Google-Smtp-Source: ABdhPJz3TJtKCG/TK1CEIY5pjpNyL6ied9Er7csKDIw0l9vkaorc7+VhMsk4ejyDnpGI+J/OKCDZgA==
X-Received: by 2002:a02:b0d5:: with SMTP id w21mr21206761jah.27.1593689143741;
        Thu, 02 Jul 2020 04:25:43 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c3sm4692842ilj.31.2020.07.02.04.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 04:25:43 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/4] net: ipa: always handle suspend workaround
Date:   Thu,  2 Jul 2020 06:25:35 -0500
Message-Id: <20200702112537.347994-3-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702112537.347994-1-elder@linaro.org>
References: <20200702112537.347994-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA version 3.5.1 has a hardware quirk that requires special
handling if an RX endpoint is suspended while aggregation is active.
This handling is implemented by ipa_endpoint_suspend_aggr().

Have ipa_endpoint_program_suspend() be responsible for calling
ipa_endpoint_suspend_aggr() if suspend mode is being enabled on
an endpoint.  If the endpoint does not support aggregation, or if
aggregation isn't active, this call will continue to have no effect.

Move the definition of ipa_endpoint_suspend_aggr() up in the file so
its definition precedes the new earlier reference to it.  This
requires ipa_endpoint_aggr_active() and ipa_endpoint_force_close()
to be moved as well.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 125 +++++++++++++++++----------------
 1 file changed, 63 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 7f4bea18bd02..d6ef5b8647bf 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -323,13 +323,73 @@ ipa_endpoint_program_delay(struct ipa_endpoint *endpoint, bool enable)
 		(void)ipa_endpoint_init_ctrl(endpoint, enable);
 }
 
-/* Returns previous suspend state (true means it was enabled) */
+static bool ipa_endpoint_aggr_active(struct ipa_endpoint *endpoint)
+{
+	u32 mask = BIT(endpoint->endpoint_id);
+	struct ipa *ipa = endpoint->ipa;
+	u32 offset;
+	u32 val;
+
+	/* assert(mask & ipa->available); */
+	offset = ipa_reg_state_aggr_active_offset(ipa->version);
+	val = ioread32(ipa->reg_virt + offset);
+
+	return !!(val & mask);
+}
+
+static void ipa_endpoint_force_close(struct ipa_endpoint *endpoint)
+{
+	u32 mask = BIT(endpoint->endpoint_id);
+	struct ipa *ipa = endpoint->ipa;
+
+	/* assert(mask & ipa->available); */
+	iowrite32(mask, ipa->reg_virt + IPA_REG_AGGR_FORCE_CLOSE_OFFSET);
+}
+
+/**
+ * ipa_endpoint_suspend_aggr() - Emulate suspend interrupt
+ * @endpoint_id:	Endpoint on which to emulate a suspend
+ *
+ *  Emulate suspend IPA interrupt to unsuspend an endpoint suspended
+ *  with an open aggregation frame.  This is to work around a hardware
+ *  issue in IPA version 3.5.1 where the suspend interrupt will not be
+ *  generated when it should be.
+ */
+static void ipa_endpoint_suspend_aggr(struct ipa_endpoint *endpoint)
+{
+	struct ipa *ipa = endpoint->ipa;
+
+	if (!endpoint->data->aggregation)
+		return;
+
+	/* Nothing to do if the endpoint doesn't have aggregation open */
+	if (!ipa_endpoint_aggr_active(endpoint))
+		return;
+
+	/* Force close aggregation */
+	ipa_endpoint_force_close(endpoint);
+
+	ipa_interrupt_simulate_suspend(ipa->interrupt);
+}
+
+/* Returns previous suspend state (true means suspend was enabled) */
 static bool
 ipa_endpoint_program_suspend(struct ipa_endpoint *endpoint, bool enable)
 {
+	bool suspended;
+
 	/* assert(!endpoint->toward_ipa); */
 
-	return ipa_endpoint_init_ctrl(endpoint, enable);
+	suspended = ipa_endpoint_init_ctrl(endpoint, enable);
+
+	/* A client suspended with an open aggregation frame will not
+	 * generate a SUSPEND IPA interrupt.  If enabling suspend, have
+	 * ipa_endpoint_suspend_aggr() handle this.
+	 */
+	if (enable && !suspended)
+		ipa_endpoint_suspend_aggr(endpoint);
+
+	return suspended;
 }
 
 /* Enable or disable delay or suspend mode on all modem endpoints */
@@ -1144,29 +1204,6 @@ void ipa_endpoint_default_route_clear(struct ipa *ipa)
 	ipa_endpoint_default_route_set(ipa, 0);
 }
 
-static bool ipa_endpoint_aggr_active(struct ipa_endpoint *endpoint)
-{
-	u32 mask = BIT(endpoint->endpoint_id);
-	struct ipa *ipa = endpoint->ipa;
-	u32 offset;
-	u32 val;
-
-	/* assert(mask & ipa->available); */
-	offset = ipa_reg_state_aggr_active_offset(ipa->version);
-	val = ioread32(ipa->reg_virt + offset);
-
-	return !!(val & mask);
-}
-
-static void ipa_endpoint_force_close(struct ipa_endpoint *endpoint)
-{
-	u32 mask = BIT(endpoint->endpoint_id);
-	struct ipa *ipa = endpoint->ipa;
-
-	/* assert(mask & ipa->available); */
-	iowrite32(mask, ipa->reg_virt + IPA_REG_AGGR_FORCE_CLOSE_OFFSET);
-}
-
 /**
  * ipa_endpoint_reset_rx_aggr() - Reset RX endpoint with aggregation active
  * @endpoint:	Endpoint to be reset
@@ -1366,34 +1403,6 @@ void ipa_endpoint_disable_one(struct ipa_endpoint *endpoint)
 			endpoint->endpoint_id);
 }
 
-/**
- * ipa_endpoint_suspend_aggr() - Emulate suspend interrupt
- * @endpoint_id:	Endpoint on which to emulate a suspend
- *
- *  Emulate suspend IPA interrupt to unsuspend an endpoint suspended
- *  with an open aggregation frame.  This is to work around a hardware
- *  issue in IPA version 3.5.1 where the suspend interrupt will not be
- *  generated when it should be.
- */
-static void ipa_endpoint_suspend_aggr(struct ipa_endpoint *endpoint)
-{
-	struct ipa *ipa = endpoint->ipa;
-
-	/* assert(ipa->version == IPA_VERSION_3_5_1); */
-
-	if (!endpoint->data->aggregation)
-		return;
-
-	/* Nothing to do if the endpoint doesn't have aggregation open */
-	if (!ipa_endpoint_aggr_active(endpoint))
-		return;
-
-	/* Force close aggregation */
-	ipa_endpoint_force_close(endpoint);
-
-	ipa_interrupt_simulate_suspend(ipa->interrupt);
-}
-
 void ipa_endpoint_suspend_one(struct ipa_endpoint *endpoint)
 {
 	struct device *dev = &endpoint->ipa->pdev->dev;
@@ -1409,16 +1418,8 @@ void ipa_endpoint_suspend_one(struct ipa_endpoint *endpoint)
 
 	/* IPA v3.5.1 doesn't use channel stop for suspend */
 	stop_channel = endpoint->ipa->version != IPA_VERSION_3_5_1;
-	if (!endpoint->toward_ipa && !stop_channel) {
-		/* Due to a hardware bug, a client suspended with an open
-		 * aggregation frame will not generate a SUSPEND IPA
-		 * interrupt.  We work around this by force-closing the
-		 * aggregation frame, then simulating the arrival of such
-		 * an interrupt.
-		 */
+	if (!endpoint->toward_ipa && !stop_channel)
 		(void)ipa_endpoint_program_suspend(endpoint, true);
-		ipa_endpoint_suspend_aggr(endpoint);
-	}
 
 	ret = gsi_channel_suspend(gsi, endpoint->channel_id, stop_channel);
 	if (ret)
-- 
2.25.1

