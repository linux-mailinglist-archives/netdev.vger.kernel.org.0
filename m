Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D124549E3
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 16:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236675AbhKQPcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 10:32:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbhKQPcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 10:32:20 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDB1C061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 07:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=S/2yRFaFlD6kkXQGsryWk54u9gmNZZ1HSG5rOScUuz4=; b=0kf5kkG+GVuS16s50qm1UjUywl
        JYFYRPqeR+l99Xu6kAB54QgwT+Nh5nxapDBuJJbd9RDLeURWf7VPhGbRqqfD8Yl8NW1mvz/bSiD73
        WXfxZHeD2rzT/Dt9FfWpgyHGUK0WeguDv9hrXCZQz48rjMLrlKMYjgGrx/mviRL5C2NxosLvOdZfb
        RQWvePRJ/J7bM7nLftVC3Yv+jRGHVxUCLkgwHx1kuZeWYK+WQJEdC2huWZ4PHC8sAhmeOoees8uYB
        ssCVCgtDQu7NEhZoM/q64lHqGsDqbHSuMa4QpKaCPBGoG3FInL99lefQMOyAcEtrJKBCoAE+qxhd+
        MoPE/iQg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45516 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mnMsC-0001yo-N6; Wed, 17 Nov 2021 15:29:20 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mnMsC-007y7m-7f; Wed, 17 Nov 2021 15:29:20 +0000
In-Reply-To: <YZUfU8fot1puQoRj@shell.armlinux.org.uk>
References: <YZUfU8fot1puQoRj@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Chris Snook <chris.snook@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Cc:     netdev@vger.kernel.org
Subject: [PATCH RFC net-next 1/3] net: ag71xx: populate supported_interfaces
 member
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mnMsC-007y7m-7f@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 17 Nov 2021 15:29:20 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the phy_interface_t bitmap for the Atheros ag71xx driver with
interfaces modes supported by the MAC.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/atheros/ag71xx.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 88d2ab748399..8d55ce266aa3 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1178,6 +1178,32 @@ static int ag71xx_phylink_setup(struct ag71xx *ag)
 	ag->phylink_config.dev = &ag->ndev->dev;
 	ag->phylink_config.type = PHYLINK_NETDEV;
 
+	if ((ag71xx_is(ag, AR9330) && ag->mac_idx == 0) ||
+	    ag71xx_is(ag, AR9340) ||
+	    ag71xx_is(ag, QCA9530) ||
+	    (ag71xx_is(ag, QCA9550) && ag->mac_idx == 1))
+		__set_bit(PHY_INTERFACE_MODE_MII,
+			  ag->phylink_config.supported_interfaces);
+
+	if ((ag71xx_is(ag, AR9330) && ag->mac_idx == 1) ||
+	    (ag71xx_is(ag, AR9340) && ag->mac_idx == 1) ||
+	    (ag71xx_is(ag, QCA9530) && ag->mac_idx == 1))
+		__set_bit(PHY_INTERFACE_MODE_GMII,
+			  ag->phylink_config.supported_interfaces);
+
+	if (ag71xx_is(ag, QCA9550) && ag->mac_idx == 0)
+		__set_bit(PHY_INTERFACE_MODE_SGMII,
+			  ag->phylink_config.supported_interfaces);
+
+	if (ag71xx_is(ag, AR9340) && ag->mac_idx == 0)
+		__set_bit(PHY_INTERFACE_MODE_RMII,
+			  ag->phylink_config.supported_interfaces);
+
+	if ((ag71xx_is(ag, AR9340) && ag->mac_idx == 0) ||
+	    (ag71xx_is(ag, QCA9550) && ag->mac_idx == 1))
+		__set_bit(PHY_INTERFACE_MODE_RGMII,
+			  ag->phylink_config.supported_interfaces);
+
 	phylink = phylink_create(&ag->phylink_config, ag->pdev->dev.fwnode,
 				 ag->phy_if_mode, &ag71xx_phylink_mac_ops);
 	if (IS_ERR(phylink))
-- 
2.30.2

