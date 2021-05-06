Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFE9375050
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 09:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbhEFHle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 03:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbhEFHlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 03:41:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80EEFC061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 00:40:25 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1leYcS-0003Dr-18
        for netdev@vger.kernel.org; Thu, 06 May 2021 09:40:24 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 8FB8B61DD92
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 07:40:22 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 78BB061DD74;
        Thu,  6 May 2021 07:40:18 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2c17e4ff;
        Thu, 6 May 2021 07:40:17 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Torin Cooper-Bennun <torin@maxiluxsystems.com>
Subject: [net 4/4] can: m_can: m_can_tx_work_queue(): fix tx_skb race condition
Date:   Thu,  6 May 2021 09:40:15 +0200
Message-Id: <20210506074015.1300591-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210506074015.1300591-1-mkl@pengutronix.de>
References: <20210506074015.1300591-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The m_can_start_xmit() function checks if the cdev->tx_skb is NULL and
returns with NETDEV_TX_BUSY in case tx_sbk is not NULL.

There is a race condition in the m_can_tx_work_queue(), where first
the skb is send to the driver and then the case tx_sbk is set to NULL.
A TX complete IRQ might come in between and wake the queue, which
results in tx_skb not being cleared yet.

Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
Tested-by: Torin Cooper-Bennun <torin@maxiluxsystems.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 34073cd077e4..3cf6de21d19c 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1562,6 +1562,8 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 	int i;
 	int putidx;
 
+	cdev->tx_skb = NULL;
+
 	/* Generate ID field for TX buffer Element */
 	/* Common to all supported M_CAN versions */
 	if (cf->can_id & CAN_EFF_FLAG) {
@@ -1678,7 +1680,6 @@ static void m_can_tx_work_queue(struct work_struct *ws)
 						   tx_work);
 
 	m_can_tx_handler(cdev);
-	cdev->tx_skb = NULL;
 }
 
 static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
-- 
2.30.2


