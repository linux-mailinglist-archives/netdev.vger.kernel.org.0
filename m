Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAF1D2930
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 14:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387635AbfJJMSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 08:18:15 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59071 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387554AbfJJMSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 08:18:11 -0400
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iIXOT-0006Lw-8M; Thu, 10 Oct 2019 14:18:09 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org, linux-can <linux-can@vger.kernel.org>
Cc:     davem@davemloft.net, kernel@pengutronix.de,
        jhofstee@victronenergy.com,
        =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 20/29] can: ti_hecc: ti_hecc_error(): increase error counters if skb enqueueing via can_rx_offload_queue_sorted() fails
Date:   Thu, 10 Oct 2019 14:17:41 +0200
Message-Id: <20191010121750.27237-21-mkl@pengutronix.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010121750.27237-1-mkl@pengutronix.de>
References: <20191010121750.27237-1-mkl@pengutronix.de>
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

The call to can_rx_offload_queue_sorted() may fail and return an error
(in the current implementation due to resource shortage). The passed skb
is consumed.

This patch adds incrementing of the appropriate error counters to let
the device statistics reflect that there's a problem.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/ti_hecc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index f8b19eef5d26..91188e6d4f78 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -558,6 +558,7 @@ static int ti_hecc_error(struct net_device *ndev, int int_status,
 	struct can_frame *cf;
 	struct sk_buff *skb;
 	u32 timestamp;
+	int err;
 
 	/* propagate the error condition to the can stack */
 	skb = alloc_can_err_skb(ndev, &cf);
@@ -639,7 +640,9 @@ static int ti_hecc_error(struct net_device *ndev, int int_status,
 	}
 
 	timestamp = hecc_read(priv, HECC_CANLNT);
-	can_rx_offload_queue_sorted(&priv->offload, skb, timestamp);
+	err = can_rx_offload_queue_sorted(&priv->offload, skb, timestamp);
+	if (err)
+		ndev->stats.rx_fifo_errors++;
 
 	return 0;
 }
-- 
2.23.0

