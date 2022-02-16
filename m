Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3824B7DCB
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 03:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343776AbiBPCgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 21:36:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244735AbiBPCgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 21:36:19 -0500
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 79255F5412;
        Tue, 15 Feb 2022 18:36:07 -0800 (PST)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app2 (Coremail) with SMTP id by_KCgAX_nAGYwxi0LrrAQ--.36391S2;
        Wed, 16 Feb 2022 10:35:55 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org
Cc:     ajk@comnets.uni-bremen.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH] drivers: hamradio: 6pack: fix UAF bug caused by mod_timer()
Date:   Wed, 16 Feb 2022 10:35:49 +0800
Message-Id: <20220216023549.50223-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgAX_nAGYwxi0LrrAQ--.36391S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr45Zr1rJr1DtrWxCFy3Jwb_yoW8try3pr
        Z8Jryftw4ktrW5tw4kAFs5Wrn5uFs5J3yxCrsag3sIvFnxJr1YgFyqvryUXFW2kFZ5Aa47
        AF4rZr9xAF15C3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgwNAVZdtYEE3QAes6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although del_timer_sync() in sixpack_close() waits for the timer handler
to finish its execution and then releases the timer, the mod_timer()
in sp_xmit_on_air() could be called by userspace syscall such as
ax25_sendmsg(), ax25_connect() and ax25_ioctl() and wakes up the timer
again. If the timer uses sp_xmit_on_air() to write data on pty work queue
that already released by unregister_netdev(), the UAF bug will happen.

One of the possible race conditions is shown below:

      (USE)                     |      (FREE)
ax25_sendmsg()                  |
  ax25_queue_xmit()             |
    ...                         |
    sp_encaps()                 |  sixpack_close()
      sp_xmit_on_air()          |    del_timer_sync(&sp->tx_t)
        mod_timer(&sp->tx_t,..) |    ...
        (wait a while)          |    unregister_netdev(sp->dev)) //FREE
      sp_xmit_on_air()          |    ...
        pty_write()             |
          queue_work_on() //USE |

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

This patch add condition check in sp_xmit_on_air(). If the
registration status of net_device is not equal to NETREG_REGISTERED,
the sp_xmit_on_air() will not write data to pty work queue and
return instead.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 drivers/net/hamradio/6pack.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index b1fc153125d..7ee25e06915 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -141,7 +141,8 @@ static void sp_xmit_on_air(struct timer_list *t)
 	struct sixpack *sp = from_timer(sp, t, tx_t);
 	int actual, when = sp->slottime;
 	static unsigned char random;
-
+	if (sp->dev->reg_state !=  NETREG_REGISTERED)
+		return;
 	random = random * 17 + 41;
 
 	if (((sp->status1 & SIXP_DCD_MASK) == 0) && (random < sp->persistence)) {
-- 
2.17.1

