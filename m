Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D86461F552
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 15:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbiKGORl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 09:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbiKGORR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 09:17:17 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD7E1D31A;
        Mon,  7 Nov 2022 06:16:56 -0800 (PST)
From:   John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1667830615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rxs6+Z/gJrAzLbOcrJicwux9sfUp+1EZ2u/YGiVkJQ0=;
        b=b4ql8y1CqshqWcXCG3fY/oCmxHiTCLqFp/vC5T7L6qJ5ftrsfJggc2LiYk23/G8uF2RCo0
        sQwE/M5aYJgbrztjWgKxbzTaokKE/ML8eKgCOoi7fZ6th7Q6pJlmDrboSmojAXWzxG356u
        7EMylIHc0pr+wXYfxZnGu4sgYKQjAL5nNKNuNvsc+jwAC/UqM05yo6/phGUgUXGOA+FWJ+
        /9BhuARU1Zk7JU3Tmkq/Qgr0KvpxrbmyGDFMZ7kTywgU+fFz1SD8KFVXYp6F4mSxtC4BLZ
        AU01jBfG7+/FAho/BFUkNEEwhkzUPDHfiPPbLzhTGSyAHbAH0YoxbOKx+scuNg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1667830615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rxs6+Z/gJrAzLbOcrJicwux9sfUp+1EZ2u/YGiVkJQ0=;
        b=NB2DL2wjGq46VY5TZjuKeyQr4jtN3KHh2TuJaQu0Gc6dPBeDZEg/LqMW4yrdBOi8ko43Bk
        Rtc49uN3OHpgz/BA==
To:     Petr Mladek <pmladek@suse.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH printk v3 32/40] netconsole: avoid CON_ENABLED misuse to track registration
Date:   Mon,  7 Nov 2022 15:22:30 +0106
Message-Id: <20221107141638.3790965-33-john.ogness@linutronix.de>
In-Reply-To: <20221107141638.3790965-1-john.ogness@linutronix.de>
References: <20221107141638.3790965-1-john.ogness@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,INVALID_DATE_TZ_ABSURD,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CON_ENABLED flag is being misused to track whether or not the
extended console should be or has been registered. Instead use
a local variable to decide if the extended console should be
registered and console_is_registered() to determine if it has
been registered.

Also add a check in cleanup_netconsole() to only unregister the
extended console if it has been registered.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
 drivers/net/netconsole.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index bdff9ac5056d..4f4f79532c6c 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -332,10 +332,8 @@ static ssize_t enabled_store(struct config_item *item,
 	}
 
 	if (enabled) {	/* true */
-		if (nt->extended && !(netconsole_ext.flags & CON_ENABLED)) {
-			netconsole_ext.flags |= CON_ENABLED;
+		if (nt->extended && !console_is_registered(&netconsole_ext))
 			register_console(&netconsole_ext);
-		}
 
 		/*
 		 * Skip netpoll_parse_options() -- all the attributes are
@@ -869,7 +867,7 @@ static void write_msg(struct console *con, const char *msg, unsigned int len)
 
 static struct console netconsole_ext = {
 	.name	= "netcon_ext",
-	.flags	= CON_EXTENDED,	/* starts disabled, registered on first use */
+	.flags	= CON_ENABLED | CON_EXTENDED,
 	.write	= write_ext_msg,
 };
 
@@ -883,6 +881,7 @@ static int __init init_netconsole(void)
 {
 	int err;
 	struct netconsole_target *nt, *tmp;
+	bool extended = false;
 	unsigned long flags;
 	char *target_config;
 	char *input = config;
@@ -895,11 +894,12 @@ static int __init init_netconsole(void)
 				goto fail;
 			}
 			/* Dump existing printks when we register */
-			if (nt->extended)
-				netconsole_ext.flags |= CON_PRINTBUFFER |
-							CON_ENABLED;
-			else
+			if (nt->extended) {
+				extended = true;
+				netconsole_ext.flags |= CON_PRINTBUFFER;
+			} else {
 				netconsole.flags |= CON_PRINTBUFFER;
+			}
 
 			spin_lock_irqsave(&target_list_lock, flags);
 			list_add(&nt->list, &target_list);
@@ -915,7 +915,7 @@ static int __init init_netconsole(void)
 	if (err)
 		goto undonotifier;
 
-	if (netconsole_ext.flags & CON_ENABLED)
+	if (extended)
 		register_console(&netconsole_ext);
 	register_console(&netconsole);
 	pr_info("network logging started\n");
@@ -945,7 +945,8 @@ static void __exit cleanup_netconsole(void)
 {
 	struct netconsole_target *nt, *tmp;
 
-	unregister_console(&netconsole_ext);
+	if (console_is_registered(&netconsole_ext))
+		unregister_console(&netconsole_ext);
 	unregister_console(&netconsole);
 	dynamic_netconsole_exit();
 	unregister_netdevice_notifier(&netconsole_netdev_notifier);
-- 
2.30.2

