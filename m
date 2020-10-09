Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECA0288B9B
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 16:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389096AbgJIOip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 10:38:45 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:11946 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732056AbgJIOiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 10:38:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602254294; x=1633790294;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aCA7e6p0AWcknI/78M+UOXvwyxnTUWfK+7LBRg0UjLQ=;
  b=iEneOZFPSzh3BeaqiuEn/0Ev90KwwwvWfBi7WSKqX8deg0VIph41Q6aW
   X8ijGRblnMaAGZyJZIM0lpsEQUjxRlC24K4KpWe0N6fZpujUXfsi5NxLr
   YI/84BBB/WZFqgOgSU6OB6hNdh/46ivRde7jyZRLSdq19I0h2tBhK5/Qn
   Qwey19y5DQ3vYEnh/EZ0yDzIikvjWSRQjOFd7UKHZIcmJ7K0hMSUEFpAE
   3tj6AiVividNOWp7k+iExwQSlDVHm2YzLNp5gQ/POMqqNdC+LxdqLuEte
   JkETG1IjQyhjXmgN0XnaMNYJRLpIHrwJmKX/6lutqs873qTjbeaHfVhbP
   A==;
IronPort-SDR: zM31xE4wBOueH8U0tz/KGHw2V6VbKRJKyQTrN/q4u5vlk2mEz51VRYAVmUxZyBlvwKDHkqbLWq
 8U5F4NOKTvmgvT1hxglLcTBLQAAuyTjxkmSEy4f+udK+N4brZzqYuzOaO9bMunGh9Ot6GTqmOe
 624fwYhiDhj8AR7cBVIyamC/kCQ7pDrlJtLiyx4VPZ6TFxdzLz9jpRuMMQEWp3ThzQJqlY8MS0
 u0F21OnUEm5kL4sJTCeSZikz8MHAJwmyDasj0NT4zMZ5ybOk1chwQDjByJyAdLeUTNbYiWzSVE
 whs=
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="98910647"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Oct 2020 07:38:13 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 9 Oct 2020 07:38:13 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 9 Oct 2020 07:38:11 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 09/10] bridge: cfm: Netlink GET status Interface.
Date:   Fri, 9 Oct 2020 14:35:29 +0000
Message-ID: <20201009143530.2438738-10-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the implementation of CFM netlink status
get information interface.

Add new nested netlink attributes. These attributes are used by the
user space to get status information.

GETLINK:
    Request filter RTEXT_FILTER_CFM_STATUS:
    Indicating that CFM status information must be delivered.

    IFLA_BRIDGE_CFM:
        Points to the CFM information.

    IFLA_BRIDGE_CFM_MEP_STATUS_INFO:
        This indicate that the MEP instance status are following.
    IFLA_BRIDGE_CFM_CC_PEER_STATUS_INFO:
        This indicate that the peer MEP status are following.

CFM nested attribute has the following attributes in next level.

