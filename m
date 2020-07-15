Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3A5220729
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 10:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730063AbgGOI2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 04:28:16 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39503 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728282AbgGOI2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 04:28:14 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 842885C018E;
        Wed, 15 Jul 2020 04:28:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 15 Jul 2020 04:28:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=oqL9Hdk4JBuTvOByVKi3TzjHsfMon9izb556kDb8m9I=; b=mrozotMU
        lyy2V9fAklr9YipTTm2agVIefB+e03QE0/R0W09mfGZMzwr8AvS1bUjulFHyLQhy
        yO0O3a3zxTL24BLTlXenpodmTmYnC2aCpveGVTaHihDkENKawcCNZLCklAHPamWz
        7E9sW5qMNJx3skxc9juD26wRjolUIfemc5oXQY2Ql9KTU7FX6A8cErRnVKr97mpb
        Pym6d4JWyWJHw/p2oXvBxuW2mLy/1cs0J1s54YEf5V+h0C4+YUk2W6n7B1Ep40gj
        HXJftd4TGwyJ8MER9DFAtsTU6YMqhPWUp0YOLA4Rb3mezXuJPHmr8WMj/eRtckuU
        SLSbQyUj6HuWiQ==
X-ME-Sender: <xms:HL4OX9t6wBWc93qXXRdzQaf0hIk3qU-YdVPoLfLfhoBwTJdyWlCF2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedvgddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieehrddufeelrddukedt
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:HL4OX2ctL6UZWmVaQ3eiwV5EqpDG4Wpn54qD1DNQ5gbvuaay08EwNA>
    <xmx:HL4OXww3NdzSZBvJeZLz_1ou_GNK0yg0vh8UXGUF8YLhaxP89wzmpg>
    <xmx:HL4OX0OkEP47C00xwFbhAY60hLoFRDdS35HLuvfvOXByYltmDx0PgQ>
    <xmx:HL4OX_JQWZXGGIBoD9tHcUWec9Zr7h6ocf22hfuynG7mrTJlevA8FA>
