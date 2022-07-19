Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1068A57A79F
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 21:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238464AbiGST43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 15:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbiGST42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 15:56:28 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654A357241;
        Tue, 19 Jul 2022 12:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VooOSpuhRyn6QflGyabZjelG9o3ODRjuOAJFHCszOAo=; b=NGNXASKnxv4yJBij9LHKUxmh0P
        mwUA56SGZAoonZApA09SVGiF/y/f8zc3XppA1Fp2bFTHKWP7BojRi7He0VhM9lr5UrUtcK1wYipJs
        aSaN8QP6C4eF4zXoOgJGgT6ZuDMmMuYimiD0ROcWumz8NrrcUpCBXpaiIRgNLZ0Gd9RvebkcoATjI
        wxPOASIbcw2oLKL150S0/dLxRnPitLqw31PH+C5crVY35WVMRw2dcMlYaH5NHxwbwVQBDA93nflNa
        LrYtGCVdrzz5N6lm5MLI8E/TOExnU4EwH/AieooFsOIdDFrfpimBB+7U6TycUcHDjacZjyJLpIsj7
        WSnitLeQ==;
Received: from 200-100-212-117.dial-up.telesp.net.br ([200.100.212.117] helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1oDtKM-006fWu-FY; Tue, 19 Jul 2022 21:56:19 +0200
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net, halves@canonical.com, fabiomirmar@gmail.com,
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
        will@kernel.org, "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        linux-um@lists.infradead.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH v2 06/13] um: Improve panic notifiers consistency and ordering
Date:   Tue, 19 Jul 2022 16:53:19 -0300
Message-Id: <20220719195325.402745-7-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719195325.402745-1-gpiccoli@igalia.com>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
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

Currently the panic notifiers from user mode linux don't follow
the convention for most of the other notifiers present in the
kernel (indentation, priority setting, numeric return).
More important, the priorities could be improved, since it's a
special case (userspace), hence we could run the notifiers earlier;
user mode linux shouldn't care much with other panic notifiers but
the ordering among the mconsole and arch notifier is important,
given that the arch one effectively triggers a core dump.

Fix that by running the mconsole notifier as the first panic
notifier, followed by the architecture one (that coredumps).

Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>

---

V2:
- Kept the notifier header to avoid implicit usage - thanks
Johannes for the suggestion!

 arch/um/drivers/mconsole_kern.c | 7 +++----
 arch/um/kernel/um_arch.c        | 8 ++++----
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index 8ca67a692683..69af3ce8407a 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -846,13 +846,12 @@ static int notify_panic(struct notifier_block *self, unsigned long unused1,
 
 	mconsole_notify(notify_socket, MCONSOLE_PANIC, message,
 			strlen(message) + 1);
-	return 0;
+	return NOTIFY_DONE;
 }
 
 static struct notifier_block panic_exit_notifier = {
-	.notifier_call 		= notify_panic,
-	.next 			= NULL,
-	.priority 		= 1
+	.notifier_call	= notify_panic,
+	.priority	= INT_MAX, /* run as soon as possible */
 };
 
 static int add_notifier(void)
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 9838967d0b2f..970fdccc2f94 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -246,13 +246,13 @@ static int panic_exit(struct notifier_block *self, unsigned long unused1,
 	bust_spinlocks(0);
 	uml_exitcode = 1;
 	os_dump_core();
-	return 0;
+
+	return NOTIFY_DONE;
 }
 
 static struct notifier_block panic_exit_notifier = {
-	.notifier_call 		= panic_exit,
-	.next 			= NULL,
-	.priority 		= 0
+	.notifier_call	= panic_exit,
+	.priority	= INT_MAX - 1, /* run as 2nd notifier, won't return */
 };
 
 void uml_finishsetup(void)
-- 
2.37.1

