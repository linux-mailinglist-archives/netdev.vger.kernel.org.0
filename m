Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B403722FC60
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgG0Wo5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 18:44:57 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49702 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727867AbgG0Woz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:44:55 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RMg130003881
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:55 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32h4ed6t0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:55 -0700
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 15:44:53 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 069A93FAB6F7F; Mon, 27 Jul 2020 15:44:45 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH v2 19/21] mlx5e: add the netgpu driver functions
Date:   Mon, 27 Jul 2020 15:44:42 -0700
Message-ID: <20200727224444.2987641-20-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 clxscore=1034
 suspectscore=3 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007270153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

Add the netgpu queue setup/teardown functions, and the interface into
the main netgpu core code.  These will be hooked up to the mlx5 driver
in the next commit.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |   1 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   1 +
 .../mellanox/mlx5/core/en/netgpu/setup.c      | 340 ++++++++++++++++++
 .../mellanox/mlx5/core/en/netgpu/setup.h      |  96 +++++
 .../ethernet/mellanox/mlx5/core/en/params.h   |   8 +
 5 files changed, 446 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 99f1ec3b2575..ceedc443666b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -33,6 +33,7 @@ config MLX5_FPGA
 config MLX5_CORE_EN
 	bool "Mellanox 5th generation network adapters (ConnectX series) Ethernet support"
 	depends on NETDEVICES && ETHERNET && INET && PCI && MLX5_CORE
+	depends on NETGPU || !NETGPU
 	select PAGE_POOL
 	select DIMLIB
 	default n
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 10e6886c96ba..5a5966bb3cb5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -41,6 +41,7 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
 					en/tc_tun_vxlan.o en/tc_tun_gre.o en/tc_tun_geneve.o \
 					en/tc_tun_mplsoudp.o diag/en_tc_tracepoint.o
 mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
+mlx5_core-$(CONFIG_NETGPU)	     += en/netgpu/setup.o
 
 #
 # Core extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.c
