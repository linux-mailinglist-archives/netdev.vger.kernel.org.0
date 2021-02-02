Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B983930C420
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbhBBPlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:41:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235246AbhBBPOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:14:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A93564F99;
        Tue,  2 Feb 2021 15:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278443;
        bh=+m/PQRdwMITWGIWQ0T0cZ1RQNFSvv6kC3lny2aBiI/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJvKoXeCA1UJn5+nODROuR4cRhBgpR2ElncFvEL1SNzwLg+66j0q6iJCPhkW2wZwe
         mE8LtwS25H1NLvd81OZdfRD27Z4mIG3G1k6rWSo4u16fNIDy3yccX1BMxMjd+Sqkyi
         zKPA5uj56+G+UUX1jcw40JW4fTG1gPQXA8iB+WPA98RXLe21Vl4pXG/CaDuXnTkvgq
         zJIC9H43vIVV1IyaTbxazSf5NLwQCPMdOObvuCYPU5O78ppkIxxziV7acQDhmDnF7Q
         evh5/QvlsJaqtuuND+XIzi7+Wm9uYXKx81v376ClKnJ/CB40V849k+JTb6LE2n8wqz
         sWeVY3kB80siw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/10] iwlwifi: pcie: add a NULL check in iwl_pcie_txq_unmap
Date:   Tue,  2 Feb 2021 10:07:10 -0500
Message-Id: <20210202150715.1864614-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150715.1864614-1-sashal@kernel.org>
References: <20210202150715.1864614-1-sashal@kernel.org>
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
index b73582ec03a08..b1a71539ca3e5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -631,6 +631,11 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq = trans_pcie->txq[txq_id];
 
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

