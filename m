Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721A82FDC7C
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 23:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbhATWWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 17:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732539AbhATWFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 17:05:52 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEDDC0613D6
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 14:04:07 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id q2so48408784iow.13
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 14:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m6e39kAfCJQxvEQdmc/oDMA8MTPHe7FkK1dKGoyuSSk=;
        b=RuFJt40Bsvi4BGgD5V5q75wwLL3L8641PLjoyA1Fp6sg7tYB3PzTkSBsMhAztSa998
         meXPzBJ/77nnux+LN6kNpyY/PUhxQpwXC2PvL3w0aVOd50/2X7ro2rc5Bsj3zpa2Azv0
         tzGxaNBNyoIXu3NkVs7sPrQy1NdkEAdiES17xTELjUT8j8sAin9rvtyEkAGpu5fjpyYr
         r5ZKEOYQF8w2E8ra2eKRFeD81MS1mcIgKMXR2enn2zWIFDDFIpxlytbVr4wvfIkUfSMV
         1OHyCzINb8bpxn17IhFLOQNuMzA3ZWjGKoo2J1TSEzeUGZslrfA/O+/3IYjXhqWlWNum
         h1QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m6e39kAfCJQxvEQdmc/oDMA8MTPHe7FkK1dKGoyuSSk=;
        b=m+3Sr6mzDGVZmiSSlLjJWzv+wvSq6yZIo9XHsR5UgYlLEGVK5acduzhS11Me4oiUVO
         47Edr5GpEBbDqmeqjVyKyC6tH9KkMSoueWAUyZlTdVb4/pBR2zB7h7tpgthZHcUciJSl
         Sen1+DLNKSv8KNTYanS3uVPTuJKXcTzKLRZDfDvdUBVGSl3ykn2PD9m6uli5yXSpF4jI
         n+NWYIpHlR6ENRrxwLf6vbQa2tzBQSH4xvi/HQtPS+C8pOoIdf6M1S+kCjDxi0cEqEez
         uLy8c2SptrP/0uHxbRP1CKpl6LGcGAfNQWNx1SQ+BZMJl4bLe/+z3n+XCyutXNDhFpq8
         0Y/w==
X-Gm-Message-State: AOAM532L/jSUMCjgGl/Olb7ZY1njsNtfKEoXvkCrWu3pJjrjaYvBg8Is
        sefZP6K0ZU5b8VBWc//aRzNFHg==
X-Google-Smtp-Source: ABdhPJwkjE5zJvRR8SO/cIvcp0SEHkTh4NdnRvP8yoUJ2pCUdXvwIqjEP5TozrfJ4cLd7ZWxlUQ3ww==
X-Received: by 2002:a05:6e02:1110:: with SMTP id u16mr9987227ilk.73.1611180246798;
        Wed, 20 Jan 2021 14:04:06 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id e5sm1651712ilu.27.2021.01.20.14.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 14:04:06 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/5] net: ipa: heed napi_complete() return value
Date:   Wed, 20 Jan 2021 16:03:58 -0600
Message-Id: <20210120220401.10713-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210120220401.10713-1-elder@linaro.org>
References: <20210120220401.10713-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pay attention to the return value of napi_complete(), completing
polling only if it returns true.

Just use napi rather than &channel->napi as the argument passed to
napi_complete().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 56a5eb61b20c4..634f514e861e7 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1555,10 +1555,8 @@ static int gsi_channel_poll(struct napi_struct *napi, int budget)
 		gsi_trans_complete(trans);
 	}
 
-	if (count < budget) {
-		napi_complete(&channel->napi);
+	if (count < budget && napi_complete(napi))
 		gsi_irq_ieob_enable(channel->gsi, channel->evt_ring_id);
-	}
 
 	return count;
 }
-- 
2.20.1

