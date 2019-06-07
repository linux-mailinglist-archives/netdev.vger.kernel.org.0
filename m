Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFDA39573
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 21:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbfFGTVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 15:21:13 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:51145 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730038AbfFGTVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 15:21:06 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hZKQ8-0004YF-5o; Fri, 07 Jun 2019 21:21:00 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     tglx@linutronix.de, "David S. Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: [PATCH v2 net-next 4/7] dpaa2-eth: Use napi_alloc_frag()
Date:   Fri,  7 Jun 2019 21:20:37 +0200
Message-Id: <20190607192040.19367-5-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190607192040.19367-1-bigeasy@linutronix.de>
References: <20190607192040.19367-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver is using netdev_alloc_frag() for allocation in the
->ndo_start_xmit() path. That one is always invoked in a BH disabled
region so we could also use napi_alloc_frag().

Use napi_alloc_frag() for skb allocation.

Cc: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Acked-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index bcd3ceb5f9dc4..becce4e89ea3b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -555,7 +555,7 @@ static int build_sg_fd(struct dpaa2_eth_priv *priv,
 	/* Prepare the HW SGT structure */
 	sgt_buf_size = priv->tx_data_offset +
 		       sizeof(struct dpaa2_sg_entry) *  num_dma_bufs;
-	sgt_buf = netdev_alloc_frag(sgt_buf_size + DPAA2_ETH_TX_BUF_ALIGN);
+	sgt_buf = napi_alloc_frag(sgt_buf_size + DPAA2_ETH_TX_BUF_ALIGN);
 	if (unlikely(!sgt_buf)) {
 		err = -ENOMEM;
 		goto sgt_buf_alloc_failed;
-- 
2.20.1

