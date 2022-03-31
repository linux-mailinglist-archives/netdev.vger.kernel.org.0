Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195994ED615
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 10:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbiCaIs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 04:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233207AbiCaIs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 04:48:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0621F89F1
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 01:46:40 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nZqRy-0000CU-Vz
        for netdev@vger.kernel.org; Thu, 31 Mar 2022 10:46:39 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 98BA4579F2
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 08:46:35 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 447F1579CE;
        Thu, 31 Mar 2022 08:46:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id bd87bcca;
        Thu, 31 Mar 2022 08:46:35 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH net 3/8] can: m_can: m_can_tx_handler(): fix use after free of skb
Date:   Thu, 31 Mar 2022 10:46:29 +0200
Message-Id: <20220331084634.869744-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220331084634.869744-1-mkl@pengutronix.de>
References: <20220331084634.869744-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

can_put_echo_skb() will clone skb then free the skb. Move the
can_put_echo_skb() for the m_can version 3.0.x directly before the
start of the xmit in hardware, similar to the 3.1.x branch.

Fixes: 80646733f11c ("can: m_can: update to support CAN FD features")
Link: https://lore.kernel.org/all/20220317081305.739554-1-mkl@pengutronix.de
Cc: stable@vger.kernel.org
Reported-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 1a4b56f6fa8c..b3b5bc1c803b 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1637,8 +1637,6 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 		if (err)
 			goto out_fail;
 
-		can_put_echo_skb(skb, dev, 0, 0);
-
 		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD) {
 			cccr = m_can_read(cdev, M_CAN_CCCR);
 			cccr &= ~CCCR_CMR_MASK;
@@ -1655,6 +1653,9 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 			m_can_write(cdev, M_CAN_CCCR, cccr);
 		}
 		m_can_write(cdev, M_CAN_TXBTIE, 0x1);
+
+		can_put_echo_skb(skb, dev, 0, 0);
+
 		m_can_write(cdev, M_CAN_TXBAR, 0x1);
 		/* End of xmit function for version 3.0.x */
 	} else {
-- 
2.35.1


