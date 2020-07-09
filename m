Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A2821958C
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 03:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgGIBSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 21:18:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726286AbgGIBSs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 21:18:48 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0A72207F9;
        Thu,  9 Jul 2020 01:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594257527;
        bh=VkpVswtOvMFkvArjmRpxUDbHJrC5PVjttQAM4u37lAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HiVqJR8SUn8vk4m1dmj2pAorEVml9Vg5DGoZQDD3bXlsoEDEaoXpH4qsAE+05bBZT
         6GP8UrKICLwGEHcfHF6k5loExplCLChUDrPnM0Pd4HidSC77SaSjHGN/QtTsZLOHlM
         G/91ZNMbATpvwFhnmj/u2CQB6rjMGuqSyskCfzA8=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 04/10] ethtool: add tunnel info interface
Date:   Wed,  8 Jul 2020 18:18:08 -0700
Message-Id: <20200709011814.4003186-5-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200709011814.4003186-1-kuba@kernel.org>
References: <20200709011814.4003186-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an interface to report offloaded UDP ports via ethtool netlink.

Now that core takes care of tracking which UDP tunnel ports the NICs
are aware of we can quite easily export this information out to
user space.

The responsibility of writing the netlink dumps is split between
ethtool code and udp_tunnel_nic.c - since udp_tunnel module may
not always be loaded, yet we should always report the capabilities
of the NIC.

$ ethtool --show-tunnels eth0
Tunnel information for eth0:
  UDP port table 0:
    Size: 4
    Types: vxlan
    No entries
  UDP port table 1:
    Size: 4
    Types: geneve, vxlan-gpe
    Entries (1):
        port 1230, vxlan-gpe

v2:
 - fix string set count,
 - reorder enums in the uAPI,
 - fix type of ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES to bitset
   in docs and comments.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/ethtool-netlink.rst |  33 +++
 include/net/udp_tunnel.h                     |  21 ++
 include/uapi/linux/ethtool.h                 |   2 +
 include/uapi/linux/ethtool_netlink.h         |  55 ++++
 net/ethtool/Makefile                         |   3 +-
 net/ethtool/common.c                         |   9 +
 net/ethtool/common.h                         |   1 +
 net/ethtool/netlink.c                        |  12 +
 net/ethtool/netlink.h                        |   4 +
 net/ethtool/strset.c                         |   5 +
 net/ethtool/tunnels.c                        | 259 +++++++++++++++++++
 net/ipv4/udp_tunnel_nic.c                    |  69 +++++
 12 files changed, 472 insertions(+), 1 deletion(-)
 create mode 100644 net/ethtool/tunnels.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 459a0d11cfde..7d75f1e32152 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1230,6 +1230,39 @@ used to report the amplitude of the reflection for a given pair.
  | | | ``ETHTOOL_A_CABLE_AMPLITUDE_mV``        | s16    | Reflection amplitude |
  +-+-+-----------------------------------------+--------+----------------------+
 
