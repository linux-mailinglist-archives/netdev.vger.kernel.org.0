Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE9D64664D
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiLHBLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiLHBLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:11:39 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B778BD26
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 17:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670461897; x=1701997897;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ttq8d6rpltmmvrAPtIyQb1R0FBtyDyjKbbEm+5DxLqs=;
  b=jvqmhkFZZxq36KQ5Vg6xCtWwBDK8R9CxW7hWYcD/5xPXuVApEwwGxQs3
   ZtpRL8fGQqaLuI5+w8Y8zjy//EOQcOOtHKOos29CY6xU4HgETkhbZ9ABV
   AHISJ3Ub2z+ayPKFt9FkqBoYmAJX4LG83BGaCjwbcUgr4aya7shE6VY4k
   3RidNoPw159yDKc20DAhjilYXPtsf8G8K5hYd9IYKJZI21brQ7wGUcIex
   ln3Ro3v1Pch6cnzeSxZHo0+rGlIIurucF1FR0RLzzLkvpXCRaOnJP8z0M
   4w1hVmbdl1sPPi4xaO0MMRPi7Idt9AkATnVKzL1xNaM+cnHQV3AkMdtkv
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="304672881"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="304672881"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="640445375"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="640445375"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:30 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH ethtool v2 09/13] ethtool: merge uapi changes to implement BIT and friends
Date:   Wed,  7 Dec 2022 17:11:18 -0800
Message-Id: <20221208011122.2343363-10-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was looking into some errors reported by the runtime sanitizers and
found a couple of places where (1 << 31) was being used. This is a shift
of a bit into the sign-bit of an integer. This is undefined behavior for
the C-specification, and can be easily fixed with using (1UL << 31)
instead. A better way to do this is to use the BIT() macro, which
already has the 1UL in it (see future patch in series).

Convert and sync with the same changes made upstream to the uapi file,
to implement ethtool use BIT() and friends.

This required an unfortunate bit of extra fussing around declaring "same
definition" versions of the BIT* macros so that the UAPI file will
compile both under the kernel and in user-space (here).

A local declaration of BIT() had to be moved out of fsl_enetc.c when
the implementation was moved to a header.

NOTE:
This change will be followed by a larger conversion patch, but *this*
commit only has the UAPI file changes and the initial implementation to
keep the work separate from the application only changes.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 fsl_enetc.c                  |   2 -
 uapi/linux/ethtool.h         | 112 +++++++++++++++++++++--------------
 uapi/linux/ethtool_netlink.h |   6 +-
 3 files changed, 70 insertions(+), 50 deletions(-)

diff --git a/fsl_enetc.c b/fsl_enetc.c
index 1180a664f777..9dbeae951bad 100644
--- a/fsl_enetc.c
+++ b/fsl_enetc.c
@@ -5,8 +5,6 @@
 #include <stdio.h>
 #include "internal.h"
 
-#define BIT(x)			(1U << (x))
-
 enum enetc_bdr_type {TX, RX};
 #define ENETC_SIMR		0
 #define ENETC_SIPMAR0		0x80
diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index 944711cfa6f6..8773143e4737 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -9,6 +9,7 @@
  *                                christopher.leech@intel.com,
  *                                scott.feldman@intel.com)
  * Portions Copyright (C) Sun Microsystems 2008
+ * Portions Copyright (C) 2022 Intel Corporation
  */
 
 #ifndef _LINUX_ETHTOOL_H
@@ -20,6 +21,27 @@
 
 #include <limits.h> /* for INT_MAX */
 
