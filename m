Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717B8430C2B
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 23:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344643AbhJQVEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 17:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344616AbhJQVEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 17:04:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E09C061769
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 14:01:58 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mcDI4-0000Ix-J0
        for netdev@vger.kernel.org; Sun, 17 Oct 2021 23:01:56 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 71CFF695F08
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 21:01:49 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id EB87D695EB3;
        Sun, 17 Oct 2021 21:01:44 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 075233f5;
        Sun, 17 Oct 2021 21:01:43 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Ziyang Xuan <william.xuanziyang@huawei.com>,
        stable@vger.kernel.org,
        syzbot+78bab6958a614b0c80b9@syzkaller.appspotmail.com,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 05/11] can: isotp: isotp_sendmsg(): add result check for wait_event_interruptible()
Date:   Sun, 17 Oct 2021 23:01:36 +0200
Message-Id: <20211017210142.2108610-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211017210142.2108610-1-mkl@pengutronix.de>
References: <20211017210142.2108610-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

Using wait_event_interruptible() to wait for complete transmission,
but do not check the result of wait_event_interruptible() which can be
interrupted. It will result in TX buffer has multiple accessors and
the later process interferes with the previous process.

Following is one of the problems reported by syzbot.

=============================================================
WARNING: CPU: 0 PID: 0 at net/can/isotp.c:840 isotp_tx_timer_handler+0x2e0/0x4c0
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.13.0-rc7+ #68
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
RIP: 0010:isotp_tx_timer_handler+0x2e0/0x4c0
Call Trace:
 <IRQ>
 ? isotp_setsockopt+0x390/0x390
 __hrtimer_run_queues+0xb8/0x610
 hrtimer_run_softirq+0x91/0xd0
 ? rcu_read_lock_sched_held+0x4d/0x80
 __do_softirq+0xe8/0x553
 irq_exit_rcu+0xf8/0x100
 sysvec_apic_timer_interrupt+0x9e/0xc0
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20

Add result check for wait_event_interruptible() in isotp_sendmsg()
to avoid multiple accessers for tx buffer.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://lore.kernel.org/all/10ca695732c9dd267c76a3c30f37aefe1ff7e32f.1633764159.git.william.xuanziyang@huawei.com
Cc: stable@vger.kernel.org
Reported-by: syzbot+78bab6958a614b0c80b9@syzkaller.appspotmail.com
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index caaa532ece94..2ac29c2b2ca6 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -865,7 +865,9 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 			return -EAGAIN;
 
 		/* wait for complete transmission of current pdu */
-		wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
+		err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
+		if (err)
+			return err;
 	}
 
 	if (!size || size > MAX_MSG_LENGTH)
-- 
2.33.0


