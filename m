Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8D520E411
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732646AbgF2VUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732287AbgF2VUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 17:20:43 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A13DC061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:20:43 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id f6so3160733ioj.5
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5NzyDp4mBovD0FjYRR3tCmdZlivRdkEwWwtmv1riTuY=;
        b=HamVpoW1/0IkR9G49C+/CBrniF24a3GIZ9p6TtnYlbSO4Jpx8uu5WJQGFRbkvKSq8+
         j6kHhPKvjPGELtsFcvX674UMr9vz1yt16f77C9fqv3dSurKPtFE28qBjLKqruB7Xho2X
         tdlAVlQJ8FrLryNHSqhfuXOSG72GQYAucZyrHocMCCzVbIpl1LfYZfpUIxUpkfrxIHPW
         b2iUXuTJqVakaOT/xk2KnXKL9hh6lMOoKk5FYHtdHBmftDgFtgePg8K8CguTarT7UImA
         uEem5KM/ZKPBDW6O4Gpn1aoLYlJzQ3N/jjs+rPwztmOdvXYJ3bN/6sRaReYvD/dMZOWF
         YpWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5NzyDp4mBovD0FjYRR3tCmdZlivRdkEwWwtmv1riTuY=;
        b=RqZ8PgUNjGZq/vAH7Md84bnN7cVvy2mUvAlimijAOi5HtVOokt6yqi95wFH+0DFZ9c
         tAcECF7AkhI5n84ARBHL3lpBvAhmWBB2hOve3bEYkLs1Zi/SVC5NN93Btb2p+TwPpFUJ
         QoE1U7KfRyTJMyOI/yqNVKCJBWzIGGBg0553NtJv2Js7hOE5SBM9lenpmZjmreyvvVo1
         V/5DQ9iGhMCWmBqyIsHy/jzyeYbpqIdWUeJmEuQasLNN6BUqc5phc7JjqGiKd5phEthk
         rgoS8Ajcc8RkIReDaaZWQ7FK/kGbyFluuTVLVYEFX7hghJ4Ze7NpNer1ulIDVBqU8/Rm
         hlwQ==
X-Gm-Message-State: AOAM532s+MJZxE21aTj6Q3XrseZxN6tTvjI1ixubjkaWY5SmJjb4XGR5
        Mwplvgur+4d+h/EsageX8bk4vQ==
X-Google-Smtp-Source: ABdhPJxvNitkIu0iE4zz7boXfb9eCDNNtZDZcvpcxTVgpXrBh0jYQMvaTJ9iT7sBkjWuhlLVyitA6A==
X-Received: by 2002:a05:6602:134d:: with SMTP id i13mr19247613iov.113.1593465642955;
        Mon, 29 Jun 2020 14:20:42 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f18sm564588ilj.15.2020.06.29.14.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 14:20:42 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 1/3] net: ipa: always check for stopped channel
Date:   Mon, 29 Jun 2020 16:20:36 -0500
Message-Id: <20200629212038.1153054-2-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629212038.1153054-1-elder@linaro.org>
References: <20200629212038.1153054-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In gsi_channel_stop(), there's a check to see if the channel might
have entered STOPPED state since a previous call, which might have
timed out before stopping completed.

That check actually belongs in gsi_channel_stop_command(), which is
called repeatedly by gsi_channel_stop() for RX channels.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 55226b264e3c..ac7e5a04c8ac 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -500,6 +500,13 @@ static int gsi_channel_stop_command(struct gsi_channel *channel)
 	int ret;
 
 	state = gsi_channel_state(channel);
+
+	/* Channel could have entered STOPPED state since last call
+	 * if it timed out.  If so, we're done.
+	 */
+	if (state == GSI_CHANNEL_STATE_STOPPED)
+		return 0;
+
 	if (state != GSI_CHANNEL_STATE_STARTED &&
 	    state != GSI_CHANNEL_STATE_STOP_IN_PROC)
 		return -EINVAL;
@@ -789,20 +796,11 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
 int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
-	enum gsi_channel_state state;
 	u32 retries;
 	int ret;
 
 	gsi_channel_freeze(channel);
 
-	/* Channel could have entered STOPPED state since last call if the
-	 * STOP command timed out.  We won't stop a channel if stopping it
-	 * was successful previously (so we still want the freeze above).
-	 */
-	state = gsi_channel_state(channel);
-	if (state == GSI_CHANNEL_STATE_STOPPED)
-		return 0;
-
 	/* RX channels might require a little time to enter STOPPED state */
 	retries = channel->toward_ipa ? 0 : GSI_CHANNEL_STOP_RX_RETRIES;
 
-- 
2.25.1

