Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0244199841
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 16:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730562AbgCaORo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 10:17:44 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:41768 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730358AbgCaORo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 10:17:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DooYIDJnk5/IiNfzdRn65t2HRLP4Ukapo3LCSrFIgQg=; b=r/WJNPoUBDyPf7GXRlmkSvILOJ
        v3MoKAMIqpJawICanwzY7/AgCn6LecKhFEIsTbB80d53L3Rkfa4zaRgzpPvAZ9fN+I5wgnIBFOXJZ
        w+aYrPJ58FRcq7f/a22J45swhcI1GAGIp/nAiNojYAo8WoxF5LzXU0or8fsCoEKD7qc746LHKdDrj
        qNoSnh1f6GpXh63/tFt2uDZFe6GQBbEt6PXg53irtw5FVntzbjFSsaRPFzEo/9bG0jIgEx0KbmrCh
        gd8O9CWfqfTylxSIXrGpE/CClYNEmp5wB1POo6tIHPC+cOFjNE1ZNpl5htIaPbBtzR7cBGOT+r7g8
        QzY3+JPA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38500 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jJHhx-0000EA-Mg; Tue, 31 Mar 2020 15:17:37 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jJHhw-0004UO-OJ; Tue, 31 Mar 2020 15:17:36 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, ioana.ciornei@nxp.com,
        olteanv@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: fix oops while probing Marvell DSA
 switches
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jJHhw-0004UO-OJ@rmk-PC.armlinux.org.uk>
Date:   Tue, 31 Mar 2020 15:17:36 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix an oops in dsa_port_phylink_mac_change() caused by a combination
of a20f997010c4 ("net: dsa: Don't instantiate phylink for CPU/DSA
ports unless needed") and the net-dsa-improve-serdes-integration
series of patches 65b7a2c8e369 ("Merge branch
'net-dsa-improve-serdes-integration'").

Unable to handle kernel NULL pointer dereference at virtual address 00000124
pgd = c0004000
[00000124] *pgd=00000000
Internal error: Oops: 805 [#1] SMP ARM
Modules linked in: tag_edsa spi_nor mtd xhci_plat_hcd mv88e6xxx(+) xhci_hcd armada_thermal marvell_cesa dsa_core ehci_orion libdes phy_armada38x_comphy at24 mcp3021 sfp evbug spi_orion sff mdio_i2c
CPU: 1 PID: 214 Comm: irq/55-mv88e6xx Not tainted 5.6.0+ #470
Hardware name: Marvell Armada 380/385 (Device Tree)
PC is at phylink_mac_change+0x10/0x88
LR is at mv88e6352_serdes_irq_status+0x74/0x94 [mv88e6xxx]

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
This problem only exists when the above patch and series are merged
together.

 net/dsa/slave.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 84dda24b7231..92a8131651cf 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1245,7 +1245,8 @@ void dsa_port_phylink_mac_change(struct dsa_switch *ds, int port, bool up)
 {
 	const struct dsa_port *dp = dsa_to_port(ds, port);
 
-	phylink_mac_change(dp->pl, up);
+	if (dp->pl)
+		phylink_mac_change(dp->pl, up);
 }
 EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_change);
 
-- 
2.20.1

