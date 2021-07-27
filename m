Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87133D7E9D
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 21:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhG0Tqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 15:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbhG0Tqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 15:46:35 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EC2C061764
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 12:46:33 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id m13so107865iol.7
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 12:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2G5lQvEnI5L7BAUDwmuhfg8oZzrhcwdOUc0mzF2aRsc=;
        b=Mp7tC8vOl5C2a2JYxESAytRd5Qb1AzB9ZFF+kS2kCRs+HYCJr3feYT/2YfjZzGi5GB
         TKbfT4o3YNzt8k8I0cqukBSAo5X6gF5yANonz3all/ow1ejcGzsHmXMlctma9kf6Zmr/
         rczoiOvhnM/oD6JW4G91cSSwgtNjrQqkNtB2A4u3rtZhKmbUFIgfJx7cxYhW15pkU3He
         zROXvWjDpAQ37+29PBD7uziK4shBu11cgPlljL5sgOKUys2OqQdpTiGZUL/0Cq0+tNtr
         jP3JxQiVdep4aTZ8aqYEU+iJnENvLFatpK/Np4fQpj+ZVEViT0BqapbKiGv0xg34svVw
         74pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2G5lQvEnI5L7BAUDwmuhfg8oZzrhcwdOUc0mzF2aRsc=;
        b=hF4+XhAw39X7c8TRFluKHXqkubj+0mw2zkMOM+B5FwuQ3wTvO0bUkT2Yp3yy+g61Yl
         yOir2OX47hDaPM2B2OtPszeyQyNY9IBFKlLLSi2S66N5QE56ijXb/F27ujAG8NOKcVVw
         Am3JjBuM2bTFGJUpLUVs6JxGlOxO4HKR+al6WjxZjT6p/pIbUadAVbY6qMDsy18TeA2K
         qpqKMVIH9eVqIOmzjXZvDhzMB5slzDBFpnDRKwTkQ/UGDO+J7+zBkRxYLT5Wp7UJ8Cla
         d7xK62zxlV21O5FSq6mQkr8ZaqPRGufsH5knkZJ/CUAoRtpK5pGWhL0QQp3h8iJSt+SP
         6niQ==
X-Gm-Message-State: AOAM531Oihf1w1gO55j2hmxuvjN3oQBDtCNoKYQx0oATmuoLQEyPSl8v
        esScTb6tcQo58/YV2ZseofykjA==
X-Google-Smtp-Source: ABdhPJxW7trJGBuq9D/FTOdvwU9uganS4E7JRZEnslTh0xbN1qbZJ1p+phGPrZjZ5dHKPTTi7bcf6Q==
X-Received: by 2002:a6b:ec0d:: with SMTP id c13mr20756506ioh.108.1627415193209;
        Tue, 27 Jul 2021 12:46:33 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c1sm2443014ils.21.2021.07.27.12.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 12:46:32 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/4] net: ipa: make IPA interrupt handler threaded only
Date:   Tue, 27 Jul 2021 14:46:26 -0500
Message-Id: <20210727194629.841131-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210727194629.841131-1-elder@linaro.org>
References: <20210727194629.841131-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the IPA interrupt handler runs, the IPA core clock must already
be operational, and the interconnect providing access by the AP to
IPA config space must be enabled too.

Currently we ensure this by taking a top-level "stay awake" IPA
clock reference, but that will soon go away.  In preparation for
that, move all handling for the IPA IRQ into the thread function.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_interrupt.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index 9fd158dd90473..7dee4ebaf5a95 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -100,32 +100,22 @@ static void ipa_interrupt_process_all(struct ipa_interrupt *interrupt)
 	}
 }
 
-/* Threaded part of the IPA IRQ handler */
+/* IPA IRQ handler is threaded */
 static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
-{
-	struct ipa_interrupt *interrupt = dev_id;
-
-	ipa_clock_get(interrupt->ipa);
-
-	ipa_interrupt_process_all(interrupt);
-
-	ipa_clock_put(interrupt->ipa);
-
-	return IRQ_HANDLED;
-}
-
-/* Hard part (i.e., "real" IRQ handler) of the IRQ handler */
-static irqreturn_t ipa_isr(int irq, void *dev_id)
 {
 	struct ipa_interrupt *interrupt = dev_id;
 	struct ipa *ipa = interrupt->ipa;
 	u32 offset;
 	u32 mask;
 
+	ipa_clock_get(ipa);
+
 	offset = ipa_reg_irq_stts_offset(ipa->version);
 	mask = ioread32(ipa->reg_virt + offset);
-	if (mask & interrupt->enabled)
-		return IRQ_WAKE_THREAD;
+	if (mask & interrupt->enabled) {
+		ipa_interrupt_process_all(interrupt);
+		goto out_clock_put;
+	}
 
 	/* Nothing in the mask was supposed to cause an interrupt */
 	offset = ipa_reg_irq_clr_offset(ipa->version);
@@ -134,6 +124,9 @@ static irqreturn_t ipa_isr(int irq, void *dev_id)
 	dev_err(&ipa->pdev->dev, "%s: unexpected interrupt, mask 0x%08x\n",
 		__func__, mask);
 
+out_clock_put:
+	ipa_clock_put(ipa);
+
 	return IRQ_HANDLED;
 }
 
@@ -260,7 +253,7 @@ struct ipa_interrupt *ipa_interrupt_config(struct ipa *ipa)
 	offset = ipa_reg_irq_en_offset(ipa->version);
 	iowrite32(0, ipa->reg_virt + offset);
 
-	ret = request_threaded_irq(irq, ipa_isr, ipa_isr_thread, IRQF_ONESHOT,
+	ret = request_threaded_irq(irq, NULL, ipa_isr_thread, IRQF_ONESHOT,
 				   "ipa", interrupt);
 	if (ret) {
 		dev_err(dev, "error %d requesting \"ipa\" IRQ\n", ret);
-- 
2.27.0

