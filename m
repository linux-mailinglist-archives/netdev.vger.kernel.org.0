Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CAF33F359
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 15:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhCQOk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 10:40:59 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50684 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbhCQOkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 10:40:43 -0400
Message-Id: <20210317143859.513307808@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615992042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8QMGgYnI70uugMofu3OLkpYTvIgYFZIdrl1oEimDU2o=;
        b=rmgC+l+KeJUNxw7DayqAHUq9NF4ItzQL4kWBGhC0Blnj6lOs0ihHR0KopYyOUd5vb/KOvx
        zPNQAfPKO5lC4/eiC3idrqjeA1ENh4sWv7IRnlv5/KTmnACRTW8pNJhZhTIGVxFcZwnYEk
        5WCU1lSPTYinnQ84+mmluEIIKxdFiRwbQ4VRGuvnIgMGRZjoFDvMxR8Vz4HA1pPalDco97
        5xL1Umdr3qjxfNSeAIR8z1haObrJBE3PmqCqx66/+ZZ5CTSS+kjvAQprMBiqOQAPjRumeI
        kw+d9PNB6SX20f++KsknCyZttPjMCFdYM535vFiBHmGPu6eOLdUrhPizN2y05Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615992042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8QMGgYnI70uugMofu3OLkpYTvIgYFZIdrl1oEimDU2o=;
        b=OBk0pWKATGPe0cnOU+iBZDG8oGm/nxdWDLtvPEsrsVytfpKq8sAidYOKW5xPy/oatjv9ki
        zClOj1w65s0FXnDg==
Date:   Wed, 17 Mar 2021 15:38:52 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Johan Hovold <johan@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-serial@vger.kernel.org
Subject: [patch 1/1] genirq: Disable interrupts for force threaded handlers
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With interrupt force threading all device interrupt handlers are invoked
from kernel threads. Contrary to hard interrupt context the invocation only
disables bottom halfs, but not interrupts. This was an oversight back then
because any code like this will have an issue:

thread(irq_A)
  irq_handler(A)
    spin_lock(&foo->lock);

interrupt(irq_B)
  irq_handler(B)
    spin_lock(&foo->lock);

This has been triggered with networking (NAPI vs. hrtimers) and console
drivers where printk() happens from an interrupt which interrupted the
force threaded handler.

Now people noticed and started to change the spin_lock() in the handler to
spin_lock_irqsave() which affects performance or add IRQF_NOTHREAD to the
interrupt request which in turn breaks RT.

Fix the root cause and not the symptom and disable interrupts before
invoking the force threaded handler which preserves the regular semantics
and the usefulness of the interrupt force threading as a general debugging
tool.

For not RT this is not changing much, except that during the execution of
the threaded handler interrupts are delayed until the handler
returns. Vs. scheduling and softirq processing there is no difference.

For RT kernels there is no issue.

Fixes: 8d32a307e4fa ("genirq: Provide forced interrupt threading")
Reported-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netdev <netdev@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>
Cc: linux-serial@vger.kernel.org
Cc: netdev <netdev@vger.kernel.org>
---
 kernel/irq/manage.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1142,11 +1142,15 @@ irq_forced_thread_fn(struct irq_desc *de
 	irqreturn_t ret;
 
 	local_bh_disable();
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		local_irq_disable();
 	ret = action->thread_fn(action->irq, action->dev_id);
 	if (ret == IRQ_HANDLED)
 		atomic_inc(&desc->threads_handled);
 
 	irq_finalize_oneshot(desc, action);
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		local_irq_enable();
 	local_bh_enable();
 	return ret;
 }

