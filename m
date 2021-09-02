Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9573B3FF507
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 22:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhIBUjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 16:39:20 -0400
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:29232 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235129AbhIBUjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 16:39:18 -0400
Received: from pop-os.home ([90.126.253.178])
        by mwinf5d54 with ME
        id p8eC2500A3riaq2038eDGc; Thu, 02 Sep 2021 22:38:16 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 02 Sep 2021 22:38:16 +0200
X-ME-IP: 90.126.253.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     luciano.coelho@intel.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, johannes.berg@intel.com,
        pierre-louis.bossart@linux.intel.com, drorx.moshe@intel.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] iwlwifi: pnvm: Fix a memory leak in 'iwl_pnvm_get_from_fs()'
Date:   Thu,  2 Sep 2021 22:38:11 +0200
Message-Id: <1b5d80f54c1dbf85710fd285243932943b498fe7.1630614969.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A firmware is requested but never released in this function. This leads to
a memory leak in the normal execution path.

Add the missing 'release_firmware()' call.
Also introduce a temp variable (new_len) in order to keep the value of
'pnvm->size' after the firmware has been released.

Fixes: cdda18fbbefa ("iwlwifi: pnvm: move file loading code to a separate function")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index 314ed90c23dd..dde22bdc8703 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -231,6 +231,7 @@ static int iwl_pnvm_get_from_fs(struct iwl_trans *trans, u8 **data, size_t *len)
 {
 	const struct firmware *pnvm;
 	char pnvm_name[MAX_PNVM_NAME];
+	size_t new_len;
 	int ret;
 
 	iwl_pnvm_get_fs_name(trans, pnvm_name, sizeof(pnvm_name));
@@ -242,11 +243,14 @@ static int iwl_pnvm_get_from_fs(struct iwl_trans *trans, u8 **data, size_t *len)
 		return ret;
 	}
 
+	new_len = pnvm->size;
 	*data = kmemdup(pnvm->data, pnvm->size, GFP_KERNEL);
+	release_firmware(pnvm);
+
 	if (!*data)
 		return -ENOMEM;
 
-	*len = pnvm->size;
+	*len = new_len;
 
 	return 0;
 }
-- 
2.30.2

