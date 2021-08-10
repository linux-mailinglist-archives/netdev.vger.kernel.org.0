Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CE83E83AC
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 21:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbhHJT1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 15:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbhHJT1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 15:27:33 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8FAC06179B
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 12:27:10 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id a13so409166iol.5
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 12:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pI+8m5HMPaYPQHluRxxBp4zHquq3RrMrrTVfNZPdFIk=;
        b=HSozmonS+ci2B96mKybDmnhhsWqEaMw8SELgDST7o5SeBGMIrKVB7lpWZgfpBrbIgh
         4gjxQOpdey+k+jQurniDJIiFFSKE1JufWBur4CjAZQ9AWPsdmrToKsBblubnWoiCSPe2
         Ewj5XUt8DEPF3aHHveOrW/HTfCAuYrlnkamaXQtxJRmG5n6rh8gzB7TN1I0lISt4u/DP
         qsIggBlPmdYg5xFwZp8ANIZkez619F0lk/LjXgKbtjnWW59acwHi3041bzyhJNPHWFk5
         2CytkSQrGnxLe/oXt0idnBJLHozwUJeckui8truuKgQ5WWIoud1IIVtG6L5pKUUTU/63
         W6+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pI+8m5HMPaYPQHluRxxBp4zHquq3RrMrrTVfNZPdFIk=;
        b=keHGpRBVB8TWcgXwcZ/SUk+yeknYQVetWoGkR1hAf49maOZlnSaBVTG3I4pIKsYpuf
         10EJbAEVE2E00Q7KrZbUmQnOna4LvoZta+87qsWmbDzxaMIeCypYN1ih4aKsaYjI/hOq
         0+IcM2lKQqxiANQOMJ/TfziNWRqtQ+mIZsUfUYZyHkPyKip6e5ms8vQBATavIVo+2d32
         lZBLtpryWCugQU/1rjHmiym9tHNgveXX23xLeXjhHI7hlFhyikDGNioYhE4IvoOi+e83
         IFsjXEyc8ooO0lbLwTbvk4rLRUNqDd+BbeClug+6EJFOfhiKWQubQJKdkQvLbihNbVSp
         9Tdw==
X-Gm-Message-State: AOAM531ejsVVymuLa+1iMlMh76O8+O4iuWgxtwpN3wNvy6LPJlp6/L8y
        pY+Toe7pDh4/8IY/qe08KNAILQ==
X-Google-Smtp-Source: ABdhPJwUWzcUDUZAxslMueGT9XeJeQPYKODVWD9L1uKPeMw0xf2cVrAGv6MrKo244dhgzRwejoP2/Q==
X-Received: by 2002:a5d:9681:: with SMTP id m1mr256048ion.113.1628623630357;
        Tue, 10 Aug 2021 12:27:10 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c5sm3025356ioz.25.2021.08.10.12.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 12:27:10 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/7] net: ipa: use runtime PM core
Date:   Tue, 10 Aug 2021 14:27:01 -0500
Message-Id: <20210810192704.2476461-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210810192704.2476461-1-elder@linaro.org>
References: <20210810192704.2476461-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the runtime power management core to cause hardware suspend and
resume to occur.  Enable it in ipa_clock_init() (without autosuspend),
and disable it in ipa_clock_exit().

Use ipa_runtime_suspend() as the ->runtime_suspend power operation,
and arrange for it to be called by having ipa_clock_get() call
pm_runtime_get_sync() when the first clock reference is taken.
Similarly, use ipa_runtime_resume() as the ->runtime_resume power
operation, and pm_runtime_put() when the last IPA clock reference
is dropped.

Introduce ipa_runtime_idle() as the ->runtime_idle power operation,
and have it return a non-zero value; this way suspend will never
occur except when forced.

Use pm_runtime_force_suspend() and pm_runtime_force_resume() as the
system suspend and resume callbacks, and remove ipa_suspend() and
ipa_resume().

Store a pointer to the device structure passed to ipa_clock_init(),
so it can be used by ipa_clock_exit() to disable runtime power
management.

