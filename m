Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400CB2676F0
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgILAsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbgILApt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 20:45:49 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4072AC06179A
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 17:45:41 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id d190so12959465iof.3
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 17:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6l4tdMeRmxzggJyDsuQpGPMnQKd0WjklRLIqQAdVFaM=;
        b=IpKhQQQ9M9KfG12g585751mFf8MpJMhEx64T4xDG4EXsl/5rGVWhZ/VMApit3TX+NL
         sxSq2lipWeVHDEA24HwiBe5z6m/GDJMEkQTiOZiKxZR73Kjh7etN6fZ4L2YCubmm/DIN
         u+728c2fYQcbyqsuq2hYlQPDd4MV44HNhKkN21rHVON6ECKMIRKcpKtthlVXXE8+rYMe
         cb4bS6IXcKDSIQpRE8qcXT+UGQegKDITAKpg9f7ckFvmengjz4zsrsN8LT/KyD1Zw9BM
         OEFWz4k1yxe6ZMLDSquJdVNqVDJtG/KkEGkdqQapxkaDbAmv/Y612d2lu0lct8uwU3Rg
         Jumw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6l4tdMeRmxzggJyDsuQpGPMnQKd0WjklRLIqQAdVFaM=;
        b=GcoDM3Re+BfTmxidQ1PhqqdTU1hT4xoNMlAElGfX5buRG/KXZJyIGfpSH1VgtFW8JI
         YNQ82WguIs5me8CHVF/29zAKjtfXkv295Kkso0uAAYkfn6T5cbaEoKkeGsF0ODKd+xF+
         vTTsKDLUd96CbuTvZNWBHGk7oKw/ODul3slnjVoE+dtHtf4/nHjCOr6i2hY/JcDEG43E
         V+bq1sbA5eVxym4RJnFch+JiqjEysydyVWAP0BTOmfSvIdKl3Fizz0Wvox0s+tpyvnih
         PpwPsZz8XSMEvu0cFDg2W+Si08+1rS2VNcOd2FpEY+TRnqADoUwqgeogHrZiqkOi/g/V
         pUaQ==
X-Gm-Message-State: AOAM5339c7kQqRVg7u/fzjq04gwomqeon8Fv5OZ5fEuWRTANRigXlIXa
        yw1i4V4IMLvbXCUJh0K2Add8tCL8/1NILw==
X-Google-Smtp-Source: ABdhPJzxMzGfxMJkuThmFvp0lwC+0HNch9jKtcJJcxilCSJ4nVmZRUm0AiUDHwVd6Km4oXBebbXnIw==
X-Received: by 2002:a02:a615:: with SMTP id c21mr3780852jam.106.1599871540562;
        Fri, 11 Sep 2020 17:45:40 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z4sm2107807ilh.45.2020.09.11.17.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 17:45:40 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 5/7] net: ipa: use device_init_wakeup()
Date:   Fri, 11 Sep 2020 19:45:30 -0500
Message-Id: <20200912004532.1386-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200912004532.1386-1-elder@linaro.org>
References: <20200912004532.1386-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The call to wakeup_source_register() in ipa_probe() does not do what
it was intended to do.  Call device_init_wakeup() in ipa_setup()
instead, to set the IPA device as wakeup-capable and to initially
enable wakeup capability.

