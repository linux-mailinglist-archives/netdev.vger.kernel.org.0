Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F6D30C3D2
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235493AbhBBPaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:30:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:40700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235045AbhBBPQH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:16:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88BEA64FAC;
        Tue,  2 Feb 2021 15:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278465;
        bh=SoteQDSMWgUNiOX4z7Aq5Z9QkB1yzcEbMGEVBDYbOiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u07YUDI3f1QiF1fd5d4APh8+cMbA81gi9PLXBD9PnWx5ah05b1lKoNmT6F9tU2CKb
         cyA8CxCTH5WHY55NzfE+VDILEGSbCGCfLL28mnbJ0HHFJUx4D+6lSKMMRnuuxhn8bL
         TxsaIXlVMAL9jV70aJk+BpXcUzECxgrolFtW6N1qQPuxR2uVHpJvzyqcT2ak3J0/kc
         J11TL+g6fihiTU1K1GVmAMWS3k6tkVh8d3MH14Bbjaw/RUP0D5Iv30lGQhBVyTgOyR
         Adht3/pRpJUIpDufg0MQLvwVYSZETCmm5+jvv/xkaN9KgvdXxJobCkaKsuMZHPrYOB
         +gMdckoC5TzxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/6] iwlwifi: pcie: add a NULL check in iwl_pcie_txq_unmap
Date:   Tue,  2 Feb 2021 10:07:37 -0500
Message-Id: <20210202150740.1864854-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150740.1864854-1-sashal@kernel.org>
References: <20210202150740.1864854-1-sashal@kernel.org>
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
index 174e45d78c46a..ff564198d2cef 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -676,6 +676,11 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
 
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

