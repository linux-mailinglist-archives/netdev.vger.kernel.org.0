Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01206FC2E4
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfKNJpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:45:54 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53063 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfKNJpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 04:45:53 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iVBhI-0003nz-8p; Thu, 14 Nov 2019 10:45:52 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jouni Hogander <jouni.hogander@unikie.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] slcan: Fix memory leak in error path
Date:   Thu, 14 Nov 2019 10:45:48 +0100
Message-Id: <20191114094548.4867-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191114094548.4867-1-mkl@pengutronix.de>
References: <20191114094548.4867-1-mkl@pengutronix.de>
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

This patch is fixing memory leak reported by Syzkaller:

BUG: memory leak unreferenced object 0xffff888067f65500 (size 4096):
  comm "syz-executor043", pid 454, jiffies 4294759719 (age 11.930s)
  hex dump (first 32 bytes):
    73 6c 63 61 6e 30 00 00 00 00 00 00 00 00 00 00 slcan0..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
  backtrace:
    [<00000000a06eec0d>] __kmalloc+0x18b/0x2c0
    [<0000000083306e66>] kvmalloc_node+0x3a/0xc0
    [<000000006ac27f87>] alloc_netdev_mqs+0x17a/0x1080
    [<0000000061a996c9>] slcan_open+0x3ae/0x9a0
    [<000000001226f0f9>] tty_ldisc_open.isra.1+0x76/0xc0
    [<0000000019289631>] tty_set_ldisc+0x28c/0x5f0
    [<000000004de5a617>] tty_ioctl+0x48d/0x1590
    [<00000000daef496f>] do_vfs_ioctl+0x1c7/0x1510
    [<0000000059068dbc>] ksys_ioctl+0x99/0xb0
    [<000000009a6eb334>] __x64_sys_ioctl+0x78/0xb0
    [<0000000053d0332e>] do_syscall_64+0x16f/0x580
    [<0000000021b83b99>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<000000008ea75434>] 0xffffffffffffffff

Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/slcan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index bb6032211043..0a9f42e5fedf 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -617,6 +617,7 @@ static int slcan_open(struct tty_struct *tty)
 	sl->tty = NULL;
 	tty->disc_data = NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
+	free_netdev(sl->dev);
 
 err_exit:
 	rtnl_unlock();
-- 
2.24.0

