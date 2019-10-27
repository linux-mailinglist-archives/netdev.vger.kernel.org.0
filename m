Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB94EE6253
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 13:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfJ0MCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 08:02:44 -0400
Received: from correo.us.es ([193.147.175.20]:60136 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726831AbfJ0MCn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 08:02:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 71D927FC4E
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 13:02:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 60529B7FF6
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 13:02:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 55E9CB7FFE; Sun, 27 Oct 2019 13:02:38 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 231B5B7FF6;
        Sun, 27 Oct 2019 13:02:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 27 Oct 2019 13:02:36 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E664A42EE38F;
        Sun, 27 Oct 2019 13:02:35 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/5] ipvs: don't ignore errors in case refcounting ip_vs module fails
Date:   Sun, 27 Oct 2019 13:02:19 +0100
Message-Id: <20191027120221.2884-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191027120221.2884-1-pablo@netfilter.org>
References: <20191027120221.2884-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

if the IPVS module is removed while the sync daemon is starting, there is
a small gap where try_module_get() might fail getting the refcount inside
ip_vs_use_count_inc(). Then, the refcounts of IPVS module are unbalanced,
and the subsequent call to stop_sync_thread() causes the following splat:

 WARNING: CPU: 0 PID: 4013 at kernel/module.c:1146 module_put.part.44+0x15b/0x290
  Modules linked in: ip_vs(-) nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 veth ip6table_filter ip6_tables iptable_filter binfmt_misc intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul ext4 mbcache jbd2 ghash_clmulni_intel snd_hda_codec_generic ledtrig_audio snd_hda_intel snd_intel_nhlt snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm aesni_intel crypto_simd cryptd glue_helper joydev pcspkr snd_timer virtio_balloon snd soundcore i2c_piix4 nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c ata_generic pata_acpi virtio_net net_failover virtio_blk failover virtio_console qxl drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ata_piix ttm crc32c_intel serio_raw drm virtio_pci libata virtio_ring virtio floppy dm_mirror dm_region_hash dm_log dm_mod [last unloaded: nf_defrag_ipv6]
  CPU: 0 PID: 4013 Comm: modprobe Tainted: G        W         5.4.0-rc1.upstream+ #741
  Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
  RIP: 0010:module_put.part.44+0x15b/0x290
  Code: 04 25 28 00 00 00 0f 85 18 01 00 00 48 83 c4 68 5b 5d 41 5c 41 5d 41 5e 41 5f c3 89 44 24 28 83 e8 01 89 c5 0f 89 57 ff ff ff <0f> 0b e9 78 ff ff ff 65 8b 1d 67 83 26 4a 89 db be 08 00 00 00 48
  RSP: 0018:ffff888050607c78 EFLAGS: 00010297
  RAX: 0000000000000003 RBX: ffffffffc1420590 RCX: ffffffffb5db0ef9
  RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffffffc1420590
  RBP: 00000000ffffffff R08: fffffbfff82840b3 R09: fffffbfff82840b3
  R10: 0000000000000001 R11: fffffbfff82840b2 R12: 1ffff1100a0c0f90
  R13: ffffffffc1420200 R14: ffff88804f533300 R15: ffff88804f533ca0
  FS:  00007f8ea9720740(0000) GS:ffff888053800000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f3245abe000 CR3: 000000004c28a006 CR4: 00000000001606f0
  Call Trace:
   stop_sync_thread+0x3a3/0x7c0 [ip_vs]
   ip_vs_sync_net_cleanup+0x13/0x50 [ip_vs]
   ops_exit_list.isra.5+0x94/0x140
   unregister_pernet_operations+0x29d/0x460
   unregister_pernet_device+0x26/0x60
   ip_vs_cleanup+0x11/0x38 [ip_vs]
   __x64_sys_delete_module+0x2d5/0x400
   do_syscall_64+0xa5/0x4e0
   entry_SYSCALL_64_after_hwframe+0x49/0xbe
  RIP: 0033:0x7f8ea8bf0db7
  Code: 73 01 c3 48 8b 0d b9 80 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 89 80 2c 00 f7 d8 64 89 01 48
  RSP: 002b:00007ffcd38d2fe8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
  RAX: ffffffffffffffda RBX: 0000000002436240 RCX: 00007f8ea8bf0db7
  RDX: 0000000000000000 RSI: 0000000000000800 RDI: 00000000024362a8
  RBP: 0000000000000000 R08: 00007f8ea8eba060 R09: 00007f8ea8c658a0
  R10: 00007ffcd38d2a60 R11: 0000000000000206 R12: 0000000000000000
  R13: 0000000000000001 R14: 00000000024362a8 R15: 0000000000000000
  irq event stamp: 4538
  hardirqs last  enabled at (4537): [<ffffffffb6193dde>] quarantine_put+0x9e/0x170
  hardirqs last disabled at (4538): [<ffffffffb5a0556a>] trace_hardirqs_off_thunk+0x1a/0x20
  softirqs last  enabled at (4522): [<ffffffffb6f8ebe9>] sk_common_release+0x169/0x2d0
  softirqs last disabled at (4520): [<ffffffffb6f8eb3e>] sk_common_release+0xbe/0x2d0

