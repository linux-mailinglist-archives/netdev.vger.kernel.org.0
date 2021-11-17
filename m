Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85806454BE3
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 18:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239376AbhKQR1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 12:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239374AbhKQR1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 12:27:04 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CF4C061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 09:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/5pJKAu86clUfne3m1qNFiQsezJ+QXOL8gtg93QnGOs=; b=kH2rl90bLU7bBb8ZHN5Ju6nQ0Q
        /Fe7INUXnly45loGkg+uuCePb4mATT9u4ipjhxGEg6rft4v8aMb753MSTecS6bZHYH9869hhDlvaa
        Gj0U/AqPw1pjQSHDaR2UC7vFVf6NmZeML6BWNDDAXqsZHZba9wJgI/yTO84wTSjP3kJQCMi6zfhCG
        pGZR84UrE2CYIcWzZot6u2JzKsoLimO77I0nPgPyboEC+flWABxZaLSbjnhc49xyRBU7yoxEq1WA1
        l25vf3p4y3NoPzMU64U7WKUWJubMWcLwqerWpA8SE/QbpB7l3V1xvu8NwJgtTKz29IbiYI56oB3hk
        wr5xWoSA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46360 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mnOfD-00029K-63; Wed, 17 Nov 2021 17:24:03 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mnOfC-0085Ij-MK; Wed, 17 Nov 2021 17:24:02 +0000
In-Reply-To: <YZU1oGJuGBpQF+vi@shell.armlinux.org.uk>
References: <YZU1oGJuGBpQF+vi@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/3] net: dpaa2-mac: populate supported_interfaces
 member
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mnOfC-0085Ij-MK@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 17 Nov 2021 17:24:02 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the phy interface mode bitmap for the Freescale DPAA2 driver
with interfaces modes supported by the MAC.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index ef8f0a055024..176ce0a03716 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -336,9 +336,30 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 			return err;
 	}
 
+	memset(&mac->phylink_config, 0, sizeof(mac->phylink_config));
 	mac->phylink_config.dev = &net_dev->dev;
 	mac->phylink_config.type = PHYLINK_NETDEV;
 
+	/* We support the current interface mode, and if we have a PCS
+	 * similar interface modes that do not require the PLLs to be
+	 * reconfigured.
+	 */
+	__set_bit(mac->if_mode, mac->phylink_config.supported_interfaces);
+	if (mac->pcs) {
+		switch (mac->if_mode) {
+		case PHY_INTERFACE_MODE_1000BASEX:
+		case PHY_INTERFACE_MODE_SGMII:
+			__set_bit(PHY_INTERFACE_MODE_1000BASEX,
+				  mac->phylink_config.supported_interfaces);
+			__set_bit(PHY_INTERFACE_MODE_SGMII,
+				  mac->phylink_config.supported_interfaces);
+			break;
+
+		default:
+			break;
+		}
+	}
+
 	phylink = phylink_create(&mac->phylink_config,
 				 dpmac_node, mac->if_mode,
 				 &dpaa2_mac_phylink_ops);
-- 
2.30.2

