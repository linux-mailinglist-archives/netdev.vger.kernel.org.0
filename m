Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388B925D48F
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 11:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbgIDJTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 05:19:47 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:8292 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730025AbgIDJTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 05:19:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1599211170; x=1630747170;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BkqX6+/LQSrJs+XTxc1DCNz7FululLE0m1ftR3LVtO0=;
  b=NJJrJqDhWg64mfTJPyuLQ4+ZppUDPpzvh9uutQrBkfN+oWHY8fHu5/J7
   2RHpLKMFezQ6tHIs9wghVMwF43LgpCStJm3T8DJzXEuyNqsPD/qkFF1Vs
   ihtRbRYdukCUHS9Fm26ovO5x4xvO26zE88EzXIFVyd6iBh0YrFa6U/njT
   JWodYg8JT9moPnOIVj8WYZPYSWNyelmHF9pRLkeqafhFfhztTiebM8rnQ
   ENAYaw5CFmqvX1oWjZeasH9rNr1OKFxAj3TaeoTw4dEc7lsSlTMHVaVCq
   i+oSBRKLeX9tBRNq9twSkFXTSlMftmZIYNMO//UiUX/PlqwEBcUowCLRf
   g==;
IronPort-SDR: BifmdAFiO0rERubWulRut3gUMrOq1b5jCtdsFbzZwexmWXSQFyNmGB+ze3vejL9rQYuxz3zRKS
 uwfcgienaodV0zqAbYWoCGqfhp1FA0E9XIzoCTiFbjm3n75v77gjOtgQNwfgRDdx0/2tMoP0L6
 9jA/YQhZR+c+V1GQ/in6m5z4gOjNKPwd9Rnw+3Im8owgGksTV0wFOZ2uSw2NBG2uPPWsU/CODT
 p1g6VMZFDk4RENIvx6fkz0jBtHSpN2QUII3rG1xLcj2p4SZZMDUmhS0WNUj5P3HsC5BGCon/7U
 Q94=
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="25340155"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Sep 2020 02:19:24 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Sep 2020 02:19:21 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 4 Sep 2020 02:19:19 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH RFC 6/7] bridge: cfm: Netlink Notifications.
Date:   Fri, 4 Sep 2020 09:15:26 +0000
Message-ID: <20200904091527.669109-7-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
References: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the implementation of Netlink notifications out of CFM.

Notifications are initiated whenever a state change happens in CFM.

IFLA_BRIDGE_CFM:
    Points to the CFM information.

IFLA_BRIDGE_CFM_MEP_STATUS_INFO:
    This indicate that the MEP instance status are following.
IFLA_BRIDGE_CFM_CC_PEER_STATUS_INFO:
    This indicate that the peer MEP status are following.

CFM nested attribute has the following attributes in next level.

IFLA_BRIDGE_CFM_MEP_STATUS_INSTANCE:
    The MEP instance number of the delivered status.
    The type is NLA_U32.
IFLA_BRIDGE_CFM_MEP_STATUS_OPCODE_UNEXP_SEEN:
    The MEP instance received CFM PDU with unexpected Opcode.
    The type is NLA_U32 (bool).
IFLA_BRIDGE_CFM_MEP_STATUS_VERSION_UNEXP_SEEN:
    The MEP instance received CFM PDU with unexpected version.
    The type is NLA_U32 (bool).
IFLA_BRIDGE_CFM_MEP_STATUS_RX_LEVEL_LOW_SEEN:
    The MEP instance received CCM PDU with MD level lower than
    configured level. This frame is discarded.
    The type is NLA_U32 (bool).

IFLA_BRIDGE_CFM_CC_PEER_STATUS_INSTANCE:
    The MEP instance number of the delivered status.
    The type is NLA_U32.
IFLA_BRIDGE_CFM_CC_PEER_STATUS_PEER_MEPID:
    The added Peer MEP ID of the delivered status.
    The type is NLA_U32.
