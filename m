Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03F9B5A2A1
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfF1Rll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:41:41 -0400
Received: from mail.us.es ([193.147.175.20]:52754 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbfF1Rlk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 13:41:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 596EC1B2B62
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 19:41:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45E5E203F9
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 19:41:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3B847DA732; Fri, 28 Jun 2019 19:41:36 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8E038DA4CA;
        Fri, 28 Jun 2019 19:41:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 28 Jun 2019 19:41:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.195.66])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3C00F4265A32;
        Fri, 28 Jun 2019 19:41:32 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/4] ipvs: fix tinfo memory leak in start_sync_thread
Date:   Fri, 28 Jun 2019 19:41:23 +0200
Message-Id: <20190628174125.20739-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190628174125.20739-1-pablo@netfilter.org>
References: <20190628174125.20739-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

syzkaller reports for memory leak in start_sync_thread [1]

As Eric points out, kthread may start and stop before the
threadfn function is called, so there is no chance the
data (tinfo in our case) to be released in thread.

Fix this by releasing tinfo in the controlling code instead.

[1]
BUG: memory leak
unreferenced object 0xffff8881206bf700 (size 32):
 comm "syz-executor761", pid 7268, jiffies 4294943441 (age 20.470s)
 hex dump (first 32 bytes):
   00 40 7c 09 81 88 ff ff 80 45 b8 21 81 88 ff ff  .@|......E.!....
   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 backtrace:
   [<0000000057619e23>] kmemleak_alloc_recursive include/linux/kmemleak.h:55 [inline]
   [<0000000057619e23>] slab_post_alloc_hook mm/slab.h:439 [inline]
   [<0000000057619e23>] slab_alloc mm/slab.c:3326 [inline]
   [<0000000057619e23>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
   [<0000000086ce5479>] kmalloc include/linux/slab.h:547 [inline]
   [<0000000086ce5479>] start_sync_thread+0x5d2/0xe10 net/netfilter/ipvs/ip_vs_sync.c:1862
   [<000000001a9229cc>] do_ip_vs_set_ctl+0x4c5/0x780 net/netfilter/ipvs/ip_vs_ctl.c:2402
   [<00000000ece457c8>] nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
   [<00000000ece457c8>] nf_setsockopt+0x4c/0x80 net/netfilter/nf_sockopt.c:115
   [<00000000942f62d4>] ip_setsockopt net/ipv4/ip_sockglue.c:1258 [inline]
   [<00000000942f62d4>] ip_setsockopt+0x9b/0xb0 net/ipv4/ip_sockglue.c:1238
   [<00000000a56a8ffd>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2616
   [<00000000fa895401>] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3130
   [<0000000095eef4cf>] __sys_setsockopt+0x98/0x120 net/socket.c:2078
   [<000000009747cf88>] __do_sys_setsockopt net/socket.c:2089 [inline]
   [<000000009747cf88>] __se_sys_setsockopt net/socket.c:2086 [inline]
   [<000000009747cf88>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2086
   [<00000000ded8ba80>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:301
   [<00000000893b4ac8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported-by: syzbot+7e2e50c8adfccd2e5041@syzkaller.appspotmail.com
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Fixes: 998e7a76804b ("ipvs: Use kthread_run() instead of doing a double-fork via kernel_thread()")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h             |   6 +-
 net/netfilter/ipvs/ip_vs_ctl.c  |   4 --
 net/netfilter/ipvs/ip_vs_sync.c | 134 +++++++++++++++++++++-------------------
 3 files changed, 76 insertions(+), 68 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 2ac40135b576..b36a1df93e7c 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -808,11 +808,12 @@ struct ipvs_master_sync_state {
 	struct ip_vs_sync_buff	*sync_buff;
 	unsigned long		sync_queue_len;
 	unsigned int		sync_queue_delay;
-	struct task_struct	*master_thread;
 	struct delayed_work	master_wakeup_work;
 	struct netns_ipvs	*ipvs;
 };
 
+struct ip_vs_sync_thread_data;
+
 /* How much time to keep dests in trash */
 #define IP_VS_DEST_TRASH_PERIOD		(120 * HZ)
 
@@ -943,7 +944,8 @@ struct netns_ipvs {
 	spinlock_t		sync_lock;
 	struct ipvs_master_sync_state *ms;
 	spinlock_t		sync_buff_lock;
-	struct task_struct	**backup_threads;
+	struct ip_vs_sync_thread_data *master_tinfo;
+	struct ip_vs_sync_thread_data *backup_tinfo;
 	int			threads_mask;
 	volatile int		sync_state;
 	struct mutex		sync_mutex;
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 776c87ed4813..741d91aa4a8d 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2396,9 +2396,7 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 			cfg.syncid = dm->syncid;
 			ret = start_sync_thread(ipvs, &cfg, dm->state);
 		} else {
-			mutex_lock(&ipvs->sync_mutex);
 			ret = stop_sync_thread(ipvs, dm->state);
-			mutex_unlock(&ipvs->sync_mutex);
 		}
 		goto out_dec;
 	}
@@ -3515,10 +3513,8 @@ static int ip_vs_genl_del_daemon(struct netns_ipvs *ipvs, struct nlattr **attrs)
 	if (!attrs[IPVS_DAEMON_ATTR_STATE])
 		return -EINVAL;
 
-	mutex_lock(&ipvs->sync_mutex);
 	ret = stop_sync_thread(ipvs,
 			       nla_get_u32(attrs[IPVS_DAEMON_ATTR_STATE]));
-	mutex_unlock(&ipvs->sync_mutex);
 	return ret;
 }
 
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 2526be6b3d90..a4a78c4b06de 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -195,6 +195,7 @@ union ip_vs_sync_conn {
 #define IPVS_OPT_F_PARAM	(1 << (IPVS_OPT_PARAM-1))
 
 struct ip_vs_sync_thread_data {
+	struct task_struct *task;
 	struct netns_ipvs *ipvs;
 	struct socket *sock;
 	char *buf;
@@ -374,8 +375,11 @@ static inline void sb_queue_tail(struct netns_ipvs *ipvs,
 					      max(IPVS_SYNC_SEND_DELAY, 1));
 		ms->sync_queue_len++;
 		list_add_tail(&sb->list, &ms->sync_queue);
-		if ((++ms->sync_queue_delay) == IPVS_SYNC_WAKEUP_RATE)
-			wake_up_process(ms->master_thread);
+		if ((++ms->sync_queue_delay) == IPVS_SYNC_WAKEUP_RATE) {
+			int id = (int)(ms - ipvs->ms);
+
+			wake_up_process(ipvs->master_tinfo[id].task);
+		}
 	} else
 		ip_vs_sync_buff_release(sb);
 	spin_unlock(&ipvs->sync_lock);
@@ -1636,8 +1640,10 @@ static void master_wakeup_work_handler(struct work_struct *work)
 	spin_lock_bh(&ipvs->sync_lock);
 	if (ms->sync_queue_len &&
 	    ms->sync_queue_delay < IPVS_SYNC_WAKEUP_RATE) {
+		int id = (int)(ms - ipvs->ms);
+
 		ms->sync_queue_delay = IPVS_SYNC_WAKEUP_RATE;
-		wake_up_process(ms->master_thread);
+		wake_up_process(ipvs->master_tinfo[id].task);
 	}
 	spin_unlock_bh(&ipvs->sync_lock);
 }
@@ -1703,10 +1709,6 @@ static int sync_thread_master(void *data)
 	if (sb)
 		ip_vs_sync_buff_release(sb);
 
-	/* release the sending multicast socket */
-	sock_release(tinfo->sock);
-	kfree(tinfo);
-
 	return 0;
 }
 
@@ -1740,11 +1742,6 @@ static int sync_thread_backup(void *data)
 		}
 	}
 
