Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F028221F3C9
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgGNOVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:21:53 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47435 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728439AbgGNOVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:21:52 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 20BB65C00EC;
        Tue, 14 Jul 2020 10:21:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 14 Jul 2020 10:21:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=0BkMzNtU/DR/kJVosGicui6+eAm8biEfvnnuTMZum8U=; b=odv5gFRw
        1EZ9zoL+2OGh9m5yuf8LGTbQ89tfnqbtSs1HBJBi3MtPGJhyqq97Un9vnHip/g+j
        UtFcZDJJgpdCTy9OS+WnjIGiD2h6q3LmbeE4Yn1XpNczLNKff1InG2YTeD5wct+W
        Br6Y9PjXO2rr/0g+7Z3hdjomn1h9gHm+UvbkBz7NCqM+7JG7JgYGGaxyj2eQbOIV
        tcdxuiAWa3xLxGdI3tBgTUEDlm9Jo860s5C9IUxnKPaCCXdYoIkV1TP8hj/NC7pH
        7UExKavswtTt5qK94hSx/1vWw9N/lsZ6w9utIBLntU3NsneRJXUqIkcF8ZFs7oKC
        kkkIdognKOwWrw==
X-ME-Sender: <xms:f78NXwxh927vsZ75VobkzkEPXKV8NdfdkZ-l_7_UHDQYfYjWbuC5qg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedtgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:f78NX0Q2i6fjp8vMS7rz6AruPIZvByH9Zkxa29BZWT3yB3HSDRRfNw>
    <xmx:f78NXyWLF1-LXK0xD7dvTMhhSjDaUaSsPJ5nhAmjj4As0ejCWfLcWg>
    <xmx:f78NX-joCEX6NvGHxUpVbkwgH3iNHcfJZk6zRerebiaJ3jP90jGz3A>
    <xmx:f78NX9MuAeNrOJzCZ7JzizlVob9xc806jkh1vdJaQpZqnAY3E5s4UQ>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 860A730600B7;
        Tue, 14 Jul 2020 10:21:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 08/13] mlxsw: spectrum_span: Allow setting policer on a SPAN agent
Date:   Tue, 14 Jul 2020 17:21:01 +0300
Message-Id: <20200714142106.386354-9-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714142106.386354-1-idosch@idosch.org>
References: <20200714142106.386354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

When mirroring packets to the CPU port the mirrored packets are trapped
to the CPU. However, unlike other traps, it is not possible to set a
policer on the associated trap group. Instead, the policer needs to be
set on the SPAN agent.

Moreover, the policer ID must be within a specified range: From a
configurable (even) base ID to this base plus the maximum number of SPAN
agents.

While the immediate use case is to set the policer on a SPAN agent that
mirrors to the CPU port, a policer can be set on any SPAN agent.
Therefore, the operation is implemented for all SPAN agent types.

Extend the SPAN agent request API to allow passing the desired policer
ID that should be bound to the SPAN agent. Return an error for
Spectrum-1, as it does not support policer setting on a SPAN agent.

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../mlxsw/spectrum_acl_flex_actions.c         |   2 +-
 .../mellanox/mlxsw/spectrum_matchall.c        |   2 +-
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 107 +++++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |   6 +
 4 files changed, 114 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c
