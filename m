Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A74368F5A
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 11:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241786AbhDWJ2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 05:28:25 -0400
Received: from inva021.nxp.com ([92.121.34.21]:51160 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241759AbhDWJ2Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 05:28:25 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 39816201F9F;
        Fri, 23 Apr 2021 11:27:48 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id DBDFA200E40;
        Fri, 23 Apr 2021 11:27:44 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 655B1402B7;
        Fri, 23 Apr 2021 11:27:40 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [net-next, v2] enetc: fix locking for one-step timestamping packet transfer
Date:   Fri, 23 Apr 2021 17:33:55 +0800
Message-Id: <20210423093355.8665-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous patch to support PTP Sync packet one-step timestamping
described one-step timestamping packet handling logic as below in
commit message:

- Trasmit packet immediately if no other one in transfer, or queue to
  skb queue if there is already one in transfer.
  The test_and_set_bit_lock() is used here to lock and check state.
- Start a work when complete transfer on hardware, to release the bit
  lock and to send one skb in skb queue if has.

There was not problem of the description, but there was a mistake in
implementation. The locking/test_and_set_bit_lock() should be put in
enetc_start_xmit() which may be called by worker, rather than in
enetc_xmit(). Otherwise, the worker calling enetc_start_xmit() after
bit lock released is not able to lock again for transfer.

Fixes: 7294380c5211 ("enetc: support PTP Sync packet one-step timestamping")
Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
Changes for v2:
	- None. Just resent.
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 4f23829e7317..3ca93adb9662 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -321,6 +321,15 @@ static netdev_tx_t enetc_start_xmit(struct sk_buff *skb,
 	struct enetc_bdr *tx_ring;
 	int count;
 
+	/* Queue one-step Sync packet if already locked */
+	if (skb->cb[0] & ENETC_F_TX_ONESTEP_SYNC_TSTAMP) {
+		if (test_and_set_bit_lock(ENETC_TX_ONESTEP_TSTAMP_IN_PROGRESS,
+					  &priv->flags)) {
+			skb_queue_tail(&priv->tx_skbs, skb);
+			return NETDEV_TX_OK;
+		}
+	}
+
 	tx_ring = priv->tx_ring[skb->queue_mapping];
 
 	if (unlikely(skb_shinfo(skb)->nr_frags > ENETC_MAX_SKB_FRAGS))
@@ -372,15 +381,6 @@ netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev)
 			skb->cb[0] = ENETC_F_TX_TSTAMP;
 	}
 
-	/* Queue one-step Sync packet if already locked */
-	if (skb->cb[0] & ENETC_F_TX_ONESTEP_SYNC_TSTAMP) {
-		if (test_and_set_bit_lock(ENETC_TX_ONESTEP_TSTAMP_IN_PROGRESS,
-					  &priv->flags)) {
-			skb_queue_tail(&priv->tx_skbs, skb);
-			return NETDEV_TX_OK;
-		}
-	}
-
 	return enetc_start_xmit(skb, ndev);
 }
 

base-commit: cad4162a90aeff737a16c0286987f51e927f003a
-- 
2.25.1

