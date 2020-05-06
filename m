Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434CB1C7665
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730346AbgEFQb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:31:26 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:46342 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730086AbgEFQan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:30:43 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046GUcWm025583;
        Wed, 6 May 2020 11:30:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588782638;
        bh=GWTcLpmIfKng0++C9JAIQL/vXaEPy4dOdqqqfM/HKT0=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=nuexToJ2k0gFVoeHEfh1J/XyPfnJgKZU7eoWR0ikozGSh7c6WTwbf4zMIJTCNT6A4
         1HGgKjL2pp2tqV+XlBMg2Bk2I28J27nWT5xo4lwZiW1mf1mnC9eKuTddzWDnoLjbXY
         LotC5TZCq+8Qn+kCe+6LcswZ19hKyl2NBzb/4KqQ=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 046GUcLB063303
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 May 2020 11:30:38 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 11:30:38 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 11:30:38 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046GUXDl119719;
        Wed, 6 May 2020 11:30:37 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>
Subject: [net-next RFC PATCH 08/13] net: hsr: migrate HSR netlink socket code to use new common API
Date:   Wed, 6 May 2020 12:30:28 -0400
Message-ID: <20200506163033.3843-9-m-karicheri2@ti.com>
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

Migrate the existing netlink socket code to the use the new common API.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 net/hsr-prp/hsr_netlink.c | 123 +++++++++++++++++++-------------------
 net/hsr-prp/hsr_netlink.h |   2 +-
 2 files changed, 64 insertions(+), 61 deletions(-)

diff --git a/net/hsr-prp/hsr_netlink.c b/net/hsr-prp/hsr_netlink.c
index fbfa98aee13c..1f7c3be8d96e 100644
--- a/net/hsr-prp/hsr_netlink.c
+++ b/net/hsr-prp/hsr_netlink.c
@@ -15,13 +15,13 @@
 #include "hsr_prp_device.h"
 #include "hsr_prp_framereg.h"
 
