Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F5F35DBE9
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242499AbhDMJxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243091AbhDMJxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 05:53:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC2FC06135C
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 02:52:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lWFib-0002mL-P4
        for netdev@vger.kernel.org; Tue, 13 Apr 2021 11:52:25 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1004B60DAD2
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 09:52:21 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 8CE8760DA75;
        Tue, 13 Apr 2021 09:52:08 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 05400ead;
        Tue, 13 Apr 2021 09:52:03 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Stephane Grosjean <s.grosjean@peak-system.com>
Subject: [net-next 14/14] can: peak_usb: pcan_usb: replace open coded endianness conversion of unaligned data
Date:   Tue, 13 Apr 2021 11:52:01 +0200
Message-Id: <20210413095201.2409865-15-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210413095201.2409865-1-mkl@pengutronix.de>
References: <20210413095201.2409865-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replaces the open coded endianness conversion of unaligned
data by the appropriate get/put_unaligned_leXX() variants.

Link: https://lore.kernel.org/r/20210406111622.1874957-11-mkl@pengutronix.de
Acked-by: Stephane Grosjean <s.grosjean@peak-system.com>
Tested-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c | 37 ++++++++-----------------
 1 file changed, 11 insertions(+), 26 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index 929cc1b05aa2..1d6f77252f01 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -394,14 +394,10 @@ static int pcan_usb_get_device_id(struct peak_usb_device *dev, u32 *device_id)
  */
 static int pcan_usb_update_ts(struct pcan_usb_msg_context *mc)
 {
-	__le16 tmp16;
-
 	if ((mc->ptr + 2) > mc->end)
 		return -EINVAL;
 
-	memcpy(&tmp16, mc->ptr, 2);
-
-	mc->ts16 = le16_to_cpu(tmp16);
+	mc->ts16 = get_unaligned_le16(mc->ptr);
 
 	if (mc->rec_idx > 0)
 		peak_usb_update_ts_now(&mc->pdev->time_ref, mc->ts16);
@@ -418,16 +414,13 @@ static int pcan_usb_decode_ts(struct pcan_usb_msg_context *mc, u8 first_packet)
 {
 	/* only 1st packet supplies a word timestamp */
 	if (first_packet) {
-		__le16 tmp16;
-
 		if ((mc->ptr + 2) > mc->end)
 			return -EINVAL;
 
-		memcpy(&tmp16, mc->ptr, 2);
-		mc->ptr += 2;
-
-		mc->ts16 = le16_to_cpu(tmp16);
+		mc->ts16 = get_unaligned_le16(mc->ptr);
 		mc->prev_ts8 = mc->ts16 & 0x00ff;
+
+		mc->ptr += 2;
 	} else {
 		u8 ts8;
 
@@ -717,25 +710,17 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
 		return -ENOMEM;
 
 	if (status_len & PCAN_USB_STATUSLEN_EXT_ID) {
-		__le32 tmp32;
-
 		if ((mc->ptr + 4) > mc->end)
 			goto decode_failed;
 
-		memcpy(&tmp32, mc->ptr, 4);
+		cf->can_id = get_unaligned_le32(mc->ptr) >> 3 | CAN_EFF_FLAG;
 		mc->ptr += 4;
-
-		cf->can_id = (le32_to_cpu(tmp32) >> 3) | CAN_EFF_FLAG;
 	} else {
-		__le16 tmp16;
-
 		if ((mc->ptr + 2) > mc->end)
 			goto decode_failed;
 
-		memcpy(&tmp16, mc->ptr, 2);
+		cf->can_id = get_unaligned_le16(mc->ptr) >> 5;
 		mc->ptr += 2;
-
-		cf->can_id = le16_to_cpu(tmp16) >> 5;
 	}
 
 	can_frame_set_cc_len(cf, rec_len, mc->pdev->dev.can.ctrlmode);
@@ -849,15 +834,15 @@ static int pcan_usb_encode_msg(struct peak_usb_device *dev, struct sk_buff *skb,
 
 	/* can id */
 	if (cf->can_id & CAN_EFF_FLAG) {
-		__le32 tmp32 = cpu_to_le32((cf->can_id & CAN_ERR_MASK) << 3);
-
 		*pc |= PCAN_USB_STATUSLEN_EXT_ID;
-		memcpy(++pc, &tmp32, 4);
+		pc++;
+
+		put_unaligned_le32((cf->can_id & CAN_ERR_MASK) << 3, pc);
 		pc += 4;
 	} else {
-		__le16 tmp16 = cpu_to_le16((cf->can_id & CAN_ERR_MASK) << 5);
+		pc++;
 
-		memcpy(++pc, &tmp16, 2);
+		put_unaligned_le16((cf->can_id & CAN_ERR_MASK) << 5, pc);
 		pc += 2;
 	}
 
-- 
2.30.2