-	/* release the sending multicast socket */
-	sock_release(tinfo->sock);
-	kfree(tinfo->buf);
-	kfree(tinfo);
-
 	return 0;
 }
 
@@ -1752,8 +1749,8 @@ static int sync_thread_backup(void *data)
 int start_sync_thread(struct netns_ipvs *ipvs, struct ipvs_sync_daemon_cfg *c,
 		      int state)
 {
-	struct ip_vs_sync_thread_data *tinfo = NULL;
-	struct task_struct **array = NULL, *task;
+	struct ip_vs_sync_thread_data *ti = NULL, *tinfo;
+	struct task_struct *task;
 	struct net_device *dev;
 	char *name;
 	int (*threadfn)(void *data);
@@ -1822,7 +1819,7 @@ int start_sync_thread(struct netns_ipvs *ipvs, struct ipvs_sync_daemon_cfg *c,
 		threadfn = sync_thread_master;
 	} else if (state == IP_VS_STATE_BACKUP) {
 		result = -EEXIST;
-		if (ipvs->backup_threads)
+		if (ipvs->backup_tinfo)
 			goto out_early;
 
 		ipvs->bcfg = *c;
@@ -1849,28 +1846,22 @@ int start_sync_thread(struct netns_ipvs *ipvs, struct ipvs_sync_daemon_cfg *c,
 					  master_wakeup_work_handler);
 			ms->ipvs = ipvs;
 		}
-	} else {
-		array = kcalloc(count, sizeof(struct task_struct *),
-				GFP_KERNEL);
-		result = -ENOMEM;
-		if (!array)
-			goto out;
 	}
