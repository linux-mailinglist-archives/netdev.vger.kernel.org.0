Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F2333FB34
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 23:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbhCQWaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 18:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbhCQW3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 18:29:52 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BC8C06175F
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 15:29:52 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id n198so235087iod.0
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 15:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NoHvO3wchc4QiGr0Z8Rd6w2XPY+8jpERYxAd8J28b3U=;
        b=mh4myCpwonUMqzOk0bwvC0EAUukNWlN0dYGmJgK2pGryFRQJq1OzULEnCT3aQhHMia
         U5CyHpeXaWKiQ4XG+D1xe1cKSh9GjA+agGe9hUuimQZawptF4Kg0gqAls6EUhRJBV2x/
         KzXmN4QO7ibRO/YzryrKQCNLnS4amclzJ8OXSj+Eul1w6u/dG5suMIy1/TL9ff0AAKC2
         5maJ8+w9UHzQeuoieDbtTy9dQzivIRfajkP1OMLE24F5AB6SEDCxtF4EC/GGqB1/7vEj
         k6ap1DVcZ287SoQ41zSeb1cQ1EIPa1J3O4EC8XlT1OesP4AVztOwmPUExVNjNLTvmXS0
         1S0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NoHvO3wchc4QiGr0Z8Rd6w2XPY+8jpERYxAd8J28b3U=;
        b=LTf1tABwXFy2u0vbTbaHti13NP6i37KdZsOVd4p9/4aHPta18pQmkwRtbVECUOmoXE
         SSMvRYj0lhjyzYOeiDjTpwbEgHLGEzaiC0+2dMw0MSxZ06QVPm3HilTW41RiUXARvsbF
         tWWu8a4CLKaa1T/rdcTipEiiX1g3//T7UUrubh/xkj0zIOdRwAfmi3WwW94j6Ldua+Ot
         BtjIoPIXtkMK6TMWpavCrT62KkNRfWsJ3+5UwVQsWySqfEQ+G3ojfrrQ854bLTJCSyim
         wW2o7ptKRd9z0NQ5pmpKzt5oigMBMi7uBR6IQ+NHU6LZwn21P3dYSQWKacSTSrZeCS3L
         /oKA==
X-Gm-Message-State: AOAM532GDz6Yqh0SE3nI6FsWSq1NR/7gLo7wIRhy43GljOcT9T90l1kf
        cZ7czV0+F7QD/0V+3nzmzfoWRA==
X-Google-Smtp-Source: ABdhPJyeBv1EJCm9MRfPf3/DYBfaGO2iixWwxEjPU61w42mdl0BjVa1MAnKijDKlpgvDSBNSoiNo/Q==
X-Received: by 2002:a02:7691:: with SMTP id z139mr4620847jab.130.1616020191458;
        Wed, 17 Mar 2021 15:29:51 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f3sm176405ilk.74.2021.03.17.15.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 15:29:51 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/4] net: ipa: fix assumptions about DMA address size
Date:   Wed, 17 Mar 2021 17:29:43 -0500
Message-Id: <20210317222946.118125-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317222946.118125-1-elder@linaro.org>
References: <20210317222946.118125-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some build time checks in ipa_table_validate_build() assume that a
DMA address is 64 bits wide.  That is more restrictive than it has
to be.  A route or filter table is 64 bits wide no matter what the
size of a DMA address is on the AP.  The code actually uses a
pointer to __le64 to access table entries, and a fixed constant
IPA_TABLE_ENTRY_SIZE to describe the size of those entries.

Loosen up two checks so they still verify some requirements, but
such that they do not assume the size of a DMA address is 64 bits.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_table.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 7450e27068f19..dd07fe9dd87a3 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -126,13 +126,15 @@ static void ipa_table_validate_build(void)
 	 */
 	BUILD_BUG_ON(ARCH_DMA_MINALIGN % IPA_TABLE_ALIGN);
 
-	/* Filter and route tables contain DMA addresses that refer to
-	 * filter or route rules.  We use a fixed constant to represent
-	 * the size of either type of table entry.  Code in ipa_table_init()
-	 * uses a pointer to __le64 to initialize table entriews.
+	/* Filter and route tables contain DMA addresses that refer
+	 * to filter or route rules.  But the size of a table entry
+	 * is 64 bits regardless of what the size of an AP DMA address
+	 * is.  A fixed constant defines the size of an entry, and
+	 * code in ipa_table_init() uses a pointer to __le64 to
+	 * initialize tables.
 	 */
-	BUILD_BUG_ON(IPA_TABLE_ENTRY_SIZE != sizeof(dma_addr_t));
-	BUILD_BUG_ON(sizeof(dma_addr_t) != sizeof(__le64));
+	BUILD_BUG_ON(sizeof(dma_addr_t) > IPA_TABLE_ENTRY_SIZE);
+	BUILD_BUG_ON(sizeof(__le64) != IPA_TABLE_ENTRY_SIZE);
 
 	/* A "zero rule" is used to represent no filtering or no routing.
 	 * It is a 64-bit block of zeroed memory.  Code in ipa_table_init()
-- 
2.27.0

