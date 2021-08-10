Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A0B3E83B1
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 21:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbhHJT2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 15:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbhHJT1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 15:27:35 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55F7C0617A3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 12:27:12 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id u7so176626ilk.7
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 12:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=75vQHBPl1C4p22sDxWz00VL6td9npCwWWXZWEV8i9ac=;
        b=QTCAsnN7e3qyk21xEzWbrDvfBDD/INdBBnRYLZuVdBqkoSLMBVdnxM59k7EOozVH+R
         e+pMVexfpCJN7iMm7+eey6RN+lNZ0avZqMrUyilG7Yx/vljXx6UcRExkDzYAqe4LYYCE
         56on2yxZo61raBUo8dA7p3I+ZV9yiBcg3AimNuNtnSNxBObd+lzxcFw6Kmzjwf17SowJ
         ZENOZz1Ljm9RZYbjBIgA4M97mX8TudInuHTKVSspB+UZFAfOFxGVA/aZXv3LaNvo4+rP
         9f2Wth7tDTimbEJVtuhduTc0spKTjkm1CWfOGM7UfxI/QTa0sOzgA/oCifByjIjkIyjI
         JCIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=75vQHBPl1C4p22sDxWz00VL6td9npCwWWXZWEV8i9ac=;
        b=iVjNbZa6652nb9Jnf6r6wmVF7Tq9qIjV4RB5R3gwV/SxGEAd3DpUhYdcp9umXPrbcD
         65an4rU9W585EkUyC7vPdU62IBrBsdLxsPzqV0j8+3bE8sElkK+TJPgj5xR6iTJYYGhG
         Q96F80aaJwEMXMAd3e4TZkE4G+XZDqJ8PqAGKSVKeIqYiRsCSC8E1N/zfwRlbYdDP3XN
         5zvF2f4U1asU78BdeQ3j300vicTG8GbSLu66NAhyeMYlW2u0I+33FXVZjKS7jvxMXuSp
         ZyNMM+eZ96N7gyEuyT9LpGf8dAsqrI7f56HqOQq57c2OQRnx0ULb2OceTYCgqg5yhoaI
         pPFA==
X-Gm-Message-State: AOAM5306VNM4H2pmFdr/pXJsmanW5bPJKI630gt7j8yMPSQ/+/+MOUxk
        GolCFnLN5gfzqXZcfjkvxpOh2A==
X-Google-Smtp-Source: ABdhPJxyaiVTWH5ni3ymy/mhjTYOCJ8InFIUL41aJ+mDrZSiNSQdZ9I7xuq93Z1Xj60mpF5uncIMWw==
X-Received: by 2002:a05:6e02:107:: with SMTP id t7mr192564ilm.77.1628623632041;
        Tue, 10 Aug 2021 12:27:12 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c5sm3025356ioz.25.2021.08.10.12.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 12:27:11 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/7] net: ipa: kill IPA clock reference count
Date:   Tue, 10 Aug 2021 14:27:03 -0500
Message-Id: <20210810192704.2476461-7-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210810192704.2476461-1-elder@linaro.org>
References: <20210810192704.2476461-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The runtime power management core code maintains a usage count.  This
count mirrors the IPA clock reference count, and there's no need to
maintain both.  So get rid of the IPA clock reference count and just
rely on the runtime PM usage count to determine when the hardware
should be suspended or resumed.

Use pm_runtime_get_if_active() in ipa_clock_get_additional().  We
care whether power is active, regardless of whether it's in use, so
pass true for its ign_usage_count argument.

The IPA clock mutex is just used to make enabling/disabling the
clock and updating the reference count occur atomically.  Without
the reference count, there's no need for the mutex, so get rid of
that too.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c | 77 +++----------------------------------
 1 file changed, 6 insertions(+), 71 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index f1ee0b46da005..ab6626c617b91 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -4,8 +4,6 @@
  * Copyright (C) 2018-2021 Linaro Ltd.
  */
 
-#include <linux/refcount.h>
-#include <linux/mutex.h>
 #include <linux/clk.h>
 #include <linux/device.h>
 #include <linux/interconnect.h>
