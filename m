Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9572930DE27
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 16:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbhBCPaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 10:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbhBCP3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 10:29:44 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C1FC061793
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 07:29:03 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id f6so5467245ioz.5
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 07:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CDjXjfXQF95s6RsUrh4TUR9OI+8JXa+z9p3uoFQLMv0=;
        b=qzNGvd2HmSEdDOGUyQIb9sVwJzsL6ntkp8azJ+8XbITQISkCCFacv1Y4YaAloIxOh0
         j5SGNy1FnNdE9qFNVmi9MNvSDMYUB46I72pUtmvaYcbDf2BonYv1OsYxkZW21jc54oCT
         JunszIMHQ5Yg+FVQBLAhgodEJT0Ik3UXneDEtRreG5FMPCyzEAyn6TELgsK5OF/3AdU9
         eTI6w/oVZ3EIqvOsgsmH6cBH6LV7EwtAodLcquo8RzMExCkhUzgawDAa+SKgjXrGwmQB
         Pw22oJXYf/pH19TnZJrk6uxhNH86VN742h28xSbWhdHmLYwHDTHYA3Y+prwzw4Ohqz+h
         Yu6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CDjXjfXQF95s6RsUrh4TUR9OI+8JXa+z9p3uoFQLMv0=;
        b=GO0Lm6y/DPapBRFqW1pnlpy71rRLFKCUP5j5f8aFwWoju+RUJ6H5zCeIChBGoq4h46
         F7p+h6e1vYlJGArasj6Ryb4i6JqpndqThjZfthD/AiMBActUJBi/FiUDZfqoaSNX16IB
         0XXYNuibUurw0SefujvUSsEFdhUd9z69TqwLD8PDXBg2Q0NuqWyKwQvpA1o1J88b1Lov
         tz/RSCc1KWgOsDGjcYrBLcaG4ydB/6C1dpJ/gvnfGKAscBhNTCdNz5K27ChQZ+51lNZ+
         eeeOvKAittLrAcx2w+69aXkpRKm/GLBvrZU4E0zbk2UjuWJWdSF+smRduPBu8Xmp7Abm
         Cgkw==
X-Gm-Message-State: AOAM533C8hfIe6Q17s0gTJQe6UWJCY7ysPfhf7IC2np37GD92Yjo00/i
        VJMc4DKxDbecF5KI8yWHRIaupw==
X-Google-Smtp-Source: ABdhPJwUeKEXtLYYmUm7H0sALRlarRdBgJR1KcOSNbbF4d+WbaRHUmSTQxkYcxWHpjaOtzoWM9h4AA==
X-Received: by 2002:a02:b703:: with SMTP id g3mr3456175jam.15.1612366143286;
        Wed, 03 Feb 2021 07:29:03 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a15sm1119774ilb.11.2021.02.03.07.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 07:29:02 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/7] net: ipa: do not cache event ring state
Date:   Wed,  3 Feb 2021 09:28:51 -0600
Message-Id: <20210203152855.11866-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210203152855.11866-1-elder@linaro.org>
References: <20210203152855.11866-1-elder@linaro.org>
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
index 420d0f3bfae9a..0f44e374c0a7e 100644
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
@@ -1104,7 +1108,6 @@ static void gsi_isr_evt_ctrl(struct gsi *gsi)
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

