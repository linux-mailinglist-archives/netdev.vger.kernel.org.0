Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53CA8AA712
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 17:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388612AbfIEPLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 11:11:41 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:49004 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388524AbfIEPLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 11:11:40 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 5665D25BE0B;
        Fri,  6 Sep 2019 01:11:28 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id CDA01940AC6; Thu,  5 Sep 2019 17:11:25 +0200 (CEST)
From:   Simon Horman <horms+renesas@verge.net.au>
To:     David Miller <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH net-next v2 2/4] ravb: remove undocumented counter processing
Date:   Thu,  5 Sep 2019 17:10:57 +0200
Message-Id: <20190905151059.26794-3-horms+renesas@verge.net.au>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190905151059.26794-1-horms+renesas@verge.net.au>
References: <20190905151059.26794-1-horms+renesas@verge.net.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes the use of the undocumented counter registers
CDCR, LCCR, CERCR, CEECR.

Offsets used for undocumented registers are considered reserved and
should not be written to. After some internal investigation with Renesas
it remains unclear why this driver accesses these fields but regardless of
what the historical reasons are the current code is considered incorrect.

Based on work by Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>

Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
---
v2
* New patch broken out of larger patch
---
 drivers/net/ethernet/renesas/ravb.h      | 4 ----
 drivers/net/ethernet/renesas/ravb_main.c | 9 ---------
 2 files changed, 13 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 2596a95a4300..70eeceb7f8ae 100644
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
 
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 6cacd5e893ac..4d1f274cded0 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1629,15 +1629,6 @@ static struct net_device_stats *ravb_get_stats(struct net_device *ndev)
 
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