For now we preserve IPA clock reference counting.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c | 75 +++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index c0a8fdf0777f4..f1ee0b46da005 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -60,6 +60,7 @@ enum ipa_power_flag {
  * struct ipa_clock - IPA clocking information
  * @count:		Clocking reference count
  * @mutex:		Protects clock enable/disable
+ * @dev:		IPA device pointer
  * @core:		IPA core clock
  * @flags:		Boolean state flags
  * @interconnect_count:	Number of elements in interconnect[]
@@ -68,6 +69,7 @@ enum ipa_power_flag {
 struct ipa_clock {
 	refcount_t count;
 	struct mutex mutex; /* protects clock enable/disable */
+	struct device *dev;
 	struct clk *core;
 	DECLARE_BITMAP(flags, IPA_POWER_FLAG_COUNT);
 	u32 interconnect_count;
@@ -263,13 +265,29 @@ static int ipa_runtime_resume(struct device *dev)
 	return 0;
 }
 
+static int ipa_runtime_idle(struct device *dev)
+{
+	return -EAGAIN;
+}
+
 /* Get an IPA clock reference, but only if the reference count is
  * already non-zero.  Returns true if the additional reference was
  * added successfully, or false otherwise.
  */
 bool ipa_clock_get_additional(struct ipa *ipa)
 {
-	return refcount_inc_not_zero(&ipa->clock->count);
+	struct device *dev;
+	int ret;
+
+	if (!refcount_inc_not_zero(&ipa->clock->count))
+		return false;
+
+	dev = &ipa->pdev->dev;
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0)
+		dev_err(dev, "error %d enabling power\n", ret);
+
+	return true;
 }
 
 /* Get an IPA clock reference.  If the reference count is non-zero, it is
@@ -283,6 +301,7 @@ bool ipa_clock_get_additional(struct ipa *ipa)
 int ipa_clock_get(struct ipa *ipa)
 {
 	struct ipa_clock *clock = ipa->clock;
+	struct device *dev;
 	int ret;
 
 	/* If the clock is running, just bump the reference count */
@@ -298,7 +317,8 @@ int ipa_clock_get(struct ipa *ipa)
 		goto out_mutex_unlock;
 	}
 
-	ret = ipa_runtime_resume(&ipa->pdev->dev);
+	dev = &ipa->pdev->dev;
+	ret = pm_runtime_get_sync(dev);
 
 	refcount_set(&clock->count, 1);
 
@@ -313,14 +333,17 @@ int ipa_clock_get(struct ipa *ipa)
  */
 int ipa_clock_put(struct ipa *ipa)
 {
+	struct device *dev = &ipa->pdev->dev;
 	struct ipa_clock *clock = ipa->clock;
+	int last;
 	int ret;
 
 	/* If this is not the last reference there's nothing more to do */
-	if (!refcount_dec_and_mutex_lock(&clock->count, &clock->mutex))
-		return 0;
+	last = refcount_dec_and_mutex_lock(&clock->count, &clock->mutex);
 
-	ret = ipa_runtime_suspend(&ipa->pdev->dev);
+	ret = pm_runtime_put(dev);
+	if (!last)
+		return ret;
 
 	mutex_unlock(&clock->mutex);
 
@@ -394,6 +417,7 @@ ipa_clock_init(struct device *dev, const struct ipa_clock_data *data)
 		ret = -ENOMEM;
 		goto err_clk_put;
 	}
+	clock->dev = dev;
 	clock->core = clk;
 	clock->interconnect_count = data->interconnect_count;
 
@@ -404,6 +428,9 @@ ipa_clock_init(struct device *dev, const struct ipa_clock_data *data)
 	mutex_init(&clock->mutex);
 	refcount_set(&clock->count, 0);
 
+	pm_runtime_dont_use_autosuspend(dev);
+	pm_runtime_enable(dev);
+
 	return clock;
 
 err_kfree:
@@ -420,43 +447,17 @@ void ipa_clock_exit(struct ipa_clock *clock)
 	struct clk *clk = clock->core;
 
 	WARN_ON(refcount_read(&clock->count) != 0);
+	pm_runtime_disable(clock->dev);
 	mutex_destroy(&clock->mutex);
 	ipa_interconnect_exit(clock);
 	kfree(clock);
 	clk_put(clk);
 }
 
-/**
- * ipa_suspend() - Power management system suspend callback
- * @dev:	IPA device structure
- *
- * Return:	0 on success, or a negative error code
- *
- * Called by the PM framework when a system suspend operation is invoked.
- * Suspends endpoints and releases the clock reference held to keep
- * the IPA clock running until this point.
- */
-static int ipa_suspend(struct device *dev)
-{
-	return ipa_runtime_suspend(dev);
-}
-
-/**
- * ipa_resume() - Power management system resume callback
- * @dev:	IPA device structure
- *
- * Return:	0 on success, or a negative error code
- *
- * Called by the PM framework when a system resume operation is invoked.
- * Takes an IPA clock reference to keep the clock running until suspend,
- * and resumes endpoints.
- */
-static int ipa_resume(struct device *dev)
-{
-	return ipa_runtime_resume(dev);
-}
-
 const struct dev_pm_ops ipa_pm_ops = {
-	.suspend	= ipa_suspend,
-	.resume		= ipa_resume,
+	.suspend		= pm_runtime_force_suspend,
+	.resume			= pm_runtime_force_resume,
+	.runtime_suspend	= ipa_runtime_suspend,
+	.runtime_resume		= ipa_runtime_resume,
+	.runtime_idle		= ipa_runtime_idle,
 };
-- 
2.27.0

