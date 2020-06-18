Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E42A1FF8CB
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731944AbgFRQKC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:10:02 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27630 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731884AbgFRQJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:09:56 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05IG7blx013417
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:52 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 31q644vseg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:52 -0700
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 09:09:51 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 4F0C53D44E142; Thu, 18 Jun 2020 09:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <axboe@kernel.dk>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 10/21] mlx5: add netgpu queue functions
Date:   Thu, 18 Jun 2020 09:09:30 -0700
Message-ID: <20200618160941.879717-11-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200618160941.879717-1-jonathan.lemon@gmail.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_14:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 cotscore=-2147483648 suspectscore=3 adultscore=0
 spamscore=0 clxscore=1034 priorityscore=1501 mlxscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the netgpu setup/teardown functions, which are not hooked up yet.
The driver also handles netgpu module loading and unloading.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   3 +-
 .../mellanox/mlx5/core/en/netgpu/setup.c      | 475 ++++++++++++++++++
 .../mellanox/mlx5/core/en/netgpu/setup.h      |  42 ++
 3 files changed, 519 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index b61e47bc16e8..27983bd074e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -25,7 +25,8 @@ mlx5_core-$(CONFIG_MLX5_CORE_EN) += en_main.o en_common.o en_fs.o en_ethtool.o \
 		en_tx.o en_rx.o en_dim.o en_txrx.o en/xdp.o en_stats.o \
 		en_selftest.o en/port.o en/monitor_stats.o en/health.o \
 		en/reporter_tx.o en/reporter_rx.o en/params.o en/xsk/umem.o \
-		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o
+		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o \
+		en/netgpu/setup.o
 
 #
 # Netdev extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.c
