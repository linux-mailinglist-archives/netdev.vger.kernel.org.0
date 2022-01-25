Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644E749B8A2
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbiAYQcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454151AbiAYQbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:31:13 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFC8C06173B
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 08:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ym/9hw8gwzhtu2X8fnrkXRhaDu8es8lD9kHHOGZZ6Us=; b=eQE/zGYToi8rBXDpI8GdHlz6PI
        lqeV3g5bNfLLV7rc2gifBqvg1f5CzkOHADs65wDVY0RPLhgpPYHX39bcPojdeln0LgtDB/fhWYkq6
        J3N4HKlaAB4FFE9sZsfUSG04ir99wRDQx+KkW1ATQ94sKUWE/EHCAsgZz65fakanaqUH9CpYoI1tI
        PyVRGeN59lXYs84mYw8EZe45gPZ5qL7tSw9DdrL0vbO9mS8sOzGl2hWvnhKrwtdyPDWur84uS/Asv
        ieRp5cCuPFzumrcXm2j69DCRxCPS8hsZHJQN4CvH3NAskM/mtfO2X+RsJdCgQm4u5yLEFx4f0XlvU
        4+VTeJPg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57356 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nCOit-00029w-7n; Tue, 25 Jan 2022 16:31:11 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nCOis-005LHL-LJ; Tue, 25 Jan 2022 16:31:10 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: enetc: use .mac_select_pcs() interface
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nCOis-005LHL-LJ@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 25 Jan 2022 16:31:10 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the PCS selection to use mac_select_pcs, which allows the PCS
to perform any validation it needs.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
CFT patch message id E1mxq4r-00GWrp-Ay@rmk-PC.armlinux.org.uk

 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index ed16a5ac9ad0..a0c75c717073 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -934,18 +934,21 @@ static void enetc_mdiobus_destroy(struct enetc_pf *pf)
 	enetc_imdio_remove(pf);
 }
 
+static struct phylink_pcs *
+enetc_pl_mac_select_pcs(struct phylink_config *config, phy_interface_t iface)
+{
+	struct enetc_pf *pf = phylink_to_enetc_pf(config);
+
+	return pf->pcs;
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
-		phylink_set_pcs(priv->phylink, pf->pcs);
 }
 
 static void enetc_force_rgmii_mac(struct enetc_hw *hw, int speed, int duplex)
@@ -1062,6 +1065,7 @@ static void enetc_pl_mac_link_down(struct phylink_config *config,
 
 static const struct phylink_mac_ops enetc_mac_phylink_ops = {
 	.validate = phylink_generic_validate,
+	.mac_select_pcs = enetc_pl_mac_select_pcs,
 	.mac_config = enetc_pl_mac_config,
 	.mac_link_up = enetc_pl_mac_link_up,
 	.mac_link_down = enetc_pl_mac_link_down,
-- 
2.30.2

