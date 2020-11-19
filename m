Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4710E2B9DCD
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgKSWtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgKSWtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:49:35 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF97C0617A7
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:49:35 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id n5so6879779ile.7
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lFOtB82zYfMy+DN+DQMCF6Al1O4+yIhvAGFtoT3kXTg=;
        b=m1/Irs8wOJcf29zRtD0c2Rh9tzyrp+HeezwFdRA5/TFNxZzvSy+x7NTQKelgdKBrt5
         9QQPBd8y0hbETgzOl/Qj2N89HA8RSSwVYDCCJUZud1QtUW67OOYGjVJgnNtxvIIXR9Hf
         VgrWv6xxea+ncWgdBWEFJrjEU9pkK73WJmD55vdl1CwIYhttbBPQvQWFLfWUHMm1gcl2
         UwsrhWlFtx9vPd/uPxG+9uvTsY42XPgVUhuvHZ102NxpLk1HJOQZR5kUnrGrjYiYP0q2
         geru9+5B0HBWRPVEkSK/szDfPVFP+uMrMsuLXWWsirhI9YHmhcyhHVwEtqvtuB48mwDl
         BbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lFOtB82zYfMy+DN+DQMCF6Al1O4+yIhvAGFtoT3kXTg=;
        b=BYtJZR7FfWmlM2CZjyzzyp2tbUo2r5aVOJNMwvyo+qrg32iKyHU6QJHKW5bBOeoSl3
         6XZKOccfKB0tLDU3GU28FcNCwNHMDSlUAuhFQaqaVLmT8Fn9BzYTWJe79Cwkn2R+qPts
         oQXNWzWf0CYmh5xqFeGfwyEbmdl+3opVBrftZ2ZixAqxK4cx4Fc1g+TE+3niG/R5WBjQ
         AZqcE82LFz77v6Pd6HvTna1VQ7cw4ypIpDjv8wkdWUNvsf+PYyvt5V9fkOI1J5dLHioz
         DZnI4NgpHIdCwlM7CYa5iOxTvylCNfpVERmH+2Ybhlgm0RtcVY5+SdjS9e6gaeyG10wq
         goEQ==
X-Gm-Message-State: AOAM533/yyYiHXduY+e7RXZbp+R1FBk7OQL9X3DptsWMBUIvbiPqvuZh
        Yue1LsxgcfiuviQ/1J3h87Beag==
X-Google-Smtp-Source: ABdhPJw+NA+fe+LOwp76vay8WAHjL0XbI+J1OEiV1iotcljozXMWLBDqKrXxzx5FfjtnG+Qdc9QQdA==
X-Received: by 2002:a05:6e02:1348:: with SMTP id k8mr21483828ilr.154.1605826174684;
        Thu, 19 Nov 2020 14:49:34 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id i3sm446532iom.8.2020.11.19.14.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 14:49:34 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/6] net: ipa: print channel/event ring number on error
Date:   Thu, 19 Nov 2020 16:49:24 -0600
Message-Id: <20201119224929.23819-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201119224929.23819-1-elder@linaro.org>
References: <20201119224929.23819-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a GSI command is used to change the state of a channel or event
ring we check the state before and after the command to ensure it is
as expected.  If not, we print an error message, but it does not
include the channel or event ring id, and it easily can.  Add the
channel or event ring id to these error messages.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 54 +++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 55151960a6985..2bc513c663396 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -365,15 +365,15 @@ static int gsi_evt_ring_alloc_command(struct gsi *gsi, u32 evt_ring_id)
 	/* Get initial event ring state */
 	evt_ring->state = gsi_evt_ring_state(gsi, evt_ring_id);
 	if (evt_ring->state != GSI_EVT_RING_STATE_NOT_ALLOCATED) {
-		dev_err(gsi->dev, "bad event ring state %u before alloc\n",
-			evt_ring->state);
+		dev_err(gsi->dev, "event ring %u bad state %u before alloc\n",
+			evt_ring_id, evt_ring->state);
 		return -EINVAL;
 	}
 
 	ret = evt_ring_command(gsi, evt_ring_id, GSI_EVT_ALLOCATE);
 	if (!ret && evt_ring->state != GSI_EVT_RING_STATE_ALLOCATED) {
-		dev_err(gsi->dev, "bad event ring state %u after alloc\n",
-			evt_ring->state);
+		dev_err(gsi->dev, "event ring %u bad state %u after alloc\n",
+			evt_ring_id, evt_ring->state);
 		ret = -EIO;
 	}
 
