Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5ACE56C73
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbfFZOod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:44:33 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60906 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726628AbfFZOod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:44:33 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Jun 2019 17:36:17 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5QEaGYE027430;
        Wed, 26 Jun 2019 17:36:17 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bjorn.topel@intel.com,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <bsd@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH bpf-next V6 16/16] net/mlx5e: Add XSK zero-copy support
Date:   Wed, 26 Jun 2019 17:35:38 +0300
Message-Id: <1561559738-4213-17-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
References: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

This commit adds support for AF_XDP zero-copy RX and TX.

We create a dedicated XSK RQ inside the channel, it means that two
RQs are running simultaneously: one for non-XSK traffic and the other
for XSK traffic. The regular and XSK RQs use a single ID namespace split
into two halves: the lower half is regular RQs, and the upper half is
XSK RQs. When any zero-copy AF_XDP socket is active, changing the number
of channels is not allowed, because it would break to mapping between
XSK RQ IDs and channels.

XSK requires different page allocation and release routines. Such
functions as mlx5e_{alloc,free}_rx_mpwqe and mlx5e_{get,put}_rx_frag are
generic enough to be used for both regular and XSK RQs, and they use the
mlx5e_page_{alloc,release} wrappers around the real allocation
functions. Function pointers are not used to avoid losing the
performance with retpolines. Wherever it's certain that the regular
(non-XSK) page release function should be used, it's called directly.

Only the stats that could be meaningful for XSK are exposed to the
userspace. Those that don't take part in the XSK flow are not
considered.

Note that we don't wait for WQEs on the XSK RQ (unlike the regular RQ),
because the newer xdpsock sample doesn't provide any Fill Ring entries
at the setup stage.

We create a dedicated XSK SQ in the channel. This separation has its
advantages:

1. When the UMEM is closed, the XSK SQ can also be closed and stop
receiving completions. If an existing SQ was used for XSK, it would
continue receiving completions for the packets of the closed socket. If
a new UMEM was opened at that point, it would start getting completions
that don't belong to it.

2. Calculating statistics separately.

When the userspace kicks the TX, the driver triggers a hardware
interrupt by posting a NOP to a dedicated XSK ICO (internal control
operations) SQ, in order to trigger NAPI on the right CPU core. This XSK
ICO SQ is protected by a spinlock, as the userspace application may kick
the TX from any core.

Store the pointers to the UMEMs in the net device private context,
independently from the kernel. This way the driver can distinguish
between the zero-copy and non-zero-copy UMEMs. The kernel function
xdp_get_umem_from_qid does not care about this difference, but the
driver is only interested in zero-copy UMEMs, particularly, on the
cleanup it determines whether to close the XSK RQ and SQ or not by
looking at the presence of the UMEM. Use state_lock to protect the
access to this area of UMEM pointers.

LRO isn't compatible with XDP, but there may be active UMEMs while
XDP is off. If this is the case, don't allow LRO to ensure XDP can
be reenabled at any time.

The validation of XSK parameters typically happens when XSK queues
open. However, when the interface is down or the XDP program isn't
set, it's still possible to have active AF_XDP sockets and even to
open new, but the XSK queues will be closed. To cover these cases,
perform the validation also in these flows:

1. A new UMEM is registered, but the XSK queues aren't going to be
created due to missing XDP program or interface being down.

2. MTU changes while there are UMEMs registered.

Having this early check prevents mlx5e_open_channels from failing
at a later stage, where recovery is impossible and the application
has no chance to handle the error, because it got the successful
return value for an MTU change or XSK open operation.

The performance testing was performed on a machine with the following
configuration:

- 24 cores of Intel Xeon E5-2620 v3 @ 2.40 GHz
- Mellanox ConnectX-5 Ex with 100 Gbit/s link

The results with retpoline disabled, single stream:

txonly: 33.3 Mpps (21.5 Mpps with queue and app pinned to the same CPU)
rxdrop: 12.2 Mpps
l2fwd: 9.4 Mpps

The results with retpoline enabled, single stream:

txonly: 21.3 Mpps (14.1 Mpps with queue and app pinned to the same CPU)
rxdrop: 9.9 Mpps
l2fwd: 6.8 Mpps

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  98 +++-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  53 ++-
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |  77 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   | 103 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |  18 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/Makefile    |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    | 192 ++++++++
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    |  27 ++
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 223 +++++++++
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.h |  25 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    | 111 +++++
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.h    |  15 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.c  | 267 +++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.h  |  31 ++
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  25 +-
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 527 +++++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  77 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 115 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  30 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |  34 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  14 +-
 24 files changed, 1840 insertions(+), 255 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/Makefile
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 5fe2bf916c06..90db891fcc22 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -24,7 +24,7 @@ mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
 mlx5_core-$(CONFIG_MLX5_CORE_EN) += en_main.o en_common.o en_fs.o en_ethtool.o \
 		en_tx.o en_rx.o en_dim.o en_txrx.o en/xdp.o en_stats.o \
 		en_selftest.o en/port.o en/monitor_stats.o en/reporter_tx.o \
-		en/params.o
+		en/params.o en/xsk/umem.o en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o
 
 #
 # Netdev extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 010140753e73..cb00e622c006 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -137,6 +137,7 @@
 #define MLX5E_MAX_NUM_CHANNELS         (MLX5E_INDIR_RQT_SIZE >> 1)
 #define MLX5E_MAX_NUM_SQS              (MLX5E_MAX_NUM_CHANNELS * MLX5E_MAX_NUM_TC)
 #define MLX5E_TX_CQ_POLL_BUDGET        128
+#define MLX5E_TX_XSK_POLL_BUDGET       64
 #define MLX5E_SQ_RECOVER_MIN_INTERVAL  500 /* msecs */
 
 #define MLX5E_UMR_WQE_INLINE_SZ \
@@ -155,6 +156,11 @@
 			    ##__VA_ARGS__);                     \
 } while (0)
 
+enum mlx5e_rq_group {
+	MLX5E_RQ_GROUP_REGULAR,
+	MLX5E_RQ_GROUP_XSK,
+	MLX5E_NUM_RQ_GROUPS /* Keep last. */
+};
 
 static inline u16 mlx5_min_rx_wqes(int wq_type, u32 wq_size)
 {
@@ -179,7 +185,8 @@ static inline int mlx5e_get_max_num_channels(struct mlx5_core_dev *mdev)
 /* Use this function to get max num channels after netdev was created */
 static inline int mlx5e_get_netdev_max_channels(struct net_device *netdev)
 {
-	return min_t(unsigned int, netdev->num_rx_queues,
+	return min_t(unsigned int,
+		     netdev->num_rx_queues / MLX5E_NUM_RQ_GROUPS,
 		     netdev->num_tx_queues);
 }
 
@@ -250,6 +257,7 @@ struct mlx5e_params {
 	u32 lro_timeout;
 	u32 pflags;
 	struct bpf_prog *xdp_prog;
+	struct mlx5e_xsk *xsk;
 	unsigned int sw_mtu;
 	int hard_mtu;
 };
@@ -399,8 +407,14 @@ struct mlx5e_txqsq {
 } ____cacheline_aligned_in_smp;
 
 struct mlx5e_dma_info {
-	struct page     *page;
-	dma_addr_t      addr;
+	dma_addr_t addr;
+	union {
+		struct page *page;
+		struct {
+			u64 handle;
+			void *data;
+		} xsk;
+	};
 };
 
 /* XDP packets can be transmitted in different ways. On completion, we need to
@@ -467,9 +481,11 @@ struct mlx5e_xdp_mpwqe {
 };
 
 struct mlx5e_xdpsq;
+typedef int (*mlx5e_fp_xmit_xdp_frame_check)(struct mlx5e_xdpsq *);
 typedef bool (*mlx5e_fp_xmit_xdp_frame)(struct mlx5e_xdpsq *,
 					struct mlx5e_xdp_xmit_data *,
-					struct mlx5e_xdp_info *);
+					struct mlx5e_xdp_info *,
+					int);
 
 struct mlx5e_xdpsq {
 	/* data path */
@@ -487,8 +503,10 @@ struct mlx5e_xdpsq {
 	struct mlx5e_cq            cq;
 
 	/* read only */
+	struct xdp_umem           *umem;
 	struct mlx5_wq_cyc         wq;
 	struct mlx5e_xdpsq_stats  *stats;
+	mlx5e_fp_xmit_xdp_frame_check xmit_xdp_frame_check;
 	mlx5e_fp_xmit_xdp_frame    xmit_xdp_frame;
 	struct {
 		struct mlx5e_xdp_wqe_info *wqe_info;
@@ -619,6 +637,7 @@ struct mlx5e_rq {
 		} mpwqe;
 	};
 	struct {
+		u16            umem_headroom;
 		u16            headroom;
 		u8             map_dir;   /* dma map direction */
 	} buff;
@@ -649,6 +668,10 @@ struct mlx5e_rq {
 	DECLARE_BITMAP(flags, 8);
 	struct page_pool      *page_pool;
 
+	/* AF_XDP zero-copy */
+	struct zero_copy_allocator zca;
+	struct xdp_umem       *umem;
+
 	/* control */
 	struct mlx5_wq_ctrl    wq_ctrl;
 	__be32                 mkey_be;
@@ -661,6 +684,11 @@ struct mlx5e_rq {
 	struct xdp_rxq_info    xdp_rxq;
 } ____cacheline_aligned_in_smp;
 
+enum mlx5e_channel_state {
+	MLX5E_CHANNEL_STATE_XSK,
+	MLX5E_CHANNEL_NUM_STATES
+};
+
 struct mlx5e_channel {
 	/* data path */
 	struct mlx5e_rq            rq;
@@ -677,6 +705,13 @@ struct mlx5e_channel {
 	/* XDP_REDIRECT */
 	struct mlx5e_xdpsq         xdpsq;
 
+	/* AF_XDP zero-copy */
+	struct mlx5e_rq            xskrq;
+	struct mlx5e_xdpsq         xsksq;
+	struct mlx5e_icosq         xskicosq;
+	/* xskicosq can be accessed from any CPU - the spinlock protects it. */
+	spinlock_t                 xskicosq_lock;
+
 	/* data path - accessed per napi poll */
 	struct irq_desc *irq_desc;
 	struct mlx5e_ch_stats     *stats;
@@ -685,6 +720,7 @@ struct mlx5e_channel {
 	struct mlx5e_priv         *priv;
 	struct mlx5_core_dev      *mdev;
 	struct hwtstamp_config    *tstamp;
+	DECLARE_BITMAP(state, MLX5E_CHANNEL_NUM_STATES);
 	int                        ix;
 	int                        cpu;
 	cpumask_var_t              xps_cpumask;
@@ -700,14 +736,17 @@ struct mlx5e_channel_stats {
 	struct mlx5e_ch_stats ch;
 	struct mlx5e_sq_stats sq[MLX5E_MAX_NUM_TC];
 	struct mlx5e_rq_stats rq;
+	struct mlx5e_rq_stats xskrq;
 	struct mlx5e_xdpsq_stats rq_xdpsq;
 	struct mlx5e_xdpsq_stats xdpsq;
+	struct mlx5e_xdpsq_stats xsksq;
 } ____cacheline_aligned_in_smp;
 
 enum {
 	MLX5E_STATE_OPENED,
 	MLX5E_STATE_DESTROYING,
 	MLX5E_STATE_XDP_TX_ENABLED,
+	MLX5E_STATE_XDP_OPEN,
 };
 
 struct mlx5e_rqt {
@@ -740,6 +779,17 @@ struct mlx5e_modify_sq_param {
 	int rl_index;
 };
 
+struct mlx5e_xsk {
+	/* UMEMs are stored separately from channels, because we don't want to
+	 * lose them when channels are recreated. The kernel also stores UMEMs,
+	 * but it doesn't distinguish between zero-copy and non-zero-copy UMEMs,
+	 * so rely on our mechanism.
+	 */
+	struct xdp_umem **umems;
+	u16 refcnt;
+	bool ever_used;
+};
+
 struct mlx5e_priv {
 	/* priv data path fields - start */
 	struct mlx5e_txqsq *txq2sq[MLX5E_MAX_NUM_CHANNELS * MLX5E_MAX_NUM_TC];
@@ -760,6 +810,7 @@ struct mlx5e_priv {
 	struct mlx5e_tir           indir_tir[MLX5E_NUM_INDIR_TIRS];
 	struct mlx5e_tir           inner_indir_tir[MLX5E_NUM_INDIR_TIRS];
 	struct mlx5e_tir           direct_tir[MLX5E_MAX_NUM_CHANNELS];
+	struct mlx5e_tir           xsk_tir[MLX5E_MAX_NUM_CHANNELS];
 	struct mlx5e_rss_params    rss_params;
 	u32                        tx_rates[MLX5E_MAX_NUM_SQS];
 
@@ -796,6 +847,7 @@ struct mlx5e_priv {
 	struct mlx5e_tls          *tls;
 #endif
 	struct devlink_health_reporter *tx_reporter;
+	struct mlx5e_xsk           xsk;
 };
 
 struct mlx5e_profile {
@@ -839,8 +891,9 @@ bool mlx5e_striding_rq_possible(struct mlx5_core_dev *mdev,
 				struct mlx5e_params *params);
 
 void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info);
-void mlx5e_page_release(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info,
-			bool recycle);
+void mlx5e_page_release_dynamic(struct mlx5e_rq *rq,
+				struct mlx5e_dma_info *dma_info,
+				bool recycle);
 void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq);
@@ -900,6 +953,30 @@ void mlx5e_build_indir_tir_ctx_hash(struct mlx5e_rss_params *rss_params,
 void mlx5e_modify_tirs_hash(struct mlx5e_priv *priv, void *in, int inlen);
 struct mlx5e_tirc_config mlx5e_tirc_get_default_config(enum mlx5e_traffic_types tt);
 
+struct mlx5e_xsk_param;
+
+struct mlx5e_rq_param;
+int mlx5e_open_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
+		  struct mlx5e_rq_param *param, struct mlx5e_xsk_param *xsk,
+		  struct xdp_umem *umem, struct mlx5e_rq *rq);
+int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int wait_time);
+void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
+void mlx5e_close_rq(struct mlx5e_rq *rq);
+
+struct mlx5e_sq_param;
+int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
+		     struct mlx5e_sq_param *param, struct mlx5e_icosq *sq);
+void mlx5e_close_icosq(struct mlx5e_icosq *sq);
+int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
+		     struct mlx5e_sq_param *param, struct xdp_umem *umem,
+		     struct mlx5e_xdpsq *sq, bool is_redirect);
+void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq);
+
+struct mlx5e_cq_param;
+int mlx5e_open_cq(struct mlx5e_channel *c, struct net_dim_cq_moder moder,
+		  struct mlx5e_cq_param *param, struct mlx5e_cq *cq);
+void mlx5e_close_cq(struct mlx5e_cq *cq);
+
 int mlx5e_open_locked(struct net_device *netdev);
 int mlx5e_close_locked(struct net_device *netdev);
 
@@ -1070,10 +1147,10 @@ int mlx5e_open_drop_rq(struct mlx5e_priv *priv,
 int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc);
 void mlx5e_destroy_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc);
 
-int mlx5e_create_direct_rqts(struct mlx5e_priv *priv);
-void mlx5e_destroy_direct_rqts(struct mlx5e_priv *priv);
-int mlx5e_create_direct_tirs(struct mlx5e_priv *priv);
-void mlx5e_destroy_direct_tirs(struct mlx5e_priv *priv);
+int mlx5e_create_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs);
+void mlx5e_destroy_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs);
+int mlx5e_create_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs);
+void mlx5e_destroy_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs);
 void mlx5e_destroy_rqt(struct mlx5e_priv *priv, struct mlx5e_rqt *rqt);
 
 int mlx5e_create_tis(struct mlx5_core_dev *mdev, int tc,
@@ -1142,6 +1219,7 @@ struct net_device*
 void mlx5e_destroy_netdev(struct mlx5e_priv *priv);
 void mlx5e_set_netdev_mtu_boundaries(struct mlx5e_priv *priv);
 void mlx5e_build_nic_params(struct mlx5_core_dev *mdev,
+			    struct mlx5e_xsk *xsk,
 			    struct mlx5e_rss_params *rss_params,
 			    struct mlx5e_params *params,
 			    u16 max_channels, u16 mtu);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 0de908b12fcc..79301d116667 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -49,48 +49,56 @@ u32 mlx5e_rx_get_linear_frag_sz(struct mlx5e_params *params,
 	return frag_sz;
 }
 
-u8 mlx5e_mpwqe_log_pkts_per_wqe(struct mlx5e_params *params)
+u8 mlx5e_mpwqe_log_pkts_per_wqe(struct mlx5e_params *params,
+				struct mlx5e_xsk_param *xsk)
 {
-	u32 linear_frag_sz = mlx5e_rx_get_linear_frag_sz(params, NULL);
+	u32 linear_frag_sz = mlx5e_rx_get_linear_frag_sz(params, xsk);
 
 	return MLX5_MPWRQ_LOG_WQE_SZ - order_base_2(linear_frag_sz);
 }
 
-bool mlx5e_rx_is_linear_skb(struct mlx5e_params *params)
+bool mlx5e_rx_is_linear_skb(struct mlx5e_params *params,
+			    struct mlx5e_xsk_param *xsk)
 {
-	u32 frag_sz = mlx5e_rx_get_linear_frag_sz(params, NULL);
+	/* AF_XDP allocates SKBs on XDP_PASS - ensure they don't occupy more
+	 * than one page. For this, check both with and without xsk.
+	 */
+	u32 linear_frag_sz = max(mlx5e_rx_get_linear_frag_sz(params, xsk),
+				 mlx5e_rx_get_linear_frag_sz(params, NULL));
 
-	return !params->lro_en && frag_sz <= PAGE_SIZE;
+	return !params->lro_en && linear_frag_sz <= PAGE_SIZE;
 }
 
 #define MLX5_MAX_MPWQE_LOG_WQE_STRIDE_SZ ((BIT(__mlx5_bit_sz(wq, log_wqe_stride_size)) - 1) + \
 					  MLX5_MPWQE_LOG_STRIDE_SZ_BASE)
 bool mlx5e_rx_mpwqe_is_linear_skb(struct mlx5_core_dev *mdev,
-				  struct mlx5e_params *params)
+				  struct mlx5e_params *params,
+				  struct mlx5e_xsk_param *xsk)
 {
-	u32 frag_sz = mlx5e_rx_get_linear_frag_sz(params, NULL);
+	u32 linear_frag_sz = mlx5e_rx_get_linear_frag_sz(params, xsk);
 	s8 signed_log_num_strides_param;
 	u8 log_num_strides;
 
-	if (!mlx5e_rx_is_linear_skb(params))
+	if (!mlx5e_rx_is_linear_skb(params, xsk))
 		return false;
 
-	if (order_base_2(frag_sz) > MLX5_MAX_MPWQE_LOG_WQE_STRIDE_SZ)
+	if (order_base_2(linear_frag_sz) > MLX5_MAX_MPWQE_LOG_WQE_STRIDE_SZ)
 		return false;
 
 	if (MLX5_CAP_GEN(mdev, ext_stride_num_range))
 		return true;
 
-	log_num_strides = MLX5_MPWRQ_LOG_WQE_SZ - order_base_2(frag_sz);
+	log_num_strides = MLX5_MPWRQ_LOG_WQE_SZ - order_base_2(linear_frag_sz);
 	signed_log_num_strides_param =
 		(s8)log_num_strides - MLX5_MPWQE_LOG_NUM_STRIDES_BASE;
 
 	return signed_log_num_strides_param >= 0;
 }
 
