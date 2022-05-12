Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEFB524C16
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 13:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353444AbiELLsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 07:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353466AbiELLsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 07:48:35 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 798ED562C6;
        Thu, 12 May 2022 04:48:31 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.91,219,1647270000"; 
   d="scan'208";a="119489205"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 12 May 2022 20:48:30 +0900
Received: from localhost.localdomain (unknown [10.226.93.50])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 8354D40083D6;
        Thu, 12 May 2022 20:48:27 +0900 (JST)
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
Subject: [PATCH v4 5/5] ravb: Add support for RZ/V2M
Date:   Thu, 12 May 2022 12:47:22 +0100
Message-Id: <20220512114722.35965-6-phil.edworthy@renesas.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220512114722.35965-1-phil.edworthy@renesas.com>
References: <20220512114722.35965-1-phil.edworthy@renesas.com>
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
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
v4:
 - No change
v3:
 - Added Reviewed-by tags
v2:
 - Removed gptp_ptm_gic feature that is no longer needed.
---
 drivers/net/ethernet/renesas/ravb_main.c | 26 ++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 9d281f74abd0..b357ac4c56c5 100644
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
2.34.1

