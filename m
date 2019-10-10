Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F10D292D
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 14:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387584AbfJJMSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 08:18:11 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59287 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387512AbfJJMSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 08:18:09 -0400
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iIXOR-0006Lw-LW; Thu, 10 Oct 2019 14:18:07 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org, linux-can <linux-can@vger.kernel.org>
Cc:     davem@davemloft.net, kernel@pengutronix.de,
        jhofstee@victronenergy.com,
        =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 17/29] can: rx-offload: can_rx_offload_irq_offload_timestamp(): continue on error
Date:   Thu, 10 Oct 2019 14:17:38 +0200
Message-Id: <20191010121750.27237-18-mkl@pengutronix.de>
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

From: Jeroen Hofstee <jhofstee@victronenergy.com>

In case of a resource shortage, i.e. the rx_offload queue will overflow
or a skb fails to be allocated (due to OOM),
can_rx_offload_offload_one() will call mailbox_read() to discard the
mailbox and return an ERR_PTR.

However can_rx_offload_irq_offload_timestamp() bails out in the error
case. In case of a resource shortage all mailboxes should be discarded,
to avoid an IRQ storm and give the system some time to recover.

Since can_rx_offload_irq_offload_timestamp() is typically called from a
while loop, all message will eventually be discarded. So lets continue
on error instead to discard them directly.

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rx-offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/rx-offload.c
index 2325890bbd14..42a1b7d1c753 100644
--- a/drivers/net/can/rx-offload.c
+++ b/drivers/net/can/rx-offload.c
@@ -198,7 +198,7 @@ int can_rx_offload_irq_offload_timestamp(struct can_rx_offload *offload, u64 pen
 
 		skb = can_rx_offload_offload_one(offload, i);
 		if (IS_ERR_OR_NULL(skb))
-			break;
+			continue;
 
 		__skb_queue_add_sort(&skb_queue, skb, can_rx_offload_compare);
 	}
-- 
2.23.0

