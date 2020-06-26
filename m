Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5281120B5BC
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 18:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgFZQRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 12:17:32 -0400
Received: from inva021.nxp.com ([92.121.34.21]:52714 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgFZQRb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 12:17:31 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3BA36200513;
        Fri, 26 Jun 2020 18:17:30 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 2CC4820050A;
        Fri, 26 Jun 2020 18:17:30 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 07B4020328;
        Fri, 26 Jun 2020 18:17:29 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net] enetc: Fix tx rings bitmap iteration range, irq handling
Date:   Fri, 26 Jun 2020 19:17:29 +0300
Message-Id: <1593188249-22686-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rings bitmap of an interrupt vector encodes
which of the device's rings were assigned to that
interrupt vector.
Hence the iteration range of the tx rings bitmap
(for_each_set_bit()) should be the total number of
Tx rings of that netdevice instead of the number of
rings assigned to the interrupt vector.
Since there are 2 cores, and one interrupt vector for
each core, the number of rings asigned to an interrupt
vector is half the number of available rings.
The impact of this error is that the upper half of the
tx rings could still generate interrupts during napi
polling.

Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 96831f4..22105d0 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -266,7 +266,7 @@ static irqreturn_t enetc_msix(int irq, void *data)
 	/* disable interrupts */
 	enetc_wr_reg(v->rbier, 0);
 
-	for_each_set_bit(i, &v->tx_rings_map, v->count_tx_rings)
+	for_each_set_bit(i, &v->tx_rings_map, ENETC_MAX_NUM_TXQS)
 		enetc_wr_reg(v->tbier_base + ENETC_BDR_OFF(i), 0);
 
 	napi_schedule_irqoff(&v->napi);
@@ -302,7 +302,7 @@ static int enetc_poll(struct napi_struct *napi, int budget)
 	/* enable interrupts */
 	enetc_wr_reg(v->rbier, ENETC_RBIER_RXTIE);
 
-	for_each_set_bit(i, &v->tx_rings_map, v->count_tx_rings)
+	for_each_set_bit(i, &v->tx_rings_map, ENETC_MAX_NUM_TXQS)
 		enetc_wr_reg(v->tbier_base + ENETC_BDR_OFF(i),
 			     ENETC_TBIER_TXTIE);
 
-- 
2.7.4

