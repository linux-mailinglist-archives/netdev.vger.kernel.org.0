Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D304A8957
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352528AbiBCRJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352517AbiBCRJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:09:35 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0A9C06173D
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 09:09:34 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id z18so2660788ilp.3
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 09:09:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HDx7zrECt0lRbn6ErTR+Jkn99RQBQ9k/kBc416RdGfc=;
        b=TjhIqGFUReCXhgyjJ7DYcxUGbwXOKufhBPP/MOfmOvCSCBciZLnMwUeQ96hHaYkQPb
         lmcXyk96hPRDuWXI0U4tfltE2PTFy94slEmLlUkMikgjc2mX4NaIZdMbsYi3vVgXUtLf
         3YqeDO5DObZCYFaZNU/k77u71LZnlgWBREW3JkuyIMXxbEBYiraQH9uwOApbxT+f0HHq
         IPZRTRGXrykjXtyqoMdbZjTS3TX+C0VomNYjfidqyKVA5tM7R4+/TtMd269gBnGqYPJk
         0tDgyYuigex5iJggC8A1l+9B81XV3rbvr+YEspMGTts3br3ZINHht2U2/qVM9ejsz5bG
         WndQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HDx7zrECt0lRbn6ErTR+Jkn99RQBQ9k/kBc416RdGfc=;
        b=27pa651mpa+DkIJwHdztX2dQBo7FqyOGNbGT0Gi0yYaRSKfBEkbqQ5EF06Jaze1dBf
         5GlBDHanNIlsNwJhKuebUJ9O0YstVGRsJdvdSHD7Ii7XKNidb+b9ynxzf4JyGgFKmYyp
         6SAHNt+OIQP1SLxBEfPCl3c3bwlqWHWkPw8JOsOWuun4H2Apriz41kCrjnNmIFN7QZ16
         Z8PODNIozKBwnHvGLIS+lKnUn6DZGAyYGnCXgZPnehxO8mfePW2Wos9n3QY86b+4J2EM
         +ENSyhUZVQ8YBuvkQm0fT7Ultl0ulgCzOYgVsafJ/6ffbmk+RQJFOMUrSlyviYUe0xuq
         5yoA==
X-Gm-Message-State: AOAM533MtuDs7oQB1Wnv0j/CSssoepqjwmmHJyyK7BEt5T3HEAwpZu1G
        mkgMH4rVs7jT5LrDMN46E4ABnw==
X-Google-Smtp-Source: ABdhPJz5StQMD32VXFnbCoQKHcybhlADU8uiE5tXhUIqC5kLooVjU+SY5inGUl/6NJ8w5o3T44lFmw==
X-Received: by 2002:a92:d4ce:: with SMTP id o14mr20659791ilm.218.1643908174073;
        Thu, 03 Feb 2022 09:09:34 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m12sm21869671iow.54.2022.02.03.09.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 09:09:33 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, mka@chromium.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, avuyyuru@codeaurora.org,
        jponduru@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 01/10] net: ipa: kill replenish_saved
Date:   Thu,  3 Feb 2022 11:09:18 -0600
Message-Id: <20220203170927.770572-2-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220203170927.770572-1-elder@linaro.org>
References: <20220203170927.770572-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The replenish_saved field keeps track of the number of times a new
buffer is added to the backlog when replenishing is disabled.  We
don't really use it though, so there's no need for us to track it
separately.  Whether replenishing is enabled or not, we can simply
increment the backlog.

Get rid of replenish_saved, and initialize and increment the backlog
where it would have otherwise been used.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 17 ++++-------------
 drivers/net/ipa/ipa_endpoint.h |  2 --
 2 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index fffd0a784ef2c..a9f6d4083f869 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1090,9 +1090,8 @@ static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint)
  * endpoint, based on the number of entries in the underlying channel ring
  * buffer.  If an endpoint's "backlog" is non-zero, it indicates how many
  * more receive buffers can be supplied to the hardware.  Replenishing for
- * an endpoint can be disabled, in which case requests to replenish a
- * buffer are "saved", and transferred to the backlog once it is re-enabled
- * again.
+ * an endpoint can be disabled, in which case buffers are not queued to
+ * the hardware.
  */
 static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, bool add_one)
 {
@@ -1102,7 +1101,7 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, bool add_one)
 
 	if (!test_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags)) {
 		if (add_one)
-			atomic_inc(&endpoint->replenish_saved);
+			atomic_inc(&endpoint->replenish_backlog);
 		return;
 	}
 
@@ -1147,11 +1146,8 @@ static void ipa_endpoint_replenish_enable(struct ipa_endpoint *endpoint)
 {
 	struct gsi *gsi = &endpoint->ipa->gsi;
 	u32 max_backlog;
-	u32 saved;
 
 	set_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
-	while ((saved = atomic_xchg(&endpoint->replenish_saved, 0)))
-		atomic_add(saved, &endpoint->replenish_backlog);
 
 	/* Start replenishing if hardware currently has no buffers */
 	max_backlog = gsi_channel_tre_max(gsi, endpoint->channel_id);
@@ -1161,11 +1157,7 @@ static void ipa_endpoint_replenish_enable(struct ipa_endpoint *endpoint)
 
 static void ipa_endpoint_replenish_disable(struct ipa_endpoint *endpoint)
 {
-	u32 backlog;
-
 	clear_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
-	while ((backlog = atomic_xchg(&endpoint->replenish_backlog, 0)))
-		atomic_add(backlog, &endpoint->replenish_saved);
 }
 
 static void ipa_endpoint_replenish_work(struct work_struct *work)
@@ -1727,9 +1719,8 @@ static void ipa_endpoint_setup_one(struct ipa_endpoint *endpoint)
 		 */
 		clear_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
 		clear_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags);
-		atomic_set(&endpoint->replenish_saved,
+		atomic_set(&endpoint->replenish_backlog,
 			   gsi_channel_tre_max(gsi, endpoint->channel_id));
-		atomic_set(&endpoint->replenish_backlog, 0);
 		INIT_DELAYED_WORK(&endpoint->replenish_work,
 				  ipa_endpoint_replenish_work);
 	}
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index 0313cdc607de3..c95816d882a74 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -66,7 +66,6 @@ enum ipa_replenish_flag {
  * @netdev:		Network device pointer, if endpoint uses one
  * @replenish_flags:	Replenishing state flags
  * @replenish_ready:	Number of replenish transactions without doorbell
- * @replenish_saved:	Replenish requests held while disabled
  * @replenish_backlog:	Number of buffers needed to fill hardware queue
  * @replenish_work:	Work item used for repeated replenish failures
  */
@@ -87,7 +86,6 @@ struct ipa_endpoint {
 	/* Receive buffer replenishing for RX endpoints */
 	DECLARE_BITMAP(replenish_flags, IPA_REPLENISH_COUNT);
 	u32 replenish_ready;
-	atomic_t replenish_saved;
 	atomic_t replenish_backlog;
 	struct delayed_work replenish_work;		/* global wq */
 };
-- 
2.32.0

