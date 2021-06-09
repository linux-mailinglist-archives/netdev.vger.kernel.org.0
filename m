Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177DC3A2036
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbhFIWiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:38:11 -0400
Received: from mail-il1-f171.google.com ([209.85.166.171]:38612 "EHLO
        mail-il1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbhFIWiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 18:38:06 -0400
Received: by mail-il1-f171.google.com with SMTP id d1so25078646ils.5
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 15:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7yhJsF4sf6g0J5+Wkc48fcn32kH/upZlX3LD7ehd/r4=;
        b=iFlIBZ5Mfm422uNt/F8WgwSdZtKGzWTZh3G+ld6B0meYU3+rtqEvJwkYq5NhfktNke
         tkk/L11PPenB5WKqj3hbau+He4BwCZLpvF+B260RFmumja1p5XwcAjuaHLJVIyk+0hrv
         OOvc3tgadnFuw53wVD8up3iVlfVpZKHRESVMUU+d0ta4zDkuD0tm/pnsTJT0X2E14atw
         NPWGHoNq3NBGPaCeijG0gd4hJZX2TN302h+RNeQ5bJf75ss5NEMvaAHNoDsu3/M9GE9Y
         ysRYR/+1yGXPZ3kQMb5TYlzXh1JrlafbyhCFIrpdiP5jr7O7L+meOkhxmBiEamgOtTZL
         fKPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7yhJsF4sf6g0J5+Wkc48fcn32kH/upZlX3LD7ehd/r4=;
        b=Jy9Xe+sjR+KD2cGuiVy337roAM2RL0kRCT/r41VSRd3yDfomA2YBbTY09/6DDPy7CX
         yIdCFy5HdbZw7ggbMLAZB8BV+o9qkwm8UVJPzBYh7g24NBCOaApClqOXbaXPKcvLEt2h
         HlqIPXtdmc1l1fUWyyjQKHbArbzhJLeWzRChNoroc6cUT07PNS9Zv0Xbyl+VtcuL4USS
         QPV8BspLkl9axGA6dLaNcHL18JZZgZZHZ2eFZQ/pAHKNjxB42B8ClSZlJI8BJRmG4xDR
         RH4FRvJsJpRqM5aLJsyeow4GP/2YzuKH6EuBfNNOlWpZuPdksMn6pds/vg71igKqseD9
         7nAw==
X-Gm-Message-State: AOAM531FCzfPBYS7SyX9xR85DGvq1DosHqaYgU82PgMu6M1wkWhRY0s5
        quvIM4EdUdPnP7ueqdfq7t5rpw==
X-Google-Smtp-Source: ABdhPJxtRPenfKwI8qEBXz0IOHU2YL7XSkC5FvxqzEPNu1fTEZtBkj0ucI738VZx69YrFJOS3Vkz2A==
X-Received: by 2002:a05:6e02:108f:: with SMTP id r15mr1390270ilj.86.1623278111240;
        Wed, 09 Jun 2021 15:35:11 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c19sm750165ili.62.2021.06.09.15.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 15:35:10 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 05/11] net: ipa: separate region range check from other validation
Date:   Wed,  9 Jun 2021 17:34:57 -0500
Message-Id: <20210609223503.2649114-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210609223503.2649114-1-elder@linaro.org>
References: <20210609223503.2649114-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only thing done by ipa_mem_valid_one() that requires hardware
access is the check for whether all regions fit within the size of
IPA local memory specified by an IPA register.

Introduce ipa_mem_size_valid() to implement this verification and
stop doing so in ipa_mem_valid_one().  Call the new function from
ipa_mem_config() (which is also the caller of ipa_mem_valid()).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_mem.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 62e1b8280d982..f245e1a60a44b 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -115,9 +115,6 @@ static bool ipa_mem_valid_one(struct ipa *ipa, const struct ipa_mem *mem)
 	else if (mem->offset < mem->canary_count * sizeof(__le32))
 		dev_err(dev, "region %u offset too small for %hu canaries\n",
 			mem_id, mem->canary_count);
-	else if (mem->offset + mem->size > ipa->mem_size)
-		dev_err(dev, "region %u ends beyond memory limit (0x%08x)\n",
-			mem_id, ipa->mem_size);
 	else if (mem_id == IPA_MEM_END_MARKER && mem->size)
 		dev_err(dev, "non-zero end marker region size\n");
 	else
@@ -151,6 +148,28 @@ static bool ipa_mem_valid(struct ipa *ipa)
 	return true;
 }
 
+/* Do all memory regions fit within the IPA local memory? */
+static bool ipa_mem_size_valid(struct ipa *ipa)
+{
+	struct device *dev = &ipa->pdev->dev;
+	u32 limit = ipa->mem_size;
+	enum ipa_mem_id mem_id;
+
+	for (mem_id = 0; mem_id < ipa->mem_count; mem_id++) {
+		const struct ipa_mem *mem = &ipa->mem[mem_id];
+
+		if (mem->offset + mem->size <= limit)
+			continue;
+
+		dev_err(dev, "region %u ends beyond memory limit (0x%08x)\n",
+			mem_id, limit);
+
+		return false;
+	}
+
+	return true;
+}
+
 /**
  * ipa_mem_config() - Configure IPA shared memory
  * @ipa:	IPA pointer
@@ -184,6 +203,10 @@ int ipa_mem_config(struct ipa *ipa)
 			mem_size);
 	}
 
+	/* We know our memory size; make sure regions are all in range */
+	if (!ipa_mem_size_valid(ipa))
+		return -EINVAL;
+
 	/* Prealloc DMA memory for zeroing regions */
 	virt = dma_alloc_coherent(dev, IPA_MEM_MAX, &addr, GFP_KERNEL);
 	if (!virt)
-- 
2.27.0

