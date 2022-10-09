Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E2B5F928C
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbiJIWt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233321AbiJIWst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:48:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8450C3A494;
        Sun,  9 Oct 2022 15:24:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB92660C95;
        Sun,  9 Oct 2022 22:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1EFC433D6;
        Sun,  9 Oct 2022 22:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354155;
        bh=F9/yLUsjGrTvt2+dVfH3TQ5FYPOmIdXXJCRI3tzhLCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dVbAkSu/hEQ6riIkd6jQsTfpD506iXPM7Pdw4xR9wmToNOAu0vrG9btZzD2U48N1n
         SnLpiRFyx2h97LYwjmKGnfQmeoPmov7yRMmi/snwTtock2HWJotLXo3gx4RnqXzWDb
         cdfQdYy8EBEXCGsrn27p/J3jyowJE/htzwLo0w15sh4xXVGaRbF49YyzKASHscFkka
         b1lGvSzG4gTjA9Tt0WbEVtsAvoLVHKNuHiRMJljhUngEFOnBDTzuNeYZsaHTn0PDee
         BbObve2iW81BcPugSVP15oyUQGP7lhfqmeLs/ej+v8ShGmgOHb9oQ5S8SuEgCFMdIS
         0si2KeoARh9ew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 21/34] net: sfp: move Alcatel Lucent 3FE46541AA fixup
Date:   Sun,  9 Oct 2022 18:21:15 -0400
Message-Id: <20221009222129.1218277-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222129.1218277-1-sashal@kernel.org>
References: <20221009222129.1218277-1-sashal@kernel.org>
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
index b09716083af4..8789530aa016 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -307,6 +307,11 @@ static const struct of_device_id sfp_of_match[] = {
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
@@ -337,6 +342,7 @@ static const struct sfp_quirk sfp_quirks[] = {
 		.vendor = "ALCATELLUCENT",
 		.part = "3FE46541AA",
 		.modes = sfp_quirk_2500basex,
+		.fixup = sfp_fixup_long_startup,
 	}, {
 		// Huawei MA5671A can operate at 2500base-X, but report 1.2GBd
 		// NRZ in their EEPROM
@@ -1989,11 +1995,7 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
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
@@ -2002,6 +2004,8 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 		sfp->tx_fault_ignore = false;
 
 	sfp->quirk = sfp_lookup_quirk(&id);
+	if (sfp->quirk && sfp->quirk->fixup)
+		sfp->quirk->fixup(sfp);
 
 	return 0;
 }
diff --git a/drivers/net/phy/sfp.h b/drivers/net/phy/sfp.h
index 37c7bbfee539..ef06d3580eea 100644
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

