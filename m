Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A7237EEA7
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 01:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhELWAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 18:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387867AbhELVtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 17:49:13 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DE1C061246;
        Wed, 12 May 2021 14:43:28 -0700 (PDT)
Date:   Wed, 12 May 2021 23:43:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620855806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HSbdv1GDdPztZw5zTb9KslOGTnh1tRDArL4XhKvz/ec=;
        b=PtKwVVKfzJNbyEOwpyCTxHTECuCU4MVf8kxZQYDpX592nPOY9pV/ABQi6nwSn2y9M4dyDd
        HOTjVjWjjr5SbCP6udeCfm/y45nmeoDKiSbD/fMFh9JQJjH8JXI4agH8pK2vkhVEmLoa1Y
        KXmI1AwmCcPk0wgfm0iEnXRCkeSzciQYmEd4jdhzSHoELRAbUwMVPq83dbruzvYhwCHbg6
        o+cKcLdccweyn2gh5VIoKxz5xlRa5zhg71we4ssfFWMdv1Ed4ROwWSPuHQYwrqIvHRS3zC
        VhtqH2QtlcFATgZAIXzuslczgnHYWj2CrueR9JHdz2GlNY+XcjRKj5+ii/3j+g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620855806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HSbdv1GDdPztZw5zTb9KslOGTnh1tRDArL4XhKvz/ec=;
        b=A4Gb/KNED+5M7zpJuUewsiFOs0wkU5hVfNlRS0Ocv7tLHf1xjZZkpwQviqVyQWpRQ8isNM
        hPIGcW+d+o1cetAQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     Juri Lelli <juri.lelli@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, sassmann@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: Treat __napi_schedule_irqoff() as
 __napi_schedule() on PREEMPT_RT
Message-ID: <20210512214324.hiaiw3e2tzmsygcz@linutronix.de>
References: <YJofplWBz8dT7xiw@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YJofplWBz8dT7xiw@localhost.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__napi_schedule_irqoff() is an optimized version of __napi_schedule()
which can be used where it is known that interrupts are disabled,
e.g. in interrupt-handlers, spin_lock_irq() sections or hrtimer
callbacks.

On PREEMPT_RT enabled kernels this assumptions is not true. Force-
threaded interrupt handlers and spinlocks are not disabling interrupts
and the NAPI hrtimer callback is forced into softirq context which runs
with interrupts enabled as well.

Chasing all usage sites of __napi_schedule_irqoff() is a whack-a-mole
game so make __napi_schedule_irqoff() invoke __napi_schedule() for
PREEMPT_RT kernels.

The callers of ____napi_schedule() in the networking core have been
audited and are correct on PREEMPT_RT kernels as well.

Reported-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
Alternatively __napi_schedule_irqoff() could be #ifdef'ed out on RT and
an inline provided which invokes __napi_schedule().

This was not chosen as it creates #ifdeffery all over the place and with
the proposed solution the code reflects the documentation consistently
and in one obvious place.

 net/core/dev.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 222b1d322c969..febb23708184e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6501,11 +6501,18 @@ EXPORT_SYMBOL(napi_schedule_prep);
  * __napi_schedule_irqoff - schedule for receive
  * @n: entry to schedule
  *
- * Variant of __napi_schedule() assuming hard irqs are masked
+ * Variant of __napi_schedule() assuming hard irqs are masked.
+ *
+ * On PREEMPT_RT enabled kernels this maps to __napi_schedule()
+ * because the interrupt disabled assumption might not be true
+ * due to force-threaded interrupts and spinlock substitution.
  */
 void __napi_schedule_irqoff(struct napi_struct *n)
 {
-	____napi_schedule(this_cpu_ptr(&softnet_data), n);
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		____napi_schedule(this_cpu_ptr(&softnet_data), n);
+	else
+		__napi_schedule(n);
 }
 EXPORT_SYMBOL(__napi_schedule_irqoff);
 
-- 
2.31.1

