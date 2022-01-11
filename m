Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF73648B749
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 20:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346455AbiAKTWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 14:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244413AbiAKTV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 14:21:57 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302DBC061748
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 11:21:57 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id v6so264512iom.6
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 11:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zG6mc9R8T0VuQRaKqR7/UCbKIE1yA2lVDcf9Ztg1BPw=;
        b=gBRFGEKQyVWTVpOHb0ZBdMzwB0eZcclVsmYYGFXiVzGc7ur6Q/unveTJlSIZDtGNye
         Bwey6ax7smlPgoxENKvfeUTkXUqsDCnae6KaHOJ+fnmH4iQBKGepbEymAcAWDCi/v2Lv
         HA1Hxt0IRq3c4TApg664Am2q1WKWazunoH+Io+eaFBgHQZV4tEu0gBC7xAMo3dvVrPvv
         ftNfkmdZ7MR2hHv6kTugk7ftOl53INz/JHvvnbSUkyNNNswePWt7YZcWirumhuXONycN
         Cs5ARCOMiIyOmadYZlOWnNPUwTdZ5jqUd6dOgeIgTnRqgiFMxb+yrYTzcswI4y3kuJzo
         8j5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zG6mc9R8T0VuQRaKqR7/UCbKIE1yA2lVDcf9Ztg1BPw=;
        b=tabM+G02l5UqFg6jfj7fH2ozwf9c1fPPRt5mQys7cfkeZ2mjvHjmng9zOOiDt6gNvy
         rnkPVZGonUF1MpJrXvcAY8tAkfs27jg6g4yYBq+Gbkz2iiy72V6BDokmAGhhS+jW9Xb4
         z/6R96/6EIi4w/3BX7o0YLD9rZoKuDoikLkN4QvCH/8eaFjQi54vCCZO/KMkhmMS6wOR
         y37+kY4/JQKmXo67ACAXfl7IPPPhJXGNpAWcfBVnMvhKepcEib+UiRKalMVtr+1CU6/2
         huZ9fRf4+frXu6spyeIlxna9aR2hbO9z2QG6eRtSqn1RcLffubjgvH4C9RUUi96EQZC9
         UP1g==
X-Gm-Message-State: AOAM532qV3KAhFKEDj4RdpJSspdSRdkdp4ShXxpa7piZFzh8D7kLDGsf
        TtM9sLIPr4fF6ZFdXj50qFIImw==
X-Google-Smtp-Source: ABdhPJwYaKcnyX6qsqEycE/nqRqkIxKSK9nGRQ6obnUE8Pj9wqslbCcNe1OOivkvsJDA+eENKbC+3Q==
X-Received: by 2002:a05:6638:1348:: with SMTP id u8mr3068773jad.278.1641928916610;
        Tue, 11 Jan 2022 11:21:56 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id e17sm6264544iow.30.2022.01.11.11.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 11:21:56 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     jponduru@codeaurora.org, avuyyuru@codeaurora.org,
        bjorn.andersson@linaro.org, agross@kernel.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        evgreen@chromium.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] net: ipa: prevent concurrent replenish
Date:   Tue, 11 Jan 2022 13:21:50 -0600
Message-Id: <20220111192150.379274-3-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220111192150.379274-1-elder@linaro.org>
References: <20220111192150.379274-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have seen cases where an endpoint RX completion interrupt arrives
while replenishing for the endpoint is underway.  This causes another
instance of replenishing to begin as part of completing the receive
transaction.  If this occurs it can lead to transaction corruption.

Use a new atomic variable to ensure only replenish instance for an
endpoint executes at a time.

Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 13 +++++++++++++
 drivers/net/ipa/ipa_endpoint.h |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 8b055885cf3cf..a1019f5fe1748 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1088,15 +1088,27 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, bool add_one)
 		return;
 	}
 
+	/* If already active, just update the backlog */
+	if (atomic_xchg(&endpoint->replenish_active, 1)) {
+		if (add_one)
+			atomic_inc(&endpoint->replenish_backlog);
+		return;
+	}
+
 	while (atomic_dec_not_zero(&endpoint->replenish_backlog))
 		if (ipa_endpoint_replenish_one(endpoint))
 			goto try_again_later;
+
+	atomic_set(&endpoint->replenish_active, 0);
+
 	if (add_one)
 		atomic_inc(&endpoint->replenish_backlog);
 
 	return;
 
 try_again_later:
+	atomic_set(&endpoint->replenish_active, 0);
+
 	/* The last one didn't succeed, so fix the backlog */
 	delta = add_one ? 2 : 1;
 	backlog = atomic_add_return(delta, &endpoint->replenish_backlog);
@@ -1691,6 +1703,7 @@ static void ipa_endpoint_setup_one(struct ipa_endpoint *endpoint)
 		 * backlog is the same as the maximum outstanding TREs.
 		 */
 		endpoint->replenish_enabled = false;
+		atomic_set(&endpoint->replenish_active, 0);
 		atomic_set(&endpoint->replenish_saved,
 			   gsi_channel_tre_max(gsi, endpoint->channel_id));
 		atomic_set(&endpoint->replenish_backlog, 0);
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index 0a859d10312dc..200f093214997 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -53,6 +53,7 @@ enum ipa_endpoint_name {
  * @netdev:		Network device pointer, if endpoint uses one
  * @replenish_enabled:	Whether receive buffer replenishing is enabled
  * @replenish_ready:	Number of replenish transactions without doorbell
+ * @replenish_active:	1 when replenishing is active, 0 otherwise
  * @replenish_saved:	Replenish requests held while disabled
  * @replenish_backlog:	Number of buffers needed to fill hardware queue
  * @replenish_work:	Work item used for repeated replenish failures
@@ -74,6 +75,7 @@ struct ipa_endpoint {
 	/* Receive buffer replenishing for RX endpoints */
 	bool replenish_enabled;
 	u32 replenish_ready;
+	atomic_t replenish_active;
 	atomic_t replenish_saved;
 	atomic_t replenish_backlog;
 	struct delayed_work replenish_work;		/* global wq */
-- 
2.32.0

