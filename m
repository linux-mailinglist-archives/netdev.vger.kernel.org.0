Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F213D2578
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbhGVNfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:35:15 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:31675 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232383AbhGVNeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 09:34:13 -0400
X-IronPort-AV: E=Sophos;i="5.84,261,1620658800"; 
   d="scan'208";a="88414788"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 22 Jul 2021 23:14:48 +0900
Received: from localhost.localdomain (unknown [10.226.92.164])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id D5067401224A;
        Thu, 22 Jul 2021 23:14:44 +0900 (JST)
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
Subject: [PATCH net-next 14/18] ravb: Factorise ravb_adjust_link function
Date:   Thu, 22 Jul 2021 15:13:47 +0100
Message-Id: <20210722141351.13668-15-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R-Car supports 100 and 1000 Mbs transfer speed where as RZ/G2L
in addition support 10Mbps. Factorise ravb_adjust_link function
in order to support 10Mbps speed.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      | 1 +
 drivers/net/ethernet/renesas/ravb_main.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 8a35b0ca1183..4725be4e85d0 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -995,6 +995,7 @@ struct ravb_ops {
 	void (*emac_init)(struct net_device *ndev);
 	void (*dmac_init)(struct net_device *ndev);
 	bool (*receive)(struct net_device *ndev, int *quota, int q);
+	void (*set_rate)(struct net_device *ndev);
 };
 
 struct ravb_drv_data {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index a0f19c6f8833..9d5ccd8f9bb1 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1049,6 +1049,7 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 static void ravb_adjust_link(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 	struct phy_device *phydev = ndev->phydev;
 	bool new_state = false;
 	unsigned long flags;
@@ -1063,7 +1064,7 @@ static void ravb_adjust_link(struct net_device *ndev)
 		if (phydev->speed != priv->speed) {
 			new_state = true;
 			priv->speed = phydev->speed;
-			ravb_set_rate(ndev);
+			info->ravb_ops->set_rate(ndev);
 		}
 		if (!priv->link) {
 			ravb_modify(ndev, ECMR, ECMR_TXF, 0);
@@ -2045,6 +2046,7 @@ static const struct ravb_ops ravb_gen3_ops = {
 	.emac_init = ravb_emac_init_ex,
 	.dmac_init = ravb_dmac_init_ex,
 	.receive = ravb_ex_rx,
+	.set_rate = ravb_set_rate,
 };
 
 static const struct ravb_drv_data ravb_gen3_data = {
-- 
2.17.1

