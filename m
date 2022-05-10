Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAD3521FDC
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346600AbiEJPwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346634AbiEJPvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:51:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564A028D4EC;
        Tue, 10 May 2022 08:45:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3CBF614A1;
        Tue, 10 May 2022 15:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A32C385C2;
        Tue, 10 May 2022 15:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197529;
        bh=DMfk2C4x4pFjrWAncW3ibnLRZMa9P+J5sL+rXn/mBoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2WEctxwiWioh6cSG/2GvGZxD/f/OkV9hlYMmsT5yj0GYHEg0Ew4AMx14FMELH0Im
         ZdIumHDF5nUAfvDEGentGm20dpL6UddSkxyxsDf2RjmQoWa/v1SEH4ZqbzMXNP6wgk
         OQaWcJK7T7/ZNOM4kXMxn8kHZ1X4jTHa6CfKWwUiJWCAWP+JasSsr90DiqMtN03i8p
         3moDYCzyupCsAxNIsqaU6AKIqyeEGueFyxJtzRPPXmF4DtnBdr1NiNsfooug2i1Ll/
         vGNqq1COryzyhuA17owavrp6TKH2Bnqjt9QcQsvysBJXnMd6g9U2K73YZBo9JPbANb
         AZX+nIX6InZuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthew Hagan <mnhagan88@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 7/9] net: sfp: Add tx-fault workaround for Huawei MA5671A SFP ONT
Date:   Tue, 10 May 2022 11:45:10 -0400
Message-Id: <20220510154512.153945-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154512.153945-1-sashal@kernel.org>
References: <20220510154512.153945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthew Hagan <mnhagan88@gmail.com>

[ Upstream commit 2069624dac19d62c558bb6468fe03678553ab01d ]

As noted elsewhere, various GPON SFP modules exhibit non-standard
TX-fault behaviour. In the tested case, the Huawei MA5671A, when used
in combination with a Marvell mv88e6085 switch, was found to
persistently assert TX-fault, resulting in the module being disabled.

This patch adds a quirk to ignore the SFP_F_TX_FAULT state, allowing the
module to function.

Change from v1: removal of erroneous return statment (Andrew Lunn)

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220502223315.1973376-1-mnhagan88@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index efffa65f8214..96068e0d841a 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -249,6 +249,7 @@ struct sfp {
 	struct sfp_eeprom_id id;
 	unsigned int module_power_mW;
 	unsigned int module_t_start_up;
+	bool tx_fault_ignore;
 
 #if IS_ENABLED(CONFIG_HWMON)
 	struct sfp_diag diag;
@@ -1893,6 +1894,12 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	else
 		sfp->module_t_start_up = T_START_UP;
 
+	if (!memcmp(id.base.vendor_name, "HUAWEI          ", 16) &&
+	    !memcmp(id.base.vendor_pn, "MA5671A         ", 16))
+		sfp->tx_fault_ignore = true;
+	else
+		sfp->tx_fault_ignore = false;
+
 	return 0;
 }
 
@@ -2320,7 +2327,10 @@ static void sfp_check_state(struct sfp *sfp)
 	mutex_lock(&sfp->st_mutex);
 	state = sfp_get_state(sfp);
 	changed = state ^ sfp->state;
-	changed &= SFP_F_PRESENT | SFP_F_LOS | SFP_F_TX_FAULT;
+	if (sfp->tx_fault_ignore)
+		changed &= SFP_F_PRESENT | SFP_F_LOS;
+	else
+		changed &= SFP_F_PRESENT | SFP_F_LOS | SFP_F_TX_FAULT;
 
 	for (i = 0; i < GPIO_MAX; i++)
 		if (changed & BIT(i))
-- 
2.35.1

