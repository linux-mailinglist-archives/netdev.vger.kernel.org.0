Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3801346B8E8
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 11:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235146AbhLGK2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 05:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235084AbhLGK20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 05:28:26 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FF0C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 02:24:56 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1muXeY-0003NT-Am
        for netdev@vger.kernel.org; Tue, 07 Dec 2021 11:24:54 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1D4EC6BE8ED
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 10:24:47 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D8F896BE8B0;
        Tue,  7 Dec 2021 10:24:43 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5b4a957b;
        Tue, 7 Dec 2021 10:24:27 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 7/9] Revert "can: m_can: remove support for custom bit timing"
Date:   Tue,  7 Dec 2021 11:24:18 +0100
Message-Id: <20211207102420.120131-8-mkl@pengutronix.de>
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

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

The timing limits specified by the Elkhart Lake CPU datasheets do not
match the defaults. Let's reintroduce the support for custom bit timings.

This reverts commit 0ddd83fbebbc5537f9d180d31f659db3564be708.

Link: https://lore.kernel.org/all/00c9e2596b1a548906921a574d4ef7a03c0dace0.1636967198.git.matthias.schiffer@ew.tq-group.com
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 24 ++++++++++++++++++------
 drivers/net/can/m_can/m_can.h |  3 +++
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index e330b4c121bf..c2a8421e7845 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1494,20 +1494,32 @@ static int m_can_dev_setup(struct m_can_classdev *cdev)
 	case 30:
 		/* CAN_CTRLMODE_FD_NON_ISO is fixed with M_CAN IP v3.0.x */
 		can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
-		cdev->can.bittiming_const = &m_can_bittiming_const_30X;
-		cdev->can.data_bittiming_const = &m_can_data_bittiming_const_30X;
+		cdev->can.bittiming_const = cdev->bit_timing ?
+			cdev->bit_timing : &m_can_bittiming_const_30X;
+
+		cdev->can.data_bittiming_const = cdev->data_timing ?
+			cdev->data_timing :
+			&m_can_data_bittiming_const_30X;
 		break;
 	case 31:
 		/* CAN_CTRLMODE_FD_NON_ISO is fixed with M_CAN IP v3.1.x */
 		can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
-		cdev->can.bittiming_const = &m_can_bittiming_const_31X;
-		cdev->can.data_bittiming_const = &m_can_data_bittiming_const_31X;
+		cdev->can.bittiming_const = cdev->bit_timing ?
+			cdev->bit_timing : &m_can_bittiming_const_31X;
+
+		cdev->can.data_bittiming_const = cdev->data_timing ?
+			cdev->data_timing :
+			&m_can_data_bittiming_const_31X;
 		break;
 	case 32:
 	case 33:
 		/* Support both MCAN version v3.2.x and v3.3.0 */
-		cdev->can.bittiming_const = &m_can_bittiming_const_31X;
-		cdev->can.data_bittiming_const = &m_can_data_bittiming_const_31X;
+		cdev->can.bittiming_const = cdev->bit_timing ?
+			cdev->bit_timing : &m_can_bittiming_const_31X;
+
+		cdev->can.data_bittiming_const = cdev->data_timing ?
+			cdev->data_timing :
+			&m_can_data_bittiming_const_31X;
 
 		cdev->can.ctrlmode_supported |=
 			(m_can_niso_supported(cdev) ?
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index d18b515e6ccc..ad063b101411 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -85,6 +85,9 @@ struct m_can_classdev {
 	struct sk_buff *tx_skb;
 	struct phy *transceiver;
 
+	struct can_bittiming_const *bit_timing;
+	struct can_bittiming_const *data_timing;
+
 	struct m_can_ops *ops;
 
 	int version;
-- 
2.33.0


