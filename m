Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B129818C946
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 09:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgCTI4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 04:56:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:43272 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgCTI4k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 04:56:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E7528AB76;
        Fri, 20 Mar 2020 08:56:38 +0000 (UTC)
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     tglx@linutronix.de
Cc:     arnd@arndb.de, balbi@kernel.org, bhelgaas@google.com,
        bigeasy@linutronix.de, dave@stgolabs.net, davem@davemloft.net,
        gregkh@linuxfoundation.org, joel@joelfernandes.org,
        kurt.schwemmer@microsemi.com, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, logang@deltatee.com,
        mingo@kernel.org, mpe@ellerman.id.au, netdev@vger.kernel.org,
        oleg@redhat.com, paulmck@kernel.org, peterz@infradead.org,
        rdunlap@infradead.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, will@kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 17/15] rcuwait: Inform rcuwait_wake_up() users if a wakeup was attempted
Date:   Fri, 20 Mar 2020 01:55:25 -0700
Message-Id: <20200320085527.23861-2-dave@stgolabs.net>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200320085527.23861-1-dave@stgolabs.net>
References: <20200318204302.693307984@linutronix.de>
 <20200320085527.23861-1-dave@stgolabs.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let the caller know if wake_up_process() was actually called or not;
some users can use this information for ad-hoc. Of course returning
true does not guarantee that wake_up_process() actually woke anything
up.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 include/linux/rcuwait.h |  2 +-
 kernel/exit.c           | 10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/rcuwait.h b/include/linux/rcuwait.h
index 6e8798458091..3f83b9a12ad3 100644
--- a/include/linux/rcuwait.h
+++ b/include/linux/rcuwait.h
@@ -24,7 +24,7 @@ static inline void rcuwait_init(struct rcuwait *w)
 	w->task = NULL;
 }
 
-extern void rcuwait_wake_up(struct rcuwait *w);
+extern bool rcuwait_wake_up(struct rcuwait *w);
 
 /*
  * The caller is responsible for locking around rcuwait_wait_event(),
diff --git a/kernel/exit.c b/kernel/exit.c
index 6cc6cc485d07..b0bb0a8ec4b1 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -234,9 +234,10 @@ void release_task(struct task_struct *p)
 		goto repeat;
 }
 
-void rcuwait_wake_up(struct rcuwait *w)
+bool rcuwait_wake_up(struct rcuwait *w)
 {
 	struct task_struct *task;
+	bool ret = false;
 
 	rcu_read_lock();
 
@@ -254,10 +255,15 @@ void rcuwait_wake_up(struct rcuwait *w)
 	smp_mb(); /* (B) */
 
 	task = rcu_dereference(w->task);
-	if (task)
+	if (task) {
 		wake_up_process(task);
+	        ret = true;
+	}
 	rcu_read_unlock();
+
+	return ret;
 }
+EXPORT_SYMBOL_GPL(rcuwait_wake_up);
 
 /*
  * Determine if a process group is "orphaned", according to the POSIX
-- 
2.16.4

