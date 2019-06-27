Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4794583E8
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfF0Nx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:53:56 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60805 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727048AbfF0Nxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 09:53:54 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2AAE721F30;
        Thu, 27 Jun 2019 09:53:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 27 Jun 2019 09:53:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=QO+urkiC8WK9bqolAPZOeortIZlnIlIAk6HGntb6FGw=; b=W8rVK5em
        rwy/bdQTEd7M/A5308RuF4Ftt2eh1R6a1gcI2qa0sRQvb3W609qXNOZZ6IAGzfVT
        8adYRAI4BsQh99aQn118QGeH7KvPFCj6WpXQJAvM8TKwyeZMuOcaFyqY7F4DgKIY
        zl5fqjqXIlZec5MfJBelk+QLKlj8uKE8LKo0gr93HYNKL3ZHWE9KEBaENe27MtbB
        qt1BbC74w68Hpf4UVLGtS9bCzmIr96GiP08+dad8qa0zwoK3drv2COnmTvrd/Ddy
        QDns+7QObl4kJWHY6tZMZjC5Puy4H9Cx9PotQmS1cRLHmJNdDjOxMz51pdxSSz8p
        zUSv88x8I8bYXw==
X-ME-Sender: <xms:ccoUXYW2mOCYCXm5fCxmiyZvIHbOUFuNKR3OHBgAwgdNeuJBdZYUAQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudekgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepke
X-ME-Proxy: <xmx:csoUXX9T3ItiJhBlUU-XMFQABYOQnfjpNfrzhlY9SFMYVE1YeEJUXw>
    <xmx:csoUXVytmMdOUAfS5fH2I8ELazr9jT9XO90hCsJfKZj8moms6htBbA>
    <xmx:csoUXfG__TNjhsEWl2UPqJej3Zjthfs-oYLQdOFZQBj5Pzw1qU_pNw>
    <xmx:csoUXYGiD20XG7ESLd10FJZBWfbxtMGxV6yCORsii7iLWqikZQfF4w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8B5778005A;
        Thu, 27 Jun 2019 09:53:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 09/16] mlxsw: pci: PTP: Hook into packet transmit path
Date:   Thu, 27 Jun 2019 16:52:52 +0300
Message-Id: <20190627135259.7292-10-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627135259.7292-1-idosch@idosch.org>
References: <20190627135259.7292-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

On Spectrum-1, timestamps are delivered separately from the packets, and
need to paired up. Therefore, at some point after mlxsw_sp_port_xmit()
is invoked, it is necessary to involve the chip-specific driver code to
allow it to do the necessary bookkeeping and matching.

On Spectrum-2, timestamps are delivered in CQE. For that reason,
position the point of driver involvement into mlxsw_pci_cqe_sdq_handle()
to make it hopefully easier to extend for Spectrum-2 in the future.

To tell the driver what port the packet was sent on, keep tx_info
in SKB control buffer.

Introduce a new driver core interface mlxsw_core_ptp_transmitted(), a
driver callback ptp_transmitted, and a PTP op transmitted. The callee is
responsible for taking care of releasing the SKB passed to the new
interfaces, and correspondingly have the new stub callbacks just call
dev_kfree_skb_any().