-u8 mlx5e_mpwqe_get_log_rq_size(struct mlx5e_params *params)
+u8 mlx5e_mpwqe_get_log_rq_size(struct mlx5e_params *params,
+			       struct mlx5e_xsk_param *xsk)
 {
-	u8 log_pkts_per_wqe = mlx5e_mpwqe_log_pkts_per_wqe(params);
+	u8 log_pkts_per_wqe = mlx5e_mpwqe_log_pkts_per_wqe(params, xsk);
 
 	/* Numbers are unsigned, don't subtract to avoid underflow. */
 	if (params->log_rq_mtu_frames <
@@ -101,27 +109,30 @@ u8 mlx5e_mpwqe_get_log_rq_size(struct mlx5e_params *params)
 }
 
 u8 mlx5e_mpwqe_get_log_stride_size(struct mlx5_core_dev *mdev,
-				   struct mlx5e_params *params)
+				   struct mlx5e_params *params,
+				   struct mlx5e_xsk_param *xsk)
 {
-	if (mlx5e_rx_mpwqe_is_linear_skb(mdev, params))
-		return order_base_2(mlx5e_rx_get_linear_frag_sz(params, NULL));
+	if (mlx5e_rx_mpwqe_is_linear_skb(mdev, params, xsk))
+		return order_base_2(mlx5e_rx_get_linear_frag_sz(params, xsk));
 
 	return MLX5_MPWRQ_DEF_LOG_STRIDE_SZ(mdev);
 }
 
 u8 mlx5e_mpwqe_get_log_num_strides(struct mlx5_core_dev *mdev,
-				   struct mlx5e_params *params)
+				   struct mlx5e_params *params,
+				   struct mlx5e_xsk_param *xsk)
 {
 	return MLX5_MPWRQ_LOG_WQE_SZ -
-		mlx5e_mpwqe_get_log_stride_size(mdev, params);
+		mlx5e_mpwqe_get_log_stride_size(mdev, params, xsk);
 }
 
 u16 mlx5e_get_rq_headroom(struct mlx5_core_dev *mdev,
-			  struct mlx5e_params *params)
+			  struct mlx5e_params *params,
+			  struct mlx5e_xsk_param *xsk)
 {
 	bool is_linear_skb = (params->rq_wq_type == MLX5_WQ_TYPE_CYCLIC) ?
-		mlx5e_rx_is_linear_skb(params) :
-		mlx5e_rx_mpwqe_is_linear_skb(mdev, params);
+		mlx5e_rx_is_linear_skb(params, xsk) :
+		mlx5e_rx_mpwqe_is_linear_skb(mdev, params, xsk);
 
-	return is_linear_skb ? mlx5e_get_linear_rq_headroom(params, NULL) : 0;
+	return is_linear_skb ? mlx5e_get_linear_rq_headroom(params, xsk) : 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index f83417b822bf..bd882b5ee9a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -40,22 +40,85 @@ struct mlx5e_channel_param {
 	struct mlx5e_cq_param      icosq_cq;
 };
 
+static inline bool mlx5e_qid_get_ch_if_in_group(struct mlx5e_params *params,
+						u16 qid,
+						enum mlx5e_rq_group group,
+						u16 *ix)
+{
+	int nch = params->num_channels;
+	int ch = qid - nch * group;
+
+	if (ch < 0 || ch >= nch)
+		return false;
+
+	*ix = ch;
+	return true;
+}
+
+static inline void mlx5e_qid_get_ch_and_group(struct mlx5e_params *params,
+					      u16 qid,
+					      u16 *ix,
+					      enum mlx5e_rq_group *group)
+{
+	u16 nch = params->num_channels;
+
+	*ix = qid % nch;
+	*group = qid / nch;
+}
+
+static inline bool mlx5e_qid_validate(struct mlx5e_params *params, u64 qid)
+{
+	return qid < params->num_channels * MLX5E_NUM_RQ_GROUPS;
+}
+
 /* Parameter calculations */
 
 u16 mlx5e_get_linear_rq_headroom(struct mlx5e_params *params,
 				 struct mlx5e_xsk_param *xsk);
 u32 mlx5e_rx_get_linear_frag_sz(struct mlx5e_params *params,
 				struct mlx5e_xsk_param *xsk);
-u8 mlx5e_mpwqe_log_pkts_per_wqe(struct mlx5e_params *params);
-bool mlx5e_rx_is_linear_skb(struct mlx5e_params *params);
+u8 mlx5e_mpwqe_log_pkts_per_wqe(struct mlx5e_params *params,
+				struct mlx5e_xsk_param *xsk);
+bool mlx5e_rx_is_linear_skb(struct mlx5e_params *params,
+			    struct mlx5e_xsk_param *xsk);
 bool mlx5e_rx_mpwqe_is_linear_skb(struct mlx5_core_dev *mdev,
-				  struct mlx5e_params *params);
-u8 mlx5e_mpwqe_get_log_rq_size(struct mlx5e_params *params);
+				  struct mlx5e_params *params,
+				  struct mlx5e_xsk_param *xsk);
+u8 mlx5e_mpwqe_get_log_rq_size(struct mlx5e_params *params,
+			       struct mlx5e_xsk_param *xsk);
 u8 mlx5e_mpwqe_get_log_stride_size(struct mlx5_core_dev *mdev,
-				   struct mlx5e_params *params);
+				   struct mlx5e_params *params,
+				   struct mlx5e_xsk_param *xsk);
 u8 mlx5e_mpwqe_get_log_num_strides(struct mlx5_core_dev *mdev,
-				   struct mlx5e_params *params);
+				   struct mlx5e_params *params,
+				   struct mlx5e_xsk_param *xsk);
 u16 mlx5e_get_rq_headroom(struct mlx5_core_dev *mdev,
-			  struct mlx5e_params *params);
+			  struct mlx5e_params *params,
+			  struct mlx5e_xsk_param *xsk);
+
+/* Build queue parameters */
+
+void mlx5e_build_rq_param(struct mlx5e_priv *priv,
+			  struct mlx5e_params *params,
+			  struct mlx5e_xsk_param *xsk,
+			  struct mlx5e_rq_param *param);
+void mlx5e_build_sq_param_common(struct mlx5e_priv *priv,
+				 struct mlx5e_sq_param *param);
+void mlx5e_build_rx_cq_param(struct mlx5e_priv *priv,
+			     struct mlx5e_params *params,
+			     struct mlx5e_xsk_param *xsk,
+			     struct mlx5e_cq_param *param);
+void mlx5e_build_tx_cq_param(struct mlx5e_priv *priv,
+			     struct mlx5e_params *params,
+			     struct mlx5e_cq_param *param);
+void mlx5e_build_ico_cq_param(struct mlx5e_priv *priv,
+			      u8 log_wq_size,
+			      struct mlx5e_cq_param *param);
+void mlx5e_build_icosq_param(struct mlx5e_priv *priv,
+			     u8 log_wq_size,
+			     struct mlx5e_sq_param *param);
+void mlx5e_build_xdpsq_param(struct mlx5e_priv *priv,
+			     struct mlx5e_params *params,
+			     struct mlx5e_sq_param *param);
 
 #endif /* __MLX5_EN_PARAMS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index ee99efde9143..b0b982cf69bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -31,6 +31,7 @@
  */
 
 #include <linux/bpf_trace.h>
+#include <net/xdp_sock.h>
 #include "en/xdp.h"
 #include "en/params.h"
 
@@ -113,12 +114,12 @@ int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk)
 		xdpi.page.di    = *di;
 	}
 
-	return sq->xmit_xdp_frame(sq, &xdptxd, &xdpi);
+	return sq->xmit_xdp_frame(sq, &xdptxd, &xdpi, 0);
 }
 
 /* returns true if packet was consumed by xdp */
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
-		      void *va, u16 *rx_headroom, u32 *len)
+		      void *va, u16 *rx_headroom, u32 *len, bool xsk)
 {
 	struct bpf_prog *prog = READ_ONCE(rq->xdp_prog);
 	struct xdp_buff xdp;
@@ -132,9 +133,13 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 	xdp_set_data_meta_invalid(&xdp);
 	xdp.data_end = xdp.data + *len;
 	xdp.data_hard_start = va;
+	if (xsk)
+		xdp.handle = di->xsk.handle;
 	xdp.rxq = &rq->xdp_rxq;
 
 	act = bpf_prog_run_xdp(prog, &xdp);
+	if (xsk)
+		xdp.handle += xdp.data - xdp.data_hard_start;
 	switch (act) {
 	case XDP_PASS:
 		*rx_headroom = xdp.data - xdp.data_hard_start;
@@ -152,7 +157,8 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 			goto xdp_abort;
 		__set_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags);
 		__set_bit(MLX5E_RQ_FLAG_XDP_REDIRECT, rq->flags);
-		mlx5e_page_dma_unmap(rq, di);
+		if (!xsk)
+			mlx5e_page_dma_unmap(rq, di);
 		rq->stats->xdp_redirect++;
 		return true;
 	default:
@@ -206,7 +212,7 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_xdpsq *sq)
 	stats->mpwqe++;
 }
 
-static void mlx5e_xdp_mpwqe_complete(struct mlx5e_xdpsq *sq)
+void mlx5e_xdp_mpwqe_complete(struct mlx5e_xdpsq *sq)
 {
 	struct mlx5_wq_cyc       *wq    = &sq->wq;
 	struct mlx5e_xdp_mpwqe *session = &sq->mpwqe;
@@ -229,9 +235,32 @@ static void mlx5e_xdp_mpwqe_complete(struct mlx5e_xdpsq *sq)
 	session->wqe = NULL; /* Close session */
 }
 
+enum {
+	MLX5E_XDP_CHECK_OK = 1,
+	MLX5E_XDP_CHECK_START_MPWQE = 2,
+};
+
+static int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq *sq)
+{
+	if (unlikely(!sq->mpwqe.wqe)) {
+		if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc,
+						     MLX5_SEND_WQE_MAX_WQEBBS))) {
+			/* SQ is full, ring doorbell */
+			mlx5e_xmit_xdp_doorbell(sq);
+			sq->stats->full++;
+			return -EBUSY;
+		}
+
+		return MLX5E_XDP_CHECK_START_MPWQE;
+	}
+
+	return MLX5E_XDP_CHECK_OK;
+}
+
 static bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq,
 				       struct mlx5e_xdp_xmit_data *xdptxd,
-				       struct mlx5e_xdp_info *xdpi)
+				       struct mlx5e_xdp_info *xdpi,
+				       int check_result)
 {
 	struct mlx5e_xdp_mpwqe *session = &sq->mpwqe;
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
@@ -241,15 +270,16 @@ static bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq,
 		return false;
 	}
 
-	if (unlikely(!session->wqe)) {
-		if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc,
-						     MLX5_SEND_WQE_MAX_WQEBBS))) {
-			/* SQ is full, ring doorbell */
-			mlx5e_xmit_xdp_doorbell(sq);
-			stats->full++;
-			return false;
-		}
+	if (!check_result)
+		check_result = mlx5e_xmit_xdp_frame_check_mpwqe(sq);
+	if (unlikely(check_result < 0))
+		return false;
 
+	if (check_result == MLX5E_XDP_CHECK_START_MPWQE) {
+		/* Start the session when nothing can fail, so it's guaranteed
+		 * that if there is an active session, it has at least one dseg,
+		 * and it's safe to complete it at any time.
+		 */
 		mlx5e_xdp_mpwqe_session_start(sq);
 	}
 
@@ -264,9 +294,22 @@ static bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq,
 	return true;
 }
 
+static int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq)
+{
+	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, 1))) {
+		/* SQ is full, ring doorbell */
+		mlx5e_xmit_xdp_doorbell(sq);
+		sq->stats->full++;
+		return -EBUSY;
+	}
+
+	return MLX5E_XDP_CHECK_OK;
+}
+
 static bool mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq,
 				 struct mlx5e_xdp_xmit_data *xdptxd,
-				 struct mlx5e_xdp_info *xdpi)
+				 struct mlx5e_xdp_info *xdpi,
+				 int check_result)
 {
 	struct mlx5_wq_cyc       *wq   = &sq->wq;
 	u16                       pi   = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
@@ -288,12 +331,10 @@ static bool mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq,
 		return false;
 	}
 
-	if (unlikely(!mlx5e_wqc_has_room_for(wq, sq->cc, sq->pc, 1))) {
-		/* SQ is full, ring doorbell */
-		mlx5e_xmit_xdp_doorbell(sq);
-		stats->full++;
+	if (!check_result)
+		check_result = mlx5e_xmit_xdp_frame_check(sq);
+	if (unlikely(check_result < 0))
 		return false;
-	}
 
 	cseg->fm_ce_se = 0;
 
@@ -323,6 +364,7 @@ static bool mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq,
 
 static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 				  struct mlx5e_xdp_wqe_info *wi,
+				  u32 *xsk_frames,
 				  bool recycle)
 {
 	struct mlx5e_xdp_info_fifo *xdpi_fifo = &sq->db.xdpi_fifo;
@@ -340,7 +382,11 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 			break;
 		case MLX5E_XDP_XMIT_MODE_PAGE:
 			/* XDP_TX from the regular RQ */
-			mlx5e_page_release(xdpi.page.rq, &xdpi.page.di, recycle);
+			mlx5e_page_release_dynamic(xdpi.page.rq, &xdpi.page.di, recycle);
+			break;
+		case MLX5E_XDP_XMIT_MODE_XSK:
+			/* AF_XDP send */
+			(*xsk_frames)++;
 			break;
 		default:
 			WARN_ON_ONCE(true);
@@ -352,6 +398,7 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
 {
 	struct mlx5e_xdpsq *sq;
 	struct mlx5_cqe64 *cqe;
+	u32 xsk_frames = 0;
 	u16 sqcc;
 	int i;
 
@@ -393,10 +440,13 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
 
 			sqcc += wi->num_wqebbs;
 
-			mlx5e_free_xdpsq_desc(sq, wi, true);
+			mlx5e_free_xdpsq_desc(sq, wi, &xsk_frames, true);
 		} while (!last_wqe);
 	} while ((++i < MLX5E_TX_CQ_POLL_BUDGET) && (cqe = mlx5_cqwq_get_cqe(&cq->wq)));
 
+	if (xsk_frames)
+		xsk_umem_complete_tx(sq->umem, xsk_frames);
+
 	sq->stats->cqes += i;
 
 	mlx5_cqwq_update_db_record(&cq->wq);
@@ -410,6 +460,8 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
 
 void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq)
 {
+	u32 xsk_frames = 0;
+
 	while (sq->cc != sq->pc) {
 		struct mlx5e_xdp_wqe_info *wi;
 		u16 ci;
@@ -419,8 +471,11 @@ void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq)
 
 		sq->cc += wi->num_wqebbs;
 
-		mlx5e_free_xdpsq_desc(sq, wi, false);
+		mlx5e_free_xdpsq_desc(sq, wi, &xsk_frames, false);
 	}
+
+	if (xsk_frames)
+		xsk_umem_complete_tx(sq->umem, xsk_frames);
 }
 
 int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
@@ -466,7 +521,7 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		xdpi.frame.xdpf     = xdpf;
 		xdpi.frame.dma_addr = xdptxd.dma_addr;
 
-		if (unlikely(!sq->xmit_xdp_frame(sq, &xdptxd, &xdpi))) {
+		if (unlikely(!sq->xmit_xdp_frame(sq, &xdptxd, &xdpi, 0))) {
 			dma_unmap_single(sq->pdev, xdptxd.dma_addr,
 					 xdptxd.len, DMA_TO_DEVICE);
 			xdp_return_frame_rx_napi(xdpf);
@@ -500,6 +555,8 @@ void mlx5e_xdp_rx_poll_complete(struct mlx5e_rq *rq)
 
 void mlx5e_set_xmit_fp(struct mlx5e_xdpsq *sq, bool is_mpw)
 {
+	sq->xmit_xdp_frame_check = is_mpw ?
+		mlx5e_xmit_xdp_frame_check_mpwqe : mlx5e_xmit_xdp_frame_check;
 	sq->xmit_xdp_frame = is_mpw ?
 		mlx5e_xmit_xdp_frame_mpwqe : mlx5e_xmit_xdp_frame;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 9200cb9f499b..2d934c8d3807 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -42,7 +42,8 @@
 struct mlx5e_xsk_param;
 int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk);
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
-		      void *va, u16 *rx_headroom, u32 *len);
+		      void *va, u16 *rx_headroom, u32 *len, bool xsk);
+void mlx5e_xdp_mpwqe_complete(struct mlx5e_xdpsq *sq);
 bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq);
 void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq);
 void mlx5e_set_xmit_fp(struct mlx5e_xdpsq *sq, bool is_mpw);
@@ -67,6 +68,21 @@ static inline bool mlx5e_xdp_tx_is_enabled(struct mlx5e_priv *priv)
 	return test_bit(MLX5E_STATE_XDP_TX_ENABLED, &priv->state);
 }
 
