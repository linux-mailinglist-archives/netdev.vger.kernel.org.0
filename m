Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198D74771FF
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 13:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbhLPMlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 07:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhLPMlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 07:41:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CCBC061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 04:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/Ml/7j0E/1wT1AhdlTDB46KMQDUPmwPkFdD19ipTVIA=; b=NWqOG57sN5LmkTGqWHBoHD8wZT
        8YbwUGVP1Yz5aN3W/StIUpA7Ex6jJnE4pMFnrwEb32/IdOvh80IVE7650KjcAFO96x+niC9YBDplU
        HNm14Ly+1oH//Smk7P+oAWumEjc8wJZjhy1OVc8BfXkPSMqgMCkLOvVC5KDVn2lJIwGjbzw/6MzaJ
        5S4TMDdP7IQNnSsHYMygpKKY0zXCSq8idfS0gAQuFNPn94vrWMkQdCd0Qw8BL6X7eDGhqxTV8GbWN
        OyGMMQgGSQfBRKad1rvPo+zYjDMYT8yByjlbNvFgs6FNJP1ybixxmx6ZlTFIxri0Fthm3WRngPcYL
        cPdxv1pg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49790 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxq4s-0007oH-1C; Thu, 16 Dec 2021 12:41:42 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxq4r-00GWrp-Ay; Thu, 16 Dec 2021 12:41:41 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>, netdev@vger.kernel.org
Subject: [PATCH CFT net-next] net: enetc: use .mac_select_pcs() interface
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mxq4r-00GWrp-Ay@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 16 Dec 2021 12:41:41 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the PCS selection to use mac_select_pcs, which allows the PCS
to perform any validation it needs.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index fe6a544f37f0..1f5bc8fe0a3c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -930,18 +930,21 @@ static void enetc_mdiobus_destroy(struct enetc_pf *pf)
 	enetc_imdio_remove(pf);
 }
 
+static struct phylink_pcs *
+enetc_pl_mac_select_pcs(struct phylink_config *config, phy_interface_t iface)
+{
+	struct enetc_pf *pf = phylink_to_enetc_pf(config);
+
+	return pf->pcs ? &pf->pcs->pcs : NULL;
+}
+
 static void enetc_pl_mac_config(struct phylink_config *config,
 				unsigned int mode,
 				const struct phylink_link_state *state)
 {
 	struct enetc_pf *pf = phylink_to_enetc_pf(config);
-	struct enetc_ndev_priv *priv;
 
 	enetc_mac_config(&pf->si->hw, state->interface);
-
-	priv = netdev_priv(pf->si->ndev);
-	if (pf->pcs)
-		phylink_set_pcs(priv->phylink, &pf->pcs->pcs);
 }
 
 static void enetc_force_rgmii_mac(struct enetc_hw *hw, int speed, int duplex)
@@ -1058,6 +1061,7 @@ static void enetc_pl_mac_link_down(struct phylink_config *config,
 
 static const struct phylink_mac_ops enetc_mac_phylink_ops = {
 	.validate = phylink_generic_validate,
+	.mac_select_pcs = enetc_pl_mac_select_pcs,
 	.mac_config = enetc_pl_mac_config,
 	.mac_link_up = enetc_pl_mac_link_up,
 	.mac_link_down = enetc_pl_mac_link_down,
-- 
2.30.2

