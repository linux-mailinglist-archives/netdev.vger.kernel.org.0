Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3326150BAF8
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449082AbiDVPCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449097AbiDVPCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:02:07 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B32885C861
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 07:58:58 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 2898332025B;
        Fri, 22 Apr 2022 15:58:51 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhukD-00079c-PC; Fri, 22 Apr 2022 15:58:49 +0100
Subject: [PATCH net-next 08/28] sfc/siena: Update nic.h to avoid conflicts
 with sfc
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 15:58:48 +0100
Message-ID: <165063952880.27138.10824380061645190000.stgit@palantir17.mph.net>
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

Remove EF10 specifics.
The functions that start with efx_farch_ will be removed from sfc.ko
with a subsequent patch.
Add the efx_ prefix to siena_prepare_flush() to make it consistent
with the other APIs.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/nic.h         |  187 --------------------------
 drivers/net/ethernet/sfc/siena/ptp.c         |   11 --
 drivers/net/ethernet/sfc/siena/siena.c       |    4 -
 drivers/net/ethernet/sfc/siena/siena_sriov.c |    2 
 drivers/net/ethernet/sfc/siena/workarounds.h |    6 -
 5 files changed, 4 insertions(+), 206 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/nic.h b/drivers/net/ethernet/sfc/siena/nic.h
index e87e4319748e..935cb0ab5ec0 100644
--- a/drivers/net/ethernet/sfc/siena/nic.h
+++ b/drivers/net/ethernet/sfc/siena/nic.h
@@ -116,191 +116,6 @@ struct siena_nic_data {
 #endif
 };
 
