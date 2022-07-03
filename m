Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3B85646DF
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 12:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbiGCKr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 06:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbiGCKrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 06:47:39 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7FD71A1BC;
        Sun,  3 Jul 2022 03:47:35 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.92,241,1650898800"; 
   d="scan'208";a="126488412"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 03 Jul 2022 19:47:34 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id B6228427AD01;
        Sun,  3 Jul 2022 19:47:30 +0900 (JST)
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
Subject: [PATCH v2 4/6] can: sja1000: Use device_get_match_data to get device data
Date:   Sun,  3 Jul 2022 11:47:03 +0100
Message-Id: <20220703104705.341070-5-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220703104705.341070-1-biju.das.jz@bp.renesas.com>
References: <20220703104705.341070-1-biju.das.jz@bp.renesas.com>
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