@@ -58,8 +56,6 @@ enum ipa_power_flag {
 
 /**
  * struct ipa_clock - IPA clocking information
- * @count:		Clocking reference count
- * @mutex:		Protects clock enable/disable
  * @dev:		IPA device pointer
  * @core:		IPA core clock
  * @flags:		Boolean state flags
@@ -67,8 +63,6 @@ enum ipa_power_flag {
  * @interconnect:	Interconnect array
  */
 struct ipa_clock {
-	refcount_t count;
-	struct mutex mutex; /* protects clock enable/disable */
 	struct device *dev;
 	struct clk *core;
 	DECLARE_BITMAP(flags, IPA_POWER_FLAG_COUNT);
@@ -276,78 +270,24 @@ static int ipa_runtime_idle(struct device *dev)
  */
 bool ipa_clock_get_additional(struct ipa *ipa)
 {
-	struct device *dev;
-	int ret;
-
-	if (!refcount_inc_not_zero(&ipa->clock->count))
-		return false;
-
-	dev = &ipa->pdev->dev;
-	ret = pm_runtime_get_sync(dev);
-	if (ret < 0)
-		dev_err(dev, "error %d enabling power\n", ret);
-
-	return true;
+	return pm_runtime_get_if_active(&ipa->pdev->dev, true) > 0;
 }
 
 /* Get an IPA clock reference.  If the reference count is non-zero, it is
- * incremented and return is immediate.  Otherwise it is checked again
- * under protection of the mutex, and if appropriate the IPA clock
- * is enabled.
- *
- * Incrementing the reference count is intentionally deferred until
- * after the clock is running and endpoints are resumed.
+ * incremented and return is immediate.  Otherwise the IPA clock is
+ * enabled.
  */
 int ipa_clock_get(struct ipa *ipa)
 {
-	struct ipa_clock *clock = ipa->clock;
-	struct device *dev;
-	int ret;
-
-	/* If the clock is running, just bump the reference count */
-	if (ipa_clock_get_additional(ipa))
-		return 1;
-
-	/* Otherwise get the mutex and check again */
-	mutex_lock(&clock->mutex);
-
-	/* A reference might have been added before we got the mutex. */
-	if (ipa_clock_get_additional(ipa)) {
-		ret = 1;
-		goto out_mutex_unlock;
-	}
-
-	dev = &ipa->pdev->dev;
-	ret = pm_runtime_get_sync(dev);
-
-	refcount_set(&clock->count, 1);
-
-out_mutex_unlock:
-	mutex_unlock(&clock->mutex);
-
-	return ret;
+	return pm_runtime_get_sync(&ipa->pdev->dev);
 }
 
 /* Attempt to remove an IPA clock reference.  If this represents the
- * last reference, disable the IPA clock under protection of the mutex.
+ * last reference, disable the IPA clock.
  */
 int ipa_clock_put(struct ipa *ipa)
 {
-	struct device *dev = &ipa->pdev->dev;
-	struct ipa_clock *clock = ipa->clock;
-	int last;
-	int ret;
-
-	/* If this is not the last reference there's nothing more to do */
-	last = refcount_dec_and_mutex_lock(&clock->count, &clock->mutex);
-
-	ret = pm_runtime_put(dev);
-	if (!last)
-		return ret;
-
-	mutex_unlock(&clock->mutex);
-
-	return ret;
+	return pm_runtime_put(&ipa->pdev->dev);
 }
 
 /* Return the current IPA core clock rate */
@@ -425,9 +365,6 @@ ipa_clock_init(struct device *dev, const struct ipa_clock_data *data)
 	if (ret)
 		goto err_kfree;
 
-	mutex_init(&clock->mutex);
-	refcount_set(&clock->count, 0);
-
 	pm_runtime_dont_use_autosuspend(dev);
 	pm_runtime_enable(dev);
 
@@ -446,9 +383,7 @@ void ipa_clock_exit(struct ipa_clock *clock)
 {
 	struct clk *clk = clock->core;
 
-	WARN_ON(refcount_read(&clock->count) != 0);
 	pm_runtime_disable(clock->dev);
-	mutex_destroy(&clock->mutex);
 	ipa_interconnect_exit(clock);
 	kfree(clock);
 	clk_put(clk);
-- 
2.27.0