@@ -389,15 +389,15 @@ static void gsi_evt_ring_reset_command(struct gsi *gsi, u32 evt_ring_id)
 
 	if (state != GSI_EVT_RING_STATE_ALLOCATED &&
 	    state != GSI_EVT_RING_STATE_ERROR) {
-		dev_err(gsi->dev, "bad event ring state %u before reset\n",
-			evt_ring->state);
+		dev_err(gsi->dev, "event ring %u bad state %u before reset\n",
+			evt_ring_id, evt_ring->state);
 		return;
 	}
 
 	ret = evt_ring_command(gsi, evt_ring_id, GSI_EVT_RESET);
 	if (!ret && evt_ring->state != GSI_EVT_RING_STATE_ALLOCATED)
-		dev_err(gsi->dev, "bad event ring state %u after reset\n",
-			evt_ring->state);
+		dev_err(gsi->dev, "event ring %u bad state %u after reset\n",
+			evt_ring_id, evt_ring->state);
 }
 
 /* Issue a hardware de-allocation request for an allocated event ring */
@@ -407,15 +407,15 @@ static void gsi_evt_ring_de_alloc_command(struct gsi *gsi, u32 evt_ring_id)
 	int ret;
 
 	if (evt_ring->state != GSI_EVT_RING_STATE_ALLOCATED) {
-		dev_err(gsi->dev, "bad event ring state %u before dealloc\n",
-			evt_ring->state);
+		dev_err(gsi->dev, "event ring %u state %u before dealloc\n",
+			evt_ring_id, evt_ring->state);
 		return;
 	}
 
 	ret = evt_ring_command(gsi, evt_ring_id, GSI_EVT_DE_ALLOC);
 	if (!ret && evt_ring->state != GSI_EVT_RING_STATE_NOT_ALLOCATED)
-		dev_err(gsi->dev, "bad event ring state %u after dealloc\n",
-			evt_ring->state);
+		dev_err(gsi->dev, "event ring %u bad state %u after dealloc\n",
+			evt_ring_id, evt_ring->state);
 }
 
 /* Fetch the current state of a channel from hardware */
@@ -479,7 +479,8 @@ static int gsi_channel_alloc_command(struct gsi *gsi, u32 channel_id)
 	/* Get initial channel state */
 	state = gsi_channel_state(channel);
 	if (state != GSI_CHANNEL_STATE_NOT_ALLOCATED) {
-		dev_err(dev, "bad channel state %u before alloc\n", state);
+		dev_err(dev, "channel %u bad state %u before alloc\n",
+			channel_id, state);
 		return -EINVAL;
 	}
 
@@ -488,7 +489,8 @@ static int gsi_channel_alloc_command(struct gsi *gsi, u32 channel_id)
 	/* Channel state will normally have been updated */
 	state = gsi_channel_state(channel);
 	if (!ret && state != GSI_CHANNEL_STATE_ALLOCATED) {
-		dev_err(dev, "bad channel state %u after alloc\n", state);
+		dev_err(dev, "channel %u bad state %u after alloc\n",
+			channel_id, state);
 		ret = -EIO;
 	}
 
