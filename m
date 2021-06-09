Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43013A203D
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhFIWiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:38:20 -0400
Received: from mail-il1-f170.google.com ([209.85.166.170]:41720 "EHLO
        mail-il1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbhFIWiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 18:38:20 -0400
Received: by mail-il1-f170.google.com with SMTP id t6so21035925iln.8
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 15:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TjKUrGqs9xe9MyXfICOgQmSpFyOBKRzcUd08/8kZ4/0=;
        b=BnUXMMEmypsVhA5PMcOInwdRPeZB/JHXrKc/CVIMV370YrKXsS0uNs70Tsn+jfoLHx
         OCtck0zI+9z4dFaQRvcAoQwVTfu3+Ci1CrQhjrz9L97ARkaUukE8WoEjhVGaZqY82ut3
         2lQ5IKXGzE0LV/q/zkJ59rUclKmEz7FvQ503u4JWOFdP0SP4QKVYMC6+zrOVo6EucIfN
         0MwgEpHfQFUITWJx12+2GBSccX6HU9vQWhDB4vP81sY5ICsVZrJHIqXr7n6joHFLcp9i
         yFlktEZ0xOUtw5xbNn/IaAentdi18kJtMIIBOxMTjwqRJqQgQZug2KNRMez/SUVlGpb1
         NqkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TjKUrGqs9xe9MyXfICOgQmSpFyOBKRzcUd08/8kZ4/0=;
        b=mVZZbEDPdutPyXZkkzuISulpd4sHaLe3ky/Y/p1RvV3j+aWUYeUTy2nkgQx4Zf7B5u
         GEExG6VkKRukxl37YnfARrxOBdgZBWUcS60iu+8jcY5jG8YyB/Ffpu7W0URZbIXRY8mF
         MC8kkBBwAkJJJS3/pm7XyjKBCuz+q7tWYeAY4wtlKHZtBQTFJ2Q3joLaxIow9n7Qx9Ed
         hN2fartN+Tpc3EJsGLlaUtw2v9BwIcaz+KCkpI05OWbcboP22MD4rqpzh5j3y3xALdGY
         UtvTlByMN1j4poYU3Jin30HsRcxChIipZu0vSDvGz19bgSXE+BuDwK0L2nKGK/csv/6q
         NRYA==
X-Gm-Message-State: AOAM5337gF+ZpYVe31gIVOkdC5WsoA4FQcDzR7pTkEOnHi72eo1IYUhr
        64yTAnTH5rnH1vbqtltQ5qOEWA==
X-Google-Smtp-Source: ABdhPJzfXoGHvosC+E+RmcwqI8f8J3+4P0RGfxyanv5HnLVqoqqt0vmDqKBJjt7POXsruvLjBt5bKw==
X-Received: by 2002:a92:d902:: with SMTP id s2mr1404875iln.278.1623278113402;
        Wed, 09 Jun 2021 15:35:13 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c19sm750165ili.62.2021.06.09.15.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 15:35:13 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 07/11] net: ipa: pass memory configuration data to ipa_mem_valid()
Date:   Wed,  9 Jun 2021 17:34:59 -0500
Message-Id: <20210609223503.2649114-8-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210609223503.2649114-1-elder@linaro.org>
References: <20210609223503.2649114-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass the memory configuration data array to ipa_mem_valid() for
validation, and use that rather than assuming it's already been
recorded in the IPA structure.  Move the memory data array size
check into ipa_mem_valid().

Call ipa_mem_valid() early in ipa_mem_init(), and only proceed with
assigning the memory array pointer and size if it is found to be
valid.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_mem.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index b2d149e7c5f0e..cb70f063320c5 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -124,13 +124,19 @@ static bool ipa_mem_valid_one(struct ipa *ipa, const struct ipa_mem *mem)
 }
 
 /* Verify each defined memory region is valid. */
-static bool ipa_mem_valid(struct ipa *ipa)
+static bool ipa_mem_valid(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 {
 	struct device *dev = &ipa->pdev->dev;
 	enum ipa_mem_id mem_id;
 
-	for (mem_id = 0; mem_id < ipa->mem_count; mem_id++) {
-		const struct ipa_mem *mem = &ipa->mem[mem_id];
+	if (mem_data->local_count > IPA_MEM_COUNT) {
+		dev_err(dev, "too many memory regions (%u > %u)\n",
+			mem_data->local_count, IPA_MEM_COUNT);
+		return false;
+	}
+
+	for (mem_id = 0; mem_id < mem_data->local_count; mem_id++) {
+		const struct ipa_mem *mem = &mem_data->local[mem_id];
 
 		/* Defined regions have non-zero size and/or canary count */
 		if (mem->size || mem->canary_count) {
@@ -491,11 +497,12 @@ int ipa_mem_init(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 	struct resource *res;
 	int ret;
 
-	if (mem_data->local_count > IPA_MEM_COUNT) {
-		dev_err(dev, "to many memory regions (%u > %u)\n",
-			mem_data->local_count, IPA_MEM_COUNT);
+	/* Make sure the set of defined memory regions is valid */
+	if (!ipa_mem_valid(ipa, mem_data))
 		return -EINVAL;
-	}
+
+	ipa->mem_count = mem_data->local_count;
+	ipa->mem = mem_data->local;
 
 	ret = dma_set_mask_and_coherent(&ipa->pdev->dev, DMA_BIT_MASK(64));
 	if (ret) {
@@ -520,14 +527,6 @@ int ipa_mem_init(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 	ipa->mem_addr = res->start;
 	ipa->mem_size = resource_size(res);
 
-	/* The ipa->mem[] array is indexed by enum ipa_mem_id values */
-	ipa->mem_count = mem_data->local_count;
-	ipa->mem = mem_data->local;
-
-	/* Make sure all defined memory regions are valid */
-	if (!ipa_mem_valid(ipa))
-		goto err_unmap;
-
 	ret = ipa_imem_init(ipa, mem_data->imem_addr, mem_data->imem_size);
 	if (ret)
 		goto err_unmap;
-- 
2.27.0

