Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0ADDA50DC
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 10:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbfIBIGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 04:06:15 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:60600 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730072AbfIBIGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 04:06:15 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id D197425B7E3;
        Mon,  2 Sep 2019 18:06:07 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 599DB94048C; Mon,  2 Sep 2019 10:06:05 +0200 (CEST)
From:   Simon Horman <horms+renesas@verge.net.au>
To:     David Miller <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [net-next 2/3] ravb: Remove undocumented processing
Date:   Mon,  2 Sep 2019 10:06:02 +0200
Message-Id: <20190902080603.5636-3-horms+renesas@verge.net.au>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190902080603.5636-1-horms+renesas@verge.net.au>
References: <20190902080603.5636-1-horms+renesas@verge.net.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>

This patch removes the use of the undocumented registers
CDCR, LCCR, CERCR, CEECR and the undocumented BOC bit of the CCC register.

Current documentation for EtherAVB (ravb) describes the offset of
what the driver uses as the BOC bit as reserved and that only a value of
0 should be written. Furthermore, the offsets used for the undocumented
registers are also considered reserved nd should not be written to.

After some internal investigation with Renesas it remains unclear
why this driver accesses these fields but regardless of what the historical
reasons are the current code is considered incorrect.

Signed-off-by: Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
---
 drivers/net/ethernet/renesas/ravb.h      |  5 -----
 drivers/net/ethernet/renesas/ravb_main.c | 15 ---------------
 2 files changed, 20 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 2596a95a4300..bdb051f04b0c 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -194,15 +194,11 @@ enum ravb_reg {
 	MAHR	= 0x05c0,
 	MALR	= 0x05c8,
 	TROCR	= 0x0700,	/* Undocumented? */
-	CDCR	= 0x0708,	/* Undocumented? */
-	LCCR	= 0x0710,	/* Undocumented? */
 	CEFCR	= 0x0740,
 	FRECR	= 0x0748,
 	TSFRCR	= 0x0750,
 	TLFRCR	= 0x0758,
 	RFCR	= 0x0760,
-	CERCR	= 0x0768,	/* Undocumented? */
-	CEECR	= 0x0770,	/* Undocumented? */
 	MAFCR	= 0x0778,
 };
 
@@ -220,7 +216,6 @@ enum CCC_BIT {
 	CCC_CSEL_HPB	= 0x00010000,
 	CCC_CSEL_ETH_TX	= 0x00020000,
 	CCC_CSEL_GMII_REF = 0x00030000,
-	CCC_BOC		= 0x00100000,	/* Undocumented? */
 	CCC_LBME	= 0x01000000,
 };
 
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 6cacd5e893ac..b538cc6fdbb7 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -447,12 +447,6 @@ static int ravb_dmac_init(struct net_device *ndev)
 	ravb_ring_format(ndev, RAVB_BE);
 	ravb_ring_format(ndev, RAVB_NC);
 
-#if defined(__LITTLE_ENDIAN)
-	ravb_modify(ndev, CCC, CCC_BOC, 0);
-#else
-	ravb_modify(ndev, CCC, CCC_BOC, CCC_BOC);
-#endif
-
 	/* Set AVB RX */
 	ravb_write(ndev,
 		   RCR_EFFS | RCR_ENCF | RCR_ETS0 | RCR_ESF | 0x18000000, RCR);
@@ -1629,15 +1623,6 @@ static struct net_device_stats *ravb_get_stats(struct net_device *ndev)
 
 	nstats->tx_dropped += ravb_read(ndev, TROCR);
 	ravb_write(ndev, 0, TROCR);	/* (write clear) */
-	nstats->collisions += ravb_read(ndev, CDCR);
-	ravb_write(ndev, 0, CDCR);	/* (write clear) */
-	nstats->tx_carrier_errors += ravb_read(ndev, LCCR);
-	ravb_write(ndev, 0, LCCR);	/* (write clear) */
-
-	nstats->tx_carrier_errors += ravb_read(ndev, CERCR);
-	ravb_write(ndev, 0, CERCR);	/* (write clear) */
-	nstats->tx_carrier_errors += ravb_read(ndev, CEECR);
-	ravb_write(ndev, 0, CEECR);	/* (write clear) */
 
 	nstats->rx_packets = stats0->rx_packets + stats1->rx_packets;
 	nstats->tx_packets = stats0->tx_packets + stats1->tx_packets;
-- 
2.11.0