+TUNNEL_INFO
+===========
+
+Gets information about the tunnel state NIC is aware of.
+
+Request contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_TUNNEL_INFO_HEADER``       nested  request header
+  =====================================  ======  ==========================
+
+Kernel response contents:
+
+ +---------------------------------------------+--------+---------------------+
+ | ``ETHTOOL_A_TUNNEL_INFO_HEADER``            | nested | reply header        |
+ +---------------------------------------------+--------+---------------------+
+ | ``ETHTOOL_A_TUNNEL_INFO_UDP_PORTS``         | nested | all UDP port tables |
+ +-+-------------------------------------------+--------+---------------------+
+ | | ``ETHTOOL_A_TUNNEL_UDP_TABLE``            | nested | one UDP port table  |
+ +-+-+-----------------------------------------+--------+---------------------+
+ | | | ``ETHTOOL_A_TUNNEL_UDP_TABLE_SIZE``     | u32    | max size of the     |
+ | | |                                         |        | table               |
+ +-+-+-----------------------------------------+--------+---------------------+
+ | | | ``ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES``    | bitset | tunnel types which  |
+ | | |                                         |        | table can hold      |
+ +-+-+-----------------------------------------+--------+---------------------+
+ | | | ``ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY``    | nested | offloaded UDP port  |
+ +-+-+-+---------------------------------------+--------+---------------------+
+ | | | | ``ETHTOOL_A_TUNNEL_UDP_ENTRY_PORT``   | be16   | UDP port            |
+ +-+-+-+---------------------------------------+--------+---------------------+
+ | | | | ``ETHTOOL_A_TUNNEL_UDP_ENTRY_TYPE``   | u32    | tunnel type         |
+ +-+-+-+---------------------------------------+--------+---------------------+
+
 Request translation
 ===================
 
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index d0ff40d9cfd7..bc9b483fd47e 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -255,6 +255,10 @@ struct udp_tunnel_nic_ops {
 	void (*add_port)(struct net_device *dev, struct udp_tunnel_info *ti);
 	void (*del_port)(struct net_device *dev, struct udp_tunnel_info *ti);
 	void (*reset_ntf)(struct net_device *dev);
+
+	size_t (*dump_size)(struct net_device *dev, unsigned int table);
+	int (*dump_write)(struct net_device *dev, unsigned int table,
+			  struct sk_buff *skb);
 };
 
 extern const struct udp_tunnel_nic_ops *udp_tunnel_nic_ops;
@@ -306,4 +310,21 @@ static inline void udp_tunnel_nic_reset_ntf(struct net_device *dev)
 	if (udp_tunnel_nic_ops)
 		udp_tunnel_nic_ops->reset_ntf(dev);
 }
