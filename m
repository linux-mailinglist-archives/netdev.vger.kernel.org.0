Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06789F02C8
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390337AbfKEQcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 11:32:41 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50625 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390304AbfKEQck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 11:32:40 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iS1l0-0002Hp-KB; Tue, 05 Nov 2019 17:32:38 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        linux-stable <stable@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 06/33] can: peak_usb: fix a potential out-of-sync while decoding packets
Date:   Tue,  5 Nov 2019 17:31:48 +0100
Message-Id: <20191105163215.30194-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0.rc1
In-Reply-To: <20191105163215.30194-1-mkl@pengutronix.de>
References: <20191105163215.30194-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

When decoding a buffer received from PCAN-USB, the first timestamp read in
a packet is a 16-bit coded time base, and the next ones are an 8-bit
offset to this base, regardless of the type of packet read.

This patch corrects a potential loss of synchronization by using a
timestamp index read from the buffer, rather than an index of received
data packets, to determine on the sizeof the timestamp to be read from the
packet being decoded.

Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Fixes: 46be265d3388 ("can: usb: PEAK-System Technik PCAN-USB specific part")
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index 617da295b6c1..5a66c9f53aae 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -100,7 +100,7 @@ struct pcan_usb_msg_context {
 	u8 *end;
 	u8 rec_cnt;
 	u8 rec_idx;
-	u8 rec_data_idx;
+	u8 rec_ts_idx;
 	struct net_device *netdev;
 	struct pcan_usb *pdev;
 };
@@ -547,10 +547,15 @@ static int pcan_usb_decode_status(struct pcan_usb_msg_context *mc,
 	mc->ptr += PCAN_USB_CMD_ARGS;
 
 	if (status_len & PCAN_USB_STATUSLEN_TIMESTAMP) {
-		int err = pcan_usb_decode_ts(mc, !mc->rec_idx);
+		int err = pcan_usb_decode_ts(mc, !mc->rec_ts_idx);
 
 		if (err)
 			return err;
+
+		/* Next packet in the buffer will have a timestamp on a single
+		 * byte
+		 */
+		mc->rec_ts_idx++;
 	}
 
 	switch (f) {
@@ -632,10 +637,13 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
 
 	cf->can_dlc = get_can_dlc(rec_len);
 
-	/* first data packet timestamp is a word */
-	if (pcan_usb_decode_ts(mc, !mc->rec_data_idx))
+	/* Only first packet timestamp is a word */
+	if (pcan_usb_decode_ts(mc, !mc->rec_ts_idx))
 		goto decode_failed;
 
+	/* Next packet in the buffer will have a timestamp on a single byte */
+	mc->rec_ts_idx++;
+
 	/* read data */
 	memset(cf->data, 0x0, sizeof(cf->data));
 	if (status_len & PCAN_USB_STATUSLEN_RTR) {
@@ -688,7 +696,6 @@ static int pcan_usb_decode_msg(struct peak_usb_device *dev, u8 *ibuf, u32 lbuf)
 		/* handle normal can frames here */
 		} else {
 			err = pcan_usb_decode_data(&mc, sl);
-			mc.rec_data_idx++;
 		}
 	}
 
-- 
2.24.0.rc1

