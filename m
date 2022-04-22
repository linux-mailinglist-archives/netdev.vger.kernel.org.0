Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F7050BAF1
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 16:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351565AbiDVPB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449067AbiDVPB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:01:27 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4C055C355
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 07:58:28 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id BD30832025B;
        Fri, 22 Apr 2022 15:58:25 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhujn-00079A-LY; Fri, 22 Apr 2022 15:58:23 +0100
Subject: [PATCH net-next 06/28] sfc/siena: Rename functions in efx.h to
 avoid conflicts with sfc
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 15:58:22 +0100
Message-ID: <165063950269.27138.6939311760052632022.stgit@palantir17.mph.net>
In-Reply-To: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
References: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Habets <martinh@xilinx.com>

For siena use efx_siena_ as the function prefix.
efx_mtd_remove_partition can become static as it is no longer called
from other files.
efx_ticks_to_usecs and efx_xmit_done_single are not used in Siena, so
they are removed.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/efx.c        |   44 +++++++-----------
 drivers/net/ethernet/sfc/siena/efx.h        |   65 ++++++++++++---------------
 drivers/net/ethernet/sfc/siena/ethtool.c    |   10 ++--
 drivers/net/ethernet/sfc/siena/farch.c      |   12 ++---
 drivers/net/ethernet/sfc/siena/mtd.c        |   16 +++----
 drivers/net/ethernet/sfc/siena/net_driver.h |    7 +--
 drivers/net/ethernet/sfc/siena/rx.c         |   11 ++---
 drivers/net/ethernet/sfc/siena/rx_common.c  |    8 ++-
 drivers/net/ethernet/sfc/siena/rx_common.h  |    5 +-
 drivers/net/ethernet/sfc/siena/siena.c      |   10 ++--
 drivers/net/ethernet/sfc/siena/tx.c         |   61 +++++--------------------
 drivers/net/ethernet/sfc/siena/tx_common.c  |    6 +-
 drivers/net/ethernet/sfc/siena/tx_common.h  |    4 +-
 13 files changed, 103 insertions(+), 156 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index bc107aac3a8d..b488c2c3580e 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -310,8 +310,8 @@ static int efx_probe_nic(struct efx_nic *efx)
 
 	/* Initialise the interrupt moderation settings */
 	efx->irq_mod_step_us = DIV_ROUND_UP(efx->timer_quantum_ns, 1000);
-	efx_init_irq_moderation(efx, tx_irq_mod_usec, rx_irq_mod_usec, true,
-				true);
+	efx_siena_init_irq_moderation(efx, tx_irq_mod_usec, rx_irq_mod_usec,
+				      true, true);
 
 	return 0;
 
@@ -413,7 +413,7 @@ static void efx_remove_all(struct efx_nic *efx)
  * Interrupt moderation
  *
  **************************************************************************/
-unsigned int efx_usecs_to_ticks(struct efx_nic *efx, unsigned int usecs)
+unsigned int efx_siena_usecs_to_ticks(struct efx_nic *efx, unsigned int usecs)
 {
 	if (usecs == 0)
 		return 0;
@@ -422,18 +422,10 @@ unsigned int efx_usecs_to_ticks(struct efx_nic *efx, unsigned int usecs)
 	return usecs * 1000 / efx->timer_quantum_ns;
 }
 
-unsigned int efx_ticks_to_usecs(struct efx_nic *efx, unsigned int ticks)
-{
-	/* We must round up when converting ticks to microseconds
-	 * because we round down when converting the other way.
-	 */
-	return DIV_ROUND_UP(ticks * efx->timer_quantum_ns, 1000);
-}
-
 /* Set interrupt moderation parameters */
