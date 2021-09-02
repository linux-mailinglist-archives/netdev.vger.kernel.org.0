Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C293FEC5E
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 12:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244373AbhIBKtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 06:49:51 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:52760 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233801AbhIBKts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 06:49:48 -0400
X-Greylist: delayed 2247 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Sep 2021 06:49:47 EDT
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <luca@coelho.fi>)
        id 1mLjgW-0003qO-1z; Thu, 02 Sep 2021 13:11:04 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     torvalds@linux-foundation.org, johannes@sipsolutions.net,
        kuba@kernel.org
Cc:     kvalo@codeaurora.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        miriam.rachel.korenblitz@intel.com
Date:   Thu,  2 Sep 2021 13:11:01 +0300
Message-Id: <20210902101101.383243-1-luca@coelho.fi>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <635201a071bb6940ac9c1f381efef6abeed13f70.camel@intel.com>
References: <635201a071bb6940ac9c1f381efef6abeed13f70.camel@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        TVD_RCVD_IP autolearn=ham autolearn_force=no version=3.4.6
Subject: [PATCH] iwlwifi: mvm: add rtnl_lock() in iwl_mvm_start_get_nvm()
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Due to a rebase damage, we lost the rtnl_lock() when the patch was
sent out.  This causes an RTNL imbalance and failed assertions, due to
missing RTNL protection, for instance:

  RTNL: assertion failed at net/wireless/reg.c (4025)
  WARNING: CPU: 60 PID: 1720 at net/wireless/reg.c:4025 regulatory_set_wiphy_regd_sync+0x7f/0x90 [cfg80211]
  Call Trace:
   iwl_mvm_init_mcc+0x170/0x190 [iwlmvm]
   iwl_op_mode_mvm_start+0x824/0xa60 [iwlmvm]
   iwl_opmode_register+0xd0/0x130 [iwlwifi]
   init_module+0x23/0x1000 [iwlmvm]

Fix this by adding the missing rtnl_lock() back to the code.

Fixes: eb09ae93dabf ("iwlwifi: mvm: load regdomain at INIT stage")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 6f60018feed1..77ea2d0a3091 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -686,6 +686,7 @@ static int iwl_mvm_start_get_nvm(struct iwl_mvm *mvm)
 {
 	int ret;
 
+	rtnl_lock();
 	mutex_lock(&mvm->mutex);
 
 	ret = iwl_run_init_mvm_ucode(mvm);
-- 
2.33.0

