Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA92404D5F
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344118AbhIIMCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:02:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345873AbhIIL75 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:59:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5569615E1;
        Thu,  9 Sep 2021 11:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187964;
        bh=IlDkFE/49KxnaZ9iZ9njirpbhLIXAYkUrhv+dy3zJ90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DXE5RZ3aNcWpm/oKMr/akb8VAGxaxr9jPg2uPqefmFugrSeV5vw6LOKn0p31L3oRw
         5IuBzgSbIAwl6NN9BbQMPTqeq/UYYMtrAH3dgHmWxZRnFHpzmntpYm9Dd1OaORf4um
         kwdtSGCljDvxHVToIdvq+5sCrlGZ6kKn9KvE+WfpPwRMINn4aDo8nRBclDRi2fCeJC
         w2/Xw2YGonkveXTIqF8jlPU3ZHaBqfdOjpB+o8KWJGcDu1nGTnOku0F7ZDcgzTzX2u
         cMSekVzrzQRCjGwlTmzg12scjhfn+ytnXOqAONZy9oA2keDvJVFV/Q8THUeY3GAW7I
         kNScH7H7q7Z6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 229/252] iwlwifi: mvm: Do not use full SSIDs in 6GHz scan
Date:   Thu,  9 Sep 2021 07:40:43 -0400
Message-Id: <20210909114106.141462-229-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit deedf9b97cd4ef45da476c9bdd2a5f3276053956 ]

The scan request processing populated the direct SSIDs
in the FW scan request command also for 6GHz scan, which is not
needed and might result in unexpected behavior.

Fix the code to add the direct SSIDs only in case the scan
is not a 6GHz scan.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210802170640.f465937c7bbf.Ic11a1659ddda850c3ec1b1afbe9e2b9577ac1800@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 0368b7101222..4899d8f90bab 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -2368,14 +2368,17 @@ static int iwl_mvm_scan_umac_v14(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (ret)
 		return ret;
 
-	iwl_mvm_scan_umac_fill_probe_p_v4(params, &scan_p->probe_params,
-					  &bitmap_ssid);
 	if (!params->scan_6ghz) {
+		iwl_mvm_scan_umac_fill_probe_p_v4(params, &scan_p->probe_params,
+					  &bitmap_ssid);
 		iwl_mvm_scan_umac_fill_ch_p_v6(mvm, params, vif,
-					       &scan_p->channel_params, bitmap_ssid);
+				       &scan_p->channel_params, bitmap_ssid);
 
 		return 0;
+	} else {
+		pb->preq = params->preq;
 	}
+
 	cp->flags = iwl_mvm_scan_umac_chan_flags_v2(mvm, params, vif);
 	cp->n_aps_override[0] = IWL_SCAN_ADWELL_N_APS_GO_FRIENDLY;
 	cp->n_aps_override[1] = IWL_SCAN_ADWELL_N_APS_SOCIAL_CHS;
-- 
2.30.2

