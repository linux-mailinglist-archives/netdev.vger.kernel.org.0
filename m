Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01CB31156F
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbhBEWbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbhBEORn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:17:43 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25C0C06121D
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 07:47:04 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id g9so6226004ilc.3
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 07:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kxUeKVVNjUYZDEFlDXz16lYFbO6uGbZz83MJ+yrq+To=;
        b=MHKCxzmuwmO3/oZLWZYANCeI3dBbjZKs52DNYS2+XYmT7KjDFmHyFR0nnq0A+ugEQZ
         drQjc5ZdJ6R1GWFpepq9BrE1iwWYD8dEOnJsRriHpru3d31kRDiamI8d810//keKACbk
         MO0ri9erP1Bd+gzSnYdtozR7ml1kcSxE/WjN5YhbMEcrqRDZZWkR4wOFZdLiwD45o+mJ
         jJjPDeLSlmCuTTX8ce31NMP4bnZyf/hhxlW7sQANGcGk7Gif/Y55RMnb11PHc3jWyXL7
         1AV54PW0fGx89ViXdBD1qS4Ghmn8ZaIKpZZbeJGkuW/4cSgbLE924TKrcNLLkkDt2HBP
         GbPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kxUeKVVNjUYZDEFlDXz16lYFbO6uGbZz83MJ+yrq+To=;
        b=iVZoMkRc5bGhMRvpkWvxA0RdtakMspsNmkJ7V272Vcsta/U7c2UoHuB7zmuijGM9tF
         KRIKXFkJqMajR+lXNnN5Fu9g5LBiGj3PLznMtdzdeh300erRFYuViCA6ppuCem/5bGSU
         OXHDkRQ8mtVPf+a0igdFYpLo96OnW0phAC6cph3SOuOOPR03a+FNwZz00g0j+jO6cOsk
         PvjQb2OGOl1HnZoi1rG+ZTLcFR27mu2cuhbwLmS+XitqXwEY/4B9P2sRqdr0ijuJZUVY
         S44QLoc9WRrmeo4SPNylXutMPpUME5daVqntxwGOG3Zmhvbkx6ua/xhtFH4GjyZmACxW
         wTsg==
X-Gm-Message-State: AOAM533Ymrs9n3vSjXjCRMxpNw9qUly0CpUke++v+9EEbVoUf5LZhCVZ
        8z/fuPsD5MF+MPTjbElxi6/8ntWP+28i5g==
X-Google-Smtp-Source: ABdhPJyN6tsNpizr/AS1lySXfiAP3FkWN+sGHt/OQ4uLybMXNhsf6SJ+WQxiPheahYUcmEaQREjJhw==
X-Received: by 2002:a92:3306:: with SMTP id a6mr4036757ilf.55.1612535915555;
        Fri, 05 Feb 2021 06:38:35 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h9sm4136882ili.43.2021.02.05.06.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 06:38:35 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/7] net: ipa: synchronize NAPI only for suspend
Date:   Fri,  5 Feb 2021 08:38:24 -0600
Message-Id: <20210205143829.16271-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210205143829.16271-1-elder@linaro.org>
References: <20210205143829.16271-1-elder@linaro.org>
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
v2: - Return early to avoid blocks of indented code

 drivers/net/ipa/gsi.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index f0432c965168c..60eb765c53647 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -939,13 +939,7 @@ static int __gsi_channel_stop(struct gsi_channel *channel, bool stop)
 
 	mutex_unlock(&gsi->mutex);
 
-	if (ret)
-		return ret;
-
-	/* Ensure NAPI polling has finished. */
-	napi_synchronize(&channel->napi);
-
-	return 0;
+	return ret;
 }
 
 /* Stop a started channel */
@@ -987,8 +981,16 @@ void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool doorbell)
 int gsi_channel_suspend(struct gsi *gsi, u32 channel_id, bool stop)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
+	int ret;
 
-	return __gsi_channel_stop(channel, stop);
+	ret = __gsi_channel_stop(channel, stop);
+	if (ret)
+		return ret;
+
+	/* Ensure NAPI polling has finished. */
+	napi_synchronize(&channel->napi);
+
+	return 0;
 }
 
 /* Resume a suspended channel (starting will be requested if STOPPED) */
-- 
2.20.1