When we receive a SUSPEND interrupt, call pm_wakeup_dev_event()
with a zero processing time, to simply call for a resume without
any other processing.  The ipa_resume() call will take care of
waking things up again, and will handle receiving the packet.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa.h      |  2 --
 drivers/net/ipa/ipa_main.c | 43 ++++++++++++++++----------------------
 2 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index e02fe979b645b..c688155ccf375 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -114,8 +114,6 @@ struct ipa {
 	void *zero_virt;
 	size_t zero_size;
 
-	struct wakeup_source *wakeup_source;
-
 	/* Bit masks indicating endpoint state */
 	u32 available;		/* supported by hardware */
 	u32 filter_map;
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 3b68b53c99015..5e714d9d2e5cb 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -75,18 +75,19 @@
  * @ipa:	IPA pointer
  * @irq_id:	IPA interrupt type (unused)
  *
- * When in suspended state, the IPA can trigger a resume by sending a SUSPEND
- * IPA interrupt.
+ * If an RX endpoint is in suspend state, and the IPA has a packet
+ * destined for that endpoint, the IPA generates a SUSPEND interrupt
+ * to inform the AP that it should resume the endpoint.  If we get
+ * one of these interrupts we just resume everything.
  */
 static void ipa_suspend_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
 {
-	/* Take a a single clock reference to prevent suspend.  All
-	 * endpoints will be resumed as a result.  This reference will
-	 * be dropped when we get a power management suspend request.
-	 * The first call activates the clock; ignore any others.
+	/* Just report the event, and let system resume handle the rest.
+	 * More than one endpoint could signal this; if so, ignore
+	 * all but the first.
 	 */
 	if (!test_and_set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
-		ipa_clock_get(ipa);
+		pm_wakeup_dev_event(&ipa->pdev->dev, 0, true);
 
 	/* Acknowledge/clear the suspend interrupt on all endpoints */
 	ipa_interrupt_suspend_clear_all(ipa->interrupt);
@@ -107,6 +108,7 @@ int ipa_setup(struct ipa *ipa)
 {
 	struct ipa_endpoint *exception_endpoint;
 	struct ipa_endpoint *command_endpoint;
+	struct device *dev = &ipa->pdev->dev;
 	int ret;
 
 	/* Setup for IPA v3.5.1 has some slight differences */
@@ -124,6 +126,10 @@ int ipa_setup(struct ipa *ipa)
 
 	ipa_uc_setup(ipa);
 
+	ret = device_init_wakeup(dev, true);
+	if (ret)
+		goto err_uc_teardown;
+
 	ipa_endpoint_setup(ipa);
 
 	/* We need to use the AP command TX endpoint to perform other
@@ -159,7 +165,7 @@ int ipa_setup(struct ipa *ipa)
 
 	ipa->setup_complete = true;
 
-	dev_info(&ipa->pdev->dev, "IPA driver setup completed successfully\n");
+	dev_info(dev, "IPA driver setup completed successfully\n");
 
 	return 0;
 
@@ -174,6 +180,8 @@ int ipa_setup(struct ipa *ipa)
 	ipa_endpoint_disable_one(command_endpoint);
 err_endpoint_teardown:
 	ipa_endpoint_teardown(ipa);
+	(void)device_init_wakeup(dev, false);
+err_uc_teardown:
 	ipa_uc_teardown(ipa);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
 	ipa_interrupt_teardown(ipa->interrupt);
@@ -201,6 +209,7 @@ static void ipa_teardown(struct ipa *ipa)
 	command_endpoint = ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX];
 	ipa_endpoint_disable_one(command_endpoint);
 	ipa_endpoint_teardown(ipa);
+	(void)device_init_wakeup(&ipa->pdev->dev, false);
 	ipa_uc_teardown(ipa);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
 	ipa_interrupt_teardown(ipa->interrupt);
@@ -715,7 +724,6 @@ static void ipa_validate_build(void)
  */
 static int ipa_probe(struct platform_device *pdev)
 {
-	struct wakeup_source *wakeup_source;
 	struct device *dev = &pdev->dev;
 	const struct ipa_data *data;
 	struct ipa_clock *clock;
@@ -764,19 +772,11 @@ static int ipa_probe(struct platform_device *pdev)
 		goto err_clock_exit;
 	}
 
-	/* Create a wakeup source. */
-	wakeup_source = wakeup_source_register(dev, "ipa");
-	if (!wakeup_source) {
-		/* The most likely reason for failure is memory exhaustion */
-		ret = -ENOMEM;
-		goto err_clock_exit;
-	}
-
 	/* Allocate and initialize the IPA structure */
 	ipa = kzalloc(sizeof(*ipa), GFP_KERNEL);
 	if (!ipa) {
 		ret = -ENOMEM;
-		goto err_wakeup_source_unregister;
+		goto err_clock_exit;
 	}
 
 	ipa->pdev = pdev;
@@ -784,7 +784,6 @@ static int ipa_probe(struct platform_device *pdev)
 	ipa->modem_rproc = rproc;
 	ipa->clock = clock;
 	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
-	ipa->wakeup_source = wakeup_source;
 	ipa->version = data->version;
 
 	ret = ipa_reg_init(ipa);
@@ -863,8 +862,6 @@ static int ipa_probe(struct platform_device *pdev)
 	ipa_reg_exit(ipa);
 err_kfree_ipa:
 	kfree(ipa);
-err_wakeup_source_unregister:
-	wakeup_source_unregister(wakeup_source);
 err_clock_exit:
 	ipa_clock_exit(clock);
 err_rproc_put:
@@ -878,11 +875,8 @@ static int ipa_remove(struct platform_device *pdev)
 	struct ipa *ipa = dev_get_drvdata(&pdev->dev);
 	struct rproc *rproc = ipa->modem_rproc;
 	struct ipa_clock *clock = ipa->clock;
-	struct wakeup_source *wakeup_source;
 	int ret;
 
-	wakeup_source = ipa->wakeup_source;
-
 	if (ipa->setup_complete) {
 		ret = ipa_modem_stop(ipa);
 		if (ret)
@@ -899,7 +893,6 @@ static int ipa_remove(struct platform_device *pdev)
 	ipa_mem_exit(ipa);
 	ipa_reg_exit(ipa);
 	kfree(ipa);
-	wakeup_source_unregister(wakeup_source);
 	ipa_clock_exit(clock);
 	rproc_put(rproc);
 
-- 
2.20.1

