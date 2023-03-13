Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0E36B7437
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 11:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjCMKhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 06:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjCMKhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 06:37:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8205B5C7
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 03:37:08 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY2-0008Sw-2T; Mon, 13 Mar 2023 11:36:58 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfY0-003pKU-G2; Mon, 13 Mar 2023 11:36:56 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pbfXz-004W3X-Sk; Mon, 13 Mar 2023 11:36:55 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH net-next 1/9] net: dpaa: Improve error reporting
Date:   Mon, 13 Mar 2023 11:36:45 +0100
Message-Id: <20230313103653.2753139-2-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
References: <20230313103653.2753139-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1460; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=HRAv2vE0At1EkTYyhbi8BdPRV0qfZrRgP3IEO0J+5+E=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBkDvylIj8vaQohZCbDovqwGFDSjGm2ueZYG3zed ggoSuuVq6CJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCZA78pQAKCRDB/BR4rcrs CV4eB/0bbYhAIw1NmfEN+oCs9HTWtMdXadInVbFr+dccURaM2+v+1PRoerlmiVHke9ZXpPUvaV+ hEnJbqMvqNMIWMQM/+pO3+ws1cSUUIN/0rdFR9YI3mt2QlGrxqmxOAYD24Wuf8a6/MSMlHsJR4n Ibxhj92UWWF1Y93WB9Z3p61R1NbiMVy5wNA6xERZnBUe3mQlLnaxvAfrUO/YjOQoABuAQ2ppCYm F5fEH/KFEnkmZiN9gbjptof3Ai0YDI1/kS7sTPCN2PilhL0VBkrTs/kwfSZAQXOYVtBhw2uyzny WiC5wmk6PpNYqRZNKAg0rHB1clMd070oR9TleSKbMD2uLCeO
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

Instead of the generic error message emitted by the driver core when a
remove callback returns an error code ("remove callback returned a
non-zero value. This will be ignored."), emit a message describing the
actual problem and return zero to suppress the generic message.

Note that apart from suppressing the generic error message there are no
side effects by changing the return value to zero. This prepares
changing the remove callback to return void.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 9318a2554056..97cad3750096 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -3520,6 +3520,8 @@ static int dpaa_remove(struct platform_device *pdev)
 	phylink_destroy(priv->mac_dev->phylink);
 
 	err = dpaa_fq_free(dev, &priv->dpaa_fq_list);
+	if (err)
+		dev_err(&pdev->dev, "Failed to free FQs on remove\n");
 
 	qman_delete_cgr_safe(&priv->ingress_cgr);
 	qman_release_cgrid(priv->ingress_cgr.cgrid);
@@ -3532,7 +3534,7 @@ static int dpaa_remove(struct platform_device *pdev)
 
 	free_netdev(net_dev);
 
-	return err;
+	return 0;
 }
 
 static const struct platform_device_id dpaa_devtype[] = {
-- 
2.39.1

