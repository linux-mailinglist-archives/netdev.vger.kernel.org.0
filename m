Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82A4DC49C2
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbfJBIlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:41:36 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54393 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbfJBIlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:41:35 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9401B22337;
        Wed,  2 Oct 2019 04:41:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 02 Oct 2019 04:41:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=kMZK9n15ELUjUXGABhS4bhnskPDlsh+W8ZhIMwucN/Y=; b=qzEkQ/b+
        89j47K9jiDz8ah0LruJagmx2BeT2zZ8Zj+pHtuFeYL7aY7nxkuZECxhWFTP0aQPh
        qwgq5hL/iX3OlK5VO3Pb1HotkQgaAEAwDmWpvRyybgVHIjQvepZFvUWJ5y/RnFQZ
        yMIf1RRZimJhCp/nhOR2oK+o3i2p3ulsWpPVRNPE7JtuzjRDo64HFkqlWQxnZDG4
        bmDcZ7tIE/hRZ/iUpXRBMP5Vxg7pm3lot0VwYPSOektZJ9LXHwLz+7sVqN1mFChx
        i2Khydwq9/r3kx52ih6jzXT8ay0126xHNNjpi4h+Vsn1y81BEmFdV41kzxbpg8IA
        5a+6lcn680L0tA==
X-ME-Sender: <xms:vmKUXU5-6_vYdWk9P6dT2-20BuvSpCDuKuSUD0NAgYCsLKjEBqh3HA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeigddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:vmKUXSPIUaw_jhYWObUC1wGKTCLkP3Cp7vOqiLfSKOT6YQg2wiJgrg>
    <xmx:vmKUXWOy5MF0dLOMG9GvikidDFscJ-WE7cFzXXT5TSADq3m0sK7d1g>
    <xmx:vmKUXa-FfCzHuN4EVTEcu7dr4ugtJhsI8WO2Q1C7Tmd6ylkX_VFjwg>
    <xmx:vmKUXXYU4p2Bl31DP8t84v8SBSPG-khZWxDVC9kh79TT_oOVfVTnKg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 085E7D60057;
        Wed,  2 Oct 2019 04:41:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 03/15] ipv4: Notify route if replacing currently offloaded one
Date:   Wed,  2 Oct 2019 11:40:51 +0300
Message-Id: <20191002084103.12138-4-idosch@idosch.org>
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

When replacing a route, its replacement should only be notified in case
the replaced route is of any interest to listeners. In other words, if
the replaced route is currently used in the data path, which means it is
the first route in the FIB alias list with the given {prefix, prefix
length, table ID}.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/ipv4/fib_trie.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 3ba63ebcfeef..8387b275721c 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -978,6 +978,27 @@ static struct key_vector *fib_find_node(struct trie *t,
 	return n;
 }
 
+/* Return the first fib alias matching prefix length and table ID. */
+static struct fib_alias *fib_find_first_alias(struct hlist_head *fah, u8 slen,
+					      u32 tb_id)
+{
+	struct fib_alias *fa;
+
+	hlist_for_each_entry(fa, fah, fa_list) {
+		if (fa->fa_slen < slen)
+			continue;
+		if (fa->fa_slen != slen)
+			break;
+		if (fa->tb_id > tb_id)
+			continue;
+		if (fa->tb_id != tb_id)
+			break;
+		return fa;
+	}
+
+	return NULL;
+}
+
 /* Return the first fib alias matching TOS with
  * priority less than or equal to PRIO.
  */
@@ -1217,6 +1238,17 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 			new_fa->tb_id = tb->tb_id;
 			new_fa->fa_default = -1;
 
+			if (fib_find_first_alias(&l->leaf, fa->fa_slen,
+						 tb->tb_id) == fa) {
+				enum fib_event_type fib_event;
+
+				fib_event = FIB_EVENT_ENTRY_REPLACE_TMP;
+				err = call_fib_entry_notifiers(net, fib_event,
+							       key, plen,
+							       new_fa, extack);
+				if (err)
+					goto out_free_new_fa;
+			}
 			err = call_fib_entry_notifiers(net,
 						       FIB_EVENT_ENTRY_REPLACE,
 						       key, plen, new_fa,
-- 
2.21.0

