Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4C142A98B
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhJLQia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:38:30 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:6887 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230002AbhJLQi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 12:38:29 -0400
X-IronPort-AV: E=Sophos;i="5.85,368,1624287600"; 
   d="scan'208";a="96771783"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 13 Oct 2021 01:36:26 +0900
Received: from localhost.localdomain (unknown [10.226.92.46])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id A36C940AA558;
        Wed, 13 Oct 2021 01:36:23 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH net-next v3 02/14] ravb: Add rx_max_buf_size to struct ravb_hw_info
Date:   Tue, 12 Oct 2021 17:36:01 +0100
Message-Id: <20211012163613.30030-3-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
References: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R-Car AVB-DMAC has maximum 2K size on RX buffer, whereas on RZ/G2L
it is 8K. We need to allow for changing the MTU within the limit
of the maximum size of a descriptor.

Add a rx_max_buf_size variable to struct ravb_hw_info to handle
this difference.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
v2->v3:
 * No change
V1->v2:
 * No change
RFC->V1:
 * No Change. Added Sergey's Rb tag
---
 drivers/net/ethernet/renesas/ravb.h      | 1 +
 drivers/net/ethernet/renesas/ravb_main.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 5dc1324786e0..b147c4a0dc0b 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1010,6 +1010,7 @@ struct ravb_hw_info {
 	int stats_len;
 	size_t max_rx_len;
 	u32 tsrq;
+	u32 rx_max_buf_size;
 	unsigned aligned_tx: 1;
 
 	/* hardware features */
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 0e3cda1140e5..fe3449fb4135 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2188,6 +2188,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
 	.tsrq = TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3,
+	.rx_max_buf_size = SZ_2K,
 	.internal_delay = 1,
 	.tx_counters = 1,
 	.multi_irqs = 1,
@@ -2212,6 +2213,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
 	.tsrq = TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3,
+	.rx_max_buf_size = SZ_2K,
 	.aligned_tx = 1,
 	.gptp = 1,
 	.nc_queue = 1,
@@ -2229,6 +2231,7 @@ static const struct ravb_hw_info gbeth_hw_info = {
 	.emac_init = ravb_emac_init_gbeth,
 	.max_rx_len = ALIGN(GBETH_RX_BUFF_MAX, RAVB_ALIGN),
 	.tsrq = TCCR_TSRQ0,
+	.rx_max_buf_size = SZ_8K,
 	.aligned_tx = 1,
 	.tx_counters = 1,
 	.half_duplex = 1,
@@ -2452,7 +2455,7 @@ static int ravb_probe(struct platform_device *pdev)
 	}
 	clk_prepare_enable(priv->refclk);
 
-	ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
+	ndev->max_mtu = info->rx_max_buf_size - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
 	ndev->min_mtu = ETH_MIN_MTU;
 
 	/* FIXME: R-Car Gen2 has 4byte alignment restriction for tx buffer
-- 
2.17.1

