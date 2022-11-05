Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1816E61D7B7
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 07:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiKEGBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 02:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiKEGBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 02:01:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1C330F5F;
        Fri,  4 Nov 2022 23:01:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8683460A47;
        Sat,  5 Nov 2022 06:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DE5C43148;
        Sat,  5 Nov 2022 06:01:29 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1orCFh-007Omi-1s;
        Sat, 05 Nov 2022 02:01:57 -0400
Message-ID: <20221105060157.411823877@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 05 Nov 2022 02:00:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org
Subject: [PATCH v4a 14/38] timers: mISDN: Use timer_shutdown_sync() before freeing timer
References: <20221105060024.598488967@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Before a timer is freed, timer_shutdown_sync() must be called, or at least
timer_shutdown() (where sync is not possible in the context). Also remove
the open coded "shutting down", and remove the unnecessary if statement of
timer->function existing before calling timer_shutdown().

Link: https://lore.kernel.org/all/20221104054053.431922658@goodmis.org/

Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c | 5 +----
 drivers/isdn/mISDN/l1oip_core.c        | 4 ++--
 drivers/isdn/mISDN/timerdev.c          | 4 ++--
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 4f7eaa17fb27..c7bb39c6b826 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -4543,10 +4543,7 @@ release_port(struct hfc_multi *hc, struct dchannel *dch)
 
 	spin_lock_irqsave(&hc->lock, flags);
 
-	if (dch->timer.function) {
-		del_timer(&dch->timer);
-		dch->timer.function = NULL;
-	}
+	timer_shutdown(&dch->timer);
 
 	if (hc->ctype == HFC_TYPE_E1) { /* E1 */
 		/* remove sync */
diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index a77195e378b7..182e3f489c60 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -1236,8 +1236,8 @@ release_card(struct l1oip *hc)
 
 	hc->shutdown = true;
 
-	del_timer_sync(&hc->keep_tl);
-	del_timer_sync(&hc->timeout_tl);
+	timer_shutdown_sync(&hc->keep_tl);
+	timer_shutdown_sync(&hc->timeout_tl);
 
 	cancel_work_sync(&hc->workq);
 
diff --git a/drivers/isdn/mISDN/timerdev.c b/drivers/isdn/mISDN/timerdev.c
index abdf36ac3bee..83d6b484d3c6 100644
--- a/drivers/isdn/mISDN/timerdev.c
+++ b/drivers/isdn/mISDN/timerdev.c
@@ -74,7 +74,7 @@ mISDN_close(struct inode *ino, struct file *filep)
 	while (!list_empty(list)) {
 		timer = list_first_entry(list, struct mISDNtimer, list);
 		spin_unlock_irq(&dev->lock);
-		del_timer_sync(&timer->tl);
+		timer_shutdown_sync(&timer->tl);
 		spin_lock_irq(&dev->lock);
 		/* it might have been moved to ->expired */
 		list_del(&timer->list);
@@ -204,7 +204,7 @@ misdn_del_timer(struct mISDNtimerdev *dev, int id)
 			list_del_init(&timer->list);
 			timer->id = -1;
 			spin_unlock_irq(&dev->lock);
-			del_timer_sync(&timer->tl);
+			timer_shutdown_sync(&timer->tl);
 			kfree(timer);
 			return id;
 		}
-- 
2.35.1