+
+static inline size_t
+udp_tunnel_nic_dump_size(struct net_device *dev, unsigned int table)
+{
+	if (!udp_tunnel_nic_ops)
+		return 0;
+	return udp_tunnel_nic_ops->dump_size(dev, table);
+}
+
+static inline int
+udp_tunnel_nic_dump_write(struct net_device *dev, unsigned int table,
+			  struct sk_buff *skb)
+{
+	if (!udp_tunnel_nic_ops)
+		return 0;
+	return udp_tunnel_nic_ops->dump_write(dev, table, skb);
+}
 #endif
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index d1413538ef30..0495314ce20b 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -669,6 +669,7 @@ enum ethtool_link_ext_substate_cable_issue {
  * @ETH_SS_SOF_TIMESTAMPING: SOF_TIMESTAMPING_* flags
  * @ETH_SS_TS_TX_TYPES: timestamping Tx types
  * @ETH_SS_TS_RX_FILTERS: timestamping Rx filters
+ * @ETH_SS_UDP_TUNNEL_TYPES: UDP tunnel types
  */
 enum ethtool_stringset {
 	ETH_SS_TEST		= 0,
@@ -686,6 +687,7 @@ enum ethtool_stringset {
 	ETH_SS_SOF_TIMESTAMPING,
 	ETH_SS_TS_TX_TYPES,
 	ETH_SS_TS_RX_FILTERS,
+	ETH_SS_UDP_TUNNEL_TYPES,
 
 	/* add new constants above here */
 	ETH_SS_COUNT
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index c12ce4df4b6b..5dcd24cb33ea 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -41,6 +41,7 @@ enum {
 	ETHTOOL_MSG_TSINFO_GET,
 	ETHTOOL_MSG_CABLE_TEST_ACT,
 	ETHTOOL_MSG_CABLE_TEST_TDR_ACT,
+	ETHTOOL_MSG_TUNNEL_INFO_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -556,6 +557,60 @@ enum {
 	ETHTOOL_A_CABLE_TEST_TDR_NTF_MAX = __ETHTOOL_A_CABLE_TEST_TDR_NTF_CNT - 1
 };
 
+/* TUNNEL INFO */
+
+enum {
+	ETHTOOL_UDP_TUNNEL_TYPE_VXLAN,
+	ETHTOOL_UDP_TUNNEL_TYPE_GENEVE,
+	ETHTOOL_UDP_TUNNEL_TYPE_VXLAN_GPE,
+
+	__ETHTOOL_UDP_TUNNEL_TYPE_CNT
+};
+
+enum {
+	ETHTOOL_A_TUNNEL_UDP_ENTRY_UNSPEC,
+
+	ETHTOOL_A_TUNNEL_UDP_ENTRY_PORT,		/* be16 */
+	ETHTOOL_A_TUNNEL_UDP_ENTRY_TYPE,		/* u32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_TUNNEL_UDP_ENTRY_CNT,
+	ETHTOOL_A_TUNNEL_UDP_ENTRY_MAX = (__ETHTOOL_A_TUNNEL_UDP_ENTRY_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_TUNNEL_UDP_TABLE_UNSPEC,
+
+	ETHTOOL_A_TUNNEL_UDP_TABLE_SIZE,		/* u32 */
+	ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES,		/* bitset */
+	ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY,		/* nest - _UDP_ENTRY_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_TUNNEL_UDP_TABLE_CNT,
+	ETHTOOL_A_TUNNEL_UDP_TABLE_MAX = (__ETHTOOL_A_TUNNEL_UDP_TABLE_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_TUNNEL_UDP_UNSPEC,
+
+	ETHTOOL_A_TUNNEL_UDP_TABLE,			/* nest - _UDP_TABLE_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_TUNNEL_UDP_CNT,
+	ETHTOOL_A_TUNNEL_UDP_MAX = (__ETHTOOL_A_TUNNEL_UDP_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_TUNNEL_INFO_UNSPEC,
+	ETHTOOL_A_TUNNEL_INFO_HEADER,			/* nest - _A_HEADER_* */
+
+	ETHTOOL_A_TUNNEL_INFO_UDP_PORTS,		/* nest - _UDP_TABLE */
+
+	/* add new constants above here */
+	__ETHTOOL_A_TUNNEL_INFO_CNT,
+	ETHTOOL_A_TUNNEL_INFO_MAX = (__ETHTOOL_A_TUNNEL_INFO_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 0c2b94f20499..7a849ff22dad 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -6,4 +6,5 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
-		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o
+		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
+		   tunnels.o
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index ce4dbae5a943..884586453d57 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <linux/ethtool_netlink.h>
 #include <linux/net_tstamp.h>
 #include <linux/phy.h>
 #include <linux/rtnetlink.h>
@@ -257,6 +258,14 @@ const char ts_rx_filter_names[][ETH_GSTRING_LEN] = {
 };
 static_assert(ARRAY_SIZE(ts_rx_filter_names) == __HWTSTAMP_FILTER_CNT);
 
+const char udp_tunnel_type_names[][ETH_GSTRING_LEN] = {
+	[ETHTOOL_UDP_TUNNEL_TYPE_VXLAN]		= "vxlan",
+	[ETHTOOL_UDP_TUNNEL_TYPE_GENEVE]	= "geneve",
+	[ETHTOOL_UDP_TUNNEL_TYPE_VXLAN_GPE]	= "vxlan-gpe",
+};
+static_assert(ARRAY_SIZE(udp_tunnel_type_names) ==
+	      __ETHTOOL_UDP_TUNNEL_TYPE_CNT);
+
 /* return false if legacy contained non-0 deprecated fields
  * maxtxpkt/maxrxpkt. rest of ksettings always updated
  */
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index b83bef38368c..3d9251c95a8b 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -28,6 +28,7 @@ extern const char wol_mode_names[][ETH_GSTRING_LEN];
 extern const char sof_timestamping_names[][ETH_GSTRING_LEN];
 extern const char ts_tx_type_names[][ETH_GSTRING_LEN];
 extern const char ts_rx_filter_names[][ETH_GSTRING_LEN];
+extern const char udp_tunnel_type_names[][ETH_GSTRING_LEN];
 
 int __ethtool_get_link(struct net_device *dev);
 
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 88fd07f47040..fb9d096faaa4 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -181,6 +181,12 @@ struct sk_buff *ethnl_reply_init(size_t payload, struct net_device *dev, u8 cmd,
 	return NULL;
 }
 
+void *ethnl_dump_put(struct sk_buff *skb, struct netlink_callback *cb, u8 cmd)
+{
+	return genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			   &ethtool_genl_family, 0, cmd);
+}
+
 void *ethnl_bcastmsg_put(struct sk_buff *skb, u8 cmd)
 {
 	return genlmsg_put(skb, 0, ++ethnl_bcast_seq, &ethtool_genl_family, 0,
@@ -849,6 +855,12 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_act_cable_test_tdr,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_TUNNEL_INFO_GET,
+		.doit	= ethnl_tunnel_info_doit,
+		.start	= ethnl_tunnel_info_start,
+		.dumpit	= ethnl_tunnel_info_dumpit,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 9a96b6e90dc2..e2085005caac 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -19,6 +19,7 @@ int ethnl_fill_reply_header(struct sk_buff *skb, struct net_device *dev,
 struct sk_buff *ethnl_reply_init(size_t payload, struct net_device *dev, u8 cmd,
 				 u16 hdr_attrtype, struct genl_info *info,
 				 void **ehdrp);
+void *ethnl_dump_put(struct sk_buff *skb, struct netlink_callback *cb, u8 cmd);
 void *ethnl_bcastmsg_put(struct sk_buff *skb, u8 cmd);
 int ethnl_multicast(struct sk_buff *skb, struct net_device *dev);
 
@@ -361,5 +362,8 @@ int ethnl_set_pause(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_eee(struct sk_buff *skb, struct genl_info *info);
 int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info);
 int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info);
+int ethnl_tunnel_info_doit(struct sk_buff *skb, struct genl_info *info);
+int ethnl_tunnel_info_start(struct netlink_callback *cb);
+int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 773634b6b048..82707b662fe4 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -75,6 +75,11 @@ static const struct strset_info info_template[] = {
 		.count		= __HWTSTAMP_FILTER_CNT,
 		.strings	= ts_rx_filter_names,
 	},
+	[ETH_SS_UDP_TUNNEL_TYPES] = {
+		.per_dev	= false,
+		.count		= __ETHTOOL_UDP_TUNNEL_TYPE_CNT,
+		.strings	= udp_tunnel_type_names,
+	},
 };
 
 struct strset_req_info {
diff --git a/net/ethtool/tunnels.c b/net/ethtool/tunnels.c
new file mode 100644
index 000000000000..6b89255f1231
--- /dev/null
+++ b/net/ethtool/tunnels.c
@@ -0,0 +1,259 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/ethtool_netlink.h>
+#include <net/udp_tunnel.h>
+
+#include "bitset.h"
+#include "common.h"
+#include "netlink.h"
+
+static const struct nla_policy
+ethtool_tunnel_info_policy[ETHTOOL_A_TUNNEL_INFO_MAX + 1] = {
+	[ETHTOOL_A_TUNNEL_INFO_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_TUNNEL_INFO_HEADER]		= { .type = NLA_NESTED },
+};
+
+static_assert(ETHTOOL_UDP_TUNNEL_TYPE_VXLAN == ilog2(UDP_TUNNEL_TYPE_VXLAN));
+static_assert(ETHTOOL_UDP_TUNNEL_TYPE_GENEVE == ilog2(UDP_TUNNEL_TYPE_GENEVE));
+static_assert(ETHTOOL_UDP_TUNNEL_TYPE_VXLAN_GPE ==
+	      ilog2(UDP_TUNNEL_TYPE_VXLAN_GPE));
+
+static ssize_t
+ethnl_tunnel_info_reply_size(const struct ethnl_req_info *req_base,
+			     struct netlink_ext_ack *extack)
+{
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	const struct udp_tunnel_nic_info *info;
+	unsigned int i;
+	size_t size;
+	int ret;
+
+	info = req_base->dev->udp_tunnel_nic_info;
+	if (!info) {
+		NL_SET_ERR_MSG(extack,
+			       "device does not report tunnel offload info");
+		return -EOPNOTSUPP;
+	}
+
+	size =	nla_total_size(0); /* _INFO_UDP_PORTS */
+
+	for (i = 0; i < UDP_TUNNEL_NIC_MAX_TABLES; i++) {
+		if (!info->tables[i].n_entries)
+			return size;
+
+		size += nla_total_size(0); /* _UDP_TABLE */
+		size +=	nla_total_size(sizeof(u32)); /* _UDP_TABLE_SIZE */
+		ret = ethnl_bitset32_size(&info->tables[i].tunnel_types, NULL,
+					  __ETHTOOL_UDP_TUNNEL_TYPE_CNT,
+					  udp_tunnel_type_names, compact);
+		if (ret < 0)
+			return ret;
+		size += ret;
+
+		size += udp_tunnel_nic_dump_size(req_base->dev, i);
+	}
+
+	return size;
+}
+
+static int
+ethnl_tunnel_info_fill_reply(const struct ethnl_req_info *req_base,
+			     struct sk_buff *skb)
+{
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	const struct udp_tunnel_nic_info *info;
+	struct nlattr *ports, *table;
+	unsigned int i;
+
+	info = req_base->dev->udp_tunnel_nic_info;
+	if (!info)
+		return -EOPNOTSUPP;
+
+	ports = nla_nest_start(skb, ETHTOOL_A_TUNNEL_INFO_UDP_PORTS);
+	if (!ports)
+		return -EMSGSIZE;
+
+	for (i = 0; i < UDP_TUNNEL_NIC_MAX_TABLES; i++) {
+		if (!info->tables[i].n_entries)
+			break;
+
+		table = nla_nest_start(skb, ETHTOOL_A_TUNNEL_UDP_TABLE);
+		if (!table)
+			goto err_cancel_ports;
+
+		if (nla_put_u32(skb, ETHTOOL_A_TUNNEL_UDP_TABLE_SIZE,
+				info->tables[i].n_entries))
+			goto err_cancel_table;
+
+		if (ethnl_put_bitset32(skb, ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES,
+				       &info->tables[i].tunnel_types, NULL,
+				       __ETHTOOL_UDP_TUNNEL_TYPE_CNT,
+				       udp_tunnel_type_names, compact))
+			goto err_cancel_table;
+
+		if (udp_tunnel_nic_dump_write(req_base->dev, i, skb))
+			goto err_cancel_table;
+
+		nla_nest_end(skb, table);
+	}
+
+	nla_nest_end(skb, ports);
+
+	return 0;
+
+err_cancel_table:
+	nla_nest_cancel(skb, table);
+err_cancel_ports:
+	nla_nest_cancel(skb, ports);
+	return -EMSGSIZE;
+}
+
+static int
+ethnl_tunnel_info_req_parse(struct ethnl_req_info *req_info,
+			    const struct nlmsghdr *nlhdr, struct net *net,
+			    struct netlink_ext_ack *extack, bool require_dev)
+{
+	struct nlattr *tb[ETHTOOL_A_TUNNEL_INFO_MAX + 1];
+	int ret;
+
+	ret = nlmsg_parse(nlhdr, GENL_HDRLEN, tb, ETHTOOL_A_TUNNEL_INFO_MAX,
+			  ethtool_tunnel_info_policy, extack);
+	if (ret < 0)
+		return ret;
+
+	return ethnl_parse_header_dev_get(req_info,
+					  tb[ETHTOOL_A_TUNNEL_INFO_HEADER],
+					  net, extack, require_dev);
+}
+
+int ethnl_tunnel_info_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct ethnl_req_info req_info = {};
+	struct sk_buff *rskb;
+	void *reply_payload;
+	int reply_len;
+	int ret;
+
+	ret = ethnl_tunnel_info_req_parse(&req_info, info->nlhdr,
+					  genl_info_net(info), info->extack,
+					  true);
+	if (ret < 0)
+		return ret;
+
+	rtnl_lock();
+	ret = ethnl_tunnel_info_reply_size(&req_info, info->extack);
+	if (ret < 0)
+		goto err_unlock_rtnl;
+	reply_len = ret + ethnl_reply_header_size();
+
+	rskb = ethnl_reply_init(reply_len, req_info.dev,
+				ETHTOOL_MSG_TUNNEL_INFO_GET,
+				ETHTOOL_A_TUNNEL_INFO_HEADER,
+				info, &reply_payload);
+	if (!rskb) {
+		ret = -ENOMEM;
+		goto err_unlock_rtnl;
+	}
+
+	ret = ethnl_tunnel_info_fill_reply(&req_info, rskb);
+	if (ret)
+		goto err_free_msg;
+	rtnl_unlock();
+	dev_put(req_info.dev);
+	genlmsg_end(rskb, reply_payload);
+
+	return genlmsg_reply(rskb, info);
+
+err_free_msg:
+	nlmsg_free(rskb);
+err_unlock_rtnl:
+	rtnl_unlock();
+	dev_put(req_info.dev);
+	return ret;
+}
+
+struct ethnl_tunnel_info_dump_ctx {
+	struct ethnl_req_info	req_info;
+	int			pos_hash;
+	int			pos_idx;
+};
+
+int ethnl_tunnel_info_start(struct netlink_callback *cb)
+{
+	struct ethnl_tunnel_info_dump_ctx *ctx = (void *)cb->ctx;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
+
+	memset(ctx, 0, sizeof(*ctx));
+
+	ret = ethnl_tunnel_info_req_parse(&ctx->req_info, cb->nlh,
+					  sock_net(cb->skb->sk), cb->extack,
+					  false);
+	if (ctx->req_info.dev) {
+		dev_put(ctx->req_info.dev);
+		ctx->req_info.dev = NULL;
+	}
+
+	return ret;
+}
+
+int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct ethnl_tunnel_info_dump_ctx *ctx = (void *)cb->ctx;
+	struct net *net = sock_net(skb->sk);
+	int s_idx = ctx->pos_idx;
+	int h, idx = 0;
+	int ret = 0;
+	void *ehdr;
+
+	rtnl_lock();
+	cb->seq = net->dev_base_seq;
+	for (h = ctx->pos_hash; h < NETDEV_HASHENTRIES; h++, s_idx = 0) {
+		struct hlist_head *head;
+		struct net_device *dev;
+
+		head = &net->dev_index_head[h];
+		idx = 0;
+		hlist_for_each_entry(dev, head, index_hlist) {
+			if (idx < s_idx)
+				goto cont;
+
+			ehdr = ethnl_dump_put(skb, cb,
+					      ETHTOOL_MSG_TUNNEL_INFO_GET);
+			if (!ehdr) {
+				ret = -EMSGSIZE;
+				goto out;
+			}
+
+			ret = ethnl_fill_reply_header(skb, dev, ETHTOOL_A_TUNNEL_INFO_HEADER);
+			if (ret < 0) {
+				genlmsg_cancel(skb, ehdr);
+				goto out;
+			}
+
+			ctx->req_info.dev = dev;
+			ret = ethnl_tunnel_info_fill_reply(&ctx->req_info, skb);
+			ctx->req_info.dev = NULL;
+			if (ret < 0) {
+				genlmsg_cancel(skb, ehdr);
+				if (ret == -EOPNOTSUPP)
+					goto cont;
+				goto out;
+			}
+			genlmsg_end(skb, ehdr);
+cont:
+			idx++;
+		}
+	}
+out:
+	rtnl_unlock();
+
+	ctx->pos_hash = h;
+	ctx->pos_idx = idx;
+	nl_dump_check_consistent(cb, nlmsg_hdr(skb));
+
+	if (ret == -EMSGSIZE && skb->len)
+		return skb->len;
+	return ret;
+}
diff --git a/net/ipv4/udp_tunnel_nic.c b/net/ipv4/udp_tunnel_nic.c
index 098fb0ebe998..687c94447d5e 100644
--- a/net/ipv4/udp_tunnel_nic.c
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 // Copyright (c) 2020 Facebook Inc.
 
+#include <linux/ethtool_netlink.h>
 #include <linux/netdevice.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -72,6 +73,12 @@ udp_tunnel_nic_entry_is_free(struct udp_tunnel_nic_table_entry *entry)
 	return entry->use_cnt == 0 && !entry->flags;
 }
 
+static bool
+udp_tunnel_nic_entry_is_present(struct udp_tunnel_nic_table_entry *entry)
+{
+	return entry->use_cnt && !(entry->flags & ~UDP_TUNNEL_NIC_ENTRY_FROZEN);
+}
+
 static bool
 udp_tunnel_nic_entry_is_frozen(struct udp_tunnel_nic_table_entry *entry)
 {
@@ -571,12 +578,74 @@ static void __udp_tunnel_nic_reset_ntf(struct net_device *dev)
 	__udp_tunnel_nic_device_sync(dev, utn);
 }
 
+static size_t
+__udp_tunnel_nic_dump_size(struct net_device *dev, unsigned int table)
+{
+	const struct udp_tunnel_nic_info *info = dev->udp_tunnel_nic_info;
+	struct udp_tunnel_nic *utn;
+	unsigned int j;
+	size_t size;
+
+	utn = dev->udp_tunnel_nic;
+	if (!utn)
+		return 0;
+
+	size = 0;
+	for (j = 0; j < info->tables[table].n_entries; j++) {
+		if (!udp_tunnel_nic_entry_is_present(&utn->entries[table][j]))
+			continue;
+
+		size += nla_total_size(0) +		 /* _TABLE_ENTRY */
+			nla_total_size(sizeof(__be16)) + /* _ENTRY_PORT */
+			nla_total_size(sizeof(u32));	 /* _ENTRY_TYPE */
+	}
+
+	return size;
+}
+
+static int
+__udp_tunnel_nic_dump_write(struct net_device *dev, unsigned int table,
+			    struct sk_buff *skb)
+{
+	const struct udp_tunnel_nic_info *info = dev->udp_tunnel_nic_info;
+	struct udp_tunnel_nic *utn;
+	struct nlattr *nest;
+	unsigned int j;
+
+	utn = dev->udp_tunnel_nic;
+	if (!utn)
+		return 0;
+
+	for (j = 0; j < info->tables[table].n_entries; j++) {
+		if (!udp_tunnel_nic_entry_is_present(&utn->entries[table][j]))
+			continue;
+
+		nest = nla_nest_start(skb, ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY);
+
+		if (nla_put_be16(skb, ETHTOOL_A_TUNNEL_UDP_ENTRY_PORT,
+				 utn->entries[table][j].port) ||
+		    nla_put_u32(skb, ETHTOOL_A_TUNNEL_UDP_ENTRY_TYPE,
+				ilog2(utn->entries[table][j].type)))
+			goto err_cancel;
+
+		nla_nest_end(skb, nest);
+	}
+
+	return 0;
+
+err_cancel:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
 static const struct udp_tunnel_nic_ops __udp_tunnel_nic_ops = {
 	.get_port	= __udp_tunnel_nic_get_port,
 	.set_port_priv	= __udp_tunnel_nic_set_port_priv,
 	.add_port	= __udp_tunnel_nic_add_port,
 	.del_port	= __udp_tunnel_nic_del_port,
 	.reset_ntf	= __udp_tunnel_nic_reset_ntf,
+	.dump_size	= __udp_tunnel_nic_dump_size,
+	.dump_write	= __udp_tunnel_nic_dump_write,
 };
 
 static void
-- 
2.26.2

