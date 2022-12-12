Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E1564A17C
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 14:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbiLLNlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 08:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232688AbiLLNkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 08:40:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C9613F15;
        Mon, 12 Dec 2022 05:39:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3381D61072;
        Mon, 12 Dec 2022 13:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE80C433D2;
        Mon, 12 Dec 2022 13:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852387;
        bh=h7In0NnjjbjZjxsJxGv5gfNAMW3C+AdRTJoqS9JIxNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xfQFscjwMaEnnPqf+NaismneBhThGyIY7Qyac5d1Py4sJpwkK8HoVbgNDKWZLb/Kq
         HMamvIOHA0WQqsEfWRJxIoChaDG8CsJR04L3X96EJc/oWIuh+fiXtal/5q46iyfTkB
         Ex9upYYAegNecPTy2HEGKgDy1ZZyqwny85Oy0hUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        Max Staudt <max@enpas.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 6.0 070/157] can: can327: flush TX_work on ldisc .close()
Date:   Mon, 12 Dec 2022 14:16:58 +0100
Message-Id: <20221212130937.442350836@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Max Staudt <max@enpas.org>

commit f4a4d121ebecaa6f396f21745ce97de014281ccc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
2.38.1



