Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB9845D95B
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 12:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbhKYLlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 06:41:03 -0500
Received: from mailgw.kylinos.cn ([123.150.8.42]:18688 "EHLO nksmu.kylinos.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233814AbhKYLjk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 06:39:40 -0500
X-UUID: 5c4d54c99707443db35721a783cfc701-20211125
X-UUID: 5c4d54c99707443db35721a783cfc701-20211125
X-User: zhangyue1@kylinos.cn
Received: from localhost.localdomain [(172.17.127.2)] by nksmu.kylinos.cn
        (envelope-from <zhangyue1@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 722217407; Thu, 25 Nov 2021 19:44:57 +0800
From:   zhangyue <zhangyue1@kylinos.cn>
To:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: qed: fix the array may be out of bound
Date:   Thu, 25 Nov 2021 19:36:10 +0800
Message-Id: <20211125113610.273841-1-zhangyue1@kylinos.cn>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the variable 'p_bit->flags' is always 0,
the loop condition is always 0.

The variable 'j' may be greater than or equal to 32.

At this time, the array 'p_aeu->bits[32]' may be out
of bound.

Signed-off-by: zhangyue <zhangyue1@kylinos.cn>
---
 drivers/net/ethernet/qlogic/qed/qed_int.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index f78e6055f654..27a74977f7a1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -1045,7 +1045,7 @@ static int qed_int_deassertion(struct qed_hwfn  *p_hwfn,
 		if (!parities)
 			continue;
 
-		for (j = 0, bit_idx = 0; bit_idx < 32; j++) {
+		for (j = 0, bit_idx = 0; bit_idx < 32 && j < 32; j++) {
 			struct aeu_invert_reg_bit *p_bit = &p_aeu->bits[j];
 
 			if (qed_int_is_parity_flag(p_hwfn, p_bit) &&
@@ -1083,7 +1083,7 @@ static int qed_int_deassertion(struct qed_hwfn  *p_hwfn,
 			 * to current group, making them responsible for the
 			 * previous assertion.
 			 */
-			for (j = 0, bit_idx = 0; bit_idx < 32; j++) {
+			for (j = 0, bit_idx = 0; bit_idx < 32 && j < 32; j++) {
 				long unsigned int bitmask;
 				u8 bit, bit_len;
 
@@ -1382,7 +1382,7 @@ static void qed_int_sb_attn_init(struct qed_hwfn *p_hwfn,
 	memset(sb_info->parity_mask, 0, sizeof(u32) * NUM_ATTN_REGS);
 	for (i = 0; i < NUM_ATTN_REGS; i++) {
 		/* j is array index, k is bit index */
-		for (j = 0, k = 0; k < 32; j++) {
+		for (j = 0, k = 0; k < 32 && j < 32; j++) {
 			struct aeu_invert_reg_bit *p_aeu;
 
 			p_aeu = &aeu_descs[i].bits[j];
-- 
2.30.0

