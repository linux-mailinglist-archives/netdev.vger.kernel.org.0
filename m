Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50742E1678
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgLWCTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:19:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728665AbgLWCTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF4F722573;
        Wed, 23 Dec 2020 02:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689940;
        bh=CmCTXlo5QOeMaTIF2kxMvmLAeNqkCnl3FUaR/jTtx0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r5zcuA2IYTU6f8inH9SsD4vYIVn0pgec+lKsgSElGOqslJz+KIi/t6/w4XOk40ISP
         PXT1dOfhy+70MCAKunxVbMZQyRrJRy0aPsCQdLJpZYBAj1vHY3aY4PrLDIrsMOeG9y
         9B/UOQn7JCvUW6345PUxjCE6m3DEdrYLbDh7ecTNF+IOw6roFeshkffhAemHLqH4be
         2wb8zXg/a/gbPPMlJyse6Z01USZbvVcLis1VSBA7oDdSuLRmcxPGpawZIDp9XHfMuh
         2mpXAsPODxZn6UvtMpgW5LNeAj4LrxAnqo/jtN9uUjdGc5X9MNTUsSVUxdNx9XNaXu
         N6YCtiOa2bD1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 036/130] r8169: use READ_ONCE in rtl_tx_slots_avail
Date:   Tue, 22 Dec 2020 21:16:39 -0500
Message-Id: <20201223021813.2791612-36-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 95f3c5458dfa5856bb110e31d156e00d894d0134 ]

tp->dirty_tx and tp->cur_tx may be changed by a racing rtl_tx() or
rtl8169_start_xmit(). Use READ_ONCE() to annotate the races and ensure
that the compiler doesn't use cached values.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/5676fee3-f6b4-84f2-eba5-c64949a371ad@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index fd5adb0c54d29..fca8252b4f21d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5856,7 +5856,8 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 static bool rtl_tx_slots_avail(struct rtl8169_private *tp,
 			       unsigned int nr_frags)
 {
-	unsigned int slots_avail = tp->dirty_tx + NUM_TX_DESC - tp->cur_tx;
+	unsigned int slots_avail = READ_ONCE(tp->dirty_tx) + NUM_TX_DESC
+					- READ_ONCE(tp->cur_tx);
 
 	/* A skbuff with nr_frags needs nr_frags+1 entries in the tx queue */
 	return slots_avail > nr_frags;
-- 
2.27.0

