Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DF8288B9E
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 16:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389111AbgJIOiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 10:38:46 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:51509 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389003AbgJIOiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 10:38:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602254291; x=1633790291;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/ZPf2x0qpdlw2BPdZESgqPo6cWx/BqLRwLFrBP0ncxI=;
  b=Eqi2aCjaCtoD5KQQgdp0Fcc4d75Pojpr5zR7uAKLYYTEQIjvkC/veJWL
   SU0EdAEDddAMTQ8hcYSICFBsNgnz2gqlr0IJVl1Ie845N79GuF8tCrFvB
   tDZy14aBB5ryH31XJZZ5ooTiJ6nfZ/GnQVXU04hVl+s/IZq9RpHRXsN2G
   q0+8IVqcELrIRiGXT7a+Cp4iKO49IFM2jURRlobMPB8YrOnBRKkcNQX4D
   vkF0X+t/c7PMimzHxh0G/k996G8lYfV/rzdf09n4KAYE+8IkM/pRyXYHS
   5E21VxBQ0n1c+bUSgXFSsOqkrN6R2l2+glxxPM+31ypebGd3ynDrOAUCE
   w==;
IronPort-SDR: ox5dFEFw7AITGj2xD5BqGjGniDDp40g+/gB1nqWRiVNWtA4yBDR8/b0XRVkqjL/3Nv8Sgr9qAW
 j0p6aprjqkMnl9vE2tHvWo9j2+xYTD6I20n7/1me8jdcp+fvVanxW1ZgrfnAj+flN8ccNpHWE9
 udCREQh256OuVDk9EYsu/ISsm5B7lEp721zgIuEF3MUu5RppzakDv0xmLIk5TEh2yzhSTfwdUO
 uwrNb6S6UlAviAlIBh1e+0rL7nBsa5lq3XfZUGa/yPHKBTMEcwm1pA08ovv20IJuBORtNFdG2H
 1ks=
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="92058397"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Oct 2020 07:38:11 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 9 Oct 2020 07:37:36 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 9 Oct 2020 07:38:08 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 08/10] bridge: cfm: Netlink GET configuration Interface.
Date:   Fri, 9 Oct 2020 14:35:28 +0000
Message-ID: <20201009143530.2438738-9-henrik.bjoernlund@microchip.com>
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
get information interface.

Add new nested netlink attributes. These attributes are used by the
user space to get configuration information.

GETLINK:
    Request filter RTEXT_FILTER_CFM_CONFIG:
    Indicating that CFM configuration information must be delivered.

    IFLA_BRIDGE_CFM:
        Points to the CFM information.

    IFLA_BRIDGE_CFM_MEP_CREATE_INFO:
        This indicate that MEP instance create parameters are following.
    IFLA_BRIDGE_CFM_MEP_CONFIG_INFO:
        This indicate that MEP instance config parameters are following.
    IFLA_BRIDGE_CFM_CC_CONFIG_INFO:
        This indicate that MEP instance CC functionality
        parameters are following.
    IFLA_BRIDGE_CFM_CC_RDI_INFO:
        This indicate that CC transmitted CCM PDU RDI
        parameters are following.
    IFLA_BRIDGE_CFM_CC_CCM_TX_INFO:
        This indicate that CC transmitted CCM PDU parameters are
        following.
    IFLA_BRIDGE_CFM_CC_PEER_MEP_INFO:
        This indicate that the added peer MEP IDs are following.

CFM nested attribute has the following attributes in next level.

GETLINK RTEXT_FILTER_CFM_CONFIG:
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
 include/uapi/linux/if_bridge.h |   6 ++
 net/bridge/br_cfm_netlink.c    | 161 +++++++++++++++++++++++++++++++++
 net/bridge/br_netlink.c        |  29 +++++-
 net/bridge/br_private.h        |   6 ++
 4 files changed, 200 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 94cc9444d749..b8b4491922d9 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -339,6 +339,12 @@ enum {
 	IFLA_BRIDGE_CFM_CC_PEER_MEP_REMOVE,
 	IFLA_BRIDGE_CFM_CC_RDI,
 	IFLA_BRIDGE_CFM_CC_CCM_TX,
+	IFLA_BRIDGE_CFM_MEP_CREATE_INFO,
+	IFLA_BRIDGE_CFM_MEP_CONFIG_INFO,
+	IFLA_BRIDGE_CFM_CC_CONFIG_INFO,
+	IFLA_BRIDGE_CFM_CC_RDI_INFO,
+	IFLA_BRIDGE_CFM_CC_CCM_TX_INFO,
+	IFLA_BRIDGE_CFM_CC_PEER_MEP_INFO,
 	__IFLA_BRIDGE_CFM_MAX,
 };
 
