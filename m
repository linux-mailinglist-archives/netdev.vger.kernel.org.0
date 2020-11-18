Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FCE2B7855
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 09:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgKRIVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 03:21:34 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:10478 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgKRIVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 03:21:31 -0500
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0AI8LFlb030703;
        Wed, 18 Nov 2020 00:21:16 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net] ch_ktls: lock is not freed
Date:   Wed, 18 Nov 2020 13:51:07 +0530
Message-Id: <20201118082107.7551-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently lock gets freed only if timeout expires, but missed a
case when HW returns failure and goes for cleanup.

Fixes: efca3878a5fb ("ch_ktls: Issue if connection offload fails")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c   | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index c24485c0d512..1f521751666d 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -594,9 +594,10 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 free_l2t:
 	cxgb4_l2t_release(tx_info->l2te);
 free_tx_info:
-	if (tx_info->pending_close)
+	if (tx_info->open_state)
 		spin_unlock_bh(&tx_info->lock);
-	else
+
+	if (!tx_info->pending_close)
 		kvfree(tx_info);
 out:
 	atomic64_inc(&port_stats->ktls_tx_connection_fail);
-- 
2.18.1