-enum {
-	EF10_STAT_port_tx_bytes = GENERIC_STAT_COUNT,
-	EF10_STAT_port_tx_packets,
-	EF10_STAT_port_tx_pause,
-	EF10_STAT_port_tx_control,
-	EF10_STAT_port_tx_unicast,
-	EF10_STAT_port_tx_multicast,
-	EF10_STAT_port_tx_broadcast,
-	EF10_STAT_port_tx_lt64,
-	EF10_STAT_port_tx_64,
-	EF10_STAT_port_tx_65_to_127,
-	EF10_STAT_port_tx_128_to_255,
-	EF10_STAT_port_tx_256_to_511,
-	EF10_STAT_port_tx_512_to_1023,
-	EF10_STAT_port_tx_1024_to_15xx,
-	EF10_STAT_port_tx_15xx_to_jumbo,
-	EF10_STAT_port_rx_bytes,
-	EF10_STAT_port_rx_bytes_minus_good_bytes,
-	EF10_STAT_port_rx_good_bytes,
-	EF10_STAT_port_rx_bad_bytes,
-	EF10_STAT_port_rx_packets,
-	EF10_STAT_port_rx_good,
-	EF10_STAT_port_rx_bad,
-	EF10_STAT_port_rx_pause,
-	EF10_STAT_port_rx_control,
-	EF10_STAT_port_rx_unicast,
-	EF10_STAT_port_rx_multicast,
-	EF10_STAT_port_rx_broadcast,
-	EF10_STAT_port_rx_lt64,
-	EF10_STAT_port_rx_64,
-	EF10_STAT_port_rx_65_to_127,
-	EF10_STAT_port_rx_128_to_255,
-	EF10_STAT_port_rx_256_to_511,
-	EF10_STAT_port_rx_512_to_1023,
-	EF10_STAT_port_rx_1024_to_15xx,
-	EF10_STAT_port_rx_15xx_to_jumbo,
-	EF10_STAT_port_rx_gtjumbo,
-	EF10_STAT_port_rx_bad_gtjumbo,
-	EF10_STAT_port_rx_overflow,
-	EF10_STAT_port_rx_align_error,
-	EF10_STAT_port_rx_length_error,
-	EF10_STAT_port_rx_nodesc_drops,
-	EF10_STAT_port_rx_pm_trunc_bb_overflow,
-	EF10_STAT_port_rx_pm_discard_bb_overflow,
-	EF10_STAT_port_rx_pm_trunc_vfifo_full,
-	EF10_STAT_port_rx_pm_discard_vfifo_full,
-	EF10_STAT_port_rx_pm_trunc_qbb,
-	EF10_STAT_port_rx_pm_discard_qbb,
-	EF10_STAT_port_rx_pm_discard_mapping,
-	EF10_STAT_port_rx_dp_q_disabled_packets,
-	EF10_STAT_port_rx_dp_di_dropped_packets,
-	EF10_STAT_port_rx_dp_streaming_packets,
-	EF10_STAT_port_rx_dp_hlb_fetch,
-	EF10_STAT_port_rx_dp_hlb_wait,
-	EF10_STAT_rx_unicast,
-	EF10_STAT_rx_unicast_bytes,
-	EF10_STAT_rx_multicast,
-	EF10_STAT_rx_multicast_bytes,
-	EF10_STAT_rx_broadcast,
-	EF10_STAT_rx_broadcast_bytes,
-	EF10_STAT_rx_bad,
-	EF10_STAT_rx_bad_bytes,
-	EF10_STAT_rx_overflow,
-	EF10_STAT_tx_unicast,
-	EF10_STAT_tx_unicast_bytes,
-	EF10_STAT_tx_multicast,
-	EF10_STAT_tx_multicast_bytes,
-	EF10_STAT_tx_broadcast,
-	EF10_STAT_tx_broadcast_bytes,
-	EF10_STAT_tx_bad,
-	EF10_STAT_tx_bad_bytes,
-	EF10_STAT_tx_overflow,
-	EF10_STAT_V1_COUNT,
-	EF10_STAT_fec_uncorrected_errors = EF10_STAT_V1_COUNT,
-	EF10_STAT_fec_corrected_errors,
-	EF10_STAT_fec_corrected_symbols_lane0,
-	EF10_STAT_fec_corrected_symbols_lane1,
-	EF10_STAT_fec_corrected_symbols_lane2,
-	EF10_STAT_fec_corrected_symbols_lane3,
-	EF10_STAT_ctpio_vi_busy_fallback,
-	EF10_STAT_ctpio_long_write_success,
-	EF10_STAT_ctpio_missing_dbell_fail,
-	EF10_STAT_ctpio_overflow_fail,
-	EF10_STAT_ctpio_underflow_fail,
-	EF10_STAT_ctpio_timeout_fail,
-	EF10_STAT_ctpio_noncontig_wr_fail,
-	EF10_STAT_ctpio_frm_clobber_fail,
-	EF10_STAT_ctpio_invalid_wr_fail,
-	EF10_STAT_ctpio_vi_clobber_fallback,
-	EF10_STAT_ctpio_unqualified_fallback,
-	EF10_STAT_ctpio_runt_fallback,
-	EF10_STAT_ctpio_success,
-	EF10_STAT_ctpio_fallback,
-	EF10_STAT_ctpio_poison,
-	EF10_STAT_ctpio_erase,
-	EF10_STAT_COUNT
-};
-
-/* Maximum number of TX PIO buffers we may allocate to a function.
- * This matches the total number of buffers on each SFC9100-family
- * controller.
- */
-#define EF10_TX_PIOBUF_COUNT 16
-
-/**
- * struct efx_ef10_nic_data - EF10 architecture NIC state
- * @mcdi_buf: DMA buffer for MCDI
- * @warm_boot_count: Last seen MC warm boot count
- * @vi_base: Absolute index of first VI in this function
- * @n_allocated_vis: Number of VIs allocated to this function
- * @n_piobufs: Number of PIO buffers allocated to this function
- * @wc_membase: Base address of write-combining mapping of the memory BAR
- * @pio_write_base: Base address for writing PIO buffers
- * @pio_write_vi_base: Relative VI number for @pio_write_base
- * @piobuf_handle: Handle of each PIO buffer allocated
- * @piobuf_size: size of a single PIO buffer
- * @must_restore_piobufs: Flag: PIO buffers have yet to be restored after MC
- *	reboot
- * @mc_stats: Scratch buffer for converting statistics to the kernel's format
- * @stats: Hardware statistics
- * @workaround_35388: Flag: firmware supports workaround for bug 35388
- * @workaround_26807: Flag: firmware supports workaround for bug 26807
- * @workaround_61265: Flag: firmware supports workaround for bug 61265
- * @must_check_datapath_caps: Flag: @datapath_caps needs to be revalidated
- *	after MC reboot
- * @datapath_caps: Capabilities of datapath firmware (FLAGS1 field of
- *	%MC_CMD_GET_CAPABILITIES response)
- * @datapath_caps2: Further Capabilities of datapath firmware (FLAGS2 field of
- * %MC_CMD_GET_CAPABILITIES response)
- * @rx_dpcpu_fw_id: Firmware ID of the RxDPCPU
- * @tx_dpcpu_fw_id: Firmware ID of the TxDPCPU
- * @must_probe_vswitching: Flag: vswitching has yet to be setup after MC reboot
- * @pf_index: The number for this PF, or the parent PF if this is a VF
-#ifdef CONFIG_SFC_SRIOV
- * @vf: Pointer to VF data structure
-#endif
- * @vport_mac: The MAC address on the vport, only for PFs; VFs will be zero
- * @vlan_list: List of VLANs added over the interface. Serialised by vlan_lock.
- * @vlan_lock: Lock to serialize access to vlan_list.
- * @udp_tunnels: UDP tunnel port numbers and types.
- * @udp_tunnels_dirty: flag indicating a reboot occurred while pushing
- *	@udp_tunnels to hardware and thus the push must be re-done.
- * @udp_tunnels_lock: Serialises writes to @udp_tunnels and @udp_tunnels_dirty.
- */
-struct efx_ef10_nic_data {
-	struct efx_buffer mcdi_buf;
-	u16 warm_boot_count;
-	unsigned int vi_base;
-	unsigned int n_allocated_vis;
-	unsigned int n_piobufs;
-	void __iomem *wc_membase, *pio_write_base;
-	unsigned int pio_write_vi_base;
-	unsigned int piobuf_handle[EF10_TX_PIOBUF_COUNT];
-	u16 piobuf_size;
-	bool must_restore_piobufs;
-	__le64 *mc_stats;
-	u64 stats[EF10_STAT_COUNT];
-	bool workaround_35388;
-	bool workaround_26807;
-	bool workaround_61265;
-	bool must_check_datapath_caps;
-	u32 datapath_caps;
-	u32 datapath_caps2;
-	unsigned int rx_dpcpu_fw_id;
-	unsigned int tx_dpcpu_fw_id;
-	bool must_probe_vswitching;
-	unsigned int pf_index;
-	u8 port_id[ETH_ALEN];
-#ifdef CONFIG_SFC_SRIOV
-	unsigned int vf_index;
-	struct ef10_vf *vf;
-#endif
-	u8 vport_mac[ETH_ALEN];
-	struct list_head vlan_list;
-	struct mutex vlan_lock;
-	struct efx_udp_tunnel udp_tunnels[16];
-	bool udp_tunnels_dirty;
-	struct mutex udp_tunnels_lock;
-	u64 licensed_features;
-};
-
-/* TSOv2 */
-int efx_ef10_tx_tso_desc(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
-			 bool *data_mapped);
-
 extern const struct efx_nic_type siena_a0_nic_type;
 
 int falcon_probe_board(struct efx_nic *efx, u16 revision_info);
