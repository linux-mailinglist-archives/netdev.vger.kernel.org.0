Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0FC118EEC
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbfLJRYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:24:55 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37833 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727561AbfLJRYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:24:52 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1A84C20765;
        Tue, 10 Dec 2019 12:24:51 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Dec 2019 12:24:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=JGeQoYBdXA53eFOIUPZvj/zTWuEelssu9LdEiCe9ICk=; b=GYQoHXJT
        DvNFpdQKJ8b5VIz5jyrdOLHNrgAB4f35bcYYMXcAAuF1qp2OynMkW1eS4pAB2mqR
        YU+kYg1GCcpO09X0Ts30A4Xr0Vm6z0O1iOBjenKMrVH8oMaeUFjkf795XiiapNjo
        Zitf51w5ET/jxCxuVJY9Ekl2xDv1ytKDmyw6OdQrlvqGH25y1xpNb7gm3I+OfSoL
        zfG/1P7TZqP7nZFqkvHLPoAmIVGzbDjVfUDUjU6EXJEp0GLuqlP9dIPfOIA4bLk3
        g3Qh97INh7jcatnzKMnK+cOmZ9aeHw7y6QkaF1FM9MLov9Fxt7YNO+gWp4SQ6hx/
        jC/AW+ZfK2Mbeg==
X-ME-Sender: <xms:49TvXTagI7S2cPjwZBefc0swcwgU901MF7vKwPH0Od71Pxgm581SPg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudelfedgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:49TvXbB0fFzkteH-KFfeaZeAnJtbyp6iat3oCqKzn0jBEa_B7NC4Zw>
    <xmx:49TvXe-fhzGOXI7idYhohG7SgqHe1JbHA4tiM8uHfY-WPz8JAIzwqA>
    <xmx:49TvXRzFr2zt_sktKjJMWaS11jDdVEP0TQozcCbP4aLam_vo2xMcsA>
    <xmx:49TvXVjRmqzmgDD4-ER4rixkhHWOCU180xirM-Id_PhvUfJOnIzrbQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9E81C8005B;
        Tue, 10 Dec 2019 12:24:49 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/9] ipv4: Notify route after insertion to the routing table
Date:   Tue, 10 Dec 2019 19:23:55 +0200
Message-Id: <20191210172402.463397-3-idosch@idosch.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191210172402.463397-1-idosch@idosch.org>
References: <20191210172402.463397-1-idosch@idosch.org>
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

