Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9CC5125D0
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238886AbiD0WzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237853AbiD0Wyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:54:38 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A968CCF2;
        Wed, 27 Apr 2022 15:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/X9VGFpkqSi0Xw+sb2fnqT5ti0fEX/+xmh5q7q7MhDY=; b=p3QOIFADQeeHCVp8bxPKwO62s+
        EGcZOVKN2qbhBt1Pf/EZXw+tkBx2x9DRVMO1uTp94JqIADubO77jiICP/E04L/nn99FEYBzZb+44L
        /kz24xVDrX4FFqomkvxzWUTFlHhE4ZhZCfkHWBQr0/Lzkqr3CE/w4r7fAtX83L8f0pEarK5Qx6XYH
        4zbdyCjIZQkKS6mh2t53k79tPqORut15Ek94GDPyIzx6i+d57M9a0UcH7EVEXkkbVPk2r+5s4ram2
        N0+1/N2WpK9qFZ8QFj+vJFSqHIZNJD4YgbbIqqLYxl+DJIQthPO2tybUvOHdIFVD8Tw3e7+DHlkve
        LuLH0yww==;
Received: from [179.113.53.197] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1njqV1-000228-53; Thu, 28 Apr 2022 00:51:08 +0200
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
        will@kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Wang ShaoBo <bobo.shaobowang@huawei.com>,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH 05/30] misc/pvpanic: Convert regular spinlock into trylock on panic path
Date:   Wed, 27 Apr 2022 19:48:59 -0300
Message-Id: <20220427224924.592546-6-gpiccoli@igalia.com>
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

The pvpanic driver relies on panic notifiers to execute a callback
on panic event. Such function is executed in atomic context - the
panic function disables local IRQs, preemption and all other CPUs
that aren't running the panic code.

With that said, it's dangerous to use regular spinlocks in such path,
as introduced by commit b3c0f8774668 ("misc/pvpanic: probe multiple instances").
This patch fixes that by replacing regular spinlocks with the trylock
safer approach.

It also fixes an old comment (about a long gone framebuffer code) and
the notifier priority - we should execute hypervisor notifiers early,
deferring this way the panic action to the hypervisor, as expected by
the users that are setting up pvpanic.

Fixes: b3c0f8774668 ("misc/pvpanic: probe multiple instances")
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Mihai Carabas <mihai.carabas@oracle.com>
Cc: Shile Zhang <shile.zhang@linux.alibaba.com>
Cc: Wang ShaoBo <bobo.shaobowang@huawei.com>
Cc: zhenwei pi <pizhenwei@bytedance.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 drivers/misc/pvpanic/pvpanic.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/pvpanic/pvpanic.c b/drivers/misc/pvpanic/pvpanic.c
index 4b8f1c7d726d..049a12006348 100644
--- a/drivers/misc/pvpanic/pvpanic.c
+++ b/drivers/misc/pvpanic/pvpanic.c
@@ -34,7 +34,9 @@ pvpanic_send_event(unsigned int event)
 {
 	struct pvpanic_instance *pi_cur;
 
-	spin_lock(&pvpanic_lock);
+	if (!spin_trylock(&pvpanic_lock))
+		return;
+
 	list_for_each_entry(pi_cur, &pvpanic_list, list) {
 		if (event & pi_cur->capability & pi_cur->events)
 			iowrite8(event, pi_cur->base);
@@ -55,9 +57,13 @@ pvpanic_panic_notify(struct notifier_block *nb, unsigned long code, void *unused
 	return NOTIFY_DONE;
 }
 
+/*
+ * Call our notifier very early on panic, deferring the
+ * action taken to the hypervisor.
+ */
 static struct notifier_block pvpanic_panic_nb = {
 	.notifier_call = pvpanic_panic_notify,
-	.priority = 1, /* let this called before broken drm_fb_helper() */
+	.priority = INT_MAX,
 };
 
 static void pvpanic_remove(void *param)
-- 
2.36.0

