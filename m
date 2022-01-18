Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0649B491A02
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350664AbiARC5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350217AbiARCvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:51:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C6EC061A82;
        Mon, 17 Jan 2022 18:42:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20B4B612D5;
        Tue, 18 Jan 2022 02:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066DCC36AEF;
        Tue, 18 Jan 2022 02:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473748;
        bh=qGUA5Sjaby0CcmdyL1x0eQfhorlxZK98VIp5iNaJCp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nhX2CSQ9KCix0bo4dIfSRKxeV89gTDTERfamUal2MF6f0tuxOwZ6FG3sqEiZln5Gb
         2fxvfaRw8wWrCnpRruvhC4q1Ez96pcphbKyqX2+TsVTm9olEXRIj7EdOA9T9L40qUo
         25flFAsk6GX+uGR71Xo0i5vHGRrARwTLgTa+mgnWTmVfa3Ub26xz5Rslw2jhXo9Mnq
         E6+rnF6e/iNBOGLf9PFNxrg+P0OUNKPieFtOSHtOLOumW4gCY+p4VARRFpRAgkNeZA
         0NVNX1q+/5sDW6Z5/8RKw1iKU9QbLME4xaKk+g9vamiLT01zfTwveCc9kT5BI9D2XY
         Sye8vF8cAwlgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, emmanuel.grumbach@intel.com,
        avraham.stern@intel.com, ilan.peer@intel.com,
        sara.sharon@intel.com, nathan.errera@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 051/116] iwlwifi: mvm: avoid clearing a just saved session protection id
Date:   Mon, 17 Jan 2022 21:39:02 -0500
Message-Id: <20220118024007.1950576-51-sashal@kernel.org>
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

From: Shaul Triebitz <shaul.triebitz@intel.com>

[ Upstream commit 8e967c137df3b236d2075f9538cb888129425d1a ]

When scheduling a session protection the id is saved but
then it may be cleared when calling iwl_mvm_te_clear_data
(if a previous session protection is currently active).
Fix it by saving the id after calling iwl_mvm_te_clear_data.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211204130722.b0743a588d14.I098fef6677d0dab3ef1b6183ed206a10bab01eb2@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 394598b14a173..6e6e5dd1b30d2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -1157,15 +1157,10 @@ void iwl_mvm_schedule_session_protection(struct iwl_mvm *mvm,
 			cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id,
 							mvmvif->color)),
 		.action = cpu_to_le32(FW_CTXT_ACTION_ADD),
+		.conf_id = cpu_to_le32(SESSION_PROTECT_CONF_ASSOC),
 		.duration_tu = cpu_to_le32(MSEC_TO_TU(duration)),
 	};
 
-	/* The time_event_data.id field is reused to save session
-	 * protection's configuration.
-	 */
-	mvmvif->time_event_data.id = SESSION_PROTECT_CONF_ASSOC;
-	cmd.conf_id = cpu_to_le32(mvmvif->time_event_data.id);
-
 	lockdep_assert_held(&mvm->mutex);
 
 	spin_lock_bh(&mvm->time_event_lock);
@@ -1179,6 +1174,11 @@ void iwl_mvm_schedule_session_protection(struct iwl_mvm *mvm,
 	}
 
 	iwl_mvm_te_clear_data(mvm, te_data);
+	/*
+	 * The time_event_data.id field is reused to save session
+	 * protection's configuration.
+	 */
+	te_data->id = le32_to_cpu(cmd.conf_id);
 	te_data->duration = le32_to_cpu(cmd.duration_tu);
 	spin_unlock_bh(&mvm->time_event_lock);
 
-- 
2.34.1

