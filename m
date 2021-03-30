Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0958134DFD9
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 06:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhC3ECN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 00:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231139AbhC3EB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 00:01:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AC6A61929;
        Tue, 30 Mar 2021 04:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617076916;
        bh=jj4zDSRwz1/y4OPeWNllNF02JTrbayMEHydg7F7ohJo=;
        h=From:To:Cc:Subject:Date:From;
        b=DOTqgkTi5aN2q+5vEEZspUyqPx33gSIuQYmCUhDplh0jasLqpTtolJkb1mXLiKvu2
         Rqk3b6TwhXvBb7JtDYryWfx951bJDRwvVqL2nNDzEJ/VMhLpscWzk2HPI/B3OxlrLr
         CDV9SIRSdum384EJdbLLycMtOZHgU9+CoEJbjWRUWQFfym071Koap8LnbZTAxAyT6X
         Sp3s1iGmLA2RiCJxuWYgYiJg9hW+5cIyj3ctsMlo9FeMkhKRT/2H2Rz8G5mf1i4m5o
         xWUJvof0fCW0BITvFuMJO/NT+AqdOHWJS1pL+ighxOhH7tfZ6WDXDKBuSk5sfc5Wti
         J3CxUUVbYQ5jg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC ethtool-next 1/3] update UAPI header copies
Date:   Mon, 29 Mar 2021 21:01:52 -0700
Message-Id: <20210330040154.1218028-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to kernel commit 6917719f1b85.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 uapi/linux/ethtool.h         | 47 +++++++++++++++++++++++++++---------
 uapi/linux/ethtool_netlink.h | 18 ++++++++++++++
 uapi/linux/if_link.h         |  9 +++++--
 uapi/linux/netlink.h         |  2 +-
 uapi/linux/rtnetlink.h       | 33 +++++++++++++++++++++----
 5 files changed, 89 insertions(+), 20 deletions(-)

diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index 052689bcc90c..ceb34faa1b16 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -14,7 +14,7 @@
 #ifndef _LINUX_ETHTOOL_H
 #define _LINUX_ETHTOOL_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/if_ether.h>
 
