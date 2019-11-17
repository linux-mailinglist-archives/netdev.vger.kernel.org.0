Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F4BFF81F
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 07:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbfKQGuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 01:50:46 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39478 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725959AbfKQGuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 01:50:46 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAH6nQGG002542
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 22:50:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=lOYiIw2L00Jmt7jzpWQlfvJwmchRN5NMUOO5xe6Lo8M=;
 b=rr9w0ZLZqLU7QiUisffMzDjIyK1iHWlecvGwNT0VfwzXVjP3qvzFuZMnTBNMtd2MjtYX
 XV0LEMXJt/F5w0ir7jxyycNr1Z/SY/3+HHnqwNr2+5Nk5CfD/uiAatvfE2xG6JNOabuI
 HuF9gN89RfB4AHYhb/SlgAtxb2WQYZI4IY4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2waftjsek4-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 22:50:44 -0800
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 16 Nov 2019 22:50:43 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id CD5012EC18AA; Sat, 16 Nov 2019 22:50:42 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v5 bpf-next 2/5] bpf: convert bpf_prog refcnt to atomic64_t
Date:   Sat, 16 Nov 2019 22:50:32 -0800
Message-ID: <20191117065035.202462-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191117065035.202462-1-andriin@fb.com>
References: <20191117065035.202462-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-17_01:2019-11-15,2019-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 clxscore=1015 mlxscore=0 spamscore=0 impostorscore=0
 suspectscore=25 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911170063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to bpf_map's refcnt/usercnt, convert bpf_prog's refcnt to atomic64
and remove artificial 32k limit. This allows to make bpf_prog's refcounting
non-failing, simplifying logic of users of bpf_prog_add/bpf_prog_inc.

