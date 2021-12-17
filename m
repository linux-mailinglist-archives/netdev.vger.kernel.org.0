Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB2B478302
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 03:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhLQCOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 21:14:07 -0500
Received: from spam.zju.edu.cn ([61.164.42.155]:47158 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229449AbhLQCOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 21:14:06 -0500
Received: from localhost.localdomain (unknown [222.205.0.213])
        by mail-app2 (Coremail) with SMTP id by_KCgB3fMBm8rthNrdgAA--.6886S4;
        Fri, 17 Dec 2021 10:14:00 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jirislaby@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Lin Ma <linma@zju.edu.cn>
Subject: [PATCH v0] hamradio: improve the incomplete fix to avoid NPD
Date:   Fri, 17 Dec 2021 10:13:56 +0800
Message-Id: <20211217021356.27322-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: by_KCgB3fMBm8rthNrdgAA--.6886S4
X-Coremail-Antispam: 1UD129KBjvJXoW7uF15Ary7AFWDGF47Cr1Dtrb_yoW8CFWkpF
        45Ka4akF4kJr1kAw4DAFWkZFyDXFsrtayUur4I934q9w4qyr1UZr10ga4j9r1UurZ3Arya
        vF15A3yIqF1Fy3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkF1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2
        jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
        x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
        GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
        8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv
        6cx26r4fKr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGw
        C20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48J
        MIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMI
        IF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E
        87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous commit 3e0588c291d6 ("hamradio: defer ax25 kfree after
unregister_netdev") reorder the kfree operations and unregister_netdev
operation to prevent UAF.

This commit improves the previous one by also deferring the nullify of
the ax->tty pointer. Otherwise, a NULL pointer dereference bug occurs.
Partial of the stack trace is shown below.

BUG: kernel NULL pointer dereference, address: 0000000000000538
RIP: 0010:ax_xmit+0x1f9/0x400
...
Call Trace:
 dev_hard_start_xmit+0xec/0x320
 sch_direct_xmit+0xea/0x240
 __qdisc_run+0x166/0x5c0
 __dev_queue_xmit+0x2c7/0xaf0
 ax25_std_establish_data_link+0x59/0x60
 ax25_connect+0x3a0/0x500
 ? security_socket_connect+0x2b/0x40
 __sys_connect+0x96/0xc0
 ? __hrtimer_init+0xc0/0xc0
 ? common_nsleep+0x2e/0x50
 ? switch_fpu_return+0x139/0x1a0
 __x64_sys_connect+0x11/0x20
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The crash point is shown as below

static void ax_encaps(...) {
  ...
  set_bit(TTY_DO_WRITE_WAKEUP, &ax->tty->flags); // ax->tty = NULL!
  ...
}

By placing the nullify action after the unregister_netdev, the ax->tty
pointer won't be assigned as NULL net_device framework layer is well
synchronized.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 drivers/net/hamradio/mkiss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 7da2bb8a443c..edde9c3ae12b 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -794,14 +794,14 @@ static void mkiss_close(struct tty_struct *tty)
 	 */
 	netif_stop_queue(ax->dev);
 
-	ax->tty = NULL;
-
 	unregister_netdev(ax->dev);
 
 	/* Free all AX25 frame buffers after unreg. */
 	kfree(ax->rbuff);
 	kfree(ax->xbuff);
 
+	ax->tty = NULL;
+
 	free_netdev(ax->dev);
 }
 
-- 
2.33.1

