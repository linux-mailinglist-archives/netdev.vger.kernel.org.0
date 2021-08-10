Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920523E83A7
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 21:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhHJT1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 15:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbhHJT1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 15:27:30 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84755C0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 12:27:08 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id a4so145510ilj.12
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 12:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tejswFKJ+fSM+4wn7Zu/HrCpQ8GGzNEx5c69sEqueIA=;
        b=RYlzrTPqEkv+pZFjFuRcC5IbA0FsSkgAiIwEmZcRpadMl3/rwsvy35AiWE/SZ4Yk5z
         0myIEAoT77moh28NtF/9TlSbDo0oaQYI6+av3TCkoOintlhyafsmJ3I4XtNK+v3OlT70
         VGOAvxLZQsAv2f4DV/jeHYnMZHZ/HkbTs9Rw5paWuBjXYDZy5OWYDld+aNb5UznM79+4
         b3zqgNSIuQfTqZfJTTsvHhwlekcj8dqCBT0qpC/bZavw9scncb9gtv0DNV5nxv7CoHNG
         7wNYT1o2lBRRFXblhHh4AY4OkZvoAzBu3mKk1FribUTCzaXpjkAhXsXUHQiadDvpBC0x
         GZSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tejswFKJ+fSM+4wn7Zu/HrCpQ8GGzNEx5c69sEqueIA=;
        b=cHZDTxceeR+GtPKVqf8fuLeJ6prLLNizzhhvUPm5JiKqpHtrvWtj906zr3h27p3Hyo
         1V9XknbHw3B3x2Nn9W3L+OnfBIDzxtD4lNibuz0rHrAudtkh2vOXLWlGCRltmsa5VLfG
         yt0T7atmqb24BHVz8pJ7Y6JCgZ8II5R7kNTIIR1QgyLykM/seJQXY+4UAdJ2JiE5rt/T
         f8Tz92psBuZQ36McSFRWEtksQId9WQt+wZSXcJONkb2W/v6tPvVoP1UhfxwgAHuFLSkn
         x8g+GwvOASMpkf52Spot/mn3aVf0D0iVBj1dMjcYTzYvXufl2UzL+0tgb9t63ng1l/zG
         HWdg==
X-Gm-Message-State: AOAM531BA8VyQBXsa4CgtqXWR4SED/L+nOVPCwnosz0kGJupmjbEQ7Z9
        yEYexbQ2hqKbHoe5+/jXrQG9Qw==
X-Google-Smtp-Source: ABdhPJyLCOdxbbxGk55N8dGWBWK3e91GAMYtrhBbxexZXVnSCy5QX+LPWD72FvqUqUjUNZeUTzfWlg==
X-Received: by 2002:a05:6e02:1047:: with SMTP id p7mr179109ilj.125.1628623627817;
        Tue, 10 Aug 2021 12:27:07 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c5sm3025356ioz.25.2021.08.10.12.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 12:27:07 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/7] net: ipa: have ipa_clock_get() return a value
Date:   Tue, 10 Aug 2021 14:26:58 -0500
Message-Id: <20210810192704.2476461-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210810192704.2476461-1-elder@linaro.org>
References: <20210810192704.2476461-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We currently assume no errors occur when enabling or disabling the
IPA core clock and interconnects.  And although this commit exposes
errors that could occur, we generally assume this won't happen in
practice.

This commit changes ipa_clock_get() and ipa_clock_put() so each
returns a value.  The values returned are meant to mimic what the
runtime power management functions return, so we can set up error
handling here before we make the switch.  Have ipa_clock_get()
increment the reference count even if it returns an error, to match
the behavior of pm_runtime_get().

More details follow.

When taking a reference in ipa_clock_get(), return 0 for the first
reference, 1 for subsequent references, or a negative error code if
an error occurs.  Note that if ipa_clock_get() returns an error, we
must not touch hardware; in some cases such errors now cause entire
blocks of code to be skipped.

