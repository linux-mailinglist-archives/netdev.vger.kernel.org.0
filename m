Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A246464EF
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiLGXRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiLGXRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:17:50 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004D52B26C
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 15:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670455066; x=1701991066;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RYV15po8hm5iZxwSem9oKboHl498WblL+0b3GMBpo6g=;
  b=fymAzu3dILABe+fPye8D4DWPiMnG2QB4SltnExTn6a6/w04J2q6JFSHJ
   tOvgZ0CRgIPNL3iLh57MX30y5ZaZxgKEsFOqk/vnx3TjSPyXGrzJQ95W/
   Z8CEsx1u+j1MSjwquuZOQnEKVpr2/SqhhaB85KMrau+4/9nvEGECHx7/Q
   MAbY5lhfjyphOx6ENC7S0KWRD2T4GoSaTookwpP+CobargJyosDAPJuSI
   9K5i02j0tdlMEJ61HhAGxlRNtrhlTLlBudXNd+3mLvaYQsgIaRz+TV4qt
   1wqYcuapwrEo1GRWTxcpyA4hwVmj8Zvw97sFe+t7w1IGoB1N2Q/dPBzGv
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="403293969"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="403293969"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 15:17:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="677539549"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="677539549"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 15:17:41 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net-next v1 1/2] ethtool/uapi: use BIT for bit-shifts
Date:   Wed,  7 Dec 2022 15:17:27 -0800
Message-Id: <20221207231728.2331166-2-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221207231728.2331166-1-jesse.brandeburg@intel.com>
References: <20221207231728.2331166-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Open-coded bit-shifts such as (1 << foo) are able to be accidentally
coded to shift << 31 into the sign bit.  The way to avoid this is to use
the BIT() and BIT_ULL() macros which correctly define the shift as
(1UL << foo) and (1ULL << foo), respectively.

Most of the kernel is using these already, but a few of the ethtool
files had been avoided because they touch UAPI and the port wasn't quite
clear.

This change matches one made to the userspace ethtool app that shows
that this "small copy" of the code from bits.h allows us to use the
modern and safe way in the ethtool UAPI files but have a way that still
compiles both in the kernel (and for header checks) and in user-space,
and avoids compilation dependencies by defining the macros in the same
way as they are defined in the kernel proper header files.

Now we can use BIT() and friends in ethtool headers as well, so refactor
the code to use BIT().

NOTES:
These duplicated macro definitions may need to be updated if the kernel
definitions change, but it will generate warnings so we should be able
to catch it.

This change is known to generate some unavoidable checkpatch errors due
to keeping the code exactly the same as defined in other header files.

CC: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 include/linux/ethtool.h              |   2 +-
 include/uapi/linux/ethtool.h         | 112 ++++++++++++++++-----------
 include/uapi/linux/ethtool_netlink.h |   6 +-
 net/ethtool/ioctl.c                  |   4 +-
 net/ethtool/strset.c                 |   6 +-
 5 files changed, 76 insertions(+), 54 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 9e0a76fc7de9..4d67de1171b0 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -93,7 +93,7 @@ enum ethtool_supported_ring_param {
 	ETHTOOL_RING_USE_TX_PUSH    = BIT(2),
 };
 
-#define __ETH_RSS_HASH_BIT(bit)	((u32)1 << (bit))
+#define __ETH_RSS_HASH_BIT(bit)	BIT((bit))
 #define __ETH_RSS_HASH(name)	__ETH_RSS_HASH_BIT(ETH_RSS_HASH_##name##_BIT)
 
 #define ETH_RSS_HASH_TOP	__ETH_RSS_HASH(TOP)
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 58e587ba0450..6ce5da444098 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -9,6 +9,7 @@
  *                                christopher.leech@intel.com,
  *                                scott.feldman@intel.com)
  * Portions Copyright (C) Sun Microsystems 2008
+ * Portions Copyright (C) 2022 Intel Corporation
  */
 
 #ifndef _UAPI_LINUX_ETHTOOL_H
