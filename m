Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77903340DAE
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 20:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbhCRS77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbhCRS7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 14:59:37 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06944C06175F
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 11:59:37 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id n198so3436799iod.0
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 11:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mJHY8qu/zb8ROas4WV0ki8PTfXxIvdJCtkC7EQYxU/c=;
        b=Q9Wc6XbbM16YwfxDXr3sNWeSKz5zpvJ0E/Um5exSMglmBlQkVU4K7TDXNRXvmxctG0
         bd2x3/DTy7h7opWcMw9wF27cNZXkZ/tVEpg3RBBFDNlw42KNGWuGPqiISn5sNW/tGdx+
         fm3F8uOHIP0SqLl+hHNV5VgGSC6nt82g+M+rVRLvnK5pBckYA3DjPBWqNIxwW5C4BlSe
         gQzRGsmXe8h/9QQIz3HrLnQG4KcNUwngLEiepeEWCN4tWnk2SNEK8yj6MWqYs63kSims
         qUOuuOOeygYDjxTcJnPR/re3reqGogVna2Tme8PqD3To+2listO5gM3ouIgPdQwdgO/M
         HfZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mJHY8qu/zb8ROas4WV0ki8PTfXxIvdJCtkC7EQYxU/c=;
        b=FobSR/vKUkHfLOqaeVRunJj7Md2YFtn5kRiSGVo7O7s0wEP+YbcZBq6uWKvUXeDGPM
         9wETkejmcvzkZ/6n4JKQloP+pRuLhJJ7Qpasc1m4fNEH3aL7kMi+Dq5GIG+PyYEbxGSr
         x7igHQCTjZ6G0/6BMWivraWZ7Hk1kAWNQNzmRkUTTyCMzbJodzIuKu+QtICsES/u9tDP
         NDf7l5+66C6PlqiBWuyC3Z+Bfec89NQBho94naqFfiCMOxk5sA5rB5Qalvapp2A6TjL6
         e4l7a1nJM+wfiWyxikwXY9GDKtCPsVm4k0Z2eZIxrjiEWXDKQvvnQHYxQjfzlw8RPv7l
         i0mw==
X-Gm-Message-State: AOAM533pfNk9TbjwGlmOC+d4j0nI1iU0YeQsILOVzCyvjRlqf2OCVaHv
        uZGH+4WPve0ZSM8TEISAqcXTEQ==
X-Google-Smtp-Source: ABdhPJzF3uG8CQhldT167jLqJ4M1hKxnKZ8EdjhwowQlEa4cPBe19KWdhkRl2d+jVcjsqc3I3Gnruw==
X-Received: by 2002:a5d:8707:: with SMTP id u7mr44175iom.18.1616093976458;
        Thu, 18 Mar 2021 11:59:36 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id k7sm770359ils.35.2021.03.18.11.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 11:59:36 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     f.fainelli@gmail.com, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 3/4] net: ipa: fix table alignment requirement
Date:   Thu, 18 Mar 2021 13:59:29 -0500
Message-Id: <20210318185930.891260-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210318185930.891260-1-elder@linaro.org>
References: <20210318185930.891260-1-elder@linaro.org>
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

