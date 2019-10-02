Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7972BC49C1
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfJBIle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:41:34 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33327 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbfJBIld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:41:33 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0337420A34;
        Wed,  2 Oct 2019 04:41:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 02 Oct 2019 04:41:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=13xxfzq9tGqIFlXsvyI+bL7y3EGKWyv/hmw64O6Ze1I=; b=D9aLWHkg
        dkABGjfMXp8rLBnYhqFEOlMO7hzG88bxoQOGyO0AwqbNVzBDDY3v/kAvGaPsHuNi
        +fU9fiLjZDZelVC4HsmqsTjZYqmxcfsbpUpCs5j9YR2b8s6sFMF3Ne5tETY0PUyX
        6TxhizPBk2pD/xY7ZH7/JJBteUISOUv12j/86miVaY8K0y/7Ont/c08p+4ZEG4vZ
        wcdYh0QNfhWOf2rouuwY+Q+grmT5zUykviwEBlVBUWvw0Rn4oLOBoxV+hd4sAZGn
        kkop00RL5cYz2hFz2sKZF82N3WSHDlToxZnXGYzmSENiRa/V6BkVWPLrUihOtPQD
        Bbt2MpoU2SS81A==
X-ME-Sender: <xms:vGKUXdfWoLHuDurEdtxNL64zqzmm1TkHQxChoO9zn0IV6BSmnXmnfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeigddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:vGKUXZ2XZBNOPI5PamxsLAS_3VZvwjh3AHh4wvQUpYRRyP3Vh3QP8Q>
    <xmx:vGKUXWIrgtEmIi6r0EKAAudRZ6OpZz_tCBS7JlGZi8TjEez1heA4CQ>
    <xmx:vGKUXdLlR6J8nZZjHGtevzBJ_hBjxpHpDGG7uQGX1arKc0HSsvIZjg>
    <xmx:vGKUXWvlfVnVLVSjn0AjLMfnfBdWY8HdErdqmawNzSYUb1oovYRvYA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 717FDD60065;
        Wed,  2 Oct 2019 04:41:31 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 02/15] ipv4: Notify route after insertion to the routing table
Date:   Wed,  2 Oct 2019 11:40:50 +0300
Message-Id: <20191002084103.12138-3-idosch@idosch.org>
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

Currently, a new route is notified in the FIB notification chain before
it is inserted to the FIB alias list.

Subsequent patches will use the placement of the new route in the
ordered FIB alias list in order to determine if the route should be
notified or not.

As a preparatory step, change the order so that the route is first
inserted into the FIB alias list and only then notified.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/ipv4/fib_trie.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index b9df9c09b84e..3ba63ebcfeef 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1063,9 +1063,6 @@ static int fib_insert_node(struct trie *t, struct key_vector *tp,
 	return -ENOMEM;
 }
 
-/* fib notifier for ADD is sent before calling fib_insert_alias with
- * the expectation that the only possible failure ENOMEM
- */
 static int fib_insert_alias(struct trie *t, struct key_vector *tp,
 			    struct key_vector *l, struct fib_alias *new,
 			    struct fib_alias *fa, t_key key)
@@ -1118,6 +1115,9 @@ static bool fib_valid_key_len(u32 key, u8 plen, struct netlink_ext_ack *extack)
 	return true;
 }
 
+static void fib_remove_alias(struct trie *t, struct key_vector *tp,
+			     struct key_vector *l, struct fib_alias *old);
+
 /* Caller must hold RTNL. */
 int fib_table_insert(struct net *net, struct fib_table *tb,
 		     struct fib_config *cfg, struct netlink_ext_ack *extack)
@@ -1269,14 +1269,19 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 	new_fa->tb_id = tb->tb_id;
 	new_fa->fa_default = -1;
 
-	err = call_fib_entry_notifiers(net, event, key, plen, new_fa, extack);
+	/* Insert new entry to the list. */
+	err = fib_insert_alias(t, tp, l, new_fa, fa, key);
 	if (err)
 		goto out_free_new_fa;
 
-	/* Insert new entry to the list. */
-	err = fib_insert_alias(t, tp, l, new_fa, fa, key);
+	/* The alias was already inserted, so the node must exist. */
+	l = fib_find_node(t, &tp, key);
+	if (WARN_ON_ONCE(!l))
+		goto out_free_new_fa;
+
+	err = call_fib_entry_notifiers(net, event, key, plen, new_fa, extack);
 	if (err)
-		goto out_fib_notif;
+		goto out_remove_new_fa;
 
 	if (!plen)
 		tb->tb_num_default++;
@@ -1287,14 +1292,8 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 succeeded:
 	return 0;
 
-out_fib_notif:
-	/* notifier was sent that entry would be added to trie, but
-	 * the add failed and need to recover. Only failure for
-	 * fib_insert_alias is ENOMEM.
-	 */
-	NL_SET_ERR_MSG(extack, "Failed to insert route into trie");
-	call_fib_entry_notifiers(net, FIB_EVENT_ENTRY_DEL, key,
-				 plen, new_fa, NULL);
+out_remove_new_fa:
+	fib_remove_alias(t, tp, l, new_fa);
 out_free_new_fa:
 	kmem_cache_free(fn_alias_kmem, new_fa);
 out:
-- 
2.21.0

