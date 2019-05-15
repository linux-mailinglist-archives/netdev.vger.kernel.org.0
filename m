Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 595711F82E
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 18:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfEOQJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 12:09:01 -0400
Received: from inva020.nxp.com ([92.121.34.13]:41310 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726511AbfEOQJB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 12:09:01 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4ECA71A00E6;
        Wed, 15 May 2019 18:08:59 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 42C6A1A002F;
        Wed, 15 May 2019 18:08:59 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 14395205F4;
        Wed, 15 May 2019 18:08:59 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net 1/3] enetc: Fix NULL dma address unmap for Tx BD extensions
Date:   Wed, 15 May 2019 19:08:56 +0300
Message-Id: <1557936538-23691-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the unlikely case of TxBD extensions (i.e. ptp)
the driver tries to unmap the tx_swbd corresponding
to the extension, which is bogus as it has no buffer
attached.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 5bb9eb35d76d..491475d87736 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -313,7 +313,9 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 	while (bds_to_clean && tx_frm_cnt < ENETC_DEFAULT_TX_WORK) {
 		bool is_eof = !!tx_swbd->skb;
 
-		enetc_unmap_tx_buff(tx_ring, tx_swbd);
+		if (likely(tx_swbd->dma))
+			enetc_unmap_tx_buff(tx_ring, tx_swbd);
+
 		if (is_eof) {
 			napi_consume_skb(tx_swbd->skb, napi_budget);
 			tx_swbd->skb = NULL;
-- 
2.17.1

