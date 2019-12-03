Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E106610FBF2
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 11:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfLCKrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 05:47:10 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41799 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbfLCKrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 05:47:10 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ic5hz-0001BG-Us; Tue, 03 Dec 2019 11:47:07 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        Martin Elshuber <martin.elshuber@theobroma-systems.com>,
        Philipp Tomsich <philipp.tomsich@theobroma-systems.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4/6] can: ucan: fix non-atomic allocation in completion handler
Date:   Tue,  3 Dec 2019 11:47:01 +0100
Message-Id: <20191203104703.14620-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203104703.14620-1-mkl@pengutronix.de>
References: <20191203104703.14620-1-mkl@pengutronix.de>
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

From: Johan Hovold <johan@kernel.org>

USB completion handlers are called in atomic context and must
specifically not allocate memory using GFP_KERNEL.

Fixes: 9f2d3eae88d2 ("can: ucan: add driver for Theobroma Systems UCAN devices")
Cc: stable <stable@vger.kernel.org>     # 4.19
Cc: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
Cc: Martin Elshuber <martin.elshuber@theobroma-systems.com>
Cc: Philipp Tomsich <philipp.tomsich@theobroma-systems.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/ucan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index 04aac3bb54ef..81e942f713e6 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -792,7 +792,7 @@ static void ucan_read_bulk_callback(struct urb *urb)
 			  up);
 
 	usb_anchor_urb(urb, &up->rx_urbs);
-	ret = usb_submit_urb(urb, GFP_KERNEL);
+	ret = usb_submit_urb(urb, GFP_ATOMIC);
 
 	if (ret < 0) {
 		netdev_err(up->netdev,
-- 
2.24.0

