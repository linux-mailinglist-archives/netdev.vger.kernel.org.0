Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22BBE1BC761
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 20:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgD1SCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 14:02:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57600 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727827AbgD1R7R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 13:59:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XQSu7TMEXytJWHO15QNLftQ1/MdjNcFx1sEuUg1XFLo=; b=n4Tz0ZPj4nmCk1r+b57GzrU7WK
        4mJONiMAoABdMKwpHMOfVpZgMMCqxJpmbz3shJPyWCN5BKX3aRwBXQ5cvtXSZE6CbKmZjlSRW4/I5
        OeW7KygoDN1EnT6uok2gsC5X6Av4RPRoS5AprXrI1jbpegQCPD6SzrJKXO0/3oUyRx0Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTUVk-0007xP-Nd; Tue, 28 Apr 2020 19:59:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Andy Duan <fugang.duan@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: ethernet: fec: Prevent MII event after MII_SPEED write
Date:   Tue, 28 Apr 2020 19:58:33 +0200
Message-Id: <20200428175833.30517-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The change to polled IO for MDIO completion assumes that MII events
are only generated for MDIO transactions. However on some SoCs writing
to the MII_SPEED register can also trigger an MII event. As a result,
the next MDIO read has a pending MII event, and immediately reads the
data registers before it contains useful data. When the read does
complete, another MII event is posted, which results in the next read
also going wrong, and the cycle continues.

By writing 0 to the MII_DATA register before writing to the speed
register, this MII event for the MII_SPEED is suppressed, and polled
IO works as expected.

Fixes: 29ae6bd1b0d8 ("net: ethernet: fec: Replace interrupt driven MDIO with polled IO")
Reported-by: Andy Duan <fugang.duan@nxp.com>
Suggested-by: Andy Duan <fugang.duan@nxp.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/freescale/fec_main.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 1ae075a246a3..aa5e744ec098 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -996,6 +996,9 @@ fec_restart(struct net_device *ndev)
 		writel(0x0, fep->hwp + FEC_X_CNTRL);
 	}
 
+	/* Prevent an MII event being report when changing speed */
+	writel(0, fep->hwp + FEC_MII_DATA);
+
 	/* Set MII speed */
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
 
@@ -1182,6 +1185,10 @@ fec_stop(struct net_device *ndev)
 		writel(val, fep->hwp + FEC_ECNTRL);
 		fec_enet_stop_mode(fep, true);
 	}
+
+	/* Prevent an MII event being report when changing speed */
+	writel(0, fep->hwp + FEC_MII_DATA);
+
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
 
 	/* We have to keep ENET enabled to have MII interrupt stay working */
@@ -2142,6 +2149,16 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	if (suppress_preamble)
 		fep->phy_speed |= BIT(7);
 
+	/* Clear MMFR to avoid to generate MII event by writing MSCR.
+	 * MII event generation condition:
+	 * - writing MSCR:
+	 *	- mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
+	 *	  mscr_reg_data_in[7:0] != 0
+	 * - writing MMFR:
+	 *	- mscr[7:0]_not_zero
+	 */
+	writel(0, fep->hwp + FEC_MII_DATA);
+
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
 
 	/* Clear any pending transaction complete indication */
-- 
2.26.1

