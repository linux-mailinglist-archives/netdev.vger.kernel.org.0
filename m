Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 440C116BBF9
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 09:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbgBYIjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 03:39:55 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57311 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgBYIjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 03:39:55 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1j6Vkt-0003Ti-Q8; Tue, 25 Feb 2020 09:39:51 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     "linux-can @ vger . kernel . org" <linux-can@vger.kernel.org>
Cc:     kernel@pengutronix.de, glider@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        syzbot+9bcb0c9409066696d3aa@syzkaller.appspotmail.com
Subject: [PATCH v2] can: af_can: can_rcv() canfd_rcv(): Fix access of uninitialized memory or out of bounds
Date:   Tue, 25 Feb 2020 09:39:50 +0100
Message-Id: <20200225083950.2542543-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.25.0
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

Syzbot found the use of uninitialzied memory when injecting non conformant
CANFD frames via a tun device into the kernel:

| BUG: KMSAN: uninit-value in number+0x9f8/0x2000 lib/vsprintf.c:459
| CPU: 1 PID: 11897 Comm: syz-executor136 Not tainted 5.6.0-rc2-syzkaller #0
| Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
| Call Trace:
|  __dump_stack lib/dump_stack.c:77 [inline]
|  dump_stack+0x1c9/0x220 lib/dump_stack.c:118
|  kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
|  __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
|  number+0x9f8/0x2000 lib/vsprintf.c:459
|  vsnprintf+0x1d85/0x31b0 lib/vsprintf.c:2640
|  vscnprintf+0xc2/0x180 lib/vsprintf.c:2677
|  vprintk_store+0xef/0x11d0 kernel/printk/printk.c:1917
|  vprintk_emit+0x2c0/0x860 kernel/printk/printk.c:1984
|  vprintk_default+0x90/0xa0 kernel/printk/printk.c:2029
|  vprintk_func+0x636/0x820 kernel/printk/printk_safe.c:386
|  printk+0x18b/0x1d3 kernel/printk/printk.c:2062
|  canfd_rcv+0x370/0x3a0 net/can/af_can.c:697
|  __netif_receive_skb_one_core net/core/dev.c:5198 [inline]
|  __netif_receive_skb net/core/dev.c:5312 [inline]
|  netif_receive_skb_internal net/core/dev.c:5402 [inline]
|  netif_receive_skb+0xe77/0xf20 net/core/dev.c:5461
|  tun_rx_batched include/linux/skbuff.h:4321 [inline]
|  tun_get_user+0x6aef/0x6f60 drivers/net/tun.c:1997
|  tun_chr_write_iter+0x1f2/0x360 drivers/net/tun.c:2026
|  call_write_iter include/linux/fs.h:1901 [inline]
|  new_sync_write fs/read_write.c:483 [inline]
|  __vfs_write+0xa5a/0xca0 fs/read_write.c:496
|  vfs_write+0x44a/0x8f0 fs/read_write.c:558
|  ksys_write+0x267/0x450 fs/read_write.c:611
|  __do_sys_write fs/read_write.c:623 [inline]
|  __se_sys_write+0x92/0xb0 fs/read_write.c:620
|  __x64_sys_write+0x4a/0x70 fs/read_write.c:620
|  do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
|  entry_SYSCALL_64_after_hwframe+0x44/0xa9

In canfd_rcv() the non conformant CANFD frame (i.e. skb too short) is detected,
but the pr_warn_once() accesses uninitialized memory or the skb->data out of
bounds to print the warning message.

This problem exists in both can_rcv() and canfd_rcv(). This patch removes the
access to the skb->data from the pr_warn_once() in both functions.

Reported-by: syzbot+9bcb0c9409066696d3aa@syzkaller.appspotmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
Hello,

changes since RFC:
- print cfd->len if backed by skb, -1 otherwise
  (Requested by Oliver)

Marc

 net/can/af_can.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 7511bfae2e0d..38b7aaa6b286 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -678,7 +678,9 @@ static int can_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CAN_MTU ||
 		     cfd->len > CAN_MAX_DLEN)) {
 		pr_warn_once("PF_CAN: dropped non conform CAN skbuf: dev type %d, len %d, datalen %d\n",
-			     dev->type, skb->len, cfd->len);
+			     dev->type, skb->len,
+			     skb->len >= offsetof(struct canfd_frame, len) +
+			     sizeof(cfd->len) ? cfd->len : -1);
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
@@ -695,7 +697,9 @@ static int canfd_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CANFD_MTU ||
 		     cfd->len > CANFD_MAX_DLEN)) {
 		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuf: dev type %d, len %d, datalen %d\n",
-			     dev->type, skb->len, cfd->len);
+			     dev->type, skb->len,
+			     skb->len >= offsetof(struct canfd_frame, len) +
+			     sizeof(cfd->len) ? cfd->len : -1);
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
-- 
2.25.0

