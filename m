Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6382E41F08F
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355102AbhJAPJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:09:01 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:8350 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1354730AbhJAPIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:08:46 -0400
X-IronPort-AV: E=Sophos;i="5.85,339,1624287600"; 
   d="scan'208";a="95671603"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 02 Oct 2021 00:07:01 +0900
Received: from localhost.localdomain (unknown [10.226.92.36])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 128BD4351834;
        Sat,  2 Oct 2021 00:06:57 +0900 (JST)
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
Subject: [PATCH 05/10] ravb: Initialize GbEthernet DMAC
Date:   Fri,  1 Oct 2021 16:06:31 +0100
Message-Id: <20211001150636.7500-6-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize GbEthernet DMAC found on RZ/G2L SoC.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
RFC->v1:
 * Removed RIC3 initialization from DMAC init, as it is 
   same as reset value.
 * moved stubs function to earlier patches.
 * renamed "rgeth" with "gbeth"
---
 drivers/net/ethernet/renesas/ravb.h      |  3 ++-
 drivers/net/ethernet/renesas/ravb_main.c | 30 +++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index f6398fdcead2..9cd3a15743b4 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -81,6 +81,7 @@ enum ravb_reg {
 	RQC3	= 0x00A0,
 	RQC4	= 0x00A4,
 	RPC	= 0x00B0,
+	RTC	= 0x00B4,	/* R-Car Gen3 and RZ/G2L only */
 	UFCW	= 0x00BC,
 	UFCS	= 0x00C0,
 	UFCV0	= 0x00C4,
@@ -193,7 +194,7 @@ enum ravb_reg {
 	GECMR	= 0x05b0,
 	MAHR	= 0x05c0,
 	MALR	= 0x05c8,
-	TROCR	= 0x0700,	/* R-Car Gen3 only */
+	TROCR	= 0x0700,	/* R-Car Gen3 and RZ/G2L only */
 	CEFCR	= 0x0740,
 	FRECR	= 0x0748,
 	TSFRCR	= 0x0750,
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index dc817b4d95a1..5790a9332e7b 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -489,7 +489,35 @@ static void ravb_emac_init(struct net_device *ndev)
 
 static int ravb_dmac_init_gbeth(struct net_device *ndev)
 {
-	/* Place holder */
+	int error;
+
+	error = ravb_ring_init(ndev, RAVB_BE);
+	if (error)
+		return error;
+
+	/* Descriptor format */
+	ravb_ring_format(ndev, RAVB_BE);
+
+	/* Set AVB RX */
+	ravb_write(ndev, 0x60000000, RCR);
+
+	/* Set Max Frame Length (RTC) */
+	ravb_write(ndev, 0x7ffc0000 | GBETH_RX_BUFF_MAX, RTC);
+
+	/* Set FIFO size */
+	ravb_write(ndev, 0x00222200, TGC);
+
+	ravb_write(ndev, 0, TCCR);
+
+	/* Frame receive */
+	ravb_write(ndev, RIC0_FRE0, RIC0);
+	/* Disable FIFO full warning */
+	ravb_write(ndev, 0x0, RIC1);
+	/* Receive FIFO full error, descriptor empty */
+	ravb_write(ndev, RIC2_QFE0 | RIC2_RFFE, RIC2);
+
+	ravb_write(ndev, TIC_FTE0, TIC);
+
 	return 0;
 }
 
-- 
2.17.1

