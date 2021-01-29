Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013FC308E73
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbhA2UYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:24:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbhA2UWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 15:22:43 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4795DC061351
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 12:20:31 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id u7so10625600iol.8
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 12:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IyvOnmoZSqo2WxAcwPn8wTudNnGv17LW2Bgf4MzbHMg=;
        b=VQH3LBiTtAbVKsZ7bIPXv7N8Y56z2hGZVXASfmr8S5wK+/kuidN/tbI9eHA0E0zRtb
         s8EFwpujww5HWIcvaZchgGw+NwsCiBoMZZZjGizwuiVgyydyKupHLHqtPQaA7jYopSIC
         tHAuzDpHpxuwC1YpexvhBx8xxLgcIwp0IBIZITDnCa9cECdBL8D7yd7NwyEs60t5jYSi
         sBpnZjy5o7qtwEJjMH+KamWH8hw3yxzAF8T5BU5SKooTY1AlL7t8rOB1L0bc2PrVcG+4
         EUV8MHriOpg2bVjwT5y4KKeYM7Qrnsgd7l7G5kelkwfLlzHtxx3xTqm4vf+yfaBPtm5K
         aEWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IyvOnmoZSqo2WxAcwPn8wTudNnGv17LW2Bgf4MzbHMg=;
        b=KDJUiujM06nFw+BwfQbkXsdA5wgSdbJs3W7qWhSnspsCgwlGNynv0Y27GfYScl48vY
         vrgS0Udb4eBZh/orAZzYW4ipNkynA6C8uv8Hxy/57H1RMwuqJUo0I/kCEOHMs9ekpbad
         49B6MCNjvBwrAR3YN5fH3jmuxHWxcrEjtsbaZevAyK3H1cJerPnSRsiQgaJ8buiaREBm
         /GIfcyoT1PPMRhdnm6jxTl5et82ilJEKUsbalKnDQDS+AW60KdJFH4DPi2SySI+XxWuc
         KJFIk0wps3Xd9cEyS7t69QQ/ar5vIFaYCrJjQ+J1/Wb45xe+r9/I85rCkJMuFfob8igc
         C/gA==
X-Gm-Message-State: AOAM532lyWMLFWI6gji8Uxg3yVfJOUSUJv+0x8VYqV6c8nwPyxj6iiBL
        FsiFbDRf2z4PxX0+GsYWWUt2Mg==
X-Google-Smtp-Source: ABdhPJzEd8JDEqy83Slf7ZqMcHQce5+cqynUYKeETnbzf96EYBiC8FmnG07NRpkjafnXrMjZOsB+sQ==
X-Received: by 2002:a5d:8ac5:: with SMTP id e5mr4770819iot.33.1611951630792;
        Fri, 29 Jan 2021 12:20:30 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h23sm4645738ila.15.2021.01.29.12.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 12:20:30 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/9] net: ipa: don't disable IEOB interrupt during suspend
Date:   Fri, 29 Jan 2021 14:20:17 -0600
Message-Id: <20210129202019.2099259-8-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210129202019.2099259-1-elder@linaro.org>
References: <20210129202019.2099259-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No completion interrupts will occur while an endpoint is suspended,
or when a channel has been stopped for suspend.  So there's no need
to disable the interrupt during suspend and re-enable it when
resuming.

We'll enable the interrupt when we first start the channel, and
disable it again only when it's "really" stopped.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 70647e8450845..74d1dd04ad6e9 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -959,30 +959,16 @@ void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool doorbell)
 int gsi_channel_suspend(struct gsi *gsi, u32 channel_id, bool stop)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
-	int ret;
 
-	/* No completions when suspended; disable interrupt if successful */
-	ret = __gsi_channel_stop(channel, stop);
-	if (!ret)
-		gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
-
-	return ret;
+	return __gsi_channel_stop(channel, stop);
 }
 
 /* Resume a suspended channel (starting will be requested if STOPPED) */
 int gsi_channel_resume(struct gsi *gsi, u32 channel_id, bool start)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
-	int ret;
 
-	/* Re-enable the completion interrupt */
-	gsi_irq_ieob_enable_one(gsi, channel->evt_ring_id);
-
-	ret = __gsi_channel_start(channel, start);
-	if (ret)
-		gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
-
-	return ret;
+	return __gsi_channel_start(channel, start);
 }
 
 /**
-- 
2.27.0

