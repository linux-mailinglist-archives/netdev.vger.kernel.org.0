Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D925C51298F
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 04:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241497AbiD1CgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 22:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241465AbiD1CgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 22:36:03 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B4FF97BAC
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 19:32:48 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 6B02432010B;
        Thu, 28 Apr 2022 03:32:47 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1njtxX-0005Y6-7G; Thu, 28 Apr 2022 03:32:47 +0100
Subject: [PATCH net-next v2 11/13] sfc/siena: Rename functions in
 nic_common.h to avoid conflicts with sfc
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Thu, 28 Apr 2022 03:32:47 +0100
Message-ID: <165111316692.21042.425403460713715053.stgit@palantir17.mph.net>
In-Reply-To: <165111298464.21042.9988060027860048966.stgit@palantir17.mph.net>
References: <165111298464.21042.9988060027860048966.stgit@palantir17.mph.net>
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

For siena use efx_siena_ as the function prefix.
efx_nic_update_stats_atomic is only used in efx_common.c, so move
it there.
efx_nic_copy_stats is not used in Siena, so it is removed.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/efx.c              |    6 +-
 drivers/net/ethernet/sfc/siena/efx_common.c       |   10 ++-
 drivers/net/ethernet/sfc/siena/ethtool.c          |    4 +
 drivers/net/ethernet/sfc/siena/farch.c            |    4 +
 drivers/net/ethernet/sfc/siena/mcdi_mon.c         |    9 +-
 drivers/net/ethernet/sfc/siena/mcdi_port_common.c |    7 +-
 drivers/net/ethernet/sfc/siena/nic.c              |   79 +++++----------------
 drivers/net/ethernet/sfc/siena/nic_common.h       |   40 ++++-------
 drivers/net/ethernet/sfc/siena/ptp.c              |   16 ++--
 drivers/net/ethernet/sfc/siena/selftest.c         |    8 +-
 drivers/net/ethernet/sfc/siena/siena.c            |   20 +++--
 drivers/net/ethernet/sfc/siena/siena_sriov.c      |   22 +++---
 drivers/net/ethernet/sfc/siena/tx.c               |    4 +
 drivers/net/ethernet/sfc/siena/tx_common.c        |    4 +
 14 files changed, 95 insertions(+), 138 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index 417c9f714da8..c0e7a919b608 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -830,7 +830,7 @@ static void efx_pci_remove_main(struct efx_nic *efx)
 
 	efx_siena_disable_interrupts(efx);
 	efx_siena_clear_interrupt_affinity(efx);
-	efx_nic_fini_interrupt(efx);
+	efx_siena_fini_interrupt(efx);
 	efx_fini_port(efx);
 	efx->type->fini(efx);
 	efx_siena_fini_napi(efx);
@@ -939,7 +939,7 @@ static int efx_pci_probe_main(struct efx_nic *efx)
 		goto fail4;
 	}
 
-	rc = efx_nic_init_interrupt(efx);
+	rc = efx_siena_init_interrupt(efx);
 	if (rc)
 		goto fail5;
 
@@ -952,7 +952,7 @@ static int efx_pci_probe_main(struct efx_nic *efx)
 
  fail6:
 	efx_siena_clear_interrupt_affinity(efx);
-	efx_nic_fini_interrupt(efx);
+	efx_siena_fini_interrupt(efx);
  fail5:
 	efx_fini_port(efx);
  fail4:
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index 3293221b9e9e..b44a7114e319 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -597,6 +597,14 @@ void efx_siena_stop_all(struct efx_nic *efx)
 	efx_stop_datapath(efx);
 }
 
+static size_t efx_siena_update_stats_atomic(struct efx_nic *efx, u64 *full_stats,
+					    struct rtnl_link_stats64 *core_stats)
+{
+	if (efx->type->update_stats_atomic)
+		return efx->type->update_stats_atomic(efx, full_stats, core_stats);
+	return efx->type->update_stats(efx, full_stats, core_stats);
+}
+
 /* Context: process, dev_base_lock or RTNL held, non-blocking. */
 void efx_siena_net_stats(struct net_device *net_dev,
 			 struct rtnl_link_stats64 *stats)
@@ -604,7 +612,7 @@ void efx_siena_net_stats(struct net_device *net_dev,
 	struct efx_nic *efx = netdev_priv(net_dev);
 
 	spin_lock_bh(&efx->stats_lock);
-	efx_nic_update_stats_atomic(efx, NULL, stats);
+	efx_siena_update_stats_atomic(efx, NULL, stats);
 	spin_unlock_bh(&efx->stats_lock);
 }
 
