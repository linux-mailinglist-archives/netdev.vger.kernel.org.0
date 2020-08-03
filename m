Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1260C23AA48
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbgHCQMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:12:48 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34555 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728360AbgHCQMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 12:12:47 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 088B65C0138;
        Mon,  3 Aug 2020 12:12:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 03 Aug 2020 12:12:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=5iYTj7D8CfwsL/vG0QzFu20VltbvrXmk7Lfo4Z1OMJI=; b=CforOCfM
        COIUtRry8NNZMpoJODdS/okL7mRus4pRcnuUYpQHlw7oUEAarcC49whJss7AEeHB
        Ry7ZIXkPI9h9EI21J2ZeFNzK4jVjffagWznNroQ80tIi3k89HQGqfI7SGECTi3L2
        ALpBJf3Zwc/TbXgRnXuG+XTVDa6SWEGunmvGaYnJMfToyIY9zVPCVSzGLPZrRNwO
        hjM+uvkhZ/HlYr5IWFX3xm/B64592frv4Gy3IX6/qf9YMk2P0LO9ydopzqTG2aUl
        iXuWEHR2/lyIZxFfEpKSOqY296SSoTst7Jz5yqE7iS/ZRqWOyyInf3KY6CzdBC3H
        Z8lbuNGKVbxsoQ==
X-ME-Sender: <xms:fjcoX8JFDTTe6OR-OL-jnQizUfgN4SEJjBzd7ChQIeNZPFoGtNfwkA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeeggdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddukedurdeirddvudelnecu
    vehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:fjcoX8IbIekzh0LtN-1pgs1sbGVgM5MgL_HEQPipMZlkPBVshpATdA>
    <xmx:fjcoX8t1QcygoG-t6yoeQdNZiUhrM-wNqrVqqPWFCxT93zsHYLtpNg>
    <xmx:fjcoX5b1uq0AQje6dEdgHdQdGyouzIfKaLqp6CuccxQH75tfmu7JcQ>
    <xmx:fzcoX_F7uP6J9MzmUbsDRQD1dTPRWTpVbgWH7-SNjs27wmyPb-YgyQ>
Received: from shredder.mtl.com (bzq-79-181-6-219.red.bezeqint.net [79.181.6.219])
        by mail.messagingengine.com (Postfix) with ESMTPA id CD1EA306005F;
        Mon,  3 Aug 2020 12:12:44 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 7/9] mlxsw: spectrum_trap: Add early_drop trap
Date:   Mon,  3 Aug 2020 19:11:39 +0300
Message-Id: <20200803161141.2523857-8-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803161141.2523857-1-idosch@idosch.org>
References: <20200803161141.2523857-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

As previously explained, packets that are dropped due to buffer related
reasons (e.g., tail drop, early drop) can be mirrored to the CPU port.
These packets are then trapped with one of the "mirror session" traps
and their CQE includes the reason for which the packet was mirrored.

Register with devlink a new trap, early_drop, and initialize the
corresponding Rx listener with the appropriate mirror reason. Return an
error in case user tries to change the traps' action, as this is not
supported.

Since Spectrum-1 does not support these traps, the above is only done
for Spectrum-2 onwards.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.h    | 13 ++++--
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 42 +++++++++++++++++++
 3 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 219ce89e629a..11af3308f8cc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -89,13 +89,15 @@ struct mlxsw_listener {
 };
 
 #define __MLXSW_RXL(_func, _trap_id, _en_action, _is_ctrl, _en_trap_group,	\