IFLA_BRIDGE_CFM_CC_PEER_STATUS_CCM_DEFECT:
    The CCM defect status.
    The type is NLA_U32 (bool).
    True means no CCM frame is received for 3.25 intervals.
    IFLA_BRIDGE_CFM_CC_CONFIG_EXP_INTERVAL.
IFLA_BRIDGE_CFM_CC_PEER_STATUS_RDI:
    The last received CCM PDU RDI.
    The type is NLA_U32 (bool).
IFLA_BRIDGE_CFM_CC_PEER_STATUS_PORT_TLV_VALUE:
    The last received CCM PDU Port Status TLV value field.
    The type is NLA_U8.
IFLA_BRIDGE_CFM_CC_PEER_STATUS_IF_TLV_VALUE:
    The last received CCM PDU Interface Status TLV value field.
    The type is NLA_U8.
IFLA_BRIDGE_CFM_CC_PEER_STATUS_SEEN:
    A CCM frame has been received from Peer MEP.
    The type is NLA_U32 (bool).
    This is cleared after GETLINK IFLA_BRIDGE_CFM_CC_PEER_STATUS_INFO.
IFLA_BRIDGE_CFM_CC_PEER_STATUS_TLV_SEEN:
    A CCM frame with TLV has been received from Peer MEP.
    The type is NLA_U32 (bool).
    This is cleared after GETLINK IFLA_BRIDGE_CFM_CC_PEER_STATUS_INFO.
IFLA_BRIDGE_CFM_CC_PEER_STATUS_SEQ_UNEXP_SEEN:
    A CCM frame with unexpected sequence number has been received
    from Peer MEP.
    The type is NLA_U32 (bool).
    When a sequence number is not one higher than previously received
    then it is unexpected.
    This is cleared after GETLINK IFLA_BRIDGE_CFM_CC_PEER_STATUS_INFO.

Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
---
 net/bridge/br_cfm.c         | 43 +++++++++++++++++++++
 net/bridge/br_cfm_netlink.c | 24 +++++++-----
 net/bridge/br_netlink.c     | 76 ++++++++++++++++++++++++++++++++-----
 net/bridge/br_private.h     | 22 ++++++++++-
 4 files changed, 144 insertions(+), 21 deletions(-)

diff --git a/net/bridge/br_cfm.c b/net/bridge/br_cfm.c
index e38cc3e8f262..b7fed2c1d8ec 100644
--- a/net/bridge/br_cfm.c
+++ b/net/bridge/br_cfm.c
@@ -155,6 +155,13 @@ static void ccm_rx_timer_start(struct br_cfm_peer_mep *peer_mep)
 			   usecs_to_jiffies(interval_us / 4));
 }
 
+static void br_cfm_notify(int event, const struct net_bridge_port *port)
+{
+	u32 filter = RTEXT_FILTER_CFM_STATUS;
+
+	return br_info_notify(event, port->br, NULL, filter);
+}
+
 static void cc_peer_enable(struct br_cfm_peer_mep *peer_mep)
 {
 	memset(&peer_mep->cc_status, 0, sizeof(peer_mep->cc_status));
@@ -299,6 +306,7 @@ static void ccm_tx_work_expired(struct work_struct *work)
 static void ccm_rx_work_expired(struct work_struct *work)
 {
 	struct br_cfm_peer_mep *peer_mep;
+	struct net_bridge_port *b_port;
 	struct delayed_work *del_work;
 
 	del_work = to_delayed_work(work);
@@ -318,6 +326,11 @@ static void ccm_rx_work_expired(struct work_struct *work)
 		peer_mep->cc_status.ccm_defect = true;
 
 		/* Change in CCM defect status - notify */
+		rcu_read_lock();
+		b_port = rcu_dereference(peer_mep->mep->b_port);
+		if (b_port)
+			br_cfm_notify(RTM_NEWLINK, b_port);
+		rcu_read_unlock();
 	}
 }
 
@@ -445,6 +458,7 @@ static int br_cfm_frame_rx(struct net_bridge_port *port, struct sk_buff *skb)
 			peer_mep->cc_status.ccm_defect = false;
 
 			/* Change in CCM defect status - notify */
