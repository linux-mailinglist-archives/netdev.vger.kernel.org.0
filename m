Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCC7358158
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 13:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbhDHLHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 07:07:34 -0400
Received: from inva020.nxp.com ([92.121.34.13]:50300 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231222AbhDHLH3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 07:07:29 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 9FAAE1A44F5;
        Thu,  8 Apr 2021 13:07:17 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1C6791A44F2;
        Thu,  8 Apr 2021 13:07:14 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 9D3AE402D3;
        Thu,  8 Apr 2021 13:07:09 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [net-next, v2, 1/2] enetc: mark TX timestamp type per skb
Date:   Thu,  8 Apr 2021 19:13:49 +0800
Message-Id: <20210408111350.3817-2-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210408111350.3817-1-yangbo.lu@nxp.com>
References: <20210408111350.3817-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark TX timestamp type per skb on skb->cb[0], instead of
global variable for all skbs. This is a preparation for
one step timestamp support.

For one-step timestamping enablement, there will be both
one-step and two-step PTP messages to transfer. And a skb
queue is needed for one-step PTP messages making sure
start to send current message only after the last one
completed on hardware. (ENETC single-step register has to
be dynamically configured per message.) So, marking TX
timestamp type per skb is required.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Rebased.
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 10 ++++++----
 drivers/net/ethernet/freescale/enetc/enetc.h | 11 +++++++----
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 57049ae97201..61bd2981517c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -67,8 +67,7 @@ static void enetc_update_tx_ring_tail(struct enetc_bdr *tx_ring)
 	enetc_wr_reg_hot(tx_ring->tpir, tx_ring->next_to_use);
 }
 
-static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb,
-			      int active_offloads)
+static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb)
 {
 	struct enetc_tx_swbd *tx_swbd;
 	skb_frag_t *frag;
@@ -101,7 +100,7 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb,
 	count++;
 
 	do_vlan = skb_vlan_tag_present(skb);
-	do_tstamp = (active_offloads & ENETC_F_TX_TSTAMP) &&
+	do_tstamp = (skb->cb[0] & ENETC_F_TX_TSTAMP) &&
 		    (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP);
 	tx_swbd->do_tstamp = do_tstamp;
 	tx_swbd->check_wb = tx_swbd->do_tstamp;
@@ -221,6 +220,9 @@ netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev)
 	struct enetc_bdr *tx_ring;
 	int count;
 
+	/* cb[0] used for TX timestamp type */
+	skb->cb[0] = priv->active_offloads & ENETC_F_TX_TSTAMP_MASK;
+
 	tx_ring = priv->tx_ring[skb->queue_mapping];
 
 	if (unlikely(skb_shinfo(skb)->nr_frags > ENETC_MAX_SKB_FRAGS))
@@ -234,7 +236,7 @@ netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev)
 	}
 
 	enetc_lock_mdio();
-	count = enetc_map_tx_buffs(tx_ring, skb, priv->active_offloads);
+	count = enetc_map_tx_buffs(tx_ring, skb);
 	enetc_unlock_mdio();
 
 	if (unlikely(!count))
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 05474f46b0d9..96889529383e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -271,12 +271,15 @@ struct psfp_cap {
 	u32 max_psfp_meter;
 };
 
+#define ENETC_F_TX_TSTAMP_MASK	0xff
 /* TODO: more hardware offloads */
 enum enetc_active_offloads {
-	ENETC_F_RX_TSTAMP	= BIT(0),
-	ENETC_F_TX_TSTAMP	= BIT(1),
-	ENETC_F_QBV             = BIT(2),
-	ENETC_F_QCI		= BIT(3),
+	/* 8 bits reserved for TX timestamp types (hwtstamp_tx_types) */
+	ENETC_F_TX_TSTAMP	= BIT(0),
+
+	ENETC_F_RX_TSTAMP	= BIT(8),
+	ENETC_F_QBV		= BIT(9),
+	ENETC_F_QCI		= BIT(10),
 };
 
 /* interrupt coalescing modes */
-- 
2.25.1

