Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4250831EDAE
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbhBRRvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234356AbhBRRcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 12:32:09 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECD3C061574;
        Thu, 18 Feb 2021 09:31:28 -0800 (PST)
Date:   Thu, 18 Feb 2021 18:31:24 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1613669486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=nLRBuVVWvc8V3uVW45ibYaABYhWDXpjkZ5kiNjBTKQk=;
        b=vE8Bl+8aDfr6BdcXD0gj7H/o1sA/w1cOYT0V+8JyW4JtxHErc89pA+Pz0Fk6Wf0PtuEPZF
        OUbk5JZ6Tnj37TmhRYe8+9ByHXaU9ipZ/aj6qtaNVVRecTQphXzP4a/keZkPzQW2XO5sSs
        KiFpcT/P/Ag/ZCUWYMYMVgVBdU905FgHIJjhWq18dUwExx0sFUYdWLo0tfTozIU334n+28
        t7td9yWBl4tSAT0EGD13Oim8HReFtrayyovUbnsPi2/LT84olfqqwJspTMIFO6cIVtpxB/
        hJHmWgoM++Xo9UATugjrVZAkctW3NGxsOruzmk/lWaLP6xULT1oOEMVMM0+JPQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1613669486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=nLRBuVVWvc8V3uVW45ibYaABYhWDXpjkZ5kiNjBTKQk=;
        b=r5bBoiddMeojU/BxwZp5Q3JGx4e4u1hPZNUoeV1fuLyrO/Kd20S7+FDo7vfYfc8V9op81O
        jV+zSj0NPzBS8fDg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org
Subject: [PATCH] kcov: Remove kcov include from sched.h and move it to its
 users.
Message-ID: <20210218173124.iy5iyqv3a4oia4vv@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recent addition of in_serving_softirq() to kconv.h results in
compile failure on PREEMPT_RT because it requires
task_struct::softirq_disable_cnt. This is not available if kconv.h is
included from sched.h.

It is not needed to include kconv.h from sched.h. All but the net/ user
already include the kconv header file.

Move the include of the kconv.h header from sched.h it its users.
Additionally include sched.h from kconv.h to ensure that everything
task_struct related is available.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/kcov.h  | 1 +
 include/linux/sched.h | 1 -
 net/core/skbuff.c     | 1 +
 net/mac80211/iface.c  | 1 +
 net/mac80211/rx.c     | 1 +
 5 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/kcov.h b/include/linux/kcov.h
index 4e3037dc12048..55dc338f6bcdd 100644
--- a/include/linux/kcov.h
+++ b/include/linux/kcov.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_KCOV_H
 #define _LINUX_KCOV_H
 
+#include <linux/sched.h>
 #include <uapi/linux/kcov.h>
 
 struct task_struct;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7337630326751..183e9d90841cb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -14,7 +14,6 @@
 #include <linux/pid.h>
 #include <linux/sem.h>
 #include <linux/shm.h>
-#include <linux/kcov.h>
 #include <linux/mutex.h>
 #include <linux/plist.h>
 #include <linux/hrtimer.h>
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 785daff48030d..e64d0a2e21c31 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -60,6 +60,7 @@
 #include <linux/prefetch.h>
 #include <linux/if_vlan.h>
 #include <linux/mpls.h>
+#include <linux/kcov.h>
 
 #include <net/protocol.h>
 #include <net/dst.h>
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index b31417f40bd56..39943c33abbfa 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -15,6 +15,7 @@
 #include <linux/if_arp.h>
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
+#include <linux/kcov.h>
 #include <net/mac80211.h>
 #include <net/ieee80211_radiotap.h>
 #include "ieee80211_i.h"
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 972895e9f22dc..3527b17f235a8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -17,6 +17,7 @@
 #include <linux/etherdevice.h>
 #include <linux/rcupdate.h>
 #include <linux/export.h>
+#include <linux/kcov.h>
 #include <linux/bitops.h>
 #include <net/mac80211.h>
 #include <net/ieee80211_radiotap.h>
-- 
2.30.0

