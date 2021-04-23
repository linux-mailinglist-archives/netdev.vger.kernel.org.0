Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47300368FE2
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 11:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242114AbhDWJxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 05:53:45 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:45950 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230246AbhDWJxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 05:53:43 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UWUyULS_1619171545;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UWUyULS_1619171545)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 23 Apr 2021 17:53:05 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     ayush.sawal@chelsio.com
Cc:     vinay.yadav@chelsio.com, rohitm@chelsio.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] ch_ktls: Remove redundant variable result
Date:   Fri, 23 Apr 2021 17:52:23 +0800
Message-Id: <1619171543-117550-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable result is being assigned a value from a calculation
however the variable is never read, so this redundant variable
can be removed.

Cleans up the following clang-analyzer warning:

drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c:1488:2:
warning: Value stored to 'pos' is never read
[clang-analyzer-deadcode.DeadStores].

drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c:876:3:
warning: Value stored to 'pos' is never read
[clang-analyzer-deadcode.DeadStores].

drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c:36:3:
warning: Value stored to 'start' is never read
[clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index a3f5b80..ef3f1e9 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -33,7 +33,6 @@ static int chcr_get_nfrags_to_send(struct sk_buff *skb, u32 start, u32 len)
 
 	if (unlikely(start < skb_linear_data_len)) {
 		frag_size = min(len, skb_linear_data_len - start);
-		start = 0;
 	} else {
 		start -= skb_linear_data_len;
 
@@ -873,10 +872,10 @@ static int chcr_ktls_xmit_tcb_cpls(struct chcr_ktls_info *tx_info,
 	}
 	/* update receive window */
 	if (first_wr || tx_info->prev_win != tcp_win) {
-		pos = chcr_write_cpl_set_tcb_ulp(tx_info, q, tx_info->tid, pos,
-						 TCB_RCV_WND_W,
-						 TCB_RCV_WND_V(TCB_RCV_WND_M),
-						 TCB_RCV_WND_V(tcp_win), 0);
+		chcr_write_cpl_set_tcb_ulp(tx_info, q, tx_info->tid, pos,
+					   TCB_RCV_WND_W,
+					   TCB_RCV_WND_V(TCB_RCV_WND_M),
+					   TCB_RCV_WND_V(tcp_win), 0);
 		tx_info->prev_win = tcp_win;
 		cpl++;
 	}
@@ -1485,7 +1484,6 @@ static int chcr_ktls_tx_plaintxt(struct chcr_ktls_info *tx_info,
 	wr->op_to_compl = htonl(FW_WR_OP_V(FW_ULPTX_WR));
 	wr->flowid_len16 = htonl(wr_mid | FW_WR_LEN16_V(len16));
 	wr->cookie = 0;
-	pos += sizeof(*wr);
 	/* ULP_TXPKT */
 	ulptx = (struct ulp_txpkt *)(wr + 1);
 	ulptx->cmd_dest = htonl(ULPTX_CMD_V(ULP_TX_PKT) |
-- 
1.8.3.1

