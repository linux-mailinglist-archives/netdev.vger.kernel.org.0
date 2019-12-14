Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A231011F2A4
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 16:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfLNPzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 10:55:05 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59031 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726861AbfLNPzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 10:55:02 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6D9E922618;
        Sat, 14 Dec 2019 10:55:02 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 14 Dec 2019 10:55:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=zGLgIsdMaxAQXDkag1XguiJpcpFhWUsh5C6k/SBeTa4=; b=J70cVzcD
        kjobVE4eN7+KCnZvSTPXJ67Fa1FlvMA6y0JfcRbj7EsS2Y4t3wzFZx+48xjGoSgp
        wTt7CtnsxNFmReXd+jB+/OvXw7bbxEWV2ZP0d4LO/nDskOKpR5xw/oVWcX4mCd4/
        +X1huof5vvpALgNTyaSPMJNp3xLVbbkoCOW4Ze0zjdjOkcIRnkn5oVat9Ovc1lCZ
        2YfodwY4L9aT1TX4l5VqS58qEXK8/nPD7RCgXBHjdaAG88t5MNmir1HOf83mJNG0
        Slz4bQjRJee9W0FZwJ6AMTzXdYId4NPbDZCZfTRcoLeTn6p41iH5mwo9qlnyCnbt
        2jvd40Fs/NUYDw==
X-ME-Sender: <xms:1gX1XTa1v76x96jcGpalHRljq0Ofd-0crPK3-89LbtPlCEd-7GsxNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtuddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekvddruddtjedrieejnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgephe
X-ME-Proxy: <xmx:1gX1XdgUqpouB7WzWZqlvN0Tui-bxQSAPfqeYwvQL318NcEHr2cBEw>
    <xmx:1gX1XcWW8sIrv9uGH9jsMKYGcTPpMiYu1NYvmEDuE-Yq54XLnS-gHw>
    <xmx:1gX1XUkg7gqsUXE4vp_jAtdAvsij38-X9WPEIwAKyQvmwWwp0sPGTA>
    <xmx:1gX1XayymUoZ-aMIPYmU31H0QfTGb03gnILMLN5888dsE9KcXm6IMw>
Received: from splinter.mtl.com (bzq-79-182-107-67.red.bezeqint.net [79.182.107.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8F6248005B;
        Sat, 14 Dec 2019 10:54:59 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        jiri@mellanox.com, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 06/10] ipv4: Handle route deletion notification
Date:   Sat, 14 Dec 2019 17:53:11 +0200
Message-Id: <20191214155315.613186-7-idosch@idosch.org>
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

When a route is deleted we potentially need to promote the next route in
the FIB alias list (e.g., with an higher metric). In case we find such a
route, a replace notification is emitted. Otherwise, a delete
notification for the deleted route.

v2:
* Convert to use fib_find_alias() instead of fib_find_first_alias()

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/ipv4/fib_trie.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index f56945d00d7a..012aca433a91 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1570,6 +1570,36 @@ static void fib_remove_alias(struct trie *t, struct key_vector *tp,
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
+	if (fib_find_alias(fah, slen, 0, 0, tb_id, true) != fa_to_delete)
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
@@ -1623,6 +1653,7 @@ int fib_table_delete(struct net *net, struct fib_table *tb,
 	if (!fa_to_delete)
 		return -ESRCH;
 
+	fib_notify_alias_delete(net, key, &l->leaf, fa_to_delete, extack);
 	call_fib_entry_notifiers(net, FIB_EVENT_ENTRY_DEL, key, plen,
 				 fa_to_delete, extack);
 	rtmsg_fib(RTM_DELROUTE, htonl(key), fa_to_delete, plen, tb->tb_id,
-- 
2.23.0