+static inline void mlx5e_xdp_set_open(struct mlx5e_priv *priv)
+{
+	set_bit(MLX5E_STATE_XDP_OPEN, &priv->state);
+}
+
+static inline void mlx5e_xdp_set_closed(struct mlx5e_priv *priv)
+{
+	clear_bit(MLX5E_STATE_XDP_OPEN, &priv->state);
+}
+
+static inline bool mlx5e_xdp_is_open(struct mlx5e_priv *priv)
+{
+	return test_bit(MLX5E_STATE_XDP_OPEN, &priv->state);
+}
+
 static inline void mlx5e_xmit_xdp_doorbell(struct mlx5e_xdpsq *sq)
 {
 	if (sq->doorbell_cseg) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/Makefile
new file mode 100644
index 000000000000..5ee42991900a
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/Makefile
@@ -0,0 +1 @@
+subdir-ccflags-y += -I$(src)/../..
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
new file mode 100644
index 000000000000..6a55573ec8f2
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -0,0 +1,192 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#include "rx.h"
+#include "en/xdp.h"
+#include <net/xdp_sock.h>
+
+/* RX data path */
+
+bool mlx5e_xsk_pages_enough_umem(struct mlx5e_rq *rq, int count)
+{
+	/* Check in advance that we have enough frames, instead of allocating
+	 * one-by-one, failing and moving frames to the Reuse Ring.
+	 */
+	return xsk_umem_has_addrs_rq(rq->umem, count);
+}
+
+int mlx5e_xsk_page_alloc_umem(struct mlx5e_rq *rq,
+			      struct mlx5e_dma_info *dma_info)
+{
+	struct xdp_umem *umem = rq->umem;
+	u64 handle;
+
+	if (!xsk_umem_peek_addr_rq(umem, &handle))
+		return -ENOMEM;
+
+	dma_info->xsk.handle = handle + rq->buff.umem_headroom;
+	dma_info->xsk.data = xdp_umem_get_data(umem, dma_info->xsk.handle);
+
+	/* No need to add headroom to the DMA address. In striding RQ case, we
+	 * just provide pages for UMR, and headroom is counted at the setup
+	 * stage when creating a WQE. In non-striding RQ case, headroom is
+	 * accounted in mlx5e_alloc_rx_wqe.
+	 */
+	dma_info->addr = xdp_umem_get_dma(umem, handle);
+
+	xsk_umem_discard_addr_rq(umem);
+
+	dma_sync_single_for_device(rq->pdev, dma_info->addr, PAGE_SIZE,
+				   DMA_BIDIRECTIONAL);
+
+	return 0;
+}
+
+static inline void mlx5e_xsk_recycle_frame(struct mlx5e_rq *rq, u64 handle)
+{
+	xsk_umem_fq_reuse(rq->umem, handle & rq->umem->chunk_mask);
+}
+
+/* XSKRQ uses pages from UMEM, they must not be released. They are returned to
+ * the userspace if possible, and if not, this function is called to reuse them
+ * in the driver.
+ */
+void mlx5e_xsk_page_release(struct mlx5e_rq *rq,
+			    struct mlx5e_dma_info *dma_info)
+{
+	mlx5e_xsk_recycle_frame(rq, dma_info->xsk.handle);
+}
+
+/* Return a frame back to the hardware to fill in again. It is used by XDP when
+ * the XDP program returns XDP_TX or XDP_REDIRECT not to an XSKMAP.
+ */
+void mlx5e_xsk_zca_free(struct zero_copy_allocator *zca, unsigned long handle)
+{
+	struct mlx5e_rq *rq = container_of(zca, struct mlx5e_rq, zca);
+
+	mlx5e_xsk_recycle_frame(rq, handle);
+}
+
+static struct sk_buff *mlx5e_xsk_construct_skb(struct mlx5e_rq *rq, void *data,
+					       u32 cqe_bcnt)
+{
+	struct sk_buff *skb;
+
+	skb = napi_alloc_skb(rq->cq.napi, cqe_bcnt);
+	if (unlikely(!skb)) {
+		rq->stats->buff_alloc_err++;
+		return NULL;
+	}
+
+	skb_put_data(skb, data, cqe_bcnt);
+
+	return skb;
+}
+
+struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
+						    struct mlx5e_mpw_info *wi,
+						    u16 cqe_bcnt,
+						    u32 head_offset,
+						    u32 page_idx)
+{
+	struct mlx5e_dma_info *di = &wi->umr.dma_info[page_idx];
+	u16 rx_headroom = rq->buff.headroom - rq->buff.umem_headroom;
+	u32 cqe_bcnt32 = cqe_bcnt;
+	void *va, *data;
+	u32 frag_size;
+	bool consumed;
+
+	/* Check packet size. Note LRO doesn't use linear SKB */
+	if (unlikely(cqe_bcnt > rq->hw_mtu)) {
+		rq->stats->oversize_pkts_sw_drop++;
+		return NULL;
+	}
+
+	/* head_offset is not used in this function, because di->xsk.data and
+	 * di->addr point directly to the necessary place. Furthermore, in the
+	 * current implementation, one page = one packet = one frame, so
+	 * head_offset should always be 0.
+	 */
+	WARN_ON_ONCE(head_offset);
+
+	va             = di->xsk.data;
+	data           = va + rx_headroom;
+	frag_size      = rq->buff.headroom + cqe_bcnt32;
+
+	dma_sync_single_for_cpu(rq->pdev, di->addr, frag_size, DMA_BIDIRECTIONAL);
+	prefetch(data);
+
+	rcu_read_lock();
+	consumed = mlx5e_xdp_handle(rq, di, va, &rx_headroom, &cqe_bcnt32, true);
+	rcu_read_unlock();
+
+	/* Possible flows:
+	 * - XDP_REDIRECT to XSKMAP:
+	 *   The page is owned by the userspace from now.
+	 * - XDP_TX and other XDP_REDIRECTs:
+	 *   The page was returned by ZCA and recycled.
+	 * - XDP_DROP:
+	 *   Recycle the page.
+	 * - XDP_PASS:
+	 *   Allocate an SKB, copy the data and recycle the page.
+	 *
+	 * Pages to be recycled go to the Reuse Ring on MPWQE deallocation. Its
+	 * size is the same as the Driver RX Ring's size, and pages for WQEs are
+	 * allocated first from the Reuse Ring, so it has enough space.
+	 */
+
+	if (likely(consumed)) {
+		if (likely(__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)))
+			__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
+		return NULL; /* page/packet was consumed by XDP */
+	}
+
+	/* XDP_PASS: copy the data from the UMEM to a new SKB and reuse the
+	 * frame. On SKB allocation failure, NULL is returned.
+	 */
+	return mlx5e_xsk_construct_skb(rq, data, cqe_bcnt32);
+}
+
+struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
+					      struct mlx5_cqe64 *cqe,
+					      struct mlx5e_wqe_frag_info *wi,
+					      u32 cqe_bcnt)
+{
+	struct mlx5e_dma_info *di = wi->di;
+	u16 rx_headroom = rq->buff.headroom - rq->buff.umem_headroom;
+	void *va, *data;
+	bool consumed;
+	u32 frag_size;
+
+	/* wi->offset is not used in this function, because di->xsk.data and
+	 * di->addr point directly to the necessary place. Furthermore, in the
+	 * current implementation, one page = one packet = one frame, so
+	 * wi->offset should always be 0.
+	 */
+	WARN_ON_ONCE(wi->offset);
+
+	va             = di->xsk.data;
+	data           = va + rx_headroom;
+	frag_size      = rq->buff.headroom + cqe_bcnt;
+
+	dma_sync_single_for_cpu(rq->pdev, di->addr, frag_size, DMA_BIDIRECTIONAL);
+	prefetch(data);
+
+	if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_RESP_SEND)) {
+		rq->stats->wqe_err++;
+		return NULL;
+	}
+
+	rcu_read_lock();
+	consumed = mlx5e_xdp_handle(rq, di, va, &rx_headroom, &cqe_bcnt, true);
+	rcu_read_unlock();
+
+	if (likely(consumed))
+		return NULL; /* page/packet was consumed by XDP */
+
+	/* XDP_PASS: copy the data from the UMEM to a new SKB. The frame reuse
+	 * will be handled by mlx5e_put_rx_frag.
+	 * On SKB allocation failure, NULL is returned.
+	 */
+	return mlx5e_xsk_construct_skb(rq, data, cqe_bcnt);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
new file mode 100644
index 000000000000..307b923a1361
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#ifndef __MLX5_EN_XSK_RX_H__
+#define __MLX5_EN_XSK_RX_H__
+
+#include "en.h"
+
+/* RX data path */
+
+bool mlx5e_xsk_pages_enough_umem(struct mlx5e_rq *rq, int count);
+int mlx5e_xsk_page_alloc_umem(struct mlx5e_rq *rq,
+			      struct mlx5e_dma_info *dma_info);
+void mlx5e_xsk_page_release(struct mlx5e_rq *rq,
+			    struct mlx5e_dma_info *dma_info);
+void mlx5e_xsk_zca_free(struct zero_copy_allocator *zca, unsigned long handle);
+struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
+						    struct mlx5e_mpw_info *wi,
+						    u16 cqe_bcnt,
+						    u32 head_offset,
+						    u32 page_idx);
+struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
+					      struct mlx5_cqe64 *cqe,
+					      struct mlx5e_wqe_frag_info *wi,
+					      u32 cqe_bcnt);
+
+#endif /* __MLX5_EN_XSK_RX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
new file mode 100644
index 000000000000..9b4d47c47c92
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -0,0 +1,223 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#include "setup.h"
+#include "en/params.h"
+
+bool mlx5e_validate_xsk_param(struct mlx5e_params *params,
+			      struct mlx5e_xsk_param *xsk,
+			      struct mlx5_core_dev *mdev)
+{
+	/* AF_XDP doesn't support frames larger than PAGE_SIZE, and the current
+	 * mlx5e XDP implementation doesn't support multiple packets per page.
+	 */
+	if (xsk->chunk_size != PAGE_SIZE)
+		return false;
+
+	/* Current MTU and XSK headroom don't allow packets to fit the frames. */
+	if (mlx5e_rx_get_linear_frag_sz(params, xsk) > xsk->chunk_size)
+		return false;
+
+	/* frag_sz is different for regular and XSK RQs, so ensure that linear
+	 * SKB mode is possible.
+	 */
+	switch (params->rq_wq_type) {
+	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
+		return mlx5e_rx_mpwqe_is_linear_skb(mdev, params, xsk);
+	default: /* MLX5_WQ_TYPE_CYCLIC */
+		return mlx5e_rx_is_linear_skb(params, xsk);
+	}
+}
+
+static void mlx5e_build_xskicosq_param(struct mlx5e_priv *priv,
+				       u8 log_wq_size,
+				       struct mlx5e_sq_param *param)
+{
+	void *sqc = param->sqc;
+	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
+
+	mlx5e_build_sq_param_common(priv, param);
+
+	MLX5_SET(wq, wq, log_wq_sz, log_wq_size);
+}
+
+static void mlx5e_build_xsk_cparam(struct mlx5e_priv *priv,
+				   struct mlx5e_params *params,
+				   struct mlx5e_xsk_param *xsk,
+				   struct mlx5e_channel_param *cparam)
+{
+	const u8 xskicosq_size = MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
+
+	mlx5e_build_rq_param(priv, params, xsk, &cparam->rq);
+	mlx5e_build_xdpsq_param(priv, params, &cparam->xdp_sq);
+	mlx5e_build_xskicosq_param(priv, xskicosq_size, &cparam->icosq);
+	mlx5e_build_rx_cq_param(priv, params, xsk, &cparam->rx_cq);
+	mlx5e_build_tx_cq_param(priv, params, &cparam->tx_cq);
+	mlx5e_build_ico_cq_param(priv, xskicosq_size, &cparam->icosq_cq);
+}
+
+int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
+		   struct mlx5e_xsk_param *xsk, struct xdp_umem *umem,
+		   struct mlx5e_channel *c)
+{
+	struct mlx5e_channel_param cparam = {};
+	struct net_dim_cq_moder icocq_moder = {};
+	int err;
+
+	if (!mlx5e_validate_xsk_param(params, xsk, priv->mdev))
+		return -EINVAL;
+
+	mlx5e_build_xsk_cparam(priv, params, xsk, &cparam);
+
+	err = mlx5e_open_cq(c, params->rx_cq_moderation, &cparam.rx_cq, &c->xskrq.cq);
+	if (unlikely(err))
+		return err;
+
+	err = mlx5e_open_rq(c, params, &cparam.rq, xsk, umem, &c->xskrq);
+	if (unlikely(err))
+		goto err_close_rx_cq;
+
+	err = mlx5e_open_cq(c, params->tx_cq_moderation, &cparam.tx_cq, &c->xsksq.cq);
+	if (unlikely(err))
+		goto err_close_rq;
+
+	/* Create a separate SQ, so that when the UMEM is disabled, we could
+	 * close this SQ safely and stop receiving CQEs. In other case, e.g., if
+	 * the XDPSQ was used instead, we might run into trouble when the UMEM
+	 * is disabled and then reenabled, but the SQ continues receiving CQEs
+	 * from the old UMEM.
+	 */
+	err = mlx5e_open_xdpsq(c, params, &cparam.xdp_sq, umem, &c->xsksq, true);
+	if (unlikely(err))
+		goto err_close_tx_cq;
+
+	err = mlx5e_open_cq(c, icocq_moder, &cparam.icosq_cq, &c->xskicosq.cq);
+	if (unlikely(err))
+		goto err_close_sq;
+
+	/* Create a dedicated SQ for posting NOPs whenever we need an IRQ to be
+	 * triggered and NAPI to be called on the correct CPU.
+	 */
+	err = mlx5e_open_icosq(c, params, &cparam.icosq, &c->xskicosq);
+	if (unlikely(err))
+		goto err_close_icocq;
+
+	spin_lock_init(&c->xskicosq_lock);
+
+	set_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
+
+	return 0;
+
+err_close_icocq:
+	mlx5e_close_cq(&c->xskicosq.cq);
+
+err_close_sq:
+	mlx5e_close_xdpsq(&c->xsksq);
+
+err_close_tx_cq:
+	mlx5e_close_cq(&c->xsksq.cq);
+
+err_close_rq:
+	mlx5e_close_rq(&c->xskrq);
+
+err_close_rx_cq:
+	mlx5e_close_cq(&c->xskrq.cq);
+
+	return err;
+}
+
+void mlx5e_close_xsk(struct mlx5e_channel *c)
+{
+	clear_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
+	napi_synchronize(&c->napi);
+
+	mlx5e_close_rq(&c->xskrq);
+	mlx5e_close_cq(&c->xskrq.cq);
+	mlx5e_close_icosq(&c->xskicosq);
+	mlx5e_close_cq(&c->xskicosq.cq);
+	mlx5e_close_xdpsq(&c->xsksq);
+	mlx5e_close_cq(&c->xsksq.cq);
+}
+
+void mlx5e_activate_xsk(struct mlx5e_channel *c)
+{
+	set_bit(MLX5E_RQ_STATE_ENABLED, &c->xskrq.state);
+	/* TX queue is created active. */
+	mlx5e_trigger_irq(&c->xskicosq);
+}
+
+void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
+{
+	mlx5e_deactivate_rq(&c->xskrq);
+	/* TX queue is disabled on close. */
+}
+
+static int mlx5e_redirect_xsk_rqt(struct mlx5e_priv *priv, u16 ix, u32 rqn)
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
+int mlx5e_xsk_redirect_rqt_to_channel(struct mlx5e_priv *priv, struct mlx5e_channel *c)
+{
+	return mlx5e_redirect_xsk_rqt(priv, c->ix, c->xskrq.rqn);
+}
+
+int mlx5e_xsk_redirect_rqt_to_drop(struct mlx5e_priv *priv, u16 ix)
+{
+	return mlx5e_redirect_xsk_rqt(priv, ix, priv->drop_rq.rqn);
+}
+
+int mlx5e_xsk_redirect_rqts_to_channels(struct mlx5e_priv *priv, struct mlx5e_channels *chs)
+{
+	int err, i;
+
+	if (!priv->xsk.refcnt)
+		return 0;
+
+	for (i = 0; i < chs->num; i++) {
+		struct mlx5e_channel *c = chs->c[i];
+
+		if (!test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
+			continue;
+
+		err = mlx5e_xsk_redirect_rqt_to_channel(priv, c);
+		if (unlikely(err))
+			goto err_stop;
+	}
+
+	return 0;
+
+err_stop:
+	for (i--; i >= 0; i--) {
+		if (!test_bit(MLX5E_CHANNEL_STATE_XSK, chs->c[i]->state))
+			continue;
+
+		mlx5e_xsk_redirect_rqt_to_drop(priv, i);
+	}
+
+	return err;
+}
+
+void mlx5e_xsk_redirect_rqts_to_drop(struct mlx5e_priv *priv, struct mlx5e_channels *chs)
+{
+	int i;
+
+	if (!priv->xsk.refcnt)
+		return;
+
+	for (i = 0; i < chs->num; i++) {
+		if (!test_bit(MLX5E_CHANNEL_STATE_XSK, chs->c[i]->state))
+			continue;
+
+		mlx5e_xsk_redirect_rqt_to_drop(priv, i);
+	}
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h
new file mode 100644
index 000000000000..0dd11b81c046
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#ifndef __MLX5_EN_XSK_SETUP_H__
+#define __MLX5_EN_XSK_SETUP_H__
+
+#include "en.h"
+
+struct mlx5e_xsk_param;
+
+bool mlx5e_validate_xsk_param(struct mlx5e_params *params,
+			      struct mlx5e_xsk_param *xsk,
+			      struct mlx5_core_dev *mdev);
+int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
+		   struct mlx5e_xsk_param *xsk, struct xdp_umem *umem,
+		   struct mlx5e_channel *c);
+void mlx5e_close_xsk(struct mlx5e_channel *c);
+void mlx5e_activate_xsk(struct mlx5e_channel *c);
+void mlx5e_deactivate_xsk(struct mlx5e_channel *c);
+int mlx5e_xsk_redirect_rqt_to_channel(struct mlx5e_priv *priv, struct mlx5e_channel *c);
+int mlx5e_xsk_redirect_rqt_to_drop(struct mlx5e_priv *priv, u16 ix);
+int mlx5e_xsk_redirect_rqts_to_channels(struct mlx5e_priv *priv, struct mlx5e_channels *chs);
+void mlx5e_xsk_redirect_rqts_to_drop(struct mlx5e_priv *priv, struct mlx5e_channels *chs);
+
+#endif /* __MLX5_EN_XSK_SETUP_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
new file mode 100644
index 000000000000..35e188cf4ea4
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -0,0 +1,111 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#include "tx.h"
+#include "umem.h"
+#include "en/xdp.h"
+#include "en/params.h"
+#include <net/xdp_sock.h>
+
+int mlx5e_xsk_async_xmit(struct net_device *dev, u32 qid)
+{
+	struct mlx5e_priv *priv = netdev_priv(dev);
+	struct mlx5e_params *params = &priv->channels.params;
+	struct mlx5e_channel *c;
+	u16 ix;
+
+	if (unlikely(!mlx5e_xdp_is_open(priv)))
+		return -ENETDOWN;
+
+	if (unlikely(!mlx5e_qid_get_ch_if_in_group(params, qid, MLX5E_RQ_GROUP_XSK, &ix)))
+		return -EINVAL;
+
+	c = priv->channels.c[ix];
+
+	if (unlikely(!test_bit(MLX5E_CHANNEL_STATE_XSK, c->state)))
+		return -ENXIO;
+
+	if (!napi_if_scheduled_mark_missed(&c->napi)) {
+		spin_lock(&c->xskicosq_lock);
+		mlx5e_trigger_irq(&c->xskicosq);
+		spin_unlock(&c->xskicosq_lock);
+	}
+
+	return 0;
+}
+
+/* When TX fails (because of the size of the packet), we need to get completions
+ * in order, so post a NOP to get a CQE. Since AF_XDP doesn't distinguish
+ * between successful TX and errors, handling in mlx5e_poll_xdpsq_cq is the
+ * same.
+ */
+static void mlx5e_xsk_tx_post_err(struct mlx5e_xdpsq *sq,
+				  struct mlx5e_xdp_info *xdpi)
+{
+	u16 pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+	struct mlx5e_xdp_wqe_info *wi = &sq->db.wqe_info[pi];
+	struct mlx5e_tx_wqe *nopwqe;
+
+	wi->num_wqebbs = 1;
+	wi->num_pkts = 1;
+
+	nopwqe = mlx5e_post_nop(&sq->wq, sq->sqn, &sq->pc);
+	mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, xdpi);
+	sq->doorbell_cseg = &nopwqe->ctrl;
+}
+
+bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
+{
+	struct xdp_umem *umem = sq->umem;
+	struct mlx5e_xdp_info xdpi;
+	struct mlx5e_xdp_xmit_data xdptxd;
+	bool work_done = true;
+	bool flush = false;
+
+	xdpi.mode = MLX5E_XDP_XMIT_MODE_XSK;
+
+	for (; budget; budget--) {
+		int check_result = sq->xmit_xdp_frame_check(sq);
+		struct xdp_desc desc;
+
+		if (unlikely(check_result < 0)) {
+			work_done = false;
+			break;
+		}
+
+		if (!xsk_umem_consume_tx(umem, &desc)) {
+			/* TX will get stuck until something wakes it up by
+			 * triggering NAPI. Currently it's expected that the
+			 * application calls sendto() if there are consumed, but
+			 * not completed frames.
+			 */
+			break;
+		}
+
+		xdptxd.dma_addr = xdp_umem_get_dma(umem, desc.addr);
+		xdptxd.data = xdp_umem_get_data(umem, desc.addr);
+		xdptxd.len = desc.len;
+
+		dma_sync_single_for_device(sq->pdev, xdptxd.dma_addr,
+					   xdptxd.len, DMA_BIDIRECTIONAL);
+
+		if (unlikely(!sq->xmit_xdp_frame(sq, &xdptxd, &xdpi, check_result))) {
+			if (sq->mpwqe.wqe)
+				mlx5e_xdp_mpwqe_complete(sq);
+
+			mlx5e_xsk_tx_post_err(sq, &xdpi);
+		}
+
+		flush = true;
+	}
+
+	if (flush) {
+		if (sq->mpwqe.wqe)
+			mlx5e_xdp_mpwqe_complete(sq);
+		mlx5e_xmit_xdp_doorbell(sq);
+
+		xsk_umem_consume_tx_done(umem);
+	}
+
+	return !(budget && work_done);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
new file mode 100644
index 000000000000..7add18bf78d8
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#ifndef __MLX5_EN_XSK_TX_H__
+#define __MLX5_EN_XSK_TX_H__
+
+#include "en.h"
+
+/* TX data path */
+
+int mlx5e_xsk_async_xmit(struct net_device *dev, u32 qid);
+
+bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget);
+
+#endif /* __MLX5_EN_XSK_TX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
new file mode 100644
index 000000000000..4baaa5788320
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
@@ -0,0 +1,267 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#include <net/xdp_sock.h>
+#include "umem.h"
+#include "setup.h"
+#include "en/params.h"
+
+static int mlx5e_xsk_map_umem(struct mlx5e_priv *priv,
+			      struct xdp_umem *umem)
+{
+	struct device *dev = priv->mdev->device;
+	u32 i;
+
+	for (i = 0; i < umem->npgs; i++) {
+		dma_addr_t dma = dma_map_page(dev, umem->pgs[i], 0, PAGE_SIZE,
+					      DMA_BIDIRECTIONAL);
+
+		if (unlikely(dma_mapping_error(dev, dma)))
+			goto err_unmap;
+		umem->pages[i].dma = dma;
+	}
+
+	return 0;
+
+err_unmap:
+	while (i--) {
+		dma_unmap_page(dev, umem->pages[i].dma, PAGE_SIZE,
+			       DMA_BIDIRECTIONAL);
+		umem->pages[i].dma = 0;
+	}
+
+	return -ENOMEM;
+}
+
+static void mlx5e_xsk_unmap_umem(struct mlx5e_priv *priv,
+				 struct xdp_umem *umem)
+{
+	struct device *dev = priv->mdev->device;
+	u32 i;
+
+	for (i = 0; i < umem->npgs; i++) {
+		dma_unmap_page(dev, umem->pages[i].dma, PAGE_SIZE,
+			       DMA_BIDIRECTIONAL);
+		umem->pages[i].dma = 0;
+	}
+}
+
+static int mlx5e_xsk_get_umems(struct mlx5e_xsk *xsk)
+{
+	if (!xsk->umems) {
+		xsk->umems = kcalloc(MLX5E_MAX_NUM_CHANNELS,
+				     sizeof(*xsk->umems), GFP_KERNEL);
+		if (unlikely(!xsk->umems))
+			return -ENOMEM;
+	}
+
+	xsk->refcnt++;
+	xsk->ever_used = true;
+
+	return 0;
+}
+
+static void mlx5e_xsk_put_umems(struct mlx5e_xsk *xsk)
+{
+	if (!--xsk->refcnt) {
+		kfree(xsk->umems);
+		xsk->umems = NULL;
+	}
+}
+
+static int mlx5e_xsk_add_umem(struct mlx5e_xsk *xsk, struct xdp_umem *umem, u16 ix)
+{
+	int err;
+
+	err = mlx5e_xsk_get_umems(xsk);
+	if (unlikely(err))
+		return err;
+
+	xsk->umems[ix] = umem;
+	return 0;
+}
+
+static void mlx5e_xsk_remove_umem(struct mlx5e_xsk *xsk, u16 ix)
+{
+	xsk->umems[ix] = NULL;
+
+	mlx5e_xsk_put_umems(xsk);
+}
+
+static bool mlx5e_xsk_is_umem_sane(struct xdp_umem *umem)
+{
+	return umem->headroom <= 0xffff && umem->chunk_size_nohr <= 0xffff;
+}
+
+void mlx5e_build_xsk_param(struct xdp_umem *umem, struct mlx5e_xsk_param *xsk)
+{
+	xsk->headroom = umem->headroom;
+	xsk->chunk_size = umem->chunk_size_nohr + umem->headroom;
+}
+
+static int mlx5e_xsk_enable_locked(struct mlx5e_priv *priv,
+				   struct xdp_umem *umem, u16 ix)
+{
+	struct mlx5e_params *params = &priv->channels.params;
+	struct mlx5e_xsk_param xsk;
+	struct mlx5e_channel *c;
+	int err;
+
+	if (unlikely(mlx5e_xsk_get_umem(&priv->channels.params, &priv->xsk, ix)))
+		return -EBUSY;
+
+	if (unlikely(!mlx5e_xsk_is_umem_sane(umem)))
+		return -EINVAL;
+
+	err = mlx5e_xsk_map_umem(priv, umem);
+	if (unlikely(err))
+		return err;
+
+	err = mlx5e_xsk_add_umem(&priv->xsk, umem, ix);
+	if (unlikely(err))
+		goto err_unmap_umem;
+
+	mlx5e_build_xsk_param(umem, &xsk);
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		/* XSK objects will be created on open. */
+		goto validate_closed;
+	}
+
+	if (!params->xdp_prog) {
+		/* XSK objects will be created when an XDP program is set,
+		 * and the channels are reopened.
+		 */
+		goto validate_closed;
+	}
+
+	c = priv->channels.c[ix];
+
+	err = mlx5e_open_xsk(priv, params, &xsk, umem, c);
+	if (unlikely(err))
+		goto err_remove_umem;
+
+	mlx5e_activate_xsk(c);
+
+	/* Don't wait for WQEs, because the newer xdpsock sample doesn't provide
+	 * any Fill Ring entries at the setup stage.
+	 */
+
+	err = mlx5e_xsk_redirect_rqt_to_channel(priv, priv->channels.c[ix]);
+	if (unlikely(err))
+		goto err_deactivate;
+
+	return 0;
+
+err_deactivate:
+	mlx5e_deactivate_xsk(c);
+	mlx5e_close_xsk(c);
+
+err_remove_umem:
+	mlx5e_xsk_remove_umem(&priv->xsk, ix);
+
+err_unmap_umem:
+	mlx5e_xsk_unmap_umem(priv, umem);
+
+	return err;
+
+validate_closed:
+	/* Check the configuration in advance, rather than fail at a later stage
+	 * (in mlx5e_xdp_set or on open) and end up with no channels.
+	 */
+	if (!mlx5e_validate_xsk_param(params, &xsk, priv->mdev)) {
+		err = -EINVAL;
+		goto err_remove_umem;
+	}
+
+	return 0;
+}
+
+static int mlx5e_xsk_disable_locked(struct mlx5e_priv *priv, u16 ix)
+{
+	struct xdp_umem *umem = mlx5e_xsk_get_umem(&priv->channels.params,
+						   &priv->xsk, ix);
+	struct mlx5e_channel *c;
+
+	if (unlikely(!umem))
+		return -EINVAL;
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
+		goto remove_umem;
+
+	/* XSK RQ and SQ are only created if XDP program is set. */
+	if (!priv->channels.params.xdp_prog)
+		goto remove_umem;
+
+	c = priv->channels.c[ix];
+	mlx5e_xsk_redirect_rqt_to_drop(priv, ix);
+	mlx5e_deactivate_xsk(c);
+	mlx5e_close_xsk(c);
+
+remove_umem:
+	mlx5e_xsk_remove_umem(&priv->xsk, ix);
+	mlx5e_xsk_unmap_umem(priv, umem);
+
+	return 0;
+}
+
+static int mlx5e_xsk_enable_umem(struct mlx5e_priv *priv, struct xdp_umem *umem,
+				 u16 ix)
+{
+	int err;
+
+	mutex_lock(&priv->state_lock);
+	err = mlx5e_xsk_enable_locked(priv, umem, ix);
+	mutex_unlock(&priv->state_lock);
+
+	return err;
+}
+
+static int mlx5e_xsk_disable_umem(struct mlx5e_priv *priv, u16 ix)
+{
+	int err;
+
+	mutex_lock(&priv->state_lock);
+	err = mlx5e_xsk_disable_locked(priv, ix);
+	mutex_unlock(&priv->state_lock);
+
+	return err;
+}
+
+int mlx5e_xsk_setup_umem(struct net_device *dev, struct xdp_umem *umem, u16 qid)
+{
+	struct mlx5e_priv *priv = netdev_priv(dev);
+	struct mlx5e_params *params = &priv->channels.params;
+	u16 ix;
+
+	if (unlikely(!mlx5e_qid_get_ch_if_in_group(params, qid, MLX5E_RQ_GROUP_XSK, &ix)))
+		return -EINVAL;
+
+	return umem ? mlx5e_xsk_enable_umem(priv, umem, ix) :
+		      mlx5e_xsk_disable_umem(priv, ix);
+}
+
+int mlx5e_xsk_resize_reuseq(struct xdp_umem *umem, u32 nentries)
+{
+	struct xdp_umem_fq_reuse *reuseq;
+
+	reuseq = xsk_reuseq_prepare(nentries);
+	if (unlikely(!reuseq))
+		return -ENOMEM;
+	xsk_reuseq_free(xsk_reuseq_swap(umem, reuseq));
+
+	return 0;
+}
+
+u16 mlx5e_xsk_first_unused_channel(struct mlx5e_params *params, struct mlx5e_xsk *xsk)
+{
+	u16 res = xsk->refcnt ? params->num_channels : 0;
+
+	while (res) {
+		if (mlx5e_xsk_get_umem(params, xsk, res - 1))
+			break;
+		--res;
+	}
+
+	return res;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
new file mode 100644
index 000000000000..25b4cbe58b54
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#ifndef __MLX5_EN_XSK_UMEM_H__
+#define __MLX5_EN_XSK_UMEM_H__
+
+#include "en.h"
+
+static inline struct xdp_umem *mlx5e_xsk_get_umem(struct mlx5e_params *params,
+						  struct mlx5e_xsk *xsk, u16 ix)
+{
+	if (!xsk || !xsk->umems)
+		return NULL;
+
+	if (unlikely(ix >= params->num_channels))
+		return NULL;
+
+	return xsk->umems[ix];
+}
+
+struct mlx5e_xsk_param;
+void mlx5e_build_xsk_param(struct xdp_umem *umem, struct mlx5e_xsk_param *xsk);
+
+/* .ndo_bpf callback. */
+int mlx5e_xsk_setup_umem(struct net_device *dev, struct xdp_umem *umem, u16 qid);
+
+int mlx5e_xsk_resize_reuseq(struct xdp_umem *umem, u32 nentries);
+
+u16 mlx5e_xsk_first_unused_channel(struct mlx5e_params *params, struct mlx5e_xsk *xsk);
+
+#endif /* __MLX5_EN_XSK_UMEM_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index ea59097dd4f8..74235317d4dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -32,6 +32,7 @@
 
 #include "en.h"
 #include "en/port.h"
+#include "en/xsk/umem.h"
 #include "lib/clock.h"
 
 void mlx5e_ethtool_get_drvinfo(struct mlx5e_priv *priv,
@@ -388,8 +389,17 @@ static int mlx5e_set_ringparam(struct net_device *dev,
 void mlx5e_ethtool_get_channels(struct mlx5e_priv *priv,
 				struct ethtool_channels *ch)
 {
+	mutex_lock(&priv->state_lock);
+
 	ch->max_combined   = mlx5e_get_netdev_max_channels(priv->netdev);
 	ch->combined_count = priv->channels.params.num_channels;
+	if (priv->xsk.refcnt) {
+		/* The upper half are XSK queues. */
+		ch->max_combined *= 2;
+		ch->combined_count *= 2;
+	}
+
+	mutex_unlock(&priv->state_lock);
 }
 
 static void mlx5e_get_channels(struct net_device *dev,
@@ -403,6 +413,7 @@ static void mlx5e_get_channels(struct net_device *dev,
 int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 			       struct ethtool_channels *ch)
 {
+	struct mlx5e_params *cur_params = &priv->channels.params;
 	unsigned int count = ch->combined_count;
 	struct mlx5e_channels new_channels = {};
 	bool arfs_enabled;
@@ -414,16 +425,26 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 		return -EINVAL;
 	}
 
-	if (priv->channels.params.num_channels == count)
+	if (cur_params->num_channels == count)
 		return 0;
 
 	mutex_lock(&priv->state_lock);
 
+	/* Don't allow changing the number of channels if there is an active
+	 * XSK, because the numeration of the XSK and regular RQs will change.
+	 */
+	if (priv->xsk.refcnt) {
+		err = -EINVAL;
+		netdev_err(priv->netdev, "%s: AF_XDP is active, cannot change the number of channels\n",
+			   __func__);
+		goto out;
+	}
+
 	new_channels.params = priv->channels.params;
 	new_channels.params.num_channels = count;
 
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-		priv->channels.params = new_channels.params;
+		*cur_params = new_channels.params;
 		if (!netif_is_rxfh_configured(priv->netdev))
 			mlx5e_build_default_indir_rqt(priv->rss_params.indirection_rqt,
 						      MLX5E_INDIR_RQT_SIZE, count);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
index 4421c10f58ae..ec5392baabc8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -32,6 +32,8 @@
 
 #include <linux/mlx5/fs.h>
 #include "en.h"
+#include "en/params.h"
+#include "en/xsk/umem.h"
 
 struct mlx5e_ethtool_rule {
 	struct list_head             list;
@@ -414,6 +416,14 @@ static bool outer_header_zero(u32 *match_criteria)
 	if (fs->ring_cookie == RX_CLS_FLOW_DISC) {
 		flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
 	} else {
+		struct mlx5e_params *params = &priv->channels.params;
+		enum mlx5e_rq_group group;
+		struct mlx5e_tir *tir;
+		u16 ix;
+
+		mlx5e_qid_get_ch_and_group(params, fs->ring_cookie, &ix, &group);
+		tir = group == MLX5E_RQ_GROUP_XSK ? priv->xsk_tir : priv->direct_tir;
+
 		dst = kzalloc(sizeof(*dst), GFP_KERNEL);
 		if (!dst) {
 			err = -ENOMEM;
@@ -421,7 +431,7 @@ static bool outer_header_zero(u32 *match_criteria)
 		}
 
 		dst->type = MLX5_FLOW_DESTINATION_TYPE_TIR;
-		dst->tir_num = priv->direct_tir[fs->ring_cookie].tirn;
+		dst->tir_num = tir[ix].tirn;
 		flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	}
 
@@ -600,9 +610,9 @@ static int validate_flow(struct mlx5e_priv *priv,
 	if (fs->location >= MAX_NUM_OF_ETHTOOL_RULES)
 		return -ENOSPC;
 
-	if (fs->ring_cookie >= priv->channels.params.num_channels &&
-	    fs->ring_cookie != RX_CLS_FLOW_DISC)
-		return -EINVAL;
+	if (fs->ring_cookie != RX_CLS_FLOW_DISC)
+		if (!mlx5e_qid_validate(&priv->channels.params, fs->ring_cookie))
+			return -EINVAL;
 
 	switch (fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT)) {
 	case ETHER_FLOW:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f6c603572bd6..67b562c7f8a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -38,6 +38,7 @@
 #include <linux/bpf.h>
 #include <linux/if_bridge.h>
 #include <net/page_pool.h>
+#include <net/xdp_sock.h>
 #include "eswitch.h"
 #include "en.h"
 #include "en_tc.h"
@@ -56,6 +57,10 @@
 #include "en/monitor_stats.h"
 #include "en/reporter.h"
 #include "en/params.h"
+#include "en/xsk/umem.h"
+#include "en/xsk/setup.h"
+#include "en/xsk/rx.h"
+#include "en/xsk/tx.h"
 
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev)
 {
@@ -85,18 +90,31 @@ void mlx5e_init_rq_type_params(struct mlx5_core_dev *mdev,
 	mlx5_core_info(mdev, "MLX5E: StrdRq(%d) RqSz(%ld) StrdSz(%ld) RxCqeCmprss(%d)\n",
 		       params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ,
 		       params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ ?
-		       BIT(mlx5e_mpwqe_get_log_rq_size(params)) :
+		       BIT(mlx5e_mpwqe_get_log_rq_size(params, NULL)) :
 		       BIT(params->log_rq_mtu_frames),
-		       BIT(mlx5e_mpwqe_get_log_stride_size(mdev, params)),
+		       BIT(mlx5e_mpwqe_get_log_stride_size(mdev, params, NULL)),
 		       MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS));
 }
 
 bool mlx5e_striding_rq_possible(struct mlx5_core_dev *mdev,
 				struct mlx5e_params *params)
 {
-	return mlx5e_check_fragmented_striding_rq_cap(mdev) &&
-		!MLX5_IPSEC_DEV(mdev) &&
-		!(params->xdp_prog && !mlx5e_rx_mpwqe_is_linear_skb(mdev, params));
+	if (!mlx5e_check_fragmented_striding_rq_cap(mdev))
+		return false;
+
+	if (MLX5_IPSEC_DEV(mdev))
+		return false;
+
+	if (params->xdp_prog) {
+		/* XSK params are not considered here. If striding RQ is in use,
+		 * and an XSK is being opened, mlx5e_rx_mpwqe_is_linear_skb will
+		 * be called with the known XSK params.
+		 */
+		if (!mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL))
+			return false;
+	}
+
+	return true;
 }
 
 void mlx5e_set_rq_type(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
@@ -365,6 +383,8 @@ static void mlx5e_free_di_list(struct mlx5e_rq *rq)
 
 static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 			  struct mlx5e_params *params,
+			  struct mlx5e_xsk_param *xsk,
+			  struct xdp_umem *umem,
 			  struct mlx5e_rq_param *rqp,
 			  struct mlx5e_rq *rq)
 {
@@ -372,6 +392,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	struct mlx5_core_dev *mdev = c->mdev;
 	void *rqc = rqp->rqc;
 	void *rqc_wq = MLX5_ADDR_OF(rqc, rqc, wq);
+	u32 num_xsk_frames = 0;
+	u32 rq_xdp_ix;
 	u32 pool_size;
 	int wq_sz;
 	int err;
@@ -388,8 +410,13 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	rq->ix      = c->ix;
 	rq->mdev    = mdev;
 	rq->hw_mtu  = MLX5E_SW2HW_MTU(params, params->sw_mtu);
-	rq->stats   = &c->priv->channel_stats[c->ix].rq;
 	rq->xdpsq   = &c->rq_xdpsq;
+	rq->umem    = umem;
+
+	if (rq->umem)
+		rq->stats = &c->priv->channel_stats[c->ix].xskrq;
+	else
+		rq->stats = &c->priv->channel_stats[c->ix].rq;
 
 	rq->xdp_prog = params->xdp_prog ? bpf_prog_inc(params->xdp_prog) : NULL;
 	if (IS_ERR(rq->xdp_prog)) {
@@ -398,12 +425,16 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		goto err_rq_wq_destroy;
 	}
 
-	err = xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix);
+	rq_xdp_ix = rq->ix;
+	if (xsk)
+		rq_xdp_ix += params->num_channels * MLX5E_RQ_GROUP_XSK;
+	err = xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq_xdp_ix);
 	if (err < 0)
 		goto err_rq_wq_destroy;
 
 	rq->buff.map_dir = rq->xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
-	rq->buff.headroom = mlx5e_get_rq_headroom(mdev, params);
+	rq->buff.headroom = mlx5e_get_rq_headroom(mdev, params, xsk);
+	rq->buff.umem_headroom = xsk ? xsk->headroom : 0;
 	pool_size = 1 << params->log_rq_mtu_frames;
 
 	switch (rq->wq_type) {
@@ -417,7 +448,12 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 
 		wq_sz = mlx5_wq_ll_get_size(&rq->mpwqe.wq);
 
-		pool_size = MLX5_MPWRQ_PAGES_PER_WQE << mlx5e_mpwqe_get_log_rq_size(params);
+		if (xsk)
+			num_xsk_frames = wq_sz <<
+				mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk);
+
+		pool_size = MLX5_MPWRQ_PAGES_PER_WQE <<
+			mlx5e_mpwqe_get_log_rq_size(params, xsk);
 
 		rq->post_wqes = mlx5e_post_rx_mpwqes;
 		rq->dealloc_wqe = mlx5e_dealloc_rx_mpwqe;
@@ -436,12 +472,15 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 			goto err_rq_wq_destroy;
 		}
 
-		rq->mpwqe.skb_from_cqe_mpwrq =
-			mlx5e_rx_mpwqe_is_linear_skb(mdev, params) ?
-			mlx5e_skb_from_cqe_mpwrq_linear :
-			mlx5e_skb_from_cqe_mpwrq_nonlinear;
-		rq->mpwqe.log_stride_sz = mlx5e_mpwqe_get_log_stride_size(mdev, params);
-		rq->mpwqe.num_strides = BIT(mlx5e_mpwqe_get_log_num_strides(mdev, params));
+		rq->mpwqe.skb_from_cqe_mpwrq = xsk ?
+			mlx5e_xsk_skb_from_cqe_mpwrq_linear :
+			mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL) ?
+				mlx5e_skb_from_cqe_mpwrq_linear :
+				mlx5e_skb_from_cqe_mpwrq_nonlinear;
+
+		rq->mpwqe.log_stride_sz = mlx5e_mpwqe_get_log_stride_size(mdev, params, xsk);
+		rq->mpwqe.num_strides =
+			BIT(mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk));
 
 		err = mlx5e_create_rq_umr_mkey(mdev, rq);
 		if (err)
