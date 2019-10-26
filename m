Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D280E5D29
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfJZNRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:17:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727128AbfJZNRG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:17:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A9F92245B;
        Sat, 26 Oct 2019 13:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095825;
        bh=IwXLtZYSRQETy3vtwD0q6ws/+iJoqLTX5++fq33rcuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZE7glz/XzUaFWoJ5FobkIGsyOiIgrXVDOo3KF/3Vs4wL0mJRaGDUtxTvMI6pSa7y
         3pbtfzfW3izKuolCWprkrFO4N6DYYfOdqlKof1knCMIhr94Eeb8d/Z9jXksez8qy0C
         T1lMSeFB2t2/i7O4aqxukAKbr8LK1f6FD7CJD6ig=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 35/99] iwlwifi: mvm: fix race in sync rx queue notification
Date:   Sat, 26 Oct 2019 09:14:56 -0400
Message-Id: <20191026131600.2507-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Naftali Goldstein <naftali.goldstein@intel.com>

[ Upstream commit a2113cc44d4387a7c3ef3a9082d273524f9230ac ]

Consider the following flow:
 1. Driver starts to sync the rx queues due to a delba.
    mvm->queue_sync_cookie=1.
    This rx-queues-sync is synchronous, so it doesn't increment the
    cookie until all rx queues handle the notification from FW.
 2. During this time, driver starts to sync rx queues due to nssn sync
    required.
    The cookie's value is still 1, but it doesn't matter since this
    rx-queue-sync is non-synchronous so in the notification handler the
    cookie is ignored.
    What _does_ matter is that this flow increments the cookie to 2
    immediately.
    Remember though that the FW won't start servicing this command until
    it's done with the previous one.
 3. FW is still handling the first command, so it sends a notification
    with internal_notif->sync=1, and internal_notif->cookie=0, which
    triggers a WARN_ONCE.

The solution for this race is to only use the mvm->queue_sync_cookie in
case of a synchronous sync-rx-queues. This way in step 2 the cookie's
value won't change so we avoid the WARN.

The commit in the "fixes" field is the first commit to introduce
non-synchronous sending of this command to FW.

Fixes: 3c514bf831ac ("iwlwifi: mvm: add a loose synchronization of the NSSN across Rx queues")
Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index a7bc00d1296fe..24a6beaacb156 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -5080,11 +5080,11 @@ void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm,
 	if (!iwl_mvm_has_new_rx_api(mvm))
 		return;
 
-	notif->cookie = mvm->queue_sync_cookie;
-
-	if (notif->sync)
+	if (notif->sync) {
+		notif->cookie = mvm->queue_sync_cookie;
 		atomic_set(&mvm->queue_sync_counter,
 			   mvm->trans->num_rx_queues);
+	}
 
 	ret = iwl_mvm_notify_rx_queue(mvm, qmask, (u8 *)notif,
 				      size, !notif->sync);
@@ -5104,7 +5104,8 @@ void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm,
 
 out:
 	atomic_set(&mvm->queue_sync_counter, 0);
-	mvm->queue_sync_cookie++;
+	if (notif->sync)
+		mvm->queue_sync_cookie++;
 }
 
 static void iwl_mvm_sync_rx_queues(struct ieee80211_hw *hw)
-- 
2.20.1

