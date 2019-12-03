Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F41E910FBFF
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 11:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfLCKrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 05:47:22 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50375 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfLCKrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 05:47:09 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ic5hz-0001BG-Bk; Tue, 03 Dec 2019 11:47:07 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jouni Hogander <jouni.hogander@unikie.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Subject: [PATCH 3/6] can: slcan: Fix use-after-free Read in slcan_open
Date:   Tue,  3 Dec 2019 11:47:00 +0100
Message-Id: <20191203104703.14620-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203104703.14620-1-mkl@pengutronix.de>
References: <20191203104703.14620-1-mkl@pengutronix.de>
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

From: Jouni Hogander <jouni.hogander@unikie.com>

Slcan_open doesn't clean-up device which registration failed from the
slcan_devs device list. On next open this list is iterated and freed
device is accessed. Fix this by calling slc_free_netdev in error path.

Driver/net/can/slcan.c is derived from slip.c. Use-after-free error was
identified in slip_open by syzboz. Same bug is in slcan.c. Here is the
trace from the Syzbot slip report:

__dump_stack lib/dump_stack.c:77 [inline]
dump_stack+0x197/0x210 lib/dump_stack.c:118
print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
__kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
kasan_report+0x12/0x20 mm/kasan/common.c:634
__asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
sl_sync drivers/net/slip/slip.c:725 [inline]
slip_open+0xecd/0x11b7 drivers/net/slip/slip.c:801
tty_ldisc_open.isra.0+0xa3/0x110 drivers/tty/tty_ldisc.c:469
tty_set_ldisc+0x30e/0x6b0 drivers/tty/tty_ldisc.c:596
tiocsetd drivers/tty/tty_io.c:2334 [inline]
tty_ioctl+0xe8d/0x14f0 drivers/tty/tty_io.c:2594
vfs_ioctl fs/ioctl.c:46 [inline]
file_ioctl fs/ioctl.c:509 [inline]
do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
__do_sys_ioctl fs/ioctl.c:720 [inline]
__se_sys_ioctl fs/ioctl.c:718 [inline]
__x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: ed50e1600b44 ("slcan: Fix memory leak in error path")
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: David Miller <davem@davemloft.net>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v5.4
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/slcan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 0a9f42e5fedf..2e57122f02fb 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -617,6 +617,7 @@ static int slcan_open(struct tty_struct *tty)
 	sl->tty = NULL;
 	tty->disc_data = NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
+	slc_free_netdev(sl->dev);
 	free_netdev(sl->dev);
 
 err_exit:
-- 
2.24.0

