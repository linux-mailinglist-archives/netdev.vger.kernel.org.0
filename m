Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944801C0A2E
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 00:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgD3WNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 18:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727872AbgD3WNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 18:13:33 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D89BC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 15:13:33 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id h124so7499050qke.11
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 15:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gN/TqDhg8bNL/QeGTI+szQXKqV9fUbqEbuIp2Eu9bQs=;
        b=efQJcaoasuYbZGC9B1Cx8MFELGozCD/WNm7f4tVvAxGMZbLr5cQowkmZoWV8bT33aa
         V+8vumksqodYEmlLzoPh9MvJBtSuJ19WPed3OYWZdoVaJtNF9ILpLbShTGjhiJurVbZS
         ZFtGEMFF4bs4XMlq6hG2XanW6HJICjTYTkljQ/qI7dWwgeg09VTX7aJYS9qiaudiM0x0
         +QUhsE1kg1TEdxICFtVFmprmr3gVjgjVvs9o0NHi3sKaUSsOpJSXDNhMGoHnALu3g33g
         N7i0wHbn0whEjzqsVPtWA837n0VOU6AJWgwwxtrRvycCbaJgQCz8YaEMOP3Vl8OQ+Pfk
         0Xxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gN/TqDhg8bNL/QeGTI+szQXKqV9fUbqEbuIp2Eu9bQs=;
        b=NMGTkdYHktAB9IW2NUWHGpXDYYMsjcJ2WulWiOL2pA3uQ4rWQmUMdrMqo+We0eogAt
         Ta0xsw5okU7jkLwfL3wRFDUAcvvF0aQzir4ZdR1NjcrvDgMZPN6EIxheUPsdQUnkGnsl
         5MuXYZHclhd3c/RgUsaxlr0qZSAJSuCd/hcXt+ZeT/7Zjybn25CIRLgtwFWRgbZah3O6
         xkoW8tQLuMG7Y+X3cPZwv0BxgQTl67w1IRoHHT7HcbBH43K+hd2Pn1Z/uP1HJRlnq+4j
         ge4wMXDsO9zpc7qgGJLu22mzlW9dDaQdQ9i1dnedkzmf5nitceRJ02tU1e0pXJLvr3Rq
         FlWw==
X-Gm-Message-State: AGi0PuZIwyUncMWa5hlsHWaMTVTN+q01/bqFXSynHD7DXBjatgw/Dj8B
        YezIkKtxX5PYKy/WWBaBD498nw==
X-Google-Smtp-Source: APiQypIMKneW4EY2z2hCYzqlrFH8vXgyuwASAjiN2i/Dm7XHyah3kzMKKNW8h1QpwFM9PnSlvOcM0g==
X-Received: by 2002:a37:bd81:: with SMTP id n123mr717459qkf.57.1588284812686;
        Thu, 30 Apr 2020 15:13:32 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w42sm957028qtj.63.2020.04.30.15.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 15:13:32 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org.net, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: ipa: do not cache channel state
Date:   Thu, 30 Apr 2020 17:13:23 -0500
Message-Id: <20200430221323.5449-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430221323.5449-1-elder@linaro.org>
References: <20200430221323.5449-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible for a GSI channel's state to be changed as a result
of an action by a different execution environment.  Specifically,
the modem is able to issue a GSI generic command that causes a state
change on a GSI channel associated with the AP.

A channel's state only needs to be known when a channel is allocated
or deallocaed, started or stopped, or reset.  So there is little
value in caching the state anyway.

Stop recording a copy of the channel's last known state, and instead
fetch the true state from hardware whenever it's needed.  In such
cases, *do* record the state in a local variable, in case an error
message reports it (so the value reported is the value seen).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 87 +++++++++++++++++++++++++++----------------
 drivers/net/ipa/gsi.h |  3 +-
 2 files changed, 55 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 6946c39b664a..8184d34124b7 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -415,7 +415,7 @@ static void gsi_evt_ring_de_alloc_command(struct gsi *gsi, u32 evt_ring_id)
 			evt_ring->state);
 }
 
