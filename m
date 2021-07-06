Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C823BD24B
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbhGFLl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:41:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237232AbhGFLgC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98EEA61D59;
        Tue,  6 Jul 2021 11:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570779;
        bh=as2n8WmnY6EI8sKfJgytQv2tt3zH4jingMxhmZ+s7SE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bMr3o8CQYgQZKT88TuYEbvBP543XCbzr+zF9CGZ3TJgrQLQYhtMQDOxh9rRVgHPPC
         ohBDeyoB7cTqBFrxMhnU7bAv3tv9Dpw+Fp3y6dSCiULRJ/CSmZmRDDVKt4MzccV66K
         2nzOEur40gBm0ZRo+3z7/NqJq4yRWcPTLSyqEWEDBOq9pKhNM4dF5cusoJnjLacNV4
         WNabocFMNRqAzE6IqKh72ZEkpXP9zk/IFFp3MiL6UAEVZcxHzxb+GtfRnwTPPxf+/J
         PHns6K8//06ySzGGM3rdwyHXxqb5CogqjFHW6bg7UyKRDj75YEujOzvr8rkz+1mPhC
         HBw/QWbvfn/EQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 60/74] iwlwifi: pcie: fix context info freeing
Date:   Tue,  6 Jul 2021 07:24:48 -0400
Message-Id: <20210706112502.2064236-60-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 26d18c75a7496c4c52b0b6789e713dc76ebfbc87 ]

After firmware alive, iwl_trans_pcie_gen2_fw_alive() is called
to free the context info. However, on gen3 that will then free
the context info with the wrong size.

Since we free this allocation later, let it stick around until
the device is stopped for now, freeing some of it earlier is a
separate change.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210618105614.afb63fb8cbc1.If4968db8e09f4ce2a1d27a6d750bca3d132d7d70@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index df8455f14e4d..ee45e475405a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -269,7 +269,8 @@ void iwl_trans_pcie_gen2_fw_alive(struct iwl_trans *trans, u32 scd_addr)
 	/* now that we got alive we can free the fw image & the context info.
 	 * paging memory cannot be freed included since FW will still use it
 	 */
-	iwl_pcie_ctxt_info_free(trans);
+	if (trans->trans_cfg->device_family < IWL_DEVICE_FAMILY_AX210)
+		iwl_pcie_ctxt_info_free(trans);
 
 	/*
 	 * Re-enable all the interrupts, including the RF-Kill one, now that
-- 
2.30.2

