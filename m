Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237BF5B7A8E
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 21:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiIMTGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 15:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbiIMTGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 15:06:36 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC77233E3A
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 12:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hmBV0ym4k+3NfW7lypi9yKbvT39144mumIEueUaIuPY=; b=haRkJdNRsPQPqa5cWcZfwT/bYT
        cOvGgGOsTrPCkZ2NMYviM+7DFaaEz+NhhbrLCb2hW4Io4rSS8N0wdgJIOlAPkb+/RtUv3VCUhMUpr
        7csAyLiYJh5+eL4py30NOUbYxrgMGoFyrOShYKXCxo1xGTmTued3wPnctxIwr39IkiYZ19X0GFPKc
        XdzK9vvB5yKDTriMH/Tp6ZACg4XmysFQB3gzzIgjkb8ftsuS3ZZ9wVy/1WiN/wIdtPonw4kiDcsBT
        sFfBYLLmRydhaUiFTVtyHsNtqjbWs5Wp+SMsALoIUqPZV3bBTMOCR6TEmNJ9HQHM2don5z4+VtmtY
        h2mVOzVw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39866 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oYBEq-0003Qf-7w; Tue, 13 Sep 2022 20:06:28 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oYBEp-006kC1-J4; Tue, 13 Sep 2022 20:06:27 +0100
In-Reply-To: <YyDUnvM1b0dZPmmd@shell.armlinux.org.uk>
References: <YyDUnvM1b0dZPmmd@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Josef Schlehofer <pepe.schlehofer@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/5] net: sfp: re-implement soft state polling setup
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oYBEp-006kC1-J4@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 13 Sep 2022 20:06:27 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Re-implement the decision making for soft state polling. Instead of
generating the soft state mask in sfp_soft_start_poll() by looking at
which GPIOs are available, record their availability in
sfp_sm_mod_probe() in sfp->state_hw_mask.

This will then allow us to clear bits in sfp->state_hw_mask in module
specific quirks when the hardware signals should not be used, thereby
allowing us to switch to using the software state polling.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index a12f7b599da2..b9fe1f554f27 100644
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
@@ -1902,6 +1905,15 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
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
@@ -2528,6 +2540,8 @@ static int sfp_probe(struct platform_device *pdev)
 				return PTR_ERR(sfp->gpio[i]);
 		}
 
+	sfp->state_hw_mask = SFP_F_PRESENT;
+
 	sfp->get_state = sfp_gpio_get_state;
 	sfp->set_state = sfp_gpio_set_state;
 
-- 
2.30.2