diff --git a/net/bridge/br_cfm_netlink.c b/net/bridge/br_cfm_netlink.c
index 0b32873a1241..952b6372874e 100644
--- a/net/bridge/br_cfm_netlink.c
+++ b/net/bridge/br_cfm_netlink.c
@@ -456,3 +456,164 @@ int br_cfm_parse(struct net_bridge *br, struct net_bridge_port *p,
 
 	return 0;
 }
+
+int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge *br)
+{
+	struct nlattr *tb;
+	struct br_cfm_mep *mep;
+	struct br_cfm_peer_mep *peer_mep;
+
+	hlist_for_each_entry_rcu(mep, &br->mep_list, head) {
+		tb = nla_nest_start(skb, IFLA_BRIDGE_CFM_MEP_CREATE_INFO);
+		if (!tb)
+			goto nla_info_failure;
+
+		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_MEP_CREATE_INSTANCE,
+				mep->instance))
+			goto nla_put_failure;
+
+		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_MEP_CREATE_DOMAIN,
+				mep->create.domain))
+			goto nla_put_failure;
+
+		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_MEP_CREATE_DIRECTION,
+				mep->create.direction))
+			goto nla_put_failure;
+
+		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_MEP_CREATE_IFINDEX,
+				mep->create.ifindex))
+			goto nla_put_failure;
+
+		nla_nest_end(skb, tb);
+
+		tb = nla_nest_start(skb, IFLA_BRIDGE_CFM_MEP_CONFIG_INFO);
+
+		if (!tb)
+			goto nla_info_failure;
+
+		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_MEP_CONFIG_INSTANCE,
+				mep->instance))
+			goto nla_put_failure;
+
+		if (nla_put(skb, IFLA_BRIDGE_CFM_MEP_CONFIG_UNICAST_MAC,
+			    sizeof(mep->config.unicast_mac.addr),
+			    mep->config.unicast_mac.addr))
+			goto nla_put_failure;
+
+		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_MEP_CONFIG_MDLEVEL,
+				mep->config.mdlevel))
+			goto nla_put_failure;
+
+		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_MEP_CONFIG_MEPID,
+				mep->config.mepid))
+			goto nla_put_failure;
+
+		nla_nest_end(skb, tb);
+
+		tb = nla_nest_start(skb, IFLA_BRIDGE_CFM_CC_CONFIG_INFO);
+
+		if (!tb)
+			goto nla_info_failure;
+
+		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CONFIG_INSTANCE,
+				mep->instance))
+			goto nla_put_failure;
+
+		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CONFIG_ENABLE,
+				mep->cc_config.enable))
+			goto nla_put_failure;
+
+		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CONFIG_EXP_INTERVAL,
+				mep->cc_config.exp_interval))
+			goto nla_put_failure;
+
+		if (nla_put(skb, IFLA_BRIDGE_CFM_CC_CONFIG_EXP_MAID,
+			    sizeof(mep->cc_config.exp_maid.data),
+			    mep->cc_config.exp_maid.data))
+			goto nla_put_failure;
+
+		nla_nest_end(skb, tb);
+
+		tb = nla_nest_start(skb, IFLA_BRIDGE_CFM_CC_RDI_INFO);
+
+		if (!tb)
+			goto nla_info_failure;
+
+		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_RDI_INSTANCE,
+				mep->instance))
+			goto nla_put_failure;
+
+		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_RDI_RDI,
+				mep->rdi))
+			goto nla_put_failure;
+
+		nla_nest_end(skb, tb);
+
+		tb = nla_nest_start(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_INFO);
+
+		if (!tb)
+			goto nla_info_failure;
+
+		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_INSTANCE,
+				mep->instance))
+			goto nla_put_failure;
+
+		if (nla_put(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_DMAC,
+			    sizeof(mep->cc_ccm_tx_info.dmac),
+			    mep->cc_ccm_tx_info.dmac.addr))
+			goto nla_put_failure;
+
+		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_SEQ_NO_UPDATE,
+				mep->cc_ccm_tx_info.seq_no_update))
+			goto nla_put_failure;
+
+		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_PERIOD,
+				mep->cc_ccm_tx_info.period))
+			goto nla_put_failure;
+
+		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV,
+				mep->cc_ccm_tx_info.if_tlv))
+			goto nla_put_failure;
+
+		if (nla_put_u8(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV_VALUE,
+			       mep->cc_ccm_tx_info.if_tlv_value))
+			goto nla_put_failure;
+
+		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV,
+				mep->cc_ccm_tx_info.port_tlv))
+			goto nla_put_failure;
+
+		if (nla_put_u8(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV_VALUE,
+			       mep->cc_ccm_tx_info.port_tlv_value))
+			goto nla_put_failure;
+
+		nla_nest_end(skb, tb);
+
+		hlist_for_each_entry_rcu(peer_mep, &mep->peer_mep_list, head) {
+			tb = nla_nest_start(skb,
+					    IFLA_BRIDGE_CFM_CC_PEER_MEP_INFO);
+
+			if (!tb)
+				goto nla_info_failure;
+
+			if (nla_put_u32(skb,
+					IFLA_BRIDGE_CFM_CC_PEER_MEP_INSTANCE,
+					mep->instance))
+				goto nla_put_failure;
+
+			if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_PEER_MEPID,
+					peer_mep->mepid))
+				goto nla_put_failure;
+
+			nla_nest_end(skb, tb);
+		}
+	}
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, tb);
+
+nla_info_failure:
+	return -EMSGSIZE;
+}
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 431ee2b06dc1..69bfe165ff7f 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -16,6 +16,7 @@
 
 #include "br_private.h"
 #include "br_private_stp.h"
