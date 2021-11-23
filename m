Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0727145990E
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 01:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbhKWATK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 19:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbhKWATI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 19:19:08 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8F7C061714
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 16:16:01 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id j7so12583801ilk.13
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 16:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NEmK1QJjfjflHiuyd2o6AMF3Twm1DpzXXEWoKNGwee8=;
        b=cF9QCO6hMB+TOyzPzIroWKvCvYWL19i/hyRd6RWujnH9zJ/N7RDYfiIFFzoRFDVV2E
         JC2k5G+HyprQ+M4/sj081jLaUf7oJ/rPE2CDNYJShpxt5qQwmtlZrzNXMa4z45m4e/OW
         9ZaoPbW1v/BkeYAKvc9OSUMJQPDiYpKCGyDNdNpHS7DLukNWjwIlN6dsY2ZbI0T+9JKQ
         EsTdsTu/DPyxetba9ggN3gqUYZ5m0D/+Td4lp1XFZUTr0kCstriuy0PIUkmQv8SJ1grq
         tBQ2IOWU/YZihmXjLMBaP77FY8IZJ+g+tX3GbBAR5ljBXoqBmcC1anCWAjrM3Hem12KM
         B8GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NEmK1QJjfjflHiuyd2o6AMF3Twm1DpzXXEWoKNGwee8=;
        b=KJmaT/5gBYvg8TmLKv2mBdC+RM2/jN0hqPY4y5KVq4urM51Fd0JyYNquV+2hAm0msO
         DaEw0LZZHXrSEQIrRpEc+bYghv55lfqTNq0wAzSlxuEsEL43n/nHFyKzdTGU/lw5fSjk
         ps08YZKGbYL1XORiO+Kfq7ZMPIR2KQQKKitzqCvbu23CC/usnaT5sp7nA21OAzaJWpyJ
         dmxCAxfQO+ygrMT6yWsa9mzF0O0JfW9gy4eBDsXGaiElcMSaz+bdocNfkjsfO9KASkot
         XjSa2I9AEpXazhgp0gbmXvGBbfREt/Dqc/HclGEu/TbF58e1LN3WTdaWzVF67YrntfDc
         KynA==
X-Gm-Message-State: AOAM533frR7ExmcM7lP/OaKiGHSBI9ZLgm4xgeuVHMUncLfwskHjw3LP
        49DHhrQKSQNz/TYe50jB7mHMAw==
X-Google-Smtp-Source: ABdhPJxEDc29IJ20qLK4pEwFK1cSr14nwHGLSsqw0iXT6BZqEPd7cqhgRy4CxEkfNKYeNpD4vxtBog==
X-Received: by 2002:a05:6e02:156b:: with SMTP id k11mr1127886ilu.77.1637626560968;
        Mon, 22 Nov 2021 16:16:00 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u4sm7040094ilv.81.2021.11.22.16.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 16:16:00 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     pkurapat@codeaurora.org, avuyyuru@codeaurora.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, evgreen@chromium.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] net: ipa: directly disable ipa-setup-ready interrupt
Date:   Mon, 22 Nov 2021 18:15:54 -0600
Message-Id: <20211123001555.505546-2-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123001555.505546-1-elder@linaro.org>
References: <20211123001555.505546-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We currently maintain a "disabled" Boolean flag to determine whether
the "ipa-setup-ready" SMP2P IRQ handler does anything.  That flag
must be accessed under protection of a mutex.

Instead, disable the SMP2P interrupt when requested, which prevents
the interrupt handler from ever being called.  More importantly, it
synchronizes a thread disabling the interrupt with the completion of
the interrupt handler in case they run concurrently.

Use the IPA setup_complete flag rather than the disabled flag in the
handler to determine whether to ignore any interrupts arriving after
the first.

Rename the "disabled" flag to be "setup_disabled", to be specific
about its purpose.

Fixes: 530f9216a953 ("soc: qcom: ipa: AP/modem communications")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_smp2p.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
index df7639c39d716..24bc112a072c6 100644
--- a/drivers/net/ipa/ipa_smp2p.c
+++ b/drivers/net/ipa/ipa_smp2p.c
@@ -53,7 +53,7 @@
  * @setup_ready_irq:	IPA interrupt triggered by modem to signal GSI ready
  * @power_on:		Whether IPA power is on
  * @notified:		Whether modem has been notified of power state
- * @disabled:		Whether setup ready interrupt handling is disabled
+ * @setup_disabled:	Whether setup ready interrupt handler is disabled
  * @mutex:		Mutex protecting ready-interrupt/shutdown interlock
  * @panic_notifier:	Panic notifier structure
 */
@@ -67,7 +67,7 @@ struct ipa_smp2p {
 	u32 setup_ready_irq;
 	bool power_on;
 	bool notified;
-	bool disabled;
+	bool setup_disabled;
 	struct mutex mutex;
 	struct notifier_block panic_notifier;
 };
@@ -155,11 +155,9 @@ static irqreturn_t ipa_smp2p_modem_setup_ready_isr(int irq, void *dev_id)
 	struct device *dev;
 	int ret;
 
-	mutex_lock(&smp2p->mutex);
-
-	if (smp2p->disabled)
-		goto out_mutex_unlock;
-	smp2p->disabled = true;		/* If any others arrive, ignore them */
+	/* Ignore any (spurious) interrupts received after the first */
+	if (smp2p->ipa->setup_complete)
+		return IRQ_HANDLED;
 
 	/* Power needs to be active for setup */
 	dev = &smp2p->ipa->pdev->dev;
@@ -176,8 +174,6 @@ static irqreturn_t ipa_smp2p_modem_setup_ready_isr(int irq, void *dev_id)
 out_power_put:
 	pm_runtime_mark_last_busy(dev);
 	(void)pm_runtime_put_autosuspend(dev);
-out_mutex_unlock:
-	mutex_unlock(&smp2p->mutex);
 
 	return IRQ_HANDLED;
 }
@@ -322,7 +318,10 @@ void ipa_smp2p_disable(struct ipa *ipa)
 
 	mutex_lock(&smp2p->mutex);
 
-	smp2p->disabled = true;
+	if (!smp2p->setup_disabled) {
+		disable_irq(smp2p->setup_ready_irq);
+		smp2p->setup_disabled = true;
+	}
 
 	mutex_unlock(&smp2p->mutex);
 }
-- 
2.32.0

