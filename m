Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04315522A60
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbiEKDTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbiEKDTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:19:34 -0400
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B30B6CAB3
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:19:27 -0700 (PDT)
X-QQ-mid: bizesmtp75t1652239162tdqrrazw
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 11 May 2022 11:19:22 +0800 (CST)
X-QQ-SSF: 01400000000000F0O000B00A0000000
X-QQ-FEAT: HoyAXBWgskkuiMtO40f0rQeZBhqJFG+zNbB4sF30bUy5yJmdMRjU+cTJx0m+D
        OrHxp8wNljGUnkN61VN18kwDXzRTfqBSTukYWiKtfebLKxvu5XFy42y/xwXYT+iBHD1MdZr
        rTtwnMSJEOPBM4bht9M9czjCAh4jb/EXP4Czw0rOwQbdiFc2kFT6gdZ6di3kiReulKGUhi8
        TRw3g4SMPEIByKMwa0oGign4DCWgFtXL4VNsj6Spp/A7wfcfxgaa9mCqwX5O0N5FfMDW+QF
        TrkGEeVaywoyiiyHXVzXc7AVTWhZUTQMZtGI1oXE+kbWFnPVr8kvKkPIyohDL+529NnpON2
        0hN+eLi+lwo483o/8plO8E91bBiGQ1+TGfGha/g
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 08/14] net: txgbe: Support flow director
Date:   Wed, 11 May 2022 11:26:53 +0800
Message-Id: <20220511032659.641834-9-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220511032659.641834-1-jiawenwu@trustnetic.com>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybgforeign:qybgforeign9
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add to support flow director signature and perfect filters.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  34 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 609 ++++++++++++++++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |  24 +
 .../net/ethernet/wangxun/txgbe/txgbe_lib.c    |  27 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 293 ++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  81 +++
 6 files changed, 1064 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 2fd11dfa43b4..7a6683b33930 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -150,6 +150,7 @@ struct txgbe_rx_queue_stats {
 
 enum txgbe_ring_state_t {
 	__TXGBE_RX_BUILD_SKB_ENABLED,
+	__TXGBE_TX_FDIR_INIT_DONE,
 	__TXGBE_TX_XPS_INIT_DONE,
 	__TXGBE_TX_DETECT_HANG,
 	__TXGBE_HANG_CHECK_ARMED,
@@ -200,7 +201,14 @@ struct txgbe_ring {
 	u16 next_to_use;
 	u16 next_to_clean;
 	u16 rx_buf_len;
-	u16 next_to_alloc;
+	union {
+		u16 next_to_alloc;
+		struct {
+			u8 atr_sample_rate;
+			u8 atr_count;
+		};
+	};
+
 	struct txgbe_queue_stats stats;
 	struct u64_stats_sync syncp;
 
@@ -213,6 +221,7 @@ struct txgbe_ring {
 enum txgbe_ring_f_enum {
 	RING_F_NONE = 0,
 	RING_F_RSS,
+	RING_F_FDIR,
 	RING_F_ARRAY_SIZE  /* must be last in enum set */
 };
 
@@ -352,6 +361,8 @@ struct txgbe_mac_addr {
 #define TXGBE_FLAG_MSIX_ENABLED                 ((u32)(1 << 3))
 #define TXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE        ((u32)(1 << 4))
 #define TXGBE_FLAG_VXLAN_OFFLOAD_ENABLE         ((u32)(1 << 5))
+#define TXGBE_FLAG_FDIR_HASH_CAPABLE            ((u32)(1 << 6))
+#define TXGBE_FLAG_FDIR_PERFECT_CAPABLE         ((u32)(1 << 7))
 
 /**
  * txgbe_adapter.flag2
@@ -367,6 +378,7 @@ struct txgbe_mac_addr {
 #define TXGBE_FLAG2_RSS_FIELD_IPV4_UDP          (1U << 8)
 #define TXGBE_FLAG2_RSS_FIELD_IPV6_UDP          (1U << 9)
 #define TXGBE_FLAG2_RSS_ENABLED                 (1U << 10)
+#define TXGBE_FLAG2_FDIR_REQUIRES_REINIT        (1U << 11)
 
 #define TXGBE_SET_FLAG(_input, _flag, _result) \
 	((_flag <= _result) ? \
@@ -397,6 +409,9 @@ struct txgbe_adapter {
 	u32 flags2;
 	u8 backplane_an;
 	u8 an37;
+
+	bool cloud_mode;
+
 	/* Tx fast path data */
 	int num_tx_queues;
 	u16 tx_itr_setting;
@@ -448,7 +463,13 @@ struct txgbe_adapter {
 
 	struct timer_list service_timer;
 	struct work_struct service_task;
+	struct hlist_head fdir_filter_list;
+	unsigned long fdir_overflow; /* number of times ATR was backed off */
+	union txgbe_atr_input fdir_mask;
+	int fdir_filter_count;
+	u32 fdir_pballoc;
 	u32 atr_sample_rate;
+	spinlock_t fdir_perfect_lock;
 
 	u8 __iomem *io_addr;    /* Mainly for iounmap use */
 
@@ -486,6 +507,13 @@ static inline u32 txgbe_misc_isb(struct txgbe_adapter *adapter,
 	return adapter->isb_mem[idx];
 }
 
+struct txgbe_fdir_filter {
+	struct  hlist_node fdir_node;
+	union txgbe_atr_input filter;
+	u16 sw_idx;
+	u16 action;
+};
+
 enum txgbe_state_t {
 	__TXGBE_TESTING,
 	__TXGBE_RESETTING,
@@ -653,6 +681,10 @@ static inline struct device *pci_dev_to_dev(struct pci_dev *pdev)
 
 extern u16 txgbe_read_pci_cfg_word(struct txgbe_hw *hw, u32 reg);
 
+#define TXGBE_HTONL(_i) htonl(_i)
+#define TXGBE_NTOHL(_i) ntohl(_i)
+#define TXGBE_NTOHS(_i) ntohs(_i)
+
 enum {
 	TXGBE_ERROR_SOFTWARE,
 	TXGBE_ERROR_POLLING,
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 70db88dfb412..040ddb0e46fd 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -4065,6 +4065,615 @@ s32 txgbe_reset_hw(struct txgbe_hw *hw)
 	return status;
 }
 
+/**
+ * txgbe_fdir_check_cmd_complete - poll to check whether FDIRCMD is complete
+ * @hw: pointer to hardware structure
+ * @fdircmd: current value of FDIRCMD register
+ */
+static s32 txgbe_fdir_check_cmd_complete(struct txgbe_hw *hw, u32 *fdircmd)
+{
+	int i;
+
+	for (i = 0; i < TXGBE_RDB_FDIR_CMD_CMD_POLL; i++) {
+		*fdircmd = rd32(hw, TXGBE_RDB_FDIR_CMD);
+		if (!(*fdircmd & TXGBE_RDB_FDIR_CMD_CMD_MASK))
+			return 0;
+		usec_delay(10);
+	}
+
+	return TXGBE_ERR_FDIR_CMD_INCOMPLETE;
+}
+
+/**
+ *  txgbe_reinit_fdir_tables - Reinitialize Flow Director tables.
+ *  @hw: pointer to hardware structure
+ **/
+s32 txgbe_reinit_fdir_tables(struct txgbe_hw *hw)
+{
+	s32 err;
+	int i;
+	u32 fdirctrl = rd32(hw, TXGBE_RDB_FDIR_CTL);
+	u32 fdircmd;
+
+	fdirctrl &= ~TXGBE_RDB_FDIR_CTL_INIT_DONE;
+
+	/* Before starting reinitialization process,
+	 * FDIRCMD.CMD must be zero.
+	 */
+	err = txgbe_fdir_check_cmd_complete(hw, &fdircmd);
+	if (err) {
+		DEBUGOUT("Flow Director previous command did not complete, aborting table re-initialization.\n");
+		return err;
+	}
+
+	wr32(hw, TXGBE_RDB_FDIR_FREE, 0);
+	TXGBE_WRITE_FLUSH(hw);
+	/* Sapphire adapters flow director init flow cannot be restarted,
+	 * workaround sapphire silicon errata by performing the following steps
+	 * before re-writing the FDIRCTRL control register with the same value.
+	 * - write 1 to bit 8 of FDIRCMD register &
+	 * - write 0 to bit 8 of FDIRCMD register
+	 */
+	wr32m(hw, TXGBE_RDB_FDIR_CMD,
+	      TXGBE_RDB_FDIR_CMD_CLEARHT, TXGBE_RDB_FDIR_CMD_CLEARHT);
+	TXGBE_WRITE_FLUSH(hw);
+	wr32m(hw, TXGBE_RDB_FDIR_CMD,
+	      TXGBE_RDB_FDIR_CMD_CLEARHT, 0);
+	TXGBE_WRITE_FLUSH(hw);
+	/* Clear FDIR Hash register to clear any leftover hashes
+	 * waiting to be programmed.
+	 */
+	wr32(hw, TXGBE_RDB_FDIR_HASH, 0x00);
+	TXGBE_WRITE_FLUSH(hw);
+
+	wr32(hw, TXGBE_RDB_FDIR_CTL, fdirctrl);
+	TXGBE_WRITE_FLUSH(hw);
+
+	/* Poll init-done after we write FDIRCTRL register */
+	for (i = 0; i < TXGBE_FDIR_INIT_DONE_POLL; i++) {
+		if (rd32(hw, TXGBE_RDB_FDIR_CTL) &
+		    TXGBE_RDB_FDIR_CTL_INIT_DONE)
+			break;
+		msec_delay(1);
+	}
+	if (i >= TXGBE_FDIR_INIT_DONE_POLL) {
+		DEBUGOUT("Flow Director Signature poll time exceeded!\n");
+		return TXGBE_ERR_FDIR_REINIT_FAILED;
+	}
+
+	/* Clear FDIR statistics registers (read to clear) */
+	rd32(hw, TXGBE_RDB_FDIR_USE_ST);
+	rd32(hw, TXGBE_RDB_FDIR_FAIL_ST);
+	rd32(hw, TXGBE_RDB_FDIR_MATCH);
+	rd32(hw, TXGBE_RDB_FDIR_MISS);
+	rd32(hw, TXGBE_RDB_FDIR_LEN);
+
+	return 0;
+}
+
+/**
+ *  txgbe_fdir_enable - Initialize Flow Director control registers
+ *  @hw: pointer to hardware structure
+ *  @fdirctrl: value to write to flow director control register
+ **/
+static void txgbe_fdir_enable(struct txgbe_hw *hw, u32 fdirctrl)
+{
+	int i;
+
+	/* Prime the keys for hashing */
+	wr32(hw, TXGBE_RDB_FDIR_HKEY, TXGBE_ATR_BUCKET_HASH_KEY);
+	wr32(hw, TXGBE_RDB_FDIR_SKEY, TXGBE_ATR_SIGNATURE_HASH_KEY);
+
+	/* Poll init-done after we write the register.  Estimated times:
+	 *      10G: PBALLOC = 11b, timing is 60us
+	 *       1G: PBALLOC = 11b, timing is 600us
+	 *     100M: PBALLOC = 11b, timing is 6ms
+	 *
+	 *     Multiple these timings by 4 if under full Rx load
+	 *
+	 * So we'll poll for TXGBE_FDIR_INIT_DONE_POLL times, sleeping for
+	 * 1 msec per poll time.  If we're at line rate and drop to 100M, then
+	 * this might not finish in our poll time, but we can live with that
+	 * for now.
+	 */
+	wr32(hw, TXGBE_RDB_FDIR_CTL, fdirctrl);
+	TXGBE_WRITE_FLUSH(hw);
+	for (i = 0; i < TXGBE_RDB_FDIR_INIT_DONE_POLL; i++) {
+		if (rd32(hw, TXGBE_RDB_FDIR_CTL) &
+		    TXGBE_RDB_FDIR_CTL_INIT_DONE)
+			break;
+		msec_delay(1);
+	}
+
+	if (i >= TXGBE_RDB_FDIR_INIT_DONE_POLL)
+		DEBUGOUT("Flow Director poll time exceeded!\n");
+}
+
+/**
+ *  txgbe_init_fdir_signature -Initialize Flow Director sig filters
+ *  @hw: pointer to hardware structure
+ *  @fdirctrl: value to write to flow director control register, initially
+ *           contains just the value of the Rx packet buffer allocation
+ **/
+s32 txgbe_init_fdir_signature(struct txgbe_hw *hw, u32 fdirctrl)
+{
+	u32 flex = 0;
+
+	flex = rd32m(hw, TXGBE_RDB_FDIR_FLEX_CFG(0),
+		     ~(TXGBE_RDB_FDIR_FLEX_CFG_BASE_MSK |
+		       TXGBE_RDB_FDIR_FLEX_CFG_MSK |
+		       TXGBE_RDB_FDIR_FLEX_CFG_OFST));
+
+	flex |= (TXGBE_RDB_FDIR_FLEX_CFG_BASE_MAC |
+		 0x6 << TXGBE_RDB_FDIR_FLEX_CFG_OFST_SHIFT);
+	wr32(hw, TXGBE_RDB_FDIR_FLEX_CFG(0), flex);
+
+	/* Continue setup of fdirctrl register bits:
+	 *  Move the flexible bytes to use the ethertype - shift 6 words
+	 *  Set the maximum length per hash bucket to 0xA filters
+	 *  Send interrupt when 64 filters are left
+	 */
+	fdirctrl |= (0xF << TXGBE_RDB_FDIR_CTL_HASH_BITS_SHIFT) |
+		    (0xA << TXGBE_RDB_FDIR_CTL_MAX_LENGTH_SHIFT) |
+		    (4 << TXGBE_RDB_FDIR_CTL_FULL_THRESH_SHIFT);
+
+	/* write hashes and fdirctrl register, poll for completion */
+	txgbe_fdir_enable(hw, fdirctrl);
+
+	if (hw->revision_id == TXGBE_SP_MPW) {
+		/* errata 1: disable RSC of drop ring 0 */
+		wr32m(hw, TXGBE_PX_RR_CFG(0),
+		      TXGBE_PX_RR_CFG_RSC, ~TXGBE_PX_RR_CFG_RSC);
+	}
+	return 0;
+}
+
+/**
+ *  txgbe_init_fdir_perfect - Initialize Flow Director perfect filters
+ *  @hw: pointer to hardware structure
+ *  @fdirctrl: value to write to flow director control register, initially
+ *           contains just the value of the Rx packet buffer allocation
+ *  @cloud_mode: true - cloud mode, false - other mode
+ **/
+s32 txgbe_init_fdir_perfect(struct txgbe_hw *hw, u32 fdirctrl,
+			    bool __maybe_unused cloud_mode)
+{
+	/* Continue setup of fdirctrl register bits:
+	 *  Turn perfect match filtering on
+	 *  Report hash in RSS field of Rx wb descriptor
+	 *  Initialize the drop queue
+	 *  Move the flexible bytes to use the ethertype - shift 6 words
+	 *  Set the maximum length per hash bucket to 0xA filters
+	 *  Send interrupt when 64 (0x4 * 16) filters are left
+	 */
+	fdirctrl |= TXGBE_RDB_FDIR_CTL_PERFECT_MATCH |
+		    (TXGBE_RDB_FDIR_DROP_QUEUE <<
+		     TXGBE_RDB_FDIR_CTL_DROP_Q_SHIFT) |
+		    (0xF << TXGBE_RDB_FDIR_CTL_HASH_BITS_SHIFT) |
+		    (0xA << TXGBE_RDB_FDIR_CTL_MAX_LENGTH_SHIFT) |
+		    (4 << TXGBE_RDB_FDIR_CTL_FULL_THRESH_SHIFT);
+
+	/* write hashes and fdirctrl register, poll for completion */
+	txgbe_fdir_enable(hw, fdirctrl);
+
+	if (hw->revision_id == TXGBE_SP_MPW) {
+		if (((struct txgbe_adapter *)hw->back)->num_rx_queues >
+			TXGBE_RDB_FDIR_DROP_QUEUE)
+			/* errata 1: disable RSC of drop ring */
+			wr32m(hw,
+			      TXGBE_PX_RR_CFG(TXGBE_RDB_FDIR_DROP_QUEUE),
+			      TXGBE_PX_RR_CFG_RSC, ~TXGBE_PX_RR_CFG_RSC);
+	}
+	return 0;
+}
+
+/* These defines allow us to quickly generate all of the necessary instructions
+ * in the function below by simply calling out TXGBE_COMPUTE_SIG_HASH_ITERATION
+ * for values 0 through 15
+ */
+#define TXGBE_ATR_COMMON_HASH_KEY \
+		(TXGBE_ATR_BUCKET_HASH_KEY & TXGBE_ATR_SIGNATURE_HASH_KEY)
+#define TXGBE_COMPUTE_SIG_HASH_ITERATION(_n) \
+do { \
+	u32 n = (_n); \
+	if (TXGBE_ATR_COMMON_HASH_KEY & (0x01 << n)) \
+		common_hash ^= lo_hash_dword >> n; \
+	else if (TXGBE_ATR_BUCKET_HASH_KEY & (0x01 << n)) \
+		bucket_hash ^= lo_hash_dword >> n; \
+	else if (TXGBE_ATR_SIGNATURE_HASH_KEY & (0x01 << n)) \
+		sig_hash ^= lo_hash_dword << (16 - n); \
+	if (TXGBE_ATR_COMMON_HASH_KEY & (0x01 << (n + 16))) \
+		common_hash ^= hi_hash_dword >> n; \
+	else if (TXGBE_ATR_BUCKET_HASH_KEY & (0x01 << (n + 16))) \
+		bucket_hash ^= hi_hash_dword >> n; \
+	else if (TXGBE_ATR_SIGNATURE_HASH_KEY & (0x01 << (n + 16))) \
+		sig_hash ^= hi_hash_dword << (16 - n); \
+} while (0)
+
+/**
+ *  txgbe_atr_compute_sig_hash - Compute the signature hash
+ *  @stream: input bitstream to compute the hash on
+ *
+ *  This function is almost identical to the function above but contains
+ *  several optimizations such as unwinding all of the loops, letting the
+ *  compiler work out all of the conditional ifs since the keys are static
+ *  defines, and computing two keys at once since the hashed dword stream
+ *  will be the same for both keys.
+ **/
+u32 txgbe_atr_compute_sig_hash(union txgbe_atr_hash_dword input,
+			       union txgbe_atr_hash_dword common)
+{
+	u32 hi_hash_dword, lo_hash_dword, flow_vm_vlan;
+	u32 sig_hash = 0, bucket_hash = 0, common_hash = 0;
+
+	/* record the flow_vm_vlan bits as they are a key part to the hash */
+	flow_vm_vlan = TXGBE_NTOHL(input.dword);
+
+	/* generate common hash dword */
+	hi_hash_dword = TXGBE_NTOHL(common.dword);
+
+	/* low dword is word swapped version of common */
+	lo_hash_dword = (hi_hash_dword >> 16) | (hi_hash_dword << 16);
+
+	/* apply flow ID/VM pool/VLAN ID bits to hash words */
+	hi_hash_dword ^= flow_vm_vlan ^ (flow_vm_vlan >> 16);
+
+	/* Process bits 0 and 16 */
+	TXGBE_COMPUTE_SIG_HASH_ITERATION(0);
+
+	/* apply flow ID/VM pool/VLAN ID bits to lo hash dword, we had to
+	 * delay this because bit 0 of the stream should not be processed
+	 * so we do not add the VLAN until after bit 0 was processed
+	 */
+	lo_hash_dword ^= flow_vm_vlan ^ (flow_vm_vlan << 16);
+
+	/* Process remaining 30 bit of the key */
+	TXGBE_COMPUTE_SIG_HASH_ITERATION(1);
+	TXGBE_COMPUTE_SIG_HASH_ITERATION(2);
+	TXGBE_COMPUTE_SIG_HASH_ITERATION(3);
+	TXGBE_COMPUTE_SIG_HASH_ITERATION(4);
+	TXGBE_COMPUTE_SIG_HASH_ITERATION(5);
+	TXGBE_COMPUTE_SIG_HASH_ITERATION(6);
+	TXGBE_COMPUTE_SIG_HASH_ITERATION(7);
+	TXGBE_COMPUTE_SIG_HASH_ITERATION(8);
+	TXGBE_COMPUTE_SIG_HASH_ITERATION(9);
+	TXGBE_COMPUTE_SIG_HASH_ITERATION(10);
+	TXGBE_COMPUTE_SIG_HASH_ITERATION(11);
+	TXGBE_COMPUTE_SIG_HASH_ITERATION(12);
+	TXGBE_COMPUTE_SIG_HASH_ITERATION(13);
+	TXGBE_COMPUTE_SIG_HASH_ITERATION(14);
+	TXGBE_COMPUTE_SIG_HASH_ITERATION(15);
+
+	/* combine common_hash result with signature and bucket hashes */
+	bucket_hash ^= common_hash;
+	bucket_hash &= TXGBE_ATR_HASH_MASK;
+
+	sig_hash ^= common_hash << 16;
+	sig_hash &= TXGBE_ATR_HASH_MASK << 16;
+
+	/* return completed signature hash */
+	return sig_hash ^ bucket_hash;
+}
+
+/**
+ *  txgbe_atr_add_signature_filter - Adds a signature hash filter
+ *  @hw: pointer to hardware structure
+ *  @input: unique input dword
+ *  @common: compressed common input dword
+ *  @queue: queue index to direct traffic to
+ **/
+s32 txgbe_fdir_add_signature_filter(struct txgbe_hw *hw,
+				    union txgbe_atr_hash_dword input,
+				    union txgbe_atr_hash_dword common,
+				    u8 queue)
+{
+	u32 fdirhashcmd = 0;
+	u8 flow_type;
+	u32 fdircmd;
+	s32 err;
+
+	/* Get the flow_type in order to program FDIRCMD properly
+	 * lowest 2 bits are FDIRCMD.L4TYPE, third lowest bit is FDIRCMD.IPV6
+	 * fifth is FDIRCMD.TUNNEL_FILTER
+	 */
+	flow_type = input.formatted.flow_type;
+	switch (flow_type) {
+	case TXGBE_ATR_FLOW_TYPE_TCPV4:
+	case TXGBE_ATR_FLOW_TYPE_UDPV4:
+	case TXGBE_ATR_FLOW_TYPE_SCTPV4:
+	case TXGBE_ATR_FLOW_TYPE_TCPV6:
+	case TXGBE_ATR_FLOW_TYPE_UDPV6:
+	case TXGBE_ATR_FLOW_TYPE_SCTPV6:
+		break;
+	default:
+		DEBUGOUT(" Error on flow type input\n");
+		return TXGBE_ERR_CONFIG;
+	}
+
+	/* configure FDIRCMD register */
+	fdircmd = TXGBE_RDB_FDIR_CMD_CMD_ADD_FLOW |
+		  TXGBE_RDB_FDIR_CMD_FILTER_UPDATE |
+		  TXGBE_RDB_FDIR_CMD_LAST | TXGBE_RDB_FDIR_CMD_QUEUE_EN;
+	fdircmd |= (u32)flow_type << TXGBE_RDB_FDIR_CMD_FLOW_TYPE_SHIFT;
+	fdircmd |= (u32)queue << TXGBE_RDB_FDIR_CMD_RX_QUEUE_SHIFT;
+
+	fdirhashcmd |= txgbe_atr_compute_sig_hash(input, common);
+	fdirhashcmd |= 0x1 << TXGBE_RDB_FDIR_HASH_BUCKET_VALID_SHIFT;
+	wr32(hw, TXGBE_RDB_FDIR_HASH, fdirhashcmd);
+
+	wr32(hw, TXGBE_RDB_FDIR_CMD, fdircmd);
+
+	err = txgbe_fdir_check_cmd_complete(hw, &fdircmd);
+	if (err) {
+		DEBUGOUT("Flow Director command did not complete!\n");
+		return err;
+	}
+
+	DEBUGOUT2("Tx Queue=%x hash=%x\n", queue, (u32)fdirhashcmd);
+
+	return 0;
+}
+
+#define TXGBE_COMPUTE_BKT_HASH_ITERATION(_n) \
+do { \
+	u32 n = (_n); \
+	if (TXGBE_ATR_BUCKET_HASH_KEY & (0x01 << n)) \
+		bucket_hash ^= lo_hash_dword >> n; \
+	if (TXGBE_ATR_BUCKET_HASH_KEY & (0x01 << (n + 16))) \
+		bucket_hash ^= hi_hash_dword >> n; \
+} while (0)
+
+/**
+ *  txgbe_atr_compute_perfect_hash - Compute the perfect filter hash
+ *  @atr_input: input bitstream to compute the hash on
+ *  @input_mask: mask for the input bitstream
+ *
+ *  This function serves two main purposes.  First it applies the input_mask
+ *  to the atr_input resulting in a cleaned up atr_input data stream.
+ *  Secondly it computes the hash and stores it in the bkt_hash field at
+ *  the end of the input byte stream.  This way it will be available for
+ *  future use without needing to recompute the hash.
+ **/
+void txgbe_atr_compute_perfect_hash(union txgbe_atr_input *input,
+				    union txgbe_atr_input *input_mask)
+{
+	u32 hi_hash_dword, lo_hash_dword, flow_vm_vlan;
+	u32 bucket_hash = 0;
+	u32 hi_dword = 0;
+	u32 i = 0;
+
+	/* Apply masks to input data */
+	for (i = 0; i < 11; i++)
+		input->dword_stream[i] &= input_mask->dword_stream[i];
+
+	/* record the flow_vm_vlan bits as they are a key part to the hash */
+	flow_vm_vlan = TXGBE_NTOHL(input->dword_stream[0]);
+
+	/* generate common hash dword */
+	for (i = 1; i <= 10; i++)
+		hi_dword ^= input->dword_stream[i];
+	hi_hash_dword = TXGBE_NTOHL(hi_dword);
+
+	/* low dword is word swapped version of common */
+	lo_hash_dword = (hi_hash_dword >> 16) | (hi_hash_dword << 16);
+
+	/* apply flow ID/VM pool/VLAN ID bits to hash words */
+	hi_hash_dword ^= flow_vm_vlan ^ (flow_vm_vlan >> 16);
+
+	/* Process bits 0 and 16 */
+	TXGBE_COMPUTE_BKT_HASH_ITERATION(0);
+
+	/* apply flow ID/VM pool/VLAN ID bits to lo hash dword, we had to
+	 * delay this because bit 0 of the stream should not be processed
+	 * so we do not add the VLAN until after bit 0 was processed
+	 */
+	lo_hash_dword ^= flow_vm_vlan ^ (flow_vm_vlan << 16);
+
+	/* Process remaining 30 bit of the key */
+	for (i = 1; i <= 15; i++)
+		TXGBE_COMPUTE_BKT_HASH_ITERATION(i);
+
+	/* Limit hash to 13 bits since max bucket count is 8K.
+	 * Store result at the end of the input stream.
+	 */
+	input->formatted.bkt_hash = bucket_hash & 0x1FFF;
+}
+
+/**
+ *  txgbe_get_fdirtcpm - generate a TCP port from atr_input_masks
+ *  @input_mask: mask to be bit swapped
+ *
+ *  The source and destination port masks for flow director are bit swapped
+ *  in that bit 15 effects bit 0, 14 effects 1, 13, 2 etc.  In order to
+ *  generate a correctly swapped value we need to bit swap the mask and that
+ *  is what is accomplished by this function.
+ **/
+static u32 txgbe_get_fdirtcpm(union txgbe_atr_input *input_mask)
+{
+	u32 mask = TXGBE_NTOHS(input_mask->formatted.dst_port);
+
+	mask <<= TXGBE_RDB_FDIR_TCP_MSK_DPORTM_SHIFT;
+	mask |= TXGBE_NTOHS(input_mask->formatted.src_port);
+
+	return mask;
+}
+
+/* These two macros are meant to address the fact that we have registers
+ * that are either all or in part big-endian.  As a result on big-endian
+ * systems we will end up byte swapping the value to little-endian before
+ * it is byte swapped again and written to the hardware in the original
+ * big-endian format.
+ */
+#define TXGBE_STORE_AS_BE32(_value) \
+	(((u32)(_value) >> 24) | (((u32)(_value) & 0x00FF0000) >> 8) | \
+	 (((u32)(_value) & 0x0000FF00) << 8) | ((u32)(_value) << 24))
+
+#define TXGBE_WRITE_REG_BE32(a, reg, value) \
+	wr32((a), (reg), TXGBE_STORE_AS_BE32(TXGBE_NTOHL(value)))
+
+#define TXGBE_STORE_AS_BE16(_value) \
+	TXGBE_NTOHS(((u16)(_value) >> 8) | ((u16)(_value) << 8))
+
+s32 txgbe_fdir_set_input_mask(struct txgbe_hw *hw,
+			      union txgbe_atr_input *input_mask,
+			      bool __maybe_unused cloud_mode)
+{
+	/* mask IPv6 since it is currently not supported */
+	u32 fdirm = 0;
+	u32 fdirtcpm;
+	u32 flex = 0;
+
+	/* Program the relevant mask registers.  If src/dst_port or src/dst_addr
+	 * are zero, then assume a full mask for that field.  Also assume that
+	 * a VLAN of 0 is unspecified, so mask that out as well.  L4type
+	 * cannot be masked out in this implementation.
+	 *
+	 * This also assumes IPv4 only.  IPv6 masking isn't supported at this
+	 * point in time.
+	 */
+
+	/* verify bucket hash is cleared on hash generation */
+	if (input_mask->formatted.bkt_hash)
+		DEBUGOUT(" bucket hash should always be 0 in mask\n");
+
+	/* Program FDIRM and verify partial masks */
+	switch (input_mask->formatted.vm_pool & 0x7F) {
+	case 0x0:
+		fdirm |= TXGBE_RDB_FDIR_OTHER_MSK_POOL;
+	case 0x7F:
+		break;
+	default:
+		DEBUGOUT(" Error on vm pool mask\n");
+		return TXGBE_ERR_CONFIG;
+	}
+
+	switch (input_mask->formatted.flow_type & TXGBE_ATR_L4TYPE_MASK) {
+	case 0x0:
+		fdirm |= TXGBE_RDB_FDIR_OTHER_MSK_L4P;
+		if (input_mask->formatted.dst_port ||
+		    input_mask->formatted.src_port) {
+			DEBUGOUT(" Error on src/dst port mask\n");
+			return TXGBE_ERR_CONFIG;
+		}
+	case TXGBE_ATR_L4TYPE_MASK:
+		break;
+	default:
+		DEBUGOUT(" Error on flow type mask\n");
+		return TXGBE_ERR_CONFIG;
+	}
+
+	/* Now mask VM pool and destination IPv6 - bits 5 and 2 */
+	wr32(hw, TXGBE_RDB_FDIR_OTHER_MSK, fdirm);
+
+	flex = rd32m(hw, TXGBE_RDB_FDIR_FLEX_CFG(0),
+		     ~(TXGBE_RDB_FDIR_FLEX_CFG_BASE_MSK |
+		       TXGBE_RDB_FDIR_FLEX_CFG_MSK |
+		       TXGBE_RDB_FDIR_FLEX_CFG_OFST));
+	flex |= (TXGBE_RDB_FDIR_FLEX_CFG_BASE_MAC |
+		 0x6 << TXGBE_RDB_FDIR_FLEX_CFG_OFST_SHIFT);
+
+	switch (input_mask->formatted.flex_bytes & 0xFFFF) {
+	case 0x0000:
+		/* Mask Flex Bytes */
+		flex |= TXGBE_RDB_FDIR_FLEX_CFG_MSK;
+	case 0xFFFF:
+		break;
+	default:
+		DEBUGOUT("Error on flexible byte mask\n");
+		return TXGBE_ERR_CONFIG;
+	}
+	wr32(hw, TXGBE_RDB_FDIR_FLEX_CFG(0), flex);
+
+	/* store the TCP/UDP port masks, bit reversed from port layout */
+	fdirtcpm = txgbe_get_fdirtcpm(input_mask);
+
+	/* write both the same so that UDP and TCP use the same mask */
+	wr32(hw, TXGBE_RDB_FDIR_TCP_MSK, ~fdirtcpm);
+	wr32(hw, TXGBE_RDB_FDIR_UDP_MSK, ~fdirtcpm);
+	wr32(hw, TXGBE_RDB_FDIR_SCTP_MSK, ~fdirtcpm);
+
+	/* store source and destination IP masks (little-enian) */
+	wr32(hw, TXGBE_RDB_FDIR_SA4_MSK,
+	     TXGBE_NTOHL(~input_mask->formatted.src_ip[0]));
+	wr32(hw, TXGBE_RDB_FDIR_DA4_MSK,
+	     TXGBE_NTOHL(~input_mask->formatted.dst_ip[0]));
+	return 0;
+}
+
+s32 txgbe_fdir_write_perfect_filter(struct txgbe_hw *hw,
+				    union txgbe_atr_input *input,
+				    u16 soft_id, u8 queue,
+				    bool cloud_mode)
+{
+	u32 fdirport, fdirvlan, fdirhash, fdircmd;
+	s32 err;
+
+	if (!cloud_mode) {
+		/* currently IPv6 is not supported, must be programmed with 0 */
+		wr32(hw, TXGBE_RDB_FDIR_IP6(2),
+		     TXGBE_NTOHL(input->formatted.src_ip[0]));
+		wr32(hw, TXGBE_RDB_FDIR_IP6(1),
+		     TXGBE_NTOHL(input->formatted.src_ip[1]));
+		wr32(hw, TXGBE_RDB_FDIR_IP6(0),
+		     TXGBE_NTOHL(input->formatted.src_ip[2]));
+
+		/* record the source address (little-endian) */
+		wr32(hw, TXGBE_RDB_FDIR_SA,
+		     TXGBE_NTOHL(input->formatted.src_ip[0]));
+
+		/* record the first 32 bits of the destination address
+		 * (little-endian)
+		 */
+		wr32(hw, TXGBE_RDB_FDIR_DA,
+		     TXGBE_NTOHL(input->formatted.dst_ip[0]));
+
+		/* record source and destination port (little-endian)*/
+		fdirport = TXGBE_NTOHS(input->formatted.dst_port);
+		fdirport <<= TXGBE_RDB_FDIR_PORT_DESTINATION_SHIFT;
+		fdirport |= TXGBE_NTOHS(input->formatted.src_port);
+		wr32(hw, TXGBE_RDB_FDIR_PORT, fdirport);
+	}
+
+	/* record packet type and flex_bytes(little-endian) */
+	fdirvlan = TXGBE_NTOHS(input->formatted.flex_bytes);
+	fdirvlan <<= TXGBE_RDB_FDIR_FLEX_FLEX_SHIFT;
+
+	fdirvlan |= TXGBE_NTOHS(input->formatted.vlan_id);
+	wr32(hw, TXGBE_RDB_FDIR_FLEX, fdirvlan);
+
+	/* configure FDIRHASH register */
+	fdirhash = input->formatted.bkt_hash |
+		   0x1 << TXGBE_RDB_FDIR_HASH_BUCKET_VALID_SHIFT;
+	fdirhash |= soft_id << TXGBE_RDB_FDIR_HASH_SIG_SW_INDEX_SHIFT;
+	wr32(hw, TXGBE_RDB_FDIR_HASH, fdirhash);
+
+	/* flush all previous writes to make certain registers are
+	 * programmed prior to issuing the command
+	 */
+	TXGBE_WRITE_FLUSH(hw);
+
+	/* configure FDIRCMD register */
+	fdircmd = TXGBE_RDB_FDIR_CMD_CMD_ADD_FLOW |
+		  TXGBE_RDB_FDIR_CMD_FILTER_UPDATE |
+		  TXGBE_RDB_FDIR_CMD_LAST | TXGBE_RDB_FDIR_CMD_QUEUE_EN;
+	if (queue == TXGBE_RDB_FDIR_DROP_QUEUE)
+		fdircmd |= TXGBE_RDB_FDIR_CMD_DROP;
+	fdircmd |= input->formatted.flow_type <<
+		   TXGBE_RDB_FDIR_CMD_FLOW_TYPE_SHIFT;
+	fdircmd |= (u32)queue << TXGBE_RDB_FDIR_CMD_RX_QUEUE_SHIFT;
+	fdircmd |= (u32)input->formatted.vm_pool <<
+			TXGBE_RDB_FDIR_CMD_VT_POOL_SHIFT;
+
+	wr32(hw, TXGBE_RDB_FDIR_CMD, fdircmd);
+	err = txgbe_fdir_check_cmd_complete(hw, &fdircmd);
+	if (err) {
+		DEBUGOUT("Flow Director command did not complete!\n");
+		return err;
+	}
+
+	return 0;
+}
+
 /**
  *  txgbe_start_hw - Prepare hardware for Tx/Rx
  *  @hw: pointer to hardware structure
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index 1b11735cc278..e6b78292c60b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -130,6 +130,30 @@ s32 txgbe_setup_mac_link_multispeed_fiber(struct txgbe_hw *hw,
 					  bool autoneg_wait_to_complete);
 int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit);
 
+s32 txgbe_reinit_fdir_tables(struct txgbe_hw *hw);
+s32 txgbe_init_fdir_signature(struct txgbe_hw *hw, u32 fdirctrl);
+s32 txgbe_init_fdir_perfect(struct txgbe_hw *hw, u32 fdirctrl,
+			    bool cloud_mode);
+s32 txgbe_fdir_add_signature_filter(struct txgbe_hw *hw,
+				    union txgbe_atr_hash_dword input,
+				    union txgbe_atr_hash_dword common,
+				    u8 queue);
+s32 txgbe_fdir_set_input_mask(struct txgbe_hw *hw,
+			      union txgbe_atr_input *input_mask, bool cloud_mode);
+s32 txgbe_fdir_write_perfect_filter(struct txgbe_hw *hw,
+				    union txgbe_atr_input *input,
+				    u16 soft_id, u8 queue, bool cloud_mode);
+s32 txgbe_fdir_add_perfect_filter(struct txgbe_hw *hw,
+				  union txgbe_atr_input *input,
+				  union txgbe_atr_input *mask,
+				  u16 soft_id,
+				  u8 queue,
+				  bool cloud_mode);
+void txgbe_atr_compute_perfect_hash(union txgbe_atr_input *input,
+				    union txgbe_atr_input *mask);
+u32 txgbe_atr_compute_sig_hash(union txgbe_atr_hash_dword input,
+			       union txgbe_atr_hash_dword common);
+
 s32 txgbe_get_link_capabilities(struct txgbe_hw *hw,
 				u32 *speed, bool *autoneg);
 enum txgbe_media_type txgbe_get_media_type(struct txgbe_hw *hw);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c
index c7eafce35e87..b466421b41cf 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c
@@ -52,6 +52,23 @@ static bool txgbe_set_rss_queues(struct txgbe_adapter *adapter)
 	f->indices = rss_i;
 	f->mask = TXGBE_RSS_64Q_MASK;
 
+	/* disable ATR by default, it will be configured below */
+	adapter->flags &= ~TXGBE_FLAG_FDIR_HASH_CAPABLE;
+
+	/* Use Flow Director in addition to RSS to ensure the best
+	 * distribution of flows across cores, even when an FDIR flow
+	 * isn't matched.
+	 */
+	if (rss_i > 1 && adapter->atr_sample_rate) {
+		f = &adapter->ring_feature[RING_F_FDIR];
+
+		f->indices = f->limit;
+		rss_i = f->indices;
+
+		if (!(adapter->flags & TXGBE_FLAG_FDIR_PERFECT_CAPABLE))
+			adapter->flags |= TXGBE_FLAG_FDIR_HASH_CAPABLE;
+	}
+
 	adapter->num_rx_queues = rss_i;
 	adapter->num_tx_queues = rss_i;
 
@@ -179,12 +196,22 @@ static int txgbe_alloc_q_vector(struct txgbe_adapter *adapter,
 	int node = -1;
 	int cpu = -1;
 	int ring_count, size;
+	u16 rss_i = 0;
 
 	/* note this will allocate space for the ring structure as well! */
 	ring_count = txr_count + rxr_count;
 	size = sizeof(struct txgbe_q_vector) +
 	       (sizeof(struct txgbe_ring) * ring_count);
 
+	/* customize cpu for Flow Director mapping */
+	rss_i = adapter->ring_feature[RING_F_RSS].indices;
+	if (rss_i > 1 && adapter->atr_sample_rate) {
+		if (cpu_online(v_idx)) {
+			cpu = v_idx;
+			node = cpu_to_node(cpu);
+		}
+	}
+
 	/* allocate q_vector and rings */
 	q_vector = kzalloc_node(size, GFP_KERNEL, node);
 	if (!q_vector)
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 6f1836a61711..ea17747c0df9 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -16,6 +16,7 @@
 #include <linux/aer.h>
 #include <net/checksum.h>
 #include <net/ip6_checksum.h>
+#include <linux/ethtool.h>
 #include <net/vxlan.h>
 #include <linux/etherdevice.h>
 
@@ -1486,6 +1487,10 @@ void txgbe_irq_enable(struct txgbe_adapter *adapter, bool queues, bool flush)
 
 	mask |= TXGBE_PX_MISC_IEN_OVER_HEAT;
 
+	if ((adapter->flags & TXGBE_FLAG_FDIR_HASH_CAPABLE) &&
+	    !(adapter->flags2 & TXGBE_FLAG2_FDIR_REQUIRES_REINIT))
+		mask |= TXGBE_PX_MISC_IEN_FLOW_DIR;
+
 	wr32(&adapter->hw, TXGBE_PX_MISC_IEN, mask);
 
 	/* unmask interrupt */
@@ -1529,6 +1534,28 @@ static irqreturn_t txgbe_msix_other(int __always_unused irq, void *data)
 		txgbe_service_event_schedule(adapter);
 	}
 
+	/* Handle Flow Director Full threshold interrupt */
+	if (eicr & TXGBE_PX_MISC_IC_FLOW_DIR) {
+		int reinit_count = 0;
+		int i;
+
+		for (i = 0; i < adapter->num_tx_queues; i++) {
+			struct txgbe_ring *ring = adapter->tx_ring[i];
+
+			if (test_and_clear_bit(__TXGBE_TX_FDIR_INIT_DONE,
+					       &ring->state))
+				reinit_count++;
+		}
+		if (reinit_count) {
+			/* no more flow director interrupts until after init */
+			wr32m(hw, TXGBE_PX_MISC_IEN,
+			      TXGBE_PX_MISC_IEN_FLOW_DIR, 0);
+			adapter->flags2 |=
+				TXGBE_FLAG2_FDIR_REQUIRES_REINIT;
+			txgbe_service_event_schedule(adapter);
+		}
+	}
+
 	txgbe_check_sfp_event(adapter, eicr);
 	txgbe_check_overtemp_event(adapter, eicr);
 
@@ -1645,6 +1672,13 @@ static int txgbe_request_msix_irqs(struct txgbe_adapter *adapter)
 				  q_vector->name, err);
 			goto free_queue_irqs;
 		}
+
+		/* If Flow Director is enabled, set interrupt affinity */
+		if (adapter->flags & TXGBE_FLAG_FDIR_HASH_CAPABLE) {
+			/* assign the mask for this irq */
+			irq_set_affinity_hint(entry->vector,
+					      &q_vector->affinity_mask);
+		}
 	}
 
 	err = request_irq(adapter->msix_entries[vector].vector,
@@ -1868,6 +1902,15 @@ void txgbe_configure_tx_ring(struct txgbe_adapter *adapter,
 
 	txdctl |= 0x20 << TXGBE_PX_TR_CFG_WTHRESH_SHIFT;
 
+	/* reinitialize flowdirector state */
+	if (adapter->flags & TXGBE_FLAG_FDIR_HASH_CAPABLE) {
+		ring->atr_sample_rate = adapter->atr_sample_rate;
+		ring->atr_count = 0;
+		set_bit(__TXGBE_TX_FDIR_INIT_DONE, &ring->state);
+	} else {
+		ring->atr_sample_rate = 0;
+	}
+
 	/* initialize XPS */
 	if (!test_and_set_bit(__TXGBE_TX_XPS_INIT_DONE, &ring->state)) {
 		struct txgbe_q_vector *q_vector = ring->q_vector;
@@ -2853,11 +2896,59 @@ static void txgbe_pbthresh_setup(struct txgbe_adapter *adapter)
 static void txgbe_configure_pb(struct txgbe_adapter *adapter)
 {
 	struct txgbe_hw *hw = &adapter->hw;
+	int hdrm;
+
+	if (adapter->flags & TXGBE_FLAG_FDIR_HASH_CAPABLE ||
+	    adapter->flags & TXGBE_FLAG_FDIR_PERFECT_CAPABLE)
+		hdrm = 32 << adapter->fdir_pballoc;
+	else
+		hdrm = 0;
 
-	TCALL(hw, mac.ops.setup_rxpba, 0, 0, PBA_STRATEGY_EQUAL);
+	TCALL(hw, mac.ops.setup_rxpba, 0, hdrm, PBA_STRATEGY_EQUAL);
 	txgbe_pbthresh_setup(adapter);
 }
 
+static void txgbe_fdir_filter_restore(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	struct hlist_node *node;
+	struct txgbe_fdir_filter *filter;
+	u8 queue = 0;
+
+	spin_lock(&adapter->fdir_perfect_lock);
+
+	if (!hlist_empty(&adapter->fdir_filter_list))
+		txgbe_fdir_set_input_mask(hw, &adapter->fdir_mask,
+					  adapter->cloud_mode);
+
+	hlist_for_each_entry_safe(filter, node,
+				  &adapter->fdir_filter_list, fdir_node) {
+		if (filter->action == TXGBE_RDB_FDIR_DROP_QUEUE) {
+			queue = TXGBE_RDB_FDIR_DROP_QUEUE;
+		} else {
+			u32 ring = ethtool_get_flow_spec_ring(filter->action);
+
+			if (ring >= adapter->num_rx_queues) {
+				txgbe_err(drv,
+					  "FDIR restore failed, ring:%u\n",
+					  ring);
+				continue;
+			}
+
+			/* Map the ring onto the absolute queue index */
+			queue = adapter->rx_ring[ring]->reg_idx;
+		}
+
+		txgbe_fdir_write_perfect_filter(hw,
+						&filter->filter,
+						filter->sw_idx,
+						queue,
+						adapter->cloud_mode);
+	}
+
+	spin_unlock(&adapter->fdir_perfect_lock);
+}
+
 void txgbe_configure_isb(struct txgbe_adapter *adapter)
 {
 	/* set ISB Address */
@@ -2903,6 +2994,16 @@ static void txgbe_configure(struct txgbe_adapter *adapter)
 
 	TCALL(hw, mac.ops.disable_sec_rx_path);
 
+	if (adapter->flags & TXGBE_FLAG_FDIR_HASH_CAPABLE) {
+		txgbe_init_fdir_signature(&adapter->hw,
+					  adapter->fdir_pballoc);
+	} else if (adapter->flags & TXGBE_FLAG_FDIR_PERFECT_CAPABLE) {
+		txgbe_init_fdir_perfect(&adapter->hw,
+					adapter->fdir_pballoc,
+					adapter->cloud_mode);
+		txgbe_fdir_filter_restore(adapter);
+	}
+
 	TCALL(hw, mac.ops.enable_sec_rx_path);
 
 	txgbe_configure_tx(adapter);
@@ -3217,6 +3318,23 @@ static void txgbe_clean_all_tx_rings(struct txgbe_adapter *adapter)
 		txgbe_clean_tx_ring(adapter->tx_ring[i]);
 }
 
+static void txgbe_fdir_filter_exit(struct txgbe_adapter *adapter)
+{
+	struct hlist_node *node;
+	struct txgbe_fdir_filter *filter;
+
+	spin_lock(&adapter->fdir_perfect_lock);
+
+	hlist_for_each_entry_safe(filter, node,
+				  &adapter->fdir_filter_list, fdir_node) {
+		hlist_del(&filter->fdir_node);
+		kfree(filter);
+	}
+	adapter->fdir_filter_count = 0;
+
+	spin_unlock(&adapter->fdir_perfect_lock);
+}
+
 void txgbe_disable_device(struct txgbe_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
@@ -3246,7 +3364,8 @@ void txgbe_disable_device(struct txgbe_adapter *adapter)
 
 	txgbe_napi_disable_all(adapter);
 
-	adapter->flags2 &= ~(TXGBE_FLAG2_PF_RESET_REQUESTED |
+	adapter->flags2 &= ~(TXGBE_FLAG2_FDIR_REQUIRES_REINIT |
+			     TXGBE_FLAG2_PF_RESET_REQUESTED |
 			     TXGBE_FLAG2_GLOBAL_RESET_REQUESTED);
 	adapter->flags &= ~TXGBE_FLAG_NEED_LINK_UPDATE;
 
@@ -3324,7 +3443,7 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
 	struct txgbe_hw *hw = &adapter->hw;
 	struct pci_dev *pdev = adapter->pdev;
 	int err;
-	unsigned int rss;
+	unsigned int fdir, rss;
 
 	/* PCI config space info */
 	hw->vendor_id = pdev->vendor;
@@ -3377,8 +3496,14 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
 	adapter->flags |= TXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE;
 	adapter->flags2 |= TXGBE_FLAG2_RSC_CAPABLE;
 
+	fdir = min_t(int, TXGBE_MAX_FDIR_INDICES, num_online_cpus());
+	adapter->ring_feature[RING_F_FDIR].limit = fdir;
+	adapter->fdir_pballoc = TXGBE_FDIR_PBALLOC_64K;
 	adapter->max_q_vectors = TXGBE_MAX_MSIX_Q_VECTORS_SAPPHIRE;
 
+	/* n-tuple support exists, always init our spinlock */
+	spin_lock_init(&adapter->fdir_perfect_lock);
+
 	/* default flow control settings */
 	hw->fc.requested_mode = txgbe_fc_full;
 	hw->fc.current_mode = txgbe_fc_full;
@@ -3808,6 +3933,8 @@ int txgbe_close(struct net_device *netdev)
 	txgbe_free_all_rx_resources(adapter);
 	txgbe_free_all_tx_resources(adapter);
 
+	txgbe_fdir_filter_exit(adapter);
+
 	txgbe_release_hw_control(adapter);
 
 	return 0;
@@ -4004,6 +4131,9 @@ void txgbe_update_stats(struct txgbe_adapter *adapter)
 				     rd32(hw, TXGBE_RDM_DRP_PKT);
 	hwstats->lxonrxc += rd32(hw, TXGBE_MAC_LXONRXC);
 
+	hwstats->fdirmatch += rd32(hw, TXGBE_RDB_FDIR_MATCH);
+	hwstats->fdirmiss += rd32(hw, TXGBE_RDB_FDIR_MISS);
+
 	bprc = rd32(hw, TXGBE_RX_BC_FRAMES_GOOD_LOW);
 	hwstats->bprc += bprc;
 	hwstats->mprc = 0;
@@ -4035,6 +4165,42 @@ void txgbe_update_stats(struct txgbe_adapter *adapter)
 	net_stats->rx_missed_errors = total_mpc;
 }
 
+/**
+ * txgbe_fdir_reinit_subtask - worker thread to reinit FDIR filter table
+ * @adapter - pointer to the device adapter structure
+ **/
+static void txgbe_fdir_reinit_subtask(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	int i;
+
+	if (!(adapter->flags2 & TXGBE_FLAG2_FDIR_REQUIRES_REINIT))
+		return;
+
+	adapter->flags2 &= ~TXGBE_FLAG2_FDIR_REQUIRES_REINIT;
+
+	/* if interface is down do nothing */
+	if (test_bit(__TXGBE_DOWN, &adapter->state))
+		return;
+
+	/* do nothing if we are not using signature filters */
+	if (!(adapter->flags & TXGBE_FLAG_FDIR_HASH_CAPABLE))
+		return;
+
+	adapter->fdir_overflow++;
+
+	if (txgbe_reinit_fdir_tables(hw) == 0) {
+		for (i = 0; i < adapter->num_tx_queues; i++)
+			set_bit(__TXGBE_TX_FDIR_INIT_DONE,
+				&adapter->tx_ring[i]->state);
+		/* re-enable flow director interrupts */
+		wr32m(hw, TXGBE_PX_MISC_IEN,
+		      TXGBE_PX_MISC_IEN_FLOW_DIR, TXGBE_PX_MISC_IEN_FLOW_DIR);
+	} else {
+		txgbe_err(probe, "failed to finish FDIR re-initialization, ignored adding FDIR ATR filters\n");
+	}
+}
+
 /**
  * txgbe_check_hang_subtask - check for hung queues and dropped interrupts
  * @adapter - pointer to the device adapter structure
@@ -4473,6 +4639,7 @@ static void txgbe_service_task(struct work_struct *work)
 	txgbe_sfp_link_config_subtask(adapter);
 	txgbe_check_overtemp_subtask(adapter);
 	txgbe_watchdog_subtask(adapter);
+	txgbe_fdir_reinit_subtask(adapter);
 	txgbe_check_hang_subtask(adapter);
 
 	txgbe_service_event_complete(adapter);
@@ -5139,6 +5306,89 @@ static int txgbe_tx_map(struct txgbe_ring *tx_ring,
 	return -1;
 }
 
+static void txgbe_atr(struct txgbe_ring *ring,
+		      struct txgbe_tx_buffer *first,
+		      struct txgbe_dptype dptype)
+{
+	struct txgbe_q_vector *q_vector = ring->q_vector;
+	union txgbe_atr_hash_dword input = { .dword = 0 };
+	union txgbe_atr_hash_dword common = { .dword = 0 };
+	union network_header hdr;
+	struct tcphdr *th;
+
+	/* if ring doesn't have a interrupt vector, cannot perform ATR */
+	if (!q_vector)
+		return;
+
+	/* do nothing if sampling is disabled */
+	if (!ring->atr_sample_rate)
+		return;
+
+	ring->atr_count++;
+
+	if (dptype.etype) {
+		if (TXGBE_PTYPE_TYPL4(dptype.ptype) != TXGBE_PTYPE_TYP_TCP)
+			return;
+		hdr.raw = (void *)skb_inner_network_header(first->skb);
+		th = inner_tcp_hdr(first->skb);
+	} else {
+		if (TXGBE_PTYPE_PKT(dptype.ptype) != TXGBE_PTYPE_PKT_IP ||
+		    TXGBE_PTYPE_TYPL4(dptype.ptype) != TXGBE_PTYPE_TYP_TCP)
+			return;
+		hdr.raw = (void *)skb_network_header(first->skb);
+		th = tcp_hdr(first->skb);
+	}
+
+	/* skip this packet since it is invalid or the socket is closing */
+	if (!th || th->fin)
+		return;
+
+	/* sample on all syn packets or once every atr sample count */
+	if (!th->syn && ring->atr_count < ring->atr_sample_rate)
+		return;
+
+	/* reset sample count */
+	ring->atr_count = 0;
+
+	/* src and dst are inverted, think how the receiver sees them
+	 *
+	 * The input is broken into two sections, a non-compressed section
+	 * containing vm_pool, vlan_id, and flow_type.  The rest of the data
+	 * is XORed together and stored in the compressed dword.
+	 */
+	input.formatted.vlan_id = htons((u16)dptype.ptype);
+
+	/* since src port and flex bytes occupy the same word XOR them together
+	 * and write the value to source port portion of compressed dword
+	 */
+	if (first->tx_flags & TXGBE_TX_FLAGS_SW_VLAN)
+		common.port.src ^= th->dest ^ first->skb->protocol;
+	else if (first->tx_flags & TXGBE_TX_FLAGS_HW_VLAN)
+		common.port.src ^= th->dest ^ first->skb->vlan_proto;
+	else
+		common.port.src ^= th->dest ^ first->protocol;
+	common.port.dst ^= th->source;
+
+	if (TXGBE_PTYPE_PKT_IPV6 & TXGBE_PTYPE_PKT(dptype.ptype)) {
+		input.formatted.flow_type = TXGBE_ATR_FLOW_TYPE_TCPV6;
+		common.ip ^= hdr.ipv6->saddr.s6_addr32[0] ^
+					 hdr.ipv6->saddr.s6_addr32[1] ^
+					 hdr.ipv6->saddr.s6_addr32[2] ^
+					 hdr.ipv6->saddr.s6_addr32[3] ^
+					 hdr.ipv6->daddr.s6_addr32[0] ^
+					 hdr.ipv6->daddr.s6_addr32[1] ^
+					 hdr.ipv6->daddr.s6_addr32[2] ^
+					 hdr.ipv6->daddr.s6_addr32[3];
+	} else {
+		input.formatted.flow_type = TXGBE_ATR_FLOW_TYPE_TCPV4;
+		common.ip ^= hdr.ipv4->saddr ^ hdr.ipv4->daddr;
+	}
+
+	/* This assumes the Rx queue and Tx queue are bound to the same CPU */
+	txgbe_fdir_add_signature_filter(&q_vector->adapter->hw,
+					input, common, ring->queue_index);
+}
+
 /**
  * skb_pad - zero pad the tail of an skb
  * @skb: buffer to pad
@@ -5271,6 +5521,10 @@ netdev_tx_t txgbe_xmit_frame_ring(struct sk_buff *skb,
 	else if (!tso)
 		txgbe_tx_csum(tx_ring, first, dptype);
 
+	/* add the ATR filter if ATR is on */
+	if (test_bit(__TXGBE_TX_FDIR_INIT_DONE, &tx_ring->state))
+		txgbe_atr(tx_ring, first, dptype);
+
 	txgbe_tx_map(tx_ring, first, hdr_len);
 
 	return NETDEV_TX_OK;
@@ -5426,6 +5680,37 @@ static int txgbe_set_features(struct net_device *netdev,
 		}
 	}
 
+	/* Check if Flow Director n-tuple support was enabled or disabled.  If
+	 * the state changed, we need to reset.
+	 */
+	switch (features & NETIF_F_NTUPLE) {
+	case NETIF_F_NTUPLE:
+		/* turn off ATR, enable perfect filters and reset */
+		if (!(adapter->flags & TXGBE_FLAG_FDIR_PERFECT_CAPABLE))
+			need_reset = true;
+
+		adapter->flags &= ~TXGBE_FLAG_FDIR_HASH_CAPABLE;
+		adapter->flags |= TXGBE_FLAG_FDIR_PERFECT_CAPABLE;
+		break;
+	default:
+		/* turn off perfect filters, enable ATR and reset */
+		if (adapter->flags & TXGBE_FLAG_FDIR_PERFECT_CAPABLE)
+			need_reset = true;
+
+		adapter->flags &= ~TXGBE_FLAG_FDIR_PERFECT_CAPABLE;
+
+		/* We cannot enable ATR if RSS is disabled */
+		if (adapter->ring_feature[RING_F_RSS].limit <= 1)
+			break;
+
+		/* A sample rate of 0 indicates ATR disabled */
+		if (!adapter->atr_sample_rate)
+			break;
+
+		adapter->flags |= TXGBE_FLAG_FDIR_HASH_CAPABLE;
+		break;
+	}
+
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
 		txgbe_vlan_strip_enable(adapter);
 	else
@@ -5849,6 +6134,8 @@ static int txgbe_probe(struct pci_dev *pdev,
 	i_s_var += sprintf(info_string, "Enabled Features: ");
 	i_s_var += sprintf(i_s_var, "RxQ: %d TxQ: %d ",
 			   adapter->num_rx_queues, adapter->num_tx_queues);
+	if (adapter->flags & TXGBE_FLAG_FDIR_HASH_CAPABLE)
+		i_s_var += sprintf(i_s_var, "FdirHash ");
 	if (adapter->flags2 & TXGBE_FLAG2_RSC_ENABLED)
 		i_s_var += sprintf(i_s_var, "RSC ");
 	if (adapter->flags & TXGBE_FLAG_VXLAN_OFFLOAD_ENABLE)
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index af9339777ea5..9416f80d07f0 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -1959,6 +1959,85 @@ struct txgbe_tx_context_desc {
 	__le32 mss_l4len_idx;
 };
 
+/************************* Flow Directory HASH *******************************/
+/* Software ATR hash keys */
+#define TXGBE_ATR_BUCKET_HASH_KEY       0x3DAD14E2
+#define TXGBE_ATR_SIGNATURE_HASH_KEY    0x174D3614
+
+/* Software ATR input stream values and masks */
+#define TXGBE_ATR_HASH_MASK             0x7fff
+#define TXGBE_ATR_L4TYPE_MASK           0x3
+#define TXGBE_ATR_L4TYPE_UDP            0x1
+#define TXGBE_ATR_L4TYPE_TCP            0x2
+#define TXGBE_ATR_L4TYPE_SCTP           0x3
+#define TXGBE_ATR_L4TYPE_IPV6_MASK      0x4
+#define TXGBE_ATR_L4TYPE_TUNNEL_MASK    0x10
+enum txgbe_atr_flow_type {
+	TXGBE_ATR_FLOW_TYPE_IPV4        = 0x0,
+	TXGBE_ATR_FLOW_TYPE_UDPV4       = 0x1,
+	TXGBE_ATR_FLOW_TYPE_TCPV4       = 0x2,
+	TXGBE_ATR_FLOW_TYPE_SCTPV4      = 0x3,
+	TXGBE_ATR_FLOW_TYPE_IPV6        = 0x4,
+	TXGBE_ATR_FLOW_TYPE_UDPV6       = 0x5,
+	TXGBE_ATR_FLOW_TYPE_TCPV6       = 0x6,
+	TXGBE_ATR_FLOW_TYPE_SCTPV6      = 0x7,
+	TXGBE_ATR_FLOW_TYPE_TUNNELED_IPV4       = 0x10,
+	TXGBE_ATR_FLOW_TYPE_TUNNELED_UDPV4      = 0x11,
+	TXGBE_ATR_FLOW_TYPE_TUNNELED_TCPV4      = 0x12,
+	TXGBE_ATR_FLOW_TYPE_TUNNELED_SCTPV4     = 0x13,
+	TXGBE_ATR_FLOW_TYPE_TUNNELED_IPV6       = 0x14,
+	TXGBE_ATR_FLOW_TYPE_TUNNELED_UDPV6      = 0x15,
+	TXGBE_ATR_FLOW_TYPE_TUNNELED_TCPV6      = 0x16,
+	TXGBE_ATR_FLOW_TYPE_TUNNELED_SCTPV6     = 0x17,
+};
+
+/* Flow Director ATR input struct. */
+union txgbe_atr_input {
+	/* Byte layout in order, all values with MSB first:
+	 *
+	 * vm_pool      - 1 byte
+	 * flow_type    - 1 byte
+	 * vlan_id      - 2 bytes
+	 * src_ip       - 16 bytes
+	 * inner_mac    - 6 bytes
+	 * cloud_mode   - 2 bytes
+	 * tni_vni      - 4 bytes
+	 * dst_ip       - 16 bytes
+	 * src_port     - 2 bytes
+	 * dst_port     - 2 bytes
+	 * flex_bytes   - 2 bytes
+	 * bkt_hash     - 2 bytes
+	 */
+	struct {
+		u8 vm_pool;
+		u8 flow_type;
+		__be16 vlan_id;
+		__be32 dst_ip[4];
+		__be32 src_ip[4];
+		__be16 src_port;
+		__be16 dst_port;
+		__be16 flex_bytes;
+		__be16 bkt_hash;
+	} formatted;
+	__be32 dword_stream[11];
+};
+
+/* Flow Director compressed ATR hash input struct */
+union txgbe_atr_hash_dword {
+	struct {
+		u8 vm_pool;
+		u8 flow_type;
+		__be16 vlan_id;
+	} formatted;
+	__be32 ip;
+	struct {
+		__be16 src;
+		__be16 dst;
+	} port;
+	__be16 flex_bytes;
+	__be32 dword;
+};
+
 /****************** Manageablility Host Interface defines ********************/
 #define TXGBE_HI_MAX_BLOCK_BYTE_LENGTH  256 /* Num of bytes in range */
 #define TXGBE_HI_MAX_BLOCK_DWORD_LENGTH 64 /* Num of dwords in range */
@@ -2330,6 +2409,8 @@ struct txgbe_hw_stats {
 	u64 qbtc[16];
 	u64 qprdc[16];
 	u64 pxon2offc[8];
+	u64 fdirmatch;
+	u64 fdirmiss;
 	u64 fccrc;
 	u64 fclast;
 	u64 ldpcec;
-- 
2.27.0



