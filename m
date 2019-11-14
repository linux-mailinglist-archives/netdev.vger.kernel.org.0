Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDEB3FC792
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 14:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfKNNcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 08:32:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbfKNNbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 08:31:38 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C173205C9;
        Thu, 14 Nov 2019 13:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573738298;
        bh=mKz+QUjNdP4DmiF6Gg+ktDfC544IqSM/2dhWDh3rukg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dpu8k4yEKUVgXmNSFoNJPVuuFPbc4oQLSdywSWgYPbhA9D8qjvCh8+jTecJvapjps
         iol9aSwQIXOed9avXJqeihDQ0OJYKcrf5xH1DPm12ilYXkXKP9XBCWy3MygVpg29gq
         BneHceAOEmygyjng6Tj4PJXtg/l8KYkF/3PrnyYo=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Danit Goldberg <danitg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 1/4] net/core: Add support for getting VF GUIDs
Date:   Thu, 14 Nov 2019 15:31:23 +0200
Message-Id: <20191114133126.238128-3-leon@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191114133126.238128-1-leon@kernel.org>
References: <20191114133126.238128-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danit Goldberg <danitg@mellanox.com>


Introduce a new ndo: ndo_get_vf_guid, to get from the net
device the port and node GUID.

New applications can choose to use this interface to show
GUIDs with iproute2 with commands such as:

- ip link show ib4
ib4: <BROADCAST,MULTICAST> mtu 4092 qdisc noop state DOWN mode DEFAULT group default qlen 256
link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:9a:03:00:44:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
vf 0     link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:9a:03:00:44:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff,
spoof checking off, NODE_GUID 22:44:33:00:33:11:00:33, PORT_GUID 10:21:33:12:00:11:22:10, link-state disable, trust off, query_rss off

Signed-off-by: Danit Goldberg <danitg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/netdevice.h |  4 ++++
 net/core/rtnetlink.c      | 11 +++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9eda1c31d1f7..379338239e49 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1316,6 +1316,10 @@ struct net_device_ops {
 						   struct nlattr *port[]);
 	int			(*ndo_get_vf_port)(struct net_device *dev,
 						   int vf, struct sk_buff *skb);
+	int			(*ndo_get_vf_guid)(struct net_device *dev,
+						   int vf,
+						   struct ifla_vf_guid *node_guid,
+						   struct ifla_vf_guid *port_guid);
 	int			(*ndo_set_vf_guid)(struct net_device *dev,
 						   int vf, u64 guid,
 						   int guid_type);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 1ee6460f8275..b8d152f55a21 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1204,6 +1204,8 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 	struct ifla_vf_mac vf_mac;
 	struct ifla_vf_broadcast vf_broadcast;
 	struct ifla_vf_info ivi;
+	struct ifla_vf_guid node_guid;
+	struct ifla_vf_guid port_guid;

 	memset(&ivi, 0, sizeof(ivi));

@@ -1270,6 +1272,15 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 	    nla_put(skb, IFLA_VF_TRUST,
 		    sizeof(vf_trust), &vf_trust))
 		goto nla_put_vf_failure;
+	if (dev->netdev_ops->ndo_get_vf_guid &&
+	    !dev->netdev_ops->ndo_get_vf_guid(dev, vfs_num, &node_guid,
+					      &port_guid)) {
+		if (nla_put(skb, IFLA_VF_IB_NODE_GUID, sizeof(node_guid),
+			    &node_guid) ||
+		    nla_put(skb, IFLA_VF_IB_PORT_GUID, sizeof(port_guid),
+			    &port_guid))
+			goto nla_put_vf_failure;
+	}
 	vfvlanlist = nla_nest_start_noflag(skb, IFLA_VF_VLAN_LIST);
 	if (!vfvlanlist)
 		goto nla_put_vf_failure;
--
2.20.1