@@ -462,6 +501,9 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 
 		wq_sz = mlx5_wq_cyc_get_size(&rq->wqe.wq);
 
+		if (xsk)
+			num_xsk_frames = wq_sz << rq->wqe.info.log_num_frags;
+
 		rq->wqe.info = rqp->frags_info;
 		rq->wqe.frags =
 			kvzalloc_node(array_size(sizeof(*rq->wqe.frags),
@@ -475,6 +517,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		err = mlx5e_init_di_list(rq, wq_sz, c->cpu);
 		if (err)
 			goto err_free;
+
 		rq->post_wqes = mlx5e_post_rx_wqes;
 		rq->dealloc_wqe = mlx5e_dealloc_rx_wqe;
 
@@ -490,37 +533,53 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 			goto err_free;
 		}
 
-		rq->wqe.skb_from_cqe = mlx5e_rx_is_linear_skb(params) ?
-			mlx5e_skb_from_cqe_linear :
-			mlx5e_skb_from_cqe_nonlinear;
+		rq->wqe.skb_from_cqe = xsk ?
+			mlx5e_xsk_skb_from_cqe_linear :
+			mlx5e_rx_is_linear_skb(params, NULL) ?
+				mlx5e_skb_from_cqe_linear :
+				mlx5e_skb_from_cqe_nonlinear;
 		rq->mkey_be = c->mkey_be;
 	}
 
