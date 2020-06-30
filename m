Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD2920F2A1
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 12:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732238AbgF3KZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 06:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732539AbgF3KZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 06:25:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02230C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 03:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gU7oN7SSRK9J5L1dR/1JDZQElNSmF0/k6IPeF33+uUo=; b=Nma86pcCQBtX2HtkMQ61QKkvvn
        4xkF1aN9lfPRT4LAzgH1y0+ptDQs0zvrH8LLEFx5E2MqpvuDyb666wvN7FVTtOlKYa5tVrZYukmyP
        ZGMhbotxgmNNlySG2kzkm3PT326vxYx6doo1S7S1nI+gKy0D8koZv/V/nIYlOnMH4kp4yBWMv/gs1
        vdSAE0LVGrUX5QwZydoxn/LzWu8rVYxC+2oX/2oZgcJU+qLZjdnFhq3m3lhxVxq7/Pf+3fhYhazIA
        hwjqFPy5bSKnoSfqxnaGxzf7eOwAskuvXUXhfooWVYX6nkB1yEFo7Bzg50gIS79neNv79DalE2gwT
        NRpUnKTQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45938 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqDRq-0000P0-Pw; Tue, 30 Jun 2020 11:25:06 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqDRq-0004qF-BT; Tue, 30 Jun 2020 11:25:06 +0100
In-Reply-To: <20200630102430.GZ1551@shell.armlinux.org.uk>
References: <20200630102430.GZ1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/2] net: dsa/b53: use resolved link config in
 mac_link_up()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jqDRq-0004qF-BT@rmk-PC.armlinux.org.uk>
Date:   Tue, 30 Jun 2020 11:25:06 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the B53 driver to use the finalised link parameters in
mac_link_up() rather than the parameters in mac_config(). This is
just a matter of moving the call to b53_force_port_config().

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/b53/b53_common.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 8a7fa6092b01..6500179c2ca2 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1254,17 +1254,9 @@ void b53_phylink_mac_config(struct dsa_switch *ds, int port,
 {
 	struct b53_device *dev = ds->priv;
 
-	if (mode == MLO_AN_PHY)
+	if (mode == MLO_AN_PHY || mode == MLO_AN_FIXED)
 		return;
 
-	if (mode == MLO_AN_FIXED) {
-		b53_force_port_config(dev, port, state->speed,
-				      state->duplex,
-				      !!(state->pause & MLO_PAUSE_TX),
-				      !!(state->pause & MLO_PAUSE_RX));
-		return;
-	}
-
 	if ((phy_interface_mode_is_8023z(state->interface) ||
 	     state->interface == PHY_INTERFACE_MODE_SGMII) &&
 	     dev->ops->serdes_config)
@@ -1314,6 +1306,8 @@ void b53_phylink_mac_link_up(struct dsa_switch *ds, int port,
 		return;
 
 	if (mode == MLO_AN_FIXED) {
+		b53_force_port_config(dev, port, speed, duplex,
+				      tx_pause, rx_pause);
 		b53_force_link(dev, port, true);
 		return;
 	}
-- 
2.20.1

