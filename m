Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8993C139154
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 13:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbgAMMrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 07:47:37 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:61038 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728791AbgAMMrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 07:47:18 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: Lrysywj6q5n6nQsiuyL5VcemqW4q6//cQRkhM/8d66khko6p0Q9sGMjZfANenOyWPRmHnR6EiX
 1lP1DisBraepbj90tjSR5oCo5D9TCGkJyx/j6T8TO38CuU1sTIeVRsxtE2nXSFiiJnLq6JUFOr
 w1jK6jc10SqJQTIxAyExyFyMjy9nTr4A6U63jfjYsFdbJZWRsG/BLIvfZDgiIPWL2R5asxoFF2
 aRLp+ZVcEpQSrhMJE0JS9YYKcRuuo1pHDCLMjP1MfONVgVF+SqXwugWvtPNz5IP46Ljdd/4Rxv
 jMA=
X-IronPort-AV: E=Sophos;i="5.69,429,1571727600"; 
   d="scan'208";a="63055976"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jan 2020 05:47:16 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 13 Jan 2020 05:47:15 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 13 Jan 2020 05:47:11 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <jakub.kicinski@netronome.com>, <vivien.didelot@gmail.com>,
        <olteanv@gmail.com>, <anirudh.venkataramanan@intel.com>,
        <andrew@lunn.ch>, <dsahern@gmail.com>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next Patch v2 3/4] net: bridge: mrp: Add netlink support to configure MRP
Date:   Mon, 13 Jan 2020 13:46:19 +0100
Message-ID: <20200113124620.18657-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200113124620.18657-1-horatiu.vultur@microchip.com>
References: <20200113124620.18657-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend br_netlink to be able to create/delete MRP instances. The current
configurations options for each instance are:
- set primary port
- set secondary port
- set MRP ring role (MRM or MRC)
- set MRP ring id.

To create a MRP instance on the bridge:
$ bridge mrp add dev br0 p_port eth0 s_port eth1 ring_role 2 ring_id 1

Where:
p_port, s_port: can be any port under the bridge
ring_role: can have the value 1(MRC - Media Redundancy Client) or
           2(MRM - Media Redundancy Manager). In a ring can be only one MRM.
ring_id: unique id for each MRP instance.

It is possible to create multiple instances. Each instance has to have it's own
ring_id and a port can't be part of multiple instances:
$ bridge mrp add dev br0 p_port eth2 s_port eth3 ring_role 1 ring_id 2

To see current MRP instances and their status:
$ bridge mrp show
dev br0 p_port eth2 s_port eth3 ring_role 1 ring_id 2 ring_state 3
dev br0 p_port eth0 s_port eth1 ring_role 2 ring_id 1 ring_state 4

Where:
p_port, s_port, ring_role, ring_id: represent the configuration values. It is
   possible for primary port to change the role with the secondary port.
   It depends on the states through which the node goes.
ring_state: depends on the ring_role. If mrp_ring_role is 1(MRC) then the values
   of mrp_ring_state can be: 0(AC_STAT1), 1(DE_IDLE), 2(PT), 3(DE), 4(PT_IDLE).
   If mrp_ring_role is 2(MRM) then the values of mrp_ring_state can be:
   0(AC_STAT1), 1(PRM_UP), 2(CHK_RO), 3(CHK_RC).

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/uapi/linux/if_bridge.h |  27 ++++
 include/uapi/linux/rtnetlink.h |   7 +
 net/bridge/br_mrp.c            | 281 +++++++++++++++++++++++++++++++++
 net/bridge/br_netlink.c        |   9 ++
 net/bridge/br_private.h        |   2 +
 net/bridge/br_private_mrp.h    |   9 ++
 security/selinux/nlmsgtab.c    |   5 +-
 7 files changed, 339 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 4a58e3d7de46..00f4f465d62a 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -265,6 +265,33 @@ enum {
 };
 #define MDBA_SET_ENTRY_MAX (__MDBA_SET_ENTRY_MAX - 1)
 
