Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE1251261C
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239322AbiD0W5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235419AbiD0W53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:57:29 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7779B3C57;
        Wed, 27 Apr 2022 15:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BexKVXcxuZt34azQ5Muv1vJV6tgwpIcW3JsMthwMxfs=; b=BRT/sKLpYXau/Ji4ZqRLBh2wLe
        Ez82oN0tPhCaeccxvStT4dM/VXWT0UOTgVT7srxju4FTp1lIxHZgITVU09FPE0hwYIbUj79K3InFF
        c3u/lCG1AZZtsXeU+SEcK9u0pYYem+Sajrhv7s+jR5UPYROYW2E4rHsCktC7o7MuiSwumDe0KTw8O
        uv2vnGx/4l5xRolhC4zk2RH1ShfOhYp0567tBrYlkHX5Tuh9PS21K9iN1pNYOoy8D+KSBJrTAnUOx
        BdTF6VrcFln7xzJle98w0XT7WzPU38wHtKJVV73Cz5eypbAomXnD5JiFGfsNH5tWiuiFJ1HH5bqlk
        bHcrf8AQ==;
Received: from [179.113.53.197] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1njqWG-00029R-Tx; Thu, 28 Apr 2022 00:52:25 +0200
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, coresight@lists.linaro.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, gpiccoli@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Richard Henderson <rth@twiddle.net>
Subject: [PATCH 10/30] alpha: Clean-up the panic notifier code
Date:   Wed, 27 Apr 2022 19:49:04 -0300
Message-Id: <20220427224924.592546-11-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220427224924.592546-1-gpiccoli@igalia.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The alpha panic notifier has some code issues, not following
the conventions of other notifiers. Also, it might halt the
machine but still it is set to run as early as possible, which
doesn't seem to be a good idea.

This patch cleans the code, and set the notifier to run as the
latest, following the same approach other architectures are doing.
Also, we remove the unnecessary include of a header already
included indirectly.

Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 arch/alpha/kernel/setup.c | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
index b4fbbba30aa2..d88bdf852753 100644
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -41,19 +41,11 @@
 #include <linux/sysrq.h>
 #include <linux/reboot.h>
 #endif
-#include <linux/notifier.h>
 #include <asm/setup.h>
 #include <asm/io.h>
 #include <linux/log2.h>
 #include <linux/export.h>
 
-static int alpha_panic_event(struct notifier_block *, unsigned long, void *);
-static struct notifier_block alpha_panic_block = {
-	alpha_panic_event,
-        NULL,
-        INT_MAX /* try to do it first */
-};
-
 #include <linux/uaccess.h>
 #include <asm/hwrpb.h>
 #include <asm/dma.h>
@@ -435,6 +427,21 @@ static const struct sysrq_key_op srm_sysrq_reboot_op = {
 };
 #endif
 
+static int alpha_panic_event(struct notifier_block *this,
+			     unsigned long event, void *ptr)
+{
+	/* If we are using SRM and serial console, just hard halt here. */
+	if (alpha_using_srm && srmcons_output)
+		__halt();
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block alpha_panic_block = {
+	.notifier_call = alpha_panic_event,
+	.priority = INT_MIN, /* may not return, do it last */
+};
+
 void __init
 setup_arch(char **cmdline_p)
 {
@@ -1427,19 +1434,6 @@ const struct seq_operations cpuinfo_op = {
 	.show	= show_cpuinfo,
 };
 
-
-static int
-alpha_panic_event(struct notifier_block *this, unsigned long event, void *ptr)
-{
-#if 1
-	/* FIXME FIXME FIXME */
-	/* If we are using SRM and serial console, just hard halt here. */
-	if (alpha_using_srm && srmcons_output)
-		__halt();
-#endif
-        return NOTIFY_DONE;
-}
-
 static __init int add_pcspkr(void)
 {
 	struct platform_device *pd;
-- 
2.36.0

