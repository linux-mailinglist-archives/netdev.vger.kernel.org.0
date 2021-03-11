Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064A43368F3
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 01:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhCKAg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 19:36:56 -0500
Received: from correo.us.es ([193.147.175.20]:50162 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230046AbhCKAg1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 19:36:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 08F3C12E837
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EDFABDA791
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E3252DA78E; Thu, 11 Mar 2021 01:36:25 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 83B2DDA73D;
        Thu, 11 Mar 2021 01:36:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Mar 2021 01:36:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 4F13E42DC6E2;
        Thu, 11 Mar 2021 01:36:23 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH net-next 16/23] netfilter: nft_flow_offload: use direct xmit if hardware offload is enabled
Date:   Thu, 11 Mar 2021 01:35:57 +0100
Message-Id: <20210311003604.22199-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210311003604.22199-1-pablo@netfilter.org>
References: <20210311003604.22199-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is a forward path to reach an ethernet device and hardware
offload is enabled, then use the direct xmit path.

Moreover, store the real device in the direct xmit path info since
software datapath uses dev_hard_header() to push the layer encapsulation
headers while hardware offload refers to the real device.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  2 ++
 net/netfilter/nf_flow_table_core.c    |  1 +
 net/netfilter/nf_flow_table_offload.c |  2 +-
 net/netfilter/nft_flow_offload.c      | 21 +++++++++++++++++++--
 4 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 8742b3351150..0f6115d90867 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -131,6 +131,7 @@ struct flow_offload_tuple {
 		struct dst_entry	*dst_cache;
 		struct {
 			u32		ifidx;
+			u32		hw_ifidx;
 			u8		h_source[ETH_ALEN];
 			u8		h_dest[ETH_ALEN];
 		} out;
@@ -188,6 +189,7 @@ struct nf_flow_route {
 		} in;
 		struct {
 			u32			ifindex;
+			u32			hw_ifindex;
 			u8			h_source[ETH_ALEN];
 			u8			h_dest[ETH_ALEN];
 		} out;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index d4aec1c988d0..f85f3d6e56d1 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -106,6 +106,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
+		flow_tuple->out.hw_ifidx = route->tuple[dir].out.hw_ifindex;
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
 	case FLOW_OFFLOAD_XMIT_NEIGH:
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index aa2a0919a4a2..00b35689815f 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -506,7 +506,7 @@ static void flow_offload_redirect(struct net *net,
 	switch (this_tuple->xmit_type) {
 	case FLOW_OFFLOAD_XMIT_DIRECT:
 		this_tuple = &flow->tuplehash[dir].tuple;
-		ifindex = this_tuple->out.ifidx;
+		ifindex = this_tuple->out.hw_ifidx;
 		break;
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		other_tuple = &flow->tuplehash[!dir].tuple;
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 143d049fd7f1..d25b4b109e25 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -66,6 +66,7 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 struct nft_forward_info {
 	const struct net_device *indev;
 	const struct net_device *outdev;
+	const struct net_device *hw_outdev;
 	struct id {
 		__u16	id;
 		__be16	proto;
@@ -76,9 +77,18 @@ struct nft_forward_info {
 	enum flow_offload_xmit_type xmit_type;
 };
 
+static bool nft_is_valid_ether_device(const struct net_device *dev)
+{
+	if (!dev || (dev->flags & IFF_LOOPBACK) || dev->type != ARPHRD_ETHER ||
+	    dev->addr_len != ETH_ALEN || !is_valid_ether_addr(dev->dev_addr))
+		return false;
+
+	return true;
+}
+
 static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			      struct nft_forward_info *info,
-			      unsigned char *ha)
+			      unsigned char *ha, struct nf_flowtable *flowtable)
 {
 	const struct net_device_path *path;
 	int i;
@@ -140,6 +150,12 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 	}
 	if (!info->outdev)
 		info->outdev = info->indev;
+
+	info->hw_outdev = info->indev;
+
+	if (nf_flowtable_hw_offload(flowtable) &&
+	    nft_is_valid_ether_device(info->indev))
+		info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 }
 
 static bool nft_flowtable_find_dev(const struct net_device *dev,
@@ -171,7 +187,7 @@ static void nft_dev_forward_path(struct nf_flow_route *route,
 	int i;
 
 	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) >= 0)
-		nft_dev_path_info(&stack, &info, ha);
+		nft_dev_path_info(&stack, &info, ha, &ft->data);
 
 	if (!info.indev || !nft_flowtable_find_dev(info.indev, ft))
 		return;
@@ -187,6 +203,7 @@ static void nft_dev_forward_path(struct nf_flow_route *route,
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
 		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
 		route->tuple[dir].out.ifindex = info.outdev->ifindex;
+		route->tuple[dir].out.hw_ifindex = info.hw_outdev->ifindex;
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
 }
-- 
2.20.1

