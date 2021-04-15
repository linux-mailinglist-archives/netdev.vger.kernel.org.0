Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2DEF3603B1
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 09:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhDOHtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 03:49:08 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:20429 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbhDOHtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 03:49:07 -0400
Received: from localhost.localdomain (cyclone.blr.asicdesigners.com [10.193.186.206])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 13F7mBm0023347;
        Thu, 15 Apr 2021 00:48:37 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        borisp@nvidia.com, john.fastabend@gmail.com
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net 3/4] ch_ktls: tcb close causes tls connection failure
Date:   Thu, 15 Apr 2021 13:17:47 +0530
Message-Id: <20210415074748.421098-4-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415074748.421098-1-vinay.yadav@chelsio.com>
References: <20210415074748.421098-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HW doesn't need marking TCB closed. This TCB state change
sometimes causes problem to the new connection which gets
the same tid.

Fixes: 34aba2c45024 ("cxgb4/chcr : Register to tls add and del callback")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index a626560f8365..8559eec161f0 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -349,18 +349,6 @@ static int chcr_set_tcb_field(struct chcr_ktls_info *tx_info, u16 word,
 	return cxgb4_ofld_send(tx_info->netdev, skb);
 }
 
-/*
- * chcr_ktls_mark_tcb_close: mark tcb state to CLOSE
- * @tx_info - driver specific tls info.
- * return: NET_TX_OK/NET_XMIT_DROP.
- */
-static int chcr_ktls_mark_tcb_close(struct chcr_ktls_info *tx_info)
-{
-	return chcr_set_tcb_field(tx_info, TCB_T_STATE_W,
-				  TCB_T_STATE_V(TCB_T_STATE_M),
-				  CHCR_TCB_STATE_CLOSED, 1);
-}
-
 /*
  * chcr_ktls_dev_del:  call back for tls_dev_del.
  * Remove the tid and l2t entry and close the connection.
@@ -395,8 +383,6 @@ static void chcr_ktls_dev_del(struct net_device *netdev,
 
 	/* clear tid */
 	if (tx_info->tid != -1) {
-		/* clear tcb state and then release tid */
-		chcr_ktls_mark_tcb_close(tx_info);
 		cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
 				 tx_info->tid, tx_info->ip_family);
 	}
@@ -574,7 +560,6 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	return 0;
 
 free_tid:
-	chcr_ktls_mark_tcb_close(tx_info);
 #if IS_ENABLED(CONFIG_IPV6)
 	/* clear clip entry */
 	if (tx_info->ip_family == AF_INET6)
@@ -672,10 +657,6 @@ static int chcr_ktls_cpl_act_open_rpl(struct adapter *adap,
 	if (tx_info->pending_close) {
 		spin_unlock(&tx_info->lock);
 		if (!status) {
-			/* it's a late success, tcb status is established,
-			 * mark it close.
-			 */
-			chcr_ktls_mark_tcb_close(tx_info);
 			cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
 					 tid, tx_info->ip_family);
 		}
-- 
2.30.2

