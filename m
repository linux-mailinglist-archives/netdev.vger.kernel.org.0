Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9424160AE
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241664AbhIWOKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:10:33 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:46334 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241642AbhIWOK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 10:10:28 -0400
X-IronPort-AV: E=Sophos;i="5.85,316,1624287600"; 
   d="scan'208";a="94936100"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 23 Sep 2021 23:08:56 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id C6F87437E764;
        Thu, 23 Sep 2021 23:08:53 +0900 (JST)
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
Subject: [RFC/PATCH 11/18] ravb: Add rx_2k_buffers to struct ravb_hw_info
Date:   Thu, 23 Sep 2021 15:08:06 +0100
Message-Id: <20210923140813.13541-12-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R-Car AVB-DMAC has Maximum 2K size on RZ buffer.
We need to Allow for changing the MTU within the
limit of the maximum size of a descriptor (2048 bytes).

Add a rx_2k_buffers hw feature bit to struct ravb_hw_info
to add this constraint only for R-Car.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      | 1 +
 drivers/net/ethernet/renesas/ravb_main.c | 8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 7532cb51d7b8..ab4909244276 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1033,6 +1033,7 @@ struct ravb_hw_info {
 	unsigned magic_pkt:1;		/* E-MAC supports magic packet detection */
 	unsigned mii_rgmii_selection:1;	/* E-MAC supports mii/rgmii selection */
 	unsigned half_duplex:1;		/* E-MAC supports half duplex mode */
+	unsigned rx_2k_buffers:1;	/* AVB-DMAC has Max 2K buf size on RX */
 };
 
 struct ravb_private {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 7f06adbd00e1..9c0d35f4b221 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2164,6 +2164,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.ccc_gac = 1,
 	.multi_tsrq = 1,
 	.magic_pkt = 1,
+	.rx_2k_buffers = 1,
 };
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
@@ -2184,6 +2185,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.aligned_tx = 1,
 	.multi_tsrq = 1,
 	.magic_pkt = 1,
+	.rx_2k_buffers = 1,
 };
 
 static const struct ravb_hw_info rgeth_hw_info = {
@@ -2417,8 +2419,10 @@ static int ravb_probe(struct platform_device *pdev)
 	}
 	clk_prepare_enable(priv->refclk);
 
-	ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
-	ndev->min_mtu = ETH_MIN_MTU;
+	if (info->rx_2k_buffers) {
+		ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
+		ndev->min_mtu = ETH_MIN_MTU;
+	}
 
 	/* FIXME: R-Car Gen2 has 4byte alignment restriction for tx buffer
 	 * Use two descriptor to handle such situation. First descriptor to
-- 
2.17.1