GETLINK RTEXT_FILTER_CFM_STATUS:
    IFLA_BRIDGE_CFM_MEP_STATUS_INSTANCE:
        The MEP instance number of the delivered status.
        The type is u32.
    IFLA_BRIDGE_CFM_MEP_STATUS_OPCODE_UNEXP_SEEN:
        The MEP instance received CFM PDU with unexpected Opcode.
        The type is u32 (bool).
    IFLA_BRIDGE_CFM_MEP_STATUS_VERSION_UNEXP_SEEN:
        The MEP instance received CFM PDU with unexpected version.
        The type is u32 (bool).
    IFLA_BRIDGE_CFM_MEP_STATUS_RX_LEVEL_LOW_SEEN:
        The MEP instance received CCM PDU with MD level lower than
        configured level. This frame is discarded.
        The type is u32 (bool).

    IFLA_BRIDGE_CFM_CC_PEER_STATUS_INSTANCE:
        The MEP instance number of the delivered status.
        The type is u32.
    IFLA_BRIDGE_CFM_CC_PEER_STATUS_PEER_MEPID:
        The added Peer MEP ID of the delivered status.
        The type is u32.
    IFLA_BRIDGE_CFM_CC_PEER_STATUS_CCM_DEFECT:
        The CCM defect status.
        The type is u32 (bool).
        True means no CCM frame is received for 3.25 intervals.
        IFLA_BRIDGE_CFM_CC_CONFIG_EXP_INTERVAL.
    IFLA_BRIDGE_CFM_CC_PEER_STATUS_RDI:
        The last received CCM PDU RDI.
        The type is u32 (bool).
    IFLA_BRIDGE_CFM_CC_PEER_STATUS_PORT_TLV_VALUE:
        The last received CCM PDU Port Status TLV value field.
        The type is u8.
    IFLA_BRIDGE_CFM_CC_PEER_STATUS_IF_TLV_VALUE:
        The last received CCM PDU Interface Status TLV value field.
        The type is u8.
    IFLA_BRIDGE_CFM_CC_PEER_STATUS_SEEN:
        A CCM frame has been received from Peer MEP.
        The type is u32 (bool).
        This is cleared after GETLINK IFLA_BRIDGE_CFM_CC_PEER_STATUS_INFO.
    IFLA_BRIDGE_CFM_CC_PEER_STATUS_TLV_SEEN:
        A CCM frame with TLV has been received from Peer MEP.
        The type is u32 (bool).
        This is cleared after GETLINK IFLA_BRIDGE_CFM_CC_PEER_STATUS_INFO.
    IFLA_BRIDGE_CFM_CC_PEER_STATUS_SEQ_UNEXP_SEEN:
        A CCM frame with unexpected sequence number has been received
        from Peer MEP.
        The type is u32 (bool).
        When a sequence number is not one higher than previously received
        then it is unexpected.
        This is cleared after GETLINK IFLA_BRIDGE_CFM_CC_PEER_STATUS_INFO.

Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
---
 include/uapi/linux/if_bridge.h |  29 +++++++++
 include/uapi/linux/rtnetlink.h |   1 +
 net/bridge/br_cfm_netlink.c    | 105 +++++++++++++++++++++++++++++++++
 net/bridge/br_netlink.c        |  16 ++++-
 net/bridge/br_private.h        |   6 ++
 5 files changed, 154 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index b8b4491922d9..d975e1223884 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -345,6 +345,8 @@ enum {
 	IFLA_BRIDGE_CFM_CC_RDI_INFO,
 	IFLA_BRIDGE_CFM_CC_CCM_TX_INFO,
 	IFLA_BRIDGE_CFM_CC_PEER_MEP_INFO,
+	IFLA_BRIDGE_CFM_MEP_STATUS_INFO,
+	IFLA_BRIDGE_CFM_CC_PEER_STATUS_INFO,
 	__IFLA_BRIDGE_CFM_MAX,
 };
 
