Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564EA4919BC
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347788AbiARCzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:55:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50332 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347881AbiARCn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:43:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77147B811CC;
        Tue, 18 Jan 2022 02:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5761EC36AF2;
        Tue, 18 Jan 2022 02:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473804;
        bh=/dLmxP0k5YulXdYMfs2D5bBa+Ba737FmT5TgawM3dGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uVgP0IXut0fzgvA7bK5nkIy5VRbhoq7kG9DowQ4RgHkcvty8x/LjmXOF6GqMtz3/E
         JOvhLKRdrBUZy3dCuIjPoYL3IdGj2k2fI1T4utvLDPpfOGw2KAX54HUyO7XAFc/qyD
         XP/WoF9BVbffFb+q+zDMxj5IorWackP6107XKlC1YoVSsoDpskA+k/ap4f1WD2uKX0
         Dhvom4BYL8Lu2Rf0qHAr4nSL8U1XScszLJOWmbUS7JSzVvYoRPRUXxmBsM1ffpSz+B
         0p5+BLHwYeNKP/lZzupuhbo48dn/tCoKEb0xNTyB9JPBFVHI1cR5vX1La32FFG9cu1
         gDmv8jhGiURAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 081/116] iwlwifi: remove module loading failure message
Date:   Mon, 17 Jan 2022 21:39:32 -0500
Message-Id: <20220118024007.1950576-81-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index 4bdfd6afa7324..30c6d7b18599a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1629,15 +1629,8 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
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

