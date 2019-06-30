Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07E5C5AED1
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 08:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfF3GGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 02:06:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46259 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbfF3GGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 02:06:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DC35B21470;
        Sun, 30 Jun 2019 02:06:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 30 Jun 2019 02:06:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=GDb3tvUuSj6ND3CilhwuWzkWuzYtPL3egJcMPTtmJcA=; b=A943BEu0
        lOJLNgDPfdbQA4VfCPeEmpChQ/DWKDXEWlwACWYi/IHz832ovaGuSJrDuqoaGagu
        YsSWnHqQImwviDQt9kRBbFmMDN/vB0aLeE3JM4TyKOHrSLPQB1rWd7Whz0MLBdgG
        b8V6AT8zwRx7e0tjYPoCyRoxmgiJMMEIZPIEGBcj9yCE4B0aFLlKEbZSIoZVol2C
        OUqufnAgIgmInj8l7xv+UfAqgjKQYKKATDfdt6Lw714N3joGKPOXlV4/uLlrz+01
        bgltLy5gA/Cvy+A2P/dkVxPUJAJQSSR1t/HFq3201Yfh3z6V7dRdteJVHmgSki3D
        Hy9dtjmrFFihLA==
X-ME-Sender: <xms:TlEYXQv17umzARRATvlgh7lFVcRoo4Kbs-304nztQKHJugn2aP55rg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdefgddutddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeek
X-ME-Proxy: <xmx:TlEYXQk6Lo7iuBSxh9XqtpuMH6YrrG6xRZN5Dd-H8XMGFO7MGGR62g>
    <xmx:TlEYXZNdX4RfIP4VBrh85NyrYtD2aGrIMRh1euXF71JwMhDvLFLf-A>
    <xmx:TlEYXXxoU9fJrJ7rBa2gjuyYHt5aKIEI-WP1bJdLA_WCJc7tvJrwRw>
    <xmx:TlEYXQGPhlSJ5JCRpR7slEwO2KOO5-sFSu1HwFrAXcyxKGRRYvI12g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 708788005A;
        Sun, 30 Jun 2019 02:06:04 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 10/16] mlxsw: spectrum: PTP: Add PTP initialization / finalization
Date:   Sun, 30 Jun 2019 09:04:54 +0300
Message-Id: <20190630060500.7882-11-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190630060500.7882-1-idosch@idosch.org>
References: <20190630060500.7882-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Add two ptp_ops: init and fini, to initialize and finalize the PTP
subsystem. Call as appropriate from mlxsw_sp_init() and _fini().

Lay the groundwork for Spectrum-1 support. On Spectrum-1, the received
timestamped packets and their corresponding timestamps arrive
independently, and need to be matched up. Introduce the related data types
and add to struct mlxsw_sp_ptp_state the hash table that will keep the
unmatched entries.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 24 ++++++-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  2 +
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 70 +++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    | 29 +++++++-
 4 files changed, 122 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 6a907e491868..6cb7aeac0657 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -152,6 +152,9 @@ struct mlxsw_sp_ptp_ops {
 		(*clock_init)(struct mlxsw_sp *mlxsw_sp, struct device *dev);
 	void (*clock_fini)(struct mlxsw_sp_ptp_clock *clock);
 
+	struct mlxsw_sp_ptp_state *(*init)(struct mlxsw_sp *mlxsw_sp);
+	void (*fini)(struct mlxsw_sp_ptp_state *ptp_state);
+
 	/* Notify a driver that a packet that might be PTP was received. Driver
 	 * is responsible for freeing the passed-in SKB.
 	 */
@@ -4429,6 +4432,8 @@ static int mlxsw_sp_basic_trap_groups_set(struct mlxsw_core *mlxsw_core)
 static const struct mlxsw_sp_ptp_ops mlxsw_sp1_ptp_ops = {
 	.clock_init	= mlxsw_sp1_ptp_clock_init,
 	.clock_fini	= mlxsw_sp1_ptp_clock_fini,
+	.init		= mlxsw_sp1_ptp_init,
+	.fini		= mlxsw_sp1_ptp_fini,
 	.receive	= mlxsw_sp1_ptp_receive,
 	.transmitted	= mlxsw_sp1_ptp_transmitted,
 };
@@ -4436,6 +4441,8 @@ static const struct mlxsw_sp_ptp_ops mlxsw_sp1_ptp_ops = {
 static const struct mlxsw_sp_ptp_ops mlxsw_sp2_ptp_ops = {
 	.clock_init	= mlxsw_sp2_ptp_clock_init,
 	.clock_fini	= mlxsw_sp2_ptp_clock_fini,
+	.init		= mlxsw_sp2_ptp_init,
+	.fini		= mlxsw_sp2_ptp_fini,
 	.receive	= mlxsw_sp2_ptp_receive,
 	.transmitted	= mlxsw_sp2_ptp_transmitted,
 };
@@ -4549,6 +4556,16 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 		}
 	}
 
