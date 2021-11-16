Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21075452E9B
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 11:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbhKPKFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 05:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbhKPKFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 05:05:02 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E35C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 02:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MmEoFnA0YeM3JWwin53spg2WK/2HFjjQaM2+RNr5Pjg=; b=u1wNserUxz0L7E8FX1koO/dL71
        No7dfNitfimnCyJXNcLzZIsMVa9arAk4jzPLv/AokOWg1l/zPzvV21pENHtrRywK3VpRf4fIiNbWU
        kRZZn9cHATlg09Xxm65OrSbO/JGFpc6kMZZxmT5YmNg7Ol4jeGAztuMZ1LZFQ6dR4ajc3uLOFcVWz
        /6ZQOvCN+JULRC8xU82ip2zwwnzCGRHVgArA5FpzN5SuOh62v1kRyUMJo+f1+YmTJC/foe/Dc/gbh
        iVE8gDfrXoIgm6gUfNDanTxwcjW7Lpq8POvVQmKB5u7O6vGmnEMlkGGRFRlzas8Isoz827m/MB6Io
        C6ACZ2zw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39828 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvHu-0000KD-1V; Tue, 16 Nov 2021 10:02:02 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvHt-0078WC-Jp; Tue, 16 Nov 2021 10:02:01 +0000
In-Reply-To: <YZOBiFK8DkYUSRml@shell.armlinux.org.uk>
References: <YZOBiFK8DkYUSRml@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 1/3] net: sparx5: populate supported_interfaces
 member
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mmvHt-0078WC-Jp@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 16 Nov 2021 10:02:01 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the phy_interface_t bitmap for the Microchip Sparx5 driver
with interfaces modes supported by the MAC.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../ethernet/microchip/sparx5/sparx5_main.c   | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 4625d4fb4cde..3cb6c1fe43ff 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -293,6 +293,30 @@ static int sparx5_create_port(struct sparx5 *sparx5,
 	spx5_port->phylink_config.type = PHYLINK_NETDEV;
 	spx5_port->phylink_config.pcs_poll = true;
 
+	__set_bit(PHY_INTERFACE_MODE_SGMII,
+		  spx5_port->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_QSGMII,
+		  spx5_port->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_1000BASEX,
+		  spx5_port->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_2500BASEX,
+		  spx5_port->phylink_config.supported_interfaces);
+
+	if (spx5_port->conf.bandwidth == SPEED_5000 ||
+	    spx5_port->conf.bandwidth == SPEED_10000 ||
+	    spx5_port->conf.bandwidth == SPEED_25000)
+		__set_bit(PHY_INTERFACE_MODE_5GBASER,
+			  spx5_port->phylink_config.supported_interfaces);
+
+	if (spx5_port->conf.bandwidth == SPEED_10000 ||
+	    spx5_port->conf.bandwidth == SPEED_25000)
+		__set_bit(PHY_INTERFACE_MODE_10GBASER,
+			  spx5_port->phylink_config.supported_interfaces);
+
+	if (spx5_port->conf.bandwidth == SPEED_25000)
+		__set_bit(PHY_INTERFACE_MODE_25GBASER,
+			  spx5_port->phylink_config.supported_interfaces);
+
 	phylink = phylink_create(&spx5_port->phylink_config,
 				 of_fwnode_handle(config->node),
 				 config->conf.phy_mode,
-- 
2.30.2

