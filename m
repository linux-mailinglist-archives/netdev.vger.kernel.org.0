Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15C645A3D2
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 14:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhKWNfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 08:35:15 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:20924 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229599AbhKWNfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 08:35:15 -0500
X-IronPort-AV: E=Sophos;i="5.87,257,1631545200"; 
   d="scan'208";a="101152354"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 23 Nov 2021 22:32:06 +0900
Received: from localhost.localdomain (unknown [10.226.93.159])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id A67154298F4C;
        Tue, 23 Nov 2021 22:32:03 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: [RFC 1/2] ravb: Fillup ravb_set_features_gbeth() stub
Date:   Tue, 23 Nov 2021 13:31:56 +0000
Message-Id: <20211123133157.21829-2-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211123133157.21829-1-biju.das.jz@bp.renesas.com>
References: <20211123133157.21829-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fillup ravb_set_features_gbeth() function to support RZ/G2L.
Also set the net_hw_features bits with rx checksum offload
supported by TOE.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      | 16 ++++++++++++++++
 drivers/net/ethernet/renesas/ravb_main.c | 24 +++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 08062d73df10..a96552348e2d 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -205,6 +205,7 @@ enum ravb_reg {
 	RFCR	= 0x0760,
 	MAFCR	= 0x0778,
 	CSR0    = 0x0800,	/* RZ/G2L only */
+	CSR2    = 0x0808,	/* RZ/G2L only */
 };
 
 
@@ -970,6 +971,21 @@ enum CSR0_BIT {
 	CSR0_RPE	= 0x00000020,
 };
 
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
index ce09bd45527e..c2b92c6a6cd2 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2314,7 +2314,28 @@ static void ravb_set_rx_csum(struct net_device *ndev, bool enable)
 static int ravb_set_features_gbeth(struct net_device *ndev,
 				   netdev_features_t features)
 {
-	/* Place holder */
+	netdev_features_t changed = ndev->features ^ features;
+	u32 csr0 = ravb_read(ndev, CSR0);
+	int error;
+
+	ravb_write(ndev, csr0 & ~(CSR0_RPE | CSR0_TPE), CSR0);
+	error = ravb_wait(ndev, CSR0, CSR0_RPE | CSR0_TPE, 0);
+	if (error) {
+		ravb_write(ndev, csr0, CSR0);
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
+	ravb_write(ndev, csr0, CSR0);
+
+	ndev->features = features;
+
 	return 0;
 }
 
@@ -2457,6 +2478,7 @@ static const struct ravb_hw_info gbeth_hw_info = {
 	.set_feature = ravb_set_features_gbeth,
 	.dmac_init = ravb_dmac_init_gbeth,
 	.emac_init = ravb_emac_init_gbeth,
+	.net_hw_features = NETIF_F_RXCSUM,
 	.gstrings_stats = ravb_gstrings_stats_gbeth,
 	.gstrings_size = sizeof(ravb_gstrings_stats_gbeth),
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats_gbeth),
-- 
2.17.1