-	/* Create a page_pool and register it with rxq */
-	pp_params.order     = 0;
-	pp_params.flags     = 0; /* No-internal DMA mapping in page_pool */
-	pp_params.pool_size = pool_size;
-	pp_params.nid       = cpu_to_node(c->cpu);
-	pp_params.dev       = c->pdev;
-	pp_params.dma_dir   = rq->buff.map_dir;
-
-	/* page_pool can be used even when there is no rq->xdp_prog,
-	 * given page_pool does not handle DMA mapping there is no
-	 * required state to clear. And page_pool gracefully handle
-	 * elevated refcnt.
-	 */
-	rq->page_pool = page_pool_create(&pp_params);
-	if (IS_ERR(rq->page_pool)) {
-		err = PTR_ERR(rq->page_pool);
-		rq->page_pool = NULL;
-		goto err_free;
+	if (xsk) {
+		err = mlx5e_xsk_resize_reuseq(umem, num_xsk_frames);
+		if (unlikely(err)) {
+			mlx5_core_err(mdev, "Unable to allocate the Reuse Ring for %u frames\n",
+				      num_xsk_frames);
+			goto err_free;
+		}
+
+		rq->zca.free = mlx5e_xsk_zca_free;
+		err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
+						 MEM_TYPE_ZERO_COPY,
+						 &rq->zca);
+	} else {
+		/* Create a page_pool and register it with rxq */
+		pp_params.order     = 0;
+		pp_params.flags     = 0; /* No-internal DMA mapping in page_pool */
+		pp_params.pool_size = pool_size;
+		pp_params.nid       = cpu_to_node(c->cpu);
+		pp_params.dev       = c->pdev;
+		pp_params.dma_dir   = rq->buff.map_dir;
+
+		/* page_pool can be used even when there is no rq->xdp_prog,
+		 * given page_pool does not handle DMA mapping there is no
+		 * required state to clear. And page_pool gracefully handle
+		 * elevated refcnt.
+		 */
+		rq->page_pool = page_pool_create(&pp_params);
+		if (IS_ERR(rq->page_pool)) {
+			err = PTR_ERR(rq->page_pool);
+			rq->page_pool = NULL;
+			goto err_free;
+		}
+		err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
+						 MEM_TYPE_PAGE_POOL, rq->page_pool);
+		if (err)
+			page_pool_free(rq->page_pool);
 	}
-	err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
-					 MEM_TYPE_PAGE_POOL, rq->page_pool);
-	if (err) {
-		page_pool_free(rq->page_pool);
+	if (err)
 		goto err_free;
-	}
 
 	for (i = 0; i < wq_sz; i++) {
 		if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
@@ -611,7 +670,11 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
 	     i = (i + 1) & (MLX5E_CACHE_SIZE - 1)) {
 		struct mlx5e_dma_info *dma_info = &rq->page_cache.page_cache[i];
 
-		mlx5e_page_release(rq, dma_info, false);
+		/* With AF_XDP, page_cache is not used, so this loop is not
+		 * entered, and it's safe to call mlx5e_page_release_dynamic
+		 * directly.
+		 */
+		mlx5e_page_release_dynamic(rq, dma_info, false);
 	}
 
 	xdp_rxq_info_unreg(&rq->xdp_rxq);
@@ -748,7 +811,7 @@ static void mlx5e_destroy_rq(struct mlx5e_rq *rq)
 	mlx5_core_destroy_rq(rq->mdev, rq->rqn);
 }
 
-static int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int wait_time)
+int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int wait_time)
 {
 	unsigned long exp_time = jiffies + msecs_to_jiffies(wait_time);
 	struct mlx5e_channel *c = rq->channel;
@@ -806,14 +869,13 @@ static void mlx5e_free_rx_descs(struct mlx5e_rq *rq)
 
 }
 
-static int mlx5e_open_rq(struct mlx5e_channel *c,
-			 struct mlx5e_params *params,
-			 struct mlx5e_rq_param *param,
-			 struct mlx5e_rq *rq)
+int mlx5e_open_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
+		  struct mlx5e_rq_param *param, struct mlx5e_xsk_param *xsk,
+		  struct xdp_umem *umem, struct mlx5e_rq *rq)
 {
 	int err;
 
-	err = mlx5e_alloc_rq(c, params, param, rq);
+	err = mlx5e_alloc_rq(c, params, xsk, umem, param, rq);
 	if (err)
 		return err;
 
@@ -851,13 +913,13 @@ static void mlx5e_activate_rq(struct mlx5e_rq *rq)
 	mlx5e_trigger_irq(&rq->channel->icosq);
 }
 
-static void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
+void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
 {
 	clear_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
 	napi_synchronize(&rq->channel->napi); /* prevent mlx5e_post_rx_wqes */
 }
 
-static void mlx5e_close_rq(struct mlx5e_rq *rq)
+void mlx5e_close_rq(struct mlx5e_rq *rq)
 {
 	cancel_work_sync(&rq->dim.work);
 	mlx5e_destroy_rq(rq);
@@ -910,6 +972,7 @@ static int mlx5e_alloc_xdpsq_db(struct mlx5e_xdpsq *sq, int numa)
 
 static int mlx5e_alloc_xdpsq(struct mlx5e_channel *c,
 			     struct mlx5e_params *params,
+			     struct xdp_umem *umem,
 			     struct mlx5e_sq_param *param,
 			     struct mlx5e_xdpsq *sq,
 			     bool is_redirect)
@@ -925,9 +988,13 @@ static int mlx5e_alloc_xdpsq(struct mlx5e_channel *c,
 	sq->uar_map   = mdev->mlx5e_res.bfreg.map;
 	sq->min_inline_mode = params->tx_min_inline_mode;
 	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu);
-	sq->stats     = is_redirect ?
-		&c->priv->channel_stats[c->ix].xdpsq :
-		&c->priv->channel_stats[c->ix].rq_xdpsq;
+	sq->umem      = umem;
+
+	sq->stats = sq->umem ?
+		&c->priv->channel_stats[c->ix].xsksq :
+		is_redirect ?
+			&c->priv->channel_stats[c->ix].xdpsq :
+			&c->priv->channel_stats[c->ix].rq_xdpsq;
 
 	param->wq.db_numa_node = cpu_to_node(c->cpu);
 	err = mlx5_wq_cyc_create(mdev, &param->wq, sqc_wq, wq, &sq->wq_ctrl);
@@ -1307,10 +1374,8 @@ static void mlx5e_tx_err_cqe_work(struct work_struct *recover_work)
 	mlx5e_tx_reporter_err_cqe(sq);
 }
 
-static int mlx5e_open_icosq(struct mlx5e_channel *c,
-			    struct mlx5e_params *params,
-			    struct mlx5e_sq_param *param,
-			    struct mlx5e_icosq *sq)
+int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
+		     struct mlx5e_sq_param *param, struct mlx5e_icosq *sq)
 {
 	struct mlx5e_create_sq_param csp = {};
 	int err;
@@ -1336,7 +1401,7 @@ static int mlx5e_open_icosq(struct mlx5e_channel *c,
 	return err;
 }
 
-static void mlx5e_close_icosq(struct mlx5e_icosq *sq)
+void mlx5e_close_icosq(struct mlx5e_icosq *sq)
 {
 	struct mlx5e_channel *c = sq->channel;
 
@@ -1347,16 +1412,14 @@ static void mlx5e_close_icosq(struct mlx5e_icosq *sq)
 	mlx5e_free_icosq(sq);
 }
 
-static int mlx5e_open_xdpsq(struct mlx5e_channel *c,
-			    struct mlx5e_params *params,
-			    struct mlx5e_sq_param *param,
-			    struct mlx5e_xdpsq *sq,
-			    bool is_redirect)
+int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
+		     struct mlx5e_sq_param *param, struct xdp_umem *umem,
+		     struct mlx5e_xdpsq *sq, bool is_redirect)
 {
 	struct mlx5e_create_sq_param csp = {};
 	int err;
 
-	err = mlx5e_alloc_xdpsq(c, params, param, sq, is_redirect);
+	err = mlx5e_alloc_xdpsq(c, params, umem, param, sq, is_redirect);
 	if (err)
 		return err;
 
@@ -1410,7 +1473,7 @@ static int mlx5e_open_xdpsq(struct mlx5e_channel *c,
 	return err;
 }
 
-static void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq)
+void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq)
 {
 	struct mlx5e_channel *c = sq->channel;
 
@@ -1539,10 +1602,8 @@ static void mlx5e_destroy_cq(struct mlx5e_cq *cq)
 	mlx5_core_destroy_cq(cq->mdev, &cq->mcq);
 }
 
