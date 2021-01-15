Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8152F7A98
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 13:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388414AbhAOMvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 07:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387742AbhAOMvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 07:51:40 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6C2C061796
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:50:56 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id e22so17831407iom.5
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HRs/Iw+fbNuG8BHg7jc2ZIXfDTbwOS1IIxrJncMvSjg=;
        b=vdAI/v/v3LmO73rs7BW4NJVaNk7yg1dQ8bxJJzj22+Vp4S361PRxFY0sNlgk5FAQZM
         xjuPwlEScjBhwGakNasyqKq+aUY7z6EzW6jaUEE+zmKn13gjDDxBw3yIRSolzxU4fkS/
         XAmnuyimEbNkvM7Y3DOyiA5yIJsoeniAj+Djc7GEu5joK69d+NEcyCKsFDUED3qZ+8ty
         O4Ex/Pb+Aw4X0gFyhJrrRGrNN6ySjNubAMO2g9ALqN5nQfzjVXiUUvmTVgewFeDsPHwe
         FfpuEn97l0rPXPNMWHtIfW3dGosKFGLvxXAQOM88j6RBnMR6A4O4gAKh4A9HZaixo/H8
         ZjZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HRs/Iw+fbNuG8BHg7jc2ZIXfDTbwOS1IIxrJncMvSjg=;
        b=L1BZzo5JY3xdHiW29Sh2uOJRc0rcpqn9kXOBlJB03Dxrne74lRFhAhO0RF9alnwAuU
         hjmJMLtcV5LwRpk3qu22R3IT6h0M0kUBKpjUejwqWbv7pZ/CwTCy0Q9xsS9nSsn13r8k
         m9yxHBjpjl0KD0DKc0KgV8T0EiXQbDhOQbTmYOHFL/G6kq2xPYHIN2XK0pNBlTlMOTNP
         q7YvOcYPy8VDX6O5K9xq7/wI7ZJhL4SaYlVAzhsRvje4M2TfdIAPPCThv5vBKMoVGzko
         goPi3WWV3CkQByHg5mU2qgVy0CKrDgwjxYU9mOoPC5XBKHKcirn8snCMc7dv+LZkw5na
         HdSw==
X-Gm-Message-State: AOAM533gH9ybjU1J+2QNIcp6pTY4ReUYh9jFt+EjOaO81S+EYVC17Dsv
        mCUE3iYy9xgJfqxeZ/eejsKArA==
X-Google-Smtp-Source: ABdhPJwD8SHUlItoDEVDMzPNd2f5xs18pT2Era3KTeFnsDMcbKI1/bvyDFawqmdv3L6EZ8EYv+CCIA==
X-Received: by 2002:a05:6e02:1a25:: with SMTP id g5mr10740701ile.2.1610715055898;
        Fri, 15 Jan 2021 04:50:55 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f13sm3952450iog.18.2021.01.15.04.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 04:50:55 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/7] net: ipa: don't return an error from ipa_interconnect_disable()
Date:   Fri, 15 Jan 2021 06:50:45 -0600
Message-Id: <20210115125050.20555-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210115125050.20555-1-elder@linaro.org>
References: <20210115125050.20555-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If disabling interconnects fails there's not a lot we can do.  The
only two callers of ipa_interconnect_disable() ignore the return
value, so just give the function a void return type.

Print an error message if disabling any of the interconnects is not
successful.  Return (and print) only the first error seen.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index 459c357e09678..baedb481fe824 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -137,36 +137,27 @@ static int ipa_interconnect_enable(struct ipa *ipa)
 }
 
 /* To disable an interconnect, we just its bandwidth to 0 */
-static int ipa_interconnect_disable(struct ipa *ipa)
+static void ipa_interconnect_disable(struct ipa *ipa)
 {
-	const struct ipa_interconnect_data *data;
 	struct ipa_clock *clock = ipa->clock;
+	int result = 0;
 	int ret;
 
 	ret = icc_set_bw(clock->memory_path, 0, 0);
 	if (ret)
-		return ret;
+		result = ret;
 
 	ret = icc_set_bw(clock->imem_path, 0, 0);
-	if (ret)
-		goto err_memory_path_reenable;
+	if (ret && !result)
+		result = ret;
 
 	ret = icc_set_bw(clock->config_path, 0, 0);
-	if (ret)
-		goto err_imem_path_reenable;
+	if (ret && !result)
+		result = ret;
 
-	return 0;
-
-err_imem_path_reenable:
-	data = &clock->interconnect_data[IPA_INTERCONNECT_IMEM];
-	(void)icc_set_bw(clock->imem_path, data->average_bandwidth,
-			 data->peak_bandwidth);
-err_memory_path_reenable:
-	data = &clock->interconnect_data[IPA_INTERCONNECT_MEMORY];
-	(void)icc_set_bw(clock->memory_path, data->average_bandwidth,
-			 data->peak_bandwidth);
-
-	return ret;
+	if (result)
+		dev_err(&ipa->pdev->dev,
+			"error %d disabling IPA interconnects\n", ret);
 }
 
 /* Turn on IPA clocks, including interconnects */
@@ -189,7 +180,7 @@ static int ipa_clock_enable(struct ipa *ipa)
 static void ipa_clock_disable(struct ipa *ipa)
 {
 	clk_disable_unprepare(ipa->clock->core);
-	(void)ipa_interconnect_disable(ipa);
+	ipa_interconnect_disable(ipa);
 }
 
 /* Get an IPA clock reference, but only if the reference count is
-- 
2.20.1

