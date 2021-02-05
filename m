Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E38131183C
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhBFCbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhBFCa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:30:58 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BBBC061A2D
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:11:10 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id z18so7232294ile.9
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P1s7hU7D7Z1a7l+hh4Bwd4ik67fh8ngiWow+qBF4KnA=;
        b=qYlnn/0gDE4AziyGSnRNwSemRdlcmPQOUMcgwj00lGUzkE7soR0Dh0tlyjLMn7bOis
         7TomvR/IkRo4l0NZVl8Vsj7v3UUPIEND5VQeocLx59p8hgiEyv2QvuDrffQ/J+EWRXci
         JdnCeyD716YZkXXIpkSfur5rhAn5cQSO8xFhUzTmkNpFm2+8bm8enaj+bnTtV4fSbD35
         Zyxb+ohCKRbgs/tadu8A8zX1mGy7pZftHp5mwQq9Y/bHnnl1y8EMhwICETiANQT1VJWR
         pyu2R/LE7eh3oHpRL/DXx5FXsiuKCIvfogA4UpH7FHg18S4v6V5Lcbz2Q5KZf32HI6KL
         ub+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P1s7hU7D7Z1a7l+hh4Bwd4ik67fh8ngiWow+qBF4KnA=;
        b=dt2qwW36UFwIuKlNuD23PCvjtsRt7pi7GDJpMp2IE4Ne7tfNya87/4bbj6Ko3KZnzY
         AdiSArx1JNrYLIvkk6XjrPYmIYJdq/Uo/+TA+QR5fCRaF7Pc6mN5H89EEhmFW89RU2O3
         v5bz+tPKdke3Pof1zXF7TnPvRnb2PCjUUP8HgovN9/6+yunew0dZP1dbZ+GcYY7B3m6D
         TAQLZJaQIbUrr1KgRGE6M3k2odxpbMaQSEaXPebOt4KRt+aa83WP3sAg+TE2DoU766kv
         EeM8n5bWapEZAwxGMGdCXIFgIs+I9YppjWOBIu4LcxCsxE7K2BPgUT6MaX036hVi/tA4
         xXfA==
X-Gm-Message-State: AOAM530bh2XPLsNbR7EhQSoWCly1q4v06zgx8RGtYDMdkNiSM0VQHGcg
        YIFute2cqMQ37jLVuJ5LQE9xVQ==
X-Google-Smtp-Source: ABdhPJzJ7rd6ZBnBeaIDdc1fB5Agk5J6tTn4LVRSXqK4Cf1yF1IG/SyPf6llVQIIqUOuHi8pkWI5Cw==
X-Received: by 2002:a05:6e02:1d85:: with SMTP id h5mr6027520ila.246.1612563070459;
        Fri, 05 Feb 2021 14:11:10 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m15sm4647171ilh.6.2021.02.05.14.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:11:09 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/7] net: ipa: do not cache event ring state
Date:   Fri,  5 Feb 2021 16:10:56 -0600
Message-Id: <20210205221100.1738-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210205221100.1738-1-elder@linaro.org>
References: <20210205221100.1738-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An event ring's state only needs to be known when it is allocated,
reset, or deallocated.  We check an event ring's state both before
and after performing an event ring control command that changes
its state.  These are only issued at startup and shutdown, so there
is very little value in caching the state.

Stop recording a copy of the channel's last known state, and instead
fetch the true state from hardware whenever it's needed.  In such
cases, *do* record the state in a local variable, in case an error
message reports it (so the value reported is the value seen).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 39 +++++++++++++++++++++------------------
 drivers/net/ipa/gsi.h |  1 -
 2 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 60eb765c53647..511c94f66036c 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -408,30 +408,31 @@ static void gsi_evt_ring_command(struct gsi *gsi, u32 evt_ring_id,
 		return;
 
 	dev_err(dev, "GSI command %u for event ring %u timed out, state %u\n",
-		opcode, evt_ring_id, evt_ring->state);
+		opcode, evt_ring_id, gsi_evt_ring_state(gsi, evt_ring_id));
 }
 
 /* Allocate an event ring in NOT_ALLOCATED state */
 static int gsi_evt_ring_alloc_command(struct gsi *gsi, u32 evt_ring_id)
 {
-	struct gsi_evt_ring *evt_ring = &gsi->evt_ring[evt_ring_id];
+	enum gsi_evt_ring_state state;
 
 	/* Get initial event ring state */
-	evt_ring->state = gsi_evt_ring_state(gsi, evt_ring_id);
-	if (evt_ring->state != GSI_EVT_RING_STATE_NOT_ALLOCATED) {
+	state = gsi_evt_ring_state(gsi, evt_ring_id);
+	if (state != GSI_EVT_RING_STATE_NOT_ALLOCATED) {
 		dev_err(gsi->dev, "event ring %u bad state %u before alloc\n",
-			evt_ring_id, evt_ring->state);
+			evt_ring_id, state);
 		return -EINVAL;
 	}
 
 	gsi_evt_ring_command(gsi, evt_ring_id, GSI_EVT_ALLOCATE);
 
 	/* If successful the event ring state will have changed */
-	if (evt_ring->state == GSI_EVT_RING_STATE_ALLOCATED)
+	state = gsi_evt_ring_state(gsi, evt_ring_id);
+	if (state == GSI_EVT_RING_STATE_ALLOCATED)
 		return 0;
 
 	dev_err(gsi->dev, "event ring %u bad state %u after alloc\n",
-		evt_ring_id, evt_ring->state);
+		evt_ring_id, state);
 
 	return -EIO;
 }
