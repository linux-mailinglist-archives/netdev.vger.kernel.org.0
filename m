Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4EDF6BA8A7
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbjCOHE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbjCOHEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:04:43 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C14F13C33;
        Wed, 15 Mar 2023 00:04:41 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.98,262,1673881200"; 
   d="scan'208";a="156005160"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 15 Mar 2023 16:04:39 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 9437A418A02B;
        Wed, 15 Mar 2023 16:04:39 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Phong Hoang <phong.hoang.wz@renesas.com>
Subject: [PATCH net 2/2] net: renesas: rswitch: Fix GWTSDIE register handling
Date:   Wed, 15 Mar 2023 16:04:24 +0900
Message-Id: <20230315070424.1088877-3-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230315070424.1088877-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230315070424.1088877-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the GWCA has the TX timestamp feature, this driver
should not disable it if one of ports is opened. So, fix it.

Reported-by: Phong Hoang <phong.hoang.wz@renesas.com>
Fixes: 33f5d733b589 ("net: renesas: rswitch: Improve TX timestamp accuracy")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 9 +++++++--
 drivers/net/ethernet/renesas/rswitch.h | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 46d8d9c8fc19..c4f93d24c6a4 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1441,7 +1441,10 @@ static int rswitch_open(struct net_device *ndev)
 	rswitch_enadis_data_irq(rdev->priv, rdev->tx_queue->index, true);
 	rswitch_enadis_data_irq(rdev->priv, rdev->rx_queue->index, true);
 
-	iowrite32(GWCA_TS_IRQ_BIT, rdev->priv->addr + GWTSDIE);
+	if (bitmap_empty(rdev->priv->opened_ports, RSWITCH_NUM_PORTS))
+		iowrite32(GWCA_TS_IRQ_BIT, rdev->priv->addr + GWTSDIE);
+
+	bitmap_set(rdev->priv->opened_ports, rdev->port, 1);
 
 	return 0;
 };
@@ -1452,8 +1455,10 @@ static int rswitch_stop(struct net_device *ndev)
 	struct rswitch_gwca_ts_info *ts_info, *ts_info2;
 
 	netif_tx_stop_all_queues(ndev);
+	bitmap_clear(rdev->priv->opened_ports, rdev->port, 1);
 
-	iowrite32(GWCA_TS_IRQ_BIT, rdev->priv->addr + GWTSDID);
+	if (bitmap_empty(rdev->priv->opened_ports, RSWITCH_NUM_PORTS))
+		iowrite32(GWCA_TS_IRQ_BIT, rdev->priv->addr + GWTSDID);
 
 	list_for_each_entry_safe(ts_info, ts_info2, &rdev->priv->gwca.ts_info_list, list) {
 		if (ts_info->port != rdev->port)
diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
index 27d3d38c055f..b3e0411b408e 100644
--- a/drivers/net/ethernet/renesas/rswitch.h
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -998,6 +998,7 @@ struct rswitch_private {
 	struct rcar_gen4_ptp_private *ptp_priv;
 
 	struct rswitch_device *rdev[RSWITCH_NUM_PORTS];
+	DECLARE_BITMAP(opened_ports, RSWITCH_NUM_PORTS);
 
 	struct rswitch_gwca gwca;
 	struct rswitch_etha etha[RSWITCH_NUM_PORTS];
-- 
2.25.1

