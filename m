Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36DAF50BAED
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 16:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449045AbiDVPBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449046AbiDVPBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:01:01 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D092B5C851
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 07:58:01 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 5B6A332025B;
        Fri, 22 Apr 2022 15:57:59 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhujN-00078h-C9; Fri, 22 Apr 2022 15:57:57 +0100
Subject: [PATCH net-next 04/28] sfc: Remove build references to missing
 functionality
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 15:57:56 +0100
Message-ID: <165063947636.27138.18421938705109715376.stgit@palantir17.mph.net>
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

Functionality not supported or needed on Siena includes:
- Anything for EF100
- EF10 specifics such as register access, PIO and TSO offload.
Also only bind to Siena NICs.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/efx.c        |   28 +---
 drivers/net/ethernet/sfc/siena/efx.h        |   15 --
 drivers/net/ethernet/sfc/siena/nic.c        |    7 -
 drivers/net/ethernet/sfc/siena/nic.h        |    3 
 drivers/net/ethernet/sfc/siena/nic_common.h |    3 
 drivers/net/ethernet/sfc/siena/tx.c         |  209 +--------------------------
 6 files changed, 13 insertions(+), 252 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index 5e7fe75cb1d4..f11e870b2eef 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -26,7 +26,6 @@
 #include "efx.h"
 #include "efx_common.h"
 #include "efx_channels.h"
-#include "ef100.h"
 #include "rx_common.h"
 #include "tx_common.h"
 #include "nic.h"
@@ -795,22 +794,10 @@ static void efx_unregister_netdev(struct efx_nic *efx)
 
 /* PCI device ID table */
 static const struct pci_device_id efx_pci_table[] = {
-	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0x0903),  /* SFC9120 PF */
-	 .driver_data = (unsigned long) &efx_hunt_a0_nic_type},
-	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0x1903),  /* SFC9120 VF */
-	 .driver_data = (unsigned long) &efx_hunt_a0_vf_nic_type},
-	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0x0923),  /* SFC9140 PF */
-	 .driver_data = (unsigned long) &efx_hunt_a0_nic_type},
-	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0x1923),  /* SFC9140 VF */
-	 .driver_data = (unsigned long) &efx_hunt_a0_vf_nic_type},
-	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0x0a03),  /* SFC9220 PF */
-	 .driver_data = (unsigned long) &efx_hunt_a0_nic_type},
-	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0x1a03),  /* SFC9220 VF */
-	 .driver_data = (unsigned long) &efx_hunt_a0_vf_nic_type},
-	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0x0b03),  /* SFC9250 PF */
-	 .driver_data = (unsigned long) &efx_hunt_a0_nic_type},
-	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0x1b03),  /* SFC9250 VF */
-	 .driver_data = (unsigned long) &efx_hunt_a0_vf_nic_type},
+	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0x0803),	/* SFC9020 */
+	 .driver_data = (unsigned long)&siena_a0_nic_type},
+	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0x0813),	/* SFL9021 */
+	 .driver_data = (unsigned long)&siena_a0_nic_type},
 	{0}			/* end of list */
 };
 
@@ -1298,14 +1285,8 @@ static int __init efx_init_module(void)
 	if (rc < 0)
 		goto err_pci;
 
-	rc = pci_register_driver(&ef100_pci_driver);
-	if (rc < 0)
-		goto err_pci_ef100;
-
 	return 0;
 
- err_pci_ef100:
-	pci_unregister_driver(&efx_pci_driver);
  err_pci:
 	efx_destroy_reset_workqueue();
  err_reset:
