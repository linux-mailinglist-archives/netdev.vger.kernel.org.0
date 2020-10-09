Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7FC288BA3
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 16:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389138AbgJIOjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 10:39:04 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:51496 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388986AbgJIOiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 10:38:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602254290; x=1633790290;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YycD8ZBSyPWJLKElEGFN1tavp1p6Wu1zunUhEzVu9bY=;
  b=vdoUQLGoAvZ0zzJ+3rOUQbvmQFAhfJylNURthxBUQX6PZZzLC9TPRUal
   IPMl20UQqHqNiYy69NOZ51QQaFKm2RevQw1NOB0QvrB2Zdo48532bAzVO
   T/kitXUup/kRQBrHaM6QI05mAIxQ08Lj3uFoP65feVNYZDufEABSXqsbC
   uiVyovykbD0ByzFTiA1xo2OW4FMfhPxGpdTg8SX+YoB9hAHEvCT1SFc+m
   tsjqt7wb39vHuSr+UdCU41LSGTvmrWEJ2J3TeioiJjXjN6kdRxGxOtjJ3
   AgNHXcl/EiQHoN3D2bDPlifz3QmFe4ipq6YBL32GHuJT9eeqI2ZcOWYgO
   g==;
IronPort-SDR: TSC2Ng4p3yt9AoPVq9pHx+cyiOW4vVct6Uf7biYyEH7lDFiO/r1BTQDnTmeK+zeZhBb87FG94t
 btG3/eQG89NWXV582LjnRYKUo8npDt8AFk9LdqOYEhn1zYog5exjmpncqnl4mVeY56pOhwrXb4
 eyrFhGKW2FZFAFzseCDqtD18ElDHY12OIoRBl6TdFgB5yjn5ldCcG7cqXKM8c5d6UQKai3EzAp
 7idVRYs5Rll3VycRymEJfa8qJ6TpMJBtjaecsVf5JOPGNbE+dkb4oHHSxxve57vAyHYQ6YPEdV
 W6g=
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="92058382"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Oct 2020 07:38:09 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 9 Oct 2020 07:37:34 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 9 Oct 2020 07:38:05 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 07/10] bridge: cfm: Netlink SET configuration Interface.
Date:   Fri, 9 Oct 2020 14:35:27 +0000
Message-ID: <20201009143530.2438738-8-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the implementation of CFM netlink configuration
set information interface.

Add new nested netlink attributes. These attributes are used by the
user space to create/delete/configure CFM instances.

SETLINK:
    IFLA_BRIDGE_CFM:
        Indicate that the following attributes are CFM.

    IFLA_BRIDGE_CFM_MEP_CREATE:
        This indicate that a MEP instance must be created.
    IFLA_BRIDGE_CFM_MEP_DELETE:
        This indicate that a MEP instance must be deleted.
    IFLA_BRIDGE_CFM_MEP_CONFIG:
        This indicate that a MEP instance must be configured.
    IFLA_BRIDGE_CFM_CC_CONFIG:
        This indicate that a MEP instance Continuity Check (CC)
        functionality must be configured.
    IFLA_BRIDGE_CFM_CC_PEER_MEP_ADD:
        This indicate that a CC Peer MEP must be added.
    IFLA_BRIDGE_CFM_CC_PEER_MEP_REMOVE:
        This indicate that a CC Peer MEP must be removed.
    IFLA_BRIDGE_CFM_CC_CCM_TX:
        This indicate that the CC transmitted CCM PDU must be configured.
    IFLA_BRIDGE_CFM_CC_RDI:
        This indicate that the CC transmitted CCM PDU RDI must be
        configured.

CFM nested attribute has the following attributes in next level.

