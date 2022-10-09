Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619625F9078
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbiJIWZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbiJIWXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:23:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DA439B9E;
        Sun,  9 Oct 2022 15:18:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C67060C6F;
        Sun,  9 Oct 2022 22:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBBDC433D6;
        Sun,  9 Oct 2022 22:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353881;
        bh=aGxvfCn8+L1kZr0Tc76loZ7zjmdxCDoOWaiyeubO5cU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FnYe3DWmTRbl26VCq2mVX1IqFbY5cOqa2FliRSiBta8CIHhF7L08xEXjQdgevTDJr
         ExUmnQ3sreYtW2YdUzciIwm+byxM3UGyTM3mIHcOl0E5zk4YBKUeFNFla3VIR3iCMK
         2fjTRA5RYL2VT5h8EseFNGps7sdKCloRjgkQLGJuVLVPbD3xR732ZWL8TA6Jce6FWB
         RevPamxYWkzghTEDkd1yEFEAX2iPZKSDrqHYcMiQaqsaRbCEEhrIFhBKnb3ETaYOlZ
         oV0MfaLJeeZFAJ9k1jIiUI6vUHnxwM9+uevqfiupL9PFWp0hlcp5HxDLLHSViuqbHN
         rqtlAByZLLpNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 51/73] net: sfp: move Alcatel Lucent 3FE46541AA fixup
Date:   Sun,  9 Oct 2022 18:14:29 -0400
Message-Id: <20221009221453.1216158-51-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

[ Upstream commit 275416754e9a262c97a1ad6f806a4bc6e0464aa2 ]

Add a new fixup mechanism to the SFP quirks, and use it for this
module.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 14 +++++++++-----
 drivers/net/phy/sfp.h |  1 +
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 1b35cf0ac02a..38ce6c579ee3 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -311,6 +311,11 @@ static const struct of_device_id sfp_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, sfp_of_match);
 
+static void sfp_fixup_long_startup(struct sfp *sfp)
+{
+	sfp->module_t_start_up = T_START_UP_BAD_GPON;
+}
+
 static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
 				unsigned long *modes)
 {
@@ -341,6 +346,7 @@ static const struct sfp_quirk sfp_quirks[] = {
 		.vendor = "ALCATELLUCENT",
 		.part = "3FE46541AA",
 		.modes = sfp_quirk_2500basex,
+		.fixup = sfp_fixup_long_startup,
 	}, {
 		// Huawei MA5671A can operate at 2500base-X, but report 1.2GBd
 		// NRZ in their EEPROM
@@ -2052,11 +2058,7 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	if (sfp->gpio[GPIO_LOS])
 		sfp->state_hw_mask |= SFP_F_LOS;
 
-	if (!memcmp(id.base.vendor_name, "ALCATELLUCENT   ", 16) &&
-	    !memcmp(id.base.vendor_pn, "3FE46541AA      ", 16))
-		sfp->module_t_start_up = T_START_UP_BAD_GPON;
-	else
-		sfp->module_t_start_up = T_START_UP;
+	sfp->module_t_start_up = T_START_UP;
 
 	if (!memcmp(id.base.vendor_name, "HUAWEI          ", 16) &&
 	    !memcmp(id.base.vendor_pn, "MA5671A         ", 16))
@@ -2065,6 +2067,8 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 		sfp->tx_fault_ignore = false;
 
 	sfp->quirk = sfp_lookup_quirk(&id);
+	if (sfp->quirk && sfp->quirk->fixup)
+		sfp->quirk->fixup(sfp);
 
 	return 0;
 }
diff --git a/drivers/net/phy/sfp.h b/drivers/net/phy/sfp.h
index 03f1d47fe6ca..7ad06deae76c 100644
--- a/drivers/net/phy/sfp.h
+++ b/drivers/net/phy/sfp.h
@@ -10,6 +10,7 @@ struct sfp_quirk {
 	const char *vendor;
 	const char *part;
 	void (*modes)(const struct sfp_eeprom_id *id, unsigned long *modes);
+	void (*fixup)(struct sfp *sfp);
 };
 
 struct sfp_socket_ops {
-- 
2.35.1

