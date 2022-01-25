Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E1149B98A
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 18:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbiAYRBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 12:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237640AbiAYQ7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:59:43 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B00C061796
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 08:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=I7cjRL1/VsHOWXY6M+pd1EaG2Wm3KWnOOJeelJw/hjM=; b=IPaWXKJOGV0gPOE8b/6xfik4AE
        SRQnVewmZJ/moFQnyCqIHnoY4xEo327AShz+jb6J9bhgl6Rt9+xRy+Gu+FjvBdUVTypMMNgE5QQtQ
        +pGza1dJgVkQ4jz4n0pSsHEOvwMnG2pSHdHaY3x2a6m5jLowap8nwqCtz1ZSMoUxsqWFCvwP9otYg
        E6gPkB1d27004dB/52yZ6OsMWFn4trWkGUWXlEt/8onVfnSCYIBhkl9G2JH7yVjX6GVWwT8Fep86E
        GXuaTrnGVDn5i3ySiCDtmgLgwtQ/bm7mo7PvmAg0w/1fh4f2gyiN0/xRr+QZP6I/d9yzPuXAZdhda
        RzPICQvQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57538 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nCPAM-0002FL-QD; Tue, 25 Jan 2022 16:59:34 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nCPAM-005LdP-75; Tue, 25 Jan 2022 16:59:34 +0000
In-Reply-To: <YfAsXaXfSGQX8w75@shell.armlinux.org.uk>
References: <YfAsXaXfSGQX8w75@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: mvneta: use .mac_select_pcs() interface
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nCPAM-005LdP-75@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 25 Jan 2022 16:59:34 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert mvneta to use the mac_select_interface rather than using
phylink_set_pcs(). The intention here is to unify the approach for
PCS and eventually remove phylink_set_pcs().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index c4aadb6a5640..315a43e4c63d 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4012,6 +4012,15 @@ static const struct phylink_pcs_ops mvneta_phylink_pcs_ops = {
 	.pcs_an_restart = mvneta_pcs_an_restart,
 };
 
+static struct phylink_pcs *mvneta_mac_select_pcs(struct phylink_config *config,
+						 phy_interface_t interface)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct mvneta_port *pp = netdev_priv(ndev);
+
+	return &pp->phylink_pcs;
+}
+
 static int mvneta_mac_prepare(struct phylink_config *config, unsigned int mode,
 			      phy_interface_t interface)
 {
@@ -4219,6 +4228,7 @@ static void mvneta_mac_link_up(struct phylink_config *config,
 
 static const struct phylink_mac_ops mvneta_phylink_ops = {
 	.validate = phylink_generic_validate,
+	.mac_select_pcs = mvneta_mac_select_pcs,
 	.mac_prepare = mvneta_mac_prepare,
 	.mac_config = mvneta_mac_config,
 	.mac_finish = mvneta_mac_finish,
@@ -5462,8 +5472,6 @@ static int mvneta_probe(struct platform_device *pdev)
 
 	pp->phylink = phylink;
 
-	phylink_set_pcs(phylink, &pp->phylink_pcs);
-
 	/* Alloc per-cpu port structure */
 	pp->ports = alloc_percpu(struct mvneta_pcpu_port);
 	if (!pp->ports) {
-- 
2.30.2

