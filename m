Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB4C280823
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733114AbgJATxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:53:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732941AbgJATx2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 15:53:28 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F173F21D7A;
        Thu,  1 Oct 2020 19:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601581998;
        bh=nQ7XBHy384gkT3QC8Zm2HtCQoZ5HIHLd6k04/7tH+nQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EoLM2Ag1zsE4iXIv5LXyoTgTuZWgZWOCpNFsK3pYdHJBqh+JiYDjheZrb2K1mE9WA
         KW8484904bsMXMhvvI664CgAWkOdzbpt7oacG2NhN5etHiQEo/TIJrOo88wTtY8+mT
         tGldORpXsl53v6v0GLQi3W1SeCaLor13U0lCHvXc=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net V2 15/15] net/mlx5e: Fix race condition on nhe->n pointer in neigh update
Date:   Thu,  1 Oct 2020 12:52:47 -0700
Message-Id: <20201001195247.66636-16-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001195247.66636-1-saeed@kernel.org>
References: <20201001195247.66636-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Current neigh update event handler implementation takes reference to
neighbour structure, assigns it to nhe->n, tries to schedule workqueue task
and releases the reference if task was already enqueued. This results
potentially overwriting existing nhe->n pointer with another neighbour
instance, which causes double release of the instance (once in neigh update
handler that failed to enqueue to workqueue and another one in neigh update
workqueue task that processes updated nhe->n pointer instead of original
one):

[ 3376.512806] ------------[ cut here ]------------
[ 3376.513534] refcount_t: underflow; use-after-free.
[ 3376.521213] Modules linked in: act_skbedit act_mirred act_tunnel_key vxlan ip6_udp_tunnel udp_tunnel nfnetlink act_gact cls_flower sch_ingress openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 mlx5_ib mlx5_core mlxfw pci_hyperv_intf ptp pps_core nfsv3 nfs_acl rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd
 grace fscache ib_isert iscsi_target_mod ib_srpt target_core_mod ib_srp rpcrdma rdma_ucm ib_umad ib_ipoib ib_iser rdma_cm ib_cm iw_cm rfkill ib_uverbs ib_core sunrpc kvm_intel kvm iTCO_wdt iTCO_vendor_support virtio_net irqbypass net_failover crc32_pclmul lpc_ich i2c_i801 failover pcspkr i2c_smbus mfd_core ghash_clmulni_intel sch_fq_codel drm i2c
_core ip_tables crc32c_intel serio_raw [last unloaded: mlxfw]
[ 3376.529468] CPU: 8 PID: 22756 Comm: kworker/u20:5 Not tainted 5.9.0-rc5+ #6
[ 3376.530399] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[ 3376.531975] Workqueue: mlx5e mlx5e_rep_neigh_update [mlx5_core]
[ 3376.532820] RIP: 0010:refcount_warn_saturate+0xd8/0xe0
[ 3376.533589] Code: ff 48 c7 c7 e0 b8 27 82 c6 05 0b b6 09 01 01 e8 94 93 c1 ff 0f 0b c3 48 c7 c7 88 b8 27 82 c6 05 f7 b5 09 01 01 e8 7e 93 c1 ff <0f> 0b c3 0f 1f 44 00 00 8b 07 3d 00 00 00 c0 74 12 83 f8 01 74 13
[ 3376.536017] RSP: 0018:ffffc90002a97e30 EFLAGS: 00010286
[ 3376.536793] RAX: 0000000000000000 RBX: ffff8882de30d648 RCX: 0000000000000000
[ 3376.537718] RDX: ffff8882f5c28f20 RSI: ffff8882f5c18e40 RDI: ffff8882f5c18e40
[ 3376.538654] RBP: ffff8882cdf56c00 R08: 000000000000c580 R09: 0000000000001a4d
[ 3376.539582] R10: 0000000000000731 R11: ffffc90002a97ccd R12: 0000000000000000
[ 3376.540519] R13: ffff8882de30d600 R14: ffff8882de30d640 R15: ffff88821e000900
[ 3376.541444] FS:  0000000000000000(0000) GS:ffff8882f5c00000(0000) knlGS:0000000000000000
[ 3376.542732] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3376.543545] CR2: 0000556e5504b248 CR3: 00000002c6f10005 CR4: 0000000000770ee0
[ 3376.544483] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3376.545419] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 3376.546344] PKRU: 55555554
[ 3376.546911] Call Trace:
[ 3376.547479]  mlx5e_rep_neigh_update.cold+0x33/0xe2 [mlx5_core]
[ 3376.548299]  process_one_work+0x1d8/0x390
[ 3376.548977]  worker_thread+0x4d/0x3e0
[ 3376.549631]  ? rescuer_thread+0x3e0/0x3e0
[ 3376.550295]  kthread+0x118/0x130
[ 3376.550914]  ? kthread_create_worker_on_cpu+0x70/0x70
[ 3376.551675]  ret_from_fork+0x1f/0x30
[ 3376.552312] ---[ end trace d84e8f46d2a77eec ]---

Fix the bug by moving work_struct to dedicated dynamically-allocated
structure. This enabled every event handler to work on its own private
neighbour pointer and removes the need for handling the case when task is
already enqueued.

Fixes: 232c001398ae ("net/mlx5e: Add support to neighbour update flow")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/rep/neigh.c         | 81 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  6 --
 2 files changed, 50 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
index 906292035088..58e27038c947 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
@@ -110,11 +110,25 @@ static void mlx5e_rep_neigh_stats_work(struct work_struct *work)
 	rtnl_unlock();
 }
 
