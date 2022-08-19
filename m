Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E3059A872
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 00:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242033AbiHSWYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 18:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241975AbiHSWXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 18:23:54 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D9B23BD1;
        Fri, 19 Aug 2022 15:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OonmUPZkO/emCOphZ8VnLPwYmag4wEjaMQk7IMB+RMQ=; b=frivb87m1aODDLexRXHjILEpy0
        zypuxM1lUa2+Sde0ChP8r+SpXKZTYYQ06rsm4azbLcf835GhtiU/63eTRWcbzZyjLucvdKKHJYKiK
        /euCL6+qpMh2bq+mDBCmd4zfYMRfG4Tqf1qA8tyF9Sf9mTKWE49sFBT6zlM+mWR7kHQzFnNnWU6MW
        lkll9FniO4rDprJKDPgb+tUp2okPeMrFiVLU/alXFetoW59OAkLnidfuhStQMFD628z2AmR0v5dqg
        u9NF7VPoqZwVRcG9G6dqJ9Zqmry2mF8HYNj1eMF0SH2Nd3PIvrPYCM3Wwvafygev10hLlqXwn+n1L
        GJahVPlA==;
Received: from [179.232.144.59] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1oPAP0-00Cb74-3H; Sat, 20 Aug 2022 00:23:47 +0200
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
        will@kernel.org, xuqiang36@huawei.com,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        linux-edac@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH V3 08/11] EDAC/altera: Skip the panic notifier if kdump is loaded
Date:   Fri, 19 Aug 2022 19:17:28 -0300
Message-Id: <20220819221731.480795-9-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819221731.480795-1-gpiccoli@igalia.com>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The altera_edac panic notifier performs some data collection with
regards errors detected; such code relies in the regmap layer to
perform reads/writes, so the code is abstracted and there is some
risk level to execute that, since the panic path runs in atomic
context, with interrupts/preemption and secondary CPUs disabled.

Users want the information collected in this panic notifier though,
so in order to balance the risk/benefit, let's skip the altera panic
notifier if kdump is loaded. While at it, remove a useless header
and encompass a macro inside the sole ifdef block it is used.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Tony Luck <tony.luck@intel.com>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>

---

V3:
- added the ack tag from Dinh - thanks!
- had a good discussion with Boris about that in V2 [0],
hopefully we can continue and reach a consensus in this V3.
[0] https://lore.kernel.org/lkml/46137c67-25b4-6657-33b7-cffdc7afc0d7@igalia.com/

V2:
- new patch, based on the discussion in [1].
[1] https://lore.kernel.org/lkml/62a63fc2-346f-f375-043a-fa21385279df@igalia.com/


 drivers/edac/altera_edac.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
index e7e8e624a436..741fe5539154 100644
--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/mfd/altera-sysmgr.h>
 #include <linux/mfd/syscon.h>
-#include <linux/notifier.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
@@ -24,6 +23,7 @@
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/types.h>
+#include <linux/kexec.h>
 #include <linux/uaccess.h>
 
 #include "altera_edac.h"
@@ -2063,22 +2063,30 @@ static const struct irq_domain_ops a10_eccmgr_ic_ops = {
 };
 
 /************** Stratix 10 EDAC Double Bit Error Handler ************/
-#define to_a10edac(p, m) container_of(p, struct altr_arria10_edac, m)
-
 #ifdef CONFIG_64BIT
 /* panic routine issues reboot on non-zero panic_timeout */
 extern int panic_timeout;
 
+#define to_a10edac(p, m) container_of(p, struct altr_arria10_edac, m)
+
 /*
  * The double bit error is handled through SError which is fatal. This is
  * called as a panic notifier to printout ECC error info as part of the panic.
+ *
+ * Notice that if kdump is set, we take the risk avoidance approach and
+ * skip the notifier, given that users are expected to have access to a
+ * full vmcore.
  */
 static int s10_edac_dberr_handler(struct notifier_block *this,
 				  unsigned long event, void *ptr)
 {
-	struct altr_arria10_edac *edac = to_a10edac(this, panic_notifier);
+	struct altr_arria10_edac *edac;
 	int err_addr, dberror;
 
+	if (kexec_crash_loaded())
+		return NOTIFY_DONE;
+
+	edac = to_a10edac(this, panic_notifier);
 	regmap_read(edac->ecc_mgr_map, S10_SYSMGR_ECC_INTSTAT_DERR_OFST,
 		    &dberror);
 	regmap_write(edac->ecc_mgr_map, S10_SYSMGR_UE_VAL_OFST, dberror);
-- 
2.37.2

