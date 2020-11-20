Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C482BAB5B
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgKTNeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728135AbgKTNda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:33:30 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D57C061A4E
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 05:33:28 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kg6XW-0006Fn-8K; Fri, 20 Nov 2020 14:33:26 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 11/25] can: gw: support modification of Classical CAN DLCs
Date:   Fri, 20 Nov 2020 14:33:04 +0100
Message-Id: <20201120133318.3428231-12-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120133318.3428231-1-mkl@pengutronix.de>
References: <20201120133318.3428231-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

Add support for data length code modifications for Classical CAN.

The netlink configuration interface always allowed to pass any value
that fits into a byte, therefore only the modification process had to be
extended to handle the raw DLC represenation of Classical CAN frames.

When a DLC value from 0 .. F is provided for Classical CAN frame
modifications the 'len' value is modified as-is with the exception that
potentially existing 9 .. F DLC values in the len8_dlc element are moved
to the 'len' element for the modification operation by mod_retrieve_ccdlc().

After the modification the Classical CAN frame DLC information is brought
back into the correct format by mod_store_ccdlc() which is filling 'len'
and 'len8_dlc' accordingly.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/r/20201119084921.2621-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/uapi/linux/can/gw.h |  4 +-
 net/can/gw.c                | 78 +++++++++++++++++++++++++++++++++----
 2 files changed, 72 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/can/gw.h b/include/uapi/linux/can/gw.h
index c2190bbe21d8..e4f0957554f3 100644
--- a/include/uapi/linux/can/gw.h
+++ b/include/uapi/linux/can/gw.h
@@ -98,8 +98,8 @@ enum {
 
 /* CAN frame elements that are affected by curr. 3 CAN frame modifications */
 #define CGW_MOD_ID	0x01
-#define CGW_MOD_DLC	0x02		/* contains the data length in bytes */
-#define CGW_MOD_LEN	CGW_MOD_DLC	/* CAN FD length representation */
+#define CGW_MOD_DLC	0x02		/* Classical CAN data length code */
+#define CGW_MOD_LEN	CGW_MOD_DLC	/* CAN FD (plain) data length */
 #define CGW_MOD_DATA	0x04
 #define CGW_MOD_FLAGS	0x08		/* CAN FD flags */
 
diff --git a/net/can/gw.c b/net/can/gw.c
index de5e8859ec9b..8598d9da0e5f 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -199,6 +199,68 @@ static void mod_set_fddata(struct canfd_frame *cf, struct cf_mod *mod)
 	memcpy(cf->data, mod->modframe.set.data, CANFD_MAX_DLEN);
 }
 
+/* retrieve valid CC DLC value and store it into 'len' */
+static void mod_retrieve_ccdlc(struct canfd_frame *cf)
+{
+	struct can_frame *ccf = (struct can_frame *)cf;
+
+	/* len8_dlc is only valid if len == CAN_MAX_DLEN */
+	if (ccf->len != CAN_MAX_DLEN)
+		return;
+
+	/* do we have a valid len8_dlc value from 9 .. 15 ? */
+	if (ccf->len8_dlc > CAN_MAX_DLEN && ccf->len8_dlc <= CAN_MAX_RAW_DLC)
+		ccf->len = ccf->len8_dlc;
+}
+
+/* convert valid CC DLC value in 'len' into struct can_frame elements */
+static void mod_store_ccdlc(struct canfd_frame *cf)
+{
+	struct can_frame *ccf = (struct can_frame *)cf;
+
+	/* clear potential leftovers */
+	ccf->len8_dlc = 0;
+
+	/* plain data length 0 .. 8 - that was easy */
+	if (ccf->len <= CAN_MAX_DLEN)
+		return;
+
+	/* potentially broken values are catched in can_can_gw_rcv() */
+	if (ccf->len > CAN_MAX_RAW_DLC)
+		return;
+
+	/* we have a valid dlc value from 9 .. 15 in ccf->len */
+	ccf->len8_dlc = ccf->len;
+	ccf->len = CAN_MAX_DLEN;
+}
+
+static void mod_and_ccdlc(struct canfd_frame *cf, struct cf_mod *mod)
+{
+	mod_retrieve_ccdlc(cf);
+	mod_and_len(cf, mod);
+	mod_store_ccdlc(cf);
+}
+
+static void mod_or_ccdlc(struct canfd_frame *cf, struct cf_mod *mod)
+{
+	mod_retrieve_ccdlc(cf);
+	mod_or_len(cf, mod);
+	mod_store_ccdlc(cf);
+}
+
+static void mod_xor_ccdlc(struct canfd_frame *cf, struct cf_mod *mod)
+{
+	mod_retrieve_ccdlc(cf);
+	mod_xor_len(cf, mod);
+	mod_store_ccdlc(cf);
+}
+
+static void mod_set_ccdlc(struct canfd_frame *cf, struct cf_mod *mod)
+{
+	mod_set_len(cf, mod);
+	mod_store_ccdlc(cf);
+}
+
 static void canframecpy(struct canfd_frame *dst, struct can_frame *src)
 {
 	/* Copy the struct members separately to ensure that no uninitialized
@@ -842,8 +904,8 @@ static int cgw_parse_attr(struct nlmsghdr *nlh, struct cf_mod *mod,
 			if (mb.modtype & CGW_MOD_ID)
 				mod->modfunc[modidx++] = mod_and_id;
 
-			if (mb.modtype & CGW_MOD_LEN)
-				mod->modfunc[modidx++] = mod_and_len;
+			if (mb.modtype & CGW_MOD_DLC)
+				mod->modfunc[modidx++] = mod_and_ccdlc;
 
 			if (mb.modtype & CGW_MOD_DATA)
 				mod->modfunc[modidx++] = mod_and_data;
@@ -858,8 +920,8 @@ static int cgw_parse_attr(struct nlmsghdr *nlh, struct cf_mod *mod,
 			if (mb.modtype & CGW_MOD_ID)
 				mod->modfunc[modidx++] = mod_or_id;
 
-			if (mb.modtype & CGW_MOD_LEN)
-				mod->modfunc[modidx++] = mod_or_len;
+			if (mb.modtype & CGW_MOD_DLC)
+				mod->modfunc[modidx++] = mod_or_ccdlc;
 
 			if (mb.modtype & CGW_MOD_DATA)
 				mod->modfunc[modidx++] = mod_or_data;
@@ -874,8 +936,8 @@ static int cgw_parse_attr(struct nlmsghdr *nlh, struct cf_mod *mod,
 			if (mb.modtype & CGW_MOD_ID)
 				mod->modfunc[modidx++] = mod_xor_id;
 
-			if (mb.modtype & CGW_MOD_LEN)
-				mod->modfunc[modidx++] = mod_xor_len;
+			if (mb.modtype & CGW_MOD_DLC)
+				mod->modfunc[modidx++] = mod_xor_ccdlc;
 
 			if (mb.modtype & CGW_MOD_DATA)
 				mod->modfunc[modidx++] = mod_xor_data;
@@ -890,8 +952,8 @@ static int cgw_parse_attr(struct nlmsghdr *nlh, struct cf_mod *mod,
 			if (mb.modtype & CGW_MOD_ID)
 				mod->modfunc[modidx++] = mod_set_id;
 
-			if (mb.modtype & CGW_MOD_LEN)
-				mod->modfunc[modidx++] = mod_set_len;
+			if (mb.modtype & CGW_MOD_DLC)
+				mod->modfunc[modidx++] = mod_set_ccdlc;
 
 			if (mb.modtype & CGW_MOD_DATA)
 				mod->modfunc[modidx++] = mod_set_data;
-- 
2.29.2

