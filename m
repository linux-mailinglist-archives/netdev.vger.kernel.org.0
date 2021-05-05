Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B018374168
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbhEEQhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:37:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234550AbhEEQfq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:35:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36A9B61439;
        Wed,  5 May 2021 16:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232383;
        bh=rvik31wNCtC9gMOzvh2YCdENR358Ai1yNdp2L2ZWotY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkqVk0DyyKMt2HCR0tDjZ6YlfK07d+TJ1B3Px0RGIlHVgF1DjaIFms1Vl1uBLEEXW
         KU/+YPjk4ARF2UBa7KpFD5/GVqMLW0T/lnHKlYgnJxneqhlgx2MKw3KpLbYezEBdT/
         8bmZqwaX0fK1rRsBjzTWklNhV1whh6WBUPADSAtVy4Sh/tXuE0BLC/+RQdXIWn9DZ7
         8Pt0zcSKnTFdPhZVnhiBR1qf3WJSIpSJzrrABiHl59mEKJ7SSWxeSR+2r8xqdsX/WK
         3XjWlDHp/N1FtNPWy+b8kQdo+0dxeYHrzbh9AHwyZzaM0/qx7a+IG1F/3vO+B1FpII
         7VuLyqxhjHB8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 070/116] iwlwifi: queue: avoid memory leak in reset flow
Date:   Wed,  5 May 2021 12:30:38 -0400
Message-Id: <20210505163125.3460440-70-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit 4cf2f5904d971a461f67825434ae3c31900ff84b ]

In case the device is stopped any usage of hw queues needs to be
reallocated in fw due to fw reset after device stop, so all driver
internal queue should also be freed, and if we don't free the next usage
would leak the old memory and get in recover flows
"iwlwifi 0000:00:03.0: dma_pool_destroy iwlwifi:bc" warning.

Also warn about trying to reuse an internal allocated queue.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210411124417.c72d2f0355c4.Ia3baff633b9b9109f88ab379ef0303aa152c16bf@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  |  4 +--
 drivers/net/wireless/intel/iwlwifi/queue/tx.c | 30 ++++---------------
 drivers/net/wireless/intel/iwlwifi/queue/tx.h |  3 +-
 3 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index 94ffc1ae484d..af9412bd697e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Copyright (C) 2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2020 Intel Corporation
+ * Copyright (C) 2018-2021 Intel Corporation
  */
 #include "iwl-trans.h"
 #include "iwl-prph.h"
@@ -143,7 +143,7 @@ void _iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans)
 	if (test_and_clear_bit(STATUS_DEVICE_ENABLED, &trans->status)) {
 		IWL_DEBUG_INFO(trans,
 			       "DEVICE_ENABLED bit was set and is now cleared\n");
-		iwl_txq_gen2_tx_stop(trans);
+		iwl_txq_gen2_tx_free(trans);
 		iwl_pcie_rx_stop(trans);
 	}
 
diff --git a/drivers/net/wireless/intel/iwlwifi/queue/tx.c b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
index 833f43d1ca7a..810dcb3df242 100644
--- a/drivers/net/wireless/intel/iwlwifi/queue/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
@@ -13,30 +13,6 @@
 #include "iwl-scd.h"
 #include <linux/dmapool.h>
 
-/*
- * iwl_txq_gen2_tx_stop - Stop all Tx DMA channels
- */
-void iwl_txq_gen2_tx_stop(struct iwl_trans *trans)
-{
-	int txq_id;
-
-	/*
-	 * This function can be called before the op_mode disabled the
-	 * queues. This happens when we have an rfkill interrupt.
-	 * Since we stop Tx altogether - mark the queues as stopped.
-	 */
-	memset(trans->txqs.queue_stopped, 0,
-	       sizeof(trans->txqs.queue_stopped));
-	memset(trans->txqs.queue_used, 0, sizeof(trans->txqs.queue_used));
-
-	/* Unmap DMA from host system and free skb's */
-	for (txq_id = 0; txq_id < ARRAY_SIZE(trans->txqs.txq); txq_id++) {
-		if (!trans->txqs.txq[txq_id])
-			continue;
-		iwl_txq_gen2_unmap(trans, txq_id);
-	}
-}
-
 /*
  * iwl_txq_update_byte_tbl - Set up entry in Tx byte-count array
  */
@@ -1189,6 +1165,12 @@ static int iwl_txq_alloc_response(struct iwl_trans *trans, struct iwl_txq *txq,
 		goto error_free_resp;
 	}
 
+	if (WARN_ONCE(trans->txqs.txq[qid],
+		      "queue %d already allocated\n", qid)) {
+		ret = -EIO;
+		goto error_free_resp;
+	}
+
 	txq->id = qid;
 	trans->txqs.txq[qid] = txq;
 	wr_ptr &= (trans->trans_cfg->base_params->max_tfd_queue_size - 1);
diff --git a/drivers/net/wireless/intel/iwlwifi/queue/tx.h b/drivers/net/wireless/intel/iwlwifi/queue/tx.h
index af1dbdf5617a..20efc62acf13 100644
--- a/drivers/net/wireless/intel/iwlwifi/queue/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/queue/tx.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2020 Intel Corporation
+ * Copyright (C) 2020-2021 Intel Corporation
  */
 #ifndef __iwl_trans_queue_tx_h__
 #define __iwl_trans_queue_tx_h__
@@ -123,7 +123,6 @@ int iwl_txq_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 void iwl_txq_dyn_free(struct iwl_trans *trans, int queue);
 void iwl_txq_gen2_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq);
 void iwl_txq_inc_wr_ptr(struct iwl_trans *trans, struct iwl_txq *txq);
-void iwl_txq_gen2_tx_stop(struct iwl_trans *trans);
 void iwl_txq_gen2_tx_free(struct iwl_trans *trans);
 int iwl_txq_init(struct iwl_trans *trans, struct iwl_txq *txq, int slots_num,
 		 bool cmd_queue);
-- 
2.30.2

