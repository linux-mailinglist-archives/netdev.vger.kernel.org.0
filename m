Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0CD60FB51
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 17:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236217AbiJ0PJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 11:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236002AbiJ0PJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 11:09:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54D918F263;
        Thu, 27 Oct 2022 08:09:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FE3362393;
        Thu, 27 Oct 2022 15:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4ECC433D6;
        Thu, 27 Oct 2022 15:09:13 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1oo4Vc-00BvaW-18;
        Thu, 27 Oct 2022 11:09:28 -0400
Message-ID: <20221027150928.182961808@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 27 Oct 2022 11:05:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org
Subject: [RFC][PATCH v2 16/31] timers: mISDN: Use del_timer_shutdown() before freeing timer
References: <20221027150525.753064657@goodmis.org>
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

Before a timer is freed, del_timer_shutdown() must be called.

Link: https://lore.kernel.org/all/20220407161745.7d6754b3@gandalf.local.home/

Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c | 2 +-
 drivers/isdn/mISDN/l1oip_core.c        | 4 ++--
 drivers/isdn/mISDN/timerdev.c          | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 4f7eaa17fb27..8a212c17a093 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -4544,7 +4544,7 @@ release_port(struct hfc_multi *hc, struct dchannel *dch)
 	spin_lock_irqsave(&hc->lock, flags);
 
 	if (dch->timer.function) {
-		del_timer(&dch->timer);
+		del_timer_shutdown(&dch->timer);
 		dch->timer.function = NULL;
 	}
 
diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index a77195e378b7..2d4b19e7d48b 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -1236,8 +1236,8 @@ release_card(struct l1oip *hc)
 
 	hc->shutdown = true;
 
-	del_timer_sync(&hc->keep_tl);
-	del_timer_sync(&hc->timeout_tl);
+	del_timer_shutdown(&hc->keep_tl);
+	del_timer_shutdown(&hc->timeout_tl);
 
 	cancel_work_sync(&hc->workq);
 
diff --git a/drivers/isdn/mISDN/timerdev.c b/drivers/isdn/mISDN/timerdev.c
index abdf36ac3bee..9d69efb8a1bc 100644
--- a/drivers/isdn/mISDN/timerdev.c
+++ b/drivers/isdn/mISDN/timerdev.c
@@ -74,7 +74,7 @@ mISDN_close(struct inode *ino, struct file *filep)
 	while (!list_empty(list)) {
 		timer = list_first_entry(list, struct mISDNtimer, list);
 		spin_unlock_irq(&dev->lock);
-		del_timer_sync(&timer->tl);
+		del_timer_shutdown(&timer->tl);
 		spin_lock_irq(&dev->lock);
 		/* it might have been moved to ->expired */
 		list_del(&timer->list);
@@ -204,7 +204,7 @@ misdn_del_timer(struct mISDNtimerdev *dev, int id)
 			list_del_init(&timer->list);
 			timer->id = -1;
 			spin_unlock_irq(&dev->lock);
-			del_timer_sync(&timer->tl);
+			del_timer_shutdown(&timer->tl);
 			kfree(timer);
 			return id;
 		}
-- 
2.35.1
