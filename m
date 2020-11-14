Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA95C2B2F05
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 18:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgKNRek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 12:34:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgKNRej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 12:34:39 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFE1C0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 09:34:39 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kdzRd-0000mY-A8; Sat, 14 Nov 2020 18:34:37 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Colin Ian King <colin.king@canonical.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 06/15] can: peak_usb: fix potential integer overflow on shift of a int
Date:   Sat, 14 Nov 2020 18:33:50 +0100
Message-Id: <20201114173358.2058600-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201114173358.2058600-1-mkl@pengutronix.de>
References: <20201114173358.2058600-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The left shift of int 32 bit integer constant 1 is evaluated using 32 bit
arithmetic and then assigned to a signed 64 bit variable. In the case where
time_ref->adapter->ts_used_bits is 32 or more this can lead to an oveflow.
Avoid this by shifting using the BIT_ULL macro instead.

Fixes: bb4785551f64 ("can: usb: PEAK-System Technik USB adapters driver core")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20201105112427.40688-1-colin.king@canonical.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index c2764799f9ef..204ccb27d6d9 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -156,7 +156,7 @@ void peak_usb_get_ts_time(struct peak_time_ref *time_ref, u32 ts, ktime_t *time)
 		if (time_ref->ts_dev_1 < time_ref->ts_dev_2) {
 			/* case when event time (tsw) wraps */
 			if (ts < time_ref->ts_dev_1)
-				delta_ts = 1 << time_ref->adapter->ts_used_bits;
+				delta_ts = BIT_ULL(time_ref->adapter->ts_used_bits);
 
 		/* Otherwise, sync time counter (ts_dev_2) has wrapped:
 		 * handle case when event time (tsn) hasn't.
@@ -168,7 +168,7 @@ void peak_usb_get_ts_time(struct peak_time_ref *time_ref, u32 ts, ktime_t *time)
 		 *              tsn            ts
 		 */
 		} else if (time_ref->ts_dev_1 < ts) {
-			delta_ts = -(1 << time_ref->adapter->ts_used_bits);
+			delta_ts = -BIT_ULL(time_ref->adapter->ts_used_bits);
 		}
 
 		/* add delay between last sync and event timestamps */
-- 
2.29.2