When dropping a reference in ipa_clock_put(), we return 0 or an
error code.  The error would come from ipa_clock_disable(), which
now returns what ipa_interconnect_disable() returns (either 0 or a
negative error code).  For now, callers ignore the return value;
if an error occurs, a message will have already been logged, and
little more can actually be done to improve the situation.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c     | 44 +++++++++++++++++++++------------
 drivers/net/ipa/ipa_clock.h     | 14 ++++++++---
 drivers/net/ipa/ipa_interrupt.c |  9 ++++---
 drivers/net/ipa/ipa_main.c      | 36 ++++++++++++++++-----------
 drivers/net/ipa/ipa_modem.c     | 15 +++++++----
 drivers/net/ipa/ipa_smp2p.c     | 28 +++++++++++----------
 drivers/net/ipa/ipa_uc.c        | 12 ++++++---
 7 files changed, 99 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index a67b6136e3c01..d5a8b45ee59d1 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -223,10 +223,11 @@ static int ipa_clock_enable(struct ipa *ipa)
 }
 
 /* Inverse of ipa_clock_enable() */
-static void ipa_clock_disable(struct ipa *ipa)
+static int ipa_clock_disable(struct ipa *ipa)
 {
 	clk_disable_unprepare(ipa->clock->core);
-	(void)ipa_interconnect_disable(ipa);
+
+	return ipa_interconnect_disable(ipa);
 }
 
 /* Get an IPA clock reference, but only if the reference count is
@@ -246,43 +247,51 @@ bool ipa_clock_get_additional(struct ipa *ipa)
  * Incrementing the reference count is intentionally deferred until
  * after the clock is running and endpoints are resumed.
  */
-void ipa_clock_get(struct ipa *ipa)
+int ipa_clock_get(struct ipa *ipa)
 {
 	struct ipa_clock *clock = ipa->clock;
 	int ret;
 
 	/* If the clock is running, just bump the reference count */
 	if (ipa_clock_get_additional(ipa))
-		return;
+		return 1;
 
 	/* Otherwise get the mutex and check again */
 	mutex_lock(&clock->mutex);
 
 	/* A reference might have been added before we got the mutex. */
-	if (ipa_clock_get_additional(ipa))
+	if (ipa_clock_get_additional(ipa)) {
+		ret = 1;
 		goto out_mutex_unlock;
+	}
 
 	ret = ipa_clock_enable(ipa);
-	if (!ret)
-		refcount_set(&clock->count, 1);
+
+	refcount_set(&clock->count, 1);
+
 out_mutex_unlock:
 	mutex_unlock(&clock->mutex);
+
+	return ret;
 }
 
 /* Attempt to remove an IPA clock reference.  If this represents the
  * last reference, disable the IPA clock under protection of the mutex.
  */
-void ipa_clock_put(struct ipa *ipa)
+int ipa_clock_put(struct ipa *ipa)
 {
 	struct ipa_clock *clock = ipa->clock;
+	int ret;
 
 	/* If this is not the last reference there's nothing more to do */
 	if (!refcount_dec_and_mutex_lock(&clock->count, &clock->mutex))
-		return;
+		return 0;
 
-	ipa_clock_disable(ipa);
+	ret = ipa_clock_disable(ipa);
 
 	mutex_unlock(&clock->mutex);
+
+	return ret;
 }
 
 /* Return the current IPA core clock rate */
@@ -388,7 +397,7 @@ void ipa_clock_exit(struct ipa_clock *clock)
  * ipa_suspend() - Power management system suspend callback
  * @dev:	IPA device structure
  *
- * Return:	Always returns zero
+ * Return:	0 on success, or a negative error code
  *
  * Called by the PM framework when a system suspend operation is invoked.
  * Suspends endpoints and releases the clock reference held to keep
@@ -405,16 +414,14 @@ static int ipa_suspend(struct device *dev)
 		gsi_suspend(&ipa->gsi);
 	}
 
-	ipa_clock_put(ipa);
-
-	return 0;
+	return ipa_clock_put(ipa);
 }
 
 /**
  * ipa_resume() - Power management system resume callback
  * @dev:	IPA device structure
  *
- * Return:	Always returns 0
+ * Return:	0 on success, or a negative error code
  *
  * Called by the PM framework when a system resume operation is invoked.
  * Takes an IPA clock reference to keep the clock running until suspend,
@@ -423,11 +430,16 @@ static int ipa_suspend(struct device *dev)
 static int ipa_resume(struct device *dev)
 {
 	struct ipa *ipa = dev_get_drvdata(dev);
+	int ret;
 
 	/* This clock reference will keep the IPA out of suspend
 	 * until we get a power management suspend request.
 	 */
