Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F6F3E044E
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239204AbhHDPgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239116AbhHDPgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 11:36:47 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A649C06179A
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 08:36:34 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id h18so2039254ilc.5
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 08:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2hCgffmVP7fwJ1V+MjpBVuuEuBwEMxZCBZdgq5a482k=;
        b=VBZQgr9/T1LngHJ7K+Jv4SY35nmFo8hxkBKFt5cQvKKIpBQtk2C9qdDPN6s4/u+Lb7
         7zkfPcLr9bVoLtYMyCKSnlRMbTLLJ90/fuHDqZK9KcW7Ndj0BxpYic8/is3o27mgs+K4
         F6gB5aOrwWlOAz/AQ9pWkh5zZF0vSHsqTnyh5hHjgwSQuBzumPQutMBBFw7otYv8G2jJ
         QZKxRQNrcS7Gh02QOuKJ9Lay3eZtv1w5VrPjBHlQDfitYiL6ooSRjHd+RZu+cRLYDNZW
         5y7QngXaOVi4M+7mD2M3ce0IKPilk4aS7I92PGLXKYsQNJbHca9uR4CJ8rT7RZjSOreU
         i59g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2hCgffmVP7fwJ1V+MjpBVuuEuBwEMxZCBZdgq5a482k=;
        b=P6VTcjYVdUQk3RoAtGKaU8JHomFUFhjXF5X8eNk3t8g1Q368khjEfRvviuxeZ8BbIX
         en+EGCJSh32j/qWGrKan4aIwHfuv+iavab8HQAXl1XnXG7pRJ/9lMB/xMSBmlsYgj61s
         9poXMZzjP1VnZmHJ1nwNp6fsu4Ykpu9uZi6CXD6l2cnIBE7+zz7oF5gBkrA+ICboj5Mt
         sXIoNSxrJyMZdJWfBvQckEjOEaq50AtpUJHg5oUnZfKFkFFN1mtp5O+wjCGmiy7OzmKD
         wmglvpo4Pv4FocaJ6FuerW1nQAXfVhcFwga3HKEzbJUDe6XtJvQJj3yY9F0pUMjtTsIG
         nFPg==
X-Gm-Message-State: AOAM532i+ifU9AEGB2KndhvOMmruz6p5uxHDMheFsS7rfe9LPw9qcZqj
        wIl0nr0EIxicYgvEES+VU/a/Lg==
X-Google-Smtp-Source: ABdhPJw/qC7E1kb164ewaA3i7f96wsE3pgjq9OcxLjqacTVJ4X2Fk/QbwquVVfEkECpVN3S0j3Dc8g==
X-Received: by 2002:a92:2009:: with SMTP id j9mr223263ile.108.1628091393882;
        Wed, 04 Aug 2021 08:36:33 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z11sm1687480ioh.14.2021.08.04.08.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 08:36:33 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/6] net: ipa: move ipa_suspend_handler()
Date:   Wed,  4 Aug 2021 10:36:25 -0500
Message-Id: <20210804153626.1549001-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210804153626.1549001-1-elder@linaro.org>
References: <20210804153626.1549001-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move ipa_suspend_handler() into "ipa_clock.c" from "ipa_main.c", to
group with the reset of the suspend/resume code.  This IPA interrupt
is triggered if an IPA RX endpoint is suspended but has a packet to
be delivered.

Introduce ipa_power_setup() and ipa_power_teardown() to add and
remove the handler for the IPA SUSPEND interrupt at the same place
as before, while allowing the handler to remain private.

The "power" naming convention will be adopted elsewhere in this
file as well (soon).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c | 34 +++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_clock.h | 12 ++++++++++++
 drivers/net/ipa/ipa_main.c  | 38 +++++++------------------------------
 3 files changed, 53 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index 475ea6318cdb2..9e77d4854fe03 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -279,6 +279,40 @@ u32 ipa_clock_rate(struct ipa *ipa)
 	return ipa->clock ? (u32)clk_get_rate(ipa->clock->core) : 0;
 }
 
+/**
+ * ipa_suspend_handler() - Handle the suspend IPA interrupt
+ * @ipa:	IPA pointer
+ * @irq_id:	IPA interrupt type (unused)
+ *
+ * If an RX endpoint is suspended, and the IPA has a packet destined for
+ * that endpoint, the IPA generates a SUSPEND interrupt to inform the AP
+ * that it should resume the endpoint.  If we get one of these interrupts
+ * we just wake up the system.
+ */
+static void ipa_suspend_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
+{
+	/* Just report the event, and let system resume handle the rest.
+	 * More than one endpoint could signal this; if so, ignore
+	 * all but the first.
+	 */
+	if (!test_and_set_bit(IPA_FLAG_RESUMED, ipa->flags))
+		pm_wakeup_dev_event(&ipa->pdev->dev, 0, true);
+
+	/* Acknowledge/clear the suspend interrupt on all endpoints */
+	ipa_interrupt_suspend_clear_all(ipa->interrupt);
+}
+
+void ipa_power_setup(struct ipa *ipa)
+{
+	ipa_interrupt_add(ipa->interrupt, IPA_IRQ_TX_SUSPEND,
+			  ipa_suspend_handler);
+}
+
+void ipa_power_teardown(struct ipa *ipa)
+{
+	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
+}
+
 /* Initialize IPA clocking */
 struct ipa_clock *
 ipa_clock_init(struct device *dev, const struct ipa_clock_data *data)
