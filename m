Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946D3521047
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 11:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238400AbiEJJIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 05:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238394AbiEJJIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 05:08:30 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B8552B0315;
        Tue, 10 May 2022 02:04:33 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.91,214,1647270000"; 
   d="scan'208";a="120503714"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 10 May 2022 18:04:32 +0900
Received: from localhost.localdomain (unknown [10.226.93.89])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 4BD5142773A5;
        Tue, 10 May 2022 18:04:29 +0900 (JST)
From:   Phil Edworthy <phil.edworthy@renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Phil Edworthy <phil.edworthy@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 4/5] ravb: Use separate clock for gPTP
Date:   Tue, 10 May 2022 10:03:35 +0100
Message-Id: <20220510090336.14272-5-phil.edworthy@renesas.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220510090336.14272-1-phil.edworthy@renesas.com>
References: <20220510090336.14272-1-phil.edworthy@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RZ/V2M has a separate gPTP reference clock that is used when the
AVB-DMAC Mode Register (CCC) gPTP Clock Select (CSEL) bits are
set to "01: High-speed peripheral bus clock".
Therefore, add a feature that allows this clock to be used for
gPTP.

Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
v3:
 - No change
v2:
 - Added Reviewed-by tags
---
 drivers/net/ethernet/renesas/ravb.h      |  2 ++
 drivers/net/ethernet/renesas/ravb_main.c | 15 ++++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index e505e8088445..b980bce763d3 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1031,6 +1031,7 @@ struct ravb_hw_info {
 	unsigned err_mgmt_irqs:1;	/* Line1 (Err) and Line2 (Mgmt) irqs are separate */
 	unsigned gptp:1;		/* AVB-DMAC has gPTP support */
 	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
+	unsigned gptp_ref_clk:1;	/* gPTP has separate reference clock */
 	unsigned nc_queues:1;		/* AVB-DMAC has RX and TX NC queues */
 	unsigned magic_pkt:1;		/* E-MAC supports magic packet detection */
 	unsigned half_duplex:1;		/* E-MAC supports half duplex mode */
@@ -1042,6 +1043,7 @@ struct ravb_private {
 	void __iomem *addr;
 	struct clk *clk;
 	struct clk *refclk;
+	struct clk *gptp_clk;
 	struct mdiobb_ctrl mdiobb;
 	u32 num_rx_ring[NUM_RX_QUEUE];
 	u32 num_tx_ring[NUM_TX_QUEUE];
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 8ccc817b8b5d..ef6967731263 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2495,11 +2495,15 @@ MODULE_DEVICE_TABLE(of, ravb_match_table);
 static int ravb_set_gti(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	struct device *dev = ndev->dev.parent;
 	unsigned long rate;
 	uint64_t inc;
 
-	rate = clk_get_rate(priv->clk);
+	if (info->gptp_ref_clk)
+		rate = clk_get_rate(priv->gptp_clk);
+	else
+		rate = clk_get_rate(priv->clk);
 	if (!rate)
 		return -EINVAL;
 
@@ -2721,6 +2725,15 @@ static int ravb_probe(struct platform_device *pdev)
 	}
 	clk_prepare_enable(priv->refclk);
 
+	if (info->gptp_ref_clk) {
+		priv->gptp_clk = devm_clk_get(&pdev->dev, "gptp");
+		if (IS_ERR(priv->gptp_clk)) {
+			error = PTR_ERR(priv->gptp_clk);
+			goto out_release;
+		}
+		clk_prepare_enable(priv->gptp_clk);
+	}
+
 	ndev->max_mtu = info->rx_max_buf_size - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
 	ndev->min_mtu = ETH_MIN_MTU;
 
-- 
2.32.0

