Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C2946B8E4
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 11:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbhLGK21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 05:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235080AbhLGK2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 05:28:24 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE52EC061748
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 02:24:54 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1muXeW-0003M1-Vf
        for netdev@vger.kernel.org; Tue, 07 Dec 2021 11:24:53 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id B3F0D6BE8E3
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 10:24:46 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 519806BE8A7;
        Tue,  7 Dec 2021 10:24:43 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a5c88c68;
        Tue, 7 Dec 2021 10:24:26 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        stable@vger.kernel.org, Matt Kline <matt@bitbashing.io>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 4/9] can: m_can: m_can_read_fifo: fix memory leak in error branch
Date:   Tue,  7 Dec 2021 11:24:15 +0100
Message-Id: <20211207102420.120131-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211207102420.120131-1-mkl@pengutronix.de>
References: <20211207102420.120131-1-mkl@pengutronix.de>
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

In m_can_read_fifo(), if the second call to m_can_fifo_read() fails,
the function jump to the out_fail label and returns without calling
m_can_receive_skb(). This means that the skb previously allocated by
alloc_can_skb() is not freed. In other terms, this is a memory leak.

This patch adds a goto label to destroy the skb if an error occurs.

Issue was found with GCC -fanalyzer, please follow the link below for
details.

Fixes: e39381770ec9 ("can: m_can: Disable IRQs on FIFO bus errors")
Link: https://lore.kernel.org/all/20211107050755.70655-1-mailhol.vincent@wanadoo.fr
Cc: stable@vger.kernel.org
Cc: Matt Kline <matt@bitbashing.io>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 91be87c4f4d3..e330b4c121bf 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -517,7 +517,7 @@ static int m_can_read_fifo(struct net_device *dev, u32 rxfs)
 		err = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_DATA,
 				      cf->data, DIV_ROUND_UP(cf->len, 4));
 		if (err)
-			goto out_fail;
+			goto out_free_skb;
 	}
 
 	/* acknowledge rx fifo 0 */
@@ -532,6 +532,8 @@ static int m_can_read_fifo(struct net_device *dev, u32 rxfs)
 
 	return 0;
 
+out_free_skb:
+	kfree_skb(skb);
 out_fail:
 	netdev_err(dev, "FIFO read returned %d\n", err);
 	return err;
-- 
2.33.0