-	ipa_clock_get(ipa);
+	ret = ipa_clock_get(ipa);
+	if (WARN_ON(ret < 0)) {
+		(void)ipa_clock_put(ipa);
+		return ret;
+	}
 
 	/* Endpoints aren't usable until setup is complete */
 	if (ipa->setup_complete) {
diff --git a/drivers/net/ipa/ipa_clock.h b/drivers/net/ipa/ipa_clock.h
index 2a0f7ff3c9e64..8692c0d98bd1c 100644
--- a/drivers/net/ipa/ipa_clock.h
+++ b/drivers/net/ipa/ipa_clock.h
@@ -54,14 +54,20 @@ void ipa_clock_exit(struct ipa_clock *clock);
  * ipa_clock_get() - Get an IPA clock reference
  * @ipa:	IPA pointer
  *
- * This call blocks if this is the first reference.
+ * Return:	0 if clock started, 1 if clock already running, or a negative
+ *		error code
+ *
+ * This call blocks if this is the first reference.  A reference is
+ * taken even if an error occurs starting the IPA clock.
  */
-void ipa_clock_get(struct ipa *ipa);
+int ipa_clock_get(struct ipa *ipa);
 
 /**
  * ipa_clock_get_additional() - Get an IPA clock reference if not first
  * @ipa:	IPA pointer
  *
+ * Return:	true if reference taken, false otherwise
+ *
  * This returns immediately, and only takes a reference if not the first
  */
 bool ipa_clock_get_additional(struct ipa *ipa);
@@ -70,10 +76,12 @@ bool ipa_clock_get_additional(struct ipa *ipa);
  * ipa_clock_put() - Drop an IPA clock reference
  * @ipa:	IPA pointer
  *
+ * Return:	0 if successful, or a negative error code
+ *
  * This drops a clock reference.  If the last reference is being dropped,
  * the clock is stopped and RX endpoints are suspended.  This call will
  * not block unless the last reference is dropped.
  */
-void ipa_clock_put(struct ipa *ipa);
+int ipa_clock_put(struct ipa *ipa);
 
 #endif /* _IPA_CLOCK_H_ */
diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index aa37f03f4557f..934c14e066a0a 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -83,8 +83,11 @@ static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
 	u32 pending;
 	u32 offset;
 	u32 mask;
+	int ret;
 
-	ipa_clock_get(ipa);
+	ret = ipa_clock_get(ipa);
+	if (WARN_ON(ret < 0))
+		goto out_clock_put;
 
 	/* The status register indicates which conditions are present,
 	 * including conditions whose interrupt is not enabled.  Handle
@@ -112,8 +115,8 @@ static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
 		offset = ipa_reg_irq_clr_offset(ipa->version);
 		iowrite32(pending, ipa->reg_virt + offset);
 	}
-
-	ipa_clock_put(ipa);
+out_clock_put:
+	(void)ipa_clock_put(ipa);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 25bbb456e0078..64112a6767743 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -431,7 +431,9 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 	 * is held after initialization completes, and won't get dropped
 	 * unless/until a system suspend request arrives.
 	 */
-	ipa_clock_get(ipa);
+	ret = ipa_clock_get(ipa);
+	if (WARN_ON(ret < 0))
+		goto err_clock_put;
 
 	ipa_hardware_config(ipa, data);
 
@@ -475,7 +477,8 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 	ipa_mem_deconfig(ipa);
 err_hardware_deconfig:
 	ipa_hardware_deconfig(ipa);
-	ipa_clock_put(ipa);
+err_clock_put:
+	(void)ipa_clock_put(ipa);
 
 	return ret;
 }
@@ -493,7 +496,7 @@ static void ipa_deconfig(struct ipa *ipa)
 	ipa->interrupt = NULL;
 	ipa_mem_deconfig(ipa);
 	ipa_hardware_deconfig(ipa);