diff --git a/drivers/net/ethernet/sfc/siena/ethtool.c b/drivers/net/ethernet/sfc/siena/ethtool.c
index 5ee626ba4eb1..e4ec589216c1 100644
--- a/drivers/net/ethernet/sfc/siena/ethtool.c
+++ b/drivers/net/ethernet/sfc/siena/ethtool.c
@@ -55,7 +55,7 @@ static int efx_ethtool_phys_id(struct net_device *net_dev,
 
 static int efx_ethtool_get_regs_len(struct net_device *net_dev)
 {
-	return efx_nic_get_regs_len(netdev_priv(net_dev));
+	return efx_siena_get_regs_len(netdev_priv(net_dev));
 }
 
 static void efx_ethtool_get_regs(struct net_device *net_dev,
@@ -64,7 +64,7 @@ static void efx_ethtool_get_regs(struct net_device *net_dev,
 	struct efx_nic *efx = netdev_priv(net_dev);
 
 	regs->version = efx->type->revision;
-	efx_nic_get_regs(efx, buf);
+	efx_siena_get_regs(efx, buf);
 }
 
 /*
diff --git a/drivers/net/ethernet/sfc/siena/farch.c b/drivers/net/ethernet/sfc/siena/farch.c
index ebd6fa408126..a24ba23fd19f 100644
--- a/drivers/net/ethernet/sfc/siena/farch.c
+++ b/drivers/net/ethernet/sfc/siena/farch.c
@@ -233,7 +233,7 @@ static int efx_alloc_special_buffer(struct efx_nic *efx,
 #endif
 	len = ALIGN(len, EFX_BUF_SIZE);
 
-	if (efx_nic_alloc_buffer(efx, &buffer->buf, len, GFP_KERNEL))
+	if (efx_siena_alloc_buffer(efx, &buffer->buf, len, GFP_KERNEL))
 		return -ENOMEM;
 	buffer->entries = len / EFX_BUF_SIZE;
 	BUG_ON(buffer->buf.dma_addr & (EFX_BUF_SIZE - 1));
@@ -269,7 +269,7 @@ efx_free_special_buffer(struct efx_nic *efx, struct efx_special_buffer *buffer)
 		  (u64)buffer->buf.dma_addr, buffer->buf.len,
 		  buffer->buf.addr, (u64)virt_to_phys(buffer->buf.addr));
 
-	efx_nic_free_buffer(efx, &buffer->buf);
+	efx_siena_free_buffer(efx, &buffer->buf);
 	buffer->entries = 0;
 }
 
diff --git a/drivers/net/ethernet/sfc/siena/mcdi_mon.c b/drivers/net/ethernet/sfc/siena/mcdi_mon.c
index eb44d4140925..d0c25dfda0d7 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi_mon.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi_mon.c
@@ -336,10 +336,9 @@ int efx_siena_mcdi_mon_probe(struct efx_nic *efx)
 	if (n_sensors == 0)
 		return 0;
 
-	rc = efx_nic_alloc_buffer(
-		efx, &hwmon->dma_buf,
-		n_sensors * MC_CMD_SENSOR_VALUE_ENTRY_TYPEDEF_LEN,
-		GFP_KERNEL);
+	rc = efx_siena_alloc_buffer(efx, &hwmon->dma_buf,
+			n_sensors * MC_CMD_SENSOR_VALUE_ENTRY_TYPEDEF_LEN,
+			GFP_KERNEL);
 	if (rc)
 		return rc;
 
@@ -526,7 +525,7 @@ void efx_siena_mcdi_mon_remove(struct efx_nic *efx)
 		hwmon_device_unregister(hwmon->device);
 	kfree(hwmon->attrs);
 	kfree(hwmon->group.attrs);
-	efx_nic_free_buffer(efx, &hwmon->dma_buf);
+	efx_siena_free_buffer(efx, &hwmon->dma_buf);
 }
 
 #endif /* CONFIG_SFC_MCDI_MON */
diff --git a/drivers/net/ethernet/sfc/siena/mcdi_port_common.c b/drivers/net/ethernet/sfc/siena/mcdi_port_common.c
index a842c139d76f..067fe0f4393a 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi_port_common.c
@@ -1225,8 +1225,9 @@ int efx_siena_mcdi_mac_init_stats(struct efx_nic *efx)
 		return 0;
 
 	/* Allocate buffer for stats */
-	rc = efx_nic_alloc_buffer(efx, &efx->stats_buffer,
-				  efx->num_mac_stats * sizeof(u64), GFP_KERNEL);
+	rc = efx_siena_alloc_buffer(efx, &efx->stats_buffer,
+				    efx->num_mac_stats * sizeof(u64),
+				    GFP_KERNEL);
 	if (rc) {
 		netif_warn(efx, probe, efx->net_dev,
 			   "failed to allocate DMA buffer: %d\n", rc);
@@ -1244,7 +1245,7 @@ int efx_siena_mcdi_mac_init_stats(struct efx_nic *efx)
 
 void efx_siena_mcdi_mac_fini_stats(struct efx_nic *efx)
 {
-	efx_nic_free_buffer(efx, &efx->stats_buffer);
+	efx_siena_free_buffer(efx, &efx->stats_buffer);
 }
 
 static unsigned int efx_mcdi_event_link_speed[] = {
diff --git a/drivers/net/ethernet/sfc/siena/nic.c b/drivers/net/ethernet/sfc/siena/nic.c
index c59357178657..abf9a4adf139 100644
--- a/drivers/net/ethernet/sfc/siena/nic.c
+++ b/drivers/net/ethernet/sfc/siena/nic.c
@@ -28,8 +28,8 @@
  *
  **************************************************************************/
 
-int efx_nic_alloc_buffer(struct efx_nic *efx, struct efx_buffer *buffer,
-			 unsigned int len, gfp_t gfp_flags)
+int efx_siena_alloc_buffer(struct efx_nic *efx, struct efx_buffer *buffer,
+			   unsigned int len, gfp_t gfp_flags)
 {
 	buffer->addr = dma_alloc_coherent(&efx->pci_dev->dev, len,
 					  &buffer->dma_addr, gfp_flags);
@@ -39,7 +39,7 @@ int efx_nic_alloc_buffer(struct efx_nic *efx, struct efx_buffer *buffer,
 	return 0;
 }
 
-void efx_nic_free_buffer(struct efx_nic *efx, struct efx_buffer *buffer)
+void efx_siena_free_buffer(struct efx_nic *efx, struct efx_buffer *buffer)
 {
 	if (buffer->addr) {
 		dma_free_coherent(&efx->pci_dev->dev, buffer->len,
@@ -51,19 +51,19 @@ void efx_nic_free_buffer(struct efx_nic *efx, struct efx_buffer *buffer)
 /* Check whether an event is present in the eventq at the current
  * read pointer.  Only useful for self-test.
  */
-bool efx_nic_event_present(struct efx_channel *channel)
+bool efx_siena_event_present(struct efx_channel *channel)
 {
 	return efx_event_present(efx_event(channel, channel->eventq_read_ptr));
 }
 
-void efx_nic_event_test_start(struct efx_channel *channel)
+void efx_siena_event_test_start(struct efx_channel *channel)
 {
 	channel->event_test_cpu = -1;
 	smp_wmb();
 	channel->efx->type->ev_test_generate(channel);
 }
 
-int efx_nic_irq_test_start(struct efx_nic *efx)
+int efx_siena_irq_test_start(struct efx_nic *efx)
 {
 	efx->last_irq_cpu = -1;
 	smp_wmb();
@@ -73,7 +73,7 @@ int efx_nic_irq_test_start(struct efx_nic *efx)
 /* Hook interrupt handler(s)
  * Try MSI and then legacy interrupts.
  */
-int efx_nic_init_interrupt(struct efx_nic *efx)
+int efx_siena_init_interrupt(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 	unsigned int n_irqs;
@@ -146,7 +146,7 @@ int efx_nic_init_interrupt(struct efx_nic *efx)
 	return rc;
 }
 
-void efx_nic_fini_interrupt(struct efx_nic *efx)
+void efx_siena_fini_interrupt(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 
@@ -364,7 +364,7 @@ static const struct efx_nic_reg_table efx_nic_reg_tables[] = {
 	REGISTER_TABLE_BZ(RX_FILTER_TBL0),
 };
 
-size_t efx_nic_get_regs_len(struct efx_nic *efx)
+size_t efx_siena_get_regs_len(struct efx_nic *efx)
 {
 	const struct efx_nic_reg *reg;
 	const struct efx_nic_reg_table *table;
@@ -387,7 +387,7 @@ size_t efx_nic_get_regs_len(struct efx_nic *efx)
 	return len;
 }
 
-void efx_nic_get_regs(struct efx_nic *efx, void *buf)
+void efx_siena_get_regs(struct efx_nic *efx, void *buf)
 {
 	const struct efx_nic_reg *reg;
 	const struct efx_nic_reg_table *table;
@@ -439,7 +439,7 @@ void efx_nic_get_regs(struct efx_nic *efx, void *buf)
 }
 
 /**
- * efx_nic_describe_stats - Describe supported statistics for ethtool
+ * efx_siena_describe_stats - Describe supported statistics for ethtool
  * @desc: Array of &struct efx_hw_stat_desc describing the statistics
  * @count: Length of the @desc array
  * @mask: Bitmask of which elements of @desc are enabled
@@ -449,8 +449,8 @@ void efx_nic_get_regs(struct efx_nic *efx, void *buf)
  * Returns the number of visible statistics, i.e. the number of set
  * bits in the first @count bits of @mask for which a name is defined.
  */
-size_t efx_nic_describe_stats(const struct efx_hw_stat_desc *desc, size_t count,
-			      const unsigned long *mask, u8 *names)
+size_t efx_siena_describe_stats(const struct efx_hw_stat_desc *desc, size_t count,
+				const unsigned long *mask, u8 *names)
 {
 	size_t visible = 0;
 	size_t index;
@@ -470,50 +470,7 @@ size_t efx_nic_describe_stats(const struct efx_hw_stat_desc *desc, size_t count,
 }
 
 /**
- * efx_nic_copy_stats - Copy stats from the DMA buffer in to an
- *	intermediate buffer. This is used to get a consistent
- *	set of stats while the DMA buffer can be written at any time
- *	by the NIC.
- * @efx: The associated NIC.
- * @dest: Destination buffer. Must be the same size as the DMA buffer.
- */
-int efx_nic_copy_stats(struct efx_nic *efx, __le64 *dest)
-{
-	__le64 *dma_stats = efx->stats_buffer.addr;
-	__le64 generation_start, generation_end;
-	int rc = 0, retry;
-
-	if (!dest)
-		return 0;
-
-	if (!dma_stats)
-		goto return_zeroes;
-
-	/* If we're unlucky enough to read statistics during the DMA, wait
-	 * up to 10ms for it to finish (typically takes <500us)
-	 */
-	for (retry = 0; retry < 100; ++retry) {
-		generation_end = dma_stats[efx->num_mac_stats - 1];
-		if (generation_end == EFX_MC_STATS_GENERATION_INVALID)
-			goto return_zeroes;
-		rmb();
-		memcpy(dest, dma_stats, efx->num_mac_stats * sizeof(__le64));
-		rmb();
-		generation_start = dma_stats[MC_CMD_MAC_GENERATION_START];
-		if (generation_end == generation_start)
-			return 0; /* return good data */
-		udelay(100);
-	}
-
-	rc = -EIO;
-
-return_zeroes:
-	memset(dest, 0, efx->num_mac_stats * sizeof(u64));
-	return rc;
-}
-
-/**
- * efx_nic_update_stats - Convert statistics DMA buffer to array of u64
+ * efx_siena_update_stats - Convert statistics DMA buffer to array of u64
  * @desc: Array of &struct efx_hw_stat_desc describing the DMA buffer
  *	layout.  DMA widths of 0, 16, 32 and 64 are supported; where
  *	the width is specified as 0 the corresponding element of
@@ -526,9 +483,9 @@ int efx_nic_copy_stats(struct efx_nic *efx, __le64 *dest)
  * @accumulate: If set, the converted values will be added rather than
  *	directly stored to the corresponding elements of @stats
  */
-void efx_nic_update_stats(const struct efx_hw_stat_desc *desc, size_t count,
-			  const unsigned long *mask,
-			  u64 *stats, const void *dma_buf, bool accumulate)
+void efx_siena_update_stats(const struct efx_hw_stat_desc *desc, size_t count,
+			    const unsigned long *mask,
+			    u64 *stats, const void *dma_buf, bool accumulate)
 {
 	size_t index;
 
@@ -561,7 +518,7 @@ void efx_nic_update_stats(const struct efx_hw_stat_desc *desc, size_t count,
 	}
 }
 
-void efx_nic_fix_nodesc_drop_stat(struct efx_nic *efx, u64 *rx_nodesc_drops)
+void efx_siena_fix_nodesc_drop_stat(struct efx_nic *efx, u64 *rx_nodesc_drops)
 {
 	/* if down, or this is the first update after coming up */
 	if (!(efx->net_dev->flags & IFF_UP) || !efx->rx_nodesc_drops_prev_state)
diff --git a/drivers/net/ethernet/sfc/siena/nic_common.h b/drivers/net/ethernet/sfc/siena/nic_common.h
index 47deeae0a034..3af0405eeaa4 100644
--- a/drivers/net/ethernet/sfc/siena/nic_common.h
+++ b/drivers/net/ethernet/sfc/siena/nic_common.h
@@ -182,9 +182,9 @@ static inline void efx_nic_eventq_read_ack(struct efx_channel *channel)
 	channel->efx->type->ev_read_ack(channel);
 }
 
-void efx_nic_event_test_start(struct efx_channel *channel);
+void efx_siena_event_test_start(struct efx_channel *channel);
 
-bool efx_nic_event_present(struct efx_channel *channel);
+bool efx_siena_event_present(struct efx_channel *channel);
 
 static inline void efx_sensor_event(struct efx_nic *efx, efx_qword_t *ev)
 {
@@ -216,9 +216,9 @@ static inline void efx_update_diff_stat(u64 *stat, u64 diff)
 }
 
 /* Interrupts */
-int efx_nic_init_interrupt(struct efx_nic *efx);
-int efx_nic_irq_test_start(struct efx_nic *efx);
-void efx_nic_fini_interrupt(struct efx_nic *efx);
+int efx_siena_init_interrupt(struct efx_nic *efx);
+int efx_siena_irq_test_start(struct efx_nic *efx);
+void efx_siena_fini_interrupt(struct efx_nic *efx);
 
 static inline int efx_nic_event_test_irq_cpu(struct efx_channel *channel)
 {
@@ -230,29 +230,21 @@ static inline int efx_nic_irq_test_irq_cpu(struct efx_nic *efx)
 }
 
 /* Global Resources */
-int efx_nic_alloc_buffer(struct efx_nic *efx, struct efx_buffer *buffer,
-			 unsigned int len, gfp_t gfp_flags);
-void efx_nic_free_buffer(struct efx_nic *efx, struct efx_buffer *buffer);
+int efx_siena_alloc_buffer(struct efx_nic *efx, struct efx_buffer *buffer,
+			   unsigned int len, gfp_t gfp_flags);
+void efx_siena_free_buffer(struct efx_nic *efx, struct efx_buffer *buffer);
 
-size_t efx_nic_get_regs_len(struct efx_nic *efx);
-void efx_nic_get_regs(struct efx_nic *efx, void *buf);
+size_t efx_siena_get_regs_len(struct efx_nic *efx);
+void efx_siena_get_regs(struct efx_nic *efx, void *buf);
 
 #define EFX_MC_STATS_GENERATION_INVALID ((__force __le64)(-1))
 
-size_t efx_nic_describe_stats(const struct efx_hw_stat_desc *desc, size_t count,
-			      const unsigned long *mask, u8 *names);
-int efx_nic_copy_stats(struct efx_nic *efx, __le64 *dest);
-void efx_nic_update_stats(const struct efx_hw_stat_desc *desc, size_t count,
-			  const unsigned long *mask, u64 *stats,
-			  const void *dma_buf, bool accumulate);
-void efx_nic_fix_nodesc_drop_stat(struct efx_nic *efx, u64 *stat);
-static inline size_t efx_nic_update_stats_atomic(struct efx_nic *efx, u64 *full_stats,
-						 struct rtnl_link_stats64 *core_stats)
-{
-	if (efx->type->update_stats_atomic)
-		return efx->type->update_stats_atomic(efx, full_stats, core_stats);
-	return efx->type->update_stats(efx, full_stats, core_stats);
-}
+size_t efx_siena_describe_stats(const struct efx_hw_stat_desc *desc, size_t count,
+				const unsigned long *mask, u8 *names);
+void efx_siena_update_stats(const struct efx_hw_stat_desc *desc, size_t count,
+			    const unsigned long *mask, u64 *stats,
+			    const void *dma_buf, bool accumulate);
+void efx_siena_fix_nodesc_drop_stat(struct efx_nic *efx, u64 *stat);
 
 #define EFX_MAX_FLUSH_TIME 5000
 
diff --git a/drivers/net/ethernet/sfc/siena/ptp.c b/drivers/net/ethernet/sfc/siena/ptp.c
index 5b4717520c3e..8e18da096595 100644
--- a/drivers/net/ethernet/sfc/siena/ptp.c
+++ b/drivers/net/ethernet/sfc/siena/ptp.c
@@ -398,8 +398,8 @@ size_t efx_siena_ptp_describe_stats(struct efx_nic *efx, u8 *strings)
 	if (!efx->ptp_data)
 		return 0;
 
-	return efx_nic_describe_stats(efx_ptp_stat_desc, PTP_STAT_COUNT,
-				      efx_ptp_stat_mask, strings);
+	return efx_siena_describe_stats(efx_ptp_stat_desc, PTP_STAT_COUNT,
+					efx_ptp_stat_mask, strings);
 }
 
 size_t efx_siena_ptp_update_stats(struct efx_nic *efx, u64 *stats)
@@ -430,9 +430,9 @@ size_t efx_siena_ptp_update_stats(struct efx_nic *efx, u64 *stats)
 				outbuf, sizeof(outbuf), NULL);
 	if (rc)
 		memset(outbuf, 0, sizeof(outbuf));
-	efx_nic_update_stats(efx_ptp_stat_desc, PTP_STAT_COUNT,
-			     efx_ptp_stat_mask,
-			     stats, _MCDI_PTR(outbuf, 0), false);
+	efx_siena_update_stats(efx_ptp_stat_desc, PTP_STAT_COUNT,
+			       efx_ptp_stat_mask,
+			       stats, _MCDI_PTR(outbuf, 0), false);
 
 	return PTP_STAT_COUNT;
 }
@@ -1452,7 +1452,7 @@ static int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel)
 	ptp->channel = channel;
 	ptp->rx_ts_inline = efx_nic_rev(efx) >= EFX_REV_HUNT_A0;
 
-	rc = efx_nic_alloc_buffer(efx, &ptp->start, sizeof(int), GFP_KERNEL);
+	rc = efx_siena_alloc_buffer(efx, &ptp->start, sizeof(int), GFP_KERNEL);
 	if (rc != 0)
 		goto fail1;
 
@@ -1519,7 +1519,7 @@ static int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel)
 	destroy_workqueue(efx->ptp_data->workwq);
 
 fail2:
-	efx_nic_free_buffer(efx, &ptp->start);
+	efx_siena_free_buffer(efx, &ptp->start);
 
 fail1:
 	kfree(efx->ptp_data);
@@ -1574,7 +1574,7 @@ static void efx_ptp_remove(struct efx_nic *efx)
 
 	destroy_workqueue(efx->ptp_data->workwq);
 
-	efx_nic_free_buffer(efx, &efx->ptp_data->start);
+	efx_siena_free_buffer(efx, &efx->ptp_data->start);
 	kfree(efx->ptp_data);
 	efx->ptp_data = NULL;
 }
diff --git a/drivers/net/ethernet/sfc/siena/selftest.c b/drivers/net/ethernet/sfc/siena/selftest.c
index 2d70b3356ddf..07715a3d6bea 100644
--- a/drivers/net/ethernet/sfc/siena/selftest.c
+++ b/drivers/net/ethernet/sfc/siena/selftest.c
@@ -138,7 +138,7 @@ static int efx_test_interrupts(struct efx_nic *efx,
 	netif_dbg(efx, drv, efx->net_dev, "testing interrupts\n");
 	tests->interrupt = -1;
 
-	rc = efx_nic_irq_test_start(efx);
+	rc = efx_siena_irq_test_start(efx);
 	if (rc == -ENOTSUPP) {
 		netif_dbg(efx, drv, efx->net_dev,
 			  "direct interrupt testing not supported\n");
@@ -184,7 +184,7 @@ static int efx_test_eventq_irq(struct efx_nic *efx,
 		read_ptr[channel->channel] = channel->eventq_read_ptr;
 		set_bit(channel->channel, &dma_pend);
 		set_bit(channel->channel, &int_pend);
-		efx_nic_event_test_start(channel);
+		efx_siena_event_test_start(channel);
 	}
 
 	timeout = jiffies + IRQ_TIMEOUT;
@@ -204,7 +204,7 @@ static int efx_test_eventq_irq(struct efx_nic *efx,
 				clear_bit(channel->channel, &dma_pend);
 				clear_bit(channel->channel, &int_pend);
 			} else {
-				if (efx_nic_event_present(channel))
+				if (efx_siena_event_present(channel))
 					clear_bit(channel->channel, &dma_pend);
 				if (efx_nic_event_test_irq_cpu(channel) >= 0)
 					clear_bit(channel->channel, &int_pend);
@@ -772,7 +772,7 @@ void efx_siena_selftest_async_start(struct efx_nic *efx)
 	struct efx_channel *channel;
 
 	efx_for_each_channel(channel, efx)
-		efx_nic_event_test_start(channel);
+		efx_siena_event_test_start(channel);
 	schedule_delayed_work(&efx->selftest_work, IRQ_TIMEOUT);
 }
 
diff --git a/drivers/net/ethernet/sfc/siena/siena.c b/drivers/net/ethernet/sfc/siena/siena.c
index 74ed8e972c93..741313aff1d1 100644
--- a/drivers/net/ethernet/sfc/siena/siena.c
+++ b/drivers/net/ethernet/sfc/siena/siena.c
@@ -301,8 +301,8 @@ static int siena_probe_nic(struct efx_nic *efx)
 	siena_init_wol(efx);
 
 	/* Allocate memory for INT_KER */
-	rc = efx_nic_alloc_buffer(efx, &efx->irq_status, sizeof(efx_oword_t),
-				  GFP_KERNEL);
+	rc = efx_siena_alloc_buffer(efx, &efx->irq_status, sizeof(efx_oword_t),
+				    GFP_KERNEL);
 	if (rc)
 		goto fail4;
 	BUG_ON(efx->irq_status.dma_addr & 0x0f);
@@ -336,7 +336,7 @@ static int siena_probe_nic(struct efx_nic *efx)
 	return 0;
 
 fail5:
-	efx_nic_free_buffer(efx, &efx->irq_status);
+	efx_siena_free_buffer(efx, &efx->irq_status);
 fail4:
 fail3:
 	efx_siena_mcdi_detach(efx);
@@ -460,7 +460,7 @@ static void siena_remove_nic(struct efx_nic *efx)
 {
 	efx_siena_mcdi_mon_remove(efx);
 
-	efx_nic_free_buffer(efx, &efx->irq_status);
+	efx_siena_free_buffer(efx, &efx->irq_status);
 
 	efx_siena_mcdi_reset(efx, RESET_TYPE_ALL);
 
@@ -547,8 +547,8 @@ static const unsigned long siena_stat_mask[] = {
 
 static size_t siena_describe_nic_stats(struct efx_nic *efx, u8 *names)
 {
-	return efx_nic_describe_stats(siena_stat_desc, SIENA_STAT_COUNT,
-				      siena_stat_mask, names);
+	return efx_siena_describe_stats(siena_stat_desc, SIENA_STAT_COUNT,
+					siena_stat_mask, names);
 }
 
 static int siena_try_update_nic_stats(struct efx_nic *efx)
@@ -564,16 +564,16 @@ static int siena_try_update_nic_stats(struct efx_nic *efx)
 	if (generation_end == EFX_MC_STATS_GENERATION_INVALID)
 		return 0;
 	rmb();
-	efx_nic_update_stats(siena_stat_desc, SIENA_STAT_COUNT, siena_stat_mask,
-			     stats, efx->stats_buffer.addr, false);
+	efx_siena_update_stats(siena_stat_desc, SIENA_STAT_COUNT, siena_stat_mask,
+			       stats, efx->stats_buffer.addr, false);
 	rmb();
 	generation_start = dma_stats[MC_CMD_MAC_GENERATION_START];
 	if (generation_end != generation_start)
 		return -EAGAIN;
 
 	/* Update derived statistics */
-	efx_nic_fix_nodesc_drop_stat(efx,
-				     &stats[SIENA_STAT_rx_nodesc_drop_cnt]);
+	efx_siena_fix_nodesc_drop_stat(efx,
+				       &stats[SIENA_STAT_rx_nodesc_drop_cnt]);
 	efx_update_diff_stat(&stats[SIENA_STAT_tx_good_bytes],
 			     stats[SIENA_STAT_tx_bytes] -
 			     stats[SIENA_STAT_tx_bad_bytes]);
diff --git a/drivers/net/ethernet/sfc/siena/siena_sriov.c b/drivers/net/ethernet/sfc/siena/siena_sriov.c
index fdfcf480fd47..8353c15dc233 100644
--- a/drivers/net/ethernet/sfc/siena/siena_sriov.c
+++ b/drivers/net/ethernet/sfc/siena/siena_sriov.c
@@ -1012,9 +1012,9 @@ static void efx_siena_sriov_reset_vf_work(struct work_struct *work)
 	struct efx_nic *efx = vf->efx;
 	struct efx_buffer buf;
 
-	if (!efx_nic_alloc_buffer(efx, &buf, EFX_PAGE_SIZE, GFP_NOIO)) {
+	if (!efx_siena_alloc_buffer(efx, &buf, EFX_PAGE_SIZE, GFP_NOIO)) {
 		efx_siena_sriov_reset_vf(vf, &buf);
-		efx_nic_free_buffer(efx, &buf);
+		efx_siena_free_buffer(efx, &buf);
 	}
 }
 
@@ -1229,7 +1229,7 @@ static void efx_siena_sriov_vfs_fini(struct efx_nic *efx)
 	for (pos = 0; pos < efx->vf_count; ++pos) {
 		vf = nic_data->vf + pos;
 
-		efx_nic_free_buffer(efx, &vf->buf);
+		efx_siena_free_buffer(efx, &vf->buf);
 		kfree(vf->peer_page_addrs);
 		vf->peer_page_addrs = NULL;
 		vf->peer_page_count = 0;
@@ -1269,8 +1269,8 @@ static int efx_siena_sriov_vfs_init(struct efx_nic *efx)
 			 pci_domain_nr(pci_dev->bus), pci_dev->bus->number,
 			 PCI_SLOT(devfn), PCI_FUNC(devfn));
 
-		rc = efx_nic_alloc_buffer(efx, &vf->buf, EFX_PAGE_SIZE,
-					  GFP_KERNEL);
+		rc = efx_siena_alloc_buffer(efx, &vf->buf, EFX_PAGE_SIZE,
+					    GFP_KERNEL);
 		if (rc)
 			goto fail;
 
@@ -1303,8 +1303,8 @@ int efx_siena_sriov_init(struct efx_nic *efx)
 	if (rc)
 		goto fail_cmd;
 
-	rc = efx_nic_alloc_buffer(efx, &nic_data->vfdi_status,
-				  sizeof(*vfdi_status), GFP_KERNEL);
+	rc = efx_siena_alloc_buffer(efx, &nic_data->vfdi_status,
+				    sizeof(*vfdi_status), GFP_KERNEL);
 	if (rc)
 		goto fail_status;
 	vfdi_status = nic_data->vfdi_status.addr;
@@ -1359,7 +1359,7 @@ int efx_siena_sriov_init(struct efx_nic *efx)
 	efx_siena_sriov_free_local(efx);
 	kfree(nic_data->vf);
 fail_alloc:
-	efx_nic_free_buffer(efx, &nic_data->vfdi_status);
+	efx_siena_free_buffer(efx, &nic_data->vfdi_status);
 fail_status:
 	efx_siena_sriov_cmd(efx, false, NULL, NULL);
 fail_cmd:
@@ -1396,7 +1396,7 @@ void efx_siena_sriov_fini(struct efx_nic *efx)
 	efx_siena_sriov_vfs_fini(efx);
 	efx_siena_sriov_free_local(efx);
 	kfree(nic_data->vf);
-	efx_nic_free_buffer(efx, &nic_data->vfdi_status);
+	efx_siena_free_buffer(efx, &nic_data->vfdi_status);
 	efx_siena_sriov_cmd(efx, false, NULL, NULL);
 }
 
@@ -1564,7 +1564,7 @@ void efx_siena_sriov_reset(struct efx_nic *efx)
 	efx_siena_sriov_usrev(efx, true);
 	(void)efx_siena_sriov_cmd(efx, true, NULL, NULL);
 
-	if (efx_nic_alloc_buffer(efx, &buf, EFX_PAGE_SIZE, GFP_NOIO))
+	if (efx_siena_alloc_buffer(efx, &buf, EFX_PAGE_SIZE, GFP_NOIO))
 		return;
 
 	for (vf_i = 0; vf_i < efx->vf_init_count; ++vf_i) {
@@ -1572,7 +1572,7 @@ void efx_siena_sriov_reset(struct efx_nic *efx)
 		efx_siena_sriov_reset_vf(vf, &buf);
 	}
 
-	efx_nic_free_buffer(efx, &buf);
+	efx_siena_free_buffer(efx, &buf);
 }
 
 int efx_init_sriov(void)
diff --git a/drivers/net/ethernet/sfc/siena/tx.c b/drivers/net/ethernet/sfc/siena/tx.c
index ef238e9efa94..b84b9e348c13 100644
--- a/drivers/net/ethernet/sfc/siena/tx.c
+++ b/drivers/net/ethernet/sfc/siena/tx.c
@@ -33,8 +33,8 @@ static inline u8 *efx_tx_get_copy_buffer(struct efx_tx_queue *tx_queue,
 		((index << EFX_TX_CB_ORDER) + NET_IP_ALIGN) & (PAGE_SIZE - 1);
 
 	if (unlikely(!page_buf->addr) &&
-	    efx_nic_alloc_buffer(tx_queue->efx, page_buf, PAGE_SIZE,
-				 GFP_ATOMIC))
+	    efx_siena_alloc_buffer(tx_queue->efx, page_buf, PAGE_SIZE,
+				   GFP_ATOMIC))
 		return NULL;
 	buffer->dma_addr = page_buf->dma_addr + offset;
 	buffer->unmap_len = 0;
diff --git a/drivers/net/ethernet/sfc/siena/tx_common.c b/drivers/net/ethernet/sfc/siena/tx_common.c
index c4c053ecaaf5..6ee71fba857a 100644
--- a/drivers/net/ethernet/sfc/siena/tx_common.c
+++ b/drivers/net/ethernet/sfc/siena/tx_common.c
@@ -132,8 +132,8 @@ void efx_siena_remove_tx_queue(struct efx_tx_queue *tx_queue)
 
 	if (tx_queue->cb_page) {
 		for (i = 0; i < efx_tx_cb_page_count(tx_queue); i++)
-			efx_nic_free_buffer(tx_queue->efx,
-					    &tx_queue->cb_page[i]);
+			efx_siena_free_buffer(tx_queue->efx,
+					      &tx_queue->cb_page[i]);
 		kfree(tx_queue->cb_page);
 		tx_queue->cb_page = NULL;
 	}

