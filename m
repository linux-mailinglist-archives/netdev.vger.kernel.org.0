Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B053D5B63
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbhGZNeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234832AbhGZNde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:33:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF3CC0619EE
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:48 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81La-0002R3-II
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:46 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1BCBC6582E0
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:12:28 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C045965822E;
        Mon, 26 Jul 2021 14:12:07 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 8b54286c;
        Mon, 26 Jul 2021 14:11:47 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 43/46] can: etas_es58x: rewrite the message cast in es58{1,_fd}_tx_can_msg to increase readability
Date:   Mon, 26 Jul 2021 16:11:41 +0200
Message-Id: <20210726141144.862529-44-mkl@pengutronix.de>
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

The es581_tx_can_msg() does below cast:
|	tx_can_msg = (struct es581_4_tx_can_msg *)
|	    &es581_4_urb_cmd->bulk_tx_can_msg.tx_can_msg_buf[msg_len - 1];

The -1 offset is to skip the first member of struct
es581_4_tx_can_msg. However, es581_4_urb_cmd already has a raw_msg
field which can be used instead without the use of an offset
calculation.

The function es58x_fd_tx_can_msg() is also modified to mirror
es581_tx_can_msg().

Link: https://lore.kernel.org/r/20210628155420.1176217-7-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/etas_es58x/es581_4.c  | 3 +--
 drivers/net/can/usb/etas_es58x/es58x_fd.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es581_4.c b/drivers/net/can/usb/etas_es58x/es581_4.c
index 88dbfe41ba85..14e360c9f2c9 100644
--- a/drivers/net/can/usb/etas_es58x/es581_4.c
+++ b/drivers/net/can/usb/etas_es58x/es581_4.c
@@ -371,8 +371,7 @@ static int es581_4_tx_can_msg(struct es58x_priv *priv,
 		return ret;
 
 	/* Fill message contents. */
-	tx_can_msg = (struct es581_4_tx_can_msg *)
-	    &es581_4_urb_cmd->bulk_tx_can_msg.tx_can_msg_buf[msg_len - 1];
+	tx_can_msg = (typeof(tx_can_msg))&es581_4_urb_cmd->raw_msg[msg_len];
 	put_unaligned_le32(es58x_get_raw_can_id(cf), &tx_can_msg->can_id);
 	put_unaligned_le32(priv->tx_head, &tx_can_msg->packet_idx);
 	put_unaligned_le16((u16)es58x_get_flags(skb), &tx_can_msg->flags);
diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.c b/drivers/net/can/usb/etas_es58x/es58x_fd.c
index e8a77d136165..af042aa55f59 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_fd.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_fd.c
@@ -357,8 +357,7 @@ static int es58x_fd_tx_can_msg(struct es58x_priv *priv,
 		return ret;
 
 	/* Fill message contents. */
-	tx_can_msg = (struct es58x_fd_tx_can_msg *)
-	    &es58x_fd_urb_cmd->tx_can_msg_buf[msg_len];
+	tx_can_msg = (typeof(tx_can_msg))&es58x_fd_urb_cmd->raw_msg[msg_len];
 	tx_can_msg->packet_idx = (u8)priv->tx_head;
 	put_unaligned_le32(es58x_get_raw_can_id(cf), &tx_can_msg->can_id);
 	tx_can_msg->flags = (u8)es58x_get_flags(skb);
-- 
2.30.2


