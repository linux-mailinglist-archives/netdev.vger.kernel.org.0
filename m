Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA03B3D67EF
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 22:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbhGZTbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 15:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232824AbhGZTbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 15:31:15 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B090FC061764
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 13:11:43 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id y200so13536052iof.1
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 13:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CbkpeKrOfcqmDReVdepadZw98qDLwbHdY24550v6RHA=;
        b=AQPJguyqnk15W1iKAm7vTy+8YvOzRvF4v3NbIy9lw//R6tq0F2Kdpk+IoriqiFhC3/
         WFm9CmoCF7nqbO1cDRXEX9NdDHYiPorqP7I/VQamTaUfEbwLcFBXUVB628bnOr5FWdJU
         2gjCVwzRfDBy5b4e/6C5/Yl4cf/Bw/4r2j9tq3ec+O+gmkDZRufEFMipV1n/yioUto6H
         WJcHqSpf5swMnTb/q06zPQuYfIfb+ddiwOtvA8snSF3cZsIoCcRM0UmHJs8+XDAcyp25
         q2XWvIgXc7gMo84uEVSte7cjQ/19IUs8xUVRmkDRASTzlI453mH1IRx7djVmTPueQP9f
         L78w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CbkpeKrOfcqmDReVdepadZw98qDLwbHdY24550v6RHA=;
        b=Rasb4yFBwQ048nXL8OWL65R9hGqbo6UiFPG5ps71n+7kiZAZK16fmsoWIqPVe4+pMe
         mdbJKkdonBMcvXR7AiJcNRBVJvFRJRheHT2dbLf8AmZJGn5lizEAVA2EcOn1O2KEmSdX
         /raMCOLCKuxkUvVmosluMBA2JeNQOvDyo7pamqJmPAIDnDpBSJoIpIJywfr7Cp/Als4A
         nvIbHjhyPdVPxf5E/6qakXf043Vz6auYDuADCUh9OYxi8uJYRfoEe7T6qQR46qkDZulU
         Emiurn8P3Zhf9UfbE4Azhy5zHxOpzjomKwFLrWDbH+8JCsEVh/+rCNF3vL3CdXEpSPmD
         ZIBQ==
X-Gm-Message-State: AOAM530W/PD2hm1+X308THjsZ94v9kLPd641i/LiFUjZ8Dlea5StWEt6
        uGeEYDiypl9Lq1x4LmLB4LJmow==
X-Google-Smtp-Source: ABdhPJxPuACskKyOes5NbbtfW7fW2dSxGgq8kjSCkaOM6mf19nKeXziArrumMpH+lRYC5HPYT+h20A==
X-Received: by 2002:a05:6602:2424:: with SMTP id g4mr16349955iob.189.1627330303103;
        Mon, 26 Jul 2021 13:11:43 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z10sm425964iln.8.2021.07.26.13.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 13:11:42 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/5] net: ipa: set up the microcontroller earlier
Date:   Mon, 26 Jul 2021 15:11:35 -0500
Message-Id: <20210726201136.502800-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210726201136.502800-1-elder@linaro.org>
References: <20210726201136.502800-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initializing up the IPA-resident microcontroller requires the IPA
clock, and sets up two IPA interrupt handlers, but this does not
require GSI access.  The interrupt handlers also require the clock
to be enabled, and require the IPA memory regions to be configured,
but neither requires GSI access.  As a result, the microcontroller
can be initialized during the "config" rather than "setup" phase of
IPA initialization.

Initialize the microcontroller in ipa_config() rather than
ipa_setup(), and rename the called function ipa_uc_config().
Do the inverse in ipa_deconfig() rather than ipa_teardown(),
and rename the function for that case ipa_uc_deconfig().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 12 ++++++------
 drivers/net/ipa/ipa_uc.c   |  8 ++++----
 drivers/net/ipa/ipa_uc.h   |  8 ++++----
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index c26acd8b1cb91..d83322bf9e7e5 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -127,11 +127,9 @@ int ipa_setup(struct ipa *ipa)
 	ipa_interrupt_add(ipa->interrupt, IPA_IRQ_TX_SUSPEND,
 			  ipa_suspend_handler);
 
