Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7107E340732
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 14:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhCRNwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 09:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhCRNvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 09:51:48 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF0EC06175F
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 06:51:48 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id v17so2335146iot.6
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 06:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mJHY8qu/zb8ROas4WV0ki8PTfXxIvdJCtkC7EQYxU/c=;
        b=vsx5ftBh4NCKMRiay+ZiqQeya0glKxvKsDmSdOqWUoRb42TOuC+fLwbmPkZmzlrrsz
         /GkGXCjAm+QKtLfOadnSd227TNYl/UwNRb+7pD47UC0tZK3D5jv2qT/Qzm8GEiu8Ufad
         yJgFFnGNjP5wKbQ+6lI2XtM+v3+GL9Wj9wXWpX/WsKKILECvVCnijnVAxO3EowT80J+J
         GJxh5vMljJuRCv8uFgbRWBqgt0qQrwpsbrH/LUtXpmsU2IDclabOdyPMsehIT/gmt89e
         oPKaXdH3BaQ69fCGvVg2+KrzjwefZ3pY07+tAiplVP8QX1V1Hza533VSOBMhy02UNQgL
         y0FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mJHY8qu/zb8ROas4WV0ki8PTfXxIvdJCtkC7EQYxU/c=;
        b=MYj7qIgHr2YeHBwwk6n8DoNNjHP/zGMo/1GHWQVskMjHDf8GbMRL8ek7XciaNBXa3+
         3feAnlKlgbLRlAqzV++qSrvp4+2I+yjjYUCc9D4bBKtqc1ttciVwri1Pp7mXwmfLlUHx
         ElMxJjjYpsufgi0E4c451x637yr1HfN+ROyy5OI8pNQhZZ29bGpwHlLNaDbi4n3W5Meh
         AyQJ+jFlA9IYc07HU8REf/QzW8jRF6n6RR5q4oWQNpvg93hOtAGV9rsnHLcNspBAkwJD
         6bZQmlbyYEbtuPa+noyVUJo71jfIbO2bGY6t/vozTf1yALOGb5pMbFuX4EXrKVM1n7vt
         MeQg==
X-Gm-Message-State: AOAM531FqqgQmCpH4feNw2pIHGf2eHmPoH8JKVwpK7gbnKw3/NRcNxPL
        w1EP4A095f3bOjIJzI1CexIAbQ==
X-Google-Smtp-Source: ABdhPJxSqREuCInnxg4Vba0/NsRuylVMMfUTq9zPa/AidFQfTX9ekVpVwEe020WcybFS9WZdjM9McQ==
X-Received: by 2002:a02:9048:: with SMTP id y8mr6962279jaf.66.1616075507892;
        Thu, 18 Mar 2021 06:51:47 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j20sm1139377ilo.78.2021.03.18.06.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 06:51:47 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     f.fainelli@gmail.com, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/4] net: ipa: fix table alignment requirement
Date:   Thu, 18 Mar 2021 08:51:40 -0500
Message-Id: <20210318135141.583977-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210318135141.583977-1-elder@linaro.org>
References: <20210318135141.583977-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We currently have a build-time check to ensure that the minimum DMA
allocation alignment satisfies the constraint that IPA filter and
route tables must point to rules that are 128-byte aligned.

But what's really important is that the actual allocated DMA memory
has that alignment, even if the minimum is smaller than that.

Remove the BUILD_BUG_ON() call checking against minimim DMA alignment
and instead verify at rutime that the allocated memory is properly
aligned.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_table.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index dd07fe9dd87a3..988f2c2886b95 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -118,14 +118,6 @@
 /* Check things that can be validated at build time. */
 static void ipa_table_validate_build(void)
 {
-	/* IPA hardware accesses memory 128 bytes at a time.  Addresses
-	 * referred to by entries in filter and route tables must be
-	 * aligned on 128-byte byte boundaries.  The only rule address
-	 * ever use is the "zero rule", and it's aligned at the base
-	 * of a coherent DMA allocation.
-	 */
-	BUILD_BUG_ON(ARCH_DMA_MINALIGN % IPA_TABLE_ALIGN);
-
 	/* Filter and route tables contain DMA addresses that refer
 	 * to filter or route rules.  But the size of a table entry
 	 * is 64 bits regardless of what the size of an AP DMA address
@@ -665,6 +657,18 @@ int ipa_table_init(struct ipa *ipa)
 	if (!virt)
 		return -ENOMEM;
 
+	/* We put the "zero rule" at the base of our table area.  The IPA
+	 * hardware requires rules to be aligned on a 128-byte boundary.
+	 * Make sure the allocation satisfies this constraint.
+	 */
+	if (addr % IPA_TABLE_ALIGN) {
+		dev_err(dev, "table address %pad not %u-byte aligned\n",
+			&addr, IPA_TABLE_ALIGN);
+		dma_free_coherent(dev, size, virt, addr);
+
+		return -ERANGE;
+	}
+
 	ipa->table_virt = virt;
 	ipa->table_addr = addr;
 
-- 
2.27.0

