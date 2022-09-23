Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797EA5E7CEB
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 16:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbiIWO0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 10:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbiIWOZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 10:25:49 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E80D34DB2A;
        Fri, 23 Sep 2022 07:25:27 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.162.98.155])
        by mail-app4 (Coremail) with SMTP id cS_KCgDnet3LwS1jIEyIBg--.16445S2;
        Fri, 23 Sep 2022 22:25:22 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, isdn@linux-pingi.de, kuba@kernel.org,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH V2] mISDN: fix use-after-free bugs in l1oip timer handlers
Date:   Fri, 23 Sep 2022 22:25:14 +0800
Message-Id: <20220923142514.58838-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgDnet3LwS1jIEyIBg--.16445S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJrykJF13tryUJw1kCr15urg_yoW8urW7pF
        4Ygrnrtry8XrWjyF4DZrs7XFyrX3Z3tayUJF98K3yfZwn7Xr9xZr10y34FgF4UCF93XrsI
        qF1rZr45CF98ZFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkI1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
        6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v
        1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
        1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
        x4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgsCAVZdtbna-QAFsv
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The l1oip_cleanup() traverses the l1oip_ilist and calls
release_card() to cleanup module and stack. However,
release_card() calls del_timer() to delete the timers
such as keep_tl and timeout_tl. If the timer handler is
running, the del_timer() will not stop it and result in
UAF bugs. One of the processes is shown below:

    (cleanup routine)          |        (timer handler)
release_card()                 | l1oip_timeout()
 ...                           |
 del_timer()                   | ...
 ...                           |
 kfree(hc) //FREE              |
                               | hc->timeout_on = 0 //USE

Fix by calling del_timer_sync() in release_card(), which
makes sure the timer handlers have finished before the
resources, such as l1oip and so on, have been deallocated.

What's more, the hc->workq and hc->socket_thread can kick
those timers right back in. We use del_timer_sync(&hc->keep_tl)
and cancel_work_sync(&hc->keep_tl) twice to stop keep_tl timer
and hc->workq. Then, we add del_timer_sync(&hc->timeout_tl)
behind l1oip_socket_close() to stop timeout_tl timer.

Fixes: 3712b42d4b1b ("Add layer1 over IP support")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in v2:
  - Solve the problem that timers could be restarted by other threads.

 drivers/isdn/mISDN/l1oip_core.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index 2c40412466e..7b89d98a781 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -1232,17 +1232,16 @@ release_card(struct l1oip *hc)
 {
 	int	ch;
 
-	if (timer_pending(&hc->keep_tl))
-		del_timer(&hc->keep_tl);
-
-	if (timer_pending(&hc->timeout_tl))
-		del_timer(&hc->timeout_tl);
-
+	del_timer_sync(&hc->keep_tl);
+	cancel_work_sync(&hc->workq);
+	del_timer_sync(&hc->keep_tl);
 	cancel_work_sync(&hc->workq);
 
 	if (hc->socket_thread)
 		l1oip_socket_close(hc);
 
+	del_timer_sync(&hc->timeout_tl);
+
 	if (hc->registered && hc->chan[hc->d_idx].dch)
 		mISDN_unregister_device(&hc->chan[hc->d_idx].dch->dev);
 	for (ch = 0; ch < 128; ch++) {
-- 
2.17.1