+			br_cfm_notify(RTM_NEWLINK, port);
 
 			/* Start CCM RX timer */
 			ccm_rx_timer_start(peer_mep);
@@ -874,6 +888,35 @@ int br_cfm_cc_counters_clear(struct net_bridge *br, const u32 instance,
 	return 0;
 }
 
+int br_cfm_mep_count(struct net_bridge *br, u32 *count)
+{
+	struct br_cfm_mep *mep;
+	*count = 0;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(mep, &br->mep_list, head)
+		* count += 1;
+	rcu_read_unlock();
+
+	return 0;
+}
+
+int br_cfm_peer_mep_count(struct net_bridge *br, u32 *count)
+{
+	struct br_cfm_peer_mep *peer_mep;
+	struct br_cfm_mep *mep;
+	*count = 0;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(mep, &br->mep_list, head) {
+		list_for_each_entry_rcu(peer_mep, &mep->peer_mep_list, head)
+			* count += 1;
+	}
+	rcu_read_unlock();
+
+	return 0;
+}
+
 bool br_cfm_created(struct net_bridge *br)
 {
 	return !list_empty(&br->mep_list);
diff --git a/net/bridge/br_cfm_netlink.c b/net/bridge/br_cfm_netlink.c
index 4e39aab1cd0b..13664ac8608a 100644
--- a/net/bridge/br_cfm_netlink.c
+++ b/net/bridge/br_cfm_netlink.c
@@ -582,7 +582,9 @@ int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge *br)
 	return -EMSGSIZE;
 }
 
-int br_cfm_status_fill_info(struct sk_buff *skb, struct net_bridge *br)
+int br_cfm_status_fill_info(struct sk_buff *skb,
+			    struct net_bridge *br,
+			    bool getlink)
 {
 	struct nlattr *tb, *cfm_tb;
 	struct br_cfm_mep *mep;
@@ -613,10 +615,12 @@ int br_cfm_status_fill_info(struct sk_buff *skb, struct net_bridge *br)
 				mep->status.rx_level_low_seen))
 			goto nla_put_failure;
 
-		/* Clear all 'seen' indications */
-		mep->status.opcode_unexp_seen = false;
-		mep->status.version_unexp_seen = false;
-		mep->status.rx_level_low_seen = false;
+		if (getlink) { /* Only clear if this is a GETLINK */
+			/* Clear all 'seen' indications */
+			mep->status.opcode_unexp_seen = false;
+			mep->status.version_unexp_seen = false;
+			mep->status.rx_level_low_seen = false;
+		}
 
 		nla_nest_end(skb, tb);
 
@@ -662,10 +666,12 @@ int br_cfm_status_fill_info(struct sk_buff *skb, struct net_bridge *br)
 					peer_mep->cc_status.seq_unexp_seen))
 				goto nla_put_failure;
 