-/* Return the hardware's notion of the current state of a channel */
+/* Fetch the current state of a channel from hardware */
 static enum gsi_channel_state gsi_channel_state(struct gsi_channel *channel)
 {
 	u32 channel_id = gsi_channel_id(channel);
@@ -433,16 +433,18 @@ gsi_channel_command(struct gsi_channel *channel, enum gsi_ch_cmd_opcode opcode)
 {
 	struct completion *completion = &channel->completion;
 	u32 channel_id = gsi_channel_id(channel);
+	struct gsi *gsi = channel->gsi;
 	u32 val;
 
 	val = u32_encode_bits(channel_id, CH_CHID_FMASK);
 	val |= u32_encode_bits(opcode, CH_OPCODE_FMASK);
 
-	if (gsi_command(channel->gsi, GSI_CH_CMD_OFFSET, val, completion))
+	if (gsi_command(gsi, GSI_CH_CMD_OFFSET, val, completion))
 		return 0;	/* Success! */
 
-	dev_err(channel->gsi->dev, "GSI command %u to channel %u timed out "
-		"(state is %u)\n", opcode, channel_id, channel->state);
+	dev_err(gsi->dev,
+		"GSI command %u to channel %u timed out (state is %u)\n",
+		opcode, channel_id, gsi_channel_state(channel));
 
 	return -ETIMEDOUT;
 }
@@ -451,18 +453,21 @@ gsi_channel_command(struct gsi_channel *channel, enum gsi_ch_cmd_opcode opcode)
 static int gsi_channel_alloc_command(struct gsi *gsi, u32 channel_id)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
+	enum gsi_channel_state state;
 	int ret;
 
 	/* Get initial channel state */
-	channel->state = gsi_channel_state(channel);
-
-	if (channel->state != GSI_CHANNEL_STATE_NOT_ALLOCATED)
+	state = gsi_channel_state(channel);
+	if (state != GSI_CHANNEL_STATE_NOT_ALLOCATED)
 		return -EINVAL;
 
 	ret = gsi_channel_command(channel, GSI_CH_ALLOCATE);
-	if (!ret && channel->state != GSI_CHANNEL_STATE_ALLOCATED) {
+
+	/* Channel state will normally have been updated */
+	state = gsi_channel_state(channel);
+	if (!ret && state != GSI_CHANNEL_STATE_ALLOCATED) {
 		dev_err(gsi->dev, "bad channel state (%u) after alloc\n",
-			channel->state);
+			state);
 		ret = -EIO;
 	}
 
@@ -472,18 +477,21 @@ static int gsi_channel_alloc_command(struct gsi *gsi, u32 channel_id)
 /* Start an ALLOCATED channel */
 static int gsi_channel_start_command(struct gsi_channel *channel)
 {
-	enum gsi_channel_state state = channel->state;
+	enum gsi_channel_state state;
 	int ret;
 
+	state = gsi_channel_state(channel);
 	if (state != GSI_CHANNEL_STATE_ALLOCATED &&
 	    state != GSI_CHANNEL_STATE_STOPPED)
 		return -EINVAL;
 
 	ret = gsi_channel_command(channel, GSI_CH_START);
-	if (!ret && channel->state != GSI_CHANNEL_STATE_STARTED) {
+
+	/* Channel state will normally have been updated */
+	state = gsi_channel_state(channel);
+	if (!ret && state != GSI_CHANNEL_STATE_STARTED) {
 		dev_err(channel->gsi->dev,
-			"bad channel state (%u) after start\n",
-			channel->state);
+			"bad channel state (%u) after start\n", state);
 		ret = -EIO;
 	}
 
@@ -493,23 +501,27 @@ static int gsi_channel_start_command(struct gsi_channel *channel)
 /* Stop a GSI channel in STARTED state */
 static int gsi_channel_stop_command(struct gsi_channel *channel)
 {
-	enum gsi_channel_state state = channel->state;
+	enum gsi_channel_state state;
 	int ret;
 
+	state = gsi_channel_state(channel);
 	if (state != GSI_CHANNEL_STATE_STARTED &&
 	    state != GSI_CHANNEL_STATE_STOP_IN_PROC)
 		return -EINVAL;
 
 	ret = gsi_channel_command(channel, GSI_CH_STOP);
-	if (ret || channel->state == GSI_CHANNEL_STATE_STOPPED)
+
+	/* Channel state will normally have been updated */
+	state = gsi_channel_state(channel);
+	if (ret || state == GSI_CHANNEL_STATE_STOPPED)
 		return ret;
 
 	/* We may have to try again if stop is in progress */
-	if (channel->state == GSI_CHANNEL_STATE_STOP_IN_PROC)
+	if (state == GSI_CHANNEL_STATE_STOP_IN_PROC)
 		return -EAGAIN;
 
-	dev_err(channel->gsi->dev, "bad channel state (%u) after stop\n",
-		channel->state);
+	dev_err(channel->gsi->dev,
+		"bad channel state (%u) after stop\n", state);
 
 	return -EIO;
 }
@@ -517,41 +529,49 @@ static int gsi_channel_stop_command(struct gsi_channel *channel)
 /* Reset a GSI channel in ALLOCATED or ERROR state. */
 static void gsi_channel_reset_command(struct gsi_channel *channel)
 {
+	enum gsi_channel_state state;
 	int ret;
 
 	msleep(1);	/* A short delay is required before a RESET command */
 
-	if (channel->state != GSI_CHANNEL_STATE_STOPPED &&
-	    channel->state != GSI_CHANNEL_STATE_ERROR) {
+	state = gsi_channel_state(channel);
+	if (state != GSI_CHANNEL_STATE_STOPPED &&
+	    state != GSI_CHANNEL_STATE_ERROR) {
 		dev_err(channel->gsi->dev,
-			"bad channel state (%u) before reset\n",
-			channel->state);
+			"bad channel state (%u) before reset\n", state);
 		return;
 	}
 
 	ret = gsi_channel_command(channel, GSI_CH_RESET);
-	if (!ret && channel->state != GSI_CHANNEL_STATE_ALLOCATED)
+
+	/* Channel state will normally have been updated */
+	state = gsi_channel_state(channel);
+	if (!ret && state != GSI_CHANNEL_STATE_ALLOCATED)
 		dev_err(channel->gsi->dev,
-			"bad channel state (%u) after reset\n",
-			channel->state);
+			"bad channel state (%u) after reset\n", state);
 }
 
 /* Deallocate an ALLOCATED GSI channel */
 static void gsi_channel_de_alloc_command(struct gsi *gsi, u32 channel_id)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
+	enum gsi_channel_state state;
 	int ret;
 
-	if (channel->state != GSI_CHANNEL_STATE_ALLOCATED) {
-		dev_err(gsi->dev, "bad channel state (%u) before dealloc\n",
-			channel->state);
+	state = gsi_channel_state(channel);
+	if (state != GSI_CHANNEL_STATE_ALLOCATED) {
+		dev_err(gsi->dev,
+			"bad channel state (%u) before dealloc\n", state);
 		return;
 	}
 
 	ret = gsi_channel_command(channel, GSI_CH_DE_ALLOC);
-	if (!ret && channel->state != GSI_CHANNEL_STATE_NOT_ALLOCATED)
-		dev_err(gsi->dev, "bad channel state (%u) after dealloc\n",
-			channel->state);
+
+	/* Channel state will normally have been updated */
+	state = gsi_channel_state(channel);
+	if (!ret && state != GSI_CHANNEL_STATE_NOT_ALLOCATED)
+		dev_err(gsi->dev,
+			"bad channel state (%u) after dealloc\n", state);
 }
 
 /* Ring an event ring doorbell, reporting the last entry processed by the AP.
@@ -778,6 +798,7 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
 int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
+	enum gsi_channel_state state;
 	u32 retries;
 	int ret;
 
@@ -787,7 +808,8 @@ int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
 	 * STOP command timed out.  We won't stop a channel if stopping it
 	 * was successful previously (so we still want the freeze above).
 	 */
-	if (channel->state == GSI_CHANNEL_STATE_STOPPED)
+	state = gsi_channel_state(channel);
+	if (state == GSI_CHANNEL_STATE_STOPPED)
 		return 0;
 
 	/* RX channels might require a little time to enter STOPPED state */
@@ -941,7 +963,6 @@ static void gsi_isr_chan_ctrl(struct gsi *gsi)
 		channel_mask ^= BIT(channel_id);
 
 		channel = &gsi->channel[channel_id];
-		channel->state = gsi_channel_state(channel);
 
 		complete(&channel->completion);
 	}
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 0698ff1ae7a6..19471017fadf 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -113,8 +113,7 @@ struct gsi_channel {
 	u16 tre_count;
 	u16 event_count;
 
-	struct completion completion;	/* signals channel state changes */
-	enum gsi_channel_state state;
+	struct completion completion;	/* signals channel command completion */
 
 	struct gsi_ring tre_ring;
 	u32 evt_ring_id;
-- 
2.20.1