index 0e32123097d8..18444f675100 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_actions.c
@@ -136,7 +136,7 @@ mlxsw_sp_act_mirror_add(void *priv, u8 local_in_port,
 			const struct net_device *out_dev,
 			bool ingress, int *p_span_id)
 {
-	struct mlxsw_sp_span_agent_parms agent_parms;
+	struct mlxsw_sp_span_agent_parms agent_parms = {};
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	struct mlxsw_sp *mlxsw_sp = priv;
 	int err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index ab4ec44b566a..f30599ad6019 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -27,7 +27,7 @@ mlxsw_sp_mall_port_mirror_add(struct mlxsw_sp_port *mlxsw_sp_port,
 			      struct mlxsw_sp_mall_entry *mall_entry)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	struct mlxsw_sp_span_agent_parms agent_parms;
+	struct mlxsw_sp_span_agent_parms agent_parms = {};
 	struct mlxsw_sp_span_trigger_parms parms;
 	enum mlxsw_sp_span_trigger trigger;
 	int err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 48eb197e649d..323eaf979aea 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -27,6 +27,8 @@ struct mlxsw_sp_span {
 	struct list_head analyzed_ports_list;
 	struct mutex analyzed_ports_lock; /* Protects analyzed_ports_list */
 	struct list_head trigger_entries_list;
+	u16 policer_id_base;
+	refcount_t policer_id_base_ref_count;
 	atomic_t active_entries_count;
 	int entries_count;
 	struct mlxsw_sp_span_entry entries[];
@@ -88,6 +90,7 @@ int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp)
 	span = kzalloc(struct_size(span, entries, entries_count), GFP_KERNEL);
 	if (!span)
 		return -ENOMEM;
+	refcount_set(&span->policer_id_base_ref_count, 0);
 	span->entries_count = entries_count;
 	atomic_set(&span->active_entries_count, 0);
 	mutex_init(&span->analyzed_ports_lock);
@@ -182,6 +185,8 @@ mlxsw_sp_span_entry_phys_configure(struct mlxsw_sp_span_entry *span_entry,
 	/* Create a new port analayzer entry for local_port. */
 	mlxsw_reg_mpat_pack(mpat_pl, pa_id, local_port, true,
 			    MLXSW_REG_MPAT_SPAN_TYPE_LOCAL_ETH);
+	mlxsw_reg_mpat_pide_set(mpat_pl, sparms.policer_enable);
+	mlxsw_reg_mpat_pid_set(mpat_pl, sparms.policer_id);
 
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mpat), mpat_pl);
 }
