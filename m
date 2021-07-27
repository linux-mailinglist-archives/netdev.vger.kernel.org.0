Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43AE3D7119
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 10:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbhG0IWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 04:22:01 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:15065 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235629AbhG0IV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 04:21:59 -0400
X-IronPort-AV: E=Sophos;i="5.84,272,1620658800"; 
   d="scan'208";a="88851480"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 27 Jul 2021 17:21:59 +0900
Received: from localhost.localdomain (unknown [10.166.14.185])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 44F30400F7B9;
        Tue, 27 Jul 2021 17:21:59 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     sergei.shtylyov@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 1/2] ravb: Fix descriptor counters' conditions
Date:   Tue, 27 Jul 2021 17:21:46 +0900
Message-Id: <20210727082147.270734-2-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210727082147.270734-1-yoshihiro.shimoda.uh@renesas.com>
References: <20210727082147.270734-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The descriptor counters ({cur,dirty}_[rt]x) acts as free counters
so that conditions are possible to be incorrect when a left value
was overflowed.

So, for example, ravb_tx_free() could not free any descriptors
because the following condition was checked as a signed value,
and then "NETDEV WATCHDOG" happened:

    for (; priv->cur_tx[q] - priv->dirty_tx[q] > 0; priv->dirty_tx[q]++) {

To fix the issue, add get_num_desc() to calculate numbers of
remaining descriptors.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/ravb_main.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 805397088850..70fbac572036 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -172,6 +172,14 @@ static const struct mdiobb_ops bb_ops = {
 	.get_mdio_data = ravb_get_mdio_data,
 };
 
+static u32 get_num_desc(u32 from, u32 subtract)
+{
+	if (from >= subtract)
+		return from - subtract;
+
+	return U32_MAX - subtract + 1 + from;
+}
+
 /* Free TX skb function for AVB-IP */
 static int ravb_tx_free(struct net_device *ndev, int q, bool free_txed_only)
 {
@@ -183,7 +191,7 @@ static int ravb_tx_free(struct net_device *ndev, int q, bool free_txed_only)
 	int entry;
 	u32 size;
 
-	for (; priv->cur_tx[q] - priv->dirty_tx[q] > 0; priv->dirty_tx[q]++) {
+	for (; get_num_desc(priv->cur_tx[q], priv->dirty_tx[q]) > 0; priv->dirty_tx[q]++) {
 		bool txed;
 
 		entry = priv->dirty_tx[q] % (priv->num_tx_ring[q] *
@@ -536,8 +544,8 @@ static bool ravb_rx(struct net_device *ndev, int *quota, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 	int entry = priv->cur_rx[q] % priv->num_rx_ring[q];
-	int boguscnt = (priv->dirty_rx[q] + priv->num_rx_ring[q]) -
-			priv->cur_rx[q];
+	int boguscnt = get_num_desc(priv->dirty_rx[q], priv->cur_rx[q]) +
+		       priv->num_rx_ring[q];
 	struct net_device_stats *stats = &priv->stats[q];
 	struct ravb_ex_rx_desc *desc;
 	struct sk_buff *skb;
@@ -613,7 +621,7 @@ static bool ravb_rx(struct net_device *ndev, int *quota, int q)
 	}
 
 	/* Refill the RX ring buffers. */
-	for (; priv->cur_rx[q] - priv->dirty_rx[q] > 0; priv->dirty_rx[q]++) {
+	for (; get_num_desc(priv->cur_rx[q], priv->dirty_rx[q]) > 0; priv->dirty_rx[q]++) {
 		entry = priv->dirty_rx[q] % priv->num_rx_ring[q];
 		desc = &priv->rx_ring[q][entry];
 		desc->ds_cc = cpu_to_le16(RX_BUF_SZ);
@@ -1499,8 +1507,8 @@ static netdev_tx_t ravb_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	u32 len;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (priv->cur_tx[q] - priv->dirty_tx[q] > (priv->num_tx_ring[q] - 1) *
-	    num_tx_desc) {
+	if (get_num_desc(priv->cur_tx[q], priv->dirty_tx[q]) >
+	    (priv->num_tx_ring[q] - 1) * num_tx_desc) {
 		netif_err(priv, tx_queued, ndev,
 			  "still transmitting with the full ring!\n");
 		netif_stop_subqueue(ndev, q);
@@ -1598,7 +1606,7 @@ static netdev_tx_t ravb_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	ravb_modify(ndev, TCCR, TCCR_TSRQ0 << q, TCCR_TSRQ0 << q);
 
 	priv->cur_tx[q] += num_tx_desc;
-	if (priv->cur_tx[q] - priv->dirty_tx[q] >
+	if (get_num_desc(priv->cur_tx[q], priv->dirty_tx[q]) >
 	    (priv->num_tx_ring[q] - 1) * num_tx_desc &&
 	    !ravb_tx_free(ndev, q, true))
 		netif_stop_subqueue(ndev, q);
-- 
2.25.1

