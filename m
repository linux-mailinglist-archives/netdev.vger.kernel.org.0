Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12DA3D2576
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbhGVNfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:35:13 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:54735 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232376AbhGVNeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 09:34:13 -0400
X-IronPort-AV: E=Sophos;i="5.84,261,1620658800"; 
   d="scan'208";a="88414784"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 22 Jul 2021 23:14:44 +0900
Received: from localhost.localdomain (unknown [10.226.92.164])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 2FD86401224B;
        Thu, 22 Jul 2021 23:14:41 +0900 (JST)
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
Subject: [PATCH net-next 13/18] ravb: Factorise ravb_rx function
Date:   Thu, 22 Jul 2021 15:13:46 +0100
Message-Id: <20210722141351.13668-14-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R-Car uses extended descriptor where as RZ/G2L uses normal
descriptor. Factorise ravb_rx function to support the later.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  1 +
 drivers/net/ethernet/renesas/ravb_main.c | 11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 4d5910dcda86..8a35b0ca1183 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -994,6 +994,7 @@ struct ravb_ops {
 	bool (*alloc_rx_desc)(struct net_device *ndev, int q);
 	void (*emac_init)(struct net_device *ndev);
 	void (*dmac_init)(struct net_device *ndev);
+	bool (*receive)(struct net_device *ndev, int *quota, int q);
 };
 
 struct ravb_drv_data {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index e200114376e4..a0f19c6f8833 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -607,7 +607,7 @@ static void ravb_rx_csum(struct sk_buff *skb)
 }
 
 /* Packet receive function for Ethernet AVB */
-static bool ravb_rx(struct net_device *ndev, int *quota, int q)
+static bool ravb_ex_rx(struct net_device *ndev, int *quota, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 	int entry = priv->cur_rx[q] % priv->num_rx_ring[q];
@@ -722,6 +722,14 @@ static bool ravb_rx(struct net_device *ndev, int *quota, int q)
 	return boguscnt <= 0;
 }
 
+static bool ravb_rx(struct net_device *ndev, int *quota, int q)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
+
+	return info->ravb_ops->receive(ndev, quota, q);
+}
+
 static void ravb_rcv_snd_disable(struct net_device *ndev)
 {
 	/* Disable TX and RX */
@@ -2036,6 +2044,7 @@ static const struct ravb_ops ravb_gen3_ops = {
 	.alloc_rx_desc = ravb_alloc_rx_desc,
 	.emac_init = ravb_emac_init_ex,
 	.dmac_init = ravb_dmac_init_ex,
+	.receive = ravb_ex_rx,
 };
 
 static const struct ravb_drv_data ravb_gen3_data = {
-- 
2.17.1

