Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B984184859
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 14:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgCMNkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 09:40:12 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:59806 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726643AbgCMNkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 09:40:11 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 13A03C0FAE;
        Fri, 13 Mar 2020 13:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584106810; bh=eZaz7QmNn7/lhPC4PtgvXOXPurr9yFGp2AZ2kph2crc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=WPrPBng89voYhxyoCDKUY0yiu9/Gq+5XgjxauecN7jjl2PYLTgEsu4Cv24/FCahkB
         LUjIUMxwPo/KI72rL6Taf48IJefhLctgUDr50V7d5QrN/UrBnxEB3OoVkaPOwa0LBX
         7W7uPIcFTcpaaJ6fncKMG3mw29nf3ffFdUT6yyAUcztOfrYVl98IghVUWbOQli0j30
         iSDlPnsB1DlPxdRIIo9Po78wnDETSOBe5FXbe8DpTNpQjKAhRZYM/ly0opeRi+10Ig
         CdmaLgIcm4yCIOL1vcVmHu+ZEU8f3b4yCvAtn5BSOAM5wRtMEQMFqwS6iQgE02TJAr
         4pSOb54PKPe/g==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 7D2A8A0061;
        Fri, 13 Mar 2020 13:40:08 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/4] net: phy: xpcs: Return error upon RX/TX fault
Date:   Fri, 13 Mar 2020 14:39:41 +0100
Message-Id: <7918fdf6bbe6505a64e54ae360c59c905aa3fe1d.1584106347.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1584106347.git.Jose.Abreu@synopsys.com>
References: <cover.1584106347.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1584106347.git.Jose.Abreu@synopsys.com>
References: <cover.1584106347.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RX/TX fault status results in link errors. Return error upon these cases
so that XPCS can be correctly resumed.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/phy/mdio-xpcs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mdio-xpcs.c b/drivers/net/phy/mdio-xpcs.c
index a4cbeecc6d42..23516397b982 100644
--- a/drivers/net/phy/mdio-xpcs.c
+++ b/drivers/net/phy/mdio-xpcs.c
@@ -190,10 +190,14 @@ static int xpcs_read_fault(struct mdio_xpcs_args *xpcs,
 	if (ret < 0)
 		return ret;
 
-	if (ret & MDIO_STAT2_RXFAULT)
+	if (ret & MDIO_STAT2_RXFAULT) {
 		xpcs_warn(xpcs, state, "Receiver fault detected!\n");
-	if (ret & MDIO_STAT2_TXFAULT)
+		return -EFAULT;
+	}
+	if (ret & MDIO_STAT2_TXFAULT) {
 		xpcs_warn(xpcs, state, "Transmitter fault detected!\n");
+		return -EFAULT;
+	}
 
 	ret = xpcs_read_vendor(xpcs, MDIO_MMD_PCS, DW_VR_XS_PCS_DIG_STS);
 	if (ret < 0)
-- 
2.7.4

