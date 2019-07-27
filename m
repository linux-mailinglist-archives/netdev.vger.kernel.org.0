Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16B9377AC8
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 19:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387983AbfG0Rdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 13:33:53 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48277 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387665AbfG0Rdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 13:33:53 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 383212104C;
        Sat, 27 Jul 2019 13:33:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 27 Jul 2019 13:33:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=2eiNspnxN12WGKD82JTV35g2V/KtwWlEhJtuzQ2ydHg=; b=F4reXhq9
        aeN4DSV+LmgwtRbr9o0oCwlS5StSCa8ADhjlsLXS5VBwzFo0W+bPJ11kxgHN91rc
        26+WMHFtDyIbEQXVks0UR8SNbLwyOHXrCMXfQk2EVUmcFnp7/Akf0pSwPsHA2CU3
        E8FwydiiZeG5pty7ZCUfX/niCMtuyN95lUV9lA29+JhAsZ3kM7xXIHlcUuzc8dcO
        AGNvGvquMd3NfD0gKcJimOsTvcVUsESbEQm+77JtoVh2xrLo/rXFQ4EPOnPBk+E8
        oB3ZKaEUQGIADdF3Nx5ab0M9v7FR+Ms16mHj4Dcl8cnIeK6MW+56KQFf85t5d/7I
        w3IPK8gQh1GMyA==
X-ME-Sender: <xms:AIs8XUbCzkK7agDruMe3vYebamlTtREyZ2LeN1aSHLD0IcNtVJO4EA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkeeigdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejjedrudefkedrvdegledrvddtleenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:AIs8XfQa_iEU1tNwgfKySgF8La8nge_WJhM3YbiJrwt2jLuimG7dcA>
    <xmx:AIs8XcS4MI3pyJ7dYzmJqFzaGS5QT5D9XGxOvBJ9EN7vHiqkMqkETw>
    <xmx:AIs8Xa16Hxj0_mviX6OtxnBeksUN7DZKanFqvR77OUgoZluUbvA2mw>
    <xmx:AIs8XZmHGPi5URT1c724F2eBzRQ2Eto10l2pj250OiLgNcyuVHWqfQ>
Received: from splinter.mtl.com (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id 777EA380084;
        Sat, 27 Jul 2019 13:33:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/3] mlxsw: spectrum_acl: Track rules that forbid egress block bind
Date:   Sat, 27 Jul 2019 20:32:56 +0300
Message-Id: <20190727173257.6848-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190727173257.6848-1-idosch@idosch.org>
References: <20190727173257.6848-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Some matches and actions are not supported on egress. Track such rules
and forbid a bind of block which contains them to egress.

With this patch, the kernel tells the user he cannot do that:
$ tc qdisc add dev ens16np1 ingress_block 22 clsact
$ tc filter add block 22 protocol 802.1q pref 2 handle 101 flower vlan_id 100 skip_sw action pass
$ tc qdisc add dev ens16np2 egress_block 22 clsact
Error: mlxsw_spectrum: Block cannot be bound to egress because it contains unsupported rules.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c  |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h  |  7 +++++--
 .../net/ethernet/mellanox/mlxsw/spectrum_acl.c  | 17 +++++++++++++----
 .../ethernet/mellanox/mlxsw/spectrum_flower.c   | 11 +++++++++++
 4 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 7e8a54068d92..9277b3f125e8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1625,7 +1625,7 @@ mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 	flow_block_cb_incref(block_cb);
 	err = mlxsw_sp_acl_block_bind(mlxsw_sp, acl_block,
-				      mlxsw_sp_port, ingress);
+				      mlxsw_sp_port, ingress, f->extack);
 	if (err)
 		goto err_block_bind;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 131f62ce9297..c78d93afbb9d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -623,7 +623,8 @@ struct mlxsw_sp_acl_rule_info {
 	unsigned int priority;
 	struct mlxsw_afk_element_values values;
 	struct mlxsw_afa_block *act_block;
-	u8 action_created:1;
+	u8 action_created:1,
+	   egress_bind_blocker:1;
 	unsigned int counter_index;
 };
 
@@ -642,6 +643,7 @@ struct mlxsw_sp_acl_block {
 	struct mlxsw_sp *mlxsw_sp;
 	unsigned int rule_count;
 	unsigned int disable_count;
+	unsigned int egress_blocker_rule_count;
 	struct net *net;
 };
 
