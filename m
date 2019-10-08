Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B472CF299
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 08:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730091AbfJHGQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 02:16:58 -0400
Received: from mga04.intel.com ([192.55.52.120]:63831 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729802AbfJHGQ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 02:16:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 23:16:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="187206749"
Received: from arch-p28.jf.intel.com ([10.166.187.31])
  by orsmga008.jf.intel.com with ESMTP; 07 Oct 2019 23:16:55 -0700
From:   Sridhar Samudrala <sridhar.samudrala@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        sridhar.samudrala@intel.com, intel-wired-lan@lists.osuosl.org,
        maciej.fijalkowski@intel.com, tom.herbert@intel.com
Subject: [PATCH bpf-next 1/4] bpf: introduce bpf_get_prog_id and bpf_set_prog_id helper functions.
Date:   Mon,  7 Oct 2019 23:16:52 -0700
Message-Id: <1570515415-45593-2-git-send-email-sridhar.samudrala@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570515415-45593-1-git-send-email-sridhar.samudrala@intel.com>
References: <1570515415-45593-1-git-send-email-sridhar.samudrala@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the users of bpf prog id access it directly via prog->aux->id.
Next patch in this series introduces a special bpf prog pointer to support
AF_XDP sockets bound to a queue to receive packets from that queue directly.
As the special bpf prog pointer is not associated with any struct bpf_prog
prog id is not accessible via prog->aux. To abstract this from the users,
2 helper functions to get and set prog id are introduced and all the users
are updated to use these functions.

Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c     |  2 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c  |  2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c       |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     |  3 +--
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |  3 +--
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c    |  3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  3 +--
 drivers/net/ethernet/qlogic/qede/qede_filter.c    |  2 +-
 drivers/net/ethernet/socionext/netsec.c           |  2 +-
 drivers/net/netdevsim/bpf.c                       |  6 +++--
 drivers/net/tun.c                                 |  4 +--
 drivers/net/veth.c                                |  4 +--
 drivers/net/virtio_net.c                          |  3 +--
 include/linux/bpf.h                               |  3 +++
 include/trace/events/xdp.h                        |  4 +--
 kernel/bpf/arraymap.c                             |  2 +-
 kernel/bpf/cgroup.c                               |  2 +-
 kernel/bpf/core.c                                 |  2 +-
 kernel/bpf/syscall.c                              | 30 +++++++++++++++++------
 kernel/events/core.c                              |  2 +-
 kernel/trace/bpf_trace.c                          |  2 +-
 net/core/dev.c                                    |  4 +--
 net/core/flow_dissector.c                         |  2 +-
 net/core/rtnetlink.c                              |  2 +-
 net/core/xdp.c                                    |  2 +-
 net/ipv6/seg6_local.c                             |  2 +-
 net/sched/act_bpf.c                               |  2 +-
 net/sched/cls_bpf.c                               |  2 +-
 29 files changed, 58 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index c6f6f2033880..ef6dd2881264 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -330,7 +330,7 @@ int bnxt_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 		rc = bnxt_xdp_set(bp, xdp->prog);
 		break;
 	case XDP_QUERY_PROG:
-		xdp->prog_id = bp->xdp_prog ? bp->xdp_prog->aux->id : 0;
+		xdp->prog_id = bpf_get_prog_id(bp->xdp_prog);
 		rc = 0;
 		break;
 	default:
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 40a44dcb3d9b..5c6c680252c1 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1912,7 +1912,7 @@ static int nicvf_xdp(struct net_device *netdev, struct netdev_bpf *xdp)
 	case XDP_SETUP_PROG:
 		return nicvf_xdp_setup(nic, xdp->prog);
 	case XDP_QUERY_PROG:
-		xdp->prog_id = nic->xdp_prog ? nic->xdp_prog->aux->id : 0;
+		xdp->prog_id = bpf_get_prog_id(nic->xdp_prog);
 		return 0;
 	default:
 		return -EINVAL;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 162d7d8fb295..8aef671d0731 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1831,7 +1831,7 @@ static int dpaa2_eth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	case XDP_SETUP_PROG:
 		return setup_xdp(dev, xdp->prog);
 	case XDP_QUERY_PROG:
-		xdp->prog_id = priv->xdp_prog ? priv->xdp_prog->aux->id : 0;
+		xdp->prog_id = bpf_get_prog_id(priv->xdp_prog);
 		break;
 	default:
 		return -EINVAL;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 6031223eafab..0a59937b376e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12820,7 +12820,7 @@ static int i40e_xdp(struct net_device *dev,
 	case XDP_SETUP_PROG:
 		return i40e_xdp_setup(vsi, xdp->prog);
 	case XDP_QUERY_PROG:
-		xdp->prog_id = vsi->xdp_prog ? vsi->xdp_prog->aux->id : 0;
+		xdp->prog_id = bpf_get_prog_id(vsi->xdp_prog);
 		return 0;
 	case XDP_SETUP_XSK_UMEM:
 		return i40e_xsk_umem_setup(vsi, xdp->xsk.umem,
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 1ce2397306b9..c51ad24be037 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10283,8 +10283,7 @@ static int ixgbe_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	case XDP_SETUP_PROG:
 		return ixgbe_xdp_setup(dev, xdp->prog);
 	case XDP_QUERY_PROG:
-		xdp->prog_id = adapter->xdp_prog ?
-			adapter->xdp_prog->aux->id : 0;
+		xdp->prog_id = bpf_get_prog_id(adapter->xdp_prog);
 		return 0;
 	case XDP_SETUP_XSK_UMEM:
 		return ixgbe_xsk_umem_setup(adapter, xdp->xsk.umem,
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 076f2da36f27..dcf32a32cde8 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4496,8 +4496,7 @@ static int ixgbevf_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	case XDP_SETUP_PROG:
 		return ixgbevf_xdp_setup(dev, xdp->prog);
 	case XDP_QUERY_PROG:
-		xdp->prog_id = adapter->xdp_prog ?
-			       adapter->xdp_prog->aux->id : 0;
+		xdp->prog_id = bpf_get_prog_id(adapter->xdp_prog);
 		return 0;
 	default:
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 40ec5acf79c0..cf086748306f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2881,8 +2881,7 @@ static u32 mlx4_xdp_query(struct net_device *dev)
 	xdp_prog = rcu_dereference_protected(
 		priv->rx_ring[0]->xdp_prog,
 		lockdep_is_held(&mdev->state_lock));
-	if (xdp_prog)
-		prog_id = xdp_prog->aux->id;
+	prog_id = bpf_get_prog_id(xdp_prog);
 	mutex_unlock(&mdev->state_lock);
 
 	return prog_id;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7569287f8f3c..45c247ff05b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4478,8 +4478,7 @@ static u32 mlx5e_xdp_query(struct net_device *dev)
 
 	mutex_lock(&priv->state_lock);
 	xdp_prog = priv->channels.params.xdp_prog;
-	if (xdp_prog)
-		prog_id = xdp_prog->aux->id;
+	prog_id = bpf_get_prog_id(xdp_prog);
 	mutex_unlock(&priv->state_lock);
 
 	return prog_id;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index 9a6a9a008714..75376bb85875 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1119,7 +1119,7 @@ int qede_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	case XDP_SETUP_PROG:
 		return qede_xdp_set(edev, xdp->prog);
 	case XDP_QUERY_PROG:
-		xdp->prog_id = edev->xdp_prog ? edev->xdp_prog->aux->id : 0;
+		xdp->prog_id = bpf_get_prog_id(edev->xdp_prog);
 		return 0;
 	default:
 		return -EINVAL;
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 55db7fbd43cc..19f5a1d850de 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1820,7 +1820,7 @@ static int netsec_xdp(struct net_device *ndev, struct netdev_bpf *xdp)
 	case XDP_SETUP_PROG:
 		return netsec_xdp_setup(priv, xdp->prog, xdp->extack);
 	case XDP_QUERY_PROG:
-		xdp->prog_id = priv->xdp_prog ? priv->xdp_prog->aux->id : 0;
+		xdp->prog_id = bpf_get_prog_id(priv->xdp_prog);
 		return 0;
 	default:
 		return -EINVAL;
diff --git a/drivers/net/netdevsim/bpf.c b/drivers/net/netdevsim/bpf.c
index 2b74425822ab..2a24a7a41985 100644
--- a/drivers/net/netdevsim/bpf.c
+++ b/drivers/net/netdevsim/bpf.c
@@ -104,7 +104,7 @@ nsim_bpf_offload(struct netdevsim *ns, struct bpf_prog *prog, bool oldprog)
 	     "bad offload state, expected offload %sto be active",
 	     oldprog ? "" : "not ");
 	ns->bpf_offloaded = prog;
-	ns->bpf_offloaded_id = prog ? prog->aux->id : 0;
+	ns->bpf_offloaded_id = bpf_get_prog_id(prog);
 	nsim_prog_set_loaded(prog, true);
 
 	return 0;
@@ -218,6 +218,7 @@ static int nsim_bpf_create_prog(struct nsim_dev *nsim_dev,
 {
 	struct nsim_bpf_bound_prog *state;
 	char name[16];
+	u32 prog_id;
 
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
 	if (!state)
@@ -235,7 +236,8 @@ static int nsim_bpf_create_prog(struct nsim_dev *nsim_dev,
 		return -ENOMEM;
 	}
 
-	debugfs_create_u32("id", 0400, state->ddir, &prog->aux->id);
+	prog_id = bpf_get_prog_id(prog);
+	debugfs_create_u32("id", 0400, state->ddir, &prog_id);
 	debugfs_create_file("state", 0400, state->ddir,
 			    &state->state, &nsim_bpf_string_fops);
 	debugfs_create_bool("loaded", 0400, state->ddir, &state->is_loaded);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index aab0be40d443..396905d5c59a 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1224,10 +1224,8 @@ static u32 tun_xdp_query(struct net_device *dev)
 	const struct bpf_prog *xdp_prog;
 
 	xdp_prog = rtnl_dereference(tun->xdp_prog);
-	if (xdp_prog)
-		return xdp_prog->aux->id;
 
-	return 0;
+	return bpf_get_prog_id(xdp_prog);
 }
 
 static int tun_xdp(struct net_device *dev, struct netdev_bpf *xdp)
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 9f3c839f9e5f..261b0df8dc41 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1140,10 +1140,8 @@ static u32 veth_xdp_query(struct net_device *dev)
 	const struct bpf_prog *xdp_prog;
 
 	xdp_prog = priv->_xdp_prog;
-	if (xdp_prog)
-		return xdp_prog->aux->id;
 
-	return 0;
+	return bpf_get_prog_id(xdp_prog);
 }
 
 static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ba98e0971b84..5aa7f95b6c99 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2521,8 +2521,7 @@ static u32 virtnet_xdp_query(struct net_device *dev)
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		xdp_prog = rtnl_dereference(vi->rq[i].xdp_prog);
-		if (xdp_prog)
-			return xdp_prog->aux->id;
+		return bpf_get_prog_id(xdp_prog);
 	}
 	return 0;
 }
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5b9d22338606..e5b023cda42a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -692,6 +692,9 @@ int bpf_get_file_flag(int flags);
 int bpf_check_uarg_tail_zero(void __user *uaddr, size_t expected_size,
 			     size_t actual_size);
 
+u32 bpf_get_prog_id(const struct bpf_prog *prog);
+void bpf_set_prog_id(struct bpf_prog *prog, u32 id);
+
 /* memcpy that is used with 8-byte aligned pointers, power-of-8 size and
  * forced to use 'long' read/writes to try to atomically copy long counters.
  * Best-effort only.  No barriers here, since it _will_ race with concurrent
diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index 8c8420230a10..3369a73c27e1 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -39,7 +39,7 @@ TRACE_EVENT(xdp_exception,
 	),
 
 	TP_fast_assign(
-		__entry->prog_id	= xdp->aux->id;
+		__entry->prog_id	= bpf_get_prog_id(xdp);
 		__entry->act		= act;
 		__entry->ifindex	= dev->ifindex;
 	),
@@ -99,7 +99,7 @@ DECLARE_EVENT_CLASS(xdp_redirect_template,
 	),
 
 	TP_fast_assign(
-		__entry->prog_id	= xdp->aux->id;
+		__entry->prog_id	= bpf_get_prog_id(xdp);
 		__entry->act		= XDP_REDIRECT;
 		__entry->ifindex	= dev->ifindex;
 		__entry->err		= err;
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 1c65ce0098a9..30037d72c176 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -589,7 +589,7 @@ static void prog_fd_array_put_ptr(void *ptr)
 
 static u32 prog_fd_array_sys_lookup_elem(void *ptr)
 {
-	return ((struct bpf_prog *)ptr)->aux->id;
+	return bpf_get_prog_id((struct bpf_prog *)ptr);
 }
 
 /* decrement refcnt of all bpf_progs that are stored in this map */
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index ddd8addcdb5c..8db882606d54 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -526,7 +526,7 @@ int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 
 		i = 0;
 		list_for_each_entry(pl, progs, node) {
-			id = pl->prog->aux->id;
+			id = bpf_get_prog_id(pl->prog);
 			if (copy_to_user(prog_ids + i, &id, sizeof(id)))
 				return -EFAULT;
 			if (++i == cnt)
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 66088a9e9b9e..60ccf0e552fc 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1832,7 +1832,7 @@ static bool bpf_prog_array_copy_core(struct bpf_prog_array *array,
 	for (item = array->items; item->prog; item++) {
 		if (item->prog == &dummy_bpf_prog.prog)
 			continue;
-		prog_ids[i] = item->prog->aux->id;
+		prog_ids[i] = bpf_get_prog_id(item->prog);
 		if (++i == request_cnt) {
 			item++;
 			break;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 82eabd4e38ad..205f95af67d2 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1287,7 +1287,7 @@ static int bpf_prog_alloc_id(struct bpf_prog *prog)
 	spin_lock_bh(&prog_idr_lock);
 	id = idr_alloc_cyclic(&prog_idr, prog, 1, INT_MAX, GFP_ATOMIC);
 	if (id > 0)
-		prog->aux->id = id;
+		bpf_set_prog_id(prog, id);
 	spin_unlock_bh(&prog_idr_lock);
 	idr_preload_end();
 
@@ -1305,7 +1305,7 @@ void bpf_prog_free_id(struct bpf_prog *prog, bool do_idr_lock)
 	 * disappears - even if someone grabs an fd to them they are unusable,
 	 * simply waiting for refcnt to drop to be freed.
 	 */
-	if (!prog->aux->id)
+	if (!bpf_get_prog_id(prog))
 		return;
 
 	if (do_idr_lock)
@@ -1313,8 +1313,8 @@ void bpf_prog_free_id(struct bpf_prog *prog, bool do_idr_lock)
 	else
 		__acquire(&prog_idr_lock);
 
-	idr_remove(&prog_idr, prog->aux->id);
-	prog->aux->id = 0;
+	idr_remove(&prog_idr, bpf_get_prog_id(prog));
+	bpf_set_prog_id(prog, 0);
 
 	if (do_idr_lock)
 		spin_unlock_bh(&prog_idr_lock);
@@ -1353,6 +1353,22 @@ void bpf_prog_put(struct bpf_prog *prog)
 }
 EXPORT_SYMBOL_GPL(bpf_prog_put);
 
+u32 bpf_get_prog_id(const struct bpf_prog *prog)
+{
+	if (prog)
+		return prog->aux->id;
+
+	return 0;
+}
+EXPORT_SYMBOL(bpf_get_prog_id);
+
+void bpf_set_prog_id(struct bpf_prog *prog, u32 id)
+{
+	if (prog)
+		prog->aux->id = id;
+}
+EXPORT_SYMBOL(bpf_set_prog_id);
+
 static int bpf_prog_release(struct inode *inode, struct file *filp)
 {
 	struct bpf_prog *prog = filp->private_data;
@@ -1406,7 +1422,7 @@ static void bpf_prog_show_fdinfo(struct seq_file *m, struct file *filp)
 		   prog->jited,
 		   prog_tag,
 		   prog->pages * 1ULL << PAGE_SHIFT,
-		   prog->aux->id,
+		   bpf_get_prog_id(prog),
 		   stats.nsecs,
 		   stats.cnt);
 }
@@ -2329,7 +2345,7 @@ static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
 		return -EFAULT;
 
 	info.type = prog->type;
-	info.id = prog->aux->id;
+	info.id = bpf_get_prog_id(prog);
 	info.load_time = prog->aux->load_time;
 	info.created_by_uid = from_kuid_munged(current_user_ns(),
 					       prog->aux->user->uid);
@@ -2792,7 +2808,7 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
 		struct bpf_raw_event_map *btp = raw_tp->btp;
 
 		err = bpf_task_fd_query_copy(attr, uattr,
-					     raw_tp->prog->aux->id,
+					     bpf_get_prog_id(raw_tp->prog),
 					     BPF_FD_TYPE_RAW_TRACEPOINT,
 					     btp->tp->name, 0, 0);
 		goto put_file;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4655adbbae10..1410951ca904 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8035,7 +8035,7 @@ void perf_event_bpf_event(struct bpf_prog *prog,
 			},
 			.type = type,
 			.flags = flags,
-			.id = prog->aux->id,
+			.id = bpf_get_prog_id(prog),
 		},
 	};
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 44bd08f2443b..35e8cd2b6b54 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1426,7 +1426,7 @@ int bpf_get_perf_event_info(const struct perf_event *event, u32 *prog_id,
 	if (prog->type == BPF_PROG_TYPE_PERF_EVENT)
 		return -EOPNOTSUPP;
 
-	*prog_id = prog->aux->id;
+	*prog_id = bpf_get_prog_id(prog);
 	flags = event->tp_event->flags;
 	is_tracepoint = flags & TRACE_EVENT_FL_TRACEPOINT;
 	is_syscall_tp = is_syscall_trace_event(event->tp_event);
diff --git a/net/core/dev.c b/net/core/dev.c
index 7a456c6a7ad8..866d0ad936a5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5286,7 +5286,7 @@ static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
 		break;
 
 	case XDP_QUERY_PROG:
-		xdp->prog_id = old ? old->aux->id : 0;
+		xdp->prog_id = bpf_get_prog_id(old);
 		break;
 
 	default:
@@ -8262,7 +8262,7 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 			return -EINVAL;
 		}
 
-		if (prog->aux->id == prog_id) {
+		if (bpf_get_prog_id(prog) == prog_id) {
 			bpf_prog_put(prog);
 			return 0;
 		}
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 6b4b88d1599d..fa8b8e88bfaa 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -89,7 +89,7 @@ int skb_flow_dissector_prog_query(const union bpf_attr *attr,
 	attached = rcu_dereference(net->flow_dissector_prog);
 	if (attached) {
 		prog_cnt = 1;
-		prog_id = attached->aux->id;
+		prog_id = bpf_get_prog_id(attached);
 	}
 	rcu_read_unlock();
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 49fa910b58af..86fd505b4111 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1387,7 +1387,7 @@ static u32 rtnl_xdp_prog_skb(struct net_device *dev)
 	generic_xdp_prog = rtnl_dereference(dev->xdp_prog);
 	if (!generic_xdp_prog)
 		return 0;
-	return generic_xdp_prog->aux->id;
+	return bpf_get_prog_id(generic_xdp_prog);
 }
 
 static u32 rtnl_xdp_prog_drv(struct net_device *dev)
diff --git a/net/core/xdp.c b/net/core/xdp.c
index d7bf62ffbb5e..0bc9a50eb318 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -469,7 +469,7 @@ EXPORT_SYMBOL_GPL(__xdp_release_frame);
 int xdp_attachment_query(struct xdp_attachment_info *info,
 			 struct netdev_bpf *bpf)
 {
-	bpf->prog_id = info->prog ? info->prog->aux->id : 0;
+	bpf->prog_id = bpf_get_prog_id(info->prog);
 	bpf->prog_flags = info->prog ? info->flags : 0;
 	return 0;
 }
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 9d4f75e0d33a..e49987655567 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -853,7 +853,7 @@ static int put_nla_bpf(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 	if (!nest)
 		return -EMSGSIZE;
 
-	if (nla_put_u32(skb, SEG6_LOCAL_BPF_PROG, slwt->bpf.prog->aux->id))
+	if (nla_put_u32(skb, SEG6_LOCAL_BPF_PROG, bpf_get_prog_id(slwt->bpf.prog)))
 		return -EMSGSIZE;
 
 	if (slwt->bpf.name &&
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index 04b7bd4ec751..d55a28d0adf6 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -119,7 +119,7 @@ static int tcf_bpf_dump_ebpf_info(const struct tcf_bpf *prog,
 	    nla_put_string(skb, TCA_ACT_BPF_NAME, prog->bpf_name))
 		return -EMSGSIZE;
 
-	if (nla_put_u32(skb, TCA_ACT_BPF_ID, prog->filter->aux->id))
+	if (nla_put_u32(skb, TCA_ACT_BPF_ID, bpf_get_prog_id(prog->filter))
 		return -EMSGSIZE;
 
 	nla = nla_reserve(skb, TCA_ACT_BPF_TAG, sizeof(prog->filter->tag));
diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index bf10bdaf5012..d35aedb4aee5 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -562,7 +562,7 @@ static int cls_bpf_dump_ebpf_info(const struct cls_bpf_prog *prog,
 	    nla_put_string(skb, TCA_BPF_NAME, prog->bpf_name))
 		return -EMSGSIZE;
 
-	if (nla_put_u32(skb, TCA_BPF_ID, prog->filter->aux->id))
+	if (nla_put_u32(skb, TCA_BPF_ID, bpf_get_prog_id(prog->filter))
 		return -EMSGSIZE;
 
 	nla = nla_reserve(skb, TCA_BPF_TAG, sizeof(prog->filter->tag));
-- 
2.14.5

