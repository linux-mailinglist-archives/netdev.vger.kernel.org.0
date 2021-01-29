Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46D7308E69
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbhA2UWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233232AbhA2UVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 15:21:25 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17F0C06178C
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 12:20:26 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id p8so9678574ilg.3
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 12:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OBqftNk7KK/hgwXMe4abpMIUsX1N08dKF58CvJahdXQ=;
        b=k9O4EaUTX7WtWmva4k0QkyOiAhETxyKXeh5mb9sltSN1n6LTdpYOhl5FwQCOJhz0sp
         srYl2moLMR0caSuxHIeXlCWYb+fxfYf3CaBsVtf0McuVYbf7QvcM7GGat+0oTJiDR2EM
         k1Av/2OUYhbGpkhk28dgHa6/T+gxPVNfJP7PwzEb8jXQswb8PeGGUomkIzds9+AhoWFY
         vEH6P33o2ENptCtw+dLRUjZtiv7Ihlq1azo2rH3m7LlonGqPI1QeUISgTzU2GzVBcbab
         5Z5MlyL9/jsWjMLzWISzjrjSB7P1GzgQDYeM7fJnllvFXuKwSfVP3vglnxPeuo8y/OMS
         l4+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OBqftNk7KK/hgwXMe4abpMIUsX1N08dKF58CvJahdXQ=;
        b=lGHo9qolshaWWlVST9IGtEN3uUtO/8yE5QqDUhjyg6LdmVXso3OkaKds9n68OKGhyw
         sGXMiv12rJtZ/AqS6bOHSf7Y+ah9T36YrtpPkOxkHuP/fZ2KCX43NaGtgrg6vk2fz5TJ
         WpOvN2sPBM+fJ8KuSNLfRa0h6evtpUQBp+/zTRAUgTKmm6u93Kplsu5VSsAJcsYV1x5a
         7D1v410t7YnAhwvUnOanRoF5hfZPHQadjwGk01mC4Is6ncO3FdHKPK5JqmxDasYHzLGp
         6WNUyDRYjDysgGEwIEqIefsdjUdPckEVc545yMqbSjl+cptaVVA9TM1GJk0bQiU6py2p
         kZRA==
X-Gm-Message-State: AOAM5337K7urDxSyaS7RyQwiRfi78blX4cO6p0gH3NVTZDY5ew+sK/QY
        aXDPzEznMtOomp4u2RFK2bajEg==
X-Google-Smtp-Source: ABdhPJxnz00s2VWLyp/FojKbyPiNbgmVU8sLuzZCZ25EUKG/UMrg2scuVzBC7mqApCq8duMfX4vp+Q==
X-Received: by 2002:a05:6e02:1bcb:: with SMTP id x11mr4452038ilv.226.1611951626374;
        Fri, 29 Jan 2021 12:20:26 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h23sm4645738ila.15.2021.01.29.12.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 12:20:25 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/9] net: ipa: introduce __gsi_channel_start()
Date:   Fri, 29 Jan 2021 14:20:13 -0600
Message-Id: <20210129202019.2099259-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210129202019.2099259-1-elder@linaro.org>
References: <20210129202019.2099259-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new function that does most of the work of starting a
channel.  What's different is that it takes a flag indicating
whether the channel should really be stopped or not.  When doing a
"normal" channel start, the flag is true.  Create another new
function __gsi_channel_stop() that behaves similarly.

IPA v3.5.1 implements suspend using a special SUSPEND endpoint
setting.  If the endpoint is suspended when an I/O completes on the
underlying GSI channel, a SUSPEND interrupt is generated.

Newer versions of IPA do not implement the SUSPEND endpoint mode.
Instead, endpoint suspend is implemented by simply stopping the
underlying GSI channel.  In this case, an I/O completion on a
*stopped* channel causes the SUSPEND interrupt condition.

These new functions put all activity related to starting or stopping
a channel (including "thawing/freezing" the channel) in one place,
whether or not the channel is actually started or stopped.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 71 ++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index bd1bf388d9892..bba64887fe969 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -873,23 +873,30 @@ static void gsi_channel_deprogram(struct gsi_channel *channel)
 	/* Nothing to do */
 }
 
+static int __gsi_channel_start(struct gsi_channel *channel, bool start)
+{
+	struct gsi *gsi = channel->gsi;
+	int ret;
+
+	mutex_lock(&gsi->mutex);
+
+	ret = start ? gsi_channel_start_command(channel) : 0;
+
+	mutex_unlock(&gsi->mutex);
+
+	/* Thaw the channel if successful */
+	if (!ret)
+		gsi_channel_thaw(channel);
+
+	return ret;
+}
+
 /* Start an allocated GSI channel */
 int gsi_channel_start(struct gsi *gsi, u32 channel_id)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
-	int ret;
 
-	mutex_lock(&gsi->mutex);
-
-	ret = gsi_channel_start_command(channel);
-
-	mutex_unlock(&gsi->mutex);
-
-	/* Thaw the channel if successful */
-	if (!ret)
-		gsi_channel_thaw(channel);
-
-	return ret;
+	return __gsi_channel_start(channel, true);
 }
 
 static int gsi_channel_stop_retry(struct gsi_channel *channel)
@@ -912,21 +919,27 @@ static int gsi_channel_stop_retry(struct gsi_channel *channel)
 	return ret;
 }
 
+static int __gsi_channel_stop(struct gsi_channel *channel, bool stop)
+{
+	int ret;
+
+	gsi_channel_freeze(channel);
+
+	ret = stop ? gsi_channel_stop_retry(channel) : 0;
+
+	/* Re-thaw the channel if an error occurred while stopping */
+	if (ret)
+		gsi_channel_thaw(channel);
+
+	return ret;
+}
+
 /* Stop a started channel */
 int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
-	int ret;
 
-	gsi_channel_freeze(channel);
-
-	ret = gsi_channel_stop_retry(channel);
-
-	/* Re-thaw the channel if an error occurred while stopping */
-	if (ret)
-		gsi_channel_thaw(channel);
-
-	return ret;
+	return __gsi_channel_stop(channel, true);
 }
 
 /* Reset and reconfigure a channel, (possibly) enabling the doorbell engine */
@@ -952,12 +965,7 @@ int gsi_channel_suspend(struct gsi *gsi, u32 channel_id, bool stop)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
 
-	if (stop)
-		return gsi_channel_stop(gsi, channel_id);
-
-	gsi_channel_freeze(channel);
-
-	return 0;
+	return __gsi_channel_stop(channel, stop);
 }
 
 /* Resume a suspended channel (starting will be requested if STOPPED) */
@@ -965,12 +973,7 @@ int gsi_channel_resume(struct gsi *gsi, u32 channel_id, bool start)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
 
-	if (start)
-		return gsi_channel_start(gsi, channel_id);
-
-	gsi_channel_thaw(channel);
-
-	return 0;
+	return __gsi_channel_start(channel, start);
 }
 
 /**
-- 
2.27.0

