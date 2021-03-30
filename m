Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E9D34E6CF
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbhC3Lr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbhC3Lqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBA5C0613DD
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:51 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCpd-0006cP-V0
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:50 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2B7CD603F16
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:38 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E5DAD603E5B;
        Tue, 30 Mar 2021 11:46:16 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2e581b62;
        Tue, 30 Mar 2021 11:46:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Dario Binacchi <dariobin@libero.it>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 36/39] can: c_can: add a comment about IF_RX interface's use
Date:   Tue, 30 Mar 2021 13:45:56 +0200
Message-Id: <20210330114559.1114855-37-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dario Binacchi <dariobin@libero.it>

After reading the commit 640916db2bf7 ("can: c_can: Make it SMP safe")
it may sound strange to see the IF_RX interface used by the
can_inval_tx_object function. A comment was added to avoid any
misunderstanding.

Link: https://lore.kernel.org/r/20210302215435.18286-4-dariobin@libero.it
Signed-off-by: Dario Binacchi <dariobin@libero.it>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/c_can/c_can.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 8212f3d98aa9..980abf6a8609 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -710,6 +710,11 @@ static void c_can_do_tx(struct net_device *dev)
 		idx--;
 		pend &= ~(1 << idx);
 		obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
+
+		/* We use IF_RX interface instead of IF_TX because we
+		 * are called from c_can_poll(), which runs inside
+		 * NAPI. We are not trasmitting.
+		 */
 		c_can_inval_tx_object(dev, IF_RX, obj);
 		can_get_echo_skb(dev, idx, NULL);
 		bytes += priv->dlc[idx];
-- 
2.30.2


