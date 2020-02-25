Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 514EF16BF0B
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 11:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730404AbgBYKpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 05:45:43 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34962 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730388AbgBYKpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 05:45:41 -0500
Received: by mail-wr1-f68.google.com with SMTP id w12so14136346wrt.2
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 02:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JK/rUEreguATu4C2P2UYrDcycytDmgIhXvcFWDU0at0=;
        b=kfnkPqVqxXXT8EJaZygbvvuTf9dIt3YS7OPiiLxbvuv0l7dMz592ACPGxVIcf/biuB
         aGHlVFMA/TkuUd0rPibQBlKkLf2m4wandrnJuWI4lmh8OrfJBZjJQB8BDw7pNGxyjpDw
         GIBIruB1P0VBH9UVKwHBE5tWs8VvCxnL+W4xO0InOUK4toopw2hpAjEu7Hz4pK2UxaGF
         t+jS0sr+/vOFMkyPRfD+ayFQnH/UxvvHAcBsqPIFdFt9qphzk0sjvLoO4iXx9qfFacO0
         6ZNyztd6YcO+fkvvs+/75wP7GD2j7qw1lIPkY1csC8SADRlNsprGnj6FRb/Fr/nma1BI
         6E8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JK/rUEreguATu4C2P2UYrDcycytDmgIhXvcFWDU0at0=;
        b=Eiq0kcU4fP6jDzQDsoXxNm11JloqWfLkuXEdFxSqUAKwoS12xYYEpqDSoJ4VlUPn2K
         bduNNYq1T+QK904PC59m37yaEUIDKuL9aM3ePm46wbnAHqri+3g7f6naKSFZO40k6mU1
         gcULqGdX+L4r9iXo9RIxJPo8ly9HaBjeuiA39oXud/PfZ4ZlD2XIcJl1/m3PWSn5zD5K
         XYLGVzZpS5va7Y0V/fVMiT/xKH4YnGyv1fS19olRv5B1e6zgo/CX9IT65xgpq0iyfJ/X
         BXuR19g2VJDYfUyvlNiBEJiFhL7ndm+AOdOTbjET8Lv+piM9SLqDW6S4uFKApwmx2dPW
         DNQA==
X-Gm-Message-State: APjAAAVO485JVsWa2BMq0GJK1r9MTjSW+cZbkzQrMvq+xgq3XoipBXBc
        +utcAyAryjug8ZiEDeBDknmF+5b5zgE=
X-Google-Smtp-Source: APXvYqxmFWP/OZxOxL0nBjxntNNOsUQpPwzdCNHLuRW0pa4r6adI7BIFOf8PtHP6V5ARQqQ5j/Z9fg==
X-Received: by 2002:a5d:4d0a:: with SMTP id z10mr22790685wrt.253.1582627538635;
        Tue, 25 Feb 2020 02:45:38 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id h13sm22433147wrw.54.2020.02.25.02.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 02:45:38 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 08/10] mlxsw: spectrum_trap: Lookup and pass cookie down to devlink_trap_report()
Date:   Tue, 25 Feb 2020 11:45:25 +0100
Message-Id: <20200225104527.2849-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200225104527.2849-1-jiri@resnulli.us>
References: <20200225104527.2849-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Use the cookie index received along with the packet to lookup original
flow_offload cookie binary and pass it down to devlink_trap_report().
Add "fa_cookie" metadata to the ACL trap.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../mellanox/mlxsw/core_acl_flex_actions.c    | 16 +++++++
 .../mellanox/mlxsw/core_acl_flex_actions.h    |  2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  6 +++
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 42 +++++++++++++++++--
 4 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index 9fad56df8303..1f2e6db743e1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -769,6 +769,22 @@ static void mlxsw_afa_cookie_put(struct mlxsw_afa *mlxsw_afa,
 	mlxsw_afa_cookie_destroy(mlxsw_afa, cookie);
 }
 
