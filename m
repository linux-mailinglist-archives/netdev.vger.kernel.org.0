Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD271C062D
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgD3TWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:22:14 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44437 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726486AbgD3TWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 15:22:06 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 30 Apr 2020 22:21:53 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03UJLqAV004128;
        Thu, 30 Apr 2020 22:21:53 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V8 rdma-next 13/16] RDMA/core: Add LAG functionality
Date:   Thu, 30 Apr 2020 22:21:43 +0300
Message-Id: <20200430192146.12863-14-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200430192146.12863-1-maorg@mellanox.com>
References: <20200430192146.12863-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to get the RoCE LAG xmit slave by building skb
of the RoCE packet and call to master_get_xmit_slave.
If driver wants to get the slave assume all slaves are available,
then need to set RDMA_LAG_FLAGS_HASH_ALL_SLAVES in flags.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/Makefile |   2 +-
 drivers/infiniband/core/lag.c    | 136 +++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h          |   1 +
 include/rdma/lag.h               |  23 ++++++
 4 files changed, 161 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/core/lag.c
 create mode 100644 include/rdma/lag.h

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index d1b14887960e..870f0fcd54d5 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -12,7 +12,7 @@ ib_core-y :=			packer.o ud_header.o verbs.o cq.o rw.o sysfs.o \
 				roce_gid_mgmt.o mr_pool.o addr.o sa_query.o \
 				multicast.o mad.o smi.o agent.o mad_rmpp.o \
 				nldev.o restrack.o counters.o ib_core_uverbs.o \
-				trace.o
+				trace.o lag.o
 
 ib_core-$(CONFIG_SECURITY_INFINIBAND) += security.o
 ib_core-$(CONFIG_CGROUP_RDMA) += cgroup.o
