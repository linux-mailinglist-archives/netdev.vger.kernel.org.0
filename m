Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E96718C94F
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 09:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbgCTI4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 04:56:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:43474 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgCTI4u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 04:56:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 18286AE9A;
        Fri, 20 Mar 2020 08:56:49 +0000 (UTC)
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
Subject: [PATCH 19/15] sched/swait: Reword some of the main description
Date:   Fri, 20 Mar 2020 01:55:27 -0700
Message-Id: <20200320085527.23861-4-dave@stgolabs.net>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200320085527.23861-1-dave@stgolabs.net>
References: <20200318204302.693307984@linutronix.de>
 <20200320085527.23861-1-dave@stgolabs.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With both the increased use of swait and kvm no longer using
it, we can reword some of the comments. While removing Linus'
valid rant, I've also cared to explicitly mention that swait
is very different than regular wait. In addition it is
mentioned against using swait in favor of the regular flavor.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 include/linux/swait.h | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/include/linux/swait.h b/include/linux/swait.h
index 73e06e9986d4..6e5b5d0e64fd 100644
--- a/include/linux/swait.h
+++ b/include/linux/swait.h
@@ -9,23 +9,10 @@
 #include <asm/current.h>
 
 /*
- * BROKEN wait-queues.
- *
- * These "simple" wait-queues are broken garbage, and should never be
- * used. The comments below claim that they are "similar" to regular
- * wait-queues, but the semantics are actually completely different, and
- * every single user we have ever had has been buggy (or pointless).
- *
- * A "swake_up_one()" only wakes up _one_ waiter, which is not at all what
- * "wake_up()" does, and has led to problems. In other cases, it has
- * been fine, because there's only ever one waiter (kvm), but in that
- * case gthe whole "simple" wait-queue is just pointless to begin with,
- * since there is no "queue". Use "wake_up_process()" with a direct
- * pointer instead.
- *
- * While these are very similar to regular wait queues (wait.h) the most
- * important difference is that the simple waitqueue allows for deterministic
- * behaviour -- IOW it has strictly bounded IRQ and lock hold times.
+ * Simple waitqueues are semantically very different to regular wait queues
+ * (wait.h). The most important difference is that the simple waitqueue allows
+ * for deterministic behaviour -- IOW it has strictly bounded IRQ and lock hold
+ * times.
  *
  * Mainly, this is accomplished by two things. Firstly not allowing swake_up_all
  * from IRQ disabled, and dropping the lock upon every wakeup, giving a higher
@@ -39,7 +26,7 @@
  *    sleeper state.
  *
  *  - the !exclusive mode; because that leads to O(n) wakeups, everything is
- *    exclusive.
+ *    exclusive. As such swait_wake_up_one will only ever awake _one_ waiter.
  *
  *  - custom wake callback functions; because you cannot give any guarantees
  *    about random code. This also allows swait to be used in RT, such that
-- 
2.16.4