+/* RCU read lock must be held */
+const struct flow_action_cookie *
+mlxsw_afa_cookie_lookup(struct mlxsw_afa *mlxsw_afa, u32 cookie_index)
+{
+	struct mlxsw_afa_cookie *cookie;
+
+	/* 0 index means no cookie */
+	if (!cookie_index)
+		return NULL;
+	cookie = idr_find(&mlxsw_afa->cookie_idr, cookie_index);
+	if (!cookie)
+		return NULL;
+	return &cookie->fa_cookie;
+}
+EXPORT_SYMBOL(mlxsw_afa_cookie_lookup);
+
 struct mlxsw_afa_cookie_ref {
 	struct mlxsw_afa_resource resource;
 	struct mlxsw_afa_cookie *cookie;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
index 67473f8bd12b..5f4c1e505136 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
@@ -43,6 +43,8 @@ int mlxsw_afa_block_activity_get(struct mlxsw_afa_block *block, bool *activity);
 int mlxsw_afa_block_continue(struct mlxsw_afa_block *block);
 int mlxsw_afa_block_jump(struct mlxsw_afa_block *block, u16 group_id);
 int mlxsw_afa_block_terminate(struct mlxsw_afa_block *block);
+const struct flow_action_cookie *
+mlxsw_afa_cookie_lookup(struct mlxsw_afa *mlxsw_afa, u32 cookie_index);
 int mlxsw_afa_block_append_drop(struct mlxsw_afa_block *block, bool ingress,
 				const struct flow_action_cookie *fa_cookie,
 				struct netlink_ext_ack *extack);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index c88f00b293a1..3522f9674577 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -780,6 +780,12 @@ int mlxsw_sp_acl_rule_get_stats(struct mlxsw_sp *mlxsw_sp,
 
 struct mlxsw_sp_fid *mlxsw_sp_acl_dummy_fid(struct mlxsw_sp *mlxsw_sp);
 
+static inline const struct flow_action_cookie *
+mlxsw_sp_acl_act_cookie_lookup(struct mlxsw_sp *mlxsw_sp, u32 cookie_index)
+{
+	return mlxsw_afa_cookie_lookup(mlxsw_sp->afa, cookie_index);
+}
+
 int mlxsw_sp_acl_init(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_acl_fini(struct mlxsw_sp *mlxsw_sp);
 u32 mlxsw_sp_acl_region_rehash_intrvl_get(struct mlxsw_sp *mlxsw_sp);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index a55577a50e90..9c300d625e04 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -75,6 +75,35 @@ static void mlxsw_sp_rx_drop_listener(struct sk_buff *skb, u8 local_port,
 	consume_skb(skb);
 }
 
+static void mlxsw_sp_rx_acl_drop_listener(struct sk_buff *skb, u8 local_port,
+					  void *trap_ctx)
+{
+	u32 cookie_index = mlxsw_skb_cb(skb)->cookie_index;
+	const struct flow_action_cookie *fa_cookie;
+	struct devlink_port *in_devlink_port;
+	struct mlxsw_sp_port *mlxsw_sp_port;
+	struct mlxsw_sp *mlxsw_sp;
+	struct devlink *devlink;
+	int err;
+
+	mlxsw_sp = devlink_trap_ctx_priv(trap_ctx);
+	mlxsw_sp_port = mlxsw_sp->ports[local_port];
+
+	err = mlxsw_sp_rx_listener(mlxsw_sp, skb, local_port, mlxsw_sp_port);
+	if (err)
+		return;
+
+	devlink = priv_to_devlink(mlxsw_sp->core);
+	in_devlink_port = mlxsw_core_port_devlink_port_get(mlxsw_sp->core,
+							   local_port);
+	skb_push(skb, ETH_HLEN);
+	rcu_read_lock();
+	fa_cookie = mlxsw_sp_acl_act_cookie_lookup(mlxsw_sp, cookie_index);
+	devlink_trap_report(devlink, skb, trap_ctx, in_devlink_port, fa_cookie);
+	rcu_read_unlock();
+	consume_skb(skb);
+}
+
 static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
 					   void *trap_ctx)
 {
@@ -106,6 +135,11 @@ static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
 			     DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
 			     MLXSW_SP_TRAP_METADATA)
 
+#define MLXSW_SP_TRAP_DROP_EXT(_id, _group_id, _metadata)		      \
+	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				      \
+			     DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
+			     MLXSW_SP_TRAP_METADATA | (_metadata))
+
 #define MLXSW_SP_TRAP_DRIVER_DROP(_id, _group_id)			      \
 	DEVLINK_TRAP_DRIVER(DROP, DROP, DEVLINK_MLXSW_TRAP_ID_##_id,	      \
 			    DEVLINK_MLXSW_TRAP_NAME_##_id,		      \
@@ -123,7 +157,7 @@ static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
 		      SET_FW_DEFAULT, SP_##_group_id)
 
 #define MLXSW_SP_RXL_ACL_DISCARD(_id, _en_group_id, _dis_group_id)	      \
-	MLXSW_RXL_DIS(mlxsw_sp_rx_drop_listener, DISCARD_##_id,		      \
+	MLXSW_RXL_DIS(mlxsw_sp_rx_acl_drop_listener, DISCARD_##_id,	      \
 		      TRAP_EXCEPTION_TO_CPU, false, SP_##_en_group_id,	      \
 		      SET_FW_DEFAULT, SP_##_dis_group_id)
 
@@ -160,8 +194,10 @@ static const struct devlink_trap mlxsw_sp_traps_arr[] = {
 	MLXSW_SP_TRAP_DROP(NON_ROUTABLE, L3_DROPS),
 	MLXSW_SP_TRAP_EXCEPTION(DECAP_ERROR, TUNNEL_DROPS),
 	MLXSW_SP_TRAP_DROP(OVERLAY_SMAC_MC, TUNNEL_DROPS),
-	MLXSW_SP_TRAP_DROP(INGRESS_FLOW_ACTION_DROP, ACL_DROPS),
-	MLXSW_SP_TRAP_DROP(EGRESS_FLOW_ACTION_DROP, ACL_DROPS),
+	MLXSW_SP_TRAP_DROP_EXT(INGRESS_FLOW_ACTION_DROP, ACL_DROPS,
+			       DEVLINK_TRAP_METADATA_TYPE_F_FA_COOKIE),
+	MLXSW_SP_TRAP_DROP_EXT(EGRESS_FLOW_ACTION_DROP, ACL_DROPS,
+			       DEVLINK_TRAP_METADATA_TYPE_F_FA_COOKIE),
 };
 
 static const struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
-- 
2.21.1

