Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE6A41F095
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354967AbhJAPJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:09:07 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:56196 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1354973AbhJAPI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:08:57 -0400
X-IronPort-AV: E=Sophos;i="5.85,339,1624287600"; 
   d="scan'208";a="95671635"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 02 Oct 2021 00:07:12 +0900
Received: from localhost.localdomain (unknown [10.226.92.36])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id E93F643DDFC6;
        Sat,  2 Oct 2021 00:07:08 +0900 (JST)
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
Subject: [PATCH 08/10] ravb: Add magic_pkt to struct ravb_hw_info
Date:   Fri,  1 Oct 2021 16:06:34 +0100
Message-Id: <20211001150636.7500-9-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

E-MAC on R-Car supports magic packet detection, whereas RZ/G2L
does not support this feature. Add magic_pkt to struct ravb_hw_info
and enable this feature only for R-Car.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
RFC->v1:
 * Removed the feature checking from interrupt handler.
---
 drivers/net/ethernet/renesas/ravb.h      | 1 +
 drivers/net/ethernet/renesas/ravb_main.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index c586070193ef..f0d9b7bc8c20 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1007,6 +1007,7 @@ struct ravb_hw_info {
 	unsigned gptp:1;		/* AVB-DMAC has gPTP support */
 	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
 	unsigned nc_queue:1;		/* AVB-DMAC has NC queue */
+	unsigned magic_pkt:1;		/* E-MAC supports magic packet detection */
 };
 
 struct ravb_private {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 4784832bd93c..6fb11d4cfc57 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1436,8 +1436,9 @@ static void ravb_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 static int ravb_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 
-	if (wol->wolopts & ~WAKE_MAGIC)
+	if (!info->magic_pkt || (wol->wolopts & ~WAKE_MAGIC))
 		return -EOPNOTSUPP;
 
 	priv->wol_enabled = !!(wol->wolopts & WAKE_MAGIC);
@@ -2136,6 +2137,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.multi_irqs = 1,
 	.ccc_gac = 1,
 	.nc_queue = 1,
+	.magic_pkt = 1,
 };
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
@@ -2157,6 +2159,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.aligned_tx = 1,
 	.gptp = 1,
 	.nc_queue = 1,
+	.magic_pkt = 1,
 };
 
 static const struct ravb_hw_info gbeth_hw_info = {
-- 
2.17.1