diff --git a/drivers/net/ipa/ipa_clock.h b/drivers/net/ipa/ipa_clock.h
index 2f0310d5709ca..2a0f7ff3c9e64 100644
--- a/drivers/net/ipa/ipa_clock.h
+++ b/drivers/net/ipa/ipa_clock.h
@@ -22,6 +22,18 @@ extern const struct dev_pm_ops ipa_pm_ops;
  */
 u32 ipa_clock_rate(struct ipa *ipa);
 
+/**
+ * ipa_power_setup() - Set up IPA power management
+ * @ipa:	IPA pointer
+ */
+void ipa_power_setup(struct ipa *ipa);
+
+/**
+ * ipa_power_teardown() - Inverse of ipa_power_setup()
+ * @ipa:	IPA pointer
+ */
+void ipa_power_teardown(struct ipa *ipa);
+
 /**
  * ipa_clock_init() - Initialize IPA clocking
  * @dev:	IPA device
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 28350b7c50c56..25bbb456e0078 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -79,29 +79,6 @@
 /* Divider for 19.2 MHz crystal oscillator clock to get common timer clock */
 #define IPA_XO_CLOCK_DIVIDER	192	/* 1 is subtracted where used */
 
-/**
- * ipa_suspend_handler() - Handle the suspend IPA interrupt
- * @ipa:	IPA pointer
- * @irq_id:	IPA interrupt type (unused)
- *
- * If an RX endpoint is in suspend state, and the IPA has a packet
- * destined for that endpoint, the IPA generates a SUSPEND interrupt
- * to inform the AP that it should resume the endpoint.  If we get
- * one of these interrupts we just resume everything.
- */
-static void ipa_suspend_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
-{
-	/* Just report the event, and let system resume handle the rest.
-	 * More than one endpoint could signal this; if so, ignore
-	 * all but the first.
-	 */
-	if (!test_and_set_bit(IPA_FLAG_RESUMED, ipa->flags))
-		pm_wakeup_dev_event(&ipa->pdev->dev, 0, true);
-
-	/* Acknowledge/clear the suspend interrupt on all endpoints */
-	ipa_interrupt_suspend_clear_all(ipa->interrupt);
-}
-
 /**
  * ipa_setup() - Set up IPA hardware
  * @ipa:	IPA pointer
@@ -124,12 +101,11 @@ int ipa_setup(struct ipa *ipa)
 	if (ret)
 		return ret;
 
-	ipa_interrupt_add(ipa->interrupt, IPA_IRQ_TX_SUSPEND,
-			  ipa_suspend_handler);
+	ipa_power_setup(ipa);
 
 	ret = device_init_wakeup(dev, true);
 	if (ret)
-		goto err_interrupt_remove;
+		goto err_gsi_teardown;
 
 	ipa_endpoint_setup(ipa);
 
@@ -177,9 +153,9 @@ int ipa_setup(struct ipa *ipa)
 	ipa_endpoint_disable_one(command_endpoint);
 err_endpoint_teardown:
 	ipa_endpoint_teardown(ipa);
+	ipa_power_teardown(ipa);
 	(void)device_init_wakeup(dev, false);
-err_interrupt_remove:
-	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
+err_gsi_teardown:
 	gsi_teardown(&ipa->gsi);
 
 	return ret;
@@ -204,8 +180,8 @@ static void ipa_teardown(struct ipa *ipa)
 	command_endpoint = ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX];
 	ipa_endpoint_disable_one(command_endpoint);
 	ipa_endpoint_teardown(ipa);
+	ipa_power_teardown(ipa);
 	(void)device_init_wakeup(&ipa->pdev->dev, false);
-	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
 	gsi_teardown(&ipa->gsi);
 }
 
@@ -474,7 +450,7 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 
 	ret = ipa_endpoint_config(ipa);
 	if (ret)
-		goto err_interrupt_deconfig;
+		goto err_uc_deconfig;
 
 	ipa_table_config(ipa);		/* No deconfig required */
 
@@ -491,7 +467,7 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 
 err_endpoint_deconfig:
 	ipa_endpoint_deconfig(ipa);
-err_interrupt_deconfig:
+err_uc_deconfig:
 	ipa_uc_deconfig(ipa);
 	ipa_interrupt_deconfig(ipa->interrupt);
 	ipa->interrupt = NULL;
-- 
2.27.0

