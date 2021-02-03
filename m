Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8640930DE29
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 16:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbhBCPaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 10:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbhBCP3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 10:29:43 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C374FC06178C
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 07:29:02 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id e7so22709907ile.7
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 07:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ctT+U1JJRhDXj7a+ZLi4WV5LisqIA2NCLe0Qt/Ic+HU=;
        b=w4NU4U+T6kwNtRNLwO2PhEjVIJpUWoCZdrNhJkXG6jTKXAZA2QT0nwZxAk/1+31fWS
         NzOl4SYTARW47iFwlmdHWZ2e+Q4ffQjjoqcgGPTQuT3L/TrcdnpNX1RrNZ3dPrfi1lmw
         E+OpX2/5sR3oLCMVGWxshmrZGyQ81XzfbWdiTjey1HlJVGkP5eWGGBB9bGxmMtd0ti+Z
         w1GPtnPhrye+PAjKQwZdiUx3+XIZLwVqBsTaE4nosvkrycVdWgpq+VcDaAlFU44jC/uS
         ezxsxgmJ0MXd+GWkNCppGwInHOxhePem8JifJPKdijnu+A5DggAwuivh8OxMqBKw1GjN
         HNcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ctT+U1JJRhDXj7a+ZLi4WV5LisqIA2NCLe0Qt/Ic+HU=;
        b=BKrajuHEyVS/9kuQptxX0rjf8xPe2ds4D6uAz5/Iss8MzAA8LqCk0W0O4Zyxm73HAd
         Ci659PsokSHCMOj+zR6NYm8Ih5z7ESSEjMMd9Gg7P5wVNKMFvIce8k7fmfhIPCShf3Cd
         bkhJbmsNhX4Y9VkokFYGS5dZN5SF6OHxD3cBY19SwMPpfFGX4vGR+Alx+p94AL2s5TTE
         rRy3w/HDUIEi3mzGXQfvDDXAFVoDQzy8nHnlZv/a6OgCNBEjwT1fCdWgafz4CxZ7RWvb
         jPDnadvcbQGCgwhIc+HNG6pfA3Dgtm3VCDro4aKz3oGSX0/WgCfHOLSA2/CsY4SVRY65
         d+Tw==
X-Gm-Message-State: AOAM5331JEmAZk91HNt0FruecNdiVq33bT0rAy1o0AbNGFzssY+G+1aP
        TLiP+nRsbgcX+vfJFUqDoudcOw==
X-Google-Smtp-Source: ABdhPJxGvCtURGbq+GzBlj/wFb12OSJjqReQ8q0iD91ySxaLC5KvmjIJCwIsz3znrow4SLH5APAuJA==
X-Received: by 2002:a05:6e02:1407:: with SMTP id n7mr3030056ilo.242.1612366142266;
        Wed, 03 Feb 2021 07:29:02 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a15sm1119774ilb.11.2021.02.03.07.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 07:29:01 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/7] net: ipa: synchronize NAPI only for suspend
Date:   Wed,  3 Feb 2021 09:28:50 -0600
Message-Id: <20210203152855.11866-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210203152855.11866-1-elder@linaro.org>
References: <20210203152855.11866-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When stopping a channel, gsi_channel_stop() will ensure NAPI
polling is complete when it calls napi_disable().  So there is no
need to call napi_synchronize() in that case.

Move the call to napi_synchronize() out of __gsi_channel_stop()
and into gsi_channel_suspend(), so it's only used where needed.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 2671b76ebcfe3..420d0f3bfae9a 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -939,10 +939,6 @@ static int __gsi_channel_stop(struct gsi_channel *channel, bool stop)
 		mutex_unlock(&gsi->mutex);
 	}
 
-	/* Finally, ensure NAPI polling has finished. */
-	if (!ret)
-		napi_synchronize(&channel->napi);
-
 	return ret;
 }
 
@@ -984,8 +980,14 @@ void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool doorbell)
 int gsi_channel_suspend(struct gsi *gsi, u32 channel_id, bool stop)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
+	int ret;
 
-	return __gsi_channel_stop(channel, stop);
+	/* Synchronize NAPI if successful, to ensure polling has finished. */
+	ret = __gsi_channel_stop(channel, stop);
+	if (!ret)
+		napi_synchronize(&channel->napi);
+
+	return ret;
 }
 
 /* Resume a suspended channel (starting will be requested if STOPPED) */
-- 
2.20.1

