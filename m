Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C2731184D
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhBFCdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbhBFCcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:32:23 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DFCC061A86
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:11:13 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id y17so7199909ili.12
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H+XXRPtcVhqL4SZA2xE4JtYQXLSPRWqhEcRZvJyBubQ=;
        b=hTPgVLNSODjoqc0f730U8vWV6C1asXWCeoeebQj6gmhDd8uSqKl34FprhHSqFK7U8F
         /CjjYvFGEyvpnzroIhG4B/OMmGP2DAVJzu2moXWhrShwr3Z4WVzoj9mGBFpGFCOOI4AT
         XX1C9Q56mUd9ODIanu0zKNcFPEetMHD0zZtTsFh8k9DRP1LuCPqRrl0q1Zm7wbIQVjHS
         Rv78RTBj38saLCFEPQne/ksBqXlscyHglmBf1gbr3yVE4MH85zI57tOdJdEK0LJXVuHv
         qmhaLQsHaNh4aTmR7QCjVhc9SZOsuHRAcHym+FuTzy+dKCwuRo88j/VHXXe96E1KyyEr
         7NNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H+XXRPtcVhqL4SZA2xE4JtYQXLSPRWqhEcRZvJyBubQ=;
        b=PKD1Z1bgStX/7oaEji5KYXK+FWTp5iF5iHmiPv2caRvs7eDprNX7yp6/mATkvG6sYA
         d6tKd7Y2PL2gNRoNISmYnoO40Uv9XvE5PcGxfjJTQT4BxV/FKiD0tOYqvpFnrNcYei/R
         rVZSSGOO7jcL1zLXpNQqshdWxOW920DBVDE8/f5rucAF1b4mzvpI168pxkJNFwOcE05+
         5Dlb6SKDbwtNSfdHQe69OUCHavJ0VvrcHEbPZ7OxnRvQt7ypzRpvAx9uwZJXEKg/kJz2
         SrDpLpHSzDoUVn5j0BhNx1hxlNfA/2DhFg6kKIMUX5GKVlle4v3g9DAN55eYW48ORrHH
         n/gw==
X-Gm-Message-State: AOAM5334I81po2e34smovLZEWseNMyzbmm7LSPsWJ/UOL9/v6/57YT/3
        JNmk6RK+YQLpZic96xgEAto5AQ==
X-Google-Smtp-Source: ABdhPJx2jF/j7ZztSAjV9hX8HZSZ1DtLl1lJVXJfLPIpaHxzn7hkDIGtvyJCmDuDOKduWRhJLYxFIQ==
X-Received: by 2002:a92:8e42:: with SMTP id k2mr6121493ilh.250.1612563072586;
        Fri, 05 Feb 2021 14:11:12 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m15sm4647171ilh.6.2021.02.05.14.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:11:12 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 5/7] net: ipa: use a Boolean rather than count when replenishing
Date:   Fri,  5 Feb 2021 16:10:58 -0600
Message-Id: <20210205221100.1738-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210205221100.1738-1-elder@linaro.org>
References: <20210205221100.1738-1-elder@linaro.org>
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

