Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04ED46911A
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391279AbfGOO0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:26:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390462AbfGOO0g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:26:36 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45E4B217F4;
        Mon, 15 Jul 2019 14:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200796;
        bh=TQbRXzfc5WhIRgOGMu7vtqmyzHneb22EBvCzCpUcghY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J52NX4ulU0Mkd2DKOTClavrfMeLOeIeItULsF9GDBi49w6hO0flleSTBFGo5i+UuO
         S2j7KwZhPodxwTOaMnJxAhy3IzN4AA39VEcqhtcbMV5wvGHKRA+kJX1WH2cZTSBXva
         TYj4PxYRsQQrs6yL98j7B3Y7EUZAEn9xbfFbOjls=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Alan Winkowski <walan@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 132/158] net: mvpp2: prs: Don't override the sign bit in SRAM parser shift
Date:   Mon, 15 Jul 2019 10:17:43 -0400
Message-Id: <20190715141809.8445-132-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 8ec3ede559956f8ad58db7b57d25ac724bab69e9 ]

The Header Parser allows identifying various fields in the packet
headers, used for various kind of filtering and classification
steps.

This is a re-entrant process, where the offset in the packet header
depends on the previous lookup results. This offset is represented in
the SRAM results of the TCAM, as a shift to be operated.

This shift can be negative in some cases, such as in IPv6 parsing.

This commit prevents overriding the sign bit when setting the shift
value, which could cause instabilities when parsing IPv6 flows.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Suggested-by: Alan Winkowski <walan@marvell.com>
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
index ae2240074d8e..5692c6087bbb 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -312,7 +312,8 @@ static void mvpp2_prs_sram_shift_set(struct mvpp2_prs_entry *pe, int shift,
 	}
 
 	/* Set value */
-	pe->sram[MVPP2_BIT_TO_WORD(MVPP2_PRS_SRAM_SHIFT_OFFS)] = shift & MVPP2_PRS_SRAM_SHIFT_MASK;
+	pe->sram[MVPP2_BIT_TO_WORD(MVPP2_PRS_SRAM_SHIFT_OFFS)] |=
+		shift & MVPP2_PRS_SRAM_SHIFT_MASK;
 
 	/* Reset and set operation */
 	mvpp2_prs_sram_bits_clear(pe, MVPP2_PRS_SRAM_OP_SEL_SHIFT_OFFS,
-- 
2.20.1