+/* BIT() and BIT_ULL() are defined in include/linux/bits.h but we need a
+ * local version to clean up this file and not break simultaneous
+ * kernel/userspace where userspace doesn't have the BIT and BIT_ULL
+ * defined. To avoid compiler issues we use the exact same definitions here
+ * of the macros as defined in the file noted below, so that we don't get
+ * 'duplicate define' or 'redefinition' errors.
+ */
+/* include/uapi/linux/const.h */
+#define __AC(X,Y)	(X##Y)
+#define _AC(X,Y)	__AC(X,Y)
+#define _AT(T,X)	((T)(X))
+#define _UL(x)		(_AC(x, UL))
+#define _ULL(x)		(_AC(x, ULL))
+/* include/vdso/linux/const.h */
+#define UL(x)		(_UL(x))
+#define ULL(x)		(_ULL(x))
+/* include/vdso/bits.h */
+#define BIT(nr)		(UL(1) << (nr))
+/* include/linux/bits.h */
+#define BIT_ULL(nr)	(ULL(1) << (nr))
+
 /* All structures exposed to userland should be defined such that they
  * have the same layout for 32-bit and 64-bit userland.
  */
@@ -789,10 +811,10 @@ struct ethtool_sset_info {
  */
 
 enum ethtool_test_flags {
-	ETH_TEST_FL_OFFLINE	= (1 << 0),
-	ETH_TEST_FL_FAILED	= (1 << 1),
-	ETH_TEST_FL_EXTERNAL_LB	= (1 << 2),
-	ETH_TEST_FL_EXTERNAL_LB_DONE	= (1 << 3),
+	ETH_TEST_FL_OFFLINE		= BIT(0),
+	ETH_TEST_FL_FAILED		= BIT(1),
+	ETH_TEST_FL_EXTERNAL_LB		= BIT(2),
+	ETH_TEST_FL_EXTERNAL_LB_DONE	= BIT(3),
 };
 
 /**
@@ -862,11 +884,11 @@ struct ethtool_perm_addr {
  * flag differs from the read-only value.
  */
 enum ethtool_flags {
-	ETH_FLAG_TXVLAN		= (1 << 7),	/* TX VLAN offload enabled */
-	ETH_FLAG_RXVLAN		= (1 << 8),	/* RX VLAN offload enabled */
-	ETH_FLAG_LRO		= (1 << 15),	/* LRO is enabled */
-	ETH_FLAG_NTUPLE		= (1 << 27),	/* N-tuple filters enabled */
-	ETH_FLAG_RXHASH		= (1 << 28),
+	ETH_FLAG_TXVLAN		= BIT(7),	/* TX VLAN offload enabled */
+	ETH_FLAG_RXVLAN		= BIT(8),	/* RX VLAN offload enabled */
+	ETH_FLAG_LRO		= BIT(15),	/* LRO is enabled */
+	ETH_FLAG_NTUPLE		= BIT(27),	/* N-tuple filters enabled */
+	ETH_FLAG_RXHASH		= BIT(28),
 };
 
 /* The following structures are for supporting RX network flow
@@ -1354,7 +1376,7 @@ struct ethtool_sfeatures {
  * The bits in the 'tx_types' and 'rx_filters' fields correspond to
  * the 'hwtstamp_tx_types' and 'hwtstamp_rx_filters' enumeration values,
  * respectively.  For example, if the device supports HWTSTAMP_TX_ON,
- * then (1 << HWTSTAMP_TX_ON) in 'tx_types' will be set.
+ * then BIT(HWTSTAMP_TX_ON) in 'tx_types' will be set.
  *
  * Drivers should only report the filters they actually support without
  * upscaling in the SIOCSHWTSTAMP ioctl. If the SIOCSHWSTAMP request for
@@ -1402,9 +1424,9 @@ enum ethtool_sfeatures_retval_bits {
 	ETHTOOL_F_COMPAT__BIT,
 };
 
-#define ETHTOOL_F_UNSUPPORTED   (1 << ETHTOOL_F_UNSUPPORTED__BIT)
-#define ETHTOOL_F_WISH          (1 << ETHTOOL_F_WISH__BIT)
-#define ETHTOOL_F_COMPAT        (1 << ETHTOOL_F_COMPAT__BIT)
+#define ETHTOOL_F_UNSUPPORTED   BIT(ETHTOOL_F_UNSUPPORTED__BIT)
+#define ETHTOOL_F_WISH          BIT(ETHTOOL_F_WISH__BIT)
+#define ETHTOOL_F_COMPAT        BIT(ETHTOOL_F_COMPAT__BIT)
 
 #define MAX_NUM_QUEUE		4096
 
@@ -1481,12 +1503,12 @@ enum ethtool_fec_config_bits {
 	ETHTOOL_FEC_LLRS_BIT,
 };
 
-#define ETHTOOL_FEC_NONE		(1 << ETHTOOL_FEC_NONE_BIT)
-#define ETHTOOL_FEC_AUTO		(1 << ETHTOOL_FEC_AUTO_BIT)
-#define ETHTOOL_FEC_OFF			(1 << ETHTOOL_FEC_OFF_BIT)
-#define ETHTOOL_FEC_RS			(1 << ETHTOOL_FEC_RS_BIT)
-#define ETHTOOL_FEC_BASER		(1 << ETHTOOL_FEC_BASER_BIT)
-#define ETHTOOL_FEC_LLRS		(1 << ETHTOOL_FEC_LLRS_BIT)
+#define ETHTOOL_FEC_NONE		BIT(ETHTOOL_FEC_NONE_BIT)
+#define ETHTOOL_FEC_AUTO		BIT(ETHTOOL_FEC_AUTO_BIT)
+#define ETHTOOL_FEC_OFF			BIT(ETHTOOL_FEC_OFF_BIT)
+#define ETHTOOL_FEC_RS			BIT(ETHTOOL_FEC_RS_BIT)
+#define ETHTOOL_FEC_BASER		BIT(ETHTOOL_FEC_BASER_BIT)
+#define ETHTOOL_FEC_LLRS		BIT(ETHTOOL_FEC_LLRS_BIT)
 
 /* CMDs currently supported */
 #define ETHTOOL_GSET		0x00000001 /* DEPRECATED, Get settings.
@@ -1695,7 +1717,7 @@ enum ethtool_link_mode_bit_indices {
 };
 
 #define __ETHTOOL_LINK_MODE_LEGACY_MASK(base_name)	\
-	(1UL << (ETHTOOL_LINK_MODE_ ## base_name ## _BIT))
+	BIT_ULL((ETHTOOL_LINK_MODE_ ## base_name ## _BIT))
 
 /* DEPRECATED macros. Please migrate to
  * ETHTOOL_GLINKSETTINGS/ETHTOOL_SLINKSETTINGS API. Please do NOT
@@ -1868,14 +1890,14 @@ static __inline__ int ethtool_validate_duplex(__u8 duplex)
 #define ETH_TP_MDI_AUTO		0x03 /*                  control: auto-select */
 
 /* Wake-On-Lan options. */
-#define WAKE_PHY		(1 << 0)
-#define WAKE_UCAST		(1 << 1)
-#define WAKE_MCAST		(1 << 2)
-#define WAKE_BCAST		(1 << 3)
-#define WAKE_ARP		(1 << 4)
-#define WAKE_MAGIC		(1 << 5)
-#define WAKE_MAGICSECURE	(1 << 6) /* only meaningful if WAKE_MAGIC */
-#define WAKE_FILTER		(1 << 7)
+#define WAKE_PHY		BIT(0)
+#define WAKE_UCAST		BIT(1)
+#define WAKE_MCAST		BIT(2)
+#define WAKE_BCAST		BIT(3)
+#define WAKE_ARP		BIT(4)
+#define WAKE_MAGIC		BIT(5)
+#define WAKE_MAGICSECURE	BIT(6) /* only meaningful if WAKE_MAGIC */
+#define WAKE_FILTER		BIT(7)
 
 #define WOL_MODE_COUNT		8
 
@@ -1905,14 +1927,14 @@ static __inline__ int ethtool_validate_duplex(__u8 duplex)
 #define	FLOW_RSS	0x20000000
 
 /* L3-L4 network traffic flow hash options */
-#define	RXH_L2DA	(1 << 1)
-#define	RXH_VLAN	(1 << 2)
-#define	RXH_L3_PROTO	(1 << 3)
-#define	RXH_IP_SRC	(1 << 4)
-#define	RXH_IP_DST	(1 << 5)
-#define	RXH_L4_B_0_1	(1 << 6) /* src port in case of TCP/UDP/SCTP */
-#define	RXH_L4_B_2_3	(1 << 7) /* dst port in case of TCP/UDP/SCTP */
-#define	RXH_DISCARD	(1 << 31)
+#define	RXH_L2DA	BIT(1)
+#define	RXH_VLAN	BIT(2)
+#define	RXH_L3_PROTO	BIT(3)
+#define	RXH_IP_SRC	BIT(4)
+#define	RXH_IP_DST	BIT(5)
+#define	RXH_L4_B_0_1	BIT(6) /* src port in case of TCP/UDP/SCTP */
+#define	RXH_L4_B_2_3	BIT(7) /* dst port in case of TCP/UDP/SCTP */
+#define	RXH_DISCARD	BIT(31)
 
 #define	RX_CLS_FLOW_DISC	0xffffffffffffffffULL
 #define RX_CLS_FLOW_WAKE	0xfffffffffffffffeULL
@@ -1949,16 +1971,16 @@ enum ethtool_reset_flags {
 	 * ETH_RESET_SHARED_SHIFT to reset a shared component of the
 	 * same type.
 	 */
-	ETH_RESET_MGMT		= 1 << 0,	/* Management processor */
-	ETH_RESET_IRQ		= 1 << 1,	/* Interrupt requester */
-	ETH_RESET_DMA		= 1 << 2,	/* DMA engine */
-	ETH_RESET_FILTER	= 1 << 3,	/* Filtering/flow direction */
-	ETH_RESET_OFFLOAD	= 1 << 4,	/* Protocol offload */
-	ETH_RESET_MAC		= 1 << 5,	/* Media access controller */
-	ETH_RESET_PHY		= 1 << 6,	/* Transceiver/PHY */
-	ETH_RESET_RAM		= 1 << 7,	/* RAM shared between
+	ETH_RESET_MGMT		= BIT(0),	/* Management processor */
+	ETH_RESET_IRQ		= BIT(1),	/* Interrupt requester */
+	ETH_RESET_DMA		= BIT(2),	/* DMA engine */
+	ETH_RESET_FILTER	= BIT(3),	/* Filtering/flow direction */
+	ETH_RESET_OFFLOAD	= BIT(4),	/* Protocol offload */
+	ETH_RESET_MAC		= BIT(5),	/* Media access controller */
+	ETH_RESET_PHY		= BIT(6),	/* Transceiver/PHY */
+	ETH_RESET_RAM		= BIT(7),	/* RAM shared between
 						 * multiple components */
-	ETH_RESET_AP		= 1 << 8,	/* Application processor */
+	ETH_RESET_AP		= BIT(8),	/* Application processor */
 
 	ETH_RESET_DEDICATED	= 0x0000ffff,	/* All components dedicated to
 						 * this interface */
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index 378ad7da74f4..8b9814e2c704 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -103,11 +103,11 @@ enum {
 /* request header */
 
 /* use compact bitsets in reply */
-#define ETHTOOL_FLAG_COMPACT_BITSETS	(1 << 0)
+#define ETHTOOL_FLAG_COMPACT_BITSETS	BIT(0)
 /* provide optional reply for SET or ACT requests */
-#define ETHTOOL_FLAG_OMIT_REPLY	(1 << 1)
+#define ETHTOOL_FLAG_OMIT_REPLY		BIT(1)
 /* request statistics, if supported by the driver */
-#define ETHTOOL_FLAG_STATS		(1 << 2)
+#define ETHTOOL_FLAG_STATS		BIT(2)
 
 #define ETHTOOL_FLAG_ALL (ETHTOOL_FLAG_COMPACT_BITSETS | \
 			  ETHTOOL_FLAG_OMIT_REPLY | \
-- 
2.31.1

