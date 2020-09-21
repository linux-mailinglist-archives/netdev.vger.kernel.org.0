Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC6627263A
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbgIUNrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727445AbgIUNqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:46:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A852C0613DF
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 06:46:10 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kKM8u-0003ED-8u; Mon, 21 Sep 2020 15:46:08 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 16/38] can: mscan: mark expected switch fall-through
Date:   Mon, 21 Sep 2020 15:45:35 +0200
Message-Id: <20200921134557.2251383-17-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921134557.2251383-1-mkl@pengutronix.de>
References: <20200921134557.2251383-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As -Wimplicit-fallthrough is now enabled the mscan driver shows this warning,
which is fixed by this patch:

drivers/net/can/mscan/mscan.c: In function ‘mscan_start_xmit’:
drivers/net/can/mscan/mscan.c:211:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
  211 |   netif_stop_queue(dev);
      |   ^~~~~~~~~~~~~~~~~~~~~
drivers/net/can/mscan/mscan.c:212:2: note: here
  212 |  case 2:
      |  ^~~~

Link: https://lore.kernel.org/r/20200915223527.1417033-17-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/mscan/mscan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/mscan/mscan.c b/drivers/net/can/mscan/mscan.c
index 99101d7027a8..0b3532dd50e2 100644
--- a/drivers/net/can/mscan/mscan.c
+++ b/drivers/net/can/mscan/mscan.c
@@ -209,6 +209,7 @@ static netdev_tx_t mscan_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		 * since buffer with lower id have higher priority (hell..)
 		 */
 		netif_stop_queue(dev);
+		fallthrough;
 	case 2:
 		if (buf_id < priv->prev_buf_id) {
 			priv->cur_pri++;
-- 
2.28.0

