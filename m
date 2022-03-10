Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAD64D4AD9
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 15:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244213AbiCJOdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344032AbiCJObh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:31:37 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CD8BF946
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:29:28 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nSJnC-0006Mn-9Z
        for netdev@vger.kernel.org; Thu, 10 Mar 2022 15:29:26 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 04E9347E39
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:29:14 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 38FC247E18;
        Thu, 10 Mar 2022 14:29:13 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 4465f46e;
        Thu, 10 Mar 2022 14:29:05 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Peter Fink <pfink@christ-es.de>,
        Ryan Edwards <ryan.edwards@gmail.com>,
        =?UTF-8?q?Christoph=20M=C3=B6hring?= <cmoehring@christ-es.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 26/29] can: gs_usb: activate quirks for CANtact Pro unconditionally
Date:   Thu, 10 Mar 2022 15:29:00 +0100
Message-Id: <20220310142903.341658-27-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310142903.341658-1-mkl@pengutronix.de>
References: <20220310142903.341658-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Peter Fink <pfink@christ-es.de>

The CANtact Pro from LinkLayer Labs is based on the LPC54616 µC, which
is affected by the NXP LPC USB transfer erratum. However, the current
firmware (version 2) doesn't set the
GS_CAN_FEATURE_REQ_USB_QUIRK_LPC546XX bit.

This patch sets the feature GS_CAN_FEATURE_REQ_USB_QUIRK_LPC546XX to
workaround this issue.

For the GS_USB_BREQ_DATA_BITTIMING USB control message the CANtact Pro
firmware uses a request value, which is already used by the
candleLight firmware for a different purpose
(GS_USB_BREQ_GET_USER_ID).

This patch set the feature GS_CAN_FEATURE_QUIRK_BREQ_CANTACT_PRO to
workaround this issue.

Link: https://lore.kernel.org/all/20220309124132.291861-19-mkl@pengutronix.de
Cc: Ryan Edwards <ryan.edwards@gmail.com>
Signed-off-by: Peter Fink <pfink@christ-es.de>
Signed-off-by: Christoph Möhring <cmoehring@christ-es.de>
[mkl: improve check for CANtact Pro and add GS_CAN_FEATURE_QUIRK_BREQ_CANTACT_PRO quirk]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 1661b91de364..915c5dd8199b 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -993,6 +993,29 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 		dev->can.do_set_data_bittiming = gs_usb_set_data_bittiming;
 	}
 
+	/* The CANtact Pro from LinkLayer Labs is based on the
+	 * LPC54616 µC, which is affected by the NXP LPC USB transfer
+	 * erratum. However, the current firmware (version 2) doesn't
+	 * set the GS_CAN_FEATURE_REQ_USB_QUIRK_LPC546XX bit. Set the
+	 * feature GS_CAN_FEATURE_REQ_USB_QUIRK_LPC546XX to workaround
+	 * this issue.
+	 *
+	 * For the GS_USB_BREQ_DATA_BITTIMING USB control message the
+	 * CANtact Pro firmware uses a request value, which is already
+	 * used by the candleLight firmware for a different purpose
+	 * (GS_USB_BREQ_GET_USER_ID). Set the feature
+	 * GS_CAN_FEATURE_QUIRK_BREQ_CANTACT_PRO to workaround this
+	 * issue.
+	 */
+	if (dev->udev->descriptor.idVendor == cpu_to_le16(USB_GSUSB_1_VENDOR_ID) &&
+	    dev->udev->descriptor.idProduct == cpu_to_le16(USB_GSUSB_1_PRODUCT_ID) &&
+	    dev->udev->manufacturer && dev->udev->product &&
+	    !strcmp(dev->udev->manufacturer, "LinkLayer Labs") &&
+	    !strcmp(dev->udev->product, "CANtact Pro") &&
+	    (le32_to_cpu(dconf->sw_version) <= 2))
+		dev->feature |= GS_CAN_FEATURE_REQ_USB_QUIRK_LPC546XX |
+			GS_CAN_FEATURE_QUIRK_BREQ_CANTACT_PRO;
+
 	if (le32_to_cpu(dconf->sw_version) > 1)
 		if (feature & GS_CAN_FEATURE_IDENTIFY)
 			netdev->ethtool_ops = &gs_usb_ethtool_ops;
-- 
2.35.1