@@ -657,7 +659,8 @@ void mlxsw_sp_acl_block_destroy(struct mlxsw_sp_acl_block *block);
 int mlxsw_sp_acl_block_bind(struct mlxsw_sp *mlxsw_sp,
 			    struct mlxsw_sp_acl_block *block,
 			    struct mlxsw_sp_port *mlxsw_sp_port,
-			    bool ingress);
+			    bool ingress,
+			    struct netlink_ext_ack *extack);
 int mlxsw_sp_acl_block_unbind(struct mlxsw_sp *mlxsw_sp,
 			      struct mlxsw_sp_acl_block *block,
 			      struct mlxsw_sp_port *mlxsw_sp_port,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index e8ac90564dbe..1aaab8446270 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -239,7 +239,8 @@ mlxsw_sp_acl_block_lookup(struct mlxsw_sp_acl_block *block,
 int mlxsw_sp_acl_block_bind(struct mlxsw_sp *mlxsw_sp,
 			    struct mlxsw_sp_acl_block *block,
 			    struct mlxsw_sp_port *mlxsw_sp_port,
-			    bool ingress)
+			    bool ingress,
+			    struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_acl_block_binding *binding;
 	int err;
@@ -247,6 +248,11 @@ int mlxsw_sp_acl_block_bind(struct mlxsw_sp *mlxsw_sp,
 	if (WARN_ON(mlxsw_sp_acl_block_lookup(block, mlxsw_sp_port, ingress)))
 		return -EEXIST;
 
+	if (!ingress && block->egress_blocker_rule_count) {
+		NL_SET_ERR_MSG_MOD(extack, "Block cannot be bound to egress because it contains unsupported rules");
+		return -EOPNOTSUPP;
+	}
+
 	binding = kzalloc(sizeof(*binding), GFP_KERNEL);
 	if (!binding)
 		return -ENOMEM;
@@ -672,6 +678,7 @@ int mlxsw_sp_acl_rule_add(struct mlxsw_sp *mlxsw_sp,
 {
 	struct mlxsw_sp_acl_ruleset *ruleset = rule->ruleset;
 	const struct mlxsw_sp_acl_profile_ops *ops = ruleset->ht_key.ops;
+	struct mlxsw_sp_acl_block *block = ruleset->ht_key.block;
 	int err;
 
 	err = ops->rule_add(mlxsw_sp, ruleset->priv, rule->priv, rule->rulei);
@@ -689,14 +696,14 @@ int mlxsw_sp_acl_rule_add(struct mlxsw_sp *mlxsw_sp,
 		 * one, to be directly bound to device. The rest of the
 		 * rulesets are bound by "Goto action set".
 		 */
-		err = mlxsw_sp_acl_ruleset_block_bind(mlxsw_sp, ruleset,
-						      ruleset->ht_key.block);
+		err = mlxsw_sp_acl_ruleset_block_bind(mlxsw_sp, ruleset, block);
 		if (err)
 			goto err_ruleset_block_bind;
 	}
 
 	list_add_tail(&rule->list, &mlxsw_sp->acl->rules);
-	ruleset->ht_key.block->rule_count++;
+	block->rule_count++;
+	block->egress_blocker_rule_count += rule->rulei->egress_bind_blocker;
 	return 0;
 
 err_ruleset_block_bind:
@@ -712,7 +719,9 @@ void mlxsw_sp_acl_rule_del(struct mlxsw_sp *mlxsw_sp,
 {
 	struct mlxsw_sp_acl_ruleset *ruleset = rule->ruleset;
 	const struct mlxsw_sp_acl_profile_ops *ops = ruleset->ht_key.ops;
+	struct mlxsw_sp_acl_block *block = ruleset->ht_key.block;
 
+	block->egress_blocker_rule_count -= rule->rulei->egress_bind_blocker;
 	ruleset->ht_key.block->rule_count--;
 	list_del(&rule->list);
 	if (!ruleset->ht_key.chain_index &&
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 1eeac8a36ead..c86d582dafbe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -83,6 +83,11 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 				return -EOPNOTSUPP;
 			}
 
+			/* Forbid block with this rulei to be bound
+			 * to egress in future.
+			 */
+			rulei->egress_bind_blocker = 1;
+
 			fid = mlxsw_sp_acl_dummy_fid(mlxsw_sp);
 			fid_index = mlxsw_sp_fid_index(fid);
 			err = mlxsw_sp_acl_rulei_act_fid_set(mlxsw_sp, rulei,
@@ -395,6 +400,12 @@ static int mlxsw_sp_flower_parse(struct mlxsw_sp *mlxsw_sp,
 			NL_SET_ERR_MSG_MOD(f->common.extack, "vlan_id key is not supported on egress");
 			return -EOPNOTSUPP;
 		}
+
+		/* Forbid block with this rulei to be bound
+		 * to egress in future.
+		 */
+		rulei->egress_bind_blocker = 1;
+
 		if (match.mask->vlan_id != 0)
 			mlxsw_sp_acl_rulei_keymask_u32(rulei,
 						       MLXSW_AFK_ELEMENT_VID,
-- 
2.21.0

