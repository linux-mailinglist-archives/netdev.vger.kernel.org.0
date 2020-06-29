Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2AC520E73E
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391575AbgF2Vzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391559AbgF2Vz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 17:55:27 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93BAC061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:55:27 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id v8so18771442iox.2
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zQuQWfZzfj1SDZzBIXoKjjE4U7nBLLgIi6SIHAdQ+GA=;
        b=nGp01w2niKYCt4PaDR03fsVvxKd2eC+s3Q3ZlNqyypP7ldsPagswtGN9KUM4XpbMIS
         Aa9+EGXM/XCYpLzhGgRDKGbNqzrCnxV387ZzSl/TfHcNQM0o3SykBipxtAeYnbQJbo1z
         h/C+KpByaLay7PG11dGkPSCVyYbYjkGT1aGqC84lQ90RyZg1H/i8zJd4M8ZfZh64WFbQ
         B7L//WshF43JDl7GAWd1uVvioE2U6lJSsSNNpRIHQ9dJMwXqBVDGEB5Nhbjsz44aJ4ly
         Odk/LQmZSPI3hCI8zXjT9mK+fzzOArU9EY9PiorANBPUC4Bjq5gnpn4UcexJh7T7mGOR
         1Plg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zQuQWfZzfj1SDZzBIXoKjjE4U7nBLLgIi6SIHAdQ+GA=;
        b=W2ArHTczmlivaxMY89jnrBHUnF+GXE0kjEaPeuHnHw1zKKf2qxcw6BfzF79fRml2nO
         6rV8iH0Pq48M28v/zAYCwpklX6drpdUxYeiTnq30RxG7iIJpf+U8LvWYCRb33TbAJSKw
         jbcTSDZp4i7HLaSe2lA+qwXs9jsIp/SNAQqcfsKJUMLLlv40VN1J5jVGjOf4e6jNtj8R
         PvkKYYiLuSn/+Nu+GSrmSe3Kwj8V5C64IaVJIb1VoY+lyipWBqfkt80oj5OvfzCQ/7pC
         radcdyaOv16eAF7z8BHrKUL9LuYtMh64Th+KhmtVxo0hiW4f8nZqzjpqm+yH4zNo0Egt
         bNwQ==
X-Gm-Message-State: AOAM5320D0PVfSlFGnM7YxIpoiRVl0TqX+XutOyxZrOJGvNGLet9GiZF
        kX5evFwZdHkW/+E0g1uWDHWL6A==
X-Google-Smtp-Source: ABdhPJxGwvvKmc1/Mw85Jidwdd9tp3bG583KjI33LYk6uebsjpDlj/Bf8q7fbeentimbgNbROGtx3Q==
X-Received: by 2002:a05:6602:491:: with SMTP id y17mr18551373iov.72.1593467727042;
        Mon, 29 Jun 2020 14:55:27 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a187sm543221iog.2.2020.06.29.14.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 14:55:26 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/3] net: ipa: rework ipa_aggr_granularity_val()
Date:   Mon, 29 Jun 2020 16:55:21 -0500
Message-Id: <20200629215523.1196263-2-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629215523.1196263-1-elder@linaro.org>
References: <20200629215523.1196263-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The timer used for aggregation makes use of an internal 32 KHz clock.
The granularity of the timer is programmed by a field whose value is
computed by ipa_aggr_granularity_val().  Redefine the way that value
is computed by using a new TIMER_FREQUENCY constant representing the
underlying clock frequency.

Add two BUILD_BUG_ON() calls to ensure the value used is valid.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c |  5 +++++
 drivers/net/ipa/ipa_reg.h  | 17 ++++++++---------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 76d5108b8403..27a869df3a4b 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -674,6 +674,11 @@ static void ipa_validate_build(void)
 
 	/* This is used as a divisor */
 	BUILD_BUG_ON(!IPA_AGGR_GRANULARITY);
+
+	/* Aggregation granularity value can't be 0, and must fit */
+	BUILD_BUG_ON(!ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY));
+	BUILD_BUG_ON(ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY) >
+			field_max(AGGR_GRANULARITY));
 #endif /* IPA_VALIDATE */
 }
 
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 0a688d8c1d7c..7ae8015798ae 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -190,24 +190,23 @@ static inline u32 ipa_reg_bcr_val(enum ipa_version version)
 	return 0x00000000;
 }
 
-
 #define IPA_REG_LOCAL_PKT_PROC_CNTXT_BASE_OFFSET	0x000001e8
 
 #define IPA_REG_AGGR_FORCE_CLOSE_OFFSET			0x000001ec
 /* ipa->available defines the valid bits in the AGGR_FORCE_CLOSE register */
 
+/* The internal inactivity timer clock is used for the aggregation timer */
+#define TIMER_FREQUENCY	32000	/* 32 KHz inactivity timer clock */
+
 #define IPA_REG_COUNTER_CFG_OFFSET			0x000001f0
 #define AGGR_GRANULARITY			GENMASK(8, 4)
-/* Compute the value to use in the AGGR_GRANULARITY field representing
- * the given number of microseconds (up to 1 millisecond).
- *	x = (32 * usec) / 1000 - 1
+/* Compute the value to use in the AGGR_GRANULARITY field representing the
+ * given number of microseconds.  The value is one less than the number of
+ * timer ticks in the requested period.  Zero not a valid granularity value.
  */
-static inline u32 ipa_aggr_granularity_val(u32 microseconds)
+static inline u32 ipa_aggr_granularity_val(u32 usec)
 {
-	/* assert(microseconds >= 16); (?) */
-	/* assert(microseconds <= 1015); */
-
-	return DIV_ROUND_CLOSEST(32 * microseconds, 1000) - 1;
+	return DIV_ROUND_CLOSEST(usec * TIMER_FREQUENCY, USEC_PER_SEC) - 1;
 }
 
 #define IPA_REG_TX_CFG_OFFSET				0x000001fc
-- 
2.25.1

