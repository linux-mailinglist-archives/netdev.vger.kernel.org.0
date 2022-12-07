Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1CB4645843
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiLGKxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiLGKwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:52:55 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C96D2F02D
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 02:52:51 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p2s2j-00077m-UB
        for netdev@vger.kernel.org; Wed, 07 Dec 2022 11:52:49 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 0CDC21387FF
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 10:52:49 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9B69B1387CC;
        Wed,  7 Dec 2022 10:52:45 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a55d57ee;
        Wed, 7 Dec 2022 10:52:44 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        Richard Palethorpe <richard.palethorpe@suse.com>,
        Petr Vorel <petr.vorel@suse.com>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org,
        Max Staudt <max@enpas.org>
Subject: [PATCH net 2/4] can: slcan: fix freed work crash
Date:   Wed,  7 Dec 2022 11:52:41 +0100
Message-Id: <20221207105243.2483884-3-mkl@pengutronix.de>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>

The LTP test pty03 is causing a crash in slcan:
  BUG: kernel NULL pointer dereference, address: 0000000000000008
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 0 PID: 348 Comm: kworker/0:3 Not tainted 6.0.8-1-default #1 openSUSE Tumbleweed 9d20364b934f5aab0a9bdf84e8f45cfdfae39dab
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b-rebuilt.opensuse.org 04/01/2014
  Workqueue:  0x0 (events)
  RIP: 0010:process_one_work (/home/rich/kernel/linux/kernel/workqueue.c:706 /home/rich/kernel/linux/kernel/workqueue.c:2185)
  Code: 49 89 ff 41 56 41 55 41 54 55 53 48 89 f3 48 83 ec 10 48 8b 06 48 8b 6f 48 49 89 c4 45 30 e4 a8 04 b8 00 00 00 00 4c 0f 44 e0 <49> 8b 44 24 08 44 8b a8 00 01 00 00 41 83 e5 20 f6 45 10 04 75 0e
  RSP: 0018:ffffaf7b40f47e98 EFLAGS: 00010046
  RAX: 0000000000000000 RBX: ffff9d644e1b8b48 RCX: ffff9d649e439968
  RDX: 00000000ffff8455 RSI: ffff9d644e1b8b48 RDI: ffff9d64764aa6c0
  RBP: ffff9d649e4335c0 R08: 0000000000000c00 R09: ffff9d64764aa734
  R10: 0000000000000007 R11: 0000000000000001 R12: 0000000000000000
  R13: ffff9d649e4335e8 R14: ffff9d64490da780 R15: ffff9d64764aa6c0
  FS:  0000000000000000(0000) GS:ffff9d649e400000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000008 CR3: 0000000036424000 CR4: 00000000000006f0
  Call Trace:
   <TASK>
  worker_thread (/home/rich/kernel/linux/kernel/workqueue.c:2436)
  kthread (/home/rich/kernel/linux/kernel/kthread.c:376)
  ret_from_fork (/home/rich/kernel/linux/arch/x86/entry/entry_64.S:312)

Apparently, the slcan's tx_work is freed while being scheduled. While
slcan_netdev_close() (netdev side) calls flush_work(&sl->tx_work),
slcan_close() (tty side) does not. So when the netdev is never set UP,
but the tty is stuffed with bytes and forced to wakeup write, the work
is scheduled, but never flushed.

So add an additional flush_work() to slcan_close() to be sure the work
is flushed under all circumstances.

The Fixes commit below moved flush_work() from slcan_close() to
slcan_netdev_close(). What was the rationale behind it? Maybe we can
drop the one in slcan_netdev_close()?

I see the same pattern in can327. So it perhaps needs the very same fix.

Fixes: cfcb4465e992 ("can: slcan: remove legacy infrastructure")
Link: https://bugzilla.suse.com/show_bug.cgi?id=1205597
Reported-by: Richard Palethorpe <richard.palethorpe@suse.com>
Tested-by: Petr Vorel <petr.vorel@suse.com>
Cc: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-can@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: Max Staudt <max@enpas.org>
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Reviewed-by: Max Staudt <max@enpas.org>
Link: https://lore.kernel.org/all/20221201073426.17328-1-jirislaby@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/slcan/slcan-core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index fbb34139daa1..f4db77007c13 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -864,12 +864,14 @@ static void slcan_close(struct tty_struct *tty)
 {
 	struct slcan *sl = (struct slcan *)tty->disc_data;
 
-	/* unregister_netdev() calls .ndo_stop() so we don't have to.
-	 * Our .ndo_stop() also flushes the TTY write wakeup handler,
-	 * so we can safely set sl->tty = NULL after this.
-	 */
 	unregister_candev(sl->dev);
 
+	/*
+	 * The netdev needn't be UP (so .ndo_stop() is not called). Hence make
+	 * sure this is not running before freeing it up.
+	 */
+	flush_work(&sl->tx_work);
+
 	/* Mark channel as dead */
 	spin_lock_bh(&sl->lock);
 	tty->disc_data = NULL;
-- 
2.35.1