-static int mlx5e_open_cq(struct mlx5e_channel *c,
-			 struct net_dim_cq_moder moder,
-			 struct mlx5e_cq_param *param,
-			 struct mlx5e_cq *cq)
+int mlx5e_open_cq(struct mlx5e_channel *c, struct net_dim_cq_moder moder,
+		  struct mlx5e_cq_param *param, struct mlx5e_cq *cq)
 {
 	struct mlx5_core_dev *mdev = c->mdev;
 	int err;
@@ -1565,7 +1626,7 @@ static int mlx5e_open_cq(struct mlx5e_channel *c,
 	return err;
 }
 
-static void mlx5e_close_cq(struct mlx5e_cq *cq)
+void mlx5e_close_cq(struct mlx5e_cq *cq)
 {
 	mlx5e_destroy_cq(cq);
 	mlx5e_free_cq(cq);
@@ -1779,17 +1840,17 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 		goto err_close_icosq;
 
 	if (c->xdp) {
-		err = mlx5e_open_xdpsq(c, params, &cparam->xdp_sq,
+		err = mlx5e_open_xdpsq(c, params, &cparam->xdp_sq, NULL,
 				       &c->rq_xdpsq, false);
 		if (err)
 			goto err_close_sqs;
 	}
 
-	err = mlx5e_open_rq(c, params, &cparam->rq, &c->rq);
+	err = mlx5e_open_rq(c, params, &cparam->rq, NULL, NULL, &c->rq);
 	if (err)
 		goto err_close_xdp_sq;
 
-	err = mlx5e_open_xdpsq(c, params, &cparam->xdp_sq, &c->xdpsq, true);
+	err = mlx5e_open_xdpsq(c, params, &cparam->xdp_sq, NULL, &c->xdpsq, true);
 	if (err)
 		goto err_close_rq;
 
@@ -1849,10 +1910,12 @@ static void mlx5e_close_queues(struct mlx5e_channel *c)
 static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 			      struct mlx5e_params *params,
 			      struct mlx5e_channel_param *cparam,
+			      struct xdp_umem *umem,
 			      struct mlx5e_channel **cp)
 {
 	int cpu = cpumask_first(mlx5_comp_irq_get_affinity_mask(priv->mdev, ix));
 	struct net_device *netdev = priv->netdev;
+	struct mlx5e_xsk_param xsk;
 	struct mlx5e_channel *c;
 	unsigned int irq;
 	int err;
@@ -1889,10 +1952,20 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	if (unlikely(err))
 		goto err_napi_del;
 
+	if (umem) {
+		mlx5e_build_xsk_param(umem, &xsk);
+		err = mlx5e_open_xsk(priv, params, &xsk, umem, c);
+		if (unlikely(err))
+			goto err_close_queues;
+	}
+
 	*cp = c;
 
 	return 0;
 
+err_close_queues:
+	mlx5e_close_queues(c);
+
 err_napi_del:
 	netif_napi_del(&c->napi);
 	mlx5e_free_xps_cpumask(c);
@@ -1911,12 +1984,18 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)
 		mlx5e_activate_txqsq(&c->sq[tc]);
 	mlx5e_activate_rq(&c->rq);
 	netif_set_xps_queue(c->netdev, c->xps_cpumask, c->ix);
+
+	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
+		mlx5e_activate_xsk(c);
 }
 
 static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
 {
 	int tc;
 
+	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
+		mlx5e_deactivate_xsk(c);
+
 	mlx5e_deactivate_rq(&c->rq);
 	for (tc = 0; tc < c->num_tc; tc++)
 		mlx5e_deactivate_txqsq(&c->sq[tc]);
@@ -1924,6 +2003,8 @@ static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
 
 static void mlx5e_close_channel(struct mlx5e_channel *c)
 {
+	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
+		mlx5e_close_xsk(c);
 	mlx5e_close_queues(c);
 	netif_napi_del(&c->napi);
 	mlx5e_free_xps_cpumask(c);
@@ -1935,6 +2016,7 @@ static void mlx5e_close_channel(struct mlx5e_channel *c)
 
 static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 				      struct mlx5e_params *params,
+				      struct mlx5e_xsk_param *xsk,
 				      struct mlx5e_rq_frags_info *info)
 {
 	u32 byte_count = MLX5E_SW2HW_MTU(params, params->sw_mtu);
@@ -1947,10 +2029,10 @@ static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 		byte_count += MLX5E_METADATA_ETHER_LEN;
 #endif
 
-	if (mlx5e_rx_is_linear_skb(params)) {
+	if (mlx5e_rx_is_linear_skb(params, xsk)) {
 		int frag_stride;
 
-		frag_stride = mlx5e_rx_get_linear_frag_sz(params, NULL);
+		frag_stride = mlx5e_rx_get_linear_frag_sz(params, xsk);
 		frag_stride = roundup_pow_of_two(frag_stride);
 
 		info->arr[0].frag_size = byte_count;
@@ -2008,9 +2090,10 @@ static u8 mlx5e_get_rq_log_wq_sz(void *rqc)
 	return MLX5_GET(wq, wq, log_wq_sz);
 }
 
-static void mlx5e_build_rq_param(struct mlx5e_priv *priv,
-				 struct mlx5e_params *params,
-				 struct mlx5e_rq_param *param)
+void mlx5e_build_rq_param(struct mlx5e_priv *priv,
+			  struct mlx5e_params *params,
+			  struct mlx5e_xsk_param *xsk,
+			  struct mlx5e_rq_param *param)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 	void *rqc = param->rqc;
@@ -2020,16 +2103,16 @@ static void mlx5e_build_rq_param(struct mlx5e_priv *priv,
 	switch (params->rq_wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
 		MLX5_SET(wq, wq, log_wqe_num_of_strides,
-			 mlx5e_mpwqe_get_log_num_strides(mdev, params) -
+			 mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk) -
 			 MLX5_MPWQE_LOG_NUM_STRIDES_BASE);
 		MLX5_SET(wq, wq, log_wqe_stride_size,
-			 mlx5e_mpwqe_get_log_stride_size(mdev, params) -
+			 mlx5e_mpwqe_get_log_stride_size(mdev, params, xsk) -
 			 MLX5_MPWQE_LOG_STRIDE_SZ_BASE);
-		MLX5_SET(wq, wq, log_wq_sz, mlx5e_mpwqe_get_log_rq_size(params));
+		MLX5_SET(wq, wq, log_wq_sz, mlx5e_mpwqe_get_log_rq_size(params, xsk));
 		break;
 	default: /* MLX5_WQ_TYPE_CYCLIC */
 		MLX5_SET(wq, wq, log_wq_sz, params->log_rq_mtu_frames);
-		mlx5e_build_rq_frags_info(mdev, params, &param->frags_info);
+		mlx5e_build_rq_frags_info(mdev, params, xsk, &param->frags_info);
 		ndsegs = param->frags_info.num_frags;
 	}
 
@@ -2060,8 +2143,8 @@ static void mlx5e_build_drop_rq_param(struct mlx5e_priv *priv,
 	param->wq.buf_numa_node = dev_to_node(mdev->device);
 }
 
-static void mlx5e_build_sq_param_common(struct mlx5e_priv *priv,
-					struct mlx5e_sq_param *param)
+void mlx5e_build_sq_param_common(struct mlx5e_priv *priv,
+				 struct mlx5e_sq_param *param)
 {
 	void *sqc = param->sqc;
 	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
@@ -2097,9 +2180,10 @@ static void mlx5e_build_common_cq_param(struct mlx5e_priv *priv,
 		MLX5_SET(cqc, cqc, cqe_sz, CQE_STRIDE_128_PAD);
 }
 
-static void mlx5e_build_rx_cq_param(struct mlx5e_priv *priv,
-				    struct mlx5e_params *params,
-				    struct mlx5e_cq_param *param)
+void mlx5e_build_rx_cq_param(struct mlx5e_priv *priv,
+			     struct mlx5e_params *params,
+			     struct mlx5e_xsk_param *xsk,
+			     struct mlx5e_cq_param *param)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 	void *cqc = param->cqc;
@@ -2107,8 +2191,8 @@ static void mlx5e_build_rx_cq_param(struct mlx5e_priv *priv,
 
 	switch (params->rq_wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
-		log_cq_size = mlx5e_mpwqe_get_log_rq_size(params) +
-			mlx5e_mpwqe_get_log_num_strides(mdev, params);
+		log_cq_size = mlx5e_mpwqe_get_log_rq_size(params, xsk) +
+			mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk);
 		break;
 	default: /* MLX5_WQ_TYPE_CYCLIC */
 		log_cq_size = params->log_rq_mtu_frames;
@@ -2124,9 +2208,9 @@ static void mlx5e_build_rx_cq_param(struct mlx5e_priv *priv,
 	param->cq_period_mode = params->rx_cq_moderation.cq_period_mode;
 }
 
-static void mlx5e_build_tx_cq_param(struct mlx5e_priv *priv,
-				    struct mlx5e_params *params,
-				    struct mlx5e_cq_param *param)
+void mlx5e_build_tx_cq_param(struct mlx5e_priv *priv,
+			     struct mlx5e_params *params,
+			     struct mlx5e_cq_param *param)
 {
 	void *cqc = param->cqc;
 
@@ -2136,9 +2220,9 @@ static void mlx5e_build_tx_cq_param(struct mlx5e_priv *priv,
 	param->cq_period_mode = params->tx_cq_moderation.cq_period_mode;
 }
 
-static void mlx5e_build_ico_cq_param(struct mlx5e_priv *priv,
-				     u8 log_wq_size,
-				     struct mlx5e_cq_param *param)
+void mlx5e_build_ico_cq_param(struct mlx5e_priv *priv,
+			      u8 log_wq_size,
+			      struct mlx5e_cq_param *param)
 {
 	void *cqc = param->cqc;
 
@@ -2149,9 +2233,9 @@ static void mlx5e_build_ico_cq_param(struct mlx5e_priv *priv,
 	param->cq_period_mode = NET_DIM_CQ_PERIOD_MODE_START_FROM_EQE;
 }
 
-static void mlx5e_build_icosq_param(struct mlx5e_priv *priv,
-				    u8 log_wq_size,
-				    struct mlx5e_sq_param *param)
+void mlx5e_build_icosq_param(struct mlx5e_priv *priv,
+			     u8 log_wq_size,
+			     struct mlx5e_sq_param *param)
 {
 	void *sqc = param->sqc;
 	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
@@ -2162,9 +2246,9 @@ static void mlx5e_build_icosq_param(struct mlx5e_priv *priv,
 	MLX5_SET(sqc, sqc, reg_umr, MLX5_CAP_ETH(priv->mdev, reg_umr_sq));
 }
 
-static void mlx5e_build_xdpsq_param(struct mlx5e_priv *priv,
-				    struct mlx5e_params *params,
-				    struct mlx5e_sq_param *param)
+void mlx5e_build_xdpsq_param(struct mlx5e_priv *priv,
+			     struct mlx5e_params *params,
+			     struct mlx5e_sq_param *param)
 {
 	void *sqc = param->sqc;
 	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
@@ -2192,14 +2276,14 @@ static void mlx5e_build_channel_param(struct mlx5e_priv *priv,
 {
 	u8 icosq_log_wq_sz;
 
-	mlx5e_build_rq_param(priv, params, &cparam->rq);
+	mlx5e_build_rq_param(priv, params, NULL, &cparam->rq);
 
 	icosq_log_wq_sz = mlx5e_build_icosq_log_wq_sz(params, &cparam->rq);
 
 	mlx5e_build_sq_param(priv, params, &cparam->sq);
 	mlx5e_build_xdpsq_param(priv, params, &cparam->xdp_sq);
 	mlx5e_build_icosq_param(priv, icosq_log_wq_sz, &cparam->icosq);
-	mlx5e_build_rx_cq_param(priv, params, &cparam->rx_cq);
+	mlx5e_build_rx_cq_param(priv, params, NULL, &cparam->rx_cq);
 	mlx5e_build_tx_cq_param(priv, params, &cparam->tx_cq);
 	mlx5e_build_ico_cq_param(priv, icosq_log_wq_sz, &cparam->icosq_cq);
 }
@@ -2220,7 +2304,12 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 
 	mlx5e_build_channel_param(priv, &chs->params, cparam);
 	for (i = 0; i < chs->num; i++) {
-		err = mlx5e_open_channel(priv, i, &chs->params, cparam, &chs->c[i]);
+		struct xdp_umem *umem = NULL;
+
+		if (chs->params.xdp_prog)
+			umem = mlx5e_xsk_get_umem(&chs->params, chs->params.xsk, i);
+
+		err = mlx5e_open_channel(priv, i, &chs->params, cparam, umem, &chs->c[i]);
 		if (err)
 			goto err_close_channels;
 	}
@@ -2262,6 +2351,10 @@ static int mlx5e_wait_channels_min_rx_wqes(struct mlx5e_channels *chs)
 		int timeout = err ? 0 : MLX5E_RQ_WQES_TIMEOUT;
 
 		err |= mlx5e_wait_for_min_rx_wqes(&chs->c[i]->rq, timeout);
+
+		/* Don't wait on the XSK RQ, because the newer xdpsock sample
+		 * doesn't provide any Fill Ring entries at the setup stage.
+		 */
 	}
 
 	return err ? -ETIMEDOUT : 0;
@@ -2334,35 +2427,35 @@ int mlx5e_create_indirect_rqt(struct mlx5e_priv *priv)
 	return err;
 }
 
-int mlx5e_create_direct_rqts(struct mlx5e_priv *priv)
+int mlx5e_create_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs)
 {
-	struct mlx5e_rqt *rqt;
+	const int max_nch = mlx5e_get_netdev_max_channels(priv->netdev);
 	int err;
 	int ix;
 
-	for (ix = 0; ix < mlx5e_get_netdev_max_channels(priv->netdev); ix++) {
-		rqt = &priv->direct_tir[ix].rqt;
-		err = mlx5e_create_rqt(priv, 1 /*size */, rqt);
-		if (err)
+	for (ix = 0; ix < max_nch; ix++) {
+		err = mlx5e_create_rqt(priv, 1 /*size */, &tirs[ix].rqt);
+		if (unlikely(err))
 			goto err_destroy_rqts;
 	}
 
 	return 0;
 
 err_destroy_rqts:
-	mlx5_core_warn(priv->mdev, "create direct rqts failed, %d\n", err);
+	mlx5_core_warn(priv->mdev, "create rqts failed, %d\n", err);
 	for (ix--; ix >= 0; ix--)
-		mlx5e_destroy_rqt(priv, &priv->direct_tir[ix].rqt);
+		mlx5e_destroy_rqt(priv, &tirs[ix].rqt);
 
 	return err;
 }
 
-void mlx5e_destroy_direct_rqts(struct mlx5e_priv *priv)
+void mlx5e_destroy_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs)
 {
+	const int max_nch = mlx5e_get_netdev_max_channels(priv->netdev);
 	int i;
 
-	for (i = 0; i < mlx5e_get_netdev_max_channels(priv->netdev); i++)
-		mlx5e_destroy_rqt(priv, &priv->direct_tir[i].rqt);
+	for (i = 0; i < max_nch; i++)
+		mlx5e_destroy_rqt(priv, &tirs[i].rqt);
 }
 
 static int mlx5e_rx_hash_fn(int hfunc)
@@ -2782,11 +2875,12 @@ static void mlx5e_build_tx2sq_maps(struct mlx5e_priv *priv)
 void mlx5e_activate_priv_channels(struct mlx5e_priv *priv)
 {
 	int num_txqs = priv->channels.num * priv->channels.params.num_tc;
+	int num_rxqs = priv->channels.num * MLX5E_NUM_RQ_GROUPS;
 	struct net_device *netdev = priv->netdev;
 
 	mlx5e_netdev_set_tcs(netdev);
 	netif_set_real_num_tx_queues(netdev, num_txqs);
-	netif_set_real_num_rx_queues(netdev, priv->channels.num);
+	netif_set_real_num_rx_queues(netdev, num_rxqs);
 
 	mlx5e_build_tx2sq_maps(priv);
 	mlx5e_activate_channels(&priv->channels);
@@ -2798,10 +2892,14 @@ void mlx5e_activate_priv_channels(struct mlx5e_priv *priv)
 
 	mlx5e_wait_channels_min_rx_wqes(&priv->channels);
 	mlx5e_redirect_rqts_to_channels(priv, &priv->channels);
+
+	mlx5e_xsk_redirect_rqts_to_channels(priv, &priv->channels);
 }
 
 void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv)
 {
+	mlx5e_xsk_redirect_rqts_to_drop(priv, &priv->channels);
+
 	mlx5e_redirect_rqts_to_drop(priv);
 
 	if (mlx5e_is_vport_rep(priv))
@@ -2880,9 +2978,12 @@ void mlx5e_timestamp_init(struct mlx5e_priv *priv)
 int mlx5e_open_locked(struct net_device *netdev)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
+	bool is_xdp = priv->channels.params.xdp_prog;
 	int err;
 
 	set_bit(MLX5E_STATE_OPENED, &priv->state);
+	if (is_xdp)
+		mlx5e_xdp_set_open(priv);
 
 	err = mlx5e_open_channels(priv, &priv->channels);
 	if (err)
@@ -2897,6 +2998,8 @@ int mlx5e_open_locked(struct net_device *netdev)
 	return 0;
 
 err_clear_state_opened_flag:
+	if (is_xdp)
+		mlx5e_xdp_set_closed(priv);
 	clear_bit(MLX5E_STATE_OPENED, &priv->state);
 	return err;
 }
@@ -2928,6 +3031,8 @@ int mlx5e_close_locked(struct net_device *netdev)
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
 		return 0;
 
+	if (priv->channels.params.xdp_prog)
+		mlx5e_xdp_set_closed(priv);
 	clear_bit(MLX5E_STATE_OPENED, &priv->state);
 
 	netif_carrier_off(priv->netdev);
@@ -3184,13 +3289,13 @@ int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 	return err;
 }
 
-int mlx5e_create_direct_tirs(struct mlx5e_priv *priv)
+int mlx5e_create_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs)
 {
-	int nch = mlx5e_get_netdev_max_channels(priv->netdev);
+	const int max_nch = mlx5e_get_netdev_max_channels(priv->netdev);
 	struct mlx5e_tir *tir;
 	void *tirc;
 	int inlen;
-	int err;
+	int err = 0;
 	u32 *in;
 	int ix;
 
@@ -3199,25 +3304,24 @@ int mlx5e_create_direct_tirs(struct mlx5e_priv *priv)
 	if (!in)
 		return -ENOMEM;
 
-	for (ix = 0; ix < nch; ix++) {
+	for (ix = 0; ix < max_nch; ix++) {
 		memset(in, 0, inlen);
-		tir = &priv->direct_tir[ix];
+		tir = &tirs[ix];
 		tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
-		mlx5e_build_direct_tir_ctx(priv, priv->direct_tir[ix].rqt.rqtn, tirc);
+		mlx5e_build_direct_tir_ctx(priv, tir->rqt.rqtn, tirc);
 		err = mlx5e_create_tir(priv->mdev, tir, in, inlen);
-		if (err)
+		if (unlikely(err))
 			goto err_destroy_ch_tirs;
 	}
 
-	kvfree(in);
-
-	return 0;
+	goto out;
 
 err_destroy_ch_tirs:
-	mlx5_core_warn(priv->mdev, "create direct tirs failed, %d\n", err);
+	mlx5_core_warn(priv->mdev, "create tirs failed, %d\n", err);
 	for (ix--; ix >= 0; ix--)
-		mlx5e_destroy_tir(priv->mdev, &priv->direct_tir[ix]);
+		mlx5e_destroy_tir(priv->mdev, &tirs[ix]);
 
+out:
 	kvfree(in);
 
 	return err;
@@ -3237,13 +3341,13 @@ void mlx5e_destroy_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 		mlx5e_destroy_tir(priv->mdev, &priv->inner_indir_tir[i]);
 }
 
-void mlx5e_destroy_direct_tirs(struct mlx5e_priv *priv)
+void mlx5e_destroy_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs)
 {
-	int nch = mlx5e_get_netdev_max_channels(priv->netdev);
+	const int max_nch = mlx5e_get_netdev_max_channels(priv->netdev);
 	int i;
 
-	for (i = 0; i < nch; i++)
-		mlx5e_destroy_tir(priv->mdev, &priv->direct_tir[i]);
+	for (i = 0; i < max_nch; i++)
+		mlx5e_destroy_tir(priv->mdev, &tirs[i]);
 }
 
 static int mlx5e_modify_channels_scatter_fcs(struct mlx5e_channels *chs, bool enable)
@@ -3385,11 +3489,12 @@ void mlx5e_fold_sw_stats64(struct mlx5e_priv *priv, struct rtnl_link_stats64 *s)
 
 	for (i = 0; i < mlx5e_get_netdev_max_channels(priv->netdev); i++) {
 		struct mlx5e_channel_stats *channel_stats = &priv->channel_stats[i];
+		struct mlx5e_rq_stats *xskrq_stats = &channel_stats->xskrq;
 		struct mlx5e_rq_stats *rq_stats = &channel_stats->rq;
 		int j;
 
-		s->rx_packets   += rq_stats->packets;
-		s->rx_bytes     += rq_stats->bytes;
+		s->rx_packets   += rq_stats->packets + xskrq_stats->packets;
+		s->rx_bytes     += rq_stats->bytes + xskrq_stats->bytes;
 
 		for (j = 0; j < priv->max_opened_tc; j++) {
 			struct mlx5e_sq_stats *sq_stats = &channel_stats->sq[j];
@@ -3488,6 +3593,13 @@ static int set_feature_lro(struct net_device *netdev, bool enable)
 
 	mutex_lock(&priv->state_lock);
 
+	if (enable && priv->xsk.refcnt) {
+		netdev_warn(netdev, "LRO is incompatible with AF_XDP (%hu XSKs are active)\n",
+			    priv->xsk.refcnt);
+		err = -EINVAL;
+		goto out;
+	}
+
 	old_params = &priv->channels.params;
 	if (enable && !MLX5E_GET_PFLAG(old_params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
 		netdev_warn(netdev, "can't set LRO with legacy RQ\n");
@@ -3501,8 +3613,8 @@ static int set_feature_lro(struct net_device *netdev, bool enable)
 	new_channels.params.lro_en = enable;
 
 	if (old_params->rq_wq_type != MLX5_WQ_TYPE_CYCLIC) {
-		if (mlx5e_rx_mpwqe_is_linear_skb(mdev, old_params) ==
-		    mlx5e_rx_mpwqe_is_linear_skb(mdev, &new_channels.params))
+		if (mlx5e_rx_mpwqe_is_linear_skb(mdev, old_params, NULL) ==
+		    mlx5e_rx_mpwqe_is_linear_skb(mdev, &new_channels.params, NULL))
 			reset = false;
 	}
 
@@ -3692,6 +3804,43 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 	return features;
 }
 
+static bool mlx5e_xsk_validate_mtu(struct net_device *netdev,
+				   struct mlx5e_channels *chs,
+				   struct mlx5e_params *new_params,
+				   struct mlx5_core_dev *mdev)
+{
+	u16 ix;
+
+	for (ix = 0; ix < chs->params.num_channels; ix++) {
+		struct xdp_umem *umem = mlx5e_xsk_get_umem(&chs->params, chs->params.xsk, ix);
+		struct mlx5e_xsk_param xsk;
+
+		if (!umem)
+			continue;
+
+		mlx5e_build_xsk_param(umem, &xsk);
+
+		if (!mlx5e_validate_xsk_param(new_params, &xsk, mdev)) {
+			u32 hr = mlx5e_get_linear_rq_headroom(new_params, &xsk);
+			int max_mtu_frame, max_mtu_page, max_mtu;
+
+			/* Two criteria must be met:
+			 * 1. HW MTU + all headrooms <= XSK frame size.
+			 * 2. Size of SKBs allocated on XDP_PASS <= PAGE_SIZE.
+			 */
+			max_mtu_frame = MLX5E_HW2SW_MTU(new_params, xsk.chunk_size - hr);
+			max_mtu_page = mlx5e_xdp_max_mtu(new_params, &xsk);
+			max_mtu = min(max_mtu_frame, max_mtu_page);
+
+			netdev_err(netdev, "MTU %d is too big for an XSK running on channel %hu. Try MTU <= %d\n",
+				   new_params->sw_mtu, ix, max_mtu);
+			return false;
+		}
+	}
+
+	return true;
+}
+
 int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 		     change_hw_mtu_cb set_mtu_cb)
 {
@@ -3712,18 +3861,31 @@ int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 	new_channels.params.sw_mtu = new_mtu;
 
 	if (params->xdp_prog &&
-	    !mlx5e_rx_is_linear_skb(&new_channels.params)) {
+	    !mlx5e_rx_is_linear_skb(&new_channels.params, NULL)) {
 		netdev_err(netdev, "MTU(%d) > %d is not allowed while XDP enabled\n",
 			   new_mtu, mlx5e_xdp_max_mtu(params, NULL));
 		err = -EINVAL;
 		goto out;
 	}
 
+	if (priv->xsk.refcnt &&
+	    !mlx5e_xsk_validate_mtu(netdev, &priv->channels,
+				    &new_channels.params, priv->mdev)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
-		bool is_linear = mlx5e_rx_mpwqe_is_linear_skb(priv->mdev, &new_channels.params);
-		u8 ppw_old = mlx5e_mpwqe_log_pkts_per_wqe(params);
-		u8 ppw_new = mlx5e_mpwqe_log_pkts_per_wqe(&new_channels.params);
+		bool is_linear = mlx5e_rx_mpwqe_is_linear_skb(priv->mdev,
+							      &new_channels.params,
+							      NULL);
+		u8 ppw_old = mlx5e_mpwqe_log_pkts_per_wqe(params, NULL);
+		u8 ppw_new = mlx5e_mpwqe_log_pkts_per_wqe(&new_channels.params, NULL);
+
+		/* If XSK is active, XSK RQs are linear. */
+		is_linear |= priv->xsk.refcnt;
 
+		/* Always reset in linear mode - hw_mtu is used in data path. */
 		reset = reset && (is_linear || (ppw_old != ppw_new));
 	}
 
@@ -4156,7 +4318,10 @@ static int mlx5e_xdp_allowed(struct mlx5e_priv *priv, struct bpf_prog *prog)
 	new_channels.params = priv->channels.params;
 	new_channels.params.xdp_prog = prog;
 
-	if (!mlx5e_rx_is_linear_skb(&new_channels.params)) {
+	/* No XSK params: AF_XDP can't be enabled yet at the point of setting
+	 * the XDP program.
+	 */
+	if (!mlx5e_rx_is_linear_skb(&new_channels.params, NULL)) {
 		netdev_warn(netdev, "XDP is not allowed with MTU(%d) > %d\n",
 			    new_channels.params.sw_mtu,
 			    mlx5e_xdp_max_mtu(&new_channels.params, NULL));
@@ -4166,6 +4331,16 @@ static int mlx5e_xdp_allowed(struct mlx5e_priv *priv, struct bpf_prog *prog)
 	return 0;
 }
 
+static int mlx5e_xdp_update_state(struct mlx5e_priv *priv)
+{
+	if (priv->channels.params.xdp_prog)
+		mlx5e_xdp_set_open(priv);
+	else
+		mlx5e_xdp_set_closed(priv);
+
+	return 0;
+}
+
 static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -4205,7 +4380,7 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 		mlx5e_set_rq_type(priv->mdev, &new_channels.params);
 		old_prog = priv->channels.params.xdp_prog;
 
-		err = mlx5e_safe_switch_channels(priv, &new_channels, NULL);
+		err = mlx5e_safe_switch_channels(priv, &new_channels, mlx5e_xdp_update_state);
 		if (err)
 			goto unlock;
 	} else {
@@ -4229,19 +4404,29 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 	 */
 	for (i = 0; i < priv->channels.num; i++) {
 		struct mlx5e_channel *c = priv->channels.c[i];
+		bool xsk_open = test_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
 
 		clear_bit(MLX5E_RQ_STATE_ENABLED, &c->rq.state);
+		if (xsk_open)
+			clear_bit(MLX5E_RQ_STATE_ENABLED, &c->xskrq.state);
 		napi_synchronize(&c->napi);
 		/* prevent mlx5e_poll_rx_cq from accessing rq->xdp_prog */
 
 		old_prog = xchg(&c->rq.xdp_prog, prog);
+		if (old_prog)
+			bpf_prog_put(old_prog);
+
+		if (xsk_open) {
+			old_prog = xchg(&c->xskrq.xdp_prog, prog);
+			if (old_prog)
+				bpf_prog_put(old_prog);
+		}
 
 		set_bit(MLX5E_RQ_STATE_ENABLED, &c->rq.state);
+		if (xsk_open)
+			set_bit(MLX5E_RQ_STATE_ENABLED, &c->xskrq.state);
 		/* napi_schedule in case we have missed anything */
 		napi_schedule(&c->napi);
-
-		if (old_prog)
-			bpf_prog_put(old_prog);
 	}
 
 unlock:
@@ -4272,6 +4457,9 @@ static int mlx5e_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	case XDP_QUERY_PROG:
 		xdp->prog_id = mlx5e_xdp_query(dev);
 		return 0;
+	case XDP_SETUP_XSK_UMEM:
+		return mlx5e_xsk_setup_umem(dev, xdp->xsk.umem,
+					    xdp->xsk.queue_id);
 	default:
 		return -EINVAL;
 	}
@@ -4354,6 +4542,7 @@ static int mlx5e_bridge_setlink(struct net_device *dev, struct nlmsghdr *nlh,
 	.ndo_tx_timeout          = mlx5e_tx_timeout,
 	.ndo_bpf		 = mlx5e_xdp,
 	.ndo_xdp_xmit            = mlx5e_xdp_xmit,
+	.ndo_xsk_async_xmit      = mlx5e_xsk_async_xmit,
 #ifdef CONFIG_MLX5_EN_ARFS
 	.ndo_rx_flow_steer	 = mlx5e_rx_flow_steer,
 #endif
@@ -4505,11 +4694,13 @@ void mlx5e_build_rq_params(struct mlx5_core_dev *mdev,
 	 * - Striding RQ configuration is not possible/supported.
 	 * - Slow PCI heuristic.
 	 * - Legacy RQ would use linear SKB while Striding RQ would use non-linear.
+	 *
+	 * No XSK params: checking the availability of striding RQ in general.
 	 */
 	if (!slow_pci_heuristic(mdev) &&
 	    mlx5e_striding_rq_possible(mdev, params) &&
-	    (mlx5e_rx_mpwqe_is_linear_skb(mdev, params) ||
-	     !mlx5e_rx_is_linear_skb(params)))
+	    (mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL) ||
+	     !mlx5e_rx_is_linear_skb(params, NULL)))
 		MLX5E_SET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ, true);
 	mlx5e_set_rq_type(mdev, params);
 	mlx5e_init_rq_type_params(mdev, params);
@@ -4531,6 +4722,7 @@ void mlx5e_build_rss_params(struct mlx5e_rss_params *rss_params,
 }
 
 void mlx5e_build_nic_params(struct mlx5_core_dev *mdev,
+			    struct mlx5e_xsk *xsk,
 			    struct mlx5e_rss_params *rss_params,
 			    struct mlx5e_params *params,
 			    u16 max_channels, u16 mtu)
@@ -4566,9 +4758,11 @@ void mlx5e_build_nic_params(struct mlx5_core_dev *mdev,
 	/* HW LRO */
 
 	/* TODO: && MLX5_CAP_ETH(mdev, lro_cap) */
-	if (params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ)
-		if (!mlx5e_rx_mpwqe_is_linear_skb(mdev, params))
+	if (params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
+		/* No XSK params: checking the availability of striding RQ in general. */
+		if (!mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL))
 			params->lro_en = !slow_pci_heuristic(mdev);
+	}
 	params->lro_timeout = mlx5e_choose_lro_timeout(mdev, MLX5E_DEFAULT_LRO_TIMEOUT);
 
 	/* CQ moderation params */
@@ -4587,6 +4781,9 @@ void mlx5e_build_nic_params(struct mlx5_core_dev *mdev,
 	mlx5e_build_rss_params(rss_params, params->num_channels);
 	params->tunneled_offload_en =
 		mlx5e_tunnel_inner_ft_supported(mdev);
+
+	/* AF_XDP */
+	params->xsk = xsk;
 }
 
 static void mlx5e_set_netdev_dev_addr(struct net_device *netdev)
@@ -4759,7 +4956,7 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	if (err)
 		return err;
 
-	mlx5e_build_nic_params(mdev, rss, &priv->channels.params,
+	mlx5e_build_nic_params(mdev, &priv->xsk, rss, &priv->channels.params,
 			       mlx5e_get_netdev_max_channels(netdev),
 			       netdev->mtu);
 
@@ -4801,7 +4998,7 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_close_drop_rq;
 
-	err = mlx5e_create_direct_rqts(priv);
+	err = mlx5e_create_direct_rqts(priv, priv->direct_tir);
 	if (err)
 		goto err_destroy_indirect_rqts;
 
@@ -4809,14 +5006,22 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_direct_rqts;
 
-	err = mlx5e_create_direct_tirs(priv);
+	err = mlx5e_create_direct_tirs(priv, priv->direct_tir);
 	if (err)
 		goto err_destroy_indirect_tirs;
 
+	err = mlx5e_create_direct_rqts(priv, priv->xsk_tir);
+	if (unlikely(err))
+		goto err_destroy_direct_tirs;
+
+	err = mlx5e_create_direct_tirs(priv, priv->xsk_tir);
+	if (unlikely(err))
+		goto err_destroy_xsk_rqts;
+
 	err = mlx5e_create_flow_steering(priv);
 	if (err) {
 		mlx5_core_warn(mdev, "create flow steering failed, %d\n", err);
-		goto err_destroy_direct_tirs;
+		goto err_destroy_xsk_tirs;
 	}
 
 	err = mlx5e_tc_nic_init(priv);
@@ -4827,12 +5032,16 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 
 err_destroy_flow_steering:
 	mlx5e_destroy_flow_steering(priv);
+err_destroy_xsk_tirs:
+	mlx5e_destroy_direct_tirs(priv, priv->xsk_tir);
+err_destroy_xsk_rqts:
+	mlx5e_destroy_direct_rqts(priv, priv->xsk_tir);
 err_destroy_direct_tirs:
-	mlx5e_destroy_direct_tirs(priv);
+	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
 err_destroy_indirect_tirs:
 	mlx5e_destroy_indirect_tirs(priv, true);
 err_destroy_direct_rqts:
-	mlx5e_destroy_direct_rqts(priv);
+	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 err_destroy_indirect_rqts:
 	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
 err_close_drop_rq:
@@ -4846,9 +5055,11 @@ static void mlx5e_cleanup_nic_rx(struct mlx5e_priv *priv)
 {
 	mlx5e_tc_nic_cleanup(priv);
 	mlx5e_destroy_flow_steering(priv);
-	mlx5e_destroy_direct_tirs(priv);
+	mlx5e_destroy_direct_tirs(priv, priv->xsk_tir);
+	mlx5e_destroy_direct_rqts(priv, priv->xsk_tir);
+	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
 	mlx5e_destroy_indirect_tirs(priv, true);
-	mlx5e_destroy_direct_rqts(priv);
+	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
 	mlx5e_destroy_q_counters(priv);
@@ -4998,7 +5209,7 @@ struct net_device *mlx5e_create_netdev(struct mlx5_core_dev *mdev,
 
 	netdev = alloc_etherdev_mqs(sizeof(struct mlx5e_priv),
 				    nch * profile->max_tc,
-				    nch);
+				    nch * MLX5E_NUM_RQ_GROUPS);
 	if (!netdev) {
 		mlx5_core_err(mdev, "alloc_etherdev_mqs() failed\n");
 		return NULL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 3999da3e6314..8a7f60f30838 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1519,7 +1519,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_close_drop_rq;
 
-	err = mlx5e_create_direct_rqts(priv);
+	err = mlx5e_create_direct_rqts(priv, priv->direct_tir);
 	if (err)
 		goto err_destroy_indirect_rqts;
 
@@ -1527,7 +1527,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_direct_rqts;
 
-	err = mlx5e_create_direct_tirs(priv);
+	err = mlx5e_create_direct_tirs(priv, priv->direct_tir);
 	if (err)
 		goto err_destroy_indirect_tirs;
 
@@ -1544,11 +1544,11 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 err_destroy_ttc_table:
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
 err_destroy_direct_tirs:
-	mlx5e_destroy_direct_tirs(priv);
+	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
 err_destroy_indirect_tirs:
 	mlx5e_destroy_indirect_tirs(priv, false);
 err_destroy_direct_rqts:
-	mlx5e_destroy_direct_rqts(priv);
+	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 err_destroy_indirect_rqts:
 	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
 err_close_drop_rq:
@@ -1562,9 +1562,9 @@ static void mlx5e_cleanup_rep_rx(struct mlx5e_priv *priv)
 
 	mlx5_del_flow_rules(rpriv->vport_rx_rule);
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
-	mlx5e_destroy_direct_tirs(priv);
+	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
 	mlx5e_destroy_indirect_tirs(priv, false);
-	mlx5e_destroy_direct_rqts(priv);
+	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index ec34df777c96..56a2f4666c47 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -47,6 +47,7 @@
 #include "en_accel/tls_rxtx.h"
 #include "lib/clock.h"
 #include "en/xdp.h"
+#include "en/xsk/rx.h"
 
 static inline bool mlx5e_rx_hw_stamp(struct hwtstamp_config *config)
 {
@@ -235,8 +236,8 @@ static inline bool mlx5e_rx_cache_get(struct mlx5e_rq *rq,
 	return true;
 }
 
-static inline int mlx5e_page_alloc_mapped(struct mlx5e_rq *rq,
-					  struct mlx5e_dma_info *dma_info)
+static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq,
+					struct mlx5e_dma_info *dma_info)
 {
 	if (mlx5e_rx_cache_get(rq, dma_info))
 		return 0;
@@ -256,13 +257,23 @@ static inline int mlx5e_page_alloc_mapped(struct mlx5e_rq *rq,
 	return 0;
 }
 
+static inline int mlx5e_page_alloc(struct mlx5e_rq *rq,
+				   struct mlx5e_dma_info *dma_info)
+{
+	if (rq->umem)
+		return mlx5e_xsk_page_alloc_umem(rq, dma_info);
+	else
+		return mlx5e_page_alloc_pool(rq, dma_info);
+}
+
 void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info)
 {
 	dma_unmap_page(rq->pdev, dma_info->addr, PAGE_SIZE, rq->buff.map_dir);
 }
 
-void mlx5e_page_release(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info,
-			bool recycle)
+void mlx5e_page_release_dynamic(struct mlx5e_rq *rq,
+				struct mlx5e_dma_info *dma_info,
+				bool recycle)
 {
 	if (likely(recycle)) {
 		if (mlx5e_rx_cache_put(rq, dma_info))
@@ -277,6 +288,20 @@ void mlx5e_page_release(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info,
 	}
 }
 
+static inline void mlx5e_page_release(struct mlx5e_rq *rq,
+				      struct mlx5e_dma_info *dma_info,
+				      bool recycle)
+{
+	if (rq->umem)
+		/* The `recycle` parameter is ignored, and the page is always
+		 * put into the Reuse Ring, because there is no way to return
+		 * the page to the userspace when the interface goes down.
+		 */
+		mlx5e_xsk_page_release(rq, dma_info);
+	else
+		mlx5e_page_release_dynamic(rq, dma_info, recycle);
+}
+
 static inline int mlx5e_get_rx_frag(struct mlx5e_rq *rq,
 				    struct mlx5e_wqe_frag_info *frag)
 {
@@ -288,7 +313,7 @@ static inline int mlx5e_get_rx_frag(struct mlx5e_rq *rq,
 		 * offset) should just use the new one without replenishing again
 		 * by themselves.
 		 */
-		err = mlx5e_page_alloc_mapped(rq, frag->di);
+		err = mlx5e_page_alloc(rq, frag->di);
 
 	return err;
 }
@@ -354,6 +379,13 @@ static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, u8 wqe_bulk)
 	int err;
 	int i;
 
+	if (rq->umem) {
+		int pages_desired = wqe_bulk << rq->wqe.info.log_num_frags;
+
+		if (unlikely(!mlx5e_xsk_pages_enough_umem(rq, pages_desired)))
+			return -ENOMEM;
+	}
+
 	for (i = 0; i < wqe_bulk; i++) {
 		struct mlx5e_rx_wqe_cyc *wqe = mlx5_wq_cyc_get_wqe(wq, ix + i);
 
@@ -401,11 +433,17 @@ static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, u8 wqe_bulk)
 static void
 mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi, bool recycle)
 {
-	const bool no_xdp_xmit =
-		bitmap_empty(wi->xdp_xmit_bitmap, MLX5_MPWRQ_PAGES_PER_WQE);
+	bool no_xdp_xmit;
 	struct mlx5e_dma_info *dma_info = wi->umr.dma_info;
 	int i;
 
+	/* A common case for AF_XDP. */
+	if (bitmap_full(wi->xdp_xmit_bitmap, MLX5_MPWRQ_PAGES_PER_WQE))
+		return;
+
+	no_xdp_xmit = bitmap_empty(wi->xdp_xmit_bitmap,
+				   MLX5_MPWRQ_PAGES_PER_WQE);
+
 	for (i = 0; i < MLX5_MPWRQ_PAGES_PER_WQE; i++)
 		if (no_xdp_xmit || !test_bit(i, wi->xdp_xmit_bitmap))
 			mlx5e_page_release(rq, &dma_info[i], recycle);
@@ -454,6 +492,12 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	int err;
 	int i;
 
+	if (rq->umem &&
+	    unlikely(!mlx5e_xsk_pages_enough_umem(rq, MLX5_MPWRQ_PAGES_PER_WQE))) {
+		err = -ENOMEM;
+		goto err;
+	}
+
 	pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
 	contig_wqebbs_room = mlx5_wq_cyc_get_contig_wqebbs(wq, pi);
 	if (unlikely(contig_wqebbs_room < MLX5E_UMR_WQEBBS)) {
@@ -465,7 +509,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	memcpy(umr_wqe, &rq->mpwqe.umr_wqe, offsetof(struct mlx5e_umr_wqe, inline_mtts));
 
 	for (i = 0; i < MLX5_MPWRQ_PAGES_PER_WQE; i++, dma_info++) {
-		err = mlx5e_page_alloc_mapped(rq, dma_info);
+		err = mlx5e_page_alloc(rq, dma_info);
 		if (unlikely(err))
 			goto err_unmap;
 		umr_wqe->inline_mtts[i].ptag = cpu_to_be64(dma_info->addr | MLX5_EN_WR);
@@ -492,6 +536,8 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		dma_info--;
 		mlx5e_page_release(rq, dma_info, true);
 	}
+
+err:
 	rq->stats->buff_alloc_err++;
 
 	return err;
@@ -605,6 +651,7 @@ bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq)
 	struct mlx5e_icosq *sq = &rq->channel->icosq;
 	struct mlx5_wq_ll *wq = &rq->mpwqe.wq;
 	u8  umr_completed = rq->mpwqe.umr_completed;
+	int alloc_err = 0;
 	u8  missing, i;
 	u16 head;
 
@@ -629,7 +676,9 @@ bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq)
 	head = rq->mpwqe.actual_wq_head;
 	i = missing;
 	do {
-		if (unlikely(mlx5e_alloc_rx_mpwqe(rq, head)))
+		alloc_err = mlx5e_alloc_rx_mpwqe(rq, head);
+
+		if (unlikely(alloc_err))
 			break;
 		head = mlx5_wq_ll_get_wqe_next_ix(wq, head);
 	} while (--i);
@@ -643,6 +692,12 @@ bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq)
 	rq->mpwqe.umr_in_progress += rq->mpwqe.umr_last_bulk;
 	rq->mpwqe.actual_wq_head   = head;
 
+	/* If XSK Fill Ring doesn't have enough frames, busy poll by
+	 * rescheduling the NAPI poll.
+	 */
+	if (unlikely(alloc_err == -ENOMEM && rq->umem))
+		return true;
+
 	return false;
 }
 
@@ -1011,7 +1066,7 @@ struct sk_buff *
 	}
 
 	rcu_read_lock();
-	consumed = mlx5e_xdp_handle(rq, di, va, &rx_headroom, &cqe_bcnt);
+	consumed = mlx5e_xdp_handle(rq, di, va, &rx_headroom, &cqe_bcnt, false);
 	rcu_read_unlock();
 	if (consumed)
 		return NULL; /* page/packet was consumed by XDP */
@@ -1228,7 +1283,7 @@ struct sk_buff *
 	prefetch(data);
 
 	rcu_read_lock();
-	consumed = mlx5e_xdp_handle(rq, di, va, &rx_headroom, &cqe_bcnt32);
+	consumed = mlx5e_xdp_handle(rq, di, va, &rx_headroom, &cqe_bcnt32, false);
 	rcu_read_unlock();
 	if (consumed) {
 		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 483d321d2151..5f540db47cc9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -104,7 +104,33 @@
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_poll) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_arm) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_aff_change) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_force_irq) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_eq_rearm) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_csum_complete) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_csum_unnecessary) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_csum_unnecessary_inner) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_csum_none) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_ecn_mark) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_removed_vlan_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_xdp_drop) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_xdp_redirect) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_wqe_err) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_mpwqe_filler_cqes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_mpwqe_filler_strides) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_oversize_pkts_sw_drop) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_buff_alloc_err) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_cqe_compress_blks) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_cqe_compress_pkts) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_congst_umr) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xsk_arfs_err) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_xsk_xmit) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_xsk_mpwqe) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_xsk_inlnw) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_xsk_full) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_xsk_err) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_xsk_cqes) },
 };
 
 #define NUM_SW_COUNTERS			ARRAY_SIZE(sw_stats_desc)
