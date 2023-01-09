Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A5C662B59
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 17:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbjAIQgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 11:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbjAIQgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 11:36:23 -0500
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80CC7FCA;
        Mon,  9 Jan 2023 08:36:22 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.96,311,1665414000"; 
   d="scan'208";a="148740488"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 10 Jan 2023 01:36:21 +0900
Received: from localhost.localdomain (unknown [10.226.92.188])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id DC37240078D9;
        Tue, 10 Jan 2023 01:36:16 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sasha Levin <sashal@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Mitsuhiro Kimura <mitsuhiro.kimura.kc@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        stable@vger.kernel.org,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] ravb: Fix "failed to switch device to config mode" message during unbind
Date:   Mon,  9 Jan 2023 16:36:14 +0000
Message-Id: <20230109163614.667480-1-biju.das.jz@bp.renesas.com>
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

commit c72a7e42592b2e18d862cf120876070947000d7a upstream.

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

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Cc: stable@vger.kernel.org # 4.9.y
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20221214105118.2495313-1-biju.das.jz@bp.renesas.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[biju: cherry-picked from 6.0 stable]
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
Resending to 4.9 with confilcts[1] fixed
[1] https://lore.kernel.org/stable/1672841813129164@kroah.com/
---
 drivers/net/ethernet/renesas/ravb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 2bebf39fe047..eeb8005d75d0 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2129,11 +2129,11 @@ static int ravb_remove(struct platform_device *pdev)
 			  priv->desc_bat_dma);
 	/* Set reset mode */
 	ravb_write(ndev, CCC_OPC_RESET, CCC);
-	pm_runtime_put_sync(&pdev->dev);
 	unregister_netdev(ndev);
 	netif_napi_del(&priv->napi[RAVB_NC]);
 	netif_napi_del(&priv->napi[RAVB_BE]);
 	ravb_mdio_release(priv);
+	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	free_netdev(ndev);
 	platform_set_drvdata(pdev, NULL);
-- 
2.25.1

