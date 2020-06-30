Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A3620F541
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388127AbgF3M6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387971AbgF3M6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:58:52 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B47C03E979
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 05:58:51 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id y2so20866280ioy.3
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 05:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zvwmuOxhUd9gYI7ZmOWVfT8VxRuFbGiVGtVR+SU80d8=;
        b=jcJyeHuZhgei633Ns+gF8MPjHBpaLmONY+fD0uvur0WjNqyKe697npjSZTYugGZzq3
         CyeTPqgF4IZwqJ1rNcSJL/5KiWJdfkS4Ew3LbCylq+mNPY2HOG9CAtjA1aAf4RhOlV9n
         p75o2bILLbT5KiPcKXhxrOaF2ruP0LMWj9lA3Irm52wWkuEoil2YgpOWWGxKU9zKfAG7
         2arx33Glcc/hoJvUjyFwVBViwzMPtN/I02Y3rOyRWVEtXk7lenzJ/r3guGziEr1BBPj8
         GvD2Jyjj3p2KUBmK/G2BQL8Xp7rgxdlKoS4rk7tdWUrrhTFEOl7UUyu7ONe48hxWba+b
         LQmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zvwmuOxhUd9gYI7ZmOWVfT8VxRuFbGiVGtVR+SU80d8=;
        b=JhoviFHuqjn8HMQZLhzhAoj8cj2UUouco0ZpxIn4zB4vLE4FqK3L7VDBwt5VAbYiRM
         2FAPYgbxKsC2YxmoLi7PzKMzD+PUaBMeOUeMn4IghsJSFCgSvvLUXZyU2NxO2WaiW/0a
         Yvrm2Pt6IiY4lYbApHjm3A7/Cw8qp1PuhGPhcaRlVBXAlvUj2ZfAW59e4wvCbBARP/NR
         Q7WkzjBFxIQTm0yuzb3RJD6T8wpDhqFbkaNWzD1ALw4f8EP7WB7IBc1TB9E4DVlS91gS
         jvWRYGEAYNAQWqoDkYAoz0TPA7aUBzRq9LwpZWqNeLVv/XL7tho6yOGbmqtcjBwYTi4h
         h2Hg==
X-Gm-Message-State: AOAM533qj8CLJBShDORB4Sin2Ii2lfuVMLaraPfqjeNhvfSBh6b8NEys
        EdQ+Yqt6Z+oiMi11R3FBkIIL9H5LNJ8=
X-Google-Smtp-Source: ABdhPJy/o3BU5qhfjlIqHI1EERFkFjHubRTEksLQefAEpHQOUn2DC6DjwWUdI7NT3Ghqm4ggoKjVNw==
X-Received: by 2002:a5e:dd4c:: with SMTP id u12mr21046408iop.14.1593521931183;
        Tue, 30 Jun 2020 05:58:51 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z9sm1622588ilb.41.2020.06.30.05.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 05:58:50 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/3] net: ipa: always report GSI state errors
Date:   Tue, 30 Jun 2020 07:58:44 -0500
Message-Id: <20200630125846.1281988-2-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200630125846.1281988-1-elder@linaro.org>
References: <20200630125846.1281988-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We check the state of an event ring or channel both before and after
any GSI command issued that will change that state.  In most--but
not all--cases, if the state is something different than expected we
report an error message.

Add error messages where missing, so that all unexpected states
provide information about what went wrong.  Drop the parentheses
around the state value shown in all cases.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: No change from v1.

 drivers/net/ipa/gsi.c | 54 ++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 55226b264e3c..7e4e54ee09b1 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -358,13 +358,15 @@ static int gsi_evt_ring_alloc_command(struct gsi *gsi, u32 evt_ring_id)
 
 	/* Get initial event ring state */
 	evt_ring->state = gsi_evt_ring_state(gsi, evt_ring_id);
