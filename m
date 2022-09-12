Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C520D5B58BF
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 12:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiILKvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 06:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiILKvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 06:51:47 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C568B32DB0;
        Mon, 12 Sep 2022 03:51:44 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.93,310,1654527600"; 
   d="scan'208";a="134604893"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 12 Sep 2022 19:51:43 +0900
Received: from localhost.localdomain (unknown [10.226.92.151])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 0ECCA431E2D9;
        Mon, 12 Sep 2022 19:51:39 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: [PATCH net-next v2] ravb: Add RZ/G2L MII interface support
Date:   Mon, 12 Sep 2022 11:51:37 +0100
Message-Id: <20220912105137.302648-1-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EMAC IP found on RZ/G2L Gb ethernet supports MII interface.
This patch adds support for selecting MII interface mode.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
v1->v2:
 * Fixed spaces->Tab around CXR35 description.
---
 drivers/net/ethernet/renesas/ravb.h      | 5 +++++
 drivers/net/ethernet/renesas/ravb_main.c | 8 +++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index b980bce763d3..0c7c0d404dcb 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -189,6 +189,7 @@ enum ravb_reg {
 	PSR	= 0x0528,
 	PIPR	= 0x052c,
 	CXR31	= 0x0530,	/* RZ/G2L only */
+	CXR35	= 0x0540,	/* RZ/G2L only */
 	MPR	= 0x0558,
 	PFTCR	= 0x055c,
 	PFRCR	= 0x0560,
@@ -965,6 +966,10 @@ enum CXR31_BIT {
 	CXR31_SEL_LINK1	= 0x00000008,
 };
 
+enum CXR35_BIT {
+	CXR35_SEL_MII	= 0x03E80002,
+};
+
 enum CSR0_BIT {
 	CSR0_TPE	= 0x00000010,
 	CSR0_RPE	= 0x00000020,
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index b357ac4c56c5..6f6bf11995b0 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -540,7 +540,13 @@ static void ravb_emac_init_gbeth(struct net_device *ndev)
 	/* E-MAC interrupt enable register */
 	ravb_write(ndev, ECSIPR_ICDIP, ECSIPR);
 
-	ravb_modify(ndev, CXR31, CXR31_SEL_LINK0 | CXR31_SEL_LINK1, CXR31_SEL_LINK0);
+	if (priv->phy_interface == PHY_INTERFACE_MODE_MII) {
+		ravb_modify(ndev, CXR31, CXR31_SEL_LINK0 | CXR31_SEL_LINK1, 0);
+		ravb_write(ndev, CXR35_SEL_MII, CXR35);
+	} else {
+		ravb_modify(ndev, CXR31, CXR31_SEL_LINK0 | CXR31_SEL_LINK1,
+			    CXR31_SEL_LINK0);
+	}
 }
 
 static void ravb_emac_init_rcar(struct net_device *ndev)
-- 
2.25.1

