Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F857422493
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbhJELIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:08:47 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:40346 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234320AbhJELIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 07:08:46 -0400
X-IronPort-AV: E=Sophos;i="5.85,348,1624287600"; 
   d="scan'208";a="96182768"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 05 Oct 2021 20:06:55 +0900
Received: from localhost.localdomain (unknown [10.226.93.104])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id ECB5940078B9;
        Tue,  5 Oct 2021 20:06:51 +0900 (JST)
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
Subject: [RFC 02/12] ravb: Add rx_max_buf_size to struct ravb_hw_info
Date:   Tue,  5 Oct 2021 12:06:32 +0100
Message-Id: <20211005110642.3744-3-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
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
---
RFC:
 * used buffer_size instead of feature bit.
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
index 56a97d583950..ed0328a90200 100644
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

