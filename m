Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 333569108E
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 15:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfHQNas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 09:30:48 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:42069 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726191AbfHQNar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 09:30:47 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id BBC12CDD;
        Sat, 17 Aug 2019 09:30:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 17 Aug 2019 09:30:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Et9TGpg9IW9IQosZ+rxc97EpkwrND5W6m9L7IYzYEjM=; b=fBEwxqv6
        V09H27g5cofAEE2Mg9AkkfLtJtsDcsnQN2SkyA9ufW4+m4c9GOyoeiOdnDhyfPzB
        xa/u/cea3BxlRGih+ULsONHmOqk+mEZ6SwZl9AL3PlEo4Ul6+mvh9ZNdK+v+MWmh
        O/IHp84BnIzGXrMBpHlzVeKZblrfux0p+nJojbUagdFOcF1ZnwWBAUXGXvE9DrsC
        v08mK+PxoH0GbCJun6JSpzrlA+hfxAXv1zYhQHQkBU6s/dGu/D1mbO4D/59dTktO
        kJHEYBtdMdIlBtEm3+JurVj1GVEhSQZfxXjHJUXiIUpj6DYxc2cT5PzPJQaX5DWz
        MMEo93MdkLA9xA==
X-ME-Sender: <xms:hgFYXfBCAm-8kjAod2mBwecK8ETHfz6dqlxLtteMannOvLFnuY5B7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefhedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejjedrvddurddukedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepie
X-ME-Proxy: <xmx:hgFYXYWv3vo6LyEaHO6ENdPOookC1vKXUqzX1EOvGzFkM0WElApaQw>
    <xmx:hgFYXf9yhrMFxyU-Pibwl3qCEBeJIHmyV30nx6ZfYAlH5x4FFUR9jA>
    <xmx:hgFYXfiP9e5YIlhZymctCRscDtZazZk09gKv1-yZFqX6QpQmiDWkBg>
    <xmx:hgFYXZmbeNyzxE_2SlTKPcYKKzKxBRBuFQPK2Kkxq6sJNmSXmaDE1w>
Received: from splinter.mtl.com (unknown [79.177.21.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6C79180059;
        Sat, 17 Aug 2019 09:30:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 09/16] devlink: Add generic packet traps and groups
Date:   Sat, 17 Aug 2019 16:28:18 +0300
Message-Id: <20190817132825.29790-10-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190817132825.29790-1-idosch@idosch.org>
References: <20190817132825.29790-1-idosch@idosch.org>
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
index 960ceaec98d6..650f36379203 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7443,6 +7443,15 @@ EXPORT_SYMBOL_GPL(devlink_region_snapshot_create);
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
@@ -7452,6 +7461,9 @@ static const struct devlink_trap devlink_trap_generic[] = {
 	}
 
 static const struct devlink_trap_group devlink_trap_group_generic[] = {
+	DEVLINK_TRAP_GROUP(L2_DROPS),
+	DEVLINK_TRAP_GROUP(L3_DROPS),
+	DEVLINK_TRAP_GROUP(BUFFER_DROPS),
 };
 
 static int devlink_trap_generic_verify(const struct devlink_trap *trap)
-- 
2.21.0

