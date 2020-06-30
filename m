Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B2820F4F3
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387898AbgF3MpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387853AbgF3Mov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:44:51 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6909C03E97B
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 05:44:50 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id y2so20819514ioy.3
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 05:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9XdXmEjc3ZwKGIQrLtpyxFD/vzTwMpcwaLUBfSuIMks=;
        b=To/SEc0bC6K5+5p1yxkI48vyuR9vyavYUd62qJak98IF5Cj2h4nl0ExdB4WrvzeHvq
         biXJNGpar5EZMpHnAVLlHdMofF3GgW6C88xEU013SGCPXEbsQu/2dY6rEnYrntMHpoCx
         ir2/jmSRJD4r4olvYJUOCeq2y31mCJw4EnyEkkDslgAsfxV/bPGDbgJV5iv6x2ld08Ux
         vF/HL0hG/uTv741vc1hwBA757qU2ppmmISgFnjdL/PwEm2N5ZATx9WjWIP2kbILGZlVT
         4NaV86nAxp0C3MceWBtIu3bit/GL0M0hI6d9lRetlGzlth5NxUHmmw6DAAKDkoqpgIRR
         IaaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9XdXmEjc3ZwKGIQrLtpyxFD/vzTwMpcwaLUBfSuIMks=;
        b=Lj98PFTxhXDl54oh+9P67AFEYmtY2msyRSbyQvuB6HAItWQ3ooohRNuTUq7hXIBsyI
         Wq7IQWH4JYDoUxQ73O6Iknb3nV7uGlItsmLnONM1yzAU6KZQo6mI/oC+2UiODnIhuR0U
         1TUoE188E/8v0gSGdGfJCBFTlGFXfvOCmlcwFH0JOflnpStkm6epH1GxFPgZ2xLuO+dx
         qih7cigx3adqEU5lkZIkwYlyaDKyM/PlOJaaLXeVFDApYRRghiqvc+AUD/FWk1B9zyev
         hDeTXLmV8aKFBXv0W5y0g/WP+Qc54h/s7VJawDFA5IBDn7bWgeBGfDw6qGtezzJVuSaw
         gkZg==
X-Gm-Message-State: AOAM530WdBDSm0aWu01ZElQUumTzYoNQii9VRAnIDq42AjUCYQI6etfU
        x19vsR64eGRNaNiemhAV0kIQTg==
X-Google-Smtp-Source: ABdhPJxjNs/FtGnrNWqgPpHIjo8ZjRElnwHel/kBOvAF+tLkynJCMt1H5qt+rKW27VbYZt7/DFP4QQ==
X-Received: by 2002:a02:cb92:: with SMTP id u18mr351945jap.143.1593521088996;
        Tue, 30 Jun 2020 05:44:48 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id t83sm1697536ilb.47.2020.06.30.05.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 05:44:48 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 1/3] net: ipa: always check for stopped channel
Date:   Tue, 30 Jun 2020 07:44:42 -0500
Message-Id: <20200630124444.1240107-2-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200630124444.1240107-1-elder@linaro.org>
References: <20200630124444.1240107-1-elder@linaro.org>
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

Fixes: 650d1603825d ("soc: qcom: ipa: the generic software interface")
Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: Added "Fixes" tag.

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

