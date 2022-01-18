Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4144917A0
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347684AbiARCmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:42:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51560 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344322AbiARCgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:36:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B5BB61291;
        Tue, 18 Jan 2022 02:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C08BC36AEB;
        Tue, 18 Jan 2022 02:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473377;
        bh=22TBzvVqrxec+4D1GlxVLaO6klk4pPbSwURl8EjB0iY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIMGJ+FLZlAFKchi1C6SefhH0HxVfTbsBCjfTQ/Uo1NE0EHuuiWeul6yaix/imS5e
         sycdeCxjLLL6R6DNuTjo3XzPDEDaDOkdH+C22q9zqiePa5qVF2N1oH2p55AU6/GdXY
         uEF+k68SnHgXvnp9yxYwEQO1kK1/tjCgSDZ8XGoOWWM0VnVRi2oTRoWie/ddSwFGyO
         sKBdsLh1SlSvTtIYUJlq95WEjCm3ph7ELh8dHnRPC0D0yhoJ8yuHBvo/bHHzS7WRJ/
         rAUW7Eq+FG0B17Yz6Xvteh5y1FQBEpjQIDgZjly/7BOPoGHYQ405H8KqCk8i4azBoj
         rNBxDmQ4QGVhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, ilan.peer@intel.com,
        avraham.stern@intel.com, emmanuel.grumbach@intel.com,
        sara.sharon@intel.com, nathan.errera@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 091/188] iwlwifi: mvm: avoid clearing a just saved session protection id
Date:   Mon, 17 Jan 2022 21:30:15 -0500
Message-Id: <20220118023152.1948105-91-sashal@kernel.org>
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
index e91f8e889df70..e6813317edf35 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -1158,15 +1158,10 @@ void iwl_mvm_schedule_session_protection(struct iwl_mvm *mvm,
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
@@ -1180,6 +1175,11 @@ void iwl_mvm_schedule_session_protection(struct iwl_mvm *mvm,
 	}
 
 	iwl_mvm_te_clear_data(mvm, te_data);
+	/*
+	 * The time_event_data.id field is reused to save session
+	 * protection's configuration.
+	 */
+	te_data->id = le32_to_cpu(cmd.conf_id);
 	te_data->duration = le32_to_cpu(cmd.duration_tu);
 	te_data->vif = vif;
 	spin_unlock_bh(&mvm->time_event_lock);
-- 
2.34.1

