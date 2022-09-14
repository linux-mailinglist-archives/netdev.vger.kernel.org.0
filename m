Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048015B8E5E
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 19:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiINRxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 13:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiINRxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 13:53:35 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2392A459A6;
        Wed, 14 Sep 2022 10:53:34 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.93,315,1654527600"; 
   d="scan'208";a="134968742"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 15 Sep 2022 02:53:33 +0900
Received: from localhost.localdomain (unknown [10.226.93.23])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id A873E4004BC6;
        Thu, 15 Sep 2022 02:53:29 +0900 (JST)
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
Subject: [PATCH net-next v4] ravb: Add RZ/G2L MII interface support
Date:   Wed, 14 Sep 2022 18:53:27 +0100
Message-Id: <20220914175327.236988-1-biju.das.jz@bp.renesas.com>
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
v3->v4:
 * Dropped CXR35_HALFCYC_CLKSW1000 macro
 * Added CXR35_HALFCYC_CLKSW, CXR35_SEL_XMII and CXR35_SEL_XMII_RGMII
   macros.
v2->v3:
 * Documented CXR35_HALFCYC_CLKSW1000 and CXR35_SEL_XMII_MII macros.
v1->v2:
 * Fixed spaces->Tab around CXR35 description.
---
 drivers/net/ethernet/renesas/ravb.h      | 8 ++++++++
 drivers/net/ethernet/renesas/ravb_main.c | 8 +++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index b980bce763d3..b445da0fa578 100644
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
@@ -965,6 +966,13 @@ enum CXR31_BIT {
 	CXR31_SEL_LINK1	= 0x00000008,
 };
 
+enum CXR35_BIT {
+	CXR35_HALFCYC_CLKSW	= 0xffff0000,
+	CXR35_SEL_XMII		= 0x00000003,
+	CXR35_SEL_XMII_RGMII	= 0x00000000,
+	CXR35_SEL_XMII_MII	= 0x00000002,
+};
+
 enum CSR0_BIT {
 	CSR0_TPE	= 0x00000010,
 	CSR0_RPE	= 0x00000020,
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index b357ac4c56c5..421c8ff1ce1f 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -540,7 +540,13 @@ static void ravb_emac_init_gbeth(struct net_device *ndev)
 	/* E-MAC interrupt enable register */
 	ravb_write(ndev, ECSIPR_ICDIP, ECSIPR);
 
-	ravb_modify(ndev, CXR31, CXR31_SEL_LINK0 | CXR31_SEL_LINK1, CXR31_SEL_LINK0);
+	if (priv->phy_interface == PHY_INTERFACE_MODE_MII) {
+		ravb_modify(ndev, CXR31, CXR31_SEL_LINK0 | CXR31_SEL_LINK1, 0);
+		ravb_write(ndev, (1000 << 16) | CXR35_SEL_XMII_MII, CXR35);
+	} else {
+		ravb_modify(ndev, CXR31, CXR31_SEL_LINK0 | CXR31_SEL_LINK1,
+			    CXR31_SEL_LINK0);
+	}
 }
 
 static void ravb_emac_init_rcar(struct net_device *ndev)
-- 
2.25.1