@@ -439,45 +440,48 @@ static int gsi_evt_ring_alloc_command(struct gsi *gsi, u32 evt_ring_id)
 /* Reset a GSI event ring in ALLOCATED or ERROR state. */
 static void gsi_evt_ring_reset_command(struct gsi *gsi, u32 evt_ring_id)
 {
-	struct gsi_evt_ring *evt_ring = &gsi->evt_ring[evt_ring_id];
-	enum gsi_evt_ring_state state = evt_ring->state;
+	enum gsi_evt_ring_state state;
 
+	state = gsi_evt_ring_state(gsi, evt_ring_id);
 	if (state != GSI_EVT_RING_STATE_ALLOCATED &&
 	    state != GSI_EVT_RING_STATE_ERROR) {
 		dev_err(gsi->dev, "event ring %u bad state %u before reset\n",
-			evt_ring_id, evt_ring->state);
+			evt_ring_id, state);
 		return;
 	}
 
 	gsi_evt_ring_command(gsi, evt_ring_id, GSI_EVT_RESET);
 
 	/* If successful the event ring state will have changed */
-	if (evt_ring->state == GSI_EVT_RING_STATE_ALLOCATED)
+	state = gsi_evt_ring_state(gsi, evt_ring_id);
+	if (state == GSI_EVT_RING_STATE_ALLOCATED)
 		return;
 
 	dev_err(gsi->dev, "event ring %u bad state %u after reset\n",
-		evt_ring_id, evt_ring->state);
+		evt_ring_id, state);
 }
 
 /* Issue a hardware de-allocation request for an allocated event ring */
 static void gsi_evt_ring_de_alloc_command(struct gsi *gsi, u32 evt_ring_id)
 {
-	struct gsi_evt_ring *evt_ring = &gsi->evt_ring[evt_ring_id];
+	enum gsi_evt_ring_state state;
 
-	if (evt_ring->state != GSI_EVT_RING_STATE_ALLOCATED) {
+	state = gsi_evt_ring_state(gsi, evt_ring_id);
+	if (state != GSI_EVT_RING_STATE_ALLOCATED) {
 		dev_err(gsi->dev, "event ring %u state %u before dealloc\n",
-			evt_ring_id, evt_ring->state);
+			evt_ring_id, state);
 		return;
 	}
 
 	gsi_evt_ring_command(gsi, evt_ring_id, GSI_EVT_DE_ALLOC);
 
 	/* If successful the event ring state will have changed */
-	if (evt_ring->state == GSI_EVT_RING_STATE_NOT_ALLOCATED)
+	state = gsi_evt_ring_state(gsi, evt_ring_id);
+	if (state == GSI_EVT_RING_STATE_NOT_ALLOCATED)
 		return;
 
 	dev_err(gsi->dev, "event ring %u bad state %u after dealloc\n",
-		evt_ring_id, evt_ring->state);
+		evt_ring_id, state);
 }
 
 /* Fetch the current state of a channel from hardware */
@@ -1107,7 +1111,6 @@ static void gsi_isr_evt_ctrl(struct gsi *gsi)
 		event_mask ^= BIT(evt_ring_id);
 
 		evt_ring = &gsi->evt_ring[evt_ring_id];
-		evt_ring->state = gsi_evt_ring_state(gsi, evt_ring_id);
 
 		complete(&evt_ring->completion);
 	}
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 96c9aed397aad..d674db0ba4eb0 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -142,7 +142,6 @@ enum gsi_evt_ring_state {
 struct gsi_evt_ring {
 	struct gsi_channel *channel;
 	struct completion completion;	/* signals event ring state changes */
-	enum gsi_evt_ring_state state;
 	struct gsi_ring ring;
 };
 
-- 
2.20.1