@@ -1318,7 +1299,6 @@ static void __exit efx_exit_module(void)
 {
 	printk(KERN_INFO "Solarflare NET driver unloading\n");
 
-	pci_unregister_driver(&ef100_pci_driver);
 	pci_unregister_driver(&efx_pci_driver);
 	efx_destroy_reset_workqueue();
 	unregister_netdevice_notifier(&efx_netdev_notifier);
diff --git a/drivers/net/ethernet/sfc/siena/efx.h b/drivers/net/ethernet/sfc/siena/efx.h
index c05a83da9e44..962c6b66eea7 100644
--- a/drivers/net/ethernet/sfc/siena/efx.h
+++ b/drivers/net/ethernet/sfc/siena/efx.h
@@ -10,8 +10,6 @@
 
 #include <linux/indirect_call_wrapper.h>
 #include "net_driver.h"
-#include "ef100_rx.h"
-#include "ef100_tx.h"
 #include "filter.h"
 
 int efx_net_open(struct net_device *net_dev);
@@ -24,9 +22,8 @@ netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
 netdev_tx_t __efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
 static inline netdev_tx_t efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 {
-	return INDIRECT_CALL_2(tx_queue->efx->type->tx_enqueue,
-			       ef100_enqueue_skb, __efx_enqueue_skb,
-			       tx_queue, skb);
+	return INDIRECT_CALL_1(tx_queue->efx->type->tx_enqueue,
+			       __efx_enqueue_skb, tx_queue, skb);
 }
 void efx_xmit_done_single(struct efx_tx_queue *tx_queue);
 int efx_setup_tc(struct net_device *net_dev, enum tc_setup_type type,
@@ -40,16 +37,10 @@ void efx_rx_packet(struct efx_rx_queue *rx_queue, unsigned int index,
 static inline void efx_rx_flush_packet(struct efx_channel *channel)
 {
 	if (channel->rx_pkt_n_frags)
-		INDIRECT_CALL_2(channel->efx->type->rx_packet,
-				__ef100_rx_packet, __efx_rx_packet,
-				channel);
+		__efx_rx_packet(channel);
 }
 static inline bool efx_rx_buf_hash_valid(struct efx_nic *efx, const u8 *prefix)
 {
-	if (efx->type->rx_buf_hash_valid)
-		return INDIRECT_CALL_1(efx->type->rx_buf_hash_valid,
-				       ef100_rx_buf_hash_valid,
-				       prefix);
 	return true;
 }
 
diff --git a/drivers/net/ethernet/sfc/siena/nic.c b/drivers/net/ethernet/sfc/siena/nic.c
index 22fbb0ae77fb..c59357178657 100644
--- a/drivers/net/ethernet/sfc/siena/nic.c
+++ b/drivers/net/ethernet/sfc/siena/nic.c
@@ -16,7 +16,6 @@
 #include "bitfield.h"
 #include "efx.h"
 #include "nic.h"
-#include "ef10_regs.h"
 #include "farch_regs.h"
 #include "io.h"
 #include "workarounds.h"
@@ -195,7 +194,6 @@ struct efx_nic_reg {
 #define REGISTER_BB(name) REGISTER(name, F, B, B)
 #define REGISTER_BZ(name) REGISTER(name, F, B, Z)
 #define REGISTER_CZ(name) REGISTER(name, F, C, Z)
-#define REGISTER_DZ(name) REGISTER(name, E, D, Z)
 
 static const struct efx_nic_reg efx_nic_regs[] = {
 	REGISTER_AZ(ADR_REGION),
@@ -302,9 +300,6 @@ static const struct efx_nic_reg efx_nic_regs[] = {
 	REGISTER_AB(XX_TXDRV_CTL),
 	/* XX_PRBS_CTL, XX_PRBS_CHK and XX_PRBS_ERR are not used */
 	/* XX_CORE_STAT is partly RC */
-	REGISTER_DZ(BIU_HW_REV_ID),
-	REGISTER_DZ(MC_DB_LWRD),
-	REGISTER_DZ(MC_DB_HWRD),
 };
 
 struct efx_nic_reg_table {
@@ -337,7 +332,6 @@ struct efx_nic_reg_table {
 				  FR_BZ_ ## name ## _STEP,		\
 				  FR_CZ_ ## name ## _ROWS)
 #define REGISTER_TABLE_CZ(name) REGISTER_TABLE(name, F, C, Z)
-#define REGISTER_TABLE_DZ(name) REGISTER_TABLE(name, E, D, Z)
 
 static const struct efx_nic_reg_table efx_nic_reg_tables[] = {
 	/* DRIVER is not used */
@@ -368,7 +362,6 @@ static const struct efx_nic_reg_table efx_nic_reg_tables[] = {
 	/* MSIX_PBA_TABLE is not mapped */
 	/* SRM_DBG is not mapped (and is redundant with BUF_FLL_TBL) */
 	REGISTER_TABLE_BZ(RX_FILTER_TBL0),
-	REGISTER_TABLE_DZ(BIU_MC_SFT_STATUS),
 };
 
 size_t efx_nic_get_regs_len(struct efx_nic *efx)
diff --git a/drivers/net/ethernet/sfc/siena/nic.h b/drivers/net/ethernet/sfc/siena/nic.h
index 251868235ae4..e87e4319748e 100644
--- a/drivers/net/ethernet/sfc/siena/nic.h
+++ b/drivers/net/ethernet/sfc/siena/nic.h
@@ -301,8 +301,7 @@ struct efx_ef10_nic_data {
 int efx_ef10_tx_tso_desc(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 			 bool *data_mapped);
 
-extern const struct efx_nic_type efx_hunt_a0_nic_type;
-extern const struct efx_nic_type efx_hunt_a0_vf_nic_type;
+extern const struct efx_nic_type siena_a0_nic_type;
 
 int falcon_probe_board(struct efx_nic *efx, u16 revision_info);
 
diff --git a/drivers/net/ethernet/sfc/siena/nic_common.h b/drivers/net/ethernet/sfc/siena/nic_common.h
index 0cef35c0c559..47deeae0a034 100644
--- a/drivers/net/ethernet/sfc/siena/nic_common.h
+++ b/drivers/net/ethernet/sfc/siena/nic_common.h
@@ -75,9 +75,6 @@ static inline bool efx_nic_tx_is_empty(struct efx_tx_queue *tx_queue, unsigned i
 	return ((empty_read_count ^ write_count) & ~EFX_EMPTY_COUNT_VALID) == 0;
 }
 
-int efx_enqueue_skb_tso(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
-			bool *data_mapped);
-
 /* Decide whether to push a TX descriptor to the NIC vs merely writing
  * the doorbell.  This can reduce latency when we are adding a single
  * descriptor to an empty queue, but is otherwise pointless.  Further,
diff --git a/drivers/net/ethernet/sfc/siena/tx.c b/drivers/net/ethernet/sfc/siena/tx.c
index d16e031e95f4..81ef6dc353f7 100644
--- a/drivers/net/ethernet/sfc/siena/tx.c
+++ b/drivers/net/ethernet/sfc/siena/tx.c
@@ -22,14 +22,6 @@
 #include "tx.h"
 #include "tx_common.h"
 #include "workarounds.h"
-#include "ef10_regs.h"
-
-#ifdef EFX_USE_PIO
-
-#define EFX_PIOBUF_SIZE_DEF ALIGN(256, L1_CACHE_BYTES)
-unsigned int efx_piobuf_size __read_mostly = EFX_PIOBUF_SIZE_DEF;
-
-#endif /* EFX_USE_PIO */
 
 static inline u8 *efx_tx_get_copy_buffer(struct efx_tx_queue *tx_queue,
 					 struct efx_tx_buffer *buffer)
@@ -123,173 +115,6 @@ static int efx_enqueue_skb_copy(struct efx_tx_queue *tx_queue,
 	return rc;
 }
 
-#ifdef EFX_USE_PIO
-
-struct efx_short_copy_buffer {
-	int used;
-	u8 buf[L1_CACHE_BYTES];
-};
-
-/* Copy to PIO, respecting that writes to PIO buffers must be dword aligned.
- * Advances piobuf pointer. Leaves additional data in the copy buffer.
- */
-static void efx_memcpy_toio_aligned(struct efx_nic *efx, u8 __iomem **piobuf,
-				    u8 *data, int len,
-				    struct efx_short_copy_buffer *copy_buf)
-{
-	int block_len = len & ~(sizeof(copy_buf->buf) - 1);
-
-	__iowrite64_copy(*piobuf, data, block_len >> 3);
-	*piobuf += block_len;
-	len -= block_len;
-
-	if (len) {
-		data += block_len;
-		BUG_ON(copy_buf->used);
-		BUG_ON(len > sizeof(copy_buf->buf));
-		memcpy(copy_buf->buf, data, len);
-		copy_buf->used = len;
-	}
-}
-
-/* Copy to PIO, respecting dword alignment, popping data from copy buffer first.
- * Advances piobuf pointer. Leaves additional data in the copy buffer.
- */
-static void efx_memcpy_toio_aligned_cb(struct efx_nic *efx, u8 __iomem **piobuf,
-				       u8 *data, int len,
-				       struct efx_short_copy_buffer *copy_buf)
-{
-	if (copy_buf->used) {
-		/* if the copy buffer is partially full, fill it up and write */
-		int copy_to_buf =
-			min_t(int, sizeof(copy_buf->buf) - copy_buf->used, len);
-
-		memcpy(copy_buf->buf + copy_buf->used, data, copy_to_buf);
-		copy_buf->used += copy_to_buf;
-
-		/* if we didn't fill it up then we're done for now */
-		if (copy_buf->used < sizeof(copy_buf->buf))
-			return;
-
-		__iowrite64_copy(*piobuf, copy_buf->buf,
-				 sizeof(copy_buf->buf) >> 3);
-		*piobuf += sizeof(copy_buf->buf);
-		data += copy_to_buf;
-		len -= copy_to_buf;
-		copy_buf->used = 0;
-	}
-
-	efx_memcpy_toio_aligned(efx, piobuf, data, len, copy_buf);
-}
-
-static void efx_flush_copy_buffer(struct efx_nic *efx, u8 __iomem *piobuf,
-				  struct efx_short_copy_buffer *copy_buf)
-{
-	/* if there's anything in it, write the whole buffer, including junk */
-	if (copy_buf->used)
-		__iowrite64_copy(piobuf, copy_buf->buf,
-				 sizeof(copy_buf->buf) >> 3);
-}
-
-/* Traverse skb structure and copy fragments in to PIO buffer.
- * Advances piobuf pointer.
- */
-static void efx_skb_copy_bits_to_pio(struct efx_nic *efx, struct sk_buff *skb,
-				     u8 __iomem **piobuf,
-				     struct efx_short_copy_buffer *copy_buf)
-{
-	int i;
-
-	efx_memcpy_toio_aligned(efx, piobuf, skb->data, skb_headlen(skb),
-				copy_buf);
-
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; ++i) {
-		skb_frag_t *f = &skb_shinfo(skb)->frags[i];
-		u8 *vaddr;
-
-		vaddr = kmap_atomic(skb_frag_page(f));
-
-		efx_memcpy_toio_aligned_cb(efx, piobuf, vaddr + skb_frag_off(f),
-					   skb_frag_size(f), copy_buf);
-		kunmap_atomic(vaddr);
-	}
-
-	EFX_WARN_ON_ONCE_PARANOID(skb_shinfo(skb)->frag_list);
-}
-
-static int efx_enqueue_skb_pio(struct efx_tx_queue *tx_queue,
-			       struct sk_buff *skb)
-{
-	struct efx_tx_buffer *buffer =
-		efx_tx_queue_get_insert_buffer(tx_queue);
-	u8 __iomem *piobuf = tx_queue->piobuf;
-
-	/* Copy to PIO buffer. Ensure the writes are padded to the end
-	 * of a cache line, as this is required for write-combining to be
-	 * effective on at least x86.
-	 */
-
-	if (skb_shinfo(skb)->nr_frags) {
-		/* The size of the copy buffer will ensure all writes
-		 * are the size of a cache line.
-		 */
-		struct efx_short_copy_buffer copy_buf;
-
-		copy_buf.used = 0;
-
-		efx_skb_copy_bits_to_pio(tx_queue->efx, skb,
-					 &piobuf, &copy_buf);
-		efx_flush_copy_buffer(tx_queue->efx, piobuf, &copy_buf);
-	} else {
-		/* Pad the write to the size of a cache line.
-		 * We can do this because we know the skb_shared_info struct is
-		 * after the source, and the destination buffer is big enough.
-		 */
-		BUILD_BUG_ON(L1_CACHE_BYTES >
-			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
-		__iowrite64_copy(tx_queue->piobuf, skb->data,
-				 ALIGN(skb->len, L1_CACHE_BYTES) >> 3);
-	}
-
-	buffer->skb = skb;
-	buffer->flags = EFX_TX_BUF_SKB | EFX_TX_BUF_OPTION;
-
-	EFX_POPULATE_QWORD_5(buffer->option,
-			     ESF_DZ_TX_DESC_IS_OPT, 1,
-			     ESF_DZ_TX_OPTION_TYPE, ESE_DZ_TX_OPTION_DESC_PIO,
-			     ESF_DZ_TX_PIO_CONT, 0,
-			     ESF_DZ_TX_PIO_BYTE_CNT, skb->len,
-			     ESF_DZ_TX_PIO_BUF_ADDR,
-			     tx_queue->piobuf_offset);
-	++tx_queue->insert_count;
-	return 0;
-}
-
-/* Decide whether we can use TX PIO, ie. write packet data directly into
- * a buffer on the device.  This can reduce latency at the expense of
- * throughput, so we only do this if both hardware and software TX rings
- * are empty, including all queues for the channel.  This also ensures that
- * only one packet at a time can be using the PIO buffer. If the xmit_more
- * flag is set then we don't use this - there'll be another packet along
- * shortly and we want to hold off the doorbell.
- */
-static bool efx_tx_may_pio(struct efx_tx_queue *tx_queue)
-{
-	struct efx_channel *channel = tx_queue->channel;
-
-	if (!tx_queue->piobuf)
-		return false;
-
-	EFX_WARN_ON_ONCE_PARANOID(!channel->efx->type->option_descriptors);
-
-	efx_for_each_channel_tx_queue(tx_queue, channel)
-		if (!efx_nic_tx_is_empty(tx_queue, tx_queue->packet_write_count))
-			return false;
-
-	return true;
-}
-#endif /* EFX_USE_PIO */
-
 /* Send any pending traffic for a channel. xmit_more is shared across all
  * queues for a channel, so we must check all of them.
  */
@@ -338,35 +163,11 @@ netdev_tx_t __efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb
 	 * size limit.
 	 */
 	if (segments) {
-		switch (tx_queue->tso_version) {
-		case 1:
-			rc = efx_enqueue_skb_tso(tx_queue, skb, &data_mapped);
-			break;
-		case 2:
-			rc = efx_ef10_tx_tso_desc(tx_queue, skb, &data_mapped);
-			break;
-		case 0: /* No TSO on this queue, SW fallback needed */
-		default:
-			rc = -EINVAL;
-			break;
-		}
-		if (rc == -EINVAL) {
-			rc = efx_tx_tso_fallback(tx_queue, skb);
-			tx_queue->tso_fallbacks++;
-			if (rc == 0)
-				return 0;
-		}
-		if (rc)
-			goto err;
-#ifdef EFX_USE_PIO
-	} else if (skb_len <= efx_piobuf_size && !xmit_more &&
-		   efx_tx_may_pio(tx_queue)) {
-		/* Use PIO for short packets with an empty queue. */
-		if (efx_enqueue_skb_pio(tx_queue, skb))
-			goto err;
-		tx_queue->pio_packets++;
-		data_mapped = true;
-#endif
+		rc = efx_tx_tso_fallback(tx_queue, skb);
+		tx_queue->tso_fallbacks++;
+		if (rc == 0)
+			return 0;
+		goto err;
 	} else if (skb->data_len && skb_len <= EFX_TX_CB_SIZE) {
 		/* Pad short packets or coalesce short fragmented packets. */
 		if (efx_enqueue_skb_copy(tx_queue, skb))

