Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781B83A202A
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhFIWhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbhFIWhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 18:37:15 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0F6C061280
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 15:35:17 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id d1so25078820ils.5
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 15:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LMjjpQs8M9kSqCO6ZvuGUH0+GwK5H/54utg6EraTogs=;
        b=ssxJcMWayGRPdGFk8seuDEbiPT0gGpO8Yt1Vu7q1Y73l7POmJVrKeua49bkoXQJujC
         mPOTH0J9PcRsj2gwh78uxmLjxnvCVyoaJGVIY3RDupNLbn0PnomToNIx/2/xa4sp6lym
         MlKcXD+mCCT28Wu5xtquKoJ+9cYjXdbtMrXu4llHa3WGSi9aLDyNLJS1IcDWNjsOkn5d
         TG3yuiZCDqRZzYPY4iyp8JVtbE37OWZjp7DwaVXjm/vTDUcwRYiGsua0WzHu9pvo1R3m
         u7eSa+AgD0/Ooy4RuyGkLoqodcKhp4tZrbROb3c5RP4RaOPkS8kAh34nEtOmH0XwZUUD
         pKdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LMjjpQs8M9kSqCO6ZvuGUH0+GwK5H/54utg6EraTogs=;
        b=slsuDzvRq6PHfFSEIQAK8B0gVZ2x+TG7yR8I4n2RUlXYNgBWdhwYFLieAn26F5RojU
         P694BGz932B6T8ijzLtXHx82jtBj0r5SneraUoZxGbMcQ4lfSeWPZChfR7Q/9HdFKcOy
         mvgTxOeN5NGSxunHMDQEYy/zQ5yY5KAqx/CYAylG3/BnbPgAb9fVnVLDG9VGUsE+grER
         W/pxJsCJX3eEKrCuS/UTZV2SWalSdeLAFCYMGZv8DYLdHojf1Gf7885JR+PEOTUFuISR
         0CXKiGUh3YZS9/k7Pt17+srNIn2EGEYca9NSVdrBQ3Exc+BO+sH94fVxGErWIxnChqep
         kCdQ==
X-Gm-Message-State: AOAM533R62UI1SiHj0xVMxkgCb9GwNfHY1JqQljtzICGlURL++2Nd7oF
        lYNiPnNmXIIqIjDCdj5XoMj4xUNpdWNcSq/e
X-Google-Smtp-Source: ABdhPJzLHswDmsiNLhV1wSn9D/fcKQCpUvxoLzsGLi7opKbz9s/gLMG3xMvg2aVWgs0cJju13UF1Ug==
X-Received: by 2002:a92:cd8d:: with SMTP id r13mr1444229ilb.93.1623278117230;
        Wed, 09 Jun 2021 15:35:17 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c19sm750165ili.62.2021.06.09.15.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 15:35:16 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 11/11] net: ipa: use bitmap to check for missing regions
Date:   Wed,  9 Jun 2021 17:35:03 -0500
Message-Id: <20210609223503.2649114-12-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210609223503.2649114-1-elder@linaro.org>
References: <20210609223503.2649114-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ipa_mem_valid(), wait until regions have been marked in the memory
region bitmap, and check all that are not found there to ensure they
are not required.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_mem.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 7b79aeb5f68fc..ef9fdd3b88750 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -249,19 +249,16 @@ static bool ipa_mem_valid(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 		if (mem->offset)
 			dev_warn(dev, "empty region %u has non-zero offset\n",
 				 mem_id);
-
-		if (ipa_mem_id_required(ipa, mem_id)) {
-			dev_err(dev, "required memory region %u missing\n",
-				mem_id);
-			return false;
-		}
 	}
 
 	/* Now see if any required regions are not defined */
-	while (mem_id < IPA_MEM_COUNT)
-		if (ipa_mem_id_required(ipa, mem_id++))
+	for (mem_id = find_first_zero_bit(regions, IPA_MEM_COUNT);
+	     mem_id < IPA_MEM_COUNT;
+	     mem_id = find_next_zero_bit(regions, IPA_MEM_COUNT, mem_id + 1)) {
+		if (ipa_mem_id_required(ipa, mem_id))
 			dev_err(dev, "required memory region %u missing\n",
 				mem_id);
+	}
 
 	return true;
 }
-- 
2.27.0

