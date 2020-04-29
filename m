Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726741BE932
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgD2Uxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:53:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60624 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbgD2Uxn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 16:53:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IMBjN/jnaGU/fNPl2LRt5FK9mjn+jTK5YE+/QO/RgWE=; b=kx/TsuV//tzLS9yyqn9UwI9QXV
        R/3LYfZE90txrMr/4pn3VfBRXG/8UJDM2FwTNFOji8vUTF6NyG5DsislXOC1YeUdEcSF4/lOvJeGH
        0vu8cbHHGRRAFhYVVyB6DV2B5yJHDSJ+zW6UaenlrXEMDmbvXQ1YBhAgylyR5HXlFkAs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTti5-000K1J-L0; Wed, 29 Apr 2020 22:53:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, fugang.duan@nxp.com,
        Chris Healy <cphealy@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2] net: ethernet: fec: Prevent MII event after MII_SPEED write
Date:   Wed, 29 Apr 2020 22:53:23 +0200
Message-Id: <20200429205323.76908-1-andrew@lunn.ch>
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

v2 - Only infec_enet_mii_init()

Fixes: 29ae6bd1b0d8 ("net: ethernet: fec: Replace interrupt driven MDIO with polled IO")
Reported-by: Andy Duan <fugang.duan@nxp.com>
Suggested-by: Andy Duan <fugang.duan@nxp.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/freescale/fec_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 1ae075a246a3..2e209142f2d1 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2142,6 +2142,16 @@ static int fec_enet_mii_init(struct platform_device *pdev)
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

