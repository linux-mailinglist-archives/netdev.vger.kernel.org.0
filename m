Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC68295C77
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 12:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896387AbgJVKK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 06:10:56 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:22004 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2896320AbgJVKK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 06:10:56 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09MAAK5i013211;
        Thu, 22 Oct 2020 03:10:51 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net 7/7] ch_ktls: tcb update fails sometimes
Date:   Thu, 22 Oct 2020 15:40:19 +0530
Message-Id: <20201022101019.7363-8-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201022101019.7363-1-rohitm@chelsio.com>
References: <20201022101019.7363-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

context id and port id should be filled while sending tcb update.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c        | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index e1c6f9489a3f..c5ea2884a313 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -733,7 +733,8 @@ static int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input)
 }
 
 static void *__chcr_write_cpl_set_tcb_ulp(struct chcr_ktls_info *tx_info,
-					u32 tid, void *pos, u16 word, u64 mask,
+					u32 tid, void *pos, u16 word,
+					struct sge_eth_txq *q, u64 mask,
 					u64 val, u32 reply)
 {
 	struct cpl_set_tcb_field_core *cpl;
@@ -742,7 +743,10 @@ static void *__chcr_write_cpl_set_tcb_ulp(struct chcr_ktls_info *tx_info,
 
 	/* ULP_TXPKT */
 	txpkt = pos;
-	txpkt->cmd_dest = htonl(ULPTX_CMD_V(ULP_TX_PKT) | ULP_TXPKT_DEST_V(0));
+	txpkt->cmd_dest = htonl(ULPTX_CMD_V(ULP_TX_PKT) |
+				ULP_TXPKT_CHANNELID_V(tx_info->port_id) |
+				ULP_TXPKT_FID_V(q->q.cntxt_id) |
+				ULP_TXPKT_RO_F);
 	txpkt->len = htonl(DIV_ROUND_UP(CHCR_SET_TCB_FIELD_LEN, 16));
 
 	/* ULPTX_IDATA sub-command */
@@ -797,7 +801,7 @@ static void *chcr_write_cpl_set_tcb_ulp(struct chcr_ktls_info *tx_info,
 		} else {
 			u8 buf[48] = {0};
 
-			__chcr_write_cpl_set_tcb_ulp(tx_info, tid, buf, word,
+			__chcr_write_cpl_set_tcb_ulp(tx_info, tid, buf, word, q,
 						     mask, val, reply);
 
 			return chcr_copy_to_txd(buf, &q->q, pos,
@@ -805,7 +809,7 @@ static void *chcr_write_cpl_set_tcb_ulp(struct chcr_ktls_info *tx_info,
 		}
 	}
 
-	pos = __chcr_write_cpl_set_tcb_ulp(tx_info, tid, pos, word,
+	pos = __chcr_write_cpl_set_tcb_ulp(tx_info, tid, pos, word, q,
 					   mask, val, reply);
 
 	/* check again if we are at the end of the queue */
-- 
2.18.1

