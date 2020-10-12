Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E854328BA40
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 16:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391154AbgJLOHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 10:07:13 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:1309 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391108AbgJLOGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 10:06:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602511603; x=1634047603;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HbeMCc+hOmuHjA47q19RJzL7fviNcUhMbPII/soGdqw=;
  b=WAWeRhH3GyqUmzJiWm0G3A1mupnnUsf7x1y9lqqGhIxCL/TLR+uRcnrI
   2hzTOKV8NbET4WPveeE6WJyEdgwibT/oGJKGBQIvtTU5OxSRWNi5zcacL
   UoBhTcRT9BUeCMI+cNG0JQ+g4ap1N5rD+srE0QifdkhMs7bQEkxY5lNK9
   GwMyv3ER1mmAGtmuc0HGsrcJyRrVOk7YEpdVgO0Z9liS6E018EAHVVKza
   frT0dCXUlK7+achTIlvzDtNwMujQNtCOfkhdxalmLjmfw/qvZpQirWAFZ
   5tbqPHugh3xUYLBwoUU/rBBwb5qTWk9YBv46H8iMe5yjU/Hrjv2nLRkrg
   A==;
IronPort-SDR: S1a1zHGf6k0Itf63NzwHyrzuImntVfjus0uIa0BR3qGai1fvYBgAw+anwZMnfIZYVXw1upT6+r
 4+0gNKVl4VMv8jL9NW2QZHJvWaGddDLqJePM9lmSDCXPEsJYHytWb1d0/P0RMnmKyJ+3Noc5mA
 D68rnl3Tyyp7eC956Vn2Z7DhLcMyugQZJVfT5Te6H59+P5NbJv1cKaKhe5YviAZms0k0REznmu
 pjuYI3Qm2J78Og+fqDo1VUDACtPbCiD3F+fa0Dq2LtzG76F66Frm2NFXzqJ4PMMORhzJSV/kYn
 NnY=
X-IronPort-AV: E=Sophos;i="5.77,366,1596524400"; 
   d="scan'208";a="92295956"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Oct 2020 07:06:42 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 12 Oct 2020 07:06:42 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 12 Oct 2020 07:06:40 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v5 08/10] bridge: cfm: Netlink GET configuration Interface.
Date:   Mon, 12 Oct 2020 14:04:26 +0000
Message-ID: <20201012140428.2549163-9-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
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
index 6558fa95630e..e7bfb8e003e8 100644
--- a/net/bridge/br_cfm_netlink.c
+++ b/net/bridge/br_cfm_netlink.c
@@ -451,3 +451,164 @@ int br_cfm_parse(struct net_bridge *br, struct net_bridge_port *p,
 
 	return 0;
 }
+
+int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge *br)
+{
+	struct br_cfm_peer_mep *peer_mep;
+	struct br_cfm_mep *mep;
+	struct nlattr *tb;
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
index 6a5db0553f19..f571bdeb5d83 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1465,6 +1465,7 @@ int br_cfm_parse(struct net_bridge *br, struct net_bridge_port *p,
 		 struct nlattr *attr, int cmd, struct netlink_ext_ack *extack);
 bool br_cfm_created(struct net_bridge *br);
 void br_cfm_port_del(struct net_bridge *br, struct net_bridge_port *p);
+int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge *br);
 #else
 static inline int br_cfm_parse(struct net_bridge *br, struct net_bridge_port *p,
 			       struct nlattr *attr, int cmd,
@@ -1482,6 +1483,11 @@ static inline void br_cfm_port_del(struct net_bridge *br,
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

