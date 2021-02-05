Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD13831149E
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbhBEWJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbhBEOwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:52:11 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF81C0611C1
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 08:29:30 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id j2so4922408pgl.0
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 08:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H+XXRPtcVhqL4SZA2xE4JtYQXLSPRWqhEcRZvJyBubQ=;
        b=juD/+IMQSeopqjDcUewqw+7th0LzGiueKxRWyZJfLMy15zCeq9KpHi2i7WwRhQweGZ
         0EHXyU+ekxL1FAX+isehGEYN7baPZiUVvYqbqiHPmEyE58s7Rxp4iMWqN3hS8twxRHix
         trsFwYsZ4bUpTsm0asNTic0agw1ba9BaCNKnAGSmU4/FXXW11bVRgT1MLZGBIeiJCjUE
         KAJJBovvbq73wbN8U99W/VgQXRZfchctJ3noW6nJTja3rsHMVFL1xxeQDv8tuUFO/s/X
         W5p44YExl3mB28Ig93OGJO/uAEL30YLbdBvaMZV/PoOYbpyEsCr4hVgxLx9E/JMvgJiB
         AcfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H+XXRPtcVhqL4SZA2xE4JtYQXLSPRWqhEcRZvJyBubQ=;
        b=j1mtr46I5JIOJs++fYjPBuUEoM3Q1nMRxRyfzfZJZDndpvf7SkQH8IAY0hkXbiyHcJ
         s9rqivbNSrq329yCp6saqMhAM+RwwFyNd6iV5HfeEuIthDWliSkh7nv2XsZNaYdGn66W
         3BXALaOuC/s7PcS6BYWLeg8q+JK+U+89/cUir9nAaJ2Tb2gH+pCF8PSgn0FcpjtzGGs6
         IO7v2j1r9NjmD7NFaSEdcVq1WRfUeR35UVH2kpwgy5+CQPxm6OFQdTxavLMjO7HGykes
         06Q3sq/5Wc9D3qHwuLSm7AzosWgZNNXopVo10o4kHr0DWS01ylQ+/wnQbpic7UCnDAG8
         ktvQ==
X-Gm-Message-State: AOAM531uh8Yk8qXRDvqaCOKH+hnDRMEIQ7BoZY0n2oe1yQfi/zsJt5wP
        pG60QOqgZ33PICaQa2R+d5NqTBC8u6EybQ==
X-Google-Smtp-Source: ABdhPJzpmVPq4i70R7apOVIic6mAVRpo/eJuY86d/TMT4Ty9BlpLtBuDaaVFPlH4FCh+VE9eepNsAA==
X-Received: by 2002:a92:4447:: with SMTP id a7mr4396967ilm.240.1612535918922;
        Fri, 05 Feb 2021 06:38:38 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h9sm4136882ili.43.2021.02.05.06.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 06:38:38 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 5/7] net: ipa: use a Boolean rather than count when replenishing
Date:   Fri,  5 Feb 2021 08:38:27 -0600
Message-Id: <20210205143829.16271-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210205143829.16271-1-elder@linaro.org>
References: <20210205143829.16271-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The count argument to ipa_endpoint_replenish() is only ever 0 or 1,
and always will be (because we always handle each receive buffer in
a single transaction).  Rename the argument to be add_one and change
it to be Boolean.

Update the function description to reflect the current code.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 35 ++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 7a46c790afbef..bff5d6ffd1186 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1020,31 +1020,34 @@ static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint)
 }
 
 /**
- * ipa_endpoint_replenish() - Replenish the Rx packets cache.
+ * ipa_endpoint_replenish() - Replenish endpoint receive buffers
  * @endpoint:	Endpoint to be replenished
- * @count:	Number of buffers to send to hardware
+ * @add_one:	Whether this is replacing a just-consumed buffer
  *
- * Allocate RX packet wrapper structures with maximal socket buffers
- * for an endpoint.  These are supplied to the hardware, which fills
- * them with incoming data.
+ * The IPA hardware can hold a fixed number of receive buffers for an RX
+ * endpoint, based on the number of entries in the underlying channel ring
+ * buffer.  If an endpoint's "backlog" is non-zero, it indicates how many
+ * more receive buffers can be supplied to the hardware.  Replenishing for
+ * an endpoint can be disabled, in which case requests to replenish a
+ * buffer are "saved", and transferred to the backlog once it is re-enabled
+ * again.
  */
-static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, u32 count)
+static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, bool add_one)
 {
 	struct gsi *gsi;
 	u32 backlog;
 
 	if (!endpoint->replenish_enabled) {
-		if (count)
-			atomic_add(count, &endpoint->replenish_saved);
+		if (add_one)
+			atomic_inc(&endpoint->replenish_saved);
 		return;
 	}
 
-
 	while (atomic_dec_not_zero(&endpoint->replenish_backlog))
 		if (ipa_endpoint_replenish_one(endpoint))
 			goto try_again_later;
-	if (count)
-		atomic_add(count, &endpoint->replenish_backlog);
+	if (add_one)
+		atomic_inc(&endpoint->replenish_backlog);
 
 	return;
 
@@ -1052,8 +1055,8 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, u32 count)
 	/* The last one didn't succeed, so fix the backlog */
 	backlog = atomic_inc_return(&endpoint->replenish_backlog);
 
-	if (count)
-		atomic_add(count, &endpoint->replenish_backlog);
+	if (add_one)
+		atomic_inc(&endpoint->replenish_backlog);
 
 	/* Whenever a receive buffer transaction completes we'll try to
 	 * replenish again.  It's unlikely, but if we fail to supply even
@@ -1080,7 +1083,7 @@ static void ipa_endpoint_replenish_enable(struct ipa_endpoint *endpoint)
 	/* Start replenishing if hardware currently has no buffers */
 	max_backlog = gsi_channel_tre_max(gsi, endpoint->channel_id);
 	if (atomic_read(&endpoint->replenish_backlog) == max_backlog)
-		ipa_endpoint_replenish(endpoint, 0);
+		ipa_endpoint_replenish(endpoint, false);
 }
 
 static void ipa_endpoint_replenish_disable(struct ipa_endpoint *endpoint)
@@ -1099,7 +1102,7 @@ static void ipa_endpoint_replenish_work(struct work_struct *work)
 
 	endpoint = container_of(dwork, struct ipa_endpoint, replenish_work);
 
-	ipa_endpoint_replenish(endpoint, 0);
+	ipa_endpoint_replenish(endpoint, false);
 }
 
 static void ipa_endpoint_skb_copy(struct ipa_endpoint *endpoint,
@@ -1300,7 +1303,7 @@ static void ipa_endpoint_rx_complete(struct ipa_endpoint *endpoint,
 {
 	struct page *page;
 
-	ipa_endpoint_replenish(endpoint, 1);
+	ipa_endpoint_replenish(endpoint, true);
 
 	if (trans->cancelled)
 		return;
-- 
2.20.1

