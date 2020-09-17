Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C18826E30E
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 19:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgIQR6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbgIQRjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:39:41 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0236EC061356
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:39:35 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id g128so3103809iof.11
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1JC8Jq8l5d3FMIOqG3s3tOJTv29rQ/B9PWS+aSrpLGw=;
        b=U405yXMXivO9GetXit4zYyFid6bzqqIA4UwrlGS5LHR/5sRVogi2Yb/2UL2pKQhQ6I
         h2y8mLHqugpSytlwllaXNvD6yLD2LkMx6JYV9OkEP9tOlOXqlqXR51d7I0PXmXIgGSsN
         Z56BE5EQTRP3G5Ug/DWidnc4tOtRGffpZTTssuJqbgiX/9ELY7wXCL/+ZS3FxPlQWGF6
         macQV8BiucaZiMVMEUIulgydWrNK1duaqGU3OOj+9FOBLjc3olAiIFCgp8R3MkMyWWgA
         5qS+MG6/cUb69sajAlTpfCU8wIwH/K+AT3KB9jsPOHI/1Cg3LPckfVKgyvafgZhfiaOt
         2cXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1JC8Jq8l5d3FMIOqG3s3tOJTv29rQ/B9PWS+aSrpLGw=;
        b=gIvXgGADX6Q6NC6JD0j1fdi796g+OL8PJfKCaj/sXkT98y1Zt97guBY7UDuGYUYd0B
         Tw9co5uTq+i509C/WO+0ttSCsjHuQb0ZPCYpyavjd7m7VTcaunTRSCn1H2UygrpSJfqN
         Uz+6Qt1PSHz8zf608FtSK5D/f9bDNqhSEupLLJm4Q50SJaDbYUq72cmIbRWy1Nf8sZoY
         7POenYdsag0ytwgf1UvYtU2sPicJMZSSU0x8Y6u4AKa2jSsM/fk/o02BIchqdJSwkSCL
         4hr+s3/hwTwKzKk8Az2Wa/U1OtYqb/sGkfC7Ji6Vy6wSYFavr2fCDQxO/VPebwr+C/Bt
         OUyA==
X-Gm-Message-State: AOAM532Q7nV6HzA8dlV17iqXCNRQelK8BGbxqT+uyj/QmCK7hvHjTWjw
        ELpETEKsGsnFxhHzp+pTmZHezgHV1C3SAg==
X-Google-Smtp-Source: ABdhPJybbRBFZ3GvAgFEYWFu2IpIWGxn/o7bQ4EoBVHUsEH7hygQHQnFqx2LFmtttDZyH5am5EUs7Q==
X-Received: by 2002:a05:6638:144:: with SMTP id y4mr27177041jao.61.1600364374081;
        Thu, 17 Sep 2020 10:39:34 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l6sm192725ilt.34.2020.09.17.10.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 10:39:33 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 3/7] net: ipa: manage endpoints separate from clock
Date:   Thu, 17 Sep 2020 12:39:22 -0500
Message-Id: <20200917173926.24266-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200917173926.24266-1-elder@linaro.org>
References: <20200917173926.24266-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when (before) the last IPA clock reference is dropped,
all endpoints are suspended.  And whenever the first IPA clock
reference is taken, all endpoints are resumed (or started).

In most cases there's no need to start endpoints when the clock
starts.  So move the calls to ipa_endpoint_suspend() and
ipa_endpoint_resume() out of ipa_clock_put() and ipa_clock_get(),
respectiely.  Instead, only suspend endpoints when handling a system
suspend, and only resume endpoints when handling a system resume.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
v3: Added Bjorn's reviewed-by tag.

 drivers/net/ipa/ipa_clock.c | 14 ++++----------
 drivers/net/ipa/ipa_main.c  |  8 ++++++++
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index b703866f2e20b..a2c0fde058199 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -200,9 +200,8 @@ bool ipa_clock_get_additional(struct ipa *ipa)
 
 /* Get an IPA clock reference.  If the reference count is non-zero, it is
  * incremented and return is immediate.  Otherwise it is checked again
- * under protection of the mutex, and if appropriate the clock (and
- * interconnects) are enabled suspended endpoints (if any) are resumed
- * before returning.
+ * under protection of the mutex, and if appropriate the IPA clock
+ * is enabled.
  *
  * Incrementing the reference count is intentionally deferred until
  * after the clock is running and endpoints are resumed.
@@ -229,17 +228,14 @@ void ipa_clock_get(struct ipa *ipa)
 		goto out_mutex_unlock;
 	}
 
-	ipa_endpoint_resume(ipa);
-
 	refcount_set(&clock->count, 1);
 
 out_mutex_unlock:
 	mutex_unlock(&clock->mutex);
 }
 
-/* Attempt to remove an IPA clock reference.  If this represents the last
- * reference, suspend endpoints and disable the clock (and interconnects)
- * under protection of a mutex.
+/* Attempt to remove an IPA clock reference.  If this represents the
+ * last reference, disable the IPA clock under protection of the mutex.
  */
 void ipa_clock_put(struct ipa *ipa)
 {
@@ -249,8 +245,6 @@ void ipa_clock_put(struct ipa *ipa)
 	if (!refcount_dec_and_mutex_lock(&clock->count, &clock->mutex))
 		return;
 
-	ipa_endpoint_suspend(ipa);
-
 	ipa_clock_disable(ipa);
 
 	mutex_unlock(&clock->mutex);
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 409375b96eb8f..4d5394bcfe47e 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -907,11 +907,15 @@ static int ipa_remove(struct platform_device *pdev)
  * Return:	Always returns zero
  *
  * Called by the PM framework when a system suspend operation is invoked.
+ * Suspends endpoints and releases the clock reference held to keep
+ * the IPA clock running until this point.
  */
 static int ipa_suspend(struct device *dev)
 {
 	struct ipa *ipa = dev_get_drvdata(dev);
 
+	ipa_endpoint_suspend(ipa);
+
 	ipa_clock_put(ipa);
 	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
 
@@ -925,6 +929,8 @@ static int ipa_suspend(struct device *dev)
  * Return:	Always returns 0
  *
  * Called by the PM framework when a system resume operation is invoked.
+ * Takes an IPA clock reference to keep the clock running until suspend,
+ * and resumes endpoints.
  */
 static int ipa_resume(struct device *dev)
 {
@@ -936,6 +942,8 @@ static int ipa_resume(struct device *dev)
 	__set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
 	ipa_clock_get(ipa);
 
+	ipa_endpoint_resume(ipa);
+
 	return 0;
 }
 
-- 
2.20.1

