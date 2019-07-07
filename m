Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6D66144E
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbfGGH77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 03:59:59 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:38911 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727229AbfGGH76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 03:59:58 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7B0B726BA;
        Sun,  7 Jul 2019 03:59:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 03:59:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=bV1Se4hoPGUJ4I0mWq1B+TjIVrgtGaiBW7MBjJTDcV0=; b=OxHRHKyo
        cgglm3QJPKG3TQ7QlIm5QvytFSie3q9nSnp4f5Y1/x+RKawSMNsSdaCdfUBaj+8S
        ZxWKWWHX9sQmQSFBdutKEb4wCVO+LPTwsjVdvBchaJ+Bhg8PUIkj5fvjVI7ploIi
        gpKOgQTnY5m5Ul1OgaNm8OgBcmBMPooJ0mIFLpdy3pKIS376gA1AVCzmVbe0nN8Z
        OkyIj1iATkQnRiZ+5aqyT6HvTwyUkof+q5otynRDVJXw7PXNThergbA12HCbCAjY
        YkD13DA8Z5Xv+K20R+rosGB5N6G6H2xPKUxu2XWl+fzvkpPOsrLUVhohZzQox18v
        yMSyWeryE/Rvkw==
X-ME-Sender: <xms:faYhXfIl9lFaqK04styTvUIS9BT8il2bx4blXPM9P5hojZOa-yPkag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:faYhXa6Hg5LLfha0FruSGzeoqOp5Uj6tmWsU5PyR9hydIJHua34yLw>
    <xmx:faYhXWQ_wWkeFSkSWh23b59L7DcrBtfPl3ydaXN-DncLnrLGTr2WHg>
    <xmx:faYhXSvX_sdM74NAMqO4YDJhAT-_8VFdiSyuXmJdjX7qIK-7NFPxIA>
    <xmx:faYhXZRd_egQc0YFqQh4mkm1P737GayGmLLDBUDWPVVKYOjnK9nzyw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id CDA40380075;
        Sun,  7 Jul 2019 03:59:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 03/11] devlink: Add generic packet traps and groups
Date:   Sun,  7 Jul 2019 10:58:20 +0300
Message-Id: <20190707075828.3315-4-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707075828.3315-1-idosch@idosch.org>
References: <20190707075828.3315-1-idosch@idosch.org>
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
index 22614d3a742a..9121eb45b1c0 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -521,18 +521,58 @@ struct devlink_trap {
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
index 44a850ec3d5f..172ede6ba1b1 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7414,6 +7414,15 @@ EXPORT_SYMBOL_GPL(devlink_region_snapshot_create);
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
@@ -7423,6 +7432,9 @@ static const struct devlink_trap devlink_trap_generic[] = {
 	}
 
 static const struct devlink_trap_group devlink_trap_group_generic[] = {
+	DEVLINK_TRAP_GROUP(L2_DROPS),
+	DEVLINK_TRAP_GROUP(L3_DROPS),
+	DEVLINK_TRAP_GROUP(BUFFER_DROPS),
 };
 
 static int devlink_trap_generic_verify(const struct devlink_trap *trap)
-- 
2.20.1

