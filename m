Return-Path: <netdev+bounces-8560-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAECF72491B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:29:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B4EB1C20A7C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:29:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ADD333CA0;
	Tue,  6 Jun 2023 16:28:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D40233C9B
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 16:28:46 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED113FB
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:28:44 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6ZXv-00056h-AK; Tue, 06 Jun 2023 18:28:35 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6ZXt-005Y5Q-VP; Tue, 06 Jun 2023 18:28:33 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q6ZXt-00Bl0K-3d; Tue, 06 Jun 2023 18:28:33 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Madalin Bucur <madalin.bucur@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Russell King <linux@armlinux.org.uk>
Cc: netdev@vger.kernel.org,
	kernel@pengutronix.de,
	Madalin Bucur <madalin.bucur@oss.nxp.com>,
	Michal Kubiak <michal.kubiak@intel.com>
Subject: [PATCH net-next v2 1/8] net: dpaa: Improve error reporting
Date: Tue,  6 Jun 2023 18:28:22 +0200
Message-Id: <20230606162829.166226-2-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230606162829.166226-1-u.kleine-koenig@pengutronix.de>
References: <20230606162829.166226-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1560; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=KPuBxR8yI1nN/gV8dadKWqbIlvPQ36Amsh9ydxKH2Do=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkf16ijykIjfdq52lnM9BFPHAv4FsQEt5TPBzaa 96Sev1A/QqJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZH9eogAKCRCPgPtYfRL+ TmWjB/97ifj+75gt3JkJ59rYnNcVUdrB7TkCNndUHhIianACcQe1t1CfuS3ubvD5Lc4PQoZ2YVs ODuF375vq5NX8Tj5Qn+HgyhC+5ED/4OzR+lv08D7ryMISaC+u5zoWMCvGncyteU321vjgu6ZBqc oAST/irZutForOl34afZl3XHDq3tFKYGvLflP1Jq4s7gWAXmHlcS1gygxW6poEJzKiuMCztig1p sEWV56XSdk+UkQCEqCAKwytkhTy0c4vu8R+2uERpk7+ZOBBxXakdXSF/WxSVcFvQrhL/tN999Fo owAIEAD4ekPGkVoCsg8Eo19FMSkV2MMcb7sXFetzCZ7NyxeZ
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

Instead of the generic error message emitted by the driver core when a
remove callback returns an error code ("remove callback returned a
non-zero value. This will be ignored."), emit a message describing the
actual problem and return zero to suppress the generic message.

Note that apart from suppressing the generic error message there are no
side effects by changing the return value to zero. This prepares
changing the remove callback to return void.

Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 431f8917dc39..6226c03cfca0 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -3516,6 +3516,8 @@ static int dpaa_remove(struct platform_device *pdev)
 	phylink_destroy(priv->mac_dev->phylink);
 
 	err = dpaa_fq_free(dev, &priv->dpaa_fq_list);
+	if (err)
+		dev_err(dev, "Failed to free FQs on remove\n");
 
 	qman_delete_cgr_safe(&priv->ingress_cgr);
 	qman_release_cgrid(priv->ingress_cgr.cgrid);
@@ -3528,7 +3530,7 @@ static int dpaa_remove(struct platform_device *pdev)
 
 	free_netdev(net_dev);
 
-	return err;
+	return 0;
 }
 
 static const struct platform_device_id dpaa_devtype[] = {
-- 
2.39.2