SETLINK RTEXT_FILTER_CFM_CONFIG:
    IFLA_BRIDGE_CFM_MEP_CREATE_INSTANCE:
        The created MEP instance number.
        The type is u32.
    IFLA_BRIDGE_CFM_MEP_CREATE_DOMAIN:
        The created MEP domain.
        The type is u32 (br_cfm_domain).
        It must be BR_CFM_PORT.
        This means that CFM frames are transmitted and received
        directly on the port - untagged. Not in a VLAN.
    IFLA_BRIDGE_CFM_MEP_CREATE_DIRECTION:
        The created MEP direction.
        The type is u32 (br_cfm_mep_direction).
        It must be BR_CFM_MEP_DIRECTION_DOWN.
        This means that CFM frames are transmitted and received on
        the port. Not in the bridge.
    IFLA_BRIDGE_CFM_MEP_CREATE_IFINDEX:
        The created MEP residence port ifindex.
        The type is u32 (ifindex).

    IFLA_BRIDGE_CFM_MEP_DELETE_INSTANCE:
        The deleted MEP instance number.
        The type is u32.

    IFLA_BRIDGE_CFM_MEP_CONFIG_INSTANCE:
        The configured MEP instance number.
        The type is u32.
    IFLA_BRIDGE_CFM_MEP_CONFIG_UNICAST_MAC:
        The configured MEP unicast MAC address.
        The type is 6*u8 (array).
        This is used as SMAC in all transmitted CFM frames.
    IFLA_BRIDGE_CFM_MEP_CONFIG_MDLEVEL:
        The configured MEP unicast MD level.
        The type is u32.
        It must be in the range 1-7.
        No CFM frames are passing through this MEP on lower levels.
    IFLA_BRIDGE_CFM_MEP_CONFIG_MEPID:
        The configured MEP ID.
        The type is u32.
        It must be in the range 0-0x1FFF.
        This MEP ID is inserted in any transmitted CCM frame.

    IFLA_BRIDGE_CFM_CC_CONFIG_INSTANCE:
        The configured MEP instance number.
        The type is u32.
    IFLA_BRIDGE_CFM_CC_CONFIG_ENABLE:
        The Continuity Check (CC) functionality is enabled or disabled.
        The type is u32 (bool).
    IFLA_BRIDGE_CFM_CC_CONFIG_EXP_INTERVAL:
        The CC expected receive interval of CCM frames.
        The type is u32 (br_cfm_ccm_interval).
        This is also the transmission interval of CCM frames when enabled.
    IFLA_BRIDGE_CFM_CC_CONFIG_EXP_MAID:
        The CC expected receive MAID in CCM frames.
        The type is CFM_MAID_LENGTH*u8.
        This is MAID is also inserted in transmitted CCM frames.

    IFLA_BRIDGE_CFM_CC_PEER_MEP_INSTANCE:
        The configured MEP instance number.
        The type is u32.
    IFLA_BRIDGE_CFM_CC_PEER_MEPID:
        The CC Peer MEP ID added.
        The type is u32.
        When a Peer MEP ID is added and CC is enabled it is expected to
        receive CCM frames from that Peer MEP.

    IFLA_BRIDGE_CFM_CC_RDI_INSTANCE:
        The configured MEP instance number.
        The type is u32.
    IFLA_BRIDGE_CFM_CC_RDI_RDI:
        The RDI that is inserted in transmitted CCM PDU.
        The type is u32 (bool).

    IFLA_BRIDGE_CFM_CC_CCM_TX_INSTANCE:
        The configured MEP instance number.
        The type is u32.
    IFLA_BRIDGE_CFM_CC_CCM_TX_DMAC:
        The transmitted CCM frame destination MAC address.
        The type is 6*u8 (array).
        This is used as DMAC in all transmitted CFM frames.
    IFLA_BRIDGE_CFM_CC_CCM_TX_SEQ_NO_UPDATE:
        The transmitted CCM frame update (increment) of sequence
        number is enabled or disabled.
        The type is u32 (bool).
    IFLA_BRIDGE_CFM_CC_CCM_TX_PERIOD:
        The period of time where CCM frame are transmitted.
        The type is u32.
        The time is given in seconds. SETLINK IFLA_BRIDGE_CFM_CC_CCM_TX
        must be done before timeout to keep transmission alive.
        When period is zero any ongoing CCM frame transmission
        will be stopped.
    IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV:
        The transmitted CCM frame update with Interface Status TLV
        is enabled or disabled.
        The type is u32 (bool).
    IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV_VALUE:
        The transmitted Interface Status TLV value field.
        The type is u8.
    IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV:
        The transmitted CCM frame update with Port Status TLV is enabled
        or disabled.
        The type is u32 (bool).
    IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV_VALUE:
        The transmitted Port Status TLV value field.
        The type is u8.

Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
---
 include/uapi/linux/if_bridge.h |  90 +++++++
 include/uapi/linux/rtnetlink.h |   1 +
 net/bridge/Makefile            |   2 +-
 net/bridge/br_cfm.c            |   5 +
 net/bridge/br_cfm_netlink.c    | 458 +++++++++++++++++++++++++++++++++
 net/bridge/br_netlink.c        |   5 +
 net/bridge/br_private.h        |  17 +-
 7 files changed, 576 insertions(+), 2 deletions(-)
 create mode 100644 net/bridge/br_cfm_netlink.c

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 4c687686aa8f..94cc9444d749 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -121,6 +121,7 @@ enum {
 	IFLA_BRIDGE_VLAN_INFO,
 	IFLA_BRIDGE_VLAN_TUNNEL_INFO,
 	IFLA_BRIDGE_MRP,
+	IFLA_BRIDGE_CFM,
 	__IFLA_BRIDGE_MAX,
 };
 #define IFLA_BRIDGE_MAX (__IFLA_BRIDGE_MAX - 1)
