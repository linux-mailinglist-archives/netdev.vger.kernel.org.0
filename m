Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD2031096B
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 11:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhBEKpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 05:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbhBEKkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 05:40:52 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C935C0617AA
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 02:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Qn2rgmzDuOrhSwmxRE/mJbcbohOyHkkBW5r8vUbcHDw=; b=NYy/MtlDWfYpzq46GYvyhNx23c
        p9owp8MWd8wBTh1jDMUTu5CLWp5xAkoNdzGFdBxIalZ5bs2eb2lpHnJEyV6PfQBxSvDAkisCRLFle
        ezFsGGIPqxghiEBPQ6TK9mqCvrQNyCNL6L1YNE6fj1iarmEMT3789EOzODBI+g+yArSxG/Nh+URS0
        AL/yh7H49H72OB5ujTcSBSyzEP+NFY772M0kogdQnMqGyNfcQaqs8sOuf9bcR/1FbVi8oDvNik+Dq
        NzhCVVeB1UjZipJgYUSlx082p4e4cJkr0pzf7vOnIS8PlqG4nXewSRDX7SDcEfYBFHpCsZZ44Myqg
        L9vmL9pg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49114 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1l7yX3-0007ek-K9; Fri, 05 Feb 2021 10:40:09 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1l7yX3-0006ob-E6; Fri, 05 Feb 2021 10:40:09 +0000
In-Reply-To: <20210205103859.GH1463@shell.armlinux.org.uk>
References: <20210205103859.GH1463@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 3/3] net: dpaa2-mac: add backplane link mode
 support
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1l7yX3-0006ob-E6@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 05 Feb 2021 10:40:09 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for backplane link mode, which is, according to discussions
with NXP earlier in the year, is a mode where the OS (Linux) is able to
manage the PCS and Serdes itself.

This commit prepares the ground work for allowing 1G fiber connections
to be used with DPAA2 on the SolidRun CEX7 platforms.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h | 4 +++-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index c3d456c45102..9b6a89709ce1 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -695,7 +695,9 @@ static inline unsigned int dpaa2_eth_rx_head_room(struct dpaa2_eth_priv *priv)
 
 static inline bool dpaa2_eth_is_type_phy(struct dpaa2_eth_priv *priv)
 {
-	if (priv->mac && priv->mac->attr.link_type == DPMAC_LINK_TYPE_PHY)
+	if (priv->mac &&
+	    (priv->mac->attr.link_type == DPMAC_LINK_TYPE_PHY ||
+	     priv->mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE))
 		return true;
 
 	return false;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 3ddfb40eb5e4..ccaf7e35abeb 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -315,8 +315,9 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 		goto err_put_node;
 	}
 
-	if (mac->attr.link_type == DPMAC_LINK_TYPE_PHY &&
-	    mac->attr.eth_if != DPMAC_ETH_IF_RGMII) {
+	if ((mac->attr.link_type == DPMAC_LINK_TYPE_PHY &&
+	     mac->attr.eth_if != DPMAC_ETH_IF_RGMII) ||
+	    mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE) {
 		err = dpaa2_pcs_create(mac, dpmac_node, mac->attr.id);
 		if (err)
 			goto err_put_node;
-- 
2.20.1

