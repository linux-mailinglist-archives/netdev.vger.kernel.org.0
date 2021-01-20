Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BFB2FDC50
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 23:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391323AbhATWUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 17:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732380AbhATWEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 17:04:47 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493EAC0613C1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 14:04:06 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id q2so48408555iow.13
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 14:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G8bjLZpoNIzOiv6PkD0iZ3h3ctPEFqZsMrd34LvNS2U=;
        b=UvCG+u3bGXVwyyD6UipJdy59reXyhCEho2eMjnMo5G8z6oh4dgT2/G1U944jKepyab
         z8zdrAJF1cSdiHNvJZIDAqxrVa+aRomeBSidiQBmTfeh6ctFMyhWhGFl+IYk+JBvnKsi
         AM1gvKgz+XlHhczG3CoFQn3b1Nr5no2eWuCUkuGVqoCZNegWtLCBu7Cwo1QGWqZ/oAIN
         UvZ8WxUU6+6SR0fs/351LMBz3woLCx2zytckX4jSdvbzAwXR6SIJRmDTExdHF1sAp4c6
         M2hGO9yFXevkrI8NajRnBcTrak2KiyV3GiXQq7qbaTDaUAOaDfJ6PHlxMwL8/LbCkUxD
         noww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G8bjLZpoNIzOiv6PkD0iZ3h3ctPEFqZsMrd34LvNS2U=;
        b=V+BX/pnUKCVnciJpRD8Zoy8FyXkT0x/GbEBjhZHZ0E/FXzi6+AS7cECpZM/WJWVaob
         PErZEqGyHNUhN+sEqzNN8b1V2SrNAfYFIZ5csCoQqYTIJq7EYh+vpKuxAV3GcByUDkFs
         qmSjhITlbUYC40YzAxwQ+riHAjl4b/QzKt3f3X5lRq8RmsXwKpM0VLjEUrzCCb00L0Dm
         Wy4Ibb4eORUju2S/F9MQFRC6dYVKi/8z+yCvFnX1dDtrBSZjn1QI1RYrH09Ordzfg9IQ
         JPhU1NDVEa00PQLDfxrxuApt2hc6PkCaQftgJSF3gJi3pyYpFXbwOLG2JjNkBhaqEkzD
         pmDQ==
X-Gm-Message-State: AOAM531v0NJo57TUzT6UusjYEc+tJpDkA4JcGNH5uFX0rPkOb1SRLzMm
        s++aLlIOVg37tkidgMuCvkFDmA==
X-Google-Smtp-Source: ABdhPJyAXoH/w1J4pscBIxjrb8Tszzb7pGVu+G6RSmmehuNR+9E1aWhEU/T25M4+vOv1p/lVxvO1Vw==
X-Received: by 2002:a05:6638:204b:: with SMTP id t11mr9300584jaj.87.1611180245665;
        Wed, 20 Jan 2021 14:04:05 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id e5sm1651712ilu.27.2021.01.20.14.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 14:04:05 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/5] net: ipa: count actual work done in gsi_channel_poll()
Date:   Wed, 20 Jan 2021 16:03:57 -0600
Message-Id: <20210120220401.10713-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210120220401.10713-1-elder@linaro.org>
References: <20210120220401.10713-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is an off-by-one problem in gsi_channel_poll().  The count of
transactions completed is incremented each time through the loop
*before* determining whether there is any more work to do.  As a
result, if we exit the loop early the counter its value is one more
than the number of transactions actually processed.

Instead, increment the count after processing, to ensure it reflects
the number of processed transactions.  The result is more naturally
described as a for loop rather than a while loop, so change that.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 5b29f7d9d6ac1..56a5eb61b20c4 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1543,13 +1543,12 @@ static struct gsi_trans *gsi_channel_poll_one(struct gsi_channel *channel)
 static int gsi_channel_poll(struct napi_struct *napi, int budget)
 {
 	struct gsi_channel *channel;
-	int count = 0;
+	int count;
 
 	channel = container_of(napi, struct gsi_channel, napi);
-	while (count < budget) {
+	for (count = 0; count < budget; count++) {
 		struct gsi_trans *trans;
 
-		count++;
 		trans = gsi_channel_poll_one(channel);
 		if (!trans)
 			break;
-- 
2.20.1

