Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFDAE3F0B86
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 21:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbhHRTI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 15:08:58 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:14414 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233727AbhHRTIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 15:08:45 -0400
X-IronPort-AV: E=Sophos;i="5.84,332,1620658800"; 
   d="scan'208";a="91033544"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 19 Aug 2021 04:08:10 +0900
Received: from localhost.localdomain (unknown [10.226.93.61])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 09B4140D5D97;
        Thu, 19 Aug 2021 04:08:06 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH net-next v3 1/9] ravb: Use unsigned int for num_tx_desc variable in struct ravb_private
Date:   Wed, 18 Aug 2021 20:07:52 +0100
Message-Id: <20210818190800.20191-2-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210818190800.20191-1-biju.das.jz@bp.renesas.com>
References: <20210818190800.20191-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The number of TX descriptors per packet is an unsigned value and
the variable for holding this information should be unsigned.

This patch replaces the data type of num_tx_desc variable in struct
ravb_private from 'int' to 'unsigned int'.
This patch also updates the data type of local variables to unsigned int,
where the local variables are evaluated using num_tx_desc.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
v3:- new patch
ref:- https://patchwork.kernel.org/project/linux-renesas-soc/patch/20210802102654.5996-2-biju.das.jz@bp.renesas.com/
---
 drivers/net/ethernet/renesas/ravb.h      |  2 +-
 drivers/net/ethernet/renesas/ravb_main.c | 28 ++++++++++++------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 80e62ca2e3d3..85ece16134c9 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1039,7 +1039,7 @@ struct ravb_private {
 	unsigned rxcidm:1;		/* RX Clock Internal Delay Mode */
 	unsigned txcidm:1;		/* TX Clock Internal Delay Mode */
 	unsigned rgmii_override:1;	/* Deprecated rgmii-*id behavior */
-	int num_tx_desc;		/* TX descriptors per packet */
+	unsigned int num_tx_desc;	/* TX descriptors per packet */
 };
 
 static inline u32 ravb_read(struct net_device *ndev, enum ravb_reg reg)
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 62b0605f02ff..94eb9136752d 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -177,10 +177,10 @@ static int ravb_tx_free(struct net_device *ndev, int q, bool free_txed_only)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 	struct net_device_stats *stats = &priv->stats[q];
-	int num_tx_desc = priv->num_tx_desc;
+	unsigned int num_tx_desc = priv->num_tx_desc;
 	struct ravb_tx_desc *desc;
+	unsigned int entry;
 	int free_num = 0;
-	int entry;
 	u32 size;
 
 	for (; priv->cur_tx[q] - priv->dirty_tx[q] > 0; priv->dirty_tx[q]++) {
@@ -220,9 +220,9 @@ static int ravb_tx_free(struct net_device *ndev, int q, bool free_txed_only)
 static void ravb_ring_free(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
-	int num_tx_desc = priv->num_tx_desc;
-	int ring_size;
-	int i;
+	unsigned int num_tx_desc = priv->num_tx_desc;
+	unsigned int ring_size;
+	unsigned int i;
 
 	if (priv->rx_ring[q]) {
 		for (i = 0; i < priv->num_rx_ring[q]; i++) {
@@ -275,15 +275,15 @@ static void ravb_ring_free(struct net_device *ndev, int q)
 static void ravb_ring_format(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
-	int num_tx_desc = priv->num_tx_desc;
+	unsigned int num_tx_desc = priv->num_tx_desc;
 	struct ravb_ex_rx_desc *rx_desc;
 	struct ravb_tx_desc *tx_desc;
 	struct ravb_desc *desc;
-	int rx_ring_size = sizeof(*rx_desc) * priv->num_rx_ring[q];
-	int tx_ring_size = sizeof(*tx_desc) * priv->num_tx_ring[q] *
-			   num_tx_desc;
+	unsigned int rx_ring_size = sizeof(*rx_desc) * priv->num_rx_ring[q];
+	unsigned int tx_ring_size = sizeof(*tx_desc) * priv->num_tx_ring[q] *
+				    num_tx_desc;
 	dma_addr_t dma_addr;
-	int i;
+	unsigned int i;
 
 	priv->cur_rx[q] = 0;
 	priv->cur_tx[q] = 0;
@@ -339,10 +339,10 @@ static void ravb_ring_format(struct net_device *ndev, int q)
 static int ravb_ring_init(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
-	int num_tx_desc = priv->num_tx_desc;
+	unsigned int num_tx_desc = priv->num_tx_desc;
+	unsigned int ring_size;
 	struct sk_buff *skb;
-	int ring_size;
-	int i;
+	unsigned int i;
 
 	/* Allocate RX and TX skb rings */
 	priv->rx_skb[q] = kcalloc(priv->num_rx_ring[q],
@@ -1488,7 +1488,7 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 static netdev_tx_t ravb_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
-	int num_tx_desc = priv->num_tx_desc;
+	unsigned int num_tx_desc = priv->num_tx_desc;
 	u16 q = skb_get_queue_mapping(skb);
 	struct ravb_tstamp_skb *ts_skb;
 	struct ravb_tx_desc *desc;
-- 
2.17.1

