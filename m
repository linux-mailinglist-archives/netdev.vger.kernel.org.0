Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A7D1F24C0
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387394AbgFHXWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731278AbgFHXWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:22:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 550E82086A;
        Mon,  8 Jun 2020 23:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658536;
        bh=gt02xV2gTXAGJGD8SHqqXs6e/DU/oGfgASH0Dlqg5Pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SI4CO99KM9tTVwppXyxMVQP2WbGiROlfX8qM4hcnVXoq2/jjlTfG36f45t3TGOryn
         UKCth3N4g9rVam183u46sRVv/Vk4P8PwxkMRNpSe3moy+YIbdFvUnlWJFkHZweyBlz
         6MCegIIYAHuK/RO08dd6jCXBgQVPmVeKozQvq+Hg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 159/175] iwlwifi: mvm: fix aux station leak
Date:   Mon,  8 Jun 2020 19:18:32 -0400
Message-Id: <20200608231848.3366970-159-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sharon <sara.sharon@intel.com>

[ Upstream commit f327236df2afc8c3c711e7e070f122c26974f4da ]

When mvm is initialized we alloc aux station with aux queue.
We later free the station memory when driver is stopped, but we
never free the queue's memory, which casues a leak.

Add a proper de-initialization of the station.

Signed-off-by: Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200529092401.0121c5be55e9.Id7516fbb3482131d0c9dfb51ff20b226617ddb49@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c  |  5 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c   | 18 +++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h   |  6 +++---
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 6ca087ffd163..ed92a8e8cd51 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1193,14 +1193,13 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm)
 	 */
 	flush_work(&mvm->roc_done_wk);
 
+	iwl_mvm_rm_aux_sta(mvm);
+
 	iwl_mvm_stop_device(mvm);
 
 	iwl_mvm_async_handlers_purge(mvm);
 	/* async_handlers_list is empty and will stay empty: HW is stopped */
 
-	/* the fw is stopped, the aux sta is dead: clean up driver state */
-	iwl_mvm_del_aux_sta(mvm);
-
 	/*
 	 * Clear IN_HW_RESTART and HW_RESTART_REQUESTED flag when stopping the
 	 * hw (as restart_complete() won't be called in this case) and mac80211
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 71d339e90a9e..41f62793a57c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2080,16 +2080,24 @@ int iwl_mvm_rm_snif_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	return ret;
 }
 
-void iwl_mvm_dealloc_snif_sta(struct iwl_mvm *mvm)
+int iwl_mvm_rm_aux_sta(struct iwl_mvm *mvm)
 {
-	iwl_mvm_dealloc_int_sta(mvm, &mvm->snif_sta);
-}
+	int ret;
 
-void iwl_mvm_del_aux_sta(struct iwl_mvm *mvm)
-{
 	lockdep_assert_held(&mvm->mutex);
 
+	iwl_mvm_disable_txq(mvm, NULL, mvm->aux_queue, IWL_MAX_TID_COUNT, 0);
+	ret = iwl_mvm_rm_sta_common(mvm, mvm->aux_sta.sta_id);
+	if (ret)
+		IWL_WARN(mvm, "Failed sending remove station\n");
 	iwl_mvm_dealloc_int_sta(mvm, &mvm->aux_sta);
+
+	return ret;
+}
+
+void iwl_mvm_dealloc_snif_sta(struct iwl_mvm *mvm)
+{
+	iwl_mvm_dealloc_int_sta(mvm, &mvm->snif_sta);
 }
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index 8d70093847cb..da2d1ac01229 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019 Intel Corporation
+ * Copyright(c) 2018 - 2020 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019 Intel Corporation
+ * Copyright(c) 2018 - 2020 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -541,7 +541,7 @@ int iwl_mvm_sta_tx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		       int tid, u8 queue, bool start);
 
 int iwl_mvm_add_aux_sta(struct iwl_mvm *mvm);
-void iwl_mvm_del_aux_sta(struct iwl_mvm *mvm);
+int iwl_mvm_rm_aux_sta(struct iwl_mvm *mvm);
 
 int iwl_mvm_alloc_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
-- 
2.25.1

