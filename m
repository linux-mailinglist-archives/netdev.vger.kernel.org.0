Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B08A3813BE
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 00:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhENWZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 18:25:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230505AbhENWZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 18:25:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2A2561440;
        Fri, 14 May 2021 22:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621031044;
        bh=rNcOKWQFlt2DrfCiyzxtGCJ02GkDJhgFsRp7/pERk+E=;
        h=From:To:Cc:Subject:Date:From;
        b=ecOoD2zuND8z2D/n5RZ03KN/DTOUjl4eFaPN4vgMPwaa9zMLfi7Yr/Cg7iYDTwX0I
         0Zx1GoMmAcEGTNi0puoVlK4GM2+6iDsMH3YNxU/enoL4eQpNH3UjEgWk7jRpNgp0aZ
         Ce2QYD4BB1gQpbD72gngKqar0X9KkzmX011FiwoStipkxrOoErNQwQ+Pbee9wVFk/A
         G1uWbnirFq+sVnZogUYHNtdF8Uc23PsW8VNAXhhhKyytJaXDL3aVGYJqvhAWADwz6f
         Uj96kKATCedlGg63Pdp4tH3BV1L/sw7GF5LeX6o89gcO091rrNMUFzldAjrtc4/5vE
         c8WFewGkvShig==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, tglx@linutronix.de
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        simon.horman@netronome.com, oss-drivers@netronome.com,
        bigeasy@linutronix.de, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/2] net: add a napi variant for RT-well-behaved drivers
Date:   Fri, 14 May 2021 15:24:01 -0700
Message-Id: <20210514222402.295157-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most networking drivers use napi_schedule_irqoff() to schedule
NAPI from hardware IRQ handler. Unfortunately, as explained in
commit 8380c81d5c4f ("net: Treat __napi_schedule_irqoff() as
__napi_schedule() on PREEMPT_RT") the current implementation
is problematic for RT.

The best solution seems to be to mark the irq handler with
IRQF_NO_THREAD, to avoid going through an irq thread just
to schedule NAPI and therefore wake up ksoftirqd.

Since analyzing the 40 callers of napi_schedule_irqoff()
to figure out which handlers are light-weight enough to
warrant IRQF_NO_THREAD seems like a larger effort add
a new helper for drivers which set IRQF_NO_THREAD.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/netdevice.h | 21 ++++++++++++++++-----
 net/core/dev.c            | 13 +++++++++++--
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5cbc950b34df..457e2e3ef5a5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -436,7 +436,8 @@ typedef enum rx_handler_result rx_handler_result_t;
 typedef rx_handler_result_t rx_handler_func_t(struct sk_buff **pskb);
 
 void __napi_schedule(struct napi_struct *n);
-void __napi_schedule_irqoff(struct napi_struct *n);
+void __napi_schedule_irqoff(struct napi_struct *n); /* deprecated */
+void __napi_schedule_irq(struct napi_struct *n);
 
 static inline bool napi_disable_pending(struct napi_struct *n)
 {
@@ -463,16 +464,26 @@ static inline void napi_schedule(struct napi_struct *n)
 		__napi_schedule(n);
 }
 
+/* Deprecated, use napi_schedule_irq(). */
+static inline void napi_schedule_irqoff(struct napi_struct *n)
+{
+	if (napi_schedule_prep(n))
+		__napi_schedule_irqoff(n);
+}
+
 /**
- *	napi_schedule_irqoff - schedule NAPI poll
- *	@n: NAPI context
+ * napi_schedule_irq() - schedule NAPI poll from hardware IRQ
+ * @n: NAPI context
  *
  * Variant of napi_schedule(), assuming hard irqs are masked.
+ * Hardware interrupt handler must be marked with IRQF_NO_THREAD
+ * to safely invoke this function on CONFIG_RT=y kernels (unless
+ * it manually masks the interrupts already).
  */
-static inline void napi_schedule_irqoff(struct napi_struct *n)
+static inline void napi_schedule_irq(struct napi_struct *n)
 {
 	if (napi_schedule_prep(n))
-		__napi_schedule_irqoff(n);
+		__napi_schedule_irq(n);
 }
 
 /* Try to reschedule poll. Called by dev->poll() after napi_complete().  */
diff --git a/net/core/dev.c b/net/core/dev.c
index febb23708184..2e20858b5df6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6497,20 +6497,29 @@ bool napi_schedule_prep(struct napi_struct *n)
 }
 EXPORT_SYMBOL(napi_schedule_prep);
 
+void __napi_schedule_irq(struct napi_struct *n)
+{
+	____napi_schedule(this_cpu_ptr(&softnet_data), n);
+}
+EXPORT_SYMBOL(__napi_schedule_irq);
+
 /**
  * __napi_schedule_irqoff - schedule for receive
  * @n: entry to schedule
  *
- * Variant of __napi_schedule() assuming hard irqs are masked.
+ * Legacy variant of __napi_schedule() assuming hard irqs are masked.
  *
  * On PREEMPT_RT enabled kernels this maps to __napi_schedule()
  * because the interrupt disabled assumption might not be true
  * due to force-threaded interrupts and spinlock substitution.
+ *
+ * For light weight IRQ handlers prefer use of napi_schedule_irq(),
+ * and marking IRQ handler with IRQF_NO_THREAD.
  */
 void __napi_schedule_irqoff(struct napi_struct *n)
 {
 	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
-		____napi_schedule(this_cpu_ptr(&softnet_data), n);
+		__napi_schedule_irq(n);
 	else
 		__napi_schedule(n);
 }
-- 
2.31.1