-static const struct nla_policy hsr_policy[IFLA_HSR_MAX + 1] = {
-	[IFLA_HSR_SLAVE1]		= { .type = NLA_U32 },
-	[IFLA_HSR_SLAVE2]		= { .type = NLA_U32 },
-	[IFLA_HSR_MULTICAST_SPEC]	= { .type = NLA_U8 },
-	[IFLA_HSR_VERSION]	= { .type = NLA_U8 },
-	[IFLA_HSR_SUPERVISION_ADDR]	= { .len = ETH_ALEN },
-	[IFLA_HSR_SEQ_NR]		= { .type = NLA_U16 },
+static const struct nla_policy hsr_policy[IFLA_HSR_PRP_MAX + 1] = {
+	[IFLA_HSR_PRP_SLAVE1]		= { .type = NLA_U32 },
+	[IFLA_HSR_PRP_SLAVE2]		= { .type = NLA_U32 },
+	[IFLA_HSR_PRP_SF_MC_ADDR_LSB]	= { .type = NLA_U8 },
+	[IFLA_HSR_PRP_VERSION]	= { .type = NLA_U8 },
+	[IFLA_HSR_PRP_SF_MC_ADDR]	= { .len = ETH_ALEN },
+	[IFLA_HSR_PRP_SEQ_NR]		= { .type = NLA_U16 },
 };
 
 /* Here, it seems a netdevice has already been allocated for us, and the
@@ -38,22 +38,22 @@ static int hsr_newlink(struct net *src_net, struct net_device *dev,
 		NL_SET_ERR_MSG_MOD(extack, "No slave devices specified");
 		return -EINVAL;
 	}
-	if (!data[IFLA_HSR_SLAVE1]) {
+	if (!data[IFLA_HSR_PRP_SLAVE1]) {
 		NL_SET_ERR_MSG_MOD(extack, "Slave1 device not specified");
 		return -EINVAL;
 	}
 	link[0] = __dev_get_by_index(src_net,
-				     nla_get_u32(data[IFLA_HSR_SLAVE1]));
+				     nla_get_u32(data[IFLA_HSR_PRP_SLAVE1]));
 	if (!link[0]) {
 		NL_SET_ERR_MSG_MOD(extack, "Slave1 does not exist");
 		return -EINVAL;
 	}
-	if (!data[IFLA_HSR_SLAVE2]) {
+	if (!data[IFLA_HSR_PRP_SLAVE2]) {
 		NL_SET_ERR_MSG_MOD(extack, "Slave2 device not specified");
 		return -EINVAL;
 	}
 	link[1] = __dev_get_by_index(src_net,
-				     nla_get_u32(data[IFLA_HSR_SLAVE2]));
+				     nla_get_u32(data[IFLA_HSR_PRP_SLAVE2]));
 	if (!link[1]) {
 		NL_SET_ERR_MSG_MOD(extack, "Slave2 does not exist");
 		return -EINVAL;
@@ -64,15 +64,15 @@ static int hsr_newlink(struct net *src_net, struct net_device *dev,
 		return -EINVAL;
 	}
 
-	if (!data[IFLA_HSR_MULTICAST_SPEC])
+	if (!data[IFLA_HSR_PRP_SF_MC_ADDR_LSB])
 		multicast_spec = 0;
 	else
-		multicast_spec = nla_get_u8(data[IFLA_HSR_MULTICAST_SPEC]);
+		multicast_spec = nla_get_u8(data[IFLA_HSR_PRP_SF_MC_ADDR_LSB]);
 
-	if (!data[IFLA_HSR_VERSION]) {
+	if (!data[IFLA_HSR_PRP_VERSION]) {
 		hsr_version = 0;
 	} else {
-		hsr_version = nla_get_u8(data[IFLA_HSR_VERSION]);
+		hsr_version = nla_get_u8(data[IFLA_HSR_PRP_VERSION]);
 		if (hsr_version > 1) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Only versions 0..1 are supported");
@@ -91,19 +91,19 @@ static int hsr_fill_info(struct sk_buff *skb, const struct net_device *dev)
 
 	port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_A);
 	if (port) {
-		if (nla_put_u32(skb, IFLA_HSR_SLAVE1, port->dev->ifindex))
+		if (nla_put_u32(skb, IFLA_HSR_PRP_SLAVE1, port->dev->ifindex))
 			goto nla_put_failure;
 	}
 
 	port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_B);
 	if (port) {
-		if (nla_put_u32(skb, IFLA_HSR_SLAVE2, port->dev->ifindex))
+		if (nla_put_u32(skb, IFLA_HSR_PRP_SLAVE2, port->dev->ifindex))
 			goto nla_put_failure;
 	}
 
-	if (nla_put(skb, IFLA_HSR_SUPERVISION_ADDR, ETH_ALEN,
+	if (nla_put(skb, IFLA_HSR_PRP_SF_MC_ADDR, ETH_ALEN,
 		    priv->sup_multicast_addr) ||
-	    nla_put_u16(skb, IFLA_HSR_SEQ_NR, priv->sequence_nr))
+	    nla_put_u16(skb, IFLA_HSR_PRP_SEQ_NR, priv->sequence_nr))
 		goto nla_put_failure;
 
 	return 0;
@@ -114,7 +114,7 @@ static int hsr_fill_info(struct sk_buff *skb, const struct net_device *dev)
 
 static struct rtnl_link_ops hsr_link_ops __read_mostly = {
 	.kind		= "hsr",
-	.maxtype	= IFLA_HSR_MAX,
+	.maxtype	= IFLA_HSR_PRP_MAX,
 	.policy		= hsr_policy,
 	.priv_size	= sizeof(struct hsr_prp_priv),
 	.setup		= hsr_prp_dev_setup,
@@ -123,14 +123,14 @@ static struct rtnl_link_ops hsr_link_ops __read_mostly = {
 };
 
 /* attribute policy */
-static const struct nla_policy hsr_genl_policy[HSR_A_MAX + 1] = {
-	[HSR_A_NODE_ADDR] = { .len = ETH_ALEN },
-	[HSR_A_NODE_ADDR_B] = { .len = ETH_ALEN },
-	[HSR_A_IFINDEX] = { .type = NLA_U32 },
-	[HSR_A_IF1_AGE] = { .type = NLA_U32 },
-	[HSR_A_IF2_AGE] = { .type = NLA_U32 },
-	[HSR_A_IF1_SEQ] = { .type = NLA_U16 },
-	[HSR_A_IF2_SEQ] = { .type = NLA_U16 },
+static const struct nla_policy hsr_genl_policy[HSR_PRP_A_MAX + 1] = {
+	[HSR_PRP_A_NODE_ADDR] = { .len = ETH_ALEN },
+	[HSR_PRP_A_NODE_ADDR_B] = { .len = ETH_ALEN },
+	[HSR_PRP_A_IFINDEX] = { .type = NLA_U32 },
+	[HSR_PRP_A_IF1_AGE] = { .type = NLA_U32 },
+	[HSR_PRP_A_IF2_AGE] = { .type = NLA_U32 },
+	[HSR_PRP_A_IF1_SEQ] = { .type = NLA_U16 },
+	[HSR_PRP_A_IF2_SEQ] = { .type = NLA_U16 },
 };
 
 static struct genl_family hsr_genl_family;
@@ -157,15 +157,15 @@ void hsr_nl_ringerror(struct hsr_prp_priv *priv,
 		goto fail;
 
 	msg_head = genlmsg_put(skb, 0, 0, &hsr_genl_family, 0,
-			       HSR_C_RING_ERROR);
+			       HSR_PRP_C_RING_ERROR);
 	if (!msg_head)
 		goto nla_put_failure;
 
-	res = nla_put(skb, HSR_A_NODE_ADDR, ETH_ALEN, addr);
+	res = nla_put(skb, HSR_PRP_A_NODE_ADDR, ETH_ALEN, addr);
 	if (res < 0)
 		goto nla_put_failure;
 
-	res = nla_put_u32(skb, HSR_A_IFINDEX, port->dev->ifindex);
+	res = nla_put_u32(skb, HSR_PRP_A_IFINDEX, port->dev->ifindex);
 	if (res < 0)
 		goto nla_put_failure;
 
@@ -199,11 +199,12 @@ void hsr_nl_nodedown(struct hsr_prp_priv *priv,
 	if (!skb)
 		goto fail;
 
-	msg_head = genlmsg_put(skb, 0, 0, &hsr_genl_family, 0, HSR_C_NODE_DOWN);
+	msg_head = genlmsg_put(skb, 0, 0, &hsr_genl_family, 0,
+			       HSR_PRP_C_NODE_DOWN);
 	if (!msg_head)
 		goto nla_put_failure;
 
-	res = nla_put(skb, HSR_A_NODE_ADDR, ETH_ALEN, addr);
+	res = nla_put(skb, HSR_PRP_A_NODE_ADDR, ETH_ALEN, addr);
 	if (res < 0)
 		goto nla_put_failure;
 
@@ -222,7 +223,7 @@ void hsr_nl_nodedown(struct hsr_prp_priv *priv,
 	rcu_read_unlock();
 }
 
-/* HSR_C_GET_NODE_STATUS lets userspace query the internal HSR node table
+/* HSR_PRP_C_GET_NODE_STATUS lets userspace query the internal HSR node table
  * about the status of a specific node in the network, defined by its MAC
  * address.
  *
@@ -252,16 +253,17 @@ static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
 	if (!info)
 		goto invalid;
 
-	na = info->attrs[HSR_A_IFINDEX];
+	na = info->attrs[HSR_PRP_A_IFINDEX];
 	if (!na)
 		goto invalid;
-	na = info->attrs[HSR_A_NODE_ADDR];
+	na = info->attrs[HSR_PRP_A_NODE_ADDR];
 	if (!na)
 		goto invalid;
 
 	rcu_read_lock();
-	hsr_dev = dev_get_by_index_rcu(genl_info_net(info),
-				       nla_get_u32(info->attrs[HSR_A_IFINDEX]));
+	hsr_dev =
+	dev_get_by_index_rcu(genl_info_net(info),
+			     nla_get_u32(info->attrs[HSR_PRP_A_IFINDEX]));
 	if (!hsr_dev)
 		goto rcu_unlock;
 	if (!is_hsr_prp_master(hsr_dev))
@@ -276,20 +278,20 @@ static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
 
 	msg_head = genlmsg_put(skb_out, NETLINK_CB(skb_in).portid,
 			       info->snd_seq, &hsr_genl_family, 0,
-			       HSR_C_SET_NODE_STATUS);
+			       HSR_PRP_C_SET_NODE_STATUS);
 	if (!msg_head) {
 		res = -ENOMEM;
 		goto nla_put_failure;
 	}
 
-	res = nla_put_u32(skb_out, HSR_A_IFINDEX, hsr_dev->ifindex);
+	res = nla_put_u32(skb_out, HSR_PRP_A_IFINDEX, hsr_dev->ifindex);
 	if (res < 0)
 		goto nla_put_failure;
 
 	priv = netdev_priv(hsr_dev);
 	res = hsr_prp_get_node_data(priv,
 				    (unsigned char *)
-				    nla_data(info->attrs[HSR_A_NODE_ADDR]),
+				    nla_data(info->attrs[HSR_PRP_A_NODE_ADDR]),
 					     node_addr_b,
 					     &addr_b_ifindex,
 					     &hsr_node_if1_age,
@@ -299,45 +301,45 @@ static int hsr_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
 	if (res < 0)
 		goto nla_put_failure;
 
-	res = nla_put(skb_out, HSR_A_NODE_ADDR, ETH_ALEN,
-		      nla_data(info->attrs[HSR_A_NODE_ADDR]));
+	res = nla_put(skb_out, HSR_PRP_A_NODE_ADDR, ETH_ALEN,
+		      nla_data(info->attrs[HSR_PRP_A_NODE_ADDR]));
 	if (res < 0)
 		goto nla_put_failure;
 
 	if (addr_b_ifindex > -1) {
-		res = nla_put(skb_out, HSR_A_NODE_ADDR_B, ETH_ALEN,
+		res = nla_put(skb_out, HSR_PRP_A_NODE_ADDR_B, ETH_ALEN,
 			      node_addr_b);
 		if (res < 0)
 			goto nla_put_failure;
 
-		res = nla_put_u32(skb_out, HSR_A_ADDR_B_IFINDEX,
+		res = nla_put_u32(skb_out, HSR_PRP_A_ADDR_B_IFINDEX,
 				  addr_b_ifindex);
 		if (res < 0)
 			goto nla_put_failure;
 	}
 
-	res = nla_put_u32(skb_out, HSR_A_IF1_AGE, hsr_node_if1_age);
+	res = nla_put_u32(skb_out, HSR_PRP_A_IF1_AGE, hsr_node_if1_age);
 	if (res < 0)
 		goto nla_put_failure;
-	res = nla_put_u16(skb_out, HSR_A_IF1_SEQ, hsr_node_if1_seq);
+	res = nla_put_u16(skb_out, HSR_PRP_A_IF1_SEQ, hsr_node_if1_seq);
 	if (res < 0)
 		goto nla_put_failure;
 	port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_A);
 	if (port)
-		res = nla_put_u32(skb_out, HSR_A_IF1_IFINDEX,
+		res = nla_put_u32(skb_out, HSR_PRP_A_IF1_IFINDEX,
 				  port->dev->ifindex);
 	if (res < 0)
 		goto nla_put_failure;
 
-	res = nla_put_u32(skb_out, HSR_A_IF2_AGE, hsr_node_if2_age);
+	res = nla_put_u32(skb_out, HSR_PRP_A_IF2_AGE, hsr_node_if2_age);
 	if (res < 0)
 		goto nla_put_failure;
-	res = nla_put_u16(skb_out, HSR_A_IF2_SEQ, hsr_node_if2_seq);
+	res = nla_put_u16(skb_out, HSR_PRP_A_IF2_SEQ, hsr_node_if2_seq);
 	if (res < 0)
 		goto nla_put_failure;
 	port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_B);
 	if (port)
-		res = nla_put_u32(skb_out, HSR_A_IF2_IFINDEX,
+		res = nla_put_u32(skb_out, HSR_PRP_A_IF2_IFINDEX,
 				  port->dev->ifindex);
 	if (res < 0)
 		goto nla_put_failure;
@@ -381,13 +383,14 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 	if (!info)
 		goto invalid;
 
-	na = info->attrs[HSR_A_IFINDEX];
+	na = info->attrs[HSR_PRP_A_IFINDEX];
 	if (!na)
 		goto invalid;
 
 	rcu_read_lock();
-	hsr_dev = dev_get_by_index_rcu(genl_info_net(info),
-				       nla_get_u32(info->attrs[HSR_A_IFINDEX]));
+	hsr_dev =
+	dev_get_by_index_rcu(genl_info_net(info),
+			     nla_get_u32(info->attrs[HSR_PRP_A_IFINDEX]));
 	if (!hsr_dev)
 		goto rcu_unlock;
 	if (!is_hsr_prp_master(hsr_dev))
@@ -403,14 +406,14 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 
 	msg_head = genlmsg_put(skb_out, NETLINK_CB(skb_in).portid,
 			       info->snd_seq, &hsr_genl_family, 0,
-			       HSR_C_SET_NODE_LIST);
+			       HSR_PRP_C_SET_NODE_LIST);
 	if (!msg_head) {
 		res = -ENOMEM;
 		goto nla_put_failure;
 	}
 
 	if (!restart) {
-		res = nla_put_u32(skb_out, HSR_A_IFINDEX, hsr_dev->ifindex);
+		res = nla_put_u32(skb_out, HSR_PRP_A_IFINDEX, hsr_dev->ifindex);
 		if (res < 0)
 			goto nla_put_failure;
 	}
@@ -420,7 +423,7 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 	if (!pos)
 		pos = hsr_prp_get_next_node(priv, NULL, addr);
 	while (pos) {
-		res = nla_put(skb_out, HSR_A_NODE_ADDR, ETH_ALEN, addr);
+		res = nla_put(skb_out, HSR_PRP_A_NODE_ADDR, ETH_ALEN, addr);
 		if (res < 0) {
 			if (res == -EMSGSIZE) {
 				genlmsg_end(skb_out, msg_head);
@@ -457,14 +460,14 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 
 static const struct genl_ops hsr_ops[] = {
 	{
-		.cmd = HSR_C_GET_NODE_STATUS,
+		.cmd = HSR_PRP_C_GET_NODE_STATUS,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = 0,
 		.doit = hsr_get_node_status,
 		.dumpit = NULL,
 	},
 	{
-		.cmd = HSR_C_GET_NODE_LIST,
+		.cmd = HSR_PRP_C_GET_NODE_LIST,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = 0,
 		.doit = hsr_get_node_list,
@@ -476,7 +479,7 @@ static struct genl_family hsr_genl_family __ro_after_init = {
 	.hdrsize = 0,
 	.name = "HSR",
 	.version = 1,
-	.maxattr = HSR_A_MAX,
+	.maxattr = HSR_PRP_A_MAX,
 	.policy = hsr_genl_policy,
 	.netnsok = true,
 	.module = THIS_MODULE,
diff --git a/net/hsr-prp/hsr_netlink.h b/net/hsr-prp/hsr_netlink.h
index ae7a1c0de80d..df3d1acb08e0 100644
--- a/net/hsr-prp/hsr_netlink.h
+++ b/net/hsr-prp/hsr_netlink.h
@@ -10,7 +10,7 @@
 
 #include <linux/if_ether.h>
 #include <linux/module.h>
-#include <uapi/linux/hsr_netlink.h>
+#include <uapi/linux/hsr_prp_netlink.h>
 
 struct hsr_prp_priv;
 struct hsr_prp_port;
-- 
2.17.1

