Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4515457875
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbfF0Ab7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726612AbfF0Ab5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:31:57 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86504217D7;
        Thu, 27 Jun 2019 00:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595516;
        bh=ZA9VrjagleecdpQ2Yn/1Dmj0Ua5l12GIiKFBWyy0Ugc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OgYcjRRPBI7QU9TosWs0LY33fAGORrODKfoZt0qiw15WW87P5G1FzFA5i7MeAxmbg
         cbCk81Ibv1HpjD55wzcQIqKvakqPAJhhg7uoJb+oFV/EhWsRH5UJOaVl6VWKLp12l3
         cIUFbdWX0GYT1i3V+SDRxIVVz9zcZUgkJ3guKzqg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matt Chen <matt.chen@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 27/95] iwlwifi: fix AX201 killer sku loading firmware issue
Date:   Wed, 26 Jun 2019 20:29:12 -0400
Message-Id: <20190627003021.19867-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matt Chen <matt.chen@intel.com>

[ Upstream commit b17dc0632a17fbfe66b34ee7c24e1cc10cfc503e ]

When try to bring up the AX201 2 killer sku, we
run into:
[81261.392463] iwlwifi 0000:01:00.0: loaded firmware version 46.8c20f243.0 op_mode iwlmvm
[81261.407407] iwlwifi 0000:01:00.0: Detected Intel(R) Dual Band Wireless AX 22000, REV=0x340
[81262.424778] iwlwifi 0000:01:00.0: Collecting data: trigger 16 fired.
[81262.673359] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[81262.673365] iwlwifi 0000:01:00.0: Status: 0x00000000, count: -906373681
[81262.673368] iwlwifi 0000:01:00.0: Loaded firmware version: 46.8c20f243.0
[81262.673371] iwlwifi 0000:01:00.0: 0x507C015D | ADVANCED_SYSASSERT

Fix this issue by adding 2 more cfg to avoid modifying the
original cfg configuration.

Signed-off-by: Matt Chen <matt.chen@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 2a03d34afa3b..80695584e406 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3585,7 +3585,9 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		}
 	} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 		   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR) &&
-		   (trans->cfg != &iwl_ax200_cfg_cc ||
+		   ((trans->cfg != &iwl_ax200_cfg_cc &&
+		    trans->cfg != &killer1650x_2ax_cfg &&
+		    trans->cfg != &killer1650w_2ax_cfg) ||
 		    trans->hw_rev == CSR_HW_REV_TYPE_QNJ_B0)) {
 		u32 hw_status;
 
-- 
2.20.1

