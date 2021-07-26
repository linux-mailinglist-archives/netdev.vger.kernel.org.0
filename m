Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5C53D67EC
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 22:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbhGZTbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 15:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbhGZTbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 15:31:14 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB577C061760
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 13:11:42 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id y9so13493129iox.2
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 13:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=70xPSqNfg1+zmAwitXIzdSa5it5L29wIVFAOMsoUpsw=;
        b=kmeELVZO1w1FfLVOV0oVQ0Y48DMhb3hXmNIWBBj5AI0X5tEtv632yCXjqcCN+HA7RG
         mMOzzWca9GME13opR7/E/OZCi2PsVeUm07ISJC6WTCpyfGropvN6FudACSVrnYxR71SY
         rZUQ2aELTnxvANKFwPF04hEaU3Ye38XI9CrQ1XN7UsIDx226nGcUqPuRcJEROLqEBcWc
         lQZIp8eNyTY+10dUeVpkU6tuCk0IcbCZ4HTkPcuTZaC4CbuZUiJdZLSnHqCoVI51pOPy
         QhjuYkNuUJEpPmklbl4mKzEgXzWoZrLxXMv5loeYeF5/KBCyQ6kSZP6sffBTn0rj9yiU
         WUFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=70xPSqNfg1+zmAwitXIzdSa5it5L29wIVFAOMsoUpsw=;
        b=DJfa+4SL6tNHU/+ZH7fmsfLKrAWlXUQPdknp/XcT4P51g4JlHo5c2ED6SwPsbA4AKb
         Pj0JUaHdnc6BqwRf2tp+2uan2rrfv6YduI5wz5nY+sxXP7KFpQtzh9AiUJ1obCGuj256
         y9LcPyJH38JyxhHaaoOiWEK7JXxDoOADBuKBYu+ova54FVmi6PbbUb5fkqvuBaKmL8mQ
         YVPKy3h8SQc401pD4dAH3CWLUApbwBFK4nX6W/ddCy85TiNJNhRiuIXce67SX0XyGLFF
         PGsvPuJKQVG15UeTYNixn5B/vCHF5IlbWK5486+6uVqSjWjmHupSCAhzq7jiNyfcQs+C
         3f/g==
X-Gm-Message-State: AOAM531E7f2PXSBV7tKzrNU1NUfRxYcDfxMUlVsufA0DhwnZM7GwmJN1
        WyjyHMMDIzNO8NM9nt0hZV8Q5g==
X-Google-Smtp-Source: ABdhPJzpQWqrSk7V+p4rTuZviP8IeHDbkAlFqSNahzsFU1C+6CIhHEPMlhNc1NAE8FQqeyEJQP/p7w==
X-Received: by 2002:a02:c8d0:: with SMTP id q16mr18184847jao.110.1627330302221;
        Mon, 26 Jul 2021 13:11:42 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z10sm425964iln.8.2021.07.26.13.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 13:11:41 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/5] net: ipa: set up IPA interrupts earlier
Date:   Mon, 26 Jul 2021 15:11:34 -0500
Message-Id: <20210726201136.502800-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210726201136.502800-1-elder@linaro.org>
References: <20210726201136.502800-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialization of the IPA driver has several phases:
   - "init" phase can be done without any access to IPA hardware
   - "config" phase requires the IPA hardware to be clocked
   - "setup" phase requires the GSI layer to be functional

Currently, initialization for the IPA interrupt handling code occurs
in the setup phase.  It requires access to the IPA hardware but does
not need GSI, so it can be moved to the config phase instead.

Call the interrupt configuration function early in ipa_config()
rather than from ipa_setup().  Rename ipa_interrupt_setup() to be
ipa_interrupt_config(), and ipa_interrupt_teardown() to be
ipa_interupt_deconfig(), so their names properly indicate when
they get called.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_interrupt.c |  8 ++++----
 drivers/net/ipa/ipa_interrupt.h |  8 ++++----
 drivers/net/ipa/ipa_main.c      | 24 ++++++++++++++----------
 3 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index c46df0b7c4e50..46a983aeebc8b 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -231,8 +231,8 @@ ipa_interrupt_remove(struct ipa_interrupt *interrupt, enum ipa_irq_id ipa_irq)
 	interrupt->handler[ipa_irq] = NULL;
 }
 
-/* Set up the IPA interrupt framework */
-struct ipa_interrupt *ipa_interrupt_setup(struct ipa *ipa)
+/* Configure the IPA interrupt framework */
+struct ipa_interrupt *ipa_interrupt_config(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
 	struct ipa_interrupt *interrupt;
@@ -281,8 +281,8 @@ struct ipa_interrupt *ipa_interrupt_setup(struct ipa *ipa)
 	return ERR_PTR(ret);
 }
 
