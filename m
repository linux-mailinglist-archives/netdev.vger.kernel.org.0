Return-Path: <netdev+bounces-1561-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33E636FE4BB
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 22:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4DF3281567
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB9C218010;
	Wed, 10 May 2023 20:00:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD270174D4
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 20:00:44 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D9B3C0D
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:00:39 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1pwpz8-0001dA-UL; Wed, 10 May 2023 22:00:26 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pwpz6-002YwS-NZ; Wed, 10 May 2023 22:00:24 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1pwpz5-003CdS-Pt; Wed, 10 May 2023 22:00:23 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Wei Fang <wei.fang@nxp.com>,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	NXP Linux Team <linux-imx@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Fugang Duan <fugang.duan@nxp.com>,
	Chuhong Yuan <hslester96@gmail.com>,
	netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH net] net: fec: Better handle pm_runtime_get() failing in .remove()
Date: Wed, 10 May 2023 22:00:20 +0200
Message-Id: <20230510200020.1534610-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1952; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=f0FYoqhWaEbRzQ16JbU4MmfMqDe5bIrT1fA6sYPZudA=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkW/fTLr0A6ZMn6wEobG7Td7ySd+Z4tK8AnNVEj yNymE5zXA6JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZFv30wAKCRCPgPtYfRL+ TkpLB/9nUudk9qKyTxxKC9SXz0YXUpbm5dcdvpOLzhroLzY7+awSJN70SI8wBikKHXy2qcy2tIw 5CrBzv/TF+QAiJlXBvFtIb7rXpeC7KWp6PJk1sS4sz9IhZyhRmCY+ZGX4gnyjHAzwlJzlRrrUi5 6n2f9uuXuZ1PlB1pF5uuaacqhU8dPO7d7tCIRVes2MqNskzNpXYRRIx4CxozdFl5Df8S+WMynD9 zLEIr54awBweJ0YjdknmcTvCx7/IO2oOBKVHD648EXvxwc3WAt/Kw4syi+1a9Sujim74ULD7Jcn Un6L5pYNrV3i8VyYQ7kmNRsOKL21S3ybcWGmOu5PdssFyE5t
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In the (unlikely) event that pm_runtime_get() (disguised as
pm_runtime_resume_and_get()) fails, the remove callback returned an
error early. The problem with this is that the driver core ignores the
error value and continues removing the device. This results in a
resource leak. Worse the devm allocated resources are freed and so if a
callback of the driver is called later the register mapping is already
gone which probably results in a crash.

Fixes: a31eda65ba21 ("net: fec: fix clock count mis-match")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/freescale/fec_main.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 42ec6ca3bf03..241df41d500f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -4478,9 +4478,11 @@ fec_drv_remove(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	int ret;
 
-	ret = pm_runtime_resume_and_get(&pdev->dev);
+	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0)
-		return ret;
+		dev_err(&pdev->dev,
+			"Failed to resume device in remove callback (%pe)\n",
+			ERR_PTR(ret));
 
 	cancel_work_sync(&fep->tx_timeout_work);
 	fec_ptp_stop(pdev);
@@ -4493,8 +4495,13 @@ fec_drv_remove(struct platform_device *pdev)
 		of_phy_deregister_fixed_link(np);
 	of_node_put(fep->phy_node);
 
-	clk_disable_unprepare(fep->clk_ahb);
-	clk_disable_unprepare(fep->clk_ipg);
+	/* After pm_runtime_get_sync() failed, the clks are still off, so skip
+	 * disabling them again.
+	 */
+	if (ret >= 0) {
+		clk_disable_unprepare(fep->clk_ahb);
+		clk_disable_unprepare(fep->clk_ipg);
+	}
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
base-commit: ac9a78681b921877518763ba0e89202254349d1b
-- 
2.39.2