@@ -363,7 +178,7 @@ irqreturn_t efx_farch_legacy_interrupt(int irq, void *dev_id);
 irqreturn_t efx_farch_fatal_interrupt(struct efx_nic *efx);
 
 /* Global Resources */
-void siena_prepare_flush(struct efx_nic *efx);
+void efx_siena_prepare_flush(struct efx_nic *efx);
 int efx_farch_fini_dmaq(struct efx_nic *efx);
 void efx_farch_finish_flr(struct efx_nic *efx);
 void siena_finish_flush(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/siena/ptp.c b/drivers/net/ethernet/sfc/siena/ptp.c
index f0ef515e2ade..daf23070d353 100644
--- a/drivers/net/ethernet/sfc/siena/ptp.c
+++ b/drivers/net/ethernet/sfc/siena/ptp.c
@@ -1790,17 +1790,6 @@ void efx_ptp_get_ts_info(struct efx_nic *efx, struct ethtool_ts_info *ts_info)
 	ts_info->so_timestamping |= (SOF_TIMESTAMPING_TX_HARDWARE |
 				     SOF_TIMESTAMPING_RX_HARDWARE |
 				     SOF_TIMESTAMPING_RAW_HARDWARE);
-	/* Check licensed features.  If we don't have the license for TX
-	 * timestamps, the NIC will not support them.
-	 */
-	if (efx_ptp_use_mac_tx_timestamps(efx)) {
-		struct efx_ef10_nic_data *nic_data = efx->nic_data;
-
-		if (!(nic_data->licensed_features &
-		      (1 << LICENSED_V3_FEATURES_TX_TIMESTAMPS_LBN)))
-			ts_info->so_timestamping &=
-				~SOF_TIMESTAMPING_TX_HARDWARE;
-	}
 	if (primary && primary->ptp_data && primary->ptp_data->phc_clock)
 		ts_info->phc_index =
 			ptp_clock_index(primary->ptp_data->phc_clock);
diff --git a/drivers/net/ethernet/sfc/siena/siena.c b/drivers/net/ethernet/sfc/siena/siena.c
index 4514f15798ed..726dd4b72779 100644
--- a/drivers/net/ethernet/sfc/siena/siena.c
+++ b/drivers/net/ethernet/sfc/siena/siena.c
@@ -56,7 +56,7 @@ static void siena_push_irq_moderation(struct efx_channel *channel)
 			       channel->channel);
 }
 
