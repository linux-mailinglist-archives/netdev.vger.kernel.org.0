Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262C935A537
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbhDISHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbhDISHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 14:07:40 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9D5C061761
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 11:07:27 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id z3so6810703ioc.8
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 11:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JnilhBvwTKFOB8eP45oHTw3WFpUuibOH2Z94szBsA0s=;
        b=MeUbvvCi/wa25GZoZsYd289FvDyW0YKqubUv0JrufJTn7ovGBXVgC3YPF0osP/UOYC
         5hKBW+2STVkl3JynCZjgU7xBDH2rXRSyM5nWyzGmtXOJ7BIr5UKycBZTGdCbMLw2xvZ4
         iG7vBLd6B8ylhItCdXUNd3VwufqJoHGjAo1O6z0zooeou1hzSiqDgit4LiEzeTwEGSAe
         Ond5i4E7TtzvFqK2jvEIWQHzVKdShwLiZbNFSrq7E0iRWKvVYDBUQriybUAqt7zRhoM3
         9/jf9qtUrfrtW8iZCFeN9rCjolzrMMTWwuYywz6rXzvK4D2E6CavNjqsAqw6xxEbQwLh
         FY3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JnilhBvwTKFOB8eP45oHTw3WFpUuibOH2Z94szBsA0s=;
        b=uD8jEhLMlRolZQRNbI+5QbeXK+WO0YpYvk1CbAHz39MVYZ2F2fciZ8PU6qM8HiBe3D
         5+SvyLmqKaRn2TYwT/SKkQ1ZTpsf1Ze+ojOnfb77/wlMFt9v5AUE0WwP0KZAzqFtXy2A
         7rX4Ej4ZlcMiks0BAdKsTPm4DAKDrwm4+pEjW4Tro4RC9VpqrJ5Rp5SlBIQV3nOdRO8M
         y+FZTYnLeLW0dZyLcg+/9hu6FqicN97AKC85Y6dcDeYX/znBlMgh0n/oW8qofUfBaS9c
         tQzSKnsemwHJbE3fvO7xjU4mI5hCceLDcabTnU2NLQ9pPgBWWZWaazbnpCZAm753dmmz
         x4LQ==
X-Gm-Message-State: AOAM533sjg4OZUq9E/l6SpIKPM5WlvVEwGrZ+ZkydGkUF3o086jtx8v1
        xzuhX34QiGmdzOI8aWAkjwme0Q==
X-Google-Smtp-Source: ABdhPJwVL26EvD+H2wFW+TfBCEaj9PM9ShBXYk6h22RSks103URiCoOL2QlTmXYxQOh448eJvPypmg==
X-Received: by 2002:a5e:c809:: with SMTP id y9mr12770689iol.192.1617991646747;
        Fri, 09 Apr 2021 11:07:26 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g12sm1412786ile.71.2021.04.09.11.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 11:07:26 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/7] net: ipa: relax pool entry size requirement
Date:   Fri,  9 Apr 2021 13:07:16 -0500
Message-Id: <20210409180722.1176868-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210409180722.1176868-1-elder@linaro.org>
References: <20210409180722.1176868-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I no longer know why a validation check ensured the size of an entry
passed to gsi_trans_pool_init() was restricted to be a multiple of 8.
For 32-bit builds, this condition doesn't always hold, and for DMA
pools, the size is rounded up to a power of 2 anyway.

Remove this restriction.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_trans.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 70c2b585f98d6..8c795a6a85986 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -91,7 +91,7 @@ int gsi_trans_pool_init(struct gsi_trans_pool *pool, size_t size, u32 count,
 	void *virt;
 
 #ifdef IPA_VALIDATE
-	if (!size || size % 8)
+	if (!size)
 		return -EINVAL;
 	if (count < max_alloc)
 		return -EINVAL;
@@ -141,7 +141,7 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
 	void *virt;
 
 #ifdef IPA_VALIDATE
-	if (!size || size % 8)
+	if (!size)
 		return -EINVAL;
 	if (count < max_alloc)
 		return -EINVAL;
-- 
2.27.0

