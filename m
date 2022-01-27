Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F53549DFE0
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239723AbiA0KzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239722AbiA0KzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:55:00 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCBBC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 02:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RB9833cujLTnyFdveYE3Eikn1+2tyH8l9c23RBxJVM0=; b=O7bCZoxzkStPXec6ILAgPmac/7
        lDOw292O2gpkx99NHKSJYB+VHZeLoB61GEYXPu0VHvXZRW8rxz5FbFZLwUkCiB1Mw3ZkuXDGSq3zP
        lDCutOOUO89AXGArsC4MeZtoDh7cQBMIWOJtfTFlloWzWG27cdamtesYOZFcHDvmzZ501wvjE40X3
        5s7tV2NRjCAZjHV7WZ8s7QxfSpsTmJEkWwg+RE1pZp25EDDyO66RjDC/BgqBzWVxagFUZoapC0oE4
        CY6ZfJEIVUwSE9XsXMqNe6fO6jkgfQQpELXK0D49e9BQ3mCngmsVCGVFplbYSiamXzInTHCGCnfcG
        Y3PBjgFw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:43560 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nD2QX-0004LA-D5; Thu, 27 Jan 2022 10:54:53 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nD2QW-005UHW-QK; Thu, 27 Jan 2022 10:54:52 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next] net: sparx5: use .mac_select_pcs() interface
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nD2QW-005UHW-QK@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 27 Jan 2022 10:54:52 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert sparx5 to use the mac_select_interface rather than using
phylink_set_pcs(). The intention here is to unify the approach for
PCS and eventually remove phylink_set_pcs().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c    |  1 -
 drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c | 10 ++++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 16266275dd36..35689b5e212c 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -328,7 +328,6 @@ static int sparx5_create_port(struct sparx5 *sparx5,
 		return PTR_ERR(phylink);
 
 	spx5_port->phylink = phylink;
-	phylink_set_pcs(phylink, &spx5_port->phylink_pcs);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
index 8ba33bc1a001..830da0e5ff27 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
@@ -26,6 +26,15 @@ static bool port_conf_has_changed(struct sparx5_port_config *a, struct sparx5_po
 	return false;
 }
 
+static struct phylink_pcs *
+sparx5_phylink_mac_select_pcs(struct phylink_config *config,
+			      phy_interface_t interface)
+{
+	struct sparx5_port *port = netdev_priv(to_net_dev(config->dev));
+
+	return &port->phylink_pcs;
+}
+
 static void sparx5_phylink_mac_config(struct phylink_config *config,
 				      unsigned int mode,
 				      const struct phylink_link_state *state)
@@ -130,6 +139,7 @@ const struct phylink_pcs_ops sparx5_phylink_pcs_ops = {
 
 const struct phylink_mac_ops sparx5_phylink_mac_ops = {
 	.validate = phylink_generic_validate,
+	.mac_select_pcs = sparx5_phylink_mac_select_pcs,
 	.mac_config = sparx5_phylink_mac_config,
 	.mac_link_down = sparx5_phylink_mac_link_down,
 	.mac_link_up = sparx5_phylink_mac_link_up,
-- 
2.30.2

