Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FFC340736
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 14:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhCRNwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 09:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhCRNvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 09:51:47 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73183C06175F
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 06:51:46 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id v3so2328946ioq.2
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 06:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NoHvO3wchc4QiGr0Z8Rd6w2XPY+8jpERYxAd8J28b3U=;
        b=QqD/1ldW6WboVrXrH1BYwO9uG7UpO7bsH52+MU/5qNlPcr8WrE6f/D62nGtYCyIhTY
         o8Y700oInS1PhdNwBsW2ZVATuA7+VEcY63//N9O33SBQNBU6oO7gjom63B4MhFWGF1fT
         wKSVPRJIgBekQ3yQwaOrfBgpx/hFYvZxb+MgfOdaqzrxCIB9wMTdFSIBsANjOEcHDvPZ
         QNwA5XT0vakADpAVyM1ZOxuRCXRvkx/SZrK5xe9m6BYt/oqGsTVSTpRKNxzWOoWQqRhO
         GWNxIJJAVI77l7Yack/zJOkIVl95b08xMI5FNPL09cWEbBiSR/Am8VOK9y4lAkTgIC8Y
         JC1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NoHvO3wchc4QiGr0Z8Rd6w2XPY+8jpERYxAd8J28b3U=;
        b=i0Co43MjUVmuYGrC4EnibJkThJh1s+XNpbEYM9pfIwUBidXlCjEIBzSBGhvxIepYb+
         0r7Z4+6iVRpoL10RoJNATXFnYyi6jy4EBCR7LWpp5ZEke+r//HrJlKzZe2eYw9Ge/f7y
         kWzMeSCDp/8FAfikAKqsDOdCai7SHnyxdG4+arFX8eV4QiZ5KoTThh4CZzJIFKYgHNWC
         h1gXXtE3ROw7uhQYawzDHZtHwbPqzub5UuMPNYjv2hgb6xn0FKP0MYu9C12G757kj46g
         xNk1BgL+m5oAeWbku2t8aBjSCoAt5fFXhWehWGG1vpuATYOXW6qiQ4nuVEJnL2b3xvGv
         UAIQ==
X-Gm-Message-State: AOAM531c+FYRVI2HkCzK2VHYXpq+PPtbj/dRClqmuBWNjfTO+SMZ2gO7
        Umy5ejRsfa3/Zy9ODzd8yFUFr44zU0C+LVoG
X-Google-Smtp-Source: ABdhPJwaJSgDWAzwJMx135PLH8TCcQJg8T06MYF5WTeluEOY4jOi0qNPL3T00kuqnnMl3MLwHWCEdA==
X-Received: by 2002:a5d:9250:: with SMTP id e16mr10491974iol.27.1616075505890;
        Thu, 18 Mar 2021 06:51:45 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j20sm1139377ilo.78.2021.03.18.06.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 06:51:45 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     f.fainelli@gmail.com, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/4] net: ipa: fix assumptions about DMA address size
Date:   Thu, 18 Mar 2021 08:51:38 -0500
Message-Id: <20210318135141.583977-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210318135141.583977-1-elder@linaro.org>
References: <20210318135141.583977-1-elder@linaro.org>
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

