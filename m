Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B414566F6C
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 15:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbiGENin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 09:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiGENi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 09:38:29 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B96C7D1F3;
        Tue,  5 Jul 2022 05:59:34 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.190.65.210])
        by mail-app2 (Coremail) with SMTP id by_KCgAnzUHrNMRivCY+Aw--.58122S2;
        Tue, 05 Jul 2022 20:56:20 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net v2] net: rose: fix UAF bug caused by rose_t0timer_expiry
Date:   Tue,  5 Jul 2022 20:56:10 +0800
Message-Id: <20220705125610.77971-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgAnzUHrNMRivCY+Aw--.58122S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar1ftFyktw4DJryUAr1xuFg_yoW8uryrpF
        WYk343Grs3tw4UXFW8XFn7Zw4Ygw4DJry3Wr1xuFWSy3Z7Jr4YvF1kKFW8uF4xZFWkCFWa
        gr1kGry5AwnFqF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkF1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2
        jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
        x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
        GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
        8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv
        6cx26r4fKr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGw
        C20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48J
        MIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMI
        IF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E
        87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgoCAVZdtaiRogAtsD
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are UAF bugs caused by rose_t0timer_expiry(). The
root cause is that del_timer() could not stop the timer
handler that is running and there is no synchronization.
One of the race conditions is shown below:

    (thread 1)             |        (thread 2)
                           | rose_device_event
                           |   rose_rt_device_down
                           |     rose_remove_neigh
rose_t0timer_expiry        |       rose_stop_t0timer(rose_neigh)
  ...                      |         del_timer(&neigh->t0timer)
                           |         kfree(rose_neigh) //[1]FREE
  neigh->dce_mode //[2]USE |

The rose_neigh is deallocated in position [1] and use in
position [2].

The crash trace triggered by POC is like below:

BUG: KASAN: use-after-free in expire_timers+0x144/0x320
Write of size 8 at addr ffff888009b19658 by task swapper/0/0
...
Call Trace:
 <IRQ>
 dump_stack_lvl+0xbf/0xee
 print_address_description+0x7b/0x440
 print_report+0x101/0x230
 ? expire_timers+0x144/0x320
 kasan_report+0xed/0x120
 ? expire_timers+0x144/0x320
 expire_timers+0x144/0x320
 __run_timers+0x3ff/0x4d0
 run_timer_softirq+0x41/0x80
 __do_softirq+0x233/0x544
 ...

This patch changes rose_stop_ftimer() and rose_stop_t0timer()
in rose_remove_neigh() to del_timer_sync() in order that the
timer handler could be finished before the resources such as
rose_neigh and so on are deallocated. As a result, the UAF
bugs could be mitigated.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in v2:
  - v2: Use del_timer_sync to stop timer in rose_remove_neigh.

 net/rose/rose_route.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index fee6409c2bb..eb0b8197ac8 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -227,8 +227,8 @@ static void rose_remove_neigh(struct rose_neigh *rose_neigh)
 {
 	struct rose_neigh *s;
 
-	rose_stop_ftimer(rose_neigh);
-	rose_stop_t0timer(rose_neigh);
+	del_timer_sync(&rose_neigh->ftimer);
+	del_timer_sync(&rose_neigh->t0timer);
 
 	skb_queue_purge(&rose_neigh->queue);
 
-- 
2.17.1

