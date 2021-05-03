Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A313718E0
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 18:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhECQJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 12:09:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231177AbhECQJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 12:09:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A532761278;
        Mon,  3 May 2021 16:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620058116;
        bh=JMLdxg1GiO4jQosGbH0gzXqOsw+kxhytCWRm+2+sCs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eoy9chVf7M704mO3ur+v6fWP9SPtGp/oJfSoTko0J5YwVXbr458xJbavMYy48TO1A
         5kQ67QuHN6mYYeGMO3shqXtLKMlgWWKJ6lfyu9jSYtIbwlX8JWa+qyua4EYQr6fSlo
         GXKJJoomlfkCuZVAiqGGwqTgWawFOXSqTtsm/+VNuL8o+fy8NnTzIwZnTfCUelz14Y
         W4MbvbUqMkyM9jgeh/BByyY2LjsZRYnb4HewwqX/j7S4sddlhOpuCm/9eEkCHdijtA
         sDGfm2zj0gN/eyvKmp5UQK46xCoVysxTunSDn3eBVqsOGzCn6Uu/SmluryN5PG2qcf
         hw3j8G5JZV0nA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PACTH ethtool-next v3 1/7] update UAPI header copies
Date:   Mon,  3 May 2021 09:08:24 -0700
Message-Id: <20210503160830.555241-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503160830.555241-1-kuba@kernel.org>
References: <20210503160830.555241-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to kernel commit f18c51b6513c.

v3: update headers to latest

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 uapi/linux/ethtool.h         | 109 ++++++++++++++------
 uapi/linux/ethtool_netlink.h | 187 +++++++++++++++++++++++++++++++++++
 uapi/linux/if_link.h         |   2 +-
 uapi/linux/rtnetlink.h       |  13 +++
 4 files changed, 278 insertions(+), 33 deletions(-)

diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index a951137bdba9..c6ec1111ffa3 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -24,6 +24,14 @@
  * have the same layout for 32-bit and 64-bit userland.
  */
 
