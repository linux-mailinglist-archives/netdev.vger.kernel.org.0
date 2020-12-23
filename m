Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CEB2E1323
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730813AbgLWC2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:28:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:55734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729788AbgLWC0N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:26:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7967C22A83;
        Wed, 23 Dec 2020 02:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690358;
        bh=OmvrlJhJ/YifQyy3+guv6v5apGg8Wr1Wj2N56B5e2zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fYr65u/xeS1819Ej0P23U3kwT24+mBwwH5DYImWiOSyR/uS6zjYfyclayIUT7Dj61
         LWGNRoIAh3hM56LFFUpw1dfFQkf+UXGNmAZFZZ19+GjoReYooqKI/JCpnnvKisXGKX
         RM4vhQNSgfjBBZMCphBnL7krhr1W3nfLTaLdQ+GJcsInnj1+Uf0x3FG2uyrdrLaYhT
         mV4bVhhW0DSsduEHDCl9GaYll2hRwWlAiJ5DjMtrzwLlbiO+2fB7LlEwkmHuW5UNuH
         H6oPRYes6SRkDYE/+WnujIFCj1zZGbTfP/VE+yfmxNEYififQVhLHZDWbODjq8gmjt
         n5ceuRYYDCggw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 33/38] iwlwifi: trans: consider firmware dead after errors
Date:   Tue, 22 Dec 2020 21:25:11 -0500
Message-Id: <20201223022516.2794471-33-sashal@kernel.org>
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

[ Upstream commit 152fdc0f698896708f9d7889a4ba4da6944b74f7 ]

If we get an error, no longer consider the firmware to be
in IWL_TRANS_FW_ALIVE state.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201209231352.a9d01e79c1c7.Ib2deb076b392fb516a7230bac91d7ab8a9586d86@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 6f76525088f0e..8dd30de1976f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -1102,8 +1102,10 @@ static inline void iwl_trans_fw_error(struct iwl_trans *trans)
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

