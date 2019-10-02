Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE43C49C7
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbfJBIlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:41:39 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33589 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727893AbfJBIli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:41:38 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B7FA42129D;
        Wed,  2 Oct 2019 04:41:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 02 Oct 2019 04:41:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=a/1PvakK6hRkLbSj0S30b+dwLO9wsp1QiJYrySgCx60=; b=i6p+8wer
        g2HRmtfByk7lH0DyUHiWqn8qmZueJFh78ieMDR3S7RrGKtQFsJZB7guRkakhKurF
        FPm4rXx/UhaEDZhm8h9RGv/aovTBzzcIRHLzsaYLwni8l18GJZVXaBT5bxsZgAcZ
        vjUhLDyWFzePwHAB2TvXRlzjq7EqkbycHCNiik/LzAyXSMuTa55IJQ+XV0XRbzFw
        RngOb9WqsvqBJCjWTLdmuSWq60IB9VIB1qSxH48V79yh6gqsYWi9Z2CFoPlYOVY+
        mY9lh4YDHHC/OEs4yK+h6Vf4P+tswgtrrJljkap4euG58k2YJ7fDm89H8Si0KSjl
        2gsk2nrnw496sg==
X-ME-Sender: <xms:wWKUXeXfXLVDDqxIZmTd-1teFPH43y32aXE8B639ONhoJZVqX4na7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeigddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepfe
X-ME-Proxy: <xmx:wWKUXUpyHPkmr10B_N-8ASNxexZ7DAMpIboLEv2uHNqYOUiSXcpQmQ>
    <xmx:wWKUXSSB3ZvJMeM6QnbsZbBNm0BqL_ZMVUO14aIsHprfQA0vK91blg>
    <xmx:wWKUXW1P7zLUfDQmO0Dk2l7udK4IRIQ8lgKRBtzypNTpwXAbZc7xoQ>
    <xmx:wWKUXbJgUTNL3fmoEuXBFDaZtZzIhLl53fpUMnIw7HNp7I6iDr4IaQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2A8DED60062;
        Wed,  2 Oct 2019 04:41:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 05/15] ipv4: Handle route deletion notification
Date:   Wed,  2 Oct 2019 11:40:53 +0300
Message-Id: <20191002084103.12138-6-idosch@idosch.org>
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

When a route is deleted we potentially need to promote the next route in
the FIB alias list (e.g., with an higher metric). In case we find such a
route, a replace notification is emitted. Otherwise, a delete
notification for the deleted route.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/ipv4/fib_trie.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index e5896729dcb9..ba597dbe1cc5 100644
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
2.21.0