+	result = -ENOMEM;
+	ti = kcalloc(count, sizeof(struct ip_vs_sync_thread_data),
+		     GFP_KERNEL);
+	if (!ti)
+		goto out;
 
 	for (id = 0; id < count; id++) {
-		result = -ENOMEM;
-		tinfo = kmalloc(sizeof(*tinfo), GFP_KERNEL);
-		if (!tinfo)
-			goto out;
+		tinfo = &ti[id];
 		tinfo->ipvs = ipvs;
-		tinfo->sock = NULL;
 		if (state == IP_VS_STATE_BACKUP) {
+			result = -ENOMEM;
 			tinfo->buf = kmalloc(ipvs->bcfg.sync_maxlen,
 					     GFP_KERNEL);
 			if (!tinfo->buf)
 				goto out;
-		} else {
-			tinfo->buf = NULL;
 		}
 		tinfo->id = id;
 		if (state == IP_VS_STATE_MASTER)
@@ -1885,17 +1876,15 @@ int start_sync_thread(struct netns_ipvs *ipvs, struct ipvs_sync_daemon_cfg *c,
 			result = PTR_ERR(task);
 			goto out;
 		}
-		tinfo = NULL;
-		if (state == IP_VS_STATE_MASTER)
-			ipvs->ms[id].master_thread = task;
-		else
-			array[id] = task;
+		tinfo->task = task;
 	}
 
 	/* mark as active */
 
-	if (state == IP_VS_STATE_BACKUP)
-		ipvs->backup_threads = array;
+	if (state == IP_VS_STATE_MASTER)
+		ipvs->master_tinfo = ti;
+	else
+		ipvs->backup_tinfo = ti;
 	spin_lock_bh(&ipvs->sync_buff_lock);
 	ipvs->sync_state |= state;
 	spin_unlock_bh(&ipvs->sync_buff_lock);
