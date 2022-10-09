Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53155F905B
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbiJIWYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231702AbiJIWW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:22:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594453D5A6;
        Sun,  9 Oct 2022 15:17:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 567F6B80DDF;
        Sun,  9 Oct 2022 22:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CD2C433D7;
        Sun,  9 Oct 2022 22:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353535;
        bh=wGINHJHSHEOesR1pntzRvB4lqvJ9w5ItPDQVF6acuZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dMi0bs6WKG+UsrIfWrIX5afsEL3F37I8ncd13xclX+4emBMTOW9joc8jPaPvQ4Qfg
         01TyzzYar2esvwEN3lru3hgxbTVAsJasISV/kx7Q0TsyaBDe8WScoDvrnZPwXNyvNF
         4I+y2kzF2HSzMLxMtjS6g2NatoASBuVcz6JEeZuK/B+daqAt//o0qpEAPB/QWU5ZTo
         wNRHTgwHDt9Ci/HIjcn/6XkKQL1mUAHwfHt1UWNVXXVgio2eGSHnnZbb7n9E2D0hEH
         pNPIRE1pv2gikMR/TsUcTHcNZtFH4o0BPlVlrpA/tk0bG5Fq+cnwRrLL1pe8qzL4hV
         BtblSEvVVylqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 54/77] net: sfp: move Alcatel Lucent 3FE46541AA fixup
Date:   Sun,  9 Oct 2022 18:07:31 -0400
Message-Id: <20221009220754.1214186-54-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
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
index 2b06230be94f..952cd73e4777 100644
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
@@ -2048,11 +2054,7 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
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
@@ -2061,6 +2063,8 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
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

