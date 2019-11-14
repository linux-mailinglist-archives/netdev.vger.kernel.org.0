Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80970FC77C
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 14:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfKNNbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 08:31:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbfKNNbf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 08:31:35 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 520C7206DC;
        Thu, 14 Nov 2019 13:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573738294;
        bh=L45WqGw5ivivRWY7YJ0O0/P39yCd9Dc12TSmZY/rTSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0vRobFaUuUPnHeRUhai6ud8DiogCQLmyIOALPnX8bPuBi5oCIWBHUaAkXkTBAMcJv
         Lk9zqxyZ7V2vHoH9hXsea7qZyuG78jMSuvc3h+RjTH560v4CafcOCXMi51lCq9axEQ
         B3k+FurfxN68sI7tlUmmDH9ZdyRamTDXO908C9eY=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Danit Goldberg <danitg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next] ip link: Add support to get SR-IOV VF node GUID and port GUID
Date:   Thu, 14 Nov 2019 15:31:22 +0200
Message-Id: <20191114133126.238128-2-leon@kernel.org>
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
 ip/ipaddress.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index b72eb7a1..ed72d0bd 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -484,6 +484,29 @@ static void print_vfinfo(FILE *fp, struct ifinfomsg *ifi, struct rtattr *vfinfo)
 				   vf_spoofchk->setting);
 	}
 
+#define GUID_STR_LEN 24
+	if (vf[IFLA_VF_IB_NODE_GUID]) {
+		char buf[GUID_STR_LEN];
+		struct ifla_vf_guid *guid = RTA_DATA(vf[IFLA_VF_IB_NODE_GUID]);
+		uint64_t node_guid = ntohll(guid->guid);
+
+		print_string(PRINT_ANY, "node guid", ", NODE_GUID %s",
+				ll_addr_n2a((const unsigned char *)&node_guid,
+					 RTA_PAYLOAD(vf[IFLA_VF_IB_NODE_GUID]),
+					 ARPHRD_INFINIBAND,
+					 buf, sizeof(buf)));
+	}
+	if (vf[IFLA_VF_IB_PORT_GUID]) {
+		char buf[GUID_STR_LEN];
+		struct ifla_vf_guid *guid = RTA_DATA(vf[IFLA_VF_IB_PORT_GUID]);
+		uint64_t port_guid = ntohll(guid->guid);
+
+		print_string(PRINT_ANY, "port guid", ", PORT_GUID %s",
+				ll_addr_n2a((const unsigned char *)&port_guid,
+					 RTA_PAYLOAD(vf[IFLA_VF_IB_PORT_GUID]),
+					 ARPHRD_INFINIBAND,
+					 buf, sizeof(buf)));
+	}
 	if (vf[IFLA_VF_LINK_STATE]) {
 		struct ifla_vf_link_state *vf_linkstate =
 			RTA_DATA(vf[IFLA_VF_LINK_STATE]);
-- 
2.20.1