+struct neigh_update_work {
+	struct work_struct work;
+	struct neighbour *n;
+	struct mlx5e_neigh_hash_entry *nhe;
+};
+
+static void mlx5e_release_neigh_update_work(struct neigh_update_work *update_work)
+{
+	neigh_release(update_work->n);
+	mlx5e_rep_neigh_entry_release(update_work->nhe);
+	kfree(update_work);
+}
+
 static void mlx5e_rep_neigh_update(struct work_struct *work)
 {
-	struct mlx5e_neigh_hash_entry *nhe =
-		container_of(work, struct mlx5e_neigh_hash_entry, neigh_update_work);
-	struct neighbour *n = nhe->n;
+	struct neigh_update_work *update_work = container_of(work, struct neigh_update_work,
+							     work);
+	struct mlx5e_neigh_hash_entry *nhe = update_work->nhe;
+	struct neighbour *n = update_work->n;
 	struct mlx5e_encap_entry *e;
 	unsigned char ha[ETH_ALEN];
 	struct mlx5e_priv *priv;
@@ -146,30 +160,42 @@ static void mlx5e_rep_neigh_update(struct work_struct *work)
 		mlx5e_rep_update_flows(priv, e, neigh_connected, ha);
 		mlx5e_encap_put(priv, e);
 	}
-	mlx5e_rep_neigh_entry_release(nhe);
 	rtnl_unlock();
-	neigh_release(n);
+	mlx5e_release_neigh_update_work(update_work);
 }
 
-static void mlx5e_rep_queue_neigh_update_work(struct mlx5e_priv *priv,
-					      struct mlx5e_neigh_hash_entry *nhe,
-					      struct neighbour *n)
+static struct neigh_update_work *mlx5e_alloc_neigh_update_work(struct mlx5e_priv *priv,
+							       struct neighbour *n)
 {
-	/* Take a reference to ensure the neighbour and mlx5 encap
-	 * entry won't be destructed until we drop the reference in
-	 * delayed work.
-	 */
-	neigh_hold(n);
+	struct neigh_update_work *update_work;
+	struct mlx5e_neigh_hash_entry *nhe;
+	struct mlx5e_neigh m_neigh = {};
 
-	/* This assignment is valid as long as the the neigh reference
-	 * is taken
-	 */
-	nhe->n = n;
+	update_work = kzalloc(sizeof(*update_work), GFP_ATOMIC);
+	if (WARN_ON(!update_work))
+		return NULL;
 
-	if (!queue_work(priv->wq, &nhe->neigh_update_work)) {
-		mlx5e_rep_neigh_entry_release(nhe);
-		neigh_release(n);
+	m_neigh.dev = n->dev;
+	m_neigh.family = n->ops->family;
+	memcpy(&m_neigh.dst_ip, n->primary_key, n->tbl->key_len);
+
+	/* Obtain reference to nhe as last step in order not to release it in
+	 * atomic context.
+	 */
+	rcu_read_lock();
+	nhe = mlx5e_rep_neigh_entry_lookup(priv, &m_neigh);
+	rcu_read_unlock();
+	if (!nhe) {
+		kfree(update_work);
+		return NULL;
 	}
+
+	INIT_WORK(&update_work->work, mlx5e_rep_neigh_update);
+	neigh_hold(n);
+	update_work->n = n;
+	update_work->nhe = nhe;
+
+	return update_work;
 }
 
 static int mlx5e_rep_netevent_event(struct notifier_block *nb,
@@ -181,7 +207,7 @@ static int mlx5e_rep_netevent_event(struct notifier_block *nb,
 	struct net_device *netdev = rpriv->netdev;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_neigh_hash_entry *nhe = NULL;
-	struct mlx5e_neigh m_neigh = {};
+	struct neigh_update_work *update_work;
 	struct neigh_parms *p;
 	struct neighbour *n;
 	bool found = false;
@@ -196,17 +222,11 @@ static int mlx5e_rep_netevent_event(struct notifier_block *nb,
 #endif
 			return NOTIFY_DONE;
 
-		m_neigh.dev = n->dev;
-		m_neigh.family = n->ops->family;
-		memcpy(&m_neigh.dst_ip, n->primary_key, n->tbl->key_len);
-
-		rcu_read_lock();
-		nhe = mlx5e_rep_neigh_entry_lookup(priv, &m_neigh);
-		rcu_read_unlock();
-		if (!nhe)
+		update_work = mlx5e_alloc_neigh_update_work(priv, n);
+		if (!update_work)
 			return NOTIFY_DONE;
 
-		mlx5e_rep_queue_neigh_update_work(priv, nhe, n);
+		queue_work(priv->wq, &update_work->work);
 		break;
 
 	case NETEVENT_DELAY_PROBE_TIME_UPDATE:
@@ -352,7 +372,6 @@ int mlx5e_rep_neigh_entry_create(struct mlx5e_priv *priv,
 
 	(*nhe)->priv = priv;
 	memcpy(&(*nhe)->m_neigh, &e->m_neigh, sizeof(e->m_neigh));
-	INIT_WORK(&(*nhe)->neigh_update_work, mlx5e_rep_neigh_update);
 	spin_lock_init(&(*nhe)->encap_list_lock);
 	INIT_LIST_HEAD(&(*nhe)->encap_list);
 	refcount_set(&(*nhe)->refcnt, 1);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 622c27ae4ac7..0d1562e20118 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -135,12 +135,6 @@ struct mlx5e_neigh_hash_entry {
 	/* encap list sharing the same neigh */
 	struct list_head encap_list;
 
-	/* valid only when the neigh reference is taken during
-	 * neigh_update_work workqueue callback.
-	 */
-	struct neighbour *n;
-	struct work_struct neigh_update_work;
-
 	/* neigh hash entry can be deleted only when the refcount is zero.
 	 * refcount is needed to avoid neigh hash entry removal by TC, while
 	 * it's used by the neigh notification call.
-- 
2.26.2

