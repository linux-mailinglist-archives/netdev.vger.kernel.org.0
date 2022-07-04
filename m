Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BE9564F16
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 09:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbiGDHvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 03:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbiGDHvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 03:51:05 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF14CA1B4;
        Mon,  4 Jul 2022 00:51:01 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.92,243,1650898800"; 
   d="scan'208";a="124987818"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 04 Jul 2022 16:51:01 +0900
Received: from localhost.localdomain (unknown [10.226.92.214])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id C6C04422BD45;
        Mon,  4 Jul 2022 16:50:56 +0900 (JST)
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
Subject: [PATCH v3 4/6] can: sja1000: Use device_get_match_data to get device data
Date:   Mon,  4 Jul 2022 08:50:30 +0100
Message-Id: <20220704075032.383700-5-biju.das.jz@bp.renesas.com>
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

This patch replaces of_match_device->device_get_match_data
to get pointer to device data.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
v2->v3:
 * No change
v1->v2:
 * Replaced of_device_get_match_data->device_get_match_data.
---
 drivers/net/can/sja1000/sja1000_platform.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000_platform.c b/drivers/net/can/sja1000/sja1000_platform.c
index f9ec7bd8dfac..0b78568f5286 100644
--- a/drivers/net/can/sja1000/sja1000_platform.c
+++ b/drivers/net/can/sja1000/sja1000_platform.c
@@ -210,7 +210,6 @@ static int sp_probe(struct platform_device *pdev)
 	struct resource *res_mem, *res_irq = NULL;
 	struct sja1000_platform_data *pdata;
 	struct device_node *of = pdev->dev.of_node;
-	const struct of_device_id *of_id;
 	const struct sja1000_of_data *of_data = NULL;
 	size_t priv_sz = 0;
 
@@ -243,11 +242,9 @@ static int sp_probe(struct platform_device *pdev)
 			return -ENODEV;
 	}
 
-	of_id = of_match_device(sp_of_table, &pdev->dev);
-	if (of_id && of_id->data) {
-		of_data = of_id->data;
+	of_data = device_get_match_data(&pdev->dev);
+	if (of_data)
 		priv_sz = of_data->priv_sz;
-	}
 
 	dev = alloc_sja1000dev(priv_sz);
 	if (!dev)
-- 
2.25.1

