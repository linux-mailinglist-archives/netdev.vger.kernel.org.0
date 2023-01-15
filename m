Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2EDB66B352
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 19:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjAOR7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 12:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbjAOR7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 12:59:30 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E5DC669
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 09:59:28 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id bs20so25502212wrb.3
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 09:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aeEkeAxRqWela9FaFXtj5Mjrbq66gbp6c2HtFsoXmUw=;
        b=uat0UBqX+XkrHCy0UnV/s5lPDfbXjusDjB8t1rO3q9P0wCgB00ZV1hZ7fcQGVvjWPP
         VmMGA8cp1nsF8fohNLQqks3hB6e5IXXgdFoNJfOuql84FjDb6f3wRnrHVzAB9hUtletO
         UWhDdm+ofdTHJPMLH40+lUv8IYp5v56vIvtH5Bvw0iJum0pGgqP928soNNE6PaXN6pCq
         t220HvDssqv2/5CZlUGthV3VXM2JomKcRIdLW1cP9JCuFUnQIz9csxQ0xeGy8EXMQDXm
         Qp+t/6yc8+VC/ewKMoj3epsrqYOmJzNgGDKsUd9+jerebbTEpJI+Rn8RqfhjZ3aKTWlx
         u2/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aeEkeAxRqWela9FaFXtj5Mjrbq66gbp6c2HtFsoXmUw=;
        b=NxATtRTDzgMKrXmrD7/A0YxH11draLH+2c8WJclsx+HknsTKksjbqNBP6D36cyIeMk
         2CyYhbscFLJPRNXpNkCeRkfd50MFo8IhLgdc6Ha/O54lyhFR/5UVqhSu2WIUNaIDXh0n
         Yjv1JygQd2peM2DMxJWxsjGAxRFWpFaYaPVZi8fAeak89c+RA4BGy04Ah1p3/8y/kDCI
         MujtdMzD824vDQbavoY3I7YSS55LpB1sWZc2fUAoCBZzv0NOibBLYRXwGOw2V2HFIcBx
         CVhBhB7mK2ooP6MzmrZGkHdR1NkVMih1vdcm2LkevvQj3KLSiuv0jNU2bsnpFF2N8vp1
         V+Kg==
X-Gm-Message-State: AFqh2kr/2NFPBKHeCZYYUURdBcZSd+aiqVuXai6gopEA0VUgfudKmLTT
        Q5GNQiUGO/QGCV0k0F1WKJ5mo1jUsxROnSpi
X-Google-Smtp-Source: AMrXdXsXAQSRiMWFVknzYCVNJfgZQc2U1pMuRDknstTIZggPcH32L3is+TTH90WMpC+iXx4qT959KQ==
X-Received: by 2002:a5d:5b18:0:b0:2bd:c2ce:dd5a with SMTP id bx24-20020a5d5b18000000b002bdc2cedd5amr6509184wrb.16.1673805567081;
        Sun, 15 Jan 2023 09:59:27 -0800 (PST)
Received: from lion.. (cpc76484-cwma10-2-0-cust274.7-3.cable.virginm.net. [82.31.201.19])
        by smtp.gmail.com with ESMTPSA id m1-20020a5d6241000000b002bbdaf21744sm21399441wrv.113.2023.01.15.09.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 09:59:26 -0800 (PST)
From:   Caleb Connolly <caleb.connolly@linaro.org>
To:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alex Elder <elder@linaro.org>, netdev@vger.kernel.org
Subject: [PATCH net] net: ipa: disable ipa interrupt during suspend
Date:   Sun, 15 Jan 2023 17:59:24 +0000
Message-Id: <20230115175925.465918-1-caleb.connolly@linaro.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IPA interrupt can fire when pm_runtime is disabled due to it racing
with the PM suspend/resume code. This causes a splat in the interrupt
handler when it tries to call pm_runtime_get().

Explicitly disable the interrupt in our ->suspend callback, and
re-enable it in ->resume to avoid this. If there is an interrupt pending
it will be handled after resuming. The interrupt is a wake_irq, as a
result even when disabled if it fires it will cause the system to wake
from suspend as well as cancel any suspend transition that may be in
progress. If there is an interrupt pending, the ipa_isr_thread handler
will be called after resuming.

Fixes: 1aac309d3207 ("net: ipa: use autosuspend")
Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
---
 drivers/net/ipa/ipa_interrupt.c | 10 ++++++++++
 drivers/net/ipa/ipa_interrupt.h | 16 ++++++++++++++++
 drivers/net/ipa/ipa_power.c     | 17 +++++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index d458a35839cc..c1b3977e1ae4 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -127,6 +127,16 @@ static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+void ipa_interrupt_irq_disable(struct ipa *ipa)
+{
+	disable_irq(ipa->interrupt->irq);
+}
+
+void ipa_interrupt_irq_enable(struct ipa *ipa)
+{
+	enable_irq(ipa->interrupt->irq);
+}
+
 /* Common function used to enable/disable TX_SUSPEND for an endpoint */
 static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
 					  u32 endpoint_id, bool enable)
diff --git a/drivers/net/ipa/ipa_interrupt.h b/drivers/net/ipa/ipa_interrupt.h
index f31fd9965fdc..8a1bd5b89393 100644
--- a/drivers/net/ipa/ipa_interrupt.h
+++ b/drivers/net/ipa/ipa_interrupt.h
@@ -85,6 +85,22 @@ void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt);
  */
 void ipa_interrupt_simulate_suspend(struct ipa_interrupt *interrupt);
 
+/**
+ * ipa_interrupt_irq_enable() - Enable IPA interrupts
+ * @ipa:	IPA pointer
+ *
+ * This enables the IPA interrupt line
+ */
+void ipa_interrupt_irq_enable(struct ipa *ipa);
+
+/**
+ * ipa_interrupt_irq_disable() - Disable IPA interrupts
+ * @ipa:	IPA pointer
+ *
+ * This disables the IPA interrupt line
+ */
+void ipa_interrupt_irq_disable(struct ipa *ipa);
+
 /**
  * ipa_interrupt_config() - Configure the IPA interrupt framework
  * @ipa:	IPA pointer
diff --git a/drivers/net/ipa/ipa_power.c b/drivers/net/ipa/ipa_power.c
index 8420f93128a2..8057be8cda80 100644
--- a/drivers/net/ipa/ipa_power.c
+++ b/drivers/net/ipa/ipa_power.c
@@ -181,6 +181,17 @@ static int ipa_suspend(struct device *dev)
 
 	__set_bit(IPA_POWER_FLAG_SYSTEM, ipa->power->flags);
 
+	/* Increment the disable depth to ensure that the IRQ won't
+	 * be re-enabled until the matching _enable call in
+	 * ipa_resume(). We do this to ensure that the interrupt
+	 * handler won't run whilst PM runtime is disabled.
+	 *
+	 * Note that disabling the IRQ is NOT the same as disabling
+	 * irq wake. If wakeup is enabled for the IPA then the IRQ
+	 * will still cause the system to wake up, see irq_set_irq_wake().
+	 */
+	ipa_interrupt_irq_disable(ipa);
+
 	return pm_runtime_force_suspend(dev);
 }
 
@@ -193,6 +204,12 @@ static int ipa_resume(struct device *dev)
 
 	__clear_bit(IPA_POWER_FLAG_SYSTEM, ipa->power->flags);
 
+	/* Now that PM runtime is enabled again it's safe
+	 * to turn the IRQ back on and process any data
+	 * that was received during suspend.
+	 */
+	ipa_interrupt_irq_enable(ipa);
+
 	return ret;
 }
 
-- 
2.39.0

