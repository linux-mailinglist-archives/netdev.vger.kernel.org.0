Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2541C4AA5
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 01:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgEDXyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 19:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728502AbgEDXx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 19:53:58 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010A0C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 16:53:57 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b6so577220qkh.11
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 16:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9XACiVuJbdGDB4m5DcOQYF/89SovpMqMs92CddW1I0Q=;
        b=hjZSXzhiaNo7S7Z4PaRrhFbpuWIknNLD4oav0hWMO37HGigoBi8g0HigaeAHgHBdN/
         tPBxLoVrY/gPCFJJ7EsvtehhVEupMsPkQtkAbeGMvMScSGRvUvlsIHd775+oE/ZNwlE8
         gy4xZ0/V93bR7rt6LUe3EbRiXdYo3FQfR049ijMt3F4McDaguECyra5HyKMBciD7AXGO
         QiqeONvmoEpBW2/lvLEO7N8k13weHGQgH1mb4J8dar3hHJNCE5qEazboYtQ44+rZNYLZ
         UP6+bpmnsnMw7KrkCgnCs33V66GdQi7jhUl+emZ7jESpmyMuIIRUwsUBt0pA+6ux0KSA
         9RtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9XACiVuJbdGDB4m5DcOQYF/89SovpMqMs92CddW1I0Q=;
        b=Nwfp3KoHhy7KXSWNVEGv8DfRidlo9Z0XrF5DFa4SXK8Gx6bpLXi6VM0ACtXFkxka8e
         PU7X660Kj2wWEn2gJEGxMXWVeMArWwrjTIjOfGLDO1Tx71qvsQKzzF43FntXXhT+QNiu
         FQpp3NUIVlj/DkHRGMskpRvIVU5TM1pmRK6/oby6uuSPvbe6sDdQrZSzsoKzfvl2kfqF
         GiGQR7riFjZ69cpbjM5BKy+MjsEG/eH4pRvbXzO7G1g/OinHxljRtPM8GrQnjzWQQMZv
         KcEzZ5PJDMJQnVnyWz1lXi41m4q7RDp1QRHH+0GwGjEjN4ALP64IlhCwvkCJTpx8ZJoa
         v67Q==
X-Gm-Message-State: AGi0Pua6VLcOjKZO4Z+BEEpfoh8slABvqOwIbNGhOzY6IaH0o6dK+Px9
        1L3XTTPfz16lTfIdAi8PwrngoQ==
X-Google-Smtp-Source: APiQypIodqgpniZDq5PJv2HA5ySMRBCbNZwo7NHU6X7Zqqib2UdT632LS1sO74kP2KxMn2ooyVYG7Q==
X-Received: by 2002:a05:620a:693:: with SMTP id f19mr852050qkh.299.1588636436181;
        Mon, 04 May 2020 16:53:56 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z18sm296004qti.47.2020.05.04.16.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 16:53:55 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/5] net: ipa: kill ipa_endpoint_stop()
Date:   Mon,  4 May 2020 18:53:44 -0500
Message-Id: <20200504235345.17118-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200504235345.17118-1-elder@linaro.org>
References: <20200504235345.17118-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous commit made ipa_endpoint_stop() be a trivial wrapper
around gsi_channel_stop().  Since it no longer does anything
special, just open-code it in the three places it's used.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 27 ++++++---------------------
 drivers/net/ipa/ipa_endpoint.h |  2 --
 2 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 4939fdd3fca0..e451c3b20ca3 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1186,7 +1186,7 @@ static int ipa_endpoint_reset_rx_aggr(struct ipa_endpoint *endpoint)
 
 	gsi_trans_read_byte_done(gsi, endpoint->channel_id);
 
-	ret = ipa_endpoint_stop(endpoint);
+	ret = gsi_channel_stop(gsi, endpoint->channel_id);
 	if (ret)
 		goto out_suspend_again;
 
@@ -1203,7 +1203,7 @@ static int ipa_endpoint_reset_rx_aggr(struct ipa_endpoint *endpoint)
 	goto out_suspend_again;
 
 err_endpoint_stop:
-	ipa_endpoint_stop(endpoint);
+	(void)gsi_channel_stop(gsi, endpoint->channel_id);
 out_suspend_again:
 	if (endpoint_suspended)
 		(void)ipa_endpoint_init_ctrl(endpoint, true);
@@ -1241,22 +1241,6 @@ static void ipa_endpoint_reset(struct ipa_endpoint *endpoint)
 			ret, endpoint->channel_id, endpoint->endpoint_id);
 }
 
-/**
- * ipa_endpoint_stop() - Stops a GSI channel in IPA
- * @client:	Client whose endpoint should be stopped
- *
- * This function implements the sequence to stop a GSI channel
- * in IPA. This function returns when the channel is is STOP state.
- *
- * Return value: 0 on success, negative otherwise
- */
-int ipa_endpoint_stop(struct ipa_endpoint *endpoint)
-{
-	struct gsi *gsi = &endpoint->ipa->gsi;
-
-	return gsi_channel_stop(gsi, endpoint->channel_id);
-}
-
 static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
 {
 	struct device *dev = &endpoint->ipa->pdev->dev;
@@ -1324,12 +1308,13 @@ void ipa_endpoint_disable_one(struct ipa_endpoint *endpoint)
 {
 	u32 mask = BIT(endpoint->endpoint_id);
 	struct ipa *ipa = endpoint->ipa;
+	struct gsi *gsi = &ipa->gsi;
 	int ret;
 
-	if (!(endpoint->ipa->enabled & mask))
+	if (!(ipa->enabled & mask))
 		return;
 
-	endpoint->ipa->enabled ^= mask;
+	ipa->enabled ^= mask;
 
 	if (!endpoint->toward_ipa) {
 		ipa_endpoint_replenish_disable(endpoint);
@@ -1338,7 +1323,7 @@ void ipa_endpoint_disable_one(struct ipa_endpoint *endpoint)
 	}
 
 	/* Note that if stop fails, the channel's state is not well-defined */
-	ret = ipa_endpoint_stop(endpoint);
+	ret = gsi_channel_stop(gsi, endpoint->channel_id);
 	if (ret)
 		dev_err(&ipa->pdev->dev,
 			"error %d attempting to stop endpoint %u\n", ret,
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index 4b336a1f759d..3b297d65828e 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -76,8 +76,6 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa);
 
 int ipa_endpoint_skb_tx(struct ipa_endpoint *endpoint, struct sk_buff *skb);
 
-int ipa_endpoint_stop(struct ipa_endpoint *endpoint);
-
 void ipa_endpoint_exit_one(struct ipa_endpoint *endpoint);
 
 int ipa_endpoint_enable_one(struct ipa_endpoint *endpoint);
-- 
2.20.1

