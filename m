Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1063929E3
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235544AbhE0IuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235582AbhE0Itt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 04:49:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D5FC061761
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 01:48:16 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lmBgc-0001xk-L1
        for netdev@vger.kernel.org; Thu, 27 May 2021 10:48:14 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 327BC62D439
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 08:45:40 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 3913F62D3E3;
        Thu, 27 May 2021 08:45:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 6a062877;
        Thu, 27 May 2021 08:45:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Patrick Menschel <menschel.p@posteo.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 06/21] can: isotp: change error format from decimal to symbolic error names
Date:   Thu, 27 May 2021 10:45:17 +0200
Message-Id: <20210527084532.1384031-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210527084532.1384031-1-mkl@pengutronix.de>
References: <20210527084532.1384031-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Patrick Menschel <menschel.p@posteo.de>

This patch changes the format string for errors from decimal %d to
symbolic error names %pe to achieve more comprehensive log messages.

Link: https://lore.kernel.org/r/20210427052150.2308-2-menschel.p@posteo.de
Signed-off-by: Patrick Menschel <menschel.p@posteo.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 9f94ad3caee9..2c4f84fac70a 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -221,8 +221,8 @@ static int isotp_send_fc(struct sock *sk, int ae, u8 flowstatus)
 
 	can_send_ret = can_send(nskb, 1);
 	if (can_send_ret)
-		pr_notice_once("can-isotp: %s: can_send_ret %d\n",
-			       __func__, can_send_ret);
+		pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
+			       __func__, ERR_PTR(can_send_ret));
 
 	dev_put(dev);
 
@@ -798,8 +798,8 @@ static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
 
 		can_send_ret = can_send(skb, 1);
 		if (can_send_ret)
-			pr_notice_once("can-isotp: %s: can_send_ret %d\n",
-				       __func__, can_send_ret);
+			pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
+				       __func__, ERR_PTR(can_send_ret));
 
 		if (so->tx.idx >= so->tx.len) {
 			/* we are done */
@@ -946,8 +946,8 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	err = can_send(skb, 1);
 	dev_put(dev);
 	if (err) {
-		pr_notice_once("can-isotp: %s: can_send_ret %d\n",
-			       __func__, err);
+		pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
+			       __func__, ERR_PTR(err));
 		return err;
 	}
 
-- 
2.30.2


