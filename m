Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6362E131A
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbgLWC2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:28:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730813AbgLWC0O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:26:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B192F22273;
        Wed, 23 Dec 2020 02:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690359;
        bh=sWQGtVQf3/N0vVvHADMoc+JEYJhR94KGod+bU12/zT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IW+vbORsAMg4QaS/ZDTyQ01TIgo3Q1847wI9b6rlR9moMD2cYkf9IJPMtaXROyAJm
         3r6GICRGV7M9wkPOJULjjZSY7F76XZkC9TbIvJtD6e2o2F+5cFVO31sBSq9nwEQNYC
         m4qpr6v3cf2TWxQVSEYxWvB80/Bfb7bn350DIJn9oxsno2fycD4P3FzR56Hes88gq1
         F3uwYynO94ryWv6jJDDB518YBTBbuI+YiaZtIt5teOjDdZhy7AoRWshriK7JE6bCY8
         o6D6eBUO2+ExJJavLKHSbD9mwgJZxBdNrBcx+GxQSm8WGiCNL1DEWfP8ITCeL+QjG/
         PiNiIZF++Nt/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 34/38] iwlwifi: add an extra firmware state in the transport
Date:   Tue, 22 Dec 2020 21:25:12 -0500
Message-Id: <20201223022516.2794471-34-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022516.2794471-1-sashal@kernel.org>
References: <20201223022516.2794471-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b2ed841ed070ccbe908016537f429a3a8f0221bf ]

Start tracking not just if the firmware is dead or alive,
but also if it's starting.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201209231352.33e50d40b688.I8bbd41af7aa5e769273a6fc1c06fbf548dd2eb26@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 8dd30de1976f0..ea60143e60fa4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -619,12 +619,14 @@ struct iwl_trans_ops {
 /**
  * enum iwl_trans_state - state of the transport layer
  *
- * @IWL_TRANS_NO_FW: no fw has sent an alive response
- * @IWL_TRANS_FW_ALIVE: a fw has sent an alive response
+ * @IWL_TRANS_NO_FW: firmware wasn't started yet, or crashed
+ * @IWL_TRANS_FW_STARTED: FW was started, but not alive yet
+ * @IWL_TRANS_FW_ALIVE: FW has sent an alive response
  */
 enum iwl_trans_state {
-	IWL_TRANS_NO_FW = 0,
-	IWL_TRANS_FW_ALIVE	= 1,
+	IWL_TRANS_NO_FW,
+	IWL_TRANS_FW_STARTED,
+	IWL_TRANS_FW_ALIVE,
 };
 
 /**
@@ -780,12 +782,18 @@ static inline int iwl_trans_start_fw(struct iwl_trans *trans,
 				     const struct fw_img *fw,
 				     bool run_in_rfkill)
 {
+	int ret;
+
 	might_sleep();
 
 	WARN_ON_ONCE(!trans->rx_mpdu_cmd);
 
 	clear_bit(STATUS_FW_ERROR, &trans->status);
-	return trans->ops->start_fw(trans, fw, run_in_rfkill);
+	ret = trans->ops->start_fw(trans, fw, run_in_rfkill);
+	if (ret == 0)
+		trans->state = IWL_TRANS_FW_STARTED;
+
+	return ret;
 }
 
 static inline int iwl_trans_update_sf(struct iwl_trans *trans,
-- 
2.27.0

