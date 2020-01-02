Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C60012E883
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 17:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgABQJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 11:09:55 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55887 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728816AbgABQJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 11:09:42 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1in32a-0000mM-QQ; Thu, 02 Jan 2020 17:09:40 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Jimmy Assarsson <extja@kvaser.com>,
        Christer Beskow <chbe@kvaser.com>,
        Nicklas Johansson <extnj@kvaser.com>,
        Martin Henriksson <mh@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 7/9] can: kvaser_usb: fix interface sanity check
Date:   Thu,  2 Jan 2020 17:09:32 +0100
Message-Id: <20200102160934.1524-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102160934.1524-1-mkl@pengutronix.de>
References: <20200102160934.1524-1-mkl@pengutronix.de>
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

Make sure to use the current alternate setting when verifying the
interface descriptors to avoid binding to an invalid interface.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: aec5fb2268b7 ("can: kvaser_usb: Add support for Kvaser USB hydra family")
Cc: stable <stable@vger.kernel.org>     # 4.19
Cc: Jimmy Assarsson <extja@kvaser.com>
Cc: Christer Beskow <chbe@kvaser.com>
Cc: Nicklas Johansson <extnj@kvaser.com>
Cc: Martin Henriksson <mh@kvaser.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 5fc0be564274..7ab87a758754 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1590,7 +1590,7 @@ static int kvaser_usb_hydra_setup_endpoints(struct kvaser_usb *dev)
 	struct usb_endpoint_descriptor *ep;
 	int i;
 
-	iface_desc = &dev->intf->altsetting[0];
+	iface_desc = dev->intf->cur_altsetting;
 
 	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
 		ep = &iface_desc->endpoint[i].desc;
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index ae4c37e1bb75..1b9957f12459 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -1310,7 +1310,7 @@ static int kvaser_usb_leaf_setup_endpoints(struct kvaser_usb *dev)
 	struct usb_endpoint_descriptor *endpoint;
 	int i;
 
-	iface_desc = &dev->intf->altsetting[0];
+	iface_desc = dev->intf->cur_altsetting;
 
 	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
 		endpoint = &iface_desc->endpoint[i].desc;
-- 
2.24.1

