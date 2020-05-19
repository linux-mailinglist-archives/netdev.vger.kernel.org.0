Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097BC1DA3D3
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 23:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgESVqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 17:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgESVqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 17:46:23 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C07C08C5C0;
        Tue, 19 May 2020 14:46:22 -0700 (PDT)
Received: from [5.158.153.53] (helo=debian-buster-darwi.lab.linutronix.de.)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <a.darwish@linutronix.de>)
        id 1jbA3e-0002Yy-7I; Tue, 19 May 2020 23:45:54 +0200
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v1 01/25] net: core: device_rename: Use rwsem instead of a seqcount
Date:   Tue, 19 May 2020 23:45:23 +0200
Message-Id: <20200519214547.352050-2-a.darwish@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200519214547.352050-1-a.darwish@linutronix.de>
References: <20200519214547.352050-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sequence counters write paths are critical sections that must never be
preempted, and blocking, even for CONFIG_PREEMPTION=n, is not allowed.

Commit 5dbe7c178d3f ("net: fix kernel deadlock with interface rename and
netdev name retrieval.") handled a deadlock, observed with
CONFIG_PREEMPTION=n, where the devnet_rename seqcount read side was
infinitely spinning: it got scheduled after the seqcount write side
blocked inside its own critical section.

To fix that deadlock, among other issues, the commit added a
cond_resched() inside the read side section. While this will get the
non-preemptible kernel eventually unstuck, the seqcount reader is fully
exhausting its slice just spinning -- until TIF_NEED_RESCHED is set.

The fix is also still broken: if the seqcount reader belongs to a
real-time scheduling policy, it can spin forever and the kernel will
livelock.

Disabling preemption over the seqcount write side critical section will
not work: inside it are a number of GFP_KERNEL allocations and mutex
locking through the drivers/base/ :: device_rename() call chain.

From all the above, replace the seqcount with a rwsem.

Fixes: 5dbe7c178d3f (net: fix kernel deadlock with interface rename and netdev name retrieval.)
Fixes: 30e6c9fa93cf (net: devnet_rename_seq should be a seqcount)
Fixes: c91f6df2db49 (sockopt: Change getsockopt() of SO_BINDTODEVICE to return an interface name)
Cc: <stable@vger.kernel.org>
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/core/dev.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 522288177bbd..e18a4c23df0e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -79,6 +79,7 @@
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
@@ -194,7 +195,7 @@ static DEFINE_SPINLOCK(napi_hash_lock);
 static unsigned int napi_gen_id = NR_CPUS;
 static DEFINE_READ_MOSTLY_HASHTABLE(napi_hash, 8);
 
-static seqcount_t devnet_rename_seq;
+static DECLARE_RWSEM(devnet_rename_sem);
 
 static inline void dev_base_seq_inc(struct net *net)
 {
@@ -930,18 +931,13 @@ EXPORT_SYMBOL(dev_get_by_napi_id);
  *	@net: network namespace
  *	@name: a pointer to the buffer where the name will be stored.
  *	@ifindex: the ifindex of the interface to get the name from.
- *
- *	The use of raw_seqcount_begin() and cond_resched() before
- *	retrying is required as we want to give the writers a chance
- *	to complete when CONFIG_PREEMPTION is not set.
  */
 int netdev_get_name(struct net *net, char *name, int ifindex)
 {
 	struct net_device *dev;
-	unsigned int seq;
 
-retry:
-	seq = raw_seqcount_begin(&devnet_rename_seq);
+	down_read(&devnet_rename_sem);
+
 	rcu_read_lock();
 	dev = dev_get_by_index_rcu(net, ifindex);
 	if (!dev) {
@@ -951,10 +947,8 @@ int netdev_get_name(struct net *net, char *name, int ifindex)
 
 	strcpy(name, dev->name);
 	rcu_read_unlock();
-	if (read_seqcount_retry(&devnet_rename_seq, seq)) {
-		cond_resched();
-		goto retry;
-	}
+
+	up_read(&devnet_rename_sem);
 
 	return 0;
 }
@@ -1228,10 +1222,10 @@ int dev_change_name(struct net_device *dev, const char *newname)
 	    likely(!(dev->priv_flags & IFF_LIVE_RENAME_OK)))
 		return -EBUSY;
 
-	write_seqcount_begin(&devnet_rename_seq);
+	down_write(&devnet_rename_sem);
 
 	if (strncmp(newname, dev->name, IFNAMSIZ) == 0) {
-		write_seqcount_end(&devnet_rename_seq);
+		up_write(&devnet_rename_sem);
 		return 0;
 	}
 
@@ -1239,7 +1233,7 @@ int dev_change_name(struct net_device *dev, const char *newname)
 
 	err = dev_get_valid_name(net, dev, newname);
 	if (err < 0) {
-		write_seqcount_end(&devnet_rename_seq);
+		up_write(&devnet_rename_sem);
 		return err;
 	}
 
@@ -1254,11 +1248,11 @@ int dev_change_name(struct net_device *dev, const char *newname)
 	if (ret) {
 		memcpy(dev->name, oldname, IFNAMSIZ);
 		dev->name_assign_type = old_assign_type;
-		write_seqcount_end(&devnet_rename_seq);
+		up_write(&devnet_rename_sem);
 		return ret;
 	}
 
-	write_seqcount_end(&devnet_rename_seq);
+	up_write(&devnet_rename_sem);
 
 	netdev_adjacent_rename_links(dev, oldname);
 
@@ -1279,7 +1273,7 @@ int dev_change_name(struct net_device *dev, const char *newname)
 		/* err >= 0 after dev_alloc_name() or stores the first errno */
 		if (err >= 0) {
 			err = ret;
-			write_seqcount_begin(&devnet_rename_seq);
+			down_write(&devnet_rename_sem);
 			memcpy(dev->name, oldname, IFNAMSIZ);
 			memcpy(oldname, newname, IFNAMSIZ);
 			dev->name_assign_type = old_assign_type;
-- 
2.20.1

