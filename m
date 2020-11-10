Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9664F2ACB7A
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 04:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731300AbgKJDDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 22:03:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44914 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729452AbgKJDDK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 22:03:10 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kcJw3-006D8X-Un; Tue, 10 Nov 2020 04:03:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 1/7] drivers: net: smc91x: Fix set but unused W=1 warning
Date:   Tue, 10 Nov 2020 04:02:42 +0100
Message-Id: <20201110030248.1480413-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110030248.1480413-1-andrew@lunn.ch>
References: <20201110030248.1480413-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/smsc/smc91x.c:706:51: warning: variable ‘pkt_len’ set but not used [-Wunused-but-set-variable]
  706 |  unsigned int saved_packet, packet_no, tx_status, pkt_len;

The read of the packet length in the descriptor probably needs to be
kept in order to keep the hardware happy. So tell the compiler we
don't expect to use the value by using the __always_unused attribute.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/smsc/smc91x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index f6b73afd1879..c8dabeaab4fc 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -703,7 +703,8 @@ static void smc_tx(struct net_device *dev)
 {
 	struct smc_local *lp = netdev_priv(dev);
 	void __iomem *ioaddr = lp->base;
-	unsigned int saved_packet, packet_no, tx_status, pkt_len;
+	unsigned int saved_packet, packet_no, tx_status;
+	unsigned int pkt_len __always_unused;
 
 	DBG(3, dev, "%s\n", __func__);
 
-- 
2.29.2