@@ -1910,29 +1899,31 @@ int start_sync_thread(struct netns_ipvs *ipvs, struct ipvs_sync_daemon_cfg *c,
 
 out:
 	/* We do not need RTNL lock anymore, release it here so that
-	 * sock_release below and in the kthreads can use rtnl_lock
-	 * to leave the mcast group.
+	 * sock_release below can use rtnl_lock to leave the mcast group.
 	 */
 	rtnl_unlock();
-	count = id;
-	while (count-- > 0) {
-		if (state == IP_VS_STATE_MASTER)
-			kthread_stop(ipvs->ms[count].master_thread);
-		else
-			kthread_stop(array[count]);
+	id = min(id, count - 1);
+	if (ti) {
+		for (tinfo = ti + id; tinfo >= ti; tinfo--) {
+			if (tinfo->task)
+				kthread_stop(tinfo->task);
+		}
 	}
 	if (!(ipvs->sync_state & IP_VS_STATE_MASTER)) {
 		kfree(ipvs->ms);
 		ipvs->ms = NULL;
 	}
 	mutex_unlock(&ipvs->sync_mutex);
-	if (tinfo) {
-		if (tinfo->sock)
-			sock_release(tinfo->sock);
-		kfree(tinfo->buf);
-		kfree(tinfo);
+
+	/* No more mutexes, release socks */
+	if (ti) {
+		for (tinfo = ti + id; tinfo >= ti; tinfo--) {
+			if (tinfo->sock)
+				sock_release(tinfo->sock);
+			kfree(tinfo->buf);
+		}
+		kfree(ti);
 	}
-	kfree(array);
 	return result;
 
 out_early:
@@ -1944,15 +1935,18 @@ int start_sync_thread(struct netns_ipvs *ipvs, struct ipvs_sync_daemon_cfg *c,
 
 int stop_sync_thread(struct netns_ipvs *ipvs, int state)
 {
-	struct task_struct **array;
+	struct ip_vs_sync_thread_data *ti, *tinfo;
 	int id;
 	int retc = -EINVAL;
 
 	IP_VS_DBG(7, "%s(): pid %d\n", __func__, task_pid_nr(current));
 
+	mutex_lock(&ipvs->sync_mutex);
 	if (state == IP_VS_STATE_MASTER) {
+		retc = -ESRCH;
 		if (!ipvs->ms)
-			return -ESRCH;
+			goto err;
+		ti = ipvs->master_tinfo;
 
 		/*
 		 * The lock synchronizes with sb_queue_tail(), so that we don't
@@ -1971,38 +1965,56 @@ int stop_sync_thread(struct netns_ipvs *ipvs, int state)
 			struct ipvs_master_sync_state *ms = &ipvs->ms[id];
 			int ret;
 
+			tinfo = &ti[id];
 			pr_info("stopping master sync thread %d ...\n",
-				task_pid_nr(ms->master_thread));
+				task_pid_nr(tinfo->task));
 			cancel_delayed_work_sync(&ms->master_wakeup_work);
-			ret = kthread_stop(ms->master_thread);
+			ret = kthread_stop(tinfo->task);
 			if (retc >= 0)
 				retc = ret;
 		}
 		kfree(ipvs->ms);
 		ipvs->ms = NULL;
+		ipvs->master_tinfo = NULL;
 	} else if (state == IP_VS_STATE_BACKUP) {
-		if (!ipvs->backup_threads)
-			return -ESRCH;
+		retc = -ESRCH;
+		if (!ipvs->backup_tinfo)
+			goto err;
+		ti = ipvs->backup_tinfo;
 
 		ipvs->sync_state &= ~IP_VS_STATE_BACKUP;
-		array = ipvs->backup_threads;
 		retc = 0;
 		for (id = ipvs->threads_mask; id >= 0; id--) {
 			int ret;
 
+			tinfo = &ti[id];
 			pr_info("stopping backup sync thread %d ...\n",
-				task_pid_nr(array[id]));
-			ret = kthread_stop(array[id]);
+				task_pid_nr(tinfo->task));
+			ret = kthread_stop(tinfo->task);
 			if (retc >= 0)
 				retc = ret;
 		}
-		kfree(array);
-		ipvs->backup_threads = NULL;
+		ipvs->backup_tinfo = NULL;
+	} else {
+		goto err;
 	}
+	id = ipvs->threads_mask;
+	mutex_unlock(&ipvs->sync_mutex);
+
+	/* No more mutexes, release socks */
+	for (tinfo = ti + id; tinfo >= ti; tinfo--) {
+		if (tinfo->sock)
+			sock_release(tinfo->sock);
+		kfree(tinfo->buf);
+	}
+	kfree(ti);
 
 	/* decrease the module use count */
 	ip_vs_use_count_dec();
+	return retc;
 
+err:
+	mutex_unlock(&ipvs->sync_mutex);
 	return retc;
 }
 
@@ -2021,7 +2033,6 @@ void ip_vs_sync_net_cleanup(struct netns_ipvs *ipvs)
 {
 	int retc;
 
-	mutex_lock(&ipvs->sync_mutex);
 	retc = stop_sync_thread(ipvs, IP_VS_STATE_MASTER);
 	if (retc && retc != -ESRCH)
 		pr_err("Failed to stop Master Daemon\n");
@@ -2029,5 +2040,4 @@ void ip_vs_sync_net_cleanup(struct netns_ipvs *ipvs)
 	retc = stop_sync_thread(ipvs, IP_VS_STATE_BACKUP);
 	if (retc && retc != -ESRCH)
 		pr_err("Failed to stop Backup Daemon\n");
-	mutex_unlock(&ipvs->sync_mutex);
 }
-- 
2.11.0