@@ -505,7 +507,8 @@ static int gsi_channel_start_command(struct gsi_channel *channel)
 	state = gsi_channel_state(channel);
 	if (state != GSI_CHANNEL_STATE_ALLOCATED &&
 	    state != GSI_CHANNEL_STATE_STOPPED) {
-		dev_err(dev, "bad channel state %u before start\n", state);
+		dev_err(dev, "channel %u bad state %u before start\n",
+			gsi_channel_id(channel), state);
 		return -EINVAL;
 	}
 
@@ -514,7 +517,8 @@ static int gsi_channel_start_command(struct gsi_channel *channel)
 	/* Channel state will normally have been updated */
 	state = gsi_channel_state(channel);
 	if (!ret && state != GSI_CHANNEL_STATE_STARTED) {
-		dev_err(dev, "bad channel state %u after start\n", state);
+		dev_err(dev, "channel %u bad state %u after start\n",
+			gsi_channel_id(channel), state);
 		ret = -EIO;
 	}
 
@@ -538,7 +542,8 @@ static int gsi_channel_stop_command(struct gsi_channel *channel)
 
 	if (state != GSI_CHANNEL_STATE_STARTED &&
 	    state != GSI_CHANNEL_STATE_STOP_IN_PROC) {
-		dev_err(dev, "bad channel state %u before stop\n", state);
+		dev_err(dev, "channel %u bad state %u before stop\n",
+			gsi_channel_id(channel), state);
 		return -EINVAL;
 	}
 
@@ -553,7 +558,8 @@ static int gsi_channel_stop_command(struct gsi_channel *channel)
 	if (state == GSI_CHANNEL_STATE_STOP_IN_PROC)
 		return -EAGAIN;
 
-	dev_err(dev, "bad channel state %u after stop\n", state);
+	dev_err(dev, "channel %u bad state %u after stop\n",
+		gsi_channel_id(channel), state);
 
 	return -EIO;
 }
@@ -570,7 +576,8 @@ static void gsi_channel_reset_command(struct gsi_channel *channel)
 	state = gsi_channel_state(channel);
 	if (state != GSI_CHANNEL_STATE_STOPPED &&
 	    state != GSI_CHANNEL_STATE_ERROR) {
-		dev_err(dev, "bad channel state %u before reset\n", state);
+		dev_err(dev, "channel %u bad state %u before reset\n",
+			gsi_channel_id(channel), state);
 		return;
 	}
 
@@ -579,7 +586,8 @@ static void gsi_channel_reset_command(struct gsi_channel *channel)
 	/* Channel state will normally have been updated */
 	state = gsi_channel_state(channel);
 	if (!ret && state != GSI_CHANNEL_STATE_ALLOCATED)
-		dev_err(dev, "bad channel state %u after reset\n", state);
+		dev_err(dev, "channel %u bad state %u after reset\n",
+			gsi_channel_id(channel), state);
 }
 
 /* Deallocate an ALLOCATED GSI channel */
@@ -592,7 +600,8 @@ static void gsi_channel_de_alloc_command(struct gsi *gsi, u32 channel_id)
 
 	state = gsi_channel_state(channel);
 	if (state != GSI_CHANNEL_STATE_ALLOCATED) {
-		dev_err(dev, "bad channel state %u before dealloc\n", state);
+		dev_err(dev, "channel %u bad state %u before dealloc\n",
+			channel_id, state);
 		return;
 	}
 
@@ -601,7 +610,8 @@ static void gsi_channel_de_alloc_command(struct gsi *gsi, u32 channel_id)
 	/* Channel state will normally have been updated */
 	state = gsi_channel_state(channel);
 	if (!ret && state != GSI_CHANNEL_STATE_NOT_ALLOCATED)
-		dev_err(dev, "bad channel state %u after dealloc\n", state);
+		dev_err(dev, "channel %u bad state %u after dealloc\n",
+			channel_id, state);
 }
 
 /* Ring an event ring doorbell, reporting the last entry processed by the AP.
-- 
2.20.1