-	ipa_clock_put(ipa);
+	(void)ipa_clock_put(ipa);
 }
 
 static int ipa_firmware_load(struct device *dev)
@@ -750,20 +753,22 @@ static int ipa_probe(struct platform_device *pdev)
 		goto err_table_exit;
 
 	/* The clock needs to be active for config and setup */
-	ipa_clock_get(ipa);
+	ret = ipa_clock_get(ipa);
+	if (WARN_ON(ret < 0))
+		goto err_clock_put;
 
 	ret = ipa_config(ipa, data);
 	if (ret)
-		goto err_clock_put;	/* Error */
+		goto err_clock_put;
 
 	dev_info(dev, "IPA driver initialized");
 
 	/* If the modem is doing early initialization, it will trigger a
-	 * call to ipa_setup() call when it has finished.  In that case
-	 * we're done here.
+	 * call to ipa_setup() when it has finished.  In that case we're
+	 * done here.
 	 */
 	if (modem_init)
-		goto out_clock_put;	/* Done; no error */
+		goto done;
 
 	/* Otherwise we need to load the firmware and have Trust Zone validate
 	 * and install it.  If that succeeds we can proceed with setup.
@@ -775,16 +780,15 @@ static int ipa_probe(struct platform_device *pdev)
 	ret = ipa_setup(ipa);
 	if (ret)
 		goto err_deconfig;
-
-out_clock_put:
-	ipa_clock_put(ipa);
+done:
+	(void)ipa_clock_put(ipa);
 
 	return 0;
 
 err_deconfig:
 	ipa_deconfig(ipa);
 err_clock_put:
-	ipa_clock_put(ipa);
+	(void)ipa_clock_put(ipa);
 	ipa_modem_exit(ipa);
 err_table_exit:
 	ipa_table_exit(ipa);
@@ -810,7 +814,9 @@ static int ipa_remove(struct platform_device *pdev)
 	struct ipa_clock *clock = ipa->clock;
 	int ret;
 
-	ipa_clock_get(ipa);
+	ret = ipa_clock_get(ipa);
+	if (WARN_ON(ret < 0))
+		goto out_clock_put;
 
 	if (ipa->setup_complete) {
 		ret = ipa_modem_stop(ipa);
@@ -826,8 +832,8 @@ static int ipa_remove(struct platform_device *pdev)
 	}
 
 	ipa_deconfig(ipa);
-
-	ipa_clock_put(ipa);
+out_clock_put:
+	(void)ipa_clock_put(ipa);
 
 	ipa_modem_exit(ipa);
 	ipa_table_exit(ipa);
diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index ad4019e8016ec..06e44afd2cf66 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -45,7 +45,9 @@ static int ipa_open(struct net_device *netdev)
 	struct ipa *ipa = priv->ipa;
 	int ret;
 
-	ipa_clock_get(ipa);
+	ret = ipa_clock_get(ipa);
+	if (WARN_ON(ret < 0))
+		goto err_clock_put;
 
 	ret = ipa_endpoint_enable_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]);
 	if (ret)
@@ -62,7 +64,7 @@ static int ipa_open(struct net_device *netdev)
 err_disable_tx:
 	ipa_endpoint_disable_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]);
 err_clock_put:
-	ipa_clock_put(ipa);
+	(void)ipa_clock_put(ipa);
 
 	return ret;
 }
@@ -78,7 +80,7 @@ static int ipa_stop(struct net_device *netdev)
 	ipa_endpoint_disable_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]);
 	ipa_endpoint_disable_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]);
 
-	ipa_clock_put(ipa);
+	(void)ipa_clock_put(ipa);
 
 	return 0;
 }
@@ -297,7 +299,9 @@ static void ipa_modem_crashed(struct ipa *ipa)
 	struct device *dev = &ipa->pdev->dev;
 	int ret;
 
-	ipa_clock_get(ipa);
+	ret = ipa_clock_get(ipa);
+	if (WARN_ON(ret < 0))
+		goto out_clock_put;
 
 	ipa_endpoint_modem_pause_all(ipa, true);
 
@@ -324,7 +328,8 @@ static void ipa_modem_crashed(struct ipa *ipa)
 	if (ret)
 		dev_err(dev, "error %d zeroing modem memory regions\n", ret);
 
-	ipa_clock_put(ipa);
+out_clock_put:
+	(void)ipa_clock_put(ipa);
 }
 
 static int ipa_modem_notify(struct notifier_block *nb, unsigned long action,
diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
index 0d15438a79e2d..f84d6523636e3 100644
--- a/drivers/net/ipa/ipa_smp2p.c
+++ b/drivers/net/ipa/ipa_smp2p.c
@@ -150,24 +150,26 @@ static void ipa_smp2p_panic_notifier_unregister(struct ipa_smp2p *smp2p)
 static irqreturn_t ipa_smp2p_modem_setup_ready_isr(int irq, void *dev_id)
 {
 	struct ipa_smp2p *smp2p = dev_id;
+	int ret;
 
 	mutex_lock(&smp2p->mutex);
 
-	if (!smp2p->disabled) {
-		int ret;
+	if (smp2p->disabled)
+		goto out_mutex_unlock;
+	smp2p->disabled = true;		/* If any others arrive, ignore them */
 
