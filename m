Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36DCC2A7CDF
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 12:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730231AbgKELYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 06:24:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56442 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729263AbgKELYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 06:24:32 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kadNT-0003Wm-Fn; Thu, 05 Nov 2020 11:24:27 +0000
From:   Colin King <colin.king@canonical.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] can: usb: fix potential integer overflow on shift of a int
Date:   Thu,  5 Nov 2020 11:24:27 +0000
Message-Id: <20201105112427.40688-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The left shift of int 32 bit integer constant 1 is evaluated using
32 bit arithmetic and then assigned to a signed 64 bit variable. In
the case where time_ref->adapter->ts_used_bits is 32 or more this
can lead to an oveflow. Avoid this by shifting using the BIT_ULL macro
instead.

Addresses-Coverity: ("Unintentional integer overflow")
Fixes: bb4785551f64 ("can: usb: PEAK-System Technik USB adapters driver core")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
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
2.27.0

