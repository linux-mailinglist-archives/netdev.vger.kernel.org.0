Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6811E51270E
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 01:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbiD0XFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 19:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240319AbiD0XEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 19:04:07 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AC692D24;
        Wed, 27 Apr 2022 15:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Vlo9T2/mvIa7VmsgTZAplfpKcY639xSpi9Lsc7QD2sA=; b=ZiYAT8sJyiBNaHzrk2673FL4+8
        1oiyWalKP6LGmKEc9hZJWoXC6cS5nMMrcCw5Iicmmfaanay2XW+Ea9CLz93XJRZPptEPdWhd8bk0b
        rKw9muPDbsgcmhx+6dtX/C/iDyONNGYxGodf7FR5gZ6gaCx9CBSOMyg/WgkwloH6LwMYOPDHwMc9i
        DlZzPF1Rmfq/gUUioCECpXAnYQMmNjWP7xmmSjqLdHZxdMlvMlgrtO3h+d5FTnJJbisLeLao1OJx/
        z7mwY9pmIo/3ja9SO2+rtPXIxKaESObUyZjm7eg6MS41mJJ7ZAlwRmPdpw93iK7tmvwyFHIvecdrE
        ZFlVRrJg==;
Received: from [179.113.53.197] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1njqb3-0002Tm-Pi; Thu, 28 Apr 2022 00:57:22 +0200
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
        will@kernel.org, Andrea Parri <parri.andrea@gmail.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Brennan <stephen.s.brennan@oracle.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 26/30] Drivers: hv: Do not force all panic notifiers to execute before kdump
Date:   Wed, 27 Apr 2022 19:49:20 -0300
Message-Id: <20220427224924.592546-27-gpiccoli@igalia.com>
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

Since commit a11589563e96 ("x86/Hyper-V: Report crash register
data or kmsg before running crash kernel") Hyper-V forcibly sets
the kernel parameter "crash_kexec_post_notifiers"; with that, it
did enforce the execution of *all* panic notifiers before kdump.
The main reason behind that is that Hyper-V has an hypervisor
notification mechanism that has the ability of warning the
hypervisor when the guest panics.

Happens that after the panic notifiers refactor, we now have 3 lists
and a level mechanism that defines the ordering of the notifiers
execution with regards to kdump. And for Hyper-V, the specific
notifier to inform the hypervisor about a panic lies in the first
list, which *by default* is set to execute before kdump. Hence,
this patch removes the hardcoded setting, effectively reverting
the aforementioned commit.

One of the problems with the forced approach was greatly exposed by
commit d57d6fe5bf34 ("drivers: hv: log when enabling crash_kexec_post_notifiers")
which ended-up confusing the user that didn't expect the notifiers
to execute before kdump, since it's a user setting and wasn't
enabled by such user. With the patch hereby proposed, that kind
of issue doesn't happen anymore, the panic notifiers level is
well-documented and users can expect a predictable behavior.

Fixes: a11589563e96 ("x86/Hyper-V: Report crash register data or kmsg before running crash kernel")
Fixes: d57d6fe5bf34 ("drivers: hv: log when enabling crash_kexec_post_notifiers"
Cc: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Michael Kelley <mikelley@microsoft.com>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Tianyu Lan <Tianyu.Lan@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Tested-by: Fabio A M Martins <fabiomirmar@gmail.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---

Special thanks to Michael Kelley for the good information about the Hyper-V
panic path in email threads some months ago, and to Fabio for the testing
performed.

 drivers/hv/hv_common.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
index ae68298c0dca..af59793de523 100644
--- a/drivers/hv/hv_common.c
+++ b/drivers/hv/hv_common.c
@@ -73,18 +73,6 @@ int __init hv_common_init(void)
 {
 	int i;
 
-	/*
-	 * Hyper-V expects to get crash register data or kmsg when
-	 * crash enlightment is available and system crashes. Set
-	 * crash_kexec_post_notifiers to be true to make sure that
-	 * calling crash enlightment interface before running kdump
-	 * kernel.
-	 */
-	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE) {
-		crash_kexec_post_notifiers = true;
-		pr_info("Hyper-V: enabling crash_kexec_post_notifiers\n");
-	}
-
 	/*
 	 * Allocate the per-CPU state for the hypercall input arg.
 	 * If this allocation fails, we will not be able to setup
-- 
2.36.0

