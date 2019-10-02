Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7C34C49CD
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbfJBIly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:41:54 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33061 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727930AbfJBIlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:41:51 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 34E99217DD;
        Wed,  2 Oct 2019 04:41:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 02 Oct 2019 04:41:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=xGTj7VLSt2BwjlmummPQZjPedZOswzdJq8uJEKVN5BM=; b=a01EFUXf
        WBlhxWbQcW9salMKMusuvDM+8922b94psQ+qEs4uZNsRU0syQBRHpaQtmMzzsV35
        Cb+Z61hd7w6KIszbYfHqkZw1ikCLfJyZSDzKQAGCBYzah2z7j2m0BmgL2FWl6NiG
        rHKxBeGp7fb7xxvx4BWFXbdfn3eYabPTsaaRADfBLAJffXNNYaOCbRs1RpjjwVvl
        hSeClcHU+hUKsj1clXlS87RI0bAGHmtFxvFzLiqXAzEcHAVPicJL0psH3ejoTkO5
        Pm282bHiHFwgikB7j46pS6KE9BNurr0eV5PFlMeQd88EJ5ZptdK8mmYQHaHr6dkb
        yIYnmVHtIZ7Dpw==
X-ME-Sender: <xms:zmKUXaOyjhk6CwTbr8IsfEkfTYkX2N5rnKVrvRg9m9bWRdKo4A29XQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeigddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepuddt
X-ME-Proxy: <xmx:zmKUXTD03h3V4qR8lWQVrvkjml-3uQEMXsKeN6rhG8Jt8KceACYBsA>
    <xmx:zmKUXQU0zSdG3SR_issTPZd9hFQvmgiBWDnvpVM19K_-VZc4A0qTrg>
    <xmx:zmKUXS0XI0-QVaYnzyUw7egyTTTm6BATw4vAtOLe0dhevLDEIDmzLQ>
    <xmx:zmKUXfQj3Z7tg_ubkSk5zCheJ_YOlnJnBLJ4Cb5HmyE3VCN4LK5u_g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B7225D60062;
        Wed,  2 Oct 2019 04:41:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 13/15] mlxsw: spectrum_router: Mark routes as "in hardware"
Date:   Wed,  2 Oct 2019 11:41:01 +0300
Message-Id: <20191002084103.12138-14-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002084103.12138-1-idosch@idosch.org>
References: <20191002084103.12138-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Make use of the recently introduced APIs and mark notified routes as "in
hardware" after they were programmed to the device's LPM tree.

Similarly, when a route is replaced by an higher priority one, clear the
"in hardware" indication from it.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 5a4e61f1feec..26ab8ae482ec 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4769,7 +4769,10 @@ static void mlxsw_sp_fib4_entry_replace(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_fib4_entry *fib4_entry)
 {
 	struct mlxsw_sp_fib_node *fib_node = fib4_entry->common.fib_node;
+	struct net *net = mlxsw_sp_net(mlxsw_sp);
+	u32 *addr = (u32 *) fib_node->key.addr;
 	struct mlxsw_sp_fib4_entry *replaced;
+	struct fib_info *fi;
 
 	if (list_is_singular(&fib_node->entry_list))
 		return;
@@ -4777,6 +4780,10 @@ static void mlxsw_sp_fib4_entry_replace(struct mlxsw_sp *mlxsw_sp,
 	/* We inserted the new entry before replaced one */
 	replaced = list_next_entry(fib4_entry, common.list);
 
+	fi = mlxsw_sp_nexthop4_group_fi(replaced->common.nh_group);
+	fib_alias_in_hw_clear(net, *addr, fib_node->key.prefix_len, fi,
+			      replaced->tos, replaced->type, replaced->tb_id);
+
 	mlxsw_sp_fib4_node_entry_unlink(mlxsw_sp, replaced);
 	mlxsw_sp_fib4_entry_destroy(mlxsw_sp, replaced);
 	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
@@ -4786,6 +4793,7 @@ static int
 mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
 			     const struct fib_entry_notifier_info *fen_info)
 {
+	struct net *net = mlxsw_sp_net(mlxsw_sp);
 	struct mlxsw_sp_fib4_entry *fib4_entry;
 	struct mlxsw_sp_fib_node *fib_node;
 	int err;
@@ -4815,6 +4823,10 @@ mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
 		goto err_fib4_node_entry_link;
 	}
 
+	fib_alias_in_hw_set(net, fen_info->dst, fen_info->dst_len,
+			    fen_info->fi, fen_info->tos, fen_info->type,
+			    fen_info->tb_id);
+
 	mlxsw_sp_fib4_entry_replace(mlxsw_sp, fib4_entry);
 
 	return 0;
@@ -5731,11 +5743,18 @@ static void mlxsw_sp_fib4_node_flush(struct mlxsw_sp *mlxsw_sp,
 				     struct mlxsw_sp_fib_node *fib_node)
 {
 	struct mlxsw_sp_fib4_entry *fib4_entry, *tmp;
+	struct net *net = mlxsw_sp_net(mlxsw_sp);
+	u32 *addr = (u32 *) fib_node->key.addr;
 
 	list_for_each_entry_safe(fib4_entry, tmp, &fib_node->entry_list,
 				 common.list) {
 		bool do_break = &tmp->common.list == &fib_node->entry_list;
+		struct fib_info *fi;
 
+		fi = mlxsw_sp_nexthop4_group_fi(fib4_entry->common.nh_group);
+		fib_alias_in_hw_clear(net, *addr, fib_node->key.prefix_len, fi,
+				      fib4_entry->tos, fib4_entry->type,
+				      fib4_entry->tb_id);
 		mlxsw_sp_fib4_node_entry_unlink(mlxsw_sp, fib4_entry);
 		mlxsw_sp_fib4_entry_destroy(mlxsw_sp, fib4_entry);
 		mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
-- 
2.21.0

