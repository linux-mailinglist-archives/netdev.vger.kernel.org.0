Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8A5231523
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 23:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729542AbgG1VsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 17:48:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729461AbgG1VsC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 17:48:02 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 900E220768;
        Tue, 28 Jul 2020 21:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595972881;
        bh=dluN9UQmcKhFU1sjD2zKKbYkTy/53gjlIxf/YnECOG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FxyFagEYDlJgIvrsqCAQJv0Rch81cgyqr3qBbsJyEWodZQWPwvza1g+Wn/5ho0p7w
         3EPVKj60rgHjPOLojagZCc2F6V66gNqUHOoU86TaAcU+96AM/zGBCKHQgMq6jSCbMr
         qEz5SayUFoSZLVe2rp7g2/KRoSruSKAzHfOuEeLY=
From:   Jakub Kicinski <kuba@kernel.org>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 1/2] udp_tunnel: add the ability to hard-code IANA VXLAN
Date:   Tue, 28 Jul 2020 14:47:58 -0700
Message-Id: <20200728214759.325418-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728214759.325418-1-kuba@kernel.org>
References: <20200728214759.325418-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx5 has the IANA VXLAN port (4789) hard coded by the device,
instead of being added dynamically when tunnels are created.

To support this add a workaround flag to struct udp_tunnel_nic_info.
Skipping updates for the port is fairly trivial, dumping the hard
coded port via ethtool requires some code duplication. The port
is not a part of any real table, we dump it in a special table
which has no tunnel types supported and only one entry.

This is the last known workaround / hack needed to convert
all drivers to the new infra.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/ethtool-netlink.rst |  3 +
 include/net/udp_tunnel.h                     |  5 ++
 net/ethtool/tunnels.c                        | 69 +++++++++++++++++---
 net/ipv4/udp_tunnel_nic.c                    |  7 ++
 4 files changed, 76 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 7d75f1e32152..d53bcb31645a 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1263,6 +1263,9 @@ Gets information about the tunnel state NIC is aware of.
  | | | | ``ETHTOOL_A_TUNNEL_UDP_ENTRY_TYPE``   | u32    | tunnel type         |
  +-+-+-+---------------------------------------+--------+---------------------+
 
+For UDP tunnel table empty ``ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES`` indicates that
+the table contains static entries, hard-coded by the NIC.
+
 Request translation
 ===================
 
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index dd20ce99740c..94bb7a882250 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -193,6 +193,11 @@ enum udp_tunnel_nic_info_flags {
 	UDP_TUNNEL_NIC_INFO_OPEN_ONLY	= BIT(1),
 	/* Device supports only IPv4 tunnels */
 	UDP_TUNNEL_NIC_INFO_IPV4_ONLY	= BIT(2),
+	/* Device has hard-coded the IANA VXLAN port (4789) as VXLAN.
+	 * This port must not be counted towards n_entries of any table.
+	 * Driver will not receive any callback associated with port 4789.
+	 */
+	UDP_TUNNEL_NIC_INFO_STATIC_IANA_VXLAN	= BIT(3),
 };
 
 /**
diff --git a/net/ethtool/tunnels.c b/net/ethtool/tunnels.c
index 6b89255f1231..84f23289475b 100644
--- a/net/ethtool/tunnels.c
+++ b/net/ethtool/tunnels.c
@@ -2,6 +2,7 @@
 
 #include <linux/ethtool_netlink.h>
 #include <net/udp_tunnel.h>
+#include <net/vxlan.h>
 
 #include "bitset.h"
 #include "common.h"
@@ -18,6 +19,20 @@ static_assert(ETHTOOL_UDP_TUNNEL_TYPE_GENEVE == ilog2(UDP_TUNNEL_TYPE_GENEVE));
 static_assert(ETHTOOL_UDP_TUNNEL_TYPE_VXLAN_GPE ==
 	      ilog2(UDP_TUNNEL_TYPE_VXLAN_GPE));
 
+static ssize_t ethnl_udp_table_reply_size(unsigned int types, bool compact)
+{
+	ssize_t size;
+
+	size = ethnl_bitset32_size(&types, NULL, __ETHTOOL_UDP_TUNNEL_TYPE_CNT,
+				   udp_tunnel_type_names, compact);
+	if (size < 0)
+		return size;
+
+	return size +
+		nla_total_size(0) + /* _UDP_TABLE */
+		nla_total_size(sizeof(u32)); /* _UDP_TABLE_SIZE */
+}
+
 static ssize_t
 ethnl_tunnel_info_reply_size(const struct ethnl_req_info *req_base,
 			     struct netlink_ext_ack *extack)
