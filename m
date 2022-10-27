Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F07860FB53
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 17:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236274AbiJ0PJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 11:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236042AbiJ0PJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 11:09:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C0518F26C;
        Thu, 27 Oct 2022 08:09:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BADD0B82686;
        Thu, 27 Oct 2022 15:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70659C43470;
        Thu, 27 Oct 2022 15:09:11 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1oo4Va-00BvUr-1D;
        Thu, 27 Oct 2022 11:09:26 -0400
Message-ID: <20221027150926.201144139@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 27 Oct 2022 11:05:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [RFC][PATCH v2 06/31] timers: atm: Use del_timer_shutdown() before freeing timer
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

Cc: Chas Williams <3chas3@gmail.com>
Cc: linux-atm-general@lists.sourceforge.net
Cc: netdev@vger.kernel.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 drivers/atm/idt77105.c | 4 ++--
 drivers/atm/idt77252.c | 4 ++--
 drivers/atm/iphase.c   | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/atm/idt77105.c b/drivers/atm/idt77105.c
index bfca7b8a6f31..2e7806ae251b 100644
--- a/drivers/atm/idt77105.c
+++ b/drivers/atm/idt77105.c
@@ -366,8 +366,8 @@ EXPORT_SYMBOL(idt77105_init);
 static void __exit idt77105_exit(void)
 {
 	/* turn off timers */
-	del_timer_sync(&stats_timer);
-	del_timer_sync(&restart_timer);
+	del_timer_shutdown(&stats_timer);
+	del_timer_shutdown(&restart_timer);
 }
 
 module_exit(idt77105_exit);
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 681cb3786794..fdb1151f1f32 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -2213,7 +2213,7 @@ idt77252_init_ubr(struct idt77252_dev *card, struct vc_map *vc,
 	}
 	spin_unlock_irqrestore(&vc->lock, flags);
 	if (est) {
-		del_timer_sync(&est->timer);
+		del_timer_shutdown(&est->timer);
 		kfree(est);
 	}
 
@@ -3752,7 +3752,7 @@ static void __exit idt77252_exit(void)
 		card = idt77252_chain;
 		dev = card->atmdev;
 		idt77252_chain = card->next;
-		del_timer_sync(&card->tst_timer);
+		del_timer_shutdown(&card->tst_timer);
 
 		if (dev->phy->stop)
 			dev->phy->stop(dev);
diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 324148686953..74eed1816f58 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -3280,7 +3280,7 @@ static void __exit ia_module_exit(void)
 {
 	pci_unregister_driver(&ia_driver);
 
-	del_timer_sync(&ia_timer);
+	del_timer_shutdown(&ia_timer);
 }
 
 module_init(ia_module_init);
-- 
2.35.1
