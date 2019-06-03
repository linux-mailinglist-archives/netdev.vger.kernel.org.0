Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64E2A33A6D
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfFCV5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:57:53 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:33352 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbfFCV5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 17:57:52 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x53LvpPa021882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 3 Jun 2019 15:57:51 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x53LvTMU008601
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 3 Jun 2019 15:57:35 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next 13/18] net: axienet: Fix race condition causing TX hang
Date:   Mon,  3 Jun 2019 15:57:12 -0600
Message-Id: <1559599037-8514-14-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559599037-8514-1-git-send-email-hancock@sedsystems.ca>
References: <1559599037-8514-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible that the interrupt handler fires and frees up space in
the TX ring in between checking for sufficient TX ring space and
stopping the TX queue in axienet_start_xmit. If this happens, the
queue wake from the interrupt handler will occur before the queue is
stopped, causing a lost wakeup and the adapter's transmit hanging.

To avoid this, after stopping the queue, check again whether there is
sufficient space in the TX ring. If so, wake up the queue again.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index e26b339..398e7e6 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -621,6 +621,10 @@ static void axienet_start_xmit_done(struct net_device *ndev)
 
 	ndev->stats.tx_packets += packets;
 	ndev->stats.tx_bytes += size;
+
+	/* Matches barrier in axienet_start_xmit */
+	smp_mb();
+
 	netif_wake_queue(ndev);
 }
 
@@ -676,9 +680,19 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 
 	if (axienet_check_tx_bd_space(lp, num_frag)) {
-		if (!netif_queue_stopped(ndev))
-			netif_stop_queue(ndev);
-		return NETDEV_TX_BUSY;
+		if (netif_queue_stopped(ndev))
+			return NETDEV_TX_BUSY;
+
+		netif_stop_queue(ndev);
+
+		/* Matches barrier in axienet_start_xmit_done */
+		smp_mb();
+
+		/* Space might have just been freed - check again */
+		if (axienet_check_tx_bd_space(lp, num_frag))
+			return NETDEV_TX_BUSY;
+
+		netif_wake_queue(ndev);
 	}
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-- 
1.8.3.1

