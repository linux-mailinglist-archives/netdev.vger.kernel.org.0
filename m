Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C0839FADF
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 17:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbhFHPhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 11:37:31 -0400
Received: from simonwunderlich.de ([79.140.42.25]:34654 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbhFHPhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 11:37:24 -0400
Received: from kero.packetmixer.de (p200300c5970dd3e020a52263b5aabfb3.dip0.t-ipconnect.de [IPv6:2003:c5:970d:d3e0:20a5:2263:b5aa:bfb3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id D1B5B174024;
        Tue,  8 Jun 2021 17:27:02 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 02/11] batman-adv: Always send iface index+name in genlmsg
Date:   Tue,  8 Jun 2021 17:26:51 +0200
Message-Id: <20210608152700.30315-3-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210608152700.30315-1-sw@simonwunderlich.de>
References: <20210608152700.30315-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The batman-adv netlink messages often contain the interface index and
interface name in the same message. This makes it easy for the receiver to
operate on the incoming data when it either needs to print something or
needs to operate on the interface index.

But one of the attributes was missing for:

* neighbor table dumps
* originator table dumps
* gateway list dumps
* query of hardif information
* query of vid information

The userspace therefore had to implement special workarounds using
SIOCGIFNAME or SIOCGIFINDEX depending on what was actually provided.
Providing both information simplifies the userspace code massively without
adding a lot of extra overhead in the kernel portion.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bat_iv_ogm.c |  6 ++++++
 net/batman-adv/bat_v.c      | 10 ++++++++++
 net/batman-adv/netlink.c    |  8 ++++++++
 3 files changed, 24 insertions(+)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 789f257be24f..680def809838 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -1849,6 +1849,8 @@ batadv_iv_ogm_orig_dump_subentry(struct sk_buff *msg, u32 portid, u32 seq,
 		    orig_node->orig) ||
 	    nla_put(msg, BATADV_ATTR_NEIGH_ADDRESS, ETH_ALEN,
 		    neigh_node->addr) ||
+	    nla_put_string(msg, BATADV_ATTR_HARD_IFNAME,
+			   neigh_node->if_incoming->net_dev->name) ||
 	    nla_put_u32(msg, BATADV_ATTR_HARD_IFINDEX,
 			neigh_node->if_incoming->net_dev->ifindex) ||
 	    nla_put_u8(msg, BATADV_ATTR_TQ, tq_avg) ||
@@ -2078,6 +2080,8 @@ batadv_iv_ogm_neigh_dump_neigh(struct sk_buff *msg, u32 portid, u32 seq,
 
 	if (nla_put(msg, BATADV_ATTR_NEIGH_ADDRESS, ETH_ALEN,
 		    hardif_neigh->addr) ||
+	    nla_put_string(msg, BATADV_ATTR_HARD_IFNAME,
+			   hardif_neigh->if_incoming->net_dev->name) ||
 	    nla_put_u32(msg, BATADV_ATTR_HARD_IFINDEX,
 			hardif_neigh->if_incoming->net_dev->ifindex) ||
 	    nla_put_u32(msg, BATADV_ATTR_LAST_SEEN_MSECS,
@@ -2459,6 +2463,8 @@ static int batadv_iv_gw_dump_entry(struct sk_buff *msg, u32 portid,
 		    router->addr) ||
 	    nla_put_string(msg, BATADV_ATTR_HARD_IFNAME,
 			   router->if_incoming->net_dev->name) ||
+	    nla_put_u32(msg, BATADV_ATTR_HARD_IFINDEX,
+			router->if_incoming->net_dev->ifindex) ||
 	    nla_put_u32(msg, BATADV_ATTR_BANDWIDTH_DOWN,
 			gw_node->bandwidth_down) ||
 	    nla_put_u32(msg, BATADV_ATTR_BANDWIDTH_UP,
diff --git a/net/batman-adv/bat_v.c b/net/batman-adv/bat_v.c
index e1ca2b8c3152..b98aea958e3d 100644
--- a/net/batman-adv/bat_v.c
+++ b/net/batman-adv/bat_v.c
@@ -146,6 +146,8 @@ batadv_v_neigh_dump_neigh(struct sk_buff *msg, u32 portid, u32 seq,
 
 	if (nla_put(msg, BATADV_ATTR_NEIGH_ADDRESS, ETH_ALEN,
 		    hardif_neigh->addr) ||
+	    nla_put_string(msg, BATADV_ATTR_HARD_IFNAME,
+			   hardif_neigh->if_incoming->net_dev->name) ||
 	    nla_put_u32(msg, BATADV_ATTR_HARD_IFINDEX,
 			hardif_neigh->if_incoming->net_dev->ifindex) ||
 	    nla_put_u32(msg, BATADV_ATTR_LAST_SEEN_MSECS,
@@ -298,6 +300,8 @@ batadv_v_orig_dump_subentry(struct sk_buff *msg, u32 portid, u32 seq,
 	if (nla_put(msg, BATADV_ATTR_ORIG_ADDRESS, ETH_ALEN, orig_node->orig) ||
 	    nla_put(msg, BATADV_ATTR_NEIGH_ADDRESS, ETH_ALEN,
 		    neigh_node->addr) ||
+	    nla_put_string(msg, BATADV_ATTR_HARD_IFNAME,
+			   neigh_node->if_incoming->net_dev->name) ||
 	    nla_put_u32(msg, BATADV_ATTR_HARD_IFINDEX,
 			neigh_node->if_incoming->net_dev->ifindex) ||
 	    nla_put_u32(msg, BATADV_ATTR_THROUGHPUT, throughput) ||
@@ -739,6 +743,12 @@ static int batadv_v_gw_dump_entry(struct sk_buff *msg, u32 portid,
 		goto out;
 	}
 
+	if (nla_put_u32(msg, BATADV_ATTR_HARD_IFINDEX,
+			router->if_incoming->net_dev->ifindex)) {
+		genlmsg_cancel(msg, hdr);
+		goto out;
+	}
+
 	if (nla_put_u32(msg, BATADV_ATTR_BANDWIDTH_DOWN,
 			gw_node->bandwidth_down)) {
 		genlmsg_cancel(msg, hdr);
diff --git a/net/batman-adv/netlink.c b/net/batman-adv/netlink.c
index f317d206b411..b6cc746e01a6 100644
--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -814,6 +814,10 @@ static int batadv_netlink_hardif_fill(struct sk_buff *msg,
 			bat_priv->soft_iface->ifindex))
 		goto nla_put_failure;
 
+	if (nla_put_string(msg, BATADV_ATTR_MESH_IFNAME,
+			   bat_priv->soft_iface->name))
+		goto nla_put_failure;
+
 	if (nla_put_u32(msg, BATADV_ATTR_HARD_IFINDEX,
 			net_dev->ifindex) ||
 	    nla_put_string(msg, BATADV_ATTR_HARD_IFNAME,
@@ -1045,6 +1049,10 @@ static int batadv_netlink_vlan_fill(struct sk_buff *msg,
 			bat_priv->soft_iface->ifindex))
 		goto nla_put_failure;
 
+	if (nla_put_string(msg, BATADV_ATTR_MESH_IFNAME,
+			   bat_priv->soft_iface->name))
+		goto nla_put_failure;
+
 	if (nla_put_u32(msg, BATADV_ATTR_VLANID, vlan->vid & VLAN_VID_MASK))
 		goto nla_put_failure;
 
-- 
2.20.1

