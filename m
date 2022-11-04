Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A296D619062
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 06:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbiKDFt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 01:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbiKDFsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 01:48:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF33D27B31;
        Thu,  3 Nov 2022 22:48:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F204D620D1;
        Fri,  4 Nov 2022 05:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B04C4347C;
        Fri,  4 Nov 2022 05:48:48 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1oqpZq-00716l-3C;
        Fri, 04 Nov 2022 01:49:14 -0400
Message-ID: <20221104054914.824782154@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 04 Nov 2022 01:41:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org
Subject: [RFC][PATCH v3 16/33] timers: mISDN: Use timer_shutdown_sync() before freeing timer
References: <20221104054053.431922658@goodmis.org>
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
timer_shutdown() (where sync is not possible in the context).

Link: https://lore.kernel.org/all/20220407161745.7d6754b3@gandalf.local.home/

Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c | 6 ++----
 drivers/isdn/mISDN/l1oip_core.c        | 4 ++--
 drivers/isdn/mISDN/timerdev.c          | 4 ++--
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 4f7eaa17fb27..9c15c2c30e88 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -4543,10 +4543,8 @@ release_port(struct hfc_multi *hc, struct dchannel *dch)
 
 	spin_lock_irqsave(&hc->lock, flags);
 
-	if (dch->timer.function) {
-		del_timer(&dch->timer);
-		dch->timer.function = NULL;
-	}
+	if (dch->timer.function)
+		timer_shutdown(&dch->timer);
 
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