Follow-up patches will introduce the actual content into
mlxsw_sp1_ptp_transmitted() in particular.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  9 +++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h    | 10 ++++++++++
 drivers/net/ethernet/mellanox/mlxsw/pci.c     | 17 ++++++++++++++++-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 19 +++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    |  6 ++++++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    | 15 +++++++++++++++
 6 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 30e0526a9cf6..17ceac7505e5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1245,6 +1245,15 @@ int mlxsw_core_skb_transmit(struct mlxsw_core *mlxsw_core, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(mlxsw_core_skb_transmit);
 
+void mlxsw_core_ptp_transmitted(struct mlxsw_core *mlxsw_core,
+				struct sk_buff *skb, u8 local_port)
+{
+	if (mlxsw_core->driver->ptp_transmitted)
+		mlxsw_core->driver->ptp_transmitted(mlxsw_core, skb,
+						    local_port);
+}
+EXPORT_SYMBOL(mlxsw_core_ptp_transmitted);
+
 static bool __is_rx_listener_equal(const struct mlxsw_rx_listener *rxl_a,
 				   const struct mlxsw_rx_listener *rxl_b)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 06babcc58c7a..8efcff4b59cb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -48,6 +48,8 @@ bool mlxsw_core_skb_transmit_busy(struct mlxsw_core *mlxsw_core,
 				  const struct mlxsw_tx_info *tx_info);
 int mlxsw_core_skb_transmit(struct mlxsw_core *mlxsw_core, struct sk_buff *skb,
 			    const struct mlxsw_tx_info *tx_info);
+void mlxsw_core_ptp_transmitted(struct mlxsw_core *mlxsw_core,
+				struct sk_buff *skb, u8 local_port);
 
 struct mlxsw_rx_listener {
 	void (*func)(struct sk_buff *skb, u8 local_port, void *priv);
@@ -296,6 +298,13 @@ struct mlxsw_driver {
 			     u64 *p_linear_size);
 	int (*params_register)(struct mlxsw_core *mlxsw_core);
 	void (*params_unregister)(struct mlxsw_core *mlxsw_core);
+
+	/* Notify a driver that a timestamped packet was transmitted. Driver
+	 * is responsible for freeing the passed-in SKB.
+	 */
+	void (*ptp_transmitted)(struct mlxsw_core *mlxsw_core,
+				struct sk_buff *skb, u8 local_port);
+
 	u8 txhdr_len;
 	const struct mlxsw_config_profile *profile;
 	bool res_query_enabled;
@@ -419,6 +428,7 @@ enum mlxsw_devlink_param_id {
 };
 
 struct mlxsw_skb_cb {
+	struct mlxsw_tx_info tx_info;
 };
 
 static inline struct mlxsw_skb_cb *mlxsw_skb_cb(struct sk_buff *skb)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 6acb9bbfdf89..051b19388a81 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -508,17 +508,28 @@ static void mlxsw_pci_cqe_sdq_handle(struct mlxsw_pci *mlxsw_pci,
 {
 	struct pci_dev *pdev = mlxsw_pci->pdev;
 	struct mlxsw_pci_queue_elem_info *elem_info;
+	struct mlxsw_tx_info tx_info;
 	char *wqe;
 	struct sk_buff *skb;
 	int i;
 
 	spin_lock(&q->lock);
 	elem_info = mlxsw_pci_queue_elem_info_consumer_get(q);
+	tx_info = mlxsw_skb_cb(elem_info->u.sdq.skb)->tx_info;
 	skb = elem_info->u.sdq.skb;
 	wqe = elem_info->elem;
 	for (i = 0; i < MLXSW_PCI_WQE_SG_ENTRIES; i++)
 		mlxsw_pci_wqe_frag_unmap(mlxsw_pci, wqe, i, DMA_TO_DEVICE);
-	dev_kfree_skb_any(skb);
+
+	if (unlikely(!tx_info.is_emad &&
+		     skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
+		mlxsw_core_ptp_transmitted(mlxsw_pci->core, skb,
+					   tx_info.local_port);
+		skb = NULL;
+	}
+
+	if (skb)
+		dev_kfree_skb_any(skb);
 	elem_info->u.sdq.skb = NULL;
 
 	if (q->consumer_counter++ != consumer_counter_limit)
@@ -1548,6 +1559,7 @@ static int mlxsw_pci_skb_transmit(void *bus_priv, struct sk_buff *skb,
 		err = -EAGAIN;
 		goto unlock;
 	}
+	mlxsw_skb_cb(skb)->tx_info = *tx_info;
 	elem_info->u.sdq.skb = skb;
 
 	wqe = elem_info->elem;
@@ -1571,6 +1583,9 @@ static int mlxsw_pci_skb_transmit(void *bus_priv, struct sk_buff *skb,
 			goto unmap_frags;
 	}
 
+	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
+		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+
 	/* Set unused sq entries byte count to zero. */
 	for (i++; i < MLXSW_PCI_WQE_SG_ENTRIES; i++)
 		mlxsw_pci_wqe_byte_count_set(wqe, i, 0);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index a0376d4f94a8..6a907e491868 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -157,6 +157,12 @@ struct mlxsw_sp_ptp_ops {
 	 */
 	void (*receive)(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
 			u8 local_port);
+
+	/* Notify a driver that a timestamped packet was transmitted. Driver
+	 * is responsible for freeing the passed-in SKB.
+	 */
+	void (*transmitted)(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
+			    u8 local_port);
 };
 
 static int mlxsw_sp_component_query(struct mlxfw_dev *mlxfw_dev,
@@ -4424,12 +4430,14 @@ static const struct mlxsw_sp_ptp_ops mlxsw_sp1_ptp_ops = {
 	.clock_init	= mlxsw_sp1_ptp_clock_init,
 	.clock_fini	= mlxsw_sp1_ptp_clock_fini,
 	.receive	= mlxsw_sp1_ptp_receive,
+	.transmitted	= mlxsw_sp1_ptp_transmitted,
 };
 
 static const struct mlxsw_sp_ptp_ops mlxsw_sp2_ptp_ops = {
 	.clock_init	= mlxsw_sp2_ptp_clock_init,
 	.clock_fini	= mlxsw_sp2_ptp_clock_fini,
 	.receive	= mlxsw_sp2_ptp_receive,
+	.transmitted	= mlxsw_sp2_ptp_transmitted,
 };
 
 static int mlxsw_sp_netdevice_event(struct notifier_block *unused,
@@ -4995,6 +5003,15 @@ static void mlxsw_sp2_params_unregister(struct mlxsw_core *mlxsw_core)
 	mlxsw_sp_params_unregister(mlxsw_core);
 }
 
+static void mlxsw_sp_ptp_transmitted(struct mlxsw_core *mlxsw_core,
+				     struct sk_buff *skb, u8 local_port)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+
+	skb_pull(skb, MLXSW_TXHDR_LEN);
+	mlxsw_sp->ptp_ops->transmitted(mlxsw_sp, skb, local_port);
+}
+
 static struct mlxsw_driver mlxsw_sp1_driver = {
 	.kind				= mlxsw_sp1_driver_name,
 	.priv_size			= sizeof(struct mlxsw_sp),
@@ -5019,6 +5036,7 @@ static struct mlxsw_driver mlxsw_sp1_driver = {
 	.kvd_sizes_get			= mlxsw_sp_kvd_sizes_get,
 	.params_register		= mlxsw_sp_params_register,
 	.params_unregister		= mlxsw_sp_params_unregister,
+	.ptp_transmitted		= mlxsw_sp_ptp_transmitted,
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp1_config_profile,
 	.res_query_enabled		= true,
@@ -5047,6 +5065,7 @@ static struct mlxsw_driver mlxsw_sp2_driver = {
 	.resources_register		= mlxsw_sp2_resources_register,
 	.params_register		= mlxsw_sp2_params_register,
 	.params_unregister		= mlxsw_sp2_params_unregister,
+	.ptp_transmitted		= mlxsw_sp_ptp_transmitted,
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp2_config_profile,
 	.res_query_enabled		= true,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 8eca1ac03e7a..3af4573a4261 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -270,3 +270,9 @@ void mlxsw_sp1_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
 {
 	mlxsw_sp_rx_listener_no_mark_func(skb, local_port, mlxsw_sp);
 }
+
+void mlxsw_sp1_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
+			       struct sk_buff *skb, u8 local_port)
+{
+	dev_kfree_skb_any(skb);
+}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
index 06bb303b5407..84955aa79c01 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -20,6 +20,9 @@ void mlxsw_sp1_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock);
 void mlxsw_sp1_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
 			   u8 local_port);
 
+void mlxsw_sp1_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
+			       struct sk_buff *skb, u8 local_port);
+
 #else
 
 static inline struct mlxsw_sp_ptp_clock *
@@ -38,6 +41,12 @@ static inline void mlxsw_sp1_ptp_receive(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_rx_listener_no_mark_func(skb, local_port, mlxsw_sp);
 }
 
+static inline void mlxsw_sp1_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
+					     struct sk_buff *skb, u8 local_port)
+{
+	dev_kfree_skb_any(skb);
+}
+
 #endif
 
 static inline struct mlxsw_sp_ptp_clock *
@@ -56,4 +65,10 @@ static inline void mlxsw_sp2_ptp_receive(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_rx_listener_no_mark_func(skb, local_port, mlxsw_sp);
 }
 
+static inline void mlxsw_sp2_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
+					     struct sk_buff *skb, u8 local_port)
+{
+	dev_kfree_skb_any(skb);
+}
+
 #endif
-- 
2.20.1

