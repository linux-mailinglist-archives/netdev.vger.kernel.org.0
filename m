Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30FBC6B7436
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 11:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjCMKhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 06:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbjCMKhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 06:37:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4CE50FB5
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 03:37:09 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY1-0008Sy-Pz; Mon, 13 Mar 2023 11:36:57 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY0-003pKc-Tj; Mon, 13 Mar 2023 11:36:56 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY0-004W3a-3U; Mon, 13 Mar 2023 11:36:56 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Wei Fang <wei.fang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 2/9] net: fec: Don't return early on error in .remove()
Date:   Mon, 13 Mar 2023 11:36:46 +0100
Message-Id: <20230313103653.2753139-3-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
References: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1289; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=6NeNoe10qCNS1oAAJ3wmxYdcXTYONYnrWH4YyJXGi6g=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBkDvyoTD3uvYT54qcEfGm2M/XGRdVZXIaLGinLf KylAfHxIpqJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCZA78qAAKCRDB/BR4rcrs CQ28B/45w0wRq6mq3QLY8fWPee6e8EMIJCTrdHriT1imSi0mBEpGePp+/TpQGF+ffhIYfVXj/dV e7OnUPSSO4Dc10bQdtHYjb5oNyNR7wQxWviXxDfKHg8ktqbCqRHMQqpaz/9M0bwJURwczvQkTLR jFnJd98K7KVVuREYe07wrK1bukKwrGfN3+XrEQbwNjoAD8wQ1pURQ/2DRrP9OvBUMvxemYam+US MnF4OhRZQcU+sRwOeALpN7Ek8yv10dqVS99YIGjo63Dsh6Ljs5sX9uPjBK8bZSi3mRpcaekkBkZ /rtoTR7bdONLkiRYGH/pI2PeHV3DhpDtE797+OmyTj4nEkfc
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If waking up the device in .remove() fails, exiting early results in
strange state: The platform device will be unbound but not all resources
are freed. E.g. the network device continues to exist without an parent.

Instead of an early error return, only skip the cleanup that was already
done by suspend and release the remaining resources.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/freescale/fec_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index c73e25f8995e..31d1dc5e9196 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -4465,15 +4465,13 @@ fec_drv_remove(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	int ret;
 
-	ret = pm_runtime_resume_and_get(&pdev->dev);
-	if (ret < 0)
-		return ret;
+	ret = pm_runtime_get_sync(&pdev->dev);
 
 	cancel_work_sync(&fep->tx_timeout_work);
 	fec_ptp_stop(pdev);
 	unregister_netdev(ndev);
 	fec_enet_mii_remove(fep);
-	if (fep->reg_phy)
+	if (ret >= 0 && fep->reg_phy)
 		regulator_disable(fep->reg_phy);
 
 	if (of_phy_is_fixed_link(np))
-- 
2.39.1