-			/* Clear all 'seen' indications */
-			peer_mep->cc_status.seen = false;
-			peer_mep->cc_status.tlv_seen = false;
-			peer_mep->cc_status.seq_unexp_seen = false;
+			if (getlink) { /* Only clear if this is a GETLINK */
+				/* Clear all 'seen' indications */
+				peer_mep->cc_status.seen = false;
+				peer_mep->cc_status.tlv_seen = false;
+				peer_mep->cc_status.seq_unexp_seen = false;
+			}
 
 			nla_nest_end(skb, tb);
 		}
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 6de5cb1295f6..f2e885521f4f 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -94,9 +94,11 @@ static size_t br_get_link_af_size_filtered(const struct net_device *dev,
 {
 	struct net_bridge_vlan_group *vg = NULL;
 	struct net_bridge_port *p = NULL;
-	struct net_bridge *br;
-	int num_vlan_infos;
+	struct net_bridge *br = NULL;
+	u32 num_cfm_peer_mep_infos;
+	u32 num_cfm_mep_infos;
 	size_t vinfo_sz = 0;
+	int num_vlan_infos;
 
 	rcu_read_lock();
 	if (netif_is_bridge_port(dev)) {
@@ -115,6 +117,52 @@ static size_t br_get_link_af_size_filtered(const struct net_device *dev,
 	/* Each VLAN is returned in bridge_vlan_info along with flags */
 	vinfo_sz += num_vlan_infos * nla_total_size(sizeof(struct bridge_vlan_info));
 
+	if (!(filter_mask & RTEXT_FILTER_CFM_STATUS))
+		return vinfo_sz;
+
+	if (!br)
+		return vinfo_sz;
+
+	/* CFM status info must be added */
+	if (br_cfm_mep_count(br, &num_cfm_mep_infos))
+		return vinfo_sz;
+
+	if (br_cfm_peer_mep_count(br, &num_cfm_peer_mep_infos))
+		return vinfo_sz;
+
+	vinfo_sz += nla_total_size(0);	/* IFLA_BRIDGE_CFM */
+	/* For each status struct the MEP instance (u32) is added */
+	/* MEP instance (u32) + br_cfm_mep_status */
+	vinfo_sz += num_cfm_mep_infos *
+		     /*IFLA_BRIDGE_CFM_MEP_STATUS_INSTANCE */
+		    (nla_total_size(sizeof(u32))
+		     /* IFLA_BRIDGE_CFM_MEP_STATUS_OPCODE_UNEXP_SEEN */
+		     + nla_total_size(sizeof(u32))
+		     /* IFLA_BRIDGE_CFM_MEP_STATUS_VERSION_UNEXP_SEEN */
+		     + nla_total_size(sizeof(u32))
+		     /* IFLA_BRIDGE_CFM_MEP_STATUS_RX_LEVEL_LOW_SEEN */
+		     + nla_total_size(sizeof(u32)));
+	/* MEP instance (u32) + br_cfm_cc_peer_status */
+	vinfo_sz += num_cfm_peer_mep_infos *
+		     /* IFLA_BRIDGE_CFM_CC_PEER_STATUS_INSTANCE */
+		    (nla_total_size(sizeof(u32))
+		     /* IFLA_BRIDGE_CFM_CC_PEER_STATUS_PEER_MEPID */
+		     + nla_total_size(sizeof(u32))
+		     /* IFLA_BRIDGE_CFM_CC_PEER_STATUS_CCM_DEFECT */
+		     + nla_total_size(sizeof(u32))
+		     /* IFLA_BRIDGE_CFM_CC_PEER_STATUS_RDI */
+		     + nla_total_size(sizeof(u32))
+		     /* IFLA_BRIDGE_CFM_CC_PEER_STATUS_PORT_TLV_VALUE */
+		     + nla_total_size(sizeof(u8))
+		     /* IFLA_BRIDGE_CFM_CC_PEER_STATUS_IF_TLV_VALUE */
+		     + nla_total_size(sizeof(u8))
+		     /* IFLA_BRIDGE_CFM_CC_PEER_STATUS_SEEN */
+		     + nla_total_size(sizeof(u32))
+		     /* IFLA_BRIDGE_CFM_CC_PEER_STATUS_TLV_SEEN */
+		     + nla_total_size(sizeof(u32))
+		     /* IFLA_BRIDGE_CFM_CC_PEER_STATUS_SEQ_UNEXP_SEEN */
+		     + nla_total_size(sizeof(u32)));
+
 	return vinfo_sz;
 }
 
@@ -378,7 +426,8 @@ static int br_fill_ifvlaninfo(struct sk_buff *skb,
 static int br_fill_ifinfo(struct sk_buff *skb,
 			  const struct net_bridge_port *port,
 			  u32 pid, u32 seq, int event, unsigned int flags,
-			  u32 filter_mask, const struct net_device *dev)
+			  u32 filter_mask, const struct net_device *dev,
+			  bool getlink)
 {
 	u8 operstate = netif_running(dev) ? dev->operstate : IF_OPER_DOWN;
 	struct net_bridge *br;
@@ -515,7 +564,7 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 			goto nla_put_failure;
 
 		rcu_read_lock();
-		err = br_cfm_status_fill_info(skb, br);
+		err = br_cfm_status_fill_info(skb, br, getlink);
 		rcu_read_unlock();
 
 		if (err)
@@ -533,11 +582,9 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 	return -EMSGSIZE;
 }
 
-/* Notify listeners of a change in bridge or port information */
-void br_ifinfo_notify(int event, const struct net_bridge *br,
-		      const struct net_bridge_port *port)
+void br_info_notify(int event, const struct net_bridge *br,
+		    const struct net_bridge_port *port, u32 filter)
 {
-	u32 filter = RTEXT_FILTER_BRVLAN_COMPRESSED;
 	struct net_device *dev;
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
@@ -562,7 +609,7 @@ void br_ifinfo_notify(int event, const struct net_bridge *br,
 	if (skb == NULL)
 		goto errout;
 
-	err = br_fill_ifinfo(skb, port, 0, 0, event, 0, filter, dev);
+	err = br_fill_ifinfo(skb, port, 0, 0, event, 0, filter, dev, false);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in br_nlmsg_size() */
 		WARN_ON(err == -EMSGSIZE);
@@ -575,6 +622,15 @@ void br_ifinfo_notify(int event, const struct net_bridge *br,
 	rtnl_set_sk_err(net, RTNLGRP_LINK, err);
 }
 
+/* Notify listeners of a change in bridge or port information */
+void br_ifinfo_notify(int event, const struct net_bridge *br,
+		      const struct net_bridge_port *port)
+{
+	u32 filter = RTEXT_FILTER_BRVLAN_COMPRESSED;
+
+	return br_info_notify(event, br, port, filter);
+}
+
 /*
  * Dump information about all ports, in response to GETLINK
  */
@@ -591,7 +647,7 @@ int br_getlink(struct sk_buff *skb, u32 pid, u32 seq,
 		return 0;
 
 	return br_fill_ifinfo(skb, port, pid, seq, RTM_NEWLINK, nlflags,
-			      filter_mask, dev);
+			      filter_mask, dev, true);
 }
 
 static int br_vlan_info(struct net_bridge *br, struct net_bridge_port *p,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index fe36592f7525..53bcbdd21f34 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1370,7 +1370,11 @@ int br_cfm_parse(struct net_bridge *br, struct net_bridge_port *p,
 int br_cfm_rx_frame_process(struct net_bridge_port *p, struct sk_buff *skb);
 bool br_cfm_created(struct net_bridge *br);
 int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge *br);
-int br_cfm_status_fill_info(struct sk_buff *skb, struct net_bridge *br);
+int br_cfm_status_fill_info(struct sk_buff *skb,
+			    struct net_bridge *br,
+			    bool getlink);
+int br_cfm_mep_count(struct net_bridge *br, u32 *count);
+int br_cfm_peer_mep_count(struct net_bridge *br, u32 *count);
 #else
 static inline int br_cfm_parse(struct net_bridge *br, struct net_bridge_port *p,
 			       struct nlattr *attr, int cmd,
@@ -1394,7 +1398,19 @@ static inline int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge
 	return -EOPNOTSUPP;
 }
 
-static inline int br_cfm_status_fill_info(struct sk_buff *skb, struct net_bridge *br)
+static inline int br_cfm_status_fill_info(struct sk_buff *skb,
+					  struct net_bridge *br,
+					  bool getlink)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int br_cfm_mep_count(struct net_bridge *br, u32 *count)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int br_cfm_peer_mep_count(struct net_bridge *br, u32 *count)
 {
 	return -EOPNOTSUPP;
 }
@@ -1406,6 +1422,8 @@ int br_netlink_init(void);
 void br_netlink_fini(void);
 void br_ifinfo_notify(int event, const struct net_bridge *br,
 		      const struct net_bridge_port *port);
+void br_info_notify(int event, const struct net_bridge *br,
+		    const struct net_bridge_port *port, u32 filter);
 int br_setlink(struct net_device *dev, struct nlmsghdr *nlmsg, u16 flags,
 	       struct netlink_ext_ack *extack);
 int br_dellink(struct net_device *dev, struct nlmsghdr *nlmsg, u16 flags);
-- 
2.28.0

