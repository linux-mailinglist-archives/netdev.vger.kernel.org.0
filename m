Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DC6463834
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 15:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243767AbhK3O6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 09:58:34 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:59996 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243285AbhK3O4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:56:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C7B07CE1A7E;
        Tue, 30 Nov 2021 14:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F374C53FD3;
        Tue, 30 Nov 2021 14:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283992;
        bh=BVJINqQCtHuC+LMN0y/OsfzHHordy9Emz3ydgJFUngs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZWkTVWx+rupvSYHeyk6cOIHVl7ENdzeoBn+Lq7B6vS2qi1c0rfykn2BkzL9xyjMI
         xpylNmWBujgN2+IgwNtgrnsQcokcn+opfyK68+5mbtcNMw9CK88qxR9eB4dx4zbKbT
         kGbbuLg17CWMsvLMFK4qjI7bvZR2FkjceU3eLbYq5nye39N9auZgehsY3Ev1wYJ1aI
         iD6jJW9/xMB8v9LKoPZOeb1nEggnCI4DGZOBLZSatcxVaZFPI/NxGSe4z8tmPckaAy
         Cfa12Y35NcDGHYUThw2xftxN5LLwfziawUoi3yHx0nRyhcWbdfIQKhHOvPJHSGy4zS
         Pbk2fO2CN2UGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhangyue <zhangyue1@kylinos.cn>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, aelior@marvell.com,
        manishc@marvell.com, davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 15/17] net: qed: fix the array may be out of bound
Date:   Tue, 30 Nov 2021 09:52:39 -0500
Message-Id: <20211130145243.946407-15-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145243.946407-1-sashal@kernel.org>
References: <20211130145243.946407-1-sashal@kernel.org>
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
index 61d5d76545687..21704e34b962f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -865,7 +865,7 @@ static int qed_int_deassertion(struct qed_hwfn  *p_hwfn,
 		if (!parities)
 			continue;
 
-		for (j = 0, bit_idx = 0; bit_idx < 32; j++) {
+		for (j = 0, bit_idx = 0; bit_idx < 32 && j < 32; j++) {
 			struct aeu_invert_reg_bit *p_bit = &p_aeu->bits[j];
 
 			if (qed_int_is_parity_flag(p_hwfn, p_bit) &&
@@ -903,7 +903,7 @@ static int qed_int_deassertion(struct qed_hwfn  *p_hwfn,
 			 * to current group, making them responsible for the
 			 * previous assertion.
 			 */
-			for (j = 0, bit_idx = 0; bit_idx < 32; j++) {
+			for (j = 0, bit_idx = 0; bit_idx < 32 && j < 32; j++) {
 				long unsigned int bitmask;
 				u8 bit, bit_len;
 
@@ -1201,7 +1201,7 @@ static void qed_int_sb_attn_init(struct qed_hwfn *p_hwfn,
 	memset(sb_info->parity_mask, 0, sizeof(u32) * NUM_ATTN_REGS);
 	for (i = 0; i < NUM_ATTN_REGS; i++) {
 		/* j is array index, k is bit index */
-		for (j = 0, k = 0; k < 32; j++) {
+		for (j = 0, k = 0; k < 32 && j < 32; j++) {
 			struct aeu_invert_reg_bit *p_aeu;
 
 			p_aeu = &aeu_descs[i].bits[j];
-- 
2.33.0

