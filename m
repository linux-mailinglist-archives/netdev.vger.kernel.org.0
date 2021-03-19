Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C733420E4
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhCSPZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbhCSPY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 11:24:28 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623D3C061764
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:24:28 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id n21so6496139ioa.7
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xYJYAGuBVG/7ONB/rhM70GnjEOT6BjXV95pgDrJwDp0=;
        b=lwt6uFD2dhgNKH5eJUw9QYEi5qXXTX9eGZz2cL5IeA7P9KG7SBeiAvijqhOUkBs1e+
         Mr+iVKGxnVjqTNrmM8wzGec3O10M0yh5n+S0ld0CD+gVTGyk3PygKScxe8bj2hb6Uj8m
         AaDqsaYZHrVRfFvoDYiPJJnutcrRDoyS5Vj2bnNL4o4o/BZfSSa7+sICzM7vVoTBV3yq
         YW/jNZnvr/SepcxzkAftyy//sRVXTsNngqIaUZEigGMjxwR7VyMg1Wbhp3b9W2phwo6W
         aTm3T5wWdAsY4fWgt/HvbZmv5hQfnfJZAz62T8RpJrr26qmPIC4gW68Z/tpxw3ad6DfQ
         iM/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xYJYAGuBVG/7ONB/rhM70GnjEOT6BjXV95pgDrJwDp0=;
        b=XU3nV46PD8xst75LBzBRiqZ0fuV7Bh1Ino9M+T8ZuLRYN3BR+xw+0G/FOZzTNIevyL
         xkv/dz9nHRthW9EhoFcgPeMf9BvnAquDK5ugnX1Tn8FBRquC/b01S08omiI2bXUL70g2
         JeJRA2WeWKst9GD0+SBUQv2KIYPWE5tgHL+bjqat63EFCwnte77yAOC2/4xrOtbUT3/R
         9H5IuQ2/iFR1oDZlLUarkVb4C8aukIYtpi41HPS2xCbpZAsqLI5V3+Yik+uLJwnWpwe2
         1/sszCu0R21KFx2YmhkJdbw+glz37qC8krCWyfhEKcMpMeICt70Uxavk5AmHnC2SPvqg
         BfOw==
X-Gm-Message-State: AOAM531JxJzkX8NPE9x16eIeJDI6v5p3VX8jvwjUS6YtCNRf60v4Gjgn
        GULwo1/FbsaW95e4OAc9ZMc3Uw==
X-Google-Smtp-Source: ABdhPJzLLSLZ23/0Wp/AM5s82fJM8N7NyQhB1sVWrHnOsuDZHPWtwNdOFxaaV2Xn4OxYulSVG9kaHg==
X-Received: by 2002:a02:c8d4:: with SMTP id q20mr1824171jao.90.1616167467914;
        Fri, 19 Mar 2021 08:24:27 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id b5sm2686887ioq.7.2021.03.19.08.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 08:24:27 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/5] net: ipa: don't define empty memory regions
Date:   Fri, 19 Mar 2021 10:24:20 -0500
Message-Id: <20210319152422.1803714-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210319152422.1803714-1-elder@linaro.org>
References: <20210319152422.1803714-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AP_HEADER memory region for both the SDM845 and SC7180 SoCs has
zero size, and has no canaries.  Defining an offset for such a
zero-length region is not meaningful, so it's better not to define
it at all.  The size of this region is used in the code, but its
value will still be zero because the memory regions are defined in
statically initialized memory.

For the SC7180, the STATS_DROP memory region has a zero size and no
canaries as well.

These regions are the only place where a zero-sized region is
defined despite having no canaries.  Remove them.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-sc7180.c | 10 ----------
 drivers/net/ipa/ipa_data-sdm845.c |  5 -----
 2 files changed, 15 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-sc7180.c b/drivers/net/ipa/ipa_data-sc7180.c
index 434869508a215..0bdb60f6755c4 100644
--- a/drivers/net/ipa/ipa_data-sc7180.c
+++ b/drivers/net/ipa/ipa_data-sc7180.c
@@ -253,11 +253,6 @@ static const struct ipa_mem ipa_mem_local_data[] = {
 		.size		= 0x0140,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_AP_HEADER] = {
-		.offset		= 0x05e8,
-		.size		= 0x0000,
-		.canary_count	= 0,
-	},
 	[IPA_MEM_MODEM_PROC_CTX] = {
 		.offset		= 0x05f0,
 		.size		= 0x0200,
@@ -283,11 +278,6 @@ static const struct ipa_mem ipa_mem_local_data[] = {
 		.size		= 0x0140,
 		.canary_count	= 0,
 	},
-	[IPA_MEM_STATS_DROP] = {
-		.offset		= 0x0bf0,
-		.size		= 0,
-		.canary_count	= 0,
-	},
 	[IPA_MEM_MODEM] = {
 		.offset		= 0x0bf0,
 		.size		= 0x140c,
diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-sdm845.c
index 401861e3c0aa4..8cae9325eb08e 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-sdm845.c
@@ -293,11 +293,6 @@ static const struct ipa_mem ipa_mem_local_data[] = {
 		.size		= 0x0140,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_AP_HEADER] = {
-		.offset		= 0x07c8,
-		.size		= 0x0000,
-		.canary_count	= 0,
-	},
 	[IPA_MEM_MODEM_PROC_CTX] = {
 		.offset		= 0x07d0,
 		.size		= 0x0200,
-- 
2.27.0

