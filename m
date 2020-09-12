Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53D62676E6
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgILAqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgILAph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 20:45:37 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683BAC061786
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 17:45:37 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id x2so10638383ilm.0
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 17:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YDLLvKUFt4FLtBLmAvx/wOC4eEuYKN2bBtAm+5nRw3k=;
        b=QArGIRWFO5muS5frroklu4PCaoP1vWYZLqH/HnLWoRyhftvAdaFY0IUJqRf8oyNOER
         SrkS+8v2KOWZNRPYQ4TlGG1U88/FSRFus4nNqb8TDCC3svoUGGjibooMEsAe17/s0KL9
         NK78nMGigKu24eQk+wxBwHh20vhihLhdChQu5jC4WztVOnqMjgEoqC+ESD/lW9tnqSvt
         bZu4rV9hlEf95DpZ3q4w0SkZJZXdztmR4E+s1BpdtS1U+JRuehB9Uts3C+LozxpTmj3C
         Z2m2jZ8Z1DO0FOoo8hxo0UXKgJfo2x6P2sZ/zqxkEHeNN8u3tQBYZnzr0BqWIEssrgVc
         TL/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YDLLvKUFt4FLtBLmAvx/wOC4eEuYKN2bBtAm+5nRw3k=;
        b=MJKzMiULJd0OqYUL8c/i87J09cGx36wSs4C8uTtyKOpkLgalCs5evYJG80Xx9ZUjVj
         JM3AZ+DqpSC0yW0TpBejyq5QPmw7Or/my/Y09uvx9XAmPQxhIGzoT7QxkjhJEMKKId1+
         dDFlnJA5KmYW0qwEfZZz2FeVYO3IJMUvH+aggQzp20BTD4FZykO1Y8MjJiMWsw8fQS8r
         1GLzIgwBjk9A3B6xS8whl124deevlA05FYMtuJmCCpKYu81Cb4woqln/KqBoWJZwLRjW
         BjcZ0UtqiXROuk6CykETtazU08h/U1LTVszbyUMXFdT9oeEamXIsQNvrKMnAv9T21lsF
         YqTA==
X-Gm-Message-State: AOAM533xq/eMVApEX8unjmGP0Q2sC0lBvtzOXg3wzfGjiE9NjBBLe/GH
        i3SF0IyxZm2eGYUJLw+ya9CxGQ==
X-Google-Smtp-Source: ABdhPJzjGXiuXVZVqy3WkyaUWI/eMzLmmD8rtzKepGkFF8I4QVJb8p7iDALrSodiy/a+2T8w9I3eQQ==
X-Received: by 2002:a05:6e02:df1:: with SMTP id m17mr3039788ilj.276.1599871536735;
        Fri, 11 Sep 2020 17:45:36 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z4sm2107807ilh.45.2020.09.11.17.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 17:45:36 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/7] net: ipa: use refcount_t for IPA clock reference count
Date:   Fri, 11 Sep 2020 19:45:26 -0500
Message-Id: <20200912004532.1386-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200912004532.1386-1-elder@linaro.org>
References: <20200912004532.1386-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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
v2: This patch is new in version 2 of the series.

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

