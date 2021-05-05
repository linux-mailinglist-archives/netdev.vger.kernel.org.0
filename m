Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2819837428B
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235765AbhEEQrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:47:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235802AbhEEQpC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:45:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E66226192C;
        Wed,  5 May 2021 16:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232544;
        bh=d0xUgckLeRh1pHbhhDdZ7uq11et2IR+/sjFS+Pl7Ngo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e82pt23uvp1dE4fzSqR/C2XbJcfXV66DXCE+V3SyiGvT9x384r2uPw7zhAizs2TbX
         IOnZFrTTbl4bsHTxauYoAyfuhFb/owaUZw7Kkgd9QnXWiontZwr/R77K/qJ6NppVvw
         26NxOQSVML4PIe4w+ksNMZFtbH2nRCe4JjnU3spkWMa/pcuJzcyR/7A490HbK3GYkW
         PdK0QgEk0xYvcHXhlWOcxmqrdUZrjWQ0cbuxqUrKhZzJHdcfei0mgHWSh3E/olwcCP
         RsQ8yUpr4dftqedqk9Asw6aIyRIqiY7zXliD6Etp/SOnCYHijNH64wWGWwG14Swl+k
         sTtX297WD/2TQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 063/104] iwlwifi: queue: avoid memory leak in reset flow
Date:   Wed,  5 May 2021 12:33:32 -0400
Message-Id: <20210505163413.3461611-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
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
index 08788bc90683..fd7398daaf65 100644
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
@@ -141,7 +141,7 @@ void _iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans)
 	if (test_and_clear_bit(STATUS_DEVICE_ENABLED, &trans->status)) {
 		IWL_DEBUG_INFO(trans,
 			       "DEVICE_ENABLED bit was set and is now cleared\n");
-		iwl_txq_gen2_tx_stop(trans);
+		iwl_txq_gen2_tx_free(trans);
 		iwl_pcie_rx_stop(trans);
 	}
 
diff --git a/drivers/net/wireless/intel/iwlwifi/queue/tx.c b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
index 7ff1bb0ccc9c..cd5b06ce3e9c 100644
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
index cff694c25ccc..d32256d78917 100644
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

