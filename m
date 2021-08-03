Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5073DEF8C
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236474AbhHCOBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236331AbhHCOBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:01:22 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D77CC061764
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 07:01:10 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id f11so24339125ioj.3
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 07:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HPmPU/IPZMujqhjgqF3ovBGi7NkWBNCG5MxA59CMXOc=;
        b=zzCH1hgowuyikO+j9qETjeo6hgLWKMkC3jRc9nK6vE/GVwrsaJmim0dmquUBbubDpy
         DAV6pwCyejx37x7biAhO6Xk0e6ShCL5VcNJBb0ZB4eHKpEnfiEZGP9lAztEi0s6eRwVQ
         /UDIGOq4UrOax0HhmIex59Akk2GrWKUUb9hRpk61GXtCEBBHoVARSo5H6dj7KwcKxmgm
         bh+tbhKlIrDzSbmN9230RrY8y90Yf2sKnVso/lJjuQyec2jM65G+5TEPZx/NoNpKG99y
         CQcHIEJiZuNCPv+koUBnm/TBvXJPb+OwCENA+KyQS2Hm3l+nBkh6vVH5AxDYPtzIxRQe
         N1Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HPmPU/IPZMujqhjgqF3ovBGi7NkWBNCG5MxA59CMXOc=;
        b=LWAEQGlKB0Vb1LQDyz/ziT6o87dY0eVsEr7+MMZZ6OhB5BNg0L4b/nwAzYLM3vCtwl
         v5aRu5+LWyOCuc5m/cY5aCxb/lz7UoHFvpx9cTlVNBJa5PHCzA2grKwI0f0Bw0PiZyjz
         z3CMMGAInqwUn3nhG9PueqIDDpPQz8jN/u6AkteqIesLdz8AzNzftEhcaABx4kPhv0O7
         mXJw0HRi46n/8TD1DyGGoJr1gywGkX4GpwrEZJICpERyisQbXUU8OlBuGY59W6s0z9mr
         JClSuFlMLAzwmssLp+bY4AgbCpkCdQbYl5KAgKhM83PlLE4RpN+rZY5QYanW3wY/deqH
         a8eg==
X-Gm-Message-State: AOAM533sXPzjatMVgysUXYXVPU+/P73fVwcaV1fKbaJAiO3bME9/Tim2
        XrbFtoynzFU863Qz9eOln5wkLA==
X-Google-Smtp-Source: ABdhPJyNFAZl8KtGpMx66NA7fEr9KyKgsBvZmM+PvnMid7uFVwqUYko+w7VZfSO+wiEYydpXb+i1gw==
X-Received: by 2002:a05:6638:306:: with SMTP id w6mr11459438jap.132.1627999270154;
        Tue, 03 Aug 2021 07:01:10 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w7sm9456798iox.1.2021.08.03.07.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 07:01:09 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/6] net: ipa: move version check for channel suspend/resume
Date:   Tue,  3 Aug 2021 09:00:59 -0500
Message-Id: <20210803140103.1012697-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210803140103.1012697-1-elder@linaro.org>
References: <20210803140103.1012697-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the Boolean flags passed to __gsi_channel_start() and
__gsi_channel_stop() so they represent whether the request is being
made to implement suspend (versus stop) or resume (versus start).

Then stop or start the channel for suspend/resume requests only if
the hardware version indicates it should be done.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index e143deddb7c09..5c5a2571d2faf 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -920,12 +920,13 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 	/* All done! */
 }
 
-static int __gsi_channel_start(struct gsi_channel *channel, bool start)
+static int __gsi_channel_start(struct gsi_channel *channel, bool resume)
 {
 	struct gsi *gsi = channel->gsi;
 	int ret;
 
-	if (!start)
+	/* Prior to IPA v4.0 suspend/resume is not implemented by GSI */
+	if (resume && gsi->version < IPA_VERSION_4_0)
 		return 0;
 
 	mutex_lock(&gsi->mutex);
@@ -947,7 +948,7 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
 	napi_enable(&channel->napi);
 	gsi_irq_ieob_enable_one(gsi, channel->evt_ring_id);
 
-	ret = __gsi_channel_start(channel, true);
+	ret = __gsi_channel_start(channel, false);
 	if (ret) {
 		gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
 		napi_disable(&channel->napi);
@@ -971,7 +972,7 @@ static int gsi_channel_stop_retry(struct gsi_channel *channel)
 	return ret;
 }
 
-static int __gsi_channel_stop(struct gsi_channel *channel, bool stop)
+static int __gsi_channel_stop(struct gsi_channel *channel, bool suspend)
 {
 	struct gsi *gsi = channel->gsi;
 	int ret;
@@ -979,7 +980,8 @@ static int __gsi_channel_stop(struct gsi_channel *channel, bool stop)
 	/* Wait for any underway transactions to complete before stopping. */
 	gsi_channel_trans_quiesce(channel);
 
-	if (!stop)
+	/* Prior to IPA v4.0 suspend/resume is not implemented by GSI */
+	if (suspend && gsi->version < IPA_VERSION_4_0)
 		return 0;
 
 	mutex_lock(&gsi->mutex);
@@ -997,7 +999,7 @@ int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
 	struct gsi_channel *channel = &gsi->channel[channel_id];
 	int ret;
 
-	ret = __gsi_channel_stop(channel, true);
+	ret = __gsi_channel_stop(channel, false);
 	if (ret)
 		return ret;
 
@@ -1032,8 +1034,7 @@ int gsi_channel_suspend(struct gsi *gsi, u32 channel_id)
 	struct gsi_channel *channel = &gsi->channel[channel_id];
 	int ret;
 
-	/* Prior to IPA v4.0 suspend/resume is not implemented by GSI */
-	ret = __gsi_channel_stop(channel, gsi->version >= IPA_VERSION_4_0);
+	ret = __gsi_channel_stop(channel, true);
 	if (ret)
 		return ret;
 
@@ -1048,8 +1049,7 @@ int gsi_channel_resume(struct gsi *gsi, u32 channel_id)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
 
-	/* Prior to IPA v4.0 suspend/resume is not implemented by GSI */
-	return __gsi_channel_start(channel, gsi->version >= IPA_VERSION_4_0);
+	return __gsi_channel_start(channel, true);
 }
 
 /**
-- 
2.27.0

