Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6683B2EE7C1
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 22:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbhAGVoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 16:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbhAGVoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 16:44:11 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1137BC0612F9
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 13:43:31 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id u26so7649567iof.3
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 13:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7IjbMJw+DvF3Ni9HvI6FJRuCxFX1OxpBhCEvG7fLR1g=;
        b=RPYiNJs1/tdsdWLCx3Qssr91jNJaxMiV5KMUmZVfgmkXxFzcd/9VV9HMSsbYNCODKR
         1lIPoZiS16R8PHAFJY13nPTPQBpS01UPjXVE51BTr6vp7Y76uBEmjb90plCVmCDlxqBf
         56Oyyz9FNEHAjq9PNsc9jDTVawOpPWf5VmTr3c+Q2bx6oxl3Kc1jVupb/DZvpUVi/Fis
         jyV9SN0Frk6Rhfp3/SFxAA0KTBtBLnLx86wXukdT/c7Zoq/x52LLnpGzqGM57UBxpkKq
         vxbjWtAWThLjA059W/VIxLgya8InS9ktsfr7IdyIoZK6zfWvme9fiKZlPSxKvvpmR4nc
         g8iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7IjbMJw+DvF3Ni9HvI6FJRuCxFX1OxpBhCEvG7fLR1g=;
        b=Z1XS8OI7lTlkUiDbJ1KFQg3Ffo7dyOSjK+wYyv/l8kw3IIplDEMbGUky41z6rDx68M
         NTeigTEfTmCO6D7FbX3LPvxj6om3fKsqbOCkemklVRykbEUuGBYn8khztsQ0dl8aidiV
         C+PIUsPYsr9fZtlpzA0DZRbU61JVX8D/YjK1eA91UVQcHYN8kv1n3v4AFWfZ4+3iNYjm
         /EsvL17CCZS5e3Pi7SdkadpwdY9TEcIWp72/2e2QptHnBo2DWPZ20vCpd2FtyQAocIpj
         dKdpH3VtOUQ9jFVnfYpuuxMGl13v8HJyubSr60XjKNR/xkDm5y6i54kE2HHLk4bpB7v/
         Ef0w==
X-Gm-Message-State: AOAM530CcIefscVdl6WjVNBkfDV4lcMtG4M2LcrPRZVdsW3OlEFwwDu1
        6kbvQDMHvanQG6tB1AYC18gUDA==
X-Google-Smtp-Source: ABdhPJw9rRUTHphDs951CJ4HYU5ddHXe0Jg92Vgu5pYoU/BFBWRnh0BvOQMhyU1YNAnbxzcQ196aHg==
X-Received: by 2002:a05:6638:f92:: with SMTP id h18mr507295jal.118.1610055810384;
        Thu, 07 Jan 2021 13:43:30 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f10sm5218260ilq.64.2021.01.07.13.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 13:43:29 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] net: ipa: introduce atomic channel STOPPING flag
Date:   Thu,  7 Jan 2021 15:43:24 -0600
Message-Id: <20210107214325.7077-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210107214325.7077-1-elder@linaro.org>
References: <20210107214325.7077-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new atomic flag bit to communicate that a channel is
stopping.  At the end of the NAPI poll loop, we normally re-enable
the IEOB interrupt, but now we won't do that if the channel is being
stopped.  This is required for the next patch.

Fixes: 650d1603825d8 ("soc: qcom: ipa: the generic software interface")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 11 ++++++++++-
 drivers/net/ipa/gsi.h |  6 ++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 14d9a791924bf..7e7629902911e 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -739,6 +739,10 @@ static void gsi_channel_freeze(struct gsi_channel *channel)
 {
 	gsi_channel_trans_quiesce(channel);
 
+	/* Don't let the NAPI poll loop re-enable interrupts when done */
+	set_bit(GSI_CHANNEL_FLAG_STOPPING, channel->flags);
+	smp_mb__after_atomic();	/* Ensure gsi_channel_poll() sees new value */
+
 	napi_disable(&channel->napi);
 
 	gsi_irq_ieob_disable(channel->gsi, channel->evt_ring_id);
@@ -749,6 +753,10 @@ static void gsi_channel_thaw(struct gsi_channel *channel)
 {
 	gsi_irq_ieob_enable(channel->gsi, channel->evt_ring_id);
 
+	/* Allow the NAPI poll loop to re-enable interrupts again */
+	clear_bit(GSI_CHANNEL_FLAG_STOPPING, channel->flags);
+	smp_mb__after_atomic();	/* Ensure gsi_channel_poll() sees new value */
+
 	napi_enable(&channel->napi);
 }
 
@@ -1536,7 +1544,8 @@ static int gsi_channel_poll(struct napi_struct *napi, int budget)
 
 	if (count < budget) {
 		napi_complete(&channel->napi);
-		gsi_irq_ieob_enable(channel->gsi, channel->evt_ring_id);
+		if (!test_bit(GSI_CHANNEL_FLAG_STOPPING, channel->flags))
+			gsi_irq_ieob_enable(channel->gsi, channel->evt_ring_id);
 	}
 
 	return count;
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 96c9aed397aad..8f0ae97c80c6e 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -104,9 +104,15 @@ enum gsi_channel_state {
 	GSI_CHANNEL_STATE_ERROR			= 0xf,
 };
 
+enum gsi_channel_flag {
+	GSI_CHANNEL_FLAG_STOPPING,
+	GSI_CHANNEL_FLAG_COUNT,		/* Last; not a flag */
+};
+
 /* We only care about channels between IPA and AP */
 struct gsi_channel {
 	struct gsi *gsi;
+	DECLARE_BITMAP(flags, GSI_CHANNEL_FLAG_COUNT);
 	bool toward_ipa;
 	bool command;			/* AP command TX channel or not */
 
-- 
2.20.1

