Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6F44919F8
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245126AbiARC5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:57:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58558 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349795AbiARCuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:50:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62262B81195;
        Tue, 18 Jan 2022 02:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED05C36AE3;
        Tue, 18 Jan 2022 02:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474218;
        bh=mxpo7azuLvVJSmhungCbxM2H1VeWeju0pvLVr9SofE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EdgHM6mJoIsbwwe2hDPoM9yX3sxl3H1Tjin2EgPy10+mO2ZrOSBr6equ/EaQYLGBh
         qzYR5P16gFQTb28Uxl2TmSuzQgvp29n/tKjNhXOQiC4Nk58lCCE+jHVN0hGptZWWY0
         MumpI4dk0e1shhFmnAcrXt4dJCY3v/PW10swkEZ3N1Zk4pDdlPyMJvTYjihVkgEPdy
         3iIWTuBvpYKGG1h0P4pT4lT4UFJb9FAXvJdfplkolPbJ+l5QvoPFLOTAdnbxJlWMwS
         5899QmbKvJHPEfXy31S30Xc4YpscwCMfPr4TniXbfd3uUvOdcKaCQHf7pNraTMkVJq
         pATPintxddX9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Maximilian Ernestus <maximilian@ernestus.de>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        mordechay.goodstein@intel.com, miriam.rachel.korenblit@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 27/56] iwlwifi: mvm: synchronize with FW after multicast commands
Date:   Mon, 17 Jan 2022 21:48:39 -0500
Message-Id: <20220118024908.1953673-27-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024908.1953673-1-sashal@kernel.org>
References: <20220118024908.1953673-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit db66abeea3aefed481391ecc564fb7b7fb31d742 ]

If userspace installs a lot of multicast groups very quickly, then
we may run out of command queue space as we send the updates in an
asynchronous fashion (due to locking concerns), and the CPU can
create them faster than the firmware can process them. This is true
even when mac80211 has a work struct that gets scheduled.

Fix this by synchronizing with the firmware after sending all those
commands - outside of the iteration we can send a synchronous echo
command that just has the effect of the CPU waiting for the prior
asynchronous commands to finish. This also will cause fewer of the
commands to be sent to the firmware overall, because the work will
only run once when rescheduled multiple times while it's running.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=213649
Suggested-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reported-by: Maximilian Ernestus <maximilian@ernestus.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211204083238.51aea5b79ea4.I88a44798efda16e9fe480fb3e94224931d311b29@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c   | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index d82d8cfe2e41c..f896758a3fa31 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1608,6 +1608,7 @@ static void iwl_mvm_recalc_multicast(struct iwl_mvm *mvm)
 	struct iwl_mvm_mc_iter_data iter_data = {
 		.mvm = mvm,
 	};
+	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1617,6 +1618,22 @@ static void iwl_mvm_recalc_multicast(struct iwl_mvm *mvm)
 	ieee80211_iterate_active_interfaces_atomic(
 		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
 		iwl_mvm_mc_iface_iterator, &iter_data);
+
+	/*
+	 * Send a (synchronous) ech command so that we wait for the
+	 * multiple asynchronous MCAST_FILTER_CMD commands sent by
+	 * the interface iterator. Otherwise, we might get here over
+	 * and over again (by userspace just sending a lot of these)
+	 * and the CPU can send them faster than the firmware can
+	 * process them.
+	 * Note that the CPU is still faster - but with this we'll
+	 * actually send fewer commands overall because the CPU will
+	 * not schedule the work in mac80211 as frequently if it's
+	 * still running when rescheduled (possibly multiple times).
+	 */
+	ret = iwl_mvm_send_cmd_pdu(mvm, ECHO_CMD, 0, 0, NULL);
+	if (ret)
+		IWL_ERR(mvm, "Failed to synchronize multicast groups update\n");
 }
 
 static u64 iwl_mvm_prepare_multicast(struct ieee80211_hw *hw,
-- 
2.34.1