Received: from shredder.mtl.com (bzq-109-65-139-180.red.bezeqint.net [109.65.139.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id 963C83280063;
        Wed, 15 Jul 2020 04:28:10 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 05/11] mlxsw: core_acl_flex_actions: Work around hardware limitation
Date:   Wed, 15 Jul 2020 11:27:27 +0300
Message-Id: <20200715082733.429610-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715082733.429610-1-idosch@idosch.org>
References: <20200715082733.429610-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

In the policy engine, each ACL rule points to an action block where the
ACL actions are stored. Each action block consists of one or more action
sets. Each action set holds one or more individual actions, up to a
maximum queried from the device. For example:

                        Action set #1               Action set #2

+----------+          +--------------+            +--------------+
| ACL rule +---------->  Action #1   |      +----->  Action #4   |
+----------+          +--------------+      |     +--------------+
                      |  Action #2   |      |     |  Action #5   |
                      +--------------+      |     +--------------+
                      |  Action #3   +------+     |              |
                      +--------------+            +--------------+

                      <---------+ Action block +----------------->

The hardware has a limitation that prevents a policing action
(MLXSW_AFA_POLCNT_CODE when used with a policer, not a counter) from
being configured in the same action set with a trap action (i.e.,
MLXSW_AFA_TRAP_CODE or MLXSW_AFA_TRAPWU_CODE). Note that the latter used
to implement multiple actions: 'trap', 'mirred', 'drop'.

Work around this limitation by teaching mlxsw_afa_block_append_action()
to create a new action set not only when there is no more room left in
the current set, but also when there is a conflict between previously
mentioned actions.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
---
 .../mellanox/mlxsw/core_acl_flex_actions.c    | 87 +++++++++++++++----
 1 file changed, 71 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index 30a7d5afdec7..06a43913b9ce 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -88,9 +88,11 @@ struct mlxsw_afa_set {
 	struct rhash_head ht_node;
 	struct mlxsw_afa_set_ht_key ht_key;
 	u32 kvdl_index;
-	bool shared; /* Inserted in hashtable (doesn't mean that
+	u8 shared:1, /* Inserted in hashtable (doesn't mean that
 		      * kvdl_index is valid).
 		      */
+	   has_trap:1,
+	   has_police:1;
 	unsigned int ref_count;
 	struct mlxsw_afa_set *next; /* Pointer to the next set. */
 	struct mlxsw_afa_set *prev; /* Pointer to the previous set,
@@ -839,16 +841,38 @@ mlxsw_afa_cookie_ref_create(struct mlxsw_afa_block *block,
 #define MLXSW_AFA_ONE_ACTION_LEN 32
 #define MLXSW_AFA_PAYLOAD_OFFSET 4
 
-static char *mlxsw_afa_block_append_action(struct mlxsw_afa_block *block,
-					   u8 action_code, u8 action_size)
+enum mlxsw_afa_action_type {
+	MLXSW_AFA_ACTION_TYPE_TRAP,
+	MLXSW_AFA_ACTION_TYPE_POLICE,
+	MLXSW_AFA_ACTION_TYPE_OTHER,
+};
+
+static bool
+mlxsw_afa_block_need_split(const struct mlxsw_afa_block *block,
+			   enum mlxsw_afa_action_type type)
+{
+	struct mlxsw_afa_set *cur_set = block->cur_set;
+
+	/* Due to a hardware limitation, police action cannot be in the same
+	 * action set with MLXSW_AFA_TRAP_CODE or MLXSW_AFA_TRAPWU_CODE
+	 * actions. Work around this limitation by creating a new action set
+	 * and place the new action there.
+	 */
+	return (cur_set->has_trap && type == MLXSW_AFA_ACTION_TYPE_POLICE) ||
+	       (cur_set->has_police && type == MLXSW_AFA_ACTION_TYPE_TRAP);
+}
+
+static char *mlxsw_afa_block_append_action_ext(struct mlxsw_afa_block *block,
+					       u8 action_code, u8 action_size,
+					       enum mlxsw_afa_action_type type)
 {
 	char *oneact;
 	char *actions;
 
 	if (block->finished)
 		return ERR_PTR(-EINVAL);
-	if (block->cur_act_index + action_size >
-	    block->afa->max_acts_per_set) {
+	if (block->cur_act_index + action_size > block->afa->max_acts_per_set ||
+	    mlxsw_afa_block_need_split(block, type)) {
 		struct mlxsw_afa_set *set;
 
 		/* The appended action won't fit into the current action set,
@@ -863,6 +887,17 @@ static char *mlxsw_afa_block_append_action(struct mlxsw_afa_block *block,
 		block->cur_set = set;
 	}
 
+	switch (type) {
+	case MLXSW_AFA_ACTION_TYPE_TRAP:
+		block->cur_set->has_trap = true;
+		break;
+	case MLXSW_AFA_ACTION_TYPE_POLICE:
+		block->cur_set->has_police = true;
+		break;
+	default:
+		break;
+	}
+
 	actions = block->cur_set->ht_key.enc_actions;
 	oneact = actions + block->cur_act_index * MLXSW_AFA_ONE_ACTION_LEN;
 	block->cur_act_index += action_size;
@@ -870,6 +905,14 @@ static char *mlxsw_afa_block_append_action(struct mlxsw_afa_block *block,
 	return oneact + MLXSW_AFA_PAYLOAD_OFFSET;
 }
 
+static char *mlxsw_afa_block_append_action(struct mlxsw_afa_block *block,
+					   u8 action_code, u8 action_size)
+{
+	return mlxsw_afa_block_append_action_ext(block, action_code,
+						 action_size,
+						 MLXSW_AFA_ACTION_TYPE_OTHER);
+}
+
 /* VLAN Action
  * -----------
  * VLAN action is used for manipulating VLANs. It can be used to implement QinQ,
@@ -1048,11 +1091,20 @@ mlxsw_afa_trap_mirror_pack(char *payload, bool mirror_enable,
 	mlxsw_afa_trap_mirror_agent_set(payload, mirror_agent);
 }
 
+static char *mlxsw_afa_block_append_action_trap(struct mlxsw_afa_block *block,
+						u8 action_code, u8 action_size)
+{
+	return mlxsw_afa_block_append_action_ext(block, action_code,
+						 action_size,
+						 MLXSW_AFA_ACTION_TYPE_TRAP);
+}
+
 static int mlxsw_afa_block_append_drop_plain(struct mlxsw_afa_block *block,
 					     bool ingress)
 {
-	char *act = mlxsw_afa_block_append_action(block, MLXSW_AFA_TRAP_CODE,
-						  MLXSW_AFA_TRAP_SIZE);
+	char *act = mlxsw_afa_block_append_action_trap(block,
+						       MLXSW_AFA_TRAP_CODE,
+						       MLXSW_AFA_TRAP_SIZE);
 
 	if (IS_ERR(act))
 		return PTR_ERR(act);
@@ -1081,8 +1133,8 @@ mlxsw_afa_block_append_drop_with_cookie(struct mlxsw_afa_block *block,
 	}
 	cookie_index = cookie_ref->cookie->cookie_index;
 
-	act = mlxsw_afa_block_append_action(block, MLXSW_AFA_TRAPWU_CODE,
-					    MLXSW_AFA_TRAPWU_SIZE);
+	act = mlxsw_afa_block_append_action_trap(block, MLXSW_AFA_TRAPWU_CODE,
+						 MLXSW_AFA_TRAPWU_SIZE);
 	if (IS_ERR(act)) {
 		NL_SET_ERR_MSG_MOD(extack, "Cannot append drop with cookie action");
 		err = PTR_ERR(act);
@@ -1113,8 +1165,9 @@ EXPORT_SYMBOL(mlxsw_afa_block_append_drop);
 
 int mlxsw_afa_block_append_trap(struct mlxsw_afa_block *block, u16 trap_id)
 {
-	char *act = mlxsw_afa_block_append_action(block, MLXSW_AFA_TRAP_CODE,
-						  MLXSW_AFA_TRAP_SIZE);
+	char *act = mlxsw_afa_block_append_action_trap(block,
+						       MLXSW_AFA_TRAP_CODE,
+						       MLXSW_AFA_TRAP_SIZE);
 
 	if (IS_ERR(act))
 		return PTR_ERR(act);
@@ -1127,8 +1180,9 @@ EXPORT_SYMBOL(mlxsw_afa_block_append_trap);
 int mlxsw_afa_block_append_trap_and_forward(struct mlxsw_afa_block *block,
 					    u16 trap_id)
 {
-	char *act = mlxsw_afa_block_append_action(block, MLXSW_AFA_TRAP_CODE,
-						  MLXSW_AFA_TRAP_SIZE);
+	char *act = mlxsw_afa_block_append_action_trap(block,
+						       MLXSW_AFA_TRAP_CODE,
+						       MLXSW_AFA_TRAP_SIZE);
 
 	if (IS_ERR(act))
 		return PTR_ERR(act);
@@ -1199,9 +1253,10 @@ static int
 mlxsw_afa_block_append_allocated_mirror(struct mlxsw_afa_block *block,
 					u8 mirror_agent)
 {
-	char *act = mlxsw_afa_block_append_action(block,
-						  MLXSW_AFA_TRAP_CODE,
-						  MLXSW_AFA_TRAP_SIZE);
+	char *act = mlxsw_afa_block_append_action_trap(block,
+						       MLXSW_AFA_TRAP_CODE,
+						       MLXSW_AFA_TRAP_SIZE);
+
 	if (IS_ERR(act))
 		return PTR_ERR(act);
 	mlxsw_afa_trap_pack(act, MLXSW_AFA_TRAP_TRAP_ACTION_NOP,
-- 
2.26.2

