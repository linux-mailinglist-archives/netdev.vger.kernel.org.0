Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1E226E30C
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 19:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgIQR6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgIQRjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:39:41 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DC1C0612F2
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:39:35 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id b6so3128438iof.6
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rTpW3FNcBGaT4VwfmVMgzfLSYM7ObfFzlWr4lD0H81Y=;
        b=QlhMnJ4RWiyKxprNM4XBp9qS7dGEy7oolZwAPHOSewO4Rq9qLs8XsRARWl1gqte78Y
         LzV0pDl/qub20uTH0brcbvS2e36lStDuYI5IvZmc5uIKMMOLCX1UXhNh/HrWvQAv7Xgc
         rY+X4dB493DYPdFpY0u6WMPeogFqMUDbVOxuKXs6jEosh7MH+qTVwoeBV3AIOhxisJyX
         OvwBko98YQRgrAK0OZWhSO0jE8yaZ4QsiH0UR/1qtuBIngVQixXhIiOM+8wgacPOLtt5
         hgavctH+HrKhakOrcfbaIW7pn8BaXHyujRsUJvxX99hFHCI5WBfXleQE052CYmc4bz9F
         2XTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rTpW3FNcBGaT4VwfmVMgzfLSYM7ObfFzlWr4lD0H81Y=;
        b=nTqxzKWxaBaIKLD2tiKscNWGSWUmafTVqm3EpGjKumyqL79pIJeGsL1oBxvREVzLAv
         MQt/dHD/DHF/E0/RR/kq/dkMyJQAbToIL5Pbl3P/UuCoH8/i7teDghK+v4QrHiN9UgAt
         ka1dIcswfzVEI3BQo8vhpP8TAcRM+SPUeXvw8GrGZlTgrZlKalTNW0F6in5/P6/EPaIg
         YOzyfujWbsSr7GnpbXcxqjrjemm3ltW5n+bbb30QGKoIHiGCYwlI96QJipX3DJzALWY5
         U/o/pHVLJZCIi0u+r3V2SF7inAhHl39NRpjUvxRLFzhhokC1cO2JwSkgqkvOoywUA5aM
         T/FA==
X-Gm-Message-State: AOAM532PVXAK0/IkvF+0qYmSYpPkb3aJHs7ikf1fLiJBv4meZw+cj3Iz
        gUX19i5UX3CWei2N5JG5eti/BQ==
X-Google-Smtp-Source: ABdhPJzLEGo+KAG+3UA9DT6dKiUvvNbnEoQ3ziyWlJE1ljHsW3rp2MCtnBMrU+xV1fL6MzuTIsxiNw==
X-Received: by 2002:a6b:b846:: with SMTP id i67mr24671016iof.103.1600364375115;
        Thu, 17 Sep 2020 10:39:35 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l6sm192725ilt.34.2020.09.17.10.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 10:39:34 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 4/7] net: ipa: use device_init_wakeup()
Date:   Thu, 17 Sep 2020 12:39:23 -0500
Message-Id: <20200917173926.24266-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200917173926.24266-1-elder@linaro.org>
References: <20200917173926.24266-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

Note that this gets rid of a clock reference counting bug that
occurred when handling an IPA SUSPEND interrupt.  Specifically,
ipa_suspend_handler() took an IPA clock reference *in addition*
to the one taken by ipa_resume().  There is no need to back-port
this fix however, because it only affects code that was not
previously working (this patch is part of fixing that).

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
v3: Added Bjorn's reviewed-by tag.

 drivers/net/ipa/ipa.h      |  2 --
 drivers/net/ipa/ipa_main.c | 42 ++++++++++++++++----------------------
 2 files changed, 18 insertions(+), 26 deletions(-)

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
index 4d5394bcfe47e..4e2508bb1bf80 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -75,17 +75,19 @@
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
+	/* Just report the event, and let system resume handle the rest.
+	 * More than one endpoint could signal this; if so, ignore
+	 * all but the first.
 	 */
 	if (!test_and_set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
-		ipa_clock_get(ipa);
+		pm_wakeup_dev_event(&ipa->pdev->dev, 0, true);
 
 	/* Acknowledge/clear the suspend interrupt on all endpoints */
 	ipa_interrupt_suspend_clear_all(ipa->interrupt);
@@ -106,6 +108,7 @@ int ipa_setup(struct ipa *ipa)
 {
 	struct ipa_endpoint *exception_endpoint;
 	struct ipa_endpoint *command_endpoint;
+	struct device *dev = &ipa->pdev->dev;
 	int ret;
 
 	/* Setup for IPA v3.5.1 has some slight differences */
@@ -123,6 +126,10 @@ int ipa_setup(struct ipa *ipa)
 
 	ipa_uc_setup(ipa);
 
+	ret = device_init_wakeup(dev, true);
+	if (ret)
+		goto err_uc_teardown;
+
 	ipa_endpoint_setup(ipa);
 
 	/* We need to use the AP command TX endpoint to perform other
@@ -158,7 +165,7 @@ int ipa_setup(struct ipa *ipa)
 
 	ipa->setup_complete = true;
 
-	dev_info(&ipa->pdev->dev, "IPA driver setup completed successfully\n");
+	dev_info(dev, "IPA driver setup completed successfully\n");
 
 	return 0;
 
@@ -173,6 +180,8 @@ int ipa_setup(struct ipa *ipa)
 	ipa_endpoint_disable_one(command_endpoint);
 err_endpoint_teardown:
 	ipa_endpoint_teardown(ipa);
+	(void)device_init_wakeup(dev, false);
+err_uc_teardown:
 	ipa_uc_teardown(ipa);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
 	ipa_interrupt_teardown(ipa->interrupt);
@@ -200,6 +209,7 @@ static void ipa_teardown(struct ipa *ipa)
 	command_endpoint = ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX];
 	ipa_endpoint_disable_one(command_endpoint);
 	ipa_endpoint_teardown(ipa);
+	(void)device_init_wakeup(&ipa->pdev->dev, false);
 	ipa_uc_teardown(ipa);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
 	ipa_interrupt_teardown(ipa->interrupt);
@@ -709,7 +719,6 @@ static void ipa_validate_build(void)
  */
 static int ipa_probe(struct platform_device *pdev)
 {
-	struct wakeup_source *wakeup_source;
 	struct device *dev = &pdev->dev;
 	const struct ipa_data *data;
 	struct ipa_clock *clock;
@@ -758,19 +767,11 @@ static int ipa_probe(struct platform_device *pdev)
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
@@ -778,7 +779,6 @@ static int ipa_probe(struct platform_device *pdev)
 	ipa->modem_rproc = rproc;
 	ipa->clock = clock;
 	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
-	ipa->wakeup_source = wakeup_source;
 	ipa->version = data->version;
 
 	ret = ipa_reg_init(ipa);
@@ -857,8 +857,6 @@ static int ipa_probe(struct platform_device *pdev)
 	ipa_reg_exit(ipa);
 err_kfree_ipa:
 	kfree(ipa);
-err_wakeup_source_unregister:
-	wakeup_source_unregister(wakeup_source);
 err_clock_exit:
 	ipa_clock_exit(clock);
 err_rproc_put:
@@ -872,11 +870,8 @@ static int ipa_remove(struct platform_device *pdev)
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
@@ -893,7 +888,6 @@ static int ipa_remove(struct platform_device *pdev)
 	ipa_mem_exit(ipa);
 	ipa_reg_exit(ipa);
 	kfree(ipa);
-	wakeup_source_unregister(wakeup_source);
 	ipa_clock_exit(clock);
 	rproc_put(rproc);
 
-- 
2.20.1

