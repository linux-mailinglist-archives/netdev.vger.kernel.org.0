Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF0661269C
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 02:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiJ3ASs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 20:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiJ3ASo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 20:18:44 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B2B24BCF
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 17:18:43 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id 11so7431283iou.0
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 17:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZcCihh0f7Qr/rXNZsx/9L0DCMnXVjeXTxfp8VH2CZiE=;
        b=LJ2tPsV9r1KXTlBIXYpW1XKmjCTrupbkXfgVj9o4EUIi20+QTbQ1/Kujr4S8iPxh08
         bgw69SDHHrkGXezV/clsAfYHTrbzYxVh3m5wRCVyp5g2yzqV0f5YxQ6YAWzo5xzxDyNV
         8VGheGUNkK7N77kfm2HbfQQ/IITpxcD77SSuHBy7gtUe0XqX2smlRokRKcSZWnfmqlqr
         pWRK2eEA8EXbFPUKGNISZNtzQKNVJjPXLNsYGYxFRFZOaWW2tHfp+MKiZVLNIKGdICXN
         DLVi4pBzB10LNnt6J3p0q0Frzmk5FmW5rf8Y81dEyw5+7W37fNMntBy+XC/YC4R7bjYB
         Og+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZcCihh0f7Qr/rXNZsx/9L0DCMnXVjeXTxfp8VH2CZiE=;
        b=tF64c7jkPWPbhz2yFwOHDQeFwDGLi4chioGOB5KMR/DtuSYY1Ieu5YSSsS75xeHms+
         SQ70YqV0PBQYeYa0n7hO34Jk1e+X8gxlRYtcLq2bsU9T6O9pX7nO8MQpO3JLxKFa7vTT
         6PBeuo9RYy5h6w8bJneCJAmPFxZkD+a2+gi+PmUMRJpTD1+djXz2jwxGDiJZAhmAcuDI
         VuDrqteANGabz+RqbZxJWsV/7Ho/nrRjoZndPEbYBcYq80JNm5E4q9YwSil1D7h0wNAd
         oKdvPIDDqTySJo4wqNActw8+3SZ84bfga9/eeZnjOKMxqkupXUB4LNGVAbQa45wqAzgN
         /PSg==
X-Gm-Message-State: ACrzQf3XmE7IYFWMy8RgoY/L+dIdkZLYViPPmOIQ/Zl6Pfuegosm3zBU
        J615rvZtY0o0RCJwnyEuXnGclw==
X-Google-Smtp-Source: AMsMyM6SSNxKbt+ssADogepxaoZgoKuZLlp51tENCfdBGJ91IQtBEVSDTIzfct82RICKODEilYGLsA==
X-Received: by 2002:a05:6602:2a48:b0:6bc:e1c7:797b with SMTP id k8-20020a0566022a4800b006bce1c7797bmr3103929iov.131.1667089122908;
        Sat, 29 Oct 2022 17:18:42 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id co20-20020a0566383e1400b00375126ae55fsm1087519jab.58.2022.10.29.17.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 17:18:42 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/9] net: ipa: add a parameter to suspend registers
