Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD88540505A
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347204AbhIIM0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350433AbhIIMWN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:22:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A501361ACE;
        Thu,  9 Sep 2021 11:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188254;
        bh=4waE5rk5InbcAiDlzUCB0X+a29DQNSAYUoca4lv1gNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zw0lrbJDy6/Rgb4JElFZxj+bESglZ0pPt4w+XdzMxmvMZhp4vMh6dZSoNhcZi4kOx
         27qS9mTlYimnaBKLeiWRpO/6OiYlBumFlVjZLUzxLwEu3si4ZrC6vm8Q+LdNZ62aF6
         nOBl/NKNGjFPs3KIAqM46CEgkQVFF2AET/S8/EIr8jJRPwyY5c1dDq6uCe8UmxhFRn
         1uAO5AEb3xADhRNF6LOSqFmRaPyLYQYZVmlRjASnKWWOiucSH+dvJNnBbyIIiHVsgu
         QQE6LTNQFNH6W/t87qbeg4AMsA8d5O9MdShCyMy+FQmIf0WO6J9wjHN2Tl3JIz6cDz
         2myh96R/E2Rog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 201/219] iwlwifi: pcie: free RBs during configure
Date:   Thu,  9 Sep 2021 07:46:17 -0400
Message-Id: <20210909114635.143983-201-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6ac5720086c8b176794eb74c5cc09f8b79017f38 ]

When switching op-modes, or more generally when reconfiguring,
we might switch the RB size. In _iwl_pcie_rx_init() we have a
comment saying we must free all RBs since we might switch the
size, but this is actually too late: the switch has been done
and we'll free the buffers with the wrong size.

Fix this by always freeing the buffers, if any, at the start
of configure, instead of only after the size may have changed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210802170640.42d7c93279c4.I07f74e65aab0e3d965a81206fcb289dc92d74878@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c    | 5 ++++-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index fb8491412be4..586c4104edf2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -487,6 +487,9 @@ void iwl_pcie_free_rbs_pool(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int i;
 
+	if (!trans_pcie->rx_pool)
+		return;
+
 	for (i = 0; i < RX_POOL_SIZE(trans_pcie->num_rx_bufs); i++) {
 		if (!trans_pcie->rx_pool[i].page)
 			continue;
@@ -1093,7 +1096,7 @@ static int _iwl_pcie_rx_init(struct iwl_trans *trans)
 	INIT_LIST_HEAD(&rba->rbd_empty);
 	spin_unlock_bh(&rba->lock);
 
-	/* free all first - we might be reconfigured for a different size */
+	/* free all first - we overwrite everything here */
 	iwl_pcie_free_rbs_pool(trans);
 
 	for (i = 0; i < RX_QUEUE_SIZE; i++)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 239bc177a3e5..a7a495dbf64d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1866,6 +1866,9 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
+	/* free all first - we might be reconfigured for a different size */
+	iwl_pcie_free_rbs_pool(trans);
+
 	trans->txqs.cmd.q_id = trans_cfg->cmd_queue;
 	trans->txqs.cmd.fifo = trans_cfg->cmd_fifo;
 	trans->txqs.cmd.wdg_timeout = trans_cfg->cmd_q_wdg_timeout;
-- 
2.30.2

