Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E52E491A01
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350385AbiARC5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350172AbiARCvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:51:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F14C061A7F;
        Mon, 17 Jan 2022 18:42:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E22E1B81244;
        Tue, 18 Jan 2022 02:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C54BC36AE3;
        Tue, 18 Jan 2022 02:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473744;
        bh=hhcJmuN2kWlMk96NPFUrqTDWUoSgBnttal2l50VDvZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dh5HEAsf+mcalT78LvKyI8CfCzDYneBFOJG3Y/Y1eyupAS8kD7AasesYx2DWMiNzm
         79V6i6Ad65OBGYNxlVyu8CvoCfZrxtpgHaE6dV2AZH+9x9mJvbD71eUy6ekULTq9Fa
         87RmoFN4NeLSwWAliJKryBOlMIxERMXl/frB8VmO/5P65wrkb/+BtRmw9p097GZK5S
         DPba5FJizb2v0iz48mBSTWMNlBEiG95yhpF8lkDMgk7LJp5y4JZQoqTQRb/6iAOAGE
         9d4daJ1ZDBQsiWgshXGBuTLmg9mYEqFkuLjzG03dxZVn4fKEEmRKpudv73favzcGqm
         CE6mCl8YjIUcA==
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
Subject: [PATCH AUTOSEL 5.10 050/116] iwlwifi: mvm: synchronize with FW after multicast commands
Date:   Mon, 17 Jan 2022 21:39:01 -0500
Message-Id: <20220118024007.1950576-50-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index 81cc85a97eb20..922a7ea0cd24e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1739,6 +1739,7 @@ static void iwl_mvm_recalc_multicast(struct iwl_mvm *mvm)
 	struct iwl_mvm_mc_iter_data iter_data = {
 		.mvm = mvm,
 	};
+	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1748,6 +1749,22 @@ static void iwl_mvm_recalc_multicast(struct iwl_mvm *mvm)
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