Date:   Sat, 29 Oct 2022 19:18:23 -0500
Message-Id: <20221030001828.754010-5-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221030001828.754010-1-elder@linaro.org>
References: <20221030001828.754010-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SUSPEND_INFO, SUSPEND_EN, SUSPEND_CLR registers represent
endpoint IDs in a bit mask.  When more than 32 endpoints are
supported, these registers will be replicated as needed to represent
the number of supported endpoints.  Update the definitions of these
registers to have a stride of 4 bytes, and update the code that
operates them to select the proper offset and bit.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_interrupt.c      | 30 ++++++++++++++++++----------
 drivers/net/ipa/reg/ipa_reg-v3.1.c   |  9 ++++++---
 drivers/net/ipa/reg/ipa_reg-v3.5.1.c |  9 ++++++---
 drivers/net/ipa/reg/ipa_reg-v4.11.c  |  9 ++++++---
 drivers/net/ipa/reg/ipa_reg-v4.2.c   |  9 ++++++---
 drivers/net/ipa/reg/ipa_reg-v4.5.c   |  9 ++++++---
 drivers/net/ipa/reg/ipa_reg-v4.9.c   |  9 ++++++---
 7 files changed, 55 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index c269432f9c2ee..a62bc667bda0e 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -132,11 +132,13 @@ static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
 					  u32 endpoint_id, bool enable)
 {
 	struct ipa *ipa = interrupt->ipa;
-	u32 mask = BIT(endpoint_id);
+	u32 mask = BIT(endpoint_id % 32);
+	u32 unit = endpoint_id / 32;
 	const struct ipa_reg *reg;
 	u32 offset;
 	u32 val;
 
+	/* This works until we actually have more than 32 endpoints */
 	WARN_ON(!(mask & ipa->available));
 
 	/* IPA version 3.0 does not support TX_SUSPEND interrupt control */
@@ -144,7 +146,7 @@ static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
 		return;
 
 	reg = ipa_reg(ipa, IRQ_SUSPEND_EN);
-	offset = ipa_reg_offset(reg);
+	offset = ipa_reg_n_offset(reg, unit);
 	val = ioread32(ipa->reg_virt + offset);
 	if (enable)
 		val |= mask;
@@ -171,18 +173,24 @@ ipa_interrupt_suspend_disable(struct ipa_interrupt *interrupt, u32 endpoint_id)
 void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt)
 {
 	struct ipa *ipa = interrupt->ipa;
-	const struct ipa_reg *reg;
-	u32 val;
+	u32 unit_count;
+	u32 unit;
 
-	reg = ipa_reg(ipa, IRQ_SUSPEND_INFO);
-	val = ioread32(ipa->reg_virt + ipa_reg_offset(reg));
+	unit_count = roundup(ipa->endpoint_count, 32);
+	for (unit = 0; unit < unit_count; unit++) {
+		const struct ipa_reg *reg;
+		u32 val;
 
-	/* SUSPEND interrupt status isn't cleared on IPA version 3.0 */
-	if (ipa->version == IPA_VERSION_3_0)
-		return;
+		reg = ipa_reg(ipa, IRQ_SUSPEND_INFO);
+		val = ioread32(ipa->reg_virt + ipa_reg_n_offset(reg, unit));
 
-	reg = ipa_reg(ipa, IRQ_SUSPEND_CLR);
-	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
+		/* SUSPEND interrupt status isn't cleared on IPA version 3.0 */
+		if (ipa->version == IPA_VERSION_3_0)
+			continue;
+
+		reg = ipa_reg(ipa, IRQ_SUSPEND_CLR);
+		iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, unit));
+	}
 }
 
 /* Simulate arrival of an IPA TX_SUSPEND interrupt */
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.1.c b/drivers/net/ipa/reg/ipa_reg-v3.1.c
index 0b6edc2912bd3..677ece3bce9e5 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.1.c
@@ -386,13 +386,16 @@ static const u32 ipa_reg_ipa_irq_uc_fmask[] = {
 IPA_REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(IRQ_SUSPEND_INFO, irq_suspend_info, 0x00003030 + 0x1000 * GSI_EE_AP);
+IPA_REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
+	       0x00003030 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(IRQ_SUSPEND_EN, irq_suspend_en, 0x00003034 + 0x1000 * GSI_EE_AP);
+IPA_REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
+	       0x00003034 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(IRQ_SUSPEND_CLR, irq_suspend_clr, 0x00003038 + 0x1000 * GSI_EE_AP);
+IPA_REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
+	       0x00003038 + 0x1000 * GSI_EE_AP, 0x0004);
 
 static const struct ipa_reg *ipa_reg_array[] = {
 	[COMP_CFG]			= &ipa_reg_comp_cfg,
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
index 10f62f6aaf7a4..b9c6a50de2436 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
@@ -397,13 +397,16 @@ static const u32 ipa_reg_ipa_irq_uc_fmask[] = {
 IPA_REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(IRQ_SUSPEND_INFO, irq_suspend_info, 0x00003030 + 0x1000 * GSI_EE_AP);
+IPA_REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
+	       0x00003030 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(IRQ_SUSPEND_EN, irq_suspend_en, 0x00003034 + 0x1000 * GSI_EE_AP);
+IPA_REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
+	       0x00003034 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(IRQ_SUSPEND_CLR, irq_suspend_clr, 0x00003038 + 0x1000 * GSI_EE_AP);
+IPA_REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
+	       0x00003038 + 0x1000 * GSI_EE_AP, 0x0004);
 
 static const struct ipa_reg *ipa_reg_array[] = {
 	[COMP_CFG]			= &ipa_reg_comp_cfg,
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.11.c b/drivers/net/ipa/reg/ipa_reg-v4.11.c
index 113a25c006da1..9a315130530dd 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.11.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.11.c
@@ -453,13 +453,16 @@ static const u32 ipa_reg_ipa_irq_uc_fmask[] = {
 IPA_REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000401c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(IRQ_SUSPEND_INFO, irq_suspend_info, 0x00004030 + 0x1000 * GSI_EE_AP);
+IPA_REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
+	       0x00004030 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(IRQ_SUSPEND_EN, irq_suspend_en, 0x00004034 + 0x1000 * GSI_EE_AP);
+IPA_REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
+	       0x00004034 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(IRQ_SUSPEND_CLR, irq_suspend_clr, 0x00004038 + 0x1000 * GSI_EE_AP);
+IPA_REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
+	       0x00004038 + 0x1000 * GSI_EE_AP, 0x0004);
 
 static const struct ipa_reg *ipa_reg_array[] = {
 	[COMP_CFG]			= &ipa_reg_comp_cfg,
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.2.c b/drivers/net/ipa/reg/ipa_reg-v4.2.c
index c93f2da9290fc..7a95149f8ec7a 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.2.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.2.c
@@ -399,13 +399,16 @@ static const u32 ipa_reg_ipa_irq_uc_fmask[] = {
 IPA_REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(IRQ_SUSPEND_INFO, irq_suspend_info, 0x00003030 + 0x1000 * GSI_EE_AP);
+IPA_REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
+	       0x00003030 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(IRQ_SUSPEND_EN, irq_suspend_en, 0x00003034 + 0x1000 * GSI_EE_AP);
+IPA_REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
+	       0x00003034 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(IRQ_SUSPEND_CLR, irq_suspend_clr, 0x00003038 + 0x1000 * GSI_EE_AP);
+IPA_REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
+	       0x00003038 + 0x1000 * GSI_EE_AP, 0x0004);
 
 static const struct ipa_reg *ipa_reg_array[] = {
 	[COMP_CFG]			= &ipa_reg_comp_cfg,
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.5.c b/drivers/net/ipa/reg/ipa_reg-v4.5.c
index 1615c5ead8cc1..587eb8d4e00f7 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.5.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.5.c
@@ -472,13 +472,16 @@ static const u32 ipa_reg_ipa_irq_uc_fmask[] = {
 IPA_REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(IRQ_SUSPEND_INFO, irq_suspend_info, 0x00003030 + 0x1000 * GSI_EE_AP);
+IPA_REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
+	       0x00003030 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(IRQ_SUSPEND_EN, irq_suspend_en, 0x00003034 + 0x1000 * GSI_EE_AP);
+IPA_REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
+	       0x00003034 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(IRQ_SUSPEND_CLR, irq_suspend_clr, 0x00003038 + 0x1000 * GSI_EE_AP);
+IPA_REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
+	       0x00003038 + 0x1000 * GSI_EE_AP, 0x0004);
 
 static const struct ipa_reg *ipa_reg_array[] = {
 	[COMP_CFG]			= &ipa_reg_comp_cfg,
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.9.c b/drivers/net/ipa/reg/ipa_reg-v4.9.c
index 4efc890d31589..1f67a03fe5992 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.9.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.9.c
@@ -450,13 +450,16 @@ static const u32 ipa_reg_ipa_irq_uc_fmask[] = {
 IPA_REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000401c + 0x1000 * GSI_EE_AP);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(IRQ_SUSPEND_INFO, irq_suspend_info, 0x00004030 + 0x1000 * GSI_EE_AP);
+IPA_REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
+	       0x00004030 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(IRQ_SUSPEND_EN, irq_suspend_en, 0x00004034 + 0x1000 * GSI_EE_AP);
+IPA_REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
+	       0x00004034 + 0x1000 * GSI_EE_AP, 0x0004);
 
 /* Valid bits defined by ipa->available */
-IPA_REG(IRQ_SUSPEND_CLR, irq_suspend_clr, 0x00004038 + 0x1000 * GSI_EE_AP);
+IPA_REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
+	       0x00004038 + 0x1000 * GSI_EE_AP, 0x0004);
 
 static const struct ipa_reg *ipa_reg_array[] = {
 	[COMP_CFG]			= &ipa_reg_comp_cfg,
-- 
2.34.1

