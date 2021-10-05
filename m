Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B3942249F
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbhJELJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:09:09 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:11860 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234387AbhJELJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 07:09:07 -0400
X-IronPort-AV: E=Sophos;i="5.85,348,1624287600"; 
   d="scan'208";a="96182806"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 05 Oct 2021 20:07:16 +0900
Received: from localhost.localdomain (unknown [10.226.93.104])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 9EF0540078B9;
        Tue,  5 Oct 2021 20:07:13 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [RFC 08/12] ravb: Add carrier_counters to struct ravb_hw_info
Date:   Tue,  5 Oct 2021 12:06:38 +0100
Message-Id: <20211005110642.3744-9-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RZ/G2L E-MAC supports carrier counters.
Add a carrier_counter hw feature bit to struct ravb_hw_info
to add this feature only for RZ/G2L.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
RFC changes:
 * Added Sergey's Rb tag.
---
 drivers/net/ethernet/renesas/ravb.h      |  5 +++++
 drivers/net/ethernet/renesas/ravb_main.c | 13 +++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 8c7b2569c7dd..899e16c5eb1a 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -196,11 +196,15 @@ enum ravb_reg {
 	MAHR	= 0x05c0,
 	MALR	= 0x05c8,
 	TROCR	= 0x0700,	/* R-Car Gen3 and RZ/G2L only */
+	CXR41	= 0x0708,	/* RZ/G2L only */
+	CXR42	= 0x0710,	/* RZ/G2L only */
 	CEFCR	= 0x0740,
 	FRECR	= 0x0748,
 	TSFRCR	= 0x0750,
 	TLFRCR	= 0x0758,
 	RFCR	= 0x0760,
+	CXR55	= 0x0768,	/* RZ/G2L only */
+	CXR56	= 0x0770,	/* RZ/G2L only */
 	MAFCR	= 0x0778,
 	CSR0    = 0x0800,	/* RZ/G2L only */
 	CSR1    = 0x0804,	/* RZ/G2L only */
@@ -1061,6 +1065,7 @@ struct ravb_hw_info {
 	unsigned nc_queue:1;		/* AVB-DMAC has NC queue */
 	unsigned magic_pkt:1;		/* E-MAC supports magic packet detection */
 	unsigned half_duplex:1;		/* E-MAC supports half duplex mode */
+	unsigned carrier_counters:1;	/* E-MAC has carrier counters */
 };
 
 struct ravb_private {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 42573eac82b9..c057de81ec58 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2075,6 +2075,18 @@ static struct net_device_stats *ravb_get_stats(struct net_device *ndev)
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
 	nstats->rx_packets = stats0->rx_packets;
 	nstats->tx_packets = stats0->tx_packets;
 	nstats->rx_bytes = stats0->rx_bytes;
@@ -2486,6 +2498,7 @@ static const struct ravb_hw_info gbeth_hw_info = {
 	.aligned_tx = 1,
 	.tx_counters = 1,
 	.half_duplex = 1,
+	.carrier_counters = 1,
 };
 
 static const struct of_device_id ravb_match_table[] = {
-- 
2.17.1

