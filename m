Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27824919D6
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346314AbiARC4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348615AbiARCpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:45:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAFAC08ED6A;
        Mon, 17 Jan 2022 18:38:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35DD8B81238;
        Tue, 18 Jan 2022 02:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0880DC36AF5;
        Tue, 18 Jan 2022 02:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473500;
        bh=0db0lA3LF46u41ABe7SmiK02EzboUvOSIxyIoCE8fDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GWEigl7t92xGkBez4PuEYlL1pzUtbGPyUsRS2fO5Wufauqw/ygIVDiWIphJJIK6bG
         bNMVccmfYD5mPcxryIzIj8zQt1+826GImvMU/UDLFelTYdJkI2djGDK9nedimkOGIz
         Zjzk/21mkFQE6damQK9OWF94Dk46o02CR5CQyD1rDXXkPBtGKVi3Bkhq73K2vZNWGL
         FkfZ+yDl258nId/ukuop+Gct679Iulr3GibiH40gPZszFOXhVS1hhhTq/pYs95zaEj
         skUXEMW8QdhM+VNvnRTOpKcJ0s+pINXPQ9qx+/B73iloAUwpCXQ4kWEHIHxw1/aqZ1
         2LYhTZ1ZFg+ZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 139/188] iwlwifi: remove module loading failure message
Date:   Mon, 17 Jan 2022 21:31:03 -0500
Message-Id: <20220118023152.1948105-139-sashal@kernel.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6518f83ffa51131daaf439b66094f684da3fb0ae ]

When CONFIG_DEBUG_TEST_DRIVER_REMOVE is set, iwlwifi crashes
when the opmode module cannot be loaded, due to completing
the completion before using drv->dev, which can then already
be freed.

Fix this by removing the (fairly useless) message. Moving the
completion later causes a deadlock instead, so that's not an
option.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/20211210091245.289008-2-luca@coelho.fi
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 2206f66f69940..b7f7b9c5b670c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1597,15 +1597,8 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	 * else from proceeding if the module fails to load
 	 * or hangs loading.
 	 */
-	if (load_module) {
+	if (load_module)
 		request_module("%s", op->name);
-#ifdef CONFIG_IWLWIFI_OPMODE_MODULAR
-		if (err)
-			IWL_ERR(drv,
-				"failed to load module %s (error %d), is dynamic loading enabled?\n",
-				op->name, err);
-#endif
-	}
 	failure = false;
 	goto free;
 
-- 
2.34.1

