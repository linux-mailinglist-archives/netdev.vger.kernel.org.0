Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8AEE650F5F
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 16:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbiLSPyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 10:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbiLSPxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 10:53:35 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA2713E3D
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 07:52:15 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p7IR4-0001w6-AO
        for netdev@vger.kernel.org; Mon, 19 Dec 2022 16:52:14 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id B297F143225
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 15:52:13 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 15C8514320B;
        Mon, 19 Dec 2022 15:52:12 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id fdbba17d;
        Mon, 19 Dec 2022 15:52:11 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Haibo Chen <haibo.chen@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 2/3] can: flexcan: avoid unbalanced pm_runtime_enable warning
Date:   Mon, 19 Dec 2022 16:52:09 +0100
Message-Id: <20221219155210.1143439-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221219155210.1143439-1-mkl@pengutronix.de>
References: <20221219155210.1143439-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

When do suspend/resume, meet the following warning message:
[   30.028336] flexcan 425b0000.can: Unbalanced pm_runtime_enable!

Balance the pm_runtime_force_suspend() and pm_runtime_force_resume().

Fixes: 8cb53b485f18 ("can: flexcan: add auto stop mode for IMX93 to support wakeup")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://lore.kernel.org/all/20221213094351.3023858-1-haibo.chen@nxp.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan/flexcan-core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/flexcan/flexcan-core.c b/drivers/net/can/flexcan/flexcan-core.c
index 0aeff34e5ae1..6d638c93977b 100644
--- a/drivers/net/can/flexcan/flexcan-core.c
+++ b/drivers/net/can/flexcan/flexcan-core.c
@@ -2349,9 +2349,15 @@ static int __maybe_unused flexcan_noirq_resume(struct device *device)
 	if (netif_running(dev)) {
 		int err;
 
-		err = pm_runtime_force_resume(device);
-		if (err)
-			return err;
+		/* For the wakeup in auto stop mode, no need to gate on the
+		 * clock here, hardware will do this automatically.
+		 */
+		if (!(device_may_wakeup(device) &&
+		      priv->devtype_data.quirks & FLEXCAN_QUIRK_AUTO_STOP_MODE)) {
+			err = pm_runtime_force_resume(device);
+			if (err)
+				return err;
+		}
 
 		if (device_may_wakeup(device))
 			flexcan_enable_wakeup_irq(priv, false);
-- 
2.35.1