-
-	if (evt_ring->state != GSI_EVT_RING_STATE_NOT_ALLOCATED)
+	if (evt_ring->state != GSI_EVT_RING_STATE_NOT_ALLOCATED) {
+		dev_err(gsi->dev, "bad event ring state %u before alloc\n",
+			evt_ring->state);
 		return -EINVAL;
+	}
 
 	ret = evt_ring_command(gsi, evt_ring_id, GSI_EVT_ALLOCATE);
 	if (!ret && evt_ring->state != GSI_EVT_RING_STATE_ALLOCATED) {
-		dev_err(gsi->dev, "bad event ring state (%u) after alloc\n",
+		dev_err(gsi->dev, "bad event ring state %u after alloc\n",
 			evt_ring->state);
 		ret = -EIO;
 	}
@@ -381,14 +383,14 @@ static void gsi_evt_ring_reset_command(struct gsi *gsi, u32 evt_ring_id)
 
 	if (state != GSI_EVT_RING_STATE_ALLOCATED &&
 	    state != GSI_EVT_RING_STATE_ERROR) {
-		dev_err(gsi->dev, "bad event ring state (%u) before reset\n",
+		dev_err(gsi->dev, "bad event ring state %u before reset\n",
 			evt_ring->state);
 		return;
 	}
 
 	ret = evt_ring_command(gsi, evt_ring_id, GSI_EVT_RESET);
 	if (!ret && evt_ring->state != GSI_EVT_RING_STATE_ALLOCATED)
-		dev_err(gsi->dev, "bad event ring state (%u) after reset\n",
+		dev_err(gsi->dev, "bad event ring state %u after reset\n",
 			evt_ring->state);
 }
 
@@ -399,14 +401,14 @@ static void gsi_evt_ring_de_alloc_command(struct gsi *gsi, u32 evt_ring_id)
 	int ret;
 
 	if (evt_ring->state != GSI_EVT_RING_STATE_ALLOCATED) {
-		dev_err(gsi->dev, "bad event ring state (%u) before dealloc\n",
+		dev_err(gsi->dev, "bad event ring state %u before dealloc\n",
 			evt_ring->state);
 		return;
 	}
 
 	ret = evt_ring_command(gsi, evt_ring_id, GSI_EVT_DE_ALLOC);
 	if (!ret && evt_ring->state != GSI_EVT_RING_STATE_NOT_ALLOCATED)
-		dev_err(gsi->dev, "bad event ring state (%u) after dealloc\n",
+		dev_err(gsi->dev, "bad event ring state %u after dealloc\n",
 			evt_ring->state);
 }
 
@@ -448,21 +450,23 @@ gsi_channel_command(struct gsi_channel *channel, enum gsi_ch_cmd_opcode opcode)
 static int gsi_channel_alloc_command(struct gsi *gsi, u32 channel_id)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
+	struct device *dev = gsi->dev;
 	enum gsi_channel_state state;
 	int ret;
 
 	/* Get initial channel state */
 	state = gsi_channel_state(channel);
-	if (state != GSI_CHANNEL_STATE_NOT_ALLOCATED)
+	if (state != GSI_CHANNEL_STATE_NOT_ALLOCATED) {
+		dev_err(dev, "bad channel state %u before alloc\n", state);
 		return -EINVAL;
+	}
 
 	ret = gsi_channel_command(channel, GSI_CH_ALLOCATE);
 
 	/* Channel state will normally have been updated */
 	state = gsi_channel_state(channel);
 	if (!ret && state != GSI_CHANNEL_STATE_ALLOCATED) {
-		dev_err(gsi->dev, "bad channel state (%u) after alloc\n",
-			state);
+		dev_err(dev, "bad channel state %u after alloc\n", state);
 		ret = -EIO;
 	}
 
@@ -472,21 +476,23 @@ static int gsi_channel_alloc_command(struct gsi *gsi, u32 channel_id)
 /* Start an ALLOCATED channel */
 static int gsi_channel_start_command(struct gsi_channel *channel)
 {
+	struct device *dev = channel->gsi->dev;
 	enum gsi_channel_state state;
 	int ret;
 
 	state = gsi_channel_state(channel);
 	if (state != GSI_CHANNEL_STATE_ALLOCATED &&
-	    state != GSI_CHANNEL_STATE_STOPPED)
+	    state != GSI_CHANNEL_STATE_STOPPED) {
+		dev_err(dev, "bad channel state %u before start\n", state);
 		return -EINVAL;
+	}
 
 	ret = gsi_channel_command(channel, GSI_CH_START);
 
 	/* Channel state will normally have been updated */
 	state = gsi_channel_state(channel);
 	if (!ret && state != GSI_CHANNEL_STATE_STARTED) {
-		dev_err(channel->gsi->dev,
-			"bad channel state (%u) after start\n", state);
+		dev_err(dev, "bad channel state %u after start\n", state);
 		ret = -EIO;
 	}
 
@@ -496,13 +502,16 @@ static int gsi_channel_start_command(struct gsi_channel *channel)
 /* Stop a GSI channel in STARTED state */
 static int gsi_channel_stop_command(struct gsi_channel *channel)
 {
+	struct device *dev = channel->gsi->dev;
 	enum gsi_channel_state state;
 	int ret;
 
 	state = gsi_channel_state(channel);
 	if (state != GSI_CHANNEL_STATE_STARTED &&
-	    state != GSI_CHANNEL_STATE_STOP_IN_PROC)
+	    state != GSI_CHANNEL_STATE_STOP_IN_PROC) {
+		dev_err(dev, "bad channel state %u before stop\n", state);
 		return -EINVAL;
+	}
 
 	ret = gsi_channel_command(channel, GSI_CH_STOP);
 
@@ -515,8 +524,7 @@ static int gsi_channel_stop_command(struct gsi_channel *channel)
 	if (state == GSI_CHANNEL_STATE_STOP_IN_PROC)
 		return -EAGAIN;
 
-	dev_err(channel->gsi->dev,
-		"bad channel state (%u) after stop\n", state);
+	dev_err(dev, "bad channel state %u after stop\n", state);
 
 	return -EIO;
 }
@@ -524,6 +532,7 @@ static int gsi_channel_stop_command(struct gsi_channel *channel)
 /* Reset a GSI channel in ALLOCATED or ERROR state. */
 static void gsi_channel_reset_command(struct gsi_channel *channel)
 {
+	struct device *dev = channel->gsi->dev;
 	enum gsi_channel_state state;
 	int ret;
 
@@ -532,8 +541,7 @@ static void gsi_channel_reset_command(struct gsi_channel *channel)
 	state = gsi_channel_state(channel);
 	if (state != GSI_CHANNEL_STATE_STOPPED &&
 	    state != GSI_CHANNEL_STATE_ERROR) {
-		dev_err(channel->gsi->dev,
-			"bad channel state (%u) before reset\n", state);
+		dev_err(dev, "bad channel state %u before reset\n", state);
 		return;
 	}
 
@@ -542,21 +550,20 @@ static void gsi_channel_reset_command(struct gsi_channel *channel)
 	/* Channel state will normally have been updated */
 	state = gsi_channel_state(channel);
 	if (!ret && state != GSI_CHANNEL_STATE_ALLOCATED)
-		dev_err(channel->gsi->dev,
-			"bad channel state (%u) after reset\n", state);
+		dev_err(dev, "bad channel state %u after reset\n", state);
 }
 
 /* Deallocate an ALLOCATED GSI channel */
 static void gsi_channel_de_alloc_command(struct gsi *gsi, u32 channel_id)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
+	struct device *dev = gsi->dev;
 	enum gsi_channel_state state;
 	int ret;
 
 	state = gsi_channel_state(channel);
 	if (state != GSI_CHANNEL_STATE_ALLOCATED) {
-		dev_err(gsi->dev,
-			"bad channel state (%u) before dealloc\n", state);
+		dev_err(dev, "bad channel state %u before dealloc\n", state);
 		return;
 	}
 
@@ -565,8 +572,7 @@ static void gsi_channel_de_alloc_command(struct gsi *gsi, u32 channel_id)
 	/* Channel state will normally have been updated */
 	state = gsi_channel_state(channel);
 	if (!ret && state != GSI_CHANNEL_STATE_NOT_ALLOCATED)
-		dev_err(gsi->dev,
-			"bad channel state (%u) after dealloc\n", state);
+		dev_err(dev, "bad channel state %u after dealloc\n", state);
 }
 
 /* Ring an event ring doorbell, reporting the last entry processed by the AP.
-- 
2.25.1

