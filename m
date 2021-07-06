Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4C73BD133
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238073AbhGFLii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:38:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236822AbhGFLfm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BEC261A1D;
        Tue,  6 Jul 2021 11:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570665;
        bh=Jt/aDsq1Stl07LbDBGnFnJezfY3j/6id96MaEfUjrqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ty+vuhmWnq/dHVGQcXdOqXwwzM2BJJsoN3ban708yNym9tRTRAji2Nw7Z80MHxvtu
         CWrvA3a/Ct4hpT+75XoUAGrhMp/u69acEQ4nCPiyM4eoCwkpmk+e2WV2gUjtrY95Qv
         e1DI43AzrRHql4vjw76Ka+u3q+BphQImN2TXz5PhrvUGqPmx87Toy4iTNdTlCwDJOv
         q+j06TSozz0Y/+wAZzNnQrMx9Qqg/Shb69H4UWP5Mz/aqSvIaLe8zYeiytcL7GYr/3
         9OkBjXDfBZW64VtuXEyIW2IJJpun7agOfcWafTPpEWZDmVwtJ02trpH1XPzoaWrFGw
         sB0TxEqReSKhw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 109/137] iwlwifi: pcie: fix context info freeing
Date:   Tue,  6 Jul 2021 07:21:35 -0400
Message-Id: <20210706112203.2062605-109-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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
index 4c3ca2a37696..b031e9304983 100644
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