-/* Tear down the IPA interrupt framework */
-void ipa_interrupt_teardown(struct ipa_interrupt *interrupt)
+/* Inverse of ipa_interrupt_config() */
+void ipa_interrupt_deconfig(struct ipa_interrupt *interrupt)
 {
 	struct device *dev = &interrupt->ipa->pdev->dev;
 	int ret;
diff --git a/drivers/net/ipa/ipa_interrupt.h b/drivers/net/ipa/ipa_interrupt.h
index d5c486a6800d9..231390cea52a2 100644
--- a/drivers/net/ipa/ipa_interrupt.h
+++ b/drivers/net/ipa/ipa_interrupt.h
@@ -86,17 +86,17 @@ void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt);
 void ipa_interrupt_simulate_suspend(struct ipa_interrupt *interrupt);
 
 /**
- * ipa_interrupt_setup() - Set up the IPA interrupt framework
+ * ipa_interrupt_config() - Configure the IPA interrupt framework
  * @ipa:	IPA pointer
  *
  * Return:	Pointer to IPA SMP2P info, or a pointer-coded error
  */
-struct ipa_interrupt *ipa_interrupt_setup(struct ipa *ipa);
+struct ipa_interrupt *ipa_interrupt_config(struct ipa *ipa);
 
 /**
- * ipa_interrupt_teardown() - Tear down the IPA interrupt framework
+ * ipa_interrupt_deconfig() - Inverse of ipa_interrupt_config()
  * @interrupt:	IPA interrupt structure
  */
-void ipa_interrupt_teardown(struct ipa_interrupt *interrupt);
+void ipa_interrupt_deconfig(struct ipa_interrupt *interrupt);
 
 #endif /* _IPA_INTERRUPT_H_ */
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 8768e52854d08..c26acd8b1cb91 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -124,11 +124,6 @@ int ipa_setup(struct ipa *ipa)
 	if (ret)
 		return ret;
 
-	ipa->interrupt = ipa_interrupt_setup(ipa);
-	if (IS_ERR(ipa->interrupt)) {
-		ret = PTR_ERR(ipa->interrupt);
-		goto err_gsi_teardown;
-	}
 	ipa_interrupt_add(ipa->interrupt, IPA_IRQ_TX_SUSPEND,
 			  ipa_suspend_handler);
 
@@ -188,8 +183,6 @@ int ipa_setup(struct ipa *ipa)
 err_uc_teardown:
 	ipa_uc_teardown(ipa);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
-	ipa_interrupt_teardown(ipa->interrupt);
-err_gsi_teardown:
 	gsi_teardown(&ipa->gsi);
 
 	return ret;
@@ -214,7 +207,6 @@ static void ipa_teardown(struct ipa *ipa)
 	(void)device_init_wakeup(&ipa->pdev->dev, false);
 	ipa_uc_teardown(ipa);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
-	ipa_interrupt_teardown(ipa->interrupt);
 	gsi_teardown(&ipa->gsi);
 }
 
@@ -475,9 +467,16 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 	if (ret)
 		goto err_hardware_deconfig;
 
-	ret = ipa_endpoint_config(ipa);
-	if (ret)
+	ipa->interrupt = ipa_interrupt_config(ipa);
+	if (IS_ERR(ipa->interrupt)) {
+		ret = PTR_ERR(ipa->interrupt);
+		ipa->interrupt = NULL;
 		goto err_mem_deconfig;
+	}
+
+	ret = ipa_endpoint_config(ipa);
+	if (ret)
+		goto err_interrupt_deconfig;
 
 	ipa_table_config(ipa);		/* No deconfig required */
 
@@ -494,6 +493,9 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 
 err_endpoint_deconfig:
 	ipa_endpoint_deconfig(ipa);
+err_interrupt_deconfig:
+	ipa_interrupt_deconfig(ipa->interrupt);
+	ipa->interrupt = NULL;
 err_mem_deconfig:
 	ipa_mem_deconfig(ipa);
 err_hardware_deconfig:
@@ -511,6 +513,8 @@ static void ipa_deconfig(struct ipa *ipa)
 {
 	ipa_modem_deconfig(ipa);
 	ipa_endpoint_deconfig(ipa);
+	ipa_interrupt_deconfig(ipa->interrupt);
+	ipa->interrupt = NULL;
 	ipa_mem_deconfig(ipa);
 	ipa_hardware_deconfig(ipa);
 	ipa_clock_put(ipa);
-- 
2.27.0

