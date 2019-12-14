Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA7011F2A0
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 16:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbfLNPyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 10:54:54 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47579 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726541AbfLNPyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 10:54:54 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DB73A22620;
        Sat, 14 Dec 2019 10:54:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 14 Dec 2019 10:54:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=C0pypP2lkgWlL5cJzAb21zGa8vw7a1pwcJEX+CgY+KE=; b=szPImQ8a
        tDAtQTNIvRGL7P3hRQMFl2NOhLKLJtYNlWSoYXRGKNinIdpb6P/S+vAfCrx343s/
        5ONNKGSAZxR8b6o821hN2rqEUNO2KOtLOR1gZXEXwPKxbjbSBWgMGbe9kFnLzpiD
        KwQQUgjbRuW+tf2l1nK+O39WE6ipt9iyCQz7J0r53AQ2+jWh14iE6nzqcqEnUYvu
        S00/SnO9RMGmMk09a/4A1G0eq158ZE1+5dOz6yqpAQuzK86EpCGJa79gXIUnURIh
        GFVImnH0ICTTWEEcHBpEZODT7BrQTztavg+LiewfUtOQQ7dfhE44N194w4admI20
        YifvKvJODrEQcg==
X-ME-Sender: <xms:zAX1XVhpc2e1zP8eAQgxAIisVNmERSeSOmr7z5ign5jvzboFGLbRiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtuddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekvddruddtjedrieejnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:zAX1XZ0HIc5wI0OBAHwIeyuLHczjvODUvpr9gCBteZj8lztOBZlMyQ>
    <xmx:zAX1XXrT1SjRAhQlgLS95msmS5z6PkKcChE05SD_Fv_oivxhsmsz2Q>
    <xmx:zAX1XW3_iqauU4Oz_fDtkfo_EkOhK4TJao1V7jxDIiqEhThDOz_MQQ>
    <xmx:zAX1XVa93RNZbawj2YwRF7HIl_dviiM-_feJkTMtbBElgO5Z6RtUPQ>
Received: from splinter.mtl.com (bzq-79-182-107-67.red.bezeqint.net [79.182.107.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id 96B158005B;
        Sat, 14 Dec 2019 10:54:50 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        jiri@mellanox.com, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 02/10] ipv4: Notify route after insertion to the routing table
Date:   Sat, 14 Dec 2019 17:53:07 +0200
Message-Id: <20191214155315.613186-3-idosch@idosch.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191214155315.613186-1-idosch@idosch.org>
References: <20191214155315.613186-1-idosch@idosch.org>
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
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/fib_trie.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index b9df9c09b84e..9264d6628e9f 100644
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
+	l = l ? l : fib_find_node(t, &tp, key);
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
2.23.0

