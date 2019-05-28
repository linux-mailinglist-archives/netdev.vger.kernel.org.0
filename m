Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87CC82C689
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfE1MbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:31:22 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:39745 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726853AbfE1MbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:31:21 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 434111FC5;
        Tue, 28 May 2019 08:22:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 28 May 2019 08:22:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=xkv48EUXh3FfCv87WIn6i0AMxySvxYD/1KvH5j7GzK4=; b=oZRFGvZ7
        o9AuvOuUTd/RhMGa/bVhj7rmFxckfvLqEGHErVZSISrWWJLY8HEsJLdJjqsi+zIX
        q21ZHiJLfnqi3wL431Mu6mbW87h056X7tT8ccHWbzLt6Fw2bqvwqJX6IxvpDAH1I
        vC9bGtjntQcf+i9jCsgmc83ZUVlcQ22KeKWpNjFWzDY0Oe8a+4r6gTs/MdKLsJvl
        rNXPSSyOTG1S/KjzXPcD5dOuQ5Az/340/60T3+kPnf3WeccLFvNe34n6qAhkYGS4
        DjtLoCCOAyAXRKymDfos3IWZETWdwXAKh1K4ZHfOVpdGdXF5w2zRyq60aTSFBCRg
        xMkTAKsxNcGK/Q==
X-ME-Sender: <xms:ESjtXNR9LDo6dWsnreqOJiAzXvemrQmGA7grmmNlE9kEx0H3eRH4dQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvhedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedv
X-ME-Proxy: <xmx:ESjtXAcZwItaUWX0LVvG8ydCXQ1Jr92vhgc6SPGZxSgiBOHcE9K-oA>
    <xmx:ESjtXJzRM_en24jPIGg5RHrwr9X2AsJuPY3o4zDBSu-aLYqEZCeLVg>
    <xmx:ESjtXJGEavfd4XajT8zo4xjxHABv-NM1xompz3opqH8LkRDyToRMDw>
    <xmx:ESjtXAJmJy4ezVzaydRLiKx0lGUKtBWwIZPnk4tDve0l5E-Vfo1DgA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8B4C438008A;
        Tue, 28 May 2019 08:22:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@savoirfairelinux.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 03/12] devlink: Add generic packet traps and groups
Date:   Tue, 28 May 2019 15:21:27 +0300
Message-Id: <20190528122136.30476-4-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190528122136.30476-1-idosch@idosch.org>
References: <20190528122136.30476-1-idosch@idosch.org>
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
---
 include/net/devlink.h | 46 +++++++++++++++++++++++++++++++++++++++++++
 net/core/devlink.c    | 14 +++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 7f090cb072f4..6cfa1ab36e3f 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -525,18 +525,64 @@ struct devlink_trap {
 };
 
 enum devlink_trap_generic_id {
+	DEVLINK_TRAP_GENERIC_ID_INGRESS_SMAC_MC_DROP,
+	DEVLINK_TRAP_GENERIC_ID_INGRESS_VLAN_TAG_ALLOW_DROP,
+	DEVLINK_TRAP_GENERIC_ID_INGRESS_VLAN_FILTER_DROP,
+	DEVLINK_TRAP_GENERIC_ID_INGRESS_STP_FILTER_DROP,
+	DEVLINK_TRAP_GENERIC_ID_UC_EMPTY_TX_LIST_DROP,
+	DEVLINK_TRAP_GENERIC_ID_MC_EMPTY_TX_LIST_DROP,
+	DEVLINK_TRAP_GENERIC_ID_UC_LOOPBACK_FILTER_DROP,
+	DEVLINK_TRAP_GENERIC_ID_BLACKHOLE_ROUTE_DROP,
+	DEVLINK_TRAP_GENERIC_ID_TTL_ERROR_EXCEPTION,
+	DEVLINK_TRAP_GENERIC_ID_TAIL_DROP,
+	DEVLINK_TRAP_GENERIC_ID_EARLY_DROP,
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
 
+#define DEVLINK_TRAP_GENERIC_NAME_INGRESS_SMAC_MC_DROP \
+	"ingress_smac_mc_drop"
+#define DEVLINK_TRAP_GENERIC_NAME_INGRESS_VLAN_TAG_ALLOW_DROP \
+	"ingress_vlan_tag_allow_drop"
+#define DEVLINK_TRAP_GENERIC_NAME_INGRESS_VLAN_FILTER_DROP \
+	"ingress_vlan_filter_drop"
+#define DEVLINK_TRAP_GENERIC_NAME_INGRESS_STP_FILTER_DROP \
+	"ingress_stp_filter_drop"
+#define DEVLINK_TRAP_GENERIC_NAME_UC_EMPTY_TX_LIST_DROP \
+	"uc_empty_tx_list_drop"
+#define DEVLINK_TRAP_GENERIC_NAME_MC_EMPTY_TX_LIST_DROP \
+	"mc_empty_tx_list_drop"
+#define DEVLINK_TRAP_GENERIC_NAME_UC_LOOPBACK_FILTER_DROP \
+	"uc_loopback_filter_drop"
+#define DEVLINK_TRAP_GENERIC_NAME_BLACKHOLE_ROUTE_DROP \
+	"blackhole_route_drop"
+#define DEVLINK_TRAP_GENERIC_NAME_TTL_ERROR_EXCEPTION \
+	"ttl_error_exception"
+#define DEVLINK_TRAP_GENERIC_NAME_TAIL_DROP \
+	"tail_drop"
+#define DEVLINK_TRAP_GENERIC_NAME_EARLY_DROP \
+	"early_drop"
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
index 96a7ce6701e6..ef22e2d061fc 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7236,6 +7236,17 @@ EXPORT_SYMBOL_GPL(devlink_region_snapshot_create);
 	}
 
 static const struct devlink_trap devlink_trap_generic[] = {
+	DEVLINK_TRAP(INGRESS_SMAC_MC_DROP, DROP),
+	DEVLINK_TRAP(INGRESS_VLAN_TAG_ALLOW_DROP, DROP),
+	DEVLINK_TRAP(INGRESS_VLAN_FILTER_DROP, DROP),
+	DEVLINK_TRAP(INGRESS_STP_FILTER_DROP, DROP),
+	DEVLINK_TRAP(UC_EMPTY_TX_LIST_DROP, DROP),
+	DEVLINK_TRAP(MC_EMPTY_TX_LIST_DROP, DROP),
+	DEVLINK_TRAP(UC_LOOPBACK_FILTER_DROP, DROP),
+	DEVLINK_TRAP(BLACKHOLE_ROUTE_DROP, DROP),
+	DEVLINK_TRAP(TTL_ERROR_EXCEPTION, EXCEPTION),
+	DEVLINK_TRAP(TAIL_DROP, DROP),
+	DEVLINK_TRAP(EARLY_DROP, DROP),
 };
 
 #define DEVLINK_TRAP_GROUP(_id)						      \
@@ -7245,6 +7256,9 @@ static const struct devlink_trap devlink_trap_generic[] = {
 	}
 
 static const struct devlink_trap_group devlink_trap_group_generic[] = {
+	DEVLINK_TRAP_GROUP(L2_DROPS),
+	DEVLINK_TRAP_GROUP(L3_DROPS),
+	DEVLINK_TRAP_GROUP(BUFFER_DROPS),
 };
 
 static int devlink_trap_generic_verify(const struct devlink_trap *trap)
-- 
2.20.1

