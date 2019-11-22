Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E91B7106609
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbfKVG2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:28:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727584AbfKVFuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7B9520731;
        Fri, 22 Nov 2019 05:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401817;
        bh=5S+2wx5oqUm03lHamCIcP+kMhEIrkazAtB5eG8VlA4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJ+Njb5zHmJKTJkIRt3KvXk6AXvX7LmSUnEu8urFQJ8qMhY6o0KSFfQAGVSJlxJLc
         9YsJA4USi1IinBOOHQKvaVDbi+48kUCwSvLTdlaoRDYGvvXYJ3L0OF5QBHQ78PlvqU
         fBfYz60Pac/0KEZ+l5ByXRw5ttnPP6VWiP7goIa8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 061/219] iwlwifi: pcie: fix erroneous print
Date:   Fri, 22 Nov 2019 00:46:33 -0500
Message-Id: <20191122054911.1750-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit 0916224eaa77bff0fbbc747961d550ff8db45457 ]

When removing the driver, the following flow can happen:
1. host command is in progress, for example at index 68.
2. RX interrupt is received with the response.
3. Before it is processed, the remove flow kicks in, and
   calls iwl_pcie_txq_unmap. The function cleans all DMA,
   and promotes the read pointer to 69.
4. RX thread proceeds with the processing, and is calling
   iwl_pcie_cmdq_reclaim, which will print this error:
   iwl_pcie_cmdq_reclaim: Read index for DMA queue txq id (0),
   index 4 is out of range [0-256] 69 69.

Detect this situation, and avoid the print. Change it to
warning while at it, to make such issues more noticeable
in the future.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 42fdb7970cfdc..7cba4c37c66fd 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1247,11 +1247,11 @@ static void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 
 	if (idx >= trans->cfg->base_params->max_tfd_queue_size ||
 	    (!iwl_queue_used(txq, idx))) {
-		IWL_ERR(trans,
-			"%s: Read index for DMA queue txq id (%d), index %d is out of range [0-%d] %d %d.\n",
-			__func__, txq_id, idx,
-			trans->cfg->base_params->max_tfd_queue_size,
-			txq->write_ptr, txq->read_ptr);
+		WARN_ONCE(test_bit(txq_id, trans_pcie->queue_used),
+			  "%s: Read index for DMA queue txq id (%d), index %d is out of range [0-%d] %d %d.\n",
+			  __func__, txq_id, idx,
+			  trans->cfg->base_params->max_tfd_queue_size,
+			  txq->write_ptr, txq->read_ptr);
 		return;
 	}
 
-- 
2.20.1

