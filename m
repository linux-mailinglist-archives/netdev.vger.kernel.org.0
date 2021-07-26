Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1123D5B39
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234727AbhGZNdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234778AbhGZNcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:32:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F54C061254
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:23 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81LC-0001dT-0D
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:22 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A14AF65822B
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:12:07 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 8672965819C;
        Mon, 26 Jul 2021 14:11:52 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id bbde9fb4;
        Mon, 26 Jul 2021 14:11:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>
Subject: [PATCH net-next 16/46] can: m_can: remove support for custom bit timing
Date:   Mon, 26 Jul 2021 16:11:14 +0200
Message-Id: <20210726141144.862529-17-mkl@pengutronix.de>
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

Since commit aee2b3ccc8a6 ("can: tcan4x5x: fix bittiming const, use
common bittiming from m_can driver") there is no use of the device
specific bit timing parameters (m_can_classdev::bit_timing and struct
m_can_classdev::data_timing).

This patch removes the support for custom bit timing from the driver,
as the common bit timing works for all known IP core implementations.

Cc: Chandrasekar Ramakrishnan <rcsekar@samsung.com>
Link: https://lore.kernel.org/r/20210616102811.2449426-7-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 24 ++++++------------------
 drivers/net/can/m_can/m_can.h |  3 ---
 2 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index c430432c28ec..0cffaad905c2 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1440,32 +1440,20 @@ static int m_can_dev_setup(struct m_can_classdev *cdev)
 	case 30:
 		/* CAN_CTRLMODE_FD_NON_ISO is fixed with M_CAN IP v3.0.x */
 		can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
-		cdev->can.bittiming_const = cdev->bit_timing ?
-			cdev->bit_timing : &m_can_bittiming_const_30X;
-
-		cdev->can.data_bittiming_const = cdev->data_timing ?
-			cdev->data_timing :
-			&m_can_data_bittiming_const_30X;
+		cdev->can.bittiming_const = &m_can_bittiming_const_30X;
+		cdev->can.data_bittiming_const = &m_can_data_bittiming_const_30X;
 		break;
 	case 31:
 		/* CAN_CTRLMODE_FD_NON_ISO is fixed with M_CAN IP v3.1.x */
 		can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
-		cdev->can.bittiming_const = cdev->bit_timing ?
-			cdev->bit_timing : &m_can_bittiming_const_31X;
-
-		cdev->can.data_bittiming_const = cdev->data_timing ?
-			cdev->data_timing :
-			&m_can_data_bittiming_const_31X;
+		cdev->can.bittiming_const = &m_can_bittiming_const_31X;
+		cdev->can.data_bittiming_const = &m_can_data_bittiming_const_31X;
 		break;
 	case 32:
 	case 33:
 		/* Support both MCAN version v3.2.x and v3.3.0 */
-		cdev->can.bittiming_const = cdev->bit_timing ?
-			cdev->bit_timing : &m_can_bittiming_const_31X;
-
-		cdev->can.data_bittiming_const = cdev->data_timing ?
-			cdev->data_timing :
-			&m_can_data_bittiming_const_31X;
+		cdev->can.bittiming_const = &m_can_bittiming_const_31X;
+		cdev->can.data_bittiming_const = &m_can_data_bittiming_const_31X;
 
 		cdev->can.ctrlmode_supported |=
 			(m_can_niso_supported(cdev) ?
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index 38cad068abad..56e994376a7b 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -85,9 +85,6 @@ struct m_can_classdev {
 	struct sk_buff *tx_skb;
 	struct phy *transceiver;
 
-	struct can_bittiming_const *bit_timing;
-	struct can_bittiming_const *data_timing;
-
 	struct m_can_ops *ops;
 
 	int version;
-- 
2.30.2


