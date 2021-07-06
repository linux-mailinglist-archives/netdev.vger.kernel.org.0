Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAC93BD2B2
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239567AbhGFLoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:44:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237631AbhGFLgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9672C61DBA;
        Tue,  6 Jul 2021 11:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570936;
        bh=xdNVNWj+EF5c1s5ti6/KbPy938IFVnsEObk7O4JrChI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQr0NHgZlFO1SYqci1f2b49zxLmKtOMfM3NqJA+HGt8OnIto2UYpj5HHZkfsJbBI/
         x7W74i/evjoYiyxKXfv80UMErY8ROXOyaocGHLlneSNWrAU00NttIVkmfzNITp3EL1
         evd4kziW81UNVj4c0Crlfg3xTu/+LOXH3g0TZ/COVKs/aByzBwuOVLzm9klQwA23i0
         5e3yO9ud23I2u21zDv2A/NTTVCKoG5z2/4RPNSUL9S+AHE5J6BBc6T7nCmBpGqPG+J
         xL3O8t3YrL77tXfXA1WFxbWDqKGQRczVOPm6mIZ/4zOGWnzkh4G2vQIVrygPdDmfBt
         n8PFc280emh2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Juri Lelli <juri.lelli@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 06/35] net: Treat __napi_schedule_irqoff() as __napi_schedule() on PREEMPT_RT
Date:   Tue,  6 Jul 2021 07:28:18 -0400
Message-Id: <20210706112848.2066036-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112848.2066036-1-sashal@kernel.org>
References: <20210706112848.2066036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 8380c81d5c4fced6f4397795a5ae65758272bbfd ]

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
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 5b69a9a41dd5..47468fc5d0c9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4998,11 +4998,18 @@ EXPORT_SYMBOL(__napi_schedule);
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
2.30.2