new file mode 100644
index 000000000000..6ece4ad0aed6
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.c
@@ -0,0 +1,340 @@
+#include "en.h"
+#include "en/xdp.h"
+#include "en/params.h"
+#include "en/netgpu/setup.h"
+
+struct netgpu_ifq *
+mlx5e_netgpu_get_ifq(struct mlx5e_params *params, struct mlx5e_xsk *xsk,
+		     u16 ix)
+{
+	if (!xsk || !xsk->ifq_tbl)
+		return NULL;
+
+	if (unlikely(ix >= params->num_channels))
+		return NULL;
+
+	if (unlikely(xsk->is_umem))
+		return NULL;
+
+	return xsk->ifq_tbl[ix];
+}
+
+static int mlx5e_netgpu_get_tbl(struct mlx5e_xsk *xsk)
+{
+	if (!xsk->ifq_tbl) {
+		xsk->ifq_tbl = kcalloc(MLX5E_MAX_NUM_CHANNELS,
+				       sizeof(*xsk->ifq_tbl), GFP_KERNEL);
+		if (unlikely(!xsk->ifq_tbl))
+			return -ENOMEM;
+		xsk->is_umem = false;
+	}
+	if (xsk->is_umem)
+		return -EINVAL;
+
+	xsk->refcnt++;
+	xsk->ever_used = true;
+
+	return 0;
+}
+
+static void mlx5e_netgpu_put_tbl(struct mlx5e_xsk *xsk)
+{
+	if (!--xsk->refcnt) {
+		kfree(xsk->ifq_tbl);
+		xsk->ifq_tbl = NULL;
+	}
+}
+
+static void mlx5e_netgpu_remove_ifq(struct mlx5e_xsk *xsk, u16 ix)
+{
+	xsk->ifq_tbl[ix] = NULL;
+
+	mlx5e_netgpu_put_tbl(xsk);
+}
+
+static int mlx5e_netgpu_add_ifq(struct mlx5e_xsk *xsk, struct netgpu_ifq *ifq,
+				u16 ix)
+{
+	int err;
+
+	err = mlx5e_netgpu_get_tbl(xsk);
+	if (unlikely(err))
+		return err;
+
+	xsk->ifq_tbl[ix] = ifq;
+
+	return 0;
+}
+
+static u16
+mlx5e_netgpu_find_unused_ifq(struct mlx5e_priv *priv,
+			     struct mlx5e_params *params)
+{
+	u16 ix;
+
+	for (ix = 0; ix < params->num_channels; ix++) {
+		if (!mlx5e_netgpu_get_ifq(params, &priv->xsk, ix))
+			break;
+	}
+	return ix;
+}
+
+static int
+mlx5e_redirect_netgpu_rqt(struct mlx5e_priv *priv, u16 ix, u32 rqn)
+{
+	struct mlx5e_redirect_rqt_param direct_rrp = {
+		.is_rss = false,
+		{
+			.rqn = rqn,
+		},
+	};
+
+	u32 rqtn = priv->xsk_tir[ix].rqt.rqtn;
+
+	return mlx5e_redirect_rqt(priv, rqtn, 1, direct_rrp);
+}
+
+static int
+mlx5e_netgpu_redirect_rqt_to_channel(struct mlx5e_priv *priv,
+				     struct mlx5e_channel *c)
+{
+	return mlx5e_redirect_netgpu_rqt(priv, c->ix, c->xskrq.rqn);
+}
+
+static int
+mlx5e_netgpu_redirect_rqt_to_drop(struct mlx5e_priv *priv, u16 ix)
+{
+	return mlx5e_redirect_netgpu_rqt(priv, ix, priv->drop_rq.rqn);
+}
+
+int mlx5e_netgpu_redirect_rqts_to_channels(struct mlx5e_priv *priv,
+					   struct mlx5e_channels *chs)
+{
+	int err, i;
+
+	for (i = 0; i < chs->num; i++) {
+		struct mlx5e_channel *c = chs->c[i];
+
+		if (!test_bit(MLX5E_CHANNEL_STATE_NETGPU, c->state))
+			continue;
+
+		err = mlx5e_netgpu_redirect_rqt_to_channel(priv, c);
+		if (unlikely(err))
+			goto err_stop;
+	}
+
+	return 0;
+
+err_stop:
+	for (i--; i >= 0; i--) {
+		if (!test_bit(MLX5E_CHANNEL_STATE_NETGPU, chs->c[i]->state))
+			continue;
+
+		mlx5e_netgpu_redirect_rqt_to_drop(priv, i);
+	}
+
+	return err;
+}
+
+void mlx5e_netgpu_redirect_rqts_to_drop(struct mlx5e_priv *priv,
+					struct mlx5e_channels *chs)
+{
+	int i;
+
+	for (i = 0; i < chs->num; i++) {
+		if (!test_bit(MLX5E_CHANNEL_STATE_NETGPU, chs->c[i]->state))
+			continue;
+
+		mlx5e_netgpu_redirect_rqt_to_drop(priv, i);
+	}
+}
+
+static void mlx5e_activate_netgpu(struct mlx5e_channel *c)
+{
+	set_bit(MLX5E_RQ_STATE_ENABLED, &c->xskrq.state);
+
+	spin_lock(&c->async_icosq_lock);
+	mlx5e_trigger_irq(&c->async_icosq);
+	spin_unlock(&c->async_icosq_lock);
+}
+
+void mlx5e_deactivate_netgpu(struct mlx5e_channel *c)
+{
+	mlx5e_deactivate_rq(&c->xskrq);
+}
+
+static int mlx5e_netgpu_enable_locked(struct mlx5e_priv *priv,
+				      struct netgpu_ifq *ifq, u16 *qid)
+{
+	struct mlx5e_params *params = &priv->channels.params;
+	struct mlx5e_channel *c;
+	int err;
+	u16 ix;
+
+	if (*qid == (u16)-1) {
+		ix = mlx5e_netgpu_find_unused_ifq(priv, params);
+		if (ix >= params->num_channels)
+			return -EBUSY;
+
+		mlx5e_get_qid_for_ch_in_group(params, qid, ix,
+					      MLX5E_RQ_GROUP_XSK);
+	} else {
+		if (!mlx5e_qid_get_ch_if_in_group(params, *qid,
+						  MLX5E_RQ_GROUP_XSK, &ix))
+			return -EINVAL;
+
+		if (unlikely(mlx5e_netgpu_get_ifq(params, &priv->xsk, ix)))
+			return -EBUSY;
+	}
+
+	err = mlx5e_netgpu_add_ifq(&priv->xsk, ifq, ix);
+	if (unlikely(err))
+		return err;
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		/* XSK objects will be created on open. */
+		goto validate_closed;
+	}
+
+	c = priv->channels.c[ix];
+
+	err = mlx5e_open_netgpu(priv, params, ifq, c);
+	if (unlikely(err))
+		goto err_remove_ifq;
+
+	mlx5e_activate_netgpu(c);
+
+	/* Don't wait for WQEs, because the newer xdpsock sample doesn't provide
+	 * any Fill Ring entries at the setup stage.
+	 */
+
+	err = mlx5e_netgpu_redirect_rqt_to_channel(priv, priv->channels.c[ix]);
+	if (unlikely(err))
+		goto err_deactivate;
+
+	return 0;
+
+err_deactivate:
+	mlx5e_deactivate_netgpu(c);
+	mlx5e_close_netgpu(c);
+
+err_remove_ifq:
+	mlx5e_netgpu_remove_ifq(&priv->xsk, ix);
+
+	return err;
+
+validate_closed:
+	return 0;
+}
+
+static int mlx5e_netgpu_disable_locked(struct mlx5e_priv *priv, u16 *qid)
+{
+	struct mlx5e_params *params = &priv->channels.params;
+	struct mlx5e_channel *c;
+	struct netgpu_ifq *ifq;
+	u16 ix;
+
+	if (unlikely(!mlx5e_qid_get_ch_if_in_group(params, *qid,
+						   MLX5E_RQ_GROUP_XSK, &ix)))
+		return -EINVAL;
+
+	ifq = mlx5e_netgpu_get_ifq(params, &priv->xsk, ix);
+
+	if (unlikely(!ifq))
+		return -EINVAL;
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
+		goto remove_ifq;
+
+	c = priv->channels.c[ix];
+	mlx5e_netgpu_redirect_rqt_to_drop(priv, ix);
+	mlx5e_deactivate_netgpu(c);
+	mlx5e_close_netgpu(c);
+
+remove_ifq:
+	mlx5e_netgpu_remove_ifq(&priv->xsk, ix);
+
+	return 0;
+}
+
+static int mlx5e_netgpu_enable_ifq(struct mlx5e_priv *priv,
+				   struct netgpu_ifq *ifq, u16 *qid)
+{
+	int err;
+
+	mutex_lock(&priv->state_lock);
+	err = mlx5e_netgpu_enable_locked(priv, ifq, qid);
+	mutex_unlock(&priv->state_lock);
+
+	return err;
+}
+
+static int mlx5e_netgpu_disable_ifq(struct mlx5e_priv *priv, u16 *qid)
+{
+	int err;
+
+	mutex_lock(&priv->state_lock);
+	err = mlx5e_netgpu_disable_locked(priv, qid);
+	mutex_unlock(&priv->state_lock);
+
+	return err;
+}
+
+int
+mlx5e_netgpu_setup_ifq(struct net_device *dev, struct netgpu_ifq *ifq, u16 *qid)
+{
+	struct mlx5e_priv *priv = netdev_priv(dev);
+
+	return ifq ? mlx5e_netgpu_enable_ifq(priv, ifq, qid) :
+		     mlx5e_netgpu_disable_ifq(priv, qid);
+}
+
+int mlx5e_open_netgpu(struct mlx5e_priv *priv, struct mlx5e_params *params,
+		      struct netgpu_ifq *ifq, struct mlx5e_channel *c)
+{
+	struct mlx5e_channel_param *cparam;
+	struct mlx5e_xsk_param xsk = { .hd_split = true };
+	int err;
+
+	cparam = kvzalloc(sizeof(*cparam), GFP_KERNEL);
+	if (!cparam)
+		return -ENOMEM;
+
+	mlx5e_build_rq_param(priv, params, &xsk, &cparam->rq);
+
+	err = mlx5e_open_cq(c, params->rx_cq_moderation, &cparam->rq.cqp,
+			    &c->xskrq.cq);
+	if (unlikely(err))
+		goto err_free_cparam;
+
+	err = mlx5e_open_rq(c, params, &cparam->rq, &xsk, NULL, &c->xskrq);
+	if (unlikely(err))
+		goto err_close_rx_cq;
+	c->xskrq.netgpu = ifq;
+
+	kvfree(cparam);
+
+	set_bit(MLX5E_CHANNEL_STATE_NETGPU, c->state);
+
+	return 0;
+
+err_close_rx_cq:
+	mlx5e_close_cq(&c->xskrq.cq);
+
+err_free_cparam:
+	kvfree(cparam);
+
+	return err;
+}
+
+void mlx5e_close_netgpu(struct mlx5e_channel *c)
+{
+	clear_bit(MLX5E_CHANNEL_STATE_NETGPU, c->state);
+	napi_synchronize(&c->napi);
+	synchronize_rcu(); /* Sync with the XSK wakeup. */
+
+	mlx5e_close_rq(&c->xskrq);
+	mlx5e_close_cq(&c->xskrq.cq);
+
+	memset(&c->xskrq, 0, sizeof(c->xskrq));
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.h b/drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.h
new file mode 100644
index 000000000000..5a199fb1873b
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.h
@@ -0,0 +1,96 @@
+#ifndef _MLX5_EN_NETGPU_SETUP_H
+#define _MLX5_EN_NETGPU_SETUP_H
+
+#include <net/netgpu.h>
+
+#if IS_ENABLED(CONFIG_NETGPU)
+
+static inline dma_addr_t
+mlx5e_netgpu_get_dma(struct sk_buff *skb, skb_frag_t *frag)
+{
+	struct netgpu_skq *skq = skb_shinfo(skb)->destructor_arg;
+
+	return netgpu_get_dma(skq->ctx, skb_frag_page(frag));
+}
+
+static inline int
+mlx5e_netgpu_get_page(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info)
+{
+	struct netgpu_ifq *ifq = rq->netgpu;
+
+	return netgpu_get_page(ifq, &dma_info->page, &dma_info->addr);
+}
+
+static inline void
+mlx5e_netgpu_put_page(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info,
+		      bool recycle)
+{
+	struct netgpu_ifq *ifq = rq->netgpu;
+	struct page *page = dma_info->page;
+
+	if (page) {
+		put_page(page);
+		netgpu_put_page(ifq, page, recycle);
+	}
+}
+
+static inline bool
+mlx5e_netgpu_avail(struct mlx5e_rq *rq, u8 count)
+{
+	struct netgpu_ifq *ifq = rq->netgpu;
+
+	/* XXX
+	 * napi_cache_count is not a total count, and this also
+	 * doesn't consider any_cache_count.
+	 */
+	return ifq->napi_cache_count >= count ||
+		sq_cons_avail(&ifq->fill, count - ifq->napi_cache_count);
+}
+
+static inline void
+mlx5e_netgpu_taken(struct mlx5e_rq *rq)
+{
+	struct netgpu_ifq *ifq = rq->netgpu;
+
+	sq_cons_complete(&ifq->fill);
+}
+
+struct netgpu_ifq *
+mlx5e_netgpu_get_ifq(struct mlx5e_params *params, struct mlx5e_xsk *xsk,
+                     u16 ix);
+
+int
+mlx5e_netgpu_setup_ifq(struct net_device *dev, struct netgpu_ifq *ifq,
+		       u16 *qid);
+
+int mlx5e_open_netgpu(struct mlx5e_priv *priv, struct mlx5e_params *params,
+		      struct netgpu_ifq *ifq, struct mlx5e_channel *c);
+
+void mlx5e_close_netgpu(struct mlx5e_channel *c);
+
+void mlx5e_deactivate_netgpu(struct mlx5e_channel *c);
+
+int mlx5e_netgpu_redirect_rqts_to_channels(struct mlx5e_priv *priv,
+					    struct mlx5e_channels *chs);
+
+void mlx5e_netgpu_redirect_rqts_to_drop(struct mlx5e_priv *priv,
+					struct mlx5e_channels *chs);
+
+#else
+
+#define mlx5e_netgpu_get_dma(skb, frag)				0
+#define mlx5e_netgpu_get_page(rq, dma_info)			0
+#define mlx5e_netgpu_put_page(rq, dma_info, recycle)
+#define mlx5e_netgpu_avail(rq, u8)				false
+#define mlx5e_netgpu_taken(rq)
+#define mlx5e_netgpu_get_ifq(params, xsk, ix)			NULL
+#define mlx5e_netgpu_setup_ifq(dev, ifq, qid)			-EINVAL
+#define mlx5e_open_netgpu(priv, params, ifq, c)			-EINVAL
+#define mlx5e_close_netgpu(c)
+#define mlx5e_deactivate_netgpu(c)
+#define mlx5e_netgpu_redirect_rqts_to_channels(priv, chs)	/* ignored */
+#define mlx5e_netgpu_redirect_rqts_to_drop(priv, chs)
+
+#endif /* IS_ENABLED(CONFIG_NETGPU) */
+
+#endif /* _MLX5_EN_NETGPU_SETUP_H */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index eb2d05a7c5b9..9700a984f5c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -67,6 +67,14 @@ static inline void mlx5e_qid_get_ch_and_group(struct mlx5e_params *params,
 	*group = qid / nch;
 }
 
+static inline void mlx5e_get_qid_for_ch_in_group(struct mlx5e_params *params,
+						 u16 *qid,
+						 u16 ix,
+						 enum mlx5e_rq_group group)
+{
+	*qid = params->num_channels * group + ix;
+}
+
 static inline bool mlx5e_qid_validate(const struct mlx5e_profile *profile,
 				      struct mlx5e_params *params, u64 qid)
 {
-- 
2.24.1

