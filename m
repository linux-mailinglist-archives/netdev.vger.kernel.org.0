Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519C23368F4
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 01:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhCKAgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 19:36:55 -0500
Received: from correo.us.es ([193.147.175.20]:50148 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230052AbhCKAg1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 19:36:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AF2EE12E830
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9CD74DA78F
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:36:26 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 92480DA78C; Thu, 11 Mar 2021 01:36:26 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C723DA722;
        Thu, 11 Mar 2021 01:36:24 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Mar 2021 01:36:24 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 06B4442DC6E2;
        Thu, 11 Mar 2021 01:36:23 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH net-next 17/23] netfilter: flowtable: bridge vlan hardware offload and switchdev
Date:   Thu, 11 Mar 2021 01:35:58 +0100
Message-Id: <20210311003604.22199-18-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210311003604.22199-1-pablo@netfilter.org>
References: <20210311003604.22199-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

The switch might have already added the VLAN tag through PVID hardware
offload. Keep this extra VLAN in the flowtable but skip it on egress.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/linux/netdevice.h             | 1 +
 include/net/netfilter/nf_flow_table.h | 8 +++++---
 net/bridge/br_device.c                | 1 +
 net/bridge/br_vlan.c                  | 2 ++
 net/netfilter/nf_flow_table_core.c    | 2 ++
 net/netfilter/nf_flow_table_offload.c | 6 +++++-
 net/netfilter/nft_flow_offload.c      | 5 +++++
 7 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d9c88962fa13..4c5d2d51ae82 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -853,6 +853,7 @@ struct net_device_path {
 				DEV_PATH_BR_VLAN_KEEP,
 				DEV_PATH_BR_VLAN_TAG,
 				DEV_PATH_BR_VLAN_UNTAG,
+				DEV_PATH_BR_VLAN_UNTAG_HW,
 			}		vlan_mode;
 			u16		vlan_id;
 			__be16		vlan_proto;
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 0f6115d90867..01b256b7fd98 100644
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
index f85f3d6e56d1..2195b1c56853 100644
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
index 00b35689815f..796f46463457 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -592,8 +592,12 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
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

