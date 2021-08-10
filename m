Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6B23E83AA
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 21:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbhHJT1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 15:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbhHJT1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 15:27:32 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FFBC0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 12:27:10 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id i13so152547ilm.11
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 12:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3RvnSI6p4fqV0uNcU76eKlSqoZMzH9RvMg7i8uWOHwQ=;
        b=OHumJWb4OpI6AuHu6FIXwC/YBm/ASJZ0cq2NnUihC0w98GhSEvXddr1zrsbYO+bf26
         51tkuH4xzgOrerfYqHAgs4N7S95ZRHe72bfG3sJcUqAdo/27j2ioSwneMywYZpQw4oId
         UqJ6s1LwItJXSaq3+QXbht524Z7zV+i7YbGecHAaWs1ee2u+ZxgQrS9mnuGJhCGuTWHD
         xjQSnHeoZ4wcmvPrToSck26n5j4u0zdw4ofstqPXuffj51jKeJXnMOPcKQzk5u+2I7Fa
         00z03HdGC3YrRVVHo+9KfRYpJmvSAw3VB/Pdew8YXrhmzXyTaInaAF34k+gyZ2vOZRQp
         rY6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3RvnSI6p4fqV0uNcU76eKlSqoZMzH9RvMg7i8uWOHwQ=;
        b=Xvwv8iii+UE1JFjiDzLpzC3izBhYzUrNZ13ZCiz8MSfBi+67ldYrYFAzA00esnJx0j
         xBnTpdiNznAR2oTuhdh+jXPXuIzxEzftlnEgReLjpf4fmDavtK0EHHGCoj78AQWV7Qp8
         QEVzaFD+os9GcYpjjRYW6Aj2lb5Ol9FQAzD3tzllnJgXT/bP+ljGfgvSXPoWX6a1Is+b
         DZXvVWa0GQwSULQxrRlktciY/HwZBmW5/VZQ+hqAnndh+mwKKwHBbR7ekyOtsCrFqcvR
         dIU8KjZyuwCkN65/adgz4LjDiw3J8WF38BtWH30uonyfJRZjXJ2kb58GSTnMWzfGCI+/
         D7TA==
X-Gm-Message-State: AOAM532tiwO9RJhk6hn1a/hyvjcndMjvEOza8OnSu3oLK2Dy8vfQScZN
        yqenTtgjXY0Axk19dfUUcEsg7sWzlcQAiA==
X-Google-Smtp-Source: ABdhPJzCO4mg8Z2/4Xik0whUmCZbIwVQ9ooj4xA3VtJp7eqfS0pAI1AjJr5/PEI6XW2hRYSPLRcmhA==
X-Received: by 2002:a92:b112:: with SMTP id t18mr324207ilh.36.1628623629517;
        Tue, 10 Aug 2021 12:27:09 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c5sm3025356ioz.25.2021.08.10.12.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 12:27:09 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/7] net: ipa: resume in ipa_clock_get()
Date:   Tue, 10 Aug 2021 14:27:00 -0500
Message-Id: <20210810192704.2476461-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210810192704.2476461-1-elder@linaro.org>
References: <20210810192704.2476461-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce ipa_runtime_suspend() and ipa_runtime_resume(), which
encapsulate the activities necessary for suspending and resuming
the IPA hardware.  Call these functions from ipa_clock_get() and
ipa_clock_put() when the first reference is taken or last one is
dropped.

When the very first clock reference is taken (for ipa_config()),
setup isn't complete yet, so (as before) only the core clock gets
enabled.

When the last clock reference is dropped (after ipa_deconfig()),
ipa_teardown() will have made the setup_complete flag false, so
there too, the core clock will be stopped without affecting GSI
or the endpoints.

Otherwise these new functions will perform the desired suspend and
resume actions once setup is complete.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c | 63 ++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index 864991f7ba4b5..c0a8fdf0777f4 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -10,6 +10,7 @@
 #include <linux/device.h>
 #include <linux/interconnect.h>
 #include <linux/pm.h>
+#include <linux/pm_runtime.h>
 #include <linux/bitops.h>
 
 #include "ipa.h"
@@ -230,6 +231,38 @@ static int ipa_clock_disable(struct ipa *ipa)
 	return ipa_interconnect_disable(ipa);
 }
 
+static int ipa_runtime_suspend(struct device *dev)
+{
+	struct ipa *ipa = dev_get_drvdata(dev);
+
+	/* Endpoints aren't usable until setup is complete */
+	if (ipa->setup_complete) {
+		__clear_bit(IPA_POWER_FLAG_RESUMED, ipa->clock->flags);
+		ipa_endpoint_suspend(ipa);
+		gsi_suspend(&ipa->gsi);
+	}
+
+	return ipa_clock_disable(ipa);
+}
+
+static int ipa_runtime_resume(struct device *dev)
+{
+	struct ipa *ipa = dev_get_drvdata(dev);
+	int ret;
+
+	ret = ipa_clock_enable(ipa);
+	if (WARN_ON(ret < 0))
+		return ret;
+
+	/* Endpoints aren't usable until setup is complete */
+	if (ipa->setup_complete) {
+		gsi_resume(&ipa->gsi);
+		ipa_endpoint_resume(ipa);
+	}
+
+	return 0;
+}
+
 /* Get an IPA clock reference, but only if the reference count is
  * already non-zero.  Returns true if the additional reference was
  * added successfully, or false otherwise.
@@ -265,7 +298,7 @@ int ipa_clock_get(struct ipa *ipa)
 		goto out_mutex_unlock;
 	}
 
-	ret = ipa_clock_enable(ipa);
+	ret = ipa_runtime_resume(&ipa->pdev->dev);
 
 	refcount_set(&clock->count, 1);
 
@@ -287,7 +320,7 @@ int ipa_clock_put(struct ipa *ipa)
 	if (!refcount_dec_and_mutex_lock(&clock->count, &clock->mutex))
 		return 0;
 
-	ret = ipa_clock_disable(ipa);
+	ret = ipa_runtime_suspend(&ipa->pdev->dev);
 
 	mutex_unlock(&clock->mutex);
 
@@ -405,16 +438,7 @@ void ipa_clock_exit(struct ipa_clock *clock)
  */
 static int ipa_suspend(struct device *dev)
 {
-	struct ipa *ipa = dev_get_drvdata(dev);
-
-	/* Endpoints aren't usable until setup is complete */
-	if (ipa->setup_complete) {
-		__clear_bit(IPA_POWER_FLAG_RESUMED, ipa->clock->flags);
-		ipa_endpoint_suspend(ipa);
-		gsi_suspend(&ipa->gsi);
-	}
-
-	return ipa_clock_disable(ipa);
+	return ipa_runtime_suspend(dev);
 }
 
 /**
@@ -429,20 +453,7 @@ static int ipa_suspend(struct device *dev)
  */
 static int ipa_resume(struct device *dev)
 {
-	struct ipa *ipa = dev_get_drvdata(dev);
-	int ret;
-
-	ret = ipa_clock_enable(ipa);
-	if (WARN_ON(ret < 0))
-		return ret;
-
-	/* Endpoints aren't usable until setup is complete */
-	if (ipa->setup_complete) {
-		gsi_resume(&ipa->gsi);
-		ipa_endpoint_resume(ipa);
-	}
-
-	return 0;
+	return ipa_runtime_resume(dev);
 }
 
 const struct dev_pm_ops ipa_pm_ops = {
-- 
2.27.0