@@ -144,6 +170,8 @@ static void mlx5e_grp_sw_update_stats(struct mlx5e_priv *priv)
 			&priv->channel_stats[i];
 		struct mlx5e_xdpsq_stats *xdpsq_red_stats = &channel_stats->xdpsq;
 		struct mlx5e_xdpsq_stats *xdpsq_stats = &channel_stats->rq_xdpsq;
+		struct mlx5e_xdpsq_stats *xsksq_stats = &channel_stats->xsksq;
+		struct mlx5e_rq_stats *xskrq_stats = &channel_stats->xskrq;
 		struct mlx5e_rq_stats *rq_stats = &channel_stats->rq;
 		struct mlx5e_ch_stats *ch_stats = &channel_stats->ch;
 		int j;
@@ -186,6 +214,7 @@ static void mlx5e_grp_sw_update_stats(struct mlx5e_priv *priv)
 		s->ch_poll        += ch_stats->poll;
 		s->ch_arm         += ch_stats->arm;
 		s->ch_aff_change  += ch_stats->aff_change;
+		s->ch_force_irq   += ch_stats->force_irq;
 		s->ch_eq_rearm    += ch_stats->eq_rearm;
 		/* xdp redirect */
 		s->tx_xdp_xmit    += xdpsq_red_stats->xmit;
