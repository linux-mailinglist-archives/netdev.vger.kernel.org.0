Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5057A65DB9E
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 18:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240084AbjADRw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 12:52:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239991AbjADRwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 12:52:46 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75C33AA9B
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 09:52:41 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id h26so5576725ila.11
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 09:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ri11bVKWxZ8HBQVrgBnLCZL7on//0SsmMOvFkbNuqmY=;
        b=hf9r/IxUGvYos/EypH+LZsWy8zskjLfb8hLTytQYwDKiOfBHIQN9yppwS+wprEwTqp
         +KGvNPxNIF8/feFE5Dkbdft9D0c5Nhy0j8dRVcRSCRDFihBg1/Lyv5MRFEhGgtiXhD0A
         XlvOsCvqsjt/JsZ3Miy3cAdiAURANrXzx/dE6/HJ/TXC0mx7RwUbtGUboFhkoD5KoikE
         8oRjsxL3uJdiqfc4DE9KrG5bhv6GIb3svJpl0KN+v+yYYYbxvAvemmzIbWBSrvnr/JFw
         JAHcKs9asNWQVBtiQ5yFhOEntOALTV0n+I1tnWSr1SmJq5vvAHpIpKUeZFzItzh4a2js
         NzKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ri11bVKWxZ8HBQVrgBnLCZL7on//0SsmMOvFkbNuqmY=;
        b=YC8akiN+OGvFY9BJX1+fzm+WRvGgStn+HFtl9Vx7s74BNaNtdsshqJs3tTf2D325Rh
         qFRIhXpBrQI5sIoryCozDToPSIy81XJ3aWpmUOYisueli7hB45FwZkFIf842AtYgUNtK
         iXWIEeVfYjlVoob9jbRFGupUogMKMPQ6D5Z0Mxx5wOYtpcux4X/xnhc/QcRm88eyEDy3
         4x6Q6zc+1INOXZ+ZKyJ3wDbatyyZytd5+9gxvc4DFMVdqpL6mL+oc2S+oBS9E2z3soOd
         E16SQb4AyHTNOrY9+N2dSAyh52rIE7T9WXlRexyfNannNzm78xIeB6nbbreKFFPKcqN3
         HATg==
X-Gm-Message-State: AFqh2kp2Iwr0DqcLBFiB5DOc6MzqfspkKVxZqBBGugSfHOn0wX6uJw8Q
        5ht9N2+El+CTF7AdQnxGfGQv+A==
X-Google-Smtp-Source: AMrXdXvrZ16sUX5HG4IZ1soj1+hicAdUMGAv2csS9G9UVGcFQfrS33hUW2MYxftdcny617USzT4xKw==
X-Received: by 2002:a05:6e02:13d2:b0:30c:251d:f98e with SMTP id v18-20020a056e0213d200b0030c251df98emr14071642ilj.27.1672854760959;
        Wed, 04 Jan 2023 09:52:40 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id u3-20020a02cbc3000000b00375783003fcsm10872304jaq.136.2023.01.04.09.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 09:52:40 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/6] net: ipa: enable IPA interrupt handlers separate from registration
Date:   Wed,  4 Jan 2023 11:52:30 -0600
Message-Id: <20230104175233.2862874-4-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230104175233.2862874-1-elder@linaro.org>
References: <20230104175233.2862874-1-elder@linaro.org>
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

Expose ipa_interrupt_enable() and have functions that register
IPA interrupt handlers enable them directly, rather than having the
registration process do that.  Do the same for disabling IPA
interrupt handlers.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2  Declared enum ipa_irq_id at the top of "ipa_interrupt.c".

 drivers/net/ipa/ipa_interrupt.c |  8 ++------
 drivers/net/ipa/ipa_interrupt.h | 15 +++++++++++++++
 drivers/net/ipa/ipa_power.c     |  6 +++++-
 drivers/net/ipa/ipa_uc.c        |  4 ++++
 4 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index 7b7388c14806f..87f4b94d02a3f 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -135,7 +135,7 @@ static void ipa_interrupt_enabled_update(struct ipa *ipa)
 }
 
 /* Enable an IPA interrupt type */
-static void ipa_interrupt_enable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
+void ipa_interrupt_enable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
 {
 	/* Update the IPA interrupt mask to enable it */
 	ipa->interrupt->enabled |= BIT(ipa_irq);
@@ -143,7 +143,7 @@ static void ipa_interrupt_enable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
 }
 
 /* Disable an IPA interrupt type */
