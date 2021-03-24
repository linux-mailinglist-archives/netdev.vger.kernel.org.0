Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB88346ED8
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbhCXBb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234519AbhCXBbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:31:20 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 45F87C061763;
        Tue, 23 Mar 2021 18:31:19 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id EBE5A630BB;
        Wed, 24 Mar 2021 02:31:10 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next,v2 17/24] netfilter: flowtable: bridge vlan hardware offload and switchdev
Date:   Wed, 24 Mar 2021 02:30:48 +0100
Message-Id: <20210324013055.5619-18-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210324013055.5619-1-pablo@netfilter.org>
References: <20210324013055.5619-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

The switch might have already added the VLAN tag through PVID hardware
offload. Keep this extra VLAN in the flowtable but skip it on egress.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 include/linux/netdevice.h             | 1 +
 include/net/netfilter/nf_flow_table.h | 8 +++++---
 net/bridge/br_device.c                | 1 +
 net/bridge/br_vlan.c                  | 2 ++
 net/netfilter/nf_flow_table_core.c    | 2 ++
 net/netfilter/nf_flow_table_offload.c | 6 +++++-
 net/netfilter/nft_flow_offload.c      | 5 +++++
 7 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7ad7df75aaaa..cc4f966b51a7 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -870,6 +870,7 @@ struct net_device_path {
 				DEV_PATH_BR_VLAN_KEEP,
 				DEV_PATH_BR_VLAN_TAG,
 				DEV_PATH_BR_VLAN_UNTAG,
+				DEV_PATH_BR_VLAN_UNTAG_HW,
 			}		vlan_mode;
 			u16		vlan_id;
 			__be16		vlan_proto;
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 52afcee6e999..4d991c1e93ef 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -123,9 +123,10 @@ struct flow_offload_tuple {
 	/* All members above are keys for lookups, see flow_offload_hash(). */
 	struct { }			__hash;
 
-	u8				dir:4,
+	u8				dir:2,
 					xmit_type:2,
-					encap_num:2;
+					encap_num:2,
+					in_vlan_ingress:2;
 	u16				mtu;
 	union {
 		struct dst_entry	*dst_cache;
@@ -185,7 +186,8 @@ struct nf_flow_route {
 				u16		id;
 				__be16		proto;
 			} encap[NF_FLOW_TABLE_ENCAP_MAX];
-			u8			num_encaps;
+			u8			num_encaps:2,
+						ingress_vlans:2;
 		} in;
 		struct {
 			u32			ifindex;
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 0c72503e0d39..e8b626cc6bfd 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -422,6 +422,7 @@ static int br_fill_forward_path(struct net_device_path_ctx *ctx,
 		ctx->vlan[ctx->num_vlans].proto = path->bridge.vlan_proto;
 		ctx->num_vlans++;
 		break;
+	case DEV_PATH_BR_VLAN_UNTAG_HW:
 	case DEV_PATH_BR_VLAN_UNTAG:
 		ctx->num_vlans--;
 		break;
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 0d09d3745e52..8e92ee5bef67 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1386,6 +1386,8 @@ int br_vlan_fill_forward_path_mode(struct net_bridge *br,
 
 	if (path->bridge.vlan_mode == DEV_PATH_BR_VLAN_TAG)
 		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP;
+	else if (v->priv_flags & BR_VLFLAG_ADDED_BY_SWITCHDEV)
+		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG_HW;
 	else
 		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG;
 
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index f728c955b1dc..8fa7bf9d5f3f 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -95,6 +95,8 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 	for (i = route->tuple[dir].in.num_encaps - 1; i >= 0; i--) {
 		flow_tuple->encap[j].id = route->tuple[dir].in.encap[i].id;
 		flow_tuple->encap[j].proto = route->tuple[dir].in.encap[i].proto;
+		if (route->tuple[dir].in.ingress_vlans & BIT(i))
+			flow_tuple->in_vlan_ingress |= BIT(j);
 		j++;
 	}
 	flow_tuple->encap_num = route->tuple[dir].in.num_encaps;
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index e0d079601fcb..9326ba74745e 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -594,8 +594,12 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 	other_tuple = &flow->tuplehash[!dir].tuple;
 
 	for (i = 0; i < other_tuple->encap_num; i++) {
-		struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
+		struct flow_action_entry *entry;
 
+		if (other_tuple->in_vlan_ingress & BIT(i))
+			continue;
+
+		entry = flow_action_entry_next(flow_rule);
 		entry->id = FLOW_ACTION_VLAN_PUSH;
 		entry->vlan.vid = other_tuple->encap[i].id;
 		entry->vlan.proto = other_tuple->encap[i].proto;
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index d25b4b109e25..4843dd2b410c 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -72,6 +72,7 @@ struct nft_forward_info {
 		__be16	proto;
 	} encap[NF_FLOW_TABLE_ENCAP_MAX];
 	u8 num_encaps;
+	u8 ingress_vlans;
 	u8 h_source[ETH_ALEN];
 	u8 h_dest[ETH_ALEN];
 	enum flow_offload_xmit_type xmit_type;
@@ -130,6 +131,9 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
 
 			switch (path->bridge.vlan_mode) {
+			case DEV_PATH_BR_VLAN_UNTAG_HW:
+				info->ingress_vlans |= BIT(info->num_encaps - 1);
+				break;
 			case DEV_PATH_BR_VLAN_TAG:
 				info->encap[info->num_encaps].id = path->bridge.vlan_id;
 				info->encap[info->num_encaps].proto = path->bridge.vlan_proto;
@@ -198,6 +202,7 @@ static void nft_dev_forward_path(struct nf_flow_route *route,
 		route->tuple[!dir].in.encap[i].proto = info.encap[i].proto;
 	}
 	route->tuple[!dir].in.num_encaps = info.num_encaps;
+	route->tuple[!dir].in.ingress_vlans = info.ingress_vlans;
 
 	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
-- 
2.20.1

