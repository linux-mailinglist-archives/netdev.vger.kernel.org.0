Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACF6C23BF3
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 17:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391465AbfETPWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 11:22:10 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48942 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731389AbfETPWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 11:22:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=G3jAVY+IumgJuyGPVT8r9KoalCV1j0V6uUAxxBJ80fg=; b=nhu/D3M4Xtj0aE6h9iNTxm01D/
        NPFwPdAe4Qn+YzOBCQwsN8JH57PQnSWyWwCvyomjMa0VzJ3k/o2tl7K8JskmPwtVV6HDb8JGerW+v
        mBE6CSLeSgKjBQ6xbGxuKZQr1FtEUL2SH17XlaiBucZkqpFGll+xRwP+b4CDv/ClA4M9ZG/SjHEPL
        SZFN9HeitOrPExd1Pgpx2Qc1LwN4Nech0HmOUd7AY1U++oJrM7B8cvJ+uZOm8WrkPRLovSff7NVCF
        j+ZNiB+qelU5zsrwdDJtSEIaQEsc8njZEp5sR1GQjPZz3iyoGdGotxtXqlRAConEjyA+N7S1nEgT0
        oGcmKdow==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:43296 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hSk6z-0003au-Dw; Mon, 20 May 2019 16:22:01 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hSk6y-0000vs-Pj; Mon, 20 May 2019 16:22:00 +0100
In-Reply-To: <20190520152134.qyka5t7c2i7drk4a@shell.armlinux.org.uk>
References: <20190520152134.qyka5t7c2i7drk4a@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/4] net: phylink: support for link gpio interrupt
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1hSk6y-0000vs-Pj@rmk-PC.armlinux.org.uk>
Date:   Mon, 20 May 2019 16:22:00 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for using GPIO interrupts with a fixed-link GPIO rather than
polling the GPIO every second and invoking the phylink resolution.  This
avoids unnecessary calls to mac_config().

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 74983593834b..bdee5f307a7f 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -52,6 +52,7 @@ struct phylink {
 	/* The link configuration settings */
 	struct phylink_link_state link_config;
 	struct gpio_desc *link_gpio;
+	unsigned int link_irq;
 	struct timer_list link_poll;
 	void (*get_fixed_state)(struct net_device *dev,
 				struct phylink_link_state *s);
@@ -608,7 +609,7 @@ void phylink_destroy(struct phylink *pl)
 {
 	if (pl->sfp_bus)
 		sfp_unregister_upstream(pl->sfp_bus);
-	if (!IS_ERR_OR_NULL(pl->link_gpio))
+	if (pl->link_gpio)
 		gpiod_put(pl->link_gpio);
 
 	cancel_work_sync(&pl->resolve);
@@ -871,6 +872,15 @@ void phylink_mac_change(struct phylink *pl, bool up)
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
@@ -906,7 +916,22 @@ void phylink_start(struct phylink *pl)
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
@@ -932,8 +957,11 @@ void phylink_stop(struct phylink *pl)
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

