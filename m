Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368E857A7C2
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 21:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238086AbiGST6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 15:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239733AbiGST5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 15:57:41 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02985F131;
        Tue, 19 Jul 2022 12:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sxerzEC6ULnrCK4xFVFRwsVny05lEai+m5Q0OhAgHvc=; b=LydLkzqrM6AQgyUZb/eK78EaTe
        voCyZOYInunbfsTQJhUj6qGYkEcwQqAZoeE5g9fyKdb2pV3SYR9F2oFs7yNM3qsGwT21rp2aZLD+6
        DRVvuKL2t8RP2KNGIJEg0K51V8ryEYddAmBtZ52mC+bH8R+QBJpSRJaHwfoS5PcBpccLkHwPVXH1p
        iZCPDlenLJA0ElBqc9ii7N0UWdszArx91MaroFoXGCYEDCyXx3ZlFTtOCFetlVaWTUnEJssIASGqW
        C9ijI9jv+NNIUzBR7rfC1MtzW0qf9n5kWS+hQY2dFbmdPPKkRpI01y7E60JasW9nNQUJB+6R9Ol6l
        duNmoiYw==;
Received: from 200-100-212-117.dial-up.telesp.net.br ([200.100.212.117] helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1oDtL7-006fav-1R; Tue, 19 Jul 2022 21:57:05 +0200
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
        Arjan van de Ven <arjan@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Xiaoming Ni <nixiaoming@huawei.com>
Subject: [PATCH v2 09/13] notifier: Show function names on notifier routines if DEBUG_NOTIFIERS is set
Date:   Tue, 19 Jul 2022 16:53:22 -0300
Message-Id: <20220719195325.402745-10-gpiccoli@igalia.com>
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

Currently we have a debug infrastructure in the notifiers file, but
it's very simple/limited. Extend it by:

(a) Showing all registered/unregistered notifiers' callback names;

(b) Adding a dynamic debug tuning to allow showing called notifiers'
function names. Notice that this should be guarded as a tunable since
it can flood the kernel log buffer.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>

---

V2:
- Major improvement thanks to the great idea from Xiaoming - changed
all the ksym wheel reinvention to printk %ps modifier;

- Instead of ifdefs, using IS_ENABLED() - thanks Steven.

- Removed an unlikely() hint on debug path.

 kernel/notifier.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/kernel/notifier.c b/kernel/notifier.c
index 0d5bd62c480e..350761b34f8a 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -37,6 +37,10 @@ static int notifier_chain_register(struct notifier_block **nl,
 	}
 	n->next = *nl;
 	rcu_assign_pointer(*nl, n);
+
+	if (IS_ENABLED(CONFIG_DEBUG_NOTIFIERS))
+		pr_info("notifiers: registered %ps\n", n->notifier_call);
+
 	return 0;
 }
 
@@ -46,6 +50,11 @@ static int notifier_chain_unregister(struct notifier_block **nl,
 	while ((*nl) != NULL) {
 		if ((*nl) == n) {
 			rcu_assign_pointer(*nl, n->next);
+
+			if (IS_ENABLED(CONFIG_DEBUG_NOTIFIERS))
+				pr_info("notifiers: unregistered %ps\n",
+					n->notifier_call);
+
 			return 0;
 		}
 		nl = &((*nl)->next);
@@ -77,13 +86,14 @@ static int notifier_call_chain(struct notifier_block **nl,
 	while (nb && nr_to_call) {
 		next_nb = rcu_dereference_raw(nb->next);
 
-#ifdef CONFIG_DEBUG_NOTIFIERS
-		if (unlikely(!func_ptr_is_kernel_text(nb->notifier_call))) {
-			WARN(1, "Invalid notifier called!");
-			nb = next_nb;
-			continue;
+		if (IS_ENABLED(CONFIG_DEBUG_NOTIFIERS)) {
+			if (!func_ptr_is_kernel_text(nb->notifier_call)) {
+				WARN(1, "Invalid notifier called!");
+				nb = next_nb;
+				continue;
+			}
+			pr_debug("notifiers: calling %ps\n", nb->notifier_call);
 		}
-#endif
 		ret = nb->notifier_call(nb, val, v);
 
 		if (nr_calls)
-- 
2.37.1

