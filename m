Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6735320722D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 13:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390671AbgFXLe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 07:34:58 -0400
Received: from inva020.nxp.com ([92.121.34.13]:48488 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388951AbgFXLex (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 07:34:53 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A42671A020F;
        Wed, 24 Jun 2020 13:34:51 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 981F21A01F2;
        Wed, 24 Jun 2020 13:34:51 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 606042047A;
        Wed, 24 Jun 2020 13:34:51 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/5] dpaa2-eth: check the result of skb_to_sgvec()
Date:   Wed, 24 Jun 2020 14:34:18 +0300
Message-Id: <20200624113421.17360-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200624113421.17360-1-ioana.ciornei@nxp.com>
References: <20200624113421.17360-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before passing the result of skb_to_sgvec() to dma_map_sg() check if any
error was returned.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index f150cd454fa4..db27f959d409 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -611,6 +611,10 @@ static int build_sg_fd(struct dpaa2_eth_priv *priv,
 
 	sg_init_table(scl, nr_frags + 1);
 	num_sg = skb_to_sgvec(skb, scl, 0, skb->len);
+	if (unlikely(num_sg < 0)) {
+		err = -ENOMEM;
+		goto dma_map_sg_failed;
+	}
 	num_dma_bufs = dma_map_sg(dev, scl, num_sg, DMA_BIDIRECTIONAL);
 	if (unlikely(!num_dma_bufs)) {
 		err = -ENOMEM;
-- 
2.25.1

