Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF46E640A1F
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 17:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbiLBQEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 11:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233824AbiLBQE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 11:04:29 -0500
Received: from mail.enpas.org (zhong.enpas.org [IPv6:2a03:4000:2:537::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CBBCDA9590;
        Fri,  2 Dec 2022 08:03:29 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id 284FCFF9B7;
        Fri,  2 Dec 2022 16:03:23 +0000 (UTC)
From:   Max Staudt <max@enpas.org>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Vincent Mailhol <vincent.mailhol@gmail.com>,
        Oliver Neukum <oneukum@suse.com>, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] can: can327: Flush tx_work on ldisc .close()
Date:   Sat,  3 Dec 2022 01:01:48 +0900
Message-Id: <20221202160148.282564-1-max@enpas.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Additionally, remove it from .ndo_stop().

This ensures that the worker is not called after being freed, and that
the UART TX queue remains active to send final commands when the netdev
is stopped.

Thanks to Jiri Slaby for finding this in slcan:

  https://lore.kernel.org/linux-can/20221201073426.17328-1-jirislaby@kernel.org/

A variant of this patch for slcan, with the flush in .ndo_stop() still
present, has been tested successfully on physical hardware:

  https://bugzilla.suse.com/show_bug.cgi?id=1205597

Fixes: 43da2f07622f ("can: can327: CAN/ldisc driver for ELM327 based OBD-II adapters")
Cc: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Cc: Max Staudt <max@enpas.org>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-can@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Max Staudt <max@enpas.org>
---
 drivers/net/can/can327.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/can327.c b/drivers/net/can/can327.c
index ed3d0b8989a0..dc7192ecb001 100644
--- a/drivers/net/can/can327.c
+++ b/drivers/net/can/can327.c
@@ -796,9 +796,9 @@ static int can327_netdev_close(struct net_device *dev)
 
 	netif_stop_queue(dev);
 
-	/* Give UART one final chance to flush. */
-	clear_bit(TTY_DO_WRITE_WAKEUP, &elm->tty->flags);
-	flush_work(&elm->tx_work);
+	/* We don't flush the UART TX queue here, as we want final stop
+	 * commands (like the above dummy char) to be flushed out.
+	 */
 
 	can_rx_offload_disable(&elm->offload);
 	elm->can.state = CAN_STATE_STOPPED;
@@ -1069,12 +1069,15 @@ static void can327_ldisc_close(struct tty_struct *tty)
 {
 	struct can327 *elm = (struct can327 *)tty->disc_data;
 
-	/* unregister_netdev() calls .ndo_stop() so we don't have to.
-	 * Our .ndo_stop() also flushes the TTY write wakeup handler,
-	 * so we can safely set elm->tty = NULL after this.
-	 */
+	/* unregister_netdev() calls .ndo_stop() so we don't have to. */
 	unregister_candev(elm->dev);
 
+	/* Give UART one final chance to flush.
+	 * No need to clear TTY_DO_WRITE_WAKEUP since .write_wakeup() is
+	 * serialised against .close() and will not be called once we return.
+	 */
+	flush_work(&elm->tx_work);
+
 	/* Mark channel as dead */
 	spin_lock_bh(&elm->lock);
 	tty->disc_data = NULL;
-- 
2.30.2

