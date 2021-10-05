Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4404224A5
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbhJELJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:09:22 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:51898 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234430AbhJELJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 07:09:18 -0400
X-IronPort-AV: E=Sophos;i="5.85,348,1624287600"; 
   d="scan'208";a="96182814"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 05 Oct 2021 20:07:23 +0900
Received: from localhost.localdomain (unknown [10.226.93.104])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id DCE7D40078B9;
        Tue,  5 Oct 2021 20:07:20 +0900 (JST)
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
Subject: [RFC 10/12] ravb: Rename "tsrq" variable
Date:   Tue,  5 Oct 2021 12:06:40 +0100
Message-Id: <20211005110642.3744-11-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the variable "tsrq" with "tccr_mask" as we are passing
TCCR mask to the ravb_wait() function.

There is no functional change.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Suggested-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
RFC changes:
 * New patch.
---
 drivers/net/ethernet/renesas/ravb.h      | 2 +-
 drivers/net/ethernet/renesas/ravb_main.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 899e16c5eb1a..010dad82091c 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1052,7 +1052,7 @@ struct ravb_hw_info {
 	netdev_features_t net_features;
 	int stats_len;
 	size_t max_rx_len;
-	u32 tsrq;
+	u32 tccr_mask;
 	u32 rx_max_buf_size;
 	unsigned aligned_tx: 1;
 
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index e2238cea9f3e..5d00650e86b0 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1043,7 +1043,7 @@ static int ravb_stop_dma(struct net_device *ndev)
 	int error;
 
 	/* Wait for stopping the hardware TX process */
-	error = ravb_wait(ndev, TCCR, info->tsrq, 0);
+	error = ravb_wait(ndev, TCCR, info->tccr_mask, 0);
 
 	if (error)
 		return error;
@@ -2467,7 +2467,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.net_features = NETIF_F_RXCSUM,
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
-	.tsrq = TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3,
+	.tccr_mask = TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3,
 	.rx_max_buf_size = SZ_2K,
 	.internal_delay = 1,
 	.tx_counters = 1,
@@ -2492,7 +2492,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.net_features = NETIF_F_RXCSUM,
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
-	.tsrq = TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3,
+	.tccr_mask = TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3,
 	.rx_max_buf_size = SZ_2K,
 	.aligned_tx = 1,
 	.gptp = 1,
@@ -2514,7 +2514,7 @@ static const struct ravb_hw_info gbeth_hw_info = {
 	.gstrings_size = sizeof(ravb_gstrings_stats_gbeth),
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats_gbeth),
 	.max_rx_len = ALIGN(GBETH_RX_BUFF_MAX, RAVB_ALIGN),
-	.tsrq = TCCR_TSRQ0,
+	.tccr_mask = TCCR_TSRQ0,
 	.rx_max_buf_size = SZ_8K,
 	.aligned_tx = 1,
 	.tx_counters = 1,
-- 
2.17.1

