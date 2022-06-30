Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178C3561E40
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 16:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbiF3Ojz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 10:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235373AbiF3Ojc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 10:39:32 -0400
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id C7D69DC9;
        Thu, 30 Jun 2022 07:39:12 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [221.192.178.120])
        by mail-app2 (Coremail) with SMTP id by_KCgA3P4t1tb1i0uLmAg--.61459S2;
        Thu, 30 Jun 2022 22:38:53 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, ralf@linux-mips.org,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net] net: rose: fix UAF bug caused by rose_t0timer_expiry
Date:   Thu, 30 Jun 2022 22:38:42 +0800
Message-Id: <20220630143842.24906-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgA3P4t1tb1i0uLmAg--.61459S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar1ftFyktw4DJryUAr1xuFg_yoW8ur1kpF
        WYkr13Jrs3J3yqgFW8ZF4kZrW7Gw4DJFy7GF18CFWSy3Z7Jr4YvF1Dtry8ZF4xAFWkCFya
        grykWry3A3ZIyrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkS14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6ry5
        MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
        W8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUrpBTUUUUU
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgsRAVZdtaeZYQBWsu
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

This patch changes del_timer() in rose_stop_t0timer() and
rose_stop_ftimer() to del_timer_sync() in order that the
timer handler could be finished before the resources such as
rose_neigh and so on are deallocated. As a result, the UAF
bugs could be mitigated.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 net/rose/rose_link.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
index 8b96a56d3a4..9734d1264de 100644
--- a/net/rose/rose_link.c
+++ b/net/rose/rose_link.c
@@ -54,12 +54,12 @@ static void rose_start_t0timer(struct rose_neigh *neigh)
 
 void rose_stop_ftimer(struct rose_neigh *neigh)
 {
-	del_timer(&neigh->ftimer);
+	del_timer_sync(&neigh->ftimer);
 }
 
 void rose_stop_t0timer(struct rose_neigh *neigh)
 {
-	del_timer(&neigh->t0timer);
+	del_timer_sync(&neigh->t0timer);
 }
 
 int rose_ftimer_running(struct rose_neigh *neigh)
-- 
2.17.1