-		/* The clock needs to be active for setup */
-		ipa_clock_get(smp2p->ipa);
+	/* The clock needs to be active for setup */
+	ret = ipa_clock_get(smp2p->ipa);
+	if (WARN_ON(ret < 0))
+		goto out_clock_put;
 
-		ret = ipa_setup(smp2p->ipa);
-		if (ret)
-			dev_err(&smp2p->ipa->pdev->dev,
-				"error %d from ipa_setup()\n", ret);
-		smp2p->disabled = true;
-
-		ipa_clock_put(smp2p->ipa);
-	}
+	/* An error here won't cause driver shutdown, so warn if one occurs */
+	ret = ipa_setup(smp2p->ipa);
+	WARN(ret != 0, "error %d from ipa_setup()\n", ret);
 
+out_clock_put:
+	(void)ipa_clock_put(smp2p->ipa);
+out_mutex_unlock:
 	mutex_unlock(&smp2p->mutex);
 
 	return IRQ_HANDLED;
@@ -206,7 +208,7 @@ static void ipa_smp2p_clock_release(struct ipa *ipa)
 	if (!ipa->smp2p->clock_on)
 		return;
 
-	ipa_clock_put(ipa);
+	(void)ipa_clock_put(ipa);
 	ipa->smp2p->clock_on = false;
 }
 
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index f88ee02457d49..9c8818c390731 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -154,7 +154,7 @@ static void ipa_uc_response_hdlr(struct ipa *ipa, enum ipa_irq_id irq_id)
 	case IPA_UC_RESPONSE_INIT_COMPLETED:
 		if (ipa->uc_clocked) {
 			ipa->uc_loaded = true;
-			ipa_clock_put(ipa);
+			(void)ipa_clock_put(ipa);
 			ipa->uc_clocked = false;
 		} else {
 			dev_warn(dev, "unexpected init_completed response\n");
@@ -182,21 +182,25 @@ void ipa_uc_deconfig(struct ipa *ipa)
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_1);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_0);
 	if (ipa->uc_clocked)
-		ipa_clock_put(ipa);
+		(void)ipa_clock_put(ipa);
 }
 
 /* Take a proxy clock reference for the microcontroller */
 void ipa_uc_clock(struct ipa *ipa)
 {
 	static bool already;
+	int ret;
 
 	if (already)
 		return;
 	already = true;		/* Only do this on first boot */
 
 	/* This clock reference dropped in ipa_uc_response_hdlr() above */
-	ipa_clock_get(ipa);
-	ipa->uc_clocked = true;
+	ret = ipa_clock_get(ipa);
+	if (WARN(ret < 0, "error %d getting proxy clock\n", ret))
+		(void)ipa_clock_put(ipa);
+
+	ipa->uc_clocked = ret >= 0;
 }
 
 /* Send a command to the microcontroller */
-- 
2.27.0

