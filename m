Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501A45BF96D
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 10:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbiIUIgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 04:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbiIUIgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 04:36:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F3F832FE
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 01:36:15 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oavDK-0000TU-AE
        for netdev@vger.kernel.org; Wed, 21 Sep 2022 10:36:14 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4E863E858B
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 08:36:12 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id CD0EBE8575;
        Wed, 21 Sep 2022 08:36:10 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id dbd3af39;
        Wed, 21 Sep 2022 08:36:10 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH net 3/3] can: gs_usb: gs_usb_set_phys_id(): return with error if identify is not supported
Date:   Wed, 21 Sep 2022 10:36:09 +0200
Message-Id: <20220921083609.419768-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921083609.419768-1-mkl@pengutronix.de>
References: <20220921083609.419768-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Until commit 409c188c57cd ("can: tree-wide: advertise software
timestamping capabilities") the ethtool_ops was only assigned for
devices which support the GS_CAN_FEATURE_IDENTIFY feature. That commit
assigns ethtool_ops unconditionally.

This results on controllers without GS_CAN_FEATURE_IDENTIFY support
for the following ethtool error:

| $ ethtool -p can0 1
| Cannot identify NIC: Broken pipe

Restore the correct error value by checking for
GS_CAN_FEATURE_IDENTIFY in the gs_usb_set_phys_id() function.

| $ ethtool -p can0 1
| Cannot identify NIC: Operation not supported

While there use the variable "netdev" for the "struct net_device"
pointer and "dev" for the "struct gs_can" pointer as in the rest of
the driver.

Fixes: 409c188c57cd ("can: tree-wide: advertise software timestamping capabilities")
Link: http://lore.kernel.org/all/20220818143853.2671854-1-mkl@pengutronix.de
Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 553e2c7b0b12..c1ff3c046d62 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -925,17 +925,21 @@ static int gs_usb_set_identify(struct net_device *netdev, bool do_identify)
 }
 
 /* blink LED's for finding the this interface */
-static int gs_usb_set_phys_id(struct net_device *dev,
+static int gs_usb_set_phys_id(struct net_device *netdev,
 			      enum ethtool_phys_id_state state)
 {
+	const struct gs_can *dev = netdev_priv(netdev);
 	int rc = 0;
 
+	if (!(dev->feature & GS_CAN_FEATURE_IDENTIFY))
+		return -EOPNOTSUPP;
+
 	switch (state) {
 	case ETHTOOL_ID_ACTIVE:
-		rc = gs_usb_set_identify(dev, GS_CAN_IDENTIFY_ON);
+		rc = gs_usb_set_identify(netdev, GS_CAN_IDENTIFY_ON);
 		break;
 	case ETHTOOL_ID_INACTIVE:
-		rc = gs_usb_set_identify(dev, GS_CAN_IDENTIFY_OFF);
+		rc = gs_usb_set_identify(netdev, GS_CAN_IDENTIFY_OFF);
 		break;
 	default:
 		break;
@@ -1072,9 +1076,10 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 		dev->feature |= GS_CAN_FEATURE_REQ_USB_QUIRK_LPC546XX |
 			GS_CAN_FEATURE_QUIRK_BREQ_CANTACT_PRO;
 
-	if (le32_to_cpu(dconf->sw_version) > 1)
-		if (feature & GS_CAN_FEATURE_IDENTIFY)
-			netdev->ethtool_ops = &gs_usb_ethtool_ops;
+	/* GS_CAN_FEATURE_IDENTIFY is only supported for sw_version > 1 */
+	if (!(le32_to_cpu(dconf->sw_version) > 1 &&
+	      feature & GS_CAN_FEATURE_IDENTIFY))
+		dev->feature &= ~GS_CAN_FEATURE_IDENTIFY;
 
 	kfree(bt_const);
 
-- 
2.35.1


