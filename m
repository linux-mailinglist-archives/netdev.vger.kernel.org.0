Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBB95F923A
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbiJIWrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbiJIWpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:45:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CE73CBC0;
        Sun,  9 Oct 2022 15:23:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0622FB80DD6;
        Sun,  9 Oct 2022 22:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB42C43148;
        Sun,  9 Oct 2022 22:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354151;
        bh=afoHegLQe21KSsJBUiYP1bQHx8ZCt7Rj4JBlRC/rAo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKmGSzbzcc7bGajI7ia3EEgyShvCsmxT8YiukKROnDYl2of+XdQDhhl9bpK0YIpOm
         je3+vZjoFeGoNNpBQedo5rkgTgKVS0J+sIA5HHqA/HdvCQBfkb7JsNZlTeuShC6tTd
         QztaKm7wl40vB91wv1V7wnSlaN8GpTrmexHSCsfOftSk45oBguAzKewwCNcwZr6NGO
         UGTEqZ7K0IzdNQncSf2tspA7x63sqNgASlscYLcBox049Qqngdg6hpOwz4acyF55ll
         Tdv+w8jlx3X/RNmXU4rY6FSjBJcB2x9wqZh0xh1RCTrnWn/IgloXllwLLadT/XHQCN
         qqfV2QCFWaUwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 19/34] net: sfp: re-implement soft state polling setup
Date:   Sun,  9 Oct 2022 18:21:13 -0400
Message-Id: <20221009222129.1218277-19-sashal@kernel.org>
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
index dcbe278086dc..79e8806a2d39 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -233,6 +233,7 @@ struct sfp {
 	bool need_poll;
 
 	struct mutex st_mutex;			/* Protects state */
+	unsigned int state_hw_mask;
 	unsigned int state_soft_mask;
 	unsigned int state;
 	struct delayed_work poll;
@@ -495,17 +496,18 @@ static void sfp_soft_set_state(struct sfp *sfp, unsigned int state)
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
@@ -519,10 +521,11 @@ static void sfp_soft_stop_poll(struct sfp *sfp)
 
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
@@ -1888,6 +1891,15 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
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
@@ -2488,6 +2500,8 @@ static int sfp_probe(struct platform_device *pdev)
 				return PTR_ERR(sfp->gpio[i]);
 		}
 
+	sfp->state_hw_mask = SFP_F_PRESENT;
+
 	sfp->get_state = sfp_gpio_get_state;
 	sfp->set_state = sfp_gpio_set_state;
 
-- 
2.35.1

