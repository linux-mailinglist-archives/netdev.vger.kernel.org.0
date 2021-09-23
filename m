Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A224160BE
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241695AbhIWOLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:11:00 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:16221 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241698AbhIWOKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 10:10:52 -0400
X-IronPort-AV: E=Sophos;i="5.85,316,1624287600"; 
   d="scan'208";a="94936141"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 23 Sep 2021 23:09:20 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 310DB437F0B8;
        Thu, 23 Sep 2021 23:09:17 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: [RFC/PATCH 18/18] ravb: Add set_feature support for RZ/G2L
Date:   Thu, 23 Sep 2021 15:08:13 +0100
Message-Id: <20210923140813.13541-19-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds set_feature support for RZ/G2L.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      | 32 ++++++++++++++
 drivers/net/ethernet/renesas/ravb_main.c | 56 +++++++++++++++++++++++-
 2 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index d42e8ea981df..2275f27c0672 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -209,6 +209,8 @@ enum ravb_reg {
 	CXR56	= 0x0770,	/* Documented for RZ/G2L only */
 	MAFCR	= 0x0778,
 	CSR0     = 0x0800,	/* Documented for RZ/G2L only */
+	CSR1     = 0x0804,	/* Documented for RZ/G2L only */
+	CSR2     = 0x0808,	/* Documented for RZ/G2L only */
 };
 
 
@@ -978,6 +980,36 @@ enum CSR0_BIT {
 	CSR0_RPE	= 0x00000020,
 };
 
+enum CSR1_BIT {
+	CSR1_TIP4	= 0x00000001,
+	CSR1_TTCP4	= 0x00000010,
+	CSR1_TUDP4	= 0x00000020,
+	CSR1_TICMP4	= 0x00000040,
+	CSR1_TTCP6	= 0x00100000,
+	CSR1_TUDP6	= 0x00200000,
+	CSR1_TICMP6	= 0x00400000,
+	CSR1_THOP	= 0x01000000,
+	CSR1_TROUT	= 0x02000000,
+	CSR1_TAHD	= 0x04000000,
+	CSR1_TDHD	= 0x08000000,
+	CSR1_ALL	= 0x0F700071,
+};
+
+enum CSR2_BIT {
+	CSR2_RIP4	= 0x00000001,
+	CSR2_RTCP4	= 0x00000010,
+	CSR2_RUDP4	= 0x00000020,
+	CSR2_RICMP4	= 0x00000040,
+	CSR2_RTCP6	= 0x00100000,
+	CSR2_RUDP6	= 0x00200000,
+	CSR2_RICMP6	= 0x00400000,
+	CSR2_RHOP	= 0x01000000,
+	CSR2_RROUT	= 0x02000000,
+	CSR2_RAHD	= 0x04000000,
+	CSR2_RDHD	= 0x08000000,
+	CSR2_ALL	= 0x0F700071,
+};
+
 #define DBAT_ENTRY_NUM	22
 #define RX_QUEUE_OFFSET	4
 #define NUM_RX_QUEUE	2
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 72aea5875bc5..641ae5553b64 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1506,6 +1506,24 @@ static void ravb_set_msglevel(struct net_device *ndev, u32 value)
 	priv->msg_enable = value;
 }
 
+static const char ravb_gstrings_stats_rgeth[][ETH_GSTRING_LEN] = {
+	"rx_queue_0_current",
+	"tx_queue_0_current",
+	"rx_queue_0_dirty",
+	"tx_queue_0_dirty",
+	"rx_queue_0_packets",
+	"tx_queue_0_packets",
+	"rx_queue_0_bytes",
+	"tx_queue_0_bytes",
+	"rx_queue_0_mcast_packets",
+	"rx_queue_0_errors",
+	"rx_queue_0_crc_errors",
+	"rx_queue_0_frame_errors",
+	"rx_queue_0_length_errors",
+	"rx_queue_0_csum_offload_errors",
+	"rx_queue_0_over_errors",
+};
+
 static const char ravb_gstrings_stats[][ETH_GSTRING_LEN] = {
 	"rx_queue_0_current",
 	"tx_queue_0_current",
@@ -2290,7 +2308,38 @@ static void ravb_set_rx_csum(struct net_device *ndev, bool enable)
 static int ravb_set_features_rgeth(struct net_device *ndev,
 				   netdev_features_t features)
 {
-	/* Place holder */
+	netdev_features_t changed = features ^ ndev->features;
+	unsigned int reg;
+	int error;
+
+	reg = ravb_read(ndev, CSR0);
+
+	ravb_write(ndev, reg & ~(CSR0_RPE | CSR0_TPE), CSR0);
+	error = ravb_wait(ndev, CSR0, CSR0_RPE | CSR0_TPE, 0);
+	if (error) {
+		ravb_write(ndev, reg, CSR0);
+		return error;
+	}
+
+	if (changed & NETIF_F_RXCSUM) {
+		if (features & NETIF_F_RXCSUM)
+			ravb_write(ndev, CSR2_ALL, CSR2);
+		else
+			ravb_write(ndev, 0, CSR2);
+	}
+
+	if (changed & NETIF_F_HW_CSUM) {
+		if (features & NETIF_F_HW_CSUM) {
+			ravb_write(ndev, CSR1_ALL, CSR1);
+			ndev->features |= NETIF_F_CSUM_MASK;
+		} else {
+			ravb_write(ndev, 0, CSR1);
+		}
+	}
+	ravb_write(ndev, reg, CSR0);
+
+	ndev->features = features;
+
 	return 0;
 }
 
@@ -2432,6 +2481,11 @@ static const struct ravb_hw_info rgeth_hw_info = {
 	.set_feature = ravb_set_features_rgeth,
 	.dmac_init = ravb_dmac_init_rgeth,
 	.emac_init = ravb_emac_init_rgeth,
+	.net_hw_features = (NETIF_F_HW_CSUM | NETIF_F_RXCSUM),
+	.gstrings_stats = ravb_gstrings_stats_rgeth,
+	.gstrings_size = sizeof(ravb_gstrings_stats_rgeth),
+	.stats_len = ARRAY_SIZE(ravb_gstrings_stats_rgeth),
+	.max_rx_len = RGETH_RX_BUFF_MAX + RAVB_ALIGN - 1,
 	.aligned_tx = 1,
 	.tx_counters = 1,
 	.no_gptp = 1,
-- 
2.17.1

