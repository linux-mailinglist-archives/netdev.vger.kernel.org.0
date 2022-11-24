Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6FC1637FE5
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 20:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiKXT5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 14:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiKXT5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 14:57:19 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD69091C2A
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 11:57:16 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oyILS-0004fr-W7
        for netdev@vger.kernel.org; Thu, 24 Nov 2022 20:57:15 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1A71C128986
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 19:57:13 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 282AB128948;
        Thu, 24 Nov 2022 19:57:10 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id db7339f2;
        Thu, 24 Nov 2022 19:57:09 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Arunachalam Santhanam <Arunachalam.Santhanam@in.bosch.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 5/8] can: etas_es58x: es58x_init_netdev(): free netdev when register_candev()
Date:   Thu, 24 Nov 2022 20:57:05 +0100
Message-Id: <20221124195708.1473369-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221124195708.1473369-1-mkl@pengutronix.de>
References: <20221124195708.1473369-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

In case of register_candev() fails, clear
es58x_dev->netdev[channel_idx] and add free_candev(). Otherwise
es58x_free_netdevs() will unregister the netdev that has never been
registered.

Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Arunachalam Santhanam <Arunachalam.Santhanam@in.bosch.com>
Acked-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/1668413685-23354-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 25f863b4f5f0..ddb7c5735c9a 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2091,8 +2091,11 @@ static int es58x_init_netdev(struct es58x_device *es58x_dev, int channel_idx)
 	netdev->dev_port = channel_idx;
 
 	ret = register_candev(netdev);
-	if (ret)
+	if (ret) {
+		es58x_dev->netdev[channel_idx] = NULL;
+		free_candev(netdev);
 		return ret;
+	}
 
 	netdev_queue_set_dql_min_limit(netdev_get_tx_queue(netdev, 0),
 				       es58x_dev->param->dql_min_limit);
-- 
2.35.1


