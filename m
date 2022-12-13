Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9054964B2E3
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 10:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235076AbiLMJ7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 04:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235071AbiLMJ7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 04:59:49 -0500
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FDED1AF25;
        Tue, 13 Dec 2022 01:59:46 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.96,241,1665414000"; 
   d="scan'208";a="143182982"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 13 Dec 2022 18:59:45 +0900
Received: from localhost.localdomain (unknown [10.226.93.72])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id B11214006DC5;
        Tue, 13 Dec 2022 18:59:40 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Masaru Nagai <masaru.nagai.vx@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        stable@vger.kernel.org
Subject: [PATCH net-next] ravb: Fix "failed to switch device to config mode" message during unbind
Date:   Tue, 13 Dec 2022 09:59:38 +0000
Message-Id: <20221213095938.1280861-1-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the error "ravb 11c20000.ethernet eth0: failed to switch
device to config mode" during unbind.

We are doing register access after pm_runtime_put_sync().

We usually do cleanup in reverse order of init. Currently in
remove(), the "pm_runtime_put_sync" is not in reverse order.

Probe
	reset_control_deassert(rstc);
	pm_runtime_enable(&pdev->dev);
	pm_runtime_get_sync(&pdev->dev);

remove
	pm_runtime_put_sync(&pdev->dev);
	unregister_netdev(ndev);
	..
	ravb_mdio_release(priv);
	pm_runtime_disable(&pdev->dev);

Consider the call to unregister_netdev()
unregister_netdev->unregister_netdevice_queue->rollback_registered_many
that calls the below functions which access the registers after
pm_runtime_put_sync()
 1) ravb_get_stats
 2) ravb_close

Fixes: a0d2f20650e8 ("Renesas Ethernet AVB PTP clock driver")
Cc: stable@vger.kernel.org
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 33f723a9f471..b4e0fc7f65bd 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2903,12 +2903,12 @@ static int ravb_remove(struct platform_device *pdev)
 			  priv->desc_bat_dma);
 	/* Set reset mode */
 	ravb_write(ndev, CCC_OPC_RESET, CCC);
-	pm_runtime_put_sync(&pdev->dev);
 	unregister_netdev(ndev);
 	if (info->nc_queues)
 		netif_napi_del(&priv->napi[RAVB_NC]);
 	netif_napi_del(&priv->napi[RAVB_BE]);
 	ravb_mdio_release(priv);
+	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	reset_control_assert(priv->rstc);
 	free_netdev(ndev);
-- 
2.25.1

