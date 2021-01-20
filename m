Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C647A2FDC8F
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 23:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731271AbhATWXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 17:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732554AbhATWFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 17:05:53 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86EDC061786
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 14:04:08 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id q2so48408957iow.13
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 14:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WBNzWrwjXuW0OAZcNNJPMhiWPrYSOE7uMer+o1tBWxs=;
        b=EopezSHSVJS84vNTnBHTbyonlclmvUvfJvafozzWmFDq8oERl7Rd97ZWIBpgxCUVaH
         FshlYUyQijgsnIG0dw7TV5JiBXErk4Nd4nhJzHix2Y7y+R+jawVu0DfUwZbNo1fBELzh
         I3ODwK7clViV6d2nW8Zgk5oLWMKOL02X6RPsWVipC1SLcsuWCrIPi6pZIsMU0x+4V6bs
         5FgAFo8qdCdu5Wv1zM1H7ac9qNXz7aysQs0gfzZjBMXx2L9XE22BAGDCyCZ4bsX6kkDc
         N+MGkp9MajWZ3iH2jt7ui2xPHBOHq2W+GHgAdoPmSenGO9RJLEcBTUtDPd3wvtzENQKs
         K7Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WBNzWrwjXuW0OAZcNNJPMhiWPrYSOE7uMer+o1tBWxs=;
        b=rgg0NTxln0Cqx0RHIaSCnVdf6DRFar6pmTzreRIFGY9mub+4lgg7n26SCeP9BRXnjO
         3bAEIjvLX80hvAZfm8rlGHPuJ/JVF1IBEowk5B9+txMa9/bMAWxv1bwlRRvQDzUQpjUf
         dH4bXucnx4LUsazcO981Zl8od0nvOGk+XK/j6fur2j0pG9Q1xXc2VRoePtvj0a1p5h2J
         IRQnFTrWM+/s9RoJ50iK/px9QPEimJ3LGXMqlQWVn0nuOinLcgWc2sFIv3XT9YyoQj6c
         LepSO4WX6XUOC5sVDrRNA9zjKPZmZV3b6nI4Mo64D6di4jWbmwWWC0tdHWGiLKKKPdCI
         nFxA==
X-Gm-Message-State: AOAM531Rhj+LBPZNUWHM4a9ZRGwc666gbdzRM7suE8zF5pCI53B8g8iM
        lo0gURbN/SpJv5bkD4q9hGo/aQ==
X-Google-Smtp-Source: ABdhPJyXk/yZF5rrvpZFab/sAJ1PvNzVK3kfc6OYJ58TgTzoBF5PRQZzH3Hdlo1ayutQoxeNo97vGw==
X-Received: by 2002:a02:52c8:: with SMTP id d191mr9443168jab.59.1611180248061;
        Wed, 20 Jan 2021 14:04:08 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id e5sm1651712ilu.27.2021.01.20.14.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 14:04:07 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/5] net: ipa: have gsi_channel_update() return a value
Date:   Wed, 20 Jan 2021 16:03:59 -0600
Message-Id: <20210120220401.10713-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210120220401.10713-1-elder@linaro.org>
References: <20210120220401.10713-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Have gsi_channel_update() return the first transaction in the
updated completed transaction list, or NULL if no new transactions
have been added.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 634f514e861e7..5b98003263710 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1452,7 +1452,7 @@ void gsi_channel_doorbell(struct gsi_channel *channel)
 }
 
 /* Consult hardware, move any newly completed transactions to completed list */
-static void gsi_channel_update(struct gsi_channel *channel)
+struct gsi_trans *gsi_channel_update(struct gsi_channel *channel)
 {
 	u32 evt_ring_id = channel->evt_ring_id;
 	struct gsi *gsi = channel->gsi;
@@ -1471,7 +1471,7 @@ static void gsi_channel_update(struct gsi_channel *channel)
 	offset = GSI_EV_CH_E_CNTXT_4_OFFSET(evt_ring_id);
 	index = gsi_ring_index(ring, ioread32(gsi->virt + offset));
 	if (index == ring->index % ring->count)
-		return;
+		return NULL;
 
 	/* Get the transaction for the latest completed event.  Take a
 	 * reference to keep it from completing before we give the events
@@ -1496,6 +1496,8 @@ static void gsi_channel_update(struct gsi_channel *channel)
 	gsi_evt_ring_doorbell(channel->gsi, channel->evt_ring_id, index);
 
 	gsi_trans_free(trans);
+
+	return gsi_channel_trans_complete(channel);
 }
 
 /**
@@ -1516,11 +1518,8 @@ static struct gsi_trans *gsi_channel_poll_one(struct gsi_channel *channel)
 
 	/* Get the first transaction from the completed list */
 	trans = gsi_channel_trans_complete(channel);
-	if (!trans) {
-		/* List is empty; see if there's more to do */
-		gsi_channel_update(channel);
-		trans = gsi_channel_trans_complete(channel);
-	}
+	if (!trans)	/* List is empty; see if there's more to do */
+		trans = gsi_channel_update(channel);
 
 	if (trans)
 		gsi_trans_move_polled(trans);
-- 
2.20.1

