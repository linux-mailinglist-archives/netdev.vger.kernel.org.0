Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA614310DB5
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 17:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbhBEOhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 09:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbhBEOem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:34:42 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B51C06178C
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 08:12:47 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id i63so4627612pfg.7
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 08:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p5s7C++oXCKkL15pcRUUu+6lFMtCGoUhTxjbs8xu7G8=;
        b=toYcYANum0bryfCxYh+S/LRngiplh0Lc19b6Lq9fkjmmnvtV/5NITO0+4Udb7m6Xzj
         Mgatqbie1YWP6o2YUoU/Ol7rE7qN+6PiNzEdat6hGEc+h2PiLUCTlDGZ8swByfbhRBm7
         19BDCUhPq0J3467Zf52+MLxBS8UHpS7jBU8E5m/6m8JhHT187S+ObjsVN44AyFYEN4yi
         9SsMLVzUIVlaFR+jsoXzALVjP72H16NSDyxZxsQ8D8ltVdp7VbuclaAQLFR+ydvJyS7h
         aJLR3UZillj34CJYqntWpfXRtbv+IY7OZo8Tlxplf505hneIQiEjlcmnocW7M1wOw3DF
         Iwfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p5s7C++oXCKkL15pcRUUu+6lFMtCGoUhTxjbs8xu7G8=;
        b=aT+sk16kZjotnMryAg/hb7msrwkGdvKuMEzx4pHb4VsBJqA6mTpaRCbTcQehXJbKIc
         mguRzhI0Q/0uP1YfyBDCSvkX1yZSXOEa+zAhjI59P8sUkhvUSChV7C1G05ibO8JrCqM+
         OKqY6Sg6/O2S1+J3s75OuRgeGADk4iXZaEovIGI8Xi43T9lRtBhmRP1n/qauGSKfgsLK
         SJ0Xcxxlvil46w66MVe9+v2oIfoMCfv+hqKNwkXQS5Dd0jNepUP1LOCVr+aDQjg5w/oP
         XlSezZI9Az/118nYu2Fp/Vml8Me0AXX3ZsruW851oF62tNSzNKupEPVT/+WushNIDhz+
         TQyw==
X-Gm-Message-State: AOAM532izhc424TxHww+rq7iABCR2xrWQkLsa15FIWHuYNL6CBkRGG1R
        67xphz8oa0rsYA0rvPXtCtnVzggymqSu8A==
X-Google-Smtp-Source: ABdhPJwaDuYrhiumZd8P0lH5T4flCQEFcPICJR2akhC5Tw/RWSCW840iBZyVia5w72yx9WyCiIIZmg==
X-Received: by 2002:a05:6e02:20e8:: with SMTP id q8mr3951625ilv.205.1612535914480;
        Fri, 05 Feb 2021 06:38:34 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h9sm4136882ili.43.2021.02.05.06.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 06:38:33 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/7] net: ipa: move mutex calls into __gsi_channel_stop()
Date:   Fri,  5 Feb 2021 08:38:23 -0600
Message-Id: <20210205143829.16271-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210205143829.16271-1-elder@linaro.org>
References: <20210205143829.16271-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the mutex calls out of gsi_channel_stop_retry() and into
__gsi_channel_stop(), to make the latter more semantically similar
to to __gsi_channel_start().

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: - Return early in some cases, to avoid blocks of indented code
    - Update description, to better reflect the updated patch
    - Fix v1 bug in gsi_channel_stop(); disable things on *success*

 drivers/net/ipa/gsi.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 53640447bf123..f0432c965168c 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -910,11 +910,8 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
 static int gsi_channel_stop_retry(struct gsi_channel *channel)
 {
 	u32 retries = GSI_CHANNEL_STOP_RETRIES;
-	struct gsi *gsi = channel->gsi;
 	int ret;
 
-	mutex_lock(&gsi->mutex);
-
 	do {
 		ret = gsi_channel_stop_command(channel);
 		if (ret != -EAGAIN)
@@ -922,24 +919,33 @@ static int gsi_channel_stop_retry(struct gsi_channel *channel)
 		usleep_range(3 * USEC_PER_MSEC, 5 * USEC_PER_MSEC);
 	} while (retries--);
 
-	mutex_unlock(&gsi->mutex);
-
 	return ret;
 }
 
 static int __gsi_channel_stop(struct gsi_channel *channel, bool stop)
 {
+	struct gsi *gsi = channel->gsi;
 	int ret;
 
 	/* Wait for any underway transactions to complete before stopping. */
 	gsi_channel_trans_quiesce(channel);
 
-	ret = stop ? gsi_channel_stop_retry(channel) : 0;
-	/* Finally, ensure NAPI polling has finished. */
-	if (!ret)
-		napi_synchronize(&channel->napi);
+	if (!stop)
+		return 0;
 
-	return ret;
+	mutex_lock(&gsi->mutex);
+
+	ret = gsi_channel_stop_retry(channel);
+
+	mutex_unlock(&gsi->mutex);
+
+	if (ret)
+		return ret;
+
+	/* Ensure NAPI polling has finished. */
+	napi_synchronize(&channel->napi);
+
+	return 0;
 }
 
 /* Stop a started channel */
@@ -948,11 +954,11 @@ int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
 	struct gsi_channel *channel = &gsi->channel[channel_id];
 	int ret;
 
-	/* Only disable the completion interrupt if stop is successful */
 	ret = __gsi_channel_stop(channel, true);
 	if (ret)
 		return ret;
 
+	/* Disable the completion interrupt and NAPI if successful */
 	gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
 	napi_disable(&channel->napi);
 
-- 
2.20.1

