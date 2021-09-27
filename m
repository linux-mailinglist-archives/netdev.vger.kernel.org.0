Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0044193FA
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 14:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbhI0MSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 08:18:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234213AbhI0MSj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 08:18:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4744A6103B;
        Mon, 27 Sep 2021 12:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632745021;
        bh=kg6cqnxzry6/+Av1WRHhc3o3FRqLV9iNvalhK8jK0I0=;
        h=From:To:Cc:Subject:Date:From;
        b=YAoQb5O0Qg44lcoRdQPW2cCt4aC4f4bBHW7tXweJWw/zQXN8VzDdk079kZk+uFOdH
         XAgnN1r8aDLZvWeALDKcYNOHCM69BmN6/CjNtZMY4k+KG7AgIMxA/SsmL0RZQtrnkh
         lroyVZssRyyVKZ80TfThBbfSBzKCIyR3FVSxtiM83wh67dL0OeJFJve2olbZjIrh8Q
         r3MYmj1pFFbRtL54JNwKXov5YaBJVG14uvBr7Ax0y5q/LyGP9x30WBkcAlDJ9umDT6
         cp69bOHg3eiZwJCMHI+Uum4JKDJ49sky3CpQKCDt8q/NJRl98wavT20M1sGtcVviwO
         OH69STxaYIrZg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH] mwifiex: avoid null-pointer-subtraction warning
Date:   Mon, 27 Sep 2021 14:16:35 +0200
Message-Id: <20210927121656.940304-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

clang complains about some NULL pointer arithmetic in this driver:

drivers/net/wireless/marvell/mwifiex/sta_tx.c:65:59: error: performing pointer subtraction with a null pointer has undefined behavior [-Werror,-Wnull-pointer-subtraction]
        pad = ((void *)skb->data - (sizeof(*local_tx_pd) + hroom)-
                                                                 ^
drivers/net/wireless/marvell/mwifiex/uap_txrx.c:478:53: error: performing pointer subtraction with a null pointer has undefined behavior [-Werror,-Wnull-pointer-subtraction]
        pad = ((void *)skb->data - (sizeof(*txpd) + hroom) - NULL) &

Rework that expression to do the same thing using a uintptr_t.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/marvell/mwifiex/sta_tx.c   | 4 ++--
 drivers/net/wireless/marvell/mwifiex/uap_txrx.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_tx.c b/drivers/net/wireless/marvell/mwifiex/sta_tx.c
index 241305377e20..a9b5eb992220 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_tx.c
@@ -62,8 +62,8 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 
 	pkt_type = mwifiex_is_skb_mgmt_frame(skb) ? PKT_TYPE_MGMT : 0;
 
-	pad = ((void *)skb->data - (sizeof(*local_tx_pd) + hroom)-
-			 NULL) & (MWIFIEX_DMA_ALIGN_SZ - 1);
+	pad = ((uintptr_t)skb->data - (sizeof(*local_tx_pd) + hroom)) &
+	       (MWIFIEX_DMA_ALIGN_SZ - 1);
 	skb_push(skb, sizeof(*local_tx_pd) + pad);
 
 	local_tx_pd = (struct txpd *) skb->data;
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
index 9bbdb8dfce62..245ff644f81e 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
@@ -475,8 +475,8 @@ void *mwifiex_process_uap_txpd(struct mwifiex_private *priv,
 
 	pkt_type = mwifiex_is_skb_mgmt_frame(skb) ? PKT_TYPE_MGMT : 0;
 
-	pad = ((void *)skb->data - (sizeof(*txpd) + hroom) - NULL) &
-			(MWIFIEX_DMA_ALIGN_SZ - 1);
+	pad = ((uintptr_t)skb->data - (sizeof(*txpd) + hroom)) &
+	       (MWIFIEX_DMA_ALIGN_SZ - 1);
 
 	skb_push(skb, sizeof(*txpd) + pad);
 
-- 
2.29.2

