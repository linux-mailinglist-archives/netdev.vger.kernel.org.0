Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4662F50DE
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 18:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbhAMRRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 12:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728143AbhAMRQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 12:16:59 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32376C0617B0
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 09:15:44 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id u26so5667939iof.3
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 09:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cya1YllzUew1Cz7aOjwGwTo+phSDuV7y8gvGZ//U/9Q=;
        b=mU/mNVI1DbIGzLDbFVMDvJokTzluyxYOZ835J5gSBXl9SNgJli/wh4cNdHzIkBHYdH
         b3dr+Gphw383vAAc1jzu4Ry+RMtAVkVT96qLS9S9dJ9sDXyCQIRf9w4lh4QHDBNaWHSr
         fcy1W8pHyz+lOKDFGkUma55jl5L9zqZVgHcK1plyCaOhBxUbqRlvGx0Cl0mA6llTaHLI
         ZNFS6agCjJpko710CEz1QhKyonVyzVprbrcxDwicKFQ+UktUiiRNW1DvpOE3MoaNIYeD
         qlp9v7mDHhdjEvbUmoiYh37CDW0s7hBG3tK5Ja1f4b3fe7LKBigxGSt7L2XGMnJKZsWC
         fgag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cya1YllzUew1Cz7aOjwGwTo+phSDuV7y8gvGZ//U/9Q=;
        b=Mcsvwm+90caFRP5rYFSunks/QhrrxyaHkrTJZAL7nq9CpBW03NsgkPj2GeH0NxrwC8
         ZvI8zYKAoRKfPy6Zwqn+638WEOsHNvtKg9TgL9C5amS4ezwRpuWMMb/vGj/KwTe3Mpki
         DhdUQmR1CMBhzXunYCbOKEyEf4khyM9L997puap29PggWLUggt0d+CzzBU/gwHlr99QF
         z3LVJrayusfmr/ys6cllWiWLxyPtST+HisEv4HvZATKw7XsZYONCnWnmZ+ucjGaNFPDw
         C5yVtO2axrl4dykF3uWYHE/8s1cNjCLEek29Vnp6vq0E9iYlx/axV6ByX1QLv9kg9QRQ
         zhYA==
X-Gm-Message-State: AOAM533sVnD8s0HApX0XwQq44OsOv6S3uGKN1q1K3pM98TD9dGzO9Gl3
        aIJjfwfA5UhqwcLijWJNSlsMTQ==
X-Google-Smtp-Source: ABdhPJwMS0K6oCxdHlBm9fgUOW23pCifG3ouH/c8/rfeYPNFtkVcq24RoUabju6o4jccQq/x07ZxvQ==
X-Received: by 2002:a02:cf9a:: with SMTP id w26mr3268797jar.25.1610558143520;
        Wed, 13 Jan 2021 09:15:43 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h9sm1120579ili.43.2021.01.13.09.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 09:15:42 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net: ipa: retry TX channel stop commands
Date:   Wed, 13 Jan 2021 11:15:32 -0600
Message-Id: <20210113171532.19248-7-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210113171532.19248-1-elder@linaro.org>
References: <20210113171532.19248-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For RX channels we issue a stop command more than once if necessary
to allow it to stop.  It turns out that TX channels could also
require retries.

Retry channel stop commands if necessary regardless of the channel
direction.  Rename the symbol defining the retry count so it's not
RX-specific.

Fixes: 650d1603825d8 ("soc: qcom: ipa: the generic software interface")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 5c163f9c0ea7b..5b29f7d9d6ac1 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -91,7 +91,7 @@
 
 #define GSI_CMD_TIMEOUT			50	/* milliseconds */
 
-#define GSI_CHANNEL_STOP_RX_RETRIES	10
+#define GSI_CHANNEL_STOP_RETRIES	10
 #define GSI_CHANNEL_MODEM_HALT_RETRIES	10
 
 #define GSI_MHI_EVENT_ID_START		10	/* 1st reserved event id */
@@ -889,14 +889,11 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
 int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
-	u32 retries;
+	u32 retries = GSI_CHANNEL_STOP_RETRIES;
 	int ret;
 
 	gsi_channel_freeze(channel);
 
-	/* RX channels might require a little time to enter STOPPED state */
-	retries = channel->toward_ipa ? 0 : GSI_CHANNEL_STOP_RX_RETRIES;
-
 	mutex_lock(&gsi->mutex);
 
 	do {
-- 
2.20.1