Check the return value of ip_vs_use_count_inc() and let its caller return
proper error. Inside do_ip_vs_set_ctl() the module is already refcounted,
we don't need refcount/derefcount there. Finally, in register_ip_vs_app()
and start_sync_thread(), take the module refcount earlier and ensure it's
released in the error path.

Change since v1:
 - better return values in case of failure of ip_vs_use_count_inc(),
   thanks to Julian Anastasov
 - no need to increase/decrease the module refcount in ip_vs_set_ctl(),
   thanks to Julian Anastasov

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 net/netfilter/ipvs/ip_vs_app.c   | 12 ++++++++++--
 net/netfilter/ipvs/ip_vs_ctl.c   | 14 ++++----------
 net/netfilter/ipvs/ip_vs_pe.c    |  3 ++-
 net/netfilter/ipvs/ip_vs_sched.c |  3 ++-
 net/netfilter/ipvs/ip_vs_sync.c  | 13 ++++++++++---
 5 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
index 4515056ef1c2..f9b16f2b2219 100644
--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -193,21 +193,29 @@ struct ip_vs_app *register_ip_vs_app(struct netns_ipvs *ipvs, struct ip_vs_app *
 
 	mutex_lock(&__ip_vs_app_mutex);
 
+	/* increase the module use count */
+	if (!ip_vs_use_count_inc()) {
+		err = -ENOENT;
+		goto out_unlock;
+	}
+
 	list_for_each_entry(a, &ipvs->app_list, a_list) {
 		if (!strcmp(app->name, a->name)) {
 			err = -EEXIST;
+			/* decrease the module use count */
+			ip_vs_use_count_dec();
 			goto out_unlock;
 		}
 	}
 	a = kmemdup(app, sizeof(*app), GFP_KERNEL);
 	if (!a) {
 		err = -ENOMEM;
+		/* decrease the module use count */
+		ip_vs_use_count_dec();
 		goto out_unlock;
 	}
 	INIT_LIST_HEAD(&a->incs_list);
 	list_add(&a->a_list, &ipvs->app_list);
-	/* increase the module use count */
-	ip_vs_use_count_inc();
 
 out_unlock:
 	mutex_unlock(&__ip_vs_app_mutex);
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 8b48e7ce1c2c..c8f81dd15c83 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1275,7 +1275,8 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 	struct ip_vs_service *svc = NULL;
 
 	/* increase the module use count */
-	ip_vs_use_count_inc();
+	if (!ip_vs_use_count_inc())
+		return -ENOPROTOOPT;
 
 	/* Lookup the scheduler by 'u->sched_name' */
 	if (strcmp(u->sched_name, "none")) {
@@ -2435,9 +2436,6 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 	if (copy_from_user(arg, user, len) != 0)
 		return -EFAULT;
 
-	/* increase the module use count */
-	ip_vs_use_count_inc();
-
 	/* Handle daemons since they have another lock */
 	if (cmd == IP_VS_SO_SET_STARTDAEMON ||
 	    cmd == IP_VS_SO_SET_STOPDAEMON) {
@@ -2450,13 +2448,13 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 			ret = -EINVAL;
 			if (strscpy(cfg.mcast_ifn, dm->mcast_ifn,
 				    sizeof(cfg.mcast_ifn)) <= 0)
-				goto out_dec;
+				return ret;
 			cfg.syncid = dm->syncid;
 			ret = start_sync_thread(ipvs, &cfg, dm->state);
 		} else {
 			ret = stop_sync_thread(ipvs, dm->state);
 		}
-		goto out_dec;
+		return ret;
 	}
 
 	mutex_lock(&__ip_vs_mutex);
@@ -2551,10 +2549,6 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 
   out_unlock:
 	mutex_unlock(&__ip_vs_mutex);
-  out_dec:
-	/* decrease the module use count */
-	ip_vs_use_count_dec();
-
 	return ret;
 }
 