@@ -25,8 +40,8 @@ ethnl_tunnel_info_reply_size(const struct ethnl_req_info *req_base,
 	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
 	const struct udp_tunnel_nic_info *info;
 	unsigned int i;
+	ssize_t ret;
 	size_t size;
-	int ret;
 
 	info = req_base->dev->udp_tunnel_nic_info;
 	if (!info) {
@@ -39,13 +54,10 @@ ethnl_tunnel_info_reply_size(const struct ethnl_req_info *req_base,
 
 	for (i = 0; i < UDP_TUNNEL_NIC_MAX_TABLES; i++) {
 		if (!info->tables[i].n_entries)
-			return size;
+			break;
 
-		size += nla_total_size(0); /* _UDP_TABLE */
-		size +=	nla_total_size(sizeof(u32)); /* _UDP_TABLE_SIZE */
-		ret = ethnl_bitset32_size(&info->tables[i].tunnel_types, NULL,
-					  __ETHTOOL_UDP_TUNNEL_TYPE_CNT,
-					  udp_tunnel_type_names, compact);
+		ret = ethnl_udp_table_reply_size(info->tables[i].tunnel_types,
+						 compact);
 		if (ret < 0)
 			return ret;
 		size += ret;
@@ -53,6 +65,17 @@ ethnl_tunnel_info_reply_size(const struct ethnl_req_info *req_base,
 		size += udp_tunnel_nic_dump_size(req_base->dev, i);
 	}
 
+	if (info->flags & UDP_TUNNEL_NIC_INFO_STATIC_IANA_VXLAN) {
+		ret = ethnl_udp_table_reply_size(0, compact);
+		if (ret < 0)
+			return ret;
+		size += ret;
+
+		size += nla_total_size(0) +		 /* _TABLE_ENTRY */
+			nla_total_size(sizeof(__be16)) + /* _ENTRY_PORT */
+			nla_total_size(sizeof(u32));	 /* _ENTRY_TYPE */
+	}
+
 	return size;
 }
 
@@ -62,7 +85,7 @@ ethnl_tunnel_info_fill_reply(const struct ethnl_req_info *req_base,
 {
 	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
 	const struct udp_tunnel_nic_info *info;
-	struct nlattr *ports, *table;
+	struct nlattr *ports, *table, *entry;
 	unsigned int i;
 
 	info = req_base->dev->udp_tunnel_nic_info;
@@ -97,10 +120,40 @@ ethnl_tunnel_info_fill_reply(const struct ethnl_req_info *req_base,
 		nla_nest_end(skb, table);
 	}
 
+	if (info->flags & UDP_TUNNEL_NIC_INFO_STATIC_IANA_VXLAN) {
+		u32 zero = 0;
+
+		table = nla_nest_start(skb, ETHTOOL_A_TUNNEL_UDP_TABLE);
+		if (!table)
+			goto err_cancel_ports;
+
+		if (nla_put_u32(skb, ETHTOOL_A_TUNNEL_UDP_TABLE_SIZE, 1))
+			goto err_cancel_table;
+
+		if (ethnl_put_bitset32(skb, ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES,
+				       &zero, NULL,
+				       __ETHTOOL_UDP_TUNNEL_TYPE_CNT,
+				       udp_tunnel_type_names, compact))
+			goto err_cancel_table;
+
+		entry = nla_nest_start(skb, ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY);
+
+		if (nla_put_be16(skb, ETHTOOL_A_TUNNEL_UDP_ENTRY_PORT,
+				 htons(IANA_VXLAN_UDP_PORT)) ||
+		    nla_put_u32(skb, ETHTOOL_A_TUNNEL_UDP_ENTRY_TYPE,
+				ilog2(UDP_TUNNEL_TYPE_VXLAN)))
+			goto err_cancel_entry;
+
+		nla_nest_end(skb, entry);
+		nla_nest_end(skb, table);
+	}
+
 	nla_nest_end(skb, ports);
 
 	return 0;
 
+err_cancel_entry:
+	nla_nest_cancel(skb, entry);
 err_cancel_table:
 	nla_nest_cancel(skb, table);
 err_cancel_ports:
diff --git a/net/ipv4/udp_tunnel_nic.c b/net/ipv4/udp_tunnel_nic.c
index f0dbd9905a53..69962165c0e8 100644
--- a/net/ipv4/udp_tunnel_nic.c
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -7,6 +7,7 @@
 #include <linux/types.h>
 #include <linux/workqueue.h>
 #include <net/udp_tunnel.h>
+#include <net/vxlan.h>
 
 enum udp_tunnel_nic_table_entry_flags {
 	UDP_TUNNEL_NIC_ENTRY_ADD	= BIT(0),
@@ -504,6 +505,12 @@ __udp_tunnel_nic_add_port(struct net_device *dev, struct udp_tunnel_info *ti)
 		return;
 	if (!netif_running(dev) && info->flags & UDP_TUNNEL_NIC_INFO_OPEN_ONLY)
 		return;
+	if (info->flags & UDP_TUNNEL_NIC_INFO_STATIC_IANA_VXLAN &&
+	    ti->port == htons(IANA_VXLAN_UDP_PORT)) {
+		if (ti->type != UDP_TUNNEL_TYPE_VXLAN)
+			netdev_warn(dev, "device assumes port 4789 will be used by vxlan tunnels\n");
+		return;
+	}
 
 	if (!udp_tunnel_nic_is_capable(dev, utn, ti))
 		return;
-- 
2.26.2

