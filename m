Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 336C5C49C8
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbfJBIls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:41:48 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46917 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727929AbfJBIlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:41:46 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8306D217DD;
        Wed,  2 Oct 2019 04:41:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 02 Oct 2019 04:41:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=kieRPY575mLl8sRtEHf48j1i7LtBtVoe+nfWrv721hw=; b=uAc1h2M+
        lwnTGWgkxEo+Tojml4YxvVqQ1V5vyllZYHH2wMt1XzePBjw4a10iQqkxoQmnKSen
        XuBRu17zSQmIUMpjr9QF/Hk54veG5oj0/NkfJgfRHj22wRRZKh2/pCKbSnbg9/9u
        ckWD+4rU4VwnxpLeHij7j+9feQJdXHtspHJLcsv2VJWTl7MohtYYsDpqQ9q5ImAl
        fSW8ZcL0vSxt4WCTZJi4jh3kQNCmhMms1GWPPbIsAHeDdA2OnRrBv6lYKlPYNRqD
        LeerNhCnIsCwdKDr4pBYT8tfaETIU5BKRVUMTPUzIm7aNgn1EiQrhuOBMOiOlEEo
        yc17pUN31g63XQ==
X-ME-Sender: <xms:yWKUXScKxqoyoapSPIOVssPOL8xwUeju0M4NfqxpaHRnEa8UIslI_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeigddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepje
X-ME-Proxy: <xmx:yWKUXXwGnd8lbIE-zWJKtq510KiPMeJR70hRUwhzaEoJut8-i3TnkA>
    <xmx:yWKUXax0zgBaU2MIv6mD0IdGZTVIbAmhOHaQeGrJiAIe3MHBR22A1w>
    <xmx:yWKUXYV4Htu3fFmjbqzL4-K7UHYlITr4FqQoGg0EROSqJ8KmPcaJ8w>
    <xmx:yWKUXY85xuEr-1XsKrpXcpRQmX-b-Imh5_GMHYGZ-3InZ99ow4k3Bw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 08C2ED60057;
        Wed,  2 Oct 2019 04:41:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 10/15] ipv4: Replace route in list before notifying
Date:   Wed,  2 Oct 2019 11:40:58 +0300
Message-Id: <20191002084103.12138-11-idosch@idosch.org>
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

Subsequent patches will add an 'in_hw' flag to routes which will signal
if the route is present in hardware or not.

After programming the route to the hardware, drivers will have to ask
the IPv4 code to set the flag by passing the route's key.

In the case of route replace, the new route is notified before it is
actually inserted into the FIB alias list. This can prevent simple
drivers (e.g., netdevsim) that program the route to the hardware in the
same context it is notified in from being able to set the flag.

Solve this by first inserting the new route to the list and rollback the
operation in case the route was vetoed.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/ipv4/fib_trie.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index cbb41eebb43b..9ea9610eebfd 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1237,23 +1237,26 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 			new_fa->tb_id = tb->tb_id;
 			new_fa->fa_default = -1;
 
+			hlist_replace_rcu(&fa->fa_list, &new_fa->fa_list);
+
 			if (fib_find_first_alias(&l->leaf, fa->fa_slen,
-						 tb->tb_id) == fa) {
+						 tb->tb_id) == new_fa) {
 				enum fib_event_type fib_event;
 
 				fib_event = FIB_EVENT_ENTRY_REPLACE;
 				err = call_fib_entry_notifiers(net, fib_event,
 							       key, plen,
 							       new_fa, extack);
-				if (err)
+				if (err) {
+					hlist_replace_rcu(&new_fa->fa_list,
+							  &fa->fa_list);
 					goto out_free_new_fa;
+				}
 			}
 
 			rtmsg_fib(RTM_NEWROUTE, htonl(key), new_fa, plen,
 				  tb->tb_id, &cfg->fc_nlinfo, nlflags);
 
-			hlist_replace_rcu(&fa->fa_list, &new_fa->fa_list);
-
 			alias_free_mem_rcu(fa);
 
 			fib_release_info(fi_drop);
-- 
2.21.0

