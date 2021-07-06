Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7203BD5FF
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhGFM0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234861AbhGFLhE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:37:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A32961DB7;
        Tue,  6 Jul 2021 11:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570980;
        bh=6kOTvq4E3rR5CPoaAQ9Fp/M1XbL8Na3T0jlE76f1Qms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YI74vwJJ6LnA+5E61zRFcCl8butWZHe9ifOSitwTBXLfvXm+1VEJPBSJbICcBSIAK
         mppLlrIVFVFg6RW086u0NWmlxoOijuVhKmpfFczZ+Q13UUQRwvNZ45lil5Mv6+Ri7/
         7I+LRUX5nW1cAzI3PonkczK5X5OkTUM3lULBJ1rI7BECrGezu1e3aHwErPO7eStCr7
         Ee06DcqXAX0xrMD5qCM6ZFb8BL0M16HAT6Xx0/qTkyPDpcaf+avedIceUAN+T9bYeQ
         Rz9ycQXF2XguHezlYpnHCTU6XTYPnk3pnX/e9ExWmX2CJkZUI03oVtkd/nBgJ9We+R
         8m1LD9W/37XRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Juri Lelli <juri.lelli@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 06/31] net: Treat __napi_schedule_irqoff() as __napi_schedule() on PREEMPT_RT
Date:   Tue,  6 Jul 2021 07:29:06 -0400
Message-Id: <20210706112931.2066397-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112931.2066397-1-sashal@kernel.org>
References: <20210706112931.2066397-1-sashal@kernel.org>
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
index 6fd356e72211..9a0c726bd124 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4723,11 +4723,18 @@ EXPORT_SYMBOL(__napi_schedule);
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

