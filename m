Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B791D5A8A
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 22:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgEOUHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 16:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726632AbgEOUHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 16:07:44 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3E6C05BD09
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 13:07:43 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id i68so3086155qtb.5
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 13:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3r8s7zaQa/KQl7hgw/M/WA+lgPX3mns2yHevK22z30k=;
        b=BRtgwGCcFo61RZsb2/I16jAiD4ENgLTywxJXh2NnUISr13acvjJOUE5nvgRKZkmM90
         wPV5jZALMt7CP2iveEOhtfs9XLAXOEPv2kijmh70T3xT/vcJ2//ofZVVy+PoCIH6l2OS
         E8j1OoCnwnuzIMqxwYf1ojxbGe5Wu74wMojaB0xOvgzMvmT5Xq+fvwXbkXg7f73FoyO6
         3mDSEY11pCdeQ4ZTBVjlgLFBTB3xtPmbsx8Ww7y6u6HbxKNQGbok/SOT06yTQDAW7Y3v
         /5//7Xd92KriSkL0nhQXTlbbgFjB2iC1CAjD37fekwyOeBe8lt2OoVX4ULr/8U1YklFh
         P9Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3r8s7zaQa/KQl7hgw/M/WA+lgPX3mns2yHevK22z30k=;
        b=nntWl3Iq7Y1pA2PA3x3ca3d/DBTiCJI3+O24LCHQCNrdtuSF46IDp2GSLSAOnFBhC3
         2WHQ7GsJz+R92naIGo/Y1WZ9HVxxk+itE9hBhZ8+7s6K489e6YY2GBl7nyr2geN3ay1n
         tKTZ4mqcd7P683iIXq9g5wBsNrga3SRLm0QrbhliRWEcbH5GtuKByriVaRyIIvWr1b37
         Zm6oSuFWjg0z6JCm3XZW5D+yCIxBnCw7wteZ6R0VZK6JsPKjIzlQI+UVkTSZkYwed2Uf
         k2RELZbH4mdlQkYKgTlPCsj2C/cO4tqDoglY/QZqHUdUIfMGonOHNNmYaq3/lfeHvJN3
         CfCw==
X-Gm-Message-State: AOAM531eiaHzXwPt7hPXjRDuLkISFw1MculS1Rv/5Sw8MmlDSPEd4MUG
        CV9qMxdiAtg6CY6mG00Bg2gykVEQoAI=
X-Google-Smtp-Source: ABdhPJz+54fAQNJEeoaeaQPLvewzy1S/LrjWypbertBQ0Kd9eVZQrPTcNc5266QmcNbbuxxQ/rpHEQ==
X-Received: by 2002:ac8:e8f:: with SMTP id v15mr5246054qti.391.1589573262634;
        Fri, 15 May 2020 13:07:42 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id 132sm2328246qkj.117.2020.05.15.13.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 13:07:42 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org.net, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: ipa: do not clear interrupt in gsi_channel_start()
Date:   Fri, 15 May 2020 15:07:31 -0500
Message-Id: <20200515200731.2931-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200515200731.2931-1-elder@linaro.org>
References: <20200515200731.2931-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In gsi_channel_start() there is harmless-looking comment "Clear the
channel's event ring interrupt in case it's pending".  The intent
was to avoid getting spurious interrupts when first bringing up a
channel.

However we now use channel stop/start to implement suspend and
resume, and an interrupt pending at the time we resume is actually
something we don't want to ignore.

The very first time we bring up the channel we do not expect an
interrupt to be pending, and even if it were, the effect would
simply be to schedule NAPI on that channel, which would find nothing
to do, which is not a problem.

Stop clearing any pending IEOB interrupt in gsi_channel_start().
That leaves one caller of the trivial function gsi_isr_ieob_clear().
Get rid of that function and just open-code it in gsi_isr_ieob()
instead.

This fixes a problem where suspend/resume IPA v4.2 would get stuck
when resuming after a suspend.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 66570609c845..d343dc94cb48 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -238,11 +238,6 @@ static void gsi_irq_ieob_enable(struct gsi *gsi, u32 evt_ring_id)
 	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
 }
 
-static void gsi_isr_ieob_clear(struct gsi *gsi, u32 mask)
-{
-	iowrite32(mask, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_CLR_OFFSET);
-}
-
 static void gsi_irq_ieob_disable(struct gsi *gsi, u32 evt_ring_id)
 {
 	u32 val;
@@ -777,7 +772,6 @@ static void gsi_channel_deprogram(struct gsi_channel *channel)
 int gsi_channel_start(struct gsi *gsi, u32 channel_id)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
-	u32 evt_ring_id = channel->evt_ring_id;
 	int ret;
 
 	mutex_lock(&gsi->mutex);
@@ -786,9 +780,6 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
 
 	mutex_unlock(&gsi->mutex);
 
-	/* Clear the channel's event ring interrupt in case it's pending */
-	gsi_isr_ieob_clear(gsi, BIT(evt_ring_id));
-
 	gsi_channel_thaw(channel);
 
 	return ret;
@@ -1093,7 +1084,7 @@ static void gsi_isr_ieob(struct gsi *gsi)
 	u32 event_mask;
 
 	event_mask = ioread32(gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_OFFSET);
-	gsi_isr_ieob_clear(gsi, event_mask);
+	iowrite32(event_mask, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_CLR_OFFSET);
 
 	while (event_mask) {
 		u32 evt_ring_id = __ffs(event_mask);
-- 
2.20.1

