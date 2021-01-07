Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E452EE7C3
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 22:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbhAGVol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 16:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbhAGVol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 16:44:41 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D58C0612FB
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 13:43:32 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id p187so7625102iod.4
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 13:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D9HgxlCMRBRvY3EtPBfpOoI3TYfy8ZVEt5J8BdfVXKI=;
        b=x5i3A8tfaLHchgjQEBdoO1VwSLM5+0GIPP0995ZsTGKIAI8HIpN+xsT6mgVuKrZenV
         9IB2rSFQyxFuVMJG6wV5NsL1AmLa8521N51CgHMxp1fqaDfyXjZaRbq1gWGoIuZmQlMr
         dBS2A2zpsuPws1Ww9igyXEm1wSqZNjXu/6ovDA9r8ypbfv20E/KYns6XzDx5qVBo/WSU
         UgXIqivDZsgQBZvuqISF69y3McqXzBdFXkc4CEaz2FubZtWpV5dXm+AiV9XM6DSaBv3Z
         LGe1CAfXsovD4ND0sp971bMb6tY2j6NZuB0uCs4LU+0v5VPYiVj2uqW39r632w2+04Jc
         hmpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D9HgxlCMRBRvY3EtPBfpOoI3TYfy8ZVEt5J8BdfVXKI=;
        b=g8pAMmYghMpyso5UA0VHVmSGQ2Kp6dDC1y5wjKO86nlpdWJNYv4tNv3n+ZoCQEYAd1
         Y48580SkP76H1AHcLpPcXEQzyjyQMZE4uirH8kDL7hlJiHL1S6/xZmQo7wLiGLKPvyDH
         MNsz678CUzenmLUHVboQDaXpXEbhS9z2rwqpaYXBk20GKyxArii63nKKUBekJQUzzQH+
         vukL3b8h6WtS3bAJrYrl5HSvP3UtotfkT1JK4Z2j8AKKP474PeiK87aF94sUzU26zzsq
         3jxep0S5AQJ5iF3CLtbJRu8XGAuum8ahLEDqyYsefR4mI9vHsBPTTW7U/6S8k03Hbv+/
         GxLQ==
X-Gm-Message-State: AOAM532mSwvvhvi3q04Uy/1gFMdFWU1P4PL0DzN6aHem0C0tz43kRPsw
        6kN69Dru1kbVg9vias+BuT4LZg==
X-Google-Smtp-Source: ABdhPJx14y6fk8GpEtaJa5MTqI3izUEBNYmTK2saNni0apMvWFsrLJTy9oqMQ5zhcFtOHz8eMufrNw==
X-Received: by 2002:a5d:84cf:: with SMTP id z15mr2896543ior.81.1610055811515;
        Thu, 07 Jan 2021 13:43:31 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f10sm5218260ilq.64.2021.01.07.13.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 13:43:30 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] net: ipa: re-enable NAPI before enabling interrupt
Date:   Thu,  7 Jan 2021 15:43:25 -0600
Message-Id: <20210107214325.7077-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210107214325.7077-1-elder@linaro.org>
References: <20210107214325.7077-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we stop or suspend a channel, we first "freeze" it.  The last
part of that involves disabling NAPI, and disabling the IEOB
interrupt that schedules NAPI when it occurs.  On resume, a "thaw"
does the inverse of these activities, in reverse order.  Currently
these are ordered such that NAPI is disabled before interrupts on
suspend, and NAPI is re-enabled after interrupts on resume.

An interrupt occurring while NAPI is disabled will request a NAPI
schedule, but polling is deferred until after NAPI is enabled again.
When NAPI is re-enabled, polling is allowed again, but enabling
NAPI does not schedule a poll (i.e., it won't trigger polling to
handle a schedule request that occurred while disabled).  Polling
won't commence until the next napi_schedule() request occurs.

Instead, disable completion interrupts *before* disabling NAPI when
stopping a channel, and re-enable interrupts *after* re-enabling
NAPI.  That way NAPI is always enabled when an interrupt occurs,
and polling to handle the interrupt can commence immediately.

The channel STOPPING flag ensures the polling function won't
re-enable the completion interrupt while we are stopping.

Fixes: 650d1603825d8 ("soc: qcom: ipa: the generic software interface")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 7e7629902911e..9bde6d02b1cd6 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -743,21 +743,21 @@ static void gsi_channel_freeze(struct gsi_channel *channel)
 	set_bit(GSI_CHANNEL_FLAG_STOPPING, channel->flags);
 	smp_mb__after_atomic();	/* Ensure gsi_channel_poll() sees new value */
 
-	napi_disable(&channel->napi);
-
 	gsi_irq_ieob_disable(channel->gsi, channel->evt_ring_id);
+
+	napi_disable(&channel->napi);
 }
 
 /* Allow transactions to be used on the channel again. */
 static void gsi_channel_thaw(struct gsi_channel *channel)
 {
-	gsi_irq_ieob_enable(channel->gsi, channel->evt_ring_id);
-
 	/* Allow the NAPI poll loop to re-enable interrupts again */
 	clear_bit(GSI_CHANNEL_FLAG_STOPPING, channel->flags);
 	smp_mb__after_atomic();	/* Ensure gsi_channel_poll() sees new value */
 
 	napi_enable(&channel->napi);
+
+	gsi_irq_ieob_enable(channel->gsi, channel->evt_ring_id);
 }
 
 /* Program a channel for use */
-- 
2.20.1