-	ipa_uc_setup(ipa);
-
 	ret = device_init_wakeup(dev, true);
 	if (ret)
-		goto err_uc_teardown;
+		goto err_interrupt_remove;
 
 	ipa_endpoint_setup(ipa);
 
@@ -180,8 +178,7 @@ int ipa_setup(struct ipa *ipa)
 err_endpoint_teardown:
 	ipa_endpoint_teardown(ipa);
 	(void)device_init_wakeup(dev, false);
-err_uc_teardown:
-	ipa_uc_teardown(ipa);
+err_interrupt_remove:
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
 	gsi_teardown(&ipa->gsi);
 
@@ -205,7 +202,6 @@ static void ipa_teardown(struct ipa *ipa)
 	ipa_endpoint_disable_one(command_endpoint);
 	ipa_endpoint_teardown(ipa);
 	(void)device_init_wakeup(&ipa->pdev->dev, false);
-	ipa_uc_teardown(ipa);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
 	gsi_teardown(&ipa->gsi);
 }
@@ -474,6 +470,8 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 		goto err_mem_deconfig;
 	}
 
+	ipa_uc_config(ipa);
+
 	ret = ipa_endpoint_config(ipa);
 	if (ret)
 		goto err_interrupt_deconfig;
@@ -494,6 +492,7 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 err_endpoint_deconfig:
 	ipa_endpoint_deconfig(ipa);
 err_interrupt_deconfig:
+	ipa_uc_deconfig(ipa);
 	ipa_interrupt_deconfig(ipa->interrupt);
 	ipa->interrupt = NULL;
 err_mem_deconfig:
@@ -513,6 +512,7 @@ static void ipa_deconfig(struct ipa *ipa)
 {
 	ipa_modem_deconfig(ipa);
 	ipa_endpoint_deconfig(ipa);
+	ipa_uc_deconfig(ipa);
 	ipa_interrupt_deconfig(ipa->interrupt);
 	ipa->interrupt = NULL;
 	ipa_mem_deconfig(ipa);
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index fd9219863234c..8b5e75711b644 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -162,8 +162,8 @@ static void ipa_uc_response_hdlr(struct ipa *ipa, enum ipa_irq_id irq_id)
 	}
 }
 
-/* ipa_uc_setup() - Set up the microcontroller */
-void ipa_uc_setup(struct ipa *ipa)
+/* Configure the IPA microcontroller subsystem */
+void ipa_uc_config(struct ipa *ipa)
 {
 	/* The microcontroller needs the IPA clock running until it has
 	 * completed its initialization.  It signals this by sending an
@@ -180,8 +180,8 @@ void ipa_uc_setup(struct ipa *ipa)
 	ipa_interrupt_add(ipa->interrupt, IPA_IRQ_UC_1, ipa_uc_response_hdlr);
 }
 
-/* Inverse of ipa_uc_setup() */
-void ipa_uc_teardown(struct ipa *ipa)
+/* Inverse of ipa_uc_config() */
+void ipa_uc_deconfig(struct ipa *ipa)
 {
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_1);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_0);
diff --git a/drivers/net/ipa/ipa_uc.h b/drivers/net/ipa/ipa_uc.h
index e8510899a3f0a..cb0a224022f58 100644
--- a/drivers/net/ipa/ipa_uc.h
+++ b/drivers/net/ipa/ipa_uc.h
@@ -9,16 +9,16 @@
 struct ipa;
 
 /**
- * ipa_uc_setup() - set up the IPA microcontroller subsystem
+ * ipa_uc_config() - Configure the IPA microcontroller subsystem
  * @ipa:	IPA pointer
  */
-void ipa_uc_setup(struct ipa *ipa);
+void ipa_uc_config(struct ipa *ipa);
 
 /**
- * ipa_uc_teardown() - inverse of ipa_uc_setup()
+ * ipa_uc_deconfig() - Inverse of ipa_uc_config()
  * @ipa:	IPA pointer
  */
-void ipa_uc_teardown(struct ipa *ipa);
+void ipa_uc_deconfig(struct ipa *ipa);
 
 /**
  * ipa_uc_panic_notifier()
-- 
2.27.0

