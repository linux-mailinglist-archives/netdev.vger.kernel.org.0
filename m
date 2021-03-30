Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F9D34E6B6
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbhC3LrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbhC3Lqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB16C061762
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:38 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCpQ-0006GE-QN
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:36 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1CC56603E87
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:21 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 10EF0603E13;
        Tue, 30 Mar 2021 11:46:09 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9abfcafd;
        Tue, 30 Mar 2021 11:46:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Torin Cooper-Bennun <torin@maxiluxsystems.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 19/39] can: m_can: m_can_chip_config(): enable and configure internal timestamps
Date:   Tue, 30 Mar 2021 13:45:39 +0200
Message-Id: <20210330114559.1114855-20-mkl@pengutronix.de>
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

From: Torin Cooper-Bennun <torin@maxiluxsystems.com>

This is a prerequisite for transitioning the m_can driver to rx-offload,
which works best with TX and RX timestamps.

The timestamps provided by M_CAN are 16-bit, timed according to the
nominal bit timing, and may be prescaled by a multiplier up to 16. We
choose the highest prescalar so that the timestamp wraps every 2^20 bit
times, or 209 ms at a bus speed of 5 Mbit/s. Timestamps will have a
precision of 16 bit times.

Link: https://lore.kernel.org/r/20210308102427.63916-3-torin@maxiluxsystems.com
Signed-off-by: Torin Cooper-Bennun <torin@maxiluxsystems.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 9f7cfe91f7ff..7df81e38b043 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1135,6 +1135,7 @@ static int m_can_set_bittiming(struct net_device *dev)
  *		- >= v3.1.x: TX FIFO is used
  * - configure mode
  * - setup bittiming
+ * - configure timestamp generation
  */
 static void m_can_chip_config(struct net_device *dev)
 {
@@ -1246,6 +1247,10 @@ static void m_can_chip_config(struct net_device *dev)
 	/* set bittiming params */
 	m_can_set_bittiming(dev);
 
+	/* enable internal timestamp generation, with a prescalar of 16. The
+	 * prescalar is applied to the nominal bit timing */
+	m_can_write(cdev, M_CAN_TSCC, FIELD_PREP(TSCC_TCP_MASK, 0xf));
+
 	m_can_config_endisable(cdev, false);
 
 	if (cdev->ops->init)
-- 
2.30.2


