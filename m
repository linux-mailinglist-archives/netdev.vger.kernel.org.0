Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2BC0105A3C
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 20:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfKUTPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 14:15:53 -0500
Received: from inva021.nxp.com ([92.121.34.21]:59772 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbfKUTPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 14:15:53 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 31F2320062F;
        Thu, 21 Nov 2019 20:15:51 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 25D8B200626;
        Thu, 21 Nov 2019 20:15:51 +0100 (CET)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id D160420413;
        Thu, 21 Nov 2019 20:15:50 +0100 (CET)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, andrew@lunn.ch,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/3] dpaa2-eth: add phylink_mac_ops stub callbacks
Date:   Thu, 21 Nov 2019 21:15:26 +0200
Message-Id: <1574363727-5437-3-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1574363727-5437-1-git-send-email-ioana.ciornei@nxp.com>
References: <1574363727-5437-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the moment, we do not have a way to query the PCS link state
or to restart aneg on it. Add stub functions for both of the callbacks
since phylink can provoke an oops when an SFP module has been inserted.

Fixes: 719479230893 ("dpaa2-eth: add MAC/PHY support through phylink")
Reported-by: Russell King <linux@armlinux.org.uk>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 0200308d1bc7..efc587515661 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -183,11 +183,24 @@ static void dpaa2_mac_link_down(struct phylink_config *config,
 		netdev_err(mac->net_dev, "dpmac_set_link_state() = %d\n", err);
 }
 
+static void dpaa2_mac_an_restart(struct phylink_config *config)
+{
+	/* Not supported */
+}
+
+static void dpaa2_mac_pcs_get_state(struct phylink_config *config,
+				    struct phylink_link_state *state)
+{
+	/* Not supported */
+}
+
 static const struct phylink_mac_ops dpaa2_mac_phylink_ops = {
 	.validate = dpaa2_mac_validate,
 	.mac_config = dpaa2_mac_config,
 	.mac_link_up = dpaa2_mac_link_up,
 	.mac_link_down = dpaa2_mac_link_down,
+	.mac_an_restart = dpaa2_mac_an_restart,
+	.mac_pcs_get_state = dpaa2_mac_pcs_get_state,
 };
 
 bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
-- 
1.9.1

