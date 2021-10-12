Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F051A42A9A3
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhJLQjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:39:11 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:11336 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230420AbhJLQjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 12:39:11 -0400
X-IronPort-AV: E=Sophos;i="5.85,368,1624287600"; 
   d="scan'208";a="96771855"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 13 Oct 2021 01:37:08 +0900
Received: from localhost.localdomain (unknown [10.226.92.46])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 638E740AA82C;
        Wed, 13 Oct 2021 01:37:05 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
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
Subject: [PATCH net-next v3 13/14] ravb: Update ravb_emac_init_gbeth()
Date:   Tue, 12 Oct 2021 17:36:12 +0100
Message-Id: <20211012163613.30030-14-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
References: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables Receive/Transmit port of TOE and removes
the setting of promiscuous bit from EMAC configuration mode register.

This patch also update EMAC configuration mode comment from
"PAUSE prohibition" to "EMAC Mode: PAUSE prohibition; Duplex; TX;
RX; CRC Pass Through".

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
v2->v3:
 * Enabled TPE/RPE of TOE, as disabling causes loopback test to fail
 * Documented CSR0 register bits
 * Removed PRM setting from EMAC configuration mode
 * Updated EMAC configuration mode.
v1->v2:
 * No change
V1:
 * New patch.
---
 drivers/net/ethernet/renesas/ravb.h      | 6 ++++++
 drivers/net/ethernet/renesas/ravb_main.c | 5 +++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 69a771526776..08062d73df10 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -204,6 +204,7 @@ enum ravb_reg {
 	TLFRCR	= 0x0758,
 	RFCR	= 0x0760,
 	MAFCR	= 0x0778,
+	CSR0    = 0x0800,	/* RZ/G2L only */
 };
 
 
@@ -964,6 +965,11 @@ enum CXR31_BIT {
 	CXR31_SEL_LINK1	= 0x00000008,
 };
 
+enum CSR0_BIT {
+	CSR0_TPE	= 0x00000010,
+	CSR0_RPE	= 0x00000020,
+};
+
 #define DBAT_ENTRY_NUM	22
 #define RX_QUEUE_OFFSET	4
 #define NUM_RX_QUEUE	2
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 21fb83f209d5..f3f676e433d1 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -519,10 +519,10 @@ static void ravb_emac_init_gbeth(struct net_device *ndev)
 	/* Receive frame limit set register */
 	ravb_write(ndev, GBETH_RX_BUFF_MAX + ETH_FCS_LEN, RFLR);
 
-	/* PAUSE prohibition */
+	/* EMAC Mode: PAUSE prohibition; Duplex; TX; RX; CRC Pass Through */
 	ravb_write(ndev, ECMR_ZPF | ((priv->duplex > 0) ? ECMR_DM : 0) |
 			 ECMR_TE | ECMR_RE | ECMR_RCPT |
-			 ECMR_TXF | ECMR_RXF | ECMR_PRM, ECMR);
+			 ECMR_TXF | ECMR_RXF, ECMR);
 
 	ravb_set_rate_gbeth(ndev);
 
@@ -534,6 +534,7 @@ static void ravb_emac_init_gbeth(struct net_device *ndev)
 
 	/* E-MAC status register clear */
 	ravb_write(ndev, ECSR_ICD | ECSR_LCHNG | ECSR_PFRI, ECSR);
+	ravb_write(ndev, CSR0_TPE | CSR0_RPE, CSR0);
 
 	/* E-MAC interrupt enable register */
 	ravb_write(ndev, ECSIPR_ICDIP, ECSIPR);
-- 
2.17.1

