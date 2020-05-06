Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52011C7652
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730183AbgEFQar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:30:47 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:58220 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730109AbgEFQan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:30:43 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046GUdk6116961;
        Wed, 6 May 2020 11:30:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588782639;
        bh=pegbbcJY02iFMTjJs0ok2VCawQmW8YotLvjpgj1tQkA=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=O9rlmIQsesDEbfborhl+GcmkY9Ek2VCrZZx/IPPZCGfVaH5Yve+Vf32dD5DN9omfX
         6UQtVNey/nQXy6gYvDmw8KKNvyCnoCU+TPH4yJkDPZFJg/k8MONNx+TJeQLw6v69NY
         kuOsd4XkIiXqRVWTotlCwUG3biCju2npxmfi3ETo=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 046GUcHh022034
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 May 2020 11:30:38 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 11:30:38 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 11:30:38 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046GUXDm119719;
        Wed, 6 May 2020 11:30:38 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>
Subject: [net-next RFC PATCH 09/13] net: hsr: move re-usable code for PRP to hsr_prp_netlink.c
Date:   Wed, 6 May 2020 12:30:29 -0400
Message-ID: <20200506163033.3843-10-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506163033.3843-1-m-karicheri2@ti.com>
References: <20200506163033.3843-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before introducing PRP netlink code, move the re-usable code to a
common hsr_prp_netlink.c.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 net/hsr-prp/Makefile          |   2 +-
 net/hsr-prp/hsr_netlink.c     | 337 +------------------------------
 net/hsr-prp/hsr_prp_netlink.c | 367 ++++++++++++++++++++++++++++++++++
 net/hsr-prp/hsr_prp_netlink.h |  27 +++
 4 files changed, 402 insertions(+), 331 deletions(-)
 create mode 100644 net/hsr-prp/hsr_prp_netlink.c
 create mode 100644 net/hsr-prp/hsr_prp_netlink.h

diff --git a/net/hsr-prp/Makefile b/net/hsr-prp/Makefile
index 608045f088a4..76f266cd1976 100644
--- a/net/hsr-prp/Makefile
+++ b/net/hsr-prp/Makefile
@@ -7,5 +7,5 @@ obj-$(CONFIG_HSR_PRP)	+= hsr-prp.o
 
 hsr-prp-y		:= hsr_prp_main.o hsr_prp_framereg.o \
 			   hsr_prp_device.o hsr_netlink.o hsr_prp_slave.o \
-			   hsr_prp_forward.o
+			   hsr_prp_forward.o hsr_prp_netlink.o
 hsr-prp-$(CONFIG_DEBUG_FS) += hsr_prp_debugfs.o
diff --git a/net/hsr-prp/hsr_netlink.c b/net/hsr-prp/hsr_netlink.c
index 1f7c3be8d96e..6bdb369ced36 100644
--- a/net/hsr-prp/hsr_netlink.c
+++ b/net/hsr-prp/hsr_netlink.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <net/rtnetlink.h>
 #include <net/genetlink.h>
+#include "hsr_prp_netlink.h"
 #include "hsr_prp_main.h"
 #include "hsr_prp_device.h"
 #include "hsr_prp_framereg.h"
