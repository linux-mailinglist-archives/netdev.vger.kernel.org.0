Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2BA49B8A0
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbiAYQcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350083AbiAYQ1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:27:38 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74E4C061760
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 08:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1OeBQ8ObQI92Isu6QA9d26tgZEA35xMF72uDxF3fJwY=; b=cxdfE0nCXHbf+hnWyMKGlI8Iz9
        SkUE0faqW+GPRWktDqhSTaBGRFxMhFfoaNgkHQQtAHJd9v/gc6xySxmfy5mD3LFmKLA//ppjYH2jb
        Xh+zD82OV7AVqKFDXrMbbXxUMX+LsMBfOQctvX4wLPwrzdy8GZrptaOywxLGEVheOjopPCcETb5cL
        KeZADsygCmWoFO/Q1ABLUUP1J3hNcC/sNzSHismSaCQiA9wGKKrpwOcRHY8F4KmcbZzwof3mRsqYM
        1KoOuOakwT7iAPJRkM/zbQ6kHLvTsm9QkOOi6QgM1lbl68fVfQP6fU6/3V8CwPd8cNyqA3giKlavf
        yh7PWu6g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57340 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nCOfL-00029g-H8; Tue, 25 Jan 2022 16:27:31 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nCOfK-005LEI-To; Tue, 25 Jan 2022 16:27:30 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: dpaa2-mac: use .mac_select_pcs() interface
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nCOfK-005LEI-To@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 25 Jan 2022 16:27:30 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert dpaa2-mac to use the mac_select_pcs() interface rather than
using phylink_set_pcs(). The intention here is to unify the approach
for PCS and eventually to remove phylink_set_pcs().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 623d113b6581..521f036d1c00 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -100,6 +100,14 @@ static int dpaa2_mac_get_if_mode(struct fwnode_handle *dpmac_node,
 	return err;
 }
 
+static struct phylink_pcs *dpaa2_mac_select_pcs(struct phylink_config *config,
+						phy_interface_t interface)
+{
+	struct dpaa2_mac *mac = phylink_to_dpaa2_mac(config);
+
+	return mac->pcs;
+}
+
 static void dpaa2_mac_config(struct phylink_config *config, unsigned int mode,
 			     const struct phylink_link_state *state)
 {
@@ -172,6 +180,7 @@ static void dpaa2_mac_link_down(struct phylink_config *config,
 
 static const struct phylink_mac_ops dpaa2_mac_phylink_ops = {
 	.validate = phylink_generic_validate,
+	.mac_select_pcs = dpaa2_mac_select_pcs,
 	.mac_config = dpaa2_mac_config,
 	.mac_link_up = dpaa2_mac_link_up,
 	.mac_link_down = dpaa2_mac_link_down,
@@ -303,9 +312,6 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	}
 	mac->phylink = phylink;
 
-	if (mac->pcs)
-		phylink_set_pcs(mac->phylink, mac->pcs);
-
 	err = phylink_fwnode_phy_connect(mac->phylink, dpmac_node, 0);
 	if (err) {
 		netdev_err(net_dev, "phylink_fwnode_phy_connect() = %d\n", err);
-- 
2.30.2

