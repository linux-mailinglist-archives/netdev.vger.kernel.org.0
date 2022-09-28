Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7C05EDDE5
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 15:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbiI1NkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 09:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234188AbiI1Njx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 09:39:53 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9FF3774DF7;
        Wed, 28 Sep 2022 06:39:49 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.192.100.195])
        by mail-app3 (Coremail) with SMTP id cC_KCgCn_g2bTjRjFHUyBw--.42262S2;
        Wed, 28 Sep 2022 21:39:46 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, isdn@linux-pingi.de, kuba@kernel.org,
        leon@kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH V4] mISDN: fix use-after-free bugs in l1oip timer handlers
Date:   Wed, 28 Sep 2022 21:39:38 +0800
Message-Id: <20220928133938.86143-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgCn_g2bTjRjFHUyBw--.42262S2
X-Coremail-Antispam: 1UD129KBjvJXoWxuF4fuFW7Gw4kGrWxXw1DWrg_yoW5Aw4xpF
        WjgwsFyr48XFW7AF47Aw1kZF95G3Z5ta4UJF98K3yfZrnrXryfXF10ya40qFWUGF93X3ya
        qF18Xr43GF98ZrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUka1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y
        6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v
        1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr
        1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
        x4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUp6wZUUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAggHAVZdtbsnvwACsT
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
those timers right back in. We add a bool flag to show
if card is released. Then, check this flag in hc->workq
and hc->socket_thread.

Fixes: 3712b42d4b1b ("Add layer1 over IP support")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in v4:
  - Use bool flag to judge whether card is released.

 drivers/isdn/mISDN/l1oip.h      |  1 +
 drivers/isdn/mISDN/l1oip_core.c | 13 +++++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/mISDN/l1oip.h b/drivers/isdn/mISDN/l1oip.h
index 7ea10db20e3..48133d02281 100644
--- a/drivers/isdn/mISDN/l1oip.h
+++ b/drivers/isdn/mISDN/l1oip.h
@@ -59,6 +59,7 @@ struct l1oip {
 	int			bundle;		/* bundle channels in one frm */
 	int			codec;		/* codec to use for transmis. */
 	int			limit;		/* limit number of bchannels */
+	bool			shutdown;	/* if card is released */
 
 	/* timer */
 	struct timer_list	keep_tl;
diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index 2c40412466e..a77195e378b 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -275,7 +275,7 @@ l1oip_socket_send(struct l1oip *hc, u8 localcodec, u8 channel, u32 chanmask,
 	p = frame;
 
 	/* restart timer */
-	if (time_before(hc->keep_tl.expires, jiffies + 5 * HZ))
+	if (time_before(hc->keep_tl.expires, jiffies + 5 * HZ) && !hc->shutdown)
 		mod_timer(&hc->keep_tl, jiffies + L1OIP_KEEPALIVE * HZ);
 	else
 		hc->keep_tl.expires = jiffies + L1OIP_KEEPALIVE * HZ;
@@ -601,7 +601,9 @@ l1oip_socket_parse(struct l1oip *hc, struct sockaddr_in *sin, u8 *buf, int len)
 		goto multiframe;
 
 	/* restart timer */
-	if (time_before(hc->timeout_tl.expires, jiffies + 5 * HZ) || !hc->timeout_on) {
+	if ((time_before(hc->timeout_tl.expires, jiffies + 5 * HZ) ||
+	     !hc->timeout_on) &&
+	    !hc->shutdown) {
 		hc->timeout_on = 1;
 		mod_timer(&hc->timeout_tl, jiffies + L1OIP_TIMEOUT * HZ);
 	} else /* only adjust timer */
@@ -1232,11 +1234,10 @@ release_card(struct l1oip *hc)
 {
 	int	ch;
 
-	if (timer_pending(&hc->keep_tl))
-		del_timer(&hc->keep_tl);
+	hc->shutdown = true;
 
-	if (timer_pending(&hc->timeout_tl))
-		del_timer(&hc->timeout_tl);
+	del_timer_sync(&hc->keep_tl);
+	del_timer_sync(&hc->timeout_tl);
 
 	cancel_work_sync(&hc->workq);
 
-- 
2.17.1

