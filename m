Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17069FFFC2
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 08:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbfKRHtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 02:49:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:34144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726316AbfKRHtR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 02:49:17 -0500
Received: from localhost (unknown [5.29.147.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 304DC2067D;
        Mon, 18 Nov 2019 07:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574063356;
        bh=vkkx0SVwOd13MZgkleJ+L2Z0Wb7DKPq+YpLQfwH65eY=;
        h=From:To:Cc:Subject:Date:From;
        b=ltvPND0ObLPky1YdVv5Tefm3/qjAVIsvz3pYu/Iv9GBCl7qKe0fc4qMJymZsITeGX
         FwY/8cu2d88T1fHXEN5iYSsDkxJKjUTCKhowZecm/cQKpXX+sRPMoiK8jYFE/+OULr
         dD7n0CAg1YarUCjqIxYmt9AXnvvXvhiWE9CIHyK8=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Danit Goldberg <danitg@mellanox.com>,
        netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH iproute2-next v2] ip link: Add support to get SR-IOV VF node GUID and port GUID
Date:   Mon, 18 Nov 2019 09:49:12 +0200
Message-Id: <20191118074912.51040-1-leon@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danit Goldberg <danitg@mellanox.com>

Extend iplink to show VF GUIDs (IFLA_VF_IB_NODE_GUID, IFLA_VF_IB_PORT_GUID),
giving the ability for user-space application to print GUID values.
This ability is added to the one of setting new node GUID and port GUID values.

Suitable ip link command:
- ip link show <device>

For example:
- ip link set ib4 vf 0 node_guid 22:44:33:00:33:11:00:33
- ip link set ib4 vf 0 port_guid 10:21:33:12:00:11:22:10
- ip link show ib4
ib4: <BROADCAST,MULTICAST> mtu 4092 qdisc noop state DOWN mode DEFAULT group default qlen 256
link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:9a:03:00:44:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
vf 0     link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:9a:03:00:44:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff,
spoof checking off, NODE_GUID 22:44:33:00:33:11:00:33, PORT_GUID 10:21:33:12:00:11:22:10, link-state disable, trust off, query_rss off

Signed-off-by: Danit Goldberg <danitg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
Changelog:
 v1->v2: https://lore.kernel.org/linux-rdma/20191115152155.246821-1-leon@kernel.orga
 * Change to "b1" caused to extra padding in print of GUIDs, use real
   size instead of RTA_PAYLOAD().
 v0->v1: https://lore.kernel.org/linux-rdma/20191114133126.238128-2-leon@kernel.org
 * Use already preallocated "b1" buffer instead of new one.
---
 ip/ipaddress.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index b72eb7a1..fe41bbef 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -484,6 +484,24 @@ static void print_vfinfo(FILE *fp, struct ifinfomsg *ifi, struct rtattr *vfinfo)
 				   vf_spoofchk->setting);
 	}

+	if (vf[IFLA_VF_IB_NODE_GUID]) {
+		struct ifla_vf_guid *guid = RTA_DATA(vf[IFLA_VF_IB_NODE_GUID]);
+		uint64_t node_guid = ntohll(guid->guid);
+
+		print_string(PRINT_ANY, "node guid", ", NODE_GUID %s",
+			     ll_addr_n2a((const unsigned char *)&node_guid,
+					 sizeof(node_guid), ARPHRD_INFINIBAND,
+					 b1, sizeof(b1)));
+	}
+	if (vf[IFLA_VF_IB_PORT_GUID]) {
+		struct ifla_vf_guid *guid = RTA_DATA(vf[IFLA_VF_IB_PORT_GUID]);
+		uint64_t port_guid = ntohll(guid->guid);
+
+		print_string(PRINT_ANY, "port guid", ", PORT_GUID %s",
+			     ll_addr_n2a((const unsigned char *)&port_guid,
+					 sizeof(port_guid), ARPHRD_INFINIBAND,
+					 b1, sizeof(b1)));
+	}
 	if (vf[IFLA_VF_LINK_STATE]) {
 		struct ifla_vf_link_state *vf_linkstate =
 			RTA_DATA(vf[IFLA_VF_LINK_STATE]);
--
2.20.1

