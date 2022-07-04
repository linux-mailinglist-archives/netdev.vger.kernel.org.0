Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B921564F12
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 09:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbiGDHvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 03:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbiGDHvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 03:51:08 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 140DB9FF6;
        Mon,  4 Jul 2022 00:51:05 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.92,243,1650898800"; 
   d="scan'208";a="124987836"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 04 Jul 2022 16:51:05 +0900
Received: from localhost.localdomain (unknown [10.226.92.214])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 892424213E2F;
        Mon,  4 Jul 2022 16:51:01 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 5/6] can: sja1000: Change the return type as void for SoC specific init
Date:   Mon,  4 Jul 2022 08:50:31 +0100
Message-Id: <20220704075032.383700-6-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220704075032.383700-1-biju.das.jz@bp.renesas.com>
References: <20220704075032.383700-1-biju.das.jz@bp.renesas.com>
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
v2->v3:
 * No change.
v1->v2:
 * No change.
---
 drivers/net/can/sja1000/sja1000_platform.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000_platform.c b/drivers/net/can/sja1000/sja1000_platform.c
index 0b78568f5286..81bc741905fd 100644
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

