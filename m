Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA7D3D2573
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhGVNfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:35:00 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:41724 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232398AbhGVNeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 09:34:17 -0400
X-IronPort-AV: E=Sophos;i="5.84,261,1620658800"; 
   d="scan'208";a="88414796"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 22 Jul 2021 23:14:51 +0900
Received: from localhost.localdomain (unknown [10.226.92.164])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 81B1E401224C;
        Thu, 22 Jul 2021 23:14:48 +0900 (JST)
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
Subject: [PATCH net-next 15/18] ravb: Factorise ravb_set_features
Date:   Thu, 22 Jul 2021 15:13:48 +0100
Message-Id: <20210722141351.13668-16-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RZ/G2L supports HW checksum. Factorise ravb_set_features
to support this feature.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  1 +
 drivers/net/ethernet/renesas/ravb_main.c | 14 ++++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 4725be4e85d0..f1de095f21d9 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -996,6 +996,7 @@ struct ravb_ops {
 	void (*dmac_init)(struct net_device *ndev);
 	bool (*receive)(struct net_device *ndev, int *quota, int q);
 	void (*set_rate)(struct net_device *ndev);
+	int (*set_features)(struct net_device *ndev, netdev_features_t features);
 };
 
 struct ravb_drv_data {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 9d5ccd8f9bb1..5a375ac962a0 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1966,8 +1966,8 @@ static void ravb_set_rx_csum(struct net_device *ndev, bool enable)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static int ravb_set_features(struct net_device *ndev,
-			     netdev_features_t features)
+static int ravb_set_features_rx_csum(struct net_device *ndev,
+				     netdev_features_t features)
 {
 	netdev_features_t changed = ndev->features ^ features;
 
@@ -1979,6 +1979,15 @@ static int ravb_set_features(struct net_device *ndev,
 	return 0;
 }
 
+static int ravb_set_features(struct net_device *ndev,
+			     netdev_features_t features)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
+
+	return info->ravb_ops->set_features(ndev, features);
+}
+
 static const struct net_device_ops ravb_netdev_ops = {
 	.ndo_open		= ravb_open,
 	.ndo_stop		= ravb_close,
@@ -2047,6 +2056,7 @@ static const struct ravb_ops ravb_gen3_ops = {
 	.dmac_init = ravb_dmac_init_ex,
 	.receive = ravb_ex_rx,
 	.set_rate = ravb_set_rate,
+	.set_features = ravb_set_features_rx_csum,
 };
 
 static const struct ravb_drv_data ravb_gen3_data = {
-- 
2.17.1

