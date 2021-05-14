Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882623806CC
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 12:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbhENKGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 06:06:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233095AbhENKGB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 06:06:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E00461451;
        Fri, 14 May 2021 10:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620986690;
        bh=Z8/t58HXrQWvRNq7RJkw/zVGS+awX9fu5iAau4CEuTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iMFORgVvpUam5l1Ot5WAFAEdgQ6hOWylryRauPWqLSM9oyPVkSljtnfsp/tRLqts7
         x1rivjkt8EjbhW/aipO0alcOfrFjzx+xSiB77wNyk5lkjq/iHNe6J2XZmA2uNgD99O
         Z4JieUdSSp34tMB49wHV2NvgIR4jRfuRwudTyu/+7OgSFkTtyKN0DA6ju5r0F9SrdD
         fu7s2OLdk+DKsHYxI4FTheOl17iZ5pV/TBH5LDFcinKYuncpC9GQKysvTEuxpZHWmF
         +/7JnHdLJzsOWGZc9wDHc8mXYOb2d7XF5Cf6KRSdBVofjwhBXAUoxLh6jaF1vgFuXK
         8VzxZxEm6yIYQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     linux-arch@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Devidas Puranik <devidas@marvell.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/13] mwifiex: re-fix for unaligned accesses
Date:   Fri, 14 May 2021 12:00:58 +0200
Message-Id: <20210514100106.3404011-11-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210514100106.3404011-1-arnd@kernel.org>
References: <20210514100106.3404011-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

A patch from 2017 changed some accesses to DMA memory to use
get_unaligned_le32() and similar interfaces, to avoid problems
with doing unaligned accesson uncached memory.

However, the change in the mwifiex_pcie_alloc_sleep_cookie_buf()
function ended up changing the size of the access instead,
as it operates on a pointer to u8.

Change this function back to actually access the entire 32 bits.
Note that the pointer is aligned by definition because it came
from dma_alloc_coherent().

Fixes: 92c70a958b0b ("mwifiex: fix for unaligned reads")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 94228b316df1..46517515ba72 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -1231,7 +1231,7 @@ static int mwifiex_pcie_delete_cmdrsp_buf(struct mwifiex_adapter *adapter)
 static int mwifiex_pcie_alloc_sleep_cookie_buf(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
-	u32 tmp;
+	u32 *cookie;
 
 	card->sleep_cookie_vbase = dma_alloc_coherent(&card->dev->dev,
 						      sizeof(u32),
@@ -1242,13 +1242,11 @@ static int mwifiex_pcie_alloc_sleep_cookie_buf(struct mwifiex_adapter *adapter)
 			    "dma_alloc_coherent failed!\n");
 		return -ENOMEM;
 	}
+	cookie = (u32 *)card->sleep_cookie_vbase;
 	/* Init val of Sleep Cookie */
-	tmp = FW_AWAKE_COOKIE;
-	put_unaligned(tmp, card->sleep_cookie_vbase);
+	*cookie = FW_AWAKE_COOKIE;
 
-	mwifiex_dbg(adapter, INFO,
-		    "alloc_scook: sleep cookie=0x%x\n",
-		    get_unaligned(card->sleep_cookie_vbase));
+	mwifiex_dbg(adapter, INFO, "alloc_scook: sleep cookie=0x%x\n", *cookie);
 
 	return 0;
 }
-- 
2.29.2

