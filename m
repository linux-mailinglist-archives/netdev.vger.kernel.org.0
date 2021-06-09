Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700803A2034
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbhFIWiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:38:05 -0400
Received: from mail-il1-f181.google.com ([209.85.166.181]:33613 "EHLO
        mail-il1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhFIWiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 18:38:04 -0400
Received: by mail-il1-f181.google.com with SMTP id z1so28254015ils.0
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 15:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZdGgujJpSC16NOxebiYpelihKJZiijAWNHIUEf3thoc=;
        b=PyZ4Dwy/Ji4+qoTMeTUJ0rNteKjCfXFM3ownSvTQJmutDCQtnbAi84HuQR6k+Qg4lP
         4MxYuwVSJTuIA3ly1lp08vSnW7/LTDh9ZIPOUZthrRmuyXeHTnsV/m6rAG90Lk7IvOoW
         FOYb2zecLrKjpdF9VYTXZArDCHX/7+/uAw3GX+8tX1Cw82FmzN5NNy+TleA969OSZ3Mk
         7higtOO33cqmuE7JWLeA6kSKf+AlCWXMF2oNBTGkw/dRcB8uEf/4NjNIjMt51ZwuVy82
         ViZ/S8TptmiuUkhJb4AbVI4Nk3sXNaz9b3MI8HvVkv1W4SJ3OP8+rFjyhaNW9QMfRIVL
         qHYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZdGgujJpSC16NOxebiYpelihKJZiijAWNHIUEf3thoc=;
        b=m4NX/DfFO72JF+/CepoIpFU422C3AozsW13CqBF74bhOwDgQBp6ptCPThm9vbkqNhs
         HrRHwKKYkHWZIaEKyWDBAPfWKOHsV+ZdFvkYSCC5u42BnKdjKVW9UyuWbUHrf7252e05
         LAPKNrwJTwvleuzmtlTiWpq1UGCzFQAQNGEomXlTBQUomSZ1v/0GYmU1KC5EAal28sm3
         RC0K53wcYqQqi32ch9sQR/QfzWnKVrXOMGsz28SNYVU2zZDWOiotVGyVOjSwpxSvdKLG
         tEb2Tpo9nRFzDoKyenW6KwQl7dzWJlA7/WHKVZ0cJu3R3kgfrQtw6qpfvqg2hvMUALTy
         44zQ==
X-Gm-Message-State: AOAM531VzmLboDTnN2S6qN3ZaR2jpTIN3rr/AklCSeVvtCeZ1CfiZ8tT
        So+E3nKFrpinZ+JG4qJHBxFCsg==
X-Google-Smtp-Source: ABdhPJyKDf0FdKlV16FRpCMIBpQOJTUDEUh4dw7TNzahMRi1V7HWlR/qWv0A8rigYr04yYQzKj2hHw==
X-Received: by 2002:a05:6e02:1447:: with SMTP id p7mr1373513ilo.131.1623278109340;
        Wed, 09 Jun 2021 15:35:09 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c19sm750165ili.62.2021.06.09.15.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 15:35:09 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 03/11] net: ipa: validate memory regions unconditionally
Date:   Wed,  9 Jun 2021 17:34:55 -0500
Message-Id: <20210609223503.2649114-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210609223503.2649114-1-elder@linaro.org>
References: <20210609223503.2649114-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do memory region descriptor validation unconditionally, rather than
having it depend on IPA_VALIDATION being defined.

Pass the address of a memory region descriptor rather than a memory
ID to ipa_mem_valid().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_mem.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index e3c43cf6e4412..effaa745a4061 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -99,12 +99,10 @@ int ipa_mem_setup(struct ipa *ipa)
 	return 0;
 }
 
-#ifdef IPA_VALIDATE
-
-static bool ipa_mem_valid(struct ipa *ipa, enum ipa_mem_id mem_id)
+static bool ipa_mem_valid(struct ipa *ipa, const struct ipa_mem *mem)
 {
-	const struct ipa_mem *mem = &ipa->mem[mem_id];
 	struct device *dev = &ipa->pdev->dev;
+	enum ipa_mem_id mem_id = mem->id;
 	u16 size_multiple;
 
 	/* Other than modem memory, sizes must be a multiple of 8 */
@@ -128,15 +126,6 @@ static bool ipa_mem_valid(struct ipa *ipa, enum ipa_mem_id mem_id)
 	return false;
 }
 
-#else /* !IPA_VALIDATE */
-
-static bool ipa_mem_valid(struct ipa *ipa, enum ipa_mem_id mem_id)
-{
-	return true;
-}
-
-#endif /*! IPA_VALIDATE */
-
 /**
  * ipa_mem_config() - Configure IPA shared memory
  * @ipa:	IPA pointer
@@ -188,7 +177,7 @@ int ipa_mem_config(struct ipa *ipa)
 		__le32 *canary;
 
 		/* Validate all regions (even undefined ones) */
-		if (!ipa_mem_valid(ipa, mem_id))
+		if (!ipa_mem_valid(ipa, mem))
 			goto err_dma_free;
 
 		/* Skip over undefined regions */
-- 
2.27.0

