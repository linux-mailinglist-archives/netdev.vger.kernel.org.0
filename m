Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690D52E0E17
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 19:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgLVSBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 13:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgLVSBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 13:01:37 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20CAC061282
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 10:00:18 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id z136so12766267iof.3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 10:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G2kmR2+L0O4KXPUATZH9veHazZttzCa4gZrsM0KnvR4=;
        b=wxBOAFSN0JQMJ2SzeI7Lx6EQE5eKxCxga6x3DlLraAiT3QY9i1/d2+s7bZIF2ruJbp
         3TIaqA2jxrv06wKqQsWxhVI9ipuzFHtpQa9dd5E0KUUTlfgrtJhZit/KbRU6y+aM5YOh
         V0z0dzIOfz0zWhCn0HvTFxB7o8OAfoYa8tn8AZ+GYHPMQ/91E4uRplklZXM3jgh6yfSN
         gJjwLjro47H9I+KOZv9T48UEQT7iuO7sbGga3mia7SN4/Bbinr/O46i4rQS8hlfhKh7j
         ROIfaC9vf/y7miszMhbQoY7NSx9AjKUT5ov1Xb669q/CDZvWzI197cY1dLWa8pO3ZBab
         WDlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G2kmR2+L0O4KXPUATZH9veHazZttzCa4gZrsM0KnvR4=;
        b=M2dS6l6QRU2OXRgc1vRawmWS6kFHE5mMVrO+d3XrzI/ujTGnZ3VoV5gV4K2TruJV4B
         F715DPxlq7TJ/gv/yM9rckcSCfQqzbE/5FmsEcEcch52a5es9IccurTPInYvC8ewhgQ3
         asYrABOBFVrDcaRnio8u8feW6vBYTpqcpix33NYvXD2jX/9fDIRN1LIFDBFri7gVzdEF
         AypkfTFOE5glA1Tu8gEybWb2TPUuiCtl6zwJEMexiAVJK7q1mtD7WL8xawpRyWsKfE/4
         3k7po6Wmp8UbEijibhEommlafkSw2mmPzVfTiPsoISJp+a7+YpHqO3tDJhGY3R4xD/7n
         rdKA==
X-Gm-Message-State: AOAM530o4HASlozD9dxqP+2ltRrrYBktxULyhRm/kvNOMjurLqQgKqAA
        PrfHq0NZ7nryyCfm1MwEnKWeEeOXXXEGpA==
X-Google-Smtp-Source: ABdhPJy+HR5O8ZnVSVC3ASh8TFTMEociyPlXjuOnA0F4pC69vUT/WQR1FUq1hKPNs9gIz7/E0145yQ==
X-Received: by 2002:a5e:9512:: with SMTP id r18mr18884304ioj.86.1608660018249;
        Tue, 22 Dec 2020 10:00:18 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f29sm16328385ilg.3.2020.12.22.10.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 10:00:17 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, cpratapa@codeaurora.org,
        bjorn.andersson@linaro.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 2/3] net: ipa: use state to determine channel command success
Date:   Tue, 22 Dec 2020 12:00:11 -0600
Message-Id: <20201222180012.22489-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201222180012.22489-1-elder@linaro.org>
References: <20201222180012.22489-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The result of issuing a channel control command should be that the
channel changes state.  If enabled, a completion interrupt signals
that the channel state has changed.  This interrupt is enabled by
gsi_channel_command() and disabled again after the command has
completed (or we time out).

There is a window of time--after the completion interrupt is disabled
but before the channel state is read--during which the command could
complete successfully without interrupting.  This would cause the
channel to transition to the desired new state.

So whether a channel command ends via completion interrupt or
timeout, we can consider the command successful if the channel
has entered the desired state (and a failure if it has not,
regardless of the cause).

Fixes: d6c9e3f506ae8 ("net: ipa: only enable generic command completion IRQ when needed");
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 4aee60d62ab09..4f0e791764237 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -505,15 +505,15 @@ static int gsi_channel_alloc_command(struct gsi *gsi, u32 channel_id)
 
 	ret = gsi_channel_command(channel, GSI_CH_ALLOCATE);
 
-	/* Channel state will normally have been updated */
+	/* If successful the channel state will have changed */
 	state = gsi_channel_state(channel);
-	if (!ret && state != GSI_CHANNEL_STATE_ALLOCATED) {
-		dev_err(dev, "channel %u bad state %u after alloc\n",
-			channel_id, state);
-		ret = -EIO;
-	}
+	if (state == GSI_CHANNEL_STATE_ALLOCATED)
+		return 0;
 
-	return ret;
+	dev_err(dev, "channel %u bad state %u after alloc\n",
+		channel_id, state);
+
+	return -EIO;
 }
 
 /* Start an ALLOCATED channel */
@@ -533,15 +533,15 @@ static int gsi_channel_start_command(struct gsi_channel *channel)
 
 	ret = gsi_channel_command(channel, GSI_CH_START);
 
-	/* Channel state will normally have been updated */
+	/* If successful the channel state will have changed */
 	state = gsi_channel_state(channel);
-	if (!ret && state != GSI_CHANNEL_STATE_STARTED) {
-		dev_err(dev, "channel %u bad state %u after start\n",
-			gsi_channel_id(channel), state);
-		ret = -EIO;
-	}
+	if (state == GSI_CHANNEL_STATE_STARTED)
+		return 0;
 
-	return ret;
+	dev_err(dev, "channel %u bad state %u after start\n",
+		gsi_channel_id(channel), state);
+
+	return -EIO;
 }
 
 /* Stop a GSI channel in STARTED state */
@@ -568,10 +568,10 @@ static int gsi_channel_stop_command(struct gsi_channel *channel)
 
 	ret = gsi_channel_command(channel, GSI_CH_STOP);
 
-	/* Channel state will normally have been updated */
+	/* If successful the channel state will have changed */
 	state = gsi_channel_state(channel);
-	if (ret || state == GSI_CHANNEL_STATE_STOPPED)
-		return ret;
+	if (state == GSI_CHANNEL_STATE_STOPPED)
+		return 0;
 
 	/* We may have to try again if stop is in progress */
 	if (state == GSI_CHANNEL_STATE_STOP_IN_PROC)
@@ -604,9 +604,9 @@ static void gsi_channel_reset_command(struct gsi_channel *channel)
 
 	ret = gsi_channel_command(channel, GSI_CH_RESET);
 
-	/* Channel state will normally have been updated */
+	/* If successful the channel state will have changed */
 	state = gsi_channel_state(channel);
-	if (!ret && state != GSI_CHANNEL_STATE_ALLOCATED)
+	if (state != GSI_CHANNEL_STATE_ALLOCATED)
 		dev_err(dev, "channel %u bad state %u after reset\n",
 			gsi_channel_id(channel), state);
 }
@@ -628,9 +628,10 @@ static void gsi_channel_de_alloc_command(struct gsi *gsi, u32 channel_id)
 
 	ret = gsi_channel_command(channel, GSI_CH_DE_ALLOC);
 
-	/* Channel state will normally have been updated */
+	/* If successful the channel state will have changed */
 	state = gsi_channel_state(channel);
-	if (!ret && state != GSI_CHANNEL_STATE_NOT_ALLOCATED)
+
+	if (state != GSI_CHANNEL_STATE_NOT_ALLOCATED)
 		dev_err(dev, "channel %u bad state %u after dealloc\n",
 			channel_id, state);
 }
-- 
2.20.1

