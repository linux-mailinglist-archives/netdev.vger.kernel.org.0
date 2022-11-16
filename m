Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E16262C431
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbiKPQXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiKPQWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:22:53 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1F957B6D;
        Wed, 16 Nov 2022 08:22:13 -0800 (PST)
From:   John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1668615732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nTf9OGb9zWeAnXP7WUtzyXzYpJkGff40DU/J1LONmEY=;
        b=Y1QeJrew+e6r3Z7q+FGlwdWrI4cvw5D3zZSh+yYtZ1MEqsgX+54C7plSKQvhmMf4aOXQaT
        VB5UDGsmTAu5RiwkT/vpLkAveZNL/nhhSnKNreP1IwT1LB66fbpTXNYBLVTqTfTUInn2uZ
        ZtMz6nBbtfygicnQlCkMnZvKSiNfzeroIUJwCciUpSdoB3yTAViIjUm4q3Zuy9YPA0IAZZ
        hH9dJXCHjBzaMXXotdH2VL1Vny2M7EHH1CVH/T2z7nhLqxD22Yv43bQ+yMIO8HuFnDu9kt
        dij2aDJdZte4xlClhtTtLXnEduAIei5RzfkkwJbyZ3CfXdwosiQANNs1SlEaGA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1668615732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nTf9OGb9zWeAnXP7WUtzyXzYpJkGff40DU/J1LONmEY=;
        b=yP8+k9Y87ZNwimyqdvpkoA/iVWsPUdCLDpRYhp8K7DNK/Q2rt0iVEsSU3DDL7sxRHTzyY8
        cXk/oSk+2Cr8pcBQ==
To:     Petr Mladek <pmladek@suse.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH printk v5 31/40] netconsole: avoid CON_ENABLED misuse to track registration
Date:   Wed, 16 Nov 2022 17:27:43 +0106
Message-Id: <20221116162152.193147-32-john.ogness@linutronix.de>
In-Reply-To: <20221116162152.193147-1-john.ogness@linutronix.de>
References: <20221116162152.193147-1-john.ogness@linutronix.de>
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
Reviewed-by: Petr Mladek <pmladek@suse.com>
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

