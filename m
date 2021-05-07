Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D721A376C39
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 00:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhEGWMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 18:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230095AbhEGWMo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 18:12:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D8BA611F1;
        Fri,  7 May 2021 22:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620425504;
        bh=Z8/t58HXrQWvRNq7RJkw/zVGS+awX9fu5iAau4CEuTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IijVFH2E9HYV114Qph7UNhwrB8O6u0uJ75WgEB1kdGOOsojWG6SZI+w7aO7Du9pPZ
         i4wK5qDqL+Xg2c21IF+rtS2QP3M2fu8X03aK/XJ12T/920xgeSeS2f+uPfu8VTspBA
         d2PzThH7iDrvRAxgXCxZ6o9UKux7qVqMfgAwNxAKh3MdEISscybroj31bgsXukMScx
         7S9iS8iUIgMXaWvsviiBYmzG8Zdl090OJV4U1xSUstAaENoNFmJHMz5aXxfr3GuGq0
         /hXveixaY+1ncEEFO4kj7NAMBeNz1AJEZ6QF1pjHpVQJb3xg1XGHRrx19/rGbv01hb
         0u2ivoBCHBxgA==
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
Subject: [RFC 10/12] mwifiex: re-fix for unaligned accesses
Date:   Sat,  8 May 2021 00:07:55 +0200
Message-Id: <20210507220813.365382-11-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210507220813.365382-1-arnd@kernel.org>
References: <20210507220813.365382-1-arnd@kernel.org>
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

