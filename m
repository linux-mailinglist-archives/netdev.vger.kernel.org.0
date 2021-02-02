Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D7430C378
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbhBBPSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:18:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:40744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235345AbhBBPQ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:16:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1BB664FAE;
        Tue,  2 Feb 2021 15:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278473;
        bh=Hz+J5UmtDXGaKbBwf4cbi2y0bPeNszPDZvo/Tzji9R4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEJPgFMRhVRSmMiQz8EQzcUg85vIsTBIap3DC7F9wLZB66ldSvXHJxRwKqtvIgHAz
         jXeQl9SCQiv0SB7YA6yq/+RvWouk2fOjWvy7nQe4ElCIZf2sSMuXphn7Gtf2oHsBK2
         BEV4yVLc6O/q9HkLAn4pTmVl6vX2idATLNxDgwfQ9gOxlBrFva64DnMcvlMImZbE7M
         i0VaPddEc1qt9SqUi3i1PYWILiUiD10gC5dAEPji9v8oq8d4rLsjeX59Q0sjud2qzF
         MosQvrExa7yb1jvxWsFDZJyD8QMjxRiFoPzopUXI4LlZNA+/DmbbqgtaCkpu0shL0P
         vrp3doja4QjVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 2/5] iwlwifi: pcie: add a NULL check in iwl_pcie_txq_unmap
Date:   Tue,  2 Feb 2021 10:07:47 -0500
Message-Id: <20210202150750.1864953-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150750.1864953-1-sashal@kernel.org>
References: <20210202150750.1864953-1-sashal@kernel.org>
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
 drivers/net/wireless/iwlwifi/pcie/tx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 8dfe6b2bc7031..cb03c2855019b 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -585,6 +585,11 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
 
+	if (!txq) {
+		IWL_ERR(trans, "Trying to free a queue that wasn't allocated?\n");
+		return;
+	}
+
 	spin_lock_bh(&txq->lock);
 	while (q->write_ptr != q->read_ptr) {
 		IWL_DEBUG_TX_REPLY(trans, "Q %d Free %d\n",
-- 
2.27.0

