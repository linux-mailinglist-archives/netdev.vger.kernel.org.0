Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD6930ADFA
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhBAReb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbhBARaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 12:30:21 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4939C0617A7
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 09:29:02 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id l4so16356198ilo.11
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 09:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q2ro88NuZQKHdsGWYPfuJW6JFivC14REhwCxv7lSOYY=;
        b=fs7JGSWDk2DyIez9s7HBm2L8UFGxKDXrmGsbBnIVdKm37iRyP4KN93gtg94OPSLe+N
         Hysbo3Owd0YEQJJ6o/9qYf95tgzgdqwQgkPUHrVTve+ZUow6oC1EXxtQ1eH9wif6Nepc
         Z+J/XbVZtwEoyn93fOqGMq9iaG6U00Qok9genuDr34I8+dSZ34ZXOTZ4rptvk4OECSbe
         kSSlmlXDlxvZsEjMB2uk678TSpE4Fg1zbJm2unuaXChbtULDKtoDo/A0llwvNrtjObpy
         wPuCybocR5VM2bHTqmuZ9tSJMBFxU1iqRs0WBXfd0HURLfQboerUG7+qZs5VtcuUjyxi
         HQAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q2ro88NuZQKHdsGWYPfuJW6JFivC14REhwCxv7lSOYY=;
        b=cjYmFjRV5UMM49NGgfXS7Vck/Wg1/nKTibA1y9OrMj9I/llirNnnSWSzTHHHchqd7C
         3VKXzSnGuXlsWzcs66EB5lvPRTpIViGBHJhNl/1VeLPaobmIHU0qu2e2Iv7X85IIB4l+
         ITKe8/NmY5FvIkuPCyaXhCr1NMDQSN0R17cqo74vcywp6pQWEuapjnEiPpJz9Ur8X0SU
         tAeLfL1YE2bocK5rbiETzKFm2Q7RvbaYZRIX/HVTgcmCj4qYCDwAcix7x6G2VB+CAEy/
         6iaNgFkq5vil/A73iKog6ssRPkP99bULjM611p2dGL+LEUEU1ThSWoCJ2HZTKVh0F4NL
         WrPg==
X-Gm-Message-State: AOAM531+PmCCw0zE9rMVySDiftUiG0oCdGecjwRj9BNV2Fb+Kw6O9m08
        rT1tWBsrFy72nKFOqmN8mgi8jg==
X-Google-Smtp-Source: ABdhPJwAI/ASi0UBA93Xj/MIF9FpEct7cfKR4ESj2WDMXtHG+UitLrC/Px98AVQ2NRSKjulzWv41Rw==
X-Received: by 2002:a05:6e02:20ee:: with SMTP id q14mr13386584ilv.259.1612200542357;
        Mon, 01 Feb 2021 09:29:02 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id v2sm9529856ilj.19.2021.02.01.09.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:29:01 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     willemdebruijn.kernel@gmail.com, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 6/7] net: ipa: don't disable interrupt on suspend
Date:   Mon,  1 Feb 2021 11:28:49 -0600
Message-Id: <20210201172850.2221624-7-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210201172850.2221624-1-elder@linaro.org>
References: <20210201172850.2221624-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No completion interrupts will occur while an endpoint is suspended,
nor when a channel has been stopped for suspend.  So there's no need
to disable the interrupt during suspend and re-enable it when
resuming.  Without any interrupts occurring, there is no need to
disable/re-enable NAPI for channel suspend/resume either.

We'll only enable NAPI and the interrupt when we first start the
channel, and disable it again only when it's "really" stopped.

To accomplish this, move the enable/disable calls out of
__gsi_channel_start() and __gsi_channel_stop(), and into
gsi_channel_start() and gsi_channel_stop() instead.

Add a call to napi_synchronize() to gsi_channel_suspend(), to ensure
NAPI polling is done before moving on.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: Consolidate preparatory patch into the "real" one.
v2: Update code for *both* NAPI and the completion interrupt.
v2: Use common return path in gsi_channel_start().

 drivers/net/ipa/gsi.c | 44 ++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 93e1d29b28385..03498182ad024 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -860,20 +860,15 @@ static int __gsi_channel_start(struct gsi_channel *channel, bool start)
 	struct gsi *gsi = channel->gsi;
 	int ret;
 
-	napi_enable(&channel->napi);
-	gsi_irq_ieob_enable_one(gsi, channel->evt_ring_id);
+	if (!start)
+		return 0;
 
 	mutex_lock(&gsi->mutex);
 
-	ret = start ? gsi_channel_start_command(channel) : 0;
+	ret = gsi_channel_start_command(channel);
 
 	mutex_unlock(&gsi->mutex);
 
-	if (ret) {
-		gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
-		napi_disable(&channel->napi);
-	}
-
 	return ret;
 }
 
@@ -881,8 +876,19 @@ static int __gsi_channel_start(struct gsi_channel *channel, bool start)
 int gsi_channel_start(struct gsi *gsi, u32 channel_id)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
+	int ret;
 
-	return __gsi_channel_start(channel, true);
+	/* Enable NAPI and the completion interrupt */
+	napi_enable(&channel->napi);
+	gsi_irq_ieob_enable_one(gsi, channel->evt_ring_id);
+
+	ret = __gsi_channel_start(channel, true);
+	if (ret) {
+		gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
+		napi_disable(&channel->napi);
+	}
+
+	return ret;
 }
 
 static int gsi_channel_stop_retry(struct gsi_channel *channel)
@@ -907,16 +913,15 @@ static int gsi_channel_stop_retry(struct gsi_channel *channel)
 
 static int __gsi_channel_stop(struct gsi_channel *channel, bool stop)
 {
-	struct gsi *gsi = channel->gsi;
 	int ret;
 
+	/* Wait for any underway transactions to complete before stopping. */
 	gsi_channel_trans_quiesce(channel);
 
 	ret = stop ? gsi_channel_stop_retry(channel) : 0;
-	if (!ret) {
-		gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
-		napi_disable(&channel->napi);
-	}
+	/* Finally, ensure NAPI polling has finished. */
+	if (!ret)
+		napi_synchronize(&channel->napi);
 
 	return ret;
 }
@@ -925,8 +930,17 @@ static int __gsi_channel_stop(struct gsi_channel *channel, bool stop)
 int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
+	int ret;
 
-	return __gsi_channel_stop(channel, true);
+	/* Only disable the completion interrupt if stop is successful */
+	ret = __gsi_channel_stop(channel, true);
+	if (ret)
+		return ret;
+
+	gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
+	napi_disable(&channel->napi);
+
+	return 0;
 }
 
 /* Reset and reconfigure a channel, (possibly) enabling the doorbell engine */
-- 
2.27.0

