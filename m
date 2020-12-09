Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF0C2D3FE5
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 11:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729929AbgLIKas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 05:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729922AbgLIKas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 05:30:48 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE68C061793
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 02:30:07 -0800 (PST)
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1kmwjS-0005ty-KH; Wed, 09 Dec 2020 11:30:02 +0100
Received: from ukl by dude02.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1kmwjQ-0000Z8-9f; Wed, 09 Dec 2020 11:30:00 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     kernel@pengutronix.de, netdev@vger.kernel.org
Subject: [PATCH] net: ethernet: fec: Clear stale flag in IEVENT register before MII transfers
Date:   Wed,  9 Dec 2020 11:29:59 +0100
Message-Id: <20201209102959.2131-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some mii transfers the MII bit in the event register is already set
before a read or write transfer is started. This breaks evaluating the
transfer's result because it is checked too early.

Before MII transfers were switched from irq to polling this was not an
issue because then it just resulted in an irq which completed the
mdio_done completion. This completion however was reset before each
transfer and so the event didn't hurt.

This fixes NFS booting on an i.MX25 based machine.

Fixes: f166f890c8f0 ("net: ethernet: fec: Replace interrupt driven MDIO with polled IO")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

I tried (shortly) to find out what actually results in this bit being
set because looking at f166f890c8f0 I'd say it cares enough. It's just
proven by the real world that it's not good enough :-)

Best regards
Uwe

 drivers/net/ethernet/freescale/fec_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2e209142f2d1..ab21d2bcda75 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1869,6 +1869,8 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 		frame_addr = regnum;
 	}
 
+	writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
+
 	/* start a read op */
 	writel(frame_start | frame_op |
 		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
@@ -1926,6 +1928,8 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 		frame_addr = regnum;
 	}
 
+	writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
+
 	/* start a write op */
 	writel(frame_start | FEC_MMFR_OP_WRITE |
 		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
-- 
2.20.1

