Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4211D514A0E
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 14:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359616AbiD2M7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 08:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359606AbiD2M7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 08:59:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8E2C9B74
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 05:56:20 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nkQAU-0000Ad-NY
        for netdev@vger.kernel.org; Fri, 29 Apr 2022 14:56:18 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3267670F0B
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 12:56:14 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D3B5670EE6;
        Fri, 29 Apr 2022 12:56:13 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id fde4f1a0;
        Fri, 29 Apr 2022 12:56:13 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Andreas Larsson <andreas@gaisler.com>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 4/5] can: grcan: grcan_probe(): fix broken system id check for errata workaround needs
Date:   Fri, 29 Apr 2022 14:56:11 +0200
Message-Id: <20220429125612.1792561-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429125612.1792561-1-mkl@pengutronix.de>
References: <20220429125612.1792561-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andreas Larsson <andreas@gaisler.com>

The systemid property was checked for in the wrong place of the device
tree and compared to the wrong value.

Fixes: 6cec9b07fe6a ("can: grcan: Add device driver for GRCAN and GRHCAN cores")
Link: https://lore.kernel.org/all/20220429084656.29788-3-andreas@gaisler.com
Cc: stable@vger.kernel.org
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/grcan.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index f8860900575b..4ca3da56d3aa 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -241,7 +241,7 @@ struct grcan_device_config {
 		.rxsize		= GRCAN_DEFAULT_BUFFER_SIZE,	\
 		}
 
-#define GRCAN_TXBUG_SAFE_GRLIB_VERSION	0x4100
+#define GRCAN_TXBUG_SAFE_GRLIB_VERSION	4100
 #define GRLIB_VERSION_MASK		0xffff
 
 /* GRCAN private data structure */
@@ -1643,6 +1643,7 @@ static int grcan_setup_netdev(struct platform_device *ofdev,
 static int grcan_probe(struct platform_device *ofdev)
 {
 	struct device_node *np = ofdev->dev.of_node;
+	struct device_node *sysid_parent;
 	u32 sysid, ambafreq;
 	int irq, err;
 	void __iomem *base;
@@ -1651,10 +1652,15 @@ static int grcan_probe(struct platform_device *ofdev)
 	/* Compare GRLIB version number with the first that does not
 	 * have the tx bug (see start_xmit)
 	 */
-	err = of_property_read_u32(np, "systemid", &sysid);
-	if (!err && ((sysid & GRLIB_VERSION_MASK)
-		     >= GRCAN_TXBUG_SAFE_GRLIB_VERSION))
-		txbug = false;
+	sysid_parent = of_find_node_by_path("/ambapp0");
+	if (sysid_parent) {
+		of_node_get(sysid_parent);
+		err = of_property_read_u32(sysid_parent, "systemid", &sysid);
+		if (!err && ((sysid & GRLIB_VERSION_MASK) >=
+			     GRCAN_TXBUG_SAFE_GRLIB_VERSION))
+			txbug = false;
+		of_node_put(sysid_parent);
+	}
 
 	err = of_property_read_u32(np, "freq", &ambafreq);
 	if (err) {
-- 
2.35.1


