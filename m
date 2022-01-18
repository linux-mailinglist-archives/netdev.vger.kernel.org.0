Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25374917A8
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347649AbiARCm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:42:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47930 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345206AbiARCia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:38:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA81AB811CC;
        Tue, 18 Jan 2022 02:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CAD4C36AE3;
        Tue, 18 Jan 2022 02:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473507;
        bh=Jlxo5S+yMxl2FOrgNcpwprHFy4eBW8lyXoh7M6q6Hcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OKrRR30IaPFhwMPLsF4099oT/v4t1Rg2uSySbfZg9pDIPp39we7TaefbdWC05TKzC
         TC34RkF5ZsYe59k4H3YGlTuun+3ws0da4IW0dNVsSNb+Ef+ioSgi8LJogNYaPjX8fG
         WZ/jDSeClKf2vj6ORpu9AG2w0nEyf5x0BBpD7eop0QCtFlZsi3n21KnXopad2m2wAl
         1QDQKEgWhw+zgkZhB2X3KOo1qVvutezjzuerbYmHpIi4YIcGnohxqlCIZw6hH3XQQW
         4NIJdlhMzCdq2eS4v2HtQFtSPoWGeWzhCIebe26GSNqlvb13CyJveyhpyfRc8O9Ter
         8Ndurb5RKphcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, shaul.triebitz@intel.com,
        ilan.peer@intel.com, emmanuel.grumbach@intel.com,
        sara.sharon@intel.com, nathan.errera@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 141/188] iwlwifi: mvm: fix AUX ROC removal
Date:   Mon, 17 Jan 2022 21:31:05 -0500
Message-Id: <20220118023152.1948105-141-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit f0337cb48f3bf5f0bbccc985d8a0a8c4aa4934b7 ]

When IWL_UCODE_TLV_CAPA_SESSION_PROT_CMD is set, removing a time event
always tries to cancel session protection. However, AUX ROC does
not use session protection so it was never removed. As a result,
if the driver tries to allocate another AUX ROC event right after
cancelling the first one, it will fail with a warning.
In addition, the time event data passed to iwl_mvm_remove_aux_roc_te()
is incorrect. Fix it.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211219132536.915e1f69f062.Id837e917f1c2beaca7c1eb33333d622548918a76@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index e6813317edf35..48383fdac634e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -687,11 +687,14 @@ static bool __iwl_mvm_remove_time_event(struct iwl_mvm *mvm,
 	iwl_mvm_te_clear_data(mvm, te_data);
 	spin_unlock_bh(&mvm->time_event_lock);
 
-	/* When session protection is supported, the te_data->id field
+	/* When session protection is used, the te_data->id field
 	 * is reused to save session protection's configuration.
+	 * For AUX ROC, HOT_SPOT_CMD is used and the te_data->id field is set
+	 * to HOT_SPOT_CMD.
 	 */
 	if (fw_has_capa(&mvm->fw->ucode_capa,
-			IWL_UCODE_TLV_CAPA_SESSION_PROT_CMD)) {
+			IWL_UCODE_TLV_CAPA_SESSION_PROT_CMD) &&
+	    id != HOT_SPOT_CMD) {
 		if (mvmvif && id < SESSION_PROTECT_CONF_MAX_ID) {
 			/* Session protection is still ongoing. Cancel it */
 			iwl_mvm_cancel_session_protection(mvm, mvmvif, id);
@@ -1027,7 +1030,7 @@ void iwl_mvm_stop_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 			iwl_mvm_p2p_roc_finished(mvm);
 		} else {
 			iwl_mvm_remove_aux_roc_te(mvm, mvmvif,
-						  &mvmvif->time_event_data);
+						  &mvmvif->hs_time_event_data);
 			iwl_mvm_roc_finished(mvm);
 		}
 
-- 
2.34.1

