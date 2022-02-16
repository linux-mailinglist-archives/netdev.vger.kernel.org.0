Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128C84B8D00
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 16:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbiBPP5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 10:57:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbiBPP5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 10:57:03 -0500
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 632C11A1323;
        Wed, 16 Feb 2022 07:56:44 -0800 (PST)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app3 (Coremail) with SMTP id cC_KCgAHz_CsHg1iQGxcDQ--.13121S2;
        Wed, 16 Feb 2022 23:56:34 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org
Cc:     kuba@kernel.org, ajk@comnets.uni-bremen.de, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH V2] drivers: hamradio: 6pack: fix UAF bug caused by mod_timer()
Date:   Wed, 16 Feb 2022 23:56:04 +0800
Message-Id: <20220216155604.92827-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgAHz_CsHg1iQGxcDQ--.13121S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGw4rZw1fuw1xGFy3GryrCrg_yoW5GryrpF
        Z8GryfJw48trZ8JrsrJa1kWr95uFsYyay8Crs3u3sI9FsxZr1j9F1UKFWvvF4UCrs3Aay7
        AF1rJry7AF15A3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkI1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxF
        aVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
        4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxG
        rwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8Jw
        CI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2
        z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgIDAVZdtYL+yAAFsN
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although del_timer_sync() in sixpack_close() won't return if
there is an active timer, we could use mod_timer() in
sp_xmit_on_air() to wake up timer again by calling userspace
syscall such as ax25_sendmsg(), ax25_connect() and ax25_ioctl().
If sp_xmit_on_air() registered as a callback function in
timer_setup() calls pty_write() to use tty resources that
already released by tty_release(), the UAF bug will happen.

One of the possible race conditions is shown below:

      (USE)                      |      (FREE)
ax25_sendmsg()                   |
 ax25_queue_xmit()               |
  ...                            |
  sp_xmit()                      |
   sp_encaps()                   | sixpack_close()
    sp_xmit_on_air()             |  del_timer_sync(&sp->tx_t)
     mod_timer(&sp->tx_t,...)    |  ...
                                 |  unregister_netdev()
                                 |  ...
     (wait a while)              | tty_release()
                                 |  tty_release_struct()
                                 |   release_tty()
    sp_xmit_on_air()             |    tty_kref_put(tty_struct) //FREE
     pty_write(tty_struct) //USE |    ...

The corresponding fail log is shown below:
===============================================================
BUG: KASAN: use-after-free in __run_timers.part.0+0x170/0x470
Write of size 8 at addr ffff88800a652ab8 by task swapper/2/0
...
Call Trace:
  ...
  queue_work_on+0x3f/0x50
  pty_write+0xcd/0xe0pty_write+0xcd/0xe0
  sp_xmit_on_air+0xb2/0x1f0
  call_timer_fn+0x28/0x150
  __run_timers.part.0+0x3c2/0x470
  run_timer_softirq+0x3b/0x80
  __do_softirq+0xf1/0x380
  ...

This patch reorders the del_timer_sync() after the unregister_netdev()
to avoid UAF bugs. Because the unregister_netdev() is well synchronized,
it flushs out any pending queues, waits the refcount of net_device
decreases to zero and removes net_device from kernel. There is not any
running routines after executing unregister_netdev(). Therefore, we could
not arouse timer from userspace again.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in V2:
  - Make the commit message more clearer.
  - Modify the patch code.
---
 drivers/net/hamradio/6pack.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index b1fc153125d..45c3c4a1101 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -668,11 +668,11 @@ static void sixpack_close(struct tty_struct *tty)
 	 */
 	netif_stop_queue(sp->dev);
 
+	unregister_netdev(sp->dev);
+
 	del_timer_sync(&sp->tx_t);
 	del_timer_sync(&sp->resync_t);
 
-	unregister_netdev(sp->dev);
-
 	/* Free all 6pack frame buffers after unreg. */
 	kfree(sp->rbuff);
 	kfree(sp->xbuff);
-- 
2.17.1

