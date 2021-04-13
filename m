Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1BFD35D618
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 05:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241484AbhDMDmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 23:42:11 -0400
Received: from inva020.nxp.com ([92.121.34.13]:33536 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237526AbhDMDmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 23:42:10 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DD8321A21D8;
        Tue, 13 Apr 2021 05:41:50 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 87F121A0DD8;
        Tue, 13 Apr 2021 05:41:47 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 06A86402CF;
        Tue, 13 Apr 2021 05:41:42 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [net-next] enetc: fix locking for one-step timestamping packet transfer
Date:   Tue, 13 Apr 2021 11:48:17 +0800
Message-Id: <20210413034817.8924-1-yangbo.lu@nxp.com>
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
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 4a0adb0b8bd7..65f1772c5740 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -301,6 +301,15 @@ static netdev_tx_t enetc_start_xmit(struct sk_buff *skb,
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
@@ -352,15 +361,6 @@ netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev)
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
 

base-commit: 8ef7adc6beb2ef0bce83513dc9e4505e7b21e8c2
-- 
2.25.1

