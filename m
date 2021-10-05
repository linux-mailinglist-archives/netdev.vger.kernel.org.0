Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F26422495
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbhJELIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:08:53 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:51445 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234333AbhJELIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 07:08:49 -0400
X-IronPort-AV: E=Sophos;i="5.85,348,1624287600"; 
   d="scan'208";a="96017423"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 05 Oct 2021 20:06:58 +0900
Received: from localhost.localdomain (unknown [10.226.93.104])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 9425A40078B9;
        Tue,  5 Oct 2021 20:06:55 +0900 (JST)
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
Subject: [RFC 03/12] ravb: Fillup ravb_set_features_gbeth() stub
Date:   Tue,  5 Oct 2021 12:06:33 +0100
Message-Id: <20211005110642.3744-4-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fillup ravb_set_features_gbeth() function to support RZ/G2L.
Also set the net_hw_features bits supported by GbEthernet

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
RFC changes:
 * Added CSR0 initilization
 * Seperated and created a new patch fro retrieving stats.
---
 drivers/net/ethernet/renesas/ravb.h      | 38 ++++++++++++++++++++++++
 drivers/net/ethernet/renesas/ravb_main.c | 34 ++++++++++++++++++++-
 2 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index b147c4a0dc0b..02f425bf9544 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -202,6 +202,9 @@ enum ravb_reg {
 	TLFRCR	= 0x0758,
 	RFCR	= 0x0760,
 	MAFCR	= 0x0778,
+	CSR0    = 0x0800,	/* RZ/G2L only */
+	CSR1    = 0x0804,	/* RZ/G2L only */
+	CSR2    = 0x0808,	/* RZ/G2L only */
 };
 
 
@@ -962,6 +965,41 @@ enum CXR31_BIT {
 	CXR31_SEL_LINK1	= 0x00000008,
 };
 
+enum CSR0_BIT {
+	CSR0_TPE	= 0x00000010,
+	CSR0_RPE	= 0x00000020,
+};
+
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
index ed0328a90200..37f50c041114 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -481,6 +481,7 @@ static void ravb_emac_init_gbeth(struct net_device *ndev)
 
 	/* E-MAC status register clear */
 	ravb_write(ndev, ECSR_ICD | ECSR_LCHNG | ECSR_PFRI, ECSR);
+	ravb_write(ndev, CSR0_TPE | CSR0_RPE, CSR0);
 
 	/* E-MAC interrupt enable register */
 	ravb_write(ndev, ECSIPR_ICDIP, ECSIPR);
@@ -2086,7 +2087,37 @@ static void ravb_set_rx_csum(struct net_device *ndev, bool enable)
 static int ravb_set_features_gbeth(struct net_device *ndev,
 				   netdev_features_t features)
 {
-	/* Place holder */
+	netdev_features_t changed = features ^ ndev->features;
+	int error;
+	u32 csr0;
+
+	csr0 = ravb_read(ndev, CSR0);
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
+	if (changed & NETIF_F_HW_CSUM) {
+		if (features & NETIF_F_HW_CSUM) {
+			ravb_write(ndev, CSR1_ALL, CSR1);
+			ndev->features |= NETIF_F_CSUM_MASK;
+		} else {
+			ravb_write(ndev, 0, CSR1);
+		}
+	}
+	ravb_write(ndev, csr0, CSR0);
+
+	ndev->features = features;
+
 	return 0;
 }
 
@@ -2229,6 +2260,7 @@ static const struct ravb_hw_info gbeth_hw_info = {
 	.set_feature = ravb_set_features_gbeth,
 	.dmac_init = ravb_dmac_init_gbeth,
 	.emac_init = ravb_emac_init_gbeth,
+	.net_hw_features = (NETIF_F_HW_CSUM | NETIF_F_RXCSUM),
 	.max_rx_len = ALIGN(GBETH_RX_BUFF_MAX, RAVB_ALIGN),
 	.tsrq = TCCR_TSRQ0,
 	.rx_max_buf_size = SZ_8K,
-- 
2.17.1

