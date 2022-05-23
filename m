Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03FB531040
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbiEWKnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234154AbiEWKnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:43:25 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F0A101CD
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:23 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id h11so17391829eda.8
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1f4qwhCWad2RUVSkCmBNNn90N38xaiuIXetdHY6xBWs=;
        b=NqCu0zYA6D31IXeEsV3Rey/23Gnc0ApE59WJKR+VUByC7W1fwbuLDRc+PK/uJBCQEQ
         RO/vhDhZxCIGX+5/JshDqmK5VDvbEYyJk3dP9j+eHtTKyJa3AyBR+5wkHBlxQ/Qg/RA9
         be3yu2/kvYH6YVvAKDhyttHRXXD3CcBIumlmbK5DFRagHhJSIxH1Ows1RAL44KjWJmCB
         GFVw5NWNxvozBvSsSiDNcpTlVj6/MtgHUaYSnghM5n1BHgHh9jYUD6e1lxUbLmuG+5R0
         6AaRNXAw50P2/1kG/OfuFug4Op8V2EGg35l3NEi1fuepPh9nwhAxwZq9fwfd4bbsFvqC
         mnAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1f4qwhCWad2RUVSkCmBNNn90N38xaiuIXetdHY6xBWs=;
        b=vShQeO5Invr//nkOHpprUAXJRXx4+TjjPWnFwlKvoVbGQ9MbcQj5PT9KRoS/YMjl7K
         xc+vNMIkloeMXKbpjlWLoKH4Hspuyxz6Imi05pHjknvGNp1u+OlPtGXjf7eC51ORVe45
         NtWdsQB6IeHVChueJnY6K2vHzttP+F8yRxPZuZweEzekq94u2gqZdAUzhf0xhRrz5q5W
         3cwp/0cC9DHlcKr3gzafqJuC6j7DECCPnwCtcoF1eegwQeFmkPQDeTUVYuD3hQdSxZVD
         3/24D1o1AVwx/wDb2+1ghUebZSbTh9Fkl+sADrP1nFMYUsdPjmXLkpiH0nqtavaaz60K
         bRdA==
X-Gm-Message-State: AOAM530ytirU0P9so53qKDXhB1dSUX5GfLI3MI2rrahacN2eQScaHNBZ
        t64gO3RGRa7l2B5Iz5PNxO3/8yGX8O4=
X-Google-Smtp-Source: ABdhPJzVFEyh4oPX/mXm9+acpyP6gOdAQ6uK1JbuzJjXm10ISbixB7pfqYOTat4q/ci+vOUDZzrU4Q==
X-Received: by 2002:a05:6402:293:b0:42a:aece:5c5c with SMTP id l19-20020a056402029300b0042aaece5c5cmr23136984edv.108.1653302601425;
        Mon, 23 May 2022 03:43:21 -0700 (PDT)
Received: from localhost.localdomain ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id j18-20020a1709066dd200b006feb875503fsm2584822ejt.78.2022.05.23.03.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 03:43:20 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 10/12] net: dsa: allow the DSA master to be seen and changed through rtnetlink
Date:   Mon, 23 May 2022 13:42:54 +0300
Message-Id: <20220523104256.3556016-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220523104256.3556016-1-olteanv@gmail.com>
References: <20220523104256.3556016-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Some DSA switches have multiple CPU ports, which can be used to improve
CPU termination throughput, but DSA, through dsa_tree_setup_cpu_ports(),
sets up only the first one, leading to suboptimal use of hardware.

The desire is to not change the default configuration but to permit the
user to create a dynamic mapping between individual user ports and the
CPU port that they are served by, configurable through rtnetlink. It is
also intended to permit load balancing between CPU ports, and in that
case, the foreseen model is for the DSA master to be a bonding interface
whose lowers are the physical DSA masters.