@@ -424,6 +426,33 @@ enum {
 
 #define IFLA_BRIDGE_CFM_CC_CCM_TX_MAX (__IFLA_BRIDGE_CFM_CC_CCM_TX_MAX - 1)
 
+enum {
+	IFLA_BRIDGE_CFM_MEP_STATUS_UNSPEC,
+	IFLA_BRIDGE_CFM_MEP_STATUS_INSTANCE,
+	IFLA_BRIDGE_CFM_MEP_STATUS_OPCODE_UNEXP_SEEN,
+	IFLA_BRIDGE_CFM_MEP_STATUS_VERSION_UNEXP_SEEN,
+	IFLA_BRIDGE_CFM_MEP_STATUS_RX_LEVEL_LOW_SEEN,
+	__IFLA_BRIDGE_CFM_MEP_STATUS_MAX,
+};
+
+#define IFLA_BRIDGE_CFM_MEP_STATUS_MAX (__IFLA_BRIDGE_CFM_MEP_STATUS_MAX - 1)
+
+enum {
+	IFLA_BRIDGE_CFM_CC_PEER_STATUS_UNSPEC,
+	IFLA_BRIDGE_CFM_CC_PEER_STATUS_INSTANCE,
+	IFLA_BRIDGE_CFM_CC_PEER_STATUS_PEER_MEPID,
+	IFLA_BRIDGE_CFM_CC_PEER_STATUS_CCM_DEFECT,
+	IFLA_BRIDGE_CFM_CC_PEER_STATUS_RDI,
+	IFLA_BRIDGE_CFM_CC_PEER_STATUS_PORT_TLV_VALUE,
+	IFLA_BRIDGE_CFM_CC_PEER_STATUS_IF_TLV_VALUE,
+	IFLA_BRIDGE_CFM_CC_PEER_STATUS_SEEN,
+	IFLA_BRIDGE_CFM_CC_PEER_STATUS_TLV_SEEN,
+	IFLA_BRIDGE_CFM_CC_PEER_STATUS_SEQ_UNEXP_SEEN,
+	__IFLA_BRIDGE_CFM_CC_PEER_STATUS_MAX,
+};
+
+#define IFLA_BRIDGE_CFM_CC_PEER_STATUS_MAX (__IFLA_BRIDGE_CFM_CC_PEER_STATUS_MAX - 1)
+
 struct bridge_stp_xstats {
 	__u64 transition_blk;
 	__u64 transition_fwd;
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index ffc9ca1f2bdb..fdd408f6a5d2 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -780,6 +780,7 @@ enum {
 #define	RTEXT_FILTER_SKIP_STATS	(1 << 3)
 #define RTEXT_FILTER_MRP	(1 << 4)
 #define RTEXT_FILTER_CFM_CONFIG	(1 << 5)
+#define RTEXT_FILTER_CFM_STATUS	(1 << 6)
 
 /* End of information exported to user level */
 
diff --git a/net/bridge/br_cfm_netlink.c b/net/bridge/br_cfm_netlink.c
index 952b6372874e..94e9b46d5fb4 100644
--- a/net/bridge/br_cfm_netlink.c
+++ b/net/bridge/br_cfm_netlink.c
@@ -617,3 +617,108 @@ int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge *br)
 nla_info_failure:
 	return -EMSGSIZE;
 }
+
+int br_cfm_status_fill_info(struct sk_buff *skb, struct net_bridge *br)
+{
+	struct nlattr *tb;
+	struct br_cfm_mep *mep;
+	struct br_cfm_peer_mep *peer_mep;
+
+	hlist_for_each_entry_rcu(mep, &br->mep_list, head) {
+		tb = nla_nest_start(skb, IFLA_BRIDGE_CFM_MEP_STATUS_INFO);
+		if (!tb)
+			goto nla_info_failure;
+
+		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_MEP_STATUS_INSTANCE,
+				mep->instance))
+			goto nla_put_failure;
+
+		if (nla_put_u32(skb,
+				IFLA_BRIDGE_CFM_MEP_STATUS_OPCODE_UNEXP_SEEN,
+				mep->status.opcode_unexp_seen))
+			goto nla_put_failure;
+
+		if (nla_put_u32(skb,
+				IFLA_BRIDGE_CFM_MEP_STATUS_VERSION_UNEXP_SEEN,
+				mep->status.version_unexp_seen))
+			goto nla_put_failure;
+
+		if (nla_put_u32(skb,
+				IFLA_BRIDGE_CFM_MEP_STATUS_RX_LEVEL_LOW_SEEN,
+				mep->status.rx_level_low_seen))
+			goto nla_put_failure;
+
+		/* Clear all 'seen' indications */
+		mep->status.opcode_unexp_seen = false;
+		mep->status.version_unexp_seen = false;
+		mep->status.rx_level_low_seen = false;
+
+		nla_nest_end(skb, tb);
+
+		hlist_for_each_entry_rcu(peer_mep, &mep->peer_mep_list, head) {
+			tb = nla_nest_start(skb,
+					    IFLA_BRIDGE_CFM_CC_PEER_STATUS_INFO);
+			if (!tb)
+				goto nla_info_failure;
+
+			if (nla_put_u32(skb,
+					IFLA_BRIDGE_CFM_CC_PEER_STATUS_INSTANCE,
+					mep->instance))
+				goto nla_put_failure;
+
+			if (nla_put_u32(skb,
+					IFLA_BRIDGE_CFM_CC_PEER_STATUS_PEER_MEPID,
+					peer_mep->mepid))
+				goto nla_put_failure;
+
+			if (nla_put_u32(skb,
+					IFLA_BRIDGE_CFM_CC_PEER_STATUS_CCM_DEFECT,
+					peer_mep->cc_status.ccm_defect))
+				goto nla_put_failure;
+
+			if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_PEER_STATUS_RDI,
+					peer_mep->cc_status.rdi))
+				goto nla_put_failure;
+
+			if (nla_put_u8(skb,
+				       IFLA_BRIDGE_CFM_CC_PEER_STATUS_PORT_TLV_VALUE,
+				       peer_mep->cc_status.port_tlv_value))
+				goto nla_put_failure;
+
+			if (nla_put_u8(skb,
+				       IFLA_BRIDGE_CFM_CC_PEER_STATUS_IF_TLV_VALUE,
+				       peer_mep->cc_status.if_tlv_value))
+				goto nla_put_failure;
+
+			if (nla_put_u32(skb,
+					IFLA_BRIDGE_CFM_CC_PEER_STATUS_SEEN,
+					peer_mep->cc_status.seen))
+				goto nla_put_failure;
+
+			if (nla_put_u32(skb,
+					IFLA_BRIDGE_CFM_CC_PEER_STATUS_TLV_SEEN,
+					peer_mep->cc_status.tlv_seen))
+				goto nla_put_failure;
+
+			if (nla_put_u32(skb,
+					IFLA_BRIDGE_CFM_CC_PEER_STATUS_SEQ_UNEXP_SEEN,
+					peer_mep->cc_status.seq_unexp_seen))
+				goto nla_put_failure;
+
+			/* Clear all 'seen' indications */
+			peer_mep->cc_status.seen = false;
+			peer_mep->cc_status.tlv_seen = false;
+			peer_mep->cc_status.seq_unexp_seen = false;
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
index 69bfe165ff7f..68c2ed87e26b 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -428,7 +428,8 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 	if (filter_mask & (RTEXT_FILTER_BRVLAN |
 			   RTEXT_FILTER_BRVLAN_COMPRESSED |
 			   RTEXT_FILTER_MRP |
-			   RTEXT_FILTER_CFM_CONFIG)) {
+			   RTEXT_FILTER_CFM_CONFIG |
+			   RTEXT_FILTER_CFM_STATUS)) {
 		af = nla_nest_start_noflag(skb, IFLA_AF_SPEC);
 		if (!af)
 			goto nla_put_failure;
@@ -477,7 +478,7 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 			goto nla_put_failure;
 	}
 
