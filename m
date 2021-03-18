Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFCD340DAC
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 20:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhCRS76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232798AbhCRS7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 14:59:35 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D4EC06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 11:59:35 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id x16so3431615iob.1
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 11:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NoHvO3wchc4QiGr0Z8Rd6w2XPY+8jpERYxAd8J28b3U=;
        b=Iuje5TVVQLo2HdoFWWdCTEDM/bfVR+9L5wlLvp5vAvMrnmZjuB3QgfYXNwgrl7bGuE
         DLm0N2NTK7OZAyhJpkqDcGf0fkU52Wnq1tiD7JQgG9EbG1Xc2T5ZXpQi4HoburkF2Z0B
         2VoG5HcP+n0UzCGKVKlG3GY9FPOjV787gHATl+ATnt18dW9qa29vb31DR+xKO1ljy6cw
         D46nTRTYxHYG9YmMSgg6n08x3DLtr9NI+fEViRmAOyhMUtkhoYW0WEBxaxSlXbnyDPac
         ZcWn8y8CX1DTYishjAKHg6OfC8Qed3urvFNx059a0GARtPgBS73WF/5V2rVKLih/fdOv
         YbYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NoHvO3wchc4QiGr0Z8Rd6w2XPY+8jpERYxAd8J28b3U=;
        b=j10ciHWsvXz4f2FpF8K0EZ/LQesGb+Ke120aiavwa3j9yk3nqFCEKM6Z9YdtcQX021
         ld0afWq2j0gh18kESJF8f/ouLGdDx8HAkeHIOX8ma19Mq9PoMt6eS2/pFsYz0SbVpEnw
         KEpLYEVg9TG1p+BC6hTrlrRxZ30ufUWzOBICKT4+60RVqXGINngHmDQGSlffu2pdSpfm
         cQCjuoXrgZPXbDcene08lOTe/ekEu2stU9rUHEQ9+7oTTXMQy893M9frCaNnDSF+iU6Y
         mLUib7ZCTMyTQlnxQ0uAXmz1iDoKsisnR0v/M36PHdABUrtxkRpsW7fg2y5i3q9J60qp
         LO6w==
X-Gm-Message-State: AOAM531N8l0O9FbAcc4O2DMOdMDN3e1lYSWbC23ql7Is/5XczjxW0qD/
        opAJODKmmZ5cb7OXbIifbOx2AQ==
X-Google-Smtp-Source: ABdhPJy9jv2NYVQwivLEd1x/GZPZi2ZcBeHTXeApktc+R23h6o2EfK8rOc0ZrqMlUzTbrFQ5MkntlA==
X-Received: by 2002:a6b:ec08:: with SMTP id c8mr13000ioh.55.1616093974646;
        Thu, 18 Mar 2021 11:59:34 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id k7sm770359ils.35.2021.03.18.11.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 11:59:34 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     f.fainelli@gmail.com, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 1/4] net: ipa: fix assumptions about DMA address size
Date:   Thu, 18 Mar 2021 13:59:27 -0500
Message-Id: <20210318185930.891260-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210318185930.891260-1-elder@linaro.org>
References: <20210318185930.891260-1-elder@linaro.org>
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

