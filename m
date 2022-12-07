Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758D2645842
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiLGKxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiLGKwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:52:55 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD0E31203
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 02:52:50 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p2s2j-00075J-BL
        for netdev@vger.kernel.org; Wed, 07 Dec 2022 11:52:49 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 67B5A1387FB
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 10:52:48 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B303D1387CE;
        Wed,  7 Dec 2022 10:52:45 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 7e3fed3b;
        Wed, 7 Dec 2022 10:52:44 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Max Staudt <max@enpas.org>,
        "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org
Subject: [PATCH net 3/4] can: can327: flush TX_work on ldisc .close()
Date:   Wed,  7 Dec 2022 11:52:42 +0100
Message-Id: <20221207105243.2483884-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221207105243.2483884-1-mkl@pengutronix.de>
References: <20221207105243.2483884-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Max Staudt <max@enpas.org>

Additionally, remove it from .ndo_stop().

This ensures that the worker is not called after being freed, and that
the UART TX queue remains active to send final commands when the
netdev is stopped.

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
Link: https://lore.kernel.org/all/20221202160148.282564-1-max@enpas.org
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
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
2.35.1


