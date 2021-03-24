Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D382346ED7
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbhCXBcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234518AbhCXBbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:31:19 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0EF66C0613D8;
        Tue, 23 Mar 2021 18:31:19 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6771D630C3;
        Wed, 24 Mar 2021 02:31:10 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next,v2 16/24] netfilter: nft_flow_offload: use direct xmit if hardware offload is enabled
Date:   Wed, 24 Mar 2021 02:30:47 +0100
Message-Id: <20210324013055.5619-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210324013055.5619-1-pablo@netfilter.org>
References: <20210324013055.5619-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
v2: no changes.

 include/net/netfilter/nf_flow_table.h |  2 ++
 net/netfilter/nf_flow_table_core.c    |  1 +
 net/netfilter/nf_flow_table_offload.c |  2 +-
 net/netfilter/nft_flow_offload.c      | 21 +++++++++++++++++++--
 4 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index e34fd3eb4bb5..52afcee6e999 100644
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
index 595f4434b84d..f728c955b1dc 100644
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
index 3fbed447132a..e0d079601fcb 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -508,7 +508,7 @@ static void flow_offload_redirect(struct net *net,
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

