Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E0E3F6FFB
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 09:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239123AbhHYHDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 03:03:11 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:13589 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239005AbhHYHCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 03:02:50 -0400
X-IronPort-AV: E=Sophos;i="5.84,349,1620658800"; 
   d="scan'208";a="91716422"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 25 Aug 2021 16:02:04 +0900
Received: from localhost.localdomain (unknown [10.226.92.232])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 5F3FE42016B7;
        Wed, 25 Aug 2021 16:02:01 +0900 (JST)
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
Subject: [PATCH net-next 01/13] ravb: Remove the macros NUM_TX_DESC_GEN[23]
Date:   Wed, 25 Aug 2021 08:01:42 +0100
Message-Id: <20210825070154.14336-2-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For addressing 4 bytes alignment restriction on transmission
buffer for R-Car Gen2 we use 2 descriptors whereas it is a single
descriptor for other cases.
Replace the macros NUM_TX_DESC_GEN[23] with magic number and
add a comment to explain it.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      | 4 ----
 drivers/net/ethernet/renesas/ravb_main.c | 8 ++++++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 37ad0f8aaf3c..84700a82a41c 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -956,10 +956,6 @@ enum RAVB_QUEUE {
 
 #define RX_BUF_SZ	(2048 - ETH_FCS_LEN + sizeof(__sum16))
 
-/* TX descriptors per packet */
-#define NUM_TX_DESC_GEN2	2
-#define NUM_TX_DESC_GEN3	1
-
 struct ravb_tstamp_skb {
 	struct list_head list;
 	struct sk_buff *skb;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 02842b980a7f..073e690ab830 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2160,8 +2160,12 @@ static int ravb_probe(struct platform_device *pdev)
 	ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
 	ndev->min_mtu = ETH_MIN_MTU;
 
-	priv->num_tx_desc = info->aligned_tx ?
-		NUM_TX_DESC_GEN2 : NUM_TX_DESC_GEN3;
+	/* FIXME: R-Car Gen2 has 4byte alignment restriction for tx buffer
+	 * Use two descriptor to handle such situation. First descriptor to
+	 * handle aligned data buffer and second descriptor to handle the
+	 * overflow data because of alignment.
+	 */
+	priv->num_tx_desc = info->aligned_tx ? 2 : 1;
 
 	/* Set function */
 	ndev->netdev_ops = &ravb_netdev_ops;
-- 
2.17.1