@@ -478,6 +483,8 @@ mlxsw_sp_span_entry_gretap4_configure(struct mlxsw_sp_span_entry *span_entry,
 	/* Create a new port analayzer entry for local_port. */
 	mlxsw_reg_mpat_pack(mpat_pl, pa_id, local_port, true,
 			    MLXSW_REG_MPAT_SPAN_TYPE_REMOTE_ETH_L3);
+	mlxsw_reg_mpat_pide_set(mpat_pl, sparms.policer_enable);
+	mlxsw_reg_mpat_pid_set(mpat_pl, sparms.policer_id);
 	mlxsw_reg_mpat_eth_rspan_pack(mpat_pl, sparms.vid);
 	mlxsw_reg_mpat_eth_rspan_l2_pack(mpat_pl,
 				    MLXSW_REG_MPAT_ETH_RSPAN_VERSION_NO_HEADER,
@@ -580,6 +587,8 @@ mlxsw_sp_span_entry_gretap6_configure(struct mlxsw_sp_span_entry *span_entry,
 	/* Create a new port analayzer entry for local_port. */
 	mlxsw_reg_mpat_pack(mpat_pl, pa_id, local_port, true,
 			    MLXSW_REG_MPAT_SPAN_TYPE_REMOTE_ETH_L3);
+	mlxsw_reg_mpat_pide_set(mpat_pl, sparms.policer_enable);
+	mlxsw_reg_mpat_pid_set(mpat_pl, sparms.policer_id);
 	mlxsw_reg_mpat_eth_rspan_pack(mpat_pl, sparms.vid);
 	mlxsw_reg_mpat_eth_rspan_l2_pack(mpat_pl,
 				    MLXSW_REG_MPAT_ETH_RSPAN_VERSION_NO_HEADER,
@@ -643,6 +652,8 @@ mlxsw_sp_span_entry_vlan_configure(struct mlxsw_sp_span_entry *span_entry,
 
 	mlxsw_reg_mpat_pack(mpat_pl, pa_id, local_port, true,
 			    MLXSW_REG_MPAT_SPAN_TYPE_REMOTE_ETH);
+	mlxsw_reg_mpat_pide_set(mpat_pl, sparms.policer_enable);
+	mlxsw_reg_mpat_pid_set(mpat_pl, sparms.policer_id);
 	mlxsw_reg_mpat_eth_rspan_pack(mpat_pl, sparms.vid);
 
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mpat), mpat_pl);
@@ -790,6 +801,45 @@ mlxsw_sp_span_entry_deconfigure(struct mlxsw_sp_span_entry *span_entry)
 		span_entry->ops->deconfigure(span_entry);
 }
 
+static int mlxsw_sp_span_policer_id_base_set(struct mlxsw_sp_span *span,
+					     u16 policer_id)
+{
+	struct mlxsw_sp *mlxsw_sp = span->mlxsw_sp;
+	u16 policer_id_base;
+	int err;
+
+	/* Policers set on SPAN agents must be in the range of
+	 * `policer_id_base .. policer_id_base + max_span_agents - 1`. If the
+	 * base is set and the new policer is not within the range, then we
+	 * must error out.
+	 */
+	if (refcount_read(&span->policer_id_base_ref_count)) {
+		if (policer_id < span->policer_id_base ||
+		    policer_id >= span->policer_id_base + span->entries_count)
+			return -EINVAL;
+
+		refcount_inc(&span->policer_id_base_ref_count);
+		return 0;
+	}
+
+	/* Base must be even. */
+	policer_id_base = policer_id % 2 == 0 ? policer_id : policer_id - 1;
+	err = mlxsw_sp->span_ops->policer_id_base_set(mlxsw_sp,
+						      policer_id_base);
+	if (err)
+		return err;
+
+	span->policer_id_base = policer_id_base;
+	refcount_set(&span->policer_id_base_ref_count, 1);
+
+	return 0;
+}
+
+static void mlxsw_sp_span_policer_id_base_unset(struct mlxsw_sp_span *span)
+{
+	refcount_dec(&span->policer_id_base_ref_count);
+}
+
 static struct mlxsw_sp_span_entry *
 mlxsw_sp_span_entry_create(struct mlxsw_sp *mlxsw_sp,
 			   const struct net_device *to_dev,
@@ -809,6 +859,15 @@ mlxsw_sp_span_entry_create(struct mlxsw_sp *mlxsw_sp,
 	if (!span_entry)
 		return NULL;
 
+	if (sparms.policer_enable) {
+		int err;
+
+		err = mlxsw_sp_span_policer_id_base_set(mlxsw_sp->span,
+							sparms.policer_id);
+		if (err)
+			return NULL;
+	}
+
 	atomic_inc(&mlxsw_sp->span->active_entries_count);
 	span_entry->ops = ops;
 	refcount_set(&span_entry->ref_count, 1);
@@ -823,6 +882,8 @@ static void mlxsw_sp_span_entry_destroy(struct mlxsw_sp *mlxsw_sp,
 {
 	mlxsw_sp_span_entry_deconfigure(span_entry);
 	atomic_dec(&mlxsw_sp->span->active_entries_count);
+	if (span_entry->parms.policer_enable)
+		mlxsw_sp_span_policer_id_base_unset(mlxsw_sp->span);
 }
 
 struct mlxsw_sp_span_entry *
@@ -861,6 +922,24 @@ mlxsw_sp_span_entry_find_by_id(struct mlxsw_sp *mlxsw_sp, int span_id)
 	return NULL;
 }
 
+static struct mlxsw_sp_span_entry *
+mlxsw_sp_span_entry_find_by_parms(struct mlxsw_sp *mlxsw_sp,
+				  const struct net_device *to_dev,
+				  const struct mlxsw_sp_span_parms *sparms)
+{
+	int i;
+
+	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
+		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span->entries[i];
+
+		if (refcount_read(&curr->ref_count) && curr->to_dev == to_dev &&
+		    curr->parms.policer_enable == sparms->policer_enable &&
+		    curr->parms.policer_id == sparms->policer_id)
+			return curr;
+	}
+	return NULL;
+}
+
 static struct mlxsw_sp_span_entry *
 mlxsw_sp_span_entry_get(struct mlxsw_sp *mlxsw_sp,
 			const struct net_device *to_dev,
@@ -869,7 +948,8 @@ mlxsw_sp_span_entry_get(struct mlxsw_sp *mlxsw_sp,
 {
 	struct mlxsw_sp_span_entry *span_entry;
 
-	span_entry = mlxsw_sp_span_entry_find_by_port(mlxsw_sp, to_dev);
+	span_entry = mlxsw_sp_span_entry_find_by_parms(mlxsw_sp, to_dev,
+						       &sparms);
 	if (span_entry) {
 		/* Already exists, just take a reference */
 		refcount_inc(&span_entry->ref_count);
@@ -1054,6 +1134,8 @@ int mlxsw_sp_span_agent_get(struct mlxsw_sp *mlxsw_sp, int *p_span_id,
 	if (err)
 		return err;
 
+	sparms.policer_id = parms->policer_id;
+	sparms.policer_enable = parms->policer_enable;
 	span_entry = mlxsw_sp_span_entry_get(mlxsw_sp, to_dev, ops, sparms);
 	if (!span_entry)
 		return -ENOBUFS;
@@ -1634,9 +1716,16 @@ static u32 mlxsw_sp1_span_buffsize_get(int mtu, u32 speed)
 	return mtu * 5 / 2;
 }
 
+static int mlxsw_sp1_span_policer_id_base_set(struct mlxsw_sp *mlxsw_sp,
+					      u16 policer_id_base)
+{
+	return -EOPNOTSUPP;
+}
+
 const struct mlxsw_sp_span_ops mlxsw_sp1_span_ops = {
 	.init = mlxsw_sp1_span_init,
 	.buffsize_get = mlxsw_sp1_span_buffsize_get,
+	.policer_id_base_set = mlxsw_sp1_span_policer_id_base_set,
 };
 
 static int mlxsw_sp2_span_init(struct mlxsw_sp *mlxsw_sp)
@@ -1672,9 +1761,24 @@ static u32 mlxsw_sp2_span_buffsize_get(int mtu, u32 speed)
 	return __mlxsw_sp_span_buffsize_get(mtu, speed, factor);
 }
 
+static int mlxsw_sp2_span_policer_id_base_set(struct mlxsw_sp *mlxsw_sp,
+					      u16 policer_id_base)
+{
+	char mogcr_pl[MLXSW_REG_MOGCR_LEN];
+	int err;
+
+	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(mogcr), mogcr_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mogcr_mirroring_pid_base_set(mogcr_pl, policer_id_base);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mogcr), mogcr_pl);
+}
+
 const struct mlxsw_sp_span_ops mlxsw_sp2_span_ops = {
 	.init = mlxsw_sp2_span_init,
 	.buffsize_get = mlxsw_sp2_span_buffsize_get,
+	.policer_id_base_set = mlxsw_sp2_span_policer_id_base_set,
 };
 
 static u32 mlxsw_sp3_span_buffsize_get(int mtu, u32 speed)
@@ -1687,4 +1791,5 @@ static u32 mlxsw_sp3_span_buffsize_get(int mtu, u32 speed)
 const struct mlxsw_sp_span_ops mlxsw_sp3_span_ops = {
 	.init = mlxsw_sp2_span_init,
 	.buffsize_get = mlxsw_sp3_span_buffsize_get,
+	.policer_id_base_set = mlxsw_sp2_span_policer_id_base_set,
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index 25f73561a9fe..1c746dd3b1bd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -21,6 +21,8 @@ struct mlxsw_sp_span_parms {
 	union mlxsw_sp_l3addr daddr;
 	union mlxsw_sp_l3addr saddr;
 	u16 vid;
+	u16 policer_id;
+	bool policer_enable;
 };
 
 enum mlxsw_sp_span_trigger {
@@ -37,6 +39,8 @@ struct mlxsw_sp_span_trigger_parms {
 
 struct mlxsw_sp_span_agent_parms {
 	const struct net_device *to_dev;
+	u16 policer_id;
+	bool policer_enable;
 };
 
 struct mlxsw_sp_span_entry_ops;
@@ -44,6 +48,8 @@ struct mlxsw_sp_span_entry_ops;
 struct mlxsw_sp_span_ops {
 	int (*init)(struct mlxsw_sp *mlxsw_sp);
 	u32 (*buffsize_get)(int mtu, u32 speed);
+	int (*policer_id_base_set)(struct mlxsw_sp *mlxsw_sp,
+				   u16 policer_id_base);
 };
 
 struct mlxsw_sp_span_entry {
-- 
2.26.2

