Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DCB3D5B62
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhGZNeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234828AbhGZNde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:33:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E8BC0619EB
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:48 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81La-0002S2-Gf
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:46 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A7CB46582EB
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:12:27 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 3188E658225;
        Mon, 26 Jul 2021 14:12:07 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id e9c93aad;
        Mon, 26 Jul 2021 14:11:47 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 42/46] can: etas_es58x: use sizeof and sizeof_field macros instead of constant values
Date:   Mon, 26 Jul 2021 16:11:40 +0200
Message-Id: <20210726141144.862529-43-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726141144.862529-1-mkl@pengutronix.de>
References: <20210726141144.862529-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Replace two constant values by a call to sizeof{,_field} on the
relevant field to make the logic easier to understand.

Link: https://lore.kernel.org/r/20210628155420.1176217-6-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/etas_es58x/es581_4.c    | 2 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es581_4.c b/drivers/net/can/usb/etas_es58x/es581_4.c
index 1985f772fc3c..88dbfe41ba85 100644
--- a/drivers/net/can/usb/etas_es58x/es581_4.c
+++ b/drivers/net/can/usb/etas_es58x/es581_4.c
@@ -355,7 +355,7 @@ static int es581_4_tx_can_msg(struct es58x_priv *priv,
 		return -EMSGSIZE;
 
 	if (priv->tx_can_msg_cnt == 0) {
-		msg_len = 1; /* struct es581_4_bulk_tx_can_msg:num_can_msg */
+		msg_len = sizeof(es581_4_urb_cmd->bulk_tx_can_msg.num_can_msg);
 		es581_4_fill_urb_header(urb_cmd, ES581_4_CAN_COMMAND_TYPE,
 					ES581_4_CMD_ID_TX_MSG,
 					priv->channel_idx, msg_len);
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 126e4d57332e..96a13c770e4a 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -70,7 +70,7 @@ MODULE_DEVICE_TABLE(usb, es58x_id_table);
  * bytes (the start of frame) are skipped and the CRC calculation
  * starts on the third byte.
  */
-#define ES58X_CRC_CALC_OFFSET 2
+#define ES58X_CRC_CALC_OFFSET sizeof_field(union es58x_urb_cmd, sof)
 
 /**
  * es58x_calculate_crc() - Compute the crc16 of a given URB.
-- 
2.30.2