-int efx_init_irq_moderation(struct efx_nic *efx, unsigned int tx_usecs,
-			    unsigned int rx_usecs, bool rx_adaptive,
-			    bool rx_may_override_tx)
+int efx_siena_init_irq_moderation(struct efx_nic *efx, unsigned int tx_usecs,
+				  unsigned int rx_usecs, bool rx_adaptive,
+				  bool rx_may_override_tx)
 {
 	struct efx_channel *channel;
 	unsigned int timer_max_us;
@@ -466,8 +458,8 @@ int efx_init_irq_moderation(struct efx_nic *efx, unsigned int tx_usecs,
 	return 0;
 }
 
-void efx_get_irq_moderation(struct efx_nic *efx, unsigned int *tx_usecs,
-			    unsigned int *rx_usecs, bool *rx_adaptive)
+void efx_siena_get_irq_moderation(struct efx_nic *efx, unsigned int *tx_usecs,
+				  unsigned int *rx_usecs, bool *rx_adaptive)
 {
 	*rx_adaptive = efx->irq_rx_adaptive;
 	*rx_usecs = efx->irq_rx_moderation_us;
@@ -520,7 +512,7 @@ static int efx_ioctl(struct net_device *net_dev, struct ifreq *ifr, int cmd)
  *************************************************************************/
 
 /* Context: process, rtnl_lock() held. */
-int efx_net_open(struct net_device *net_dev)
+static int efx_net_open(struct net_device *net_dev)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	int rc;
@@ -551,7 +543,7 @@ int efx_net_open(struct net_device *net_dev)
  * Note that the kernel will ignore our return code; this method
  * should really be a void.
  */
-int efx_net_stop(struct net_device *net_dev)
+static int efx_net_stop(struct net_device *net_dev)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
@@ -589,7 +581,7 @@ static const struct net_device_ops efx_netdev_ops = {
 	.ndo_stop		= efx_net_stop,
 	.ndo_get_stats64	= efx_siena_net_stats,
 	.ndo_tx_timeout		= efx_siena_watchdog,
-	.ndo_start_xmit		= efx_hard_start_xmit,
+	.ndo_start_xmit		= efx_siena_hard_start_xmit,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_eth_ioctl		= efx_ioctl,
 	.ndo_change_mtu		= efx_siena_change_mtu,
@@ -608,7 +600,7 @@ static const struct net_device_ops efx_netdev_ops = {
 #endif
 	.ndo_get_phys_port_id   = efx_siena_get_phys_port_id,
 	.ndo_get_phys_port_name	= efx_siena_get_phys_port_name,
-	.ndo_setup_tc		= efx_setup_tc,
+	.ndo_setup_tc		= efx_siena_setup_tc,
 #ifdef CONFIG_RFS_ACCEL
 	.ndo_rx_flow_steer	= efx_filter_rfs,
 #endif
@@ -663,13 +655,13 @@ static int efx_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **xdpfs,
 	if (!netif_running(dev))
 		return -EINVAL;
 
-	return efx_xdp_tx_buffers(efx, n, xdpfs, flags & XDP_XMIT_FLUSH);
+	return efx_siena_xdp_tx_buffers(efx, n, xdpfs, flags & XDP_XMIT_FLUSH);
 }
 
 static void efx_update_name(struct efx_nic *efx)
 {
 	strcpy(efx->name, efx->net_dev->name);
-	efx_mtd_rename(efx);
+	efx_siena_mtd_rename(efx);
 	efx_set_channel_names(efx);
 }
 
@@ -708,7 +700,7 @@ static int efx_register_netdev(struct efx_nic *efx)
 	net_dev->netdev_ops = &efx_netdev_ops;
 	if (efx_nic_rev(efx) >= EFX_REV_HUNT_A0)
 		net_dev->priv_flags |= IFF_UNICAST_FLT;
-	net_dev->ethtool_ops = &efx_ethtool_ops;
+	net_dev->ethtool_ops = &efx_siena_ethtool_ops;
 	netif_set_gso_max_segs(net_dev, EFX_TSO_MAX_SEGS);
 	net_dev->min_mtu = EFX_MIN_MTU;
 	net_dev->max_mtu = EFX_MAX_MTU;
@@ -742,7 +734,7 @@ static int efx_register_netdev(struct efx_nic *efx)
 	efx_for_each_channel(channel, efx) {
 		struct efx_tx_queue *tx_queue;
 		efx_for_each_channel_tx_queue(tx_queue, channel)
-			efx_init_tx_queue_core_txq(tx_queue);
+			efx_siena_init_tx_queue_core_txq(tx_queue);
 	}
 
 	efx_associate(efx);
@@ -807,7 +799,7 @@ static const struct pci_device_id efx_pci_table[] = {
  *
  **************************************************************************/
 
-void efx_update_sw_stats(struct efx_nic *efx, u64 *stats)
+void efx_siena_update_sw_stats(struct efx_nic *efx, u64 *stats)
 {
 	u64 n_rx_nodesc_trunc = 0;
 	struct efx_channel *channel;
@@ -869,7 +861,7 @@ static void efx_pci_remove(struct pci_dev *pci_dev)
 
 	efx_unregister_netdev(efx);
 
-	efx_mtd_remove(efx);
+	efx_siena_mtd_remove(efx);
 
 	efx_pci_remove_main(efx);
 
diff --git a/drivers/net/ethernet/sfc/siena/efx.h b/drivers/net/ethernet/sfc/siena/efx.h
index 962c6b66eea7..a4f9e6e962b0 100644
--- a/drivers/net/ethernet/sfc/siena/efx.h
+++ b/drivers/net/ethernet/sfc/siena/efx.h
@@ -12,36 +12,28 @@
 #include "net_driver.h"
 #include "filter.h"
 
-int efx_net_open(struct net_device *net_dev);
-int efx_net_stop(struct net_device *net_dev);
-
 /* TX */
-void efx_init_tx_queue_core_txq(struct efx_tx_queue *tx_queue);
-netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
-				struct net_device *net_dev);
-netdev_tx_t __efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
+void efx_siena_init_tx_queue_core_txq(struct efx_tx_queue *tx_queue);
+netdev_tx_t efx_siena_hard_start_xmit(struct sk_buff *skb,
+				      struct net_device *net_dev);
+netdev_tx_t __efx_siena_enqueue_skb(struct efx_tx_queue *tx_queue,
+				    struct sk_buff *skb);
 static inline netdev_tx_t efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 {
 	return INDIRECT_CALL_1(tx_queue->efx->type->tx_enqueue,
-			       __efx_enqueue_skb, tx_queue, skb);
+			       __efx_siena_enqueue_skb, tx_queue, skb);
 }
-void efx_xmit_done_single(struct efx_tx_queue *tx_queue);
-int efx_setup_tc(struct net_device *net_dev, enum tc_setup_type type,
-		 void *type_data);
-extern unsigned int efx_piobuf_size;
+int efx_siena_setup_tc(struct net_device *net_dev, enum tc_setup_type type,
+		       void *type_data);
 
 /* RX */
-void __efx_rx_packet(struct efx_channel *channel);
-void efx_rx_packet(struct efx_rx_queue *rx_queue, unsigned int index,
-		   unsigned int n_frags, unsigned int len, u16 flags);
+void __efx_siena_rx_packet(struct efx_channel *channel);
+void efx_siena_rx_packet(struct efx_rx_queue *rx_queue, unsigned int index,
+			 unsigned int n_frags, unsigned int len, u16 flags);
 static inline void efx_rx_flush_packet(struct efx_channel *channel)
 {
 	if (channel->rx_pkt_n_frags)
-		__efx_rx_packet(channel);
-}
-static inline bool efx_rx_buf_hash_valid(struct efx_nic *efx, const u8 *prefix)
-{
-	return true;
+		__efx_siena_rx_packet(channel);
 }
 
 /* Maximum number of TCP segments we support for soft-TSO */
@@ -156,34 +148,33 @@ static inline bool efx_rss_active(struct efx_rss_context *ctx)
 }
 
 /* Ethtool support */
-extern const struct ethtool_ops efx_ethtool_ops;
+extern const struct ethtool_ops efx_siena_ethtool_ops;
 
 /* Global */
-unsigned int efx_usecs_to_ticks(struct efx_nic *efx, unsigned int usecs);
-unsigned int efx_ticks_to_usecs(struct efx_nic *efx, unsigned int ticks);
-int efx_init_irq_moderation(struct efx_nic *efx, unsigned int tx_usecs,
-			    unsigned int rx_usecs, bool rx_adaptive,
-			    bool rx_may_override_tx);
-void efx_get_irq_moderation(struct efx_nic *efx, unsigned int *tx_usecs,
-			    unsigned int *rx_usecs, bool *rx_adaptive);
+unsigned int efx_siena_usecs_to_ticks(struct efx_nic *efx, unsigned int usecs);
+int efx_siena_init_irq_moderation(struct efx_nic *efx, unsigned int tx_usecs,
+				  unsigned int rx_usecs, bool rx_adaptive,
+				  bool rx_may_override_tx);
+void efx_siena_get_irq_moderation(struct efx_nic *efx, unsigned int *tx_usecs,
+				  unsigned int *rx_usecs, bool *rx_adaptive);
 
 /* Update the generic software stats in the passed stats array */
-void efx_update_sw_stats(struct efx_nic *efx, u64 *stats);
+void efx_siena_update_sw_stats(struct efx_nic *efx, u64 *stats);
 
 /* MTD */
 #ifdef CONFIG_SFC_MTD
-int efx_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
-		size_t n_parts, size_t sizeof_part);
+int efx_siena_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
+		      size_t n_parts, size_t sizeof_part);
 static inline int efx_mtd_probe(struct efx_nic *efx)
 {
 	return efx->type->mtd_probe(efx);
 }
