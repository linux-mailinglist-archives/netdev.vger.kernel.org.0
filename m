Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99DEC491CC7
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349793AbiARDSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352935AbiARDIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 22:08:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A94C06173E;
        Mon, 17 Jan 2022 18:50:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C147C612E8;
        Tue, 18 Jan 2022 02:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD87C36AE3;
        Tue, 18 Jan 2022 02:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474246;
        bh=f7zDL95n+kg9huLTEOAIIEnuKev+HlSFHBWny+tfZwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IzjnllUkaDxQLbn9tOhFI2LotOdpd3DRoimkpnmiAE9Xwxm0//van93z7GXdOoHhJ
         4t3u6K4pjWix7/yXbWuME02wIJzmU66MFk80wdjnPxVc3qVAFGTRpr9aZScETAHHri
         mFVgTsUom28E8Fo6pwxDzkvM2wkJEtO2KKxKHHhpyd3k5boqV43aumMaVtbE8lvhjn
         XKktJZeK2DhdgTunEsnJIwWbl1sz+6nfPKk/N5OqF9DADJAhsc5gEQ3lqXoxpirJrd
         VqnMphsGc5Qnj1z4W1LRybliSNLlMZQUEbtXX0wRSYH1BQyvEUNaFrBWqVS/VQMtlE
         mjZCXvUk6l7CQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 40/56] iwlwifi: remove module loading failure message
Date:   Mon, 17 Jan 2022 21:48:52 -0500
Message-Id: <20220118024908.1953673-40-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024908.1953673-1-sashal@kernel.org>
References: <20220118024908.1953673-1-sashal@kernel.org>
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
index 95101f66a886e..ade3c27050471 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1494,15 +1494,8 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
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

