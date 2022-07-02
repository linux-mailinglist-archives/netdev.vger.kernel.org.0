Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBEA1564091
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 16:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbiGBOCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 10:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbiGBOCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 10:02:06 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89E10101CC;
        Sat,  2 Jul 2022 07:02:03 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.92,240,1650898800"; 
   d="scan'208";a="124846514"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 02 Jul 2022 23:02:02 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 1431243676A2;
        Sat,  2 Jul 2022 23:01:58 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH 5/6] can: sja1000: Change the return type as void for SoC specific init
Date:   Sat,  2 Jul 2022 15:01:29 +0100
Message-Id: <20220702140130.218409-6-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
References: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the return type as void for SoC specific init function as it
always return 0.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/can/sja1000/sja1000_platform.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000_platform.c b/drivers/net/can/sja1000/sja1000_platform.c
index 24ea0f76e130..5f3d362e0da5 100644
--- a/drivers/net/can/sja1000/sja1000_platform.c
+++ b/drivers/net/can/sja1000/sja1000_platform.c
@@ -31,7 +31,7 @@ MODULE_LICENSE("GPL v2");
 
 struct sja1000_of_data {
 	size_t  priv_sz;
-	int     (*init)(struct sja1000_priv *priv, struct device_node *of);
+	void    (*init)(struct sja1000_priv *priv, struct device_node *of);
 };
 
 struct technologic_priv {
@@ -94,15 +94,13 @@ static void sp_technologic_write_reg16(const struct sja1000_priv *priv,
 	spin_unlock_irqrestore(&tp->io_lock, flags);
 }
 
-static int sp_technologic_init(struct sja1000_priv *priv, struct device_node *of)
+static void sp_technologic_init(struct sja1000_priv *priv, struct device_node *of)
 {
 	struct technologic_priv *tp = priv->priv;
 
 	priv->read_reg = sp_technologic_read_reg16;
 	priv->write_reg = sp_technologic_write_reg16;
 	spin_lock_init(&tp->io_lock);
-
-	return 0;
 }
 
 static void sp_populate(struct sja1000_priv *priv,
@@ -266,11 +264,8 @@ static int sp_probe(struct platform_device *pdev)
 	if (of) {
 		sp_populate_of(priv, of);
 
-		if (of_data && of_data->init) {
-			err = of_data->init(priv, of);
-			if (err)
-				goto exit_free;
-		}
+		if (of_data && of_data->init)
+			of_data->init(priv, of);
 	} else {
 		sp_populate(priv, pdata, res_mem->flags);
 	}
-- 
2.25.1

