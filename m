Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368A3491623
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245496AbiARCcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345343AbiARCb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:31:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37166C0613EF;
        Mon, 17 Jan 2022 18:28:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0BC1B8124E;
        Tue, 18 Jan 2022 02:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359F1C36AE3;
        Tue, 18 Jan 2022 02:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472935;
        bh=Jlxo5S+yMxl2FOrgNcpwprHFy4eBW8lyXoh7M6q6Hcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FNmZhv5/KmtKAikhSiAezJVSoM+7Ql+V6XUKgXs+07g1DkzanTjJxD2FrMM2sQVUz
         XCcIqxfkMzHx/D38ZiNsjZsaIUwARTXHn7w2nihjqjWzrp4QGByHngdrKMY+vl1s9E
         6ROv9FdA4gPeFLqxAqpeedTNYSys5Ig/1O3L2C4nsNzelBT2GTk3Asy11lkQV304BJ
         2Hh8njkBevZswqRCP/TXhSlWnVRJS8fjX7dVFRU2E8I4Y8XJenwifKxAehw4hie6yZ
         uY0Ms6NXBVySvNiSM9gd7UBGU+mbjcZ/RsRC2dxtCHuq+h0yYsPhbjBM72pd1mtlWU
         XM6Eej5J7URbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, shaul.triebitz@intel.com,
        emmanuel.grumbach@intel.com, sara.sharon@intel.com,
        ilan.peer@intel.com, nathan.errera@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 167/217] iwlwifi: mvm: fix AUX ROC removal
Date:   Mon, 17 Jan 2022 21:18:50 -0500
Message-Id: <20220118021940.1942199-167-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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

