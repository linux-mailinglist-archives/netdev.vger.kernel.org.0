Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D0368BDA2
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjBFNRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjBFNRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:17:21 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C2215CBA
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:19 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1N0-0007PZ-1d
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:18 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 12596171508
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:29 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A727117131B;
        Mon,  6 Feb 2023 13:16:24 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 6888d7bc;
        Mon, 6 Feb 2023 13:16:23 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 38/47] can: netlink: can_changelink(): convert from netdev_err() to NL_SET_ERR_MSG_FMT()
Date:   Mon,  6 Feb 2023 14:16:11 +0100
Message-Id: <20230206131620.2758724-39-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230206131620.2758724-1-mkl@pengutronix.de>
References: <20230206131620.2758724-1-mkl@pengutronix.de>
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

Since commit 51c352bdbcd2 ("netlink: add support for formatted extack
messages") formatted extack messages are supported to inform the user
space or warnings/errors during netlink calls.

Replace the netdev_err() by NL_SET_ERR_MSG_FMT() to better inform the
user about the problem. While there, use %u to print unsigned values
and improve error message a bit.

Link: https://lore.kernel.org/all/20230202110854.2318594-9-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/netlink.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 02f5c00c521f..a03b45a020b9 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -220,8 +220,9 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 			return err;
 
 		if (priv->bitrate_max && bt.bitrate > priv->bitrate_max) {
-			netdev_err(dev, "arbitration bitrate surpasses transceiver capabilities of %d bps\n",
-				   priv->bitrate_max);
+			NL_SET_ERR_MSG_FMT(extack,
+					   "arbitration bitrate %u bps surpasses transceiver capabilities of %u bps",
+					   bt.bitrate, priv->bitrate_max);
 			return -EINVAL;
 		}
 
@@ -324,8 +325,9 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 			return err;
 
 		if (priv->bitrate_max && dbt.bitrate > priv->bitrate_max) {
-			netdev_err(dev, "canfd data bitrate surpasses transceiver capabilities of %d bps\n",
-				   priv->bitrate_max);
+			NL_SET_ERR_MSG_FMT(extack,
+					   "CANFD data bitrate %u bps surpasses transceiver capabilities of %u bps",
+					   dbt.bitrate, priv->bitrate_max);
 			return -EINVAL;
 		}
 
-- 
2.39.1