To that end, we create a struct rtnl_link_ops for DSA user ports with
the "dsa" kind. We expose the IFLA_DSA_MASTER link attribute that
contains the ifindex of the newly desired DSA master.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h            |   8 +++
 include/uapi/linux/if_link.h |  10 +++
 net/dsa/Makefile             |  10 ++-
 net/dsa/dsa.c                |   9 +++
 net/dsa/dsa2.c               |  14 ++++
 net/dsa/dsa_priv.h           |  10 +++
 net/dsa/master.c             |   1 +
 net/dsa/netlink.c            |  62 ++++++++++++++++
 net/dsa/port.c               | 133 +++++++++++++++++++++++++++++++++++
 net/dsa/slave.c              | 117 ++++++++++++++++++++++++++++++
 10 files changed, 373 insertions(+), 1 deletion(-)
 create mode 100644 net/dsa/netlink.c

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 7f6ca944c092..0958ad3289c9 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -555,6 +555,10 @@ static inline bool dsa_is_user_port(struct dsa_switch *ds, int p)
 	list_for_each_entry((_dp), &(_dst)->ports, list) \
 		if (dsa_port_is_user((_dp)))
 
+#define dsa_tree_for_each_user_port_continue_reverse(_dp, _dst) \
+	list_for_each_entry_continue_reverse((_dp), &(_dst)->ports, list) \
+		if (dsa_port_is_user((_dp)))
+
 #define dsa_tree_for_each_cpu_port(_dp, _dst) \
 	list_for_each_entry((_dp), &(_dst)->ports, list) \
 		if (dsa_port_is_cpu((_dp)))
@@ -826,6 +830,10 @@ struct dsa_switch_ops {
 	int	(*connect_tag_protocol)(struct dsa_switch *ds,
 					enum dsa_tag_protocol proto);
 
+	int	(*port_change_master)(struct dsa_switch *ds, int port,
+				      struct net_device *master,
+				      struct netlink_ext_ack *extack);
+
 	/* Optional switch-wide initialization and destruction methods */
 	int	(*setup)(struct dsa_switch *ds);
 	void	(*teardown)(struct dsa_switch *ds);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 5f58dcfe2787..f0a7797924ea 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1373,4 +1373,14 @@ enum {
 
 #define IFLA_MCTP_MAX (__IFLA_MCTP_MAX - 1)
 
+/* DSA section */
+
+enum {
+	IFLA_DSA_UNSPEC,
+	IFLA_DSA_MASTER,
+	__IFLA_DSA_MAX,
+};
+
+#define IFLA_DSA_MAX	(__IFLA_DSA_MAX - 1)
+
 #endif /* _UAPI_LINUX_IF_LINK_H */
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 9f75820e7c98..d0ed170bb7aa 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -1,7 +1,15 @@
 # SPDX-License-Identifier: GPL-2.0
 # the core
 obj-$(CONFIG_NET_DSA) += dsa_core.o
-dsa_core-y += dsa.o dsa2.o master.o port.o slave.o switch.o tag_8021q.o
+dsa_core-y += \
+	dsa.o \
+	dsa2.o \
+	master.o \
+	netlink.o \
+	port.o \
+	slave.o \
+	switch.o \
+	tag_8021q.o
 
 # tagging formats
 obj-$(CONFIG_NET_DSA_TAG_AR9331) += tag_ar9331.o
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index be7b320cda76..64b14f655b23 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -536,8 +536,16 @@ static int __init dsa_init_module(void)
 	dsa_tag_driver_register(&DSA_TAG_DRIVER_NAME(none_ops),
 				THIS_MODULE);
 
+	rc = rtnl_link_register(&dsa_link_ops);
+	if (rc)
+		goto netlink_register_fail;
+
 	return 0;
 
+netlink_register_fail:
+	dsa_tag_driver_unregister(&DSA_TAG_DRIVER_NAME(none_ops));
+	dsa_slave_unregister_notifier();
+	dev_remove_pack(&dsa_pack_type);
 register_notifier_fail:
 	destroy_workqueue(dsa_owq);
 
@@ -547,6 +555,7 @@ module_init(dsa_init_module);
 
 static void __exit dsa_cleanup_module(void)
 {
+	rtnl_link_unregister(&dsa_link_ops);
 	dsa_tag_driver_unregister(&DSA_TAG_DRIVER_NAME(none_ops));
 
 	dsa_slave_unregister_notifier();
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 8ff5467ac3e2..32d5a5413bb9 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -386,6 +386,20 @@ static struct dsa_port *dsa_tree_find_first_cpu(struct dsa_switch_tree *dst)
 	return NULL;
 }
 
+struct net_device *dsa_tree_find_first_master(struct dsa_switch_tree *dst)
+{
+	struct device_node *ethernet;
+	struct net_device *master;
+	struct dsa_port *cpu_dp;
+
+	cpu_dp = dsa_tree_find_first_cpu(dst);
+	ethernet = of_parse_phandle(cpu_dp->dn, "ethernet", 0);
+	master = of_find_net_device_by_node(ethernet);
+	of_node_put(ethernet);
+
+	return master;
+}
+
 /* Assign the default CPU port (the first one in the tree) to all ports of the
  * fabric which don't already have one as part of their own switch.
  */
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index f3562cef32ad..1ce0e48d5a92 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -200,6 +200,9 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 	return NULL;
 }
 
+/* netlink.c */
+extern struct rtnl_link_ops dsa_link_ops __read_mostly;
+
 /* port.c */
 void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
 			       const struct dsa_device_ops *tag_ops);
