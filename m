Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2A5813E128
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbgAPQsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:48:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:58078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730113AbgAPQsA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:48:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF49220663;
        Thu, 16 Jan 2020 16:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193279;
        bh=ylrQYMiUd958FmaBqH6W2z+JR6vME6Lajrty0yVxl4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yflLwB7+G0XhdyYmQBnKlNJhRkN2tusLhaIYDMYtVLQkXMu2NiKjjoYiiBoQdRI2c
         /I5xt2GZv/CpPiaWqi5nDOoPw6bUwCHcDqcjXJJTqxSfTsoLER+wHulcRZjcGLK8GR
         L3HfJEZw3ahEjtklDzDMmfFCUbWS+2ALrnBn7CxM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 064/205] iwlwifi: mvm: consider ieee80211 station max amsdu value
Date:   Thu, 16 Jan 2020 11:40:39 -0500
Message-Id: <20200116164300.6705-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit ee4cce9b9d6421d037ffc002536b918fd7f4aff3 ]

debugfs amsdu_len sets only the max_amsdu_len for ieee80211 station
so take it into consideration while getting max amsdu

Fixes: af2984e9e625 ("iwlwifi: mvm: add a debugfs entry to set a fixed size AMSDU for all TX packets")
Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c | 8 +++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c    | 7 ++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index 8f50e2b121bd..098d48153a38 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -350,7 +350,13 @@ void iwl_mvm_tlc_update_notif(struct iwl_mvm *mvm,
 		u16 size = le32_to_cpu(notif->amsdu_size);
 		int i;
 
-		if (WARN_ON(sta->max_amsdu_len < size))
+		/*
+		 * In debug sta->max_amsdu_len < size
+		 * so also check with orig_amsdu_len which holds the original
+		 * data before debugfs changed the value
+		 */
+		if (WARN_ON(sta->max_amsdu_len < size &&
+			    mvmsta->orig_amsdu_len < size))
 			goto out;
 
 		mvmsta->amsdu_enabled = le32_to_cpu(notif->amsdu_enabled);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 8a059da7a1fa..e3b2a2bf3863 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -935,7 +935,12 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	    !(mvmsta->amsdu_enabled & BIT(tid)))
 		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
 
-	max_amsdu_len = iwl_mvm_max_amsdu_size(mvm, sta, tid);
+	/*
+	 * Take the min of ieee80211 station and mvm station
+	 */
+	max_amsdu_len =
+		min_t(unsigned int, sta->max_amsdu_len,
+		      iwl_mvm_max_amsdu_size(mvm, sta, tid));
 
 	/*
 	 * Limit A-MSDU in A-MPDU to 4095 bytes when VHT is not
-- 
2.20.1

