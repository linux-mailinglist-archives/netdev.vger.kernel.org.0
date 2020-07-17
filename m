Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7B1223FB1
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 17:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgGQPhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 11:37:08 -0400
Received: from inva020.nxp.com ([92.121.34.13]:60712 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727010AbgGQPhH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 11:37:07 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id ACCB11A0ADA;
        Fri, 17 Jul 2020 17:37:05 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A014A1A036A;
        Fri, 17 Jul 2020 17:37:05 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 7311920466;
        Fri, 17 Jul 2020 17:37:05 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 3/6] enetc: Fix interrupt coalescing register naming
Date:   Fri, 17 Jul 2020 18:37:01 +0300
Message-Id: <1595000224-6883-4-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595000224-6883-1-git-send-email-claudiu.manoil@nxp.com>
References: <1595000224-6883-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Interrupt coalescing registers naming in the current revision
of the Ref Man (RM) is ICR, deprecating the ICIR name used
in earlier (draft) versions of the RM.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
v2: none

 drivers/net/ethernet/freescale/enetc/enetc.c         | 4 ++--
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 2 +-
 drivers/net/ethernet/freescale/enetc/enetc_hw.h      | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 51a1c97aedac..be594c7af538 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1140,7 +1140,7 @@ static void enetc_setup_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
 	tx_ring->next_to_clean = enetc_txbdr_rd(hw, idx, ENETC_TBCIR);
 
 	/* enable Tx ints by setting pkt thr to 1 */
-	enetc_txbdr_wr(hw, idx, ENETC_TBICIR0, ENETC_TBICIR0_ICEN | 0x1);
+	enetc_txbdr_wr(hw, idx, ENETC_TBICR0, ENETC_TBICR0_ICEN | 0x1);
 
 	tbmr = ENETC_TBMR_EN;
 	if (tx_ring->ndev->features & NETIF_F_HW_VLAN_CTAG_TX)
@@ -1174,7 +1174,7 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 	enetc_rxbdr_wr(hw, idx, ENETC_RBPIR, 0);
 
 	/* enable Rx ints by setting pkt thr to 1 */
-	enetc_rxbdr_wr(hw, idx, ENETC_RBICIR0, ENETC_RBICIR0_ICEN | 0x1);
+	enetc_rxbdr_wr(hw, idx, ENETC_RBICR0, ENETC_RBICR0_ICEN | 0x1);
 
 	rbmr = ENETC_RBMR_EN;
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 34bd1f3fb415..8aeaa3de0012 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -19,7 +19,7 @@ static const u32 enetc_txbdr_regs[] = {
 
 static const u32 enetc_rxbdr_regs[] = {
 	ENETC_RBMR, ENETC_RBSR, ENETC_RBBSR, ENETC_RBCIR, ENETC_RBBAR0,
-	ENETC_RBBAR1, ENETC_RBPIR, ENETC_RBLENR, ENETC_RBICIR0, ENETC_RBIER
+	ENETC_RBBAR1, ENETC_RBPIR, ENETC_RBLENR, ENETC_RBICR0, ENETC_RBIER
 };
 
 static const u32 enetc_port_regs[] = {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index fc357bc56835..05bb4c525897 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -121,8 +121,8 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_RBIER	0xa0
 #define ENETC_RBIER_RXTIE	BIT(0)
 #define ENETC_RBIDR	0xa4
-#define ENETC_RBICIR0	0xa8
-#define ENETC_RBICIR0_ICEN	BIT(31)
+#define ENETC_RBICR0	0xa8
+#define ENETC_RBICR0_ICEN	BIT(31)
 
 /* TX BDR reg offsets */
 #define ENETC_TBMR	0
@@ -141,8 +141,8 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_TBIER	0xa0
 #define ENETC_TBIER_TXTIE	BIT(0)
 #define ENETC_TBIDR	0xa4
-#define ENETC_TBICIR0	0xa8
-#define ENETC_TBICIR0_ICEN	BIT(31)
+#define ENETC_TBICR0	0xa8
+#define ENETC_TBICR0_ICEN	BIT(31)
 
 #define ENETC_RTBLENR_LEN(n)	((n) & ~0x7)
 
-- 
2.17.1