@@ -22,6 +23,27 @@
 #include <limits.h> /* for INT_MAX */
 #endif
 
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
@@ -834,10 +856,10 @@ struct ethtool_sset_info {
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
@@ -907,11 +929,11 @@ struct ethtool_perm_addr {
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
@@ -1399,7 +1421,7 @@ struct ethtool_sfeatures {
  * The bits in the 'tx_types' and 'rx_filters' fields correspond to
  * the 'hwtstamp_tx_types' and 'hwtstamp_rx_filters' enumeration values,
  * respectively.  For example, if the device supports HWTSTAMP_TX_ON,
- * then (1 << HWTSTAMP_TX_ON) in 'tx_types' will be set.
+ * then BIT(HWTSTAMP_TX_ON) in 'tx_types' will be set.
  *
  * Drivers should only report the filters they actually support without
  * upscaling in the SIOCSHWTSTAMP ioctl. If the SIOCSHWSTAMP request for
@@ -1447,9 +1469,9 @@ enum ethtool_sfeatures_retval_bits {
 	ETHTOOL_F_COMPAT__BIT,
 };
 
-#define ETHTOOL_F_UNSUPPORTED   (1 << ETHTOOL_F_UNSUPPORTED__BIT)
-#define ETHTOOL_F_WISH          (1 << ETHTOOL_F_WISH__BIT)
-#define ETHTOOL_F_COMPAT        (1 << ETHTOOL_F_COMPAT__BIT)
+#define ETHTOOL_F_UNSUPPORTED   BIT(ETHTOOL_F_UNSUPPORTED__BIT)
+#define ETHTOOL_F_WISH          BIT(ETHTOOL_F_WISH__BIT)
+#define ETHTOOL_F_COMPAT        BIT(ETHTOOL_F_COMPAT__BIT)
 
 #define MAX_NUM_QUEUE		4096
 
@@ -1526,12 +1548,12 @@ enum ethtool_fec_config_bits {
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
@@ -1747,7 +1769,7 @@ enum ethtool_link_mode_bit_indices {
 };
 
 #define __ETHTOOL_LINK_MODE_LEGACY_MASK(base_name)	\
-	(1UL << (ETHTOOL_LINK_MODE_ ## base_name ## _BIT))
+	BIT_ULL((ETHTOOL_LINK_MODE_ ## base_name ## _BIT))
 
 /* DEPRECATED macros. Please migrate to
  * ETHTOOL_GLINKSETTINGS/ETHTOOL_SLINKSETTINGS API. Please do NOT
@@ -1935,14 +1957,14 @@ static inline int ethtool_validate_duplex(__u8 duplex)
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
 
@@ -1972,14 +1994,14 @@ static inline int ethtool_validate_duplex(__u8 duplex)
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
@@ -2016,16 +2038,16 @@ enum ethtool_reset_flags {
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
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 5799a9db034e..8561d07e7b80 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -108,11 +108,11 @@ enum {
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
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index c2f1a542e6fa..60e26f6970f9 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -794,12 +794,12 @@ static noinline_for_stack int ethtool_get_sset_info(struct net_device *dev,
 	 * get_sset_count return
 	 */
 	for (i = 0; i < 64; i++) {
-		if (!(sset_mask & (1ULL << i)))
+		if (!(sset_mask & BIT_ULL(i)))
 			continue;
 
 		rc = __ethtool_get_sset_count(dev, i);
 		if (rc >= 0) {
-			info.sset_mask |= (1ULL << i);
+			info.sset_mask |= BIT_ULL(i);
 			info_buf[idx++] = rc;
 		}
 	}
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 3f7de54d85fb..bd9bc68608d0 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -149,7 +149,7 @@ static bool strset_include(const struct strset_req_info *info,
 	BUILD_BUG_ON(ETH_SS_COUNT >= BITS_PER_BYTE * sizeof(info->req_ids));
 
 	if (info->req_ids)
-		return info->req_ids & (1U << id);
+		return info->req_ids & BIT(id);
 	per_dev = data->sets[id].per_dev;
 	if (!per_dev && !data->sets[id].strings)
 		return false;
@@ -213,7 +213,7 @@ static int strset_parse_request(struct ethnl_req_info *req_base,
 			return -EOPNOTSUPP;
 		}
 
-		req_info->req_ids |= (1U << id);
+		req_info->req_ids |= BIT(id);
 	}
 
 	return 0;
@@ -287,7 +287,7 @@ static int strset_prepare_data(const struct ethnl_req_info *req_base,
 
 	if (!dev) {
 		for (i = 0; i < ETH_SS_COUNT; i++) {
-			if ((req_info->req_ids & (1U << i)) &&
+			if ((req_info->req_ids & BIT(i)) &&
 			    data->sets[i].per_dev) {
 				if (info)
 					GENL_SET_ERR_MSG(info, "requested per device strings without dev");
-- 
2.31.1

