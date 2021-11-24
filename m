Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C7045CDF6
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbhKXU2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:28:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbhKXU2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 15:28:33 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAFEC061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:25:23 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id e144so4808056iof.3
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UpKBv5Hg3B/Al/7B7GMLhRk/WGXeQjxo7kM2CiDkP7w=;
        b=mQ07PSmcSlu687rnQXtx+JCScGMkeE8ni8caCVYHxZ0a7FrY7yi2olVe4OgNBzxGGM
         V/b2yOZXbgj5LDLQOym9nmFva4htHoS6g32+KlHcBA4gQnpfpwW3UNmGh8E+yyORxPnF
         vGKUdgGo2PdMrn0XeETcJvSa4H3FN403xTrMOdylCkxj9JYZ9syenS3+yWqfIn/7LdL9
         acTM0r5Q8Q+Xm2EQABT1de+Vf9E8YrVyHwA9DYzPps/kIThou24EuNkoeKC0wXB+L0Yu
         /hCM5OUEORNbcN5mL4/VJiTxL1lZnckfuf/q7/QQw9rGg82Xnfx/fzCRjwEKnkabSr9o
         fOhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UpKBv5Hg3B/Al/7B7GMLhRk/WGXeQjxo7kM2CiDkP7w=;
        b=XY9rcQDH8vRgpLKb/8eP9rGvc6RS1wrW/725r7l8kLr7v32kN29Tqdxw3aHO8qeMTp
         P6wrqjVdPXoNcgf9xsIPOt2xKEXd1ztIcPkNo664NtFnXxyJNwejLwGW8ipDCXzgbt/a
         JrhCckP9HAUFct8TZaQCk01ufacMBIqCYMs3GWphTY0f9IRD/ucRzB0M/dK98AHJTkss
         zHoVV05zRLdii1iMgb8ORY3hmui5JDsLg2zdSqNX7KYQm9OiFU306M3fe6KvKFR9+uib
         FK+GEM+pZM3DgizBokTDZeUzCuvUuuPoUEIEb2WjHoBVsx7S6WJp3ijebADhQkC0JY6T
         wqdg==
X-Gm-Message-State: AOAM532OU2QP0eJwZxV/mq8H/1U+P9xBhDnqbisIxstsL9PdaEi3/tEK
        iZC1GA7n/aHqcF53f/D7sHuKRw==
X-Google-Smtp-Source: ABdhPJz/WtlL3Vm2NRZQwhH6/z31JIZ417jxnVDAYaCYUtMdQu23rkD0Rd3Cd4BU7bSUfmcP+PxcyQ==
X-Received: by 2002:a5d:9ec2:: with SMTP id a2mr18823785ioe.44.1637785522979;
        Wed, 24 Nov 2021 12:25:22 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x2sm312795ile.29.2021.11.24.12.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 12:25:22 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     pkurapat@codeaurora.org, avuyyuru@codeaurora.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, evgreen@chromium.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/7] net: ipa: GSI only needs one completion
Date:   Wed, 24 Nov 2021 14:25:10 -0600
Message-Id: <20211124202511.862588-7-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124202511.862588-1-elder@linaro.org>
References: <20211124202511.862588-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A mutex ensures we never submit more than one GSI command of any
kind at once.  This means the per-channel and per-event ring
completion structures provide no benefit.  Instead, just use the
single (existing) GSI completion to signal the completion of GSI
commands of all types.

This makes gsi_evt_ring_init() a trivial function with no inverse,
so open-code it in its sole caller and get rid of the function.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 44 +++++++++++--------------------------------
 drivers/net/ipa/gsi.h |  5 +----
 2 files changed, 12 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index a2fcdb1abdb96..b611e39167fe0 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -339,10 +339,10 @@ static u32 gsi_ring_index(struct gsi_ring *ring, u32 offset)
  * completion to be signaled.  Returns true if the command completes
  * or false if it times out.
  */