@@ -292,6 +295,8 @@ void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
 int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast);
 void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid, bool broadcast);
 void dsa_port_set_host_flood(struct dsa_port *dp, bool uc, bool mc);
+int dsa_port_change_master(struct dsa_port *dp, struct net_device *master,
+			   struct netlink_ext_ack *extack);
 
 /* slave.c */
 extern const struct dsa_device_ops notag_netdev_ops;
@@ -305,8 +310,12 @@ int dsa_slave_suspend(struct net_device *slave_dev);
 int dsa_slave_resume(struct net_device *slave_dev);
 int dsa_slave_register_notifier(void);
 void dsa_slave_unregister_notifier(void);
+void dsa_slave_sync_ha(struct net_device *dev);
+void dsa_slave_unsync_ha(struct net_device *dev);
 void dsa_slave_setup_tagger(struct net_device *slave);
 int dsa_slave_change_mtu(struct net_device *dev, int new_mtu);
+int dsa_slave_change_master(struct net_device *dev, struct net_device *master,
+			    struct netlink_ext_ack *extack);
 int dsa_slave_manage_vlan_filtering(struct net_device *dev,
 				    bool vlan_filtering);
 
@@ -542,6 +551,7 @@ void dsa_lag_map(struct dsa_switch_tree *dst, struct dsa_lag *lag);
 void dsa_lag_unmap(struct dsa_switch_tree *dst, struct dsa_lag *lag);
 struct dsa_lag *dsa_tree_lag_find(struct dsa_switch_tree *dst,
 				  const struct net_device *lag_dev);
+struct net_device *dsa_tree_find_first_master(struct dsa_switch_tree *dst);
 int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
 int dsa_broadcast(unsigned long e, void *v);
 int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 32c0a00a8b92..a7420bad0a0a 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -6,6 +6,7 @@
  *	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
  */
 
+#include <linux/of_net.h>
 #include "dsa_priv.h"
 
 static int dsa_master_get_regs_len(struct net_device *dev)