-	if (filter_mask & RTEXT_FILTER_CFM_CONFIG) {
+	if (filter_mask & (RTEXT_FILTER_CFM_CONFIG | RTEXT_FILTER_CFM_STATUS)) {
 		struct nlattr *cfm_nest = NULL;
 		int err;
 
@@ -496,6 +497,14 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 				goto nla_put_failure;
 		}
 
+		if (filter_mask & RTEXT_FILTER_CFM_STATUS) {
+			rcu_read_lock();
+			err = br_cfm_status_fill_info(skb, br);
+			rcu_read_unlock();
+			if (err)
+				goto nla_put_failure;
+		}
+
 		nla_nest_end(skb, cfm_nest);
 	}
 
@@ -563,7 +572,8 @@ int br_getlink(struct sk_buff *skb, u32 pid, u32 seq,
 	if (!port && !(filter_mask & RTEXT_FILTER_BRVLAN) &&
 	    !(filter_mask & RTEXT_FILTER_BRVLAN_COMPRESSED) &&
 	    !(filter_mask & RTEXT_FILTER_MRP) &&
-	    !(filter_mask & RTEXT_FILTER_CFM_CONFIG))
+	    !(filter_mask & RTEXT_FILTER_CFM_CONFIG) &&
+	    !(filter_mask & RTEXT_FILTER_CFM_STATUS))
 		return 0;
 
 	return br_fill_ifinfo(skb, port, pid, seq, RTM_NEWLINK, nlflags,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 7bfd7c09b01a..9394709e2531 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1467,6 +1467,7 @@ int br_cfm_parse(struct net_bridge *br, struct net_bridge_port *p,
 bool br_cfm_created(struct net_bridge *br);
 void br_cfm_port_del(struct net_bridge *br, struct net_bridge_port *p);
 int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge *br);
+int br_cfm_status_fill_info(struct sk_buff *skb, struct net_bridge *br);
 #else
 static inline int br_cfm_parse(struct net_bridge *br, struct net_bridge_port *p,
 			       struct nlattr *attr, int cmd,
@@ -1489,6 +1490,11 @@ static inline int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int br_cfm_status_fill_info(struct sk_buff *skb, struct net_bridge *br)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 /* br_netlink.c */
-- 
2.28.0

