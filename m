Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD7E5F9075
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbiJIWYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbiJIWXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:23:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E6C3B953;
        Sun,  9 Oct 2022 15:17:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4981A60C9B;
        Sun,  9 Oct 2022 22:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B7AC4347C;
        Sun,  9 Oct 2022 22:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353877;
        bh=2UDk4z1swJFZwwUOmjxM+8NA8pWDM1s7uZqCqSEuaZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FwM9MlOTRV1fY3aCXV9qNa3i1DPxzVFVYqhbHbOuEGPw/b/A0bLLZd7FNgmTRGh7g
         Ktf0oWJ7vxfXZzx1X/hqpT7Uf3RpwZWguhRZlfTS4y/wqRQL7038fRt5htPNsI90Fy
         lN5iVFW/HUJ+xXV8yn9PNIy+td2CqOKpG9JSmFnVkSueJBqWokejz0j+66L/FMOpGP
         S/orEHWVfXT1LinUGu/ch1n8AdY7/Q81RG89KNftPvDMu1ePAIDJIOg9cLAWK7k0dm
         PEfeXxTgcTrht/TAqeG6RatH4tQt0ZvMuf+muluKnrYpmaqQ/VEuFLLDBog7wa06jc
         W2PorkF87Ovgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 49/73] net: sfp: re-implement soft state polling setup
Date:   Sun,  9 Oct 2022 18:14:27 -0400
Message-Id: <20221009221453.1216158-49-sashal@kernel.org>
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

[ Upstream commit 8475c4b70b040f9d8cbc308100f2c4d865f810b3 ]

Re-implement the decision making for soft state polling. Instead of
generating the soft state mask in sfp_soft_start_poll() by looking at
which GPIOs are available, record their availability in
sfp_sm_mod_probe() in sfp->state_hw_mask.

This will then allow us to clear bits in sfp->state_hw_mask in module
specific quirks when the hardware signals should not be used, thereby
allowing us to switch to using the software state polling.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index e7b0e12cc75b..aa219f2c574e 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -234,6 +234,7 @@ struct sfp {
 	bool need_poll;
 
 	struct mutex st_mutex;			/* Protects state */
+	unsigned int state_hw_mask;
 	unsigned int state_soft_mask;
 	unsigned int state;
 	struct delayed_work poll;
@@ -499,17 +500,18 @@ static void sfp_soft_set_state(struct sfp *sfp, unsigned int state)
 static void sfp_soft_start_poll(struct sfp *sfp)
 {
 	const struct sfp_eeprom_id *id = &sfp->id;
+	unsigned int mask = 0;
 
 	sfp->state_soft_mask = 0;
-	if (id->ext.enhopts & SFP_ENHOPTS_SOFT_TX_DISABLE &&
-	    !sfp->gpio[GPIO_TX_DISABLE])
-		sfp->state_soft_mask |= SFP_F_TX_DISABLE;
-	if (id->ext.enhopts & SFP_ENHOPTS_SOFT_TX_FAULT &&
-	    !sfp->gpio[GPIO_TX_FAULT])
-		sfp->state_soft_mask |= SFP_F_TX_FAULT;
-	if (id->ext.enhopts & SFP_ENHOPTS_SOFT_RX_LOS &&
-	    !sfp->gpio[GPIO_LOS])
-		sfp->state_soft_mask |= SFP_F_LOS;
+	if (id->ext.enhopts & SFP_ENHOPTS_SOFT_TX_DISABLE)
+		mask |= SFP_F_TX_DISABLE;
+	if (id->ext.enhopts & SFP_ENHOPTS_SOFT_TX_FAULT)
+		mask |= SFP_F_TX_FAULT;
+	if (id->ext.enhopts & SFP_ENHOPTS_SOFT_RX_LOS)
+		mask |= SFP_F_LOS;
+
+	// Poll the soft state for hardware pins we want to ignore
+	sfp->state_soft_mask = ~sfp->state_hw_mask & mask;
 
 	if (sfp->state_soft_mask & (SFP_F_LOS | SFP_F_TX_FAULT) &&
 	    !sfp->need_poll)
@@ -523,10 +525,11 @@ static void sfp_soft_stop_poll(struct sfp *sfp)
 
 static unsigned int sfp_get_state(struct sfp *sfp)
 {
-	unsigned int state = sfp->get_state(sfp);
+	unsigned int soft = sfp->state_soft_mask & (SFP_F_LOS | SFP_F_TX_FAULT);
+	unsigned int state;
 
-	if (state & SFP_F_PRESENT &&
-	    sfp->state_soft_mask & (SFP_F_LOS | SFP_F_TX_FAULT))
+	state = sfp->get_state(sfp) & sfp->state_hw_mask;
+	if (state & SFP_F_PRESENT && soft)
 		state |= sfp_soft_get_state(sfp);
 
 	return state;
@@ -1951,6 +1954,15 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	if (ret < 0)
 		return ret;
 
+	/* Initialise state bits to use from hardware */
+	sfp->state_hw_mask = SFP_F_PRESENT;
+	if (sfp->gpio[GPIO_TX_DISABLE])
+		sfp->state_hw_mask |= SFP_F_TX_DISABLE;
+	if (sfp->gpio[GPIO_TX_FAULT])
+		sfp->state_hw_mask |= SFP_F_TX_FAULT;
+	if (sfp->gpio[GPIO_LOS])
+		sfp->state_hw_mask |= SFP_F_LOS;
+
 	if (!memcmp(id.base.vendor_name, "ALCATELLUCENT   ", 16) &&
 	    !memcmp(id.base.vendor_pn, "3FE46541AA      ", 16))
 		sfp->module_t_start_up = T_START_UP_BAD_GPON;
@@ -2577,6 +2589,8 @@ static int sfp_probe(struct platform_device *pdev)
 				return PTR_ERR(sfp->gpio[i]);
 		}
 
+	sfp->state_hw_mask = SFP_F_PRESENT;
+
 	sfp->get_state = sfp_gpio_get_state;
 	sfp->set_state = sfp_gpio_set_state;
 
-- 
2.35.1

