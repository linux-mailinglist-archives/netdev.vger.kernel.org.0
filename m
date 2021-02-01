Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2EB30ADDB
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhBAR3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbhBAR3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 12:29:37 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966C3C0613ED
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 09:28:57 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id x21so18206468iog.10
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 09:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LCw8t3dNLb85N9LUx0CmQJolraUZfpfFkvo2+8sOa0o=;
        b=YaC0edC7bZatVna8cq1y+F9Li8RsLiT8fGSwnT3dt2Q7EOGwF6UW+kFHEOf4E/+pZN
         Q8UcTWlzxyyi+YYpvCbrhV9MdhBK+dWAviD3Ju19eUoe0U5mJoavcL+6cYKatqkPo/dS
         TB5pDT+qne/Rt6Q7wBYzAcC+H2kRZ//tqPcR2HZLvEOGm3IyL5YXu9IIvymgnn6RGjxF
         LGE1A+QUOjxY4uOGxFLgvrh0mgHH8HT+oQtL9FuhlHaouRqik0s93nhGgD8AB+r/TrMT
         osgYCJiQuILQR5NbzXvBfpbTkpA1h98yTl4jmVvwKxfTQK7FWiuBVAQo6I6XW5JklakQ
         V+pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LCw8t3dNLb85N9LUx0CmQJolraUZfpfFkvo2+8sOa0o=;
        b=bLAPfWywyyjc7YYy518poqlPHll6S2bENVeGst+5H22dXOlGvhu529uM5BQBJzaYNi
         r2RJOIBVms0bqNsFKf8YWUcTWPW0zpK/AN02R48WYX58eA3o1eem6Unpnesn7kva+XRY
         wfkf5xkVDwcDNZ7X25t6nOw+k1XEBjUNyd1X6vco3g7k+3VC22iSMHkhKiTFlddcRrzu
         n5yF4pl8sEvhJAu9G8Zt3S22tgU4bEH59e8Pcr63nm150GbwR9PoMck6yyPEH8t86nU0
         NcZSKNMOgm1CFW0LNzd3B8gTdwLibhqldx82vabk1Z6wNIeVgQAE7bkxmGBeQC6u0/bP
         iaIg==
X-Gm-Message-State: AOAM532fcDWOrdQ4r5QyWV+2vUToaHkCSmZUU0B3bcQazX6Of/zd7aPe
        pcvqvfNpoyJsWzHoKwgX62W2hw==
X-Google-Smtp-Source: ABdhPJygz6UZ1A1FN0ClrkS1VJJIGTbdX1zRTQgIibUf+X2X3PVVnsB45qK3MwD8YzWnlwqWFzJZVQ==
X-Received: by 2002:a5d:9ad4:: with SMTP id x20mr1836777ion.31.1612200537129;
        Mon, 01 Feb 2021 09:28:57 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id v2sm9529856ilj.19.2021.02.01.09.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:28:56 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     willemdebruijn.kernel@gmail.com, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/7] net: ipa: introduce gsi_channel_stop_retry()
Date:   Mon,  1 Feb 2021 11:28:45 -0600
Message-Id: <20210201172850.2221624-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210201172850.2221624-1-elder@linaro.org>
References: <20210201172850.2221624-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new helper function that encapsulates issuing a set of
channel stop commands, retrying if appropriate, with a short delay
between attempts.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 4a3e125e898f6..bd1bf388d9892 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -892,15 +892,12 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
 	return ret;
 }
 
-/* Stop a started channel */
-int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
+static int gsi_channel_stop_retry(struct gsi_channel *channel)
 {
-	struct gsi_channel *channel = &gsi->channel[channel_id];
 	u32 retries = GSI_CHANNEL_STOP_RETRIES;
+	struct gsi *gsi = channel->gsi;
 	int ret;
 
-	gsi_channel_freeze(channel);
-
 	mutex_lock(&gsi->mutex);
 
 	do {
@@ -912,6 +909,19 @@ int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
 
 	mutex_unlock(&gsi->mutex);
 
+	return ret;
+}
+
+/* Stop a started channel */
+int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
+{
+	struct gsi_channel *channel = &gsi->channel[channel_id];
+	int ret;
+
+	gsi_channel_freeze(channel);
+
+	ret = gsi_channel_stop_retry(channel);
+
 	/* Re-thaw the channel if an error occurred while stopping */
 	if (ret)
 		gsi_channel_thaw(channel);
-- 
2.27.0

