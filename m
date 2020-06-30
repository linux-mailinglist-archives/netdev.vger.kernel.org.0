Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E852B20F5AB
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 15:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387671AbgF3NdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 09:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733072AbgF3NdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 09:33:12 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFCFC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 06:33:11 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id k23so20925861iom.10
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 06:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r5aSRp59jKO5d55dBFG61qZSPf1iY4fVxx3iYfquSAE=;
        b=UQnfJJ9gy2RTNvVo3X6qL/EUr1IfMDFqaAo5/bpHG6K0FpVsMRaJjt1jpMfKvOjEBe
         Gz3kespK0A0O9wPjziN0o/9IelwlJYSBabSRt1ldI3BidnGo8/ZdCSj6JwxgW5fDjXJ3
         l7n/tDTcKXZt8+wKGW8yFoXyNIR2qdjJu2582Zi2ns9Ld1L9CIQ93ZZ+FGZOtvA1Jt9U
         yyVHilZ6aQMNtXLTcI2N0DKxemM8wjp40/QOc21194xQwQhxtoR2YduvUnnm4oTlEk7/
         qc/h9MMKNokPozIy38ZxduQXAc0QOJyztMgPMwSFlcQYu+PSTj56gXw7ahcPcaODn2ur
         /j1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r5aSRp59jKO5d55dBFG61qZSPf1iY4fVxx3iYfquSAE=;
        b=PyWrSgh1RskMVJlZL/o3XBzvBPQ6kaBwFQzOEm/aFRindAwhbFa59SdtTofvJwGz5k
         Dc/DeROVYUUVvh4HQKlEk9BcBaj3qMyTXQY/FG68fXHM5B0afNMwyLZnETL76DSOqqXf
         tJTBv98lwEcehbgm4Am5Yem0h22VQgQmWlqJZUzhkdJY+BCnI/io6S7PZ0DczRcg3HnD
         E3ghRiceT7rx2P9KZBUojgMr22vTOK6koDWO0CNMd99SfICaBqfmLrMCCzoCgilSpX8y
         rHQqKpBue73DHDts/pTVHgMbeVn76NS+JXUTW5hXDpnAUo3zInK8xXgjmmE9sSskMyd6
         W/iA==
X-Gm-Message-State: AOAM5332Y5yuf5AdvoXBY+xEQpL/kI2u9B2HCBXLi2jepX7yfMj7KcU5
        udPjrLN0/oP8m+e37j2elv1VUQ==
X-Google-Smtp-Source: ABdhPJzxUL/OXKdQC0L4kfFUqJLX6w6ie9b1sYG3tSzEVuBI5e/8Zqs/9qFk1rNhFbJSmgjAea6XDg==
X-Received: by 2002:a6b:f40a:: with SMTP id i10mr21701041iog.155.1593523991143;
        Tue, 30 Jun 2020 06:33:11 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u15sm1538776iog.18.2020.06.30.06.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 06:33:10 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/5] net: ipa: mode register is TX only
Date:   Tue, 30 Jun 2020 08:33:02 -0500
Message-Id: <20200630133304.1331058-4-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200630133304.1331058-1-elder@linaro.org>
References: <20200630133304.1331058-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The INIT_MODE endpoint configuration register is only valid for TX
endpoints.  Rather than writing a zero to that register for RX
endpoints, avoid writing the register at all.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: The commented calls to assert() that were added are now gone.

 drivers/net/ipa/ipa_endpoint.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 1babcfc79360..566ff6a09e65 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -541,7 +541,7 @@ static void ipa_endpoint_init_mode(struct ipa_endpoint *endpoint)
 	u32 offset = IPA_REG_ENDP_INIT_MODE_N_OFFSET(endpoint->endpoint_id);
 	u32 val;
 
-	if (endpoint->toward_ipa && endpoint->data->dma_mode) {
+	if (endpoint->data->dma_mode) {
 		enum ipa_endpoint_name name = endpoint->data->dma_endpoint;
 		u32 dma_endpoint_id;
 
@@ -552,7 +552,7 @@ static void ipa_endpoint_init_mode(struct ipa_endpoint *endpoint)
 	} else {
 		val = u32_encode_bits(IPA_BASIC, MODE_FMASK);
 	}
-	/* Other bitfields unspecified (and 0) */
+	/* All other bits unspecified (and 0) */
 
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
@@ -1297,6 +1297,7 @@ static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
 		ipa_endpoint_init_aggr(endpoint);
 		ipa_endpoint_init_deaggr(endpoint);
 		ipa_endpoint_init_seq(endpoint);
+		ipa_endpoint_init_mode(endpoint);
 	} else {
 		if (endpoint->ipa->version == IPA_VERSION_3_5_1)
 			(void)ipa_endpoint_program_suspend(endpoint, false);
@@ -1306,7 +1307,6 @@ static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
 	}
 	ipa_endpoint_init_cfg(endpoint);
 	ipa_endpoint_init_hdr(endpoint);
-	ipa_endpoint_init_mode(endpoint);
 	ipa_endpoint_status(endpoint);
 }
 
-- 
2.25.1

