Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF33C319510
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhBKVVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 16:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbhBKVUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 16:20:55 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D1EC0617A7
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 13:19:37 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id d20so1675423ilo.4
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 13:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ljog9ADMI3z+A1fikGBkRhxkobB8HTkMuLZ8xQG2g7c=;
        b=NpUGZf1mopmj5Tpd0dM/H7KVszQxZomppQGOYlEOSW+OxA4JhucbdINRb5oHSQKOyO
         BOknfmz7+CBV8wdqavwRdGTwA8lv1dAroKJHFfAOBq11yIjou6UaOq6LXWIyWOF5r5BN
         fZfHA/NPdHTS4V4eJ7SUnCq/7AddRliM7B38TaNLOPyamKz0zILcUWvkWfo2ali70tq8
         0gubbvzMa8RhyzwhNHvTYfK7PzI9RJyxWBhTw8hGUPPfMZcnG2GNIOnpOZgS9oCOomPM
         ocrn6oHWvLesVVJvzkEQ44nWRxpv+0Eir0WfokcekXcgXYCc0MKIlgWUYf/xV8VSfDIH
         yAOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ljog9ADMI3z+A1fikGBkRhxkobB8HTkMuLZ8xQG2g7c=;
        b=O9pce4dFobTz5sBxPaSW0tVtrx3OhXzVXXo12wDqWMspjee0IJCPC/um1y++VmOxuD
         +u+KYJLe5V04pUB83pYjkXSpTwCD0CjVI3CEOZpHPhNbxeane4Gk9XoVoMG6MXph+WW1
         2ZBTo1XYx1uHHyhL0+t2+Rb5hZPeIYM46hYDoo7lShkra9wWfIZh+gLrEg5cKvSvNXBI
         nrlvRgLnPv0BAhXKfKW1ufAxh9nIDjW3BnAvoxu2L3jjntNgvc8iHHi7Ge06oXoytTA7
         zw35QU1MFQ2nUwPOsYhjOPrhTn5NEsHl+iKaOdwSx6NaHt7k33kkSI2fYZ/y4PYEdwyG
         Lkqw==
X-Gm-Message-State: AOAM532QkuG6o5aqrGUhAdsR+EhtHXb62DGOrTkoc1m6Bg3fFRejO1JR
        XRgrd7oQ5ssJwIkoGeG8mRFfjA==
X-Google-Smtp-Source: ABdhPJxv+3D4mwl5rJ4V+M8HKYSWLEVABuHdF4rbjkJGzSmwIp67wEzGbhI/5pW4XtB/T5V73jIC8A==
X-Received: by 2002:a92:cc03:: with SMTP id s3mr48852ilp.45.1613078376523;
        Thu, 11 Feb 2021 13:19:36 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j10sm3155718ilc.50.2021.02.11.13.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 13:19:36 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 5/5] net: ipa: introduce gsi_channel_initialized()
Date:   Thu, 11 Feb 2021 15:19:27 -0600
Message-Id: <20210211211927.28061-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210211211927.28061-1-elder@linaro.org>
References: <20210211211927.28061-1-elder@linaro.org>
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
index 9c977f80109a9..390d3403386aa 100644
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
 
 		ret = -EINVAL;
 		dev_err(gsi->dev, "channel %u not supported by hardware\n",
@@ -2089,8 +2095,8 @@ static int gsi_channel_init_one(struct gsi *gsi,
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

