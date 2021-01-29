Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BEF308E75
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbhA2UZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbhA2UWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 15:22:03 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1DCC0617A7
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 12:20:29 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id q129so10656188iod.0
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 12:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qBeIWIoL4lPuHMIewwlmHC2HR0MCP9P0drFvCV7BbtI=;
        b=M/Ac5MurdUC/9plj3pZACJ+JA8zznucmWbj1AaldW7yCA9ngrjrkzXzJzEvC5KtarH
         YzVQUuEyIxHvy4AfU+DmcgW7y957rDp2Ny/yc1r53wNwtK7bGTwKpabKM4uJPM3Ahg08
         BRm+3pvP2LOp8HIG3etB69TmMoNeiH4H1oLeoaJjtJl/nOq8bIOnsSJFiC93pnJTwUTC
         Eyot0H9zGfWFkE5A/RWF7YnmQtwyusKuDtSy4JYOTkA6dfvI+3DL+3hLPM9PUqfsNj6p
         1WvwcbNpn7NKnRXtV1itl8mDeyVRzYNIaq61ETfAIu4hFb8lKa9okO4qYZDV5GULaQPn
         rZhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qBeIWIoL4lPuHMIewwlmHC2HR0MCP9P0drFvCV7BbtI=;
        b=ZSzWX0LhrFIdACJn1tqaX8mG7fUMjJnL+HXPb/jlDQ1XbbSckPHCLkq0o08ZweTPZf
         p+M3DEhUPR3PLz++WOcHu24FxkX9ewL7UmlH9sB0jsC0uOoqvfL3VOGTDKleLZtAj1wo
         x5tqgqrcdVu3YVznBTRLixh03Efrk4w26OBl7LNLyd/CwaqN3fduZ5wNZAw/K2c4EhLn
         lswqiZWZjIlrOJKzn5jvgXM/6Joz4RDhYFbjBoHwyIfLgJV9NKUaO1W3cuancIdWFSbs
         /mFYJiphAYArsH+8XH8BHT9PbepcZYPrMl4ivVj7wsaWPI/xq1jL6uzvqw6dyq6jao9i
         B7gg==
X-Gm-Message-State: AOAM531r6sSSKS2hOwxvvzFY2hMbZ/wTYjyXnN77gun32IHNp6sjJuYG
        +JZnPTREH+WledrsVlfYBCyQJg==
X-Google-Smtp-Source: ABdhPJxQxobB4kniGzBmeBuz9P8MqRdPlwo2Fp9dng1UIv95gYWaDFnj70nI2afzo18Ox1BPOW72Fw==
X-Received: by 2002:a02:ca17:: with SMTP id i23mr5513738jak.25.1611951628546;
        Fri, 29 Jan 2021 12:20:28 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h23sm4645738ila.15.2021.01.29.12.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 12:20:28 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/9] net: ipa: disable IEOB interrupt after channel stop
Date:   Fri, 29 Jan 2021 14:20:15 -0600
Message-Id: <20210129202019.2099259-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210129202019.2099259-1-elder@linaro.org>
References: <20210129202019.2099259-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disable the I/O completion interrupt on a channel *after* we
successfully stop it rather than before.  This ensures a completion
occurring just before the channel is stopped triggers an interrupt.

Enable the interrupt *before* starting a channel rather than after,
to be symmetric.  A stopped channel won't generate any completion
interrupts anyway.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 565c785e33a25..1a02936b4db06 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -860,16 +860,18 @@ static int __gsi_channel_start(struct gsi_channel *channel, bool start)
 	struct gsi *gsi = channel->gsi;
 	int ret;
 
+	gsi_irq_ieob_enable_one(gsi, channel->evt_ring_id);
+
 	mutex_lock(&gsi->mutex);
 
 	ret = start ? gsi_channel_start_command(channel) : 0;
 
 	mutex_unlock(&gsi->mutex);
 
-	if (!ret) {
-		gsi_irq_ieob_enable_one(gsi, channel->evt_ring_id);
+	if (ret)
+		gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
+	else
 		napi_enable(&channel->napi);
-	}
 
 	return ret;
 }
@@ -909,14 +911,13 @@ static int __gsi_channel_stop(struct gsi_channel *channel, bool stop)
 
 	gsi_channel_trans_quiesce(channel);
 	napi_disable(&channel->napi);
-	gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
 
 	ret = stop ? gsi_channel_stop_retry(channel) : 0;
 
-	if (ret) {
-		gsi_irq_ieob_enable_one(gsi, channel->evt_ring_id);
+	if (ret)
 		napi_enable(&channel->napi);
-	}
+	else
+		gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
 
 	return ret;
 }
-- 
2.27.0

