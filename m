Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4F93D711C
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 10:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbhG0IWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 04:22:03 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:5647 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235906AbhG0IWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 04:22:00 -0400
X-IronPort-AV: E=Sophos;i="5.84,272,1620658800"; 
   d="scan'208";a="88892218"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 27 Jul 2021 17:21:59 +0900
Received: from localhost.localdomain (unknown [10.166.14.185])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 54ACA400D4FF;
        Tue, 27 Jul 2021 17:21:59 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     sergei.shtylyov@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 2/2] sh_eth: Fix descriptor counters' conditions
Date:   Tue, 27 Jul 2021 17:21:47 +0900
Message-Id: <20210727082147.270734-3-yoshihiro.shimoda.uh@renesas.com>
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

So, for example, sh_eth_tx_free() could not free any descriptors
because the following condition was checked as a signed value,
and then "NETDEV WATCHDOG" happened:

    for (; mdp->cur_tx - mdp->dirty_tx > 0; mdp->dirty_tx++) {

To fix the issue, add get_num_desc() to calculate numbers of
remaining descriptors.

Fixes: 86a74ff21a7a ("net: sh_eth: add support for Renesas SuperH Ethernet")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/sh_eth.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 840478692a37..7c9445ad684b 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -1227,6 +1227,14 @@ static const struct mdiobb_ops bb_ops = {
 	.get_mdio_data = sh_get_mdio,
 };
 
+static u32 get_num_desc(u32 from, u32 subtract)
+{
+	if (from >= subtract)
+		return from - subtract;
+
+	return U32_MAX - subtract + 1 + from;
+}
+
 /* free Tx skb function */
 static int sh_eth_tx_free(struct net_device *ndev, bool sent_only)
 {
@@ -1236,7 +1244,7 @@ static int sh_eth_tx_free(struct net_device *ndev, bool sent_only)
 	int entry;
 	bool sent;
 
-	for (; mdp->cur_tx - mdp->dirty_tx > 0; mdp->dirty_tx++) {
+	for (; get_num_desc(mdp->cur_tx, mdp->dirty_tx) > 0; mdp->dirty_tx++) {
 		entry = mdp->dirty_tx % mdp->num_tx_ring;
 		txdesc = &mdp->tx_ring[entry];
 		sent = !(txdesc->status & cpu_to_le32(TD_TACT));
@@ -1587,7 +1595,7 @@ static int sh_eth_rx(struct net_device *ndev, u32 intr_status, int *quota)
 	struct sh_eth_rxdesc *rxdesc;
 
 	int entry = mdp->cur_rx % mdp->num_rx_ring;
-	int boguscnt = (mdp->dirty_rx + mdp->num_rx_ring) - mdp->cur_rx;
+	int boguscnt = get_num_desc(mdp->dirty_rx, mdp->cur_rx) + mdp->num_rx_ring;
 	int limit;
 	struct sk_buff *skb;
 	u32 desc_status;
@@ -1667,7 +1675,7 @@ static int sh_eth_rx(struct net_device *ndev, u32 intr_status, int *quota)
 	}
 
 	/* Refill the Rx ring buffers. */
-	for (; mdp->cur_rx - mdp->dirty_rx > 0; mdp->dirty_rx++) {
+	for (; get_num_desc(mdp->cur_rx, mdp->dirty_rx) > 0; mdp->dirty_rx++) {
 		entry = mdp->dirty_rx % mdp->num_rx_ring;
 		rxdesc = &mdp->rx_ring[entry];
 		/* The size of the buffer is 32 byte boundary. */
@@ -2499,7 +2507,7 @@ static netdev_tx_t sh_eth_start_xmit(struct sk_buff *skb,
 	unsigned long flags;
 
 	spin_lock_irqsave(&mdp->lock, flags);
-	if ((mdp->cur_tx - mdp->dirty_tx) >= (mdp->num_tx_ring - 4)) {
+	if (get_num_desc(mdp->cur_tx, mdp->dirty_tx) >= (mdp->num_tx_ring - 4)) {
 		if (!sh_eth_tx_free(ndev, true)) {
 			netif_warn(mdp, tx_queued, ndev, "TxFD exhausted.\n");
 			netif_stop_queue(ndev);
-- 
2.25.1

