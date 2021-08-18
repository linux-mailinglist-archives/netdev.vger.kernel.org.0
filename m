Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8403F0B90
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 21:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbhHRTJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 15:09:20 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:14414 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233350AbhHRTI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 15:08:58 -0400
X-IronPort-AV: E=Sophos;i="5.84,332,1620658800"; 
   d="scan'208";a="91033563"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 19 Aug 2021 04:08:22 +0900
Received: from localhost.localdomain (unknown [10.226.93.61])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 4437040D5D67;
        Thu, 19 Aug 2021 04:08:19 +0900 (JST)
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
Subject: [PATCH net-next v3 4/9] ravb: Add max_rx_len to struct ravb_hw_info
Date:   Wed, 18 Aug 2021 20:07:55 +0100
Message-Id: <20210818190800.20191-5-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210818190800.20191-1-biju.das.jz@bp.renesas.com>
References: <20210818190800.20191-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The maximum descriptor size that can be specified on the reception side for
R-Car is 2048 bytes, whereas for RZ/G2L it is 8096.

Add the max_rx_len variable to struct ravb_hw_info for allocating different
RX skb buffer sizes for R-Car and RZ/G2L using the netdev_alloc_skb
function.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
v3:
 * Retained Rb tag from Andrew, since the change is just renaming
   the variable from skb_sz to max_rx_len.
v2:
 * Incorporated Andrew and Sergei's review comments for making it smaller patch
   and provided detailed description.
---
 drivers/net/ethernet/renesas/ravb.h      |  1 +
 drivers/net/ethernet/renesas/ravb_main.c | 10 ++++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 4f71e5699ca1..976242ed6f7a 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -990,6 +990,7 @@ enum ravb_chip_id {
 
 struct ravb_hw_info {
 	enum ravb_chip_id chip_id;
+	size_t max_rx_len;
 	unsigned aligned_tx: 1;
 };
 
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index dbccf2cd89b2..d9bb5a261d40 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -339,6 +339,7 @@ static void ravb_ring_format(struct net_device *ndev, int q)
 static int ravb_ring_init(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	unsigned int num_tx_desc = priv->num_tx_desc;
 	unsigned int ring_size;
 	struct sk_buff *skb;
@@ -353,7 +354,7 @@ static int ravb_ring_init(struct net_device *ndev, int q)
 		goto error;
 
 	for (i = 0; i < priv->num_rx_ring[q]; i++) {
-		skb = netdev_alloc_skb(ndev, RX_BUF_SZ + RAVB_ALIGN - 1);
+		skb = netdev_alloc_skb(ndev, info->max_rx_len);
 		if (!skb)
 			goto error;
 		ravb_set_buffer_align(skb);
@@ -535,6 +536,7 @@ static void ravb_rx_csum(struct sk_buff *skb)
 static bool ravb_rx(struct net_device *ndev, int *quota, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	int entry = priv->cur_rx[q] % priv->num_rx_ring[q];
 	int boguscnt = (priv->dirty_rx[q] + priv->num_rx_ring[q]) -
 			priv->cur_rx[q];
@@ -619,9 +621,7 @@ static bool ravb_rx(struct net_device *ndev, int *quota, int q)
 		desc->ds_cc = cpu_to_le16(RX_BUF_SZ);
 
 		if (!priv->rx_skb[q][entry]) {
-			skb = netdev_alloc_skb(ndev,
-					       RX_BUF_SZ +
-					       RAVB_ALIGN - 1);
+			skb = netdev_alloc_skb(ndev, info->max_rx_len);
 			if (!skb)
 				break;	/* Better luck next round. */
 			ravb_set_buffer_align(skb);
@@ -1926,10 +1926,12 @@ static int ravb_mdio_release(struct ravb_private *priv)
 
 static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.chip_id = RCAR_GEN3,
+	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
 };
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.chip_id = RCAR_GEN2,
+	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
 	.aligned_tx = 1,
 };
 
-- 
2.17.1

