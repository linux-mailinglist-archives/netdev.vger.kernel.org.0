Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82FD78B1AF
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 09:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbfHMH4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 03:56:22 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:54165 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728077AbfHMH4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 03:56:18 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id DF515303E;
        Tue, 13 Aug 2019 03:56:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 13 Aug 2019 03:56:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=k3OshMmmo70oCEOH3xJ8PbD6XFBZ8Kz1sr/bSwcUbFw=; b=SSfAAW+b
        0W2f3yCnf8J72i7s6uF3BDqOcrZYGpLsSKXrbbRez43kWex6qLqbqumhLtrXp+4e
        5SzTDjazEakNRz3Xx3R608eBymYu4Z5PYncx6sJnqeHqBRc+GaArmNQYvYPlULWk
        b1cvq/tIFi9Dko2XirYorwwbz/EUuWRUh1SWlEJZuE/c2Uer9tNb/bERtLb5Th1/
        ysL+RceYR4q2uVbrc+GgJmxuu/Q1lVs7/9r+THw1Ib2hprK4HkBHpeUwZ/FkzXIl
        gtFpGQ0DaQWy35ydoJeKOQJJwbmk6IpN8GG2OqTpDtvM5mwYj3YsdfAv1L23LNau
        LY2n/czf2VJULw==
X-ME-Sender: <xms:IW1SXSq8p21ZHjgZ_y2ERXy5uRq4zEdgQZUfUhSzcVAxFI5_CQgnyQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvhedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgepie
X-ME-Proxy: <xmx:IW1SXdQlzYLAuJ64l1hIdsHf5nxK2gROU24325ryxLPN-dT2Tx0LuQ>
    <xmx:IW1SXdn45VxGtcxucUvQA5gO8lr1OUrct7eF6c0YFiyNiPMaX2ulsw>
    <xmx:IW1SXbyAF5-Rjgobg_9ljszrIBlXwyLHc0UlQ40sh16O33_fxZCWCQ>
    <xmx:IW1SXXvrrxTqROv9l15Ic-b_OrcRMmDVH1uxKQWyFdrUkWxk1hKABg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 64AD98005B;
        Tue, 13 Aug 2019 03:56:14 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 09/14] devlink: Add generic packet traps and groups
Date:   Tue, 13 Aug 2019 10:53:55 +0300
Message-Id: <20190813075400.11841-10-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190813075400.11841-1-idosch@idosch.org>
References: <20190813075400.11841-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Add generic packet traps and groups that can report dropped packets as
well as exceptions such as TTL error.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h | 40 ++++++++++++++++++++++++++++++++++++++++
 net/core/devlink.c    | 12 ++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 03b32e33e93e..fb02e0e89f9d 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -541,18 +541,58 @@ struct devlink_trap {
 };
 
 enum devlink_trap_generic_id {
+	DEVLINK_TRAP_GENERIC_ID_SMAC_MC,
+	DEVLINK_TRAP_GENERIC_ID_VLAN_TAG_MISMATCH,
+	DEVLINK_TRAP_GENERIC_ID_INGRESS_VLAN_FILTER,
+	DEVLINK_TRAP_GENERIC_ID_INGRESS_STP_FILTER,
+	DEVLINK_TRAP_GENERIC_ID_EMPTY_TX_LIST,
+	DEVLINK_TRAP_GENERIC_ID_PORT_LOOPBACK_FILTER,
+	DEVLINK_TRAP_GENERIC_ID_BLACKHOLE_ROUTE,
+	DEVLINK_TRAP_GENERIC_ID_TTL_ERROR,
+	DEVLINK_TRAP_GENERIC_ID_TAIL_DROP,
+
 	/* Add new generic trap IDs above */
 	__DEVLINK_TRAP_GENERIC_ID_MAX,
 	DEVLINK_TRAP_GENERIC_ID_MAX = __DEVLINK_TRAP_GENERIC_ID_MAX - 1,
 };
 
 enum devlink_trap_group_generic_id {
+	DEVLINK_TRAP_GROUP_GENERIC_ID_L2_DROPS,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_L3_DROPS,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_BUFFER_DROPS,
+
 	/* Add new generic trap group IDs above */
 	__DEVLINK_TRAP_GROUP_GENERIC_ID_MAX,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_MAX =
 		__DEVLINK_TRAP_GROUP_GENERIC_ID_MAX - 1,
 };
 
+#define DEVLINK_TRAP_GENERIC_NAME_SMAC_MC \
+	"source_mac_is_multicast"
+#define DEVLINK_TRAP_GENERIC_NAME_VLAN_TAG_MISMATCH \
+	"vlan_tag_mismatch"
+#define DEVLINK_TRAP_GENERIC_NAME_INGRESS_VLAN_FILTER \
+	"ingress_vlan_filter"
+#define DEVLINK_TRAP_GENERIC_NAME_INGRESS_STP_FILTER \
+	"ingress_spanning_tree_filter"
+#define DEVLINK_TRAP_GENERIC_NAME_EMPTY_TX_LIST \
+	"port_list_is_empty"
+#define DEVLINK_TRAP_GENERIC_NAME_PORT_LOOPBACK_FILTER \
+	"port_loopback_filter"
+#define DEVLINK_TRAP_GENERIC_NAME_BLACKHOLE_ROUTE \
+	"blackhole_route"
+#define DEVLINK_TRAP_GENERIC_NAME_TTL_ERROR \
+	"ttl_value_is_too_small"
+#define DEVLINK_TRAP_GENERIC_NAME_TAIL_DROP \
+	"tail_drop"
+
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_L2_DROPS \
+	"l2_drops"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_L3_DROPS \
+	"l3_drops"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_BUFFER_DROPS \
+	"buffer_drops"
+
 #define DEVLINK_TRAP_GENERIC(_type, _init_action, _id, _group, _metadata_cap) \
 	{								      \
 		.type = DEVLINK_TRAP_TYPE_##_type,			      \
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 3a3ef2f8c133..6b15b9f744c7 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7442,6 +7442,15 @@ EXPORT_SYMBOL_GPL(devlink_region_snapshot_create);
 	}
 
 static const struct devlink_trap devlink_trap_generic[] = {
+	DEVLINK_TRAP(SMAC_MC, DROP),
+	DEVLINK_TRAP(VLAN_TAG_MISMATCH, DROP),
+	DEVLINK_TRAP(INGRESS_VLAN_FILTER, DROP),
+	DEVLINK_TRAP(INGRESS_STP_FILTER, DROP),
+	DEVLINK_TRAP(EMPTY_TX_LIST, DROP),
+	DEVLINK_TRAP(PORT_LOOPBACK_FILTER, DROP),
+	DEVLINK_TRAP(BLACKHOLE_ROUTE, DROP),
+	DEVLINK_TRAP(TTL_ERROR, EXCEPTION),
+	DEVLINK_TRAP(TAIL_DROP, DROP),
 };
 
 #define DEVLINK_TRAP_GROUP(_id)						      \
@@ -7451,6 +7460,9 @@ static const struct devlink_trap devlink_trap_generic[] = {
 	}
 
 static const struct devlink_trap_group devlink_trap_group_generic[] = {
+	DEVLINK_TRAP_GROUP(L2_DROPS),
+	DEVLINK_TRAP_GROUP(L3_DROPS),
+	DEVLINK_TRAP_GROUP(BUFFER_DROPS),
 };
 
 static int devlink_trap_generic_verify(const struct devlink_trap *trap)
-- 
2.21.0