@@ -1374,15 +1374,33 @@ struct ethtool_per_queue_op {
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
@@ -1394,11 +1412,16 @@ struct ethtool_fecparam {
 
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
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index c022883cdb22..737b1a4b342c 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -42,6 +42,8 @@ enum {
 	ETHTOOL_MSG_CABLE_TEST_ACT,
 	ETHTOOL_MSG_CABLE_TEST_TDR_ACT,
 	ETHTOOL_MSG_TUNNEL_INFO_GET,
+	ETHTOOL_MSG_FEC_GET,
+	ETHTOOL_MSG_FEC_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -80,6 +82,8 @@ enum {
 	ETHTOOL_MSG_CABLE_TEST_NTF,
 	ETHTOOL_MSG_CABLE_TEST_TDR_NTF,
 	ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY,
+	ETHTOOL_MSG_FEC_GET_REPLY,
+	ETHTOOL_MSG_FEC_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -227,6 +231,7 @@ enum {
 	ETHTOOL_A_LINKMODES_DUPLEX,		/* u8 */
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,	/* u8 */
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,	/* u8 */
+	ETHTOOL_A_LINKMODES_LANES,		/* u32 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_LINKMODES_CNT,
@@ -628,6 +633,19 @@ enum {
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
+
+	__ETHTOOL_A_FEC_CNT,
+	ETHTOOL_A_FEC_MAX = (__ETHTOOL_A_FEC_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/uapi/linux/if_link.h b/uapi/linux/if_link.h
index 307e5c245e9f..50193377e5e4 100644
--- a/uapi/linux/if_link.h
+++ b/uapi/linux/if_link.h
@@ -75,8 +75,9 @@ struct rtnl_link_stats {
  *
  * @rx_dropped: Number of packets received but not processed,
  *   e.g. due to lack of resources or unsupported protocol.
- *   For hardware interfaces this counter should not include packets
- *   dropped by the device which are counted separately in
+ *   For hardware interfaces this counter may include packets discarded
+ *   due to L2 address filtering but should not include packets dropped
+ *   by the device due to buffer exhaustion which are counted separately in
  *   @rx_missed_errors (since procfs folds those two counters together).
  *
  * @tx_dropped: Number of packets dropped on their way to transmission,
@@ -522,6 +523,8 @@ enum {
 	IFLA_BRPORT_BACKUP_PORT,
 	IFLA_BRPORT_MRP_RING_OPEN,
 	IFLA_BRPORT_MRP_IN_OPEN,
+	IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
+	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
@@ -586,6 +589,8 @@ enum {
 	IFLA_MACVLAN_MACADDR,
 	IFLA_MACVLAN_MACADDR_DATA,
 	IFLA_MACVLAN_MACADDR_COUNT,
+	IFLA_MACVLAN_BC_QUEUE_LEN,
+	IFLA_MACVLAN_BC_QUEUE_LEN_USED,
 	__IFLA_MACVLAN_MAX,
 };
 
diff --git a/uapi/linux/netlink.h b/uapi/linux/netlink.h
index dfef006be9f9..5024c5435749 100644
--- a/uapi/linux/netlink.h
+++ b/uapi/linux/netlink.h
@@ -2,7 +2,7 @@
 #ifndef __LINUX_NETLINK_H
 #define __LINUX_NETLINK_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/socket.h> /* for __kernel_sa_family_t */
 #include <linux/types.h>
 
diff --git a/uapi/linux/rtnetlink.h b/uapi/linux/rtnetlink.h
index 5ad84e663d01..e01efa281bdc 100644
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
 
@@ -396,11 +409,13 @@ struct rtnexthop {
 #define RTNH_F_DEAD		1	/* Nexthop is dead (used by multipath)	*/
 #define RTNH_F_PERVASIVE	2	/* Do recursive gateway lookup	*/
 #define RTNH_F_ONLINK		4	/* Gateway is forced on link	*/
-#define RTNH_F_OFFLOAD		8	/* offloaded route */
+#define RTNH_F_OFFLOAD		8	/* Nexthop is offloaded */
 #define RTNH_F_LINKDOWN		16	/* carrier-down on nexthop */
 #define RTNH_F_UNRESOLVED	32	/* The entry is unresolved (ipmr) */
+#define RTNH_F_TRAP		64	/* Nexthop is trapping packets */
 
-#define RTNH_COMPARE_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN | RTNH_F_OFFLOAD)
+#define RTNH_COMPARE_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN | \
+				 RTNH_F_OFFLOAD | RTNH_F_TRAP)
 
 /* Macros to handle hexthops */
 
@@ -764,12 +779,18 @@ enum {
 #define TA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct tcamsg))
 /* tcamsg flags stored in attribute TCA_ROOT_FLAGS
  *
- * TCA_FLAG_LARGE_DUMP_ON user->kernel to request for larger than TCA_ACT_MAX_PRIO
- * actions in a dump. All dump responses will contain the number of actions
- * being dumped stored in for user app's consumption in TCA_ROOT_COUNT
+ * TCA_ACT_FLAG_LARGE_DUMP_ON user->kernel to request for larger than
+ * TCA_ACT_MAX_PRIO actions in a dump. All dump responses will contain the
+ * number of actions being dumped stored in for user app's consumption in
+ * TCA_ROOT_COUNT
+ *
+ * TCA_ACT_FLAG_TERSE_DUMP user->kernel to request terse (brief) dump that only
+ * includes essential action info (kind, index, etc.)
  *
  */
 #define TCA_FLAG_LARGE_DUMP_ON		(1 << 0)
+#define TCA_ACT_FLAG_LARGE_DUMP_ON	TCA_FLAG_LARGE_DUMP_ON
+#define TCA_ACT_FLAG_TERSE_DUMP		(1 << 1)
 
 /* New extended info filters for IFLA_EXT_MASK */
 #define RTEXT_FILTER_VF		(1 << 0)
@@ -777,6 +798,8 @@ enum {
 #define RTEXT_FILTER_BRVLAN_COMPRESSED	(1 << 2)
 #define	RTEXT_FILTER_SKIP_STATS	(1 << 3)
 #define RTEXT_FILTER_MRP	(1 << 4)
+#define RTEXT_FILTER_CFM_CONFIG	(1 << 5)
+#define RTEXT_FILTER_CFM_STATUS	(1 << 6)
 
 /* End of information exported to user level */
 
-- 
2.30.2

