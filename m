Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 603702C3A7
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfE1J5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:57:32 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35894 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfE1J5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 05:57:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IPDioJpb7e5HefCLt8vhmlq8rifN2b4+VeG7F4vAS5c=; b=WhnhCCo8L7prSfU2LpfP4e8Inf
        XjVsYcGHpnWbKlODLWaEhNt1VoY8d9YZdIh6k5iYUkUpJMIf7ykLRR2faKuSbn1kV7SmQ5UN1diCf
        sW/Ym/Ajl5YNUoorAVZnPUPXgUISC5cgbpbuQa7bP8bXNVP+xWa7pA8H0FO6Q7HFAkQ/V5V0aakGO
        k2qYANTa+XZ5zSYNes/Nhu5gA2nRHgOlIqz5BVjZRElSQ7/a1R8KODLW+tOVAwAuiBXwJD8qB5Wkr
        TfFUtAQjxkzRaBj5w+g/dX6xUP9wwJz/in7527QUAmI6bPrv9vVw1cPsTn0BaVC+1GjMiJZfJS44M
        xabshy5w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:40426 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hVYrE-0004yY-HP; Tue, 28 May 2019 10:57:24 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hVYrD-0005Z1-L0; Tue, 28 May 2019 10:57:23 +0100
In-Reply-To: <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk>
References: <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/5] net: phylink: support for link gpio interrupt
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1hVYrD-0005Z1-L0@rmk-PC.armlinux.org.uk>
Date:   Tue, 28 May 2019 10:57:23 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for using GPIO interrupts with a fixed-link GPIO rather than
polling the GPIO every second and invoking the phylink resolution.  This
avoids unnecessary calls to mac_config().

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 219a061572d2..00cd0ed7ff3d 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -56,6 +56,7 @@ struct phylink {
 	phy_interface_t cur_interface;
 
 	struct gpio_desc *link_gpio;
+	unsigned int link_irq;
 	struct timer_list link_poll;
 	void (*get_fixed_state)(struct net_device *dev,
 				struct phylink_link_state *s);
@@ -612,7 +613,7 @@ void phylink_destroy(struct phylink *pl)
 {
 	if (pl->sfp_bus)
 		sfp_unregister_upstream(pl->sfp_bus);
-	if (!IS_ERR_OR_NULL(pl->link_gpio))
+	if (pl->link_gpio)
 		gpiod_put(pl->link_gpio);
 
 	cancel_work_sync(&pl->resolve);
@@ -875,6 +876,15 @@ void phylink_mac_change(struct phylink *pl, bool up)
 }
 EXPORT_SYMBOL_GPL(phylink_mac_change);
 
+static irqreturn_t phylink_link_handler(int irq, void *data)
+{
+	struct phylink *pl = data;
+
+	phylink_run_resolve(pl);
+
+	return IRQ_HANDLED;
+}
+
 /**
  * phylink_start() - start a phylink instance
  * @pl: a pointer to a &struct phylink returned from phylink_create()
@@ -910,7 +920,22 @@ void phylink_start(struct phylink *pl)
 	clear_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state);
 	phylink_run_resolve(pl);
 
-	if (pl->link_an_mode == MLO_AN_FIXED && !IS_ERR(pl->link_gpio))
+	if (pl->link_an_mode == MLO_AN_FIXED && pl->link_gpio) {
+		int irq = gpiod_to_irq(pl->link_gpio);
+
+		if (irq > 0) {
+			if (!request_irq(irq, phylink_link_handler,
+					 IRQF_TRIGGER_RISING |
+					 IRQF_TRIGGER_FALLING,
+					 "netdev link", pl))
+				pl->link_irq = irq;
+			else
+				irq = 0;
+		}
+		if (irq <= 0)
+			mod_timer(&pl->link_poll, jiffies + HZ);
+	}
+	if (pl->link_an_mode == MLO_AN_FIXED && pl->get_fixed_state)
 		mod_timer(&pl->link_poll, jiffies + HZ);
 	if (pl->sfp_bus)
 		sfp_upstream_start(pl->sfp_bus);
@@ -936,8 +961,11 @@ void phylink_stop(struct phylink *pl)
 		phy_stop(pl->phydev);
 	if (pl->sfp_bus)
 		sfp_upstream_stop(pl->sfp_bus);
-	if (pl->link_an_mode == MLO_AN_FIXED && !IS_ERR(pl->link_gpio))
-		del_timer_sync(&pl->link_poll);
+	del_timer_sync(&pl->link_poll);
+	if (pl->link_irq) {
+		free_irq(pl->link_irq, pl);
+		pl->link_irq = 0;
+	}
 
 	phylink_run_resolve_and_disable(pl, PHYLINK_DISABLE_STOPPED);
 }
-- 
2.7.4

