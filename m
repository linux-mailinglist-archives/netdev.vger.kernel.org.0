Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C1230C4ED
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbhBBQGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:06:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235156AbhBBPJp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:09:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39D4264F65;
        Tue,  2 Feb 2021 15:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278396;
        bh=Mntyyw9pDo73Mx8hzXtsDcqsj83PlObc6cNFP+pQy/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TsWY0Gl21G85gdRx1av0D/erLGQJQWy4GbMpKZLZAiegZITdmg09DtZUGBRtpg7dp
         cOFq1LvjL7V0Wihk7jZKey/pCsyBY0fQovm22wX+E8RuzkKoQ986scgxVDCz4diJzG
         +nryLltoMbwgmNpItCh5k4eYBcSScURI10H724qJoPz9mrv4gaJ2zZSwSOyQIvZjiQ
         +k9wBMzjlzGnO33QiWuywHnV6Y44U5Cna02BL3SHJb08QjlJCyucl/fsPliVFDV0/Y
         NDyfqantD402gIPlCompk7pC+ux45QOOdzRZcyCKVZoF4BELBX6NIpmWesUc8urF/G
         Qs9ry5i0LnDfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 15/25] iwlwifi: pcie: add a NULL check in iwl_pcie_txq_unmap
Date:   Tue,  2 Feb 2021 10:06:05 -0500
Message-Id: <20210202150615.1864175-15-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150615.1864175-1-sashal@kernel.org>
References: <20210202150615.1864175-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 98c7d21f957b10d9c07a3a60a3a5a8f326a197e5 ]

I hit a NULL pointer exception in this function when the
init flow went really bad.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210115130252.2e8da9f2c132.I0234d4b8ddaf70aaa5028a20c863255e05bc1f84@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 966be5689d63a..ed54d04e43964 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -299,6 +299,11 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq = trans->txqs.txq[txq_id];
 
+	if (!txq) {
+		IWL_ERR(trans, "Trying to free a queue that wasn't allocated?\n");
+		return;
+	}
+
 	spin_lock_bh(&txq->lock);
 	while (txq->write_ptr != txq->read_ptr) {
 		IWL_DEBUG_TX_REPLY(trans, "Q %d Free %d\n",
-- 
2.27.0