@@ -31,85 +32,7 @@ static int hsr_newlink(struct net *src_net, struct net_device *dev,
 		       struct nlattr *tb[], struct nlattr *data[],
 		       struct netlink_ext_ack *extack)
 {
-	struct net_device *link[2];
-	unsigned char multicast_spec, hsr_version;
-
-	if (!data) {
-		NL_SET_ERR_MSG_MOD(extack, "No slave devices specified");
-		return -EINVAL;
-	}
-	if (!data[IFLA_HSR_PRP_SLAVE1]) {
-		NL_SET_ERR_MSG_MOD(extack, "Slave1 device not specified");
-		return -EINVAL;
-	}
-	link[0] = __dev_get_by_index(src_net,
-				     nla_get_u32(data[IFLA_HSR_PRP_SLAVE1]));
-	if (!link[0]) {
-		NL_SET_ERR_MSG_MOD(extack, "Slave1 does not exist");
-		return -EINVAL;
-	}
-	if (!data[IFLA_HSR_PRP_SLAVE2]) {
-		NL_SET_ERR_MSG_MOD(extack, "Slave2 device not specified");
-		return -EINVAL;
-	}
-	link[1] = __dev_get_by_index(src_net,
-				     nla_get_u32(data[IFLA_HSR_PRP_SLAVE2]));
-	if (!link[1]) {
-		NL_SET_ERR_MSG_MOD(extack, "Slave2 does not exist");
-		return -EINVAL;
-	}
-
-	if (link[0] == link[1]) {
-		NL_SET_ERR_MSG_MOD(extack, "Slave1 and Slave2 are same");
-		return -EINVAL;
-	}
-
-	if (!data[IFLA_HSR_PRP_SF_MC_ADDR_LSB])
-		multicast_spec = 0;
-	else
-		multicast_spec = nla_get_u8(data[IFLA_HSR_PRP_SF_MC_ADDR_LSB]);
-
-	if (!data[IFLA_HSR_PRP_VERSION]) {
-		hsr_version = 0;
-	} else {
-		hsr_version = nla_get_u8(data[IFLA_HSR_PRP_VERSION]);
-		if (hsr_version > 1) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Only versions 0..1 are supported");
-			return -EINVAL;
-		}
-	}
-
-	return hsr_prp_dev_finalize(dev, link, multicast_spec, hsr_version,
-				    extack);
-}
-
-static int hsr_fill_info(struct sk_buff *skb, const struct net_device *dev)
-{
-	struct hsr_prp_priv *priv = netdev_priv(dev);
-	struct hsr_prp_port *port;
-
-	port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_A);
-	if (port) {
-		if (nla_put_u32(skb, IFLA_HSR_PRP_SLAVE1, port->dev->ifindex))
-			goto nla_put_failure;
-	}
-
-	port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_B);
-	if (port) {
-		if (nla_put_u32(skb, IFLA_HSR_PRP_SLAVE2, port->dev->ifindex))
-			goto nla_put_failure;
-	}
-
-	if (nla_put(skb, IFLA_HSR_PRP_SF_MC_ADDR, ETH_ALEN,
-		    priv->sup_multicast_addr) ||
-	    nla_put_u16(skb, IFLA_HSR_PRP_SEQ_NR, priv->sequence_nr))
-		goto nla_put_failure;
-
-	return 0;
-
-nla_put_failure:
-	return -EMSGSIZE;
+	return hsr_prp_newlink(src_net, dev, tb, data, extack);
 }
 
 static struct rtnl_link_ops hsr_link_ops __read_mostly = {
@@ -119,7 +42,7 @@ static struct rtnl_link_ops hsr_link_ops __read_mostly = {
 	.priv_size	= sizeof(struct hsr_prp_priv),
 	.setup		= hsr_prp_dev_setup,
 	.newlink	= hsr_newlink,
-	.fill_info	= hsr_fill_info,
+	.fill_info	= hsr_prp_fill_info,
 };
 
 /* attribute policy */
@@ -187,40 +110,9 @@ void hsr_nl_ringerror(struct hsr_prp_priv *priv,
 /* This is called when we haven't heard from the node with MAC address addr for
  * some time (just before the node is removed from the node table/list).
  */
-void hsr_nl_nodedown(struct hsr_prp_priv *priv,
-		     unsigned char addr[ETH_ALEN])
+void hsr_nl_nodedown(struct hsr_prp_priv *priv, unsigned char addr[ETH_ALEN])
 {
-	struct sk_buff *skb;
-	void *msg_head;
-	struct hsr_prp_port *master;
-	int res;
-
-	skb = genlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
-	if (!skb)
-		goto fail;
-
-	msg_head = genlmsg_put(skb, 0, 0, &hsr_genl_family, 0,
-			       HSR_PRP_C_NODE_DOWN);
-	if (!msg_head)
-		goto nla_put_failure;
-
-	res = nla_put(skb, HSR_PRP_A_NODE_ADDR, ETH_ALEN, addr);
-	if (res < 0)
-		goto nla_put_failure;
-
-	genlmsg_end(skb, msg_head);
-	genlmsg_multicast(&hsr_genl_family, skb, 0, 0, GFP_ATOMIC);
-
-	return;
-
-nla_put_failure:
-	kfree_skb(skb);
-
-fail:
-	rcu_read_lock();
-	master = hsr_prp_get_port(priv, HSR_PRP_PT_MASTER);
-	netdev_warn(master->dev, "Could not send HSR node down\n");
-	rcu_read_unlock();
+	hsr_prp_nl_nodedown(priv, &hsr_genl_family, addr);
 }
 
 /* HSR_PRP_C_GET_NODE_STATUS lets userspace query the internal HSR node table
@@ -233,229 +125,14 @@ void hsr_nl_nodedown(struct hsr_prp_priv *priv,
  */
 static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
 {
-	/* For receiving */
-	struct nlattr *na;
-	struct net_device *hsr_dev;
-
-	/* For sending */
-	struct sk_buff *skb_out;
-	void *msg_head;
-	struct hsr_prp_priv *priv;
-	struct hsr_prp_port *port;
-	unsigned char node_addr_b[ETH_ALEN];
-	int hsr_node_if1_age;
-	u16 hsr_node_if1_seq;
-	int hsr_node_if2_age;
-	u16 hsr_node_if2_seq;
-	int addr_b_ifindex;
-	int res;
-
-	if (!info)
-		goto invalid;
-
-	na = info->attrs[HSR_PRP_A_IFINDEX];
-	if (!na)
-		goto invalid;
-	na = info->attrs[HSR_PRP_A_NODE_ADDR];
-	if (!na)
-		goto invalid;
-
-	rcu_read_lock();
-	hsr_dev =
-	dev_get_by_index_rcu(genl_info_net(info),
-			     nla_get_u32(info->attrs[HSR_PRP_A_IFINDEX]));
-	if (!hsr_dev)
-		goto rcu_unlock;
-	if (!is_hsr_prp_master(hsr_dev))
-		goto rcu_unlock;
-
-	/* Send reply */
-	skb_out = genlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
-	if (!skb_out) {
-		res = -ENOMEM;
-		goto fail;
-	}
-
-	msg_head = genlmsg_put(skb_out, NETLINK_CB(skb_in).portid,
-			       info->snd_seq, &hsr_genl_family, 0,
-			       HSR_PRP_C_SET_NODE_STATUS);
-	if (!msg_head) {
-		res = -ENOMEM;
-		goto nla_put_failure;
-	}
-
-	res = nla_put_u32(skb_out, HSR_PRP_A_IFINDEX, hsr_dev->ifindex);
-	if (res < 0)
-		goto nla_put_failure;
-
-	priv = netdev_priv(hsr_dev);
-	res = hsr_prp_get_node_data(priv,
-				    (unsigned char *)
-				    nla_data(info->attrs[HSR_PRP_A_NODE_ADDR]),
-					     node_addr_b,
-					     &addr_b_ifindex,
-					     &hsr_node_if1_age,
-					     &hsr_node_if1_seq,
-					     &hsr_node_if2_age,
-					     &hsr_node_if2_seq);
-	if (res < 0)
-		goto nla_put_failure;
-
-	res = nla_put(skb_out, HSR_PRP_A_NODE_ADDR, ETH_ALEN,
-		      nla_data(info->attrs[HSR_PRP_A_NODE_ADDR]));
-	if (res < 0)
-		goto nla_put_failure;
-
-	if (addr_b_ifindex > -1) {
-		res = nla_put(skb_out, HSR_PRP_A_NODE_ADDR_B, ETH_ALEN,
-			      node_addr_b);
-		if (res < 0)
-			goto nla_put_failure;
-
-		res = nla_put_u32(skb_out, HSR_PRP_A_ADDR_B_IFINDEX,
-				  addr_b_ifindex);
-		if (res < 0)
-			goto nla_put_failure;
-	}
-
-	res = nla_put_u32(skb_out, HSR_PRP_A_IF1_AGE, hsr_node_if1_age);
-	if (res < 0)
-		goto nla_put_failure;
-	res = nla_put_u16(skb_out, HSR_PRP_A_IF1_SEQ, hsr_node_if1_seq);
-	if (res < 0)
-		goto nla_put_failure;
-	port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_A);
-	if (port)
-		res = nla_put_u32(skb_out, HSR_PRP_A_IF1_IFINDEX,
-				  port->dev->ifindex);
-	if (res < 0)
-		goto nla_put_failure;
-
-	res = nla_put_u32(skb_out, HSR_PRP_A_IF2_AGE, hsr_node_if2_age);
-	if (res < 0)
-		goto nla_put_failure;
-	res = nla_put_u16(skb_out, HSR_PRP_A_IF2_SEQ, hsr_node_if2_seq);
-	if (res < 0)
-		goto nla_put_failure;
-	port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_B);
-	if (port)
-		res = nla_put_u32(skb_out, HSR_PRP_A_IF2_IFINDEX,
-				  port->dev->ifindex);
-	if (res < 0)
-		goto nla_put_failure;
-
-	rcu_read_unlock();
-
-	genlmsg_end(skb_out, msg_head);
-	genlmsg_unicast(genl_info_net(info), skb_out, info->snd_portid);
-
-	return 0;
-
-rcu_unlock:
-	rcu_read_unlock();
-invalid:
-	netlink_ack(skb_in, nlmsg_hdr(skb_in), -EINVAL, NULL);
-	return 0;
-
-nla_put_failure:
-	kfree_skb(skb_out);
-	/* Fall through */
-
-fail:
-	rcu_read_unlock();
-	return res;
+	return hsr_prp_get_node_status(&hsr_genl_family, skb_in, info);
 }
 
 /* Get a list of MacAddressA of all nodes known to this node (including self).
  */
 static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 {
-	unsigned char addr[ETH_ALEN];
-	struct net_device *hsr_dev;
-	struct hsr_prp_priv *priv;
-	struct sk_buff *skb_out;
-	bool restart = false;
-	struct nlattr *na;
-	void *pos = NULL;
-	void *msg_head;
-	int res;
-
-	if (!info)
-		goto invalid;
-
-	na = info->attrs[HSR_PRP_A_IFINDEX];
-	if (!na)
-		goto invalid;
-
-	rcu_read_lock();
-	hsr_dev =
-	dev_get_by_index_rcu(genl_info_net(info),
-			     nla_get_u32(info->attrs[HSR_PRP_A_IFINDEX]));
-	if (!hsr_dev)
-		goto rcu_unlock;
-	if (!is_hsr_prp_master(hsr_dev))
-		goto rcu_unlock;
-
-restart:
-	/* Send reply */
-	skb_out = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_ATOMIC);
-	if (!skb_out) {
-		res = -ENOMEM;
-		goto fail;
-	}
-
-	msg_head = genlmsg_put(skb_out, NETLINK_CB(skb_in).portid,
-			       info->snd_seq, &hsr_genl_family, 0,
-			       HSR_PRP_C_SET_NODE_LIST);
-	if (!msg_head) {
-		res = -ENOMEM;
-		goto nla_put_failure;
-	}
-
-	if (!restart) {
-		res = nla_put_u32(skb_out, HSR_PRP_A_IFINDEX, hsr_dev->ifindex);
-		if (res < 0)
-			goto nla_put_failure;
-	}
-
-	priv = netdev_priv(hsr_dev);
-
-	if (!pos)
-		pos = hsr_prp_get_next_node(priv, NULL, addr);
-	while (pos) {
-		res = nla_put(skb_out, HSR_PRP_A_NODE_ADDR, ETH_ALEN, addr);
-		if (res < 0) {
-			if (res == -EMSGSIZE) {
-				genlmsg_end(skb_out, msg_head);
-				genlmsg_unicast(genl_info_net(info), skb_out,
-						info->snd_portid);
-				restart = true;
-				goto restart;
-			}
-			goto nla_put_failure;
-		}
-		pos = hsr_prp_get_next_node(priv, pos, addr);
-	}
-	rcu_read_unlock();
-
-	genlmsg_end(skb_out, msg_head);
-	genlmsg_unicast(genl_info_net(info), skb_out, info->snd_portid);
-
-	return 0;
-
-rcu_unlock:
-	rcu_read_unlock();
-invalid:
-	netlink_ack(skb_in, nlmsg_hdr(skb_in), -EINVAL, NULL);
-	return 0;
-
-nla_put_failure:
-	nlmsg_free(skb_out);
-	/* Fall through */
-
-fail:
-	rcu_read_unlock();
-	return res;
+	return hsr_prp_get_node_list(&hsr_genl_family, skb_in, info);
 }
 
 static const struct genl_ops hsr_ops[] = {
diff --git a/net/hsr-prp/hsr_prp_netlink.c b/net/hsr-prp/hsr_prp_netlink.c
new file mode 100644
index 000000000000..04d51cd97496
--- /dev/null
+++ b/net/hsr-prp/hsr_prp_netlink.c
@@ -0,0 +1,367 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2011-2014 Autronica Fire and Security AS
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
+ *
+ * Based on Code by Arvid Brodin, arvid.brodin@alten.se
+ *
+ * Common routines for handling Netlink messages for HSR and PRP
+ */
+
+#include "hsr_prp_netlink.h"
+#include "hsr_prp_main.h"
+#include "hsr_prp_device.h"
+#include "hsr_prp_framereg.h"
+
+int hsr_prp_newlink(struct net *src_net, struct net_device *dev,
+		    struct nlattr *tb[], struct nlattr *data[],
+		    struct netlink_ext_ack *extack)
+{
+	struct net_device *link[2];
+	unsigned char multicast_spec, hsr_version;
+
+	if (!data) {
+		NL_SET_ERR_MSG_MOD(extack, "No slave devices specified");
+		return -EINVAL;
+	}
+	if (!data[IFLA_HSR_PRP_SLAVE1]) {
+		NL_SET_ERR_MSG_MOD(extack, "Slave1 device not specified");
+		return -EINVAL;
+	}
+	link[0] = __dev_get_by_index(src_net,
+				     nla_get_u32(data[IFLA_HSR_PRP_SLAVE1]));
+	if (!link[0]) {
+		NL_SET_ERR_MSG_MOD(extack, "Slave1 does not exist");
+		return -EINVAL;
+	}
+	if (!data[IFLA_HSR_PRP_SLAVE2]) {
+		NL_SET_ERR_MSG_MOD(extack, "Slave2 device not specified");
+		return -EINVAL;
+	}
+	link[1] = __dev_get_by_index(src_net,
+				     nla_get_u32(data[IFLA_HSR_PRP_SLAVE2]));
+	if (!link[1]) {
+		NL_SET_ERR_MSG_MOD(extack, "Slave2 does not exist");
+		return -EINVAL;
+	}
+
+	if (link[0] == link[1]) {
+		NL_SET_ERR_MSG_MOD(extack, "Slave1 and Slave2 are same");
+		return -EINVAL;
+	}
+
+	if (!data[IFLA_HSR_PRP_SF_MC_ADDR_LSB])
+		multicast_spec = 0;
+	else
+		multicast_spec = nla_get_u8(data[IFLA_HSR_PRP_SF_MC_ADDR_LSB]);
+
+	if (!data[IFLA_HSR_PRP_VERSION]) {
+		hsr_version = 0;
+	} else {
+		hsr_version = nla_get_u8(data[IFLA_HSR_PRP_VERSION]);
+		if (hsr_version > 1) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Only versions 0..1 are supported");
+			return -EINVAL;
+		}
+	}
+
+	return hsr_prp_dev_finalize(dev, link, multicast_spec, hsr_version,
+				    extack);
+}
+
+int hsr_prp_fill_info(struct sk_buff *skb, const struct net_device *dev)
+{
+	struct hsr_prp_priv *priv = netdev_priv(dev);
+	struct hsr_prp_port *port;
+
+	port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_A);
+	if (port) {
+		if (nla_put_u32(skb, IFLA_HSR_PRP_SLAVE1, port->dev->ifindex))
+			goto nla_put_failure;
+	}
+
+	port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_B);
+	if (port) {
+		if (nla_put_u32(skb, IFLA_HSR_PRP_SLAVE2, port->dev->ifindex))
+			goto nla_put_failure;
+	}
+
+	if (nla_put(skb, IFLA_HSR_PRP_SF_MC_ADDR, ETH_ALEN,
+		    priv->sup_multicast_addr) ||
+	    nla_put_u16(skb, IFLA_HSR_PRP_SEQ_NR, priv->sequence_nr))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+/* This is called when we haven't heard from the node with MAC address addr for
+ * some time (just before the node is removed from the node table/list).
+ */
+void hsr_prp_nl_nodedown(struct hsr_prp_priv *priv,
+			 struct genl_family *genl_family,
+			 unsigned char addr[ETH_ALEN])
+{
+	struct sk_buff *skb;
+	void *msg_head;
+	struct hsr_prp_port *master;
+	int res;
+
+	skb = genlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
+	if (!skb)
+		goto fail;
+
+	msg_head = genlmsg_put(skb, 0, 0, genl_family, 0,
+			       HSR_PRP_C_NODE_DOWN);
+	if (!msg_head)
+		goto nla_put_failure;
+
+	res = nla_put(skb, HSR_PRP_A_NODE_ADDR, ETH_ALEN, addr);
+	if (res < 0)
+		goto nla_put_failure;
+
+	genlmsg_end(skb, msg_head);
+	genlmsg_multicast(genl_family, skb, 0, 0, GFP_ATOMIC);
+
+	return;
+
+nla_put_failure:
+	kfree_skb(skb);
+
+fail:
+	rcu_read_lock();
+	master = hsr_prp_get_port(priv, HSR_PRP_PT_MASTER);
+	netdev_warn(master->dev, "Could not send HSR node down\n");
+	rcu_read_unlock();
+}
+
+int hsr_prp_get_node_status(struct genl_family *genl_family,
+			    struct sk_buff *skb_in, struct genl_info *info)
+{
+	/* For receiving */
+	struct nlattr *na;
+	struct net_device *hsr_dev;
+
+	/* For sending */
+	struct sk_buff *skb_out;
+	void *msg_head;
+	struct hsr_prp_priv *priv;
+	struct hsr_prp_port *port;
+	unsigned char node_addr_b[ETH_ALEN];
+	int hsr_node_if1_age;
+	u16 hsr_node_if1_seq;
+	int hsr_node_if2_age;
+	u16 hsr_node_if2_seq;
+	int addr_b_ifindex;
+	int res;
+
+	if (!info)
+		goto invalid;
+
+	na = info->attrs[HSR_PRP_A_IFINDEX];
+	if (!na)
+		goto invalid;
+	na = info->attrs[HSR_PRP_A_NODE_ADDR];
+	if (!na)
+		goto invalid;
+
+	rcu_read_lock();
+	hsr_dev =
+	dev_get_by_index_rcu(genl_info_net(info),
+			     nla_get_u32(info->attrs[HSR_PRP_A_IFINDEX]));
+	if (!hsr_dev)
+		goto rcu_unlock;
+	if (!is_hsr_prp_master(hsr_dev))
+		goto rcu_unlock;
+
+	/* Send reply */
+	skb_out = genlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
+	if (!skb_out) {
+		res = -ENOMEM;
+		goto fail;
+	}
+
+	msg_head = genlmsg_put(skb_out, NETLINK_CB(skb_in).portid,
+			       info->snd_seq, genl_family, 0,
+			       HSR_PRP_C_SET_NODE_STATUS);
+	if (!msg_head) {
+		res = -ENOMEM;
+		goto nla_put_failure;
+	}
+
+	res = nla_put_u32(skb_out, HSR_PRP_A_IFINDEX, hsr_dev->ifindex);
+	if (res < 0)
+		goto nla_put_failure;
+
+	priv = netdev_priv(hsr_dev);
+	res = hsr_prp_get_node_data(priv,
+				    (unsigned char *)
+				    nla_data(info->attrs[HSR_PRP_A_NODE_ADDR]),
+					     node_addr_b,
+					     &addr_b_ifindex,
+					     &hsr_node_if1_age,
+					     &hsr_node_if1_seq,
+					     &hsr_node_if2_age,
+					     &hsr_node_if2_seq);
+	if (res < 0)
+		goto nla_put_failure;
+
+	res = nla_put(skb_out, HSR_PRP_A_NODE_ADDR, ETH_ALEN,
+		      nla_data(info->attrs[HSR_PRP_A_NODE_ADDR]));
+	if (res < 0)
+		goto nla_put_failure;
+
+	if (addr_b_ifindex > -1) {
+		res = nla_put(skb_out, HSR_PRP_A_NODE_ADDR_B, ETH_ALEN,
+			      node_addr_b);
+		if (res < 0)
+			goto nla_put_failure;
+
+		res = nla_put_u32(skb_out, HSR_PRP_A_ADDR_B_IFINDEX,
+				  addr_b_ifindex);
+		if (res < 0)
+			goto nla_put_failure;
+	}
+
+	res = nla_put_u32(skb_out, HSR_PRP_A_IF1_AGE, hsr_node_if1_age);
+	if (res < 0)
+		goto nla_put_failure;
+	res = nla_put_u16(skb_out, HSR_PRP_A_IF1_SEQ, hsr_node_if1_seq);
+	if (res < 0)
+		goto nla_put_failure;
+	port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_A);
+	if (port)
+		res = nla_put_u32(skb_out, HSR_PRP_A_IF1_IFINDEX,
+				  port->dev->ifindex);
+	if (res < 0)
+		goto nla_put_failure;
+
+	res = nla_put_u32(skb_out, HSR_PRP_A_IF2_AGE, hsr_node_if2_age);
+	if (res < 0)
+		goto nla_put_failure;
+	res = nla_put_u16(skb_out, HSR_PRP_A_IF2_SEQ, hsr_node_if2_seq);
+	if (res < 0)
+		goto nla_put_failure;
+	port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_B);
+	if (port)
+		res = nla_put_u32(skb_out, HSR_PRP_A_IF2_IFINDEX,
+				  port->dev->ifindex);
+	if (res < 0)
+		goto nla_put_failure;
+
+	rcu_read_unlock();
+
+	genlmsg_end(skb_out, msg_head);
+	genlmsg_unicast(genl_info_net(info), skb_out, info->snd_portid);
+
+	return 0;
+
+rcu_unlock:
+	rcu_read_unlock();
+invalid:
+	netlink_ack(skb_in, nlmsg_hdr(skb_in), -EINVAL, NULL);
+	return 0;
+
+nla_put_failure:
+	kfree_skb(skb_out);
+	/* Fall through */
+
+fail:
+	rcu_read_unlock();
+	return res;
+}
+
+/* Get a list of MacAddressA of all nodes known to this node (including self).
+ */
+int hsr_prp_get_node_list(struct genl_family *genl_family,
+			  struct sk_buff *skb_in, struct genl_info *info)
+{
+	unsigned char addr[ETH_ALEN];
+	struct net_device *hsr_dev;
+	struct hsr_prp_priv *priv;
+	struct sk_buff *skb_out;
+	bool restart = false;
+	struct nlattr *na;
+	void *pos = NULL;
+	void *msg_head;
+	int res;
+
+	if (!info)
+		goto invalid;
+
+	na = info->attrs[HSR_PRP_A_IFINDEX];
+	if (!na)
+		goto invalid;
+
+	rcu_read_lock();
+	hsr_dev =
+	dev_get_by_index_rcu(genl_info_net(info),
+			     nla_get_u32(info->attrs[HSR_PRP_A_IFINDEX]));
+	if (!hsr_dev)
+		goto rcu_unlock;
+	if (!is_hsr_prp_master(hsr_dev))
+		goto rcu_unlock;
+
+restart:
+	/* Send reply */
+	skb_out = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!skb_out) {
+		res = -ENOMEM;
+		goto fail;
+	}
+
+	msg_head = genlmsg_put(skb_out, NETLINK_CB(skb_in).portid,
+			       info->snd_seq, genl_family, 0,
+			       HSR_PRP_C_SET_NODE_LIST);
+	if (!msg_head) {
+		res = -ENOMEM;
+		goto nla_put_failure;
+	}
+
+	if (!restart) {
+		res = nla_put_u32(skb_out, HSR_PRP_A_IFINDEX, hsr_dev->ifindex);
+		if (res < 0)
+			goto nla_put_failure;
+	}
+
+	priv = netdev_priv(hsr_dev);
+
+	if (!pos)
+		pos = hsr_prp_get_next_node(priv, NULL, addr);
+	while (pos) {
+		res = nla_put(skb_out, HSR_PRP_A_NODE_ADDR, ETH_ALEN, addr);
+		if (res < 0) {
+			if (res == -EMSGSIZE) {
+				genlmsg_end(skb_out, msg_head);
+				genlmsg_unicast(genl_info_net(info), skb_out,
+						info->snd_portid);
+				restart = true;
+				goto restart;
+			}
+			goto nla_put_failure;
+		}
+		pos = hsr_prp_get_next_node(priv, pos, addr);
+	}
+	rcu_read_unlock();
+
+	genlmsg_end(skb_out, msg_head);
+	genlmsg_unicast(genl_info_net(info), skb_out, info->snd_portid);
+
+	return 0;
+
+rcu_unlock:
+	rcu_read_unlock();
+invalid:
+	netlink_ack(skb_in, nlmsg_hdr(skb_in), -EINVAL, NULL);
+	return 0;
+
+nla_put_failure:
+	nlmsg_free(skb_out);
+	/* Fall through */
+
+fail:
+	rcu_read_unlock();
+	return res;
+}
diff --git a/net/hsr-prp/hsr_prp_netlink.h b/net/hsr-prp/hsr_prp_netlink.h
new file mode 100644
index 000000000000..a3a4e6252e45
--- /dev/null
+++ b/net/hsr-prp/hsr_prp_netlink.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright 2011-2014 Autronica Fire and Security AS
+ *
+ * Author(s):
+ *	2011-2014 Arvid Brodin, arvid.brodin@alten.se
+ */
+
+#ifndef __HSR_PRP_NETLINK_H
+#define __HSR_PRP_NETLINK_H
+
+#include <uapi/linux/hsr_prp_netlink.h>
+#include <net/genetlink.h>
+
+#include "hsr_prp_main.h"
+
+int hsr_prp_newlink(struct net *src_net, struct net_device *dev,
+		    struct nlattr *tb[], struct nlattr *data[],
+		    struct netlink_ext_ack *extack);
+int hsr_prp_fill_info(struct sk_buff *skb, const struct net_device *dev);
+void hsr_prp_nl_nodedown(struct hsr_prp_priv *priv,
+			 struct genl_family *genl_family,
+			 unsigned char addr[ETH_ALEN]);
+int hsr_prp_get_node_status(struct genl_family *genl_family,
+			    struct sk_buff *skb_in, struct genl_info *info);
+int hsr_prp_get_node_list(struct genl_family *genl_family,
+			  struct sk_buff *skb_in, struct genl_info *info);
+#endif /* __HSR_PRP_NETLINK_H */
-- 
2.17.1

