Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C60C4A895F
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352607AbiBCRJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352556AbiBCRJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:09:45 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E007BC06175A
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 09:09:42 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id z18so2661107ilp.3
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 09:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UTD/8NZGtGtHN6WTCBTC3xofep8IAMari0myuecKnYQ=;
        b=OYR8oTnqEhUdLucBWHO5TUpvftUwNm40eg0joHmIB1RFw06B4Khq67KtL9nRUj0dFI
         VbuyDsFNOO7JA2DqdkcLnfmfDgQFFrpKdFqBfheY9A8hImWYM/rXDM0OTdDmYQY4eVSE
         e3puryseN9tyXPExl8zcRyQhQpB7eTbL+v3QXj5v+L590JphWD4hTyNba4O8CEC5dpJz
         1jTwbW7U1gKG6Kz9TfO/sKxikrcZZ3K19sJ8r+ddCH/U7FomyYj8Fdxhm9VuatCt+nrI
         FopJHVkK9BVscMPzVfRWoRVHT6gmz5XYNEnR1MYLH1688qseSI6TG5aggtXsIEMeNQQM
         K+lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UTD/8NZGtGtHN6WTCBTC3xofep8IAMari0myuecKnYQ=;
        b=reLn5vmOYxChsr6DBcUKQiPCQwuu1UIUWMqwhQEa8ZC8qFWgdEeAQpnt17MssS3qAQ
         v1rCqC06ECQ0dVL2AI0QQWA4iLKzSLncT6nI44C2M6UkbaX5S+4n8wbwjiCnwmWejYun
         LrESPLXSl+kjC2f76Q/dvunrkAuoGjnkaQ8++Ht747JxnsiD2Y+fC+wlwscN5cWqV1f4
         tFxqOfOJmpKUqIBEUV5ovzMRNMsTZGo7zTNSBu0+rQCwzSADKSE8xalFQkQVLbuTmB8j
         pBEiIS3c3huW+Yw1eY7m2GFotXRE720CUOtd7fdP8Qvf5Y7rAe6DBIgwwjQsCi6fq8uz
         hkEQ==
X-Gm-Message-State: AOAM531u3OMDvRa9IH60XUWdTklfvdalxExDmhF3Z5Wp0OQhlX9tSRv5
        YtYl1apPV8OORQrdJNcwNCCbVg==
X-Google-Smtp-Source: ABdhPJwhKCVVa3GlNNcFDuFJ0nVbvWnU46D74FgYnJqaUyx0SvYPrC9nNwh4YU8fl0EIhGBWYAx9wQ==
X-Received: by 2002:a92:c548:: with SMTP id a8mr21026692ilj.51.1643908182246;
        Thu, 03 Feb 2022 09:09:42 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m12sm21869671iow.54.2022.02.03.09.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 09:09:41 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, mka@chromium.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, avuyyuru@codeaurora.org,
        jponduru@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 07/10] net: ipa: introduce gsi_channel_trans_idle()
Date:   Thu,  3 Feb 2022 11:09:24 -0600
Message-Id: <20220203170927.770572-8-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220203170927.770572-1-elder@linaro.org>
References: <20220203170927.770572-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new function that returns true if all transactions for a
channel are available for use.

Use it in ipa_endpoint_replenish_enable() to see whether to start
replenishing, and in ipa_endpoint_replenish() to determine whether
it's necessary after a failure to schedule delayed work to ensure a
future replenish attempt occurs.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_trans.c    | 11 +++++++++++
 drivers/net/ipa/gsi_trans.h    | 10 ++++++++++
 drivers/net/ipa/ipa_endpoint.c | 17 +++++------------
 3 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 1544564bc2835..87e1d43c118c1 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -320,6 +320,17 @@ gsi_trans_tre_release(struct gsi_trans_info *trans_info, u32 tre_count)
 	atomic_add(tre_count, &trans_info->tre_avail);
 }
 
+/* Return true if no transactions are allocated, false otherwise */
+bool gsi_channel_trans_idle(struct gsi *gsi, u32 channel_id)
+{
+	u32 tre_max = gsi_channel_tre_max(gsi, channel_id);
+	struct gsi_trans_info *trans_info;
+
+	trans_info = &gsi->channel[channel_id].trans_info;
+
+	return atomic_read(&trans_info->tre_avail) == tre_max;
+}
+
 /* Allocate a GSI transaction on a channel */
 struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
 					  u32 tre_count,
diff --git a/drivers/net/ipa/gsi_trans.h b/drivers/net/ipa/gsi_trans.h
index 17fd1822d8a9f..af379b49299ee 100644
--- a/drivers/net/ipa/gsi_trans.h
+++ b/drivers/net/ipa/gsi_trans.h
@@ -129,6 +129,16 @@ void *gsi_trans_pool_alloc_dma(struct gsi_trans_pool *pool, dma_addr_t *addr);
  */
 void gsi_trans_pool_exit_dma(struct device *dev, struct gsi_trans_pool *pool);
 
+/**
+ * gsi_channel_trans_idle() - Return whether no transactions are allocated
+ * @gsi:	GSI pointer
+ * @channel_id:	Channel the transaction is associated with
+ *
+ * Return:	True if no transactions are allocated, false otherwise
+ *
+ */
+bool gsi_channel_trans_idle(struct gsi *gsi, u32 channel_id);
+
 /**
  * gsi_channel_trans_alloc() - Allocate a GSI transaction on a channel
  * @gsi:	GSI pointer
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index fba8728ce12e3..b854a39c69925 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1077,8 +1077,6 @@ static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint,
 static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint)
 {
 	struct gsi_trans *trans;
-	struct gsi *gsi;
-	u32 backlog;
 
 	if (!test_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags))
 		return;
@@ -1108,30 +1106,25 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint)
 	clear_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags);
 
 	/* The last one didn't succeed, so fix the backlog */
-	backlog = atomic_inc_return(&endpoint->replenish_backlog);
+	atomic_inc(&endpoint->replenish_backlog);
 
 	/* Whenever a receive buffer transaction completes we'll try to
 	 * replenish again.  It's unlikely, but if we fail to supply even
 	 * one buffer, nothing will trigger another replenish attempt.
-	 * Receive buffer transactions use one TRE, so schedule work to
-	 * try replenishing again if our backlog is *all* available TREs.
+	 * If the hardware has no receive buffers queued, schedule work to
+	 * try replenishing again.
 	 */
-	gsi = &endpoint->ipa->gsi;
-	if (backlog == gsi_channel_tre_max(gsi, endpoint->channel_id))
+	if (gsi_channel_trans_idle(&endpoint->ipa->gsi, endpoint->channel_id))
 		schedule_delayed_work(&endpoint->replenish_work,
 				      msecs_to_jiffies(1));
 }
 
 static void ipa_endpoint_replenish_enable(struct ipa_endpoint *endpoint)
 {
-	struct gsi *gsi = &endpoint->ipa->gsi;
-	u32 max_backlog;
-
 	set_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
 
 	/* Start replenishing if hardware currently has no buffers */
-	max_backlog = gsi_channel_tre_max(gsi, endpoint->channel_id);
-	if (atomic_read(&endpoint->replenish_backlog) == max_backlog)
+	if (gsi_channel_trans_idle(&endpoint->ipa->gsi, endpoint->channel_id))
 		ipa_endpoint_replenish(endpoint);
 }
 
-- 
2.32.0