-static bool
-gsi_command(struct gsi *gsi, u32 reg, u32 val, struct completion *completion)
+static bool gsi_command(struct gsi *gsi, u32 reg, u32 val)
 {
 	unsigned long timeout = msecs_to_jiffies(GSI_CMD_TIMEOUT);
+	struct completion *completion = &gsi->completion;
 
 	reinit_completion(completion);
 
@@ -366,8 +366,6 @@ gsi_evt_ring_state(struct gsi *gsi, u32 evt_ring_id)
 static void gsi_evt_ring_command(struct gsi *gsi, u32 evt_ring_id,
 				 enum gsi_evt_cmd_opcode opcode)
 {
-	struct gsi_evt_ring *evt_ring = &gsi->evt_ring[evt_ring_id];
-	struct completion *completion = &evt_ring->completion;
 	struct device *dev = gsi->dev;
 	bool timeout;
 	u32 val;
@@ -378,7 +376,7 @@ static void gsi_evt_ring_command(struct gsi *gsi, u32 evt_ring_id,
 	val = u32_encode_bits(evt_ring_id, EV_CHID_FMASK);
 	val |= u32_encode_bits(opcode, EV_OPCODE_FMASK);
 
-	timeout = !gsi_command(gsi, GSI_EV_CH_CMD_OFFSET, val, completion);
+	timeout = !gsi_command(gsi, GSI_EV_CH_CMD_OFFSET, val);
 
 	gsi_irq_ev_ctrl_disable(gsi);
 
@@ -478,7 +476,6 @@ static enum gsi_channel_state gsi_channel_state(struct gsi_channel *channel)
 static void
 gsi_channel_command(struct gsi_channel *channel, enum gsi_ch_cmd_opcode opcode)
 {
-	struct completion *completion = &channel->completion;
 	u32 channel_id = gsi_channel_id(channel);
 	struct gsi *gsi = channel->gsi;
 	struct device *dev = gsi->dev;
@@ -490,7 +487,7 @@ gsi_channel_command(struct gsi_channel *channel, enum gsi_ch_cmd_opcode opcode)
 
 	val = u32_encode_bits(channel_id, CH_CHID_FMASK);
 	val |= u32_encode_bits(opcode, CH_OPCODE_FMASK);
-	timeout = !gsi_command(gsi, GSI_CH_CMD_OFFSET, val, completion);
+	timeout = !gsi_command(gsi, GSI_CH_CMD_OFFSET, val);
 
 	gsi_irq_ch_ctrl_disable(gsi);
 
@@ -1074,13 +1071,10 @@ static void gsi_isr_chan_ctrl(struct gsi *gsi)
 
 	while (channel_mask) {
 		u32 channel_id = __ffs(channel_mask);
-		struct gsi_channel *channel;
 
 		channel_mask ^= BIT(channel_id);
 
-		channel = &gsi->channel[channel_id];
-
-		complete(&channel->completion);
+		complete(&gsi->completion);
 	}
 }
 
@@ -1094,13 +1088,10 @@ static void gsi_isr_evt_ctrl(struct gsi *gsi)
 
 	while (event_mask) {
 		u32 evt_ring_id = __ffs(event_mask);
-		struct gsi_evt_ring *evt_ring;
 
 		event_mask ^= BIT(evt_ring_id);
 
-		evt_ring = &gsi->evt_ring[evt_ring_id];
-
-		complete(&evt_ring->completion);
+		complete(&gsi->completion);
 	}
 }
 
@@ -1110,7 +1101,7 @@ gsi_isr_glob_chan_err(struct gsi *gsi, u32 err_ee, u32 channel_id, u32 code)
 {
 	if (code == GSI_OUT_OF_RESOURCES) {
 		dev_err(gsi->dev, "channel %u out of resources\n", channel_id);
-		complete(&gsi->channel[channel_id].completion);
+		complete(&gsi->completion);
 		return;
 	}
 
@@ -1127,7 +1118,7 @@ gsi_isr_glob_evt_err(struct gsi *gsi, u32 err_ee, u32 evt_ring_id, u32 code)
 		struct gsi_evt_ring *evt_ring = &gsi->evt_ring[evt_ring_id];
 		u32 channel_id = gsi_channel_id(evt_ring->channel);
 
-		complete(&evt_ring->completion);
+		complete(&gsi->completion);
 		dev_err(gsi->dev, "evt_ring for channel %u out of resources\n",
 			channel_id);
 		return;
@@ -1651,7 +1642,6 @@ static void gsi_channel_teardown_one(struct gsi *gsi, u32 channel_id)
 static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 			       enum gsi_generic_cmd_opcode opcode)
 {
-	struct completion *completion = &gsi->completion;
 	bool timeout;
 	u32 val;
 
@@ -1675,7 +1665,7 @@ static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 	val |= u32_encode_bits(channel_id, GENERIC_CHID_FMASK);
 	val |= u32_encode_bits(GSI_EE_MODEM, GENERIC_EE_FMASK);
 
-	timeout = !gsi_command(gsi, GSI_GENERIC_CMD_OFFSET, val, completion);
+	timeout = !gsi_command(gsi, GSI_GENERIC_CMD_OFFSET, val);
 
 	/* Disable the GP_INT1 IRQ type again */
 	iowrite32(BIT(ERROR_INT), gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
@@ -1975,18 +1965,6 @@ static void gsi_channel_evt_ring_exit(struct gsi_channel *channel)
 	gsi_evt_ring_id_free(gsi, evt_ring_id);
 }
 
-/* Init function for event rings; there is no gsi_evt_ring_exit() */
-static void gsi_evt_ring_init(struct gsi *gsi)
-{
-	u32 evt_ring_id = 0;
-
-	gsi->event_bitmap = gsi_event_bitmap_init(GSI_EVT_RING_COUNT_MAX);
-	gsi->ieob_enabled_bitmap = 0;
-	do
-		init_completion(&gsi->evt_ring[evt_ring_id].completion);
-	while (++evt_ring_id < GSI_EVT_RING_COUNT_MAX);
-}
-
 static bool gsi_channel_data_valid(struct gsi *gsi,
 				   const struct ipa_gsi_endpoint_data *data)
 {
@@ -2069,7 +2047,6 @@ static int gsi_channel_init_one(struct gsi *gsi,
 	channel->tlv_count = data->channel.tlv_count;
 	channel->tre_count = tre_count;
 	channel->event_count = data->channel.event_count;
-	init_completion(&channel->completion);
 
 	ret = gsi_channel_evt_ring_init(channel);
 	if (ret)
@@ -2129,7 +2106,8 @@ static int gsi_channel_init(struct gsi *gsi, u32 count,
 	/* IPA v4.2 requires the AP to allocate channels for the modem */
 	modem_alloc = gsi->version == IPA_VERSION_4_2;
 
-	gsi_evt_ring_init(gsi);			/* No matching exit required */
+	gsi->event_bitmap = gsi_event_bitmap_init(GSI_EVT_RING_COUNT_MAX);
+	gsi->ieob_enabled_bitmap = 0;
 
 	/* The endpoint data array is indexed by endpoint name */
 	for (i = 0; i < count; i++) {
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 88b80dc3db79f..ccaa333e37620 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -114,8 +114,6 @@ struct gsi_channel {
 	u16 tre_count;
 	u16 event_count;
 
-	struct completion completion;	/* signals channel command completion */
-
 	struct gsi_ring tre_ring;
 	u32 evt_ring_id;
 
@@ -141,7 +139,6 @@ enum gsi_evt_ring_state {
 
 struct gsi_evt_ring {
 	struct gsi_channel *channel;
-	struct completion completion;	/* signals event ring state changes */
 	struct gsi_ring ring;
 };
 
@@ -160,7 +157,7 @@ struct gsi {
 	u32 modem_channel_bitmap;	/* modem channels to allocate */
 	u32 type_enabled_bitmap;	/* GSI IRQ types enabled */
 	u32 ieob_enabled_bitmap;	/* IEOB IRQ enabled (event rings) */
-	struct completion completion;	/* for global EE commands */
+	struct completion completion;	/* Signals GSI command completion */
 	int result;			/* Negative errno (generic commands) */
 	struct mutex mutex;		/* protects commands, programming */
 };
-- 
2.32.0

