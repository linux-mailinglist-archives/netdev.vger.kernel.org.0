Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3CF269AD6D
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 15:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjBQOKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 09:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjBQOKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 09:10:37 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46916B303
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 06:10:35 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pT1Ra-0002yL-Cf
        for netdev@vger.kernel.org; Fri, 17 Feb 2023 15:10:34 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 25ABF17C162
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:10:33 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6EA4317C141;
        Fri, 17 Feb 2023 14:10:31 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 99c69299;
        Fri, 17 Feb 2023 14:10:30 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Frank Jungclaus <frank.jungclaus@esd.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 4/4] can: esd_usb: Improve readability on decoding ESD_EV_CAN_ERROR_EXT messages
Date:   Fri, 17 Feb 2023 15:10:29 +0100
Message-Id: <20230217141029.3734802-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230217141029.3734802-1-mkl@pengutronix.de>
References: <20230217141029.3734802-1-mkl@pengutronix.de>
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

From: Frank Jungclaus <frank.jungclaus@esd.eu>

As suggested by Marc introduce a union plus a struct ev_can_err_ext
for easier decoding of an ESD_EV_CAN_ERROR_EXT event message (which
simply is a rx_msg with some dedicated data).

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/linux-can/20220621071152.ggyhrr5sbzvwpkpx@pengutronix.de/
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
Link: https://lore.kernel.org/all/20230216190450.3901254-4-frank.jungclaus@esd.eu
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/esd_usb.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 578b25f873e5..55b36973952d 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -127,7 +127,15 @@ struct rx_msg {
 	u8 dlc;
 	__le32 ts;
 	__le32 id; /* upper 3 bits contain flags */
-	u8 data[8];
+	union {
+		u8 data[8];
+		struct {
+			u8 status; /* CAN Controller Status */
+			u8 ecc;    /* Error Capture Register */
+			u8 rec;    /* RX Error Counter */
+			u8 tec;    /* TX Error Counter */
+		} ev_can_err_ext;  /* For ESD_EV_CAN_ERROR_EXT */
+	};
 };
 
 struct tx_msg {
@@ -229,10 +237,10 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 	u32 id = le32_to_cpu(msg->msg.rx.id) & ESD_IDMASK;
 
 	if (id == ESD_EV_CAN_ERROR_EXT) {
-		u8 state = msg->msg.rx.data[0];
-		u8 ecc = msg->msg.rx.data[1];
-		u8 rxerr = msg->msg.rx.data[2];
-		u8 txerr = msg->msg.rx.data[3];
+		u8 state = msg->msg.rx.ev_can_err_ext.status;
+		u8 ecc = msg->msg.rx.ev_can_err_ext.ecc;
+		u8 rxerr = msg->msg.rx.ev_can_err_ext.rec;
+		u8 txerr = msg->msg.rx.ev_can_err_ext.tec;
 
 		netdev_dbg(priv->netdev,
 			   "CAN_ERR_EV_EXT: dlc=%#02x state=%02x ecc=%02x rec=%02x tec=%02x\n",
-- 
2.39.1


