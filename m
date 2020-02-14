Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E399315EF6D
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389930AbgBNRrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:47:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:45106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389042AbgBNQAA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:00:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6027222314;
        Fri, 14 Feb 2020 15:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695999;
        bh=Mn14DlESABQtKLvTvserqm6tq4FNSFJNS1Etw+77Saw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oIdxHk/AS+9NYO3E3F860ero/nsI+gjL6W1yvw80JPdJmPfn6SDLP0JBcWtFfuoEp
         aKLHe0H8mJWyKvbly9zg9cJ8Zi4RYO8glVCEQchTGXfmi+uX1ep/HK91b/y/8u/pDf
         aCdNHOnz1WLmWz6UY+dLu2vKANLF2Zt6ccSUSLsM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 518/542] iwlwifi: mvm: Check the sta is not NULL in iwl_mvm_cfg_he_sta()
Date:   Fri, 14 Feb 2020 10:48:30 -0500
Message-Id: <20200214154854.6746-518-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

[ Upstream commit 12d47f0ea5e0aa63f19ba618da55a7c67850ca10 ]

Fix a kernel panic by checking that the sta is not NULL.
This could happen during a reconfig flow, as mac80211 moves the sta
between all the states without really checking if the previous state was
successfully set. So, if for some reason we failed to add back the
station, subsequent calls to sta_state() callback will be done when the
station is NULL. This would result in a following panic:

BUG: unable to handle kernel NULL pointer dereference at
0000000000000040
IP: iwl_mvm_cfg_he_sta+0xfc/0x690 [iwlmvm]
[..]
Call Trace:
 iwl_mvm_mac_sta_state+0x629/0x6f0 [iwlmvm]
 drv_sta_state+0xf4/0x950 [mac80211]
 ieee80211_reconfig+0xa12/0x2180 [mac80211]
 ieee80211_restart_work+0xbb/0xe0 [mac80211]
 process_one_work+0x1e2/0x610
 worker_thread+0x4d/0x3e0
[..]

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 6717f25c46b1c..8ecd1f6875deb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -5,10 +5,9 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019 Intel Corporation
+ * Copyright(c) 2012 - 2014, 2018 - 2020 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -28,10 +27,9 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019 Intel Corporation
+ * Copyright(c) 2012 - 2014, 2018 - 2020 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -2037,7 +2035,7 @@ static void iwl_mvm_cfg_he_sta(struct iwl_mvm *mvm,
 	rcu_read_lock();
 
 	sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_ctxt_cmd.sta_id]);
-	if (IS_ERR(sta)) {
+	if (IS_ERR_OR_NULL(sta)) {
 		rcu_read_unlock();
 		WARN(1, "Can't find STA to configure HE\n");
 		return;
-- 
2.20.1