+#ifdef CONFIG_BRIDGE_MRP
+enum {
+	MRPA_UNSPEC,
+	MRPA_MRP,
+	__MRPA_MAX,
+};
+#define MRPA_MAX (__MRPA_MAX - 1)
+
+enum {
+	MRPA_MRP_UNSPEC,
+	MRPA_MRP_ENTRY,
+	__MRPA_MRP_MAX,
+};
+#define MRPA_MRP_MAX (__MRPA_MRP_MAX - 1)
+
+enum {
+	MRP_ATTR_UNSPEC,
+	MRP_ATTR_P_IFINDEX,
+	MRP_ATTR_S_IFINDEX,
+	MRP_ATTR_RING_ROLE,
+	MRP_ATTR_RING_NR,
+	MRP_ATTR_RING_STATE,
+	__MRP_ATTR_MAX,
+};
+#define MRP_ATTR_MAX (__MRP_ATTR_MAX - 1)
+#endif
+
 /* Embedded inside LINK_XSTATS_TYPE_BRIDGE */
 enum {
 	BRIDGE_XSTATS_UNSPEC,
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 1418a8362bb7..b1d72a5309cd 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -171,6 +171,13 @@ enum {
 	RTM_GETLINKPROP,
 #define RTM_GETLINKPROP	RTM_GETLINKPROP
 
+	RTM_NEWMRP = 112,
+#define RTM_NEWMRP	RTM_NEWMRP
+	RTM_DELMRP,
+#define RTM_DELMRP	RTM_DELMRP
+	RTM_GETMRP,
+#define RTM_GETMRP	RTM_GETMRP
+
 	__RTM_MAX,
 #define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
 };
diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index a84aab3f7114..4173021d3bfa 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -1234,3 +1234,284 @@ void br_mrp_port_uninit(struct net_bridge_port *port)
 
 	mutex_unlock(&mrp->lock);
 }
