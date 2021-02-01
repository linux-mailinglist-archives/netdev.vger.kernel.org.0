Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF4230ADEB
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbhBARa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbhBARaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 12:30:20 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C6EC061788
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 09:28:58 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id s24so6662098iob.6
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 09:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S6UrYR89rofy8hE7qWATkIkJyfK6GF/86I4qksnu9sI=;
        b=EnDETKm4J5LhZK4ej0H/mtR46vNCiJWFRQs8N3XLOT39eML1sFrccDex46b1mJJkj4
         HzFY309+TQpXLC1RDIEVqVW5FxFbNH4C1xC09myhkYfxLa1k/zk3TCobP+qeeoVzbE9l
         Q4EAGBin9glOoxzh9dAal5ydMXVvgbsVvKP8WXyl2htHxC0bCzQJ97z6JOn+2SkY2N14
         XBDX8RYGg29Jzt9zX3hifE9SXTFoPO76ZHD0TeDpl5b7QOvmB3fPbt+P2Q+SVILQkSU/
         wK0nE0cC2sgIKYN0HckRq9+sBnTH3ryPFUYU+jc8myLl5ij5TXcq2kZv7ad9z6NEPDQa
         vD+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S6UrYR89rofy8hE7qWATkIkJyfK6GF/86I4qksnu9sI=;
        b=kcCrlAGMuSwUsHYW7u8gV94Vq3A3XRPTiqCj1tqW7P1vSKiI245BxoCg1RuHqH2kmS
         yMMC1eK+S320t/bhm1EQLQLlmrv5Oa44OEgblT677D2sjqETW3iD1f9vGgA++GljwCJF
         vqn+fpeSTTHmks65M/uCrkPq314Lkzz/9IaWPY1spI/pFQ1hgfyxlwcATQ/aGpvUBirt
         DxE11S97DQtK5FVgBvJFpD6n5075Ki+7DYsNWdS5xxJIAGhpNvsdPsk4VfFmSYEbF6Bt
         Oi+WyDt93mHd/LXbVfNXYPn2piIphj2H/SpLYq71ij6fWUUIlahPcNogCXDG+VSUmyos
         Is+Q==
X-Gm-Message-State: AOAM533ASbIues5W+eOdgBz3I+/gaBnwk2kFSd1bbFoX9Zt18q6RENGt
        rtS5t4G3pDM5gHNvnk5njlf76w==
X-Google-Smtp-Source: ABdhPJzqXikoXli2cdw8YD8g6w4oiEyCrjfHaBTVK8862fhTr4ingSTAVJh2zz4fDmciLhdTvFHXhw==
X-Received: by 2002:a5e:840d:: with SMTP id h13mr13798860ioj.23.1612200538427;
        Mon, 01 Feb 2021 09:28:58 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id v2sm9529856ilj.19.2021.02.01.09.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:28:57 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     willemdebruijn.kernel@gmail.com, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/7] net: ipa: introduce __gsi_channel_start()
Date:   Mon,  1 Feb 2021 11:28:46 -0600
Message-Id: <20210201172850.2221624-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210201172850.2221624-1-elder@linaro.org>
References: <20210201172850.2221624-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new function that does most of the work of starting a
channel.  What's different is that it takes a flag indicating
whether the channel should really be started or not.  Create
another new function __gsi_channel_stop() that behaves similarly.

IPA v3.5.1 implements suspend using a special SUSPEND endpoint
setting.  If the endpoint is suspended when an I/O completes on the
underlying GSI channel, a SUSPEND interrupt is generated.

Newer versions of IPA do not implement the SUSPEND endpoint mode.
Instead, endpoint suspend is implemented by simply stopping the
underlying GSI channel.  In this case, a completing I/O on a
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

