Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BA233FB35
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 23:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbhCQWaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 18:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbhCQW3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 18:29:53 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEDCC06175F
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 15:29:53 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id v26so238610iox.11
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 15:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mJHY8qu/zb8ROas4WV0ki8PTfXxIvdJCtkC7EQYxU/c=;
        b=uXrdEig5Q8aCl1RmZxxC9heobx+8PUPj8zBCf68sGS3hl/B21E3YDLBvV60dnyzv/a
         b51ixW1V2GvEMmyfRXpf7wx2nkZMeMEcA9zgVdNHajKV6tdVTlM1xZqctm6kdr1YQEqR
         iyTUFD+jkrXmvLoEWPNvK+VSG4AQWP1cbOm4AKCOJxuQm9KZZTOnS4fCzO13zHBM053d
         DoRc/gAuYEltZVjBA3VXsQKMuFk6fqASc+AJnP0N1cPnBirs+minRT/G/BXYTkT0BEvC
         wUNog2ve70IdlV2bvX/tBr0MDbdjxJ4ZJbVEEOJwWoY7Vx+Yc15EXzaB7yVEoLjHNhKx
         2OSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mJHY8qu/zb8ROas4WV0ki8PTfXxIvdJCtkC7EQYxU/c=;
        b=n/dIXnvCF4/iSDIe1hDIXjizeBNvf25Z1OeVNgSUN3gaB2PLL/9l5eHD3l8tuPyxvU
         6+1dbq7FWFWcjZ2Hzqw+cNYnqnt/cw/QzhD5Q1Pcwm+YHnvCFFpDZixAmmoY1B7pQtsU
         2qbBomSfyuFTgdJMcfMVBPXuOsaegJ2z2hRICBAq2iqLxbePKqU5z2OYNpYOZgS0720r
         jDO7TmuuixzeReGX+uKk1rwMNs7HnF3Y0J9D6TtBgmQ6XafcHNHCxU5iKmp/1Mv7txBh
         BBwwftXwp8ZhiFLUaZxvMC4KNG8dIUXrB6jXfN5kGJGJJt0EH947snWSVZg45FDeOqF5
         iyqg==
X-Gm-Message-State: AOAM532cDTibf9MPAKI6+HKIV3TwWLgYIVVxFgbeGv2gmB50tAZbfgqe
        CAWNoRH53ogrxZuudkiRMCmHqw==
X-Google-Smtp-Source: ABdhPJw6YnjvWAUfRm9waslOSl/uRPGYD7PG21A0gPfUrkpwUIetoveKR7JKJzqsngPOskX6vQcdPw==
X-Received: by 2002:a02:c8d4:: with SMTP id q20mr4593415jao.90.1616020193197;
        Wed, 17 Mar 2021 15:29:53 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f3sm176405ilk.74.2021.03.17.15.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 15:29:52 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/4] net: ipa: fix table alignment requirement
Date:   Wed, 17 Mar 2021 17:29:45 -0500
Message-Id: <20210317222946.118125-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317222946.118125-1-elder@linaro.org>
References: <20210317222946.118125-1-elder@linaro.org>
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

