Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084BA2E13D1
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730676AbgLWCfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:35:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:54958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728649AbgLWCYm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1333622285;
        Wed, 23 Dec 2020 02:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690241;
        bh=pYqKZDBD/Z+Xi+SGmb6fikkE+l3hFSPgaMm2LW/Q7a0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G9ETVnSR1ZTk/0wbgjMgbaFulkbi8qrTx8J8XAv4ZQIMRWakGvDoLd5SMhJaGOQr7
         4O7fH8rceuRXP4hUwVZKCcztdfYwda8UVOltZbzWxYbPuSoyDzp2Ag9Yb4bBUBYo+K
         QV/zvRyPwIstq+UGb6DxaIma3xqdrZ6dsHeubCLHvrJSKc3erYPjoEOvyN6ycSt/FR
         86CZ5+HJiucx6GpisATetacdtbMViSknPmN3i3/JuTHaW72Uva3OkcvfxPulmC1oRl
         N58tJEPjhzhGTAAHA1+2aoRNbbM9xhJj9HWAk2LYiLnVndgmuwbuD+NWn16JI6DXlr
         zw0xT91/gsPBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 55/66] iwlwifi: trans: consider firmware dead after errors
Date:   Tue, 22 Dec 2020 21:22:41 -0500
Message-Id: <20201223022253.2793452-55-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 152fdc0f698896708f9d7889a4ba4da6944b74f7 ]

If we get an error, no longer consider the firmware to be
in IWL_TRANS_FW_ALIVE state.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201209231352.a9d01e79c1c7.Ib2deb076b392fb516a7230bac91d7ab8a9586d86@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index ecd5c1df811ca..7de7dac3260ce 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -1181,8 +1181,10 @@ static inline void iwl_trans_fw_error(struct iwl_trans *trans)
 		return;
 
 	/* prevent double restarts due to the same erroneous FW */
-	if (!test_and_set_bit(STATUS_FW_ERROR, &trans->status))
+	if (!test_and_set_bit(STATUS_FW_ERROR, &trans->status)) {
 		iwl_op_mode_nic_error(trans->op_mode);
+		trans->state = IWL_TRANS_NO_FW;
+	}
 }
 
 /*****************************************************
-- 
2.27.0