new file mode 100644
index 000000000000..f0578c41951d
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.c
@@ -0,0 +1,475 @@
+#include <linux/prefetch.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/tcp.h>
+#include <linux/indirect_call_wrapper.h>
+#include <net/ip6_checksum.h>
+#include <net/page_pool.h>
+#include <net/inet_ecn.h>
+#include "en.h"
+#include "en_tc.h"
+#include "lib/clock.h"
+#include "en/xdp.h"
+#include "en/params.h"
+#include "en/netgpu/setup.h"
+
+#include <net/netgpu.h>
+#include <uapi/misc/shqueue.h>
+
+int (*fn_netgpu_get_page)(struct netgpu_ctx *ctx,
+				 struct page **page, dma_addr_t *dma);
+void (*fn_netgpu_put_page)(struct netgpu_ctx *, struct page *, bool);
+int (*fn_netgpu_get_pages)(struct sock *, struct page **,
+			   unsigned long, int);
+struct netgpu_ctx *g_ctx;
+
+static void
+netgpu_fn_unload(void)
+{
+	if (fn_netgpu_get_page)
+		symbol_put(netgpu_get_page);
+	if (fn_netgpu_put_page)
+		symbol_put(netgpu_put_page);
+	if (fn_netgpu_get_pages)
+		symbol_put(netgpu_get_pages);
+
+	fn_netgpu_get_page = NULL;
+	fn_netgpu_put_page = NULL;
+	fn_netgpu_get_pages = NULL;
+}
+
+static int
+netgpu_fn_load(void)
+{
+	fn_netgpu_get_page = symbol_get(netgpu_get_page);
+	fn_netgpu_put_page = symbol_get(netgpu_put_page);
+	fn_netgpu_get_pages = symbol_get(netgpu_get_pages);
+
+	if (fn_netgpu_get_page &&
+	    fn_netgpu_put_page &&
+	    fn_netgpu_get_pages)
+		return 0;
+
+	netgpu_fn_unload();
+
+	return -EFAULT;
+}
+
+void
+mlx5e_netgpu_put_page(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info,
+		      bool recycle)
+{
+	struct netgpu_ctx *ctx = rq->netgpu;
+	struct page *page = dma_info->page;
+
+	if (page) {
+		put_page(page);
+		__netgpu_put_page(ctx, page, recycle);
+	}
+}
+
+bool
+mlx5e_netgpu_avail(struct mlx5e_rq *rq, u8 count)
+{
+	struct netgpu_ctx *ctx = rq->netgpu;
+
+	/* XXX
+	 * napi_cache_count is not a total count, and this also
+	 * doesn't consider any_cache_count.
+	 */
+	return ctx->napi_cache_count >= count ||
+		sq_cons_ready(&ctx->fill) >= (count - ctx->napi_cache_count);
+}
+
+void mlx5e_netgpu_taken(struct mlx5e_rq *rq)
+{
+	struct netgpu_ctx *ctx = rq->netgpu;
+
+	sq_cons_complete(&ctx->fill);
+}
+
+int
+mlx5e_netgpu_get_page(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info)
+{
+	struct netgpu_ctx *ctx = rq->netgpu;
+
+	return __netgpu_get_page(ctx, &dma_info->page, &dma_info->addr);
+}
+
+struct netgpu_ctx *
+mlx5e_netgpu_get_ctx(struct mlx5e_params *params, struct mlx5e_xsk *xsk,
+		     u16 ix)
+{
+	if (!xsk || !xsk->ctx_tbl)
+		return NULL;
+
+	if (unlikely(ix >= params->num_channels))
+		return NULL;
+
+	if (unlikely(!xsk->is_netgpu))
+		return NULL;
+
+	return xsk->ctx_tbl[ix];
+}
+
+static int mlx5e_netgpu_get_tbl(struct mlx5e_xsk *xsk)
+{
+	if (!xsk->ctx_tbl) {
+		xsk->ctx_tbl = kcalloc(MLX5E_MAX_NUM_CHANNELS,
+				       sizeof(*xsk->ctx_tbl), GFP_KERNEL);
+		if (unlikely(!xsk->ctx_tbl))
+			return -ENOMEM;
+		xsk->is_netgpu = true;
+	}
+	if (!xsk->is_netgpu)
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
+		kfree(xsk->ctx_tbl);
+		xsk->ctx_tbl = NULL;
+	}
+}
+
+static void mlx5e_netgpu_remove_ctx(struct mlx5e_xsk *xsk, u16 ix)
+{
+	xsk->ctx_tbl[ix] = NULL;
+
+	mlx5e_netgpu_put_tbl(xsk);
+}
+
+static int mlx5e_netgpu_add_ctx(struct mlx5e_xsk *xsk, struct netgpu_ctx *ctx,
+				u16 ix)
+{
+	int err;
+
+	err = mlx5e_netgpu_get_tbl(xsk);
+	if (unlikely(err))
+		return err;
+
+	xsk->ctx_tbl[ix] = ctx;
+
+	return 0;
+}
+
+static int mlx5e_netgpu_enable_locked(struct mlx5e_priv *priv,
+				      struct netgpu_ctx *ctx, u16 ix)
+{
+	struct mlx5e_params *params = &priv->channels.params;
+	struct mlx5e_channel *c;
+	int err;
+
+	if (unlikely(mlx5e_netgpu_get_ctx(&priv->channels.params,
+					  &priv->xsk, ix)))
+		return -EBUSY;
+
+	err = mlx5e_netgpu_add_ctx(&priv->xsk, ctx, ix);
+	if (unlikely(err))
+		return err;
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		/* XSK objects will be created on open. */
+		goto validate_closed;
+	}
+
+	if (!params->hd_split) {
+		/* XSK objects will be created when header split is set,
+		 * and the channels are reopened.
+		 */
+		goto validate_closed;
+	}
+
+	c = priv->channels.c[ix];
+
+	err = mlx5e_open_netgpu(priv, params, ctx, c);
+	if (unlikely(err))
+		goto err_remove_ctx;
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
+err_remove_ctx:
+	mlx5e_netgpu_remove_ctx(&priv->xsk, ix);
+
+	return err;
+
+validate_closed:
+	return 0;
+}
+
+static int mlx5e_netgpu_disable_locked(struct mlx5e_priv *priv, u16 ix)
+{
+	struct mlx5e_channel *c;
+	struct netgpu_ctx *ctx;
+
+	ctx = mlx5e_netgpu_get_ctx(&priv->channels.params, &priv->xsk, ix);
+
+	if (unlikely(!ctx))
+		return -EINVAL;
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
+		goto remove_ctx;
+
+	/* NETGPU RQ is only created if header split is set. */
+	if (!priv->channels.params.hd_split)
+		goto remove_ctx;
+
+	c = priv->channels.c[ix];
+	mlx5e_netgpu_redirect_rqt_to_drop(priv, ix);
+	mlx5e_deactivate_netgpu(c);
+	mlx5e_close_netgpu(c);
+
+remove_ctx:
+	mlx5e_netgpu_remove_ctx(&priv->xsk, ix);
+
+	return 0;
+}
+
+static int mlx5e_netgpu_enable_ctx(struct mlx5e_priv *priv,
+				   struct netgpu_ctx *ctx, u16 ix)
+{
+	int err;
+
+	mutex_lock(&priv->state_lock);
+	err = netgpu_fn_load();
+	if (!err)
+		err = mlx5e_netgpu_enable_locked(priv, ctx, ix);
+	g_ctx = ctx;
+	mutex_unlock(&priv->state_lock);
+
+	return err;
+}
+
+static int mlx5e_netgpu_disable_ctx(struct mlx5e_priv *priv, u16 ix)
+{
+	int err;
+
+	mutex_lock(&priv->state_lock);
+	err = mlx5e_netgpu_disable_locked(priv, ix);
+	netgpu_fn_unload();
+	g_ctx = NULL;
+	mutex_unlock(&priv->state_lock);
+
+	return err;
+}
+
+int
+mlx5e_netgpu_setup_ctx(struct net_device *dev, struct netgpu_ctx *ctx, u16 qid)
+{
+	struct mlx5e_priv *priv = netdev_priv(dev);
+	struct mlx5e_params *params = &priv->channels.params;
+	u16 ix;
+
+	if (unlikely(!mlx5e_qid_get_ch_if_in_group(params, qid,
+						   MLX5E_RQ_GROUP_XSK, &ix)))
+		return -EINVAL;
+
+	return ctx ? mlx5e_netgpu_enable_ctx(priv, ctx, ix) :
+		     mlx5e_netgpu_disable_ctx(priv, ix);
+}
+
+static void mlx5e_build_netgpuicosq_param(struct mlx5e_priv *priv,
+					  u8 log_wq_size,
+					  struct mlx5e_sq_param *param)
+{
+	void *sqc = param->sqc;
+	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
+
+	mlx5e_build_sq_param_common(priv, param);
+
+	MLX5_SET(wq, wq, log_wq_sz, log_wq_size);
+}
+
+static void mlx5e_build_netgpu_cparam(struct mlx5e_priv *priv,
+				      struct mlx5e_params *params,
+				      struct mlx5e_channel_param *cparam)
+{
+	const u8 icosq_size = MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
+	struct mlx5e_xsk_param *xsk = (void *)0x1;
+
+	mlx5e_build_rq_param(priv, params, xsk, &cparam->rq);
+	mlx5e_build_rx_cq_param(priv, params, NULL, &cparam->rx_cq);
+
+	mlx5e_build_netgpuicosq_param(priv, icosq_size, &cparam->icosq);
+	mlx5e_build_ico_cq_param(priv, icosq_size, &cparam->icosq_cq);
+}
+
+int mlx5e_open_netgpu(struct mlx5e_priv *priv, struct mlx5e_params *params,
+		      struct netgpu_ctx *ctx, struct mlx5e_channel *c)
+{
+	struct mlx5e_channel_param *cparam;
+	struct dim_cq_moder icocq_moder = {};
+	struct xdp_umem *umem = (void *)0x1;
+	int err;
+
+	cparam = kvzalloc(sizeof(*cparam), GFP_KERNEL);
+	if (!cparam)
+		return -ENOMEM;
+
+	mlx5e_build_netgpu_cparam(priv, params, cparam);
+
+	err = mlx5e_open_cq(c, params->rx_cq_moderation, &cparam->rx_cq,
+			   &c->xskrq.cq);
+	if (unlikely(err))
+		goto err_free_cparam;
+
+	err = mlx5e_open_rq(c, params, &cparam->rq, NULL, umem, &c->xskrq);
+	if (unlikely(err))
+		goto err_close_rx_cq;
+	c->xskrq.netgpu = ctx;
+
+	err = mlx5e_open_cq(c, icocq_moder, &cparam->icosq_cq, &c->xskicosq.cq);
+	if (unlikely(err))
+		goto err_close_rq;
+
+	/* Create a dedicated SQ for posting NOPs whenever we need an IRQ to be
+	 * triggered and NAPI to be called on the correct CPU.
+	 */
+	err = mlx5e_open_icosq(c, params, &cparam->icosq, &c->xskicosq);
+	if (unlikely(err))
+		goto err_close_icocq;
+
+	kvfree(cparam);
+
+	spin_lock_init(&c->xskicosq_lock);
+
+	set_bit(MLX5E_CHANNEL_STATE_NETGPU, c->state);
+
+	return 0;
+
+err_close_icocq:
+	mlx5e_close_cq(&c->xskicosq.cq);
+
+err_close_rq:
+	mlx5e_close_rq(&c->xskrq);
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
+	mlx5e_close_icosq(&c->xskicosq);
+	mlx5e_close_cq(&c->xskicosq.cq);
+
+	/* zero these out - so the next open has a clean slate. */
+	memset(&c->xskrq, 0, sizeof(c->xskrq));
+	memset(&c->xsksq, 0, sizeof(c->xsksq));
+	memset(&c->xskicosq, 0, sizeof(c->xskicosq));
+}
+
+void mlx5e_activate_netgpu(struct mlx5e_channel *c)
+{
+	mlx5e_activate_icosq(&c->xskicosq);
+	set_bit(MLX5E_RQ_STATE_ENABLED, &c->xskrq.state);
+	/* TX queue is created active. */
+
+	spin_lock(&c->xskicosq_lock);
+	mlx5e_trigger_irq(&c->xskicosq);
+	spin_unlock(&c->xskicosq_lock);
+}
+
+void mlx5e_deactivate_netgpu(struct mlx5e_channel *c)
+{
+	mlx5e_deactivate_rq(&c->xskrq);
+	/* TX queue is disabled on close. */
+	mlx5e_deactivate_icosq(&c->xskicosq);
+}
+
+static int mlx5e_redirect_netgpu_rqt(struct mlx5e_priv *priv, u16 ix, u32 rqn)
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
+int mlx5e_netgpu_redirect_rqt_to_channel(struct mlx5e_priv *priv,
+					 struct mlx5e_channel *c)
+{
+	return mlx5e_redirect_netgpu_rqt(priv, c->ix, c->xskrq.rqn);
+}
+
+int mlx5e_netgpu_redirect_rqt_to_drop(struct mlx5e_priv *priv, u16 ix)
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
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.h b/drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.h
new file mode 100644
index 000000000000..37fde92ef89d
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/netgpu/setup.h
@@ -0,0 +1,42 @@
+#pragma once
+
+struct netgpu_ctx *
+mlx5e_netgpu_get_ctx(struct mlx5e_params *params, struct mlx5e_xsk *xsk,
+                     u16 ix);
+
+int
+mlx5e_open_netgpu(struct mlx5e_priv *priv, struct mlx5e_params *params,
+                  struct netgpu_ctx *ctx, struct mlx5e_channel *c);
+
+bool mlx5e_netgpu_avail(struct mlx5e_rq *rq, u8 count);
+void mlx5e_netgpu_taken(struct mlx5e_rq *rq);
+
+int
+mlx5e_netgpu_setup_ctx(struct net_device *dev, struct netgpu_ctx *ctx, u16 qid);
+
+int
+mlx5e_netgpu_get_page(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info);
+
+void
+mlx5e_netgpu_put_page(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info,
+		      bool recycle);
+
+int mlx5e_open_netgpu(struct mlx5e_priv *priv, struct mlx5e_params *params,
+		      struct netgpu_ctx *ctx, struct mlx5e_channel *c);
+
+void mlx5e_close_netgpu(struct mlx5e_channel *c);
+
+void mlx5e_activate_netgpu(struct mlx5e_channel *c);
+
+void mlx5e_deactivate_netgpu(struct mlx5e_channel *c);
+
+int mlx5e_netgpu_redirect_rqt_to_channel(struct mlx5e_priv *priv,
+					 struct mlx5e_channel *c);
+
+int mlx5e_netgpu_redirect_rqt_to_drop(struct mlx5e_priv *priv, u16 ix);
+
+int mlx5e_netgpu_redirect_rqts_to_channels(struct mlx5e_priv *priv,
+					   struct mlx5e_channels *chs);
+
+void mlx5e_netgpu_redirect_rqts_to_drop(struct mlx5e_priv *priv,
+					struct mlx5e_channels *chs);
-- 
2.24.1