+
+/* Do sanity checks and obtain device and the ring */
+static int br_mrp_parse(struct sk_buff *skb, struct nlmsghdr *nlh,
+			struct net_device **pdev, struct br_mrp_config *conf)
+{
+	struct nlattr *tb[MRP_ATTR_MAX + 1];
+	struct net *net = sock_net(skb->sk);
+	struct br_port_msg *bpm;
+	struct net_device *dev;
+	int err;
+
+	err = nlmsg_parse_deprecated(nlh, sizeof(*bpm), tb,
+				     MRP_ATTR_MAX, NULL, NULL);
+	if (err < 0)
+		return err;
+
+	bpm = nlmsg_data(nlh);
+	if (bpm->ifindex == 0) {
+		pr_info("PF_BRIDGE: %s with invalid ifindex\n", __func__);
+		return -EINVAL;
+	}
+
+	dev = __dev_get_by_index(net, bpm->ifindex);
+	if (!dev) {
+		pr_info("PF_BRIDGE: %s with unknown ifindex\n", __func__);
+		return -ENODEV;
+	}
+
+	if (!(dev->priv_flags & IFF_EBRIDGE)) {
+		pr_info("PF_BRIDGE: %s with non-bridge\n", __func__);
+		return -EOPNOTSUPP;
+	}
+
+	*pdev = dev;
+
+	if (tb[MRP_ATTR_P_IFINDEX])
+		conf->p_ifindex = nla_get_u32(tb[MRP_ATTR_P_IFINDEX]);
+	if (tb[MRP_ATTR_S_IFINDEX])
+		conf->s_ifindex = nla_get_u32(tb[MRP_ATTR_S_IFINDEX]);
+	if (tb[MRP_ATTR_RING_ROLE])
+		conf->ring_role = nla_get_u8(tb[MRP_ATTR_RING_ROLE]);
+	if (tb[MRP_ATTR_RING_NR])
+		conf->ring_nr = nla_get_u8(tb[MRP_ATTR_RING_NR]);
+
+	return 0;
+}
+
+static int br_mrp_fill_entry(struct sk_buff *skb, struct netlink_callback *cb,
+			     struct net_device *dev)
+{
+	int idx = 0, s_idx = cb->args[1], err = 0;
+	struct net_bridge *br = netdev_priv(dev);
+	struct br_mrp *mrp;
+	struct nlattr *nest, *nest2;
+
+	nest = nla_nest_start_noflag(skb, MRPA_MRP);
+	if (!nest)
+		return -EMSGSIZE;
+
+	list_for_each_entry_rcu(mrp, &br->mrp_list, list) {
+		if (idx < s_idx)
+			goto skip;
+
+		nest2 = nla_nest_start_noflag(skb, MRPA_MRP_ENTRY);
+		if (!nest2) {
+			err = -EMSGSIZE;
+			mutex_unlock(&mrp->lock);
+			break;
+		}
+
+		mutex_lock(&mrp->lock);
+
+		if (mrp->p_port)
+			nla_put_u32(skb, MRP_ATTR_P_IFINDEX,
+				    mrp->p_port->dev->ifindex);
+		if (mrp->s_port)
+			nla_put_u32(skb, MRP_ATTR_S_IFINDEX,
+				    mrp->s_port->dev->ifindex);
+
+		nla_put_u32(skb, MRP_ATTR_RING_NR, mrp->ring_nr);
+		nla_put_u32(skb, MRP_ATTR_RING_ROLE, mrp->ring_role);
+
+		if (mrp->ring_role == BR_MRP_RING_ROLE_MRM)
+			nla_put_u32(skb, MRP_ATTR_RING_STATE, mrp->mrm_state);
+		if (mrp->ring_role == BR_MRP_RING_ROLE_MRC)
+			nla_put_u32(skb, MRP_ATTR_RING_STATE, mrp->mrc_state);
+
+		mutex_unlock(&mrp->lock);
+
+		nla_nest_end(skb, nest2);
+skip:
+		idx++;
+	}
+
+	cb->args[1] = idx;
+	nla_nest_end(skb, nest);
+	return err;
+}
+
+static int br_mrp_dump(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct net *net = sock_net(skb->sk);
+	struct nlmsghdr *nlh = NULL;
+	struct net_device *dev;
+	int idx = 0, s_idx;
+
+	s_idx = cb->args[0];
+
+	rcu_read_lock();
+
+	cb->seq = net->dev_base_seq;
+
+	for_each_netdev_rcu(net, dev) {
+		if (dev->priv_flags & IFF_EBRIDGE) {
+			struct br_port_msg *bpm;
+
+			if (idx < s_idx)
+				goto skip;
+
+			nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid,
+					cb->nlh->nlmsg_seq, RTM_GETMRP,
+					sizeof(*bpm), NLM_F_MULTI);
+			if (!nlh)
+				break;
+
+			bpm = nlmsg_data(nlh);
+			memset(bpm, 0, sizeof(*bpm));
+			bpm->ifindex = dev->ifindex;
+			if (br_mrp_fill_entry(skb, cb, dev) < 0)
+				goto out;
+
+			cb->args[1] = 0;
+			nlmsg_end(skb, nlh);
+skip:
+			idx++;
+		}
+	}
+
+out:
+	if (nlh)
+		nlmsg_end(skb, nlh);
+	rcu_read_unlock();
+	cb->args[0] = idx;
+	return skb->len;
+}
+
+static int br_mrp_add(struct sk_buff *skb, struct nlmsghdr *nlh,
+		      struct netlink_ext_ack *extack)
+{
+	struct net_bridge_port *p_port, *s_port;
+	struct net *net = sock_net(skb->sk);
+	enum br_mrp_ring_role_type role;
+	struct br_mrp_config conf;
+	struct net_device *dev;
+	struct net_bridge *br;
+	struct br_mrp *mrp;
+	u32 ring_nr;
+	int err;
+
+	err = br_mrp_parse(skb, nlh, &dev, &conf);
+	if (err < 0)
+		return err;
+
+	br = netdev_priv(dev);
+
+	/* Get priority and secondary ports */
+	dev = __dev_get_by_index(net, conf.p_ifindex);
+	if (!dev)
+		return -ENODEV;
+
+	p_port = br_port_get_rtnl(dev);
+	if (!p_port || p_port->br != br)
+		return -EINVAL;
+
+	dev = __dev_get_by_index(net, conf.s_ifindex);
+	if (!dev)
+		return -ENODEV;
+
+	s_port = br_port_get_rtnl(dev);
+	if (!s_port || s_port->br != br)
+		return -EINVAL;
+
+	/* Get role */
+	role = conf.ring_role;
+
+	/* Get ring number */
+	ring_nr = conf.ring_nr;
+
+	/* It is not possible to have MRP instances with the same ID */
+	mrp = br_mrp_find(br, ring_nr);
+	if (mrp)
+		return -EINVAL;
+
+	/* Create the mrp instance */
+	err = br_mrp_create(br, ring_nr);
+	if (err < 0)
+		return err;
+
+	mrp = br_mrp_find(br, ring_nr);
+
+	mutex_lock(&mrp->lock);
+
+	/* Initialize the ports */
+	err = br_mrp_port_init(p_port, mrp, BR_MRP_PORT_ROLE_PRIMARY);
+	if (err < 0) {
+		mutex_unlock(&mrp->lock);
+		goto delete_mrp;
+	}
+
+	err = br_mrp_port_init(s_port, mrp, BR_MRP_PORT_ROLE_SECONDARY);
+	if (err < 0) {
+		mutex_unlock(&mrp->lock);
+		goto delete_port;
+	}
+
+	if (role == BR_MRP_RING_ROLE_MRM)
+		br_mrp_set_mrm_role(mrp);
+	if (role == BR_MRP_RING_ROLE_MRC)
+		br_mrp_set_mrc_role(mrp);
+
+	mutex_unlock(&mrp->lock);
+
+	return 0;
+
+delete_port:
+	br_mrp_port_uninit(p_port);
+
+delete_mrp:
+	br_mrp_destroy(br, ring_nr);
+	return err;
+}
+
+static int br_mrp_del(struct sk_buff *skb, struct nlmsghdr *nlh,
+		      struct netlink_ext_ack *extack)
+{
+	struct br_mrp_config conf;
+	struct net_device *dev;
+	struct net_bridge *br;
+	struct br_mrp *mrp;
+	u32 ring_nr;
+	int err;
+
+	err = br_mrp_parse(skb, nlh, &dev, &conf);
+	if (err < 0)
+		return err;
+
+	br = netdev_priv(dev);
+
+	/* Get ring number */
+	ring_nr = conf.ring_nr;
+
+	mrp = br_mrp_find(br, ring_nr);
+	if (!mrp) {
+		pr_info("PF_BRIDGE: %s with invalid ring_nr\n", __func__);
+		return -EINVAL;
+	}
+
+	br_mrp_port_uninit(mrp->p_port);
+	br_mrp_port_uninit(mrp->s_port);
+
+	br_mrp_destroy(br, ring_nr);
+
+	return 0;
+}
+
+void br_mrp_netlink_init(void)
+{
+	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_GETMRP, NULL,
+			     br_mrp_dump, 0);
+	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_NEWMRP, br_mrp_add,
+			     NULL, 0);
+	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_DELMRP, br_mrp_del,
+			     NULL, 0);
+}
+
+void br_mrp_netlink_uninit(void)
+{
+	rtnl_unregister(PF_BRIDGE, RTM_GETMRP);
+	rtnl_unregister(PF_BRIDGE, RTM_NEWMRP);
+	rtnl_unregister(PF_BRIDGE, RTM_DELMRP);
+}
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 60136575aea4..6d8f84ed8b0d 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1664,6 +1664,9 @@ int __init br_netlink_init(void)
 	int err;
 
 	br_mdb_init();
