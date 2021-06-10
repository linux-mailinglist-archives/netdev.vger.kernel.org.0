Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1593A33EA
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 21:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhFJTZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 15:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbhFJTZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 15:25:15 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472ECC0617AD
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 12:23:19 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id k22so28299519ioa.9
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 12:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HL9o9ctxrHknoeR61K9dgQ4l+oTFbtzywLTa0WvXVK4=;
        b=V3iQh2CjsxmYxYGd5hCEgcOBM7sZS0HvKHFoLXi8Cbk1sgvDD71iZ5U8R/rieoh4lT
         bbA+bywVRsFbXHz5BuIcB444Xa7ujBo9uqopLIwuik90lIfbkrF0dEDzsdBqC+qkEkd/
         r46DWGHEM233gdrx6RyoUfrvEyzN+Y+QczU1mhZWGbWBPdWa3fRH5TR8o8XKtWwttekA
         uabxkM8MjFbeasUqF9n/nxvNb7N+vLGbuA4+d13scN+TpBNy77s2v3p+u8oLBitMTGk5
         Vii0MU2S8tKH6VOrZnkqz5W9fUaC3EMNpzP0V+HtVUdDqOfq9NSlEBzFXkYdZtE+H0hl
         ZwXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HL9o9ctxrHknoeR61K9dgQ4l+oTFbtzywLTa0WvXVK4=;
        b=Y64xdQktQOeLZr3Z9GJHm3edQmfR4oXyn4KYaBQ9aMhXt66vZk2Bw3nYqefYQzpMun
         jFx4brdH8ZidIW/pxuCg5qA9EyFBi9G1DZIKp3KnxoazhQ+Y5EQVVhzkED+QrAZxacld
         IlReTo8pOlEDS62TUvQkxlT7Wsa34vhXzXwuMyu8NMT1E8i8JMI+I8X4KuZ8hc/Nv/d9
         Nbf+T4gsBVuqxbwk9wkNpeiVcwDzxIkrvkcRuwVvTrVNo8Ek4i6x9QbCYGw1WBsFbzDf
         v565/eWpLjmmbMXG1NEonS+dS3fqIqCsJDUV96sGeYxjNPMbO0ICYTxZgmqcerf5C+cc
         6wRQ==
X-Gm-Message-State: AOAM531GWjZ1wrEgC59M69X/kS9th6h2DtmnEcyn9pCdcH148vqpKmrw
        qmmLl/ln6baUwLy0xKkyi0e7ZA==
X-Google-Smtp-Source: ABdhPJzpU4D3z4QomuSprLiM4T9fCmLxTozvveww/Hmo/GwHhNDiLFvPmLlBaWrTr5T8ZUVT+kycUw==
X-Received: by 2002:a05:6638:3885:: with SMTP id b5mr206110jav.68.1623352998699;
        Thu, 10 Jun 2021 12:23:18 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w21sm2028684iol.52.2021.06.10.12.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 12:23:18 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/8] net: ipa: pass memory id to ipa_table_valid_one()
Date:   Thu, 10 Jun 2021 14:23:06 -0500
Message-Id: <20210610192308.2739540-7-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210610192308.2739540-1-elder@linaro.org>
References: <20210610192308.2739540-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop passing most of the Boolean flags to ipa_table_valid_one(), and
just pass a memory region ID to it instead.  We still need to
indicate whether we're operating on a routing or filter table.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_table.c | 44 +++++++++++++------------------------
 1 file changed, 15 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index f7ee75bfba748..679855b1d5495 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -150,29 +150,16 @@ static void ipa_table_validate_build(void)
 }
 
 static bool
-ipa_table_valid_one(struct ipa *ipa, bool route, bool ipv6, bool hashed)
+ipa_table_valid_one(struct ipa *ipa, enum ipa_mem_id mem_id, bool route)
 {
+	const struct ipa_mem *mem = &ipa->mem[mem_id];
 	struct device *dev = &ipa->pdev->dev;
-	const struct ipa_mem *mem;
 	u32 size;
 
-	if (route) {
-		if (ipv6)
-			mem = hashed ? &ipa->mem[IPA_MEM_V6_ROUTE_HASHED]
-				     : &ipa->mem[IPA_MEM_V6_ROUTE];
-		else
-			mem = hashed ? &ipa->mem[IPA_MEM_V4_ROUTE_HASHED]
-				     : &ipa->mem[IPA_MEM_V4_ROUTE];
+	if (route)
 		size = IPA_ROUTE_COUNT_MAX * sizeof(__le64);
-	} else {
-		if (ipv6)
-			mem = hashed ? &ipa->mem[IPA_MEM_V6_FILTER_HASHED]
-				     : &ipa->mem[IPA_MEM_V6_FILTER];
-		else
-			mem = hashed ? &ipa->mem[IPA_MEM_V4_FILTER_HASHED]
-				     : &ipa->mem[IPA_MEM_V4_FILTER];
+	else
 		size = (1 + IPA_FILTER_COUNT_MAX) * sizeof(__le64);
-	}
 
 	if (!ipa_cmd_table_valid(ipa, mem, route, ipv6, hashed))
 		return false;
@@ -185,9 +172,8 @@ ipa_table_valid_one(struct ipa *ipa, bool route, bool ipv6, bool hashed)
 	if (hashed && !mem->size)
 		return true;
 
-	dev_err(dev, "IPv%c %s%s table region size 0x%02x, expected 0x%02x\n",
-		ipv6 ? '6' : '4', hashed ? "hashed " : "",
-		route ? "route" : "filter", mem->size, size);
+	dev_err(dev, "%s table region %u size 0x%02x, expected 0x%02x\n",
+		route ? "route" : "filter", mem_id, mem->size, size);
 
 	return false;
 }
@@ -195,16 +181,16 @@ ipa_table_valid_one(struct ipa *ipa, bool route, bool ipv6, bool hashed)
 /* Verify the filter and route table memory regions are the expected size */
 bool ipa_table_valid(struct ipa *ipa)
 {
-	bool valid = true;
+	bool valid;
 
-	valid = valid && ipa_table_valid_one(ipa, false, false, false);
-	valid = valid && ipa_table_valid_one(ipa, false, false, true);
-	valid = valid && ipa_table_valid_one(ipa, false, true, false);
-	valid = valid && ipa_table_valid_one(ipa, false, true, true);
-	valid = valid && ipa_table_valid_one(ipa, true, false, false);
-	valid = valid && ipa_table_valid_one(ipa, true, false, true);
-	valid = valid && ipa_table_valid_one(ipa, true, true, false);
-	valid = valid && ipa_table_valid_one(ipa, true, true, true);
+	valid = ipa_table_valid_one(IPA_MEM_V4_FILTER, false);
+	valid = valid && ipa_table_valid_one(IPA_MEM_V4_FILTER_HASHED, false);
+	valid = valid && ipa_table_valid_one(IPA_MEM_V6_FILTER, false);
+	valid = valid && ipa_table_valid_one(IPA_MEM_V6_FILTER_HASHED, false);
+	valid = valid && ipa_table_valid_one(IPA_MEM_V4_ROUTE, true);
+	valid = valid && ipa_table_valid_one(IPA_MEM_V4_ROUTE_HASHED, true);
+	valid = valid && ipa_table_valid_one(IPA_MEM_V6_ROUTE, true);
+	valid = valid && ipa_table_valid_one(IPA_MEM_V6_ROUTE_HASHED, true);
 
 	return valid;
 }
-- 
2.27.0