diff --git a/net/netfilter/ipvs/ip_vs_pe.c b/net/netfilter/ipvs/ip_vs_pe.c
index 8e104dff7abc..166c669f0763 100644
--- a/net/netfilter/ipvs/ip_vs_pe.c
+++ b/net/netfilter/ipvs/ip_vs_pe.c
@@ -68,7 +68,8 @@ int register_ip_vs_pe(struct ip_vs_pe *pe)
 	struct ip_vs_pe *tmp;
 
 	/* increase the module use count */
-	ip_vs_use_count_inc();
+	if (!ip_vs_use_count_inc())
+		return -ENOENT;
 
 	mutex_lock(&ip_vs_pe_mutex);
 	/* Make sure that the pe with this name doesn't exist
diff --git a/net/netfilter/ipvs/ip_vs_sched.c b/net/netfilter/ipvs/ip_vs_sched.c
index 2f9d5cd5daee..d4903723be7e 100644
--- a/net/netfilter/ipvs/ip_vs_sched.c
+++ b/net/netfilter/ipvs/ip_vs_sched.c
@@ -179,7 +179,8 @@ int register_ip_vs_scheduler(struct ip_vs_scheduler *scheduler)
 	}
 
 	/* increase the module use count */
-	ip_vs_use_count_inc();
+	if (!ip_vs_use_count_inc())
+		return -ENOENT;
 
 	mutex_lock(&ip_vs_sched_mutex);
 
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index a4a78c4b06de..8dc892a9dc91 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1762,6 +1762,10 @@ int start_sync_thread(struct netns_ipvs *ipvs, struct ipvs_sync_daemon_cfg *c,
 	IP_VS_DBG(7, "Each ip_vs_sync_conn entry needs %zd bytes\n",
 		  sizeof(struct ip_vs_sync_conn_v0));
 
+	/* increase the module use count */
+	if (!ip_vs_use_count_inc())
+		return -ENOPROTOOPT;
+
 	/* Do not hold one mutex and then to block on another */
 	for (;;) {
 		rtnl_lock();
@@ -1892,9 +1896,6 @@ int start_sync_thread(struct netns_ipvs *ipvs, struct ipvs_sync_daemon_cfg *c,
 	mutex_unlock(&ipvs->sync_mutex);
 	rtnl_unlock();
 
-	/* increase the module use count */
-	ip_vs_use_count_inc();
-
 	return 0;
 
 out:
@@ -1924,11 +1925,17 @@ int start_sync_thread(struct netns_ipvs *ipvs, struct ipvs_sync_daemon_cfg *c,
 		}
 		kfree(ti);
 	}
+
+	/* decrease the module use count */
+	ip_vs_use_count_dec();
 	return result;
 
 out_early:
 	mutex_unlock(&ipvs->sync_mutex);
 	rtnl_unlock();
+
+	/* decrease the module use count */
+	ip_vs_use_count_dec();
 	return result;
 }
 
-- 
2.11.0