-void siena_prepare_flush(struct efx_nic *efx)
+void efx_siena_prepare_flush(struct efx_nic *efx)
 {
 	if (efx->fc_disable++ == 0)
 		efx_mcdi_set_mac(efx);
@@ -992,7 +992,7 @@ const struct efx_nic_type siena_a0_nic_type = {
 	.probe_port = efx_mcdi_port_probe,
 	.remove_port = efx_mcdi_port_remove,
 	.fini_dmaq = efx_farch_fini_dmaq,
-	.prepare_flush = siena_prepare_flush,
+	.prepare_flush = efx_siena_prepare_flush,
 	.finish_flush = siena_finish_flush,
 	.prepare_flr = efx_siena_port_dummy_op_void,
 	.finish_flr = efx_farch_finish_flr,
diff --git a/drivers/net/ethernet/sfc/siena/siena_sriov.c b/drivers/net/ethernet/sfc/siena/siena_sriov.c
index 1020b72e1c68..f8e14f0d2f34 100644
--- a/drivers/net/ethernet/sfc/siena/siena_sriov.c
+++ b/drivers/net/ethernet/sfc/siena/siena_sriov.c
@@ -689,7 +689,7 @@ static int efx_vfdi_fini_all_queues(struct siena_vf *vf)
 		     MC_CMD_FLUSH_RX_QUEUES_IN_QID_OFST_MAXNUM);
 
 	rtnl_lock();
-	siena_prepare_flush(efx);
+	efx_siena_prepare_flush(efx);
 	rtnl_unlock();
 
 	/* Flush all the initialized queues */
diff --git a/drivers/net/ethernet/sfc/siena/workarounds.h b/drivers/net/ethernet/sfc/siena/workarounds.h
index 815be2d20c4b..42fb143a94ab 100644
--- a/drivers/net/ethernet/sfc/siena/workarounds.h
+++ b/drivers/net/ethernet/sfc/siena/workarounds.h
@@ -21,12 +21,6 @@
 /* Legacy interrupt storm when interrupt fifo fills */
 #define EFX_WORKAROUND_17213 EFX_WORKAROUND_SIENA
 
-/* Lockup when writing event block registers at gen2/gen3 */
-#define EFX_EF10_WORKAROUND_35388(efx)					\
-	(((struct efx_ef10_nic_data *)efx->nic_data)->workaround_35388)
-#define EFX_WORKAROUND_35388(efx)					\
-	(efx_nic_rev(efx) == EFX_REV_HUNT_A0 && EFX_EF10_WORKAROUND_35388(efx))
-
 /* Moderation timer access must go through MCDI */
 #define EFX_EF10_WORKAROUND_61265(efx)					\
 	(((struct efx_ef10_nic_data *)efx->nic_data)->workaround_61265)