+#ifdef CONFIG_BRIDGE_MRP
+	br_mrp_netlink_init();
+#endif
 	rtnl_af_register(&br_af_ops);
 
 	err = rtnl_link_register(&br_link_ops);
@@ -1674,12 +1677,18 @@ int __init br_netlink_init(void)
 
 out_af:
 	rtnl_af_unregister(&br_af_ops);
+#ifdef CONFIG_BRIDGE_MRP
+	br_mrp_netlink_uninit();
+#endif
 	br_mdb_uninit();
 	return err;
 }
 
 void br_netlink_fini(void)
 {
+#ifdef CONFIG_BRIDGE_MRP
+	br_mrp_netlink_uninit();
+#endif
 	br_mdb_uninit();
 	rtnl_af_unregister(&br_af_ops);
 	rtnl_link_unregister(&br_link_ops);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 0c008b3d24cc..9a060c3c7713 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1169,6 +1169,8 @@ unsigned long br_timer_value(const struct timer_list *timer);
 
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 /* br_mrp.c */
+void br_mrp_netlink_init(void);
+void br_mrp_netlink_uninit(void);
 void br_mrp_uninit(struct net_bridge *br);
 void br_mrp_port_uninit(struct net_bridge_port *p);
 void br_mrp_port_link_change(struct net_bridge_port *br, bool up);
diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
index 00ee20582ac9..13fd2330ccfc 100644
--- a/net/bridge/br_private_mrp.h
+++ b/net/bridge/br_private_mrp.h
@@ -174,6 +174,15 @@ struct br_mrp {
 	u16				react_on_link_change;
 };
 
+/* Represents the configuration of the MRP instance */
+struct br_mrp_config {
+	u32 p_ifindex;
+	u32 s_ifindex;
+	u32 ring_role;
+	u32 ring_nr;
+	u32 ring_state;
+};
+
 /* br_mrp.c */
 void br_mrp_ring_test_req(struct br_mrp *mrp, u32 interval);
 void br_mrp_ring_topo_req(struct br_mrp *mrp, u32 interval);
diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index c97fdae8f71b..7c110fdb9e1e 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -85,6 +85,9 @@ static const struct nlmsg_perm nlmsg_route_perms[] =
 	{ RTM_GETNEXTHOP,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
 	{ RTM_NEWLINKPROP,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_DELLINKPROP,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_NEWMRP,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_DELMRP,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_GETMRP,		NETLINK_ROUTE_SOCKET__NLMSG_READ  },
 };
 
 static const struct nlmsg_perm nlmsg_tcpdiag_perms[] =
@@ -168,7 +171,7 @@ int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm)
 		 * structures at the top of this file with the new mappings
 		 * before updating the BUILD_BUG_ON() macro!
 		 */
-		BUILD_BUG_ON(RTM_MAX != (RTM_NEWLINKPROP + 3));
+		BUILD_BUG_ON(RTM_MAX != (RTM_DELMRP + 3));
 		err = nlmsg_perm(nlmsg_type, perm, nlmsg_route_perms,
 				 sizeof(nlmsg_route_perms));
 		break;
-- 
2.17.1