+	if (mlxsw_sp->clock) {
+		/* NULL is a valid return value from ptp_ops->init */
+		mlxsw_sp->ptp_state = mlxsw_sp->ptp_ops->init(mlxsw_sp);
+		if (IS_ERR(mlxsw_sp->ptp_state)) {
+			err = PTR_ERR(mlxsw_sp->ptp_state);
+			dev_err(mlxsw_sp->bus_info->dev, "Failed to initialize PTP\n");
+			goto err_ptp_init;
+		}
+	}
+
 	/* Initialize netdevice notifier after router and SPAN is initialized,
 	 * so that the event handler can use router structures and call SPAN
 	 * respin.
@@ -4579,6 +4596,9 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 err_dpipe_init:
 	unregister_netdevice_notifier(&mlxsw_sp->netdevice_nb);
 err_netdev_notifier:
+	if (mlxsw_sp->clock)
+		mlxsw_sp->ptp_ops->fini(mlxsw_sp->ptp_state);
+err_ptp_init:
 	if (mlxsw_sp->clock)
 		mlxsw_sp->ptp_ops->clock_fini(mlxsw_sp->clock);
 err_ptp_clock_init:
@@ -4659,8 +4679,10 @@ static void mlxsw_sp_fini(struct mlxsw_core *mlxsw_core)
 	mlxsw_sp_ports_remove(mlxsw_sp);
 	mlxsw_sp_dpipe_fini(mlxsw_sp);
 	unregister_netdevice_notifier(&mlxsw_sp->netdevice_nb);
-	if (mlxsw_sp->clock)
+	if (mlxsw_sp->clock) {
+		mlxsw_sp->ptp_ops->fini(mlxsw_sp->ptp_state);
 		mlxsw_sp->ptp_ops->clock_fini(mlxsw_sp->clock);
+	}
 	mlxsw_sp_router_fini(mlxsw_sp);
 	mlxsw_sp_acl_fini(mlxsw_sp);
 	mlxsw_sp_nve_fini(mlxsw_sp);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 139fb1c53f96..7e1808179a2a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -136,6 +136,7 @@ struct mlxsw_sp_acl_tcam_ops;
 struct mlxsw_sp_nve_ops;
 struct mlxsw_sp_sb_vals;
 struct mlxsw_sp_port_type_speed_ops;
+struct mlxsw_sp_ptp_state;
 struct mlxsw_sp_ptp_ops;
 
 struct mlxsw_sp {
@@ -157,6 +158,7 @@ struct mlxsw_sp {
 	struct mlxsw_sp_nve *nve;
 	struct notifier_block netdevice_nb;
 	struct mlxsw_sp_ptp_clock *clock;
+	struct mlxsw_sp_ptp_state *ptp_state;
 
 	struct mlxsw_sp_counter_pool *counter_pool;
 	struct {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 3af4573a4261..6725a4d53f87 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -7,6 +7,7 @@
 #include <linux/spinlock.h>
 #include <linux/device.h>
 
+#include "spectrum.h"
 #include "spectrum_ptp.h"
 #include "core.h"
 
@@ -14,6 +15,33 @@
 #define MLXSW_SP1_PTP_CLOCK_FREQ_KHZ		156257 /* 6.4nSec */
 #define MLXSW_SP1_PTP_CLOCK_MASK		64
 