diff --git a/net/dsa/netlink.c b/net/dsa/netlink.c
new file mode 100644
index 000000000000..0f43bbb94769
--- /dev/null
+++ b/net/dsa/netlink.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2022 NXP
+ */
+#include <linux/netdevice.h>
+#include <net/rtnetlink.h>
+
+#include "dsa_priv.h"
+
+static const struct nla_policy dsa_policy[IFLA_DSA_MAX + 1] = {
+	[IFLA_DSA_MASTER]	= { .type = NLA_U32 },
+};
+
+static int dsa_changelink(struct net_device *dev, struct nlattr *tb[],
+			  struct nlattr *data[],
+			  struct netlink_ext_ack *extack)
+{
+	int err;
+
+	if (!data)
+		return 0;
+
+	if (data[IFLA_DSA_MASTER]) {
+		u32 ifindex = nla_get_u32(data[IFLA_DSA_MASTER]);
+		struct net_device *master;
+
+		master = __dev_get_by_index(dev_net(dev), ifindex);
+		if (!master)
+			return -EINVAL;
+
+		err = dsa_slave_change_master(dev, master, extack);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static size_t dsa_get_size(const struct net_device *dev)
+{
+	return nla_total_size(sizeof(u32)) +	/* IFLA_DSA_MASTER  */
+	       0;
+}
+
+static int dsa_fill_info(struct sk_buff *skb, const struct net_device *dev)
+{
+	struct net_device *master = dsa_slave_to_master(dev);
+
+	if (nla_put_u32(skb, IFLA_DSA_MASTER, master->ifindex))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+struct rtnl_link_ops dsa_link_ops __read_mostly = {
+	.kind			= "dsa",
+	.priv_size		= sizeof(struct dsa_port),
+	.maxtype		= IFLA_DSA_MAX,
+	.policy			= dsa_policy,
+	.changelink		= dsa_changelink,
+	.get_size		= dsa_get_size,
+	.fill_info		= dsa_fill_info,
+};
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 8557217ed5de..ced7f8d8ec62 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/if_bridge.h>
+#include <linux/netdevice.h>
 #include <linux/notifier.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
@@ -1370,6 +1371,138 @@ int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
 	return ds->ops->port_mrp_del_ring_role(ds, dp->index, mrp);
 }
 
+static int dsa_port_assign_master(struct dsa_port *dp,
+				  struct net_device *master,
+				  struct netlink_ext_ack *extack,
+				  bool fail_on_err)
+{
+	struct dsa_switch *ds = dp->ds;
+	int port = dp->index, err;
+
+	err = ds->ops->port_change_master(ds, port, master, extack);
+	if (err && !fail_on_err)
+		dev_err(ds->dev, "port %d failed to assign master %s: %pe\n",
+			port, master->name, ERR_PTR(err));
+
+	if (err && fail_on_err)
+		return err;
+
+	dp->cpu_dp = master->dsa_ptr;
+
+	return 0;
+}
+
+/* Change the dp->cpu_dp affinity for a user port. Note that both cross-chip
+ * notifiers and drivers have implicit assumptions about user-to-CPU-port
+ * mappings, so we unfortunately cannot delay the deletion of the objects
+ * (switchdev, standalone addresses, standalone VLANs) on the old CPU port
+ * until the new CPU port has been set up. So we need to completely tear down
+ * the old CPU port before changing it, and restore it on errors during the
+ * bringup of the new one.
+ */
+int dsa_port_change_master(struct dsa_port *dp, struct net_device *master,
+			   struct netlink_ext_ack *extack)
+{
+	struct net_device *bridge_dev = dsa_port_bridge_dev_get(dp);
+	struct net_device *old_master = dsa_port_to_master(dp);
+	struct net_device *dev = dp->slave;
+	struct dsa_switch *ds = dp->ds;
+	int port = dp->index;
+	bool vlan_filtering;
+	int err, tmp;
+
+	/* Bridges may hold host FDB, MDB and VLAN objects. These need to be
+	 * migrated, so dynamically unoffload and later reoffload the bridge
+	 * port.
+	 */
+	if (bridge_dev) {
+		dsa_port_pre_bridge_leave(dp, bridge_dev);
+		dsa_port_bridge_leave(dp, bridge_dev);
+	}
+
+	/* The port might still be VLAN filtering even if it's no longer
+	 * under a bridge, either due to ds->vlan_filtering_is_global or
+	 * ds->needs_standalone_vlan_filtering. In turn this means VLANs
+	 * on the CPU port.
+	 */
+	vlan_filtering = dsa_port_is_vlan_filtering(dp);
+	if (vlan_filtering) {
+		err = dsa_slave_manage_vlan_filtering(dev, false);
+		if (err) {
+			dev_err(ds->dev,
+				"port %d failed to remove standalone VLANs: %pe\n",
+				port, ERR_PTR(err));
+			goto rewind_old_bridge;
+		}
+	}
+
+	/* Standalone addresses, and addresses of upper interfaces like
+	 * VLAN, LAG, HSR need to be migrated.
+	 */
+	dsa_slave_unsync_ha(dev);
+
+	err = dsa_port_assign_master(dp, master, extack, true);
+	if (err)
+		goto rewind_old_addrs;
+
+	dsa_slave_sync_ha(dev);
+
+	if (vlan_filtering) {
+		err = dsa_slave_manage_vlan_filtering(dev, true);
+		if (err) {
+			dev_err(ds->dev,
+				"port %d failed to restore standalone VLANs: %pe\n",
+				port, ERR_PTR(err));
+			goto rewind_new_addrs;
+		}
+	}
+
+	if (bridge_dev) {
+		err = dsa_port_bridge_join(dp, bridge_dev, extack);
+		if (err && err == -EOPNOTSUPP) {
+			dev_err(ds->dev,
+				"port %d failed to reoffload bridge %s: %pe\n",
+				port, bridge_dev->name, ERR_PTR(err));
+			goto rewind_new_vlan;
+		}
+	}
+
+	return 0;
+
+rewind_new_vlan:
+	if (vlan_filtering)
+		dsa_slave_manage_vlan_filtering(dev, false);
+
+rewind_new_addrs:
+	dsa_slave_unsync_ha(dev);
+
+	dsa_port_assign_master(dp, old_master, NULL, false);
+
+/* Restore the objects on the old CPU port */
+rewind_old_addrs:
+	dsa_slave_sync_ha(dev);
+
+	if (vlan_filtering) {
+		tmp = dsa_slave_manage_vlan_filtering(dev, true);
+		if (tmp) {
+			dev_err(ds->dev, "port %d failed to restore standalone VLANs: %pe\n",
+				dp->index, ERR_PTR(tmp));
+		}
+	}
+
+rewind_old_bridge:
+	if (bridge_dev) {
+		tmp = dsa_port_bridge_join(dp, bridge_dev, extack);
+		if (tmp) {
+			dev_err(ds->dev,
+				"port %d failed to rejoin bridge %s: %pe\n",
+				dp->index, bridge_dev->name, ERR_PTR(tmp));
+		}
+	}
+
+	return err;
+}
+
 void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
 			       const struct dsa_device_ops *tag_ops)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 0d0deca99eba..95bfce49d57d 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -164,6 +164,48 @@ static int dsa_slave_unsync_mc(struct net_device *dev,
 	return dsa_slave_schedule_standalone_work(dev, DSA_MC_DEL, addr, 0);
 }
 
+void dsa_slave_sync_ha(struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	struct netdev_hw_addr *ha;
+
+	netif_addr_lock_bh(dev);
+
+	netdev_for_each_synced_mc_addr(ha, dev)
+		dsa_slave_sync_mc(dev, ha->addr);
+
+	netdev_for_each_synced_uc_addr(ha, dev)
+		dsa_slave_sync_uc(dev, ha->addr);
+
+	netif_addr_unlock_bh(dev);
+
+	if (dsa_switch_supports_uc_filtering(ds) ||
+	    dsa_switch_supports_mc_filtering(ds))
+		dsa_flush_workqueue();
+}
+
+void dsa_slave_unsync_ha(struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	struct netdev_hw_addr *ha;
+
+	netif_addr_lock_bh(dev);
+
+	netdev_for_each_synced_uc_addr(ha, dev)
+		dsa_slave_unsync_uc(dev, ha->addr);
+
+	netdev_for_each_synced_mc_addr(ha, dev)
+		dsa_slave_unsync_mc(dev, ha->addr);
+
+	netif_addr_unlock_bh(dev);
+
+	if (dsa_switch_supports_uc_filtering(ds) ||
+	    dsa_switch_supports_mc_filtering(ds))
+		dsa_flush_workqueue();
+}
+
 /* slave mii_bus handling ***************************************************/
 static int dsa_slave_phy_read(struct mii_bus *bus, int addr, int reg)
 {
@@ -2322,6 +2364,7 @@ int dsa_slave_create(struct dsa_port *port)
 	if (slave_dev == NULL)
 		return -ENOMEM;
 
+	slave_dev->rtnl_link_ops = &dsa_link_ops;
 	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
 #if IS_ENABLED(CONFIG_DCB)
 	slave_dev->dcbnl_ops = &dsa_slave_dcbnl_ops;
@@ -2438,6 +2481,80 @@ void dsa_slave_destroy(struct net_device *slave_dev)
 	free_netdev(slave_dev);
 }
 
+int dsa_slave_change_master(struct net_device *dev, struct net_device *master,
+			    struct netlink_ext_ack *extack)
+{
+	struct net_device *old_master = dsa_slave_to_master(dev);
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	struct net_device *upper;
+	struct list_head *iter;
+	int err;
+
+	if (master == old_master)
+		return 0;
+
+	if (!ds->ops->port_change_master)
+		return -EOPNOTSUPP;
+
+	if (!netdev_uses_dsa(master)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Interface not eligible as DSA master");
+		return -EOPNOTSUPP;
+	}
+
+	netdev_for_each_upper_dev_rcu(master, upper, iter) {
+		if (dsa_slave_dev_check(upper))
+			continue;
+		if (netif_is_bridge_master(upper))
+			continue;
+		NL_SET_ERR_MSG_MOD(extack, "Cannot join master with unknown uppers");
+		return -EOPNOTSUPP;
+	}
+
+	/* Since we allow live-changing the DSA master, plus we auto-open the
+	 * DSA master when the user port opens => we need to ensure that the
+	 * new DSA master is open too.
+	 */
+	if (dev->flags & IFF_UP) {
+		err = dev_open(master, extack);
+		if (err)
+			return err;
+	}
+
+	netdev_upper_dev_unlink(old_master, dev);
+
+	err = netdev_upper_dev_link(master, dev, extack);
+	if (err)
+		goto out_revert_old_master_unlink;
+
+	err = dsa_port_change_master(dp, master, extack);
+	if (err)
+		goto out_revert_master_link;
+
+	/* Update the MTU of the new CPU port through cross-chip notifiers */
+	err = dsa_slave_change_mtu(dev, dev->mtu);
+	if (err && err != -EOPNOTSUPP) {
+		netdev_warn(dev,
+			    "nonfatal error updating MTU with new master: %pe\n",
+			    ERR_PTR(err));
+	}
+
+	/* If the port doesn't have its own MAC address and relies on the DSA
+	 * master's one, inherit it again from the new DSA master.
+	 */
+	if (is_zero_ether_addr(dp->mac))
+		eth_hw_addr_inherit(dev, master);
+
+	return 0;
+
+out_revert_master_link:
+	netdev_upper_dev_unlink(master, dev);
+out_revert_old_master_unlink:
+	netdev_upper_dev_link(old_master, dev, NULL);
+	return err;
+}
+
 bool dsa_slave_dev_check(const struct net_device *dev)
 {
 	return dev->netdev_ops == &dsa_slave_netdev_ops;
-- 
2.25.1

