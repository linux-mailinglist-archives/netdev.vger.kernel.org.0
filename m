Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF363F71D0
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239722AbhHYJgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239697AbhHYJgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 05:36:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C36C0613CF
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 02:35:24 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mIpJb-00048S-59
        for netdev@vger.kernel.org; Wed, 25 Aug 2021 11:35:23 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1953766F5B2
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 09:35:20 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1CC2566F596;
        Wed, 25 Aug 2021 09:35:18 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9c2f2eee;
        Wed, 25 Aug 2021 09:35:17 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Tang Bin <tangbin@cmss.chinamobile.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 3/4] can: mscan: mpc5xxx_can: mpc5xxx_can_probe(): use of_device_get_match_data to simplify code
Date:   Wed, 25 Aug 2021 11:35:15 +0200
Message-Id: <20210825093516.448231-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210825093516.448231-1-mkl@pengutronix.de>
References: <20210825093516.448231-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>

Retrieve OF match data, it's better and cleaner to use
'of_device_get_match_data' over 'of_match_device'.

Link: https://lore.kernel.org/r/20210823113338.3568-4-tangbin@cmss.chinamobile.com
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/mscan/mpc5xxx_can.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/mpc5xxx_can.c
index e254e04ae257..3b7465acd35c 100644
--- a/drivers/net/can/mscan/mpc5xxx_can.c
+++ b/drivers/net/can/mscan/mpc5xxx_can.c
@@ -279,7 +279,6 @@ static u32 mpc512x_can_get_clock(struct platform_device *ofdev,
 static const struct of_device_id mpc5xxx_can_table[];
 static int mpc5xxx_can_probe(struct platform_device *ofdev)
 {
-	const struct of_device_id *match;
 	const struct mpc5xxx_can_data *data;
 	struct device_node *np = ofdev->dev.of_node;
 	struct net_device *dev;
@@ -289,10 +288,9 @@ static int mpc5xxx_can_probe(struct platform_device *ofdev)
 	int irq, mscan_clksrc = 0;
 	int err = -ENOMEM;
 
-	match = of_match_device(mpc5xxx_can_table, &ofdev->dev);
-	if (!match)
+	data = of_device_get_match_data(&ofdev->dev);
+	if (!data)
 		return -EINVAL;
-	data = match->data;
 
 	base = of_iomap(np, 0);
 	if (!base) {
-- 
2.32.0