+struct mlxsw_sp_ptp_state {
+	struct rhashtable unmatched_ht;
+	spinlock_t unmatched_lock; /* protects the HT */
+};
+
+struct mlxsw_sp1_ptp_key {
+	u8 local_port;
+	u8 message_type;
+	u16 sequence_id;
+	u8 domain_number;
+	bool ingress;
+};
+
+struct mlxsw_sp1_ptp_unmatched {
+	struct mlxsw_sp1_ptp_key key;
+	struct rhash_head ht_node;
+	struct rcu_head rcu;
+	struct sk_buff *skb;
+	u64 timestamp;
+};
+
+static const struct rhashtable_params mlxsw_sp1_ptp_unmatched_ht_params = {
+	.key_len = sizeof_field(struct mlxsw_sp1_ptp_unmatched, key),
+	.key_offset = offsetof(struct mlxsw_sp1_ptp_unmatched, key),
+	.head_offset = offsetof(struct mlxsw_sp1_ptp_unmatched, ht_node),
+};
+
 struct mlxsw_sp_ptp_clock {
 	struct mlxsw_core *core;
 	spinlock_t lock; /* protect this structure */
@@ -265,6 +293,18 @@ void mlxsw_sp1_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock)
 	kfree(clock);
 }
 
+static void mlxsw_sp1_ptp_unmatched_free_fn(void *ptr, void *arg)
+{
+	struct mlxsw_sp1_ptp_unmatched *unmatched = ptr;
+
+	/* This is invoked at a point where the ports are gone already. Nothing
+	 * to do with whatever is left in the HT but to free it.
+	 */
+	if (unmatched->skb)
+		dev_kfree_skb_any(unmatched->skb);
+	kfree_rcu(unmatched, rcu);
+}
+
 void mlxsw_sp1_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
 			   u8 local_port)
 {
@@ -276,3 +316,33 @@ void mlxsw_sp1_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
 {
 	dev_kfree_skb_any(skb);
 }
+
+struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
+{
+	struct mlxsw_sp_ptp_state *ptp_state;
+	int err;
+
+	ptp_state = kzalloc(sizeof(*ptp_state), GFP_KERNEL);
+	if (!ptp_state)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock_init(&ptp_state->unmatched_lock);
+
+	err = rhashtable_init(&ptp_state->unmatched_ht,
+			      &mlxsw_sp1_ptp_unmatched_ht_params);
+	if (err)
+		goto err_hashtable_init;
+
+	return ptp_state;
+
+err_hashtable_init:
+	kfree(ptp_state);
+	return ERR_PTR(err);
+}
+
+void mlxsw_sp1_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state)
+{
+	rhashtable_free_and_destroy(&ptp_state->unmatched_ht,
+				    &mlxsw_sp1_ptp_unmatched_free_fn, NULL);
+	kfree(ptp_state);
+}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
index 84955aa79c01..0f66e63e229c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -5,9 +5,10 @@
 #define _MLXSW_SPECTRUM_PTP_H
 
 #include <linux/device.h>
+#include <linux/rhashtable.h>
 
-#include "spectrum.h"
-
+struct mlxsw_sp;
+struct mlxsw_sp_port;
 struct mlxsw_sp_ptp_clock;
 
 #if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
@@ -17,6 +18,10 @@ mlxsw_sp1_ptp_clock_init(struct mlxsw_sp *mlxsw_sp, struct device *dev);
 
 void mlxsw_sp1_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock);
 
+struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp);
+
+void mlxsw_sp1_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state);
+
 void mlxsw_sp1_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
 			   u8 local_port);
 
@@ -35,6 +40,16 @@ static inline void mlxsw_sp1_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock)
 {
 }
 
+static inline struct mlxsw_sp_ptp_state *
+mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
+{
+	return NULL;
+}
+
+static inline void mlxsw_sp1_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state)
+{
+}
+
 static inline void mlxsw_sp1_ptp_receive(struct mlxsw_sp *mlxsw_sp,
 					 struct sk_buff *skb, u8 local_port)
 {
@@ -59,6 +74,16 @@ static inline void mlxsw_sp2_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock)
 {
 }
 
+static inline struct mlxsw_sp_ptp_state *
+mlxsw_sp2_ptp_init(struct mlxsw_sp *mlxsw_sp)
+{
+	return NULL;
+}
+
+static inline void mlxsw_sp2_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state)
+{
+}
+
 static inline void mlxsw_sp2_ptp_receive(struct mlxsw_sp *mlxsw_sp,
 					 struct sk_buff *skb, u8 local_port)
 {
-- 
2.20.1

