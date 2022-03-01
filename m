Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336824C98E4
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 00:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiCAXL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 18:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237939AbiCAXLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 18:11:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D73E46B32;
        Tue,  1 Mar 2022 15:10:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7A97B81E98;
        Tue,  1 Mar 2022 23:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF49AC340F1;
        Tue,  1 Mar 2022 23:10:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="kFJUX7By"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1646176254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JitSAewM5XJnyNcarCeKZoli7SPLiQKyT0vtFg6EFEU=;
        b=kFJUX7ByF+p+w9SVX+GdmTQCHZhwpA4C+M8oZ1TQhG/Hb/kMcdwY3QaLlhp0KuILVKA0bU
        6Px26fc96VQg4Jpf8Z+C3Yw6tXVQ3fhyLdB0fPrFaoR7E0ZswLDWEJXZe01kYxHwV8+4jC
        yob7Q2uIeT+USQKiW2zQOvVxXFvwln4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8b7222fd (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 1 Mar 2022 23:10:54 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] random: provide notifier for VM fork
Date:   Wed,  2 Mar 2022 00:10:37 +0100
Message-Id: <20220301231038.530897-3-Jason@zx2c4.com>
In-Reply-To: <20220301231038.530897-1-Jason@zx2c4.com>
References: <20220301231038.530897-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers such as WireGuard need to learn when VMs fork in order to clear
sessions. This commit provides a simple notifier_block for that, with a
register and unregister function. When no VM fork detection is compiled
in, this turns into a no-op, similar to how the power notifier works.

Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/random.c  | 15 +++++++++++++++
 include/linux/random.h |  5 +++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 6bd1bbab7392..483fd2dc2057 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1141,6 +1141,8 @@ void add_bootloader_randomness(const void *buf, size_t size)
 EXPORT_SYMBOL_GPL(add_bootloader_randomness);
 
 #if IS_ENABLED(CONFIG_VMGENID)
+static BLOCKING_NOTIFIER_HEAD(vmfork_notifier);
+
 /*
  * Handle a new unique VM ID, which is unique, not secret, so we
  * don't credit it, but we do immediately force a reseed after so
@@ -1152,11 +1154,24 @@ void add_vmfork_randomness(const void *unique_vm_id, size_t size)
 	if (crng_ready()) {
 		crng_reseed(true);
 		pr_notice("crng reseeded due to virtual machine fork\n");
+		blocking_notifier_call_chain(&vmfork_notifier, 0, NULL);
 	}
 }
 #if IS_MODULE(CONFIG_VMGENID)
 EXPORT_SYMBOL_GPL(add_vmfork_randomness);
 #endif
+
+int register_random_vmfork_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&vmfork_notifier, nb);
+}
+EXPORT_SYMBOL_GPL(register_random_vmfork_notifier);
+
+int unregister_random_vmfork_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&vmfork_notifier, nb);
+}
+EXPORT_SYMBOL_GPL(unregister_random_vmfork_notifier);
 #endif
 
 struct fast_pool {
diff --git a/include/linux/random.h b/include/linux/random.h
index e84b6fa27435..7fccbc7e5a75 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -31,6 +31,11 @@ extern void add_hwgenerator_randomness(const void *buffer, size_t count,
 				       size_t entropy);
 #if IS_ENABLED(CONFIG_VMGENID)
 extern void add_vmfork_randomness(const void *unique_vm_id, size_t size);
+extern int register_random_vmfork_notifier(struct notifier_block *nb);
+extern int unregister_random_vmfork_notifier(struct notifier_block *nb);
+#else
+static inline int register_random_vmfork_notifier(struct notifier_block *nb) { return 0; }
+static inline int unregister_random_vmfork_notifier(struct notifier_block *nb) { return 0; }
 #endif
 
 extern void get_random_bytes(void *buf, size_t nbytes);
-- 
2.35.1

