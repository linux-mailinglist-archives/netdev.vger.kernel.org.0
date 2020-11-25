Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D58B2C3A0D
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 08:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgKYH0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 02:26:38 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:19247 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgKYH0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 02:26:38 -0500
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0AP7QSsd009367;
        Tue, 24 Nov 2020 23:26:29 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net v2] ch_ktls: lock is not freed
Date:   Wed, 25 Nov 2020 12:56:26 +0530
Message-Id: <20201125072626.10861-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently lock gets freed only if timeout expires, but missed a
case when HW returns failure and goes for cleanup.

Fixes: efca3878a5fb ("ch_ktls: Issue if connection offload fails")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c    | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index c24485c0d512..7f90b828d159 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -544,7 +544,9 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 		/* need to wait for hw response, can't free tx_info yet. */
 		if (tx_info->open_state == CH_KTLS_OPEN_PENDING)
 			tx_info->pending_close = true;
-		/* free the lock after the cleanup */
+		else
+			spin_unlock_bh(&tx_info->lock);
+		/* if in pending close, free the lock after the cleanup */
 		goto put_module;
 	}
 	spin_unlock_bh(&tx_info->lock);
-- 
2.18.1

