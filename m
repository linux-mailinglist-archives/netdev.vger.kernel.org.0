Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A61A31187F
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhBFCjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbhBFCgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:36:17 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF291C061A2B
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:11:09 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id z18so7232256ile.9
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kxUeKVVNjUYZDEFlDXz16lYFbO6uGbZz83MJ+yrq+To=;
        b=HPiOVeky7a2Uf27cS5sPHL8+U0ndFwwub2ApiF9duyiJFjOaYTOYAEfwtIqRWLKw1K
         43B0TJDKV4K6tNuG+VpwSBmicQOi1SjnL671emiWlarpWVgpHIdjWuFxsSHvoc2qw/GW
         fNd7Bgr05JZpnJMECyfDjpVecPFohd0ZTMzOgwAozoX/rKoOAYaYDmwHMYw2z/k4X9yi
         PK8173e+xuPO2hoKz8ZUdl0WKl+M0ff2SLbEflw2T3bI7htu0dSzMxWCzaQAhkfON8Ie
         HpcLG4AL4/9eemfMGqs5rbEAk23SCgkftpyupT2D3y8I9WP2jocHyfKk2eX4EOl+fLvZ
         2EWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kxUeKVVNjUYZDEFlDXz16lYFbO6uGbZz83MJ+yrq+To=;
        b=KSeunPhkhDptD/iDHnUUzoheMly+7qKAb2bYct1VLldTBjeI1IKrgO70dvQps5T8+7
         ygCQJx8GdjXx2Eg36bclXpZyixSgnFxR/NrW11dduZKze06sdFpslOzkIPJ241EAvl7a
         G2aLdgW/F4JrL2NpNzN9Lrp0CTj7TQYmIaHuXsdqWhlWyeDcrBbtJ0q3MZFox63/trpw
         5++l4tn4UkB/k27AWQgfEzkVglJ/hOo6dQNushCw+lRd9O1ulTwZufspQcKVWERy1C9i
         4W5dBWe4Yr0hQ6L606EGv8oqv/P1zsHCRa6RHF+DkCBquMPnH+B1HMrSkB0wBuhry+HP
         Dl6g==
X-Gm-Message-State: AOAM533NQaLB8LJ1JA3vj6Ptape9fKPxYe7fshJpT9hbfejk5nF8onN/
        mBznA/O2yzE1FZWR5vJA8wIUrw==
X-Google-Smtp-Source: ABdhPJyZ/4KF3v9mB5K30CB2oFdZiBScDN+hax8YcZ/ybqKog6CYsuD9xkHzq9vg4TQTimguG4A+Gg==
X-Received: by 2002:a05:6e02:20e8:: with SMTP id q8mr5572337ilv.205.1612563069287;
        Fri, 05 Feb 2021 14:11:09 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m15sm4647171ilh.6.2021.02.05.14.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:11:08 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/7] net: ipa: synchronize NAPI only for suspend
Date:   Fri,  5 Feb 2021 16:10:55 -0600
Message-Id: <20210205221100.1738-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210205221100.1738-1-elder@linaro.org>
References: <20210205221100.1738-1-elder@linaro.org>
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