diff --git a/drivers/infiniband/core/lag.c b/drivers/infiniband/core/lag.c
new file mode 100644
index 000000000000..a29533626a7c
--- /dev/null
+++ b/drivers/infiniband/core/lag.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2020 Mellanox Technologies. All rights reserved.
+ */
+
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_cache.h>
+#include <rdma/lag.h>
+
+static struct sk_buff *rdma_build_skb(struct ib_device *device,
+				      struct net_device *netdev,
+				      struct rdma_ah_attr *ah_attr,
+				      gfp_t flags)
+{
+	struct ipv6hdr *ip6h;
+	struct sk_buff *skb;
+	struct ethhdr *eth;
+	struct iphdr *iph;
+	struct udphdr *uh;
+	u8 smac[ETH_ALEN];
+	bool is_ipv4;
+	int hdr_len;
+
+	is_ipv4 = ipv6_addr_v4mapped((struct in6_addr *)ah_attr->grh.dgid.raw);
+	hdr_len = ETH_HLEN + sizeof(struct udphdr) + LL_RESERVED_SPACE(netdev);
+	hdr_len += is_ipv4 ? sizeof(struct iphdr) : sizeof(struct ipv6hdr);
+
+	skb = alloc_skb(hdr_len, flags);
+	if (!skb)
+		return NULL;
+
+	skb->dev = netdev;
+	skb_reserve(skb, hdr_len);
+	skb_push(skb, sizeof(struct udphdr));
+	skb_reset_transport_header(skb);
+	uh = udp_hdr(skb);
+	uh->source = htons(0xC000);
+	uh->dest = htons(ROCE_V2_UDP_DPORT);
+	uh->len = htons(sizeof(struct udphdr));
+
+	if (is_ipv4) {
+		skb_push(skb, sizeof(struct iphdr));
+		skb_reset_network_header(skb);
+		iph = ip_hdr(skb);
+		iph->frag_off = 0;
+		iph->version = 4;
+		iph->protocol = IPPROTO_UDP;
+		iph->ihl = 0x5;
+		iph->tot_len = htons(sizeof(struct udphdr) + sizeof(struct
+								    iphdr));
+		memcpy(&iph->saddr, ah_attr->grh.sgid_attr->gid.raw + 12,
+		       sizeof(struct in_addr));
+		memcpy(&iph->daddr, ah_attr->grh.dgid.raw + 12,
+		       sizeof(struct in_addr));
+	} else {
+		skb_push(skb, sizeof(struct ipv6hdr));
+		skb_reset_network_header(skb);
+		ip6h = ipv6_hdr(skb);
+		ip6h->version = 6;
+		ip6h->nexthdr = IPPROTO_UDP;
+		memcpy(&ip6h->flow_lbl, &ah_attr->grh.flow_label,
+		       sizeof(*ip6h->flow_lbl));
+		memcpy(&ip6h->saddr, ah_attr->grh.sgid_attr->gid.raw,
+		       sizeof(struct in6_addr));
+		memcpy(&ip6h->daddr, ah_attr->grh.dgid.raw,
+		       sizeof(struct in6_addr));
+	}
+
+	skb_push(skb, sizeof(struct ethhdr));
+	skb_reset_mac_header(skb);
+	eth = eth_hdr(skb);
+	skb->protocol = eth->h_proto = htons(is_ipv4 ? ETH_P_IP : ETH_P_IPV6);
+	rdma_read_gid_l2_fields(ah_attr->grh.sgid_attr, NULL, smac);
+	memcpy(eth->h_source, smac, ETH_ALEN);
+	memcpy(eth->h_dest, ah_attr->roce.dmac, ETH_ALEN);
+
+	return skb;
+}
+
+static struct net_device *rdma_get_xmit_slave_udp(struct ib_device *device,
+						  struct net_device *master,
+						  struct rdma_ah_attr *ah_attr,
+						  gfp_t flags)
+{
+	struct net_device *slave;
+	struct sk_buff *skb;
+
+	skb = rdma_build_skb(device, master, ah_attr, flags);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	rcu_read_lock();
+	slave = netdev_get_xmit_slave(master, skb,
+				      !!(device->lag_flags &
+					 RDMA_LAG_FLAGS_HASH_ALL_SLAVES));
+	if (slave)
+		dev_hold(slave);
+	rcu_read_unlock();
+	kfree_skb(skb);
+	return slave;
+}
+
+void rdma_lag_put_ah_roce_slave(struct net_device *xmit_slave)
+{
+	if (xmit_slave)
+		dev_put(xmit_slave);
+}
+
+struct net_device *rdma_lag_get_ah_roce_slave(struct ib_device *device,
+					      struct rdma_ah_attr *ah_attr,
+					      gfp_t flags)
+{
+	struct net_device *slave = NULL;
+	struct net_device *master;
+
+	if (!(ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE &&
+	      ah_attr->grh.sgid_attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP))
+		return NULL;
+
+	rcu_read_lock();
+	master = rdma_read_gid_attr_ndev_rcu(ah_attr->grh.sgid_attr);
+	if (IS_ERR(master)) {
+		rcu_read_unlock();
+		return master;
+	}
+	dev_hold(master);
+	rcu_read_unlock();
+
+	if (!netif_is_bond_master(master))
+		goto put;
+
+	slave = rdma_get_xmit_slave_udp(device, master, ah_attr, flags);
+put:
+	dev_put(master);
+	return slave;
+}
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 20ea26810349..e6c18ec0365a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2714,6 +2714,7 @@ struct ib_device {
 	/* Used by iWarp CM */
 	char iw_ifname[IFNAMSIZ];
 	u32 iw_driver_flags;
+	u32 lag_flags;
 };
 
 struct ib_client_nl_info;
diff --git a/include/rdma/lag.h b/include/rdma/lag.h
new file mode 100644
index 000000000000..7c06ec9b2eef
--- /dev/null
+++ b/include/rdma/lag.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/*
+ * Copyright (c) 2020 Mellanox Technologies. All rights reserved.
+ */
+
+#ifndef _RDMA_LAG_H_
+#define _RDMA_LAG_H_
+
+#include <net/lag.h>
+
+struct ib_device;
+struct rdma_ah_attr;
+
+enum rdma_lag_flags {
+	RDMA_LAG_FLAGS_HASH_ALL_SLAVES = 1 << 0
+};
+
+void rdma_lag_put_ah_roce_slave(struct net_device *xmit_slave);
+struct net_device *rdma_lag_get_ah_roce_slave(struct ib_device *device,
+					      struct rdma_ah_attr *ah_attr,
+					      gfp_t flags);
+
+#endif /* _RDMA_LAG_H_ */
-- 
2.17.2