@@ -194,6 +223,32 @@ static void mlx5e_grp_sw_update_stats(struct mlx5e_priv *priv)
 		s->tx_xdp_full    += xdpsq_red_stats->full;
 		s->tx_xdp_err     += xdpsq_red_stats->err;
 		s->tx_xdp_cqes    += xdpsq_red_stats->cqes;
+		/* AF_XDP zero-copy */
+		s->rx_xsk_packets                += xskrq_stats->packets;
+		s->rx_xsk_bytes                  += xskrq_stats->bytes;
+		s->rx_xsk_csum_complete          += xskrq_stats->csum_complete;
+		s->rx_xsk_csum_unnecessary       += xskrq_stats->csum_unnecessary;
+		s->rx_xsk_csum_unnecessary_inner += xskrq_stats->csum_unnecessary_inner;
+		s->rx_xsk_csum_none              += xskrq_stats->csum_none;
+		s->rx_xsk_ecn_mark               += xskrq_stats->ecn_mark;
+		s->rx_xsk_removed_vlan_packets   += xskrq_stats->removed_vlan_packets;
+		s->rx_xsk_xdp_drop               += xskrq_stats->xdp_drop;
+		s->rx_xsk_xdp_redirect           += xskrq_stats->xdp_redirect;
+		s->rx_xsk_wqe_err                += xskrq_stats->wqe_err;
+		s->rx_xsk_mpwqe_filler_cqes      += xskrq_stats->mpwqe_filler_cqes;
+		s->rx_xsk_mpwqe_filler_strides   += xskrq_stats->mpwqe_filler_strides;
+		s->rx_xsk_oversize_pkts_sw_drop  += xskrq_stats->oversize_pkts_sw_drop;
+		s->rx_xsk_buff_alloc_err         += xskrq_stats->buff_alloc_err;
+		s->rx_xsk_cqe_compress_blks      += xskrq_stats->cqe_compress_blks;
+		s->rx_xsk_cqe_compress_pkts      += xskrq_stats->cqe_compress_pkts;
+		s->rx_xsk_congst_umr             += xskrq_stats->congst_umr;
+		s->rx_xsk_arfs_err               += xskrq_stats->arfs_err;
+		s->tx_xsk_xmit                   += xsksq_stats->xmit;
+		s->tx_xsk_mpwqe                  += xsksq_stats->mpwqe;
+		s->tx_xsk_inlnw                  += xsksq_stats->inlnw;
+		s->tx_xsk_full                   += xsksq_stats->full;
+		s->tx_xsk_err                    += xsksq_stats->err;
+		s->tx_xsk_cqes                   += xsksq_stats->cqes;
 
 		for (j = 0; j < priv->max_opened_tc; j++) {
 			struct mlx5e_sq_stats *sq_stats = &channel_stats->sq[j];
@@ -1266,11 +1321,43 @@ static int mlx5e_grp_tls_fill_stats(struct mlx5e_priv *priv, u64 *data, int idx)
 	{ MLX5E_DECLARE_XDPSQ_STAT(struct mlx5e_xdpsq_stats, cqes) },
 };
 
+static const struct counter_desc xskrq_stats_desc[] = {
+	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, packets) },
+	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, bytes) },
+	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, csum_complete) },
+	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, csum_unnecessary) },
+	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, csum_unnecessary_inner) },
+	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, csum_none) },
+	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, ecn_mark) },
+	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, removed_vlan_packets) },
+	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, xdp_drop) },
+	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, xdp_redirect) },
+	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, wqe_err) },
+	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, mpwqe_filler_cqes) },
+	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, mpwqe_filler_strides) },
+	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, oversize_pkts_sw_drop) },
+	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, buff_alloc_err) },
+	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, cqe_compress_blks) },
+	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, cqe_compress_pkts) },
+	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, congst_umr) },
+	{ MLX5E_DECLARE_XSKRQ_STAT(struct mlx5e_rq_stats, arfs_err) },
+};
+
+static const struct counter_desc xsksq_stats_desc[] = {
+	{ MLX5E_DECLARE_XSKSQ_STAT(struct mlx5e_xdpsq_stats, xmit) },
+	{ MLX5E_DECLARE_XSKSQ_STAT(struct mlx5e_xdpsq_stats, mpwqe) },
+	{ MLX5E_DECLARE_XSKSQ_STAT(struct mlx5e_xdpsq_stats, inlnw) },
+	{ MLX5E_DECLARE_XSKSQ_STAT(struct mlx5e_xdpsq_stats, full) },
+	{ MLX5E_DECLARE_XSKSQ_STAT(struct mlx5e_xdpsq_stats, err) },
+	{ MLX5E_DECLARE_XSKSQ_STAT(struct mlx5e_xdpsq_stats, cqes) },
+};
+
 static const struct counter_desc ch_stats_desc[] = {
 	{ MLX5E_DECLARE_CH_STAT(struct mlx5e_ch_stats, events) },
 	{ MLX5E_DECLARE_CH_STAT(struct mlx5e_ch_stats, poll) },
 	{ MLX5E_DECLARE_CH_STAT(struct mlx5e_ch_stats, arm) },
 	{ MLX5E_DECLARE_CH_STAT(struct mlx5e_ch_stats, aff_change) },
+	{ MLX5E_DECLARE_CH_STAT(struct mlx5e_ch_stats, force_irq) },
 	{ MLX5E_DECLARE_CH_STAT(struct mlx5e_ch_stats, eq_rearm) },
 };
 
@@ -1278,6 +1365,8 @@ static int mlx5e_grp_tls_fill_stats(struct mlx5e_priv *priv, u64 *data, int idx)
 #define NUM_SQ_STATS			ARRAY_SIZE(sq_stats_desc)
 #define NUM_XDPSQ_STATS			ARRAY_SIZE(xdpsq_stats_desc)
 #define NUM_RQ_XDPSQ_STATS		ARRAY_SIZE(rq_xdpsq_stats_desc)
+#define NUM_XSKRQ_STATS			ARRAY_SIZE(xskrq_stats_desc)
+#define NUM_XSKSQ_STATS			ARRAY_SIZE(xsksq_stats_desc)
 #define NUM_CH_STATS			ARRAY_SIZE(ch_stats_desc)
 
 static int mlx5e_grp_channels_get_num_stats(struct mlx5e_priv *priv)
@@ -1288,13 +1377,16 @@ static int mlx5e_grp_channels_get_num_stats(struct mlx5e_priv *priv)
 	       (NUM_CH_STATS * max_nch) +
 	       (NUM_SQ_STATS * max_nch * priv->max_opened_tc) +
 	       (NUM_RQ_XDPSQ_STATS * max_nch) +
-	       (NUM_XDPSQ_STATS * max_nch);
+	       (NUM_XDPSQ_STATS * max_nch) +
+	       (NUM_XSKRQ_STATS * max_nch * priv->xsk.ever_used) +
+	       (NUM_XSKSQ_STATS * max_nch * priv->xsk.ever_used);
 }
 
 static int mlx5e_grp_channels_fill_strings(struct mlx5e_priv *priv, u8 *data,
 					   int idx)
 {
 	int max_nch = mlx5e_get_netdev_max_channels(priv->netdev);
+	bool is_xsk = priv->xsk.ever_used;
 	int i, j, tc;
 
 	for (i = 0; i < max_nch; i++)
@@ -1306,6 +1398,9 @@ static int mlx5e_grp_channels_fill_strings(struct mlx5e_priv *priv, u8 *data,
 		for (j = 0; j < NUM_RQ_STATS; j++)
 			sprintf(data + (idx++) * ETH_GSTRING_LEN,
 				rq_stats_desc[j].format, i);
+		for (j = 0; j < NUM_XSKRQ_STATS * is_xsk; j++)
+			sprintf(data + (idx++) * ETH_GSTRING_LEN,
+				xskrq_stats_desc[j].format, i);
 		for (j = 0; j < NUM_RQ_XDPSQ_STATS; j++)
 			sprintf(data + (idx++) * ETH_GSTRING_LEN,
 				rq_xdpsq_stats_desc[j].format, i);
@@ -1318,10 +1413,14 @@ static int mlx5e_grp_channels_fill_strings(struct mlx5e_priv *priv, u8 *data,
 					sq_stats_desc[j].format,
 					priv->channel_tc2txq[i][tc]);
 
-	for (i = 0; i < max_nch; i++)
+	for (i = 0; i < max_nch; i++) {
+		for (j = 0; j < NUM_XSKSQ_STATS * is_xsk; j++)
+			sprintf(data + (idx++) * ETH_GSTRING_LEN,
+				xsksq_stats_desc[j].format, i);
 		for (j = 0; j < NUM_XDPSQ_STATS; j++)
 			sprintf(data + (idx++) * ETH_GSTRING_LEN,
 				xdpsq_stats_desc[j].format, i);
+	}
 
 	return idx;
 }
@@ -1330,6 +1429,7 @@ static int mlx5e_grp_channels_fill_stats(struct mlx5e_priv *priv, u64 *data,
 					 int idx)
 {
 	int max_nch = mlx5e_get_netdev_max_channels(priv->netdev);
+	bool is_xsk = priv->xsk.ever_used;
 	int i, j, tc;
 
 	for (i = 0; i < max_nch; i++)
@@ -1343,6 +1443,10 @@ static int mlx5e_grp_channels_fill_stats(struct mlx5e_priv *priv, u64 *data,
 			data[idx++] =
 				MLX5E_READ_CTR64_CPU(&priv->channel_stats[i].rq,
 						     rq_stats_desc, j);
+		for (j = 0; j < NUM_XSKRQ_STATS * is_xsk; j++)
+			data[idx++] =
+				MLX5E_READ_CTR64_CPU(&priv->channel_stats[i].xskrq,
+						     xskrq_stats_desc, j);
 		for (j = 0; j < NUM_RQ_XDPSQ_STATS; j++)
 			data[idx++] =
 				MLX5E_READ_CTR64_CPU(&priv->channel_stats[i].rq_xdpsq,
@@ -1356,11 +1460,16 @@ static int mlx5e_grp_channels_fill_stats(struct mlx5e_priv *priv, u64 *data,
 					MLX5E_READ_CTR64_CPU(&priv->channel_stats[i].sq[tc],
 							     sq_stats_desc, j);
 
-	for (i = 0; i < max_nch; i++)
+	for (i = 0; i < max_nch; i++) {
+		for (j = 0; j < NUM_XSKSQ_STATS * is_xsk; j++)
+			data[idx++] =
+				MLX5E_READ_CTR64_CPU(&priv->channel_stats[i].xsksq,
+						     xsksq_stats_desc, j);
 		for (j = 0; j < NUM_XDPSQ_STATS; j++)
 			data[idx++] =
 				MLX5E_READ_CTR64_CPU(&priv->channel_stats[i].xdpsq,
 						     xdpsq_stats_desc, j);
+	}
 
 	return idx;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index cdddcc46971b..fb3ad7231e11 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -46,6 +46,8 @@
 #define MLX5E_DECLARE_TX_STAT(type, fld) "tx%d_"#fld, offsetof(type, fld)
 #define MLX5E_DECLARE_XDPSQ_STAT(type, fld) "tx%d_xdp_"#fld, offsetof(type, fld)
 #define MLX5E_DECLARE_RQ_XDPSQ_STAT(type, fld) "rx%d_xdp_tx_"#fld, offsetof(type, fld)
+#define MLX5E_DECLARE_XSKRQ_STAT(type, fld) "rx%d_xsk_"#fld, offsetof(type, fld)
+#define MLX5E_DECLARE_XSKSQ_STAT(type, fld) "tx%d_xsk_"#fld, offsetof(type, fld)
 #define MLX5E_DECLARE_CH_STAT(type, fld) "ch%d_"#fld, offsetof(type, fld)
 
 struct counter_desc {
@@ -116,12 +118,39 @@ struct mlx5e_sw_stats {
 	u64 ch_poll;
 	u64 ch_arm;
 	u64 ch_aff_change;
+	u64 ch_force_irq;
 	u64 ch_eq_rearm;
 
 #ifdef CONFIG_MLX5_EN_TLS
 	u64 tx_tls_ooo;
 	u64 tx_tls_resync_bytes;
 #endif
+
+	u64 rx_xsk_packets;
+	u64 rx_xsk_bytes;
+	u64 rx_xsk_csum_complete;
+	u64 rx_xsk_csum_unnecessary;
+	u64 rx_xsk_csum_unnecessary_inner;
+	u64 rx_xsk_csum_none;
+	u64 rx_xsk_ecn_mark;
+	u64 rx_xsk_removed_vlan_packets;
+	u64 rx_xsk_xdp_drop;
+	u64 rx_xsk_xdp_redirect;
+	u64 rx_xsk_wqe_err;
+	u64 rx_xsk_mpwqe_filler_cqes;
+	u64 rx_xsk_mpwqe_filler_strides;
+	u64 rx_xsk_oversize_pkts_sw_drop;
+	u64 rx_xsk_buff_alloc_err;
+	u64 rx_xsk_cqe_compress_blks;
+	u64 rx_xsk_cqe_compress_pkts;
+	u64 rx_xsk_congst_umr;
+	u64 rx_xsk_arfs_err;
+	u64 tx_xsk_xmit;
+	u64 tx_xsk_mpwqe;
+	u64 tx_xsk_inlnw;
+	u64 tx_xsk_full;
+	u64 tx_xsk_err;
+	u64 tx_xsk_cqes;
 };
 
 struct mlx5e_qcounter_stats {
@@ -256,6 +285,7 @@ struct mlx5e_ch_stats {
 	u64 poll;
 	u64 arm;
 	u64 aff_change;
+	u64 force_irq;
 	u64 eq_rearm;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index d2b8ce5df59c..9ae327e80d6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -33,6 +33,7 @@
 #include <linux/irq.h>
 #include "en.h"
 #include "en/xdp.h"
+#include "en/xsk/tx.h"
 
 static inline bool mlx5e_channel_no_affinity_change(struct mlx5e_channel *c)
 {
@@ -87,7 +88,12 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 	struct mlx5e_channel *c = container_of(napi, struct mlx5e_channel,
 					       napi);
 	struct mlx5e_ch_stats *ch_stats = c->stats;
+	struct mlx5e_xdpsq *xsksq = &c->xsksq;
+	struct mlx5e_rq *xskrq = &c->xskrq;
 	struct mlx5e_rq *rq = &c->rq;
+	bool xsk_open = test_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
+	bool aff_change = false;
+	bool busy_xsk = false;
 	bool busy = false;
 	int work_done = 0;
 	int i;
@@ -103,18 +109,32 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 		busy |= mlx5e_poll_xdpsq_cq(&c->rq_xdpsq.cq);
 
 	if (likely(budget)) { /* budget=0 means: don't poll rx rings */
-		work_done = mlx5e_poll_rx_cq(&rq->cq, budget);
+		if (xsk_open)
+			work_done = mlx5e_poll_rx_cq(&xskrq->cq, budget);
+
+		if (likely(budget - work_done))
+			work_done += mlx5e_poll_rx_cq(&rq->cq, budget - work_done);
+
 		busy |= work_done == budget;
 	}
 
 	mlx5e_poll_ico_cq(&c->icosq.cq);
 
 	busy |= rq->post_wqes(rq);
+	if (xsk_open) {
+		mlx5e_poll_ico_cq(&c->xskicosq.cq);
+		busy |= mlx5e_poll_xdpsq_cq(&xsksq->cq);
+		busy_xsk |= mlx5e_xsk_tx(xsksq, MLX5E_TX_XSK_POLL_BUDGET);
+		busy_xsk |= xskrq->post_wqes(xskrq);
+	}
+
+	busy |= busy_xsk;
 
 	if (busy) {
 		if (likely(mlx5e_channel_no_affinity_change(c)))
 			return budget;
 		ch_stats->aff_change++;
+		aff_change = true;
 		if (budget && work_done == budget)
 			work_done--;
 	}
@@ -135,6 +155,18 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 	mlx5e_cq_arm(&c->icosq.cq);
 	mlx5e_cq_arm(&c->xdpsq.cq);
 
+	if (xsk_open) {
+		mlx5e_handle_rx_dim(xskrq);
+		mlx5e_cq_arm(&c->xskicosq.cq);
+		mlx5e_cq_arm(&xsksq->cq);
+		mlx5e_cq_arm(&xskrq->cq);
+	}
+
+	if (unlikely(aff_change && busy_xsk)) {
+		mlx5e_trigger_irq(&c->icosq);
+		ch_stats->force_irq++;
+	}
+
 	return work_done;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 9ca492b430d8..da81a5a7b8e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -87,7 +87,7 @@ int mlx5i_init(struct mlx5_core_dev *mdev,
 	mlx5e_set_netdev_mtu_boundaries(priv);
 	netdev->mtu = netdev->max_mtu;
 
-	mlx5e_build_nic_params(mdev, &priv->rss_params, &priv->channels.params,
+	mlx5e_build_nic_params(mdev, NULL, &priv->rss_params, &priv->channels.params,
 			       mlx5e_get_netdev_max_channels(netdev),
 			       netdev->mtu);
 	mlx5i_build_nic_params(mdev, &priv->channels.params);
@@ -365,7 +365,7 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_close_drop_rq;
 
-	err = mlx5e_create_direct_rqts(priv);
+	err = mlx5e_create_direct_rqts(priv, priv->direct_tir);
 	if (err)
 		goto err_destroy_indirect_rqts;
 
@@ -373,7 +373,7 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_direct_rqts;
 
-	err = mlx5e_create_direct_tirs(priv);
+	err = mlx5e_create_direct_tirs(priv, priv->direct_tir);
 	if (err)
 		goto err_destroy_indirect_tirs;
 
@@ -384,11 +384,11 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	return 0;
 
 err_destroy_direct_tirs:
-	mlx5e_destroy_direct_tirs(priv);
+	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
 err_destroy_indirect_tirs:
 	mlx5e_destroy_indirect_tirs(priv, true);
 err_destroy_direct_rqts:
-	mlx5e_destroy_direct_rqts(priv);
+	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 err_destroy_indirect_rqts:
 	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
 err_close_drop_rq:
@@ -401,9 +401,9 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 static void mlx5i_cleanup_rx(struct mlx5e_priv *priv)
 {
 	mlx5i_destroy_flow_steering(priv);
-	mlx5e_destroy_direct_tirs(priv);
+	mlx5e_destroy_direct_tirs(priv, priv->direct_tir);
 	mlx5e_destroy_indirect_tirs(priv, true);
-	mlx5e_destroy_direct_rqts(priv);
+	mlx5e_destroy_direct_rqts(priv, priv->direct_tir);
 	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
 	mlx5e_destroy_q_counters(priv);
-- 
1.8.3.1

