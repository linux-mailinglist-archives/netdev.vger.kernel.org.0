Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2C72623F5
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 02:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729940AbgIIAWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 20:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729005AbgIIAVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 20:21:41 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C88AC061796
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 17:21:36 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id a8so706686ilk.1
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 17:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OPjPRK2p71t9ZdCjb3Zea5jYz+oh8o7PLedtAuj54eo=;
        b=D+4idf1NZ8wKX+Bvh68xw2GihYbk8Qrdt50Io/Apvp1qPCja9YQMLuhYNc1SwEtQ0d
         pRabs+i056pIR1SzF5zNKXdS3jwfmE9D6vm4W1INKUsfuK35MyUKZPi6G2YmNDGwlObH
         bG2vUjwff2txxqMpwnlVvP1SYKohPJ7+t24tNF1/CGd1Z2Jg9QPtapDL8bVHcjds3Az2
         HaqCT8rGI1rT2StYCoV7MMMPDY2bV3wO8VMldMU3PJJO/olsqMmePxogbIsKIgZFFS6t
         jT9m7keaOEDXMcmXW8O9C7ARqeTcsj1mfIe9QAdMmfZKGqmgMdE8sTCiEiLPYaeNSgJN
         SOcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OPjPRK2p71t9ZdCjb3Zea5jYz+oh8o7PLedtAuj54eo=;
        b=i7etoOtCZ6pbcLvpkrBHyxKhFOiSabMcYZOx8z6ODm3jSpopXYgLlEzqdxugHOcThI
         ItTwXe5K5IHdMAFZe/7hMzdiIYAEzDlL7cKSC0YIellrL4r6wEYmKPBYz8L8/MaXOI+6
         kuvXY2v1vtCJ+ktUfAuUIbfJPRh/9qJGx5OrtRf2AFQLch7LjuzutVnsBbs8MB+gDSCa
         Mt0BgDzrnTBjIiW7uSuIlEBh4zBcN9Npmk7/1At+o1gbVaW5b2zqpQhNCyZcJQcQvF41
         FZ2UZW8CeuKmEVBf8VnAei9JIjE43DngUEsu0GcLfThL3O+MC6XRyjttv61r4yry0PaR
         ZR5w==
X-Gm-Message-State: AOAM532ik+qfXc/JwU0o/Wn2Qw01Q8rwqSDHcT3L8SL7etG4Ei9jt0WF
        QSsFq8oiZyXHak7xrx5fcvT88A==
X-Google-Smtp-Source: ABdhPJz61ej4TTXIIjTL9Va5qRhEZ65lluaOfX0jgyU8NxspTHrOeg3vsdHmC01QYwnbGUqOhraHNA==
X-Received: by 2002:a05:6e02:1023:: with SMTP id o3mr1396823ilj.141.1599610895311;
        Tue, 08 Sep 2020 17:21:35 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f21sm457739ioh.1.2020.09.08.17.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 17:21:34 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/5] net: ipa: use device_init_wakeup()
Date:   Tue,  8 Sep 2020 19:21:25 -0500
Message-Id: <20200909002127.21089-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200909002127.21089-1-elder@linaro.org>
References: <20200909002127.21089-1-elder@linaro.org>
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
index 407fee841a9a8..a1adc308e030f 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -104,8 +104,6 @@ struct ipa {
 	void *zero_virt;
 	size_t zero_size;
 
-	struct wakeup_source *wakeup_source;
-
 	/* Bit masks indicating endpoint state */
 	u32 available;		/* supported by hardware */
 	u32 filter_map;
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index b8e4a2532fc1a..92ea6a811ae31 100644
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
 	if (!atomic_xchg(&ipa->suspend_ref, 1))
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
@@ -714,7 +723,6 @@ static void ipa_validate_build(void)
  */
 static int ipa_probe(struct platform_device *pdev)
 {
-	struct wakeup_source *wakeup_source;
 	struct device *dev = &pdev->dev;
 	const struct ipa_data *data;
 	struct ipa_clock *clock;
@@ -763,19 +771,11 @@ static int ipa_probe(struct platform_device *pdev)
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
@@ -783,7 +783,6 @@ static int ipa_probe(struct platform_device *pdev)
 	ipa->modem_rproc = rproc;
 	ipa->clock = clock;
 	atomic_set(&ipa->suspend_ref, 0);
-	ipa->wakeup_source = wakeup_source;
 	ipa->version = data->version;
 
 	ret = ipa_reg_init(ipa);
@@ -862,8 +861,6 @@ static int ipa_probe(struct platform_device *pdev)
 	ipa_reg_exit(ipa);
 err_kfree_ipa:
 	kfree(ipa);
-err_wakeup_source_unregister:
-	wakeup_source_unregister(wakeup_source);
 err_clock_exit:
 	ipa_clock_exit(clock);
 err_rproc_put:
@@ -877,11 +874,8 @@ static int ipa_remove(struct platform_device *pdev)
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
@@ -898,7 +892,6 @@ static int ipa_remove(struct platform_device *pdev)
 	ipa_mem_exit(ipa);
 	ipa_reg_exit(ipa);
 	kfree(ipa);
-	wakeup_source_unregister(wakeup_source);
 	ipa_clock_exit(clock);
 	rproc_put(rproc);
 
-- 
2.20.1

