Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304CA1F29F8
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731131AbgFHXVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:21:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730394AbgFHXVP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:21:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96CD320823;
        Mon,  8 Jun 2020 23:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658475;
        bh=caU9kQfvMODb0OJ2Hu0o+ztCJtskyU9GmhAPkivUg70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTei9LQKW1gU1ekE14ScOuYJADuOQdK++79/m5/BWEutTTbC03BqVAJhHnpjp6hfP
         Vurinn8MKRWkTtrWlTNhQjHyQEt2oOlyNioEYsxlj8BkdwbFCU/YqDv+as8HS9BxSd
         YWdfV8878uDo3DGw4TtA7an0mOmCBavwsDasp6IA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 112/175] iwlwifi: avoid debug max amsdu config overwriting itself
Date:   Mon,  8 Jun 2020 19:17:45 -0400
Message-Id: <20200608231848.3366970-112-sashal@kernel.org>
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

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit a65a5824298b06049dbaceb8a9bd19709dc9507c ]

If we set amsdu_len one after another the second one overwrites
the orig_amsdu_len so allow only moving from debug to non debug state.

Also the TLC update check was wrong: it was checking that also the orig
is smaller then the new updated size, which is not the case in debug
amsdu mode.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Fixes: af2984e9e625 ("iwlwifi: mvm: add a debugfs entry to set a fixed size AMSDU for all TX packets")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200424182644.e565446a4fce.I9729d8c520d8b8bb4de9a5cdc62e01eb85168aac@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 11 +++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c   | 15 ++++++++-------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index ad18c2f1a806..524f9dd2323d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
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
@@ -478,6 +476,11 @@ static ssize_t iwl_dbgfs_amsdu_len_write(struct ieee80211_sta *sta,
 	if (kstrtou16(buf, 0, &amsdu_len))
 		return -EINVAL;
 
+	/* only change from debug set <-> debug unset */
+	if ((amsdu_len && mvmsta->orig_amsdu_len) ||
+	    (!!amsdu_len && mvmsta->orig_amsdu_len))
+		return -EBUSY;
+
 	if (amsdu_len) {
 		mvmsta->orig_amsdu_len = sta->max_amsdu_len;
 		sta->max_amsdu_len = amsdu_len;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index 5b2bd603febf..be8bc0601d7b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -367,14 +367,15 @@ void iwl_mvm_tlc_update_notif(struct iwl_mvm *mvm,
 		u16 size = le32_to_cpu(notif->amsdu_size);
 		int i;
 
-		/*
-		 * In debug sta->max_amsdu_len < size
-		 * so also check with orig_amsdu_len which holds the original
-		 * data before debugfs changed the value
-		 */
-		if (WARN_ON(sta->max_amsdu_len < size &&
-			    mvmsta->orig_amsdu_len < size))
+		if (sta->max_amsdu_len < size) {
+			/*
+			 * In debug sta->max_amsdu_len < size
+			 * so also check with orig_amsdu_len which holds the
+			 * original data before debugfs changed the value
+			 */
+			WARN_ON(mvmsta->orig_amsdu_len < size);
 			goto out;
+		}
 
 		mvmsta->amsdu_enabled = le32_to_cpu(notif->amsdu_enabled);
 		mvmsta->max_amsdu_len = size;
-- 
2.25.1

