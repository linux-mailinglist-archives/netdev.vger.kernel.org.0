Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85821C4A69
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 01:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgEDXhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 19:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbgEDXhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 19:37:21 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91500C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 16:37:20 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id l18so582004qtp.0
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 16:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J11alJGda5HaqAUxfI/cdtT9wkZmopm5cF4QPolHp/c=;
        b=a5y9l0J3zaR2uSZcvyFzfQZKffiPpM6RMnsj8/sZhMqDK6pgE9026ML3pIjHZq584Q
         6FlW7TWaxp1uc9NQGjfDVNA6PiG7zj3WZ6O2oj6BAl41IHF8QP+UWCmQhGjCtcaezfuV
         tZEFV2AN+gjtbxD41DDPdVJ5aSmPobkAP9V/XB7mJO06oy/y3H7SWewrX4qtcCWmSzYs
         KW66XBNj1rGvDjOfYhgdYUHi+kUYQqLzIRYga2cKlh4N0Rtr1E9RMFr9t7iBi7B7hpXl
         HA8rZfCRVH1qeSz2BINcXt7gNIQj6jgvc2ISokr0WdCJY8LChZVSwB6uvETjWAvpru3Z
         gulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J11alJGda5HaqAUxfI/cdtT9wkZmopm5cF4QPolHp/c=;
        b=UOSHS0+Bpo+rrf6KnqJbCWGhAR22OaZNJ4RzN7Rkq/OqNVFzlfGCHcN811QwjIx5PR
         uClhnUwx0KDDkEg3/2Y7LFX5pbyiil49/md2DTX7bf1x82J3hI6tCfHl3Vnf3XnVXRIU
         FwzhJgff0zhjL/Iqtejy+BuEinRyu2zuTiSJClxhWFPE5MLWlN5vGcIzFM7E/rUyePhE
         sfScd/Vixxqj18nAZpnqrteOlicVAka9YgrjWkSiy3qzcrEAT/R8ssfLqrOq5FZ2NjOt
         jgTcCEa20y9To1JRAW55e3/U7nGQYmUA38EU+i0W17oo87pibPar9RjBg0tFbQLyrIZb
         McnA==
X-Gm-Message-State: AGi0PuYOqyd/q6/lonAathOQApM2gqg8WlkEbWw/sgCm18e8WWkdVM37
        xAnSnXECFM0rYMryhZuyHcZeDw==
X-Google-Smtp-Source: APiQypLhwk6BWUyml3LuTvS3m1RTo8mByAb6bzwhBhE/9FMy8E00f1S2PfWWFO6KS9Otk0PZjnanBw==
X-Received: by 2002:ac8:65d4:: with SMTP id t20mr26926qto.358.1588635439718;
        Mon, 04 May 2020 16:37:19 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x125sm494311qke.34.2020.05.04.16.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 16:37:19 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/3] net: ipa: have ipa_endpoint_init_ctrl() return previous state
Date:   Mon,  4 May 2020 18:37:11 -0500
Message-Id: <20200504233713.16954-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200504233713.16954-1-elder@linaro.org>
References: <20200504233713.16954-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change ipa_endpoint_init_ctrl() so it returns the previous state
(whether suspend or delay mode was enabled) rather than indicating
whether the request caused a change in state.  This makes it easier
to understand what's happening where called.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 6de03be28784..ad72adff653e 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -284,11 +284,12 @@ static struct gsi_trans *ipa_endpoint_trans_alloc(struct ipa_endpoint *endpoint,
 /* suspend_delay represents suspend for RX, delay for TX endpoints.
  * Note that suspend is not supported starting with IPA v4.0.
  */
-static int
+static bool
 ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_delay)
 {
 	u32 offset = IPA_REG_ENDP_INIT_CTRL_N_OFFSET(endpoint->endpoint_id);
 	struct ipa *ipa = endpoint->ipa;
+	bool state;
 	u32 mask;
 	u32 val;
 
@@ -296,13 +297,14 @@ ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_delay)
 	mask = endpoint->toward_ipa ? ENDP_DELAY_FMASK : ENDP_SUSPEND_FMASK;
 
 	val = ioread32(ipa->reg_virt + offset);
-	if (suspend_delay == !!(val & mask))
-		return -EALREADY;	/* Already set to desired state */
+	/* Don't bother if it's already in the requested state */
+	state = !!(val & mask);
+	if (suspend_delay != state) {
+		val ^= mask;
+		iowrite32(val, ipa->reg_virt + offset);
+	}
 
-	val ^= mask;
-	iowrite32(val, ipa->reg_virt + offset);
-
-	return 0;
+	return state;
 }
 
 /* Enable or disable delay or suspend mode on all modem endpoints */
@@ -1164,8 +1166,7 @@ static int ipa_endpoint_reset_rx_aggr(struct ipa_endpoint *endpoint)
 
 	/* Make sure the channel isn't suspended */
 	if (endpoint->ipa->version == IPA_VERSION_3_5_1)
-		if (!ipa_endpoint_init_ctrl(endpoint, false))
-			endpoint_suspended = true;
+		endpoint_suspended = ipa_endpoint_init_ctrl(endpoint, false);
 
 	/* Start channel and do a 1 byte read */
 	ret = gsi_channel_start(gsi, endpoint->channel_id);
@@ -1318,21 +1319,20 @@ static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
 	if (endpoint->toward_ipa) {
 		bool delay_mode = endpoint->data->tx.delay;
 
-		ret = ipa_endpoint_init_ctrl(endpoint, delay_mode);
 		/* Endpoint is expected to not be in delay mode */
-		if (!ret != delay_mode) {
+		if (ipa_endpoint_init_ctrl(endpoint, delay_mode))
 			dev_warn(dev,
 				"TX endpoint %u was %sin delay mode\n",
 				endpoint->endpoint_id,
 				delay_mode ? "already " : "");
-		}
 		ipa_endpoint_init_hdr_ext(endpoint);
 		ipa_endpoint_init_aggr(endpoint);
 		ipa_endpoint_init_deaggr(endpoint);
 		ipa_endpoint_init_seq(endpoint);
 	} else {
+		/* Endpoint is expected to not be suspended */
 		if (endpoint->ipa->version == IPA_VERSION_3_5_1) {
-			if (!ipa_endpoint_init_ctrl(endpoint, false))
+			if (ipa_endpoint_init_ctrl(endpoint, false))
 				dev_warn(dev,
 					"RX endpoint %u was suspended\n",
 					endpoint->endpoint_id);
@@ -1471,7 +1471,7 @@ void ipa_endpoint_resume_one(struct ipa_endpoint *endpoint)
 	/* IPA v3.5.1 doesn't use channel start for resume */
 	start_channel = endpoint->ipa->version != IPA_VERSION_3_5_1;
 	if (!endpoint->toward_ipa && !start_channel)
-		WARN_ON(ipa_endpoint_init_ctrl(endpoint, false));
+		WARN_ON(!ipa_endpoint_init_ctrl(endpoint, false));
 
 	ret = gsi_channel_resume(gsi, endpoint->channel_id, start_channel);
 	if (ret)
-- 
2.20.1