Validated compilation by running allyesconfig kernel build.

Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  9 ++----
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  9 ++----
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  7 ++---
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 24 ++++-----------
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 18 ++++-------
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  8 ++---
 drivers/net/virtio_net.c                      |  7 ++---
 include/linux/bpf.h                           | 13 ++++----
 kernel/bpf/inode.c                            |  5 ++--
 kernel/bpf/syscall.c                          | 30 ++++++-------------
 kernel/events/core.c                          |  7 ++---
 11 files changed, 40 insertions(+), 97 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c07172429c70..9da4fbee3cf7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3171,13 +3171,8 @@ static int bnxt_init_one_rx_ring(struct bnxt *bp, int ring_nr)
 	bnxt_init_rxbd_pages(ring, type);
 
 	if (BNXT_RX_PAGE_MODE(bp) && bp->xdp_prog) {
-		rxr->xdp_prog = bpf_prog_add(bp->xdp_prog, 1);
-		if (IS_ERR(rxr->xdp_prog)) {
-			int rc = PTR_ERR(rxr->xdp_prog);
-
-			rxr->xdp_prog = NULL;
-			return rc;
-		}
+		bpf_prog_add(bp->xdp_prog, 1);
+		rxr->xdp_prog = bp->xdp_prog;
 	}
 	prod = rxr->rx_prod;
 	for (i = 0; i < bp->rx_ring_size; i++) {
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 40a44dcb3d9b..f28409279ea4 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1876,13 +1876,8 @@ static int nicvf_xdp_setup(struct nicvf *nic, struct bpf_prog *prog)
 
 	if (nic->xdp_prog) {
 		/* Attach BPF program */
-		nic->xdp_prog = bpf_prog_add(nic->xdp_prog, nic->rx_queues - 1);
-		if (!IS_ERR(nic->xdp_prog)) {
-			bpf_attached = true;
-		} else {
-			ret = PTR_ERR(nic->xdp_prog);
-			nic->xdp_prog = NULL;
-		}
+		bpf_prog_add(nic->xdp_prog, nic->rx_queues - 1);
+		bpf_attached = true;
 	}
 
 	/* Calculate Tx queues needed for XDP and network stack */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index c26c0a7cbb6b..acc56606d3a5 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1807,11 +1807,8 @@ static int setup_xdp(struct net_device *dev, struct bpf_prog *prog)
 	if (prog && !xdp_mtu_valid(priv, dev->mtu))
 		return -EINVAL;
 
-	if (prog) {
-		prog = bpf_prog_add(prog, priv->num_channels);
-		if (IS_ERR(prog))
-			return PTR_ERR(prog);
-	}
+	if (prog)
+		bpf_prog_add(prog, priv->num_channels);
 
 	up = netif_running(dev);
 	need_update = (!!priv->xdp_prog != !!prog);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 40ec5acf79c0..d4697beeacc2 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2286,11 +2286,7 @@ int mlx4_en_try_alloc_resources(struct mlx4_en_priv *priv,
 		lockdep_is_held(&priv->mdev->state_lock));
 
 	if (xdp_prog && carry_xdp_prog) {
-		xdp_prog = bpf_prog_add(xdp_prog, tmp->rx_ring_num);
-		if (IS_ERR(xdp_prog)) {
-			mlx4_en_free_resources(tmp);
-			return PTR_ERR(xdp_prog);
-		}
+		bpf_prog_add(xdp_prog, tmp->rx_ring_num);
 		for (i = 0; i < tmp->rx_ring_num; i++)
 			rcu_assign_pointer(tmp->rx_ring[i]->xdp_prog,
 					   xdp_prog);
@@ -2782,11 +2778,9 @@ static int mlx4_xdp_set(struct net_device *dev, struct bpf_prog *prog)
 	 * program for a new one.
 	 */
 	if (priv->tx_ring_num[TX_XDP] == xdp_ring_num) {
-		if (prog) {
-			prog = bpf_prog_add(prog, priv->rx_ring_num - 1);
-			if (IS_ERR(prog))
-				return PTR_ERR(prog);
-		}
+		if (prog)
+			bpf_prog_add(prog, priv->rx_ring_num - 1);
+
 		mutex_lock(&mdev->state_lock);
 		for (i = 0; i < priv->rx_ring_num; i++) {
 			old_prog = rcu_dereference_protected(
@@ -2807,13 +2801,8 @@ static int mlx4_xdp_set(struct net_device *dev, struct bpf_prog *prog)
 	if (!tmp)
 		return -ENOMEM;
 
-	if (prog) {
-		prog = bpf_prog_add(prog, priv->rx_ring_num - 1);
-		if (IS_ERR(prog)) {
-			err = PTR_ERR(prog);
-			goto out;
-		}
-	}
+	if (prog)
+		bpf_prog_add(prog, priv->rx_ring_num - 1);
 
 	mutex_lock(&mdev->state_lock);
 	memcpy(&new_prof, priv->prof, sizeof(struct mlx4_en_port_profile));
@@ -2862,7 +2851,6 @@ static int mlx4_xdp_set(struct net_device *dev, struct bpf_prog *prog)
 
 unlock_out:
 	mutex_unlock(&mdev->state_lock);
-out:
 	kfree(tmp);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 772bfdbdeb9c..1d4a66fb466a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -408,12 +408,9 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		rq->stats = &c->priv->channel_stats[c->ix].rq;
 	INIT_WORK(&rq->recover_work, mlx5e_rq_err_cqe_work);
 
-	rq->xdp_prog = params->xdp_prog ? bpf_prog_inc(params->xdp_prog) : NULL;
-	if (IS_ERR(rq->xdp_prog)) {
-		err = PTR_ERR(rq->xdp_prog);
-		rq->xdp_prog = NULL;
-		goto err_rq_wq_destroy;
-	}
+	if (params->xdp_prog)
+		bpf_prog_inc(params->xdp_prog);
+	rq->xdp_prog = params->xdp_prog;
 
 	rq_xdp_ix = rq->ix;
 	if (xsk)
@@ -4406,16 +4403,11 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 	/* no need for full reset when exchanging programs */
 	reset = (!priv->channels.params.xdp_prog || !prog);
 
-	if (was_opened && !reset) {
+	if (was_opened && !reset)
 		/* num_channels is invariant here, so we can take the
 		 * batched reference right upfront.
 		 */
-		prog = bpf_prog_add(prog, priv->channels.num);
-		if (IS_ERR(prog)) {
-			err = PTR_ERR(prog);
-			goto unlock;
-		}
-	}
+		bpf_prog_add(prog, priv->channels.num);
 
 	if (was_opened && reset) {
 		struct mlx5e_channels new_channels = {};
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 8d1c208f778f..1e26964fe4e9 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -2107,12 +2107,8 @@ static int qede_start_queues(struct qede_dev *edev, bool clear_stats)
 			if (rc)
 				goto out;
 
-			fp->rxq->xdp_prog = bpf_prog_add(edev->xdp_prog, 1);
-			if (IS_ERR(fp->rxq->xdp_prog)) {
-				rc = PTR_ERR(fp->rxq->xdp_prog);
-				fp->rxq->xdp_prog = NULL;
-				goto out;
-			}
+			bpf_prog_add(edev->xdp_prog, 1);
+			fp->rxq->xdp_prog = edev->xdp_prog;
 		}
 
 		if (fp->type & QEDE_FASTPATH_TX) {
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 5a635f028bdc..4d7d5434cc5d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2445,11 +2445,8 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	if (!prog && !old_prog)
 		return 0;
 
-	if (prog) {
-		prog = bpf_prog_add(prog, vi->max_queue_pairs - 1);
-		if (IS_ERR(prog))
-			return PTR_ERR(prog);
-	}
+	if (prog)
+		bpf_prog_add(prog, vi->max_queue_pairs - 1);
 
 	/* Make sure NAPI is not using any XDP TX queues for RX. */
 	if (netif_running(dev)) {
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 34a34445c009..fb606dc61a3a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -485,7 +485,7 @@ struct bpf_func_info_aux {
 };
 
 struct bpf_prog_aux {
-	atomic_t refcnt;
+	atomic64_t refcnt;
 	u32 used_map_cnt;
 	u32 max_ctx_offset;
 	u32 max_pkt_offset;
@@ -770,9 +770,9 @@ extern const struct bpf_verifier_ops xdp_analyzer_ops;
 struct bpf_prog *bpf_prog_get(u32 ufd);
 struct bpf_prog *bpf_prog_get_type_dev(u32 ufd, enum bpf_prog_type type,
 				       bool attach_drv);
-struct bpf_prog * __must_check bpf_prog_add(struct bpf_prog *prog, int i);
+void bpf_prog_add(struct bpf_prog *prog, int i);
 void bpf_prog_sub(struct bpf_prog *prog, int i);
-struct bpf_prog * __must_check bpf_prog_inc(struct bpf_prog *prog);
+void bpf_prog_inc(struct bpf_prog *prog);
 struct bpf_prog * __must_check bpf_prog_inc_not_zero(struct bpf_prog *prog);
 void bpf_prog_put(struct bpf_prog *prog);
 int __bpf_prog_charge(struct user_struct *user, u32 pages);
@@ -912,10 +912,8 @@ static inline struct bpf_prog *bpf_prog_get_type_dev(u32 ufd,
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
-static inline struct bpf_prog * __must_check bpf_prog_add(struct bpf_prog *prog,
-							  int i)
+static inline void bpf_prog_add(struct bpf_prog *prog, int i)
 {
-	return ERR_PTR(-EOPNOTSUPP);
 }
 
 static inline void bpf_prog_sub(struct bpf_prog *prog, int i)
@@ -926,9 +924,8 @@ static inline void bpf_prog_put(struct bpf_prog *prog)
 {
 }
 
-static inline struct bpf_prog * __must_check bpf_prog_inc(struct bpf_prog *prog)
+static inline void bpf_prog_inc(struct bpf_prog *prog)
 {
-	return ERR_PTR(-EOPNOTSUPP);
 }
 
 static inline struct bpf_prog *__must_check
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 2f17f24258dc..ecf42bec38c0 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -31,7 +31,7 @@ static void *bpf_any_get(void *raw, enum bpf_type type)
 {
 	switch (type) {
 	case BPF_TYPE_PROG:
-		raw = bpf_prog_inc(raw);
+		bpf_prog_inc(raw);
 		break;
 	case BPF_TYPE_MAP:
 		bpf_map_inc_with_uref(raw);
@@ -534,7 +534,8 @@ static struct bpf_prog *__get_prog_inode(struct inode *inode, enum bpf_prog_type
 	if (!bpf_prog_get_ok(prog, &type, false))
 		return ERR_PTR(-EINVAL);
 
-	return bpf_prog_inc(prog);
+	bpf_prog_inc(prog);
+	return prog;
 }
 
 struct bpf_prog *bpf_prog_get_type_path(const char *name, enum bpf_prog_type type)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 20030751b7a2..52fe4bacb330 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1339,7 +1339,7 @@ static void __bpf_prog_put_noref(struct bpf_prog *prog, bool deferred)
 
 static void __bpf_prog_put(struct bpf_prog *prog, bool do_idr_lock)
 {
-	if (atomic_dec_and_test(&prog->aux->refcnt)) {
+	if (atomic64_dec_and_test(&prog->aux->refcnt)) {
 		perf_event_bpf_event(prog, PERF_BPF_EVENT_PROG_UNLOAD, 0);
 		/* bpf_prog_free_id() must be called first */
 		bpf_prog_free_id(prog, do_idr_lock);
@@ -1445,16 +1445,9 @@ static struct bpf_prog *____bpf_prog_get(struct fd f)
 	return f.file->private_data;
 }
 
-/* prog's refcnt limit */
-#define BPF_MAX_REFCNT 32768
-
-struct bpf_prog *bpf_prog_add(struct bpf_prog *prog, int i)
+void bpf_prog_add(struct bpf_prog *prog, int i)
 {
-	if (atomic_add_return(i, &prog->aux->refcnt) > BPF_MAX_REFCNT) {
-		atomic_sub(i, &prog->aux->refcnt);
-		return ERR_PTR(-EBUSY);
-	}
-	return prog;
+	atomic64_add(i, &prog->aux->refcnt);
 }
 EXPORT_SYMBOL_GPL(bpf_prog_add);
 
@@ -1465,13 +1458,13 @@ void bpf_prog_sub(struct bpf_prog *prog, int i)
 	 * path holds a reference to the program, thus atomic_sub() can
 	 * be safely used in such cases!
 	 */
-	WARN_ON(atomic_sub_return(i, &prog->aux->refcnt) == 0);
+	WARN_ON(atomic64_sub_return(i, &prog->aux->refcnt) == 0);
 }
 EXPORT_SYMBOL_GPL(bpf_prog_sub);
 
-struct bpf_prog *bpf_prog_inc(struct bpf_prog *prog)
+void bpf_prog_inc(struct bpf_prog *prog)
 {
-	return bpf_prog_add(prog, 1);
+	atomic64_inc(&prog->aux->refcnt);
 }
 EXPORT_SYMBOL_GPL(bpf_prog_inc);
 
@@ -1480,12 +1473,7 @@ struct bpf_prog *bpf_prog_inc_not_zero(struct bpf_prog *prog)
 {
 	int refold;
 
-	refold = atomic_fetch_add_unless(&prog->aux->refcnt, 1, 0);
-
-	if (refold >= BPF_MAX_REFCNT) {
-		__bpf_prog_put(prog, false);
-		return ERR_PTR(-EBUSY);
-	}
+	refold = atomic64_fetch_add_unless(&prog->aux->refcnt, 1, 0);
 
 	if (!refold)
 		return ERR_PTR(-ENOENT);
@@ -1523,7 +1511,7 @@ static struct bpf_prog *__bpf_prog_get(u32 ufd, enum bpf_prog_type *attach_type,
 		goto out;
 	}
 
-	prog = bpf_prog_inc(prog);
+	bpf_prog_inc(prog);
 out:
 	fdput(f);
 	return prog;
@@ -1714,7 +1702,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	prog->orig_prog = NULL;
 	prog->jited = 0;
 
-	atomic_set(&prog->aux->refcnt, 1);
+	atomic64_set(&prog->aux->refcnt, 1);
 	prog->gpl_compatible = is_gpl ? 1 : 0;
 
 	if (bpf_prog_is_dev_bound(prog->aux)) {
diff --git a/kernel/events/core.c b/kernel/events/core.c
index aec8dba2bea4..73c616876597 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10477,12 +10477,9 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 		context = parent_event->overflow_handler_context;
 #if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_EVENT_TRACING)
 		if (overflow_handler == bpf_overflow_handler) {
-			struct bpf_prog *prog = bpf_prog_inc(parent_event->prog);
+			struct bpf_prog *prog = parent_event->prog;
 
-			if (IS_ERR(prog)) {
-				err = PTR_ERR(prog);
-				goto err_ns;
-			}
+			bpf_prog_inc(prog);
 			event->prog = prog;
 			event->orig_overflow_handler =
 				parent_event->orig_overflow_handler;
-- 
2.17.1

