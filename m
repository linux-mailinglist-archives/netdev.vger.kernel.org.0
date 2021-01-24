Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D996301A70
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 09:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbhAXINL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 03:13:11 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:47931 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbhAXIMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 03:12:55 -0500
Received: from localhost.localdomain ([92.131.99.25])
        by mwinf5d58 with ME
        id LYBC240090Ys01Y03YBCwG; Sun, 24 Jan 2021 09:11:13 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 24 Jan 2021 09:11:13 +0100
X-ME-IP: 92.131.99.25
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     luciano.coelho@intel.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        mordechay.goodstein@intel.com, johannes.berg@intel.com,
        sara.sharon@intel.com, nathan.errera@intel.com,
        Dan1.Halperin@intel.com, emmanuel.grumbach@intel.com,
        naftali.goldstein@intel.com, netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH v2] iwlwifi: mvm: Fix an error handling path in 'iwl_mvm_wowlan_config_key_params()'
Date:   Sun, 24 Jan 2021 09:11:07 +0100
Message-Id: <20210124081107.732360-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the 'cmd_ver' check fails, we must release some memory as already done
in all the other error handling paths of this function.

Fixes: 9e3c39361a30 ("iwlwifi: mvm: support new KEK KCK api")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
v1->v2: Fix the subject
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index c025188fa9bc..2fb897cbfca6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -810,8 +810,10 @@ static int iwl_mvm_wowlan_config_key_params(struct iwl_mvm *mvm,
 						WOWLAN_KEK_KCK_MATERIAL,
 						IWL_FW_CMD_VER_UNKNOWN);
 		if (WARN_ON(cmd_ver != 2 && cmd_ver != 3 &&
-			    cmd_ver != IWL_FW_CMD_VER_UNKNOWN))
-			return -EINVAL;
+			    cmd_ver != IWL_FW_CMD_VER_UNKNOWN)) {
+			ret = -EINVAL;
+			goto out;
+		}
 		if (cmd_ver == 3)
 			cmd_size = sizeof(struct iwl_wowlan_kek_kck_material_cmd_v3);
 		else
-- 
2.27.0

