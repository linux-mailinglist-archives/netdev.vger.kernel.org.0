Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11CC3F829D
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 08:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239661AbhHZGpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 02:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239344AbhHZGps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 02:45:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB5FC0613D9
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 23:45:01 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mJ98G-0008Kj-9p
        for netdev@vger.kernel.org; Thu, 26 Aug 2021 08:45:00 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 7B41766FF66
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:44:59 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id CA77666FF5A;
        Thu, 26 Aug 2021 06:44:57 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d093c18f;
        Thu, 26 Aug 2021 06:44:57 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net] can: usb: esd_usb2: esd_usb2_rx_event(): fix the interchange of the CAN RX and TX error counters
Date:   Thu, 26 Aug 2021 08:44:56 +0200
Message-Id: <20210826064456.1427513-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210826064456.1427513-1-mkl@pengutronix.de>
References: <20210826064456.1427513-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Mätje <stefan.maetje@esd.eu>

This patch fixes the interchanged fetch of the CAN RX and TX error
counters from the ESD_EV_CAN_ERROR_EXT message. The RX error counter
is really in struct rx_msg::data[2] and the TX error counter is in
struct rx_msg::data[3].

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Link: https://lore.kernel.org/r/20210825215227.4947-2-stefan.maetje@esd.eu
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Mätje <stefan.maetje@esd.eu>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/esd_usb2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 66fa8b07c2e6..95ae740fc311 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -224,8 +224,8 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 	if (id == ESD_EV_CAN_ERROR_EXT) {
 		u8 state = msg->msg.rx.data[0];
 		u8 ecc = msg->msg.rx.data[1];
-		u8 txerr = msg->msg.rx.data[2];
-		u8 rxerr = msg->msg.rx.data[3];
+		u8 rxerr = msg->msg.rx.data[2];
+		u8 txerr = msg->msg.rx.data[3];
 
 		skb = alloc_can_err_skb(priv->netdev, &cf);
 		if (skb == NULL) {

base-commit: ec92e524ee91c98e6ee06807c7d69d9e2fd141bc
-- 
2.32.0


