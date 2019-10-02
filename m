Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 429CCC49C5
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbfJBIln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:41:43 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58841 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbfJBIll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:41:41 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DEF102071B;
        Wed,  2 Oct 2019 04:41:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 02 Oct 2019 04:41:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=l6XUjyee8O289z64ubGGrq7ixfno3QVPNbrZYKcatVY=; b=wAQ8X+ix
        PTjQvE/kxStvrp39rkr9wvy/KAy702stFMG+QD+uuVu+gttHclgE/JdcMH0+1997
        jNhoY7SJcn6ehC6RjwK4HZl7k+86Tz6s+MoIlgXvrpVeLlbGcQgiTYIo86PDHawD
        hp5Lleu4Uu3ZTfcpn9Ccf47Wpqkc/Aspq49w2JeVs3nBc4rIRwdsrb/lKSHIaSQr
        T/uU0jICyYboVJwT1OWX6CBMJQVJiEpjQ0QK19U8LjVeu00m/6yfkNGwFNIMNKqp
        Qa0fyvdLX4zCCt0OoeDb5TlZX2ymkpWAkfA6SZlHbHPGQstiI7jOKs2/os3OMfgd
        QF5aXoZaDYYi5A==
X-ME-Sender: <xms:xGKUXT2Kdll50fOpqzBZUQAJHE15uK2QELsjCBMaRtADVZs2KbNozg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeigddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepfe
X-ME-Proxy: <xmx:xGKUXar-r0rf_leisEX1QbUoyIQyYmIceLZUqAkllcmDAWTOpNf8zw>
    <xmx:xGKUXa_ObblxaNQTrPOTgemaRDhUQvTpKKPiOAQXQMj32NZPMe8iDA>
    <xmx:xGKUXd6XmQND2D0XWvgpiqgiQQ5yL4T-yXUmc0Wvm44vEwbvWofyjQ>
    <xmx:xGKUXYOvpMqJ2ZP7na_RUF1sFZDES5jVTfyxAHQ7wPOYhY2a_bwzAQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4D37CD60065;
        Wed,  2 Oct 2019 04:41:39 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 07/15] ipv4: Only Replay routes of interest to new listeners
Date:   Wed,  2 Oct 2019 11:40:55 +0300
Message-Id: <20191002084103.12138-8-idosch@idosch.org>
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

When a new listener is registered to the FIB notification chain it
receives a dump of all the available routes in the system. Instead, make
sure to only replay the IPv4 routes that are actually used in the data
path and are of any interest to the new listener.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/ipv4/fib_trie.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index dc4c4e2cb0b3..4937a3503f4f 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2096,6 +2096,7 @@ static int fib_leaf_notify(struct key_vector *l, struct fib_table *tb,
 			   struct netlink_ext_ack *extack)
 {
 	struct fib_alias *fa;
+	int last_slen = -1;
 	int err;
 
 	hlist_for_each_entry_rcu(fa, &l->leaf, fa_list) {
@@ -2110,6 +2111,15 @@ static int fib_leaf_notify(struct key_vector *l, struct fib_table *tb,
 		if (tb->tb_id != fa->tb_id)
 			continue;
 
+		if (fa->fa_slen == last_slen)
+			continue;
+
+		last_slen = fa->fa_slen;
+		err = call_fib_entry_notifier(nb, FIB_EVENT_ENTRY_REPLACE_TMP,
+					      l->key, KEYLENGTH - fa->fa_slen,
+					      fa, extack);
+		if (err)
+			return err;
 		err = call_fib_entry_notifier(nb, FIB_EVENT_ENTRY_ADD, l->key,
 					      KEYLENGTH - fa->fa_slen,
 					      fa, extack);
-- 
2.21.0

