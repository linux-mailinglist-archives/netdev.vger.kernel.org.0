Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C3651FFCC
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237190AbiEIO3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237188AbiEIO3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:29:37 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 03FE41D314;
        Mon,  9 May 2022 07:25:42 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.91,211,1647270000"; 
   d="scan'208";a="120391145"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 09 May 2022 23:25:42 +0900
Received: from localhost.localdomain (unknown [10.226.93.110])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id C946740078D5;
        Mon,  9 May 2022 23:25:38 +0900 (JST)
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
Subject: [PATCH v2 5/5] ravb: Add support for RZ/V2M
Date:   Mon,  9 May 2022 15:24:31 +0100
Message-Id: <20220509142431.24898-6-phil.edworthy@renesas.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220509142431.24898-1-phil.edworthy@renesas.com>
References: <20220509142431.24898-1-phil.edworthy@renesas.com>
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

RZ/V2M Ethernet is very similar to R-Car Gen3 Ethernet-AVB, though
some small parts are the same as R-Car Gen2.
Other differences to R-Car Gen3 and Gen2 are:
* It has separate data (DI), error (Line 1) and management (Line 2) irqs
  rather than one irq for all three.
* Instead of using the High-speed peripheral bus clock for gPTP, it has a
  separate gPTP reference clock.

Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
---
v2:
 - Removed gptp_ptm_gic feature that is no longer needed.
---
 drivers/net/ethernet/renesas/ravb_main.c | 26 ++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 0e1d9fc8a627..0fbb0fbcf996 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2460,6 +2460,31 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.magic_pkt = 1,
 };
 
+static const struct ravb_hw_info ravb_rzv2m_hw_info = {
+	.rx_ring_free = ravb_rx_ring_free_rcar,
+	.rx_ring_format = ravb_rx_ring_format_rcar,
+	.alloc_rx_desc = ravb_alloc_rx_desc_rcar,
+	.receive = ravb_rx_rcar,
+	.set_rate = ravb_set_rate_rcar,
+	.set_feature = ravb_set_features_rcar,
+	.dmac_init = ravb_dmac_init_rcar,
+	.emac_init = ravb_emac_init_rcar,
+	.gstrings_stats = ravb_gstrings_stats,
+	.gstrings_size = sizeof(ravb_gstrings_stats),
+	.net_hw_features = NETIF_F_RXCSUM,
+	.net_features = NETIF_F_RXCSUM,
+	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
+	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
+	.tccr_mask = TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3,
+	.rx_max_buf_size = SZ_2K,
+	.multi_irqs = 1,
+	.err_mgmt_irqs = 1,
+	.gptp = 1,
+	.gptp_ref_clk = 1,
+	.nc_queues = 1,
+	.magic_pkt = 1,
+};
+
 static const struct ravb_hw_info gbeth_hw_info = {
 	.rx_ring_free = ravb_rx_ring_free_gbeth,
 	.rx_ring_format = ravb_rx_ring_format_gbeth,
@@ -2487,6 +2512,7 @@ static const struct of_device_id ravb_match_table[] = {
 	{ .compatible = "renesas,etheravb-rcar-gen2", .data = &ravb_gen2_hw_info },
 	{ .compatible = "renesas,etheravb-r8a7795", .data = &ravb_gen3_hw_info },
 	{ .compatible = "renesas,etheravb-rcar-gen3", .data = &ravb_gen3_hw_info },
+	{ .compatible = "renesas,etheravb-rzv2m", .data = &ravb_rzv2m_hw_info },
 	{ .compatible = "renesas,rzg2l-gbeth", .data = &gbeth_hw_info },
 	{ }
 };
-- 
2.32.0