-void efx_mtd_rename(struct efx_nic *efx);
-void efx_mtd_remove(struct efx_nic *efx);
+void efx_siena_mtd_rename(struct efx_nic *efx);
+void efx_siena_mtd_remove(struct efx_nic *efx);
 #else
 static inline int efx_mtd_probe(struct efx_nic *efx) { return 0; }
-static inline void efx_mtd_rename(struct efx_nic *efx) {}
-static inline void efx_mtd_remove(struct efx_nic *efx) {}
+static inline void efx_siena_mtd_rename(struct efx_nic *efx) {}
+static inline void efx_siena_mtd_remove(struct efx_nic *efx) {}
 #endif
 
 #ifdef CONFIG_SFC_SRIOV
@@ -221,7 +212,7 @@ static inline bool efx_rwsem_assert_write_locked(struct rw_semaphore *sem)
 	return true;
 }
 
-int efx_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpfs,
-		       bool flush);
+int efx_siena_xdp_tx_buffers(struct efx_nic *efx, int n,
+			     struct xdp_frame **xdpfs, bool flush);
 
 #endif /* EFX_EFX_H */
diff --git a/drivers/net/ethernet/sfc/siena/ethtool.c b/drivers/net/ethernet/sfc/siena/ethtool.c
index 48506373721a..8d59e95b4951 100644
--- a/drivers/net/ethernet/sfc/siena/ethtool.c
+++ b/drivers/net/ethernet/sfc/siena/ethtool.c
@@ -105,7 +105,7 @@ static int efx_ethtool_get_coalesce(struct net_device *net_dev,
 	unsigned int tx_usecs, rx_usecs;
 	bool rx_adaptive;
 
-	efx_get_irq_moderation(efx, &tx_usecs, &rx_usecs, &rx_adaptive);
+	efx_siena_get_irq_moderation(efx, &tx_usecs, &rx_usecs, &rx_adaptive);
 
 	coalesce->tx_coalesce_usecs = tx_usecs;
 	coalesce->tx_coalesce_usecs_irq = tx_usecs;
@@ -127,7 +127,7 @@ static int efx_ethtool_set_coalesce(struct net_device *net_dev,
 	bool adaptive, rx_may_override_tx;
 	int rc;
 
-	efx_get_irq_moderation(efx, &tx_usecs, &rx_usecs, &adaptive);
+	efx_siena_get_irq_moderation(efx, &tx_usecs, &rx_usecs, &adaptive);
 
 	if (coalesce->rx_coalesce_usecs != rx_usecs)
 		rx_usecs = coalesce->rx_coalesce_usecs;
@@ -146,8 +146,8 @@ static int efx_ethtool_set_coalesce(struct net_device *net_dev,
 	else
 		tx_usecs = coalesce->tx_coalesce_usecs_irq;
 
-	rc = efx_init_irq_moderation(efx, tx_usecs, rx_usecs, adaptive,
-				     rx_may_override_tx);
+	rc = efx_siena_init_irq_moderation(efx, tx_usecs, rx_usecs, adaptive,
+					   rx_may_override_tx);
 	if (rc != 0)
 		return rc;
 
@@ -239,7 +239,7 @@ static int efx_ethtool_get_ts_info(struct net_device *net_dev,
 	return 0;
 }
 
-const struct ethtool_ops efx_ethtool_ops = {
+const struct ethtool_ops efx_siena_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_USECS_IRQ |
 				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
diff --git a/drivers/net/ethernet/sfc/siena/farch.c b/drivers/net/ethernet/sfc/siena/farch.c
index 8c85bda54b86..9fc5c6ebbfec 100644
--- a/drivers/net/ethernet/sfc/siena/farch.c
+++ b/drivers/net/ethernet/sfc/siena/farch.c
@@ -838,7 +838,7 @@ efx_farch_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
 		tx_ev_q_label = EFX_QWORD_FIELD(*event, FSF_AZ_TX_EV_Q_LABEL);
 		tx_queue = channel->tx_queue +
 				(tx_ev_q_label % EFX_MAX_TXQ_PER_CHANNEL);
-		efx_xmit_done(tx_queue, tx_ev_desc_ptr);
+		efx_siena_xmit_done(tx_queue, tx_ev_desc_ptr);
 	} else if (EFX_QWORD_FIELD(*event, FSF_AZ_TX_EV_WQ_FF_FULL)) {
 		/* Rewrite the FIFO write pointer */
 		tx_ev_q_label = EFX_QWORD_FIELD(*event, FSF_AZ_TX_EV_Q_LABEL);
@@ -1001,7 +1001,7 @@ efx_farch_handle_rx_event(struct efx_channel *channel, const efx_qword_t *event)
 
 		/* Discard all pending fragments */
 		if (rx_queue->scatter_n) {
-			efx_rx_packet(
+			efx_siena_rx_packet(
 				rx_queue,
 				rx_queue->removed_count & rx_queue->ptr_mask,
 				rx_queue->scatter_n, 0, EFX_RX_PKT_DISCARD);
@@ -1015,7 +1015,7 @@ efx_farch_handle_rx_event(struct efx_channel *channel, const efx_qword_t *event)
 
 		/* Discard new fragment if not SOP */
 		if (!rx_ev_sop) {
-			efx_rx_packet(
+			efx_siena_rx_packet(
 				rx_queue,
 				rx_queue->removed_count & rx_queue->ptr_mask,
 				1, 0, EFX_RX_PKT_DISCARD);
@@ -1067,9 +1067,9 @@ efx_farch_handle_rx_event(struct efx_channel *channel, const efx_qword_t *event)
 	channel->irq_mod_score += 2;
 
 	/* Handle received packet */
-	efx_rx_packet(rx_queue,
-		      rx_queue->removed_count & rx_queue->ptr_mask,
-		      rx_queue->scatter_n, rx_ev_byte_cnt, flags);
+	efx_siena_rx_packet(rx_queue,
+			    rx_queue->removed_count & rx_queue->ptr_mask,
+			    rx_queue->scatter_n, rx_ev_byte_cnt, flags);
 	rx_queue->removed_count += rx_queue->scatter_n;
 	rx_queue->scatter_n = 0;
 }
diff --git a/drivers/net/ethernet/sfc/siena/mtd.c b/drivers/net/ethernet/sfc/siena/mtd.c
index 273c08e5455f..12a624247f44 100644
--- a/drivers/net/ethernet/sfc/siena/mtd.c
+++ b/drivers/net/ethernet/sfc/siena/mtd.c
@@ -37,7 +37,7 @@ static void efx_mtd_sync(struct mtd_info *mtd)
 		       part->name, part->dev_type_name, rc);
 }
 
-static void efx_mtd_remove_partition(struct efx_mtd_partition *part)
+static void efx_siena_mtd_remove_partition(struct efx_mtd_partition *part)
 {
 	int rc;
 
@@ -51,8 +51,8 @@ static void efx_mtd_remove_partition(struct efx_mtd_partition *part)
 	list_del(&part->node);
 }
 
-int efx_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
-		size_t n_parts, size_t sizeof_part)
+int efx_siena_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
+		      size_t n_parts, size_t sizeof_part)
 {
 	struct efx_mtd_partition *part;
 	size_t i;
@@ -79,7 +79,7 @@ int efx_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
 		if (mtd_device_register(&part->mtd, NULL, 0))
 			goto fail;
 
-		/* Add to list in order - efx_mtd_remove() depends on this */
+		/* Add to list in order - efx_siena_mtd_remove() depends on this */
 		list_add_tail(&part->node, &efx->mtd_list);
 	}
 
@@ -89,13 +89,13 @@ int efx_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
 	while (i--) {
 		part = (struct efx_mtd_partition *)((char *)parts +
 						    i * sizeof_part);
-		efx_mtd_remove_partition(part);
+		efx_siena_mtd_remove_partition(part);
 	}
 	/* Failure is unlikely here, but probably means we're out of memory */
 	return -ENOMEM;
 }
 
-void efx_mtd_remove(struct efx_nic *efx)
+void efx_siena_mtd_remove(struct efx_nic *efx)
 {
 	struct efx_mtd_partition *parts, *part, *next;
 
@@ -108,12 +108,12 @@ void efx_mtd_remove(struct efx_nic *efx)
 				 node);
 
 	list_for_each_entry_safe(part, next, &efx->mtd_list, node)
-		efx_mtd_remove_partition(part);
+		efx_siena_mtd_remove_partition(part);
 
 	kfree(parts);
 }
 
-void efx_mtd_rename(struct efx_nic *efx)
+void efx_siena_mtd_rename(struct efx_nic *efx)
 {
 	struct efx_mtd_partition *part;
 
diff --git a/drivers/net/ethernet/sfc/siena/net_driver.h b/drivers/net/ethernet/sfc/siena/net_driver.h
index ec88bbfcb5be..3fe93f25a569 100644
--- a/drivers/net/ethernet/sfc/siena/net_driver.h
+++ b/drivers/net/ethernet/sfc/siena/net_driver.h
@@ -207,7 +207,6 @@ struct efx_tx_buffer {
  * @txd: The hardware descriptor ring
  * @ptr_mask: The size of the ring minus 1.
  * @piobuf: PIO buffer region for this TX queue (shared with its partner).
- *	Size of the region is efx_piobuf_size.
  * @piobuf_offset: Buffer offset to be specified in PIO descriptors
  * @initialised: Has hardware queue been initialised?
  * @timestamping: Is timestamping enabled for this channel?
@@ -478,9 +477,9 @@ enum efx_sync_events_state {
  * @n_rx_xdp_tx: Count of RX packets retransmitted due to XDP
  * @n_rx_xdp_redirect: Count of RX packets redirected to a different NIC by XDP
  * @rx_pkt_n_frags: Number of fragments in next packet to be delivered by
- *	__efx_rx_packet(), or zero if there is none
+ *	__efx_siena_rx_packet(), or zero if there is none
  * @rx_pkt_index: Ring index of first buffer for next packet to be delivered
- *	by __efx_rx_packet(), if @rx_pkt_n_frags != 0
+ *	by __efx_siena_rx_packet(), if @rx_pkt_n_frags != 0
  * @rx_list: list of SKBs from current RX, awaiting processing
  * @rx_queue: RX queue for this channel
  * @tx_queue: TX queues for this channel
@@ -1255,7 +1254,7 @@ struct efx_udp_tunnel {
  *	This must check whether the specified table entry is used by RFS
  *	and that rps_may_expire_flow() returns true for it.
  * @mtd_probe: Probe and add MTD partitions associated with this net device,
- *	 using efx_mtd_add()
+ *	 using efx_siena_mtd_add()
  * @mtd_rename: Set an MTD partition name using the net device name
  * @mtd_read: Read from an MTD partition
  * @mtd_erase: Erase part of an MTD partition
diff --git a/drivers/net/ethernet/sfc/siena/rx.c b/drivers/net/ethernet/sfc/siena/rx.c
index 2375cef577e4..099cb23e3250 100644
--- a/drivers/net/ethernet/sfc/siena/rx.c
+++ b/drivers/net/ethernet/sfc/siena/rx.c
@@ -118,8 +118,8 @@ static struct sk_buff *efx_rx_mk_skb(struct efx_channel *channel,
 	return skb;
 }
 
-void efx_rx_packet(struct efx_rx_queue *rx_queue, unsigned int index,
-		   unsigned int n_frags, unsigned int len, u16 flags)
+void efx_siena_rx_packet(struct efx_rx_queue *rx_queue, unsigned int index,
+			 unsigned int n_frags, unsigned int len, u16 flags)
 {
 	struct efx_nic *efx = rx_queue->efx;
 	struct efx_channel *channel = efx_rx_queue_channel(rx_queue);
@@ -310,7 +310,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 	case XDP_TX:
 		/* Buffer ownership passes to tx on success. */
 		xdpf = xdp_convert_buff_to_frame(&xdp);
-		err = efx_xdp_tx_buffers(efx, 1, &xdpf, true);
+		err = efx_siena_xdp_tx_buffers(efx, 1, &xdpf, true);
 		if (unlikely(err != 1)) {
 			efx_free_rx_buffers(rx_queue, rx_buf, 1);
 			if (net_ratelimit())
@@ -357,7 +357,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 }
 
 /* Handle a received packet.  Second half: Touches packet payload. */
-void __efx_rx_packet(struct efx_channel *channel)
+void __efx_siena_rx_packet(struct efx_channel *channel)
 {
 	struct efx_nic *efx = channel->efx;
 	struct efx_rx_buffer *rx_buf =
@@ -391,7 +391,8 @@ void __efx_rx_packet(struct efx_channel *channel)
 		rx_buf->flags &= ~EFX_RX_PKT_CSUMMED;
 
 	if ((rx_buf->flags & EFX_RX_PKT_TCP) && !channel->type->receive_skb)
-		efx_rx_packet_gro(channel, rx_buf, channel->rx_pkt_n_frags, eh, 0);
+		efx_siena_rx_packet_gro(channel, rx_buf,
+					channel->rx_pkt_n_frags, eh, 0);
 	else
 		efx_rx_deliver(channel, eh, rx_buf, channel->rx_pkt_n_frags);
 out:
diff --git a/drivers/net/ethernet/sfc/siena/rx_common.c b/drivers/net/ethernet/sfc/siena/rx_common.c
index 1b22c7be0088..d737c7c5b2ab 100644
--- a/drivers/net/ethernet/sfc/siena/rx_common.c
+++ b/drivers/net/ethernet/sfc/siena/rx_common.c
@@ -501,8 +501,9 @@ void efx_fast_push_rx_descriptors(struct efx_rx_queue *rx_queue, bool atomic)
  * regardless of checksum state and skbs with a good checksum.
  */
 void
-efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
-		  unsigned int n_frags, u8 *eh, __wsum csum)
+efx_siena_rx_packet_gro(struct efx_channel *channel,
+			struct efx_rx_buffer *rx_buf,
+			unsigned int n_frags, u8 *eh, __wsum csum)
 {
 	struct napi_struct *napi = &channel->napi_str;
 	struct efx_nic *efx = channel->efx;
@@ -517,8 +518,7 @@ efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
 		return;
 	}
 
-	if (efx->net_dev->features & NETIF_F_RXHASH &&
-	    efx_rx_buf_hash_valid(efx, eh))
+	if (efx->net_dev->features & NETIF_F_RXHASH)
 		skb_set_hash(skb, efx_rx_buf_hash(efx, eh),
 			     PKT_HASH_TYPE_L3);
 	if (csum) {
diff --git a/drivers/net/ethernet/sfc/siena/rx_common.h b/drivers/net/ethernet/sfc/siena/rx_common.h
index fbd2769307f9..909d06a4fdc9 100644
--- a/drivers/net/ethernet/sfc/siena/rx_common.h
+++ b/drivers/net/ethernet/sfc/siena/rx_common.h
@@ -81,8 +81,9 @@ void efx_rx_config_page_split(struct efx_nic *efx);
 void efx_fast_push_rx_descriptors(struct efx_rx_queue *rx_queue, bool atomic);
 
 void
-efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
-		  unsigned int n_frags, u8 *eh, __wsum csum);
+efx_siena_rx_packet_gro(struct efx_channel *channel,
+			struct efx_rx_buffer *rx_buf,
+			unsigned int n_frags, u8 *eh, __wsum csum);
 
 struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx);
 struct efx_rss_context *efx_find_rss_context_entry(struct efx_nic *efx, u32 id);
diff --git a/drivers/net/ethernet/sfc/siena/siena.c b/drivers/net/ethernet/sfc/siena/siena.c
index e072b5842f78..4514f15798ed 100644
--- a/drivers/net/ethernet/sfc/siena/siena.c
+++ b/drivers/net/ethernet/sfc/siena/siena.c
@@ -40,7 +40,7 @@ static void siena_push_irq_moderation(struct efx_channel *channel)
 	if (channel->irq_moderation_us) {
 		unsigned int ticks;
 
-		ticks = efx_usecs_to_ticks(efx, channel->irq_moderation_us);
+		ticks = efx_siena_usecs_to_ticks(efx, channel->irq_moderation_us);
 		EFX_POPULATE_DWORD_2(timer_cmd,
 				     FRF_CZ_TC_TIMER_MODE,
 				     FFE_CZ_TIMER_MODE_INT_HLDOFF,
@@ -583,7 +583,7 @@ static int siena_try_update_nic_stats(struct efx_nic *efx)
 	efx_update_diff_stat(&stats[SIENA_STAT_rx_good_bytes],
 			     stats[SIENA_STAT_rx_bytes] -
 			     stats[SIENA_STAT_rx_bad_bytes]);
-	efx_update_sw_stats(efx, stats);
+	efx_siena_update_sw_stats(efx, stats);
 	return 0;
 }
 
@@ -943,7 +943,7 @@ static int siena_mtd_probe(struct efx_nic *efx)
 	if (rc)
 		goto fail;
 
-	rc = efx_mtd_add(efx, &parts[0].common, n_parts, sizeof(*parts));
+	rc = efx_siena_mtd_add(efx, &parts[0].common, n_parts, sizeof(*parts));
 fail:
 	if (rc)
 		kfree(parts);
@@ -1024,7 +1024,7 @@ const struct efx_nic_type siena_a0_nic_type = {
 	.tx_remove = efx_farch_tx_remove,
 	.tx_write = efx_farch_tx_write,
 	.tx_limit_len = efx_farch_tx_limit_len,
-	.tx_enqueue = __efx_enqueue_skb,
+	.tx_enqueue = __efx_siena_enqueue_skb,
 	.rx_push_rss_config = siena_rx_push_rss_config,
 	.rx_pull_rss_config = siena_rx_pull_rss_config,
 	.rx_probe = efx_farch_rx_probe,
@@ -1032,7 +1032,7 @@ const struct efx_nic_type siena_a0_nic_type = {
 	.rx_remove = efx_farch_rx_remove,
 	.rx_write = efx_farch_rx_write,
 	.rx_defer_refill = efx_farch_rx_defer_refill,
-	.rx_packet = __efx_rx_packet,
+	.rx_packet = __efx_siena_rx_packet,
 	.ev_probe = efx_farch_ev_probe,
 	.ev_init = efx_farch_ev_init,
 	.ev_fini = efx_farch_ev_fini,
diff --git a/drivers/net/ethernet/sfc/siena/tx.c b/drivers/net/ethernet/sfc/siena/tx.c
index 9777a0af0790..9199cddfa536 100644
--- a/drivers/net/ethernet/sfc/siena/tx.c
+++ b/drivers/net/ethernet/sfc/siena/tx.c
@@ -138,13 +138,14 @@ static void efx_tx_send_pending(struct efx_channel *channel)
  * If any DMA mapping fails, any mapped fragments will be unmapped,
  * the queue's insert pointer will be restored to its original value.
  *
- * This function is split out from efx_hard_start_xmit to allow the
+ * This function is split out from efx_siena_hard_start_xmit to allow the
  * loopback test to direct packets via specific TX queues.
  *
  * Returns NETDEV_TX_OK.
  * You must hold netif_tx_lock() to call this function.
  */
-netdev_tx_t __efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
+netdev_tx_t __efx_siena_enqueue_skb(struct efx_tx_queue *tx_queue,
+				    struct sk_buff *skb)
 {
 	unsigned int old_insert_count = tx_queue->insert_count;
 	bool xmit_more = netdev_xmit_more();
@@ -219,8 +220,8 @@ netdev_tx_t __efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb
  * Runs in NAPI context, either in our poll (for XDP TX) or a different NIC
  * (for XDP redirect).
  */
-int efx_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpfs,
-		       bool flush)
+int efx_siena_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpfs,
+			     bool flush)
 {
 	struct efx_tx_buffer *tx_buffer;
 	struct efx_tx_queue *tx_queue;
@@ -307,8 +308,8 @@ int efx_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpfs,
  * Context: non-blocking.
  * Should always return NETDEV_TX_OK and consume the skb.
  */
-netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
-				struct net_device *net_dev)
+netdev_tx_t efx_siena_hard_start_xmit(struct sk_buff *skb,
+				      struct net_device *net_dev)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	struct efx_tx_queue *tx_queue;
@@ -350,52 +351,14 @@ netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
 		return NETDEV_TX_OK;
 	}
 
-	return __efx_enqueue_skb(tx_queue, skb);
+	return __efx_siena_enqueue_skb(tx_queue, skb);
 }
 
-void efx_xmit_done_single(struct efx_tx_queue *tx_queue)
-{
-	unsigned int pkts_compl = 0, bytes_compl = 0;
-	unsigned int read_ptr;
-	bool finished = false;
-
-	read_ptr = tx_queue->read_count & tx_queue->ptr_mask;
-
-	while (!finished) {
-		struct efx_tx_buffer *buffer = &tx_queue->buffer[read_ptr];
-
-		if (!efx_tx_buffer_in_use(buffer)) {
-			struct efx_nic *efx = tx_queue->efx;
-
-			netif_err(efx, hw, efx->net_dev,
-				  "TX queue %d spurious single TX completion\n",
-				  tx_queue->queue);
-			efx_siena_schedule_reset(efx, RESET_TYPE_TX_SKIP);
-			return;
-		}
-
-		/* Need to check the flag before dequeueing. */
-		if (buffer->flags & EFX_TX_BUF_SKB)
-			finished = true;
-		efx_dequeue_buffer(tx_queue, buffer, &pkts_compl, &bytes_compl);
-
-		++tx_queue->read_count;
-		read_ptr = tx_queue->read_count & tx_queue->ptr_mask;
-	}
-
-	tx_queue->pkts_compl += pkts_compl;
-	tx_queue->bytes_compl += bytes_compl;
-
-	EFX_WARN_ON_PARANOID(pkts_compl != 1);
-
-	efx_xmit_done_check_empty(tx_queue);
-}
-
-void efx_init_tx_queue_core_txq(struct efx_tx_queue *tx_queue)
+void efx_siena_init_tx_queue_core_txq(struct efx_tx_queue *tx_queue)
 {
 	struct efx_nic *efx = tx_queue->efx;
 
-	/* Must be inverse of queue lookup in efx_hard_start_xmit() */
+	/* Must be inverse of queue lookup in efx_siena_hard_start_xmit() */
 	tx_queue->core_txq =
 		netdev_get_tx_queue(efx->net_dev,
 				    tx_queue->channel->channel +
@@ -403,8 +366,8 @@ void efx_init_tx_queue_core_txq(struct efx_tx_queue *tx_queue)
 				     efx->n_tx_channels : 0));
 }
 
-int efx_setup_tc(struct net_device *net_dev, enum tc_setup_type type,
-		 void *type_data)
+int efx_siena_setup_tc(struct net_device *net_dev, enum tc_setup_type type,
+		       void *type_data)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	struct tc_mqprio_qopt *mqprio = type_data;
diff --git a/drivers/net/ethernet/sfc/siena/tx_common.c b/drivers/net/ethernet/sfc/siena/tx_common.c
index 622c8d72b52f..298eb198f23d 100644
--- a/drivers/net/ethernet/sfc/siena/tx_common.c
+++ b/drivers/net/ethernet/sfc/siena/tx_common.c
@@ -223,7 +223,7 @@ static void efx_dequeue_buffers(struct efx_tx_queue *tx_queue,
 	}
 }
 
-void efx_xmit_done_check_empty(struct efx_tx_queue *tx_queue)
+void efx_siena_xmit_done_check_empty(struct efx_tx_queue *tx_queue)
 {
 	if ((int)(tx_queue->read_count - tx_queue->old_write_count) >= 0) {
 		tx_queue->old_write_count = READ_ONCE(tx_queue->write_count);
@@ -236,7 +236,7 @@ void efx_xmit_done_check_empty(struct efx_tx_queue *tx_queue)
 	}
 }
 
-void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
+void efx_siena_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
 {
 	unsigned int fill_level, pkts_compl = 0, bytes_compl = 0;
 	struct efx_nic *efx = tx_queue->efx;
@@ -263,7 +263,7 @@ void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
 			netif_tx_wake_queue(tx_queue->core_txq);
 	}
 
-	efx_xmit_done_check_empty(tx_queue);
+	efx_siena_xmit_done_check_empty(tx_queue);
 }
 
 /* Remove buffers put into a tx_queue for the current packet.
diff --git a/drivers/net/ethernet/sfc/siena/tx_common.h b/drivers/net/ethernet/sfc/siena/tx_common.h
index bbab7f248250..602f5a052918 100644
--- a/drivers/net/ethernet/sfc/siena/tx_common.h
+++ b/drivers/net/ethernet/sfc/siena/tx_common.h
@@ -26,8 +26,8 @@ static inline bool efx_tx_buffer_in_use(struct efx_tx_buffer *buffer)
 	return buffer->len || (buffer->flags & EFX_TX_BUF_OPTION);
 }
 
-void efx_xmit_done_check_empty(struct efx_tx_queue *tx_queue);
-void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index);
+void efx_siena_xmit_done_check_empty(struct efx_tx_queue *tx_queue);
+void efx_siena_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index);
 
 void efx_enqueue_unwind(struct efx_tx_queue *tx_queue,
 			unsigned int insert_count);