@@ -328,6 +329,95 @@ struct br_mrp_start_in_test {
 	__u16 in_id;
 };
 
+enum {
+	IFLA_BRIDGE_CFM_UNSPEC,
+	IFLA_BRIDGE_CFM_MEP_CREATE,
+	IFLA_BRIDGE_CFM_MEP_DELETE,
+	IFLA_BRIDGE_CFM_MEP_CONFIG,
+	IFLA_BRIDGE_CFM_CC_CONFIG,
+	IFLA_BRIDGE_CFM_CC_PEER_MEP_ADD,
+	IFLA_BRIDGE_CFM_CC_PEER_MEP_REMOVE,
+	IFLA_BRIDGE_CFM_CC_RDI,
+	IFLA_BRIDGE_CFM_CC_CCM_TX,
+	__IFLA_BRIDGE_CFM_MAX,
+};
+
+#define IFLA_BRIDGE_CFM_MAX (__IFLA_BRIDGE_CFM_MAX - 1)
+
+enum {
+	IFLA_BRIDGE_CFM_MEP_CREATE_UNSPEC,
+	IFLA_BRIDGE_CFM_MEP_CREATE_INSTANCE,
+	IFLA_BRIDGE_CFM_MEP_CREATE_DOMAIN,
+	IFLA_BRIDGE_CFM_MEP_CREATE_DIRECTION,
+	IFLA_BRIDGE_CFM_MEP_CREATE_IFINDEX,
+	__IFLA_BRIDGE_CFM_MEP_CREATE_MAX,
+};
+
+#define IFLA_BRIDGE_CFM_MEP_CREATE_MAX (__IFLA_BRIDGE_CFM_MEP_CREATE_MAX - 1)
+
+enum {
+	IFLA_BRIDGE_CFM_MEP_DELETE_UNSPEC,
+	IFLA_BRIDGE_CFM_MEP_DELETE_INSTANCE,
+	__IFLA_BRIDGE_CFM_MEP_DELETE_MAX,
+};
+
+#define IFLA_BRIDGE_CFM_MEP_DELETE_MAX (__IFLA_BRIDGE_CFM_MEP_DELETE_MAX - 1)
+
+enum {
+	IFLA_BRIDGE_CFM_MEP_CONFIG_UNSPEC,
+	IFLA_BRIDGE_CFM_MEP_CONFIG_INSTANCE,
+	IFLA_BRIDGE_CFM_MEP_CONFIG_UNICAST_MAC,
+	IFLA_BRIDGE_CFM_MEP_CONFIG_MDLEVEL,
+	IFLA_BRIDGE_CFM_MEP_CONFIG_MEPID,
+	__IFLA_BRIDGE_CFM_MEP_CONFIG_MAX,
+};
+
+#define IFLA_BRIDGE_CFM_MEP_CONFIG_MAX (__IFLA_BRIDGE_CFM_MEP_CONFIG_MAX - 1)
+
+enum {
+	IFLA_BRIDGE_CFM_CC_CONFIG_UNSPEC,
+	IFLA_BRIDGE_CFM_CC_CONFIG_INSTANCE,
+	IFLA_BRIDGE_CFM_CC_CONFIG_ENABLE,
+	IFLA_BRIDGE_CFM_CC_CONFIG_EXP_INTERVAL,
+	IFLA_BRIDGE_CFM_CC_CONFIG_EXP_MAID,
+	__IFLA_BRIDGE_CFM_CC_CONFIG_MAX,
+};
+
+#define IFLA_BRIDGE_CFM_CC_CONFIG_MAX (__IFLA_BRIDGE_CFM_CC_CONFIG_MAX - 1)
+
+enum {
+	IFLA_BRIDGE_CFM_CC_PEER_MEP_UNSPEC,
+	IFLA_BRIDGE_CFM_CC_PEER_MEP_INSTANCE,
+	IFLA_BRIDGE_CFM_CC_PEER_MEPID,
+	__IFLA_BRIDGE_CFM_CC_PEER_MEP_MAX,
+};
+
+#define IFLA_BRIDGE_CFM_CC_PEER_MEP_MAX (__IFLA_BRIDGE_CFM_CC_PEER_MEP_MAX - 1)
+
+enum {
+	IFLA_BRIDGE_CFM_CC_RDI_UNSPEC,
+	IFLA_BRIDGE_CFM_CC_RDI_INSTANCE,
+	IFLA_BRIDGE_CFM_CC_RDI_RDI,
+	__IFLA_BRIDGE_CFM_CC_RDI_MAX,
+};
+
+#define IFLA_BRIDGE_CFM_CC_RDI_MAX (__IFLA_BRIDGE_CFM_CC_RDI_MAX - 1)
+
+enum {
+	IFLA_BRIDGE_CFM_CC_CCM_TX_UNSPEC,
+	IFLA_BRIDGE_CFM_CC_CCM_TX_INSTANCE,
+	IFLA_BRIDGE_CFM_CC_CCM_TX_DMAC,
+	IFLA_BRIDGE_CFM_CC_CCM_TX_SEQ_NO_UPDATE,
+	IFLA_BRIDGE_CFM_CC_CCM_TX_PERIOD,
+	IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV,
+	IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV_VALUE,
+	IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV,
+	IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV_VALUE,
+	__IFLA_BRIDGE_CFM_CC_CCM_TX_MAX,
+};
+
+#define IFLA_BRIDGE_CFM_CC_CCM_TX_MAX (__IFLA_BRIDGE_CFM_CC_CCM_TX_MAX - 1)
+
 struct bridge_stp_xstats {
 	__u64 transition_blk;
 	__u64 transition_fwd;
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 9b814c92de12..ffc9ca1f2bdb 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -779,6 +779,7 @@ enum {
 #define RTEXT_FILTER_BRVLAN_COMPRESSED	(1 << 2)
 #define	RTEXT_FILTER_SKIP_STATS	(1 << 3)
 #define RTEXT_FILTER_MRP	(1 << 4)
+#define RTEXT_FILTER_CFM_CONFIG	(1 << 5)
 
 /* End of information exported to user level */
 
diff --git a/net/bridge/Makefile b/net/bridge/Makefile
index ddc0a9192348..4702702a74d3 100644
--- a/net/bridge/Makefile
+++ b/net/bridge/Makefile
@@ -28,4 +28,4 @@ obj-$(CONFIG_NETFILTER) += netfilter/
 
 bridge-$(CONFIG_BRIDGE_MRP)	+= br_mrp_switchdev.o br_mrp.o br_mrp_netlink.o
 
-bridge-$(CONFIG_BRIDGE_CFM)	+= br_cfm.o
+bridge-$(CONFIG_BRIDGE_CFM)	+= br_cfm.o br_cfm_netlink.o
diff --git a/net/bridge/br_cfm.c b/net/bridge/br_cfm.c
index d928de5de155..c8de462c2fd4 100644
--- a/net/bridge/br_cfm.c
+++ b/net/bridge/br_cfm.c
@@ -816,6 +816,11 @@ int br_cfm_cc_ccm_tx(struct net_bridge *br, const u32 instance,
 	return 0;
 }
 
+bool br_cfm_created(struct net_bridge *br)
+{
+	return !hlist_empty(&br->mep_list);
+}
+
 /* Deletes the CFM instances on a specific bridge port
  */
 void br_cfm_port_del(struct net_bridge *br, struct net_bridge_port *port)
diff --git a/net/bridge/br_cfm_netlink.c b/net/bridge/br_cfm_netlink.c
new file mode 100644
index 000000000000..0b32873a1241
--- /dev/null
+++ b/net/bridge/br_cfm_netlink.c
@@ -0,0 +1,458 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <net/genetlink.h>
+
+#include "br_private.h"
+#include "br_private_cfm.h"
+
+static inline struct mac_addr nla_get_mac(const struct nlattr *nla)
+{
+	struct mac_addr mac;
+
+	nla_memcpy(&mac.addr, nla, sizeof(mac.addr));
+
+	return mac;
+}
+
+static inline struct br_cfm_maid nla_get_maid(const struct nlattr *nla)
+{
+	struct br_cfm_maid maid;
+
+	nla_memcpy(&maid.data, nla, sizeof(maid.data));
+
+	return maid;
+}
+
+static const struct nla_policy
+br_cfm_policy[IFLA_BRIDGE_CFM_MAX + 1] = {
+	[IFLA_BRIDGE_CFM_UNSPEC]		= { .type = NLA_REJECT },
+	[IFLA_BRIDGE_CFM_MEP_CREATE]		= { .type = NLA_NESTED },
+	[IFLA_BRIDGE_CFM_MEP_DELETE]		= { .type = NLA_NESTED },
+	[IFLA_BRIDGE_CFM_MEP_CONFIG]		= { .type = NLA_NESTED },
+	[IFLA_BRIDGE_CFM_CC_CONFIG]		= { .type = NLA_NESTED },
+	[IFLA_BRIDGE_CFM_CC_PEER_MEP_ADD]	= { .type = NLA_NESTED },
+	[IFLA_BRIDGE_CFM_CC_PEER_MEP_REMOVE]	= { .type = NLA_NESTED },
+	[IFLA_BRIDGE_CFM_CC_RDI]		= { .type = NLA_NESTED },
+	[IFLA_BRIDGE_CFM_CC_CCM_TX]		= { .type = NLA_NESTED },
+};
+
+static const struct nla_policy
+br_cfm_mep_create_policy[IFLA_BRIDGE_CFM_MEP_CREATE_MAX + 1] = {
+	[IFLA_BRIDGE_CFM_MEP_CREATE_UNSPEC]	= { .type = NLA_REJECT },
+	[IFLA_BRIDGE_CFM_MEP_CREATE_INSTANCE]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_CFM_MEP_CREATE_DOMAIN]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_CFM_MEP_CREATE_DIRECTION]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_CFM_MEP_CREATE_IFINDEX]	= { .type = NLA_U32 },
+};
+
+static const struct nla_policy
+br_cfm_mep_delete_policy[IFLA_BRIDGE_CFM_MEP_DELETE_MAX + 1] = {
+	[IFLA_BRIDGE_CFM_MEP_DELETE_UNSPEC]	= { .type = NLA_REJECT },
+	[IFLA_BRIDGE_CFM_MEP_DELETE_INSTANCE]	= { .type = NLA_U32 },
+};
+
+static const struct nla_policy
+br_cfm_mep_config_policy[IFLA_BRIDGE_CFM_MEP_CONFIG_MAX + 1] = {
+	[IFLA_BRIDGE_CFM_MEP_CONFIG_UNSPEC]		= { .type = NLA_REJECT },
+	[IFLA_BRIDGE_CFM_MEP_CONFIG_INSTANCE]		= { .type = NLA_U32 },
+	[IFLA_BRIDGE_CFM_MEP_CONFIG_UNICAST_MAC]	= NLA_POLICY_ETH_ADDR,
+	[IFLA_BRIDGE_CFM_MEP_CONFIG_MDLEVEL]		= { .type = NLA_U32 },
+	[IFLA_BRIDGE_CFM_MEP_CONFIG_MEPID]		= { .type = NLA_U32 },
+};
+
+static const struct nla_policy
+br_cfm_cc_config_policy[IFLA_BRIDGE_CFM_CC_CONFIG_MAX + 1] = {
+	[IFLA_BRIDGE_CFM_CC_CONFIG_UNSPEC]		= { .type = NLA_REJECT },
+	[IFLA_BRIDGE_CFM_CC_CONFIG_INSTANCE]		= { .type = NLA_U32 },
+	[IFLA_BRIDGE_CFM_CC_CONFIG_ENABLE]		= { .type = NLA_U32 },
+	[IFLA_BRIDGE_CFM_CC_CONFIG_EXP_INTERVAL]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_CFM_CC_CONFIG_EXP_MAID]	= {
+	.type = NLA_BINARY, .len = CFM_MAID_LENGTH },
+};
+
+static const struct nla_policy
+br_cfm_cc_peer_mep_policy[IFLA_BRIDGE_CFM_CC_PEER_MEP_MAX + 1] = {
+	[IFLA_BRIDGE_CFM_CC_PEER_MEP_UNSPEC]	= { .type = NLA_REJECT },
+	[IFLA_BRIDGE_CFM_CC_PEER_MEP_INSTANCE]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_CFM_CC_PEER_MEPID]		= { .type = NLA_U32 },
+};
+
+static const struct nla_policy
+br_cfm_cc_rdi_policy[IFLA_BRIDGE_CFM_CC_RDI_MAX + 1] = {
+	[IFLA_BRIDGE_CFM_CC_RDI_UNSPEC]		= { .type = NLA_REJECT },
+	[IFLA_BRIDGE_CFM_CC_RDI_INSTANCE]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_CFM_CC_RDI_RDI]		= { .type = NLA_U32 },
+};
+
+static const struct nla_policy
+br_cfm_cc_ccm_tx_policy[IFLA_BRIDGE_CFM_CC_CCM_TX_MAX + 1] = {
+	[IFLA_BRIDGE_CFM_CC_CCM_TX_UNSPEC]		= { .type = NLA_REJECT },
+	[IFLA_BRIDGE_CFM_CC_CCM_TX_INSTANCE]		= { .type = NLA_U32 },
+	[IFLA_BRIDGE_CFM_CC_CCM_TX_DMAC]		= NLA_POLICY_ETH_ADDR,
+	[IFLA_BRIDGE_CFM_CC_CCM_TX_SEQ_NO_UPDATE]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_CFM_CC_CCM_TX_PERIOD]		= { .type = NLA_U32 },
+	[IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV]		= { .type = NLA_U32 },
+	[IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV_VALUE]	= { .type = NLA_U8 },
+	[IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV]		= { .type = NLA_U32 },
+	[IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV_VALUE]	= { .type = NLA_U8 },
+};
+
+static int br_mep_create_parse(struct net_bridge *br, struct nlattr *attr,
+			       struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_CFM_MEP_CREATE_MAX + 1];
+	struct br_cfm_mep_create create;
+	u32 instance;
+	int err;
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_CFM_MEP_CREATE_MAX, attr,
+			       br_cfm_mep_create_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[IFLA_BRIDGE_CFM_MEP_CREATE_INSTANCE]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing INSTANCE attribute");
+		return -EINVAL;
+	}
+	if (!tb[IFLA_BRIDGE_CFM_MEP_CREATE_DOMAIN]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing DOMAIN attribute");
+		return -EINVAL;
+	}
+	if (!tb[IFLA_BRIDGE_CFM_MEP_CREATE_DIRECTION]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing DIRECTION attribute");
+		return -EINVAL;
+	}
+	if (!tb[IFLA_BRIDGE_CFM_MEP_CREATE_IFINDEX]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing IFINDEX attribute");
+		return -EINVAL;
+	}
+
+	memset(&create, 0, sizeof(create));
+
+	instance =  nla_get_u32(tb[IFLA_BRIDGE_CFM_MEP_CREATE_INSTANCE]);
+	create.domain = nla_get_u32(tb[IFLA_BRIDGE_CFM_MEP_CREATE_DOMAIN]);
+	create.direction = nla_get_u32(tb[IFLA_BRIDGE_CFM_MEP_CREATE_DIRECTION]);
+	create.ifindex = nla_get_u32(tb[IFLA_BRIDGE_CFM_MEP_CREATE_IFINDEX]);
+
+	return br_cfm_mep_create(br, instance, &create, extack);
+}
+
+static int br_mep_delete_parse(struct net_bridge *br, struct nlattr *attr,
+			       struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_CFM_MEP_DELETE_MAX + 1];
+	u32 instance;
+	int err;
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_CFM_MEP_DELETE_MAX, attr,
+			       br_cfm_mep_delete_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[IFLA_BRIDGE_CFM_MEP_DELETE_INSTANCE]) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Missing INSTANCE attribute");
+		return -EINVAL;
+	}
+
+	instance =  nla_get_u32(tb[IFLA_BRIDGE_CFM_MEP_DELETE_INSTANCE]);
+
+	return br_cfm_mep_delete(br, instance, extack);
+}
+
+static int br_mep_config_parse(struct net_bridge *br, struct nlattr *attr,
+			       struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_CFM_MEP_CONFIG_MAX + 1];
+	struct br_cfm_mep_config config;
+	u32 instance;
+	int err;
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_CFM_MEP_CONFIG_MAX, attr,
+			       br_cfm_mep_config_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[IFLA_BRIDGE_CFM_MEP_CONFIG_INSTANCE]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing INSTANCE attribute");
+		return -EINVAL;
+	}
+	if (!tb[IFLA_BRIDGE_CFM_MEP_CONFIG_UNICAST_MAC]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing UNICAST_MAC attribute");
+		return -EINVAL;
+	}
+	if (!tb[IFLA_BRIDGE_CFM_MEP_CONFIG_MDLEVEL]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing MDLEVEL attribute");
+		return -EINVAL;
+	}
+	if (!tb[IFLA_BRIDGE_CFM_MEP_CONFIG_MEPID]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing MEPID attribute");
+		return -EINVAL;
+	}
+
+	memset(&config, 0, sizeof(config));
+
+	instance =  nla_get_u32(tb[IFLA_BRIDGE_CFM_MEP_CONFIG_INSTANCE]);
+	config.unicast_mac = nla_get_mac(tb[IFLA_BRIDGE_CFM_MEP_CONFIG_UNICAST_MAC]);
+	config.mdlevel = nla_get_u32(tb[IFLA_BRIDGE_CFM_MEP_CONFIG_MDLEVEL]);
+	config.mepid = nla_get_u32(tb[IFLA_BRIDGE_CFM_MEP_CONFIG_MEPID]);
+
+	return br_cfm_mep_config_set(br, instance, &config, extack);
+}
+
+static int br_cc_config_parse(struct net_bridge *br, struct nlattr *attr,
+			      struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_CFM_CC_CONFIG_MAX + 1];
+	struct br_cfm_cc_config config;
+	u32 instance;
+	int err;
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_CFM_CC_CONFIG_MAX, attr,
+			       br_cfm_cc_config_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[IFLA_BRIDGE_CFM_CC_CONFIG_INSTANCE]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing INSTANCE attribute");
+		return -EINVAL;
+	}
+	if (!tb[IFLA_BRIDGE_CFM_CC_CONFIG_ENABLE]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing ENABLE attribute");
+		return -EINVAL;
+	}
+	if (!tb[IFLA_BRIDGE_CFM_CC_CONFIG_EXP_INTERVAL]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing INTERVAL attribute");
+		return -EINVAL;
+	}
+	if (!tb[IFLA_BRIDGE_CFM_CC_CONFIG_EXP_MAID]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing MAID attribute");
+		return -EINVAL;
+	}
+
+	memset(&config, 0, sizeof(config));
+
+	instance =  nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_CONFIG_INSTANCE]);
+	config.enable = nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_CONFIG_ENABLE]);
+	config.exp_interval = nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_CONFIG_EXP_INTERVAL]);
+	config.exp_maid = nla_get_maid(tb[IFLA_BRIDGE_CFM_CC_CONFIG_EXP_MAID]);
+
+	return br_cfm_cc_config_set(br, instance, &config, extack);
+}
+
+static int br_cc_peer_mep_add_parse(struct net_bridge *br, struct nlattr *attr,
+				    struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_CFM_CC_PEER_MEP_MAX + 1];
+	u32 instance, peer_mep_id;
+	int err;
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_CFM_CC_PEER_MEP_MAX, attr,
+			       br_cfm_cc_peer_mep_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[IFLA_BRIDGE_CFM_CC_PEER_MEP_INSTANCE]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing INSTANCE attribute");
+		return -EINVAL;
+	}
+	if (!tb[IFLA_BRIDGE_CFM_CC_PEER_MEPID]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing PEER_MEP_ID attribute");
+		return -EINVAL;
+	}
+
+	instance =  nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_PEER_MEP_INSTANCE]);
+	peer_mep_id =  nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_PEER_MEPID]);
+
+	return br_cfm_cc_peer_mep_add(br, instance, peer_mep_id, extack);
+}
+
+static int br_cc_peer_mep_remove_parse(struct net_bridge *br, struct nlattr *attr,
+				       struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_CFM_CC_PEER_MEP_MAX + 1];
+	u32 instance, peer_mep_id;
+	int err;
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_CFM_CC_PEER_MEP_MAX, attr,
+			       br_cfm_cc_peer_mep_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[IFLA_BRIDGE_CFM_CC_PEER_MEP_INSTANCE]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing INSTANCE attribute");
+		return -EINVAL;
+	}
+	if (!tb[IFLA_BRIDGE_CFM_CC_PEER_MEPID]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing PEER_MEP_ID attribute");
+		return -EINVAL;
+	}
+
+	instance =  nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_PEER_MEP_INSTANCE]);
+	peer_mep_id =  nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_PEER_MEPID]);
+
+	return br_cfm_cc_peer_mep_remove(br, instance, peer_mep_id, extack);
+}
+
+static int br_cc_rdi_parse(struct net_bridge *br, struct nlattr *attr,
+			   struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_CFM_CC_RDI_MAX + 1];
+	u32 instance, rdi;
+	int err;
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_CFM_CC_RDI_MAX, attr,
+			       br_cfm_cc_rdi_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[IFLA_BRIDGE_CFM_CC_RDI_INSTANCE]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing INSTANCE attribute");
+		return -EINVAL;
+	}
+	if (!tb[IFLA_BRIDGE_CFM_CC_RDI_RDI]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing RDI attribute");
+		return -EINVAL;
+	}
+
+	instance =  nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_RDI_INSTANCE]);
+	rdi =  nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_RDI_RDI]);
+
+	return br_cfm_cc_rdi_set(br, instance, rdi, extack);
+}
+
+static int br_cc_ccm_tx_parse(struct net_bridge *br, struct nlattr *attr,
+			      struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_CFM_CC_CCM_TX_MAX + 1];
+	struct br_cfm_cc_ccm_tx_info tx_info;
+	u32 instance;
+	int err;
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_CFM_CC_CCM_TX_MAX, attr,
+			       br_cfm_cc_ccm_tx_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[IFLA_BRIDGE_CFM_CC_CCM_TX_INSTANCE]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing INSTANCE attribute");
+		return -EINVAL;
+	}
+	if (!tb[IFLA_BRIDGE_CFM_CC_CCM_TX_DMAC]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing DMAC attribute");
+		return -EINVAL;
+	}
+	if (!tb[IFLA_BRIDGE_CFM_CC_CCM_TX_SEQ_NO_UPDATE]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing SEQ_NO_UPDATE attribute");
+		return -EINVAL;
+	}
+	if (!tb[IFLA_BRIDGE_CFM_CC_CCM_TX_PERIOD]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing PERIOD attribute");
+		return -EINVAL;
+	}
+	if (!tb[IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing IF_TLV attribute");
+		return -EINVAL;
+	}
+	if (!tb[IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV_VALUE]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing IF_TLV_VALUE attribute");
+		return -EINVAL;
+	}
+	if (!tb[IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing PORT_TLV attribute");
+		return -EINVAL;
+	}
+	if (!tb[IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV_VALUE]) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing PORT_TLV_VALUE attribute");
+		return -EINVAL;
+	}
+
+	memset(&tx_info, 0, sizeof(tx_info));
+
+	instance = nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_RDI_INSTANCE]);
+	tx_info.dmac = nla_get_mac(tb[IFLA_BRIDGE_CFM_CC_CCM_TX_DMAC]);
+	tx_info.seq_no_update = nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_CCM_TX_SEQ_NO_UPDATE]);
+	tx_info.period = nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_CCM_TX_PERIOD]);
+	tx_info.if_tlv = nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV]);
+	tx_info.if_tlv_value = nla_get_u8(tb[IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV_VALUE]);
+	tx_info.port_tlv = nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV]);
+	tx_info.port_tlv_value = nla_get_u8(tb[IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV_VALUE]);
+
+	return br_cfm_cc_ccm_tx(br, instance, &tx_info, extack);
+}
+
+int br_cfm_parse(struct net_bridge *br, struct net_bridge_port *p,
+		 struct nlattr *attr, int cmd, struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_CFM_MAX + 1];
+	int err;
+
+	/* When this function is called for a port then the br pointer is
+	 * invalid, therefor set the br to point correctly
+	 */
+	if (p)
+		br = p->br;
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_CFM_MAX, attr,
+			       br_cfm_policy, extack);
+	if (err)
+		return err;
+
+	if (tb[IFLA_BRIDGE_CFM_MEP_CREATE]) {
+		err = br_mep_create_parse(br, tb[IFLA_BRIDGE_CFM_MEP_CREATE],
+					  extack);
+		if (err)
+			return err;
+	}
+
+	if (tb[IFLA_BRIDGE_CFM_MEP_DELETE]) {
+		err = br_mep_delete_parse(br, tb[IFLA_BRIDGE_CFM_MEP_DELETE],
+					  extack);
+		if (err)
+			return err;
+	}
+
+	if (tb[IFLA_BRIDGE_CFM_MEP_CONFIG]) {
+		err = br_mep_config_parse(br, tb[IFLA_BRIDGE_CFM_MEP_CONFIG],
+					  extack);
+		if (err)
+			return err;
+	}
+
+	if (tb[IFLA_BRIDGE_CFM_CC_CONFIG]) {
+		err = br_cc_config_parse(br, tb[IFLA_BRIDGE_CFM_CC_CONFIG],
+					 extack);
+		if (err)
+			return err;
+	}
+
+	if (tb[IFLA_BRIDGE_CFM_CC_PEER_MEP_ADD]) {
+		err = br_cc_peer_mep_add_parse(br, tb[IFLA_BRIDGE_CFM_CC_PEER_MEP_ADD],
+					       extack);
+		if (err)
+			return err;
+	}
+
+	if (tb[IFLA_BRIDGE_CFM_CC_PEER_MEP_REMOVE]) {
+		err = br_cc_peer_mep_remove_parse(br, tb[IFLA_BRIDGE_CFM_CC_PEER_MEP_REMOVE],
+						  extack);
+		if (err)
+			return err;
+	}
+
+	if (tb[IFLA_BRIDGE_CFM_CC_RDI]) {
+		err = br_cc_rdi_parse(br, tb[IFLA_BRIDGE_CFM_CC_RDI],
+				      extack);
+		if (err)
+			return err;
+	}
+
+	if (tb[IFLA_BRIDGE_CFM_CC_CCM_TX]) {
+		err = br_cc_ccm_tx_parse(br, tb[IFLA_BRIDGE_CFM_CC_CCM_TX],
+					 extack);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 92d64abffa87..431ee2b06dc1 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -700,6 +700,11 @@ static int br_afspec(struct net_bridge *br,
 			if (err)
 				return err;
 			break;
+		case IFLA_BRIDGE_CFM:
+			err = br_cfm_parse(br, p, attr, cmd, extack);
+			if (err)
+				return err;
+			break;
 		}
 	}
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index ece67f962220..397d098dd694 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1460,10 +1460,25 @@ static inline int br_mrp_fill_info(struct sk_buff *skb, struct net_bridge *br)
 
 #endif
 
-/* br_mrp.c */
+/* br_cfm.c */
 #if IS_ENABLED(CONFIG_BRIDGE_CFM)
+int br_cfm_parse(struct net_bridge *br, struct net_bridge_port *p,
+		 struct nlattr *attr, int cmd, struct netlink_ext_ack *extack);
+bool br_cfm_created(struct net_bridge *br);
 void br_cfm_port_del(struct net_bridge *br, struct net_bridge_port *p);
 #else
+static inline int br_cfm_parse(struct net_bridge *br, struct net_bridge_port *p,
+			       struct nlattr *attr, int cmd,
+			       struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline bool br_cfm_created(struct net_bridge *br)
+{
+	return false;
+}
+
 static inline void br_cfm_port_del(struct net_bridge *br,
 				   struct net_bridge_port *p)
 {
-- 
2.28.0

