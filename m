Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E4352738C
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 20:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbiENS5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 14:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234771AbiENS5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 14:57:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE06227140
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 11:57:47 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1npwxW-0001zk-97
        for netdev@vger.kernel.org; Sat, 14 May 2022 20:57:46 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 50A007E3DD
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 18:57:45 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C31B47E3CE;
        Sat, 14 May 2022 18:57:44 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 09835300;
        Sat, 14 May 2022 18:57:43 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 2/2] can: m_can: remove support for custom bit timing, take #2
Date:   Sat, 14 May 2022 20:57:42 +0200
Message-Id: <20220514185742.407230-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514185742.407230-1-mkl@pengutronix.de>
References: <20220514185742.407230-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

Now when Intel Elkhart Lake uses again common bit timing and there are
no other users for custom bit timing, we can bring back the changes
done by the commit 0ddd83fbebbc ("can: m_can: remove support for
custom bit timing").

This effectively reverts commit ea768b2ffec6 ("Revert "can: m_can:
remove support for custom bit timing"") while taking into account
commit ea22ba40debe ("can: m_can: make custom bittiming fields const")
and commit 7d4a101c0bd3 ("can: dev: add sanity check in
can_set_static_ctrlmode()").

Link: https://lore.kernel.org/all/20220512124144.536850-2-jarkko.nikula@linux.intel.com
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 24 ++++++------------------
 drivers/net/can/m_can/m_can.h |  3 ---
 2 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index b3b5bc1c803b..088bb1bcf1ef 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1495,34 +1495,22 @@ static int m_can_dev_setup(struct m_can_classdev *cdev)
 		err = can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
 		if (err)
 			return err;
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
 		err = can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
 		if (err)
 			return err;
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
index 2c5d40997168..d18b515e6ccc 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -85,9 +85,6 @@ struct m_can_classdev {
 	struct sk_buff *tx_skb;
 	struct phy *transceiver;
 
-	const struct can_bittiming_const *bit_timing;
-	const struct can_bittiming_const *data_timing;
-
 	struct m_can_ops *ops;
 
 	int version;
-- 
2.35.1


