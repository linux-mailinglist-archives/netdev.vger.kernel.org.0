Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE247118EED
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfLJRY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:24:58 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33757 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727561AbfLJRY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:24:56 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7AA81221F8;
        Tue, 10 Dec 2019 12:24:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Dec 2019 12:24:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=FvfJxSedvVyesPs0PLrOBM8YfriPcFIRbfrKNk3MTOw=; b=rMtWPAeR
        RbFEoVg7d4NIQ0ak4AOAm6Uw9tLDp0T9NvlAVcx4Q+vivSGKrMB3lGVzDzC76vQE
        E+tZWXAB5NbF6JjMej3g88xxNi6hm1FeFkqNF6XGIH7LuCkHaYM3eTsJjIFhlpby
        ugFOaANStKXC1Ock/8aNTVN/qktnyrjLtrr1uGc6sUT7Q5eeo7uH5rQ7RvETxg9r
        2Feu6bx4ryDkI4gjdR7iNHfvHEnepy1ZUGq/bvHnbxAjkvTc0kXy4YYg8fflNa/5
        15lDrYRPkNIZOvUFHNpaVwese+otDBtMfhBIHjrE7rP6GAIKzxVUoTV+ujh4DVV4
        i7/S3PgZX8hhXQ==
X-ME-Sender: <xms:59TvXdKxIIsKxcvjrwlTC2gD9sUaiLs38lRDVx4rPlr0Z8Oh1J1LHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudelfedgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:59TvXV2u8LOi4IjoPCjr_9Op6Zl7OYhphokCfS832x1p0BToxt-DKw>
    <xmx:59TvXZmuy7eJD29SOjyCvn802LbJbTnxX-bzthSYr824GHZPzmZX-Q>
    <xmx:59TvXYjAaIHphCVstQIKxs3GAO9WI7_-_6ey-FuJTkxT9eDWSEYBuA>
    <xmx:59TvXXTXRbkcJ2b5LGldz-RbOFYYK1vQf-6cHiorjvHaA72Wl8VMUA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 075A28005B;
        Tue, 10 Dec 2019 12:24:53 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/9] ipv4: Handle route deletion notification
Date:   Tue, 10 Dec 2019 19:23:58 +0200
Message-Id: <20191210172402.463397-6-idosch@idosch.org>
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

When a route is deleted we potentially need to promote the next route in
the FIB alias list (e.g., with an higher metric). In case we find such a
route, a replace notification is emitted. Otherwise, a delete
notification for the deleted route.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/ipv4/fib_trie.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 66c7926d027d..2d338469d4f2 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1586,6 +1586,36 @@ static void fib_remove_alias(struct trie *t, struct key_vector *tp,
 	node_pull_suffix(tp, fa->fa_slen);
 }
 
+static void fib_notify_alias_delete(struct net *net, u32 key,
+				    struct hlist_head *fah,
+				    struct fib_alias *fa_to_delete,
+				    struct netlink_ext_ack *extack)
+{
+	struct fib_alias *fa_next, *fa_to_notify;
+	u32 tb_id = fa_to_delete->tb_id;
+	u8 slen = fa_to_delete->fa_slen;
+	enum fib_event_type fib_event;
+
+	/* Do not notify if we do not care about the route. */
+	if (fib_find_first_alias(fah, slen, tb_id) != fa_to_delete)
+		return;
+
+	/* Determine if the route should be replaced by the next route in the
+	 * list.
+	 */
+	fa_next = hlist_entry_safe(fa_to_delete->fa_list.next,
+				   struct fib_alias, fa_list);
+	if (fa_next && fa_next->fa_slen == slen && fa_next->tb_id == tb_id) {
+		fib_event = FIB_EVENT_ENTRY_REPLACE_TMP;
+		fa_to_notify = fa_next;
+	} else {
+		fib_event = FIB_EVENT_ENTRY_DEL_TMP;
+		fa_to_notify = fa_to_delete;
+	}
+	call_fib_entry_notifiers(net, fib_event, key, KEYLENGTH - slen,
+				 fa_to_notify, extack);
+}
+
 /* Caller must hold RTNL. */
 int fib_table_delete(struct net *net, struct fib_table *tb,
 		     struct fib_config *cfg, struct netlink_ext_ack *extack)
@@ -1639,6 +1669,7 @@ int fib_table_delete(struct net *net, struct fib_table *tb,
 	if (!fa_to_delete)
 		return -ESRCH;
 
+	fib_notify_alias_delete(net, key, &l->leaf, fa_to_delete, extack);
 	call_fib_entry_notifiers(net, FIB_EVENT_ENTRY_DEL, key, plen,
 				 fa_to_delete, extack);
 	rtmsg_fib(RTM_DELROUTE, htonl(key), fa_to_delete, plen, tb->tb_id,
-- 
2.23.0

