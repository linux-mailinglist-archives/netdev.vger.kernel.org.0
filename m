Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CEE2B9DD0
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgKSWti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbgKSWti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:49:38 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D585DC0617A7
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:49:37 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id m13so7910302ioq.9
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UGA7hgxTj0rrDkTjuJWFChVaqNnZoVILxCFPrIN84nI=;
        b=NQbMDdelo5Ak8qfJjinOe8675xff8rg5+KFkXVIYJqLnTX9kg0NWl10hz/xqZTVJXA
         NXNF0RFvkBuFCodcsLLxrSJdFYPbK619yl/hFkfs+WRlN5fb/B7bW89Xr313BLMMYrl0
         G++NC8fckKH90eoeMd559KAVjr6KCT+Zu38rE873ge+I4On1PhF236/8x8OOcsBTH2o1
         OyXNX9A9I0FRsojg30POMKyImar2XyizOloU/291OQzksz2iFtBKa68PaJgD9xR184cl
         nJd3MOjB/QQnWWtlcGDrAO7ODX8lXbnBf6i2AcA90UvZIjIuf/sRkeDyCdaysQytDlFv
         DKiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UGA7hgxTj0rrDkTjuJWFChVaqNnZoVILxCFPrIN84nI=;
        b=OSimIIURQn8dNGJ0QOBi7jGwv+smYX1JTWe2MTgBVspRzzc2uX0f0L8jJQ6LwohOSf
         c5cw19oj9mG6EIuSjGKZy7COi6JPr2n+ma0YzMHksRdKF3wgYRP64wtt7pnCk9kluOad
         20C9rcC58MoT05tvrDOJqbdcd8Ev0j/sc27ftT55HT3uCpSnUrQL3CwKxk6qC1UUz2bS
         BKUiqZ3maHdU8MPBmews3gvb3TPrzNk4uMeAfFgA1+qml/IR02hk3ZrgyRw9ddK+kj+D
         1/ssisYdMU6m4EqQsl7hqRGhWUQw4fqY3I1ghCpBCTTL0pjlSOHL4LR4f+Cg+Y97rKUC
         WqdQ==
X-Gm-Message-State: AOAM532NdacGXD/QQ0PKjDX6zm1aVql+EJYYieKMR0MsUwnic22yvx94
        cKSFNnzFkUZECGPLrNVDh5QOmXU4YdgtXg==
X-Google-Smtp-Source: ABdhPJyqAGnNIngptG2cXBNFx3CSA4orgUA+1eJKEDHqTVLGzO9ufqatp0m0RX5nsZe6h8MJko5sQQ==
X-Received: by 2002:a05:6638:124f:: with SMTP id o15mr16247013jas.40.1605826177177;
        Thu, 19 Nov 2020 14:49:37 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id i3sm446532iom.8.2020.11.19.14.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 14:49:36 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] net: ipa: ignore CHANNEL_NOT_RUNNING errors
Date:   Thu, 19 Nov 2020 16:49:26 -0600
Message-Id: <20201119224929.23819-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201119224929.23819-1-elder@linaro.org>
References: <20201119224929.23819-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA v4.2 has a hardware quirk that requires the AP to allocate GSI
channels for the modem to use.  It is recommended that these modem
channels get stopped (with a HALT generic command) by the AP when
its IPA driver gets removed.

The AP has no way of knowing the current state of a modem channel.
So when the IPA driver issues a HALT command it's possible the
channel is not running, and in that case we get an error indication.
This error simply means we didn't need to stop the channel, so we
can ignore it.

This patch adds an explanation for this situation, and arranges for
this condition to *not* report an error message.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 58bec70db5ab4..7c2e820625590 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1087,10 +1087,32 @@ static void gsi_isr_gp_int1(struct gsi *gsi)
 	u32 result;
 	u32 val;
 
+	/* This interrupt is used to handle completions of the two GENERIC
+	 * GSI commands.  We use these to allocate and halt channels on
+	 * the modem's behalf due to a hardware quirk on IPA v4.2.  Once
+	 * allocated, the modem "owns" these channels, and as a result we
+	 * have no way of knowing the channel's state at any given time.
+	 *
+	 * It is recommended that we halt the modem channels we allocated
+	 * when shutting down, but it's possible the channel isn't running
+	 * at the time we issue the HALT command.  We'll get an error in
+	 * that case, but it's harmless (the channel is already halted).
+	 *
+	 * For this reason, we silently ignore a CHANNEL_NOT_RUNNING error
+	 * if we receive it.
+	 */
 	val = ioread32(gsi->virt + GSI_CNTXT_SCRATCH_0_OFFSET);
 	result = u32_get_bits(val, GENERIC_EE_RESULT_FMASK);
-	if (result != GENERIC_EE_SUCCESS)
+
+	switch (result) {
+	case GENERIC_EE_SUCCESS:
+	case GENERIC_EE_CHANNEL_NOT_RUNNING:
+		break;
+
+	default:
 		dev_err(gsi->dev, "global INT1 generic result %u\n", result);
+		break;
+	}
 
 	complete(&gsi->completion);
 }
-- 
2.20.1

