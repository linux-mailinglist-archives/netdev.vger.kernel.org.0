Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61A29D294B
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 14:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387573AbfJJMSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 08:18:11 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49295 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387492AbfJJMSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 08:18:09 -0400
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iIXOQ-0006Lw-Ju; Thu, 10 Oct 2019 14:18:06 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org, linux-can <linux-can@vger.kernel.org>
Cc:     davem@davemloft.net, kernel@pengutronix.de,
        jhofstee@victronenergy.com,
        =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 15/29] can: rx-offload: can_rx_offload_offload_one(): increment rx_fifo_errors on queue overflow or OOM
Date:   Thu, 10 Oct 2019 14:17:36 +0200
Message-Id: <20191010121750.27237-16-mkl@pengutronix.de>
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

If the rx-offload skb_queue is full or the skb allocation fails (due to OOM),
the mailbox contents is discarded.

This patch adds the incrementing of the rx_fifo_errors statistics counter.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rx-offload.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/rx-offload.c
index bdc27481b57f..e224530a0630 100644
--- a/drivers/net/can/rx-offload.c
+++ b/drivers/net/can/rx-offload.c
@@ -125,8 +125,10 @@ static struct sk_buff *can_rx_offload_offload_one(struct can_rx_offload *offload
 
 		ret = offload->mailbox_read(offload, &cf_overflow,
 					    &timestamp, n);
-		if (ret)
+		if (ret) {
 			offload->dev->stats.rx_dropped++;
+			offload->dev->stats.rx_fifo_errors++;
+		}
 
 		return NULL;
 	}
-- 
2.23.0