+#include "br_private_cfm.h"
 #include "br_private_tunnel.h"
 
 static int __get_num_vlan_infos(struct net_bridge_vlan_group *vg,
@@ -426,7 +427,8 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 
 	if (filter_mask & (RTEXT_FILTER_BRVLAN |
 			   RTEXT_FILTER_BRVLAN_COMPRESSED |
-			   RTEXT_FILTER_MRP)) {
+			   RTEXT_FILTER_MRP |
+			   RTEXT_FILTER_CFM_CONFIG)) {
 		af = nla_nest_start_noflag(skb, IFLA_AF_SPEC);
 		if (!af)
 			goto nla_put_failure;
@@ -475,6 +477,28 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 			goto nla_put_failure;
 	}
 
+	if (filter_mask & RTEXT_FILTER_CFM_CONFIG) {
+		struct nlattr *cfm_nest = NULL;
+		int err;
+
+		if (!br_cfm_created(br) || port)
+			goto done;
+
+		cfm_nest = nla_nest_start(skb, IFLA_BRIDGE_CFM);
+		if (!cfm_nest)
+			goto nla_put_failure;
+
+		if (filter_mask & RTEXT_FILTER_CFM_CONFIG) {
+			rcu_read_lock();
+			err = br_cfm_config_fill_info(skb, br);
+			rcu_read_unlock();
+			if (err)
+				goto nla_put_failure;
+		}
+
+		nla_nest_end(skb, cfm_nest);
+	}
+
 done:
 	if (af)
 		nla_nest_end(skb, af);
@@ -538,7 +562,8 @@ int br_getlink(struct sk_buff *skb, u32 pid, u32 seq,
 
 	if (!port && !(filter_mask & RTEXT_FILTER_BRVLAN) &&
 	    !(filter_mask & RTEXT_FILTER_BRVLAN_COMPRESSED) &&
-	    !(filter_mask & RTEXT_FILTER_MRP))
+	    !(filter_mask & RTEXT_FILTER_MRP) &&
+	    !(filter_mask & RTEXT_FILTER_CFM_CONFIG))
 		return 0;
 
 	return br_fill_ifinfo(skb, port, pid, seq, RTM_NEWLINK, nlflags,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 397d098dd694..7bfd7c09b01a 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1466,6 +1466,7 @@ int br_cfm_parse(struct net_bridge *br, struct net_bridge_port *p,
 		 struct nlattr *attr, int cmd, struct netlink_ext_ack *extack);
 bool br_cfm_created(struct net_bridge *br);
 void br_cfm_port_del(struct net_bridge *br, struct net_bridge_port *p);
+int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge *br);
 #else
 static inline int br_cfm_parse(struct net_bridge *br, struct net_bridge_port *p,
 			       struct nlattr *attr, int cmd,
@@ -1483,6 +1484,11 @@ static inline void br_cfm_port_del(struct net_bridge *br,
 				   struct net_bridge_port *p)
 {
 }
+
+static inline int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge *br)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 /* br_netlink.c */
-- 
2.28.0

