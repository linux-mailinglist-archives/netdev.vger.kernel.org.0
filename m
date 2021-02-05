Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2CE311446
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbhBEWCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbhBEO5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:57:43 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3809C0617A9
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 08:26:53 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id m20so6291315ilj.13
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 08:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ktpO/jSmoOx5RVisI52DM6PeD/6jBsQ5/HisJypSEHU=;
        b=bdgOwBy2EdlM8UU2CbP0LQUUrUdWj9ErOn2Pypwrr2YlwgXfTIy49IdBEeE/C4Gti8
         pWfKw8O2Txoje8FGF+dNElEqJdDUvkOzRflX/T5ZZJB6fVLkOaoLtZw/mVgjhPMnBAeE
         BPh1fVoyM6VGVVWmkMmRpTrWUSCQMLDzIPU2fnBgWKfrRuGRQje75F7s3vwo6mcqAMe0
         qxQ7o8SWtPtOQ5elX/qC05vTjHAbcg43BKrkk217z6x3pygbQzE0G9QXZ4nCzgQHqjbX
         UxOTqboS0NX4U7sWXbv5WOIPnLMIqqVI9hbHNMhYJHxd1wWF1V9h8rFFPVDaRxW+7+JY
         bN+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ktpO/jSmoOx5RVisI52DM6PeD/6jBsQ5/HisJypSEHU=;
        b=lFA1oCiZJHPkZ9ZE3G1UnH1bBw/ybRe+R33/KmOsIqTVTGGCd3GoB4CB5Gi3TWo+P+
         URdCCVqtlML1zs+disFBsFqzGqutwIzzZ1U3RqhzpyEKm2QUj0nrM7C4w4vsmqaw5Mak
         1aZQOU5BBIx/EvbqpW2xCAKvDh4TA9t6yj2LEJtkE9pTKayEfBwoRt6CsahdNa973HDU
         cNvGIqru5FUgymtePMrUHOhbE7FZ6RzTFvFG6dfDnlaSAtxaatV2Gx8SXmNA/xlx/GG8
         WFWAZs5AhYRe1dTvn/1fk7f/wN9k/fBCLMsOtirAQYilKe+XbcYBivNAbWdpRmRBzWQ/
         /ApQ==
X-Gm-Message-State: AOAM533R5/qcNdsIhjNgoYrU99ZtbvUDxS5ziP8CW+EKXW2GQiRMHF4t
        FkoH1fd4JyJOWuxfG3FeeOs2wLlw8X0ttQ==
X-Google-Smtp-Source: ABdhPJwiRGWecuiPuMFn8Z+xj2JpfGLpEDk9gLnBWUrlLf5hOstCF5U+3C2HcWcQqh7UrCSbndbi/g==
X-Received: by 2002:a05:6602:2c4e:: with SMTP id x14mr4376864iov.58.1612535919991;
        Fri, 05 Feb 2021 06:38:39 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h9sm4136882ili.43.2021.02.05.06.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 06:38:39 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 6/7] net: ipa: get rid of status size constraint
Date:   Fri,  5 Feb 2021 08:38:28 -0600
Message-Id: <20210205143829.16271-7-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210205143829.16271-1-elder@linaro.org>
References: <20210205143829.16271-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a build-time check that the packet status structure is a
multiple of 4 bytes in size.  It's not clear where that constraint
comes from, but the structure defines what hardware provides so its
definition won't change.  Get rid of the check; it adds no value.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index bff5d6ffd1186..7209ee3c31244 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -174,9 +174,6 @@ static bool ipa_endpoint_data_valid(struct ipa *ipa, u32 count,
 	enum ipa_endpoint_name name;
 	u32 limit;
 
-	/* Not sure where this constraint come from... */
-	BUILD_BUG_ON(sizeof(struct ipa_status) % 4);
-
 	if (count > IPA_ENDPOINT_COUNT) {
 		dev_err(dev, "too many endpoints specified (%u > %u)\n",
 			count, IPA_ENDPOINT_COUNT);
-- 
2.20.1

