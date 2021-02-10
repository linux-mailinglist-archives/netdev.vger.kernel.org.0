Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848D7317377
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 23:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbhBJWgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 17:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbhBJWfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 17:35:51 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDB7C0617AA
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 14:33:29 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id z21so2330281iob.7
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 14:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7FCuQIhoM4UnSeDf+V9T1zVw5r1nx3mRIbuQj9L1BYA=;
        b=Rd/yJmUWl/CbjQMXYAj81h5dkBwFZoIiFyzebIXqmV6DFK9Qtj9EkWHVY3rV1A/GT+
         jHv17UrnbOkI3wbe4ApcNKXs4L6No+EBJ2tsgAlQyV0Sjs9+OEo3aI2DT+AgD6duxV1H
         LtIwyRHbsl8CtEfljXn4SqVpgMWXIqksSyR4UEILQWBvKwZ+bOU/Xoj/w1w4g4px9nyU
         Tsh5RNdBhuIwN0AmjIgHkNLCyvZ4GcHuOljB2CAtkq8pvR4oIl9qVwVwooCLQoqT50aY
         BIhbNnmr6rVSvaDcLmfhFW9vIZImUVfEkjRsC2seur/r9ExLYkngZdpeYVGnp65WPNuZ
         EeNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7FCuQIhoM4UnSeDf+V9T1zVw5r1nx3mRIbuQj9L1BYA=;
        b=QXQrTSYfpCpVbFauCZqbtein1CYW7VnMCXwz8wrwGfvncJmvKRGcyTCIrYKt8SEBUI
         sy3LPbVujVtvcec+EUGZnPWofNTgfNpvG+sahu2CIwMoipRIS4MrU9c16UU0O14H0p1k
         ABsP5Hm3FA7SdzQR3a6Y/F1qShoyFCWFRwPxbmxileTrOALp1jqRtRjvtpnkieM7DoCg
         wA0Zb4JB2AjpfJfG1I9HGtgvGsFPlNv5ng3wSD98TAa4LI0LgVa/uE1XazM7iINunFXe
         HYAb4juVOrmvmjXZKAJ6NgGLZ5uBAJOqMbpw+PesP4Hsbe6dYA7NMGr+IeoG/59lvFNV
         Zsjg==
X-Gm-Message-State: AOAM533hmjn1BZEyItQEh74ZutgBY5K2CNcJSK8fViorw2T5WIpJGYsV
        QWM2aaGRsth4s8WxbaovRx/NyQ==
X-Google-Smtp-Source: ABdhPJzEwRYBYmx50KyPLxbXpPzMLdZUtiR4RWBfkd/2A9g86F+haXl3TmymKpxL7zb9SU127tPSJA==
X-Received: by 2002:a5e:9612:: with SMTP id a18mr2732161ioq.209.1612996408710;
        Wed, 10 Feb 2021 14:33:28 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id e23sm1484525ioc.34.2021.02.10.14.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 14:33:28 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/5] net: ipa: introduce gsi_channel_initialized()
Date:   Wed, 10 Feb 2021 16:33:20 -0600
Message-Id: <20210210223320.11269-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210210223320.11269-1-elder@linaro.org>
References: <20210210223320.11269-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a simple helper function that indicates whether a channel has
been initialized.  This abstacts/hides the details of how this is
determined.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index d33686da15420..2406363bba2e8 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -175,6 +175,12 @@ static u32 gsi_channel_id(struct gsi_channel *channel)
 	return channel - &channel->gsi->channel[0];
 }
 
+/* An initialized channel has a non-null GSI pointer */
+static bool gsi_channel_initialized(struct gsi_channel *channel)
+{
+	return !!channel->gsi;
+}
+
 /* Update the GSI IRQ type register with the cached value */
 static void gsi_irq_type_update(struct gsi *gsi, u32 val)
 {
@@ -1638,8 +1644,8 @@ static int gsi_channel_setup_one(struct gsi *gsi, u32 channel_id)
 	u32 evt_ring_id = channel->evt_ring_id;
 	int ret;
 
-	if (!channel->gsi)
-		return 0;	/* Ignore uninitialized channels */
+	if (!gsi_channel_initialized(channel))
+		return 0;
 
 	ret = gsi_evt_ring_alloc_command(gsi, evt_ring_id);
 	if (ret)
@@ -1675,8 +1681,8 @@ static void gsi_channel_teardown_one(struct gsi *gsi, u32 channel_id)
 	struct gsi_channel *channel = &gsi->channel[channel_id];
 	u32 evt_ring_id = channel->evt_ring_id;
 
-	if (!channel->gsi)
-		return;		/* Ignore uninitialized channels */
+	if (!gsi_channel_initialized(channel))
+		return;
 
 	netif_napi_del(&channel->napi);
 
@@ -1770,8 +1776,8 @@ static int gsi_channel_setup(struct gsi *gsi)
 	while (channel_id < GSI_CHANNEL_COUNT_MAX) {
 		struct gsi_channel *channel = &gsi->channel[channel_id++];
 
-		if (!channel->gsi)
-			continue;	/* Ignore uninitialized channels */
+		if (!gsi_channel_initialized(channel))
+			continue;
 
 		dev_err(gsi->dev, "channel %u not supported by hardware\n",
 			channel_id - 1);
@@ -2088,8 +2094,8 @@ static int gsi_channel_init_one(struct gsi *gsi,
 /* Inverse of gsi_channel_init_one() */
 static void gsi_channel_exit_one(struct gsi_channel *channel)
 {
-	if (!channel->gsi)
-		return;		/* Ignore uninitialized channels */
+	if (!gsi_channel_initialized(channel))
+		return;
 
 	if (channel->command)
 		ipa_cmd_pool_exit(channel);
-- 
2.20.1

