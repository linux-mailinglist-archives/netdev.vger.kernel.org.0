Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9F74638F7
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245082AbhK3PGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244208AbhK3PAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:00:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8567EC08C5D1;
        Tue, 30 Nov 2021 06:52:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0A2FFCE1A72;
        Tue, 30 Nov 2021 14:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACA9C8D182;
        Tue, 30 Nov 2021 14:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283958;
        bh=hx5PblAh7S4fefABmWw2qDrUtLJIWtlBNAXSYaQxJzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gliI52jrGO9naEkfyfMBnl0COHsFdlTwsiUK5mu5C8thNw3N+5z2KLO2XTkSOPMty
         iRuY/aUioJu13KjMNJQ7UgFeELbL7opummwAAMcsa9ZfadWZTCX6zxs+64KuINLwXI
         4qufWPmo6Srp3CcqJjBYazSxYzAEfmRLSBLevCZqwyAdzf+r4y8Vz8NByf428DxDuG
         yW8nvO05jardhl8bdUpalOKkclwTIDzDuOZwn9/vLPLenvojwQyYQY5Jx+3iAIYMRw
         7VGYVz1Ac4OFoZQ8nd5ihDZI07SQ8mtazsaP6sM5s02CZabQh7c8kVp/1clTj1xhWT
         ORxiQD58lc3Wg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhangyue <zhangyue1@kylinos.cn>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, aelior@marvell.com,
        manishc@marvell.com, davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/25] net: qed: fix the array may be out of bound
Date:   Tue, 30 Nov 2021 09:51:53 -0500
Message-Id: <20211130145156.946083-23-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145156.946083-1-sashal@kernel.org>
References: <20211130145156.946083-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhangyue <zhangyue1@kylinos.cn>

[ Upstream commit 0435a4d08032c8fba2966cebdac870e22238cacc ]

If the variable 'p_bit->flags' is always 0,
the loop condition is always 0.

The variable 'j' may be greater than or equal to 32.

At this time, the array 'p_aeu->bits[32]' may be out
of bound.

Signed-off-by: zhangyue <zhangyue1@kylinos.cn>
Link: https://lore.kernel.org/r/20211125113610.273841-1-zhangyue1@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_int.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index 666e43748a5f4..a68363e1a9030 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -1027,7 +1027,7 @@ static int qed_int_deassertion(struct qed_hwfn  *p_hwfn,
 		if (!parities)
 			continue;
 
-		for (j = 0, bit_idx = 0; bit_idx < 32; j++) {
+		for (j = 0, bit_idx = 0; bit_idx < 32 && j < 32; j++) {
 			struct aeu_invert_reg_bit *p_bit = &p_aeu->bits[j];
 
 			if (qed_int_is_parity_flag(p_hwfn, p_bit) &&
@@ -1065,7 +1065,7 @@ static int qed_int_deassertion(struct qed_hwfn  *p_hwfn,
 			 * to current group, making them responsible for the
 			 * previous assertion.
 			 */
-			for (j = 0, bit_idx = 0; bit_idx < 32; j++) {
+			for (j = 0, bit_idx = 0; bit_idx < 32 && j < 32; j++) {
 				long unsigned int bitmask;
 				u8 bit, bit_len;
 
@@ -1365,7 +1365,7 @@ static void qed_int_sb_attn_init(struct qed_hwfn *p_hwfn,
 	memset(sb_info->parity_mask, 0, sizeof(u32) * NUM_ATTN_REGS);
 	for (i = 0; i < NUM_ATTN_REGS; i++) {
 		/* j is array index, k is bit index */
-		for (j = 0, k = 0; k < 32; j++) {
+		for (j = 0, k = 0; k < 32 && j < 32; j++) {
 			struct aeu_invert_reg_bit *p_aeu;
 
 			p_aeu = &aeu_descs[i].bits[j];
-- 
2.33.0

