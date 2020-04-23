Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68271B54EA
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 08:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgDWGtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 02:49:06 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:33892 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbgDWGtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 02:49:05 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 03N6mvPH003555;
        Wed, 22 Apr 2020 23:48:58 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     kuba@kernel.org, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net] chcr: Fix CPU hard lockup
Date:   Thu, 23 Apr 2020 12:18:55 +0530
Message-Id: <20200423064855.11408-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Soft lock should be taken in place of hard lock.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/crypto/chelsio/chcr_ktls.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index cd1769ecdc1c..e92b352fb0ad 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -120,12 +120,10 @@ static int chcr_ktls_save_keys(struct chcr_ktls_info *tx_info,
 static int chcr_ktls_update_connection_state(struct chcr_ktls_info *tx_info,
 					     int new_state)
 {
-	unsigned long flags;
-
 	/* This function can be called from both rx (interrupt context) and tx
 	 * queue contexts.
 	 */
-	spin_lock_irqsave(&tx_info->lock, flags);
+	spin_lock_bh(&tx_info->lock);
 	switch (tx_info->connection_state) {
 	case KTLS_CONN_CLOSED:
 		tx_info->connection_state = new_state;
@@ -169,7 +167,7 @@ static int chcr_ktls_update_connection_state(struct chcr_ktls_info *tx_info,
 		pr_err("unknown KTLS connection state\n");
 		break;
 	}
-	spin_unlock_irqrestore(&tx_info->lock, flags);
+	spin_unlock_bh(&tx_info->lock);
 
 	return tx_info->connection_state;
 }
-- 
2.18.1

