Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20BE92E1723
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731517AbgLWDGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 22:06:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:46328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728477AbgLWCTF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86616235F8;
        Wed, 23 Dec 2020 02:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689889;
        bh=dSKaEjABsu3I40sGE2bbbn00CsFmFpI5AvkjtJluISE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PmD8wjzDUip8zTR1eM4JcSMZYuT116WbhYyvw3u4H8dq85ezBbZWpAeZ75F02xQ7i
         FbJgu33pFv2hsHzPEELCw1xPGlAllykV/7CW7F1CSC387lvD+UyCBIbo+YY+B8mlI0
         sMzWhVn0ujiTBoVRvZ7xWYCRjI3FqKh2I/Xxu8ka2T5G3i1E06XTZR8e3lhVPC/pV2
         ftPpmkoliH83Y8P187P9D075keaqjCdn60GQJGzizBkTLr6tihnsmHihWD3ChMRu9x
         S+UhEzuinOFUPatdCilsooDBJqSN/tqK5WhnFAThqqamHwDnZr6nZrwcE7UuFdkOnQ
         AxY5ReyFl5aOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 077/217] r8169: use READ_ONCE in rtl_tx_slots_avail
Date:   Tue, 22 Dec 2020 21:14:06 -0500
Message-Id: <20201223021626.2790791-77-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
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
index 85d9c3e30c699..67918feed307e 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4173,7 +4173,8 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
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

