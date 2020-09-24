Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7671C276933
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 08:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgIXGsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 02:48:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44936 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgIXGsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 02:48:18 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1kLL31-00029j-H1; Thu, 24 Sep 2020 06:48:08 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        Tova Mussai <tova.mussai@intel.com>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Naftali Goldstein <naftali.goldstein@intel.com>,
        linux-wireless@vger.kernel.org (open list:INTEL WIRELESS WIFI LINK
        (iwlwifi)), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] iwlwifi: mvm: Increase session protection duration for association
Date:   Thu, 24 Sep 2020 14:48:00 +0800
Message-Id: <20200924064802.3441-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometimes Intel AX201 fails to associate with AP:
[  839.290042] wlp0s20f3: authenticate with xx:xx:xx:xx:xx:xx
[  839.291737] wlp0s20f3: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[  839.350010] wlp0s20f3: send auth to xx:xx:xx:xx:xx:xx (try 2/3)
[  839.360826] wlp0s20f3: authenticated
[  839.363205] wlp0s20f3: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[  839.370342] wlp0s20f3: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x431 status=0 aid=12)
[  839.378925] wlp0s20f3: associated
[  839.431788] wlp0s20f3: deauthenticated from xx:xx:xx:xx:xx:xx (Reason: 2=PREV_AUTH_NOT_VALID)

It fails because EAPOL hasn't finished. Increase the  session protection
duration to 1200TU can eliminate the problem.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=209237
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 9374c85c5caf..54acd9a68955 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3297,13 +3297,13 @@ static void iwl_mvm_mac_mgd_prepare_tx(struct ieee80211_hw *hw,
 	 * session for a much longer time since the firmware will internally
 	 * create two events: a 300TU one with a very high priority that
 	 * won't be fragmented which should be enough for 99% of the cases,
-	 * and another one (which we configure here to be 900TU long) which
+	 * and another one (which we configure here to be 1200TU long) which
 	 * will have a slightly lower priority, but more importantly, can be
 	 * fragmented so that it'll allow other activities to run.
 	 */
 	if (fw_has_capa(&mvm->fw->ucode_capa,
 			IWL_UCODE_TLV_CAPA_SESSION_PROT_CMD))
-		iwl_mvm_schedule_session_protection(mvm, vif, 900,
+		iwl_mvm_schedule_session_protection(mvm, vif, 1200,
 						    min_duration, false);
 	else
 		iwl_mvm_protect_session(mvm, vif, duration,
-- 
2.17.1