-		    _dis_action, _enabled_on_register, _dis_trap_group)		\
+		    _dis_action, _enabled_on_register, _dis_trap_group,		\
+		    _mirror_reason)						\
 	{									\
 		.trap_id = MLXSW_TRAP_ID_##_trap_id,				\
 		.rx_listener =							\
 		{								\
 			.func = _func,						\
 			.local_port = MLXSW_PORT_DONT_CARE,			\
+			.mirror_reason = _mirror_reason,			\
 			.trap_id = MLXSW_TRAP_ID_##_trap_id,			\
 		},								\
 		.en_action = MLXSW_REG_HPKT_ACTION_##_en_action,		\
@@ -109,12 +111,17 @@ struct mlxsw_listener {
 #define MLXSW_RXL(_func, _trap_id, _en_action, _is_ctrl, _trap_group,		\
 		  _dis_action)							\
 	__MLXSW_RXL(_func, _trap_id, _en_action, _is_ctrl, _trap_group,		\
-		    _dis_action, true, _trap_group)
+		    _dis_action, true, _trap_group, 0)
 
 #define MLXSW_RXL_DIS(_func, _trap_id, _en_action, _is_ctrl, _en_trap_group,	\
 		      _dis_action, _dis_trap_group)				\
 	__MLXSW_RXL(_func, _trap_id, _en_action, _is_ctrl, _en_trap_group,	\
-		    _dis_action, false, _dis_trap_group)
+		    _dis_action, false, _dis_trap_group, 0)
+
+#define MLXSW_RXL_MIRROR(_func, _session_id, _trap_group, _mirror_reason)	\
+	__MLXSW_RXL(_func, MIRROR_SESSION##_session_id,	TRAP_TO_CPU, false,	\
+		    _trap_group, TRAP_TO_CPU, true, _trap_group,		\
+		    _mirror_reason)
 
 #define MLXSW_EVENTL(_func, _trap_id, _trap_group)				\
 	{									\
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 28a2576eb783..079b080de7f7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5614,6 +5614,7 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_L3_EXCEPTIONS,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_TUNNEL_DISCARDS,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_ACL_DISCARDS,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_BUFFER_DISCARDS,
 
 	__MLXSW_REG_HTGT_TRAP_GROUP_MAX,
 	MLXSW_REG_HTGT_TRAP_GROUP_MAX = __MLXSW_REG_HTGT_TRAP_GROUP_MAX - 1
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 93dd88abbe23..16bf154076b3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -21,6 +21,7 @@ struct mlxsw_sp_trap_group_item {
 	struct devlink_trap_group group;
 	u16 hw_group_id;
 	u8 priority;
+	u8 fixed_policer:1; /* Whether policer binding can change */
 };
 
 #define MLXSW_SP_TRAP_LISTENERS_MAX 3
@@ -28,6 +29,7 @@ struct mlxsw_sp_trap_group_item {
 struct mlxsw_sp_trap_item {
 	struct devlink_trap trap;
 	struct mlxsw_listener listeners_arr[MLXSW_SP_TRAP_LISTENERS_MAX];
+	u8 is_source:1;
 };
 
 /* All driver-specific traps must be documented in
@@ -46,6 +48,11 @@ enum {
 
 #define MLXSW_SP_TRAP_METADATA DEVLINK_TRAP_METADATA_TYPE_F_IN_PORT
 
+enum {
+	/* Packet was early dropped. */
+	MLXSW_SP_MIRROR_REASON_INGRESS_WRED = 9,
+};
+
 static int mlxsw_sp_rx_listener(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
 				u8 local_port,
 				struct mlxsw_sp_port *mlxsw_sp_port)
@@ -222,6 +229,11 @@ static void mlxsw_sp_rx_sample_listener(struct sk_buff *skb, u8 local_port,
 			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
 			     MLXSW_SP_TRAP_METADATA | (_metadata))
 
+#define MLXSW_SP_TRAP_BUFFER_DROP(_id)					      \
+	DEVLINK_TRAP_GENERIC(DROP, TRAP, _id,				      \
+			     DEVLINK_TRAP_GROUP_GENERIC_ID_BUFFER_DROPS,      \
+			     MLXSW_SP_TRAP_METADATA)
+
 #define MLXSW_SP_TRAP_DRIVER_DROP(_id, _group_id)			      \
 	DEVLINK_TRAP_DRIVER(DROP, DROP, DEVLINK_MLXSW_TRAP_ID_##_id,	      \
 			    DEVLINK_MLXSW_TRAP_NAME_##_id,		      \
@@ -248,6 +260,10 @@ static void mlxsw_sp_rx_sample_listener(struct sk_buff *skb, u8 local_port,
 		      TRAP_EXCEPTION_TO_CPU, false, SP_##_en_group_id,	      \
 		      SET_FW_DEFAULT, SP_##_dis_group_id)
 
+#define MLXSW_SP_RXL_BUFFER_DISCARD(_mirror_reason)			      \
+	MLXSW_RXL_MIRROR(mlxsw_sp_rx_drop_listener, 0, SP_BUFFER_DISCARDS,    \
+			 MLXSW_SP_MIRROR_REASON_##_mirror_reason)
+
 #define MLXSW_SP_RXL_EXCEPTION(_id, _group_id, _action)			      \
 	MLXSW_RXL(mlxsw_sp_rx_mark_listener, _id,			      \
 		   _action, false, SP_##_group_id, SET_FW_DEFAULT)
@@ -331,6 +347,9 @@ mlxsw_sp_trap_policer_items_arr[] = {
 	{
 		.policer = MLXSW_SP_TRAP_POLICER(19, 1024, 512),
 	},
+	{
+		.policer = MLXSW_SP_TRAP_POLICER(20, 10240, 4096),
+	},
 };
 
 static const struct mlxsw_sp_trap_group_item mlxsw_sp_trap_group_items_arr[] = {
@@ -1429,6 +1448,11 @@ int mlxsw_sp_trap_action_set(struct mlxsw_core *mlxsw_core,
 	if (WARN_ON(!trap_item))
 		return -EINVAL;
 
+	if (trap_item->is_source) {
+		NL_SET_ERR_MSG_MOD(extack, "Changing the action of source traps is not supported");
+		return -EOPNOTSUPP;
+	}
+
 	for (i = 0; i < MLXSW_SP_TRAP_LISTENERS_MAX; i++) {
 		const struct mlxsw_listener *listener;
 		bool enabled;
@@ -1470,6 +1494,11 @@ __mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
 	if (WARN_ON(!group_item))
 		return -EINVAL;
 
+	if (group_item->fixed_policer && policer_id != group->init_policer_id) {
+		NL_SET_ERR_MSG_MOD(extack, "Changing the policer binding of this group is not supported");
+		return -EOPNOTSUPP;
+	}
+
 	if (policer_id) {
 		struct mlxsw_sp_trap_policer_item *policer_item;
 
@@ -1682,10 +1711,23 @@ const struct mlxsw_sp_trap_ops mlxsw_sp1_trap_ops = {
 
 static const struct mlxsw_sp_trap_group_item
 mlxsw_sp2_trap_group_items_arr[] = {
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(BUFFER_DROPS, 20),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_BUFFER_DISCARDS,
+		.priority = 0,
+		.fixed_policer = true,
+	},
 };
 
 static const struct mlxsw_sp_trap_item
 mlxsw_sp2_trap_items_arr[] = {
+	{
+		.trap = MLXSW_SP_TRAP_BUFFER_DROP(EARLY_DROP),
+		.listeners_arr = {
+			MLXSW_SP_RXL_BUFFER_DISCARD(INGRESS_WRED),
+		},
+		.is_source = true,
+	},
 };
 
 static int
-- 
2.26.2

