Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633901F2EF2
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbgFHXLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:11:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728941AbgFHXLk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:11:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E343B20897;
        Mon,  8 Jun 2020 23:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657899;
        bh=6qFB+xmqfN7wt3Btr+n50UrRMA+WUXiQ88tCbhKAgm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NcVAQO8WgMuZiME8wwVHlXlkkj1n5Gpzr7k1er9V6yIM7OXEc9biqPsoCGnt8/a6P
         FuIcQqQZUirAzElBu/wqlAZmpHkfI+3OTaZUX5QqtRNePflZEqmZHuGY9PeLSri9UQ
         okmemf525p1r/DT8h8/+x0GAHmxzviOmuaVyK5U4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 253/274] iwlwifi: mvm: fix aux station leak
Date:   Mon,  8 Jun 2020 19:05:46 -0400
Message-Id: <20200608230607.3361041-253-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
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
index 7aa1350b093e..cf3c46c9b1ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1209,14 +1209,13 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm)
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
index 56ae72debb96..07ca8c91499d 100644
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