-static void ipa_interrupt_disable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
+void ipa_interrupt_disable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
 {
 	/* Update the IPA interrupt mask to disable it */
 	ipa->interrupt->enabled &= ~BIT(ipa_irq);
@@ -232,8 +232,6 @@ void ipa_interrupt_add(struct ipa_interrupt *interrupt,
 		return;
 
 	interrupt->handler[ipa_irq] = handler;
-
-	ipa_interrupt_enable(interrupt->ipa, ipa_irq);
 }
 
 /* Remove the handler for an IPA interrupt type */
@@ -243,8 +241,6 @@ ipa_interrupt_remove(struct ipa_interrupt *interrupt, enum ipa_irq_id ipa_irq)
 	if (WARN_ON(ipa_irq >= IPA_IRQ_COUNT))
 		return;
 
-	ipa_interrupt_disable(interrupt->ipa, ipa_irq);
-
 	interrupt->handler[ipa_irq] = NULL;
 }
 
diff --git a/drivers/net/ipa/ipa_interrupt.h b/drivers/net/ipa/ipa_interrupt.h
index f31fd9965fdc6..90b61e013064b 100644
--- a/drivers/net/ipa/ipa_interrupt.h
+++ b/drivers/net/ipa/ipa_interrupt.h
@@ -11,6 +11,7 @@
 
 struct ipa;
 struct ipa_interrupt;
+enum ipa_irq_id;
 
 /**
  * typedef ipa_irq_handler_t - IPA interrupt handler function type
@@ -85,6 +86,20 @@ void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt);
  */
 void ipa_interrupt_simulate_suspend(struct ipa_interrupt *interrupt);
 
+/**
+ * ipa_interrupt_enable() - Enable an IPA interrupt type
+ * @ipa:	IPA pointer
+ * @ipa_irq:	IPA interrupt ID
+ */
+void ipa_interrupt_enable(struct ipa *ipa, enum ipa_irq_id ipa_irq);
+
+/**
+ * ipa_interrupt_disable() - Disable an IPA interrupt type
+ * @ipa:	IPA pointer
+ * @ipa_irq:	IPA interrupt ID
+ */
+void ipa_interrupt_disable(struct ipa *ipa, enum ipa_irq_id ipa_irq);
+
 /**
  * ipa_interrupt_config() - Configure the IPA interrupt framework
  * @ipa:	IPA pointer
diff --git a/drivers/net/ipa/ipa_power.c b/drivers/net/ipa/ipa_power.c
index 8420f93128a26..9148d606d5fc2 100644
--- a/drivers/net/ipa/ipa_power.c
+++ b/drivers/net/ipa/ipa_power.c
@@ -337,10 +337,13 @@ int ipa_power_setup(struct ipa *ipa)
 
 	ipa_interrupt_add(ipa->interrupt, IPA_IRQ_TX_SUSPEND,
 			  ipa_suspend_handler);
+	ipa_interrupt_enable(ipa, IPA_IRQ_TX_SUSPEND);
 
 	ret = device_init_wakeup(&ipa->pdev->dev, true);
-	if (ret)
+	if (ret) {
+		ipa_interrupt_disable(ipa, IPA_IRQ_TX_SUSPEND);
 		ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
+	}
 
 	return ret;
 }
@@ -348,6 +351,7 @@ int ipa_power_setup(struct ipa *ipa)
 void ipa_power_teardown(struct ipa *ipa)
 {
 	(void)device_init_wakeup(&ipa->pdev->dev, false);
+	ipa_interrupt_disable(ipa, IPA_IRQ_TX_SUSPEND);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
 }
 
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index 0a890b44c09e1..af541758d047f 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -187,7 +187,9 @@ void ipa_uc_config(struct ipa *ipa)
 	ipa->uc_powered = false;
 	ipa->uc_loaded = false;
 	ipa_interrupt_add(interrupt, IPA_IRQ_UC_0, ipa_uc_interrupt_handler);
+	ipa_interrupt_enable(ipa, IPA_IRQ_UC_0);
 	ipa_interrupt_add(interrupt, IPA_IRQ_UC_1, ipa_uc_interrupt_handler);
+	ipa_interrupt_enable(ipa, IPA_IRQ_UC_1);
 }
 
 /* Inverse of ipa_uc_config() */
@@ -195,7 +197,9 @@ void ipa_uc_deconfig(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
 
+	ipa_interrupt_disable(ipa, IPA_IRQ_UC_1);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_1);
+	ipa_interrupt_disable(ipa, IPA_IRQ_UC_0);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_0);
 	if (ipa->uc_loaded)
 		ipa_power_retention(ipa, false);
-- 
2.34.1

