Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B5A42D413
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 09:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhJNHyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 03:54:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229970AbhJNHyE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 03:54:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BACCB61019;
        Thu, 14 Oct 2021 07:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634197919;
        bh=PgQ8DWLj15Tn737Iixsm64rGGY1DE9ojmh8tALjZ11Q=;
        h=From:To:Cc:Subject:Date:From;
        b=O40rSVIBPZIeaNmnZrBI55sDnVF4LqbXOhFliczCNqa9V3CKjAspkW9hX/G1JEYjJ
         6CwhjeyYDOq7ZcBMYx55TlCOAHh7Zk30sZWxwSdDK9Uerx8tMMi959fGRx/k4WFiZQ
         GehcxUp3u2gxty0W21OnvGlLCy9bnMuS3LQcWKGD6ExqI6h7+y5I06B5RL5LoxsSqO
         THPxuHq4QNI+sWjtLdIrjpj9FQUKY/ITd8vFrPsZnT+Y9MaWebL/57eDvZUa6g7So8
         phjZfqaT4cX/6pXQjsYo70wj6bDVcr0L0XChe9VRL9XBtLU36Y2jpSJdJOzbGNEw58
         g02ufvH4DL8WQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Alagu Sankar <alagusankar@silex-india.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Wen Gong <wgong@codeaurora.org>,
        Tamizh Chelvam <tamizhr@codeaurora.org>,
        Carl Huang <cjhuang@codeaurora.org>,
        Miaoqing Pan <miaoqing@codeaurora.org>,
        Ben Greear <greearb@candelatech.com>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        Fabio Estevam <festevam@denx.de>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath10k: fix invalid dma_addr_t token assignment
Date:   Thu, 14 Oct 2021 09:51:15 +0200
Message-Id: <20211014075153.3655910-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Using a kernel pointer in place of a dma_addr_t token can
lead to undefined behavior if that makes it into cache
management functions. The compiler caught one such attempt
in a cast:

drivers/net/wireless/ath/ath10k/mac.c: In function 'ath10k_add_interface':
drivers/net/wireless/ath/ath10k/mac.c:5586:47: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
 5586 |                         arvif->beacon_paddr = (dma_addr_t)arvif->beacon_buf;
      |                                               ^

Looking through how this gets used down the way, I'm fairly
sure that beacon_paddr is never accessed again for ATH10K_DEV_TYPE_HL
devices, and if it was accessed, that would be a bug.

Change the assignment to use a known-invalid address token
instead, which avoids the warning and makes it easier to catch
bugs if it does end up getting used.

Fixes: e263bdab9c0e ("ath10k: high latency fixes for beacon buffer")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 7ca68c81d9b6..c0e78eaa65f8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5583,7 +5583,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		if (ar->bus_param.dev_type == ATH10K_DEV_TYPE_HL) {
 			arvif->beacon_buf = kmalloc(IEEE80211_MAX_FRAME_LEN,
 						    GFP_KERNEL);
-			arvif->beacon_paddr = (dma_addr_t)arvif->beacon_buf;
+			arvif->beacon_paddr = DMA_MAPPING_ERROR;
 		} else {
 			arvif->beacon_buf =
 				dma_alloc_coherent(ar->dev,
-- 
2.29.2