+/* Note on reserved space.
+ * Reserved fields must not be accessed directly by user space because
+ * they may be replaced by a different field in the future. They must
+ * be initialized to zero before making the request, e.g. via memset
+ * of the entire structure or implicitly by not being set in a structure
+ * initializer.
+ */
+
 /**
  * struct ethtool_cmd - DEPRECATED, link control and status
  * This structure is DEPRECATED, please use struct ethtool_link_settings.
@@ -65,6 +73,7 @@
  *	and other link features that the link partner advertised
  *	through autonegotiation; 0 if unknown or not applicable.
  *	Read-only.
+ * @reserved: Reserved for future use; see the note on reserved space.
  *
  * The link speed in Mbps is split between @speed and @speed_hi.  Use
  * the ethtool_cmd_speed() and ethtool_cmd_speed_set() functions to
@@ -153,6 +162,7 @@ static __inline__ __u32 ethtool_cmd_speed(const struct ethtool_cmd *ep)
  * @bus_info: Device bus address.  This should match the dev_name()
  *	string for the underlying bus device, if there is one.  May be
  *	an empty string.
+ * @reserved2: Reserved for future use; see the note on reserved space.
  * @n_priv_flags: Number of flags valid for %ETHTOOL_GPFLAGS and
  *	%ETHTOOL_SPFLAGS commands; also the number of strings in the
  *	%ETH_SS_PRIV_FLAGS set
@@ -354,6 +364,7 @@ struct ethtool_eeprom {
  * @tx_lpi_timer: Time in microseconds the interface delays prior to asserting
  *	its tx lpi (after reaching 'idle' state). Effective only when eee
  *	was negotiated and tx_lpi_enabled was set.
+ * @reserved: Reserved for future use; see the note on reserved space.
  */
 struct ethtool_eee {
 	__u32	cmd;
@@ -372,6 +383,7 @@ struct ethtool_eee {
  * @cmd: %ETHTOOL_GMODULEINFO
  * @type: Standard the module information conforms to %ETH_MODULE_SFF_xxxx
  * @eeprom_len: Length of the eeprom
+ * @reserved: Reserved for future use; see the note on reserved space.
  *
  * This structure is used to return the information to
  * properly size memory for a subsequent call to %ETHTOOL_GMODULEEEPROM.
@@ -577,9 +589,7 @@ struct ethtool_pauseparam {
 	__u32	tx_pause;
 };
 
-/**
- * enum ethtool_link_ext_state - link extended state
- */
+/* Link extended state */
 enum ethtool_link_ext_state {
 	ETHTOOL_LINK_EXT_STATE_AUTONEG,
 	ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE,
@@ -593,10 +603,7 @@ enum ethtool_link_ext_state {
 	ETHTOOL_LINK_EXT_STATE_OVERHEAT,
 };
 
-/**
- * enum ethtool_link_ext_substate_autoneg - more information in addition to
- * ETHTOOL_LINK_EXT_STATE_AUTONEG.
- */
+/* More information in addition to ETHTOOL_LINK_EXT_STATE_AUTONEG. */
 enum ethtool_link_ext_substate_autoneg {
 	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED = 1,
 	ETHTOOL_LINK_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED,
@@ -606,9 +613,7 @@ enum ethtool_link_ext_substate_autoneg {
 	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_HCD,
 };
 
-/**
- * enum ethtool_link_ext_substate_link_training - more information in addition to
- * ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE.
+/* More information in addition to ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE.
  */
 enum ethtool_link_ext_substate_link_training {
 	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED = 1,
@@ -617,9 +622,7 @@ enum ethtool_link_ext_substate_link_training {
 	ETHTOOL_LINK_EXT_SUBSTATE_LT_REMOTE_FAULT,
 };
 
-/**
- * enum ethtool_link_ext_substate_logical_mismatch - more information in addition
- * to ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH.
+/* More information in addition to ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH.
  */
 enum ethtool_link_ext_substate_link_logical_mismatch {
 	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_BLOCK_LOCK = 1,
@@ -629,19 +632,14 @@ enum ethtool_link_ext_substate_link_logical_mismatch {
 	ETHTOOL_LINK_EXT_SUBSTATE_LLM_RS_FEC_IS_NOT_LOCKED,
 };
 
-/**
- * enum ethtool_link_ext_substate_bad_signal_integrity - more information in
- * addition to ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY.
+/* More information in addition to ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY.
  */
 enum ethtool_link_ext_substate_bad_signal_integrity {
 	ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS = 1,
 	ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE,
 };
 
-/**
- * enum ethtool_link_ext_substate_cable_issue - more information in
- * addition to ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE.
- */
+/* More information in addition to ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE. */
 enum ethtool_link_ext_substate_cable_issue {
 	ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE = 1,
 	ETHTOOL_LINK_EXT_SUBSTATE_CI_CABLE_TEST_FAILURE,
@@ -659,6 +657,7 @@ enum ethtool_link_ext_substate_cable_issue {
  *	now deprecated
  * @ETH_SS_FEATURES: Device feature names
  * @ETH_SS_RSS_HASH_FUNCS: RSS hush function names
+ * @ETH_SS_TUNABLES: tunable names
  * @ETH_SS_PHY_STATS: Statistic names, for use with %ETHTOOL_GPHYSTATS
  * @ETH_SS_PHY_TUNABLES: PHY tunable names
  * @ETH_SS_LINK_MODES: link mode names
@@ -668,6 +667,13 @@ enum ethtool_link_ext_substate_cable_issue {
  * @ETH_SS_TS_TX_TYPES: timestamping Tx types
  * @ETH_SS_TS_RX_FILTERS: timestamping Rx filters
  * @ETH_SS_UDP_TUNNEL_TYPES: UDP tunnel types
+ * @ETH_SS_STATS_STD: standardized stats
+ * @ETH_SS_STATS_ETH_PHY: names of IEEE 802.3 PHY statistics
+ * @ETH_SS_STATS_ETH_MAC: names of IEEE 802.3 MAC statistics
+ * @ETH_SS_STATS_ETH_CTRL: names of IEEE 802.3 MAC Control statistics
+ * @ETH_SS_STATS_RMON: names of RMON statistics
+ *
+ * @ETH_SS_COUNT: number of defined string sets
  */
 enum ethtool_stringset {
 	ETH_SS_TEST		= 0,
@@ -686,6 +692,11 @@ enum ethtool_stringset {
 	ETH_SS_TS_TX_TYPES,
 	ETH_SS_TS_RX_FILTERS,
 	ETH_SS_UDP_TUNNEL_TYPES,
+	ETH_SS_STATS_STD,
+	ETH_SS_STATS_ETH_PHY,
+	ETH_SS_STATS_ETH_MAC,
+	ETH_SS_STATS_ETH_CTRL,
+	ETH_SS_STATS_RMON,
 
 	/* add new constants above here */
 	ETH_SS_COUNT
@@ -713,6 +724,7 @@ struct ethtool_gstrings {
 /**
  * struct ethtool_sset_info - string set information
  * @cmd: Command number = %ETHTOOL_GSSET_INFO
+ * @reserved: Reserved for future use; see the note on reserved space.
  * @sset_mask: On entry, a bitmask of string sets to query, with bits
  *	numbered according to &enum ethtool_stringset.  On return, a
  *	bitmask of those string sets queried that are supported.
@@ -757,6 +769,7 @@ enum ethtool_test_flags {
  * @flags: A bitmask of flags from &enum ethtool_test_flags.  Some
  *	flags may be set by the user on entry; others may be set by
  *	the driver on return.
+ * @reserved: Reserved for future use; see the note on reserved space.
  * @len: On return, the number of test results
  * @data: Array of test results
  *
@@ -957,6 +970,7 @@ union ethtool_flow_union {
  * @vlan_etype: VLAN EtherType
  * @vlan_tci: VLAN tag control information
  * @data: user defined data
+ * @padding: Reserved for future use; see the note on reserved space.
  *
  * Note, @vlan_etype, @vlan_tci, and @data are only valid if %FLOW_EXT
  * is set in &struct ethtool_rx_flow_spec @flow_type.
@@ -1132,7 +1146,8 @@ struct ethtool_rxfh_indir {
  *	hardware hash key.
  * @hfunc: Defines the current RSS hash function used by HW (or to be set to).
  *	Valid values are one of the %ETH_RSS_HASH_*.
- * @rsvd:	Reserved for future extensions.
+ * @rsvd8: Reserved for future use; see the note on reserved space.
+ * @rsvd32: Reserved for future use; see the note on reserved space.
  * @rss_config: RX ring/queue index for each hash value i.e., indirection table
  *	of @indir_size __u32 elements, followed by hash key of @key_size
  *	bytes.
@@ -1300,7 +1315,9 @@ struct ethtool_sfeatures {
  * @so_timestamping: bit mask of the sum of the supported SO_TIMESTAMPING flags
  * @phc_index: device index of the associated PHC, or -1 if there is none
  * @tx_types: bit mask of the supported hwtstamp_tx_types enumeration values
+ * @tx_reserved: Reserved for future use; see the note on reserved space.
  * @rx_filters: bit mask of the supported hwtstamp_rx_filters enumeration values
+ * @rx_reserved: Reserved for future use; see the note on reserved space.
  *
  * The bits in the 'tx_types' and 'rx_filters' fields correspond to
  * the 'hwtstamp_tx_types' and 'hwtstamp_rx_filters' enumeration values,
@@ -1374,15 +1391,33 @@ struct ethtool_per_queue_op {
 };
 
 /**
- * struct ethtool_fecparam - Ethernet forward error correction(fec) parameters
+ * struct ethtool_fecparam - Ethernet Forward Error Correction parameters
  * @cmd: Command number = %ETHTOOL_GFECPARAM or %ETHTOOL_SFECPARAM
- * @active_fec: FEC mode which is active on porte
- * @fec: Bitmask of supported/configured FEC modes
- * @rsvd: Reserved for future extensions. i.e FEC bypass feature.
+ * @active_fec: FEC mode which is active on the port, single bit set, GET only.
+ * @fec: Bitmask of configured FEC modes.
+ * @reserved: Reserved for future extensions, ignore on GET, write 0 for SET.
  *
- * Drivers should reject a non-zero setting of @autoneg when
- * autoneogotiation is disabled (or not supported) for the link.
+ * Note that @reserved was never validated on input and ethtool user space
+ * left it uninitialized when calling SET. Hence going forward it can only be
+ * used to return a value to userspace with GET.
+ *
+ * FEC modes supported by the device can be read via %ETHTOOL_GLINKSETTINGS.
+ * FEC settings are configured by link autonegotiation whenever it's enabled.
+ * With autoneg on %ETHTOOL_GFECPARAM can be used to read the current mode.
+ *
+ * When autoneg is disabled %ETHTOOL_SFECPARAM controls the FEC settings.
+ * It is recommended that drivers only accept a single bit set in @fec.
+ * When multiple bits are set in @fec drivers may pick mode in an implementation
+ * dependent way. Drivers should reject mixing %ETHTOOL_FEC_AUTO_BIT with other
+ * FEC modes, because it's unclear whether in this case other modes constrain
+ * AUTO or are independent choices.
+ * Drivers must reject SET requests if they support none of the requested modes.
+ *
+ * If device does not support FEC drivers may use %ETHTOOL_FEC_NONE instead
+ * of returning %EOPNOTSUPP from %ETHTOOL_GFECPARAM.
  *
+ * See enum ethtool_fec_config_bits for definition of valid bits for both
+ * @fec and @active_fec.
  */
 struct ethtool_fecparam {
 	__u32   cmd;
@@ -1394,11 +1429,16 @@ struct ethtool_fecparam {
 
 /**
  * enum ethtool_fec_config_bits - flags definition of ethtool_fec_configuration
- * @ETHTOOL_FEC_NONE: FEC mode configuration is not supported
- * @ETHTOOL_FEC_AUTO: Default/Best FEC mode provided by driver
- * @ETHTOOL_FEC_OFF: No FEC Mode
- * @ETHTOOL_FEC_RS: Reed-Solomon Forward Error Detection mode
- * @ETHTOOL_FEC_BASER: Base-R/Reed-Solomon Forward Error Detection mode
+ * @ETHTOOL_FEC_NONE_BIT: FEC mode configuration is not supported. Should not
+ *			be used together with other bits. GET only.
+ * @ETHTOOL_FEC_AUTO_BIT: Select default/best FEC mode automatically, usually
+ *			based link mode and SFP parameters read from module's
+ *			EEPROM. This bit does _not_ mean autonegotiation.
+ * @ETHTOOL_FEC_OFF_BIT: No FEC Mode
+ * @ETHTOOL_FEC_RS_BIT: Reed-Solomon FEC Mode
+ * @ETHTOOL_FEC_BASER_BIT: Base-R/Reed-Solomon FEC Mode
+ * @ETHTOOL_FEC_LLRS_BIT: Low Latency Reed Solomon FEC Mode (25G/50G Ethernet
+ *			Consortium)
  */
 enum ethtool_fec_config_bits {
 	ETHTOOL_FEC_NONE_BIT,
@@ -1956,6 +1996,11 @@ enum ethtool_reset_flags {
  *	autonegotiation; 0 if unknown or not applicable.  Read-only.
  * @transceiver: Used to distinguish different possible PHY types,
  *	reported consistently by PHYLIB.  Read-only.
+ * @master_slave_cfg: Master/slave port mode.
+ * @master_slave_state: Master/slave port state.
+ * @reserved: Reserved for future use; see the note on reserved space.
+ * @reserved1: Reserved for future use; see the note on reserved space.
+ * @link_mode_masks: Variable length bitmaps.
  *
  * If autonegotiation is disabled, the speed and @duplex represent the
  * fixed link mode and are writable if the driver supports multiple
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index 0cd6906aa5d5..4653c4c79972 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -42,6 +42,10 @@ enum {
 	ETHTOOL_MSG_CABLE_TEST_ACT,
 	ETHTOOL_MSG_CABLE_TEST_TDR_ACT,
 	ETHTOOL_MSG_TUNNEL_INFO_GET,
+	ETHTOOL_MSG_FEC_GET,
+	ETHTOOL_MSG_FEC_SET,
+	ETHTOOL_MSG_MODULE_EEPROM_GET,
+	ETHTOOL_MSG_STATS_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -80,6 +84,10 @@ enum {
 	ETHTOOL_MSG_CABLE_TEST_NTF,
 	ETHTOOL_MSG_CABLE_TEST_TDR_NTF,
 	ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY,
+	ETHTOOL_MSG_FEC_GET_REPLY,
+	ETHTOOL_MSG_FEC_NTF,
+	ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY,
+	ETHTOOL_MSG_STATS_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -629,6 +637,185 @@ enum {
 	ETHTOOL_A_TUNNEL_INFO_MAX = (__ETHTOOL_A_TUNNEL_INFO_CNT - 1)
 };
 
+/* FEC */
+
+enum {
+	ETHTOOL_A_FEC_UNSPEC,
+	ETHTOOL_A_FEC_HEADER,				/* nest - _A_HEADER_* */
+	ETHTOOL_A_FEC_MODES,				/* bitset */
+	ETHTOOL_A_FEC_AUTO,				/* u8 */
+	ETHTOOL_A_FEC_ACTIVE,				/* u32 */
+	ETHTOOL_A_FEC_STATS,				/* nest - _A_FEC_STAT */
+
+	__ETHTOOL_A_FEC_CNT,
+	ETHTOOL_A_FEC_MAX = (__ETHTOOL_A_FEC_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_FEC_STAT_UNSPEC,
+	ETHTOOL_A_FEC_STAT_PAD,
+
+	ETHTOOL_A_FEC_STAT_CORRECTED,			/* array, u64 */
+	ETHTOOL_A_FEC_STAT_UNCORR,			/* array, u64 */
+	ETHTOOL_A_FEC_STAT_CORR_BITS,			/* array, u64 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_FEC_STAT_CNT,
+	ETHTOOL_A_FEC_STAT_MAX = (__ETHTOOL_A_FEC_STAT_CNT - 1)
+};
+
+/* MODULE EEPROM */
+
+enum {
+	ETHTOOL_A_MODULE_EEPROM_UNSPEC,
+	ETHTOOL_A_MODULE_EEPROM_HEADER,			/* nest - _A_HEADER_* */
+
+	ETHTOOL_A_MODULE_EEPROM_OFFSET,			/* u32 */
+	ETHTOOL_A_MODULE_EEPROM_LENGTH,			/* u32 */
+	ETHTOOL_A_MODULE_EEPROM_PAGE,			/* u8 */
+	ETHTOOL_A_MODULE_EEPROM_BANK,			/* u8 */
+	ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS,		/* u8 */
+	ETHTOOL_A_MODULE_EEPROM_DATA,			/* nested */
+
+	__ETHTOOL_A_MODULE_EEPROM_CNT,
+	ETHTOOL_A_MODULE_EEPROM_MAX = (__ETHTOOL_A_MODULE_EEPROM_CNT - 1)
+};
+
+/* STATS */
+
+enum {
+	ETHTOOL_A_STATS_UNSPEC,
+	ETHTOOL_A_STATS_PAD,
+	ETHTOOL_A_STATS_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_STATS_GROUPS,			/* bitset */
+
+	ETHTOOL_A_STATS_GRP,			/* nest - _A_STATS_GRP_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_STATS_CNT,
+	ETHTOOL_A_STATS_MAX = (__ETHTOOL_A_STATS_CNT - 1)
+};
+
+enum {
+	ETHTOOL_STATS_ETH_PHY,
+	ETHTOOL_STATS_ETH_MAC,
+	ETHTOOL_STATS_ETH_CTRL,
+	ETHTOOL_STATS_RMON,
+
+	/* add new constants above here */
+	__ETHTOOL_STATS_CNT
+};
+
+enum {
+	ETHTOOL_A_STATS_GRP_UNSPEC,
+	ETHTOOL_A_STATS_GRP_PAD,
+
+	ETHTOOL_A_STATS_GRP_ID,			/* u32 */
+	ETHTOOL_A_STATS_GRP_SS_ID,		/* u32 */
+
+	ETHTOOL_A_STATS_GRP_STAT,		/* nest */
+
+	ETHTOOL_A_STATS_GRP_HIST_RX,		/* nest */
+	ETHTOOL_A_STATS_GRP_HIST_TX,		/* nest */
+
+	ETHTOOL_A_STATS_GRP_HIST_BKT_LOW,	/* u32 */
+	ETHTOOL_A_STATS_GRP_HIST_BKT_HI,	/* u32 */
+	ETHTOOL_A_STATS_GRP_HIST_VAL,		/* u64 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_STATS_GRP_CNT,
+	ETHTOOL_A_STATS_GRP_MAX = (__ETHTOOL_A_STATS_CNT - 1)
+};
+
+enum {
+	/* 30.3.2.1.5 aSymbolErrorDuringCarrier */
+	ETHTOOL_A_STATS_ETH_PHY_5_SYM_ERR,
+
+	/* add new constants above here */
+	__ETHTOOL_A_STATS_ETH_PHY_CNT,
+	ETHTOOL_A_STATS_ETH_PHY_MAX = (__ETHTOOL_A_STATS_ETH_PHY_CNT - 1)
+};
+
+enum {
+	/* 30.3.1.1.2 aFramesTransmittedOK */
+	ETHTOOL_A_STATS_ETH_MAC_2_TX_PKT,
+	/* 30.3.1.1.3 aSingleCollisionFrames */
+	ETHTOOL_A_STATS_ETH_MAC_3_SINGLE_COL,
+	/* 30.3.1.1.4 aMultipleCollisionFrames */
+	ETHTOOL_A_STATS_ETH_MAC_4_MULTI_COL,
+	/* 30.3.1.1.5 aFramesReceivedOK */
+	ETHTOOL_A_STATS_ETH_MAC_5_RX_PKT,
+	/* 30.3.1.1.6 aFrameCheckSequenceErrors */
+	ETHTOOL_A_STATS_ETH_MAC_6_FCS_ERR,
+	/* 30.3.1.1.7 aAlignmentErrors */
+	ETHTOOL_A_STATS_ETH_MAC_7_ALIGN_ERR,
+	/* 30.3.1.1.8 aOctetsTransmittedOK */
+	ETHTOOL_A_STATS_ETH_MAC_8_TX_BYTES,
+	/* 30.3.1.1.9 aFramesWithDeferredXmissions */
+	ETHTOOL_A_STATS_ETH_MAC_9_TX_DEFER,
+	/* 30.3.1.1.10 aLateCollisions */
+	ETHTOOL_A_STATS_ETH_MAC_10_LATE_COL,
+	/* 30.3.1.1.11 aFramesAbortedDueToXSColls */
+	ETHTOOL_A_STATS_ETH_MAC_11_XS_COL,
+	/* 30.3.1.1.12 aFramesLostDueToIntMACXmitError */
+	ETHTOOL_A_STATS_ETH_MAC_12_TX_INT_ERR,
+	/* 30.3.1.1.13 aCarrierSenseErrors */
+	ETHTOOL_A_STATS_ETH_MAC_13_CS_ERR,
+	/* 30.3.1.1.14 aOctetsReceivedOK */
+	ETHTOOL_A_STATS_ETH_MAC_14_RX_BYTES,
+	/* 30.3.1.1.15 aFramesLostDueToIntMACRcvError */
+	ETHTOOL_A_STATS_ETH_MAC_15_RX_INT_ERR,
+
+	/* 30.3.1.1.18 aMulticastFramesXmittedOK */
+	ETHTOOL_A_STATS_ETH_MAC_18_TX_MCAST,
+	/* 30.3.1.1.19 aBroadcastFramesXmittedOK */
+	ETHTOOL_A_STATS_ETH_MAC_19_TX_BCAST,
+	/* 30.3.1.1.20 aFramesWithExcessiveDeferral */
+	ETHTOOL_A_STATS_ETH_MAC_20_XS_DEFER,
+	/* 30.3.1.1.21 aMulticastFramesReceivedOK */
+	ETHTOOL_A_STATS_ETH_MAC_21_RX_MCAST,
+	/* 30.3.1.1.22 aBroadcastFramesReceivedOK */
+	ETHTOOL_A_STATS_ETH_MAC_22_RX_BCAST,
+	/* 30.3.1.1.23 aInRangeLengthErrors */
+	ETHTOOL_A_STATS_ETH_MAC_23_IR_LEN_ERR,
+	/* 30.3.1.1.24 aOutOfRangeLengthField */
+	ETHTOOL_A_STATS_ETH_MAC_24_OOR_LEN,
+	/* 30.3.1.1.25 aFrameTooLongErrors */
+	ETHTOOL_A_STATS_ETH_MAC_25_TOO_LONG_ERR,
+
+	/* add new constants above here */
+	__ETHTOOL_A_STATS_ETH_MAC_CNT,
+	ETHTOOL_A_STATS_ETH_MAC_MAX = (__ETHTOOL_A_STATS_ETH_MAC_CNT - 1)
+};
+
+enum {
+	/* 30.3.3.3 aMACControlFramesTransmitted */
+	ETHTOOL_A_STATS_ETH_CTRL_3_TX,
+	/* 30.3.3.4 aMACControlFramesReceived */
+	ETHTOOL_A_STATS_ETH_CTRL_4_RX,
+	/* 30.3.3.5 aUnsupportedOpcodesReceived */
+	ETHTOOL_A_STATS_ETH_CTRL_5_RX_UNSUP,
+
+	/* add new constants above here */
+	__ETHTOOL_A_STATS_ETH_CTRL_CNT,
+	ETHTOOL_A_STATS_ETH_CTRL_MAX = (__ETHTOOL_A_STATS_ETH_CTRL_CNT - 1)
+};
+
+enum {
+	/* etherStatsUndersizePkts */
+	ETHTOOL_A_STATS_RMON_UNDERSIZE,
+	/* etherStatsOversizePkts */
+	ETHTOOL_A_STATS_RMON_OVERSIZE,
+	/* etherStatsFragments */
+	ETHTOOL_A_STATS_RMON_FRAG,
+	/* etherStatsJabbers */
+	ETHTOOL_A_STATS_RMON_JABBER,
+
+	/* add new constants above here */
+	__ETHTOOL_A_STATS_RMON_CNT,
+	ETHTOOL_A_STATS_RMON_MAX = (__ETHTOOL_A_STATS_RMON_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/uapi/linux/if_link.h b/uapi/linux/if_link.h
index c96880c51c93..0e81707a9637 100644
--- a/uapi/linux/if_link.h
+++ b/uapi/linux/if_link.h
@@ -612,6 +612,7 @@ enum macvlan_macaddr_mode {
 };
 
 #define MACVLAN_FLAG_NOPROMISC	1
+#define MACVLAN_FLAG_NODST	2 /* skip dst macvlan if matching src macvlan */
 
 /* VRF section */
 enum {
@@ -809,7 +810,6 @@ enum {
 	IFLA_GTP_FD1,
 	IFLA_GTP_PDP_HASHSIZE,
 	IFLA_GTP_ROLE,
-	IFLA_GTP_COLLECT_METADATA,
 	__IFLA_GTP_MAX,
 };
 #define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)
diff --git a/uapi/linux/rtnetlink.h b/uapi/linux/rtnetlink.h
index c66fd247d90a..e01efa281bdc 100644
--- a/uapi/linux/rtnetlink.h
+++ b/uapi/linux/rtnetlink.h
@@ -178,6 +178,13 @@ enum {
 	RTM_GETVLAN,
 #define RTM_GETVLAN	RTM_GETVLAN
 
+	RTM_NEWNEXTHOPBUCKET = 116,
+#define RTM_NEWNEXTHOPBUCKET	RTM_NEWNEXTHOPBUCKET
+	RTM_DELNEXTHOPBUCKET,
+#define RTM_DELNEXTHOPBUCKET	RTM_DELNEXTHOPBUCKET
+	RTM_GETNEXTHOPBUCKET,
+#define RTM_GETNEXTHOPBUCKET	RTM_GETNEXTHOPBUCKET
+
 	__RTM_MAX,
 #define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
 };
@@ -283,6 +290,7 @@ enum {
 #define RTPROT_MROUTED		17	/* Multicast daemon */
 #define RTPROT_KEEPALIVED	18	/* Keepalived daemon */
 #define RTPROT_BABEL		42	/* Babel daemon */
+#define RTPROT_OPENR		99	/* Open Routing (Open/R) Routes */
 #define RTPROT_BGP		186	/* BGP Routes */
 #define RTPROT_ISIS		187	/* ISIS Routes */
 #define RTPROT_OSPF		188	/* OSPF Routes */
@@ -319,6 +327,11 @@ enum rt_scope_t {
 #define RTM_F_FIB_MATCH	        0x2000	/* return full fib lookup match */
 #define RTM_F_OFFLOAD		0x4000	/* route is offloaded */
 #define RTM_F_TRAP		0x8000	/* route is trapping packets */
+#define RTM_F_OFFLOAD_FAILED	0x20000000 /* route offload failed, this value
+					    * is chosen to avoid conflicts with
+					    * other flags defined in
+					    * include/uapi/linux/ipv6_route.h
+					    */
 
 /* Reserved table identifiers */
 
-- 
2.31.1

