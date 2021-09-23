Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204324160BC
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241625AbhIWOK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:10:59 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:61965 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241667AbhIWOKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 10:10:49 -0400
X-IronPort-AV: E=Sophos;i="5.85,316,1624287600"; 
   d="scan'208";a="94816130"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 23 Sep 2021 23:09:16 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id D558D437F0B8;
        Thu, 23 Sep 2021 23:09:13 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: [RFC/PATCH 17/18] ravb: Add carrier_counters to struct ravb_hw_info
Date:   Thu, 23 Sep 2021 15:08:12 +0100
Message-Id: <20210923140813.13541-18-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RZ/G2L E-MAC supports carrier counters.
Add a carrier_counter hw feature bit to struct ravb_hw_info
to add this feature only for RZ/G2L.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  5 +++++
 drivers/net/ethernet/renesas/ravb_main.c | 13 +++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 85260f89e1cd..d42e8ea981df 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -198,11 +198,15 @@ enum ravb_reg {
 	MAHR	= 0x05c0,
 	MALR	= 0x05c8,
 	TROCR	= 0x0700,	/* R-Car Gen3 and RZ/G2L only */
+	CXR41	= 0x0708,	/* Documented for RZ/G2L only */
+	CXR42	= 0x0710,	/* Documented for RZ/G2L only */
 	CEFCR	= 0x0740,
 	FRECR	= 0x0748,
 	TSFRCR	= 0x0750,
 	TLFRCR	= 0x0758,
 	RFCR	= 0x0760,
+	CXR55	= 0x0768,	/* Documented for RZ/G2L only */
+	CXR56	= 0x0770,	/* Documented for RZ/G2L only */
 	MAFCR	= 0x0778,
 	CSR0     = 0x0800,	/* Documented for RZ/G2L only */
 };
@@ -1036,6 +1040,7 @@ struct ravb_hw_info {
 	unsigned half_duplex:1;		/* E-MAC supports half duplex mode */
 	unsigned rx_2k_buffers:1;	/* AVB-DMAC has Max 2K buf size on RX */
 	unsigned timestamp:1;		/* AVB-DMAC has timestamp */
+	unsigned carrier_counters:1;	/* E-MAC has carrier counters */
 };
 
 struct ravb_private {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 867e180e6655..72aea5875bc5 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2060,6 +2060,18 @@ static struct net_device_stats *ravb_get_stats(struct net_device *ndev)
 		ravb_write(ndev, 0, TROCR);	/* (write clear) */
 	}
 
+	if (info->carrier_counters) {
+		nstats->collisions += ravb_read(ndev, CXR41);
+		ravb_write(ndev, 0, CXR41);	/* (write clear) */
+		nstats->tx_carrier_errors += ravb_read(ndev, CXR42);
+		ravb_write(ndev, 0, CXR42);	/* (write clear) */
+
+		nstats->tx_carrier_errors += ravb_read(ndev, CXR55);
+		ravb_write(ndev, 0, CXR55);	/* (write clear) */
+		nstats->tx_carrier_errors += ravb_read(ndev, CXR56);
+		ravb_write(ndev, 0, CXR56);	/* (write clear) */
+	}
+
 	nstats->rx_packets = stats0->rx_packets + stats1->rx_packets;
 	nstats->tx_packets = stats0->tx_packets + stats1->tx_packets;
 	nstats->rx_bytes = stats0->rx_bytes + stats1->rx_bytes;
@@ -2425,6 +2437,7 @@ static const struct ravb_hw_info rgeth_hw_info = {
 	.no_gptp = 1,
 	.mii_rgmii_selection = 1,
 	.half_duplex = 1,
+	.carrier_counters = 1,
 };
 
 static const struct of_device_id ravb_match_table[] = {
-- 
2.17.1

