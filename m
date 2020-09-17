Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A74126E32D
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgIQSBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgIQRjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:39:33 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC70FC061351
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:39:32 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id r9so3160094ioa.2
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bXindhdvkQaAk3Cd415sil6PrEN75fleSugapgasIK0=;
        b=T69eAZTJvv3a87sZwq7xkk9cDvGBj8Y6Xb5Uul5fYOfMkEZXE1jZ+tMwuw8Iun1mmC
         sJUsk+62obo/B2prpFs2GbZ2+bGUY3JWqCeN4g5ezw8MCa50n9KOgZGM1QLR7XjE5g2I
         YqussllL33xvrzXLdCuQ4BPi1gz1mX8Uoa3L3p+myjxRVSp38QxcRurWQ/OFEfBvTSt/
         5JHyT+L2vvBSo760UJ1hPmkAE0TjN3b1S4yhVeW2plxvgpaUBvys0xLe4sIhMD0LUysN
         91w91O224zoLMxmtdvh+J+lZ2AhiW878pigJg685HWp48gwzIYKWzCuUPZ4sEp5AAik3
         CJTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bXindhdvkQaAk3Cd415sil6PrEN75fleSugapgasIK0=;
        b=jQuVgd9NTLt4ZYmO+OwFjnDJiaVTPJgv6cUtnr56W48/Vc8uhdI6/AjW2PmrRdrl7t
         ApruN8wWD0cCrsHxJ+VXslJuyrJHJuzm939fKP0riO7hV+jHXTBXUyvt3+607NWuZH9V
         1Bb72eEGicL9nid667z5/+8N2oumbsPi/v6l+xCzez8o/XxP9j94QMZiPVbiZ2uqrgHa
         qG+PIqPCybV5HVDI4MbjtVK4NHKf8Ua5RNZksiJjJFq6FSPTjZWcJ0Xx4E7oZWXN/6Rb
         r1UrZiiXSLxcmHtJm8//aT9gVPXuvQao6sz77JO8RFAxtmaJZYFELO9Cm2AEgd9C4EUs
         ecgw==
X-Gm-Message-State: AOAM5310YUIVJDkDl0mjM1c1dpV4PAahQ4wpzG3k3XhoRPscoIJoatWE
        WIaqSUOoYFAT4fjgRWW9dTdmQQ==
X-Google-Smtp-Source: ABdhPJwyc3E2/w98W0RFVLNqBDtu7AqwXZuA6rwLXOHNfBx9z5zXNmeVhsS99S7YU3jj4gyRLb8cCQ==
X-Received: by 2002:a05:6602:2d55:: with SMTP id d21mr23642445iow.134.1600364371878;
        Thu, 17 Sep 2020 10:39:31 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l6sm192725ilt.34.2020.09.17.10.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 10:39:31 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 1/7] net: ipa: use refcount_t for IPA clock reference count
Date:   Thu, 17 Sep 2020 12:39:20 -0500
Message-Id: <20200917173926.24266-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200917173926.24266-1-elder@linaro.org>
References: <20200917173926.24266-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take advantage of the checking provided by refcount_t, rather than
using a plain atomic to represent the IPA clock reference count.

Note that we need to *set* the value to 1 in ipa_clock_get() rather
than incrementing it from 0 (because doing that is considered an
error for a refcount_t).

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: This patch was added in version 2 of the series.
v3: No change.

 drivers/net/ipa/ipa_clock.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index 398f2e47043d8..b703866f2e20b 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2018-2020 Linaro Ltd.
  */
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/mutex.h>
 #include <linux/clk.h>
 #include <linux/device.h>
@@ -51,7 +51,7 @@
  * @config_path:	Configuration space interconnect
  */
 struct ipa_clock {
-	atomic_t count;
+	refcount_t count;
 	struct mutex mutex; /* protects clock enable/disable */
 	struct clk *core;
 	struct icc_path *memory_path;
@@ -195,7 +195,7 @@ static void ipa_clock_disable(struct ipa *ipa)
  */
 bool ipa_clock_get_additional(struct ipa *ipa)
 {
-	return !!atomic_inc_not_zero(&ipa->clock->count);
+	return refcount_inc_not_zero(&ipa->clock->count);
 }
 
 /* Get an IPA clock reference.  If the reference count is non-zero, it is
@@ -231,7 +231,7 @@ void ipa_clock_get(struct ipa *ipa)
 
 	ipa_endpoint_resume(ipa);
 
-	atomic_inc(&clock->count);
+	refcount_set(&clock->count, 1);
 
 out_mutex_unlock:
 	mutex_unlock(&clock->mutex);
@@ -246,7 +246,7 @@ void ipa_clock_put(struct ipa *ipa)
 	struct ipa_clock *clock = ipa->clock;
 
 	/* If this is not the last reference there's nothing more to do */
-	if (!atomic_dec_and_mutex_lock(&clock->count, &clock->mutex))
+	if (!refcount_dec_and_mutex_lock(&clock->count, &clock->mutex))
 		return;
 
 	ipa_endpoint_suspend(ipa);
@@ -294,7 +294,7 @@ struct ipa_clock *ipa_clock_init(struct device *dev)
 		goto err_kfree;
 
 	mutex_init(&clock->mutex);
-	atomic_set(&clock->count, 0);
+	refcount_set(&clock->count, 0);
 
 	return clock;
 
@@ -311,7 +311,7 @@ void ipa_clock_exit(struct ipa_clock *clock)
 {
 	struct clk *clk = clock->core;
 
-	WARN_ON(atomic_read(&clock->count) != 0);
+	WARN_ON(refcount_read(&clock->count) != 0);
 	mutex_destroy(&clock->mutex);
 	ipa_interconnect_exit(clock);
 	kfree(clock);
-- 
2.20.1

