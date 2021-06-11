Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6AB53A4A3A
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhFKUlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbhFKUlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 16:41:46 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D39C061574
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:39:47 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id l64so10886482ioa.7
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P7uaYucC+62klUqk+ruT7sASOO838Q3Fy6yssPZtvh4=;
        b=KMCAcHJAIMxrgGwUWsIpQ9GXDLNt5lT/NifJxtXW+piGpj/hshXULJfk6G3W/Ce/zI
         nI+LlP2qDy73Q6Kl8mFbbuzvuIEdchOnRywPShlPUaYjK6KZXxyKEvRQAnwICSDieWVl
         l1Hns8Xs5uyGYuuVH3+JXO5Z4V0o4luisclY9/O/pkh8WXNujyHC8vWLhRH2JPffbzKZ
         Tf2+M6anOupoo1HM4OMsUkLyvarGujJIpqKr2YvHZ4rbuTSK7p6g2h6Pc7k8qpl15y8Z
         xHsqLw9k8/OEVcPjuqC53U8vBbgORFVvjcrxaMuZr7pQtQC5Hwcrv0Gwb7f5QpqHgJPK
         z4DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P7uaYucC+62klUqk+ruT7sASOO838Q3Fy6yssPZtvh4=;
        b=hhoO4a3nYe43hQP8r8aQkHFGk6+Ox63yrUzST8FRZX/lkkkDUfmno0CzWGsVjAe+kI
         44A5BdKAUIbwtVL7zOlXf2XZ0nsU2VJ8JCbzjDQDysA2+ut2uKoOhZU/lsne5xSiKyDA
         KY3tRvcNvxErG4SQyMaNpn10OQ+ZFPha4PoGU8noRweiD/7yUItsyhzrNQaeLG6hJezQ
         6YCzg+HbOMQRrOc2uoLTYHYJOl1PAZ3YVhD6Qt70gb/XUdcrw87btpimyiAzyWOf+bEY
         CY9JWk9jv1tz9I/mugbMWKmgYZ4Zq3c+vI++BTs7zzL6OWcetLSp32mEwxbPlrOfU6zK
         e5Xw==
X-Gm-Message-State: AOAM5315DULx4abCoQL/2oaHJFOpyZ8jkW0c7fULgOZiDCrP383WUieu
        Yr2+vrRFG/qUf8V0QShq29aELQ==
X-Google-Smtp-Source: ABdhPJyCVhj8gUrNAlX22r/zn5RovPU3D26T7avfsbxrfpnuFc/GTdhxQlUWZLoeXP0WEkAMhEEXuQ==
X-Received: by 2002:a02:354d:: with SMTP id y13mr5524096jae.83.1623443984720;
        Fri, 11 Jun 2021 13:39:44 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id y9sm3761544ilp.58.2021.06.11.13.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 13:39:44 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     leon@kernel.org, bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        aleksander@aleksander.es, ejcaruso@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/3] net: ipa: make endpoint data validation unconditional
Date:   Fri, 11 Jun 2021 15:39:38 -0500
Message-Id: <20210611203940.3171057-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210611203940.3171057-1-elder@linaro.org>
References: <20210611203940.3171057-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cost of validating the endpoint configuration data is not all
that high, so just do it unconditionally, rather than doing so only
when IPA_VALIDATAION is defined.

Suggested-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 07a81b73306fe..3520852936ed1 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -75,8 +75,6 @@ struct ipa_status {
 #define IPA_STATUS_FLAGS1_RT_RULE_ID_FMASK	GENMASK(31, 22)
 #define IPA_STATUS_FLAGS2_TAG_FMASK		GENMASK_ULL(63, 16)
 
-#ifdef IPA_VALIDATE
-
 static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 			    const struct ipa_gsi_endpoint_data *all_data,
 			    const struct ipa_gsi_endpoint_data *data)
@@ -225,16 +223,6 @@ static bool ipa_endpoint_data_valid(struct ipa *ipa, u32 count,
 	return true;
 }
 
-#else /* !IPA_VALIDATE */
-
-static bool ipa_endpoint_data_valid(struct ipa *ipa, u32 count,
-				    const struct ipa_gsi_endpoint_data *data)
-{
-	return true;
-}
-
-#endif /* !IPA_VALIDATE */
-
 /* Allocate a transaction to use on a non-command endpoint */
 static struct gsi_trans *ipa_endpoint_trans_alloc(struct ipa_endpoint *endpoint,
 						  u32 tre_count)
-- 
2.27.0

