Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490A461D7D1
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 07:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiKEGCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 02:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiKEGBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 02:01:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AC631238;
        Fri,  4 Nov 2022 23:01:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3582960AB2;
        Sat,  5 Nov 2022 06:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10253C4347C;
        Sat,  5 Nov 2022 06:01:33 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1orCFl-007Oy1-0o;
        Sat, 05 Nov 2022 02:02:01 -0400
Message-ID: <20221105060201.081948530@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 05 Nov 2022 02:00:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH v4a 34/38] timers: atm: Use timer_shutdown_sync() before a module is released
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

Before a module is released, timer_shutdown_sync() must be called on its
timers.

Link: https://lore.kernel.org/all/20221104054053.431922658@goodmis.org/

Cc: Chas Williams <3chas3@gmail.com>
Cc: linux-atm-general@lists.sourceforge.net
Cc: netdev@vger.kernel.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 drivers/atm/idt77105.c | 4 ++--
 drivers/atm/iphase.c   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/atm/idt77105.c b/drivers/atm/idt77105.c
index bfca7b8a6f31..cc4a5449ca42 100644
--- a/drivers/atm/idt77105.c
+++ b/drivers/atm/idt77105.c
@@ -366,8 +366,8 @@ EXPORT_SYMBOL(idt77105_init);
 static void __exit idt77105_exit(void)
 {
 	/* turn off timers */
-	del_timer_sync(&stats_timer);
-	del_timer_sync(&restart_timer);
+	timer_shutdown_sync(&stats_timer);
+	timer_shutdown_sync(&restart_timer);
 }
 
 module_exit(idt77105_exit);
diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 324148686953..9be45d9d66b3 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -3280,7 +3280,7 @@ static void __exit ia_module_exit(void)
 {
 	pci_unregister_driver(&ia_driver);
 
-	del_timer_sync(&ia_timer);
+	timer_shutdown_sync(&ia_timer);
 }
 
 module_init(ia_module_init);
-- 
2.35.1
