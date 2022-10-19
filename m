Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A47604A6C
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 17:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiJSPEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 11:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiJSPEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 11:04:00 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1AF189C3E;
        Wed, 19 Oct 2022 07:58:32 -0700 (PDT)
From:   John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1666191366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6uEJOM0caPrcvNJcHiErtW6cO4rX4lvkgAL5ZPoAngE=;
        b=CapeSp4lIuUCMT3A2F+Nh1MiAgJLkP2QvT6kPUMQDmJJFQsukbmY9zgoaeE4Mq6UuBqXXb
        FrZc++ZOPgsuLs9l7PcPyG4j8PgQByAcFR2QTb5ZOiIdmXyyFYqlRtydfmDmoK5yA3OP78
        U0XmnXaelSW/V/NwDwJUqlWqX2IcrI2b9QoB5wTOni/8eC59uwoJspmELM/0AK/+2z5J0G
        bd1oHF0zuZVLDhAFAcJJT5y3CPqV4fXZIaKcBDHjVUzgpVkWqsTRUcD5J9GUYo05fhBIDg
        fYj1DxyE3Wu0F0Ede8aUNYGFTPayP73PEUKd+FQ5qnHfrV5Nu/mSQTYm2wS3RQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1666191366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6uEJOM0caPrcvNJcHiErtW6cO4rX4lvkgAL5ZPoAngE=;
        b=ZQecdyT7PQky3Pel/Hzc+4qBo3aS7NXlfHW9v7oMg/iE63aGG0BcneUC9VkDNd/cxE1gob
        fBX8kx6iiefyiNCg==
To:     Petr Mladek <pmladek@suse.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH printk v2 09/38] netconsole: use console_is_enabled()
Date:   Wed, 19 Oct 2022 17:01:31 +0206
Message-Id: <20221019145600.1282823-10-john.ogness@linutronix.de>
In-Reply-To: <20221019145600.1282823-1-john.ogness@linutronix.de>
References: <20221019145600.1282823-1-john.ogness@linutronix.de>
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

Replace (console->flags & CON_ENABLED) usage with console_is_enabled().

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
 drivers/net/netconsole.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index bdff9ac5056d..073e59a06f21 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -332,7 +332,7 @@ static ssize_t enabled_store(struct config_item *item,
 	}
 
 	if (enabled) {	/* true */
-		if (nt->extended && !(netconsole_ext.flags & CON_ENABLED)) {
+		if (nt->extended && !console_is_enabled(&netconsole_ext)) {
 			netconsole_ext.flags |= CON_ENABLED;
 			register_console(&netconsole_ext);
 		}
@@ -915,7 +915,7 @@ static int __init init_netconsole(void)
 	if (err)
 		goto undonotifier;
 
-	if (netconsole_ext.flags & CON_ENABLED)
+	if (console_is_enabled(&netconsole_ext))
 		register_console(&netconsole_ext);
 	register_console(&netconsole);
 	pr_info("network logging started\n");
-- 
2.30.2

